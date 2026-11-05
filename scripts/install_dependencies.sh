#!/bin/bash
set -e

echo "Installing application dependencies..."

dnf install -y nginx nodejs npm

mkdir -p /opt/combined-app
mkdir -p /usr/share/nginx/html

echo "Dependencies installed successfully."