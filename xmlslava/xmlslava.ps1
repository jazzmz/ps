$path="C:\test\xmlslava"
$pathforcp="C:\test\xmlslava\cpdir"
$xml=New-Object XML

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
      $Object = $myXML.Envelope.Header.MessageInfo.LegacyTransportFileName
      $ObjectUnchanged=$Object.Substring(0,$Object.LastindexOf("."))
      $Object=$Object.Substring($Object.LastindexOf(".")+1,3)
      $Object=[convert]::Toint32($Object)
      if ($Object -eq 998) { SendMail "Файл $xmlname переполнен!" }
      if ($Object -ne 999) {
        $Object=$Object+1
        $Object=$Object.Tostring();
        while ($Object.Length -lt 3) {
            $Object="0"+$Object
        }
        $Object=$ObjectUnchanged+"."+$Object
        $myXML.Envelope.Header.MessageInfo.LegacyTransportFileName = $Object
        $myXML.Save("$path\$xmlname")
        Copy-Item -Force $path\$xmlname $pathforcp
        if (!$?){ SendMail "Возникла ошибка при копировании файла!" }
        break
      }
}      
}

SendMail "Ни одного файла не скопировано! `nОни либо отсутствуют, либо переполнены!"