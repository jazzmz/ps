<?php
 class VitalikController extends CController

{
   CONST SPLITTER = " ";

    public function actions()
    {
        return array(
            'wf'=>array(
                'class'=>'CWebServiceAction',
            ),
        );
    }


public function MakingGoodString($str) {

$newstr="";

$pointPos = strpos($str,".");

for ($i=0;$i<strlen($str);$i++) {

  if (($i!=$pointPos && $i!=$pointPos-1) || $pointPos===FALSE) {
     $newstr.=$str[$i].self::SPLITTER;

  } else {
     $newstr.=$str[$i];
  };

};

$newstr = str_pad($newstr,12,self::SPLITTER);


return $newstr;
}

/*
public function MakingFinal($val, $sell, $buy) {

$sellpart = $this->MakingGoodString($sell);
$buypart = $this->MakingGoodString($buy);
$finalstr = "\\\$E,$val,$buypart,0,$sellpart,0";
return $finalstr;

}
*/
/**
     * @param string time
     * @param string dt
     * @param string usdBuy
     * @param string eurBuy
     * @param string usdSell
     * @param string eurSell
     * @return string
     * @soap
     */

public function setRate($time,$dt,$usdBuy,$eurBuy,$usdSell,$eurSell)
    {

//	$device = ' > /dev/ttyUSB0';
//	$paramUsd = $this->MakingFinal("00", $usdSell, $usdBuy);
//	$paramEur = $this->MakingFinal("01", $eurSell, $eurBuy);

	$seU = $this->MakingGoodString($usdSell);
        $buU = $this->MakingGoodString($usdBuy);
	$seE = $this->MakingGoodString($eurSell);
        $buE = $this->MakingGoodString($eurBuy);

//	$paramDat = "\\\$D,$dt";
//	$prefix_com = 'echo ';
        shell_exec("echo '\$T,$time' >/dev/ttyUSB0");
	shell_exec("echo '\$D,$dt' >/dev/ttyUSB0");
        shell_exec("echo '\$E,00,$buU,0,$seU,0' >/dev/ttyUSB0");
        shell_exec("echo '\$E,01,$buE,0,$seE,0' >/dev/ttyUSB0");
/*
	$command4exec = $prefix_com.$paramDat.$device;
	$err_code = shell_exec($command4exec);
	if ($err_code <> NULL)	{ return false; }

	$command4exec = $prefix_com.$paramUsd.$device;
	$err_code = shell_exec($command4exec);
	if ($err_code <> NULL) { return false; }

	$command4exec = $prefix_com.$paramEur.$device;
	$err_code = shell_exec($command4exec);
	if ($err_code <> NULL) { return false;  }

        $paramreturn = $paramUsd;
*/
#	return $paramreturn;
	return true;



    }
}
