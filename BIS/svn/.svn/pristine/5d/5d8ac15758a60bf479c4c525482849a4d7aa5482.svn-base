/** 
	Печать сводного распоряжения по депозитным договорам 
	Бурягин Е.П.
	19.05.2006 9:24
*/

/**
	pirdps114.p - формирование распоряжения о начислении процентов
	по депозиту и возврат вклада и начисленных процентов в связи с
	окончанием срока.
*/

DEF INPUT PARAM iParam AS CHAR.

{tmprecid.def}        /** Используем информацию из броузера */

/** Дата распоряжения */
DEF VAR docDate AS DATE LABEL "Дата распоряжения".
/** Период расчета процентов */
DEF VAR periodBegin AS DATE  NO-UNDO.
DEF VAR periodEnd AS DATE  NO-UNDO.
/** Даты подпериодов */
DEF VAR subperBegin AS DATE NO-UNDO.
DEF VAR subperEnd AS DATE NO-UNDO.
DEF VAR subperDays AS INTEGER NO-UNDO.

/** Номер депозитного счета */
DEF VAR dpsAcct AS CHAR NO-UNDO.
/** Номер счета для %% */
DEF VAR PrAcct AS CHAR NO-UNDO.
/** Номер счета по расходам банка на выплату %% */
DEF VAR outcomeacct AS CHAR NO-UNDO.

/** Комиссия по договору */
DEF VAR comm AS DECIMAL NO-UNDO.
DEF VAR newComm AS DECIMAL NO-UNDO.
/** Остаток по счету */
DEF VAR amount AS DECIMAL NO-UNDO.
DEF VAR newAmount AS DECIMAL NO-UNDO.
/** Сумма процентов за период */
DEF VAR persAmount AS DECIMAL NO-UNDO.
/** Общая сумма процентов */
DEF VAR totalPersAmount AS DECIMAL NO-UNDO.
DEF VAR totalPersAmountStr AS CHAR EXTENT 2 NO-UNDO.
/** Итератор */
DEF VAR iDate AS DATE NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER INITIAL 0 NO-UNDO.
/** Кол-во дней в глобальном периоде */
DEF VAR globDays AS INTEGER INITIAL 365 NO-UNDO.
/** Таблица процентов */
DEF VAR persTable AS CHAR NO-UNDO.
/** Вместо SKIP */
DEF VAR cr AS CHAR NO-UNDO.
cr = CHR(10).
/** Временная */
DEF VAR tmpStr AS CHAR EXTENT 10 NO-UNDO.

/** Выплата в конце срока */
/*DEF VAR payOutFlag AS LOGICAL INITIAL FALSE.*/

/** Перенос строк */
{wordwrap.def}

/** Глобальные определения */
{globals.i}

/** Библиотека функций работы с договорами */
{ulib.i}

def var cur_year as integer NO-UNDO.
/** Бос */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR NO-UNDO. /** Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).

/***********************************************/
/*** запрос #1327                                   ***/

{intrface.get count}

DEF VAR oSysClass1	    AS TSysClass NO-UNDO.
DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.

curr-user-id = USERID("bisquit").
curr-user-inspector = '02050MEM'.
DEF VAR oEra    AS TEra                        NO-UNDO.
DEF VAR oConfig AS TAArray                     NO-UNDO.
DEF VAR taxon   AS CHAR    INIT "fin ved acct" NO-UNDO.

{pir-c2346u.i}

/**************************************************/

{getdate.i}
ASSIGN docDate = end-date.
{getdates.i}
{get-bankname.i}
{setdest.i}

/** 
	Шапка таблицы 
*/
		
/** Формируем распоряжение */
		
PUT UNFORMATTED SPACE(70) "В Департамент 3" SKIP
SPACE(70) cBankName SKIP(2)
SPACE(70) 'Дата: ' docDate FORMAT "99/99/9999" SKIP(4)
SPACE(45) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3).

