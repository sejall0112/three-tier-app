#!/bin/bash
set -e

echo "Setting application permissions..."

chown -R ec2-user:ec2-user /opt/combined-app

chmod -R 755 /opt/combined-app
chmod -R 755 /usr/share/nginx/html

echo "Permissions updated successfully."