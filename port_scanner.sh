#!/bin/bash

# Port Scan Reporter — port_scanner.sh
# Objective: Create a simple security tool to detect open ports on a target host.
#
# What the Script Does:
# - Accepts one command-line argument (target host)
# - Validates input presence
# - Runs network scan using `nmap`
# - Filters output to show only open ports
# - Prints results to terminal
#
# Key Commands Used:
# - nmap
# - grep
# - awk
# - exit codes
#
# Flow Diagram:
# 🏁 Start
#    ↓
#  🌐 Validate Input
#    ↓
#  🔎 Run nmap Scan
#    ↓
#  📋 Filter Open Ports
#    ↓
#  🖨️ Print Results
#    ↓
# 🏁 End
#
# Example Usage:
#   ./port_scanner.sh localhost
#
# Why This Matters:
# Used in: security audits, vulnerability scanning, network troubleshooting, incident response
#
# Requirements:
# - `nmap` must be installed and available in PATH
#
# Tip:
# - macOS: `brew install nmap`
# - Debian/Ubuntu: `sudo apt install nmap`
#
# ----------------------------
# Begin script
# ----------------------------

# Validate required argument (target host)
if [ -z "$1" ]; then  # If no first positional argument provided
    echo "Usage: $0 <target_host>"  # Show usage help
    exit 2  # Exit with status 2 (incorrect usage)
fi

TARGET_HOST="$1"  # Store the target host from the first argument

echo "🔎 Scanning ${TARGET_HOST} for open ports..."  # Inform the user the scan is starting

# Run nmap to scan for open ports and filter the output.
# -p-     : scan all ports (1-65535)
# --open  : show only ports in the open state
# -Pn     : skip host discovery (treat host as up)
# -T4     : faster timing template (aggressive)
# -oG -   : output in grepable format to stdout
# We then grep for 'open' lines (e.g., '22/tcp open ssh')
nmap -p- --open -Pn -T4 -oG - "${TARGET_HOST}" | grep "open"  # Execute scan and show open ports

# End of script
exit 0  # Exit successfully
