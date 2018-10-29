$file = "C:\test\smsservice\phoneslist.txt"

$message = Read-Host "Enter mesage string: ";
Get-Content $file | % {
$newstring = $_ + ":" + $message
echo $newstring
}