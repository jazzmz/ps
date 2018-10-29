$path="C:\test\365formanalyz"

$flag=Test-Path $path\error
if ($flag){
    rm $path\error
}

Get-Childitem $path -Filter IZ*txt | % {
$i=0 
$file=$_   
    Get-Content $_ | % {
        $i++
        if ($i -eq 2){
            $resline=$_.Substring(0,2)
            if ($resline -ne "01"){
                echo "File $file has code $resline, it's wrong!"
                echo "$file" >>$path\error
            }
        }
    }
}