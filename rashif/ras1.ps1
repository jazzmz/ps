$dir="C:\test\rashif";

Get-Childitem -Filter *.ED $dir | foreach {
    $file = $_.Name
    [string]$Base64Str = Get-Content $_.Fullname | Select-String "Object"
    $Base64StrCr=$Base64Str.Substring($Base64Str.IndexOf(">")+1,$Base64Str.Length-27)
    $b  = [System.Convert]::FromBase64String($Base64StrCr)
    set-content -encoding byte "$dir\$file.dat" -value $b    
}
