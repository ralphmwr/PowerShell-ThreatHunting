$LaunchCountdown = {
    [int]$hour, [int]$min = $TextBoxTime.Text -split ":"
    $script:endtime = Get-Date -Hour $hour -Minute $min
    $script:message = $textboxmessage.text
    . (Join-Path $PSScriptRoot 'countdownDisplay.ps1')
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'Countdown.designer.ps1')
$FormSetCountdown.ShowDialog()  