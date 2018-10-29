$path="C:\test\ciphercheck"
$log="$path\log.txt"

$flag = Test-Path $path\res.txt
if ($flag){
    rm $path\res.txt
}
#echo "your param $args"
$res=Get-Content $log | Select-String "Зашифрован"
if ($res){
            $res=Get-Content $log | Select-String "КА установлен"
            if ($res){
                echo "true" >$path\res.txt
            }
            else {
                echo "false" >$path\res.txt
            }
}
else {
echo "false" >$path\res.txt
}