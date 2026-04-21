#!/bin/bash

# System Update Automation — update-system.sh
# Objective: Automate system updates, package installation, logging, and reboot detection.
#
# What the Script Does:
# - Updates package index
# - Upgrades installed packages
# - Installs required packages (curl, tree)
# - Logs update activity
# - Detects if a reboot is required
#
# Key Commands Used:
# - apt update
# - apt upgrade
# - apt install
# - log redirection >>
#
# Flow Diagram:
# 🏁 Start
#    ↓
#  🔐 Check privileges
#    ↓
#  📦 Update package index
#    ↓
#  ⬆️ Upgrade packages
#    ↓
#  📥 Install extras
#    ↓
#  ⚠️ Detect reboot requirement
#    ↓
# 🏁 End
#
# Example Usage:
#   sudo ./update-system.sh
#
# Requirements:
# - Must run with root privileges (sudo)
# - `apt` must be available (Debian/Ubuntu)
#
# ----------------------------
# Begin script
# ----------------------------

LOG_FILE="/var/log/system_update.log"  # 📁 Log file for update activities

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then  # Check UID
    echo "This script must be run as root. Try: sudo $0" >&2
    exit 1
fi

echo "🔄 Starting system update at $(date)" >> "$LOG_FILE"  # Log the start time

# Update package index
echo "📦 Updating package index..." >> "$LOG_FILE"
apt update >> "$LOG_FILE" 2>&1  # Update the package lists and log output

# Upgrade installed packages
echo "⬆️ Upgrading installed packages..." >> "$LOG_FILE"
apt upgrade -y >> "$LOG_FILE" 2>&1  # Perform non-interactive upgrade, logging output

# Install required packages
echo "📥 Installing required packages (curl, tree)..." >> "$LOG_FILE"
apt install -y curl tree >> "$LOG_FILE" 2>&1  # Install extras and log

# Check for reboot requirement by presence of the reboot-required file
if [ -f /var/run/reboot-required ]; then  # File indicates reboot is required
    echo "⚠️ Reboot required after update. Please reboot the system." >> "$LOG_FILE"
else
    echo "✅ System update completed successfully. No reboot required." >> "$LOG_FILE"
fi

echo "Update finished at $(date)" >> "$LOG_FILE"  # Log completion time

exit 0