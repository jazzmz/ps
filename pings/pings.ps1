$line1 = ""
$line2 = ""
$line3 = ""

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

Function PingResult ([string]$Addr){
$ping=ping $Addr -n 3 -w 50 | ConvertTo-Encoding cp866 windows-1251
$firstSym=$Addr.Substring(0,1)
#echo $ping
#echo "____________________________________"
$line1=$ping[2].substring(9,1)
$line2=$ping[3].substring(9,1)
$line3=$ping[4].substring(9,1)
#echo "$line1 $line2 $line3"

if (($line1 -eq $firstSym) -or ($line2 -eq $firstSym) -or ($line3 -eq $firstSym)){
return ($True)
}
else {
return ($False)
}
}

$Result=PingResult 192.168.10.211
echo $Result