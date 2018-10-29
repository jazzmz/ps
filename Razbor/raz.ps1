dir -Filter *.KVT -Name  | % {  

	echo $_

	.\arj32.exe x -y $_ >NULL
							#echo $lastexitcode
	if ($lastexitcode -eq 0) {
	del $_
	echo "file $_ deleted"
			};

}
sleep 2
del *.arj
