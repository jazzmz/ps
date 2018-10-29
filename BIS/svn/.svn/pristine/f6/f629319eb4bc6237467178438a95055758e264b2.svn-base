/** дата опер дня, в котором выполнялась транзакция */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** собственно код транзакции, которая выполнялась */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** пользователь, который запускал транзакцию */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.
/** идентификатор транзакции op-transaction.op-transaction */
DEFINE INPUT PARAMETER in-op-transaction AS CHAR NO-UNDO.

/** отслеживаем нажатие ctrl+c в момент работы УТ
    если нажатие было, то op-transaction не создается и, следовательно,
    не передается в данную процедуру проверки */
IF TRIM(in-op-transaction) = "" THEN 
	RETURN ERROR.
ELSE
	RETURN.