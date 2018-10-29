{globals.i}
/******************************************************
 *
 * Процедура выгрузки АВТОМАТИЧЕСКИХ ОТЧЕТОВ по
 * депозитарию
 *
 ******************************************************
 * Автор: Маслов Д. А.
 * Дата создания: ??.??.????
 * Дата модификации: 11.10.10
 * Заявка: #515
 ******************************************************/

DEFINE INPUT PARAMETER iParmStr AS CHARACTER.
DEF VAR iBegPos AS INTEGER INITIAL 1  No-Undo.
DEF VAR iEndPos AS INTEGER INITIAL 1  No-Undo.
DEF VAR i AS INTEGER  No-Undo.

IF NUM-ENTRIES(iParmStr,'-') > 1 THEN 
				   DO:
				     iBegPos = INTEGER(ENTRY(1,iParmStr,'-')).
				     iEndPos = INTEGER(ENTRY(2,iParmStr,'-')).
				   END.
				   ELSE
				     DO:
					iBegPos = INTEGER(iParmStr).
					iEndPos = INTEGER(iParmStr).
				     END.

DO i = iBegPos TO iEndPos:
        if NOT Holiday(TODAY - i) THEN
	  DO:
 	     RUN pir-opendep.p (i).

	     RUN pir-otdepo5.p (i).

	     RUN pir-oborot1.p (i).

	     RUN pir-oborot2.p (i).

             RUN pir-depopos.p (i).

	     RUN pir-deppr.p (i).

	     RUN "svod(d).p" (i).

	     RUN pir-otdepo3.p (i).        

	     RUN pir-grpprint.p ("anksec," + STRING(i)).
          END.
END.