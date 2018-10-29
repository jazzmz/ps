$flag=$false
$date=Get-Date
$PSEmailServer="mail.pirbank.ru"
$from="notify@pirbank.ru"
$to="bis@pirbank.ru"
$subject="Запущен АРМ КБР"
$body="АРМ КБР забущен $date"
$encoding=[System.Text.Encoding]::UTF8
 
 Clear-Host

get-process | foreach {
            if ($_.Name -eq "uarm")
                        {
                                   $flag=$true
                        }
            } 
if (!$flag)
{
            & C:\uarm2\bin\uarm.exe
            Send-MailMessage -From $from -Subject $subject -To $to -Encoding $encoding -Body $body
}
