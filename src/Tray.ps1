[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing');

$Url = 'http://localhost:__REPLACE_PORT__/';

$Process = [System.Diagnostics.Process]::New();
$StartInfo = $Process.StartInfo;
$StartInfo.FileName = 'powershell';
$StartInfo.Arguments = '-f Server.ps1';
$StartInfo.UseShellExecute = $false;
$StartInfo.CreateNoWindow = $true;
$Process.Start();

$IconPath = [System.Environment]::ExpandEnvironmentVariables('%SystemRoot%\System32\newdev.exe');
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($IconPath);

$NotifyIcon = [System.Windows.Forms.NotifyIcon]::New();
$NotifyIcon.Icon = $Icon;
$NotifyIcon.Text = 'Close server';
$NotifyIcon.BalloonTipTitle = 'Server listening on ' + $Url;
$NotifyIcon.BalloonTipText = 'Click here to open. To close, click tray icon.';
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
