[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing');

$Url = 'http://localhost:8000/';

$Process = [System.Diagnostics.Process]::New();
$StartInfo = $Process.StartInfo;
$StartInfo.FileName = 'powershell';
$StartInfo.Arguments = '-f Server.ps1';
$StartInfo.UseShellExecute = $false;
$StartInfo.CreateNoWindow = $true;
$Process.Start();

$IconPath = [System.Environment]::ExpandEnvironmentVariables('%SystemRoot%\System32\newdev.exe');
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($IconPath);

$CurrentUICulture = [System.Globalization.CultureInfo]::CurrentUICulture;
$Language = $CurrentUICulture.TwoLetterISOLanguageName;

$TrayText = switch ($Language) {
	'en' { 'Close server' }
	'de' { 'Server beenden' }
};
$BalloonTitle = switch ($Language) {
	'en' { 'Server listening on ' + $Url }
	'de' { 'Server horcht auf ' + $Url }
};
$BalloonText = switch ($Language) {
	'en' { 'Click here to open. To close, click tray icon.' }
	'de' { 'Zum Aufrufen hier klicken. Zum Beenden Ablagebild anklicken.' }
};

$NotifyIcon = [System.Windows.Forms.NotifyIcon]::New();
$NotifyIcon.Icon = $Icon;
$NotifyIcon.Text = $TrayText;
$NotifyIcon.BalloonTipTitle = $BalloonTitle;
$NotifyIcon.BalloonTipText = $BalloonText;
$NotifyIcon.Visible = $true;
$NotifyIcon.Add_Click({
	if (!$Process.HasExited) {
		$Process.Kill();
	}
	$ApplicationContext.ExitThread();
});
$NotifyIcon.Add_BalloonTipClicked({
	rundll32.exe url.dll,FileProtocolHandler $Url;
});
$NotifyIcon.ShowBalloonTip(0);

$ApplicationContext = [System.Windows.Forms.ApplicationContext]::New();
[System.Windows.Forms.Application]::Run($ApplicationContext);