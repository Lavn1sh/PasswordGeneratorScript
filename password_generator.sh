#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install OpenSSL on Arch Linux systems
install_openssl_arch() {
    echo "Installing OpenSSL using pacman..."
    sudo pacman -Syu --noconfirm openssl
}

clear
cat <<'EOF'
 ____                                     _      
|  _ \ __ _ ___ _____      _____  _ __ __| |    
| |_) / _` / __/ __\ \ /\ / / _ \| '__/ _` |    
|  __/ (_| \__ \__ \\ V  V / (_) | | | (_| |    
|_|   \__,_|___/___/ \_/\_/ \___/|_|  \__,_|
  ____                           _              
 / ___| ___ _ __   ___ _ __ __ _| |_ ___  _ __  
| |  _ / _ \ '_ \ / _ \ '__/ _` | __/ _ \| '__| 
| |_| |  __/ | | |  __/ | | (_| | || (_) | |    
 \____|\___|_| |_|\___|_|  \__,_|\__\___/|_|

EOF
# Check if OpenSSL is already installed
if command_exists openssl; then
    echo "OpenSSL is already installed. Version: $(openssl version)"
else
# Detect if the system is Arch-based
  if [ -f /etc/os-release ]; then
      . /etc/os-release
      if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
          install_openssl_arch
          if command_exists openssl; then
            echo "OpenSSL installed successfully. Version: $(openssl version)"
          else
            echo "Failed to install OpenSSL."
            exit 1
          fi
      else
        echo "This script is intended for Arch Linux systems."
        exit 1
      fi
  else
      echo "Cannot determine the Linux distribution. Exiting."
      exit 1
  fi
fi

#Simple password generator 

echo "This is a simple password generator"

echo "Enter the length of the password you want: "
read PASS_LENGTH

echo "Enter the number of passwords you want"
read NUM_PASS

for ((i=1; i<=NUM_PASS; i++)); do
	password=$(openssl rand -base64 48 | cut -c1-$PASS_LENGTH)
	echo "Password $i: $password" 
done
exit 0
