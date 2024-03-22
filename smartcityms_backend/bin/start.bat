@echo off

set "SCRIPT_DIR=%~dp0"
set "PARENT_DIR=%SCRIPT_DIR%\.."
set "DJANGO_PROJECT_DIR=%PARENT_DIR%"

cd /d "%DJANGO_PROJECT_DIR%"

echo Starting the application...
start /B waitress-serve --listen=*:8090 backend.wsgi:application > waitress.log 2>&1
echo Application started successfully.
