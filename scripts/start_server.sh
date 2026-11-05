#!/bin/bash
set -e

echo "Installing Node.js packages..."

cd /opt/combined-app

npm install --omit=dev

echo "Starting backend service..."

systemctl daemon-reload
systemctl enable combined-backend
systemctl restart combined-backend

echo "Starting Nginx..."

systemctl enable nginx
systemctl restart nginx

echo "Application started."