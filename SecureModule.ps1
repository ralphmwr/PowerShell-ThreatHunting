#region Lab1 Baseline Processes
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win10"} | Select-Object -ExpandProperty IP
$ht = @{
    ReferenceObject  = Import-Csv .\Win10BaselineProcs.csv
    DifferenceObject = $null  #I added this initially because that's the way we taught compare-object.  We tested by removing and still had errors.
    Property         = "hash","path"
    PassThru         = $True
}
$current = Survey-Processes -ComputerName $targets -Credential $creds

ForEach ($ip in $targets) {
    $ht.differenceobject = $current | Where-Object {$_.pscomputername -eq $ip} | Sort-Object -Property hash,path -Unique
    Compare-Object @ht | Where-Object {$_.sideindicator -eq "=>" -and $_.path -ne $null} 
}#end of foreach loop
#endregion

#region Lab1 Baseline Accounts
$targets = Import-csv .\Winhosts.csv | Select-Object -ExpandProperty IP
$ht = @{
    ReferenceObject  = Import-Csv .\LocalAccountBaseline.csv
    DifferenceObject = $null  #I added this initially because that's the way we taught compare-object.  We tested by removing and still had errors.
    Property         = "name"
    PassThru         = $True
}
$current = Survey-Accounts -ComputerName $targets -Credential $creds

ForEach ($ip in $targets) {
    $ht.differenceobject = $current | Where-Object {$_.pscomputername -eq $ip} | Sort-Object -Property name -Unique
    Compare-Object @ht | Where-Object {$_.sideindicator -eq "=>"} 
}#end of foreach loop
#endregion

#region Lab1 Baseline Services
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win7"} | Select-Object -ExpandProperty IP
$ht = @{
    ReferenceObject  = Import-Csv .\Win7ServiceBaseline.csv
    DifferenceObject = $null  #I added this initially because that's the way we taught compare-object.  We tested by removing and still had errors.
    Property         = "name"
    PassThru         = $True
}
$current = Survey-Services -ComputerName $targets -Credential $creds

ForEach ($ip in $targets) {
    #code in Instructor notes differs between labs...not sure if it was just an old version way of doing it
    #previous code: 
    #$diff = $current | Where-Object {$_.pscomputername -eq $ip} | Sort-Object -Property name -Unique
    #Compare-Object @ht -DifferenceObject $diff | Where-Object {$_.sideindicator -eq "=>"} 
    #current code:
    $ht.differenceobject = $current | Where-Object {$_.pscomputername -eq $ip} | Sort-Object -Property name -Unique
    Compare-Object @ht | Where-Object {$_.sideindicator -eq "=>"} 
}#end of foreach loop
#endregion

#region Lab1 Baseline AutoRuns
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win Server 2012R2"} | Select-Object -ExpandProperty IP
$ht = @{
    ReferenceObject  = Import-Csv .\WinServer2012AutoBaseline.csv
    DifferenceObject = $null  #I added this initially because that's the way we taught compare-object.  We tested by removing and still had errors.
    Property         = "hash"
    PassThru         = $True
}
$current = Survey-AutoRuns -ComputerName $targets -Credential $creds -RegistryAutoRunLoc (get-content .\AutoRunKeys.txt)

ForEach ($ip in $targets) {
    #code in Instructor notes differs between labs...not sure if it was just an old version way of doing it
    #previous code: 
    #$diff = $current | Where-Object {$_.pscomputername -eq $ip} | Sort-Object -Property name -Unique
    #Compare-Object @ht -DifferenceObject $diff | Where-Object {$_.sideindicator -eq "=>"} 
    #the way we copied and ran in class:
    $ht.differenceobject = $current | Where-Object {$_.pscomputername -eq $ip} | Sort-Object -Property hash -Unique
    Compare-Object @ht | Where-Object {$_.sideindicator -eq "=>"} 
}#end of foreach loop
#endregion

#region Lab1 Baseline Firewall
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win10"} | Select-Object -ExpandProperty IP
$ht = @{
    ReferenceObject  = Import-Csv .\Win10Firewall.csv
    DifferenceObject = $null  #I added this initially because that's the way we taught compare-object.  We tested by removing and still had errors.
    Property         = "direction","action","localaddress","remoteaddress","localport","remoteport"
    PassThru         = $True
}
$current = Survey-Firewall -ComputerName $targets -Credential $creds

ForEach ($ip in $targets) {
    #code in Instructor notes differs between labs...not sure if it was just an old version way of doing it
    #previous code: 
    #$diff = $current | Where-Object {$_.pscomputername -eq $ip} | 
        #Sort-Object -Property direction,action,localaddress,remoteaddress,localport,remoteport -Unique
    #Compare-Object @ht -DifferenceObject $diff  
    #the way we copied and ran in class:
    $ht.differenceobject = $current | Where-Object {$_.pscomputername -eq $ip} | 
        Sort-Object -Property direction,action,localaddress,remoteaddress,localport,remoteport -Unique
    Compare-Object @ht | Select-Object -Property *,@{n="IP";e={"$IP"}} 
}#end of foreach loop
#endregion

