#!/bin/bash
set -e

echo "Preparing application directory..."
cd /opt/combined-app

echo "Installing Node.js dependencies..."
npm install --omit=dev

echo "Retrieving database configuration from Parameter Store..."

export DB_HOST=$(aws ssm get-parameter \
  --name "/three-tier/db-host" \
  --with-decryption \
  --region eu-north-1 \
  --query "Parameter.Value" \
  --output text)

export DB_NAME=$(aws ssm get-parameter \
  --name "/three-tier/db-name" \
  --with-decryption \
  --region eu-north-1 \
  --query "Parameter.Value" \
  --output text)

export DB_USER=$(aws ssm get-parameter \
  --name "/three-tier/db-user" \
  --with-decryption \
  --region eu-north-1 \
  --query "Parameter.Value" \
  --output text)

export DB_PASSWORD=$(aws ssm get-parameter \
  --name "/three-tier/db-password" \
  --with-decryption \
  --region eu-north-1 \
  --query "Parameter.Value" \
  --output text)

echo "Creating secure .env file..."

umask 077
node -e '
const fs = require("fs");
const keys = ["DB_HOST", "DB_NAME", "DB_USER", "DB_PASSWORD"];
const content = keys.map(k => {
  if (!process.env[k]) throw new Error(k + " is missing");
  return k + "=" + JSON.stringify(process.env[k]);
}).join("\n") + "\n";
fs.writeFileSync("/opt/combined-app/.env", content, { mode: 0o600 });
'

echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling backend service..."
systemctl enable combined-backend

echo "Starting backend..."
systemctl restart combined-backend

echo "Enabling Nginx..."
systemctl enable nginx

echo "Restarting Nginx..."
systemctl restart nginx

echo "Application started successfully."
