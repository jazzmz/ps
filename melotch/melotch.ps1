#############################################################
#############################################################
###                                                       ###
### Программа для формирования папок с отчетностью        ###
###                                                       ###
### Автор: Доркин Дмитрий                                 ###
###                                                       ###
### Дата последних изменений: 2014.12.02                  ###
###                                                       ###
#############################################################
#############################################################


$PSEmailServer="mail.pirbank.ru"

$path="T:\temp\melotch"
$progData="T:\temp\melotch"

$curYear=Get-Date -Format "yyyy"
$curMonth=Get-Date -Format "MM"
$curDay=Get-Date -Format "dd"
$dayfolder="ОТЧЕТНОСТЬ\на $curYear.$curMonth.$curDay"
$archdir="$path\АРХИВ ОТЧЕТНОСТИ"

$domain="PIRBANK"
$u4="noborina"
$u5_1="emarsheva,ekrasnova"
$u5_2="ekotlyar,ekrasnova"
$u6_2="aovchinnikov,dmaslov"
$u7_1="okolosova"
$u7_2="okolosova"
$u7_3="okolosova"
$u8="okolosova"
$u10_1="dsavina"
$u10_2="tsudnik"
$u11="oblinova"
$u17="isavtseva"
$admin="ddorkin"
$u9="lmelihova,mzenkova,oegorkina"
$u9admin="ghohlova,nsundukova"

$adminmail="ddorkin@pirbank.ru"


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

function setaclwrite ([string]$folder, [string]$users){
$usersarr = $users -split ","
$i=0
While ( $i -lt $usersarr.Length){
    $user=$usersarr[$i]
    & icacls "$folder" /grant:r "${domain}\${user}:(OI)(WD,GR,X)" /T
    $i++
}
}

function setaclro ([string]$folder, [string]$users){
$usersarr = $users -split ","
$i=0
While ( $i -lt $usersarr.Length){
    $user=$usersarr[$i]
    & icacls "$folder" /grant:r "${domain}\${user}:(OI)(GR,X)" /T
    $i++
}
}

function setacladmin ([string]$folder, [string]$users){
$usersarr = $users -split ","
$i=0
While ( $i -lt $usersarr.Length){
    $user=$usersarr[$i]
    & icacls "$folder" /grant:r "${domain}\${user}:(OI)F" /T
    $i++
}
}

function setacldelete ([string]$folder, [string]$users){
$usersarr = $users -split ","
$i=0
While ( $i -lt $usersarr.Length){
    $user=$usersarr[$i]
    & icacls "$folder" /grant:r "${domain}\${user}:(OI)(GR,X,DE)" /T
    $i++
}
}

