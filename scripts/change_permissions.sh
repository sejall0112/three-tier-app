#!/bin/bash
set -e

echo "Setting application permissions..."

chown -R ec2-user:ec2-user /opt/combined-app

find /opt/combined-app -type d -exec chmod 755 {} \;
find /opt/combined-app -type f -exec chmod 644 {} \;

find /usr/share/nginx/html -type d -exec chmod 755 {} \;
find /usr/share/nginx/html -type f -exec chmod 644 {} \;

echo "Permissions updated."
