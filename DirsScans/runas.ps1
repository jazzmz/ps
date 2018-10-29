$dir="C:\test\DirsScans"
<#
$flag=Test-Path "$env:USERPROFILE\flagtest"
if (!$flag){
    & runas /savecred /user:"PIRBANK\test" "notepad"
    exit
}
#>

if ($env:username -ne "test3")
{
    #& runas /savecred /user:"PIRBANK\test3" "powershell C:\test\DirsScans\runas.ps1"
    & runas /user:"PIRBANK\test3" "powershell C:\test\DirsScans\runas.ps1"
    echo "$env:username"
}

else

{
    $date=Get-Date
    echo $date >> "C:\test\DirsScans\log.log"
    & notepad
}