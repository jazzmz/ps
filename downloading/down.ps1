$pathtodown="C:\test\downloading"
$link="http://www.cbr.ru/mcirabis/BIK/"
$datepart=Get-Date -Format ddMMyyyy
$filename="bik_db_$datepart.zip"

C:\test\downloading\wget.exe --execute=http_proxy=192.168.2.204:8080 --proxy-user=pirbank\ddorkin --proxy-password=mypass --proxy $link$filename -P $pathtodown
C:\test\downloading\pscp.exe -P 22 -pw mypass $pathtodown/$filename dorkin@hydrogen:/home/dorkin
