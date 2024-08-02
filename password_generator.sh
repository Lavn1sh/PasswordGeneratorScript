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
generate_password() {
    length=$1
    special_option=$2

    # Define character sets
    lowercase="abcdefghijklmnopqrstuvwxyz"
    uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numbers="0123456789"
    all_special='!@#$%^&*()_+-=[]{}|;:,.<>?'
    limited_special="@_@_@_"

    # Start with alphanumeric characters
    charset="${lowercase}${uppercase}${numbers}"

    case $special_option in
        "all")
            charset="${charset}${all_special}"
            special_chars="$all_special"
            ;;
        "limited")
            charset="${charset}${limited_special}"
            special_chars="$limited_special"
            ;;
        "none")
            special_chars=""
            ;;
    esac

    # Generate initial password
    password=$(openssl rand -base64 48 | tr -dc "${charset}" | head -c ${length})

    # Ensure at least one special character if requested
    if [ "$special_option" != "none" ]; then
        if [ "$special_option" = "all" ] && ! echo "$password" | grep -Fq '[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'; then
            need_special=true
        elif [ "$special_option" = "limited" ] && ! echo "$password" | grep -Fq '[@_]'; then
            need_special=true
        else
            need_special=false
        fi

        if [ "$need_special" = true ]; then
            position=$((RANDOM % length))
            special_char=${special_chars:$((RANDOM % ${#special_chars})):1}
            password="${password:0:$position}${special_char}${password:$((position+1))}"
        fi
    fi

    echo "$password"
}

# Prompt user for password length
read -p "Enter password length: " length

# Prompt user for special character option
echo "Choose special character option:"
echo "1. All special characters"
echo "2. Only @ and _"
echo "3. No special characters"
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1) special_option="all" ;;
    2) special_option="limited" ;;
    3) special_option="none" ;;
    *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

# Prompt user for number of passwords
read -p "How many passwords do you want to generate? " num_passwords

# Generate and display passwords
echo "Generated passwords:"
for ((i=1; i<=num_passwords; i++))
do
    password=$(generate_password $length $special_option)
    echo "$i. $password"
done
exit 0
