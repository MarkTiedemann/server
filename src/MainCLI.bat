@echo off
setlocal

:: A tiny HTTP server CLI for Windows
:: https://github.com/MarkTiedemann/server

set port=8000
set root=.
set index=index.html
set clean_urls=true

powershell -f CLI.ps1
