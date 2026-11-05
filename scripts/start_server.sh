#!/bin/bash
set -e

echo "Installing Node.js dependencies..."

cd /opt/combined-app
npm install --omit=dev

echo "Starting backend..."

systemctl daemon-reload
systemctl enable combined-backend
systemctl restart combined-backend

echo "Starting Nginx..."

systemctl enable nginx
systemctl restart nginx

echo "Application started."
