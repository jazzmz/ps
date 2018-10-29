/*╩Ёрёъют └.╤. 1.12.11:  ╚чьхэхэш  яю яшё№ьє юЄ ╠рЁ°хтющ.*/
{pirsavelog.p}
/**
 * Наращенные проценты по договорам ЧВ.
 * Информация о наращенных процентах берется из параметров. Договор
 * должен быть пересчитан на дату отчета.
 * Бурягин Е.П., 17.02.2006 9:23
 *
 * Модификация: Бурягин Е.П., 07.02.2007 9:52
 *							По требованию Маршевой Е.М. в отчет добавлены колонки "Счет процентов", "Дата возврата"
 *							Значение поля "Договор № ОТ" разносится по двум колонкам: "Договор №" и "Дата открытия"
 */
 
 /** Глобальные определения */
{globals.i}
/** Библиотека функций */
{ulib.i}
/** Перенос строк по словам */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/** Рабочая переменная */
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpDate AS DATE NO-UNDO.
/** Флаг трассировки функций из модулей u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** Дата отчета */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "Дата отчета" NO-UNDO.
/** Итератор */
DEF VAR i AS INTEGER.
DEF VAR j AS INTEGER.
/** Итоговая сумма %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.
DEF VAR totalSumma%%1 AS DECIMAL NO-UNDO.
DEF VAR totalSumma%%d AS DECIMAL NO-UNDO.

PAUSE 0.
/** Задаем дату с помощью рук пользователя ;) */
repDate = TODAY.
DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR EXTENT 3
	FIELD currency AS CHAR
	FIELD loanInfo AS CHAR EXTENT 3
	/** Бурягин добавил 07.02.2007 9:55 */
	FIELD loanOpenDate AS DATE
	FIELD loanEndDate AS DATE
	FIELD intAccount AS CHAR
	/** Бурягин конец */	
	FIELD account AS CHAR
	FIELD summa%%1 AS DECIMAL
	FIELD rate AS DECIMAL
	FIELD summaDeposit AS DECIMAL
	FIELD summa%%d AS DECIMAL
	FIELD summa%% AS DECIMAL
	FIELD nextDate AS DATE
	INDEX main balAcct%% ASCENDING currency ASCENDING nextDate ASCENDING.
	
FOR EACH tmprecid 
			NO-LOCK,
    FIRST loan WHERE 
    	RECID(loan) = tmprecid.id 
    	NO-LOCK,
    LAST loan-acct WHERE 
    	loan-acct.contract = loan.contract
    	AND
    	loan-acct.cont-code = loan.cont-code
    	AND
   		loan-acct.acct-type = "loan-dps-int"
    	AND
    	loan-acct.since LE repDate
    	NO-LOCK
  :
  	CREATE tt-report.
  	tt-report.balAcct%% = SUBSTRING(loan-acct.acct,1,5).
  	tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).
  	{wordwrap.i &s=tt-report.clientName &l=30 &n=3}
  	/** Бурягин закоментировал 07.02.2007 9:58 
  	tt-report.loanInfo[1] = loan.cont-code + " от "
  		+ GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff).
  	*/
  	
		/** Бурягин добавил 07.02.2007 9:57 */
  	tt-report.loanInfo[1] = loan.cont-code.
  	tt-report.loanOpenDate = DATE(GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff)).
		tt-report.loanEndDate = loan.end-date.
		tt-report.intAccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-int", repDate, traceOnOff).
		/** Бурягин конец */
  	{wordwrap.i &s=tt-report.loanInfo &l=25 &n=3}
		tt-report.account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t,loan-dps-p", repDate, traceOnOff).
		tt-report.summa%%1 = ABS(
  		GetAcctPosValue_UAL(
  			loan-acct.acct, 
  			loan.currency, repDate, traceOnOff
  		)
  	).
  	IF loan.close-date <> ? AND loan.close-date LE repDate THEN 
  		tmpDate = loan.close-date - 1.
  	ELSE IF loan.end-date <> ? AND loan.end-date LE repDate THEN
  		tmpDate = loan.end-date - 1.
  	ELSE
  		tmpDate = repDate.
		tt-report.summaDeposit = ABS(GetAcctPosValue_UAL(tt-report.account,	loan.currency, 
			tmpDate, traceOnOff)).
		tt-report.rate = GetDpsCommission_ULL(
			loan.cont-code, 
			"commission", 
			repDate, traceOnOff
		).
		tt-report.summa%%d = GetDpsCurrentPersent_ULL(loan.cont-code, repDate, traceOnOff).
  	tt-report.summa%% = tt-report.summa%%1 + tt-report.summa%%d.
  	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
  	tt-report.nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, repDate, traceOnOff).
