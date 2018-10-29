/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-pko.p
      Comment: Отчет по клиенту формирующий реестр платежей по ндфл и проводок по снятию ден средств
   Parameters: 
         Uses: Globals.I tmprecid.def SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 20/10/2008 Templar
     Modified:
*/

{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR client_id	as int  no-undo.

DEFINE VAR summadoc	as int  no-undo.
DEFINE VAR summadoc2	as int  no-undo.

DEFINE VAR date1		as date  no-undo.
DEFINE VAR v_name		as char  no-undo.
DEFINE VAR v_racct	as char  no-undo.
DEFINE VAR client_nm	as char  no-undo.

/*-------------------------------------- Main ------------------------------------------------------------------*/


{getdates.i}

{setdest.i}

{tmprecid.def}
{get-bankname.i}
FOR EACH tmprecid NO-LOCK,
FIRST acct WHERE RECID(acct) = tmprecid.id AND acct.contract EQ "Расчет" NO-LOCK: 

 IF AVAIL acct THEN 
	DO:
	v_racct = acct.acct .
	client_id = acct.cust-id.

	summadoc = 0.


 	FIND FIRST cust-corp WHERE  cust-corp.cust-id = client_id /*AND acct.cust-cat EQ "Ю"  AND  acct.contract EQ "Расчет"*/ no-lock no-error.     
		if AVAIL cust-corp THEN 
			DO:	
				v_Name = cust-corp.name-corp.			
				client_nm =  cust-corp.name-short .
			END.
      

	FOR each op WHERE op.op-date >= beg-date AND op.op-date <= end-date NO-LOCK,
			FIRST op-entry OF op WHERE ( (op-entry.acct-cr BEGINS '20202') AND ( op-entry.acct-db EQ v_racct ) AND (op-entry.symbol EQ "40" ) ) NO-LOCK:
 				PUT UNFORMATTED '| ' op.op-date  ' | '  op-entry.acct-cr  ' | 'op-entry.amt-rub FORMAT "->>>,>>>,>>9.99" ' | ' op.details FORMAT "X(30)" ' |' SKIP.
				summadoc = summadoc + op-entry.amt-rub . 
			END.
		END.

	IF summadoc = 0 THEN 
	DO:
		PUT UNFORMATTED '         ' + cBankName + ' сообщает, что с расчетного счета'  SKIP.
		PUT UNFORMATTED  v_racct + ' ' + client_nm + '  за период  '  SKIP.
		PUT UNFORMATTED 'с ' beg-date ' по ' end-date ' денежные средства на выплату заработной платы' SKIP.
		PUT UNFORMATTED ' из кассы банка не выдавались.'  SKIP.

	END.
	ELSE  PUT UNFORMATTED '!! денежные средства на выплату заработной платы  выдавались !!'  SKIP.




END.

{preview.i}
