#!/bin/bash
set -e

echo "Checking backend health..."

curl -fsS http://127.0.0.1:3000/health

echo "Backend health check passed."

echo "Checking Nginx..."

curl -fsS http://127.0.0.1/health

echo "Nginx health check passed."

echo "Checking products API..."

curl -fsS http://127.0.0.1/api/products

echo "Products API check passed."

echo "All validation checks passed."