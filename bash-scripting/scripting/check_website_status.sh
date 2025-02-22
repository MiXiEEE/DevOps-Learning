#!/bin/bash

LOGS="/home/mika/log-dir/web_status.log"

check_website_status() {
	website_name=$1
	full_webname="https://$website_name"

	response=$(curl -Is "$full_webname")

	status_code=$(echo "$response" | awk '/^HTTP/{print $2}')

	# if curl fails, logs error no response
	if [ -z "$status_code" ]; then
		status_code="ERROR: No response"
	fi

	timestamp=$(date "+%Y-%m-%d %H:%M:%S")

	# Log the output
	echo "[$timestamp] Checking: $full_webname" | tee -a "$LOGS"
	echo "[$timestamp] Status: $status_code" | tee -a "$LOGS"
	echo "----------------------------------------" | tee -a "$LOGS"
}

read -p "Input Website name to check its status like e.g example.com: " website_name

# checks website_name string is empty
if [ -z "$website_name" ]; then
	echo "input is empty"
	exit 1
fi

# trap is a built-in command that allows you to specify commands that should be executed like ctrl + c to exit
trap 'echo "Monitoring stopped."; exit 0' INT

while true; do
	check_website_status "$website_name"
	sleep 10
done
