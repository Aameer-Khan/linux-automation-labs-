1. #!/bin/bash

# System Inventory Collector — collect_inventory.sh
# Objective
#
# Automate collection of core system health data and store it in a structured file for monitoring and reporting.
#
# What the Script Does
# Captures system hostname
# Retrieves human-readable uptime
# Extracts total and used memory in MB
# Checks disk usage of root filesystem
# Gets primary IP address
# Writes output to /tmp/inventory_<hostname>.txt
# Overwrites file on every run
#
# Key Commands Used
# hostname
# uptime -p
# free -m
# df -h /
# hostname -I
# Output redirection >
#
# Why This Matters
#
# Used in:
# system monitoring
# health checks
# automation pipelines
# server inventory reporting

# Collect system inventory data
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)

TOTAL_MEM=$(free -m | awk '/^Mem:/ {print $2}')
USED_MEM=$(free -m | awk '/^Mem:/ {print $3}')

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
PRIMARY_IP=$(hostname -I | awk '{print $1}')

# Create output file
OUTPUT_FILE="/tmp/inventory_${HOSTNAME}.txt"

# Write data to file
{
    echo "Hostname: ${HOSTNAME}"
    echo "Uptime: ${UPTIME}"
    echo "Total Memory (MB): ${TOTAL_MEM}"
    echo "Used Memory (MB): ${USED_MEM}"
    echo "Disk Usage of Root Filesystem: ${DISK_USAGE}"
    echo "Primary IP Address: ${PRIMARY_IP}"
} > "${OUTPUT_FILE}"

echo "Inventory collected and saved to ${OUTPUT_FILE}"
