$path="C:\test\newxml"
$pathforcp="C:\test\newxml\cpdir"
#$xml=New-Object XML

Function SendMail ($message) {
    $smtpServer="mail.pirbank.ru"
    $emailFrom="notify@pirbank.ru"
    $emailRcpt="ddorkin@pirbank.ru"
    $emailSubject="Message about files"
    $utf8  = New-Object System.Text.utf8encoding
    $smtp = New-Object Net.Mail.SmtpClient -arg $smtpServer
    $msg = New-Object Net.Mail.MailMessage
    $msg.From = $emailFrom
    $msg.To.Add($emailRcpt)
    $msg.Subject = $emailSubject
    $msg.Body = $message
    $msg.SubjectEncoding = $utf8
    $msg.BodyEncoding = $utf8
    $smtp.Send($msg) 
}

 Get-ChildItem -exclude *.ps1 $path | % {
 if (!$_.PsIsContainer){
      $xmlname=$_.Name
      [xml]$myXML = Get-Content $path\$xmlname
      $EdNo = $myXML.ED999.EDNo
      $EdDate = $myXML.ED999.EDDate
      $CurDate=Get-Date -Format "yyyy-MM-dd"
      if ($EdNo) {
      $EdNo=[convert]::Toint32($EdNo)
      if ($EdNo -eq 998) { SendMail "Файл $xmlname переполнен!" }
      if ($EdNo -ne 999) {
        $EdNo=$EdNo+1
        $EdNo=$EdNo.Tostring();

        #while ($Object.Length -lt 3) {
        #    $Object="0"+$Object
        #}
        echo "$EdNo $EdDate $CurDate"

        if ("$EdDate" -ne "$CurDate")
        {
           $myXML.ED999.EdDate = "$CurDate"
           $myXML.ED999.EDNo = "50"
        }
        else
        {
            $myXML.ED999.EDNo = "$EdNo"
        }
        $myXML.Save("$path\$xmlname")
        Copy-Item -Force $path\$xmlname $pathforcp
        if (!$?){ SendMail "Возникла ошибка при копировании файла!" }
        break
      }
      }
}      
}

SendMail "Ни одного файла не скопировано! `nОни либо отсутствуют, либо переполнены!"