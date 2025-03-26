#!/bin/bash

# Wait for Redis to be available
/usr/local/bin/wait-for-it.sh redis-server:6379 --timeout=60 --strict -- echo "Redis is up"

# Activate virtual environment
source /opt/venv/bin/activate

# Run upgrade script
echo 'Running upgrade.sh...'
bash /opt/upgrade.sh

# Start Gunicorn
exec gunicorn --bind 0.0.0.0:8000 statuspage.wsgi:application \
    --chdir /opt/statuspage \
    --workers 3 \
    --log-level debug
