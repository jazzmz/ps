/* ========================================================================= */
/** 
    Copyright: ООО ПИР БАНК, Управление автоматизации (C) 2013
     Filename: pir_u17rep_w0001.p
      Comment: Информация о денежных средствах, размещенных в качестве 
		гарантийного взноса по договору аренды банковской ячейки
   Parameters: 
       Launch: КиД - ПЕЧАТЬ - ВЫХОДНЫЕ ФОРМЫ 
      Created: Sitov S.A., 20.03.2013
	Basis: #2520
     Modified: 
*/
/* ========================================================================= */


{globals.i}		/** Глобальные определения */
{getdate.i}
{sh-defs.i}



/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */


DEF VAR acctost  AS DEC NO-UNDO.
DEF VAR Sum	 AS DEC INIT 0 NO-UNDO.       

DEF VAR i	 AS INT INIT 1  NO-UNDO.
DEF VAR tmpblact AS INT NO-UNDO.

DEF TEMP-TABLE rep01 NO-UNDO
	FIELD balacct	AS INT
	FIELD acct	AS CHAR
	FIELD acctcur	AS CHAR
	FIELD acctost	AS DEC
	FIELD carddog	AS CHAR
	FIELD loancond	AS CHAR
	FIELD clientfio	AS CHAR
.

DEF VAR PrntHead	AS CHAR NO-UNDO.
DEF VAR PrntTblHd	AS CHAR NO-UNDO.
DEF VAR PrntTblSep	AS CHAR NO-UNDO.
DEF VAR PrntTblTotal	AS CHAR NO-UNDO.
DEF VAR PrntTblEnd	AS CHAR NO-UNDO.

DEF VAR usershortname AS CHAR NO-UNDO.

/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */

/* message end-date view-as alert-box. */

FOR EACH acct
	WHERE acct.cust-cat = 'Ч' 
	AND ( acct.bal-acct = 42609 OR acct.bal-acct = 42309 )
	AND ( acct.close-date = ? OR acct.close-date > end-date ) 
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

		acctost = IF loan-acct.currency = '' THEN ABS(sh-bal) ELSE ABS(sh-val) .

		IF acctost > 0 THEN
		DO:

		 FIND FIRST  person  WHERE  person.person-id = acct.cust-id  NO-LOCK NO-ERROR.

	     	 Create rep01.

		 ASSIGN
		   rep01.balacct   = acct.bal-acct
		   rep01.acct      = loan-acct.acct
		   rep01.acctcur   = (IF loan-acct.currency = '' THEN '810' ELSE loan-acct.currency )
		   rep01.acctost   = acctost
		   rep01.carddog   = loan.cont-code
		   rep01.loancond  = loan-cond.class-code
		   rep01.clientfio = person.name-last + " " + person.first-name
		 .

		END.

	    END.	  
	   END. /* end IF avail loan-cond */
	END. /* end IF avail loan-acct */ 

END.



/* ========================================================================= */
				/** Печатная форма */
/* ========================================================================= */

PrntHead = FILL(" ",66) + "Приложение №1" + CHR(10) + 
	   FILL(" ",66) + "к форме отчетности 0409302" + CHR(10) + CHR(10) +
	   FILL(" ",10) + "Информация о денежных средствах, размещенных в качестве гарантийного взноса" + CHR(10) +
	   FILL(" ",30) + "по договору аренды банковской ячейки" + CHR(10) +
	   FILL(" ",32) + "по состоянию на " + STRING(end-date,"99/99/9999") + " г." + CHR(10) 
	.


PrntTblHd = 
	"┌────────┬──────────────────────┬─────────────────────────────────────┬────────────────────┐" + CHR(10) +
	"│        │                      │                                     │                    │" + CHR(10) +
	"│ N п/п  │   N лицевого счета   │        Наименование  клиента        │   Остаток в руб    │" + CHR(10) +
	"│        │                      │                                     │                    │" + CHR(10) +
	"├────────┼──────────────────────┼─────────────────────────────────────┼────────────────────┤" + CHR(10) +
	"│   1    │           2          │                  3                  │         4          │" + CHR(10) +		
	"├────────┼──────────────────────┼─────────────────────────────────────┼────────────────────┤" 
	.


