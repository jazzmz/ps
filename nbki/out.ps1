#######################################
#Скрипт отсылки и шифровки файлов БКИ     #
#Создано Доркиным Д.В.                                 #
#28/05/2013                                                         #
#######################################

#Переменные общие
$PSEmailServer="mail.pirbank.ru"
$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"
$currHour = Get-Date -format "HH"
$currMinute = Get-Date -format "mm"
$currSecond = Get-Date -format "ss"
$enc  = New-Object System.Text.utf8encoding

#Переменные частные
$pathwithfiles="C:\test\nbki\out"
$dn="petrova@pirbank.ru"

#Функции

#Волшебная функция формирования окна ошибки

function Warning ($message)
{
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing");

$objForm = New-Object Windows.Forms.Form 

$objForm.Text = "Ошибка!" 
$objForm.Size = New-Object Drawing.Size @(400,200) 
$objForm.StartPosition = "CenterScreen"

$Warningtext=New-Object System.Windows.Forms.Label
$objForm.Controls.Add($Warningtext)
$Warningtext.Location = New-Object System.Drawing.Size(140,20)
$Warningtext.Size = New-Object System.Drawing.Size(200,50)
$Warningtext.Text = "$message"

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(160,100)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($OKButton)

$objForm.Controls.Add($OKButton) 
$objForm.Topmost = $True
$objForm.Add_Shown({$objForm.Activate()})  
[void] $objForm.ShowDialog() 
}

#Программа

#Проверим есть ли файлы для работы

dir -Filter *.txt -Name $pathwithfiles | % { 
$filename=$_.substring(0,29)
}

if ($filename -eq $null) {
Warning "Нет файлов для работы!!!"
exit
}

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

#1) Создать подписи
$i=0
#C:\test\nbki\cryptcp.exe -norev -nochain -der -signf -dir $pathwithfiles -dn "$dn" "$pathwithfiles\*.txt"
$resultofsign=C:\test\nbki\cryptcp.exe -norev -nochain -der -signf -dir $pathwithfiles -dn "$dn" "$pathwithfiles\*.txt"
while ($i -le $resultofsign.length) {
     if ($resultofsign[$i]. length -le 10) {}
	else
	{
	if ($resultofsign[$i].substring(0,10) -eq "[ErrorCode") {
	Warning "Не удалось подписать файлы!!!"	
	#echo "Не удалось подписать файлы!!!"
	#pause
	exit }}
     $i++
     }

dir -Filter *.sgn -Name $pathwithfiles | % { 
$name=$_.substring(0,29)
echo $name
mv $pathwithfiles\$_ $pathwithfiles\$name.txt.sig
}

#2) Зазиповать
C:\test\nbki\7z.exe a -tzip $pathwithfiles\NBKIV201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.zip $pathwithfiles\NBKI*

#3) Зашифровать
$i=0
#C:\test\nbki\cryptcp.exe -nochain -der -encr -f C:\test\nbki\tpetrova.cer $pathwithfiles\NBKIV201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.zip $pathwithfiles\NBKIV201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.enc
$resultofencription=C:\test\nbki\cryptcp.exe -nochain -der -encr -f C:\test\nbki\tpetrova.cer $pathwithfiles\NBKIV201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.zip $pathwithfiles\NBKIV201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.enc
while ($i -le $resultofencription.length) {
     if ($resultofencription[$i]. length -le 10) {}
	else
	{
	if ($resultofencription[$i].substring(0,10) -eq "[ErrorCode") {
	Warning "Ошибка шифрования!!!"
	#echo "Ошибка шифрования!!!"
	#pause
	exit }}
     $i++
     }

#4) Отослать
Send-MailMessage -from "nbki@pirbank.ru" -to "ddorkin@pirbank.ru" -subject "ООО ПИР Банк (OOO PIR Bank)" -body "Files from OOO PIR Bank" -Encoding $enc -attachments "$pathwithfiles\NBKIV201FF000001_$CurrYear$CurrMonth$CurrDay`_$currHour$currMinute$currSecond.enc"

#5) Раскидать по папкам
mv -Force $pathwithfiles\NBKI* $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay
