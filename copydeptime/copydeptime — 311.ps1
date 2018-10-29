######################################################################
#                                                                    #
#   Скрипт для перекладывания файлов с учетом времени и дня недели   #
#   Автор: Доркин Дмитрий                                            #
#   Дата создания: 2014-06-23                                        #
#                                                                    #
######################################################################

$time=get-date
$timestamp=get-date -Format HHmmss
$dayofweek=$time.AddDays(0).DayOfWeek
$mintime="132000"
$maxtime="140000"
$fromdir="C:\test\mns\out"
$fromdirxml="Q:\mns\Simlpe_физ_лица"
$todir="C:\test\mns\send_out"
$folder1="C:\test\mns\send_out"
$folder2="C:\test\mns\send_out2"
$text_to_send = ""
$encoding = [System.Text.Encoding]::UTF8

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

function CountTime([string]$maxtime, [string]$timestamp){
    $maxhour=$maxtime.substring(0,2)
    $maxmin=$maxtime.substring(2,2)
    $maxsec=$maxtime.substring(4,2)
    $nowhour=$timestamp.substring(0,2)
    $nowmin=$timestamp.substring(2,2)
    $nowsec=$timestamp.substring(4,2)
    $delay = ([Convert]::ToInt32($maxhour)*3600+[Convert]::ToInt32($maxmin)*60+[Convert]::ToInt32($maxsec))-([Convert]::ToInt32($nowhour)*3600+[Convert]::ToInt32($nowmin)*60+[Convert]::ToInt32($nowsec))
    return $delay
}

$flag=Test-Path $fromdir

if ($flag){

if ($dayofweek -eq "Friday"){
    $maxtime="152500"
    $mintime="151500"
#   echo "Now Friday!"
}
else
{
    $maxtime="162500"
    $mintime="161500"
#   echo "Now not friday!"
}


if ($timestamp -gt $mintime -and $timestamp -lt $maxtime){
    echo "В данный момент копирование данных невозможно"
    $delay=CountTime $maxtime $timestamp
    echo "Копирование будет возможно через $delay секунд"
    pause
    exit
}

$date = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
$text_to_send = $text_to_send + $date


Get-ChildItem $fromdir -Filter SB*.txt | %{
$FileFullName=$_.FullName
$FileName=$_
    Get-Content $FileFullName | %{
    $Line=$_ | ConvertTo-Encoding cp866 windows-1251
    $LineSubst = ""
    if ($Line.Length -gt 5){
    #echo $Line
        $LineSubst=$Line.Substring(0,5)
        }
    if ($LineSubst -eq "НомСч" ){
    $fivesyms = $Line.Substring(6,5)
    $fivesyms = [Convert]::ToInt32($fivesyms)

    if ((($fivesyms -ge 410) -and ($fivesyms -le 422)) -or ($fivesyms -eq 425)){
    #echo "$fivesyms to Fodler2"
    #cp $fromdir\$Filename $folder2
    }
    else{
    #echo "$fivesyms to Fodler1"
    #cp $fromdir\$Filename $folder1
    }

    $text_to_send = $text_to_send + "`n" + $FileName.Tostring()
    $text_to_send = $text_to_send + "`n" + $Line
    }
    }
$text_to_send = $text_to_send + "`n" 
}


Get-ChildItem $fromdir -Filter SFC*.xml | %{
$FileFullName=$_.FullName
echo $FileFullNAme
$FileName=$_
    Get-Content $FileFullName | %{
    $Line=$_ | Select-String "НомСЧ"
    echo $Line
        if ($Line.Length -gt 0) {
        $NomSch=[Regex]::matches($Line,'НомСч="[\d]*"',[System.Text.RegularExpressions.RegexOptions]::IgnoreCase).Value
        $NomSch=$NomSch.Substring(7,20)
        $NomSch="НомСч:$NomSch"
        #echo "$FileFullName Nomsch=$NomSch"
        $text_to_send = $text_to_send + "`n" + $FileName.Tostring()
        $text_to_send = $text_to_send + "`n" + $NomSch
        }
    }
    $text_to_send = $text_to_send + "`n" 
}


echo $text_to_send
#mv $fromdir/SB*.txt $todir
if ($text_to_send -ne $date){
#echo "Sending"
#send-mailmessage -from "notify@pirbank.ru" -to "bis@pirbank.ru", "u6@pirbank.ru", "u5@pirbank.ru", "u10-1@pirbank.ru" -subject "Результаты проверки" -body "$text_to_send" -smtpServer mail.pirbank.ru -Encoding $encoding
}
}

else {
echo "Директория недоступна!!!!"
pause
}