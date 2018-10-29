{pirsavelog.p}

/** 
	Формирование Справки о начислении комиссий по межбанковским платежам.
	Бурягин Е.П., 22.01.2007 10:26
	
	Изменение: Бурягин Е.П. 23.05.2007 15:15 (Локальный код для поиска: БЕП0000001)
						 Добавил параметр iNotClientAcctMask, который указывает процедуре 
						 рассматривать также внутренние счета по дебету, указанные в маске.	
	Изменение: Бурягин Е.П. 8.09.2008 
	                     Изменил логику проверки. Проверяется не только кол-во платежей с количеством комиссий, 
	                     но и, что на мой взгляд, более верно, сумма комиссии с некой расчетной суммой комиссии.				 
*/

{globals.i}
{ulib.i}

DEF INPUT PARAM iParam AS CHAR NO-UNDO.
{get-bankname.i}

/** Запрашиваем дату */
{getdate.i}

DEF VAR iNalogAccountMask  AS CHAR NO-UNDO. /** Маска счетов по налогам */
DEF VAR iRateAccountMask   AS CHAR NO-UNDO. /** Маска счетов по доходам по комиссиям */
DEF VAR iShowLog           AS LOG  NO-UNDO. /** Показывать таблицу для отладки (Да) или готовый отчет (Нет) */
DEF VAR iCommission        AS CHAR NO-UNDO. /* Код комиссии */
DEF VAR iExceptAccountMask AS CHAR NO-UNDO. /** Маска счетов по дебету проводки, которые должны исключатся из проверки */
DEF VAR iNotClientAcctMask AS CHAR NO-UNDO. /** Маска внетренних счетов, которые процедура должна проверять */
DEF VAR iCommOpKind        AS CHAR NO-UNDO. /** Маска кодов транзакций, с помощью которых списывалась проверяемая комиссия */

DEF VAR cAcctCom AS CHAR NO-UNDO.

DEF VAR totalCountOfPayOut      AS INT     INIT 0 NO-UNDO.
DEF VAR totalCountOfNalogPayOut AS INT     INIT 0 NO-UNDO.
DEF VAR totalCountOfRate        AS INT     INIT 0 NO-UNDO.
DEF VAR totalAmountOfRateFact   AS DECIMAL INIT 0 NO-UNDO.
DEF VAR totalAmountOfRateCalc   AS DECIMAL INIT 0 NO-UNDO.

DEF VAR accountTable AS CHAR NO-UNDO. /** Таблица счетов, по которым комиссия не начислина */

/** Определение таблицы для сбора информации */
DEF TEMP-TABLE ttResult NO-UNDO
	FIELD account AS CHAR FORMAT "x(20)" LABEL "Счет"  /* Счет, с которого сделаны платежи */
	FIELD accountName LIKE acct.details /* Наименование счета */
	FIELD countOfPayOut AS INTEGER LABEL "Кол-во плат." /* Кол-во платежей */
	FIELD isNalog AS LOGICAL LABEL "Налог." /* Налоговый платеж */
	FIELD countOfRate AS INTEGER LABEL "Кол-во комис." /* Кол-во взятий комиссии за платеж с данного счета */
	FIELD amountOfRateCalc AS DECIMAL LABEL "Сумма комис.(расчет)" /* Расчетная сумма комиссии */
	FIELD amountOfRateFact AS DECIMAL LABEL "Сумма комис.(фактич)" /* Фактическая сумма комиссии */
	FIELD checkResult AS CHAR LABEL "Проверка" /* статус проверки */
	INDEX idxAcct IS UNIQUE account isNalog ASCENDING
.

/** Выборка в броузер */
DEF QUERY acct-query FOR ttResult.
DEF BROWSE acct-browse QUERY acct-query NO-LOCK 
	DISPLAY ttResult.account ttResult.isNalog ttResult.checkResult ttResult.countOfPayOut 
	        ttResult.countOfRate ttResult.amountOfRateCalc ttResult.amountOfRateFact 
	WITH 16 DOWN WIDTH 68 TITLE "Информация по комиссиям".
	
DEF FRAME logFrame acct-browse WITH CENTERED OVERLAY SIZE 70 BY 60.


