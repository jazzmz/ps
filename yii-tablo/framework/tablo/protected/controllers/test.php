<?
//$command4exec = 'echo -e "\$T,01:45:00" > /dev/ttyUSB0';
//$out=shell_exec($command4exec);
//echo $out;
$prefix_com = 'echo -e ';
$paramDat = '\$T,11:45:00 ';
$paramUsd = "22.22";
$device = ' > /dev/ttyUSB0';
//$command4exec = $prefix_com.$paramDat."> /dev/ttyUSB0";
//$command4exec = $prefix_com.$paramDat.' > /dev/ttyUSB0';
$command4exec = $prefix_com.$paramDat.$device;
$err_code = shell_exec($command4exec);
//shell_exec ('echo -e "\$T,11:45:00" > /dev/ttyUSB0');
?>
