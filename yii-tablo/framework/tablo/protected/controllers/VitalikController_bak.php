<?php
 class VitalikController extends CController
{
    public function actions()
    {
        return array(
            'wf'=>array(
                'class'=>'CWebServiceAction',
            ),
        );
    }
 
    /**
     * @param string dt
     * @param string usdBuy
     * @param string eurBuy
     * @param string usdSell
     * @param string eurSell
     * @return float цена
     * @soap
     */
    public function setRate($dt,$usdBuy,$eurBuy,$usdSell,$eurSell)
    {
	return 1;
    }
}