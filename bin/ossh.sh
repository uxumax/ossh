#!/bin/bash

BEFORE_ESTABLISHED_SCRIPT="/home/$USER/.ssh/before_established.sh"
AFTER_ESTABLISHED_SCRIPT="/home/$USER/.ssh/after_established.sh"

# First argument should be the Hostname
if [[ -z "$1" ]]; then
  echo "Usage: $0 hostname [ssh_args...]"
  exit 1
fi

# Function to check if hostname exists in ~/.ssh/config
hostname_exists() {
  local host=$1
  awk -v host="$host" '
    $1 == "Host" && $2 == host { print "exists"; exit }
  ' ~/.ssh/config
}

# Function fetch ~/.ssh/config data by hostname (e.g., User, IdentityFile)
get_ssh_option() {
  local host=$1
  local option=$2
  awk -v host="$host" -v option="$option" '
    $1 == "Host" { in_host_block = ($2 == host); next }
    in_host_block && $1 == option { print $2 }
  ' ~/.ssh/config
}

is_ainb() {
  a=$1
  b=($2)
  for b_item in "${b[@]}"; do
    if [[ "$a" == "$b_item" ]]; then
      echo 1
      return
    fi
  done
  echo 0
}

is_hostname() {
  hostnames=$1
  echo $(is_ainb "$Hostname" "$hostnames")
  return
}

# Make functions accessable to ossh scripts
export -f get_ssh_option
export -f is_ainb
export -f is_hostname

Hostname=$1
shift

# Check if Hostname exists in ~/.ssh/config
if [[ -z "$(hostname_exists "$Hostname")" ]]; then
  echo "Error: Hostname '$Hostname' not found in ~/.ssh/config"
  exit 1
fi

$BEFORE_ESTABLISHED_SCRIPT "$Hostname"

# Establish SSH connection with LocalCommand option that will be called afer ssh connection established
ssh $Hostname -o PermitLocalCommand=yes -o LocalCommand="$AFTER_ESTABLISHED_SCRIPT $Hostname" "$@"

