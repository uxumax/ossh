#!/bin/bash

# Paths
LOCAL_BIN_DIR="/usr/local/bin"
SSH_DIR="/home/$SUDO_USER/.ssh"
BASHRC="/home/$SUDO_USER/.bashrc"

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
cp ./bin/ossh_completion.sh "$SSH_DIR/.ossh_completion.sh"
cp ./ssh/before_established.sh "$SSH_DIR/"
cp ./ssh/after_established.sh "$SSH_DIR/"

# Activate ossh bash completion
echo "" >> $BASHRC
echo "# Activate bash completion for ossh" >> $BASHRC
echo "source $SSH_DIR/.ossh_completion.sh" >> $BASHRC

# Make bash scripts executable and set user as owner
echo "Setup privileges..."
chmod +x "$LOCAL_BIN_DIR/ossh"
chmod +x "$SSH_DIR/before_established.sh"
chmod +x "$SSH_DIR/after_established.sh" 
chmod +x "$SSH_DIR/.ossh_completion.sh" 
chown $SUDO_USER:$SUDO_USER "$SSH_DIR/before_established.sh"
chown $SUDO_USER:$SUDO_USER "$SSH_DIR/after_established.sh" 
chown $SUDO_USER:$SUDO_USER "$SSH_DIR/.ossh_completion.sh" 

echo "Installation complete."
echo "Please run this command to activate ossh bash completion"
echo ""
echo "source ~/.bashrc"
echo ""
