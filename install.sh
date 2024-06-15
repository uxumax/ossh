#!/bin/bash

# Paths
LOCAL_BIN_DIR="/usr/local/bin"
OSSH_SCRIPTS_DIR="/home/$SUDO_USER/.ssh/scripts"
BASHRC="/home/$SUDO_USER/.bashrc"

# Ensure the script is run with sudo or root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit
fi

# Check if the directory exists
if [ ! -d "$OSSH_SCRIPTS_DIR" ]; then
  # Create the directory
  mkdir -p "$OSSH_SCRIPTS_DIR"
fi

# Copy bash script files
echo "Copying bash scripts..."
cp ./ossh.sh "$LOCAL_BIN_DIR/ossh"
cp ./scripts/ossh_completion.sh "$OSSH_SCRIPTS_DIR/.ossh_completion.sh"
cp ./scripts/before_established.sh "$OSSH_SCRIPTS_DIR/"
cp ./scripts/after_established.sh "$OSSH_SCRIPTS_DIR/"

# Activate ossh bash completion
echo "" >> $BASHRC
echo "# Activate bash completion for ossh" >> $BASHRC
echo "source $OSSH_SCRIPTS_DIR/.ossh_completion.sh" >> $BASHRC

# Make bash scripts executable and set user as owner
echo "Setup privileges..."
chmod +x "$LOCAL_BIN_DIR/ossh"
chmod +x "$OSSH_SCRIPTS_DIR/before_established.sh"
chmod +x "$OSSH_SCRIPTS_DIR/after_established.sh" 
chmod +x "$OSSH_SCRIPTS_DIR/.ossh_completion.sh" 
chown -R $SUDO_USER:$SUDO_USER "$OSSH_SCRIPTS_DIR"

echo "Installation complete."
echo "Please run this command to activate ossh bash completion"
echo ""
echo "source ~/.bashrc"
echo ""
