$FormSetCountdown = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.TextBox]$TextBoxTime = $null
[System.Windows.Forms.Button]$ButtonCountdown = $null
[System.Windows.Forms.Label]$LabelEndTime = $null
[System.Windows.Forms.Label]$LabelMessage = $null
[System.Windows.Forms.TextBox]$TextBoxmessage = $null
function InitializeComponent
{
$TextBoxTime = (New-Object -TypeName System.Windows.Forms.TextBox)
$ButtonCountdown = (New-Object -TypeName System.Windows.Forms.Button)
$LabelEndTime = (New-Object -TypeName System.Windows.Forms.Label)
$LabelMessage = (New-Object -TypeName System.Windows.Forms.Label)
$TextBoxmessage = (New-Object -TypeName System.Windows.Forms.TextBox)
$FormSetCountdown.SuspendLayout()
#
#TextBoxTime
#
$TextBoxTime.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]181,[System.Int32]78))
$TextBoxTime.Name = [System.String]'TextBoxTime'
$TextBoxTime.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]136,[System.Int32]21))
$TextBoxTime.TabIndex = [System.Int32]0
#
#ButtonCountdown
#
$ButtonCountdown.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]8.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$ButtonCountdown.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]181,[System.Int32]121))
$ButtonCountdown.Name = [System.String]'ButtonCountdown'
$ButtonCountdown.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]174,[System.Int32]75))
$ButtonCountdown.TabIndex = [System.Int32]1
$ButtonCountdown.Text = [System.String]'Launch'
$ButtonCountdown.UseCompatibleTextRendering = $true
$ButtonCountdown.UseVisualStyleBackColor = $true
$ButtonCountdown.add_Click($LaunchCountdown)
#
#LabelEndTime
#
$LabelEndTime.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]8.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LabelEndTime.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]76))
$LabelEndTime.Name = [System.String]'LabelEndTime'
$LabelEndTime.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]169,[System.Int32]23))
$LabelEndTime.TabIndex = [System.Int32]2
$LabelEndTime.Text = [System.String]'End Time hh:mm'
$LabelEndTime.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
$LabelEndTime.UseCompatibleTextRendering = $true
#
#LabelMessage
#
$LabelMessage.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Tahoma',[System.Single]8.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LabelMessage.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]39,[System.Int32]43))
$LabelMessage.Name = [System.String]'LabelMessage'
$LabelMessage.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]136,[System.Int32]23))
$LabelMessage.TabIndex = [System.Int32]3
$LabelMessage.Text = [System.String]'Message'
$LabelMessage.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
$LabelMessage.UseCompatibleTextRendering = $true
#
#TextBoxmessage
#
$TextBoxmessage.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]181,[System.Int32]43))
$TextBoxmessage.Name = [System.String]'TextBoxmessage'
$TextBoxmessage.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]326,[System.Int32]21))
$TextBoxmessage.TabIndex = [System.Int32]4
#
#FormSetCountdown
#
$FormSetCountdown.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]520,[System.Int32]225))
$FormSetCountdown.Controls.Add($TextBoxmessage)
$FormSetCountdown.Controls.Add($LabelMessage)
$FormSetCountdown.Controls.Add($LabelEndTime)
$FormSetCountdown.Controls.Add($ButtonCountdown)
$FormSetCountdown.Controls.Add($TextBoxTime)
$FormSetCountdown.Text = [System.String]'Final Countdown'
$FormSetCountdown.ResumeLayout($false)
$FormSetCountdown.PerformLayout()
Add-Member -InputObject $FormSetCountdown -Name base -Value $base -MemberType NoteProperty
Add-Member -InputObject $FormSetCountdown -Name TextBoxTime -Value $TextBoxTime -MemberType NoteProperty
Add-Member -InputObject $FormSetCountdown -Name ButtonCountdown -Value $ButtonCountdown -MemberType NoteProperty
Add-Member -InputObject $FormSetCountdown -Name LabelEndTime -Value $LabelEndTime -MemberType NoteProperty
Add-Member -InputObject $FormSetCountdown -Name LabelMessage -Value $LabelMessage -MemberType NoteProperty
Add-Member -InputObject $FormSetCountdown -Name TextBoxmessage -Value $TextBoxmessage -MemberType NoteProperty
}
. InitializeComponent
