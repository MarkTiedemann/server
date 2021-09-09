[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing');

$Process = [System.Diagnostics.Process]::New();
$Process.StartInfo.FileName = 'powershell';
$Process.StartInfo.Arguments = '-f Server.ps1';
$Process.StartInfo.UseShellExecute = $false;
$Process.StartInfo.CreateNoWindow = $true;
$Process.Start();

$IconPath = [System.Environment]::ExpandEnvironmentVariables('%SystemRoot%\System32\newdev.exe');
$Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($IconPath);

$CurrentUICulture = [System.Globalization.CultureInfo]::CurrentUICulture;
$Text = switch ($CurrentUICulture.TwoLetterISOLanguageName) {
	'en' { 'Close server' }
	'de' { 'Server schließen' }
};

$NotifyIcon = [System.Windows.Forms.NotifyIcon]::New();
$NotifyIcon.Icon = $Icon;
$NotifyIcon.Text = $Text;
$NotifyIcon.Visible = $true;
$NotifyIcon.Add_Click({
	if (!$Process.HasExited) {
		$Process.Kill();
	}
	$ApplicationContext.ExitThread();
});

$ApplicationContext = [System.Windows.Forms.ApplicationContext]::New();
[System.Windows.Forms.Application]::Run($ApplicationContext);