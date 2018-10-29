#######################################
#Скрипт отсылки и шифровки файлов     #
#нотариусу                            #
#Автор:         Доркин Д.В.           #
#Дата:           01/09/2014           #
#######################################

#Переменные общие
#$PSEmailServer="mail.pirbank.ru"
$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"

$smtpServer="mail.pirbank.ru"
$emailFrom="zalog@pirbank.ru"
$emailRcpt1="2414401@mail.ru"
$emailRcpt2="zalog@pirbank.ru"
$emailSubject="ООО ПИР Банк (OOO PIR Bank)"
$msgBody="Files from OOO PIR Bank"



#Переменные частные
$pathwithfiles="C:\test\obmennot"
$dn1="obazhinova@pirbank.ru"
$dn2="02722615326"

#Создадим объекты
$utf8  = New-Object System.Text.utf8encoding
$smtp = New-Object Net.Mail.SmtpClient -arg $smtpServer 

#Создать директории
$flag = Test-Path $pathwithfiles\ARCHIVE\$currYear #Сначала год
	if (!$flag) {
				mkdir $pathwithfiles\ARCHIVE\$currYear | Out-Null
			      };
$flag = Test-Path $pathwithfiles\ARCHIVE\$currYear\$currMonth #Теперь месяц
	if (!$flag) {
				mkdir $pathwithfiles\ARCHIVE\$currYear\$currMonth | Out-Null
			      };
$flag = Test-Path $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay #Теперь день
	if (!$flag) {
				mkdir $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay | Out-Null
			      };

Get-ChildItem -Filter *.xml $pathwithfiles | % {
$currFile=$_

#1) Создать подпись
& $pathwithfiles\cryptcp.exe -nochain -der -signf -dir $pathwithfiles -dn "$dn1, $dn2" "$pathwithfiles\$currFile" -cert 

# Переименовать sgn в sig

mv $pathwithfiles\$currFile.sgn $pathwithfiles\$currFile.sig


#2) Зазиповать
& $pathwithfiles\7z.exe a -tzip $pathwithfiles\$currFile.zip $pathwithfiles\$currFile*

#3) Зашифровать
& $pathwithfiles\cryptcp.exe -nochain -der -encr -f $pathwithfiles\theirsert.cer $pathwithfiles\$currFile.zip $pathwithfiles\$currFile.zip.enc

#4) Отослать
$OutputFile="$pathwithfiles\$currFile.zip.enc"
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

sleep 1
#5) Раскидать по папкам
mv -Force $pathwithfiles\$currFile* $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay

}
