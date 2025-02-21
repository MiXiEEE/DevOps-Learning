#!/bin/bash
# Write a script to monitor disk usage and alert when space is low.
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"

# Get disk usage
disk_info=$(df -Ph /mnt/c 2>/dev/null)
if [ $? -ne 0 ]; then
	echo -e "${RED}Could not retrieve disk info for /mnt/c${RESET}"
	exit
fi

# Extract available space and with tr -d "%" remove % from use% e.g 50% -> 50 and makes it a number
used_space=$(df -Ph /mnt/c | awk 'NR==2 {print $5}' | tr -d "%")

# Calculate available % space
available_space=$((100 - $used_space))

echo "$disk_info"
echo -e "${CYAN}Used Space: $used_space%${RESET}"
echo -e "${CYAN}Available Space: $available_space%${RESET}"

# Check if available space is below 5%
if [ "$available_space" -le 10 ]; then
	echo -e "${RED}Your available space is less than 10%${RESET}"
fi
