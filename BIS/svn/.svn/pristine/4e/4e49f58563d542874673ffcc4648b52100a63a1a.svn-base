{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pirdps103i.p
      Comment: Распоряжение по начислению и выплате
		Сделано на основе pirdps103.p
   Parameters: ФИО исполнителя
         Uses:
      Created: Sitov S.A., 29.06.2012
	Basis: # 1074
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


DEF INPUT PARAM iParam AS CHAR.

{tmprecid.def}        /** Используем информацию из броузера */

/** Дата распоряжения */
DEF VAR docDate AS DATE LABEL "Дата распоряжения" NO-UNDO.
/** Период расчета процентов */
DEF VAR periodBegin AS DATE NO-UNDO.
DEF VAR periodEnd AS DATE NO-UNDO.
/** Даты подпериодов */
DEF VAR subperBegin AS DATE NO-UNDO.
DEF VAR subperEnd AS DATE NO-UNDO.
DEF VAR subperDays AS INTEGER NO-UNDO.
/** Даты подпериодов расчета ставки рефинансирования */
DEF VAR refsubperBegin AS DATE NO-UNDO.
DEF VAR refsubperEnd AS DATE NO-UNDO.
DEF VAR refsubperDays AS INTEGER NO-UNDO.
/** Номер депозитного счета */
DEF VAR dpsAcct AS CHAR NO-UNDO.
/** Комиссия по договору */
DEF VAR comm AS DECIMAL NO-UNDO.
DEF VAR newComm AS DECIMAL NO-UNDO.
/** Ставка рефенансирования */
DEF VAR cbref AS DECIMAL NO-UNDO.
DEF VAR newCbref AS DECIMAL NO-UNDO.
/** Остаток по счету */
DEF VAR amount AS DECIMAL NO-UNDO.
DEF VAR newAmount AS DECIMAL NO-UNDO.
DEF VAR totalAmountStr AS CHAR EXTENT 2 NO-UNDO.
/** Сумма процентов за период */
DEF VAR persAmount AS DECIMAL NO-UNDO.
/** Сумма процентов за период по ставке рефинансирования */
DEF VAR refPersAmount AS DECIMAL NO-UNDO.
/** Признак разбиения процентного периода по ставке рефинансирования */
DEF VAR divRefPeriod AS LOGICAL NO-UNDO.
/** Общая сумма процентов */
DEF VAR totalPersAmount AS DECIMAL NO-UNDO.
DEF VAR totalPersAmountStr AS CHAR EXTENT 2 NO-UNDO.
/** Общая сумма процентов по ставке рефинансирования */
DEF VAR totalRefPersAmount AS DECIMAL NO-UNDO.
DEF VAR totalNalogStr AS CHAR EXTENT 2 NO-UNDO.
DEF VAR totalNalog AS DECIMAL NO-UNDO.
DEF VAR nalog AS DECIMAL NO-UNDO.
/** Итератор */
DEF VAR iDate AS DATE NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
/** Кол-во дней в глобальном периоде */
DEF VAR globDays AS INTEGER INITIAL 365 NO-UNDO.
/** Таблица процентов */
DEF VAR persTable AS CHAR NO-UNDO.
/** Вместо SKIP */
DEF VAR cr AS CHAR NO-UNDO.
cr = CHR(10).
/** Временная */
DEF VAR tmpStr AS CHAR EXTENT 10 NO-UNDO.
DEF VAR tmpDec1 AS DECIMAL NO-UNDO.
DEF VAR tmpDec2 AS DECIMAL NO-UNDO.
/** Расчет налога */
DEF VAR nalogCalcStr AS CHAR NO-UNDO.
DEF VAR curConvertStr AS CHAR NO-UNDO.

/** Код комиссии подоходного налога */
DEF VAR pdhNalog AS CHAR INIT "ПдхН1" NO-UNDO.

/** Выплата в конце срока */
DEF VAR payOutFlag AS LOGICAL INITIAL FALSE NO-UNDO.

/* Глобальные опеределения */
DEF VAR MAIN_ACCT_NAME AS CHAR INITIAL "loan-dps-t,loan-dps-p" NO-UNDO.
DEF VAR PAYOUT_ACCT_NAME AS CHAR INITIAL "loan-dps-out" NO-UNDO.

/** Перенос строк */
{wordwrap.def}

/** Глобальные определения */
{globals.i}
{get-bankname.i}
/** Библиотека функций работы с договорами */
{ulib.i}

def var cur_year as integer.

/** Бос */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

def var ExecFIO as char no-undo.
find first _user where _user._userid = userid no-lock no-error.
if avail _user then
	ExecFIO = _user._user-name.
else
	ExecFIO = "-".

DEF VAR fioSpecDPS AS CHAR NO-UNDO. /** Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).





/** Поиск выбранного договора */
FOR FIRST tmprecid NO-LOCK,
		FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
	:
		{getdate.i}
		ASSIGN docDate = end-date.
		{getdates.i}
		ASSIGN
			periodBegin = beg-date.	
		IF (periodBegin <= loan.open-date) THEN periodBegin = loan.open-date + 1.
		periodEnd = end-date.
		IF(periodEnd > loan.end-date) THEN periodEnd = loan.end-date.
		
		cur_year = YEAR(periodEnd).
		if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
			globDays = 366.
		else
			globDays = 365.
			
		payOutFlag = FALSE.
		IF(periodEnd = loan.end-date) THEN payOutFlag = TRUE.
		
		/** Код комиссии подоходного налога */
		if GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_country", false) <> "RUS" THEN
			pdhNalog = "ПдхН1н".
			
		{setdest.i}
		
		/** Поиск депозитного счета */
		dpsAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, MAIN_ACCT_NAME, periodBegin - 1, FALSE).
		/** Процентная ставка */
		comm = GetDpsCommission_ULL(loan.cont-code, "commission", periodBegin, FALSE).
		/** Остаток вклада */
		amount = ABS(GetAcctPosValue_UAL(dpsAcct, loan.currency, periodBegin - 1, FALSE)).

		/** Подпериод равен всему периоду */
		ASSIGN 
			subperBegin = periodBegin
			subperEnd = periodEnd
			refsubperBegin = periodBegin
			refsubperEnd = periodEnd.

		/** Ставка рефинансирования */
	
		cbref = GetCommRate_ULL("%ЦБрефП", loan.currency, 0.00, "", 0, periodBegin - 1, FALSE).

		divRefPeriod = FALSE.
		
		/** 
			Шапка таблицы 
		*/
		
		
		
		persTable = "                 РАСЧЕТ  ПРОЦЕНТОВ  С  " + STRING(periodBegin,"99/99/9999") 
			+ "  ПО  " + STRING(periodEnd, "99/99/9999") + cr
			+ "┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┐" + cr
			+ "│ Остаток          │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │" + cr
			+ "│ на счете         ├──────────┬──────────┤ дней   │        │ процентов        │" + cr
			+ "│                  │     С    │    ПО    │        │        │                  │" + cr
			+ "├──────────────────┼──────────┼──────────┼────────┼────────┼──────────────────┤" + cr.
			
		
		/** 
			Основной цикл формирования таблицы начисления процентов.
			Пробегаем по каждому дню глобального периода, и определяем, изменилась ли процентная ставка или остаток.
			Если изменения были в указанный день, то разбиваем общий период на подпериоды.
			Также разбиваем на подпериоды датами конца месяца.
		*/
		DO iDate = periodBegin TO periodEnd - 1 :
			/** Может счет изменился? */
			dpsAcct = GetLoanAcct_ULL(loan.contract, loan.cont-code, MAIN_ACCT_NAME, iDate, FALSE).
			/** Новый остаток */
			newAmount = ABS(GetAcctPosValue_UAL(dpsAcct, loan.currency, iDate, FALSE)).
			/** Новая процентная ставка */
			newComm = GetDpsCommission_ULL(loan.cont-code, "commission", iDate + 1, FALSE).
			/** Новая ставка рефинансирования */
			newCbref = GetCommRate_ULL("%ЦБрефП", loan.currency, 0.00, "", 0, iDate + 1, FALSE).
			
			/** Если есть разница, то... */
			IF (newCbref <> cbref) THEN
				divRefPeriod = TRUE.
				
			/** Если есть разница или следующее число - 1 число месяца, то... */
			IF (newAmount <> amount) OR (newComm <> comm) OR (DAY(iDate + 1) = 1) THEN DO:
				divRefPeriod = TRUE.
				/** Дата окончания подпериода равна текущей дате цикла по переменной iDate */
				subperEnd = iDate.
				/** База */
				cur_year = YEAR(subperEnd).
				if TRUNCATE(cur_year / 4,0) = cur_year / 4 then globDays = 366.	else globDays = 365.
				/** Кол-во дней в подпериоде вычисляются как разность + 1 день, т.к. дни учитываются включительно */
				subperDays = subperEnd - subperBegin + 1.
				/** Сумма процентов за подпериод */
				persAmount = ROUND(amount * comm / globDays * subperDays,2).
				/** Вывод в переменную */
				persTable = persTable + 
					"│" + STRING(amount,">>>,>>>,>>>,>>9.99") +
					"│" + STRING(subperBegin,"99/99/9999") +
					"│" + STRING(subperEnd, "99/99/9999") +
					"│" + STRING(subperDays, ">>>>>>>>") +
					"│" + STRING(comm * 100,">>>>9.99") +
					"│" + STRING(persAmount,">>>,>>>,>>>,>>9.99") +
					"│" + cr.
				/** Прибавляем к итогу */
				totalPersAmount = totalPersAmount + persAmount.
			END.
			
			/**
1				Если нужно разбить период начисления процентов по ставке рефинансирования 
			*/
			IF (divRefPeriod) THEN DO:
				refsubperEnd = iDate.
				refsubperDays = refsubperEnd - refsubperBegin + 1.
				tmpDec1 = ROUND(amount * (comm - cbref) / globDays * refsubperDays,2).

				IF (comm - cbref > 0) THEN DO:
				
	 				IF (loan.currency <> "") THEN DO:
		 				FIND LAST instr-rate WHERE 
								instr-code = loan.currency
								AND
								rate-type = "Учетный"
								AND
								since LE docDate /* periodEnd */
								NO-LOCK NO-ERROR.
						IF AVAIL instr-rate THEN DO:
								curConvertStr = 
									'Сумма доходов от процентов по вкладу: ' + 
									STRING((comm - cbref) * 100, '->9.99') + '% / ' + STRING(globDays) + ' * ' + STRING(refsubperDays) +
									' * ' + STRING(amount) + ' = ' + 
									STRING(tmpDec1) + cr +
									'Курс валюты ' + loan.currency + ': ' + STRING(instr-rate.rate-instr, ">9.9999") + ' руб.' + cr
									+ 'Рублевый эквивалент доходов от процентов по вкладу: ' + 
									STRING(tmpDec1) + ' * ' + STRING(instr-rate.rate-instr) + ' = ' +
									STRING(ROUND(tmpDec1 * instr-rate.rate-instr,2)) + ' руб.' + cr.
								tmpDec1 = ROUND(tmpDec1 * instr-rate.rate-instr,2).
						END.
					END.
					ELSE
						curConvertStr = 
									'Сумма доходов от процентов по вкладу: ' + 
									STRING((comm - cbref) * 100, '->9.99') + '% / ' + STRING(globDays) + ' * ' + STRING(refsubperDays) +
									' * ' + STRING(amount) + ' = ' + 
									STRING(tmpDec1) + cr.
					
					
					nalog = ROUND(tmpDec1 * GetCommRate_ULL(pdhNalog, "", 0.00, "", 0, periodEnd, FALSE),2).
		
					totalNalog = totalNalog + nalog.
					
					nalogCalcStr = nalogCalcStr + 
						'Сумма вклада: ' + STRING(amount) + " (".
					IF (loan.currency = "") THEN
						nalogCalcStr = nalogCalcStr + "810".
					ELSE 
						nalogCalcStr = nalogCalcStr + loan.currency.
					nalogCalcStr = nalogCalcStr + ")" + cr +
						'Ставка по вкладу: ' + STRING(comm * 100, '->9.99') + '%' + cr +
						'Период, за который возникает доход от процентов по вкладу: с ' + STRING(refsubperBegin, "99/99/9999") +
							' по ' + STRING(refsubperEnd, "99/99/9999") + cr +
						'Максимально допустимый размер ставки, не попадающий' + cr + 
						'под налогообложение: ' + STRING(cbref * 100, '->9.99') + '% годовых' + cr +
						'Превышение: ' + STRING((comm - cbref) * 100, '->9.99') + '% годовых' + cr + 
						curConvertStr +
						'Ставка налога: ' + STRING(GetCommRate_ULL(pdhNalog, "", 0.00, "", 0, periodEnd, FALSE) * 100, '->9.99') + '%' + cr + 
						'Сумма налога с дохода от процентов по вкладу: ' + STRING(tmpDec1) + ' * ' + 
						STRING(GetCommRate_ULL(pdhNalog, "", 0.00, "", 0, periodEnd, FALSE) * 100, '->9.99') + '%' +
						' = ' + STRING(nalog) + cr + cr.
	
				END. /* comm - cbref > 0 */

				cbref = newCbref.
				refsubperBegin = iDate + 1.
				refsubperEnd = periodEnd.	
					
				divRefPeriod = FALSE.			
					
			END.
	

			IF (newAmount <> amount) OR (newComm <> comm) OR (DAY(iDate + 1) = 1) THEN DO:
				/** Замена */
				amount = newAmount.
				comm = newComm.
				/** Новый подпериод начинается со следующего дня от iDate */
				subperBegin = iDate + 1.
				/** Конец нового подпериода по-умолчанию равен концу глобального периода расчета */
				subperEnd = periodEnd.
			END.

			
		END.
		
		/** 
			Обработаем последний подпериод. Выше описанное условие в цикле может ни разу не отработать,
			тогда необходим следующий кусок кода. В принципе, это кусок нужен в любом случае.
		*/
		subperDays = subperEnd - subperBegin + 1.
		/** База */
		cur_year = YEAR(subperEnd).
		if TRUNCATE(cur_year / 4,0) = cur_year / 4 then globDays = 366.	else globDays = 365.
		persAmount = ROUND(amount * comm / globDays * subperDays,2).
		persTable = persTable + 
			"│" + STRING(amount,">>>,>>>,>>>,>>9.99") +
			"│" + STRING(subperBegin,"99/99/9999") +
			"│" + STRING(subperEnd, "99/99/9999") +
			"│" + STRING(subperDays, ">>>>>>>>") +
			"│" + STRING(comm * 100,">>>>9.99") +
			"│" + STRING(persAmount,">>>,>>>,>>>,>>9.99") +
			"│" + cr.
		totalPersAmount = totalPersAmount + persAmount.

		refsubperDays = refsubperEnd - refsubperBegin + 1.
		tmpDec1 = ROUND(amount * (comm - cbref) / globDays * refsubperDays,2).

			IF (comm - cbref > 0) THEN DO:
				IF (loan.currency <> "") THEN DO:
					FIND LAST instr-rate WHERE 
							instr-code = loan.currency
							AND
							rate-type = "Учетный"
							AND
							since LE docDate /* periodEnd */
							NO-LOCK NO-ERROR.
					IF AVAIL instr-rate THEN DO:
							curConvertStr = 
								'Сумма процентов: ' + 
								STRING((comm - cbref) * 100, '->9.99') + '% / ' + STRING(globDays) + ' * ' + STRING(refsubperDays) +
								' * ' + STRING(amount) + ' = ' + 
								STRING(tmpDec1) + cr +
								'Курс валюты ' + loan.currency + ': ' + STRING(instr-rate.rate-instr, ">9.9999") + ' руб.' + cr
								+ 'Рублевый эквивалент: ' + 
								STRING(tmpDec1) + ' * ' + STRING(instr-rate.rate-instr) + ' = ' +
								STRING(ROUND(tmpDec1 * instr-rate.rate-instr,2)) + ' руб.' + cr.
							tmpDec1 = ROUND(tmpDec1 * instr-rate.rate-instr,2).
					END.
				END.
				ELSE
					curConvertStr = 
								'Сумма процентов: ' + 
								STRING((comm - cbref) * 100, '->9.99') + '% / ' + STRING(globDays) + ' * ' + STRING(refsubperDays) +
								' * ' + STRING(amount) + ' = ' + 
								STRING(tmpDec1) + cr.

					
				nalog = ROUND(tmpDec1 * GetCommRate_ULL(pdhNalog, "", 0.00, "", 0, periodEnd, FALSE),2).
	
				totalNalog = totalNalog + nalog.
					
				nalogCalcStr = nalogCalcStr + 
					'Сумма вклада: ' + STRING(amount) + " (".
				IF (loan.currency = "") THEN
					nalogCalcStr = nalogCalcStr + "810".
				ELSE 
					nalogCalcStr = nalogCalcStr + loan.currency.
				nalogCalcStr = nalogCalcStr + ")" + cr +
					'Ставка по вкладу: ' + STRING(comm * 100, '->9.99') + '%' + cr +
					'Период, за который возникает доход от процентов по вкладу: с ' + STRING(refsubperBegin, "99/99/9999") +
						' по ' + STRING(refsubperEnd, "99/99/9999") + cr +
					'Максимально допустимый размер ставки, не попадающий' + cr + 
					'под налогообложение: ' + STRING(cbref * 100, '->9.99') + '% годовых' + cr +
					'Превышение: ' + STRING(((comm - cbref) * 100), '->9.99') + '% годовых' + cr + 
					curConvertStr + 
					'Ставка налога: ' + STRING(GetCommRate_ULL(pdhNalog, "", 0.00, "", 0, periodEnd, FALSE) * 100, '->9.99') + '%' + cr + 
					'Сумма налога с дохода от процентов по вкладу: ' + STRING(tmpDec1) + ' * ' + 
					STRING(GetCommRate_ULL(pdhNalog, "", 0.00, "", 0, periodEnd, FALSE) * 100, '->9.99') + '%' +
					' = ' + STRING(nalog) + cr + cr.

			END. /** comm - cbref > 0 */


		/** 
			Итоги таблицы 
		*/
		persTable = persTable + "└──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┘" + cr
			 	                  + "                                        Начислено процентов:" + STRING(totalPersAmount,">>>,>>>,>>>,>>9.99") + cr.

		
		/**
			Формируем распоряжение 
		*/
		PUT UNFORMATTED SPACE(50) "В Департамент 3" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' docDate FORMAT "99/99/9999" SKIP(4)
		SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3).
		
		/** 
			Сумма прописью 
		*/
		Run x-amtstr.p(totalPersAmount, loan.currency, true, true, 
				output totalPersAmountStr[1], 
				output totalPersAmountStr[2]).
	  totalPersAmountStr[1] = totalPersAmountStr[1] + ' ' + totalPersAmountStr[2].
		Substr(totalPersAmountStr[1],1,1) = Caps(Substr(totalPersAmountStr[1],1,1)).
		
		/** 
			Форматирование первого параграфа 
		*/
