$dir="C:\test\convertfrombase64"
#$dir="$env:userprofile\Desktop\�������"
$flag=$false
$keyphrase="Content-Transfer-Encoding: base64"
$spacecounter=0


Clear-Host
Write-Host "�������� ������ ����� ������ � ���� unparsed.txt (� ��������� ���), ������� ��������� � ����� ������� �� ������� ����� (�������� ���� ����� ����� ���������� Ctrl+� ������ ������)"
Write-Host "����� ������� Enter"
Write-Host "��� ������� ���� ����� ���������� � ����� ������� ��� ��������� out.pdf"
Read-Host
Write-Host "����������..."

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

