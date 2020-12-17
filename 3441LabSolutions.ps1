#region Lab 1
$targets = Import-csv .\Winhosts.csv | 
    Where-Object os -eq Win10 | Select-Object -ExpandProperty ip

$ht = @{
    ReferenceObject = Import-Csv .\Win10BaselineProcs.csv
    Property = "hash","path"
    PassThru = $true
}

$current = Survey-Processes -ComputerName $targets -Credential $creds

ForEach ($ip in $targets) {
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip}| 
            Sort-Object -Property hash, path –Unique
    Compare-Object @ht | 
        Where-Object {$_.sideindicator –eq “=>” –and $_.path –ne $null} | 
            Select-Object pscomputername, path, hash, sideindicator  (NOTE: Optional)
} #end of foreach loop  

$targets = Import-csv .\Winhosts.csv | Select-Object -ExpandProperty ip
$ht = @{
    ReferenceObject = Import-Csv .\LocalAccountBaseline.csv
    Property = "name"
    PassThru = $true
}
$current = Survey-Accounts -ComputerName $targets -Credential $creds

ForEach ($ip in $targets) {
    $ht.DifferenceObject = $current |
        Where-Object {$_.pscomputername -eq $ip} |
            Sort-Object -Property name -Unique
    Compare-Object @ht | 
        Where-Object {$_.sideindicator –eq “=>”}
} #foreach loop

$targets = Import-csv .\Winhosts.csv | 
    Where-Object os -eq Win7 | Select-Object -ExpandProperty ip
$ht = @{
    ReferenceObject = Import-Csv .\Win7ServiceBaseline.csv
    Property = "name"
    PassThru = $true
}
$current = Survey-Services -ComputerName $targets -Credential $creds
ForEach ($ip in $targets) {
    $ht.DifferenceObject = $current | 
        Where-Object {$_.pscomputername -eq $ip} | 
            Sort-Object -Property name -Unique
    Compare-Object @ht | 
        Where-Object {$_.sideindicator –eq “=>”}
} #foreach loop

$targets = Import-csv .\Winhosts.csv | 
    Where-Object os -eq "Win Server 2012R2" | Select-Object -ExpandProperty ip
$ht = @{
    ReferenceObject = Import-Csv .\WinServer2012AutoBaseline.csv
    Property = "hash"
    PassThru = $true
}
$autoruns = Get-Content .\autorunkeys.txt
$current = Survey-Autoruns -ComputerName $targets -Credential $creds –RegistryAutoRunLoc $autoruns
ForEach ($ip in $targets) {
    $ht.DifferenceObject = $current | 
        Where-Object {$_.pscomputername -eq $ip} | 
            Sort-Object -Property hash -Unique
    Compare-Object @ht | 
        Where-Object {$_.sideindicator –eq “=>”}
} #foreach loop

$targets = Import-csv .\Winhosts.csv | 
    Where-Object os -eq Win10 | Select-Object -ExpandProperty ip
$ht = @{
    ReferenceObject = Import-Csv .\Win10FirewallBaseline.csv
    Property = "direction", "action", "localAddress", "remoteaddress", "localport",
               "remoteport"
    PassThru = $true
}
$current = Survey-Firewall -ComputerName $targets -Credential $creds
ForEach ($ip in $targets) {
    $ht.DifferenceObject = $current | 
        Where-Object {$_.pscomputername -eq $ip} | 
            Sort-Object -Property "direction", "action", "localAddress", 
                           "remoteaddress", "localport", "remoteport" -Unique
    Compare-Object @ht | 
        Select-Object -Property *, @{n = "IP"; e = {"$IP"}} 
} #foreach loop

#endregion

#region Lab 2

$targets = Import-Csv .\winhosts.csv | 
    Where-Object os -eq Win10 | Select-Object -ExpandProperty ip
$targets.count
$procs = Survey-Processes -ComputerName $targets -Credential $creds
$procs | Sort-Object -Unique pscomputername, hash | 
    Group-Object hash | 
        Where-Object count –lt 2 |
            Select-Object –ExpandProperty Group

$svcs | Sort-Object -Unique pscomputername, name |
Group-Object name | 
    Where-Object count –lt 2 | 
        Select-Object –ExpandProperty Group
        
$targets = Import-Csv .\winhosts.csv | 
    Where-Object os –eq “Win Server 2012R2” | Select-Object -ExpandProperty ip
$targets.count
$auto = Survey-AutoRuns -ComputerName $targets -Credential $creds ↵
                        –RegistryAutoRunLoc (Get-Content .\AutoRunKeys.txt)
$auto | Sort-Object -Unique pscomputername, hash | 
    Group-Object hash | 
        Where-Object count –lt 2 | 
            Select-Object –ExpandProperty Group
    
#endregion

#region Lab 3
Invoke-Command -ComputerName "ws16.vaoc.net" -Credential $creds –Scriptblock {
    $logfilter = @{
        LogName = "Security"
        ID = 4720
    } #End $logfilter
    Get-WinEvent -FilterHashtable $logfilter
} | select-object RecordID, Message | Format-Table -wrap


Invoke-Command -ComputerName ws16.vaoc.net -Credential $creds {
    $logfilter = @{
        LogName   = "Security"
        ID        = 4728,4732,4756
        starttime = (Get-Date).AddDays(-1)  
        data      = "<SID>"  
    }
    Get-WinEvent -FilterHashtable $logfilter | 
        Where-Object message -like "*<SID>*"  
} | select-object RecordID, Message

Invoke-Command –ComputerName ws13.vaoc.net –Credential $creds –ScriptBlock {
    Get-WinEvent –FilterHashtable @{Logname = "*fire*"; ID=2004} 
} | Select-Object TimeCreated, RecordID, Message 

(Invoke-Command -ComputerName ws5.vaoc.net -Credential $creds -ScriptBlock {
    Get-WinEvent -FilterHashtable @{
        Logname = Security
        ID      = 4624
        StartTime = [datetime]"02/25/2020 00:00:00Z"
        EndTime   = [datetime]"02/25/2020 23:59:59Z"
    } # FilterHashtable
}).count # ScriptBlock 

#endregion

#region Lab 4
$session = New-PSSession -ComputerName WS20.vaoc.net -Credential $creds
Copy-Item -Path .\last_first.txt -ToSession $session -Destination C:\Users\Student\lastname_first.txt
Remove-PSSession -Session $session 

$session = New-PSSession -ComputerName WS20.vaoc.net -Credential $creds
Copy-Item -Path C:\Users\Student\lastname_first.txt -Destination .\last_first.txt -FromSession $session 
Remove-PSSession -Session $session 

#endregion

#region Lab 5
Invoke-Command -ComputerName FSVR1.vaoc.net -Credential $creds -ScriptBlock {
    $expression = "\d{3}-\d{2}-\d{4}"
    $filepath = "C:\users\student\share"
    Get-ChildItem $filepath -Recurse –File | 
        Select-String –Pattern $expression –AllMatches | 
            Format-Table Path, line -Wrap
}

$expression = "[\w\.-]+@[\w\.-]+\.[\w]{2,3}"  

$SSN = "\d{3}-\d{2}-\d{4}"
$Email = "[\w\.-]+@[\w\.-]+\.[\w]{2,3}"
$KeyWords = "(?=.*Str1)(?=.*Str2 |.*Str3)"

#endregion