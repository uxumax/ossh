# SSH Wrapper with Pre/Post Connection Scripts

This project provides a simple SSH wrapper that allows you to run custom scripts before and after an SSH connection is established.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Scripts](#scripts)
  - [Pre Connection Script](#pre-connection-script)
  - [Post Connection Script](#post-connection-script)
- [Contributing](#contributing)

## Installation

To install the SSH wrapper, run the provided `install.sh` script with root or sudo privileges:

```bash
sudo ./install.sh
```

This script will:
1. Copy the wrapper script to `/usr/local/bin` as `ossh`.
2. Copy the pre and post connection scripts to the `~/.ssh/scripts` directory.
3. Set the necessary execution permissions for the scripts.

## Usage

To use the SSH wrapper, simply call `ossh` followed by the hostname and any additional `ssh` arguments:

```bash
ossh <hostname> [ssh_args...]
```

For example:

```bash
ossh myserver -p 2222
```

The wrapper script will automatically execute the pre and post connection scripts.

## Configuration

The SSH wrapper relies on your existing `~/.ssh/config` file for configuration details such as `User`, `Port`, and `IdentityFile`. Ensure you have the necessary entries in your `~/.ssh/config` file for each SSH host you want to use with the wrapper.

Example `~/.ssh/config` entry:

```config
Host myserver
  User myuser
  HostName myserver.example.com
  Port 22
  IdentityFile ~/.ssh/id_rsa
```

## Scripts

### Pre Connection Script

The pre-connection script is located at `~/.ssh/scripts/before_established.sh`. This script will run before establishing the SSH connection.

```bash
#!/bin/bash

# Set ssh connection hostname
Hostname=$1

# Parse .ssh/config Hostname params
User=$(get_ssh_option "$Hostname" "User")
Port=$(get_ssh_option "$Hostname" "Port")
IdentityFile=$(get_ssh_option "$Hostname" "IdentityFile")

echo "Do some stuff before ssh connection established..."

# Your code here (e.g., open a port on another server)

echo "Done!"
```

### Post Connection Script

The post-connection script is located at `~/.ssh/scripts/after_established.sh`. This script will run after the SSH connection has been established.

```bash
#!/bin/bash

# Set ssh connection hostname
Hostname=$1

# Parse .ssh/config Hostname params
User=$(get_ssh_option "$Hostname" "User")
Port=$(get_ssh_option "$Hostname" "Port")
IdentityFile=$(get_ssh_option "$Hostname" "IdentityFile")

echo "Do some stuff after ssh connection established..."

# Your code here (e.g., close a port on another server)

echo "Done!"
```

### Built-in functions

You can specify code for some hostnames using built-in bash function is_hostname(). Example with `~/.ssh/scripts/before_established.sh`:

```bash
#!/bin/bash

# Set ssh connection hostname
Hostname=$1
Port=$(get_ssh_option "$Hostname" "Port")

echo "Do some staff before ssh connection established..."

if [ $(is_hostname "hostname1 hostname2") == 1 ]; then
    echo "Have to open port on public_vps" before ssh connection established
    ssh public_vps "echo $Port > /tmp/ports_to_open.list"
    sleep 1.1
fi

echo "Done!"
```

## Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue if you have any suggestions or bug reports.
