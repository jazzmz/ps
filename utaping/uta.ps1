Clear-Host
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted

$address = "172.22.23.44"
$i=0
$chf=$false
$PSEmailServer="mail.pirbank.ru"
$from="notify@pirbank.ru"
$to="bis@pirbank.ru"
$subject="Тема письма"
$encoding=[System.Text.Encoding]::UTF8
#$prog="c:\windows\system32\notepad.exe"
$service="UtaService"
#$debugcount=0

#$debugcount++; echo "Point $debugcount"

get-wmiobject win32_process -filter "name='powershell.exe'" | % {
    $res=$false
    $res = $_.commandline | Select-String "uta.ps1"
    if ($res){
        $i++
    }
}
if ($i -gt 1) {exit} 

#$debugcount++; echo "Point $debugcount"

$badres=Test-Connection -count 1 -quiet $address
#$debugcount++; echo "Point $debugcount"

if (!$badres) {
    $elapsed = [System.Diagnostics.Stopwatch]::StartNew()
    while ((!$badres) -and ($elapsed.elapsed.Minutes -lt 1)) {
        $badres=Test-Connection -count 1 -quiet $address
        echo $elapsed.elapsed.seconds
        $totalsecs=[System.Math]::Round($elapsed.elapsed.Totalseconds,0)
        if ($totalsecs -gt 60) {$chf=$true}
    }
    $elapsed.Stop()
}

#$debugcount++; echo "Point $debugcount";

if ($chf) {
    echo "actions..."
    #Get-Process | % {if ($_.Path -eq $prog){$_.Kill()}}
    #Get-Service | %{ if ($_.Name -eq $service){Stop-Service -force $_.Name}}
    & net stop $service
    $date=Get-Date
    $body="Отключилось в $date"
    Send-MailMessage -From $from -Subject $subject -To $to -Encoding $encoding -Body $body
    while (!$badres){
        $badres=Test-Connection -count 1 -quiet $address
    }
    & net start $service
    #Start-Process $prog
    $date=Get-Date
    $body="Включилось в $date"
    Send-MailMessage -From $from -Subject $subject -To $to -Encoding $encoding -Body $body

}
else{
    $res=$false
    Get-Process | % {if($_.Path -eq $prog){$res=$true}}
    if (!$res) { 
        #Start-Process $prog
        #Get-Service | %{ if ($_.Name -eq $service){Start-Service $_.Name}}
        & net start $service
        $date=Get-Date
        $body="Включилось в $date"
        Send-MailMessage -From $from -Subject $subject -To $to -Encoding $encoding -Body $body
    }
}


#sleep 10