#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

SCRIPT_DIR="$(dirname "$0")"
LOGFILE="$SCRIPT_DIR/../bash-logs/directory_check.log"
mkdir -p "$(dirname "$LOGFILE")" # Always ensure log directory exists

print_and_log_message() {
    local message="$1"
    echo -e "$message"
    # Remove ANSI color codes for clean log
    local clean_message
    clean_message=$(echo -e "$message" | sed 's/\x1b\[[0-9;]*m//g')
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $clean_message" >> "$LOGFILE"
}

trim_whitespace() {
    trimmed_var=$(echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    echo "$trimmed_var"
}

list_directory_contents() {
    print_and_log_message "${GREEN}[SUCCESS]${RESET} Successfully printed contents!"
    echo "list $1 contents:"
    if ! ls "$1"; then
        print_and_log_message "${YELLOW}[WARNING]${RESET} Unable to list directory, permission not fulfilled" 
    fi
}

directory_validation() {
    if [[ -d "$1" && -n "$1" ]]; then
        return 0
    else
        return 1
    fi
}

# --- CI MODE EARLY EXIT + LOG ----
if [ ! -z "$TARGET_DIR" ]; then
    trimmed_directory_path=$(trim_whitespace "$TARGET_DIR")
    if ! directory_validation "$trimmed_directory_path"; then
        print_and_log_message "${RED}[ERROR]${RESET} Directory '$trimmed_directory_path' doesn't exist."
        exit 1
    fi
    # If valid, list contents and exit (no interactive loop)
    list_directory_contents "$trimmed_directory_path"
    exit 0
fi
#-----------------------------------
# MAIN
exit_condition=true
while [ "$exit_condition" = true ]
do
    trimmed_directory_path=""
    first_attempt=true

    while ! directory_validation "$trimmed_directory_path"
    do
        if [ "$first_attempt" = false ]; then
            print_and_log_message "${RED}[ERROR]${RESET} Directory '$trimmed_directory_path' doesn't exist."
        fi

        trimmed_directory_path=$(directory_input)

        if [[ "${trimmed_directory_path,,}" = "quit" || "${trimmed_directory_path,,}" = "exit" ]]; then
            exit 0
        fi
        first_attempt=false
    done

    list_directory_contents "$trimmed_directory_path"

    yes_no_response=$(validate_yes_no_input)
    if [[ "${yes_no_response,,}" = "n" ]]; then
        exit_condition=false
    fi
done
# MAIN-END
# --- SUPPORTING FUNCTIONS FOR INTERACTIVE MODE ---
directory_input() {
    if [ -z "$TARGET_DIR" ]; then
        local directory_path
        echo -n -e "${CYAN}Input directory path or to exit (quit, exit), you would like to check: ${RESET}" >&2
        read -r directory_path
    else
        directory_path=$TARGET_DIR
    fi
    trimmed_directory_path=$(trim_whitespace "$directory_path")
    echo "$trimmed_directory_path"
}

validate_yes_no_input() {
    if [ ! -z "$TARGET_DIR" ]; then
        check="N"
    else
        echo -e "${CYAN}Input if you wanna search for another directory y/n${RESET}" >&2
        read -r check
    fi
    trimmed_check=$(trim_whitespace "$check")
    while [[ ! "${trimmed_check,,}" = "y" && ! "${trimmed_check,,}" = "n" ]]
    do
        print_and_log_message "${RED}[ERROR]${RESET} incorrectly typed command" >&2
        read -r check
        trimmed_check=$(trim_whitespace "$check")
    done
    echo "$trimmed_check"
}
