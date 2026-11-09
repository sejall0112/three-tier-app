#!/bin/bash
set -e

echo "Removing old frontend files..."
rm -f /usr/share/nginx/html/index.html

echo "Checking application dependencies..."

if ! command -v nginx >/dev/null 2>&1; then
    dnf install -y nginx
fi

if ! command -v node >/dev/null 2>&1; then
    dnf install -y nodejs npm
fi

echo "Stopping existing backend service..."
systemctl stop combined-backend || true

echo "Removing old application files..."
rm -rf /opt/combined-app

echo "Creating clean application directory..."
mkdir -p /opt/combined-app
mkdir -p /usr/share/nginx/html

echo "BeforeInstall completed successfully."