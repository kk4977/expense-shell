# Setting Up Apache2 and Displaying Server Details

This guide provides step-by-step instructions to install Apache2 on Ubuntu and display server details (hostname and IP address) in an `index.html` file served by Apache.

## Installation Steps

### 1. Update Package Lists

```bash
sudo apt update

sudo apt install -y apache2

----------------------------------------------------------------

3. Create a Bash Script for index.html
Create a Bash script named generate_index.sh to generate the index.html file with server details:

```bash
#!/bin/bash

# Retrieve hostname and IP address
HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Generate HTML content for index.html
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Server Details</title>
</head>
<body>
    <h1>Server Details</h1>
    <p><strong>Hostname:</strong> $HOSTNAME</p>
    <p><strong>IP Address:</strong> $IP_ADDRESS</p>
</body>
</html>
EOF

----------------------------------------------------------------

chmod +x generate_index.sh

sudo ./generate_index.sh

sudo systemctl restart apache2

sudo tail -f /var/log/apache2/access.log






 