persTable = "                 ВЕДОМОСТЬ РАСЧЕТА ПРОЦЕНТОВ ЗА  " +  MONTH_NAMES[MONTH(end-date)] + ' ' + STRING(YEAR(end-date)) + ' г.'  +  cr
	+ "┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┬────────────────────┬────────────────────┐" + cr
	+ "│ Остаток          │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │       Счет         │       Счет         │" + cr
	+ "│ на счете         ├──────────┬──────────┤ дней   │        │ процентов        │     по дебету      │     по кредиту     │" + cr
	+ "│                  │     С    │    ПО    │        │        │                  │                    │                    │" + cr
	+ "├──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┴────────────────────┴────────────────────┤" + cr.


/** 
	Шапка текстовки 
*/

tmpStr[1] = 'В соответствии с Положением Банка России №39-П от 26.06.1998г. начислить ' +
		'проценты на остаток по счету банковского вклада согласно ведомости:'.

/** 
	Вывод шапки текстовки 
*/

{wordwrap.i &s=tmpStr &n=10 &l=120}
		
tmpStr[1] = '   ' + tmpStr[1].
DO i = 1 TO 10 :
	IF tmpStr[i] <> "" THEN
		PUT UNFORMATTED tmpStr[i] SKIP.
END.
PUT UNFORMATTED "" SKIP(1).



