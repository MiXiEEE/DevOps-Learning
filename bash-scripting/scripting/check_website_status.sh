#!/bin/bash

LOGS="/home/mika/log-dir/web_status.log"

check_website_status() {
	full_webname="https://$website_name"

	response=$(curl -Is "$full_webname")

	# gets curls status code e.g 200
	status_code=$(echo "$response" | awk '/^HTTP/{print $2}')

	# if curl fails, logs error no response
	if [ -z "$status_code" ]; then
		status_code="ERROR: No response"
	fi

	timestamp=$(date "+%Y-%m-%d %H:%M:%S")
	echo "----------------------------------------"
	# verifies if port 80 (HTTP) or 443 (HTTPS) is open
	for port in 80 443; do
		port_status=$(nc -zv "$website_name" "$port" 2>&1)
		echo "[$timestamp] Port $port: $port_status" | tee -a "$LOGS"
	done

	# Log the output
	echo "[$timestamp] Checking: $full_webname" | tee -a "$LOGS"
	echo "[$timestamp] Status: $status_code" | tee -a "$LOGS"
	echo "----------------------------------------" | tee -a "$LOGS"
}

if [ $# -eq 0 ]; then
	read -r -a website_name -p "Input Website name to check its status like e.g (example.com or example.com wikipedia.org): "
	set -- "${website_name[@]}" # 'set --' will re-assign the script's positional arguments ($1, $2, ...) to the array elements.
fi

if [ $# -eq 0 ]; then
	echo "input is empty"
	exit 1
fi


# trap is a built-in command that allows you to specify commands that should be executed like ctrl + c to exit
trap 'echo "Monitoring stopped."; exit 0' INT

while true; do
	for website_name in "$@"; do
		check_website_status "$website_name"
	done
	echo "Ctrl + C to Close out and exit from website check"
	sleep 10
done