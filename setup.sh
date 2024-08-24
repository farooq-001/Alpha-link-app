#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Define the path
TARGET_PATH="/opt/snb-tech"
APP_PATH="$TARGET_PATH/Alpha-link-app"

# Create the directory if it does not exist
if [ ! -d "$TARGET_PATH" ]; then
    mkdir -p "$TARGET_PATH"
fi

# Unzip the Alpha-link-app.zip to the target path
unzip Alpha-link-app.zip -d "$TARGET_PATH"

# Navigate to the application directory
cd "$APP_PATH" || { echo "Application directory not found"; exit 1; }

# Set up Python virtual environment
python3 -m venv venu
source venu/bin/activate

# Install necessary Python packages
pip install flask gunicorn requests

# Copy the service file to the systemd directory
cp -r "$APP_PATH/alpha-link.service" /etc/systemd/system/

# Start the service
systemctl daemon-reload
systemctl start alpha-link.service

# Optional: enable the service to start on boot
systemctl enable alpha-link.service

echo "Setup complete."
