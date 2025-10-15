#!/bin/bash
GREEN="\e[32m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

error_exit() {
    echo -e "${RED}Error: $1${RESET}" >&2
    exit 1
}

echo -e "${CYAN}Source directory you want to create back up${RESET}"
read -r sourceDir

if [ -z "$sourceDir" ]; then
    error_exit "No source directory provided."
fi

echo -e "${CYAN}Where to save the backup, provide extension too!${RESET}"
read -r backup

if [ -z "$backup" ]; then
    backup="default.tar.gz"
fi

if [ ! -d "$sourceDir" ]; then
    error_exit "The source directory '$sourceDir' does not exist."
fi

baseName="${backup%%.*}"
extension="${backup#*.}"

if [[ "$extension" != "tar.gz" ]]; then
    extension="tar.gz"
    backup="${backup}.tar.gz"
fi

if [ -z "$baseName" ] || [ -z "$extension" ]; then
    error_exit "Invalid backup filename."
fi

availableSpace=$(df -k "$sourceDir" | awk 'NR==2 {print $4}')
requiredSpace=$(du -s "$sourceDir" | awk '{print $1}')
if [ "$requiredSpace" -ge "$availableSpace" ]; then
    error_exit "Not enough disk space to create the backup!"
fi

backupFile="${baseName}-$(date -I).${extension}"

# Direct exit code check instead of using $?
if tar cvfz "$backupFile" -C "$(dirname "$sourceDir")" "$(basename "$sourceDir")"; then
    echo -e "${GREEN}Backup completed successfully! File saved as: $backupFile${RESET}"
    echo -e "${CYAN}Listing contents of the backup file:${RESET}"
    tar -tvf "$backupFile"
else
    error_exit "Backup failed."
fi