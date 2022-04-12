# test aes program
# using phrases:
# a) "hello there" - 11 chars, 1 block
# b) "A grilled cheese sandwich." - 27 chars, 2 blocks
# c) "I bless the rains down in Africa." - 33 chars, 3 blocks
# d) "Keep your friends close, but your enemies closer." - 49 chars, 4 blocks
# e) "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." - 114 chars, 8 blocks
# f) "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." - 257 chars, 17 blocks
# using keys:
# 128) "this_is_the_key_" - 16 chars
# 192) "this_is_the_longer_key__" - 24 chars
# 256) "this_here_is_an_even_longer_key_" - 32 chars
# Tested with:
# 2 processes
# 3 processes
# 4 processes

filename=times3.txt

# test 128 bit - 2 procs
echo "" >> $filename
echo "128 Bit - 2 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 2 ./mpi encrypt 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 2 ./mpi encrypt 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 2 ./mpi encrypt 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 2 ./mpi encrypt 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 2 ./mpi encrypt 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 2 ./mpi encrypt 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename

# test 192 bit - 2 procs
echo "" >> $filename
echo "192 Bit - 2 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 2 ./mpi encrypt 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 2 ./mpi encrypt 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 2 ./mpi encrypt 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 2 ./mpi encrypt 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 2 ./mpi encrypt 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 2 ./mpi encrypt 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename

# test 256 bit - 2 procs
echo "" >> $filename
echo "256 Bit - 2 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 2 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 2 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 2 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 2 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 2 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 2 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 2 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename

# test 128 bit - 3 procs
echo "" >> $filename
echo "128 Bit - 3 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 3 ./mpi encrypt 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 3 ./mpi encrypt 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 3 ./mpi encrypt 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 3 ./mpi encrypt 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 3 ./mpi encrypt 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 3 ./mpi encrypt 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename

# test 192 bit - 3 procs
echo "" >> $filename
echo "192 Bit - 3 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 3 ./mpi encrypt 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 3 ./mpi encrypt 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 3 ./mpi encrypt 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 3 ./mpi encrypt 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 3 ./mpi encrypt 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 3 ./mpi encrypt 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename

# test 256 bit - 3 procs
echo "" >> $filename
echo "256 Bit - 3 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 3 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 3 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 3 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 3 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 3 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 3 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 3 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename

# test 128 bit - 4 procs
echo "" >> $filename
echo "128 Bit - 4 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 4 ./mpi encrypt 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 128 this_is_the_key_ `< ciphertext.txt` 2>> $filename

# test 192 bit - 4 procs
echo "" >> $filename
echo "192 Bit - 4 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 4 ./mpi encrypt 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 4 ./mpi encrypt 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 4 ./mpi encrypt 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 4 ./mpi encrypt 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 4 ./mpi encrypt 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 4 ./mpi encrypt 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> $filename

# test 256 bit - 4 procs
echo "" >> $filename
echo "256 Bit - 4 procs:" >> $filename
echo "1 segment" >> $filename
mpirun -np 4 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "2 segments" >> $filename
mpirun -np 4 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "3 segments" >> $filename
mpirun -np 4 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "4 segments" >> $filename
mpirun -np 4 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "8 segments" >> $filename
mpirun -np 4 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename
echo "17 segments" >> $filename
mpirun -np 4 ./mpi encrypt 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> $filename
mpirun -np 4 ./mpi decrypt 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> $filename