Clear-Host

$path="C:\test\parsephones"

$csv = Import-Csv -Delimiter ";" "$path\Call.csv"
Copy-Item -Force "$path\Etalon.xml" "$path\Result.xml"

[xml]$xml = Get-Content "$path\Result.xml"

$datemax = [datetime]::parseexact("1900-01-01", 'yyyy-MM-dd', $null)
$datemaxprev = [datetime]::parseexact("1900-01-01", 'yyyy-MM-dd', $null)
foreach ($line in $csv)
  {
     $date = $line.Date.Substring(0,10)
     $date = [datetime]::parseexact($date, 'yyyy-MM-dd', $null)
     if (($date -gt $datemax) -and ($datemax -eq $datemaxprev)){
        $datemax = $date
        $datemaxprev = $date
     }
     if (($date -lt $datemax) -and ($datemaxprev -eq $datemax)){
        $datemaxprev = $date
     }   
     }
$datemax = $datemax.ToString('yyyy-MM-dd')
$datemaxprev = $datemaxprev.ToString('yyyy-MM-dd')
$xml.Days.Today.date = $datemax
$xml.Days.Yesterday.date = $datemaxprev



$DaysNode = $xml.SelectSingleNode("/Days")

ForEach ($DayNode in $DaysNode.ChildNodes) {
    $CurDayNode = $DayNode.Name
    $datexml = $xml.Days.$CurDayNode.date
    echo "$CurDayNode $datexml"
    $FilesNode = $xml.SelectSingleNode("/Days/$CurDayNode/Numbers")
    Foreach ($FileNode in $FilesNode.ChildNodes) {
        $CurNode = $FileNode.Name
        echo $CurNode
        $telnum = $CurNode.Substring(3,11)
        echo "For $telnum"
    
    Foreach ($line in $csv)
    {
        $date = $line.Date
        $datestr = $date.Substring(0,10)
        #echo $datestr
        $hour = $date.Substring(11,2)
        $to = $line.To.Trim()
        $dur = $line."Duration (sec.)"

        if (("$to" -eq "$telnum") -and ("$dur" -ne "0" ) -and ("$datestr" -eq "$datexml") ) {
                        #echo "$date / $hour / $to / $dur"
                        $hournode="h"+"$hour"
                        $durvalue = $xml.Days.$CurDayNode.Numbers.$Curnode.$hournode.dur
                        $durvalue = [convert]::ToInt32($durvalue,10) + [convert]::ToInt32($dur, 10)
                        $xml.Days.$CurDayNode.Numbers.$Curnode.$hournode.dur = $durvalue.Tostring()
                        $totaldurvalue = $xml.Days.$CurDayNode.Numbers.$Curnode.total.dur
                        $totaldurvalue = [convert]::ToInt32($totaldurvalue,10) + [convert]::ToInt32($dur, 10)
                        $xml.Days.$CurDayNode.Numbers.$Curnode.total.dur = $totaldurvalue.Tostring()

                        $numvalue = $xml.Days.$CurDayNode.Numbers.$Curnode.$hournode.num
                        $numvalue = [convert]::ToInt32($numvalue,10) + 1
                        $xml.Days.$CurDayNode.Numbers.$Curnode.$hournode.num = $numvalue.Tostring()
                        $totalnumvalue = $xml.Days.$CurDayNode.Numbers.$Curnode.total.num
                        $totalnumvalue = [convert]::ToInt32($totalnumvalue,10) + 1
                        $xml.Days.$CurDayNode.Numbers.$Curnode.total.num = $totalnumvalue.Tostring()
        }
       #>
    }
    }
}


$xml.Save("$path\Result.xml")

