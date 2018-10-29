{pirsavelog.p}

/*          
    Copyright: (C) ОАО КБ "Пpоминвестрасчет"
     Filename: pir-credkominfo.p
      Comment: Вывод информационного сообщения для кредитного комитета
      Used by:
      Created: 11.01.2011 - Ситов С.А.
*/

{globals.i}		/** Глобальные определения */
{ulib.i}		/** Библиотека моих собственных функций */
{getdate.i}
{intrface.get i254}


def var i as int64 init 0 no-undo.
def var tmpstr as char no-undo.
def var curr as char no-undo.
def var summa as dec no-undo.
def var task as int64 no-undo.
def var bag as char init "" no-undo.
def var vGrRisk as char no-undo.
def var risk as char init "" no-undo.
def var risk_b as char init "" no-undo.
def var risk_o as char init "" no-undo.


DEF VAR out_file_name AS char NO-UNDO.
DEF VAR expdate AS char NO-UNDO.

DEFINE TEMP-TABLE rep NO-UNDO
	FIELD numcl AS INT64 init 0
	FIELD task AS INT64 
	FIELD fioclient AS CHAR 
	FIELD numdogcard AS CHAR
	FIELD numcard AS CHAR 
	FIELD summa AS DEC
	FIELD totalsum AS DEC
	FIELD curr AS CHAR 
	FIELD rate AS CHAR 
	FIELD srok AS CHAR
	FIELD risk AS CHAR
	INDEX numcl numcard  
.

{empty rep}


/*FOR EACH op WHERE (op.op-date >= beg-date AND op.op-date <= end-date )*/
FOR EACH op WHERE op.op-date = end-date
	AND (op.op-kind = "1403" OR op.op-kind = "1404")	
	AND (op.op-status = "√"  OR op.op-status = "√√")  NO-LOCK,
FIRST op-entry OF op WHERE (((op-entry.acct-db BEGINS '91317')) 
	OR ((op-entry.acct-cr BEGINS '91317'))) NO-LOCK
	BY op.op-date BY op.op-status BY op.op: 

  CASE op-entry.currency:
    WHEN "840" 	THEN 
	do:
	 curr = "Долларов США" .      
	 summa = ABS(op-entry.amt-cur) .
	end.
    WHEN "978" 	THEN 
	do:
	 curr = "Евро" .          
	 summa = ABS(op-entry.amt-cur) .
	end.
    OTHERWISE 
	do:
	 curr = "рублей"  .
	 summa = ABS(op-entry.amt-rub) .
	end.
  END CASE .

  IF avail(op) THEN 
  DO:

		/* Открытие, Увеличение */
	IF ( op-entry.acct-cr BEGINS '91317' ) THEN
		FIND FIRST acct WHERE acct.acct = op-entry.acct-cr NO-LOCK NO-ERROR.
		/* Закрытие, Уменьшение */
	ELSE 
		FIND FIRST acct WHERE acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.

	IF num-entries(op.details, " ") > 1 THEN
		tmpstr =  entry(1, op.details, " ") .
	ELSE tmpstr = " ".
	
	CASE tmpstr:
	  WHEN "Открытие" 	THEN task = 1 .         
	  WHEN "Увеличение" 	THEN task = 2 .          
	  WHEN "Закрытие" 	THEN task = 3 .         
	  WHEN "Уменьшение" 	THEN task = 4 .          
	  OTHERWISE task = 0  .
	END CASE .
	

		/***	КРЕДИТНЫЙ ДОГОВОР	***/
	/************************************************/

	FIND FIRST loan-acct WHERE loan-acct.acct eq acct.acct  
		AND loan-acct.currency eq acct.currency NO-LOCK NO-ERROR.

	FIND FIRST loan WHERE loan.contract eq loan-acct.contract  
		AND (loan.cont-code eq loan-acct.cont-code  OR loan.cont-code eq ENTRY(1,loan-acct.cont-code, ' ')  OR (IF NUM-ENTRIES(loan-acct.cont-code, ' ') GT 1 THEN loan.cont-code eq ENTRY(1,loan-acct.cont-code, ' ') + ' ' + ENTRY(2,loan-acct.cont-code, ' ') ELSE FALSE)) 
		AND loan.Class-Code = "l_agr_with_per" NO-LOCK NO-ERROR.

		bag = LnInBagOnDate(loan.contract, loan.cont-code, end-date) .


		/***	КАРТОЧНЫЙ ДОГОВОР	***/
	/*************************************************/

	FIND FIRST loan-acct OF loan WHERE loan-acct.acct-type = "КредРасч" NO-LOCK NO-ERROR.

	DEF BUFFER dogcard FOR loan.
	DEF BUFFER dogcard-acct FOR loan-acct.

	FIND FIRST dogcard-acct WHERE dogcard-acct.acct = loan-acct.acct 
		AND  dogcard-acct.acct-type begins "SCS@" NO-LOCK NO-ERROR.

	FIND FIRST dogcard WHERE dogcard.contract eq dogcard-acct.contract  
		AND (dogcard.cont-code eq dogcard-acct.cont-code  OR dogcard.cont-code eq ENTRY(1,dogcard-acct.cont-code, ' ')  OR (IF NUM-ENTRIES(dogcard-acct.cont-code, ' ') GT 1 THEN dogcard.cont-code eq ENTRY(1,dogcard-acct.cont-code, ' ') + ' ' + ENTRY(2,dogcard-acct.cont-code, ' ') ELSE FALSE)) 
		AND dogcard.Class-Code = "card-loan-pers" 
		AND dogcard.cust-cat  EQ 'Ч'
		AND dogcard.loan-status = "ОТКР"
	NO-LOCK NO-ERROR.


			/***	КАРТА	***/
	/**********************************************/

	DEF BUFFER card FOR loan.

	FIND FIRST card WHERE card.contract = "card"
		AND card.parent-contract = dogcard.contract
		AND card.parent-cont-code = dogcard.cont-code
		AND card.loan-work = YES
		AND card.loan-status = "АКТ"
		AND card.close-date = ?
	NO-LOCK NO-ERROR.


	/***	Для получения категории качества и процентов ***/
	/***	          вставлен этот кусок                ***/
