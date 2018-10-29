$smtpServer="mail.pirbank.ru"
$OutputFile="C:\test\sendmailobject\attach.txt"
$emailFrom="ddorkin@pirbank.ru"
$emailRcpt1="ddorkin@pirbank.ru"
$emailRcpt2="tstmail@pirbank.ru"
$emailSubject="Тема тестового письма"
$msgBody="Тело письма"
$ReplyAddr="tstmail@pirbank.ru"

$utf8  = New-Object System.Text.utf8encoding
$smtp = New-Object Net.Mail.SmtpClient -arg $smtpServer 
$msg = New-Object Net.Mail.MailMessage
$attach = New-Object Net.Mail.Attachment($OutputFile)          
 
$msg.From = $emailFrom
$msg.To.Add($emailRcpt1)
$msg.To.Add($emailRcpt2)
$msg.Subject = $emailSubject
$msg.Body = $msgBody
$msg.Attachments.Add($attach)
$msg.ReplyTo = $ReplyAddr
$msg.SubjectEncoding = $utf8
$msg.BodyEncoding = $utf8
 
$smtp.Send($msg)
$attach.Dispose()