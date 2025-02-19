#!/bin/bash

LOG_FILE="/home/mika/log-dir/ssh-logs.log"
FETCH_LOG="/var/log/auth.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi

# Clear the log file
> "$LOG_FILE"

# Extract failed ssh login attempts and count by IP
if grep -q "Failed password" "$FETCH_LOG"; then
    grep "Failed password" "$FETCH_LOG" | awk '
	{
		split($1, dateTime, "T");  # Split ISO format at "T"
		split(dateTime[2], timeParts, ".");  # Remove milliseconds
		split(dateTime[1], dateParts, "-");  # Split date into components

		# Format date to DD-MM-YYYY
		formattedDate = dateParts[3] "-" dateParts[2] "-" dateParts[1];

		# Format time to HH:MM:SS
		formattedTime = timeParts[1];

		# Increment count for the IP address
		ip = $(NF-3);  # Store IP in a variable for clarity
		ipCount[ip]++;  # Increment the count for this IP

		# Update the date and time to the most recent occurrence
		ipDate[ip] = formattedDate;
		ipTime[ip] = formattedTime;
	}
	END {
		# Loop through the ipCount array
		for (ip in ipCount) {
			print "IP:", ip, "Attempts:", ipCount[ip], "Most Recent Date:", ipDate[ip], "Time:", ipTime[ip];
		}
	}' >> "$LOG_FILE"
else
	echo "No failed login attempts found." >> "$LOG_FILE"
fi
