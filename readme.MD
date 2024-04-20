# Setting Up Apache2 and Displaying Server Details

This guide provides step-by-step instructions to install Apache2 on Ubuntu and display server details (hostname and IP address) in an `index.html` file served by Apache.

## Installation Steps

### 1. Update Package Lists



```bash
 # Update Package Lists
sudo apt update

```bash
# Install Apache2
sudo apt install -y apache2

```bash
# Create Bash Script to Generate index.html
cat <<EOF > generate_index.sh
#!/bin/bash

# Retrieve hostname and IP address
HOSTNAME=\$(hostname)
IP_ADDRESS=\$(hostname -I | awk '{print \$1}')

# Generate HTML content for index.html
cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Server Details</title>
</head>
<body>
    <h1>Server Details</h1>
    <p><strong>Hostname:</strong> \$HOSTNAME</p>
    <p><strong>IP Address:</strong> \$IP_ADDRESS</p>
</body>
</html>
EOF

```bash
# Make script executable
chmod +x generate_index.sh

```bash
# Run Bash Script to Generate index.html
sudo ./generate_index.sh

```bash
# Restart Apache2
sudo systemctl restart apache2

```bash
# View Apache2 Status
sudo systemctl status apache2

