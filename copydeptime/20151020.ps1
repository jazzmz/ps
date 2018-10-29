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

function CheckInterval ([string]$maxtime, [string]$mintime) {
$timestamp=get-date -Format HHmmss
#echo "$timestamp"
#echo "$maxtime"
#echo "$mintime"
if ($timestamp -gt $mintime -and $timestamp -lt $maxtime){
    echo "В данный момент копирование данных невозможно"
    $delay=CountTime $maxtime $timestamp
    echo "Копирование будет возможно через $delay секунд"
    pause
    exit
}

}

#Тут задается любое число интервалов в виде CheckInterval "верхняя граница ЧЧММСС" "нижняя граница ЧЧММСС"
CheckInterval "100000" "093000"
CheckInterval "120000" "110000"

#Тут любое число команд, которые выполняются если время не входит ни в один заданных из интервалов
echo "Success"