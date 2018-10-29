#$Path = "C:\test\parsephones\excel"
$officePath="C:\Program Files (x86)\Microsoft Office\Office12"
$Path = Get-Location
$Path = $Path.Path
$PathOut = "$Path\CSV_OUT"
$PathIn = "$Path\CSV"
$PSEmailServer="mail.pirbank.ru"
$enc=[System.Text.Encoding]::UTF8

$files = New-Object System.Collections.ArrayList

Remove-Item "$Path\Diag_final.xlsm"
Remove-Item "$Path\TZ2.xls"

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
<#
echo "Before"
foreach ($file in $files){
    echo $file.Date $file.Name
    echo "---------------------------------------------"
}
#>

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
<#
echo "After"
foreach ($file in $files){
    echo $file.Date $file.Name
    echo "---------------------------------------------"
}
#>
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


& "$officepath\EXCEL.EXE" "$Path\TZ2.xls"
sleep 20
& "$officepath\EXCEL.EXE" "$Path\Diag_final.xlsm"
sleep 80

Send-MailMessage -From "notify@pirbank.ru" -Attachments "$Path\TZ2.xls", "$Path\Diag_final.xlsm" -To "ddorkin@pirbank.ru", "aakimov@tertehserv.ru", "mbayer@pirbank.ru" -Subject "Информация по звонкам" -Body "Files" -Encoding $enc
Send-MailMessage -From "notify@pirbank.ru" -Attachments "$Path\Diag_final.xlsm" -To "ddorkin@pirbank.ru", "asuvorov@pirbank.ru", "mbayer@pirbank.ru" -Subject "Информация по звонкам" -Body "Files" -Encoding $enc
