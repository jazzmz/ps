{pirsavelog.p}
/**
 * Отчет по кредитным договорам на дату для 124-И.
 * Бурягин Е.П., 10.02.2006 13:36
 */

/** Глобальные определения */
{globals.i}
/** Библиотека функций для работы с кредитными договорами */ 
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
/** Курсы валют на дату */
DEF VAR curRateUSD AS DECIMAL NO-UNDO.
DEF VAR curRateUSDDate AS DATE NO-UNDO.
DEF VAR curRateEUR AS DECIMAL NO-UNDO.
DEF VAR curRateEURDate AS DATE NO-UNDO.

/** Ошибатор */
DEF VAR badLoans AS CHAR.
/** Итератор */
DEF VAR i AS INTEGER.
/** Итоговые суммы */
DEF VAR total5 AS DECIMAL NO-UNDO.
DEF VAR total7 AS DECIMAL NO-UNDO.
DEF VAR total8 AS DECIMAL NO-UNDO.
DEF VAR total9 AS DECIMAL NO-UNDO.
DEF VAR total10 AS DECIMAL NO-UNDO.
DEF VAR total11 AS DECIMAL NO-UNDO.
DEF VAR total12 AS DECIMAL NO-UNDO.
DEF VAR total13 AS DECIMAL NO-UNDO.
DEF VAR total14 AS DECIMAL NO-UNDO.

/** Таблица формы отчета. Используется для сбора информации */
DEFINE TEMP-TABLE tt-report
	FIELD clientName AS CHAR EXTENT 3
	FIELD loanNo LIKE loan.cont-code
	FIELD loanOpenDate LIKE loan.open-date
	FIELD reserv%% AS DECIMAL
	FIELD loanAcctPosCur AS DECIMAL /** Основная + просроченная задолженность */
	FIELD loanCur LIKE loan.currency
	/** FIELD reservAcct LIKE acct.acct */
	FIELD reservCalcCur AS DECIMAL
	FIELD reservCreatedRub AS DECIMAL
	FIELD reservCreatedCur AS DECIMAL
	FIELD limitPosCur AS DECIMAL
	FIELD limitOVPPos AS DECIMAL
	FIELD garPosCur AS DECIMAL
	FIELD garOPVPos1 AS DECIMAL /** вариант расчета от ЦБ   13 = MIN(12, 9) */
	FIELD garOPVPos2 AS DECIMAL /** вариант расчета от БИС  14 = 12 * 4 (графы) */
	
	INDEX loan loanCur loanNo ASCENDING.

PAUSE 0.
/** Задаем дату с помощью рук пользователя ;) */
repDate = TODAY.
DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	
/** Найдем курсы валют */
FIND LAST instr-rate WHERE instr-cat = "currency"	AND	instr-code = "840"	AND	rate-type = "УЧЕТНЫЙ"	AND instr-rate.since LE repDate NO-LOCK NO-ERROR.
IF AVAIL instr-rate THEN DO: curRateUSD = rate-instr. curRateUSDDate = instr-rate.since. END.

FIND LAST instr-rate WHERE instr-cat = "currency"	AND	instr-code = "978"	AND	rate-type = "УЧЕТНЫЙ"	AND instr-rate.since LE repDate NO-LOCK NO-ERROR.
IF AVAIL instr-rate THEN	ASSIGN curRateEUR = rate-instr curRateEURDate = instr-rate.since.


/** Для каждого выбранного договора... */
FOR EACH tmprecid NO-LOCK,
	FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		IF loan.since < repDate THEN
			DO:
				badLoans = badLoans + " " + loan.cont-code.
			END.
		CREATE tt-report.
		tt-report.clientName[1] = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).
		{wordwrap.i &s=tt-report.clientName &l=21 &n=3}
		tt-report.loanNo = loan.cont-code.
		tt-report.loanOpenDate = DATE(GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff)).
		tt-report.reserv%% = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%Рез", repDate, traceOnOff).
		tt-report.loanAcctPosCur = ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, repDate, traceOnOff)) +
				ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 7, repDate, traceOnOff)) +
				GetLoanParamValue_ULL(loan.contract, loan.cont-code, 2, repDate, traceOnOff) +
				ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 13, repDate, traceOnOff)).
		tt-report.loanCur = loan.currency.
		/** tt-report.reservAcct = GetCredLoanAcct_ULL(loan.cont-code, "КредРез", repDate, traceOnOff). */
		tt-report.reservCalcCur = ROUND(tt-report.loanAcctPosCur * tt-report.reserv%%, 2).
		tt-report.reservCreatedRub = ABS(
			GetAcctPosValue_UAL(
				GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредРез", repDate, traceOnOff),
				"810", 
				repDate,
				traceOnOff))
			+ ABS(
			GetAcctPosValue_UAL(
				GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредРез1", repDate, traceOnOff),
				"810", 
				repDate,
				traceOnOff) 
			).
			
				/*
				ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 21, repDate, traceOnOff)) +
				ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 46, repDate, traceOnOff)).
				*/
		tt-report.reservCreatedCur = 0.
		
		IF loan.currency = "840" AND curRateUSD <> 0 THEN
			tt-report.reservCreatedCur = tt-report.reservCreatedRub / curRateUSD.
		
		IF loan.currency = "978" AND curRateEUR <> 0 THEN
			tt-report.reservCreatedCur = tt-report.reservCreatedRub / curRateEUR.
		
		tt-report.limitPosCur = ABS(
			GetAcctPosValue_UAL(
				GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредТВ", repDate, traceOnOff),
				loan.currency, 
				repDate,
				FALSE)) 
			+ ABS(
			GetAcctPosValue_UAL(
				GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредПр%В", repDate, traceOnOff),
				loan.currency, 
				repDate,
				FALSE) 
			).
		tt-report.limitOVPPos = ROUND(tt-report.limitPosCur * (1 - tt-report.reserv%%),2).
		tt-report.garPosCur = ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 42, repDate, traceOnOff))
		  		+ ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 44, repDate, traceOnOff)) 
		  		+ ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 45, repDate, traceOnOff)).
		tt-report.garOPVPos1 = MINIMUM(tt-report.garPosCur, tt-report.reservCreatedCur).
		tt-report.garOPVPos2 = ROUND(tt-report.garPosCur * tt-report.reserv%%,2).