/*message "payOutflag="   payOutflag .
message "totalNalog="   totalNalog .*/

		/* --- Случай когда НЕ конец срока вклада и НЕТ налога - просто переводим %%  ----------  */		
		IF  payOutFlag EQ FALSE AND (totalNalog <= 0) THEN
		DO:		
			tmpStr[1] = 'В соответствии с Положением Банка России №39-П от 26.06.1998г. начислить ' +
			'проценты за период с ' + STRING(periodBegin, "99/99/9999") + ' по ' + STRING(periodEnd, "99/99/9999") + 
			' вкл. по Договору банковского вклада №' + loan.cont-code + ' от ' + GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", false) + 
			' (вкладчик - ' + GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false) + ') по счету №' +
			dpsAcct + ' в размере ' + STRING(ROUND(totalPersAmount,2)) + ' (' + totalPersAmountStr[1] + ') ' +
			'и перевести начисленные проценты на счет №' + GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false) + ' (' +
			GetAcctClientName_UAL(
					GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false), false) + ').' .


		END.

			
		/* --- Случай когда  конец срока вклада или есть налог - начислить %%  ----------  */		
		IF    payOutFlag OR (totalNalog > 0) THEN
		DO:		
			tmpStr[1] = 'В соответствии с Положением Банка России №39-П от 26.06.1998г. начислить ' +
			'проценты за период с ' + STRING(periodBegin, "99/99/9999") + ' по ' + STRING(periodEnd, "99/99/9999") + 
			' вкл. по Договору банковского вклада №' + loan.cont-code + ' от ' + GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", false) + 
			' (вкладчик - ' + GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false) + ') по счету №' +
			dpsAcct + ' в размере ' + STRING(ROUND(totalPersAmount,2)) + ' (' + totalPersAmountStr[1] + ').' .	.


		/*	IF  totalNalog > 0 THEN
				tmpStr[1] = tmpStr[1] + ' '.
			ELSE
				tmpStr[1] = tmpStr[1] + ' и перевести начисленные проценты на счет №' + 
					GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false) + ' (' +
					GetAcctClientName_UAL(
						GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false), false) + ').' .
			         	*/
	
		END.



	


		
		/**			Перенос по словам		*/

		{wordwrap.i &s=tmpStr &n=10 &l=80}
		

		/** 			Вывод только заполненных строк после переноса по словам 		*/

		tmpStr[1] = '   ' + tmpStr[1].
		DO i = 1 TO 10 :
			IF tmpStr[i] <> "" THEN
				PUT UNFORMATTED tmpStr[i] SKIP.
		END.
		
		/**
			Если возврат вклада. Форматирование второго параграфа
		*/
		IF (payOutFlag AND (totalNalog LE 0)) THEN DO:


				Run x-amtstr.p(amount, loan.currency, true, true, 
						output totalAmountStr[1], 
						output totalAmountStr[2]).
			  totalAmountStr[1] = totalAmountStr[1] + ' ' + totalAmountStr[2].
				Substr(totalAmountStr[1],1,1) = Caps(Substr(totalAmountStr[1],1,1)).


			tmpStr[1] = 'В связи с окончанием срока действия Договора банковского вклада ' + loan.cont-code + 
			' от ' + GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", false) + 'г. осуществить возврат вклада
			в сумме '  + STRING(ROUND(Amount,2)) + ' (' + totalAmountStr[1] + ') и начисленных процентов в размере ' + STRING(ROUND(totalPersAmount,2)) + ' (' + totalPersAmountStr[1] + ') на счет №' +
			GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false) + ' (' +
			GetAcctClientName_UAL(
					GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false), false) + ').'.

			/*
				Перенос по словам 
			*/
			{wordwrap.i &s=tmpStr &n=10 &l=80}
		
			/**
				Вывод заполненных строк после переноса по словам 
			*/
			tmpStr[1] = '   ' + tmpStr[1].
			DO i = 1 TO 10 :
				IF tmpStr[i] <> "" THEN
					PUT UNFORMATTED tmpStr[i] SKIP.
			END.
			
		END.


		/**
			Вывод таблицы расчета суммы процентов 
		*/
		PUT UNFORMATTED "" SKIP(3) persTable SKIP(3).
		
		/** 
			Если превышение ставки рефинансирования 
		*/

		IF (totalNalog > 0) THEN DO:
			totalNalog = ROUND(totalNalog,0).
			

			IF (loan.currency <> "") THEN DO:
				FIND LAST instr-rate WHERE 
						instr-code = loan.currency
						AND
						rate-type = "Учетный"
						AND
						instr-rate.since LE docDate /* periodEnd */
						NO-LOCK NO-ERROR.
				IF AVAIL instr-rate THEN DO:
					Run x-amtstr.p(totalNalog / instr-rate.rate-instr, loan.currency, true, true, 
							output totalNalogStr[1], 
							output totalNalogStr[2]).
				  totalNalogStr[1] = totalNalogStr[1] + ' ' + totalNalogStr[2].
					Substr(totalNalogStr[1],1,1) = Caps(Substr(totalNalogStr[1],1,1)).
					tmpStr[1] = "Cумму налога с дохода от процентов по вкладу в размере " +
							STRING(ROUND(totalNalog / instr-rate.rate-instr,2)) + " (" + totalNalogStr[1] + ") отправить в налоговую инспекцию ".
				END.
			END.
			ELSE DO:
					Run x-amtstr.p(totalNalog, "", true, true, 
							output totalNalogStr[1], 
							output totalNalogStr[2]).
				  totalNalogStr[1] = totalNalogStr[1] + ' ' + totalNalogStr[2].
					Substr(totalNalogStr[1],1,1) = Caps(Substr(totalNalogStr[1],1,1)).
					
					tmpStr[1] = "Cумму налога с дохода от процентов по вкладу в размере " +
							STRING(ROUND(totalNalog,2)) + " (" + totalNalogStr[1] + ") отправить в налоговую инспекцию ".
			END.

			IF (payOutFlag) THEN DO:
				IF (loan.currency <> "") THEN DO:
					FIND LAST instr-rate WHERE 
						instr-code = loan.currency
						AND
						rate-type = "Учетный"
						AND
						instr-rate.since LE docDate /* periodEnd */
						NO-LOCK NO-ERROR.
					IF AVAIL instr-rate THEN 
						tmpDec1 = totalPersAmount - ROUND(totalNalog / instr-rate.rate-instr,2).
				END.
				ELSE
					tmpDec1 = totalPersAmount - totalNalog.
				
				/*сумма начисленных процентов  в текстовом виде  */
				Run x-amtstr.p(tmpDec1, loan.currency, true, true, 
						output totalNalogStr[1], 
						output totalNalogStr[2]).
			  totalNalogStr[1] = totalNalogStr[1] + ' ' + totalNalogStr[2].
				Substr(totalNalogStr[1],1,1) = Caps(Substr(totalNalogStr[1],1,1)).
				
				/*остаток на счете вклада  в текстовом виде  */				
				Run x-amtstr.p(amount, loan.currency, true, true, 
						output totalAmountStr[1], 
						output totalAmountStr[2]).
			  totalAmountStr[1] = totalAmountStr[1] + ' ' + totalAmountStr[2].
				Substr(totalAmountStr[1],1,1) = Caps(Substr(totalAmountStr[1],1,1)).

				tmpStr[1] = tmpStr[1] + "." + cr + "   В связи с окончанием срока действия Договора банковского вклада " +
					loan.cont-code + " от " + STRING(loan.open-date, "99/99/9999") + " г. осуществить возврат вклада 
					в сумме " + STRING(ROUND(amount,2)) + " (" + totalAmountStr[1] + ")	и " +
					"причитающихся процентов в размере " + STRING(ROUND(tmpDec1,2)) + " (" + totalNalogStr[1] + ") на счет №" +
					GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false) + ' (' +
					GetAcctClientName_UAL(
							GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false), false) + ').'.
			END. /* payOutFlag */


			ELSE DO:


				IF (loan.currency <> "") THEN DO:
					FIND LAST instr-rate WHERE 
						instr-code = loan.currency
						AND
						rate-type = "Учетный"
						AND
						instr-rate.since LE docDate /* periodEnd */
						NO-LOCK NO-ERROR.
					IF AVAIL instr-rate THEN 
						tmpDec1 = totalPersAmount - ROUND(totalNalog / instr-rate.rate-instr,2).
				END.
				ELSE
					tmpDec1 = totalPersAmount - totalNalog.

				Run x-amtstr.p(tmpDec1, loan.currency, true, true, 
						output totalNalogStr[1], 
						output totalNalogStr[2]).
			  totalNalogStr[1] = totalNalogStr[1] + ' ' + totalNalogStr[2].
				Substr(totalNalogStr[1],1,1) = Caps(Substr(totalNalogStr[1],1,1)).
			
				tmpStr[1] = tmpStr[1] + "и перевести начисленные проценты в размере " + STRING(ROUND(tmpDec1,2)) +
				" (" + totalNalogStr[1] + ")" + " на счет №" +
				GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false) + ' (' +
				GetAcctClientName_UAL(
					GetLoanAcct_ULL(loan.contract, loan.cont-code, PAYOUT_ACCT_NAME, periodEnd, false), false) + ').'.
			END.
			
			/** 
				Перенос по словам
			*/
			{wordwrap.i &s=tmpStr &n=10 &l=80}
			
			/** 
				Вывод заполненных строк после переноса по словам 
			*/
			tmpStr[1] = '   ' + tmpStr[1].
			DO i = 1 TO 10 :
				IF tmpStr[i] <> "" THEN
					PUT UNFORMATTED tmpStr[i] SKIP.
			END.

			Run x-amtstr.p(totalNalog, "", true, true, 
					output totalNalogStr[1], 
					output totalNalogStr[2]).
		  totalNalogStr[1] = totalNalogStr[1] + ' ' + totalNalogStr[2].
			Substr(totalNalogStr[1],1,1) = Caps(Substr(totalNalogStr[1],1,1)).

		END.
		
			/**
				Вывод подписи 
			*/
			PUT UNFORMATTED "" SKIP(3)ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(2).
			IF pirbosdps <> "," THEN 
				PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(2).

			if fioSpecDPS <> "" then
				PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
		
		/*******************************************************************************************************
		 *******************************************************************************************************
		 *******************************************************************************************************
			Второе распоряжение 
		*/
		IF (totalNalog > 0) THEN DO:
		
			PUT UNFORMATTED CHR(12) SKIP
				SPACE(50) 'Утверждаю' SKIP(1)
				SPACE(50) 'Начальник Д2' SKIP(1)
				SPACE(50) '____________________' SKIP(2)
				SPACE(50) 'В Департамент 3' SKIP(1)
				SPACE(50) cBankName SKIP(2)
				SPACE(50) docDate FORMAT "99/99/9999" SKIP(2)
				SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(2).
			
			tmpStr[1] = 'Направить в налоговую инспекцию сумму налога в размере ' + STRING(totalNalog) + ' (' +
				totalNalogStr[1] + ') с дохода по процентам по банковскому вкладу за период с ' + STRING(periodBegin, "99/99/9999") +
				' по ' + STRING(periodEnd, "99/99/9999") + ' включительно, размещенному вкладчиком - ' + 
				GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false) + ' по Договору банковского вклада №' +
				loan.cont-code + ' от  ' + STRING(loan.open-date, "99/99/9999") + 'г.'.
			
			/** 
				Перенос по словам
			*/
			{wordwrap.i &s=tmpStr &n=10 &l=80}
			
			/** 
				Вывод заполненных строк после переноса по словам 
			*/
			tmpStr[1] = '   ' + tmpStr[1].
			DO i = 1 TO 10 :
				IF tmpStr[i] <> "" THEN
					PUT UNFORMATTED tmpStr[i] SKIP.
			END.
			
			PUT UNFORMATTED "" SKIP(3) SPACE(25) 'РАСЧЕТ НАЛОГА С ДОХОДА ОТ' SKIP
											           SPACE(28)    'ПРОЦЕНТОВ ПО ВКЛАДУ' SKIP(1)
			nalogCalcStr SKIP(1).
			
			PUT UNFORMATTED
			'К перечислению: ' STRING(ROUND(totalNalog,2)) ' руб.'SKIP(3).

			/**
				Вывод подписи 
			*/
			PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP(2).
			IF pirbosdps <> "," THEN 
				PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(2).
			
			if fioSpecDPS <> "" then
				PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
			

		END.
		
		/** 
			Отображение печатной формы документа 
		*/
		{preview.i}

END.
