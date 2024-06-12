#!/bin/bash

# Paths
LOCAL_BIN_DIR="/usr/local/bin"
SSH_DIR="/home/$SUDO_USER/.ssh"


# Ensure the script is run with sudo or root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit
fi

# Check if the directory exists
if [ ! -d "$SSH_DIR" ]; then
  # Create the directory
  mkdir -p "$SSH_DIR"
fi

# Copy bash script files
echo "Copying bash scripts..."
cp ./bin/ossh.sh "$LOCAL_BIN_DIR/ossh"
cp ./ssh/before_established.sh "$SSH_DIR/"
cp ./ssh/after_established.sh "$SSH_DIR/"

# Make bash scripts executable
echo "Set +x permission to scripts"
chmod +x "$LOCAL_BIN_DIR/ossh"
chmod +x "$SSH_DIR/before_established.sh"
chmod +x "$SSH_DIR/after_established.sh" 
chown $SUDO_USER:$SUDO_USER "$SSH_DIR/before_established.sh"
chown $SUDO_USER:$SUDO_USER "$SSH_DIR/after_established.sh" 

echo "Installation complete."
