#!/bin/bash

# Define the log file path
log_file="./bash-scripting/bash-logs/dummy_logs.log"

# Check if the log file exists
if [ ! -f "$log_file" ]; then
    echo "Log file not found!"
    exit 1
fi

# Print out CRITICAL, ERROR and WARNING logs
echo "----- CRITICAL -----"
grep "CRITICAL" $log_file
echo "----- ERROR -----"
grep "ERROR" $log_file
echo "----- WARNING -----"
grep "WARNING" $log_file