PrntTblSep =
	"├────────┼──────────────────────┼─────────────────────────────────────┼────────────────────┤" + CHR(10). 
	.


PrntTblTotal =
	"│  ИТОГО │                      │                                     │" 		
	.
PrntTblEnd =
	"└────────┴──────────────────────┴─────────────────────────────────────┴────────────────────┘" + CHR(10)
	.



/* ========================================================================= */
				/** Печать */
/* ========================================================================= */

{setdest.i}

tmpblact = 42309 .

/*
PUT UNFORM  
	PrntHead SKIP
	PrntTblHd
SKIP.
*/

PUT UNFORM  FILL(" ",66)  "Приложение №1" SKIP.
PUT UNFORM  FILL(" ",66)  "к форме отчетности 0409302" SKIP(2).
PUT UNFORM  FILL(" ",10)  "Информация о денежных средствах, размещенных в качестве гарантийного взноса" SKIP.
PUT UNFORM  FILL(" ",30)  "по договору аренды банковской ячейки" SKIP.
PUT UNFORM  FILL(" ",32)  "по состоянию на "  STRING(end-date,"99/99/9999") " г." SKIP.

PUT UNFORM  "┌────────┬──────────────────────┬─────────────────────────────────────┬────────────────────┐" SKIP.
PUT UNFORM  "│        │                      │                                     │                    │" SKIP.
PUT UNFORM  "│ N п/п  │   N лицевого счета   │        Наименование  клиента        │   Остаток в руб    │" SKIP.
PUT UNFORM  "│        │                      │                                     │                    │" SKIP.
PUT UNFORM  "├────────┼──────────────────────┼─────────────────────────────────────┼────────────────────┤" SKIP.
PUT UNFORM  "│   1    │           2          │                  3                  │         4          │" SKIP.		
PUT UNFORM  "├────────┼──────────────────────┼─────────────────────────────────────┼────────────────────┤" SKIP.


FOR EACH rep01 BY rep01.balacct BY rep01.acctcur :

  IF tmpblact = rep01.balacct THEN
	Sum = Sum + rep01.acctost .

  IF tmpblact <> rep01.balacct THEN
  DO:
	PUT UNFORM  PrntTblSep  SKIP.
	PUT UNFORM  PrntTblTotal STRING(Sum,">>>,>>>,>>>,>>9.99") "  │"  SKIP.
	PUT UNFORM  PrntTblEnd  SKIP.
	Sum = rep01.acctost .
	i = 1 .	
  END.


  PUT UNFORM 
    "│ " i    	    FORMAT "999999" " │ "
    rep01.acct      FORMAT "X(20)" " │ "
    rep01.clientfio FORMAT "X(35)" " │ "
    rep01.acctost   FORMAT ">>>,>>>,>>>,>>9.99" " │"
  SKIP.


  i = i + 1 .
  tmpblact = rep01.balacct .
  
END.

	PUT UNFORM  PrntTblSep  SKIP.
	PUT UNFORM  PrntTblTotal STRING(Sum,">>>,>>>,>>>,>>9.99") "  │"  SKIP.
	PUT UNFORM  PrntTblEnd  SKIP(1).


FIND FIRST _user WHERE _user._userid = LC(userid("bisquit")) NO-LOCK NO-ERROR.
usershortname =  ENTRY(1, _user._user-name, " ") + " " 
		 + SUBSTRING(ENTRY(2, _user._user-name, " "), 1, 1) + "." 
		 + SUBSTRING(ENTRY(3, _user._user-name, " "), 1, 1) + "."
		.

PUT UNFORM  "Ответственный исполнитель " FORMAT "X(50)" "__________ / " usershortname SKIP(1).
PUT UNFORM  "Контролер " FORMAT "X(50)" "__________ / ________________" SKIP.	



{preview.i}

