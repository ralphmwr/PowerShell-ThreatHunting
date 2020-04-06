function Survey-Firewall
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]
        $ComputerName,

        [pscredential]
        $Credential
    ) # param
    Begin
    {
        If (!$Credential) {$Credential = Get-Credential}
    } # Begin
    Process
    {
        Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
            $rules         = Get-NetFirewallRule | Where-Object {$_.enabled}
            $portfilter    = Get-NetFirewallPortFilter
            $addressfilter = Get-NetFirewallAddressFilter

            foreach ($rule in $rules) {
                $ruleport    = $portfilter | Where-Object {$_.InstanceID -eq $rule.instanceid}
                $ruleaddress = $addressfilter | Where-Object {$_.InstanceID -eq $rule.instanceid}
                $data = @{
                    InstanceID    = $rule.instanceid.tostring()
                    Direction     = $rule.direction.tostring()
                    Action        = $rule.action.tostring()
                    LocalAddress  = $ruleaddress.LocalAddress.tostring()
                    RemoteAddress = $ruleaddress.RemoteAddress.tostring()
                    Protocol      = $ruleport.Protocol.tostring()
                    LocalPort     = $ruleport.LocalPort -join ","
                    RemotePort    = $ruleport.RemotePort -join ","
                } # data hashtable
                New-Object -TypeName psobject -Property $data
            } # foreach rule
        } # Invoke-Command ScriptBlock
    } # Process
} # function Survey-Firewall

function Survey-Autoruns
{
    [cmdletbinding()]
    Param 
    (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]
        $ComputerName,

        [pscredential]
        $Credential

    )# param
    Begin
    {
        If (!$Credential) {$Credential = Get-Credential}
    } # Begin
    Process
    {
        Invoke-Command -ComputerName $ComputerName -Credential $Credential  -ScriptBlock {
            $autorundirs = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\startup",
                           "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\startup"
            foreach ($dir in $autorundirs) {
                foreach ($file in Get-ChildItem $dir -Recurse -Attributes !Directory -Force) {
                    $hash = If (Get-Command Get-FileHash) {(Get-FileHash $file.fullname).hash}
                            else {(certutil.exe -hashfile $file.fullname SHA256)[1] -replace " ",""}
                    $data = @{
                        type     = "AutoRun Directory"
                        file     = $file.FullName
                        hash     = $hash
                        location = $dir
                        command  = ""
                    } # data hashtable
                    New-Object -TypeName psobject -Property $data
                } #foreach file
            } # foreach dir
            foreach ($location in $using:RegistryAutoRunLoc) {
                if (!(Test-Path $location)) {continue}
                $reg = Get-Item -Path $location -ErrorAction SilentlyContinue
                foreach ($key in $reg.getvaluenames()) {
                    $command = $reg.GetValue($key)
                    $file = $command -replace '\"',"" -replace "\.exe.*",".exe"
                    $hash = If (Get-Command Get-FileHash) {(Get-FileHash $file).hash}
                            else {(certutil.exe -hashfile $file SHA256)[1] -replace " ",""}
                    $data = @{
                        type     = "AutoRun Registry"
                        file     = $file
                        hash     = $hash
                        location = "$location\$key"
                        command  = $command
                    } # data hashtable
                    New-Object -TypeName psobject -Property $data
                } # foreach key
            } # foreach autorunreg
        } # Invoke-Command ScriptBlock
    } # Process 
} # function Survey-Autoruns

function Survey-Accounts 
{
    [cmdletbinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]
        $ComputerName,

        [pscredential]
        $Credential
    ) # param
    Begin
    {
        If (!$Credential) {$Credential = Get-Credential}
    } # Begin
    Process
    {
        Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
            Get-WmiObject win32_UserAccount | 
                Select-Object AccountType,
                              Name,
                              LocalAccount,
                              Domain,
                              SID
        } # Invoke-Command ScriptBlock
    } # Process
} # Survey-Accounts function

function Survey-Services 
{
    [cmdletbinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]
        $ComputerName,

        [pscredential]
        $Credential
    ) # param
    Begin
    {
        If (!$Credential) {$Credential = Get-Credential}
    } # Begin
    Process
    {
        Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
            Get-WmiObject win32_Service | 
                Select-Object Name,
                              PathName,
                              State,
                              StartMode,
                              StartName
        } # Invoke-Command ScriptBlock
    } # Process
} # Survey-Services function

function Survey-Processes 
{
    [cmdletbinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]
        $ComputerName,

        [pscredential]
        $Credential
    ) # param
    Begin
    {
        If (!$Credential) {$Credential = Get-Credential}
    } # Begin
    Process
    {
        Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
            Get-WmiObject win32_Process | 
                Select-Object Name,
                              ProcessID,
                              Path,
                              CommandLine,
                              @{name       = "hash"
                                expression = {If (Get-Command Get-FileHash) {(Get-FileHash $file).hash}
                                              else {(certutil.exe -hashfile $file SHA256)[1] -replace " ",""}}
                              } # Hash hashtable,
                              @{name       = "Process_Owner"
                                expression = {@($_.getowner().domain, $_.getowner().user) -join "\"}
                              } # Process_Owner hashtable
        } # Invoke-Command ScriptBlock
    } # Process
} # Survey-Processes function

function Survey-FileHash 
{
    [cmdletbinding()]
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [string[]]
        $ComputerName,

        [pscredential]
        $Credential,

        [Parameter(Mandatory=$true)]
        [string]
        $path
    ) # param
    Begin
    {
        If (!$Credential) {$Credential = Get-Credential}
    } # Begin
    Process
    {
        Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
            Get-ChildItem -Attributes !Directory -Path $using:Path -Force |
                Select-Object Name,
                              @{name       = "hash"
                                expression = {If (Get-Command Get-FileHash) {(Get-FileHash $_.FullName).hash}
                                              else {(certutil.exe -hashfile $_.FullName SHA256)[1] -replace " ",""}}
                              } # Hash hashtable,
        } # Invoke-Command ScriptBlock
    } # Process
} # Survey-FileHash function


Export-ModuleMember Survey-Accounts,
                    Survey-Autoruns,
                    Survey-FileHash,
                    Survey-Firewall,
                    Survey-Processes,
                    Survey-Services
