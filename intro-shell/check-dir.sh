#!/bin/bash
GREEN="\e[32m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

echo -e "${CYAN}Input directory path!${RESET}"
read dirPath

error_exit() {
	echo -e "${RED}Error: $1${RESET}" >&2
	exit 1
}

if [ -f "${dirPath}" ]; then
	error_exit "file provided instead of directory path"
fi

if [ ! -d "${dirPath}" ] || [ -z "${dirPath}" ]; then
    error_exit "No directory path provided or found"
else
    echo -e "${GREEN}path exists: ${dirPath}${RESET}"
fi
