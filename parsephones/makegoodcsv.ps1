Clear-Host
$Path = "C:\test\parsephones\excel";
$PathIn = "$Path\CSV"
$PathOut = "$Path\CSV_OUT"

if (Get-ChildItem $PathOut){
    Remove-Item "$PathOut\*"
}


$files = New-Object System.Collections.ArrayList
Get-ChildItem $PathIn -Filter *.csv | Sort-Object -Property Name | % {
    $Name = $_.Name
    $csv = Import-Csv -Delimiter ";" "$PathIn\$Name"
    $date = $csv[$csv.count-3].Date
    $CustomObject = New-Object –TypeName PSObject
    $CustomObject | Add-Member –MemberType NoteProperty –Name Name  –Value $Name
    $CustomObject | Add-Member –MemberType NoteProperty –Name Date  –Value $date
    $files.Add($CustomObject)
}
Clear-Host
<#
echo "Before Sorting"
foreach ($file in $files){
    echo $file.Date
}
#>
$flag = $false
While (!$flag){
    $flag = $true
    for ($i=0; $i -lt $files.Count -1; $i++){

        if ([datetime]$files[$i].Date -gt [datetime]$files[$i+1].Date){
            $filesProm = $files[$i]
            $files[$i] = $files[$i+1]
            $files[$i+1] = $filesProm
            $flag = $false
        }
    }
}
<#
echo "After Sorting"
foreach ($file in $files){
    echo $file.Date
}
#>

for ($i=0; $i -lt $files.Count; $i++){
    $res = $i
    while ($res.Length -lt 5){
        $res = "0" + $res
    }
    #echo "$res - $i"
    #echo $i
    #echo $files[$i].Date
    $FileForRen = $files[$i].Name
    $NewName = "Call"+$res+".csv"
    Move-Item "$PathIn\$FileForRen" "$PathIn\$NewName"
}


Get-ChildItem $PathIn -Filter *.csv | Sort-Object -Property Name | % {
$basename = $_.BaseName
$newname = $basename + "_rec.csv"
$file = "$PathIn\$_"; 
$newfile = "$PathOut\$newname"; 

If (Test-Path $newfile) {Remove-Item $newfile}; 
$csv = Get-Content $file 

for ($i = 0; $i -lt $csv.Length; $i++){
    $element = $csv[$csv.Length-$i]
    if (($element -ne $null) -and ($element.Trim() -ne "")){
            echo $element >> $newfile
    }
}

}