/*
Осуществляет выборку по количеству платежей за день
Бакланов А.В. 13.09.2013
*/

{globals.i}
{norm.i}
{sh-defs.i}

DEF OUTPUT PARAMETER iRes AS INTEGER INIT 0 NO-UNDO.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iAccts AS CHARACTER NO-UNDO. /*ВАЛЮТА*,*БАНК-КЛИЕНТ*,*СЧЕТА*/
DEF VAR oPlast AS INTEGER INIT 0 NO-UNDO.

FOR EACH op-entry WHERE op-entry.acct-cr BEGINS "3" AND op-entry.op-date = iEndDate AND CAN-DO(ENTRY(3,iAccts,";"),STRING(op-entry.acct-db))
    AND op-entry.currency = ENTRY(1,iAccts,";") AND op-entry.user-id <> "PLASTIK" AND op-entry.user-id <> "BNK-CL" NO-LOCK,
FIRST op WHERE op.op = op-entry.op AND op.op-date = iEndDate
NO-LOCK.
iRes = iRes + 1.
END.

IF ENTRY(2,iAccts,";") = "1" THEN
	DO:
	FOR EACH op-entry WHERE op-entry.acct-cr BEGINS "3" AND op-entry.op-date = iEndDate AND CAN-DO(ENTRY(3,iAccts,";"),STRING(op-entry.acct-db))
    	   AND op-entry.user-id = "BNK-CL" NO-LOCK,
	FIRST op WHERE op.op = op-entry.op AND op.op-date = iEndDate
	NO-LOCK.
	oPlast = oPlast + 1.
	END.
END.

IF ENTRY(2,iAccts,";") = "1" THEN iRes = oPlast.
      
RETURN "".

        
