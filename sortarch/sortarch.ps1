########################################
### Script for sorting docs from ERA ###
### Author: Dorkin Dmitry            ###
### Date:   1.08.2013                ###
########################################


#[System.IO.File]::ReadAllText('q:\docum\common.psm1') | Invoke-Expression

#$CurrYear   = getYear;
#$CurrMonth  = getMonth;
$CurrYear   = "2016";
$CurrMonth  = "01";
$filelog='C:\test\sortarch\logofsearching.log'
$period="Q:\docum\$CurrYear\$CurrMonth"
$period_sign="Q:\docum_s\$CurrYear\$CurrMonth"
#$period='Q:\docum\2014\10'
echo "Path for Looking $period"

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

function SearchingSubstings ([string]$Path, [string]$Pattern){
$FindStr = $null
$i = 0
while ($i -le 31) {
$i = $i + 1
if ($i -le 9) {
	 $day="0"+$i
	 }
else
	{
	$day=$i
	}
$flag = Test-Path $Path\$day
if ($flag) {
echo "Looking in day $day"
	ls -R $Path\$day | where  { ! $_.PSISContainer } |% {
        echo "Checking $_"
        $FindStr = get-content $_.FullName | ConvertTo-Encoding cp866 windows-1251 | Select-String ".*$Pattern.*" 
		if ($FindStr -ne $null) {
                    $flag = Test-Path $Path\$day\other
                    if (!$flag) {
                        mkdir $Path\$day\other
                    }
					echo $_.FullName
                    mv $_.FullName $Path\$day\other
                    $param="String found in file `n " + $_.FullName + "`n with pattern `n $Pattern `n"
                    echo $param >>'c:\test\sortarch\logofsearching.log'
				}
	}
	}
}
}

function SortingFromUser ([string]$Path, [string]$User, [string]$Folder){
$i = 0
while ($i -le 31) {
    $i = $i + 1
    if ($i -le 9) {
    	 $day="0"+$i
       	 }
    else
	    {
	    $day=$i
	    }

    $flag = Test-Path $Path\$day
    if ($flag) {
       ls -R $Path\$day | where  { ! $_.PSISContainer } |% {
       $FileName=$_.Name
       $UserOwner=$Filename.Substring(0,8)
       if ($UserOwner -eq $User) {
                    $flag = Test-Path $Path\$day\$Folder
                    if (!$flag) {
                        mkdir $Path\$day\$Folder
                    }
                    mv $_.Fullname $Path\$day\$Folder
                    $param="String found in file `n " + $_.FullName + "`n from user `n $User `n"
                    echo $param >>'c:\test\sortarch\logofsearching.log'
            }
       }
    }
}
}


$flag=test-path $filelog
if ($flag) { 
    del $filelog 
}
get-date >>$filelog
SearchingSubstings $period 'Выписк'
SearchingSubstings $period 'ВЕДОМОСТЬ ЗАКРЫТЫХ ЛИЦЕВЫХ'
SearchingSubstings $period 'ВЕДОМОСТЬ ОТКРЫТЫХ ЛИЦЕВЫХ'
SearchingSubstings $period 'ВЕДОМОСТЬ ОСТАТКОВ'
SearchingSubstings $period 'Отчет о загрузке файла'
SearchingSubstings $period 'Позиция по кор. счету'
SortingFromUser $period 03080NAI nalog
get-date >>$filelog
