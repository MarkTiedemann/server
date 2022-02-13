[System.Reflection.Assembly]::LoadWithPartialName('System.Web');

$Server = [System.Net.HttpListener]::New();
$Server.Prefixes.Add('http://localhost:__REPLACE_PORT__/');
$Server.Start();

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
		$Response.ContentType = [System.Web.MimeMapping]::GetMimeMapping($Path);
		$File.CopyTo($Response.OutputStream);
	} catch {
		$Response.StatusCode = 404;
	} finally {
		$Response.Close();
		$File.Close();
	}
}
