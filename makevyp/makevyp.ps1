$dir="Q:\doc"
$desktop="$env:Userprofile\Desktop"

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


Get-ChildItem -Filter "vipis*.bol" $dir | % {
$name=$_.Name
$filepath=$_.Fullname
$i=0

    Get-Content $filepath | % {
        $i++
        if ($i -eq "1"){
            $line = $_ | ConvertTo-Encoding cp866 windows-1251 
            #echo $line.Substing
            $count=0
            do
             {
                $line=$line.Substring(1)
                $count++
                #echo $line
             }
             while ($line.Substring(0,1) -ne " ")
             $count2=0
            do
                {
                    $line = " " + $line
                    $count2++
                    #echo $line
                }
                while ($count2 -lt $count) 
                echo $line > "$desktop\$name.txt"
        }
        else
        {
            echo $_ | ConvertTo-Encoding cp866 windows-1251  >> "$desktop\$name.txt"
        }
    }


}