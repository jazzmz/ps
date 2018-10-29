/**
 * ПИРБанк, Бурягин Е.П., 18/11/2009 
 * Реализация Алгоритма 2-2
 * Запрет отката неуполномоченному сотруднику
 *
*/

usersCanRollback = getThisUserXAttrValue('pirCanRollbackUsers').
pirRollbackStat = FGetSetting("PirRollbackStat","","").

/** message iStat iFlSal iFlDate iChkMaxSts iCodOper view-as alert-box. */

IF CAN-DO("!Signs,!View,!Copy,*", iCodOper)
   AND
   CAN-DO(pirRollbackStat, op.op-status)
   AND 
   op.user-inspector <> USERID('bisquit') 
   AND 
   NOT CAN-DO(usersCanRollback, op.user-inspector)
THEN DO:
	oMsg = "Вы не имеете права делать данную операцию с данным документом! Вы не являетесь его контролером, и пользователя-контролера нет в Вашем списке \"Замещаемые лица\".".
    RETURN.	
END.