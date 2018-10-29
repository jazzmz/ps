/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011 
     Filename: pir-inv15.p
      Comment: Акт инвентаризации наличных денежных средств по состоянию на заданную дату
       Launch: ХЗ -> УМЦ -> ОС -> Картотоке -> Браузер карточек ctrl+g (хотя к картам отношения не имеет :) ) -> ИНВ15 Акт инвентаризации нал.ден.средств
   Parameters: 
         Uses:
      Used by:
      Created: Ситов С.А., 02.11.2011 
<Как_работает> : ПО ТЗ должны быть найдены остатки по след. синт. счетам:
		Наличные деньги: 20202810200000000001,20202840500000000001,
				 20202978100000000001 (только операционная касса)
				+операционная касса:
				20202810800000000003,20202840100000000003,20202978700000000003 
		Ценные бумаги: 90803 + репо
		Ценности: 91202
		Бланки: 91207
*/

{globals.i}
{sh-defs.i}
{getdate.i}
{get-bankname.i}
{tmprecid.def &pref = g }

DEF VAR Cash_acct     AS CHAR NO-UNDO.
DEF VAR Ost_cash_rub  AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_cash_usd  AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_cash_eur  AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_cash_usd_eq  AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_cash_eur_eq  AS DEC INIT 0 NO-UNDO.
                             
DEF VAR tmpstr  AS CHAR Extent 2 NO-UNDO.
DEF VAR Ost_cash_rub_str  AS CHAR  NO-UNDO.
DEF VAR Ost_cash_usd_str  AS CHAR  NO-UNDO.
DEF VAR Ost_cash_eur_str  AS CHAR  NO-UNDO.

DEF VAR Ost_90803_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_90803_usd AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_90803_eur AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_91202_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91202_usd AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91202_eur AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_91207_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91207_usd AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_91207_eur AS DEC INIT 0 NO-UNDO.

DEF VAR Ost_All_rub AS DEC INIT 0 NO-UNDO.
DEF VAR Ost_All_rub_str AS CHAR NO-UNDO.

/*
FORM TypeBcl WITH FRAME fr1.
*/

Cash_acct = "20202810200000000001,20202840500000000001,20202978100000000001,20202810800000000003,20202840100000000003,20202978700000000003" .


{setdest.i}

		/* Наличные деньги */

FOR EACH acct WHERE CAN-DO(Cash_acct,acct.acct)
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
	DO:
        Ost_cash_usd = Ost_cash_usd + ABS(sh-val).    
        Ost_cash_usd_eq = Ost_cash_usd_eq + ABS(sh-bal).    
	END. 	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
	DO:
        Ost_cash_eur = Ost_cash_eur + ABS(sh-val).     	
        Ost_cash_eur_eq = Ost_cash_eur_eq + ABS(sh-bal).     	
	END.
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_cash_rub = Ost_cash_rub + ABS(sh-bal).     	
  END.

END.


		/* Ценные бумаги */

FOR EACH acct WHERE acct.acct begins "90803"
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
        Ost_90803_usd = Ost_90803_usd + ABS(sh-val).     	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
        Ost_90803_eur = Ost_90803_eur + ABS(sh-val).     	
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_90803_rub = Ost_90803_rub + ABS(sh-bal).     	
  END.

END.


		/* Ценности */

FOR EACH acct WHERE acct.acct begins "91202"
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
        Ost_91202_usd = Ost_91202_usd + ABS(sh-val).     	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
        Ost_91202_eur = Ost_91202_eur + ABS(sh-val).     	
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_91202_rub = Ost_91202_rub + ABS(sh-bal).     	
  END.

END.



		/* Бланки */

FOR EACH acct WHERE acct.acct begins "91207"
NO-LOCK:

  IF acct.currency <> "" THEN
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-val) > 0 AND acct.currency = "840" THEN
        Ost_91207_usd = Ost_91207_usd + ABS(sh-val).     	
     IF ABS(sh-val) > 0 AND acct.currency = "978" THEN
        Ost_91207_eur = Ost_91207_eur + ABS(sh-val).     	
  END.	
  ELSE
  DO:
     RUN acct-pos IN h_base (acct.acct, acct.currency,end-date,end-date, chr(251)).
     IF ABS(sh-bal) > 0 THEN
        Ost_91207_rub = Ost_91207_rub + ABS(sh-bal).     	
  END.

END.


