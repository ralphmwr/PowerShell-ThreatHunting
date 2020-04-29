$lab2 = {
    $name = Read-Host -Prompt "Enter your name"
    "Hello " + $name + "!"
    "Hello $name!"
    "Hello {0}!" -f $name
}

$lab3 = {
    import-module .\ObjectLab.psm1
    $canine = New-Canine
    $canine.breed = "Golden"
    $canine.Size  = "Large"
    $canine.color = $MyCar.Color 
    $ht = @{myauto = $MyCar; mydog=$canine}
    $custom = [pscustomobject]$ht
    $custom2 = new-object -TypeName psobject -Property $ht
}

$lab4 = {
    [int]$a = Read-Host "Enter length of side a"
    [int]$b = Read-Host "Enter length of side b"
    "The area of the rectangle is $($a * $b)"
    "The area of the rectangle is " + ($a * $b)
    "The area of the rectangle is {0}" -f ($a * $b)

}

$lab5 = {
    $counter = 1
    while ($counter -le 21) {"WS$counter.vaoc.net"; $counter++}

    foreach ($item in 1..21) {"WS$item.vaoc.net"}

    1..21 | ForEach-Object {"WS$_.vaoc.net"}
}

$lab6 = {
    foreach ($item in 1..21) {
        switch (Test-Connection -ComputerName "WS$item.vaoc.net" -Count 1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty responsetimetolive) {
            {$_ -lt 65}      {"OS for WS$item is Linux"}
            {$_ -in 65..128} {"OS for WS$item is Windows"}
            default          {"OS for WS$item is Unknown"}
        }
    }
}

$lab7 = {
    $arp = foreach ($line in (arp -a)) {
        if ($line -eq "" -or $line -like "*Inter*") {Continue}
        $IP, $MAC, $type = -split $line
        [pscustomobject]@{ip=$ip;mac=$MAC;type=$type}
    }    
}

#region Lab8
function FloorSqRt([int]$x)
{
    if ($x -le 1) {return $x}
    $i = 1
    $result = 1
    while ($result -lt $x)
    {
        $i++
        $result = $i * $i
    }
    $i
}
function Calculate-Hypotenuse ($SideA, $SideB)
{
    FloorSqRt -x ($SideA * $SideA + $SideB * $SideB)
}
#endregion

$lab13 = {
    Get-Process | Sort-Object ID
    Get-LocalUser | Sort-Object SID -Descending
    Get-Process | Select-Object ID, Name, Path
    Get-LocalUser | Select-Object name, passwordlastset, @{n="Password Age";e={(Get-Date) - $_.passwordlastset}}
    Get-ChildItem -Path C:\Users\student\Documents -File | Select name, @{n="read_WO_change";e={$_.lastaccesstime -eq $_.lastwritetime}}
}

$lab14 = {
    Import-Csv -Path .\WinHosts.csv | Where-Object subnet -EQ "Vault"
    Import-Csv -Path .\WinHosts.csv | Where-Object {$_.os -eq "Win10" -and $_.hostname -ne "WS19"}
    Get-Process | Where-Object {$_.StartTime -gt ((Get-Date).AddHours(-1))}
    Get-LocalUser | Where-Object {$_.passwordexpires -lt ((Get-Date).AddDays(7))}
}

