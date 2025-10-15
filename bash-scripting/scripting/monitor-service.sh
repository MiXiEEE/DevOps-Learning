#!/bin/bash

SERVICE="apache2"

if pgrep -x "$SERVICE" > /dev/null; then
    echo "$SERVICE is running."
else
    echo "$SERVICE is not running. Attempting to start it..."
    
    if sudo systemctl start "$SERVICE"; then
        echo "$SERVICE started successfully."
    else
        echo "Failed to start $SERVICE. Check permissions."
        exit 1  # Exit with error code
    fi
fi