/**********************************************************************/

	FIND LAST comm-rate  WHERE comm-rate.commission = "%Рез" 
		AND comm-rate.kau  = loan.contract + ',' + loan.cont-code 
		AND comm-rate.currency = loan.currency
		AND comm-rate.since <= op.op-date
	NO-LOCK NO-ERROR.

	IF avail(comm-rate) THEN 
		DO:
	            vGrRisk = string(re_history_risk(ENTRY(1,comm-rate.kau), ENTRY(2,comm-rate.kau), comm-rate.since,1)) .
		    risk_b = string(comm-rate.rate-comm) .
		END.
	IF bag <> ? THEN
		risk = vGrRisk + " (" + risk_b  + "%)" .
	ELSE IF (bag = ? AND task = 1)  THEN
	   DO:
		DEFINE BUFFER comloan-acct FOR loan-acct.
		FIND FIRST comloan-acct of loan where 
			comloan-acct.acct-type = "КредН" 
		NO-LOCK NO-ERROR.
		IF avail(comloan-acct)  THEN
		  DO:
		      FIND FIRST comm-rate WHERE 
			comm-rate.acct EQ comloan-acct.acct
			AND comm-rate.currency   EQ loan-acct.currency
			AND comm-rate.since = op.op-date
			NO-LOCK NO-ERROR.

			IF avail(comm-rate) THEN 
				risk_o = string(comm-rate.rate-comm) .
		  END.
		risk = vGrRisk + " (" + risk_b + "% по 254-П / " + risk_o + "% по 283-П)" .
	   END.
	ELSE IF (bag = ? AND task <> 1) THEN
		risk = vGrRisk + " (" + risk_b  + "%)" .

/**********************************************************************/


	IF task <> 0 AND avail(loan) AND avail(loan-acct) AND avail(dogcard)  AND avail(dogcard-acct) AND avail(card) THEN
	  DO:
	   i = i + 1 .
	   CREATE rep.
		assign
		  rep.task = task 
		  rep.numcl = i
		  rep.fioclient =  string(GetLoanInfo_ULL("Кредит", loan.doc-ref, "client_name", false) ) 
		  rep.summa = summa 
		  rep.totalsum = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, end-date, false))
		  rep.curr = curr
		  rep.srok = GetXAttrValueEx("loan", string(loan.contract + "," + loan.doc-ref),"ОврПр"," " )
		  rep.rate = substring(string(GetLoanCommission_ULL(loan.contract, loan.cont-code, "%Кред", end-date , false)),2) + "%" 
		  rep.risk = risk /*string(loan.gr-riska) + "(" + string(loan.risk) + "%)"*/
		  rep.numcard = card.doc-num 
		  rep.numdogcard = dogcard.doc-ref 
		.
	  END.

  END. /* END_IF */

END. /* END_FOR */



IF not avail(rep) THEN 
	MESSAGE " За " end-date "  документов не обнаружено! " VIEW-AS ALERT-BOX .
ELSE
DO:

expdate = replace(string(end-date, "99/99/99"), "/" , "") .

out_file_name = "/home2/bis/quit41d/imp-exp/users/" + lc(userid("bisquit")) + "/credkom_opday" + expdate + ".txt" . 

DEFINE STREAM wintxt.

OUTPUT STREAM wintxt TO VALUE(out_file_name) CONVERT TARGET "1251".


PUT STREAM wintxt SKIP (3) .


PUT STREAM wintxt  "                            				Д1/У 2-1" SKIP(2) .
PUT STREAM wintxt  "                            		 	 Чеботаревой И.В." SKIP(3) .
PUT STREAM wintxt  "     	                       Сообщение для к/к" SKIP (3) .

def var tmpdate as date no-undo.

IF weekday(end-date) = 2 OR weekday(end-date) = 3 THEN
	tmpdate = end-date - 7 .
ELSE IF weekday(end-date) = 4 THEN 
	tmpdate = end-date - 1 .
ELSE IF weekday(end-date) = 5 THEN 
	tmpdate = end-date - 2 .
