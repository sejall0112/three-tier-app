#!/bin/bash

echo "Stopping existing backend..."

if systemctl is-active --quiet combined-backend; then
    systemctl stop combined-backend
fi

echo "Backend stopped."