END. /* tmprecid */

IF badLoans <> "" THEN 
	DO:
		MESSAGE "Договорa пересчитаны на дату меньшую, чем дата отчета. Отчет не будет сформирован! (" + badLoans + ")" 
					VIEW-AS ALERT-BOX.
		RETURN.
	END.


{setdest.i &cols=240}

PUT UNFORMATTED 
		"Дата отчета   : " repDate FORMAT "99/99/9999" SKIP
		"КУРС USD на дату " curRateUSDDate FORMAT "99/99/9999" ": " curRateUSD FORMAT "99.9999" SKIP
		"КУРС EUR на дату " curRateEURDate FORMAT "99/99/9999" ": " curRateEUR FORMAT "99.9999" SKIP.

FOR EACH tt-report WHERE loanAcctPosCur > 0 BREAK BY loanCur BY loanNo:
	IF FIRST-OF(tt-report.loanCur) THEN DO:
		PUT UNFORMATTED 
	 		"┌─────────────────────┬──────────┬──────────┬─────┬───────────────────┬───┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┐" SKIP
			"│Наименование заемщика│Кред.дог. │Кред.дог. │проц.│Остаток (Исх)      │ВАЛ│     РЕЗЕРВ        │     РЕЗЕРВ        │     РЕЗЕРВ        │ Остаток по счету  │   91604 для ОВП   │ Остаток по счету  │   91305 для ОВП   │   91305 для ОВП   │" SKIP
			"│                     │   (№)    │   (от)   │(РР) │долг.в валюте      │   │(Расчетный) в вал. │(созданный) в руб. │(созданный) в вал. │    №91604 (вал.)  │                   │    №91305 (вал.)  │   (вариант ЦБ)    │   (вариант БИС)   │" SKIP
	 		"├─────────────────────┼──────────┼──────────┼─────┼───────────────────┼───┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┤" SKIP
			"│          1          │    2     │    3     │  4  │        5          │ 6 │          7        │        8          │          9        │         10        │         11        │         12        │         13        │         14        │" SKIP
	 		"├─────────────────────┼──────────┼──────────┼─────┼───────────────────┼───┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┤" SKIP.
	END.

	PUT UNFORMATTED 
		"│" tt-report.clientName[1] FORMAT "X(21)"
		"│" tt-report.loanNo FORMAT "X(10)"
		"│" tt-report.loanOpenDate FORMAT "99/99/9999"
		"│" STRING(tt-report.reserv%% * 100, ">>>9") "%"
		"│" tt-report.loanAcctPosCur FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.loanCur FORMAT "XXX"
/**		"│" tt-report.reservAcct FORMAT "X(20)" */
		"│" tt-report.reservCalcCur FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.reservCreatedRub FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.reservCreatedCur FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.limitPosCur FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.limitOVPPos FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.garPosCur FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.garOPVPos1 FORMAT "->>>,>>>,>>>,>>9.99"
		"│" tt-report.garOPVPos2 FORMAT "->>>,>>>,>>>,>>9.99"
		"│" SKIP.
	DO i = 2 TO 3 :
		IF tt-report.clientName[i] <> "" THEN
			DO:
				PUT UNFORMATTED 
					"│" tt-report.clientName[i] FORMAT "X(21)"
					"│" SPACE(10)
					"│" SPACE(10)
					"│" SPACE(5)
					"│" SPACE(19)
					"│" SPACE(3)
/**					"│" SPACE(20) */
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SPACE(19)
					"│" SKIP.
			END.
	END.
	PUT UNFORMATTED 
	 	"├─────────────────────┼──────────┼──────────┼─────┼───────────────────┼───┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┼───────────────────┤" SKIP.
	/** Расчитываем итоги */
		total5 = total5 + tt-report.loanAcctPosCur.
		total7 = total7 + tt-report.reservCalcCur.
		total8 = total8 + tt-report.reservCreatedRub.
		total9 = total9 + tt-report.reservCreatedCur.
		total10 = total10 + tt-report.limitPosCur.
		total11 = total11 + tt-report.limitOVPPos.
		total12 = total12 + tt-report.garPosCur.
		total13 = total13 + tt-report.garOPVPos1.
		total14 = total14 + tt-report.garOPVPos2.

	IF LAST-OF(tt-report.loanCur) THEN DO:
		PUT UNFORMATTED 
					"│   ИТОГО:            " 
					"│" SPACE(10)
					"│" SPACE(10)
					"│" SPACE(5)
					"│" total5 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" SPACE(3)
					/**					"│" SPACE(20) */
					"│" total7 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total8 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total9 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total10 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total11 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total12 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total13 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" total14 FORMAT "->>>,>>>,>>>,>>9.99"
					"│" SKIP
 	  			"└─────────────────────┴──────────┴──────────┴─────┴───────────────────┴───┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┘" SKIP.
		ASSIGN total5 = 0 total7 = 0 total8 = 0 total9 = 0 total10 = 0 total11 = 0 total12 = 0 total13 = 0 total14 = 0.
	END.
END.


{preview.i}
