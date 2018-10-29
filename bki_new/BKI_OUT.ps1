#######################################
#Скрипт отсылки и шифровки файлов БКИ      #
#Автор:         Доркин Д.В.                                  #
#Дата:           28/05/2013                                       #
#######################################

#Переменные общие
$PSEmailServer="mail.pirbank.ru"
$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"
$enc  = New-Object System.Text.utf8encoding

#Переменные частные
$pathwithfiles="C:\test\bki_new\out"
$dn="sbaturina@pirbank.ru"

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

Get-ChildItem -Filter V* $pathwithfiles | % {
$currFile=$_

#1) Создать подпись
C:\test\nbki\cryptcp.exe -nochain -der -signf -dir $pathwithfiles -dn "$dn" "$pathwithfiles\$currFile" -cert 

# Переименовать sgn в sig

mv $pathwithfiles\$currFile.sgn $pathwithfiles\$currFile.sig


#2) Зазиповать
C:\test\nbki\7z.exe a -tzip $pathwithfiles\$currFile.zip $pathwithfiles\$currFile*

#3) Зашифровать
C:\test\nbki\cryptcp.exe -nochain -der -encr -f C:\test\nbki\theirsert.cer $pathwithfiles\$currFile.zip $pathwithfiles\$currFile.zip.enc

#4) Отослать
#Send-MailMessage -from "kotliar@pirbank.ru" -to "credithistory@nbki.ru", "nbki@pirbank.ru" -subject "ООО ПИР Банк (OOO PIR Bank)" -body "Files from OOO PIR Bank" -Encoding $enc -attachments "$pathwithfiles\$currFile.zip.enc"
Send-MailMessage -from "kotliar@pirbank.ru" -to "ddorkin@pirbank.ru", "aanisimov@pirbank.ru" -subject "ООО ПИР Банк (OOO PIR Bank)" -body "Files from OOO PIR Bank" -Encoding $enc -attachments "$pathwithfiles\$currFile.zip.enc"

#mv $pathwithfiles\V201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.zip.zip $pathwithfiles\V201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.zip

#5) Раскидать по папкам
mv -Force $pathwithfiles\$currFile* $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay
}
