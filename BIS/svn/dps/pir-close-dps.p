/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-close-dps.p
      Comment: Ведомость  
   Parameters: 
         Uses: Globals.I SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 27/07/2009 Templar
     Modified:
*/

{globals.i}

DEFINE VAR i as int  no-undo.
DEFINE VAR namep as char  no-undo.

/*--------------------------------------- Main ------------------------------------------------------------------*/


{globals.i}
{wordwrap.def}
{tmprecid.def}
{intrface.get xclass}
{intrface.get count}
{getdates.i}
{setdest.i}

	PUT UNFORMATTED ' Частные вклады, закрывшиеся раньше установленного срока за период с ' beg-date ' по ' end-date SKIP(2) .


FOR EACH loan WHERE loan.contract = 'dps' AND loan.loan-status = CHR(251) 
	AND loan.close-date LE end-date AND loan.close-date GE beg-date 
	AND loan.end-date - loan.close-date GE 4 BY loan.close-date :
DO:


	FIND FIRST PERSON WHERE loan.cust-id EQ person.person-id NO-ERROR.

	IF AVAIL person THEN namep = person.name-last + ' ' + person.first-names.


	PUT UNFORMATTED '|  ' loan.cont-code '  |  ' namep FORMAT "X(35)" '  |  ' loan.open-date '  |  '  loan.close-date '  |  ' loan.end-date '  |'  SKIP.

END.



END.
{preview.i}


