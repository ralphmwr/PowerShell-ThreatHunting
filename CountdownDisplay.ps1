$LabelCountdown_Click = {
}
$TickTock = {
    $timeremaining = $Script:endtime - (Get-Date)
    if ($timeremaining.TotalSeconds -le 0) {
        $TimerCountdown.Enabled = $false
        $FormCountdownDisplay.close()
    }
    if ($timeremaining.TotalSeconds -le 10) {
        $TimerCountdown.Interval = 250
        $labelCountdown.text = "{0:00}:{1:00}:{2:00}:{3:000}" -f $timeremaining.hours, 
                                                                    $timeremaining.minutes, 
                                                                    $timeremaining.seconds,
                                                                    $timeremaining.milliseconds
    }
    else {
        $TimerCountdown.Interval = 1000
        $TimerCountdown.Interval = 10
        $labelCountdown.text = "{0:00}:{1:00}:{2:00}" -f $timeremaining.hours, 
                                                            $timeremaining.minutes, 
                                                            $timeremaining.seconds
    }
}

Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'CountdownDisplay.designer.ps1')
$labelDisplayMsg.text = $Script:message
$TickTock.Invoke()
$FormCountdownDisplay.ShowDialog()
