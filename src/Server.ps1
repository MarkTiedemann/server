[System.Reflection.Assembly]::LoadWithPartialName('System.Web');

$Server = [System.Net.HttpListener]::New();
$Server.Prefixes.Add('http://localhost:__REPLACE_PORT__/');
$Server.Start();

function Get-ContentType($Pathname) {
	$Extension = [System.IO.Path]::GetExtension($Pathname);
	$OctetStream = 'application/octet-stream';
	$ContentType = switch ($Extension) {
		'.csv' { 'text/csv' }
		'.jsonld' { 'application/ld+json' }
		'.mjs' { 'text/javascript' }
		'.oft' { 'font/otf' }
		'.ttf' { 'font/ttf' }
		'.wasm' { 'application/wasm' }
		'.webp' { 'image/webp' }
		'.woff' { 'font/woff' }
		'.woff2' { 'font/woff2' }
		default { $OctetStream }
	};
	if ($ContentType -eq $OctetStream) {
		$ContentType = [System.Web.MimeMapping]::GetMimeMapping($Extension);
		if ($ContentType -eq $OctetStream) {
			$ContentType = [Microsoft.Win32.Registry]::GetValue('HKEY_CLASSES_ROOT\' + $Extension, 'Content Type', $null);
			if ($ContentType -eq $null) {
				$ContentType = $OctetStream;
			}
		}
	}
	return $ContentType;
}

while ($Server.IsListening) {
	try {
		$Context = $Server.GetContext();
		$Request = $Context.Request;
		$Response = $Context.Response;
		$Pathname = $Request.Url.LocalPath -replace '/', '\';
		if ($Pathname -eq '\') {
			$Pathname = '\__REPLACE_INDEX__';
		}
		$Path = '__REPLACE_ROOT__' + $Pathname;
		$File = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite);
		$Response.ContentType = Get-ContentType($Path);
		$File.CopyTo($Response.OutputStream);
	} catch {
		$Response.StatusCode = 404;
	} finally {
		$Response.Close();
		$File.Close();
	}
}
