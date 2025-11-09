#!/bin/bash

# === 1. Update and install OpenSSH server ===
sudo apt update -y
sudo apt install -y openssh-server

# === 2. Enable root login and password authentication ===
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# === 3. Set root password ===
echo "root:root" | sudo chpasswd

# === 4. Start SSH service ===
sudo systemctl enable ssh
sudo systemctl restart ssh

# === 5. Show status and info ===
sudo systemctl status ssh --no-pager
echo "✅ SSH is running on port 22 with root password 'root'"
echo "You can now SSH using: ssh root@<IP> and password 'root'"
