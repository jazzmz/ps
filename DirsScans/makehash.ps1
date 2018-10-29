Get-Childitem -Filter *.ps1 | % {
$someString = Get-Content $_.Fullname
$md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = new-object -TypeName System.Text.UTF8Encoding
$hash = [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($someString)))
echo "$_ $hash"
}