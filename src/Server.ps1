[System.Reflection.Assembly]::LoadWithPartialName('System.Web');

$Server = [System.Net.HttpListener]::New();
$Server.Prefixes.Add('http://localhost:8000/');
$Server.Start();

while ($Server.IsListening) {
	$Context = $Server.GetContext();
	$Request = $Context.Request;
	$Response = $Context.Response;

	if ($Request.HttpMethod -ne 'GET') {
		$Response.StatusCode = 405;
		$Response.Close();
		continue;
	}

	try {
		$Path = '.' + $Request.Url.LocalPath -replace '/', '\';
		$File = [System.IO.File]::OpenRead($Path);
		$Response.ContentType = [System.Web.MimeMapping]::GetMimeMapping($Path);
		$File.CopyTo($Response.OutputStream);
		$Response.Close();
		$File.Close();
	} catch {
		$Response.StatusCode = 404;
		$Response.Close();
	}
}