function createDirs {
mkdir "$path\$dayfolder"

mkdir "$path\$dayfolder\U4"
mkdir "$path\$dayfolder\U4\135"
mkdir "$path\$dayfolder\U4\118"
setacladmin "$path\$dayfolder\U4" $admin
setaclwrite "$path\$dayfolder\U4" $u4
setaclro "$path\$dayfolder\U4" $u9
setacldelete "$path\$dayfolder\U4" $u9admin
& icacls "$path\$dayfolder\U4" /inheritance:r /T

mkdir "$path\$dayfolder\U5_1"
mkdir "$path\$dayfolder\U5_1\123"
mkdir "$path\$dayfolder\U5_1\135"
mkdir "$path\$dayfolder\U5_1\116"
mkdir "$path\$dayfolder\U5_1\128"
mkdir "$path\$dayfolder\U5_1\129"
mkdir "$path\$dayfolder\U5_1\125"
mkdir "$path\$dayfolder\U5_1\157"
mkdir "$path\$dayfolder\U5_1\711"
mkdir "$path\$dayfolder\U5_1\127"
mkdir "$path\$dayfolder\U5_1\501"
mkdir "$path\$dayfolder\U5_1\345"
setacladmin "$path\$dayfolder\U5_1" $admin
setaclwrite "$path\$dayfolder\U5_1" $u5_1
setaclro "$path\$dayfolder\U5_1" $u9
setacldelete "$path\$dayfolder\U5_1" $u9admin
& icacls "$path\$dayfolder\U5_1" /inheritance:r /T

mkdir "$path\$dayfolder\U5_2"
mkdir "$path\$dayfolder\U5_2\123"
mkdir "$path\$dayfolder\U5_2\135"
mkdir "$path\$dayfolder\U5_2\634"
mkdir "$path\$dayfolder\U5_2\118"
mkdir "$path\$dayfolder\U5_2\117"
mkdir "$path\$dayfolder\U5_2\155"
mkdir "$path\$dayfolder\U5_2\128"
mkdir "$path\$dayfolder\U5_2\115"
mkdir "$path\$dayfolder\U5_2\125"
mkdir "$path\$dayfolder\U5_2\127"
mkdir "$path\$dayfolder\U5_2\302"
mkdir "$path\$dayfolder\U5_2\316"
mkdir "$path\$dayfolder\U5_2\126"
setacladmin "$path\$dayfolder\U5_2" $admin
setaclwrite "$path\$dayfolder\U5_2" $u5_2
setaclro "$path\$dayfolder\U5_2" $u9
setacldelete "$path\$dayfolder\U5_2" $u9admin
& icacls "$path\$dayfolder\U5_2" /inheritance:r /T

mkdir "$path\$dayfolder\U6_2"
mkdir "$path\$dayfolder\U6_2\101"
setacladmin "$path\$dayfolder\U6_2" $admin
setaclwrite "$path\$dayfolder\U6_2" $u6_2
setaclro "$path\$dayfolder\U6_2" $u9
setacldelete "$path\$dayfolder\U6_2" $u9admin
& icacls "$path\$dayfolder\U6_2" /inheritance:r /T

mkdir "$path\$dayfolder\U7_1"
mkdir "$path\$dayfolder\U7_1\135"
mkdir "$path\$dayfolder\U7_1\115"
setacladmin "$path\$dayfolder\U7_1" $admin
setaclwrite "$path\$dayfolder\U7_1" $u7_1
setaclro "$path\$dayfolder\U7_1" $u9
setacldelete "$path\$dayfolder\U7_1" $u9admin
& icacls "$path\$dayfolder\U7_1" /inheritance:r /T

mkdir "$path\$dayfolder\U7_2"
mkdir "$path\$dayfolder\U7_2\135"
mkdir "$path\$dayfolder\U7_2\634"
setacladmin "$path\$dayfolder\U7_2" $admin
setaclwrite "$path\$dayfolder\U7_2" $u7_2
setaclro "$path\$dayfolder\U7_2" $u9
setacldelete "$path\$dayfolder\U7_2" $u9admin
& icacls "$path\$dayfolder\U7_2" /inheritance:r /T

mkdir "$path\$dayfolder\U7_3"
mkdir "$path\$dayfolder\U7_3\603"
setacladmin "$path\$dayfolder\U7_3" $admin
setaclwrite "$path\$dayfolder\U7_3" $u7_3
setaclro "$path\$dayfolder\U7_3" $u9
setacldelete "$path\$dayfolder\U7_3" $u9admin
& icacls "$path\$dayfolder\U7_3" /inheritance:r /T

mkdir $path\$dayfolder\U8
mkdir $path\$dayfolder\U8\135
setacladmin "$path\$dayfolder\U8" $admin
setaclwrite "$path\$dayfolder\U8" $u8
setaclro "$path\$dayfolder\U8" $u9
setacldelete "$path\$dayfolder\U8" $u9admin
& icacls "$path\$dayfolder\U8" /inheritance:r /T

mkdir $path\$dayfolder\U10_1
mkdir $path\$dayfolder\U10_1\135
setacladmin "$path\$dayfolder\U10_1" $admin
setaclwrite "$path\$dayfolder\U10_1" $u10_1
setaclro "$path\$dayfolder\U10_1" $u9
setacldelete "$path\$dayfolder\U10_1" $u9admin
& icacls "$path\$dayfolder\U10_1" /inheritance:r /T

mkdir $path\$dayfolder\U10_2
mkdir $path\$dayfolder\U10_2\101
setacladmin "$path\$dayfolder\U10_2" $admin
setaclwrite "$path\$dayfolder\U10_1" $u10_1
setaclro "$path\$dayfolder\U10_1" $u9
setacldelete "$path\$dayfolder\U10_2" $u9admin
& icacls "$path\$dayfolder\U10_2" /inheritance:r /T

mkdir "$path\$dayfolder\U11"
mkdir "$path\$dayfolder\U11\135"
mkdir "$path\$dayfolder\U11\302"
setacladmin "$path\$dayfolder\U11" $admin
setaclwrite "$path\$dayfolder\U11" $u11
setaclro "$path\$dayfolder\U11" $u9
setacldelete "$path\$dayfolder\U11" $u9admin
& icacls "$path\$dayfolder\U11" /inheritance:r /T
}

function setacldirro ([string]$folder, [string]$group){
setacladmin "$folder" $admin
setaclro "$folder" $group
setaclro "$folder" $u9
setaclro "$folder" $u9admin
& icacls "$folder" /inheritance:r /T
}

function moveDirs {
$dirname = Get-ChildItem "$path/ОТЧЕТНОСТЬ" -Filter "*20*"
$dirname = $dirname.Fullname
&icacls "$dirname" /reset /T
setacldirro "$dirname\U4" $u4
setacldirro "$dirname\U5_1" $u5_1
setacldirro "$dirname\U5_2" $u5_2
setacldirro "$dirname\U6_2" $u6_2
setacldirro "$dirname\U7_1" $u7_1
setacldirro "$dirname\U7_2" $u7_2
setacldirro "$dirname\U7_3" $u7_3
setacldirro "$dirname\U8" $u8
setacldirro "$dirname\U10_1" $u10_1
setacldirro "$dirname\U10_2" $u10_2
setacldirro "$dirname\U11" $u11
Move-Item "$dirname" "$archdir"
if (!$?){
    Send-MailMessage -From "notify@pirbank.ru" -To $adminmail -Subject "Error moving reporting files" -Body "WARNING! Directory is busy! Moving failed!"
}
}


#createDirs
#moveDirs
if ($curDay -eq "01"){
    $flag=Test-Path "$path\$dayfolder"
    if (!$flag){
         createDirs
    }
}

Get-Content "$progData\datelist.txt" | % {
$line="$_"
$line=$line.Trim()
if ($line -ne ""){
      $firstsym=$line.SubString(0,1)
      if ($firstsym -ne "#"){
        $lineYear=$line.Substring(0,4)
        $lineMonth=$line.Substring(5,2)
        $lineDay=$line.Substring(8,2)
        #echo "$lineYear-$lineMonth-$lineDay"
        if (("$curYear" -eq "$lineYear") -and ("$curMonth" -eq "$lineMonth") -and ("$curDay" -eq "$lineDay")){
            moveDirs
        }
      }
}
}