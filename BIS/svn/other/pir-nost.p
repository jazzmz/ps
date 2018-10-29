/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-nost.p
      Comment: Ведомость расчетных счетов с заданным неснижаемым остатком
   Parameters: 
         Uses: Globals.I SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 22/09/2008 Templar
     Modified:
*/

{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR minost	as int  no-undo.
DEFINE VAR k		as date  no-undo.


/*--------------------------------------- Main ------------------------------------------------------------------*/

DEFINE INPUT PARAM nost AS INT NO-UNDO.
MESSAGE "Введите неснижаемый остаток" UPDATE nost.

{setdest.i}
PUT UNFORMATTED 'СПИСОК РАСЧЕТНЫХ СЧЕТОВ С НЕСНИЖАЕМЫМ ОСТАТКОМ НЕ МЕНЕЕ ' nost  ' РУБ' SKIP(1) 
'ЗА 2008 ГОД' SKIP(1) 'CЧЕТ                              МИНИМ. ОСТАТОК' SKIP(1) FILL('-',80) FORM 'X(78)' SKIP(1) .

FOR EACH acct WHERE acct.contract EQ "Расчет" :
	minost=99999999.	/* минимальный остаток на счете за год*/


		FOR EACH acct-pos WHERE acct-pos.acct = acct.acct :
			IF YEAR(acct-pos.since) = 2008 AND -(acct-pos.balance) < minost  THEN minost = - acct-pos.balance .			
		END.

	IF  minost > nost AND minost <> 99999999  THEN /* остаток на счете был все время больше несниж. остатка */
	PUT UNFORMATTED  acct.acct '            '  minost FORMAT "->>>,>>>,>>9.99" SKIP.
 	

END.

{signatur.i}
{preview.i}
