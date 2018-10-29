########################################
### Script for sorting docs from ERA ###
### Author: Dorkin Dmitry            ###
### Date:   1.08.2013                ###
########################################


$Result = $null
$flagexist = $false
$Path="T:\temp\1"

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

function SearchingSubstings ([string]$Pattern){
	ls $Path |% {
#       echo $_.Fullname

        $FindStr = $null
        $FindStr = get-content $_.FullName | ConvertTo-Encoding cp866 windows-1251 | Select-String ".*$Pattern.*" 
             if ($FindStr -ne $null) {
             $Result = $Result + "`n" + "$FindStr"
             $flagexist = $true
#             echo $FindStr
#             echo $Result
		     }
    }
	
return $Result
}


SearchingSubstings 'заменил'
echo $Result
#if (!$flagexist) {
#                  send-mailmessage -from ddorkin@pirbank.ru -smtpserver mail.pirbank.ru -Subject "Message from Razbor" -Body $Result -to ddorkin@pirbank.ru
#                  }