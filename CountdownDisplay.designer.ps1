$FormCountdownDisplay = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$LabelCountdown = $null
[System.Windows.Forms.Timer]$TimerCountdown = $null
[System.ComponentModel.IContainer]$components = $null
[System.Windows.Forms.Label]$LabelDisplayMsg = $null
function InitializeComponent
{
$components = (New-Object -TypeName System.ComponentModel.Container)
$LabelCountdown = (New-Object -TypeName System.Windows.Forms.Label)
$TimerCountdown = (New-Object -TypeName System.Windows.Forms.Timer -ArgumentList @($components))
$LabelDisplayMsg = (New-Object -TypeName System.Windows.Forms.Label)
$FormCountdownDisplay.SuspendLayout()
#
#LabelCountdown
#
$LabelCountdown.Dock = [System.Windows.Forms.DockStyle]::Fill
$LabelCountdown.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]72,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LabelCountdown.ForeColor = [System.Drawing.Color]::White
$LabelCountdown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$LabelCountdown.Name = [System.String]'LabelCountdown'
$LabelCountdown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]837,[System.Int32]541))
$LabelCountdown.TabIndex = [System.Int32]0
$LabelCountdown.Text = [System.String]'00:00:00'
$LabelCountdown.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelCountdown.UseCompatibleTextRendering = $true
$LabelCountdown.add_Click($LabelCountdown_Click)
#
#TimerCountdown
#
$TimerCountdown.Enabled = $true
$TimerCountdown.add_Tick($TickTock)
#
#LabelDisplayMsg
#
$LabelDisplayMsg.Dock = [System.Windows.Forms.DockStyle]::Top
$LabelDisplayMsg.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]36,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LabelDisplayMsg.ForeColor = [System.Drawing.Color]::White
$LabelDisplayMsg.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]0,[System.Int32]0))
$LabelDisplayMsg.Name = [System.String]'LabelDisplayMsg'
$LabelDisplayMsg.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]837,[System.Int32]164))
$LabelDisplayMsg.TabIndex = [System.Int32]1
$LabelDisplayMsg.Text = [System.String]'Message'
$LabelDisplayMsg.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$LabelDisplayMsg.UseCompatibleTextRendering = $true
#
#FormCountdownDisplay
#
$FormCountdownDisplay.BackColor = [System.Drawing.Color]::Black
$FormCountdownDisplay.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]837,[System.Int32]541))
$FormCountdownDisplay.Controls.Add($LabelDisplayMsg)
$FormCountdownDisplay.Controls.Add($LabelCountdown)
$FormCountdownDisplay.Text = [System.String]'Countdown'
$FormCountdownDisplay.ResumeLayout($false)
Add-Member -InputObject $FormCountdownDisplay -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $FormCountdownDisplay -Name LabelCountdown -Value $LabelCountdown -MemberType NoteProperty
Add-Member -InputObject $FormCountdownDisplay -Name TimerCountdown -Value $TimerCountdown -MemberType NoteProperty
Add-Member -InputObject $FormCountdownDisplay -Name components -Value $components -MemberType NoteProperty
Add-Member -InputObject $FormCountdownDisplay -Name LabelDisplayMsg -Value $LabelDisplayMsg -MemberType NoteProperty
}
. InitializeComponent
