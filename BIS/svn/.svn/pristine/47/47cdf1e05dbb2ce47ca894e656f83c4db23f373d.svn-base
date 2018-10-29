/*
 Смотрим операции за последние 3 месяца более 10 000 р. 
 Если операция 31 мая, то 3 месяца назад будет 28 фев или 29 фев. 30 мая, 3 месяц назад это 28 фев. или 29 фев.
 игнорируем операции менее 10 000 р., игнорируем переоценку.
Сделано на основе pir-6231.
12.07.2013
Никитина Ю.А.

*/
/******************************************************************************/


/************************
 * Процедура переработана.
 * 
 ************************
 * Автор: Маслов Д. А. Maslov D. A.
 * Заявка: #754
 * Дата создания: 27.09.2011
 ************************/
{globals.i}
DEFINE INPUT  PARAMETER iOp LIKE op.op NO-UNDO.                   /* Документ */
DEFINE OUTPUT PARAMETER oOk AS LOGICAL NO-UNDO INIT FALSE.

DEFINE VARIABLE dLastBigDat AS DATE    NO-UNDO.


DEF VAR oAcct AS TAcct   NO-UNDO.
DEF VAR oel AS TEventLog NO-UNDO.

DEF VAR dLine AS DECIMAL                 NO-UNDO INITIAL 10000.
DEF VAR nextStep AS LOGICAL INITIAL TRUE NO-UNDO.
DEF VAR i AS INTEGER                     NO-UNDO.

DEF VAR cTranMask AS CHARACTER           NO-UNDO.
DEF VAR date_m 	  AS DATE 		 NO-UNDO.

DO i = 1 TO NUM-ENTRIES(FGetSetting("Переоценка","","")):
  cTranMask = cTranMask + "!" + ENTRY(i,FGetSetting("Переоценка","","")) + ",".
END. /* do*/

cTranMask = cTranMask + "*".
oel = new TEventLog("file","./111.log").
oel:isEnable = FALSE.

/*************
 * По всем проводкам
 * из фильтра.
 *************/
FIND FIRST op
   WHERE (op.op EQ iOp)
   NO-LOCK NO-ERROR.

IF NOT AVAILABLE op
THEN RETURN "".

FOR EACH op-entry OF op
   NO-LOCK:

   /* #3231 смотрим операции за последние 3 месяца более 10 000 р. 
      Если операция 31 мая, то 3 месяца назад будет 28 фев или 29 фев. 30 мая, 3 месяц назад это 28 фев. или 29 фев.
      игнорируются операции менее 10 000 р.
      Date(месяц,день,год). Если текущий месяц минус 3 равно минусовое значание или 0, то значит текущий месяц янв, фев, март и 
      берем месяц предыдущего года.	
   */
   date_m = Date(if month(op-entry.op-date) - 3 <= 0 then 12 + month(op-entry.op-date) - 3 else month(op-entry.op-date) - 3,day(op-entry.op-date),if month(op-entry.op-date) - 3 <= 0 then year(op-entry.op-date) - 1 else year(op-entry.op-date)) NO-ERROR.
    
   IF ERROR-STATUS:ERROR THEN
   	date_m = TSysClass:getMonthEndDate(Date(if month(op-entry.op-date) + 3 <= 0 then 12 - month(op-entry.op-date) - 3 else month(op-entry.op-date) - 3,1,if month(op-entry.op-date) - 3 <= 0 then year(op-entry.op-date) - 1 else year(op-entry.op-date))).

   oel:send(1402,STRING(TIME) + "|*** ДИАПАЗОН:" + STRING(date_m + 1) + "-" + STRING(op-entry.op-date - 1)).
   oel:send(1402,"МАСКА ТРАНЗАКЦИЙ" + cTranMask).

   oAcct = new TAcct(op-entry.acct-db).
   IF CAN-DO("405*,406*,407*,40807*,40802*",op-entry.acct-db)
   THEN DO:
	oel:send(1402,STRING(TIME) + "|*** НАЧАЛОСЬ ДБ:" + op-entry.acct-db).
	      dLastBigDat = oAcct:getLastMoveByDate(date_m + 1,op.op-date - 1,dLine,cTranMask).
	oel:send(1402,STRING(TIME) + "|*** ЗАКОНЧИЛОСЬ ДБ" + op-entry.acct-db).

      IF (dLastBigDat EQ ?) and (oAcct:open-date <= date_m + 1)
      THEN DO:
		oOk = TRUE.
		nextStep = false.
      END.
   END.
   DELETE OBJECT oAcct.

      oAcct = new TAcct(op-entry.acct-cr).
   IF CAN-DO("405*,406*,407*,40807*,40802*", op-entry.acct-cr) AND nextStep
   THEN DO:
	oel:send(1402,STRING(TIME) + "|*** НАЧАЛОСЬ КР:" + op-entry.acct-cr).
	      dLastBigDat = oAcct:getLastMoveByDate(date_m + 1,op.op-date - 1,dLine,cTranMask).
	oel:send(1402,STRING(TIME) + "|*** ЗАКОНЧИЛОСЬ КР" + op-entry.acct-cr).


      IF (dLastBigDat EQ ?) and (oAcct:open-date <= date_m + 1)
      THEN DO:
		oOk = TRUE.
		nextStep = false.
      END.
   END.
END.
      DELETE OBJECT oAcct.
DELETE OBJECT oel.
{intrface.del}
RETURN "".
/******************************************************************************/
