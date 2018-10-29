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


#3) Проверить подпись
dir -Filter *.p7s -Name $pathwithfiles | % { 
$name=$_ -split ".p7s"
#echo $name[0]
$namesign=$name[0]
mv $pathwithfiles\$_ $pathwithfiles\$namesign.sgn
}

$i=0
echo "C:\test\nbki\cryptcp.exe -nochain -f C:\test\nbki\obazhinova.cer -vsignf -dir $pathwithfiles $pathwithfiles\V*"
C:\test\nbki\cryptcp.exe -nochain -f C:\test\nbki\obazhinova.cer -vsignf -dir $pathwithfiles $pathwithfiles\V*5
$resultofchecking=C:\test\nbki\cryptcp.exe -nochain -f C:\test\nbki\obazhinova.cer -vsignf -dir $pathwithfiles $pathwithfiles\V*5
while ($i -le $resultofchecking.length) {
     if ($resultofchecking[$i].length -le 10) {}
	else
	{
	if ($resultofchecking[$i].substring(0,10) -eq "[ErrorCode") {
	Warning "Подпись неверна!!!"	
	#echo "Подпись неверна!!!"	
	#pause
	exit }}
     $i++
     }