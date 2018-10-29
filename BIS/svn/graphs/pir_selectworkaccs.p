/*
Осуществляет выборку счетов с оборотами не позже N дней из Analiz.ini
по рублевым, валютным и пластиковым счетам
Бакланов А.В. 12.09.2013
*/

{globals.i}
{norm.i}
{sh-defs.i}

DEF OUTPUT PARAMETER iRes AS INTEGER INIT 0 NO-UNDO.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iAccts AS CHARACTER NO-UNDO. /*ВАЛЮТА*,*Nдней*,*ПЛАСТИК*,*СЧЕТА*/
DEF VAR oPlast AS INTEGER INIT 0 NO-UNDO.

FOR EACH bal-acct WHERE CAN-DO(ENTRY(4,iAccts,";"), string(bal-acct.bal-acct,"99999"))
 	NO-LOCK,
    	EACH acct OF bal-acct WHERE (acct.close-date > iEndDate OR acct.close-date = ?) AND acct.currency = ENTRY(1,iAccts,";") NO-LOCK:
	RUN acct-pos IN h_base (acct.acct, acct.currency, iEndDate, iEndDate, CHR(251)).
	IF lastmove EQ ? THEN lastmove = DATE("01/01/1990").
	IF lastmove > iEndDate - INTEGER(ENTRY(2,iAccts,";")) THEN iRes = iRes + 1.
	IF ENTRY(3,iAccts,";") = "пласт" AND CAN-DO("40817....000.05*", STRING(acct.acct)) 
	    AND (lastmove > iEndDate - INTEGER(ENTRY(2,iAccts,";"))) THEN oPlast = oPlast + 1.
	
/* Более правильный способ подсчета, но результат не сходится с Анализом!
FOR EACH bal-acct WHERE CAN-DO(ENTRY(4,iAccts,";"), string(bal-acct.bal-acct,"99999"))
 	NO-LOCK,
    	EACH acct OF bal-acct WHERE acct.currency = ENTRY(1,iAccts,";") AND (acct.close-date > iEndDate OR acct.close-date = ?) NO-LOCK:
	FIND FIRST op-entry WHERE (op-entry.op-date >= iEndDate - INTEGER(ENTRY(2,iAccts,";"))) AND (op-entry.currency = ENTRY(1,iAccts,";"))
		AND (op-entry.acct-db = acct.acct) AND (op-entry.acct-cr NOT BEGINS "6") AND op-entry.op-status > "Ф"
	NO-LOCK NO-ERROR.
	IF AVAILABLE op-entry THEN iRes = iRes + 1.
        ELSE
        DO:
	FIND FIRST op-entry WHERE (op-entry.op-date >= iEndDate - INTEGER(ENTRY(2,iAccts,";"))) AND (op-entry.currency = ENTRY(1,iAccts,";"))
	AND (op-entry.acct-cr = acct.acct) AND (op-entry.acct-db NOT BEGINS "6") AND op-entry.op-status > "Ф"
	NO-LOCK NO-ERROR.
	IF AVAILABLE op-entry THEN iRes = iRes + 1.

        END.
*/
END.
IF ENTRY(3,iAccts,";") = "пласт" THEN iRes = oPlast.
      
RETURN "".

        
