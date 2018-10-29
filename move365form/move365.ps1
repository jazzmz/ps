$PSEmailServer="mail.pirbank.ru"
#$pathwithfiles="C:\test\move365form"
$body=""
$pathwithfilesr="Q:\mns\365"
$enc = [System.Text.Encoding]::UTF8
$to="ddorkin@pirbank.ru"

$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"
$currHour = Get-Date -format "HH"
$currMinute = Get-Date -format "mm"
$currSecond = Get-Date -format "ss"

$list=Get-ChildItem "$pathwithfiles\out"

foreach ($file in $list){
    $body = $body + $file.Name + "`n"
}


if ($list){
    Send-MailMessage -From "notify@pirbank.ru" -To $to -Subject "Данные по 365 форме перемещены" -Body $body -encoding $enc
    $flag = Test-Path $pathwithfiles\arch_send_out\$currYear #Сначала год
	if (!$flag) {
				mkdir $pathwithfiles\arch_send_out\$currYear | Out-Null
			      };
    $flag = Test-Path $pathwithfiles\arch_send_out\$currYear\$currMonth #Теперь месяц
	if (!$flag) {
				mkdir $pathwithfiles\arch_send_out\$currYear\$currMonth | Out-Null
			      };
    $flag = Test-Path $pathwithfiles\arch_send_out\$currYear\$currMonth\$currDay #Теперь день
	if (!$flag) {
				mkdir $pathwithfiles\arch_send_out\$currYear\$currMonth\$currDay | Out-Null
			      };
    Move-Item -Force "$pathwithfiles\out\*" "$pathwithfiles\arch_send_out\$currYear\$currMonth\$currDay"

    }





