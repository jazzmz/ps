/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-close-dps.p
      Comment: Ведомость вкладов с индивидуальными тарифами
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

{setdest.i}

	PUT UNFORMATTED ' Частные вклады c индивидуальными ставками '  SKIP(2) .


FOR EACH comm-rate WHERE comm-rate.acct GT '0' AND ( comm-rate.commission BEGINS "fixed" OR comm-rate.commission BEGINS "pir" ) :
DO:


	FIND FIRST loan WHERE loan.contract EQ 'dps' AND loan.doc-ref = comm-rate.acct NO-LOCK NO-ERROR.
	IF AVAIL loan THEN
	DO:
		DO:
		FIND FIRST PERSON WHERE loan.cust-id EQ person.person-id NO-LOCK NO-ERROR.
		IF AVAIL person THEN namep = person.name-last + ' ' + person.first-names.
		END.

	PUT UNFORMATTED '| ' comm-rate.acct ' | ' namep FORMAT "X(30)" ' | ' loan.loan-status ' | ' comm-rate.commission FORMAT "X(10)" ' | '   STRING(comm-rate.rate-comm) FORMAT "X(5)"    '  |'  SKIP.


	END.

END.



END.
{preview.i}


