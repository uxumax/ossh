#!/bin/bash

# First argument should be the Hostname
if [[ -z "$1" ]]; then
  echo "Usage: $0 hostname [ssh_args...]"
  exit 1
fi

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

~/.ssh/before_established.sh $Hostname

# Establish SSH connection with LocalCommand option that will be called afer ssh connection established
ssh $Hostname -o PermitLocalCommand=yes -o LocalCommand="~/.ssh/after_established.sh $Hostname" "$@"

