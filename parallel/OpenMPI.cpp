/*
	COSC 3P93 Group Project
	Topic: AES Encryption

	AES Encryption/Decryption Tool. Supports 128, 192, and 256 bit encryption.
	Only ECB (Electronic CodeBook) Mode is Supported and is used by default.

	Authors:
		Tennyson Demchuk (td16qg@brocku.ca) | St#: 6190532
		Daniel Sokic (ds16sz@brocku.ca) 	| St#: 6164545

	Program Usage:
		mpirun -np <# proc> ./mpi encrypt {KEYSIZE=128,192,256} "ENCRYPTION_KEY" "PLAINTEXT"
		mpirun -np <# proc> ./mpi decrypt {KEYSIZE=128,192,256} "ENCRYPTION_KEY" "CIPHERTEXT"
		** np MUST be two or greater

	Linux Compilation Command: mpic++ -O3 -o mpi OpenMPI.cpp -std=c++11
*/

#include "base64.h"
#include <iostream>
#include <string>
#include <bitset>
#include <vector>
#include <algorithm>
#include <chrono>
#include <mpi.h>

// function prototypes
void encrypt(std::bitset<32> key[], std::vector<std::bitset<8>>& text, const int numRounds);	// encrypt and decrypt functions
void decrypt(std::bitset<32> key[], std::vector<std::bitset<8>>& text, const int numRounds);	
void printHelpText();																			// print help information to user (program usage, etc...)
void subBytes(std::vector<std::bitset<8>> &inText);												// Substitute bytes state transformation and inverse
void invSubBytes(std::vector<std::bitset<8>>& inText);	
void shiftRows(std::vector<std::bitset<8>> &inText);											// Shift rows state transformation and inverse
void invShiftRows(std::vector<std::bitset<8>>& inText);
void mixCols(std::vector<std::bitset<8>>& inText);												// Mix columns state transformation and inverse
void invMixCols(std::vector<std::bitset<8>> &inText);
void addRoundKey(std::vector<std::bitset<8>>& state, std::bitset<32>* ks, int curRound);		// addRoundKey state transformation - XOR's round key in key schedule with state
std::bitset<8> 		GFMult(std::bitset<8> &valA, std::bitset<8> &valB);							// performs Galios Field Multiplication (2^8)
std::bitset<8> 		subByte(std::bitset<8> inByte);												// helper functions
std::bitset<8> 		invSubByte(std::bitset<8> inByte);
std::bitset<32> 	subWord(std::bitset<32> inWord);
std::bitset<32> 	rotWord(std::bitset<32> rotWord);
std::bitset<32> 	Rcon(std::bitset<32> inWord);
std::bitset<32>* 	KeyExpansion(std::bitset<8> key[], int rounds, int wordsInKey);				// Generates N-entry key schedule of round keys, each consisting of 4 32-bit words (for a total of 128 bits). N = # rounds in cipher + 1
void printStateRow(const std::vector<std::bitset<8>>& state);									// State matrix print functions - for debug
void printStateCol(const std::vector<std::bitset<8>>& state);


