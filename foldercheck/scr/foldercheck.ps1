$PSEmailServer="mail.pirbank.ru"
$utf8=[System.Text.Encoding]::UTF8
$to="kolosova@pirbank.ru"
$subject="Ќовый файл от провер€ющих!"
$from="notify@pirbank.ru"

$workdir="C:\test\foldercheck" 
$dirname="Z:\«јя¬ »"


Clear-Host

if (Test-Path "$workdir\newfile.log"){rm "$workdir\newfile.log"}
if (Test-Path "$workdir\dist.log"){rm "$workdir\dist.log"}
if (!(Test-Path "$workdir\dist.log")){echo "" > "$workdir\dist.log"}

Get-Childitem -R $dirname | % {
    $name=$_.name
    if ($name.Substring(0,1) -ne "~"){
        echo $_.Fullname >> "$workdir\newfile.log"
    }
}


Get-Content "$workdir\newfile.log" | % {
$newfile=$_
$flag=$false
    Get-Content "$workdir\oldfile.log" | % {
        if ("$_" -eq "$newfile"){$flag=$true}
    }
    if (!$flag){
        echo "$newfile" >> "$workdir\dist.log"
    }
}

if (Test-Path "$workdir\oldfile.log"){rm "$workdir\oldfile.log"}

mv "$workdir\newfile.log" "$workdir\oldfile.log"

$bodyflag=Get-Content "$workdir\dist.log"
$body=""
Get-Content "$workdir\dist.log" | % { 
$body=$body + "<br>" + "$_"
}
if ("$bodyflag" -ne ""){
    Send-Mailmessage -from $from -to "$to" -subject $subject -body "$body" -encoding $utf8 -BodyAsHtml
    }