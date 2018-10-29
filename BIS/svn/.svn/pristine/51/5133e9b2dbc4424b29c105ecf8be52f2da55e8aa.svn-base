{pirsavelog.p}

/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

		<Что_делает_процедура> : Формирует отчет "КРЕДИТНЫЙ ПОРТФЕЛЬ В РАЗРЕЗЕ ВАЛЮТ.
		
		<Автор> : Бурягин Е.П., <Время_создания [F7]> : 18.06.2007 9:33
		
		<Как_запускается> : Запускается из броузера кредитных договоров
		<Параметры запуска>
		<Как_работает> : Обрабатывает выбранные в броузере договора. Запрашивает у пользователя 
		                 дату, по состоянию на которую беруться значения параметров договоров. На момент 
		                 запуска процедуры, договора должны быть расчитаны на дату формирования отчета.
		                 Сначала процедура для всех выбранных в броузере договоров заполняет некую 
		                 временную таблицу (ВТ). Эта ВТ позволит выполнять
		                 сотрировку и группировку данных при формировании итогового отчета.
		<Особенности_реализации>
		
		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

*/

/** Глобальные определения */
{globals.i}

/** Используем информацию из броузера через TEMP-TABLE tmprecid */
{tmprecid.def}

/** Мои процеДурки */
{ulib.i}

/** Будем переносить по словам */
{wordwrap.def}

/** ОПРЕДЕЛЕНИЕ ПЕРЕМЕННЫХ И ВСЯКОЙ ВСЯЧИНЫ */

/** Определение структуры временной таблицы, в которую будем сохранять данные для последующего их вывода. */
DEF TEMP-TABLE ttReportLine NO-UNDO
	FIELD id AS INTEGER /* идентификатор */
	FIELD part AS INTEGER /* раздел отчета */
	FIELD subPart AS CHAR /* подраздел: просрочка или месяц.год даты возврата */
	FIELD clientCat AS CHAR /* категория клиента */
	FIELD clientID AS INTEGER /* идентификатор клиента */
	FIELD clientName AS CHAR EXTENT 4 /* наименование клиента */
	FIELD loanNumber AS CHAR /* номер договора */
	FIELD loanCurrency AS CHAR /* валюта договора */
	FIELD loanOpenDate AS DATE /* дата открытия договора */
	FIELD loanEndDate AS DATE /* дата окончания договора */
	FIELD loanAmount AS DECIMAL /* остаток задолженности */
	FIELD rate AS DECIMAL /* процентная ставка по сумме */
	FIELD rateOutOrder AS CHAR /* порядок выплаты процентов */
	FIELD guarantyInfo AS CHAR EXTENT 4 /* информация о гараниях */
	INDEX id IS UNIQUE id
	INDEX main loanCurrency clientCat part subPart.

/** итератор */
DEF VAR i AS INTEGER NO-UNDO.

DEF VAR tmpStr AS CHAR NO-UNDO.

DEF VAR repDate AS DATE NO-UNDO.

DEF VAR total AS DECIMAL NO-UNDO.
DEF VAR partTotal AS DECIMAL NO-UNDO.
DEF VAR subPartTotal AS DECIMAL NO-UNDO.

/** наименование разделов */
DEF VAR partName AS CHAR EXTENT 3 INITIAL ["КРЕДИТЫ ЮРИДИЧЕСКИМ ЛИЦАМ", "КРЕДИТЫ ФИЗИЧЕСКИХ ЛИЦ", "(не определен)"]	 NO-UNDO.


/** РЕАЛИЗАЦИЯ */

/** Запрашиваем у пользователя дату отчета */
{getdate.i}
repDate = end-date.

