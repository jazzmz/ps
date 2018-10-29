/*
** Распоряжение о ежеквартальном начислении процентов по счету 40703.
** Запускается из броузера л.счетов.
** Бурягин Е.П., 31.05.2006 10:11
*/

{tmprecid.def}        /** Используем информацию из броузера */

DEF INPUT PARAM iParam AS CHAR.

/** Дата распоряжения */
DEF VAR docDate AS DATE LABEL "Дата распоряжения"  NO-UNDO.
/** Период расчета процентов */
DEF VAR periodBegin AS DATE NO-UNDO.
DEF VAR periodEnd AS DATE NO-UNDO.
/** Даты подпериодов */
DEF VAR subperBegin AS DATE NO-UNDO.
DEF VAR subperEnd AS DATE NO-UNDO.
DEF VAR subperDays AS INTEGER NO-UNDO.
/** Вместо SKIP */
DEF VAR cr AS CHAR  NO-UNDO.
cr = CHR(10).
/** Временная */
DEF VAR tmpStr AS CHAR EXTENT 10  NO-UNDO.
/** Общая сумма процентов */
DEF VAR totalPersAmount AS DECIMAL NO-UNDO.
DEF VAR totalPersAmountStr AS CHAR EXTENT 2 NO-UNDO.
/** Таблица процентов */
DEF VAR persTable AS CHAR NO-UNDO.
/** Комиссия по договору */
DEF VAR comm AS DECIMAL NO-UNDO.
DEF VAR newComm AS DECIMAL NO-UNDO.
/** Остаток по счету */
DEF VAR amount AS DECIMAL NO-UNDO.
DEF VAR newAmount AS DECIMAL NO-UNDO.
/** Сумма процентов за период */
DEF VAR persAmount AS DECIMAL NO-UNDO.
/** Итератор */
DEF VAR iDate AS DATE NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
/** Кол-во дней в глобальном периоде */
DEF VAR globDays AS INTEGER INITIAL 365  NO-UNDO.
/** Номер дополнительного соглашения */
DEF VAR subAgreeNo AS CHAR NO-UNDO.
/** Дата дополнительного соглашения */
DEF VAR subAgreeDate AS DATE  NO-UNDO.


/** Перенос строк */
{wordwrap.def}

/** Глобальные определения */
{globals.i}
{get-bankname.i}
/** Библиотека функций работы с договорами */
{ulib.i}


def var cur_year as integer NO-UNDO.

/** Бос */
DEF VAR pirbosdps AS CHAR NO-UNDO.
pirbosdps = FGetSetting("PIRboss","PIRbosdps","").
DEF VAR pirboskzn AS CHAR NO-UNDO.
pirboskzn = FGetSetting("PIRboss", "PIRbosKazna","").

DEF VAR fioSpecDPS AS CHAR. /** Специалист отдела ДПС */
fioSpecDPS = ENTRY(1, iParam).


