#!/bin/bash

# The first argument passed into the bash script should be the prime number we are giving to the compiled C code.
prime=$1

# Make sure the archive file exists before we bother trying to uncompress it.
if [ ! -f NthPrime.tgz ]; then
	echo "# The archive NthPrime.tgz does not exist." >&2
	exit 1
fi

# We use the tar command to extract the compressed tar file.
# -x is required and indicates that we are to extract the given file.
# -z I don't believe is required, but tells tar to filter the archive through gunzip, which is how it is
# compressed already (using the .tgz or .gz extension)
# -f tells tar the file to be extracted; in this case, the name of the file directly follows.
# We will NOT use the verbose flag -v here since it can cause some of the tests to fail according to the README.md file. In other situations it may be nice, though.
tar -xzf NthPrime.tgz

# The result of the above code is that we get a directory NthPrime,
# containing the files main.c, nth_prime.c, and nth_prime.h
# We need to compile these files to generate the binary file simply called
# NthPrime

# We use the gcc compiler to achieve this, linking both main.c and nth_prime.c in (hopefully) one step. From my understanding, gcc links the files automatically if both are compiled together. The -o flag determines what file to "put" all of the linked, compiled code into.
cd NthPrime && gcc -o NthPrime main.c nth_prime.c

# Now we need to actually run the C code we've just created, and pass into it the first command line argument we received from the user.
./NthPrime "${prime}"