DEF VAR i           AS INT      NO-UNDO. /** счетчик */
DEF VAR totalAmount AS DECIMAL  NO-UNDO. /** сумма чего-либо */
DEF VAR oAcct       AS TAcctBal NO-UNDO.

/** Входные параметры */
IF NUM-ENTRIES(iParam, ";") = 7 THEN 
	DO:
		ASSIGN 
			iNalogAccountMask = ENTRY(1, iParam, ";")
			iRateAccountMask = ENTRY(2, iParam, ";")
			iShowLog = CAPS(ENTRY(3, iParam, ";")) = "ДА"
			iCommission = CAPS(ENTRY(4, iParam, ";"))
			iExceptAccountMask = ENTRY(5, iParam, ";")
			iNotClientAcctMask = ENTRY(6, iParam, ";").
			iCommOpKind = ENTRY(7, iParam, ";").			
	END.
ELSE
	DO:
		MESSAGE "Недостаточное кол-во прараметров!" VIEW-AS ALERT-BOX.
		RETURN ERROR.
	END.

/** Выбираем все проводки */
i = 0.
totalAmount = 0.

FOR EACH op-entry WHERE
		op-entry.acct-cr BEGINS "30102"
		AND
		op-entry.op-date EQ end-date
		NO-LOCK,
		FIRST op OF op-entry WHERE op.op-status >= CHR(251) 
		      NO-LOCK,
		FIRST acct WHERE 
					CAN-DO(iExceptAccountMask, op-entry.acct-db) 
					AND 
					acct.acct = op-entry.acct-db 
					AND 
					(	
						CAN-DO("Ч,Ю", acct.cust-cat)
						OR
					  (acct.cust-cat = "В" AND CAN-DO(iNotClientAcctMask, acct.acct))
				) NO-LOCK 
		BREAK BY acct-db BY CAN-DO(iNalogAccountMask, op.ben-acct)  /* "Разбиваем" выборку на группы */
	:
		/** Суммируем кол-во платежей старым дедовским способом */
		i = i + 1.
		
		/** Расчитаем суммы комиссий всех платежей и просуммируем их */
		totalAmount = totalAmount + GetSumRate_ULL(iCommission, "", op-entry.amt-rub, acct.acct, 0, end-date, false).
		
		/** Если это последний счет в группе */
		IF LAST-OF(CAN-DO(iNalogAccountMask, op.ben-acct)) THEN 
			DO:
					CREATE ttResult.
					ASSIGN 
						ttResult.account = op-entry.acct-db
						ttResult.accountName = acct.details
						ttResult.countOfPayOut = i
						ttResult.isNalog = (IF CAN-DO(iNalogAccountMask, op.ben-acct) THEN YES ELSE NO)
						ttResult.amountOfRateCalc = totalAmount.
						ttResult.countOfRate = 0
						.
					
				i = 0.
				totalAmount = 0.
				
			END.
END.


