function ConvertTo-Encoding ([string]$From, [string]$To){
	Begin{
		$encFrom = [System.Text.Encoding]::GetEncoding($from)
		$encTo = [System.Text.Encoding]::GetEncoding($to)
	}
	Process{
		$bytes = $encTo.GetBytes($_)
		$bytes = [System.Text.Encoding]::Convert($encFrom, $encTo, $bytes)
		$encTo.GetString($bytes)
	}
}

function Execute-SOAPRequest 
( 
        [Xml]    $SOAPRequest, 
        [String] $URL,
        [String] $user,
        [String] $password, 
        [String] $function
) 
{ 
        write-host "Sending SOAP Request To Server: $URL" 
        $soapWebRequest = [System.Net.WebRequest]::Create($URL) 
        
        $soapWebRequest.Credentials = New-Object System.Net.NetworkCredential($user, $password);

        $soapWebRequest.ContentType = "text/xml;charset=`"utf-8`"" 
        #$soapWebRequest.Headers.Add("SOAPAction","`"http://tempuri.org/IMessageService/GetMessageContent`"")
        $soapWebRequest.Headers.Add("SOAPAction","`"http://tempuri.org/IMessageService/$function`"")
        $soapWebRequest.Headers.Add("Accept-Encoding: gzip,deflate")


        $soapWebRequest.Accept      = "text/xml" 
        $soapWebRequest.Method      = "POST" 

        #$SOAPRequest.Save("C:\test\SOAP\Echo.xml")
        
        write-host "Initiating Send." 
        $requestStream = $soapWebRequest.GetRequestStream() 
        $SOAPRequest.Save($requestStream) 
        $requestStream.Close() 
        
        write-host "Send Complete, Waiting For Response." 
        $resp = $soapWebRequest.GetResponse() 
        $responseStream = $resp.GetResponseStream() 
        $soapReader = [System.IO.StreamReader]($responseStream) 
        $ReturnXml = [Xml] $soapReader.ReadToEnd() 
        $responseStream.Close() 
        
        write-host "Response Received."

        return $ReturnXml 
}

$file = "D:\scripts\dorkin\test_reg.xml"
#$outfile = "C:\test\SOAP\out.xml"
$function = "GetDebtorRegister"
#$url = 'http://test.fedresurs.ru/MessageService/WebService.svc'
#$user = 'demowebuser'
#$password = 'Ax!761BN'
$url = 'http://bankrot.fedresurs.ru/MessageService/WebService.svc'
$user = 'Kraskov3'
$password = 'Q1qDAv'
<#
Clear-Host
if (Test-Path $outfile){
    Remove-Item $outfile
}
#>
#$datestring=(Get-Date).AddDays(0).Tostring("yyyy-MM-ddTHH:mm:ss")
$dateforname=Get-Date -Format "yyyyMMdd"
#echo $datestring
$outfile = "\\neon\disk_q\regdeb\DebtorRegister-$dateforname.xml"
$soap = [Xml](Get-Content $file) 

#$soap.Envelope.Body.$function.date = "$datestring"

#$soap.Save($file)


$ret = Execute-SOAPRequest $soap $url $user $password $function
if ($ret){
    $ret.Save($outfile)
    #Get-Content $outfile | ConvertTo-Encoding UTF-8 Windows-1251
    }