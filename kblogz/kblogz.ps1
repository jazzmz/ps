$date=get-date
$dateyesterday=$date.AddDays(-1).ToString()
$day=$dateyesterday.Substring(0,2)
$month=$dateyesterday.Substring(3,2)
$year=$dateyesterday.Substring(6,4)
$filename="Log_Of_NAT_for_KB_On_$year-$month-$day.bz2"
$param="C:\test\kblogz\$filename"
#echo $param
C:\test\kblogz\pscp.exe -P 22 -i C:\test\kblogz\mykey.ppk root@hydrogen:/var/log/security.1.bz2 $param