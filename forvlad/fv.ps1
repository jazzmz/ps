$file = "C:\test\forvlad\111.txt"

get-content $file | % {
echo $_
sleep 1
}