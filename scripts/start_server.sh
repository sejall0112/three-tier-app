```bash
#!/bin/bash
set -e

echo "Preparing application directory..."
cd /opt/combined-app

echo "Installing Node.js dependencies..."
npm install --omit=dev

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
```