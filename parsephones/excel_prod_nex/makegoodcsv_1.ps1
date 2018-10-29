#$Path = "C:\test\parsephones\excel"
$officePath="C:\Program Files (x86)\Microsoft Office\Office12"
$Path = Get-Location
$Path = $Path.Path
$PathOut = "$Path\CSV_OUT"
$PathIn = "$Path\CSV"
$PathBF = "$Path\CSV_Big"
$PSEmailServer="mail.pirbank.ru"
$enc=[System.Text.Encoding]::UTF8
$csvtitle = "Date;From;Account;To;`"Duration (sec.)`""

$files = New-Object System.Collections.ArrayList

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

function ChangeStr ([String]$str){
$newstr = ""
    for ($i=0;$i -lt $str.length; $i++){
        switch -casesensitive ($str[$i]) {
            "а" {$addsym = "a"}
            "б" {$addsym = "b"}
            "в" {$addsym = "v"}
            "г" {$addsym = "g"}
            "д" {$addsym = "d"}
            "е" {$addsym = "e"}
            "ё" {$addsym = "yo"}
            "ж" {$addsym = "j"}
            "з" {$addsym = "z"}
            "и" {$addsym = "i"}
            "й" {$addsym = "y"}
            "к" {$addsym = "k"}
            "л" {$addsym = "l"}
            "м" {$addsym = "m"}
            "н" {$addsym = "n"}
            "о" {$addsym = "o"}
            "п" {$addsym = "p"}
            "р" {$addsym = "r"}
            "с" {$addsym = "s"}
            "т" {$addsym = "t"}
            "у" {$addsym = "u"}
            "ф" {$addsym = "f"}
            "х" {$addsym = "h"}
            "ц" {$addsym = "ts"}
            "ч" {$addsym = "ch"}
            "ш" {$addsym = "sh"}
            "щ" {$addsym = "shch"}
            "ъ" {$addsym = ""}
            "ы" {$addsym = "i"}
            "ь" {$addsym = ""}
            "э" {$addsym = "e"}
            "ю" {$addsym = "yu"}
            "я" {$addsym = "ya"}
            "А" {$addsym = "A"}
            "Б" {$addsym = "B"}
            "В" {$addsym = "V"}
            "Г" {$addsym = "G"}
            "Д" {$addsym = "D"}
            "Е" {$addsym = "E"}
            "Ё" {$addsym = "Yo"}
            "Ж" {$addsym = "J"}
            "З" {$addsym = "Z"}
            "И" {$addsym = "I"}
            "Й" {$addsym = "Y"}
            "К" {$addsym = "K"}
            "Л" {$addsym = "L"}
            "М" {$addsym = "M"}
            "Н" {$addsym = "N"}
            "О" {$addsym = "O"}
            "П" {$addsym = "P"}
            "Р" {$addsym = "R"}
            "С" {$addsym = "S"}
            "Т" {$addsym = "T"}
            "У" {$addsym = "U"}
            "Ф" {$addsym = "F"}
            "Х" {$addsym = "H"}
            "Ц" {$addsym = "Ts"}
            "Ч" {$addsym = "Ch"}
            "Ш" {$addsym = "Sh"}
            "Щ" {$addsym = "Shch"}
            "Ъ" {$addsym = ""}
            "Ы" {$addsym = "I"}
            "Ь" {$addsym = ""}
            "Э" {$addsym = "E"}
            "Ю" {$addsym = "Yu"}
            "Я" {$addsym = "Ya"}
            Default {$addsym = $str[$i]}
        }
        $newstr = $newstr + $addsym
    }
 return $newstr   
 }



Remove-Item "$Path\Diag_final.xlsm"
#Remove-Item "$Path\TZ2.xls"
Remove-Item "$Path\CSV_OUT\*"
Remove-Item "$PathBF\*.ncsv"

Clear-Host

Get-ChildItem -Filter "*.csv" $PathBF | % {
    $filename = $_.BaseName
    Get-Content "$PathBF\$_" | % {
        echo $_  >> $PathBF\$filename.ncsv
    }
}



$date = ""
Get-ChildItem -Filter "*.ncsv" $PathBF | % {
    $filename = $_.name
    $curfilepath = $_.FullName
    #echo $filename
    $csv = Import-Csv -Delimiter ";" "$PathBF\$filename"
    $i=0
    #echo $csv.count

    while ($i -lt $csv.count) {
    #echo $i
        $dateold = $date
        $date = $csv[$i]."Дата"
        $time= $csv[$i]."Время"
        $from= ChangeStr($csv[$i]."Кто звонил")
        $account= ChangeStr($csv[$i]."Номер или Call-back компании")
        $destin= ChangeStr($csv[$i]."Кому звонили")
        $duration= $csv[$i]."Длительность вызова ЧЧ:MM:СС"
        if ("$duration" -ne "–"){
            $dursec=$duration.Substring(6,2)
            $durmin=$duration.Substring(3,2)
            $durh=$duration.Substring(0,2)
            $duration = [convert]::ToInt32($durh,10)*3600 + [convert]::ToInt32($durmin,10)*60 + [convert]::ToInt32($dursec,10)
            }
        $newstr = "`"" + $date + " " + $time + "`"" + ";" + $from + ";" + $account + ";" + $destin + ";" + $duration 
        $year=$date.Substring(6,4)
        $month=$date.Substring(3,2)
        $day=$date.Substring(0,2)
        $datename="$year"+"$month"+$day
        if ($date -ne $dateold) {
            #echo "New file"
            echo $csvtitle > "$PathIn\$datename.csv"
            }
        echo $newstr | ConvertTo-Encoding utf-8 windows-1251 >> "$PathIn\$datename.csv"
        #echo "$date === $time === $who === $duration"
        $i++
    }
}