int main(int argc, char* argv[]) {

	// local vars
	std::string arg;		// arg loader var
	int mode;				// program mode [0 = encrypt, 1 = decrypt]
	int keysize;			// cipher keysize [128, 192, or 256]
	int rounds;				// rounds based on keysize [10, 12, or 14]
	int segments;			// number of segments plaintext is split into
	std::string key;		// encryption key							- TODO: maybe easier if char* key[] (?)
	std::string text;		// plaintext/ciphertext = text to be encrypted/decrypted
	std::vector<std::bitset<8>> state;		// 4x4 Column-Major State Matrix
	std::bitset<8> keyBytes[32];			// Key bytes for generating key schedule
	std::bitset<32>* ks;					// Key schedule - array N*4 32-bit words, every 4 of which represents a round key for a round of processing in the cipher. N = # rounds + 1

	// Validate arguments
	if (argc >= 2) {							// Handle program help
		if (std::string(argv[1]) == "help") {
			std::cout << "\nType \"mpi help\" to show help on how to use this program (this text).\n\n";
			printHelpText();
			return 0;
		}
	}
	if (argc > 5) 		{						// validate argument count
		std::cerr << "Too many program arguments! Enter 'mpi help' for more information." << std::endl;
		return -1;
	}
	else if (argc < 5)	{
		std::cerr << "Too few program arguments! Enter 'mpi help' for more information." << std::endl;
		return -1;
	}
	arg = std::string(argv[1]);					// validate program cipher mode [encrypt/decrypt]
	if (arg != "encrypt" && arg != "decrypt") {
		std::cerr << '\'' << arg << "' is an invalid program mode. Valid program modes are 'encrypt' or 'decrypt'. Enter 'mpi help' for more information." << std::endl;
		return -1;
	}
	else mode = (arg == "encrypt" ? 0 : 1);
	arg = std::string(argv[2]);					// validate keysize value
	if (arg != "128" && arg != "192" && arg != "256") {
		std::cerr << '\'' << arg <<"' is an invalid keysize value. Valid keysizes are '128', '192', or '256' (bits). Enter 'mpi help' for more information." << std::endl;
		return -1;
	}
	else keysize = atoi(arg.c_str());

	switch (keysize) {							// set rounds by specified keysize
		case 128:
			rounds = 10;
			break;
		case 192:
			rounds = 12;
			break;
		case 256:
			rounds = 14;
	}

	arg = std::string(argv[3]);					// validate encryption key (size)
	if ((keysize == 128 && arg.size() != 16) || (keysize == 192 && arg.size() != 24) || (keysize == 256 && arg.size() != 32)) {
		std::cerr << '\'' << arg <<"' is an invalid key. Key must be ";
		std::cerr << (keysize == 128 ? 16 : (keysize == 192 ? 24 : 32));
		std::cerr << " characters (exact length) for " << keysize << " bit " << (mode == 0 ? "encryption" : "decryption") << ". Enter 'mpi help' for more information." << std::endl;
		return -1;
	}
	key = arg;

	arg = std::string(argv[4]);					// validate plaintext/ciphertext
	if (arg.size() == 0) {
		std::cerr << "Invalid input.";
		std::cerr << (mode == 0 ? "Plaintext" : "Ciphertext");
		std::cerr << " cannot be blank. Enter 'mpi help' for more information." << std::endl;
		return -1;
	}
	text = arg;

	/*
		MPI Strategy
		Core 0 distributes segments to other cores.
		Cores 1 through (n-1) perform encryption / decryption.
		Cores send encrypted/decrypted segment back to core 0 in sequence.
		Core 0 stitches encrypted/decrypted segments together.
		Core 0 prints merged result.
	*/

	// MPI vars
	int commsize;		// # processes running prog
	int rank;			// index of *this* process
	int workers;		// # worker procs

	MPI_Init(NULL, NULL);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
	MPI_Comm_size(MPI_COMM_WORLD, &commsize);
	workers = commsize - 1;

	// Begin measuring time
	auto start = std::chrono::high_resolution_clock::now();

	// Generate Key Schedule
	for (int j = 0; j < (keysize/8); ++j) keyBytes[j] = std::bitset<8>(key[j]);		// Load key characters into array for key expansion
	ks = KeyExpansion(keyBytes, rounds, (key.size() / 4));							// Perform key expansion to generate key schedule	

	int index;
	char temp;
	std::string out = "";				// final plaintext/ciphertext [core 0 = final output, other = encrypted/decrypted segment]
	std::vector<std::bitset<8>> buffer; // buffer for converting between byte arrays and text input/output
	std::string tmp = "";
	if (mode) {
		buffer = b64decode(text);					// decode input if decrypt
		segments = (buffer.size() / 16);			// calculate # segments (blocks)
		if ((buffer.size() % 16) > 0) segments++;
	}
	else {
		segments = (text.size() / 16);				// calculate # segments (blocks)
		if ((text.size() % 16) > 0) segments++;
	}
	if (rank != 0) {
		for (int i = (rank-1); i < segments; i += workers) {		// Iteratively run cipher over blocks
			if (!mode) {								
				for (int j = 0; j < 16; ++j) {
					index = (16 * i) + j;
					if (index >= text.size()) 	state.push_back(std::bitset<8>(0x00));
					else 						state.push_back(std::bitset<8>(text[index]));
				}
				encrypt(ks, state, rounds);					// perform encryption
				for (auto c : state) tmp += (char)(c.to_ulong());
			}
			else {
				for (int j = 0; j < 16; ++j) {
					index = (16 * i) + j;
					if (index >= buffer.size()) state.push_back(std::bitset<8>(0x00));
					else 						state.push_back(buffer[index]);
				}
				decrypt(ks, state, rounds);					// perform decryption
				for (auto c : state) {						// append character to out string
					temp = (char)(c.to_ulong());
					if (temp == 0x00) break;
					tmp += temp;
				}
			}
			state.erase(state.begin(), state.end());		// erase state matrix for next iteration (block)
			MPI_Send(tmp.c_str(), tmp.size(), MPI_CHAR, 0, 0, MPI_COMM_WORLD);
			tmp = "";
		}
	}
	else {		// core 0
		int source = 1;		// source worker proc
		int bs;				// buffer size
		MPI_Status mpiStat;

		for (int i=0; i < segments; i++) {		// iterate worker procs
			MPI_Probe(source, 0, MPI_COMM_WORLD, &mpiStat);
			MPI_Get_count(&mpiStat, MPI_CHAR, &bs);
			char* cbuf = new char[bs];		// dynamically allocate memory
			MPI_Recv(cbuf, bs, MPI_CHAR, source, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

			if (!mode) {		// encrypt
				// char buffer will always hold 16 chars
				for (int j=0; j<16; j++) {
					buffer.push_back(std::bitset<8>(cbuf[j]));		// convert and push
				}
			}
			else {				// decrypt
				// char buffer may hold fewer than 16 chars (is null terminator included in bs length? DO NOT INCLUDE null terminator)
				for (int j=0; j < bs; j++) {
					out += cbuf[j];
				}
			}
			delete cbuf;					// free mem
			source++;
			if (source > workers) source = 1;
		}
		if (!mode) out = b64encode(buffer);					// base 64 encode buffer of encrypted text for console output
		std::cout << out << '\n';							// output merged encrypted/decrypted string

		// stop measuring time
		auto stop = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start);
		std::cerr << "Execution Time: " << duration.count() << "ms\n";		// use cerr to avoid contaminating output for file pipes
	}

	MPI_Finalize();

	return 0;
}

