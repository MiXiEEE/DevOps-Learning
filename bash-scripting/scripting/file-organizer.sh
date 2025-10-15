#!/bin/bash
GREEN="\e[32m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

# Allows user to provide directory path as command line argument
if [ -z "$1" ]; then
	echo -e "${CYAN}Input directory path${RESET}"
	read -r DIRECTORY
else
	DIRECTORY="$1"
fi

error_exit () {
	echo -e "${RED}Error: $1${RESET}" >&2
	exit 1
}

if [ ! -d "$DIRECTORY" ]; then
	error_exit "Directory doesn't exist at this path: ${DIRECTORY}"
fi

# Check if directory is empty
if [ -z "$(ls -A "$DIRECTORY")" ]; then
	error_exit "The directory is empty."
fi

movedCount=0

for file in "$DIRECTORY"/* "$DIRECTORY"/.*
do
	if [ -f "$file" ]; then
		baseName="${file##*/}"

		# Skip hidden files
		if [[ "$(basename "$file")" =~ ^\. ]]; then
			 echo "Skipping hidden file: $file"
			continue
		fi

		echo "Processing: $file"

		# Determine file extension
		if [[ "$baseName" == *.* ]]; then
			fileExt="${baseName##*.}"
		else
			fileExt="unknown"
		fi

		destDir="$DIRECTORY/$fileExt"

		# Create subdirectory if it doesn't exist
		mkdir -p "$destDir"

		# Handle conflict if file already exists, adds _seconds
		if [ -e "$destDir/$baseName" ]; then
			mv "$file" "$destDir/${baseName}_$(date +%s)"
		else
			mv "$file" "$destDir"
		fi

		((movedCount++))

		echo -e "${GREEN}Moved: ${RESET}$baseName -> ${CYAN}$destDir/${RESET}"
	fi
done

echo -e "${GREEN}Total files moved: $movedCount${RESET}"
