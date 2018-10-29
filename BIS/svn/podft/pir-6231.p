/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2009 ЗАО "Банковские информационные системы"
     Filename: pir-6231.p
   Parameters:
         Uses:
      Used by:
      Created: 26.04.2011 admbav
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

   oel:send(6231,STRING(TIME) + "|*** ДИАПАЗОН:" + STRING(op-entry.op-date - 180) + "-" + STRING(op-entry.op-date - 1)).
   oel:send(6231,"МАСКА ТРАНЗАКЦИЙ" + cTranMask).


   oAcct = new TAcct(op-entry.acct-db).
   IF CAN-DO("405*,406*,407*,40807*,40802*",op-entry.acct-db) AND oAcct:open-date >= op-entry.op-date - dLine
   THEN DO:
	oel:send(6231,STRING(TIME) + "|*** НАЧАЛОСЬ ДБ:" + op-entry.acct-db).
	      dLastBigDat = oAcct:getLastMoveByDate(op.op-date - 180,op.op-date - 1,dLine,cTranMask).
	oel:send(6231,STRING(TIME) + "|*** ЗАКОНЧИЛОСЬ ДБ" + op-entry.acct-db).

      IF (dLastBigDat EQ ?)
      THEN DO:
		oOk = TRUE.
		nextStep = false.
      END.
   END.
   DELETE OBJECT oAcct.

      oAcct = new TAcct(op-entry.acct-cr).
   IF CAN-DO("405*,406*,407*,40807*,40802*", op-entry.acct-cr) AND oAcct:open-date > op-entry.op-date - dLine AND nextStep
   THEN DO:
	oel:send(6231,STRING(TIME) + "|*** НАЧАЛОСЬ КР:" + op-entry.acct-cr).
	      dLastBigDat = oAcct:getLastMoveByDate(op.op-date - 180,op.op-date - 1,dLine,cTranMask).
	oel:send(6231,STRING(TIME) + "|*** ЗАКОНЧИЛОСЬ КР" + op-entry.acct-cr).


      IF (dLastBigDat EQ ?)
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
