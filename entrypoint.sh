#!/bin/bash

# Change to the app directory
cd /app

# Activate virtual environment
source /app/venv/bin/activate

# Wait for Redis to be available
/usr/local/bin/wait-for-it.sh redis-server:6379 --timeout=60 --strict -- echo "Redis is up"

# Run upgrade script
echo 'Running upgrade.sh...'
bash /app/upgrade.sh

# Start Gunicorn
gunicorn --bind 0.0.0.0:8000 statuspage.wsgi:application \
    --chdir /app \
    --workers 3 \
    --log-level debug
