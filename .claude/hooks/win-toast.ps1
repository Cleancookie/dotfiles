param([string]$Title = $env:TOAST_TITLE, [string]$Message = $env:TOAST_MSG)

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime] > $null

$t = [Security.SecurityElement]::Escape($Title)
$m = [Security.SecurityElement]::Escape($Message)
$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
$xml.LoadXml(@"
<toast>
  <visual><binding template="ToastGeneric"><text>$t</text><text>$m</text></binding></visual>
</toast>
"@)

$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
$app = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app).Show($toast)
