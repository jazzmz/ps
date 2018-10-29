/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-dps-tblkau.i
      Comment: Процедура используется при досрочном расторжении вклада 
		Cтроит таблицу по аналитике
      Created: Sitov S.A., 20.02.2013
	Basis: #1073 
     Modified:  
*/
/* ========================================================================= */

	/*** Временная таблица  ***/
DEF TEMP-TABLE tblkau NO-UNDO
	FIELD KauEntry-OpDate  AS DATE
	FIELD Op-ContractDate  AS DATE
	FIELD Op-DocNum        AS CHAR
	FIELD KauEntry-Kau     AS CHAR
	FIELD KauEntry-AcctDb  AS CHAR
	FIELD KauEntry-AcctCr  AS CHAR
	FIELD KauEntry-AmtRub  AS DEC
	FIELD KauEntry-AmtCur  AS DEC
.


DEF BUFFER bloan-acct FOR loan-acct .
DEF BUFFER bop FOR op .
DEF BUFFER bop-entry FOR op-entry .


/* ========================================================================= */
			/**  */
/* ========================================================================= */

FOR EACH bloan-acct
    WHERE bloan-acct.contract  EQ "dps"
    AND   bloan-acct.cont-code EQ LoanNumber
NO-LOCK,
FIRST code
WHERE code.class EQ "ШаблКау"
    AND code.code    EQ bloan-acct.acct-type
NO-LOCK,
EACH kau-entry
    WHERE kau-entry.acct   EQ bloan-acct.acct
    AND kau-entry.currency EQ bloan-acct.currency
    AND kau-entry.op-status NE 'А'
    AND kau-entry.op-date >= (LoanOpDate /*+ 1*/)  AND kau-entry.op-date < RaspDate
    AND  (
		( kau-entry.kau  BEGINS "dps" + ',' + LoanNumber + ',НачПр'   ) 
		OR 
		( kau-entry.kau  BEGINS "dps" + ',' + LoanNumber + ',ОстВклС' ) 
	 )
NO-LOCK ,
FIRST bop OF kau-entry WHERE bop.op-date < RaspDate
NO-LOCK,
FIRST bop-entry OF bop
NO-LOCK  BY  bop.op-date :

 IF AVAIL(bop) THEN
 DO:

	CREATE tblkau .
	ASSIGN
		tblkau.KauEntry-OpDate = kau-entry.op-date
		tblkau.Op-ContractDate = bop.contract-date
		tblkau.KauEntry-Kau    = REPLACE( kau-entry.kau, "dps," + LoanNumber + "," , "")
		tblkau.Op-DocNum       = bop.doc-num
		tblkau.KauEntry-AcctDb = bop-entry.acct-db
		tblkau.KauEntry-AcctCr = bop-entry.acct-cr
		tblkau.KauEntry-AmtRub = bop-entry.amt-rub
		tblkau.KauEntry-AmtCur = bop-entry.amt-cur
	.
 END.

END.

/* ========================================================================= */
			/**  */
/* ========================================================================= */

/* для отладки */ 
/*
{setdest.i}

FOR EACH tblkau :
  PUT UNFORM  
	tblkau.KauEntry-OpDate   "|"  
	tblkau.Op-ContractDate   "|"
	tblkau.KauEntry-Kau      "|"
	tblkau.Op-DocNum         "|"
	tblkau.KauEntry-AcctDb   "|"
	tblkau.KauEntry-AcctCr   "|"
	tblkau.KauEntry-AmtRub   "|"
	tblkau.KauEntry-AmtCur   "|"
  SKIP.
END.

{preview.i}
*/