// Print help text to the console
void printHelpText() {
	std::cout << "Usage:\n\
mpirun -np <# proc> ./mpi encrypt {KEYSIZE=128,192,256} \"ENCRYPTION_KEY\" \"PLAINTEXT\"\n\
mpirun -np <# proc> ./mpi decrypt {KEYSIZE=128,192,256} \"ENCRYPTION_KEY\" \"CIPHERTEXT\"\n\
** np MUST be two or greater\n\
eg. mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ \"This is some random plaintext. Unlike the key, it can be of any length\".\n\
\n\
Notes:\n\
- 'mpirun' launches an OpenMPI program.\n\
- '-np <# proc>' specifies the number of processes to run in parallel.\
- 'mpi' invokes this program.\n\
- 'encrypt/decrypt' specifies whether to encrypt or decrypt.\n\
- 'KEYSIZE': Substitute the key size value (in bits) here. Valid key sizes are 128, 192, or 256 bits.\n\
- 'ENCRYPTION_KEY': Substitute the encryption key here. The number of characters that must be in the key directly corresponds to the key size value:\n\
  | Key Size | # Chars in Key |\n\
  +----------+----------------+\n\
  |   128    |       16       |\n\
  |   192    |       24       |\n\
  |   256    |       32       |\n\
  +----------+----------------+\n\
\n\
- 'PLANTEXT/CIPHERTEXT': Substitute the plaintext/ciphertext to be encrypted/decrypted here.\n" << std::endl;
}

