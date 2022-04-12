#ifndef BASE64_H
#define BASE64_H

/*
	COSC 3P93 Group Project
	Topic: AES Encryption

	Base 64 Encoding/Decoding Utility.

	Authors:
		Tennyson Demchuk (td16qg@brocku.ca) | St#: 6190532
		Daniel Sokic (ds16sz@brocku.ca) 	| St#: 6164545

	Usage:
		std::string encoded = b64encode(std::vector<std::bitset<8>>{00011000,10111001,...});
        std::vector<std::bitset<8>> decoded = b64decode(encoded);
*/

#include <cmath>
#include <iostream>
#include <vector>
#include <bitset>
#include <cstdint>

const std::string       charmap = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
const char              padchar = '=';              
uint32_t                mask;                       // bitmask
uint32_t                bytebuffer;                 // single byte buffer
uint32_t                tribuffer;                  // triple byte buffer
int numchars;                                       // characters in input
int numpad;                                         // number of padchars to be appended

/*
    Takes in a vector of bytes (bitset<8>) representing characters and converts
    to a base64 encoded string.

    Every 3 chars input = 4 chars in b64, pad when needed
    ie. ABCDEFG --> [ABC][DEF][G] --> [QUJD][REVG][Rw==] --> QUJDREVGRw==
*/
std::string b64encode(std::vector<std::bitset<8>> in) {
    std::string out     = "";
    int         index   = 0;
    numchars = in.size();
    numpad = numchars % 3;
    if (numpad > 0) numpad = 3 - numpad;            // replace the last 'numpad' chars of encoded string with pad characters ('=')

    while (index < numchars) {     // process each input byte
        tribuffer = 0x00;
        for (int i=0; i < 3; i++) {
            bytebuffer = 0x00;
            if (index < numchars) bytebuffer = in[index].to_ulong();
            bytebuffer <<= (8 * (2 - i));
            tribuffer |= bytebuffer;
            index++;
        }
        mask = 0xFC0000;
        for (int i=0; i < 4; i++) {     // extract 6 bits of tribuffer
            bytebuffer = tribuffer & mask;
            bytebuffer >>= (6 * (3 - i));
            out += charmap[bytebuffer];
            mask >>= 6;                 // shift to next 6 bits
        }
    }
    out = out.substr(0,(out.size() - numpad));          // handle padding
    for (int i=0; i < numpad; i++) out += padchar;
    return out;
}

/*
    Takes in a base64 encoded string and converts to a 
    vector of bytes (bitset<8>). 

    Base64 encoded string must contain a multiple of 4 chars, and must
    only contain chars: [A-Z][a-z][0-9][+][/][=]

    Every 4 chars b64 input = 3 chars, remove padding
    ie. QUJDREVGRw== --> [QUJD][REVG][Rw==] --> [ABC][DEF][G] --< ABCDEFG
*/
std::vector<std::bitset<8>> b64decode(std::string& in) {
    std::vector<std::bitset<8>> out;
    int                         index   = 0;
    char                        tmp;                
    numchars = in.size();

    // validate input
    if (numchars % 4 != 0) {
        std::cerr << "Base 64 Decoding Error! Input String \"" << in << "\" is Incorrectly Padded! [Length: " << numchars << "]\n";
        exit(EXIT_FAILURE);
    }

    while (index < numchars) {
        tribuffer = 0x00;
        numpad = 0;
        for (int i=0; i < 4; i++) {     // process input in quads
            tmp = in[index];
            if (isalpha(tmp)) {         // calculate corr. charmap index
                if (isupper(tmp))   bytebuffer = tmp - 65;
                else                bytebuffer = tmp - 71;
            }
            else if (isdigit(tmp))  bytebuffer = tmp + 4;
            else if (tmp == '+')    bytebuffer = 62;
            else if (tmp == '/')    bytebuffer = 63;
            else if (tmp == '=')   {bytebuffer = 0; numpad++;}
            else {
                std::cerr << "Base 64 Decoding Error! Input String is Not Base 64 Encoded! Invalid Char '" << tmp << "' Found!\n";
                exit(EXIT_FAILURE);
            }
            bytebuffer <<= (6 * (3 - i));   // Shift to correct pos for tribuffer
            tribuffer |= bytebuffer;        // load into tribuffer
            index++;
        }
        mask = 0xFF0000;
        numpad = 2 - numpad;
        for (int i=0; i < 3; i++) {
            if (i > numpad) break;
            bytebuffer = tribuffer & mask;
            bytebuffer >>= (8 * (2 - i));
            out.push_back(std::bitset<8>(bytebuffer));
            mask >>= 8;
        }
    }
    return out;
}
#endif