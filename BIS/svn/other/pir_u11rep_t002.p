{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_u11rep_t002.p
      Comment: pir_u11rep_t002.csv - временный отчет для У11
	       Отбираем все договора ПК в статусе ЗАКР,√ , у которых 
	       на счетах 61304 ненулевой остаток.
   Parameters: 
       Launch: ПК - ПЕЧАТЬ - ВЫХОДНЫЕ ФОРМЫ 
         Uses:
      Created: Ситов С.А., 22.02.2012
	Basis: без ТЗ
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */




{globals.i}		/** Глобальные определения */
{tmprecid.def}		/** Подключение возможности использовать информацию броузера */
{intrface.get strng}
{ulib.i}		/** Библиотека ПИР-функций */
{getdate.i}
{sh-defs.i}



/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

DEF VAR iagr  AS INT INIT 0 NO-UNDO.


DEF VAR tmpFile	AS CHAR INIT "pir_u11rep_t002.csv" NO-UNDO.
tmpFile = "/home/bis/quit41d/imp-exp/users/" + LC(userid("bisquit")) + "/" + tmpFile .
DEFINE STREAM rep_excel .



/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */

OUTPUT STREAM rep_excel TO VALUE (tmpFile) CONVERT TARGET "1251".

PUT STREAM rep_excel UNFORM ";Отчет по договорам ПК физ.лиц в статусе ЗАКР и V, у которых есть остаток на счете 61304;"  SKIP(2).
PUT STREAM rep_excel UNFORM "Дата запуска отчета;" today  ";"  SKIP(2).

PUT STREAM rep_excel UNFORM "Отчет на дату;" end-date  ";"  SKIP(2).


PUT STREAM rep_excel UNFORM 
	"Клиент" ";" 
	"Статус договора" ";" 
	"Номер договора" ";"  
	"Условие договора" ";"  
	"Номер счета" ";"
	"Остаток в валюте договора" ";"

SKIP.


FOR EACH loan WHERE loan.contract   EQ "card-pers" 
		AND loan.class-code EQ "card-loan-pers"
		AND loan.cust-cat   EQ 'Ч'
		AND CAN-DO("ЗАКР,√",loan.loan-status)
NO-LOCK:

	IF AVAIL(loan) THEN
	  DO:
		FOR EACH loan-acct OF loan 
			WHERE loan-acct.acct BEGINS "61304"
		NO-LOCK:

		  IF AVAIL(loan-acct) THEN				  
		    DO:
			RUN acct-pos IN h_base (loan-acct.acct,loan-acct.currency,end-date,end-date,"√").

                	IF (sh-bal <> 0) OR (sh-val <> 0) THEN
			  DO:
				iagr = iagr + 1 .


				FIND LAST loan-cond WHERE loan-cond.contract EQ "card-pers" 
					AND loan-cond.cont-code EQ loan.cont-code 
				NO-LOCK NO-ERROR.

				FIND FIRST person WHERE	person.person-id = loan.cust-id
				NO-LOCK NO-ERROR.
  
				PUT STREAM rep_excel UNFORM 
					person.name-last  " "  person.first-names  ";" 
					REPLACE(loan.loan-status,"√","V") ";" 
					loan.cont-code ";" 
					loan-cond.class-code ";"
					"_" loan-acct.acct ";"
					( IF loan.currency = "" THEN ABS(sh-bal) ELSE ABS(sh-val) ) ";"
				SKIP.

			  END. /* end_if */
		    END. /* end_if */
		END.  /* for_each */
  END. /* end_if */

END.

PUT STREAM rep_excel UNFORM SKIP (2).
PUT STREAM rep_excel UNFORM "Всего договоров;" iagr SKIP.

OUTPUT STREAM rep_excel CLOSE.


MESSAGE tmpFile VIEW-AS ALERT-BOX /*BUTTON YES-NO */ TITLE "Файл сохранен в:".
