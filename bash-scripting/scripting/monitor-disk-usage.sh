#!/bin/bash
# Enhanced disk usage monitor with multiple mount points
CYAN="\e[36m"
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
RESET="\e[0m"

LOG_DIR="/home/mika/log-dir"
THRESHOLD_WARNING=10
THRESHOLD_CRITICAL=5
MOUNT_POINTS=("/" "/mnt/c" "/home")  # Add your mount points here

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

monitor_mount_point() {
    local mount_point="$1"
    
    # Get disk usage
    if ! disk_info=$(df -Ph "$mount_point" 2>/dev/null); then
        echo -e "${RED}Could not retrieve disk info for $mount_point${RESET}"
        return 1
    fi

    # Extract used space percentage
    used_space=$(echo "$disk_info" | awk 'NR==2 {print $5}' | tr -d '%')
    available_space=$((100 - used_space))

    # Determine color and severity
    if [ "$available_space" -le "$THRESHOLD_CRITICAL" ]; then
        color="$RED"
        severity="CRITICAL"
    elif [ "$available_space" -le "$THRESHOLD_WARNING" ]; then
        color="$YELLOW"
        severity="WARNING"
    else
        color="$GREEN"
        severity="OK"
    fi

    # Display information
    echo -e "\n${CYAN}=== Mount Point: $mount_point ===${RESET}"
    echo "$disk_info"
    echo -e "Used Space: ${used_space}%"
    echo -e "${color}Available Space: ${available_space}% - $severity${RESET}"

    # Log and alert if below threshold
    if [ "$available_space" -le "$THRESHOLD_WARNING" ]; then
        log_message="ALERT: $mount_point - ${available_space}% available - $(date '+%Y-%m-%d %H:%M:%S')"
        echo "$log_message" >> "$LOG_DIR/disk-space.log"
        
        echo -e "${color}⚠️  Warning: Space below ${THRESHOLD_WARNING}%${RESET}"
    fi
}

# Main monitoring loop
echo -e "${CYAN}=== Disk Space Monitor ===${RESET}"
echo -e "Thresholds: ${GREEN}OK${RESET} > ${YELLOW}WARNING${RESET} (${THRESHOLD_WARNING}%) > ${RED}CRITICAL${RESET} (${THRESHOLD_CRITICAL}%)"

for mount_point in "${MOUNT_POINTS[@]}"; do
    monitor_mount_point "$mount_point"
done

echo -e "\n${CYAN}Log file: $LOG_DIR/disk-space.log${RESET}"