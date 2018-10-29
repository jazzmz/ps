###########################################################################
### Script for sorting incoming files. Made by Dorkin Dmitry 17.04.2013 ###
###########################################################################

#Variables
$currDay = Get-Date -format "dd"
#$currDay = "08"
$currMonth = Get-Date -format "MM"
#$CurrMonth="01"
$currYear = Get-Date -format "yyyy"
$pathwithfiles="C:\test\Razbor"
$addrpath = "C:\test\blat"
$text_to_send = "C:\test\blat\label.txt"

#Functions
function searchforsubstr ($token, $dirtoput, $addresses, $nomerformi)
{
echo "Сообщение по форме $nomerformi" >> $text_to_send

dir -Filter *.KVT -Name $pathwithfiles | % { 
   #echo $_ 
	$fileContent=Get-Content $pathwithfiles\$_
	$length=$fileContent.Count
	$i=0
	$flagtotal=$false
		do {	
			$substr=$fileContent[$i]
			$flag="$substr" -match $token
		    #echo "For $substr flag $flag with token $token"

			if ($flag)  	
                { 
				$flagtotal=$true
				    if ($token -eq "85491[0-9][0-9][0-9]\.0[1-3]1")
					{
					$subsplited=$substr -split '85491'
					$subsplited= $subsplited[1]
					$daytoputpodft = $subsplited.substring(1,2)
					if ($CurrDay -lt $daytoputpodft)
								{
								$monthtoputpodft=$CurrMonth-1
                                    if ($monthtoputpodft -le 9 )
                                         {
                                         $monthtoputpodft="0$monthtoputpodft"
                                         };
									if ($monthtoputpodft -eq "00") 
										{
										$monthtoputpodft=12
										$yeartoputpodft=$CurrYear-1
										}
									else
									    {
									    $yeartoputpodft=$CurrYear
									    };
								}
					else
								{
								$monthtoputpodft=$CurrMonth
								$yeartoputpodft=$CurrYear
								};
                    #echo "DAYTOPUT = $daytoputpodft.$monthtoputpodft.$yeartoputpodft"
                    $dirtoput="T:\Soft\ARMFM\ARCH\$yeartoputpodft\$monthtoputpodft\$daytoputpodft.$monthtoputpodft.$yeartoputpodft"
					};
				};
			$i++
		   }
		while ($i -le $length) 

	if ($flagtotal) { 
	               #echo "V faile $_ uslovie vipolneno!"
                    echo "mv $pathwithfiles\$_ $dirtoput"
                    $sendingflag=$true
	                }
	else 
	                 {
	                 #echo "V faile $_ uslovie NE vipolneno!"
	                 };
#pause
#cls

    }

if ($sendingflag)
 {
 $blatparams="$text_to_send -tf $addrpath\$addresses"
 #C:\test\blat\blat.exe $blatparams
 C:\test\blat\blat.exe $text_to_send -tf $addrpath\$addresses -subject `"Получены файлы по форме № $nomerformi`"
 sleep 2
 }
 del $text_to_send
}

#Main program
$test = Test-Path $text_to_send
if ($test)
    {
    del $text_to_send
    };

#podft
echo "Processing for PODFT"
searchforsubstr "85491[0-9][0-9][0-9]\.0[1-3]1" "XXX" dorkin.txt 321
echo ""

#Forma311
echo "Processing for Forma311"
searchforsubstr "SBC\w*\.txt" "T:\Operu\F311P\$CurrYear\IN\$CurrMonth\$CurrDay.$CurrMonth.$CurrYear" forma311.txt 311
echo ""

Forma364
echo "Processing for Forma364"
searchforsubstr "PS\w*\.xml" "T:\Operu\F364P\ARHIV\$CurrYear\IN\$CurrMonth\$CurrDay.$CurrMonth.$CurrYear" forma364.txt 364
echo ""