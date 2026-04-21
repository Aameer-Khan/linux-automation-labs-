#!/bin/bash

# Linux User and File System Audit Tool — sys_audit.sh
# Objective: Perform security and compliance checks on filesystem ownership and sudo privileges.
#
# What the Script Does:
# - Detects orphaned files (files without valid owners) in an audit zone
# - Audits sudo privileges for regular users (UID ≥ 1000)
# - Produces a structured report at the configured report file
#
# Key Commands Used:
# - find -nouser
# - awk (parse /etc/passwd)
# - grep (scan sudoers)
#
# Flow Diagram:
# 🏁 Start
#    ↓
#  🔎 Orphaned File Detection
#    ↓
#  🔐 Sudo Privilege Audit
#    ↓
#  📝 Write Structured Report
#    ↓
# 🏁 End
#
# Example Usage:
#   sudo ./sys_audit.sh
#
# Requirements:
# - Read access to /etc/passwd, /etc/sudoers and /etc/sudoers.d/
# - Read access to the audit zone directory
#
# ----------------------------
# Begin script
# ----------------------------

REPORT_FILE="/home/user/audit_report.txt"  # 📁 Output file for the audit report
AUDIT_ZONE="/home/user/audit_zone"  # 📂 Directory to scan for orphaned files

# Start fresh: clear or create the report file
: > "$REPORT_FILE"  # Truncate (or create) the report file

echo "[ORPHANED FILES]" >> "$REPORT_FILE"  # Section header for orphaned files

# Check audit zone exists before running find
if [ ! -d "$AUDIT_ZONE" ]; then
    echo "Audit zone directory not found: ${AUDIT_ZONE}" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
else
    # Find files under AUDIT_ZONE that have no valid owner
    ORPHANED_FILES=$(find "$AUDIT_ZONE" -xdev -nouser 2>/dev/null)

    if [ -z "$ORPHANED_FILES" ]; then
        echo "NONE" >> "$REPORT_FILE"
    else
        echo "$ORPHANED_FILES" >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"
fi

echo "[SUDO AUDIT]" >> "$REPORT_FILE"  # Section header for sudo audit

# Get list of regular users (UID >= 1000), excluding 'nobody'
USERS=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | sort)

if [ -z "$USERS" ]; then
    echo "No regular users found." >> "$REPORT_FILE"
else
    # For each user, check presence in sudoers or sudoers.d entries
    for USER in $USERS; do
        # Grep for whole-word matches of the username in sudoers files
        if grep -qE "(^|\s)${USER}(\b|:)" /etc/sudoers /etc/sudoers.d/* 2>/dev/null; then
            echo "$USER  SUDO:YES" >> "$REPORT_FILE"
        else
            echo "$USER  SUDO:NO" >> "$REPORT_FILE"
        fi
    done
fi

echo "" >> "$REPORT_FILE"
echo "Audit report generated at ${REPORT_FILE}"  # Inform the user where the report is located

exit 0

