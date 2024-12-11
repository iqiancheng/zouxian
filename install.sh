#!/bin/bash

# Check if running with root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this script with sudo"
    exit 1
fi

# Get absolute path of script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define target directories and paths
TARGET_DIR="/Library/LaunchDaemons"
TARGET_SCRIPT="/usr/local/bin/zouxian.sh"
LOG_DIR="/var/log/zouxian"

# Create necessary directories
mkdir -p "$(dirname "${TARGET_SCRIPT}")"
mkdir -p "${LOG_DIR}"

# Copy zouxian.sh to target directory
cp "${SCRIPT_DIR}/zouxian.sh" "${TARGET_SCRIPT}"

# Update the path in plist file to use the standard location
sed -i '' "s|.*<string>.*zouxian.sh</string>|<string>${TARGET_SCRIPT}</string>|g" "${SCRIPT_DIR}/cat.me0w.zouxian.plist"

# Print paths for verification
echo "Script directory: ${SCRIPT_DIR}"
echo "Target script path: ${TARGET_SCRIPT}"
echo "Plist destination: ${TARGET_DIR}/cat.me0w.zouxian.plist"

# Copy plist file to LaunchDaemons
cp "${SCRIPT_DIR}/cat.me0w.zouxian.plist" "${TARGET_DIR}/"

# Set correct permissions
chown root:wheel "${TARGET_DIR}/cat.me0w.zouxian.plist"
chmod 644 "${TARGET_DIR}/cat.me0w.zouxian.plist"
chown root:wheel "${TARGET_SCRIPT}"
chmod 755 "${TARGET_SCRIPT}"
chown root:wheel "${LOG_DIR}"
chmod 755 "${LOG_DIR}"

# Verify permissions
if [ ! -x "${TARGET_SCRIPT}" ]; then
    echo "Error: Target script is not executable"
    exit 1
fi

# Unload existing service (if any)
launchctl unload "${TARGET_DIR}/cat.me0w.zouxian.plist" 2>/dev/null

# Load the service
if ! launchctl load "${TARGET_DIR}/cat.me0w.zouxian.plist"; then
    echo "Error: Failed to load service"
    exit 1
fi

echo "Installation completed! Service started."
echo "You can check the log files for running status:"
echo "Error log: ${LOG_DIR}/error.log"
echo "Output log: ${LOG_DIR}/output.log"

# Verify installation
echo "\nChecking service status:"
echo "1. LaunchDaemon list:"
launchctl list | grep cat.me0w.zouxian

echo "\n2. Service details:"
launchctl print system/cat.me0w.zouxian

echo "\n3. Plist syntax check:"
plutil -lint "${TARGET_DIR}/cat.me0w.zouxian.plist"

echo "\n4. Check permissions:"
ls -l "${TARGET_DIR}/cat.me0w.zouxian.plist"
ls -l "${TARGET_SCRIPT}"

# Final verification
if ! pgrep -f "zouxian.sh" > /dev/null; then
    echo "\nWarning: Service appears to be not running, check system logs for more information"
    echo "Use the following command to view system logs:"
    echo "sudo log show --predicate 'subsystem contains \"cat.me0w.zouxian\"' --last 1h"
fi 