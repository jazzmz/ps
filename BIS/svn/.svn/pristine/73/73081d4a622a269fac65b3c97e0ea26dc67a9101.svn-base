/** Заглушка, которая может быть использована в работе транзакций, 
    основанных на процедуре pirustrt.p 
*/

/** дата опер дня, в котором выполнялась транзакция */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** собственно код транзакции, которая выполнялась */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** пользователь, который запускал транзакцию */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.
/** идентификатор транзакции op-transaction.op-transaction */
DEFINE INPUT PARAMETER in-op-transaction AS CHAR NO-UNDO.



/*MESSAGE " BEGIN CHECK! " VIEW-AS ALERT-BOX.*/

FIND FIRST pc-trans WHERE pc-trans.pctr-status = 'ГОТ' NO-LOCK NO-ERROR .

IF AVAIL pc-trans THEN 
DO:
    MESSAGE "НЕ ВСЕ ТРАНЗАКЦИИ УСПЕШНО ОБРАБОТАНЫ !!! " VIEW-AS ALERT-BOX.
    RETURN ERROR.
END.    
ELSE 
DO:
    /* MESSAGE " ВСЕ OK! " VIEW-AS ALERT-BOX. */
    RETURN.
END.