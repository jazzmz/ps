/** дата опер дня, в котором выполнялась транзакция */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** собственно код транзакции, которая выполнялась */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** пользователь, который запускал транзакцию */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.
/** идентификатор транзакции op-transaction.op-transaction */
DEFINE INPUT PARAMETER in-op-transaction AS CHAR NO-UNDO.

{globals.i}

DEF VAR dir AS CHAR NO-UNDO.
DEF VAR file-name AS CHAR NO-UNDO.
DEF VAR ulian-date AS INT NO-UNDO.

dir = FGetSetting("PIRCard","PathImp","").

/** вычисление юлианской даты - кол-ва дней с начала года */
ulian-date = in-op-date - DATE(1, 1, YEAR(in-op-date)) + 1.

file-name = dir + "c" 
	+ STRING(INT(FGetSetting("PIRCard","BranchCode","")),"9999") + "__1."
	+ STRING(ulian-date,"999").
	
RUN VALUE("pir-pctrdel.p")(INPUT file-name, INPUT in-op-date) NO-ERROR.

IF ERROR-STATUS:ERROR THEN 
	RETURN ERROR.
ELSE
	RETURN.

/** RETURN. */