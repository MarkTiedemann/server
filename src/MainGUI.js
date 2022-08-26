// A tiny HTTP server GUI for Windows
// https://github.com/MarkTiedemann/server

var port = 8000;
var root = ".";
var index = "index.html";
var clean_urls = true;

new ActiveXObject("WScript.Shell").run("powershell -f GUI.ps1", 0, false);