ELSE IF weekday(end-date) = 6 THEN 
	tmpdate = end-date - 3 .
ELSE IF weekday(end-date) = 7 THEN 
	tmpdate = end-date - 4 .

PUT STREAM wintxt  "    Прошу включить в протокол Кредитного комитета от " tmpdate FORMAT "99/99/9999" " следующие вопросы:" SKIP (2) .


FOR EACH rep BY rep.numcl:

	CASE rep.task:
	  WHEN 1 THEN put STREAM wintxt rep.numcl ". Открытие лимита по овердрафту по пластиковой карте" skip.         
	  WHEN 2 THEN put STREAM wintxt rep.numcl ". Увеличение лимита по овердрафту по пластиковой карте"skip.         
	  WHEN 3 THEN put STREAM wintxt rep.numcl ". Закрытие лимита по овердрафту по пластиковой карте" skip.         
	  WHEN 4 THEN put STREAM wintxt rep.numcl ". Уменьшение лимита по овердрафту по пластиковой карте" skip.         
	END CASE .

	PUT STREAM wintxt rep.fioclient FORMAT "X(50)" SKIP .

END.

PUT STREAM wintxt  SKIP (4).

FOR EACH rep BY rep.numcl:

	CASE rep.task:
	  WHEN 1 THEN 
	    DO:
		put STREAM wintxt rep.numcl ". Открыть лимит по овердрафту по пластиковой карте" skip.         
		put STREAM wintxt "ФИО: " rep.fioclient FORMAT "X(50)" skip .
		put STREAM wintxt "№ договора: " rep.numdogcard FORMAT "X(30)" skip .
		put STREAM wintxt "№ ПК: " rep.numcard FORMAT "X(30)" skip .
		put STREAM wintxt "Сумма: " rep.summa  "  " rep.curr skip.
		put STREAM wintxt "Процентная ставка: " rep.rate  skip .
		put STREAM wintxt "Срок погашения траншей: " "45" /*rep.srok*/ " дней" skip .
		put STREAM wintxt "Отнести задолженность в портфель однородных ссуд: категория качества - " rep.risk  skip .
	    END.
	  WHEN 2 THEN 
	    DO:
		put STREAM wintxt rep.numcl ". Увеличить лимит по овердрафту по пластиковой карте"skip.         
		put STREAM wintxt "ФИО: " rep.fioclient FORMAT "X(50)" skip .
		put STREAM wintxt "№ договора: " rep.numdogcard FORMAT "X(30)" skip .
		put STREAM wintxt "№ ПК: " rep.numcard FORMAT "X(30)" skip .
		put STREAM wintxt "Сумма увеличения: " rep.summa  "  " rep.curr skip.
		put STREAM wintxt "Общая сумма овердрафта: " rep.totalsum "  " curr skip.
		put STREAM wintxt "Процентная ставка: " rep.rate skip .
		put STREAM wintxt "Срок погашения траншей: " "45" /*rep.srok*/ " дней" skip .
		put STREAM wintxt "Отнести задолженность в портфель однородных ссуд: категория качества - " rep.risk  skip .
	    END.
	  WHEN 3 THEN 
	    DO:
		put STREAM wintxt rep.numcl ". Закрыть лимит по овердрафту по пластиковой карте" skip.         
		put STREAM wintxt "ФИО: " rep.fioclient FORMAT "X(50)" skip .
		put STREAM wintxt "№ договора: " rep.numdogcard FORMAT "X(30)" skip .
		put STREAM wintxt "№ ПК: " rep.numcard FORMAT "X(30)" skip .
		put STREAM wintxt "Сумма закрытия: " rep.summa  "  " rep.curr skip.
	    END.
	  WHEN 4 THEN 
	    DO:
		put STREAM wintxt rep.numcl ". Уменьшить лимит по овердрафту по пластиковой карте" skip.         
		put STREAM wintxt "ФИО: " rep.fioclient FORMAT "X(50)" skip .
		put STREAM wintxt "№ договора: " rep.numdogcard FORMAT "X(30)" skip .
		put STREAM wintxt "№ ПК: " rep.numcard FORMAT "X(30)" skip .
		put STREAM wintxt "Сумма уменьшения: " rep.summa  "  " rep.curr skip.
		put STREAM wintxt "Общая сумма овердрафта: " rep.totalsum  "  " curr skip.
		put STREAM wintxt "Процентная ставка: " rep.rate skip .
		put STREAM wintxt "Срок погашения траншей: " "45" /*rep.srok*/ " дней" skip .
		put STREAM wintxt "Отнести задолженность в портфель однородных ссуд: категория качества - " rep.risk  skip .
	    END.
        END CASE .

PUT STREAM wintxt  SKIP (1).

END. /*END_FOR*/

PUT STREAM wintxt  SKIP (2).
PUT STREAM wintxt  " 	  Начальник У11      	                 	  	 _______________ " SKIP(3) .


MESSAGE " Результат сохранен в файле: " out_file_name VIEW-AS ALERT-BOX  .


END. /*END_IF*/


OUTPUT STREAM wintxt CLOSE.