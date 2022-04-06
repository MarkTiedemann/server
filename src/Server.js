// A tiny, double-clickable HTTP server for Windows
// https://github.com/MarkTiedemann/server

var port = 8000;
var root = ".";
var index = "index.html";

new ActiveXObject("WScript.Shell").run("powershell -f Tray.ps1", 0, false);
