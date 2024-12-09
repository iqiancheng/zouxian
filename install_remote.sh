#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 sudo 运行此脚本"
    echo "正确用法: sudo curl -fsSL https://raw.githubusercontent.com/iqiancheng/zouxian/HEAD/install_remote.sh | bash"
    exit 1
fi

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Define GitHub repository information
REPO_URL="https://raw.githubusercontent.com/iqiancheng/zouxian/HEAD"

# Download required files
echo "正在下载所需文件..."
curl -fsSL "${REPO_URL}/zouxian.sh" -o "${TMP_DIR}/zouxian.sh" || {
    echo "下载 zouxian.sh 失败"
    exit 1
}
curl -fsSL "${REPO_URL}/cat.me0w.zouxian.plist" -o "${TMP_DIR}/cat.me0w.zouxian.plist" || {
    echo "下载 cat.me0w.zouxian.plist 失败"
    exit 1
}

# Rest of the installation script remains the same, but use TMP_DIR instead of SCRIPT_DIR
TARGET_DIR="/Library/LaunchDaemons"
TARGET_SCRIPT="${TARGET_DIR}/zouxian.sh"

# Copy zouxian.sh to target directory
cp "${TMP_DIR}/zouxian.sh" "${TARGET_SCRIPT}"

# Update the path in plist file
sed -i '' "s|/path/to/zouxian.sh|${TARGET_SCRIPT}|g" "${TMP_DIR}/cat.me0w.zouxian.plist"

# Copy plist file to LaunchDaemons
cp "${TMP_DIR}/cat.me0w.zouxian.plist" "${TARGET_DIR}/"

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