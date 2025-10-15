#!/bin/bash

# Create a Bash script that prompts the user to enter a directory path, checks if the directory 
# exists, and if it does, lists its contents. If it doesn’t exist, the script should display a friendly error 
# message and prompt the user again until a valid directory is provided.

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# This returns the directory where the script file is located 
SCRIPT_DIR="$(dirname "$0")"
LOGFILE="$SCRIPT_DIR/../bash-logs/directory_check.log"

# A flag to control when to end the script
exit_condition=true

print_and_log_message() {
    # $1 is the message
    local message="$1" # local scope variable
    echo -e "$message" # Show on console ( includes colors )

    # Remove ANSI color codes for clean log
    local clean_message
    clean_message=$(echo -e "$message" | sed 's/\x1b\[[0-9;]*m//g')
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $clean_message" >> "$LOGFILE" # Append to log with timestamp
}

# Trim any leading or trailing whitespace
trim_whitespace() {
    trimmed_var=$(echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    echo "$trimmed_var"
}

# Displays directory files (ls)
list_directory_contents() {
    print_and_log_message "${GREEN}[SUCCESS]${RESET} Successfully printed contents!"
    echo "list $1 contents:"
    if ! ls "$1";  then #  Check permissions errors when listing directories.
        print_and_log_message "${YELLOW}[WARNING]${RESET} Unable to list directory, permission not fulfilled" 
    fi
}

# Directory validation if path exists and is a directory (-d) and if the string is not empty (-n)
directory_validation() {
    if [[ -d "$1" && -n "$1" ]]; then
        return 0 # valid directory
    else
        return 1 # invalid directory
    fi
}

# Prompt user for directory path input
directory_input() {
    # Checks if env variable is set in yml file
    if [ -z "$TARGET_DIR" ]; then
    local directory_path trimmed_directory_path
    echo -n -e "${CYAN}Input directory path or to exit (quit, exit), you would like to check: ${RESET}" >&2
    read -r directory_path
    else
        directory_path=$TARGET_DIR
    fi
    trimmed_directory_path=$(trim_whitespace "$directory_path")
    echo "$trimmed_directory_path"
}

# Prompt user for Yes/No input and validate response
validate_yes_no_input() {
    # If env variable isn't empty exits script
    if [ -n "$TARGET_DIR" ]; then
        check="N"
    else
        echo -e "${CYAN}Input if you wanna search for another directory y/n${RESET}" >&2
        read -r check
    fi
    trimmed_check=$(trim_whitespace "$check")
    # Loop untill the user enters 'Y' or 'N' ( case-insensitive )
    while [[ ! "${trimmed_check,,}" = "y" && ! "${trimmed_check,,}" = "n" ]]
    do
        print_and_log_message "${RED}[ERROR]${RESET} incorrectly typed command" >&2
        read -r check
        trimmed_check=$(trim_whitespace "$check")
    done
    echo "$trimmed_check"
}

# Exiting errors with exit 1 for env variables
env_error_code () {
    if [ -n "$TARGET_DIR" ]; then
        exit 1
    fi
}

# Main script exuctable loop
while [ "$exit_condition" = true ]
do
    trimmed_directory_path=""   # Reset for each outer iteration
    first_attempt=true # This flag helps display the error message ONLY after the first failed attempt

    while ! directory_validation "$trimmed_directory_path"
    do
        # Show error message only after the first attempt
        if [ "$first_attempt" = false ]; then
            print_and_log_message "${RED}[ERROR]${RESET} Directory '$trimmed_directory_path' doesn't exist."
            # Erorr code for env variable if set "exit 1"
            env_error_code
        fi

        trimmed_directory_path=$(directory_input)

        # Checks if user wants to quit/exit
        if [[ "${trimmed_directory_path,,}" = "quit" || "${trimmed_directory_path,,}" = "exit" ]]; then
            exit 0 # End the script
        fi
        first_attempt=false # After first invalid attempt, show error messages
    done
   
    # List the contents for a valid directory
    list_directory_contents "$trimmed_directory_path"

    # Ask user if they want to continue to check for another directory path or exit
    yes_no_response=$(validate_yes_no_input)
    
    # Accept both "n" and "N" as exit conditions
    if [[ "${yes_no_response,,}" = "n" ]]; then
        exit_condition=false
    fi
done