/** Найдем кол-во платежей по комиссиям по каждому счету */
FOR EACH ttResult WHERE NOT ttResult.isNalog :
	/*Заявка #763 */
	cAcctCom = ttResult.account.
	if can-do("40821*",cAcctCom) then do:
	MESSAGE cAcctCom VIEW-AS ALERT-BOX.

	oAcct = NEW TAcctBal(ttResult.account).
    	  cAcctCom = oAcct:getAlias40821(op-entry.op-date).
        DELETE OBJECT oAcct.
	end.
	/*Конец #763 */

	i = 0.
	totalAmount = 0.
	
	FOR EACH op-entry WHERE 
		op-entry.op-date EQ end-date
		AND
		op-entry.acct-db = cAcctCom
		AND
		CAN-DO(iRateAccountMask, op-entry.acct-cr)
		NO-LOCK,
		FIRST op OF op-entry WHERE CAN-DO(iCommOpKind, op.op-kind) NO-LOCk 
	:
		/** Поиск комиссии */
		FIND LAST comm-rate WHERE 
			comm-rate.commission = iCommission 
			AND
			comm-rate.rate-fixed /** значение "=" */ 
			AND 
			(
				comm-rate.acct = cAcctCom
				OR
				comm-rate.acct = "0"
			)
			AND 
			comm-rate.since LE end-date
			/*USE-INDEX comm-rate*/
			NO-LOCK NO-ERROR.
		IF AVAIL comm-rate THEN
			i = i + ROUND(op-entry.amt-rub / comm-rate.rate-comm,0).
		ELSE
			i = i + 1.
		
		totalAmount = totalAmount + op-entry.amt-rub.
		
	END.
	
	ttResult.countOfRate = i.
	ttResult.amountOfRateFact = totalAmount.

	/** Если не налоговые платежи и есть разница либо в кол-ве, либо в суммах комиссий (фактической и расчетной) */
	if not ttResult.isNalog 
	   and 
	   ttResult.countOfRate <> ttResult.countOfPayOut
	   and
	   ttResult.amountOfRateCalc <> amountOfRateFact 
	then 
		do:
			/** Сравнение кол-ва платежей с кол-вом комиссий */
			if ttResult.countOfRate < ttResult.countOfPayOut then 
				ttResult.checkResult = "< кол.".
			else
				ttResult.checkResult = "> кол.".
			
			/** Сравнение суммы расчитанной комиссии с суммой фактической комиссии */
			if ttResult.amountOfRateFact < ttResult.amountOfRateCalc then 
				ttResult.checkResult = ttResult.checkResult + "< сум.".
			else
				ttResult.checkResult = ttResult.checkResult + "> сум.".
			DISPLAY ttResult.checkResult WITH BROWSE acct-browse.
		end.
	
END.

/** Вывод */
IF iShowLog THEN 
	DO:
		OPEN QUERY acct-query FOR EACH ttResult.
		ENABLE acct-browse WITH FRAME logFrame.
		/*APPLY "VALUE-CHANGED" TO BROWSE acct-browse.*/
		WAIT-FOR WINDOW-CLOSE OF CURRENT-WINDOW.
	END.
ELSE
	DO:
		/** Сбор информации */
		FOR EACH ttResult NO-LOCK:
			totalCountOfPayOut = totalCountOfPayOut + ttResult.countOfPayOut.
			if ttResult.isNalog then
				totalCountOfNalogPayOut = totalCountOfNalogPayOut + ttResult.countOfPayOut.
			else
				totalAmountOfRateCalc = totalAmountOfRateCalc + ttResult.amountOfRateCalc.
			
			totalCountOfRate = totalCountOfRate + ttResult.countOfRate.
			totalAmountOfRateFact = totalAmountOfRateFact + ttResult.amountOfRateFact.

			if not ttResult.isNalog 
			   and 
			   ttResult.countOfRate <> ttResult.countOfPayOut 
			   and
			   ttResult.amountOfRateCalc <> ttResult.amountOfRateFact
			then
				do:
					accountTable = accountTable + "|" + ttResult.account + "|" + STRING(ttResult.accountName,"x(46)") + "|" + chr(10).
				end.
		END.
		/** Вывод информации в PREVIEW */
		{setdest.i}
		PUT UNFORMATTED 
			cBankName SKIP(2)
			SPACE(40) "Справка" SKIP
			SPACE(20) "о начислении комиссий по межбанковским платежам" SKIP
			SPACE(37) "за " end-date FORMAT "99/99/9999" SKIP(3)
			"Количество отправленных платежей: " totalCountOfPayOut SKIP
			"из них" SKIP
			"количество отправленных налоговых платежей: " totalCountOfNalogPayOut SKIP(2)
			"Всего платежей, на которые начисляется комиссия: " (totalCountOfPayOut - totalCountOfNalogPayOut) SKIP
			"  расчетная сумма комиссии: " STRING(totalAmountOfRateCalc, ">>>,>>>,>>>,>>9.99") SKIP(2)
			"Количество начисленных комиссий: " totalCountOfRate " (может быть не равно кол-ву платежей, тогда см. суммы)" SKIP
			"  сумма: " STRING(totalAmountOfRateFact, ">>>,>>>,>>>,>>9.99") SKIP(2).
		
		/** Вывод таблицы счетов, если нужно... */
		IF accountTable <> "" then	
			DO:
				PUT UNFORMATTED
					"|№ счета             |Наименование                                  |" SKIP
					"---------------------------------------------------------------------" SKIP
					accountTable SKIP.
			END.
			
		{preview.i}
	END.