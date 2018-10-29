$url="http://192.168.21.25/doswi/awi.dll/~logon?frame=body"
$username="PIR"
$password="KB1234"
$workdir="D:\scripts\dorkin\"
$PSEmailServer="mail.pirbank.ru"
$utf8=[System.Text.Encoding]::UTF8
$to="admin@pirbank.ru"
$subject="Information about 365 form downloading"
$from="admin@pirbank.ru"
$savedir="T:\Operu\F365P\Rashifr\Temp"
$global:anyflag=$false

function sendmail ([string]$body) {
    Send-Mailmessage -from $from -to $to -subject $subject -body $body -encoding $utf8
}


function fixreg {
$flagreg=get-itemproperty -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Styles\" | Select MaxScriptStatements | % {$_.MaxScriptStatements} | Out-Null
if (!$?) {
    new-item -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\" -name Styles
    new-itemproperty -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Styles\" -name MaxScriptStatements -propertytype dword -value 0xFFFFFFFF
}
}

function FilterExclude {
$flag = Get-Content "$workdir\exclude.log" | Select-String $args[0]
if (!$flag) {
    return $true
    }
else {
    return $false
    }
}

function cz {
if (!$?){sendmail "Ошибка в ходе выполнения закачки";break}
}

function typeline {
$line = $args[0]
$chararr=$line.ToCharArray();cz
foreach ($sym in $chararr) {
$obj.SendKeys("$sym");cz
}
}

function GetPageList {
$ping=ping 192.168.21.25 -n 2
$flagping = $ping | select-string "Ответ от 192.168.21.25"
if (!$flagping){
sendmail "Unavailable channel!"
break
}
$flag=Test-Path "$workdir\temp"
$totalflag=$true
if ($flag){
    rm "$workdir\temp1"
    rm "$workdir\temp"
}
$ie = New-Object -com InternetExplorer.Application;cz
$ie.visible=$true;cz
$ie.navigate($url);cz
while($ie.ReadyState -ne 4) {start-sleep -m 100}
if ($ie.Document.Title -ne "Compaq Office Server Web Interface V7.0"){
    sendmail "Unavailable website!"
    $ie.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
    Remove-Variable ie
    break
}
$ie.document.getElementById("account").value=$username
$ie.document.getElementById("password").value=$password
$ie.document.getElementById("OK").click();cz
while($ie.ReadyState -ne 4) {start-sleep -m 100}
sleep 5
$url2="http://192.168.21.25/doswi/awi.dll/Post01/Pir/Main/Inbox?frame=body"
#$url2="http://192.168.21.25/doswi/awi.dll/Post01/Pir/Main/Inbox?ALL=1&frame=body"

$ie.navigate($url2);cz
while($ie.ReadyState -ne 4) {start-sleep -m 100}
$url2content = $ie.Document.Documentelement.InnerHTML
#$ie.Document.frames | foreach {$url2content = $_.document.documentElement.outerHTML}
write-output $url2content >> "$workdir\temp1"
while($ie.ReadyState -ne 4) {start-sleep -m 100}
$ie.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
Remove-Variable ie
Get-Content "$workdir\temp1" | % {
    echo $_ | Select-String "/doswi/awi.dll/Post01/Pir/Main/Inbox/" | Select-String "forsend_arj.txt" >> "$workdir\temp2"
}
Get-Content "$workdir\temp2" | Select-String "forsend_arj.txt" >> "$workdir\temp"
rm "$workdir\temp2"
Get-Date
#break
}
 

function GetPage {
$ping=ping 192.168.21.25 -n 2
$flagping = $ping | select-string "Ответ от 192.168.21.25"
if (!$flagping){
sendmail "Unavailable channel!"
break
}
$totalflag=$true
$count=0
if ($flag){
    rm "$workdir\temp"
}
$ie = New-Object -com InternetExplorer.Application;cz
$ie.visible=$true;cz
$ie.navigate($url);cz
while($ie.ReadyState -ne 4) {start-sleep -m 100}
if ($ie.Document.Title -ne "Compaq Office Server Web Interface V7.0"){
    sendmail "Unavailable website!"
    $ie.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
    Remove-Variable ie
    break
}
$ie.document.getElementById("account").value=$username
$ie.document.getElementById("password").value=$password
$ie.document.getElementById("OK").click();cz
while($ie.ReadyState -ne 4) {start-sleep -m 100}
sleep 5
#$url2contentSel = Get-Content "$workdir\temp" | Select-String "/doswi/awi.dll/Post01/Pir/Main/Inbox/" |Select-String "forsend_arj.txt"
$url2contentSel = Get-Content "$workdir\temp"
if ($url2contentSel -ne $null)  {
$url2contentSel | % {
    if (($_ -ne "") -and ($_ -ne $null)){
    $linemass = $_ -split "/"
    write-output $linemass[1]
    $id="D" + $linemass[1].Substring(1) + "1"
    #echo $id
    $dllink = "http://192.168.21.25/doswi/awi.dll/POST01/PIR/Main/Inbox/" + $id + "/Untitled.fgn"
    #echo $dllink
    $flag = FilterExclude $linemass[1];cz;
    <#if (!$flag) {
        $ie.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
        Remove-Variable ie
        continue}#>
    if ($flag) {
    if ($count -eq 0) {
        $count++
        echo $dllink
        $ie.navigate("$dllink");cz
        $obj = new-object -com WScript.SHell;cz
        while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $idie=(gps iexplore*).id
        $obj.AppActivate($idie);cz
        sleep 4
        #while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Tab}")
        sleep 3
        #while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Tab}")
        sleep 3
        #while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Tab}")
        sleep 3
        #while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Enter}")
        sleep 3
        #while($ie.ReadyState -ne 4) {start-sleep -m 100}
        typeline $savedir
        $obj.SendKeys("{Enter}")
        sleep 3
        typeline "$id.fgn"
        $obj.SendKeys("{Enter}")
        sleep 3
        while($ie.Busy){sleep 1}
        $filetest=Test-Path "$savedir\$id.fgn"
        if (!$filetest){
            sendmail "Не смог скачать файл $id"
        }
        $numforlog=$linemass[1]
        $date=Get-Date
        echo "$date $numforlog" >> "$workdir\exclude.log"
        $global:anyflag=$true
        #set-variable -name $anyflag -value ($true) -scope Global
        write-output "flag = $anyflag"
        $totalflag = $false
    }
    else {
        $ie.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
        Remove-Variable ie
        continue}
    }
    }
    }
    if ($totalflag) {
        $ie.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
        Remove-Variable ie
        break}
    }
    $ie.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
    Remove-Variable ie
}

Clear-Host
Get-Date
fixreg
GetPageList
do {
    GetPage
}
while (!$totalflag)
#$ie.Quit()
#[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie)
#Remove-Variable ie
Get-Date
if (!$anyflag){
    #sendmail "Ничего не скачалось"
    echo "flag=$anyflag"
}
sleep 10


