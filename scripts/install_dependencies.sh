#!/bin/bash
set -e

echo "Checking application dependencies..."

if ! command -v nginx >/dev/null 2>&1; then
    dnf install -y nginx
fi

if ! command -v node >/dev/null 2>&1; then
    dnf install -y nodejs npm
fi

mkdir -p /opt/combined-app
mkdir -p /usr/share/nginx/html

echo "Dependencies are ready."
