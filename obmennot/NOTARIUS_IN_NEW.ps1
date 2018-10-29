################################################
#Скрипт приема и расшифровки файлов нотариуса  #
#Автор: 	      Доркин Д.В.                  #
#Дата:	      24/12/2014                       #
################################################

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

$pathwithfiles="Q:\zalog\in"
$programdir="C:\test\obmennot"
$dn1="obazhinova@pirbank.ru"
#$dn2="02722615326"
$dn2="V201FF"

#Функции

#Смена кодировки
function ConvertTo-Encoding ([string]$From, [string]$To){
	Begin{
		$encFrom = [System.Text.Encoding]::GetEncoding($from)
		$encTo = [System.Text.Encoding]::GetEncoding($to)
	}
	Process{
		$bytes = $encTo.GetBytes($_)
		$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
		$encTo.GetString($bytes)
	}
}

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
$j=1
$filename=$false
dir -Filter *.enc $pathwithfiles | % { 
$filename= $_
$filename=$filename -split ".enc"
$filename=$filename[0]

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
$resultofdecription=&$programdir\cryptcp.exe -nochain -decr -dn "$dn1, $dn2" $pathwithfiles\$filename.enc $pathwithfiles\$filename


while ($i -le $resultofdecription.length) {
     if ($resultofdecription[$i].length -le 10) {}
	else
	{
	    if ($resultofdecription[$i].substring(0,10) -eq "[ErrorCode") {
	        Warning "Ошибка расшифровки!!!"
	        del $pathwithfiles\$filename | Out-Null
	        exit 
        }
    }
$i++
}


#2) Раззиповать
$pathtoextract="-o$pathwithfiles"
& $programdir\7z.exe e $pathwithfiles\$filename $pathtoextract -y | Out-Null

#3) Проверить подпись
#dir -include @("*.p7s", "*.sig") -Name $pathwithfiles/* | % { 
dir -Filter *.xml $pathwithfiles | % { 
    $name=$_
    mv $pathwithfiles\$_.sig $pathwithfiles\$_.sgn
}

$i=0
$resultofchecking=&$programdir\cryptcp.exe -nochain -vsignf -f $programdir\theirsert.cer -dir $pathwithfiles $pathwithfiles\*.xml -cert

$flag=$resultofchecking | select-string "ErrorCode"
if ($flag){
    #echo "Error in file $name, code: $flag"
    Warning "Неверная подпись в файле $name"
}

dir -include @("*.xml", "*.sgn", "*.zip") -Name $pathwithfiles/* | % { 
    mv $pathwithfiles\$_ $pathwithfiles\$j$_
    mv -Force $pathwithfiles\$j$_ $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay
}
$j++

}
#4) Раскидать по папкам исходные файлы
if (!$filename){
    Warning "Нет файлов для работы!!!"
exit
}

mv -Force $pathwithfiles\*.enc $pathwithfiles\ARCHIVE\$currYear\$currMonth\$currDay