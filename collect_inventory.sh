1. System Inventory Collector — collect_inventory.sh
Objective

Automate collection of core system health data and store it in a structured file for monitoring and reporting.

What the Script Does
Captures system hostname
Retrieves human-readable uptime
Extracts total and used memory in MB
Checks disk usage of root filesystem
Gets primary IP address
Writes output to /tmp/inventory_<hostname>.txt
Overwrites file on every run
Key Commands Used
hostname
uptime -p
free -m
df -h /
hostname -I
Output redirection >
Why This Matters

Used in:

system monitoring
health checks
automation pipelines
server inventory reporting
