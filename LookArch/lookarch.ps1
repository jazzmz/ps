$dir="Q:\docum"
$Pattern = "РЕЕСТР ОПЕРАЦИЙ С НАЛИЧНОЙ ВАЛЮТОЙ И ЧЕКАМИ"
$tardir = "T:\temp\123456"

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


$Counter = 0

Get-Childitem $dir | % {
    if ($_.PsIsContainer) {
        $Year=$_.Name
        Get-ChildItem $_.Fullname | % {
            $Month=$_.Name
            #if ((($Year -eq "2014") -and ($Month -ne "01") -and ($Month -ne "02")) -or ($Year -eq "2015"))
            if (($Year -eq "2015") -and ($Month -eq "03"))
            {
                $lookdir=$_.FullName
                Get-ChildItem $lookdir | % {
                    if ($_.PsIsContainer)
                    {
                        $Day = $_.Name
                        $Path = $_.Fullname
                        Get-ChildItem -Recurse $Path | % {
                            if (!$_.PsIsContainer)
                            {
                                $flag = $_.Name | Select-String "04120"
                                if ($flag) {
                                    $flag = Get-Content $_.FullName | ConvertTo-Encoding cp866 windows-1251 | Select-String ".*$Pattern.*"
                                    if ($flag) {
                                        echo $_.FullName >>"$tardir/operation.log"
                                        $Counter++
                                        $flag = Test-Path $tardir\$Year
                                        if (!$flag) {mkdir $tardir\$Year | Out-Null }
                                        $flag = Test-Path $tardir\$Year\$Month
                                        if (!$flag) {mkdir $tardir\$Year\$Month | Out-Null }
                                        $flag = Test-Path $tardir\$Year\$Month\$Day
                                        if (!$flag) {mkdir $tardir\$Year\$Month\$Day | Out-Null }
                                        Copy-Item $_.Fullname $tardir\$Year\$Month\$Day
                                    }
                                }
                            }

                        }
                    }
                }
            }

        }
    }
}

echo "Total: $Counter" >>"$tardir/operation.log"
