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

# using threads:
# 1 thread
# 2 threads
# 4 threads
# 8 threads

# test 128 bit - 1 thread
echo "128 Bit - 1 thread:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 1 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 1 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 1 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 1 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 1 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 1 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

# test 192 bit - 1 thread
echo "" >> times.txt
echo "192 Bit - 1 thread:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 1 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 1 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 1 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 1 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 1 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 1 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

# test 256 bit - 1 thread
echo "" >> times.txt
echo "256 Bit - 1 thread:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 1 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 1 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 1 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 1 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 1 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 1 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 1 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

# test 128 bit - 2 threads
echo "" >> times.txt
echo "128 Bit - 2 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 2 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 2 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 2 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 2 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 2 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 2 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

# test 192 bit - 2 threads
echo "" >> times.txt
echo "192 Bit - 2 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 2 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 2 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 2 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 2 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 2 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 2 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

# test 256 bit - 2 threads
echo "" >> times.txt
echo "256 Bit - 2 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 2 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 2 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 2 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 2 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 2 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 2 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 2 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

# test 128 bit - 4 threads
echo "" >> times.txt
echo "128 Bit - 4 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 4 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 4 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 4 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 4 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 4 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 4 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

# test 192 bit - 4 threads
echo "" >> times.txt
echo "192 Bit - 4 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 4 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 4 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 4 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 4 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 4 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 4 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

# test 256 bit - 4 threads
echo "" >> times.txt
echo "256 Bit - 4 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 4 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 4 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 4 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 4 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 4 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 4 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 4 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

# test 128 bit - 8 threads
echo "" >> times.txt
echo "128 Bit - 8 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 8 128 this_is_the_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 8 128 this_is_the_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 8 128 this_is_the_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 8 128 this_is_the_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 8 128 this_is_the_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 8 128 this_is_the_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 128 this_is_the_key_ `< ciphertext.txt` 2>> times.txt

# test 192 bit - 8 threads
echo "" >> times.txt
echo "192 Bit - 8 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 8 192 this_is_the_longer_key__ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 8 192 this_is_the_longer_key__ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 8 192 this_is_the_longer_key__ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 8 192 this_is_the_longer_key__ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 8 192 this_is_the_longer_key__ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 8 192 this_is_the_longer_key__ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 192 this_is_the_longer_key__ `< ciphertext.txt` 2>> times.txt

# test 256 bit - 8 threads
echo "" >> times.txt
echo "256 Bit - 8 threads:" >> times.txt
echo "1 segment" >> times.txt
./aesomp encrypt 8 256 this_here_is_an_even_longer_key_ "hello there" > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "2 segments" >> times.txt
./aesomp encrypt 8 256 this_here_is_an_even_longer_key_ "A grilled cheese sandwich." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "3 segments" >> times.txt
./aesomp encrypt 8 256 this_here_is_an_even_longer_key_ "I bless the rains down in Africa." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "4 segments" >> times.txt
./aesomp encrypt 8 256 this_here_is_an_even_longer_key_ "Keep your friends close, but your enemies closer." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "8 segments" >> times.txt
./aesomp encrypt 8 256 this_here_is_an_even_longer_key_ "Did you ever hear the tragedy of Darth Plagueis The Wise? I thought not. It's not a story the Jedi would tell you." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt

echo "17 segments" >> times.txt
./aesomp encrypt 8 256 this_here_is_an_even_longer_key_ "It's a Sith legend. Darth Plagueis was a Dark Lord of the Sith, so powerful and so wise he could use the Force to influence the midichlorians to create life… He had such a knowledge of the dark side that he could even keep the ones he cared about from dying." > ciphertext.txt 2>> times.txt
./aesomp decrypt 8 256 this_here_is_an_even_longer_key_ `< ciphertext.txt` 2>> times.txt
