$dir="C:\test\convertfrombase64"
#$dir="$env:userprofile\Desktop\Декодер"
$flag=$false
$keyphrase="Content-Transfer-Encoding: base64"
$spacecounter=0


Clear-Host
Write-Host "Вставьте полный текст письма в файл unparsed.txt (и сохранить его), который находится в папке Декодер на рабочем столе (выделить весь текст можно сочетанием Ctrl+Ф внутри письма)"
Write-Host "Затем нажмите Enter"
Write-Host "Ваш готовый файл будет находиться в папке Декодер под названием out.pdf"
Read-Host
Write-Host "Преобразую..."

$flagE=Test-Path "$dir\parsed.log"
if ($flagE){Remove-Item "$dir\parsed.log"}

Get-Content "$dir\unparsed.txt" | % {
if ($flag){
    if ($_.Trim() -eq ""){$spacecounter++}
}

if (($flag) -and ($spacecounter -gt 0) -and ($spacecounter -lt 2)){
    echo $_ >> "$dir\parsed.log"
    }

if ($_ -eq $keyphrase){
    $flag=$true;
    }
}

$basestr=Get-Content "$dir\parsed.log"
$b  = [System.Convert]::FromBase64String($basestr)
set-content -encoding byte "$dir\out_d.pdf" -value $b

$flagE=Test-Path "$dir\parsed.log"
if ($flagE){Remove-Item "$dir\parsed.log"}

echo "" > "$dir\unparsed.txt"

