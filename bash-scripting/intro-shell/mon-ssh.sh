#!/bin/bash

LOG_FILE="/home/mika/log-dir/ssh-logs.log"
FETCH_LOG="/var/log/auth.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
	touch "$LOG_FILE"
fi


# Extract failed ssh login attempts and count by IP
 > "$LOG_FILE"
grep "Failed password" "$FETCH_LOG" | awk '{
    split($1, dateTime, "T");	# Split ISO format at "T"
    split(dateTime[2], timeParts, ".");	# Remove milliseconds by splitting at "."
    split(dateTime[1], dateParts, "-");	# Split date into components
    # Format date to DD-MM-YYYY
    formattedDate = dateParts[3] "-" dateParts[2] "-" dateParts[1];
    print "IP:", $(NF-3), "Date:", formattedDate, "Time:", timeParts[1];# Print formatted date & time
}' >> "$LOG_FILE"
