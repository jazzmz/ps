/**
 * ПИРБанк, Ермилов В.Н., 23/07/2010 
 * Запрет на редактирование документа, помеченного валютным контролем
 *
*/

 /*message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box.*/ 

IF CAN-DO("!View,!ChgSts,!Undo,!Signs,*", iCodOper)
   AND
   (GetXattrValueEx("op", string(op.op), "PIRcheckVO","") EQ "Да")
THEN DO:
	oMsg = "Вы не имеете права изменять документ, помеченный валютным контролем!".
    RETURN.	
END.