#!/bin/bash

SERVICE="apache2"

if ! pgrep -x "$SERVICE" > /dev/null; then
	 echo "$SERVICE is not running. Attempting to start it..."
	sudo systemctl start "$SERVICE"
	# checks the exit status of the last executed command
	if [ $? -eq 0 ]; then
		echo "$SERVICE started successfully."
	else
		echo "Failed to start $SERVICE. Check permissions."
	fi
else
	echo "$SERVICE is running."
fi