/** Поиск выбранных договоров */
FOR EACH tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		ASSIGN
			totalPersAmount = 0.
			periodBegin = beg-date.	
		IF (periodBegin <= loan.open-date) THEN periodBegin = loan.open-date + 1.
		periodEnd = end-date.
		IF(periodEnd > loan.end-date) THEN periodEnd = loan.end-date.
		
		cur_year = YEAR(periodEnd).
		if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
			globDays = 366.
		else
			globDays = 365.
			
			
		/*
		payOutFlag = FALSE.
		IF(periodEnd = loan.end-date) THEN payOutFlag = TRUE.
		*/
		
		
		/** Поиск депозитного счета */
		dpsAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Депоз", periodBegin - 1, false).
		
		/** Поиск счета по оплате %% */
		prAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "ДепТ", periodBegin - 1, false).
		
		/** Поиск расчетного по оплате %% */
		outcomeacct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "ДепПроц", periodBegin - 1, false).
		
		
		/** Процентная ставка */
		comm = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%Деп", periodBegin - 1, false).
		/** Остаток вклада */
		amount = ABS(GetAcctPosValue_UAL(dpsAcct, loan.currency, periodBegin - 1, false)).
		/** Подпериод равен всему периоду */
		ASSIGN 
			subperBegin = periodBegin
			subperEnd = periodEnd.
		
		/** 
			Добавляем в таблицу информацию о договоре
		*/
		persTable = persTable + 	
				"│Счет №" + GetLoanAcct_ULL(loan.contract, loan.cont-code, "Депоз", periodEnd - 1, false) + "                                                                                             │" + cr +
				"│" + STRING(GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE),"x(119)") + "│" + cr + 
				"│Дог. №" + STRING(loan.cont-code, "x(11)") + " от " + STRING(loan.open-date,"99/99/9999") +
				"                                                                                        │" + cr +
				"├──────────────────┬─────────────────────┬────────┬────────┬──────────────────┬────────────────────┬────────────────────┤" + cr.             
		
		/** 
			Основной цикл формирования таблицы начисления процентов.
			Пробегаем по каждому дню, и определяем, изменилась ли процентная ставка или остаток.
			Если изменения были в указанный день, то разбиваем общий период на подпериоды.
		*/
		DO iDate = periodBegin TO periodEnd - 1 :
 	 	        dpsAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Депоз", iDate, false).
			newAmount = ABS(GetAcctPosValue_UAL(dpsAcct, loan.currency, iDate, false)).
			newComm = GetLoanCommission_ULL(loan.contract, loan.cont-code, "%Деп", iDate, false).
			IF (newAmount <> amount) OR (newComm <> comm) OR (DAY(iDate + 1) = 1) THEN DO:
				
				
				/*FIND FIRST op-entry  WHERE 	op-entry.acct-cr = prAcct AND op-entry.op-date = iDate NO-LOCK NO-ERROR .
				IF AVAIL op-entry THEN
				DO:
					outcomeacct = op-entry.acct-db .
				END.*/
				
				
				subperEnd = iDate.
				subperDays = subperEnd - subperBegin + 1.
				persAmount = ROUND(amount * comm / globDays * subperDays,2).
				persTable = persTable + 
					"│" + STRING(amount,">>>,>>>,>>>,>>9.99") +
					"│" + STRING(subperBegin,"99/99/9999") +
					"│" + STRING(subperEnd, "99/99/9999") +
					"│" + STRING(subperDays, ">>>>>>>>") +
					"│" + STRING(comm * 100,">>>>9.99") +
					"│" + STRING(persAmount,">>>,>>>,>>>,>>9.99") +
					"│" + STRING(outcomeacct) +
					"│" + STRING(pracct) +

					"│" + cr.
				totalPersAmount = totalPersAmount + persAmount.
				amount = newAmount.
				comm = newComm.
				subperBegin = iDate + 1.
				subperEnd = periodEnd.
			END.
		END.
		
		/** Обработаем последний подпериод */
		subperDays = subperEnd - subperBegin + 1.
		persAmount = ROUND(amount * comm / globDays * subperDays,2).
		persTable = persTable + 
			"│" + STRING(amount,">>>,>>>,>>>,>>9.99") +
			"│" + STRING(subperBegin,"99/99/9999") +
			"│" + STRING(subperEnd, "99/99/9999") +
			"│" + STRING(subperDays, ">>>>>>>>") +
			"│" + STRING(comm * 100,">>>>9.99") +
			"│" + STRING(persAmount,">>>,>>>,>>>,>>9.99") +
			"│" + STRING(outcomeacct) +
			"│" + STRING(pracct) +			
			"│" + cr.
		totalPersAmount = totalPersAmount + persAmount.
		
		/** 
			Итоги таблицы по счету
		*/
		persTable = persTable + "├──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┴────────────────────┴────────────────────┤" + cr
			 	                  + "│Итого по л/счету " + dpsAcct + "                                                                " + STRING(totalPersAmount,">>>,>>>,>>>,>>9.99") + "│" + cr +
			                    	"├───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤" + cr.             

		
		/** 
			Заполняем текстовку для текущего договора 
		*/
		
		Run x-amtstr.p(totalPersAmount, loan.currency, true, true, 
				output totalPersAmountStr[1], 
				output totalPersAmountStr[2]).
	  totalPersAmountStr[1] = totalPersAmountStr[1] + ' ' + totalPersAmountStr[2].
		Substr(totalPersAmountStr[1],1,1) = Caps(Substr(totalPersAmountStr[1],1,1)).
		
		j = j + 1.
		tmpStr[1] = STRING(j) + ") " + GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", FALSE) + 
			" по Договору банковского вклада №" + loan.cont-code + 
			" от " + STRING(loan.open-date, "99/99/9999") + " в размере " + STRING(ROUND(totalPersAmount,2)) + " (" +
			totalPersAmountStr[1] + ").".
		
		
		/** 
			Выводим текстовку по договору 
		
		{wordwrap.i &s=tmpStr &n=10 &l=80}
		
		DO i = 1 TO 10 :
			IF tmpStr[i] <> "" THEN
				PUT UNFORMATTED tmpStr[i] SKIP.
		END.
		PUT UNFORMATTED "" SKIP(1).

		*/
		
END.

persTable = persTable + "└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘" + cr.



/** 
	Вывод таблицы расчета процентов 
*/

PUT UNFORMATTED "" SKIP(3) persTable SKIP(4).
		
PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(1).

if fioSpecDPS <> "" then
				PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
		

{preview.i}

/***********************************************/
/***  запрос #1327                           ***/

oConfig = new TAArray().
oConfig:setH("taxon",taxon).
oConfig:setH("opdate",TEra:getDate(docDate)). /* # 2798 */
oConfig:setH("num",iCurrOut).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",USERID("bisquit")).
oConfig:setH("inspector",curr-user-inspector).
oConfig:setH("fext","txt").
oEra = new TEra(TRUE).
 oEra:askAndSave(oConfig,"_spool.tmp").
DELETE OBJECT oEra.
DELETE OBJECT oConfig.















