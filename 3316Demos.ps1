#region Variables/Interpolation
$strEmail = "joe.smith.102@us.af.mil"
$flt = 3.14159265359

"Send an email to $strEmail and tell him the value of pi is $flt"
"You can also tell him 22/7 = $(22/7)"

'$strEmail is your email'
#endregion

#region Concat/Format
"Send an email to " + $strEmail + " and tell him the value of PI is $fltpi"
"You can also tell him 22/7 = {0:C2}" -f $(22/7)

#endregion

#region Arithmetic Operators

# +
6 + 2
"Hello " + "World"
@(1,'one') + @(2,'two')
@{"ip"="10.0.5.25"} + @{"host" = "WinSvr"}

# -
6 - 2
-6

# *
6 * 2
"What! " * 3
"Hello", ("World" * 4)

# /
6 / 2

# %
7 % 2

#endregion

#region Assignment Operators

# =
$a = 6 * 2
$a = $a + 3

# +=
$a += 3; $a
$b = 1,2; $b += 3; $b
$c = "Hello "; $c += "World!"; $c

# -=
$a -= 2; $a

# *= 
$a *= 5; $a
$c *= 3; $c

# /=
$a /= 5; $a

# %=
$a %= 7; $a

# ++
$a++; $a

# --
$a--; $a

#endregion

#region split/join

$myarray = "www.mysite.com/myfolder/myfolder2/index.htm" -split "/"
$myarray
$myarray[-1]
-split "The   quick brown
fox jumped   over the lazy dog. Sir!"

"The   quick brown
fox jumped   over the lazy dog. Sir!" -split " "

$ip, $port = "192.168.39.1:445" -split ":"
$ip
$port

$myIP = $ip, $port -join ":"
$myIP

-join ($ip, $port)

#endregion

#region Special Operators

# Array Subexpression @()
$d = @("Hello")
$d.GetType()
$d += "World"
$d

$e = @()
$e
$e.GetType()

# Comma ,
$f = , "Hello" 
$f
$f.GetType()

# Cast [type]
[int]$x = 5
$x
$x.GetType()

[string[]]$myarray = "Jamie","Mike","Ryan","Lt Hicks"
$myarray.GetType()
$myarray2 = "Jamie","Mike","Ryan","Lt Hicks"
$myarray2.GetType()

# Index [x]
$myEmail = "joe.smith.250.ctr@us.af.mil" -split "@"
$myEmail
$myEmail.GetType()

$Domain = $myEmail[-1]
$Account = $myEmail[0]
$Domain
$Account

$strGreeting = "Hello World!"
$strGreeting[0]
$strGreeting[3]
$strGreeting[-2]

#Script Block
$sb = {
    $name = Read-Host "What is your name"
    2 + 2
    "Hello $name"
}
$sb
$sb.GetType()
$sb.Invoke()

# Property Dereference .
"Hello".Length
$d
$d.Count
$d[0].Length

# Range ..
1..1000
10..1
$range = 0..32
$range
$range.GetType()
$range[6]
$range[6].GetType()

#endregion

#region Comparison Operators
5 -eq 5
5 -ne 5
4 -gt 3
4 -ge 4
4 -lt 4
4 -le 4

"Hello World" -like "Hello*"
"Hello World" -notlike "ello*"

"555-867-5309" -match "\d{3}-\d{2}-\d{4}"
"123-45-6789" -match "\d{3}-\d{2}-\d{4}"

$evilips = "10.0.5.35","10.0.5.36","10.0.5.55"
"10.0.5.35" -in $evilips
"10.0.5.35" -notin $evilips


#endregion

#region Logical Operators

(1 -eq 1) -and (1 -eq 2)
(1 -eq 1) -and !(1 -eq 2)

(1 -eq 1) -or (1 -eq 2)


#endregion

#region Loops

$Lyrics = "What", "Who", "Slim Shady"

# While
$count = 0
while ($count -lt 3)
{
    "My name is {0}" -f $Lyrics[$count]
    $count++
}

# foreach
foreach ($word in $Lyrics)
{ "My name is $word" }

# foreach-object
$Lyrics | ForEach-Object { "My name is $PSItem"}
$Lyrics | % {"My name is $_"}

#endregion

#region Break/Continue
$nostrike = 5, 9, 11, 20
foreach ($item in 1..21) {
    if ($item -in $nostrike){continue}
    "WS$item.vaoc.net"
}
"I'm done"
#endregion

#region Parameters/Arguments
Get-Process -Name lsass, explorer -ComputerName localhost

Get-Process -N lsass, explorer 

Set-ItemProperty '.\winhosts.csv' isreadonly $true

Set-ItemProperty -Path '.\winhosts.csv' -Name isreadonly -Value $true

Get-Service winRM

[pscustomobject]@{name="WinRM"; somethingelse="Jamie"} | Get-Service

"WinRM" | Get-Service

#endregion

