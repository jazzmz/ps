/**
 * ПИРБанк, Ермилов В.Н., 28/12/2010 
 * Блокировка пластикового функционала
 *
*/

/** список транзакций, результы работы которых необходимо запретить редактировать */
DEF VAR PirBlockTrans AS CHAR NO-UNDO.

PirBlockTrans = FGetSetting("PirBlockTrans","","").

 /*message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box.*/ 

IF CAN-DO("!View,!ChgSts,!Undo,!Signs,*", iCodOper)
   AND
   CAN-DO(pirBlockTrans, op.op-kind)
   
THEN DO:
	oMsg = "Вы не имеете права изменять документ, созданный автоматизированным функционалом!".
    RETURN.	
END.