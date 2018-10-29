{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir-repostconvact.p 
      Comment: Отчет об остатках на конверсионных счетах
	       Выборка осуществляеся по открытым договорам ПК:
		 если валюта счета не равна валюте договора, то определеям остаток по счету на заданную дату
		 если остаток по модулю > 0, то выводим в отчет
   Parameters: 
       Launch: ПК - ПЕЧАТЬ - ВЫХОДНЫЕ ФОРМЫ 
         Uses:
      Created: Ситов С.А., 28.09.2011
	Basis: ТЗ
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{getdate.i}
{sh-defs.i}

{get-bankname.i}

{setdest.i}

DEF VAR counter		AS INT INIT 1	NO-UNDO.

DEF VAR ost_acct 	AS DEC INIT 0 	NO-UNDO.
DEF VAR card_holder	AS CHAR		NO-UNDO.


	/*  Шапка отчета */

PUT UNFORM SKIP(2).
PUT UNFORM FILL(" ",10)  "ПРИЛОЖЕНИЕ №1"  SKIP.
PUT UNFORM FILL(" ",10)  cBankName SKIP(2).
PUT UNFORM FILL(" ",40)  "ДЕНЕЖНЫЕ СРЕДСТВА НА КОНВЕРСИОННЫХ СЧЕТАХ "  SKIP(1).
PUT UNFORM FILL(" ",50)   " на дату " string(end-date,"99/99/9999") SKIP(2).


PUT UNFORM "| № пп " 
	   "|  Номер договора  "
	   "| Вал.счета "
	   "|           Держатель ПК              "
	   "|  Конверсионный счет  "
	   "| Остаток средств |"
	 SKIP(1).


FOR EACH loan
WHERE CAN-DO('card-corp,card-pers',loan.contract)
  and CAN-DO('ОТКР,ЗВЛ',loan.loan-status)
  and CAN-DO('card-loan-corp,card-loan-pers',loan.class-code)
/*  and loan.close-date < ? > 08/08/11 */
NO-LOCK,
/*EACH loan-acct OF loan WHERE ( loan-acct.acct-type = "SCS@840" OR loan-acct.acct-type = "SCS@978")*/
EACH loan-acct OF loan WHERE loan-acct.currency <> loan.currency 
  and loan-acct.acct-type BEGINS ("SCS")
NO-LOCK:

  IF (AVAIL loan) AND (AVAIL loan-acct) THEN
  DO:

       FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.
         card_holder = person.name-last + " " + person.first-name .

       RUN acct-pos IN h_base (loan-acct.acct, loan-acct.currency, end-date, end-date, ? ).
       ost_acct = IF loan-acct.currency = '' THEN ABSOLUTE(sh-bal) ELSE ABSOLUTE(sh-val) .
/*     ost_acct = IF loan-acct.currency = '' THEN sh-bal ELSE sh-val . */

       IF ost_acct <> 0 THEN
         DO:

	 PUT UNFORM "| " string(counter,"9999") " | " 
		    string(loan.doc-ref,"X(16)") " | "
		    string((IF loan-acct.currency = '' THEN "810" ELSE loan-acct.currency ),"X(9)")  " | "
		    string(card_holder,"X(35)") " | "
		    loan-acct.acct " | "
		    string(ost_acct,">>>>>>>>,999.99") " |" 
	 SKIP.

         counter = counter + 1 .

	 END.

  END.

END.



  /* Исполнитель */

PUT UNFORM  SKIP(2).
PUT UNFORM FILL(" ",3)   string(TODAY,"99/99/9999") " " string(TIME,"HH:MM:SS") SKIP(1).

FIND FIRST code WHERE code.class EQ "PirU11Podpisi"
  AND code.parent EQ "PirU11Podpisi"
  AND code.code = userid("bisquit") NO-LOCK NO-ERROR.

  PUT UNFORM " " code.name SKIP(2).

{preview.i}