PUT UNFORM "                                                                                  Унифицированная форма № ИНВ-15 " SKIP. 
PUT UNFORM "                                               Утвержденная Постановлением Госкомстата России от 18.08.1998 № 88 " SKIP. 
PUT UNFORM "                                                                                                    ------------ " SKIP. 
PUT UNFORM "                                                                                                    |    Код   |  " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM "                                                                                      Форма по ОКУД | 0317013  | " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM " СВОД ПО " + STRING(cBankName,"x(25)") + "                                                       по ОКПО | 29287152 | " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM  STRING(cBankName,"x(25)") + "                                                                        | 29287152 | " SKIP.
PUT UNFORM "                                                                                                    |----------| " SKIP.
PUT UNFORM "                                                                                   Вид деятельности |          | " SKIP.
PUT UNFORM "                                                                                         -----------|----------| " SKIP.
PUT UNFORM "                            Основание для         приказ, постановление, распоряжение    | номер    |          |" SKIP.
PUT UNFORM "                            проведения        ------------------------------------------------------|----------| " SKIP.
PUT UNFORM "                            инвентаризации:               (ненужное зачеркнуть)          | дата     |          |" SKIP.
PUT UNFORM "                                                                                         -----------|----------| " SKIP.
PUT UNFORM "                                                                                       Вид операции |          | " SKIP.
PUT UNFORM "                                                                                                    ------------ " SKIP.
PUT UNFORM "                                                                                      -------------------------- " SKIP.
PUT UNFORM "                                                                                      |Номер  |   Дата     |   | " SKIP.
PUT UNFORM "                                                                                      |док-та |   док-та   |   | " SKIP.
PUT UNFORM "                                                                                      |------------------------| " SKIP.
PUT UNFORM "                                                                                      |       | " (end-date + 1) FORMAT "99/99/9999" " |   | " SKIP.
PUT UNFORM "                                                                                      -------------------------- " SKIP.
PUT UNFORM "                                                        Акт " SKIP.
PUT UNFORM "                                     инвентаризации наличных денежных средств," SKIP.
PUT UNFORM "                                     находящихся по состоянию на " (end-date + 1) FORMAT "99.99.9999" " г." SKIP.
PUT UNFORM "" SKIP(1).
PUT UNFORM "                                                      РАСПИСКА" SKIP.
PUT UNFORM "   К началу проведения инвентаризации все расходные и приходные документы на денежные средства сданы  " SKIP. 
PUT UNFORM " в бухгалтерию и все денежные средства, разные ценности и документы, поступившие на мою ответственность," SKIP.
PUT UNFORM " оприходованы, а выбывшие списаны в расход." SKIP.
PUT UNFORM "" SKIP.
PUT UNFORM " Материально ответственное лицо: ____________________      _______________      _______________________________" SKIP.
PUT UNFORM "                                     (должность)              (подпись)               (расшифровка подписи)    " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "           Акт составлен комиссией, которая установила следующее:                                              " SKIP.
PUT UNFORM "                                                                                                               " SKIP.

IF Ost_cash_rub > 0 THEN
PUT UNFORM "          1) наличных денег    рублей:  " TRUNCATE(Ost_cash_rub,0)   " руб" (Ost_cash_rub - TRUNCATE(Ost_cash_rub,0) )   " коп. " SKIP.
IF Ost_cash_usd > 0 THEN                           
PUT UNFORM "                             долл.США:  " TRUNCATE(Ost_cash_usd_eq,0)   " руб" (Ost_cash_usd_eq - TRUNCATE(Ost_cash_usd_eq,0) )   " коп. " SKIP.
IF Ost_cash_eur > 0 THEN                           
PUT UNFORM "                                 Евро:  " TRUNCATE(Ost_cash_eur_eq,0)   " руб" (Ost_cash_eur_eq - TRUNCATE(Ost_cash_eur_eq,0) )   " коп. " SKIP.

IF Ost_90803_rub > 0 THEN
PUT UNFORM "          2) ценных бумаг        " TRUNCATE(Ost_90803_rub ,0) " руб " (Ost_90803_rub - TRUNCATE(Ost_90803_rub,0) ) " коп. " SKIP.
IF Ost_90803_usd > 0 THEN
PUT UNFORM "                                 " Ost_90803_usd " долл.США  " SKIP.
IF Ost_90803_eur > 0 THEN
PUT UNFORM "                                 " Ost_90803_eur " Евро      " SKIP.