Get-ChildItem -Filter "*.csv" $PathIn | % {
    $filename = $_.name
    $csv = Import-Csv -Delimiter ";" "$PathIn\$filename"
    $date = $csv[$csv.count-3].Date
    #echo "$filename $date"

    $CustomObject = New-Object –TypeName PSObject
    $CustomObject | Add-Member –MemberType NoteProperty –Name Name  –Value $filename
    $CustomObject | Add-Member –MemberType NoteProperty –Name Date  –Value $date
    $files.Add($CustomObject)
}

Clear-Host
Write-Host "Подождите, идет обработка файлов. Это займет некоторое время..."


$numfiles = $files.count

$flag = $false
While (!$flag){
    $flag = $true
    for ($i=0; $i -lt $numfiles-1;$i++){
        if ([DateTime]$files[$i].Date -gt [Datetime]$files[$i+1].Date){
            $TempFile=$files[$i]
            $files[$i] = $files[$i+1]
            $files[$i+1]=$TempFile
            $flag=$false
        }
    }
}

for ($i=0; $i -lt $files.count; $i++){
    $res = $i
    while ($res.Length -lt 5){
        $res = "0" + $res   
    }
    $newname = "Call" + $res + ".csv"
    $oldname = $files[$i].Name
    #Write-Host $files[$i].Date
    Move-Item "$PathIn\$oldname" "$PathIn\$newname"
}

if (Get-ChildItem $PathIn){
    if (Get-ChildItem $PathOut){
        Remove-Item "$PathOut\*"
    }
}

Get-ChildItem -Filter "*.csv" $PathIn | % {
    $FullName=$_.FullName
    $Base=$_.BaseName
    $NewName=$Base+"_rec.csv"
    $OldFile=Get-Content $FullName
    #echo $OldFile.Count
    for ($i=0;$i -lt $OldFile.Count; $i++){
        echo $OldFile[$OldFile.Count-$i] >> "$PathOut\$NewName"
        #sleep -m 500
    }
    if ($?){Remove-Item $FullName}
}




Copy-Item "$Path\Эталонные файлы\*" $Path


#& "$officepath\EXCEL.EXE" "$Path\TZ2.xls"
#sleep 20
& "$officepath\EXCEL.EXE" "$Path\Diag_final.xlsm"
sleep 30

#Send-MailMessage -From "notify@pirbank.ru" -Attachments "$Path\TZ2.xls", "$Path\Diag_final.xlsm" -To "ddorkin@pirbank.ru", "aakimov@tertehserv.ru", "mbayer@pirbank.ru" -Subject "Информация по звонкам" -Body "Files" -Encoding $enc
Send-MailMessage -From "notify@pirbank.ru" -Attachments "$Path\Diag_final.xlsm" -To "ddorkin@pirbank.ru", "asuvorov@pirbank.ru", "mbayer@pirbank.ru", "aakimov@tertehserv.ru" -Subject "Информация по звонкам" -Body "Files" -Encoding $enc
#Send-MailMessage -From "notify@pirbank.ru" -Attachments "$Path\Diag_final.xlsm" -To "ddorkin@pirbank.ru" -Subject "Информация по звонкам" -Body "Files" -Encoding $enc

#>