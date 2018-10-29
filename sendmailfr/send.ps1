
$PSEmailServer="mail.pirbank.ru"
$utf8=[System.Text.Encoding]::UTF8
$to="ddorkin@pirbank.ru"
$subject="Terminal 10354346."
$from="noreply@qiwi1.com"
#$attach="C:\test\sendmailfr\attach.txt"
$bodyfile="C:\test\sendmailfr\text.txt"

function sendmail ([string]$body, [string]$attach) {
    Send-Mailmessage -from $from -to "$to" -subject $subject -body $body -encoding $utf8 -BodyAsHtml # -Attachments $attach
}

$body = Get-Content $bodyfile
sendmail $body # $attach