#######################################
#Скрипт приема и расшифровки файлов БКИ  #
#Автор: 	      Доркин Д.В.                                 #
#Дата:	      30/05/2013                                      #
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

$pathwithfiles="Q:\nbki\in"
$dn="obazhinova@pirbank.ru"

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


#Сама программа

#Проверим есть ли файлы для работы

dir -Filter *.p7m -Name $pathwithfiles | % { 
$filename=$_.substring(0,32)
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
#1) расшифровать файл

$i=0
#C:\test\nbki\cryptcp.exe -nochain -decr -dn $dn $pathwithfiles\$filename.enc $pathwithfiles\$filename.zip
$resultofdecription=C:\test\nbki\cryptcp.exe -nochain -decr -dn $dn $pathwithfiles\$filename.enc $pathwithfiles\$filename.zip
while ($i -le $resultofdecription.length) {
     if ($resultofdecription[$i]. length -le 10) {}
	else
	{
	if ($resultofdecription[$i].substring(0,10) -eq "[ErrorCode") {
	Warning "Ошибка расшифровки!!!"
	#echo "Ошибка расшифровки!!!"
	#pause
	del $pathwithfiles\$filename.zip | Out-Null
	exit }}
     $i++
     }

#2) Раззиповать
$pathtoextract="-o$pathwithfiles"
C:\test\nbki\7z.exe e $pathwithfiles\$filename.zip $pathtoextract -y

#3) Проверить подпись
dir -Filter *.sig -Name $pathwithfiles | % { 
$name=$_.substring(0,29)
#echo $name
mv $pathwithfiles\$_ $pathwithfiles\$name.txt.sgn
}

$i=0
#C:\test\nbki\cryptcp.exe -nochain -vsignf -f C:\test\nbki\tpetrova.cer -dir $pathwithfiles $pathwithfiles\*.txt
$resultofchecking=C:\test\nbki\cryptcp.exe -nochain -vsignf -f C:\test\nbki\tpetrova.cer -dir $pathwithfiles $pathwithfiles\*.txt
while ($i -le $resultofchecking.length) {
     if ($resultofchecking[$i]. length -le 10) {}
	else
	{
	if ($resultofchecking[$i].substring(0,10) -eq "[ErrorCode") {
	Warning "Подпись неверна!!!"	
	#echo "Подпись неверна!!!"	
	#pause
	exit }}
     $i++
     }

#4) Раскидать по папкам
mv -Force $pathwithfiles\NBKI* $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay
