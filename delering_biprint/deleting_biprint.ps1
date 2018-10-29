############################################
##                                        ##
## Скрипт для удаления файлов бипринт     ##
##                                        ##
## Автор: Доркин Дмитрий                  ##
##                                        ##
## Дата: 2014-09-09                       ##
##                                        ##
############################################

$CPUType=$env:processor_architecture

if ($CPUType -eq "AMD64"){
echo "У вас 64 разрядная OS"
$workingdir="C:\Program Files (x86)\BiPrint-Bank"
cmd /c "$workingdir\bpwinh.exe"
}
elseif ($CPUType -eq "x86"){
echo "У вас 32 разрядная OS"
$workingdir="C:\Program Files\BiPrint-Bank"
cmd /c "$workingdir\bpwinh.exe"
}
else {
echo "Неизвестный тип процессора"
exit
}


rm $workingdir\docs\_01\arc\*.CDX
rm $workingdir\docs\_01\arc\*.DBF
rm $workingdir\docs\_01\arc\*.FPT
rm $workingdir\docs\arc\*.CDX
rm $workingdir\docs\arc\*.DBF
rm $workingdir\docs\arc\*.FPT
echo "END!"
