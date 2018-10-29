[System.IO.File]::ReadAllText('q:\docum\common.psm1') | Invoke-Expression

###########################################
#                                         #
# !!! ОБЯЗАТЕЛЬНО ПОДКЛЮЧИТЬ ShowUI !!!   #
#                                         #
###########################################

####################

#
#
# Скрипт проверки правильности подписей
# 
########################################

<# СЛУЖЕБНЫЕ ПЕРЕМЕННЫЕ #>
<# Инициализируем массив дней #>
$DayArray = @();
for ($i=1;$i -lt 32;$i++) {
 if ($i -le 9) {
    $DayArray+=@("0$i");
	}
	else
	 { 
      $DayArray+=@("$i");
	 };
};

$currYear=getYear;
$CurrMonth=getMonth;
<#$DayArray=@("02","27");#>
$docum="q:\docum\$CurrYear\$CurrMonth";
$docum_s="q:\docum_s\$CurrYear\$CurrMonth";
$logfile="c:\2write\checkSign1.log";
<# КОНЕЦ СЛУЖЕБНЫХ ПЕРЕМЕННЫХ #>

clear;
<# ОЧИЩАЕМ ИНФОРМАЦИОННЫЙ ЖУРНАЛ #>
rm $logfile

"*** НАЧИНАЮ ПРОВЕРКУ xx.$CurrMonth.$CurrYear ***" >> $logfile;

foreach ($day in $DayArray) {
	echo "$docum\$day";
	$res=test-path "$docum\$day";
	
	if ($res) {
	"*** ПРОВЕРЯЮ ДЕНЬ $day ***" >> $logfile;
	    dir  -Recurse $docum\$day | where{!$_.PsIsContainer} | <#where{!($_ -like "BNK-CL*")} |#> % {
			# Смотрим по документам
			$isSign1="False";
			$isSign2="False";
            $isSign3="False";

			echo "ПРОВЕРЯЮ $_ ...";
			$res=Test-Path "$docum_s\$day\1\$_.sgn";
				if ($res) {
				   q:\docum\cryptcp.exe -nochain -dir "$docum_s\$day\1" -vsignf  $_.FullName | ConvertTo-Encoding windows-1251 cp866 | % { $_; if ($_ -like "*OK?") {$isSign1="True"};}
				}
				else { $isSign1="NoSign" }
				
				
			$res=Test-Path "$docum_s\$day\2\$_.sgn";
				if ($res) {
				   q:\docum\cryptcp.exe -nochain -dir "$docum_s\$day\2" -vsignf  $_.FullName | ConvertTo-Encoding windows-1251 cp866 | % { if ($_ -like "*OK?") {$isSign2="True"};}
				}
				else { $isSign2="NoSign"}

			$res=Test-Path "$docum_s\$day\3\$_.sgn";
				if ($res) {
				   q:\docum\cryptcp.exe -nochain -dir "$docum_s\$day\3" -vsignf  $_.FullName | ConvertTo-Encoding windows-1251 cp866 | % { if ($_ -like "*OK?") {$isSign3="True"};}
				}
				else { $isSign3="NoSign" }

				
#				if ($_ -like "BNK-CL*" -or $_ -like "03000KOV*") {

#   				   if (($isSign1 -eq "False") -or ($isSign2 -eq "False")) {
#				      echo "1|$_|$isSign1|$isSign2" >> $logfile;
#		                 	   };
#				}
#				else {
                if ($isSign3 -eq "NoSign" ) {
				      if (($isSign1 -ne "True") -or ($isSign2  -ne "True")) {
				    	  echo "2|$_|$isSign1|$isSign2" >> $logfile;
  				       }
                }
                else {
                      if ($isSign1 -eq "NoSign") {
                      	  echo "2|$_|$isSign2|$isSign3" >> $logfile;
                      }
                      elseif ($isSign2 -eq "NoSign") {
                          echo "2|$_|$isSign2|$isSign3" >> $logfile;
                      }
                      else {
                          echo "2|$_|$isSign1|$isSign2|$isSign3" >> $logfile;
                      }
                }
#				}			
		};
	};

};