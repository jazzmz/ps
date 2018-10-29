$Path="C:\test\sortother\KVtKliko"
$addrpath="C:\test\blat"
$text_to_send = "C:\test\blat\label.txt" 
$enc  = New-Object System.Text.utf8encoding
$PSEmailServer="mail.pirbank.ru"


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

function FormAnalysys ([string]$Form, [string]$EmailAddr){

$FindStr = $null
$flag = $false
ls -filter "*.kvt" $Path |% {

        $FindStr = $null
        $FindStr = get-content $_.FullName | ConvertTo-Encoding cp866 windows-1251 | Select-String "Код формы по ОКУД.*$Form.*" 
             if ($FindStr -ne $null) {
                $flag = $true
                $DocContent = get-content $_.FullName | ConvertTo-Encoding cp866 windows-1251
                echo $DocContent >>$text_to_send
                echo "---------------------------------------------------------------------------------------------" >>$text_to_send
		     }
    }

if ($flag) {
$content=Get-Content $text_to_send
echo $content
Send-MailMessage -from "root@pirbank.ru" -to "$EmailAddr" -subject "квит. на отправл. форму №$Form" -body "$content" -Encoding $enc
#   C:\blat\blat.exe $text_to_send -tf $addrpath\$EmailAddr -subject `"квит. на отправл. форму №$Form`"             
#  echo "$Form найдена, отправляю письмо на $EmailAddr"
}

$test = Test-Path $text_to_send
if ($test)
    {
    #del $text_to_send
    };

}

$test = Test-Path $text_to_send
if ($test)
    {
    del $text_to_send
    };

FormAnalysys 0409128 "ddorkin@pirbank.ru"