/** заполнение временной таблицы */
i = 1.
FOR EACH tmprecid NO-LOCK,
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    LAST loan-cond WHERE loan-cond.contract = loan.contract 
                         AND 
                         loan-cond.cont-code = loan.cont-code 
                         AND
                         loan-cond.since LE repDate
                         NO-LOCK                         
  :
  	CREATE ttReportLine.
  	ttReportLine.id = i. i = i + 1.
  	/** юрики в первый раздел, физики - во второй, все остальные - в третий */
  	IF loan.cust-cat = "Ю" THEN ttReportLine.part = 1.
  	ELSE IF loan.cust-cat = "Ч" THEN ttReportLine.part = 2.
  	ELSE ttReportLine.part = 3.
  	
  	
  	ttReportLine.clientCat = loan.cust-cat.
  	ttReportLine.clientID = loan.cust-id.
  	tmpStr = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name,open_date,end_date", false).
  	ttReportLine.clientName[1] = ENTRY(1, tmpStr).
  	ttReportLine.loanNumber = loan.cont-code.
  	ttReportLine.loanOpenDate = DATE(ENTRY(2, tmpStr)).
  	ttReportLine.loanEndDate = DATE(ENTRY(3, tmpStr)).
  	ttReportLine.loanAmount = ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, repDate, false)) 
  				+ ABS(GetLoanParamValue_ULL(loan.contract, loan.cont-code, 7, repDate, false)).
  	ttReportLine.loanCurrency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
  	ttReportLine.rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", repDate, false, tmpStr).

  	/** подраздел может имееть два типа значения: просрочено - если дата окончания дог. меньше даты отчета,
  	    месяц и год срока окончания договора - если договор оканчивается в будущем */
  	IF repDate > ttReportLine.loanEndDate THEN 
  		ttReportLine.subPart = " просрочка".
  	ELSE
  		ttReportLine.subPart = STRING(YEAR(ttReportLine.loanEndDate)) + "." + STRING(MONTH(ttReportLine.loanEndDate), "99").
  	
  	ttReportLine.rateOutOrder = loan-cond.int-period.
  	
  	/** Информация о поручительстве */
		FOR EACH term-obl WHERE
			term-obl.contract = loan.contract
			AND
			term-obl.cont-code = loan.cont-code
			AND
			term-obl.idnt = 5 
			NO-LOCK
			:
			tmpStr = loan.contract + "," + loan.cont-code + "," + STRING(term-obl.idnt) + "," + 
				STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
			
			/** 
			 * Формат значения в элементе массива backLoans: 
			 * <Название вида обеспечения>,<Номер дог. обеспечения> 
			 */
			
			FIND FIRST code WHERE code.class = "ВидДогОб" 
				AND code.code = GetXAttrValueEx("term-obl",tmpStr,"ВидДогОб","") NO-LOCK NO-ERROR.
			IF AVAIL code THEN DO:
						ttReportLine.guarantyInfo[1] = code.name + ",".
			END.
			
			ttReportLine.guarantyInfo[1] = ttReportLine.guarantyInfo[1] + "№" + GetXAttrValueEx("term-obl",tmpStr,"НомДогОб","") + " от " 
				+ GetXAttrValueEx("term-obl",tmpStr,"ДатаПост","") + " (".
			
			ttReportLine.guarantyInfo[1] = ttReportLine.guarantyInfo[1] + STRING(term-obl.amt) + ")".
		END.
  	
  	
END.


/** формирование отчета */
/** ОПРЕДЕЛЕНИЕ ПОТОКА ВЫВОДА */
{setdest.i}