/*
	Perform encryption cipher to block (128 bits) of plaintext. After all processing finished, 
	bytes in state matrix are encrypted and must be base64 encoded in order to be output to
	the user.

	@key - computed key schedule
	@state - 4x4 state matrix of bytes - initially corresponds to 16 sequential characters in input plaintext
	@numrounds - The number of rounds of processing to be performed by the cipher as determined by the size of the key
		ie. 128 bit AES --> 10 rounds
*/
void encrypt(std::bitset<32> key[], std::vector<std::bitset<8>>& state, int numRounds) {

	addRoundKey(state, key, 0);
	for (int i = 1; i < numRounds; ++i) {		// rounds 1 - (N-1)
		subBytes(state);
		shiftRows(state);
		mixCols(state);
		addRoundKey(state, key, i);
	}
												// round N
	subBytes(state);
	shiftRows(state);
	addRoundKey(state, key, numRounds);
}

/*
	Perform inverse cipher to block (128 bits) of base 64 decoded ciphertext. After all processing finished, 
	bytes in state matrix are decrypted and directly correspond to characters in the original 
	plaintext.

	@key - computed key schedule
	@state - 4x4 state matrix of bytes - initially corresponds to 16 sequential characters in input plaintext
	@numrounds - The number of rounds of processing to be performed by the cipher as determined by the size of the key
		ie. 128 bit AES --> 10 rounds
*/
void decrypt(std::bitset<32> key[], std::vector<std::bitset<8>>& state, int numRounds) {

	addRoundKey(state, key, numRounds);
	for (int i = (numRounds-1); i > 0; --i) {
		invShiftRows(state);
		invSubBytes(state);
		addRoundKey(state, key, i);
		invMixCols(state);
	}
												// round N
	invShiftRows(state);
	invSubBytes(state);
	addRoundKey(state, key, 0);
}

/*
	Each byte of state is XOR'ed with the corr. byte of this round's
	round key (generated with Rijndael's keyschedule). Round key
	consists of four sequential 32-bit words in key schedule.

	@state = conceptually is a 4x4 column-major matrix of bytes --> 128 bits that represent 'block'
	@ks = key schedule array
	@curRound = current round number
*/
void addRoundKey(std::vector<std::bitset<8>>& state, std::bitset<32>* ks, int curRound) {
	
	const int 				ksIndex = curRound * 4;		// base index for current round's round key in key schedule
	const std::bitset<32> 	mask(0xFF);					// mask for single byte extraction
	std::bitset<32> 		rkword(0x00);				// buffer for single word in round key
	std::bitset<8>			rkbyte(0x00);				// buffer for single byte in loaded word of round key
	int						sti = 0;					// state index

	for (int i=0; i < 4; i++) {		// iterate all 4 words in current round key
		rkword = ks[ksIndex + i];
		for (int j=0; j < 4; j++) {		// iterate 4 bytes in i'th state matrix column
			rkbyte = std::bitset<8>((int)((rkword >> (8 * j)) & mask).to_ulong());		// extract byte from word
			sti = (4 * i) + j;						// process in column-major order
			state[sti] = state[sti] ^ rkbyte;		// perform XOR
		}
	}
}

