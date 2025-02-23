#!/bin/bash
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

# error handling function, exit on fail
error_exit() {
	echo -e "${RED}Error: $1${RESET}" >&2
	exit 1
}

# echo -e "${CYAN}Input directory you want to log file names from${RESET}"
directory=$(realpath "$1")

# check if provided directory exists and isn't empty
if [ ! -d "${directory}" ]; then
	error_exit "No directory found at: ${directory}"
elif [ -z "$(ls -A "$directory" 2>/dev/null)" ]; then #2>dev/null supresses the ls error message when directory doesn't exist
	error_exit "Directory is empty ${directory}"
fi

log_file="log_$(date +%Y-%m-%d_%H-%M-%S).txt" #sets log file name with date

maxCount=0
for file in "$directory"/.* "$directory"/* #loops through all hidden files / unhidden files
do
	# Skip . and .. and .* directory entries
	[[ "$file" == "$directory/." || "$file" == "$directory/.." || "$file" == "$directory/.*" ]] && continue
	maxCount=$((maxCount+1))
	# echo "${file##*/}" >> "$log_file"
	echo "${file##*/}"
done
# echo "Logged file count is: ${maxCount}" >> "$log_file"
echo "Logged file count is: ${maxCount}"