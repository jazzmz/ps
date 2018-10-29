/**
 * ПИРБанк, Бурягин Е.П., 18/05/2010 
 * Реализация Алгоритма 2-3
 * Запрет на редактирование документа, созданного на основании транзакции ПЦ
 *
*/

/* message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box. */

IF CAN-DO("!View,!ChgSts,!Undo,!Signs,*", iCodOper)
   AND
   (GetXattrValueEx("op", string(op.op), "ТранзПЦ","") NE "")
   AND 
   getThisUserXAttrValue('pirCanEditPCTransOp') <> "Да"
THEN DO:
	oMsg = "Вы не имеете права изменять документ, созданный на основании Транзакции ПЦ!".
    RETURN.	
END.