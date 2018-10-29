/** Заглушка, которая может быть использована в работе транзакций, 
    основанных на процедуре pirustrt.p 
*/

/** дата опер дня, в котором выполнялась транзакция */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** собственно код транзакции, которая выполнялась */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** пользователь, который запускал транзакцию */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.



/**  Напоминание о необходимости подтвердить проводки выдачи 
*/

MESSAGE "А Вы подтвердили проводки выдачи ??? "
	VIEW-AS ALERT-BOX BUTTONS YES-NO 
	TITLE "ПРЕДУПРЕЖДЕНИЕ" 
	UPDATE choice AS LOGICAL.

IF choice = no THEN
	RETURN ERROR.



