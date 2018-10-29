######################################################################
#                                                                    #
#   Скрипт для перекладывания файлов с учетом времени и дня недели   #
#   Автор: Доркин Дмитрий                                            #
#   Дата создания: 2014-03-21                                        #
#                                                                    #
######################################################################

$time=get-date
$timestamp=get-date -Format HHmmss
$dayofweek=$time.AddDays(0).DayOfWeek
$mintime="132000"
$maxtime="140000"
$fromdir="Q:\mns\365\out"
$todir="Q:\mns\365\send_out "

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

cp $fromdir\Bos*.vrb $todir
cp $fromdir\Bv*.vrb $todir
cp $fromdir\Pb*.txt $todir

echo "Данные успешно скопированы"
pause