END.

{setdest.i}

PUT UNFORMATTED "Приложение № 13" AT 150 SKIP
                "к форме отчетности 0409135" AT 150 SKIP(1).
PUT UNFORMATTED "Остатки по наращенным и не отраженным на балансе процентам" AT 25 SKIP
	        "по обязательствам банка" AT 40 SKIP
                "по состоянию за " AT 39 repDate FORMAT "99/99/9999" SKIP(3).

FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "Проценты по балансовому счету " tt-report.balAcct%% SKIP(1).
		END.
	IF FIRST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED "По депозитам в валюте " tt-report.currency ":" SKIP(1).
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				"№ п/п "
				"|Вкладчик                      "
				"|ВАЛ" 
				"|Договор №                "
			        "|Лиц.Счет            "
				"|Сумма %% на 474"
				"|Ставка"
				"|Сумма вклада   "
				"|Сумма расч. %% "
				"|Cумма всех %%  "
				"|Дата выплаты"
				SKIP
				FILL("-",171) SKIP.
		END.
	i = i + 1.
	totalSumma%% = totalSumma%% + tt-report.summa%%.
	totalSumma%%1 = totalSumma%%1 + tt-report.summa%%1.
	totalSumma%%d = totalSumma%%d + tt-report.summa%%d.
	PUT UNFORMATTED
		i FORMAT ">>>>>>"
		"|" tt-report.clientName[1] FORMAT "x(30)"
		"|" tt-report.currency FORMAT "XXX" 
		"|" tt-report.loanInfo[1] FORMAT "x(25)"
	        "|" tt-report.intAccount FORMAT "x(20)"
		"|" tt-report.summa%%1 FORMAT "->>>,>>>,>>9.99"
		"|" (tt-report.rate * 100) FORMAT ">>9.99"
		"|" tt-report.summaDeposit FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.summa%%d FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.nextDate FORMAT "99/99/9999"
		SKIP.
	DO j = 2 TO 3 :
		IF tt-report.clientName[j] <> "" OR tt-report.loanInfo[j] <> "" THEN
			PUT UNFORMATTED
				"      "
				"|" tt-report.clientName[j] FORMAT "x(30)"
				"|   "  
				"|" tt-report.loanInfo[j] FORMAT "x(25)"
				"|" SPACE(20)
				"|" SPACE(15)
				"|" SPACE(6)
				"|" SPACE(15)
				"|" SPACE(15)
				"|" SPACE(15)
				"|"
				SKIP.
	END.
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED 
			  FILL("-",171) SKIP
			  totalSumma%%1 FORMAT "->>>,>>>,>>9.99" AT 90
			  totalSumma%%d FORMAT "->>>,>>>,>>9.99" AT 129
			  totalSumma%% FORMAT "->>>,>>>,>>9.99" AT 145
			  SKIP(1).
			totalSumma%%1 = 0.
			totalSumma%%d = 0.
			totalSumma%% = 0.
		END.
END.

			PUT UNFORMATTED  "Контролер                    ______________  Маршева Е.М." SKIP(1).

			PUT UNFORMATTED  "Ответственный исполнитель    ______________  Балан С.В." SKIP(0).	
			PUT UNFORMATTED  "(ответственный за все графы)" SKIP(3).

			PUT UNFORMATTED  "Примечание к заполнению Приложения :" SKIP(0).
			PUT UNFORMATTED  "гр 1-12  заполняются в соответствии с наименованием в графах  " SKIP(0).
			PUT UNFORMATTED  "* Итоговые значения заполняются по гр 6 - 9 в разрезе валют" SKIP(0).

{preview.i}