$dir="T:\Operu\RVK_KONTR\"
$progdir="C:\test\valxmlsend"
$user=$env:username
#$user="dsavina"
#$user="ochumicheva"
$dn="$user@pirbank.ru"


$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"

Get-Childitem -Filter "*.xml" "$dir\out" | % {
    & "$progdir\cryptcp.exe" -nochain -der -signf -dir "$dir\out" -dn "$dn" "$dir\out\$_" -cert 
}

#������� ����������
$flag = Test-Path "$dir\out\archive\$user" #���������������� �����
	if (!$flag) {
				mkdir "$dir\out\archive\$user" | Out-Null
}
$flag = Test-Path "$dir\out\archive\$user\$currYear" #������� ���
	if (!$flag) {
				mkdir "$dir\out\archive\$user\$currYear" | Out-Null
			      };
$flag = Test-Path "$dir\out\archive\$user\$currYear\$currMonth" #������ �����
	if (!$flag) {
				mkdir "$dir\out\archive\$user\$currYear\$currMonth" | Out-Null
			      };
$flag = Test-Path "$dir\out\archive\$user\$currYear\$currMonth\$currDay" #������ ����
	if (!$flag) {
				mkdir "$dir\out\archive\$user\$currYear\$currMonth\$currDay" | Out-Null
			      };


Move-Item "$dir\out\*.xml" "$dir\out\archive\$user\$currYear\$currMonth\$currDay"
Move-Item "$dir\out\*.sgn" "$dir\out\archive\$user\$currYear\$currMonth\$currDay"