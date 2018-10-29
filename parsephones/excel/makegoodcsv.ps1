$Path = "C:\test\parsephones\excel"
$PathOut = "$Path\CSV_OUT"
$PathIn = "$Path\CSV"

$files = New-Object System.Collections.ArrayList

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
Write-Host "ֿמהמזהטעו, טהוע מבנאבמעךא פאיכמג. Ýעמ חאילוע םוךמעמנמו גנולÿ..."
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
}