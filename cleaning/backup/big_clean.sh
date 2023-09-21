#!/bin/bash

# Similar to the compiling script... the first argument is the name of the tar archive to operate on.
dir=$1

# Again... make sure the archive file exists first.
if [ ! -f "${dir}" ]; then
	echo "# The archive specified does not exist." >&2
	exit 1
fi

# Make a temporary scratch directory named "temp".
# The argument -d specifies the object we are making is a directory.
# The argument -p allows us to specify a relative filepath for this directory (by default, it is made in /tmp)
# We should also capture the output of mktemp in a variable so we can actually access its filepath later. Using parentheses () in the variable assignment allows us to do so.
tempdir=$(mktemp -dp .)

# Store the current directory for use later.
here=$(pwd)

# Same tar command as before; we also need to specify that we are extracting the files to the new tempdir.
# The flag -C allows us to specify the directory we are extracting into (changes to this dir before performing any operations)
tar -xzf "${1}" -C "${tempdir}"

# Loop through files in this new extracted directory...
# The % operator deletes the '.tgz' match from the name of the tar file we extracted, so we can access its directory within the tempdir... thanks to pfnuesel on StackOverflow for this one.
cd "${tempdir}/${1%.tgz}"

for file in *; do
	# Send the output of the grep search for "DELETE ME!" in each file to a variable.
	# There is probably a better way to do this... but as I'm just starting to get familiar with how these searching tools work, this option is the most intuitive to me for right now.
	out=$(grep "DELETE ME!" file)
	# The -z flag checks that the variable is empty; i.e., if grep does contain some output, delete the file
	if [ ! -z "${out}" ]; then
		rm file
	fi
done

# Once we've cleaned the files, we make a new tar archive containing them.
# We HAVE to be in the scratch directory to ensure that the file names are correct.
cd ${tempdir}
newtar=$(tar -zcf "cleaned_${1}" "cleaned_${1%.tgz}")

# Move the new tar file into cleaning/
mv ${newtar} ${here}
