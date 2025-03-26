#!/bin/bash

# Ensure the virtual environment is activated
source /opt/venv/bin/activate

# Wait for Redis to be available
/usr/local/bin/wait-for-it.sh redis-server:6379 --timeout=60 --strict -- echo "Redis is up"

# Run upgrade script
echo 'Running upgrade.sh...'
bash /opt/upgrade.sh

# Start Gunicorn
gunicorn --bind 0.0.0.0:8000 statuspage.wsgi:application \
    --chdir /opt/statuspage \
    --workers 3 \
    --log-level debug