/*
	Processes bytes of key and performs a key expansion routine to generate the key schedule.
	Returns a key schedule of R+1 128-bit "round keys", where R = # of rounds of processing
	ie. if 128 bit AES, R = 10, thus Key expansion generates 11 round keys
	Key schedule represented as a list of 32 bit words -> ie. Each 128 bit round key consists of 4 of these words

	@key - bytes of initial key
	@rounds - number of rounds as determined by key size in bits (128b=10,192b=12,256b=14)
	@wordsInKey - number of words in initial key
*/
std::bitset<32>* KeyExpansion(std::bitset<8> key[], int rounds, int wordsInKey) {

	std::bitset<32> rconTable[] = {0x00,0x01000000,0x02000000,0x04000000,0x08000000,0x10000000,0x20000000,0x40000000,0x80000000,0x1B000000,0x36000000};
	std::bitset<32> temp;
	static std::bitset<32> expWord[60]; //Set to max size to apease the beast that is C++, discuss fix at later date
	std::string tempBits;

	for (int i = 0; i < wordsInKey; ++i) {
		tempBits = key[4 * i].to_string() + key[4 * i + 1].to_string() + key[4 * i + 2].to_string() + key[4 * i + 3].to_string();
		expWord[i] = (std::bitset<32>(tempBits));
	}
															// rounds = 10
	for (int i = wordsInKey; i < (4 * (rounds + 1)); ++i) {	// i = 4, i < 44, i++
		temp = expWord[i - 1];
		if (i % wordsInKey == 0) {
			temp = subWord(rotWord(temp)) ^ rconTable[i/wordsInKey];

		}
		else if (wordsInKey > 6 && (i % wordsInKey == 4)) {
			temp = subWord(temp);
		}
		expWord[i] = expWord[i - wordsInKey] ^ temp;
	}
	return expWord;
}

// Performs cyclic permutation on bytes of a word - for key expansion
std::bitset<32> rotWord(std::bitset<32> inWord) {
	std::string wordString = inWord.to_string();
	std::string firstByte = wordString.substr(0,8);
	std::string newWord = wordString.substr(8, 24);
	newWord.append(firstByte);
	return std::bitset<32>(newWord);
}

// Perform Sub Byte routine on each individual byte of state matrix
void subBytes(std::vector<std::bitset<8>> &inText) {
	for (int i = 0; i < 16; ++i) {
		inText[i] = subByte(inText[i]);
	}

}

// Perform Inverse Sub Byte routine on each individual byte of state matrix
void invSubBytes(std::vector<std::bitset<8>>& inText) {
	for (int i = 0; i < 16; ++i) {
		inText[i] = invSubByte(inText[i]);
	}
}

/*
	The last three rows of the state matrix are cyclically shifted (rotated)
	over a different number of offsets. The first row is not rotated. The 
	second row is rotated one place to the left. The third row is rotated
	two places to the left. The fourth row is rotated three places to the 
	left. 
*/
void shiftRows(std::vector<std::bitset<8>> &inText) {
	std::bitset<8> temp1;
	std::bitset<8> temp2;
	std::bitset<8> temp3;
	std::bitset<8> temp4;
	std::bitset<8> zero = std::bitset<8>(0x00);
	for (int i = 0; i < 4; ++i) {
		temp1 = inText[i * 4] ^ zero;
		temp2 = inText[(i * 4)+1] ^ zero;
		temp3 = inText[(i * 4)+2] ^ zero;
		temp4 = inText[(i * 4)+3] ^ zero;
		switch (i) {
		case 1:
			inText[4] = temp2 ^ zero;
			inText[5] = temp3 ^ zero;
			inText[6] = temp4 ^ zero;
			inText[7] = temp1 ^ zero;
			break;
		case 2:
			inText[8] = temp3 ^ zero;
			inText[9] = temp4 ^ zero;
			inText[10] = temp1 ^ zero;
			inText[11] = temp2 ^ zero;
			break;
		case 3:
			inText[12] = temp4 ^ zero;
			inText[13] = temp1 ^ zero;
			inText[14] = temp2 ^ zero;
			inText[15] = temp3 ^ zero;
			break;
		default:
			break;
		}
	}
}

