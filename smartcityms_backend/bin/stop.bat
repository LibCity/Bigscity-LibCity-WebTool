@echo off
echo Stopping the application...
taskkill /IM waitress-serve.exe /F > nul 2>&1
echo Application stopped successfully.
