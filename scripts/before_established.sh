#!/bin/bash

# Set ssh connection hostname
Hostname=$1

# Parse .ssh/config Hostname params
User=$(get_ssh_option "$Hostname" "User")
Port=$(get_ssh_option "$Hostname" "Port")
IdentityFile=$(get_ssh_option "$Hostname" "IdentityFile")
# etc... You can get and set here any .ssh/config Hostname options with this way

echo "Do some staff before ssh connection established..."

# Your code here (e.g., open a port on another server)
#
# You can specify code for some $Hostname using built-in bash function is_hostname(). Ex:
# if [ $(is_hostname "hostname1 hostname2") == 1 ]; then
#   echo "Have to open port on public_vps" before ssh connection established
#   ssh public_vps "echo $Port > /tmp/ports_to_open.list"
#   sleep 1.1
# fi

echo "Done!"
