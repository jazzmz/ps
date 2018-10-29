dir -Filter *.txt -Name T:\OPERU\F365P\Rashifr | % { 
	#echo $_ 
	$fileContent=Get-Content T:\OPERU\F365P\Rashifr\$_
	$length=$fileContent.Count
	$i=0
	$flag=$false
		do {
			#echo $fileContent[$i];$i++
			if ($fileContent[$i] -eq "20@@@")  {
				$flag=$true
							};
		   }
		while ($i -le $length)

	if ($flag) { 
	#echo "Uslovie vipolneno!"
	}
	else 
	     {
	echo "V faile $_ Uslovie NE vipolneno!"
	     };

}
pause