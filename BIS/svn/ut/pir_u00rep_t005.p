
/* ========================================================================= */
/** 
    Copyright: ООО ПИР БАНК, Управление автоматизации (C) 2013
     Filename: pir_u00rep_t005.p
      Comment: Остатки на счетах 42309/42609 по договорам аренды банковской ячейки. #2520 
   Parameters: 
       Launch: ПК - ПЕЧАТЬ - ВЫХОДНЫЕ ФОРМЫ - Остатки на счетах 42309/42609 по банковским ячейчам
         Uses:
      Created: Sitov S.A., 14.02.2013
	Basis: без ТЗ
     Modified: 
*/
/* ========================================================================= */




{globals.i}		/** Глобальные определения */
/*{ulib.i}		/** Библиотека ПИР-функций */
*/
{getdate.i}
{sh-defs.i}



/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */


DEF VAR acctcur AS CHAR NO-UNDO.
DEF VAR acctost AS DEC  NO-UNDO.

DEF VAR Sum42309_810 AS DEC INIT 0 NO-UNDO.
DEF VAR Sum42309_840 AS DEC INIT 0 NO-UNDO.
DEF VAR Sum42309_978 AS DEC INIT 0 NO-UNDO.
            
DEF VAR Sum42609_810 AS DEC INIT 0 NO-UNDO.
DEF VAR Sum42609_840 AS DEC INIT 0 NO-UNDO.
DEF VAR Sum42609_978 AS DEC INIT 0 NO-UNDO.

DEF VAR i AS INT INIT 0  NO-UNDO.

   /* Временная таблица  */
DEF TEMP-TABLE rep01 NO-UNDO
	FIELD acct	AS CHAR
	FIELD balacct	AS INT
	FIELD acctcur	AS CHAR
	FIELD acctost	AS DEC
	FIELD carddog	AS CHAR
	FIELD loancond	AS CHAR
.




/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */

message end-date view-as alert-box.

FOR EACH acct
/*	where acct.bal-acct = 42309 */
	where acct.bal-acct = 42609 
	AND acct.cust-cat = 'Ч'
	AND acct.acct-cat = 'b'
	AND (acct.close-date = ? OR acct.close-date > end-date) 
NO-LOCK:

	FIND FIRST loan-acct 
	  WHERE loan-acct.acct = acct.acct 
	  AND   loan-acct.contract = 'card-pers'
	NO-LOCK NO-ERROR.

	IF avail loan-acct THEN
	DO:

	   FIND FIRST loan 
	       WHERE loan.contract = "card-pers"
	       AND   loan.cont-code = loan-acct.cont-code
	       AND   loan.class-code = "card-loan-pers"
	       AND   loan.cust-cat  = 'Ч'
	   NO-LOCK NO-ERROR.
	  
	   FIND LAST loan-cond 
	       WHERE loan-cond.contract = loan.contract
	       AND   loan-cond.cont-code = loan.cont-code 
	       AND   loan-cond.since <= end-date
	   NO-LOCK NO-ERROR.
	  
	   IF avail loan-cond THEN
	   DO:
	    IF 	loan-cond.class-code MATCHES '*SAFE-BOX'  THEN
	    DO:
		RUN acct-pos IN h_base (loan-acct.acct,loan-acct.currency,end-date,end-date,CHR(251)).	

		IF loan-acct.currency = '' THEN
			acctost = ABS(sh-bal) .
		ELSE
			acctost = ABS(sh-val) .

		IF loan-acct.currency = '' THEN
			acctcur = '810' .
		ELSE                    
			acctcur = loan-acct.currency .

		IF acctost > 0 THEN
		DO:
	     	 Create rep01.
		 ASSIGN
		   rep01.acct =  loan-acct.acct
		   rep01.balacct = acct.bal-acct
		   rep01.acctcur = acctcur
		   rep01.acctost = acctost
		   rep01.carddog = loan.cont-code
		   rep01.loancond = loan-cond.class-code
		 .
		END.

	    END.	  
	   END. /* end IF avail loan-cond */

	END. /* end IF avail loan-acct */ 

END.





{setdest.i}

PUT UNFORM FILL(" ", 20) "Отчет за дату " STRING(end-date,"99/99/9999") SKIP.

FOR EACH rep01 BY rep01.balacct BY rep01.acctcur :

  i = i + 1 .
  
  PUT UNFORM 
    i 	FORMAT "999999" "|"
    rep01.acct    FORMAT "X(20)" "|"
    rep01.acctcur FORMAT "X(3)" "|"
    rep01.acctost FORMAT ">>>,>>>,>>>,>>9.99" "|"
    rep01.carddog FORMAT "X(20)" "|"
    rep01.loancond FORMAT "X(20)" "|"
  SKIP.

  IF rep01.balacct = 42309 THEN
  DO:
	IF rep01.acctcur = '810' THEN
		Sum42309_810 = Sum42309_810 + rep01.acctost .
	IF rep01.acctcur = '840' THEN
		Sum42309_840 = Sum42309_840 + rep01.acctost .
	IF rep01.acctcur = '978' THEN
		Sum42309_978 = Sum42309_978 + rep01.acctost .
  END.

  IF rep01.balacct = 42609 THEN
  DO:
	IF rep01.acctcur = '810' THEN
		Sum42609_810 = Sum42609_810 + rep01.acctost .
	IF rep01.acctcur = '840' THEN
		Sum42609_840 = Sum42609_840 + rep01.acctost .
	IF rep01.acctcur = '978' THEN
		Sum42609_978 = Sum42609_978 + rep01.acctost .
  END.
  
END.

PUT UNFORM "ВСЕГО:" i  SKIP (2).

PUT UNFORM "42309_810 = " Sum42309_810 FORMAT ">>>,>>>,>>>,>>9.99" SKIP.
PUT UNFORM "42309_840 = " Sum42309_840 FORMAT ">>>,>>>,>>>,>>9.99" SKIP.
PUT UNFORM "42309_978 = " Sum42309_978 FORMAT ">>>,>>>,>>>,>>9.99" SKIP.

PUT UNFORM "42609_810 = " Sum42609_810 FORMAT ">>>,>>>,>>>,>>9.99" SKIP.
PUT UNFORM "42609_840 = " Sum42609_840 FORMAT ">>>,>>>,>>>,>>9.99" SKIP.
PUT UNFORM "42609_978 = " Sum42609_978 FORMAT ">>>,>>>,>>>,>>9.99" SKIP.



{preview.i}

