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

echo "Validating database configuration..."

for name in DB_HOST DB_NAME DB_USER DB_PASSWORD; do
  if [ -z "${!name}" ] || [ "${!name}" = "None" ]; then
    echo "ERROR: $name is empty."
    exit 1
  fi
done

echo "Creating environment file..."
umask 077

node -e '
const fs = require("fs");
const keys = ["DB_HOST", "DB_NAME", "DB_USER", "DB_PASSWORD"];
const content = keys.map(k => k + "=" + JSON.stringify(process.env[k]))
  .join("\n") + "\n";
fs.writeFileSync("/opt/combined-app/.env", content, { mode: 0o600 });
'

echo "Setting environment file permissions..."
chown ec2-user:ec2-user /opt/combined-app/.env
chmod 600 /opt/combined-app/.env

echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling and restarting backend..."
systemctl enable combined-backend
systemctl restart combined-backend

echo "Enabling and restarting Nginx..."
systemctl enable nginx
systemctl restart nginx

echo "Application startup completed."
