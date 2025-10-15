#!/bin/bash

LOG_FILE="/home/mika/log-dir/ssh-logs.log"
FETCH_LOG="/var/log/auth.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi

# Clear the log file
true > "$LOG_FILE"

# Extract failed ssh login attempts and count by IP
if grep -q "Failed password" "$FETCH_LOG"; then
    grep "Failed password" "$FETCH_LOG" | awk '
    {
        # Extract date and time (fields 1-3 in auth.log)
        month = $1
        day = $2
        time = $3
        
        # Find the IP address - it'\''s after "from" in the message
        ip = "unknown"
        for (i = 1; i <= NF; i++) {
            if ($i == "from" && $(i+1) ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
                ip = $(i+1)
                break
            }
        }
        
        # Increment count for the IP address
        ipCount[ip]++
        
        # Update the date and time to the most recent occurrence
        ipDate[ip] = day "-" month
        ipTime[ip] = time
    }
    END {
        # Loop through the ipCount array
        for (ip in ipCount) {
            if (ip != "unknown") {
                print "IP:", ip, "Attempts:", ipCount[ip], "Most Recent Date:", ipDate[ip], "Time:", ipTime[ip]
            }
        }
    }' >> "$LOG_FILE"
else
    echo "No failed login attempts found." >> "$LOG_FILE"
fi