#!/bin/bash

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

# Flow Diagram:
# 🏁 Start
#     ↓
#   🖥️ Collect Hostname
#     ↓
#   ⏰ Collect Uptime
#     ↓
#   🧠 Collect Memory Info
#     ↓
#   💾 Collect Disk Usage
#     ↓
#   🌐 Collect Primary IP
#     ↓
#   📝 Write Data to File
#     ↓
# 🏁 End

# Collect system inventory data
HOSTNAME=$(hostname)  # 🖥️ Get the system hostname
UPTIME=$(uptime -p)  # ⏰ Get human-readable uptime information
TOTAL_MEM=$(free -m | awk '/^Mem:/ {print $2}')  # 🧠 Extract total memory in MB
USED_MEM=$(free -m | awk '/^Mem:/ {print $3}')  # 🧠 Extract used memory in MB
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')  # 💾 Get disk usage percentage of root filesystem
PRIMARY_IP=$(hostname -I | awk '{print $1}')  # 🌐 Get the primary IP address

# Create output file
OUTPUT_FILE="/tmp/inventory_${HOSTNAME}.txt"  # 📁 Define the output file path with hostname

# Write data to file
{  # 📝 Start writing collected data to the output file
    echo "🖥️ Hostname: ${HOSTNAME}"  # 📝 Output the hostname with emoji
    echo "⏰ Uptime: ${UPTIME}"  # 📝 Output the uptime with emoji
    echo "🧠 Total Memory (MB): ${TOTAL_MEM}"  # 📝 Output total memory with emoji
    echo "🧠 Used Memory (MB): ${USED_MEM}"  # 📝 Output used memory with emoji
    echo "💾 Disk Usage of Root Filesystem: ${DISK_USAGE}"  # 📝 Output disk usage with emoji
    echo "🌐 Primary IP Address: ${PRIMARY_IP}"  # 📝 Output primary IP with emoji
} > "${OUTPUT_FILE}"  # 📝 Redirect output to the file, overwriting if exists

echo "Inventory collected and saved to ${OUTPUT_FILE}"
