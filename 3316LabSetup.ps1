If (!$creds) {
    $pass = ConvertTo-SecureString -AsPlainText "ST@dm1n!ST@dm1n!" -Force
    $creds = [pscredential]::new("vaoc.net\student",$pass)
}

function survey-changettl {
  param(
    [string]$ComputerName,
    [pscredential]$credentials,
    [switch]$default,
    [switch]$newttl
  )

# or PS-Remote into box (WS1.vaoc.net)
  Invoke-Command -computername $ComputerName -Credential $creds -ScriptBlock {
    cd "HKLM:\system\CurrentControlSet\services\tcpip\Parameters\"
    if ($using:default) {
      Set-ItemProperty -Name "DefaultTTL" -Value 128 -path "HKLM:\system\CurrentControlSet\services\tcpip\Parameters\"
      "Setting TTL to 128"
    }
    elseif ($using:newttl) {
      Set-ItemProperty -Name "DefaultTTL" -Value 254 -path "HKLM:\system\CurrentControlSet\services\tcpip\Parameters\"
      "Setting TTL to 254"
    }
    "Rebooting Computer.  Wait 30 seconds for results"
    restart-computer
  }

  start-sleep -Seconds 30
    $ping = test-connection -computername $ComputerName -count 1 -erroraction SilentlyContinue
    start-sleep -seconds 4
    "$ComputerName response time to live is $($ping.responsetimetolive)"
}

function lab-setup 
{
    param(
        [pscredential]$Credentials
    )
    survey-changettl -ComputerName ws4.vaoc.net -credentials $Credentials -newttl
    
}


function lab-clear 
{
    param(
        [pscredential]$Credentials
    )
    survey-changettl -ComputerName ws4.vaoc.net -credentials $Credentials -default
    
}