/*
	Performs the inverse of the shiftRows process as described above on
	the state matrix, thereby reverting the matrix to its previous state.
*/
void invShiftRows(std::vector<std::bitset<8>>& inText) {
	std::bitset<8> temp1;
	std::bitset<8> temp2;
	std::bitset<8> temp3;
	std::bitset<8> temp4;
	std::bitset<8> zero = std::bitset<8>(0x00);
	for (int i = 0; i < 4; ++i) {
		temp1 = inText[i * 4] ^ zero;
		temp2 = inText[(i * 4) + 1] ^ zero;
		temp3 = inText[(i * 4) + 2] ^ zero;
		temp4 = inText[(i * 4) + 3] ^ zero;
		switch (i) {
		case 1:
			inText[4] = temp4 ^ zero;
			inText[5] = temp1 ^ zero;
			inText[6] = temp2 ^ zero;
			inText[7] = temp3 ^ zero;
			break;
		case 2:
			inText[8] = temp3 ^ zero;
			inText[9] = temp4 ^ zero;
			inText[10] = temp1 ^ zero;
			inText[11] = temp2 ^ zero;
			break;
		case 3:
			inText[12] = temp2 ^ zero;
			inText[13] = temp3 ^ zero;
			inText[14] = temp4 ^ zero;
			inText[15] = temp1 ^ zero;
			break;
		default:
			break;
		}
	}
}

/*
	Operates on the state matrix column by column, treating each column
	as a 4 term polynomial over GF(2^8) [Galios Field] then multiplying
	it modulo (x^4 + 1) with a fixed polynomial a(x) = {03}x^3 + {01}x^2
	+ {01}x + {02}. This essentially boils down to a matrix multiplication.
	The resulting state matrix has columns with values that have been
	mathematically transformed. This step is not performed is the last 
	round of processing.
*/
void mixCols(std::vector<std::bitset<8>> &inText) {
	std::bitset<8> zero = std::bitset<8>(0x00);
	std::bitset<8> two = std::bitset<8>(0x02);
	std::bitset<8> three = std::bitset<8>(0x03);
	std::bitset<8> temp1;
	std::bitset<8> temp2;
	std::bitset<8> temp3;
	std::bitset<8> temp4;

	for (int i = 0; i < 4; ++i) {
		temp1 = inText[0 + i] ^ zero;
		temp2 = inText[4 + i] ^ zero;
		temp3 = inText[8 + i] ^ zero;
		temp4 = inText[12 + i] ^ zero;

		inText[0 + i] = GFMult(two, temp1) ^ GFMult(three, temp2) ^ temp3 ^ temp4;
		inText[4 + i] = temp1 ^ GFMult(two, temp2) ^ GFMult(three, temp3) ^ temp4;
		inText[8 + i] = temp1 ^ temp2 ^ GFMult(two, temp3) ^ GFMult(three, temp4);
		inText[12 + i] = GFMult(three, temp1) ^ temp2 ^ temp3 ^ GFMult(two, temp4);
	}
}

