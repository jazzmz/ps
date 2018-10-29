$url="http://192.168.21.25/doswi/awi.dll/~logon?frame=body"
$username="PIR"
$password="KB1234"
$workdir="D:\scripts\dorkin\"


Clear-Host

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
if (!$?){echo "Error!";break}
}

function typeline {
$line = $args[0]
$chararr=$line.ToCharArray();cz
foreach ($sym in $chararr) {
$obj.SendKeys("$sym");cz
}
}

function GetPage {
$ping=ping 192.168.21.25 -n 1
$flagping = $ping | select-string "Ответ от 192.168.21.25"
if (!$flagping){
echo "Unavailable channel!"
break
}
$flag=Test-Path "$workdir\temp"
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
    echo "Unavailable!"
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
#$url2="http://192.168.21.25/doswi/awi.dll/Post01/Pir/Main/Inbox?frame=body"
$url2="http://192.168.21.25/doswi/awi.dll/Post01/Pir/Main/Inbox?ALL=1"

$ie.navigate($url2);cz
while($ie.ReadyState -ne 4) {start-sleep -m 100}
$ie.Document.frames | foreach {$url2content = $_.document.documentElement.outerHTML}
echo $url2content > "$workdir\temp"
$url2contentSel = Get-Content "$workdir\temp" | Select-String "/doswi/awi.dll/Post01/Pir/Main/Inbox/" |Select-String "forsend_arj.txt"
if ($url2contentSel -ne $null)  {
$url2contentSel | % {
    $linemass = $_ -split "/"
    #echo $linemass[7]
    $id="D" + $linemass[7].Substring(1) + "1"
    #echo $id
    $dllink = "http://192.168.21.25/doswi/awi.dll/POST01/PIR/Main/Inbox/" + $id + "/Untitled.fgn"
    #echo $dllink
    $flag = FilterExclude $linemass[7];cz;
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
        #while($ie.Busy){sleep 1}
        $idie=(gps iexplore*).id
        $obj.AppActivate($idie);cz
        sleep 2
        while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Tab}")
        sleep 2
        while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Tab}")
        sleep 2
        while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Tab}")
        sleep 2
        while($ie.ReadyState -ne 4) {start-sleep -m 100}
        $obj.SendKeys("{Enter}")
        sleep 2
        while($ie.ReadyState -ne 4) {start-sleep -m 100}
        typeline "C:\TMP\"
        $obj.SendKeys("{Enter}")
        sleep 1
        typeline "$id.fgn"
        $obj.SendKeys("{Enter}")
        sleep 3
        while($ie.Busy){sleep 1}
        $numforlog=$linemass[7]
        $date=Get-Date
        echo "$date $numforlog" >> "$workdir\exclude.log"
        $totalflag = $false
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

fixreg

do {
GetPage
}
while ($totalflag)


