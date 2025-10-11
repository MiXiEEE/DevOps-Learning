#!/bin/bash

# Create a script that performs a series of commands, implementing error handling with set -e and logging errors.
# Write a script that reads a file and prints each line, handling errors if the file doesn’t exist.
# Use trap to catch errors and log them.

# The set -e command will exit the script if any command fails.
set -e
# The trap command captures errors and prints a message before exiting.
trap 'echo "An error occured. Exiting..."; exit 1' ERR
trap 'echo "Stopped!"; exit 0' INT

read -p "Input file with its path: " file

# checks if file exists and is a file
if [ ! -f "$file" ]; then
	echo "Error: Can't find file or not a regular file." >&2
	exit 1 # Exit with an error status
fi

line_number=1

# Read file line by line
while read -r line; do
	echo "$line_number: $line"
	((line_number++))
done < "$file" # Redirects input from the file
