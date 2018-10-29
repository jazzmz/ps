$LOG_DIR='C:\test\nc111nt\logs'

function deleteempty() {
dir -filter *.xml $LOG_DIR |% {
$str=$null;
$flag=$false;
                cat $LOG_DIR\$_ |% {
                                                if ($_ -ne $null) {
                                                                   $flag=$true
                                                                  }
                                   }
if (!$flag) {
            del $LOG_DIR\$_
            }

                              }
                        };

while (1 -lt 2) {
deleteempty;
$currDay = Get-Date -format "dd"
$currMonth = Get-Date -format "MM"
$currYear = Get-Date -format "yyyy"
$currHour = Get-Date -format "HH"
$currMinute = Get-Date -format "mm"
$currSecond = Get-Date -format "ss"
C:\test\nc111nt\nc.exe -l -p 12345 >$LOG_DIR\$currYear$CurrMonth$currDay$currHour$currMinute$currSecond.xml
}

