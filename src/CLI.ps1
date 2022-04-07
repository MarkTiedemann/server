[System.Console]::TreatControlCAsInput = $true;

$Process = [System.Diagnostics.Process]::New();
$StartInfo = $Process.StartInfo;
$StartInfo.FileName = 'powershell';
$StartInfo.Arguments = '-f Server.ps1';
$StartInfo.UseShellExecute = $false;
$StartInfo.CreateNoWindow = $true;
$Process.Start() | Out-Null;

while ($true) {
	if ([System.Console]::KeyAvailable) {
		$KeyInfo = [System.Console]::ReadKey($true);
		if ($KeyInfo.Modifiers -eq 'Control' -and $KeyInfo.Key -eq 'C') {
			$Process.Kill();
			Exit;
		}
	} else {
		Start-Sleep -Milliseconds 10;
	}
}
