#!/bin/bash

# Set ssh connection hostname
Hostname=$1

# Parse .ssh/config Hostname params
User=$(get_ssh_option "$Hostname" "User")
Port=$(get_ssh_option "$Hostname" "Port")
IdentityFile=$(get_ssh_option "$Hostname" "IdentityFile")
# etc... You can get and set here any .ssh/config Hostname options with this way

echo "Do some staff before ssh connection established..."

# Your code here
# You can use all ./ssh/config variables of Hostname here
#
# For example open port on another server if you use ssh backtunnels for connect to your VMs and don't want keep ports open all the time
# Just call here your command that open port on server that you use for backtunnels:
#
# path/to/open_port_on_tunnel_vps.sh $Port
#

echo "Done!"
