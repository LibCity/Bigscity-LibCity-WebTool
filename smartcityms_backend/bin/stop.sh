#!/bin/bash

DJANGO_PROJECT_DIR=$(dirname "$(dirname "$(realpath "$0")")")

cd "$DJANGO_PROJECT_DIR"

echo "Stopping the application..."
PID=$(cat app.pid)
kill $PID
rm app.pid
echo "Application stopped successfully."

