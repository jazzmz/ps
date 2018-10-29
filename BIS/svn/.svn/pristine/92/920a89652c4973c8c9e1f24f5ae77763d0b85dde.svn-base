{pirsavelog.p}

/**
 * Печать распоряжения по процентам по кредитным договорам.
 * Информация о процентах берется из параметров. Договор
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
{get-bankname.i}

/** Рабочая переменная */
DEF VAR tmpStr AS CHAR NO-UNDO.
/** Флаг трассировки функций из модулей u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** Дата отчета */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "Дата отчета" NO-UNDO.
/** Итератор */
DEF VAR i AS INTEGER.
DEF VAR j AS INTEGER.
/** Итоговая сумма %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.

DEF VAR bosLoan AS CHAR.
DEF VAR execUser AS CHAR.

PAUSE 0.
/** Задаем дату с помощью рук пользователя ;) */
repDate = TODAY.
DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR EXTENT 3
	FIELD loanInfo AS CHAR
	FIELD grRisk AS CHAR
	FIELD summa%% AS DECIMAL
	FIELD currency AS CHAR
	INDEX main balAcct%% ASCENDING currency ASCENDING.
	
/** Прочитаем начальников */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
/** Прочитаем исполнителя */
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	execUser = _user._user-name.
ELSE
	execUser = "-".

FOR EACH tmprecid 
			NO-LOCK,
    FIRST loan WHERE 
    	RECID(loan) = tmprecid.id 
    	NO-LOCK
  :
  	CREATE tt-report.
  	tt-report.balAcct%% = (IF loan.gr-riska = 1 THEN "47427" ELSE "91604") /*SUBSTRING(loan-acct.acct,1,5)*/.
  	tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).
  	{wordwrap.i &s=tt-report.clientName &l=30 &n=3}
  	tt-report.loanInfo = loan.cont-code + " от "
  		+ GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff).
  	tt-report.grRisk = STRING(loan.gr-riska).
  	tt-report.summa%% = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 4, repDate, traceOnOff).
  	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
END.

{setdest.i}

PUT UNFORMATTED 
		SPACE(70) "В Департамент 3" SKIP
		SPACE(70) cBankName SKIP(2)
		SPACE(70) 'Дата: ' repDate FORMAT "99/99/9999" SKIP(1)
		SPACE(35) 'Р А С П О Р Я Ж Е Н И Е' SKIP(1)
		SPACE(4) 'В соответствии с Положением Банка России №39-П от 26.06.98г. "О порядке начисления' SKIP
		      'процентов по операциям, связанным с привлечением и размещением денежных средств' SKIP
		      'банками, и отражения указанных операций по счетам бухгалтерского учета" прошу Вас' SKIP
		      'начислить проценты на задолженность по следующим кредитам:' SKIP(2).

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
				'┌──────┬───────────────────────────────┬─────────────────────────┬───────────────┬───┐' SKIP
				"│№ п/п │Заемщик                        │Договор № от             │Сумма %%       │ВАЛ│" SKIP
				'├──────┼───────────────────────────────┼─────────────────────────┼───────────────┼───┤' SKIP.
		END.
	i = i + 1.
	totalSumma%% = totalSumma%% + tt-report.summa%%.
	PUT UNFORMATTED
		"│" i FORMAT ">>>>>>"
		"│" tt-report.clientName[1] FORMAT "x(31)"
		"│" tt-report.loanInfo FORMAT "x(25)"
		"│" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"│" tt-report.currency FORMAT "XXX" 
		"│"	SKIP.
	DO j = 2 TO 3 :
		IF tt-report.clientName[j] <> "" THEN
			PUT UNFORMATTED
				"│" SPACE(6)
				"│" tt-report.clientName[j] FORMAT "x(31)"
				"│" SPACE(25)
				"│" SPACE(15)
				"│" SPACE(3)
				"│"	SKIP.
	END.
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED 
				'├──────┼───────────────────────────────┼─────────────────────────┼───────────────┼───┤' SKIP
				"│" SPACE(6)
				"│" SPACE(31)
				"│" SPACE(25)
				"│" totalSumma%% FORMAT "->>>,>>>,>>9.99"
				"│" SPACE(3)
				"│"	SKIP
				"└──────┴───────────────────────────────┴─────────────────────────┴───────────────┴───┘"
			  SKIP(1).
			totalSumma%% = 0.
		END.
END.

PUT UNFORMATTED
	SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(3)
	SPACE(4) 'Исполнитель: ' execUser SKIP(3)
	SPACE(4) 'Отметка Департамента 3:' SKIP.

{preview.i}