/** Поиск выбранного счета */
FOR FIRST tmprecid NO-LOCK,
		FIRST acct WHERE RECID(acct) EQ tmprecid.id NO-LOCK
	:
		
		/** Дата документа */
		{getdate.i}
		ASSIGN docDate = end-date.

		/** Период расчета процентов */
		{getdates.i}
		ASSIGN
			periodBegin = beg-date.	
			IF (periodBegin <= acct.open-date) THEN periodBegin = acct.open-date + 1.
			periodEnd = end-date.
			IF(periodEnd > acct.close-date) THEN periodEnd = acct.close-date.
		
			cur_year = YEAR(periodEnd).
			if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
				globDays = 366.
			else
				globDays = 365.

		/*
		** Начальные установки ******************************
		*/


		/** Шапка таблицы расчета процентов */
		persTable = "                 РАСЧЕТ  ПРОЦЕНТОВ  С  " + STRING(periodBegin,"99/99/9999") 
			+ "  ПО  " + STRING(periodEnd, "99/99/9999") + cr
			+ "┌──────────────────┬─────────────────────┬────────┬────────┬──────────────────┐" + cr
			+ "│ Остаток          │   Расчетный период  │ Кол-во │ Ставка │ Начислено        │" + cr
			+ "│ на счете         ├──────────┬──────────┤ дней   │        │ процентов        │" + cr
			+ "│                  │     С    │    ПО    │        │        │                  │" + cr
			+ "├──────────────────┼──────────┼──────────┼────────┼────────┼──────────────────┤" + cr.
		
		
		/** Остаток вклада */
		amount = ABS(GetAcctPosValue_UAL(acct.acct, acct.currency, periodBegin - 1, false)).

		/** Процентная ставка */
		comm = GetCommRate_ULL("K32TAR", acct.currency, amount, acct.acct, 
											0, periodBegin, FALSE).
											
		/** Подпериод равен всему периоду */
		ASSIGN 
			subperBegin = periodBegin
			subperEnd = periodEnd.


		
		/*
		** Расчет процентов *********************************
		*/
	
		/** 
			Основной цикл формирования таблицы начисления процентов.
			Пробегаем по каждому дню, и определяем, изменилась ли процентная ставка или остаток.
			Если изменения были в указанный день, то разбиваем общий период на подпериоды.
		*/
		DO iDate = periodBegin TO periodEnd - 1 :
			newAmount = ABS(GetAcctPosValue_UAL(acct.acct, acct.currency, iDate, false)).
			newComm = GetCommRate_ULL("K32TAR", acct.currency, newAmount, acct.acct, 
											0, iDate + 1, FALSE).
			IF (newAmount <> amount) OR (newComm <> comm) OR (DAY(iDate + 1) = 1) THEN DO:
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
			"│" + cr.
		totalPersAmount = totalPersAmount + persAmount.
		
		/** 
			Итоги таблицы 
		*/
		persTable = persTable + "└──────────────────┴──────────┴──────────┴────────┴────────┴──────────────────┘" + cr
			 	                  + "                                        Начислено процентов:" + STRING(totalPersAmount,">>>,>>>,>>>,>>9.99") + cr.

		/** Реквизиты доп.соглашения */
		subAgreeNo = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "PIRSubAgree", ",").
		subAgreeDate = DATE(ENTRY(1,subAgreeNo)).
		subAgreeNo = ENTRY(2,subAgreeNo).

		
		/*
		** Вывод на результатов на экран ********************
		*/

		{setdest.i}
		
				/** Формируем распоряжение */
		
		PUT UNFORMATTED SPACE(50) "В Департамент 3" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) 'Дата: ' docDate FORMAT "99/99/9999" SKIP(4)
		SPACE(25) 'Р А С П О Р Я Ж Е Н И Е' SKIP(3).
	
		Run x-amtstr.p(totalPersAmount, acct.currency, true, true, 
				output totalPersAmountStr[1], 
				output totalPersAmountStr[2]).
	  totalPersAmountStr[1] = totalPersAmountStr[1] + ' ' + totalPersAmountStr[2].
		Substr(totalPersAmountStr[1],1,1) = Caps(Substr(totalPersAmountStr[1],1,1)).
		
		tmpStr[1] = 'В соответствии с Положением Банка России №39-П от 26.06.98г. начислить проценты за период с ' + 
		STRING(periodBegin, "99/99/9999") + ' по ' + STRING(periodEnd, "99/99/9999") + 
		' вкл. по дополнительному соглашению ' + subAgreeNo + " от " + STRING(subAgreeDate, "99/99/9999") + 'г. к договору банковского счета от ' + 
		STRING(acct.open-date, "99/99/9999") + 'г. (' +
		TRIM(GetAcctClientName_UAL(acct.acct, false)) + 
		') по счету №' + acct.acct + ' в размере ' + STRING(ROUND(totalPersAmount,2)) + ' (' + totalPersAmountStr[1] +
		') и перевести начисленные проценты на счет ' + acct.acct + ' (' +
		TRIM(GetAcctClientName_UAL(acct.acct, false)) + ')' + cr.
				
		{wordwrap.i &s=tmpStr &n=10 &l=80}
		
		tmpStr[1] = '   ' + tmpStr[1].
		DO i = 1 TO 10 :
			IF tmpStr[i] <> "" THEN
				PUT UNFORMATTED tmpStr[i] SKIP.
		END.
		
		
		/** Вывод таблицы расчета процентов */
		PUT UNFORMATTED "" SKIP(3) persTable SKIP(4).
	
		
		/** Подпись */
		PUT UNFORMATTED ENTRY(1,pirbosdps) SPACE(80 - LENGTH(ENTRY(1,pirbosdps))) ENTRY(2,pirbosdps) SKIP(1).
				
		PUT UNFORMATTED ENTRY(1,pirboskzn) SPACE(80 - LENGTH(ENTRY(1,pirboskzn))) ENTRY(2,pirboskzn) SKIP.
		
		if fioSpecDPS <> "" then
		PUT UNFORMATTED 'Ведущий специалист Депозитного отдела: ' SPACE(80 - LENGTH('Ведущий специалист Депозитного отдела: ')) fioSpecDPS SKIP.
		
		
		{preview.i}
		
END.
