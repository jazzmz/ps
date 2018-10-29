$dir="C:\test\convertfrombase64"
clear-Host
$basestr=Get-Content "$dir\parsed.log"
$b  = [System.Convert]::FromBase64String($basestr)
set-content -encoding byte "$dir\out_d.log" -value $b