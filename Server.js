// A tiny HTTP server GUI for Windows
// https://github.com/MarkTiedemann/server

var port = 8000;
var root = ".";
var index = "index.html";

new ActiveXObject("WScript.Shell").run("powershell -c \"[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing'); $Process = [System.Diagnostics.Process]::New(); $StartInfo = $Process.StartInfo; $StartInfo.FileName = 'powershell'; $StartInfo.Arguments = '-c \"$Port = ''" + port + "''; $Root = ''" + root + "''; $Index = ''" + index + "''; [System.Reflection.Assembly]::LoadWithPartialName(''System.Web''); $Server = [System.Net.HttpListener]::New(); $Server.Prefixes.Add(''http://localhost:'' + $Port + ''/''); $Server.Start(); function Get-ContentType([string] $Pathname) { $Extension = [System.IO.Path]::GetExtension($Pathname); $OctetStream = ''application/octet-stream''; if ($null -eq $Extension) { return $OctetStream; } $ContentType = switch ($Extension) { ''.csv'' { ''text/csv'' } ''.jsonld'' { ''application/ld+json'' } ''.mjs'' { ''text/javascript'' } ''.otf'' { ''font/otf'' } ''.ttf'' { ''font/ttf'' } ''.wasm'' { ''application/wasm'' } ''.webp'' { ''image/webp'' } ''.woff'' { ''font/woff'' } ''.woff2'' { ''font/woff2'' } default { $OctetStream } }; if ($ContentType -eq $OctetStream) { $ContentType = [System.Web.MimeMapping]::GetMimeMapping($Extension); if ($ContentType -eq $OctetStream) { $ContentType = [Microsoft.Win32.Registry]::GetValue(''HKEY_CLASSES_ROOT\\'' + $Extension, ''Content Type'', $null); if ($null -eq $ContentType) { $ContentType = $OctetStream; } } } return $ContentType; } while ($Server.IsListening) { try { $Context = $Server.GetContext(); $Request = $Context.Request; $Response = $Context.Response; if ($Request.HttpMethod -ne ''GET'') { $Response.StatusCode = 405; continue; } $Pathname = $Request.Url.LocalPath; if ($Pathname.EndsWith(''/'')) { $Pathname += $Index; $ContentType = ''text/html''; } $Path = $Root + ($Pathname -replace ''/'', ''\\''); $ContentType = Get-ContentType($Path); $File = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read); $Response.ContentType = $ContentType; $File.CopyTo($Response.OutputStream); } catch { $Response.StatusCode = 404; } finally { $Response.Close(); if ($null -ne $File) { $File.Close(); } } } \"'; $StartInfo.UseShellExecute = $false; $StartInfo.CreateNoWindow = $true; $Process.Start(); $NotifyIcon = [System.Windows.Forms.NotifyIcon]::New(); $NotifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon([System.Environment]::ExpandEnvironmentVariables('%SystemRoot%\\System32\\newdev.exe')); $NotifyIcon.Text = 'Close server'; $NotifyIcon.Visible = $true; $NotifyIcon.Add_Click({ if (!$Process.HasExited) { $Process.Kill(); } $ApplicationContext.ExitThread(); }); $ApplicationContext = [System.Windows.Forms.ApplicationContext]::New(); [System.Windows.Forms.Application]::Run($ApplicationContext); \"", 0, false);
