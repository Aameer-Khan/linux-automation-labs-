#!/bin/bash

# Temporary File Cleanup Tool — cleanup_temp_files.sh
# Objective: Automatically remove large, inactive temporary files to prevent disk space issues.
#
# What the Script Does:
# - Deletes files larger than 50MB and not accessed for 120 minutes
# - Logs deleted file paths to a central log
# - Sets ownership and permissions on the log
#
# Key Commands Used:
# - find
# - chown
# - chmod
# - touch
#
# Flow Diagram:
# 🏁 Start
#    ↓
#  📁 Validate Target Directory
#    ↓
#  🔎 Find Old & Large Files
#    ↓
#  🗑️ Delete & Log Files
#    ↓
#  🔐 Set Log Ownership & Permissions
#    ↓
# 🏁 End
#
# Example Usage:
#   ./cleanup_temp_files.sh /var/tmp
#
# Requirements:
# - Run as a user that can delete files in the target directory
# - `find` available in PATH
#
# ----------------------------
# Begin script
# ----------------------------

# Configuration: path to log file where deleted files will be recorded
LOG_FILE="/home/user/deleted_files.log"  # 📁 Change if you want a different log location

# Check input: require a target directory argument
if [ -z "$1" ]; then  # If no argument provided
    echo "Usage: $0 <target_directory>"  # Show usage
    exit 2  # Exit with error code for incorrect usage
fi

TARGET_DIR="$1"  # 📂 Directory to scan for large, inactive files

# Validate target directory exists and is a directory
if [ ! -d "$TARGET_DIR" ]; then  # If target is not a directory
    echo "Error: target directory '$TARGET_DIR' does not exist or is not a directory." >&2
    exit 3
fi

# Ensure the log file exists, then set ownership and permissions
touch "$LOG_FILE"  # 📝 Create log file if it doesn't exist
chown user "$LOG_FILE"  # 👤 Set ownership to 'user' (adjust as needed)
chmod 644 "$LOG_FILE"  # 🔐 Set file permissions to rw-r--r--

echo "Cleaning files in ${TARGET_DIR} — logging to ${LOG_FILE}"  # Inform the user

# Find and delete files matching criteria:
# - type f      : regular files only
# - size +50M   : larger than 50 megabytes
# - amin +120   : not accessed in the last 120 minutes
# We print each deleted file to the log and then delete it. Redirect errors to the same log.
find "$TARGET_DIR" \
    -type f \
    -size +50M \
    -amin +120 \
    -print -delete >> "$LOG_FILE" 2>&1  # 🗒️ Log deleted file paths and any errors

echo "Cleanup complete."  # Final status message

exit 0

