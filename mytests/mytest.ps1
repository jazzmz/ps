$dir="C:\test\mytests"

Add-Type -AssemblyName System.IO.Compression.FileSystem

$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal

[System.IO.Compression.ZipFile]::CreateFromDirectory("$dir\dirforzip", "$dir\a.zip", $compressionLevel, $false)

$Bytearr=Get-Content "$dir\a.zip" -Encoding Byte

$Base64str=[Convert]::ToBase64String($Bytearr)

echo $Base64str > "$dir\base64coded.log"

rm "$dir\a.zip"

$BytesCon=[Convert]::FromBase64String($Base64str)

[System.IO.File]::WriteAllBytes("$dir\decoded.zip",$BytesCon)