/*
	Performs the inverse of the mixCols process as described above on
	the state matrix, thereby reverting the matrix to its previous
	state.
*/
void invMixCols(std::vector<std::bitset<8>>& inText) {
	std::bitset<8> zero = std::bitset<8>(0x00);
	std::bitset<8> eleven = std::bitset<8>(0x0b); //hex 0x0b
	std::bitset<8> thirteen = std::bitset<8>(0x0d); //hex 0x0d
	std::bitset<8> nine = std::bitset<8>(0x09); //hex 0x09
	std::bitset<8> fourteen = std::bitset<8>(0x0e); //hex 0x0e
	std::bitset<8> temp1;
	std::bitset<8> temp2;
	std::bitset<8> temp3;
	std::bitset<8> temp4;

	for (int i = 0; i < 4; ++i) {
		temp1 = inText[0 + i] ^ zero;
		temp2 = inText[4 + i] ^ zero;
		temp3 = inText[8 + i] ^ zero;
		temp4 = inText[12 + i] ^ zero;

		inText[0 + i] = GFMult(fourteen, temp1) ^ GFMult(eleven, temp2) ^ GFMult(thirteen, temp3) ^ GFMult(nine, temp4);
		inText[4 + i] = GFMult(nine, temp1) ^ GFMult(fourteen, temp2) ^ GFMult(eleven, temp3) ^ GFMult(thirteen, temp4);
		inText[8 + i] = GFMult(thirteen, temp1) ^ GFMult(nine, temp2) ^ GFMult(fourteen, temp3) ^ GFMult(eleven, temp4);
		inText[12 + i] = GFMult(eleven, temp1) ^ GFMult(thirteen, temp2) ^ GFMult(nine, temp3) ^ GFMult(fourteen, temp4);
	}
}

//This is Finite Field Multiplication check: https://en.wikipedia.org/wiki/Finite_field_arithmetic for more info
/* This function performs Galios Field (2^8) multiplication on 2 multiplicands and employes the reducing polynomial
* x^8 + x^4 + x^3 + x + 1, which as a byte can be represented as 100011011 or 0x1b in hex. This form of multiplying 
* bytes was employed by Rijndael to generate multiple functions of encryption for AES (i.e. mixcols, subBytes, etc.).
* 
* GF(2^8) multiplication is performed by treating the multiplicand bytes as polynomials and multiplying them, removing
* any values with a coefficient higher than 1. The result is the reaminder from the product modulo 0x1b. However the same
* result is achieved through performing XOR on the product for everytime the first bit is set on the second multiplicand, shifting
* both multiplicands left and right respectively (accounting for the carry), and adding 0x1b to the first multiplicand everytime the
* carry bit is set.
*/
std::bitset<8> GFMult(std::bitset<8> &valA, std::bitset<8> &valB) {
	std::bitset<8> Pval = std::bitset<8>(0x00);
	std::bitset<8> valX = std::bitset<8>(0x1b); //hex 0x1b
	std::bitset<8> tempA = valA ^ Pval;
	std::bitset<8> tempB = valB ^ Pval;
	int carry;

	for (int i = 0; i < 8; ++i) {
		if (tempB[0] == 1) Pval = Pval ^ tempA;
		tempB >>= 1;
		carry = tempA[7];
		tempA <<= 1;
		if (carry == 1) tempA = tempA ^ valX;
	}
	return Pval;
}

// Transforms (substitutes) bytes of word using S-Box lookup table - for key expansion
std::bitset<32> subWord(std::bitset<32> inWord) {
	std::string wordString = inWord.to_string();
	std::string subString = "";

	for (int i = 0; i < 4; ++i) {
		subString.append(subByte(std::bitset<8>(wordString.substr(i * 8, 8))).to_string());
	}
	return std::bitset<32>(subString);
}

