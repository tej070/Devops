#Setup script for dB SERVER WITH following configurations:
    #1.change ssh port to 3500 
    #2.mssql 2019 setup
    #3.mssql port 55450
    #4.update
    #5.timezone change
    #6.awscli
    #7.zip

    #((Setup mssql 2019, mssql port change 55450, ssh port 3500, zip, awscli, timezone and update))


#!/bin/bash

# GET UPDATE
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

# Define the new SSH port
NEW_SSH_PORT=3500

# Backup the current SSH configuration file
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Change the SSH port in the configuration file
sudo sed -i "s/#Port 22/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config
sudo sed -i "s/Port 22/Port $NEW_SSH_PORT/" /etc/ssh/sshd_config

# Allow the new SSH port through the firewall
sudo ufw allow $NEW_SSH_PORT/tcp
sudo systemctl restart sshd

# Set the timezone to Kathmandu
sudo timedatectl set-timezone Asia/Kathmandu
sudo timedatectl set-local-rtc 1 --adjust-system-clock

# Display the current date and time
timedatectl

# Install zip

sudo apt install zip -y

# Install the AWS CLI
sudo apt install awscli -y

sudo apt install libc6-dev
sudo apt install libgdiplus

# For installation of MSSQL-Server

# Import the public repository GPG keys:
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# Register the SQL Server Ubuntu repository:
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"

# INSTALL MSSQL-Server
sudo apt-get update
sudo apt-get install mssql-server -y
sudo /opt/mssql/bin/mssql-conf setup

# Install the SQL Server command-line tools
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list)"

sudo apt-get update
sudo apt-get install mssql-tools unixodbc-dev -y

# Add MSSQL tools to PATH in .bashrc
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

# Change the MSSQL port to 55450
NEW_MSSQL_PORT=55450
echo "Changing SQL Server port to $NEW_MSSQL_PORT..."
sudo /opt/mssql/bin/mssql-conf set network.tcpport $NEW_MSSQL_PORT

# Restart the MSSQL service to apply the new port
sudo systemctl restart mssql-server

# Verify the port change
sudo /opt/mssql/bin/mssql-conf get network.tcpport