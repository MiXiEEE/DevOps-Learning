#!/bin/bash
# Write a Bash script that:
# Searches a given directory for log files (e.g., files ending in .log)
# Compresses any logs older than 7 days into a timestamped archive (tar.gz or similar)
# Moves those archived files into a subfolder called archive
# Prints a summary of what was archived

LOG_DIR="/home/mika/log-dir"
ARCHIVE_DIR="/home/mika/archived_logs"

# Checks if string is not empty (-n) AND checks if directory exists (-d)
if [[ -n "$LOG_DIR" && -d "$LOG_DIR" ]]; then
    archive="$(date '+%Y-%m-%d')_logs.tar.gz"
    
    # Read file list into array safely (handles spaces and special chars)
    mapfile -t file_array < <(find "$LOG_DIR" -name "*.log" -mtime +7)
    
    if (( ${#file_array[@]} )); then
        # Create archive with all files
        tar -czvf "$archive" "${file_array[@]}"
        
        # Ensure archive directory exists
        if [ ! -d "$ARCHIVE_DIR" ]; then
            echo "Directory not found, creating new directory in ${ARCHIVE_DIR}"
            mkdir -p "$ARCHIVE_DIR"
        fi
        
        # Move archive into directory
        mv "$archive" "$ARCHIVE_DIR"
        
        # Summary output
        echo "Created archive: $archive"
        echo "Archived ${#file_array[@]} files from $LOG_DIR"
        echo "Archived detailed summary:"
        tar -tvf "$ARCHIVE_DIR/$archive"
    else
        echo "No log files older than 7 days found in $LOG_DIR"
    fi 
else
    echo "[ERROR]: Provided directory doesn't exist or path is invalid"
fi