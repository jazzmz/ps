{pirsavelog.p}

/**
 * Наращенные проценты по кредитным договорам.
 * Информация о наращенных процентах берется из параметров. Договор
 * должен быть пересчитан на дату отчета.
 * Бурягин Е.П., 16.02.2006 8:55
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
/** Флаг трассировки функций из модулей u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** Дата отчета */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "Дата отчета" NO-UNDO.
/** Итератор */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
/** Итоговая сумма %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.

PAUSE 0.
/** Задаем дату с помощью рук пользователя ;) */
repDate = TODAY.
DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report  NO-UNDO
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR EXTENT 3
	FIELD loanInfo AS CHAR
	FIELD grRisk AS CHAR
	FIELD summa%% AS DECIMAL
	FIELD currency AS CHAR
	INDEX main balAcct%% ASCENDING currency ASCENDING.
	
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
    	/*(
    		loan-acct.acct-type = "КредТ"
    		OR 
    		loan-acct.acct-type = "КредТВ"
    	)
    	AND*/
    	loan-acct.since LE repDate
    	NO-LOCK
  :
  	CREATE tt-report.
  	tt-report.balAcct%% = (IF loan.gr-riska = 1 THEN "47427" ELSE "91604") /*SUBSTRING(loan-acct.acct,1,5)*/.
  	tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", traceOnOff).
  	{wordwrap.i &s=tt-report.clientName &l=30 &n=3}
  	tt-report.loanInfo = loan.cont-code + " от "
  		+ GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff).
  	tt-report.grRisk = STRING(loan.gr-riska).
  	tt-report.summa%% = ABS(
  		GetAcctPosValue_UAL(
  			loan-acct.acct, 
  			loan.currency, repDate, traceOnOff
  		) 
  	) + GetLoanParamValue_ULL(loan.contract, loan.cont-code, 4, repDate, traceOnOff).
  	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
END.

{setdest.i}

PUT UNFORMATTED "РАСЧЕТ ПРОЦЕНТОВ ПО КРЕДИТАМ" AT 35 SKIP
                "по состоянию на " AT 36 repDate FORMAT "99/99/9999" SKIP(1).

FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "Проценты по балансовому счету " tt-report.balAcct%% SKIP(1).
		END.
	IF FIRST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED "По кредитам в валюте " tt-report.currency ":" SKIP(1).
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				"№ п/п "
				"|Заемщик                       "
				"|Договор № от             "
				"|Гр.Риска"
				"|Сумма %%       "
				"|ВАЛ" 
				SKIP
				FILL("-",100) SKIP.
		END.
	i = i + 1.
	totalSumma%% = totalSumma%% + tt-report.summa%%.
	PUT UNFORMATTED
		i FORMAT ">>>>>>"
		"|" tt-report.clientName[1] FORMAT "x(30)"
		"|" tt-report.loanInfo FORMAT "x(25)"
		"|" tt-report.grRisk FORMAT "X(8)"
		"|" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.currency FORMAT "XXX" 
		SKIP.
	DO j = 2 TO 3 :
		IF tt-report.clientName[j] <> "" THEN
			PUT UNFORMATTED
				SPACE(6)
				"|" tt-report.clientName[j] FORMAT "x(30)"
				"|" SPACE(25)
				"|" SPACE(8)
				"|" SPACE(15)
				"|" SPACE(3)
				SKIP.
	END.
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED 
			  FILL("-",100) SKIP
			  totalSumma%% FORMAT "->>>,>>>,>>9.99" AT 74
			  SKIP(1).
			totalSumma%% = 0.
		END.
END.

{preview.i}