IF Ost_91202_rub > 0 THEN
PUT UNFORM "          3) ценности            " TRUNCATE(Ost_91202_rub ,0) " руб " (Ost_91202_rub - TRUNCATE(Ost_91202_rub,0) ) " коп. " SKIP.
IF Ost_91202_usd > 0 THEN
PUT UNFORM "                                 " Ost_91202_usd " долл.США  " SKIP.
IF Ost_91202_eur > 0 THEN
PUT UNFORM "                                 " Ost_91202_eur " Евро      " SKIP.

IF Ost_91207_rub > 0 THEN
PUT UNFORM "          4) бланки              " TRUNCATE(Ost_91207_rub ,0) " руб " (Ost_91207_rub - TRUNCATE(Ost_91207_rub,0) ) " коп. " SKIP.
IF Ost_91207_usd > 0 THEN
PUT UNFORM "                                 " Ost_91207_usd " долл.США  " SKIP.
IF Ost_91207_eur > 0 THEN
PUT UNFORM "                                 " Ost_91207_eur " Евро      " SKIP.

PUT UNFORM  SKIP(1).

Ost_All_rub = Ost_cash_rub + Ost_cash_usd_eq + Ost_cash_eur_eq + Ost_90803_rub + Ost_91202_rub + Ost_91207_rub .

RUN x-amtstr.p(dec(Ost_All_rub),"",true,true, output tmpstr[1], output tmpstr[2]).
Ost_All_rub_str = tmpstr[1] + " " + tmpstr[2].


PUT UNFORM "          Итого фактически наличие на сумм " TRUNCATE(Ost_All_rub,0)   " руб" (Ost_All_rub - TRUNCATE(Ost_All_rub,0) )   " коп. " SKIP.
PUT UNFORM "     " Ost_All_rub_str  SKIP.
PUT UNFORM "                                             (прописью)                                                        " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "          По учетным данным на сумму " TRUNCATE(Ost_All_rub,0)   " руб" (Ost_All_rub - TRUNCATE(Ost_All_rub,0) )   " коп. " SKIP. 
PUT UNFORM "     " Ost_All_rub_str  SKIP.
PUT UNFORM "                                             (прописью)                                                        " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "     Результаты инвентаризации: излишек   __________________________________ руб. ______________коп.           " SKIP.
PUT UNFORM "                                недостача __________________________________ руб. ______________коп.           " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "     Последние номера кассовых ордеров приходного № ____________________,                                      " SKIP.
PUT UNFORM "                                       расходного № ____________________                                       " SKIP.
PUT UNFORM "                                                                                                               " SKIP.



PUT UNFORM "    Председатель комиссии  _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (должность)              (подпись)                  (расшифровка подписи)         " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "    Члены комиссии         _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (должность)              (подпись)                  (расшифровка подписи)         " SKIP.
PUT UNFORM "                           _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (должность)              (подпись)                  (расшифровка подписи)         " SKIP.
PUT UNFORM "                           _______________      _________________       _______________________________________" SKIP.
PUT UNFORM "                             (должность)              (подпись)                  (расшифровка подписи)         " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM " Подтверждаю, что денежные средства, перечисленные в акте, находятся на моем ответственном хранении.           " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM " Материально ответственное лицо: ____________________      _______________      _______________________________" SKIP.
PUT UNFORM "                                     (должность)              (подпись)             (расшифровка подписи)      " SKIP.
PUT UNFORM "  ''___'' __________ _____ г.                                                                                  " SKIP.
PUT UNFORM "                                                                                                               " SKIP.

/*PAGE.*/

PUT UNFORM "   Объяснение причин излишков или недостач ____________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM " Материально ответственное лицо: ____________________      _______________      _______________________________" SKIP.
PUT UNFORM "                                     (должность)              (подпись)             (расшифровка подписи)      " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   Решение руководителя организации ___________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "   ____________________________________________________________________________________________________________" SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "      _________________________     ______________________      _______________________________________________" SKIP.
PUT UNFORM "             (должность)                   (подпись)                           (расшифровка подписи)           " SKIP.
PUT UNFORM "                                                                                                               " SKIP.
PUT UNFORM "     ''___''__________ _____ г.                                                                                " SKIP.

                                                                                                                           
                                                                                                                           
{preview.i}                                                                                                                
                                                                                                                           
                                                                                                                           
                                                                                                                           