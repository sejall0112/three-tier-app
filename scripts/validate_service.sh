#!/bin/bash
set -e

echo "Checking backend health..."

for i in {1..30}; do
    if curl -fsS http://127.0.0.1:3000/health; then
        echo "Backend health check passed."
        break
    fi

    if [ "$i" -eq 30 ]; then
        echo "Backend health check failed."
        exit 1
    fi

    sleep 2
done

echo "Checking Nginx..."

curl -fsS http://localhost/health

echo "Checking products API..."

curl -fsS http://localhost/api/products

echo "All validation checks passed."
