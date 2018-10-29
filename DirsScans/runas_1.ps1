$dir="C:\test\DirsScans"

if ($env:username -ne "test3")
{
    & runas /savecred /user:"PIRBANK\test3" powershell #-File "C:\test\DirsScans\runas.ps1"
    echo "$env:username"
}

else

{
    echo "lol" > "C:\test\DirsScans\log.log"
    & notepad
}