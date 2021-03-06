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

function SearchingSubstings ([string]$Path){
$FindStr = $null
$i = 0
#while ($i -le 31) {
$i = $i + 1
if ($i -le 9) {
	 $day="0"+$i
	 }
else
	{
	$day=$i
	}
$flag = Test-Path $Path\$day
#echo  $Path\$day
#if ($flag) {
#echo "Looking in day $day"
	ls -R Q:\docum\2013\04\05\md\03073PTV | where  { ! $_.PSISContainer } |% {
		$FindStr = $null
        $FullDoc = get-content $_.FullName
		$FindStr=Select-Patterns $FullDoc
		if ($FindStr -ne $null) {
					echo $_.FullName
                    #echo "I found string!"
                    #echo "$FindStr"
                    sleep 5
				}
	}
#	}
#}
}

function Select-Patterns ([string]$FullDoc){
echo "Testing doc $_"
$FindStr = $FullDoc | ConvertTo-Encoding cp866 windows-1251 | select-string -pattern ".*Maeerrin.*"
if ($FindStr -eq $null) {
	$FindStr = $FullDoc | ConvertTo-Encoding cp866 windows-1251 | select-string -pattern ".*Varerch.*"
}
return $FindStr
}

get-date
SearchingSubstings 'q:\docum\2013\04'
get-date
