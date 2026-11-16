#!/bin/sh
set -e

cd /app/backend
node server.js &

exec nginx -g "daemon off;"
