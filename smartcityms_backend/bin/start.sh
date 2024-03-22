#!/bin/bash

DJANGO_PROJECT_DIR=$(dirname "$(dirname "$(realpath "$0")")")

cd "$DJANGO_PROJECT_DIR"

echo "Starting the application..."
nohup waitress-serve --listen=*:8090 backend.wsgi:application > waitress.log 2>&1 &
echo $! > app.pid
echo "Application started successfully."

