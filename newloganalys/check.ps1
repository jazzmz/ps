$path="C:\test\newloganalys"
$log="$path\log2.txt"
$temp="$path\temp"
$file=""; 

$flag = Test-Path $temp
if ($flag){
    rm $temp
}
gc $log | % { 
        if ($_.Trim() -ne "" ) {
            $file=$file+$_+"`n"
        }
} 
echo $file >$temp 
$kacount=gc $temp | select-string "ка установлен"; 
$zashcount = gc $temp | select-string "зашифрован"; 
echo $kacount.Length; 
echo $zashcount.Length; 
if (($kacount.Length -eq 2) -and ($zashcount.Length -eq 1)) 
         {
            echo "all right"
            echo "true" >$path\shifr.txt
         } 
else 
         {
            echo "all bad"
            echo "false" >$path\noshifr.txt
         } 
rm $temp