FOR EACH ttReportLine NO-LOCK BREAK BY ttReportLine.loanCurrency 
																		BY ttReportLine.part
																		BY ttReportLine.subPart
	:
		IF FIRST-OF(ttReportLine.loanCurrency) THEN 
			PUT UNFORMATTED "" SKIP(1) "КРЕДИТНЫЙ ПОРТФЕЛЬ В (" ttReportLine.loanCurrency ")" SKIP
			                "(по состоянию на " STRING(repDate, "99.99.9999") ")" SKIP(1)
			                "┌────────────────────┬──────────────────────────────┬──────────────────┬──────────┬──────┬─────┬────────────────────────────────────────┐" SKIP
			                "│Заемщик             │№ и дата договора             │Остаток           │Дата      │%     │Поряд│Обеспечение                             │" SKIP
			                "│                    │                              │задолженности     │возврата  │ставка│выпл │                                        │" SKIP
			                "│                    │                              │по кредиту        │кредита   │      │проц │                                        │" SKIP
			                "├────────────────────┴──────────────────────────────┴──────────────────┴──────────┴──────┴─────┴────────────────────────────────────────┤" SKIP.
			
		
		IF FIRST-OF(ttReportLine.subPart) THEN DO:
			IF FIRST-OF(ttReportLine.part) THEN
				PUT UNFORMATTED 
					"│" STRING(STRING(ttReportLine.part) + ". " + partName[ttReportLine.part],"x(135)") "│" SKIP
					"├────────────────────┬──────────────────────────────┬──────────────────┬──────────┬──────┬─────┬────────────────────────────────────────┤" SKIP.
			ELSE		
				PUT UNFORMATTED 
					"├────────────────────┼──────────────────────────────┼──────────────────┼──────────┬──────┬─────┬────────────────────────────────────────┐" SKIP.
		END.

		/** Переносим по словам */
		{wordwrap.i &s=ttReportLine.clientName &l=20 &n=4}
		{wordwrap.i &s=ttReportLine.guarantyInfo &l=40 &n=4}
			
		PUT UNFORMATTED 
			"│" ttReportLine.clientName[1] FORMAT "x(20)" "│"
			STRING(ttReportLine.loanNumber + " от " + STRING(ttReportLine.loanOpenDate,"99.99.9999"), "x(30)") "│"
			STRING(ttReportLine.loanAmount, ">>>,>>>,>>>,>>9.99") "│"
			STRING(ttReportLine.loanEndDate, "99.99.9999") "│"
			STRING(ttReportLine.rate, ">>9.99") "│"
			STRING(ttReportLine.rateOutOrder, "x(5)") "│"
			STRING(ttReportLine.guarantyInfo[1], "x(40)") "│" 
			SKIP.
			
		/** Вывод дополнительных строк, если нужно */
		DO i = 2 TO 4 :
		
			IF ttReportLine.clientName[i] <> "" OR ttReportLine.guarantyInfo[i] <> "" THEN DO:
				
				PUT UNFORMATTED 
					"│" ttReportLine.clientName[i] FORMAT "x(20)" "│"
					SPACE(30) "│"
					SPACE(18) "│"
					SPACE(10) "│"
					SPACE(6)  "│"
					SPACE(5)  "│"
					STRING(ttReportLine.guarantyInfo[i], "x(40)") "│"
					SKIP.
				
			END.
		
		END.

		/** Итоги подраздела */
		subPartTotal = subPartTotal + ttReportLine.loanAmount.
		
		IF LAST-OF(ttReportLine.subPart) THEN DO:
			PUT UNFORMATTED "├────────────────────┼──────────────────────────────┼──────────────────┼──────────┴──────┴─────┴────────────────────────────────────────┘" SKIP
											"│" STRING("Итого: " + TRIM(ttReportLine.subPart), "x(20)") "│"
			                SPACE(30) "│"
			                STRING(subPartTotal, ">>>,>>>,>>>,>>9.99") "│" SKIP.
			subPartTotal = 0.
		END.

		/** Итоги раздела */
		partTotal = partTotal + ttReportLine.loanAmount.

		IF LAST-OF(ttReportLine.part) THEN DO:
			PUT UNFORMATTED "│" STRING("Итого по разделу " + STRING(ttReportLine.part) + ":", "x(20)") "│"
			                SPACE(30) "│"
			                STRING(partTotal, ">>>,>>>,>>>,>>9.99") "│" SKIP.
			IF NOT LAST-OF(ttReportLine.loanCurrency) THEN DO:
				PUT UNFORMATTED "├────────────────────┴──────────────────────────────┴──────────────────┴────────────────────────────────────────────────────────────────┐" SKIP.
			END.
			partTotal = 0.
		END.	

		/** Итоги портфеля */
		total = total + ttReportLine.loanAmount.
		
		IF LAST-OF(ttReportLine.loanCurrency) THEN DO:
			PUT UNFORMATTED "│" STRING("Итого по портфелю в " + STRING(ttReportLine.loanCurrency) + ":", "x(20)") "│"
			                SPACE(30) "│"
			                STRING(total, ">>>,>>>,>>>,>>9.99") "│" SKIP
			                "└────────────────────┴──────────────────────────────┴──────────────────┘" SKIP(1).
			total = 0.
		END.	

END.

/** ВЫВОД В PREVIEW */
{preview.i}