#region Lab2 LFA Windows 10 Processes
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win10"} | Select-Object -ExpandProperty IP
#$targets.count * .1 (10% example)
$procs = Survey-Processes -ComputerName $targets -Credential $creds
$procs | sort -Unique pscomputername, hash | Group-Object hash | Where-Object count -lt 2 |Select-Object -ExpandProperty Group
#endregion 

#region Lab2 LFA Windows 7 Services
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win7"} | Select-Object -ExpandProperty IP
#$targets.count * .1 (10% example)
$svcs = Survey-Services -ComputerName $targets -Credential $creds
#We changed pathname to name to help ease the students
$svcs | sort -Unique pscomputername, name | Group-Object name | Where-Object count -lt 2 |Select-Object -ExpandProperty Group
#endregion 

#region Lab2 LFA Windows Server 2012 AutoRuns
$targets = Import-csv .\Winhosts.csv | Where-Object {$_.os -eq "Win Server 2012R2"} | Select-Object -ExpandProperty IP
#$targets.count * .1 (10% example)
$auto = Survey-AutoRuns -ComputerName $targets -Credential $creds -RegistryAutoRunLoc (get-content .\AutoRunKeys.txt)
$auto | sort -Unique pscomputername,hash | Group-Object hash | Where-Object count -lt 2 |Select-Object -ExpandProperty Group
#endregion 

#region Lab3 New User
$On_Target = @{
    ComputerName = "ws16.vaoc.net"
    Credential   = $creds
}#end of $On_Target
Invoke-Command @On_Target {
    $logfilter         = @{}
    $logfilter.logname = "Security"
    $logfilter.ID      = 4720
    Get-WinEvent -FilterHashtable $logfilter
} | Select-Object RecordID,Message |format-table -wrap
#endregion

#region Lab3 Security Group
$On_Target = @{
    ComputerName = "ws16.vaoc.net"
    Credential   = $creds
}#end of $On_Target
Invoke-Command @On_Target {
    $logfilter         = @{}
    $logfilter.logname = "Security"
    $logfilter.ID      = 4728,4732,4756
    Get-WinEvent -FilterHashtable $logfilter |Where-Object message -like "*<SID>*"
} | Select-Object RecordID,Message |format-table -wrap
#endregion

#region Lab3 New Firewall Rule
$On_Target = @{
    ComputerName = "ws13.vaoc.net"
    Credential   = $creds
}#end of $On_Target
Invoke-Command @On_Target {
    $logfilter         = @{}
    $logfilter.logname = "*fire*"
    $logfilter.ID      = 2004
    Get-WinEvent -FilterHashtable $logfilter
} | Select-Object TimeCreated,RecordID,Message |format-table -wrap
#endregion

#region Lab3 Successful Logons
$On_Target = @{
    ComputerName = "ws5.vaoc.net"
    Credential   = $creds
}#end of $On_Target
(Invoke-Command @On_Target {
    $logfilter           = @{}
    $logfilter.logname   = "Security"
    $logfilter.ID        = 4624
    $logfilter.starttime = [datetime]"04/14/2020 00:00:00Z"
    $logfilter.endtime   = [datetime]"04/14/2020 23:59:59Z"
    Get-WinEvent -FilterHashtable $logfilter
}).count
#endregion

#region Lab4 Copy TO Remote Machine
$session = New-PSSession -ComputerName ws20.vaoc.net -Credential $creds
Copy-Item -path .\last_first.txt -ToSession $session -Destination C:\Users\Student\lastname_first.txt
Remove-PSSession $session
#endregion

#region Lab4 Copy FROM Remote Machine
$session = New-PSSession -ComputerName ws20.vaoc.net -Credential $creds
Copy-Item -path c:\users\student\lastname_first.txt -FromSession $session -Destination .\last_firstnew.txt
Remove-PSSession $session
#endregion

#region Lab5 Regular Expressions
Invoke-Command -ComputerName fsvr1.vaoc.net -Credential $creds -ScriptBlock {
    $expression = "\d{3}-\d{2}-\d{4}"  #SSN
    $expression = "[\w\.-]+@[\w\.-]+\.[\w]{2,3}"  #Email Address
    $expression = "(?=.*Power Stone)(?=.*xandar|.*Nova Corps) "  #Text search of "A" & "B or C"
    $filepath   = "C:\users\student\share"
    Get-ChildItem $filepath -Recurse -File |
        Select-String -Pattern $expression -AllMatches | format-table Path, line -wrap
}
#endregion
