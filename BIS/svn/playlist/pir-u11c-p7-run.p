/** Заглушка, которая может быть использована в работе транзакций, 
    основанных на процедуре pirustrt.p 
*/

/** дата опер дня, в котором выполнялась транзакция */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** собственно код транзакции, которая выполнялась */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** пользователь, который запускал транзакцию */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.



/**  Напоминание о необходимости провести приход 
*/

MESSAGE "А Вы провели кредитовые проводки (приход) ??? "
	VIEW-AS ALERT-BOX BUTTONS YES-NO 
	TITLE "ПРЕДУПРЕЖДЕНИЕ" 
	UPDATE choice AS LOGICAL.

IF choice = no THEN
	RETURN ERROR.




/**  Убрано в связи с разделением плей-листа (пластики и кредиты)
*/

/*
FIND FIRST op WHERE op.op-date		EQ	in-op-date
                AND op.op-status	LT	'√'
                AND op.user-id 		EQ  'PLASTIK' 

NO-LOCK NO-ERROR.
                      

IF AVAIL op THEN 
DO:
	MESSAGE "ОШИБКА! НАЙДЕНЫ НЕОТКОНТРОЛИРОВАННЫЕ ДОКУМЕНТЫ !!" VIEW-AS ALERT-BOX.
	RETURN ERROR.
END.
ELSE 
DO:
/*MESSAGE " ALL OK!" VIEW-AS ALERT-BOX.*/
RETURN.
END.
*/
