$Path="C:\test\sendmailoutlook"

function SendMailMsg {

#Start-Process Outlook

$o = New-Object -com Outlook.Application

 
$mail = $o.CreateItem(0)

#2 = high importance email header
$mail.importance = 2

$mail.subject = “Subject here“

$mail.body = “Message body here“

#for multiple email, use semi-colon ; to separate
$mail.To = “ddorkin@pirbank.ru“

$mail.Send()

#$o.Quit()
}

function GetMessages {
 $olFolderInbox = 5
 $outlook = new-object -com outlook.application;
 $ns = $outlook.GetNameSpace("MAPI");
 $ns.Folders.Item(1).Folders | foreach {
 if ($_.Name -eq "Âàæíûå"){
        $MyFolder1=$_
    }
 if ($_.Name -eq "Îáðàáîòàííûå"){
        $MyFolder2=$_
    }
 }
 $inbox = $ns.GetDefaultFolder($olFolderInbox)
 #checks 10 newest messages
 
 $MyFolder1.items | Select-Object -Last 1 | foreach {
    #if(!$_.unread -eq $True) {
        # $_ | Get-Member
        $mBody = $_.body
        #Splits the line before any previous replies are loaded
        $mBodySplit = $mBody -split "From:"
        #Assigns only the first message in the chain
        $mBodyLeft = $mbodySplit[0]
        #build a string using the –f operator
        $q = "From: " + $_.SenderName + ("`n") + " Message: " + $mBodyLeft
        #create the COM object and invoke the Speak() method 
        echo $q
        $to = $_.To
        #echo "To: $to"
        if ($_.Attachments.Count -ne "0" ){
            $_.Attachments | foreach {
                $filename=$_.Filename
                $_.SaveAsFile("$Path\$filename")
            }
            #$_.Attachments.SaveAsFile($_.Attachments.FileName)
        }
        echo "_____________________________________________________________________________________________________________________________"
        if ($_.unread) {
         $_.Move($MyFolder2) | Out-Null
         }
    #} 
}


}

Clear-Host
GetMessages