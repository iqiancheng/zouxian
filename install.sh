#!/bin/bash

# Check if running with root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Please run this script with sudo"
    exit 1
fi

# Get absolute path of script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define target directory and script path
TARGET_DIR="/Library/LaunchDaemons"
TARGET_SCRIPT="${TARGET_DIR}/zouxian.sh"

# Copy zouxian.sh to target directory
cp "${SCRIPT_DIR}/zouxian.sh" "${TARGET_SCRIPT}"

# Update the path in plist file
sed -i '' "s|${SCRIPT_DIR}/zouxian.sh|${TARGET_SCRIPT}|g" "${SCRIPT_DIR}/cat.me0w.zouxian.plist"
sed -i '' "s|/path/to/zouxian.sh|${TARGET_SCRIPT}|g" "${SCRIPT_DIR}/cat.me0w.zouxian.plist"

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

# Unload existing service (if any)
launchctl unload "${TARGET_DIR}/cat.me0w.zouxian.plist" 2>/dev/null

# Load the service
launchctl load "${TARGET_DIR}/cat.me0w.zouxian.plist"

echo "Installation completed! Service started."
echo "You can check the log files for running status:"
echo "Error log: /tmp/cat.me0w.zouxian.err"
echo "Output log: /tmp/cat.me0w.zouxian.out"

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