/*
	Maps 'inByte' to a value in the S-Box and returns it, thereby substituting
	inByte for another value. The S-Box is a lookup table that uniquely maps each
	possible byte to another value. 
*/
std::bitset<8> subByte(std::bitset<8> inByte) {
	//Step 1: Find Multiplicative Inverse
	int carry;
	std::bitset<8> valB = std::bitset<8>(0x00); //starts at 0
	std::bitset<8> valA = inByte; //^ valB;
	std::bitset<8> valP;
	std::bitset<8> one = std::bitset<8>(0x01); //1
	std::bitset<8> valX = std::bitset<8>(0x1b); //hex 0x1b
	std::bitset<8> staticByte = std::bitset<8>(0x63); //hex 63

	if (valA == valB) return staticByte; //If {00} map to itself i.e. return {63}

	while(true){
		//Performs check for if valB is mult inv. of A, if valP == 1, then yes, otherwise no
		valP = std::bitset<8>(0x00);
		std::bitset<8> tempA = valP ^ valA; //Copy over value of A to temp
		std::bitset<8> tempB = valP ^ valB; //Copy over value of B to temp
		
		valP = GFMult(tempA, tempB);

		if (valP == one) break;
		else {
			long longB = valB.to_ulong() + 1;
			valB = std::bitset<8>(longB);
		}
	}

	//Step 2: Substitution of the inverse
	std::string bitString = "";
	for (int i = 0; i < valB.size(); ++i) { // STEP 2 of SubBytes (Perform transformation on multiplicative inverse)
		bitString.append(std::to_string(valB[i] ^ valB[(i+4) % 8] ^ valB[(i + 5) % 8] ^ valB[(i + 6) % 8] ^ valB[(i + 7) % 8] ^ staticByte[i]));
	}
	for (int i = 0; i < (bitString.size() / 2); i++) { //reverse String
		std::swap(bitString[i], bitString[bitString.size() - i - 1]);
	}
	return std::bitset<8>(bitString);
}

/*
	Performs the inverse of the subByte process as described above on
	the state matrix, thereby reverting the matrix to its previous
	state.
*/
std::bitset<8> invSubByte(std::bitset<8> inByte) {
	int carry;
	std::bitset<8> valB = std::bitset<8>(0x00); //starts at 0
	std::bitset<8> valA = inByte; //^ valB;
	std::bitset<8> valP;
	std::bitset<8> one = std::bitset<8>(0x01); //1
	std::bitset<8> valX = std::bitset<8>(0x1b); //hex 0x1b
	std::bitset<8> staticByte = std::bitset<8>(0x05); //hex 05

	//Step 1: The Substitution of the input
	std::string bitString = "";
	for (int i = 0; i < valA.size(); ++i) { // STEP 2 of SubBytes (Perform transformation on multiplicative inverse)
		bitString.append(std::to_string(valA[(i + 2) % 8] ^ valA[(i + 5) % 8] ^ valA[(i + 7) % 8] ^ staticByte[i]));
	}
	for (int i = 0; i < (bitString.size() / 2); i++) { //reverse String
		std::swap(bitString[i], bitString[bitString.size() - i - 1]);
	}
	valA = std::bitset<8>(bitString);

	//Step 2: Multiplicative Inverse of the substitution
	if (valA == std::bitset<8>(0x00)) return std::bitset<8>(0x00);
	while (true) {
		//Performs check for if valB is mult inv. of A, if valP == 1, then yes, otherwise no
		valP = std::bitset<8>(0x00);
		std::bitset<8> tempA = valP ^ valA; //Copy over value of A to temp
		std::bitset<8> tempB = valP ^ valB; //Copy over value of B to temp

		valP = GFMult(tempA, tempB);

		if (valP == one) {
			break;
		}
		else {
			long longB = valB.to_ulong() + 1;
			valB = std::bitset<8>(longB);
		}
	}
	return valB;
}

// Print functions - for debug
void printStateRow(const std::vector<std::bitset<8>>& state) {
	std::cout << "State Matrix [Row-Major]:\n";
	for (int a=0; a < 4; a++) {
		std::cout << '\t';
		for (int b=0; b < 4; b++) {
			int index = (a*4) + b;
			std::cout << state[index] << " ";
		}
		std::cout << '\n' << std::endl;
	}
}

void printStateCol(const std::vector<std::bitset<8>>& state) {
	std::cout << "State Matrix [Column-Major]:\n";
	for (int a=0; a < 4; a++) {
		std::cout << '\t';
		for (int b=0; b < 4; b++) {
			int index = (b*4) + a;
			std::cout << state[index] << " ";
		}
		std::cout << '\n' << std::endl;
	}
}