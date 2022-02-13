[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing');

$Process = [System.Diagnostics.Process]::New();
$StartInfo = $Process.StartInfo;
$StartInfo.FileName = 'powershell';
$StartInfo.Arguments = '-f Server.ps1';
$StartInfo.UseShellExecute = $false;
$StartInfo.CreateNoWindow = $true;
$Process.Start();

$NotifyIcon = [System.Windows.Forms.NotifyIcon]::New();
$NotifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon([System.Environment]::ExpandEnvironmentVariables('%SystemRoot%\System32\newdev.exe'));
$NotifyIcon.Text = 'Close server';
$NotifyIcon.Visible = $true;
$NotifyIcon.Add_Click({
	if (!$Process.HasExited) {
		$Process.Kill();
	}
	$ApplicationContext.ExitThread();
});

$ApplicationContext = [System.Windows.Forms.ApplicationContext]::New();
[System.Windows.Forms.Application]::Run($ApplicationContext);
