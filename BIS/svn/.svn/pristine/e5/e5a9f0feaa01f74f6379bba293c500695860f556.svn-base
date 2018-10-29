/*
		Udgin Account Library (UAL).
		
		Библиотека функций для работы с счетами.
		
		Бурягин Е.П., 10.01.2006 12:24
		
		Описания функций выполнены в нотации языка Pascal (хоть здесь можно понятно излагать мысли :-(  )
		
		Все функции классифицированны по группам.
			1) Получение информации по счету(ам)
*/

/* 

		1 класс функций. 
		Предназначены для получения информации о счете
		
		Список:
			
			GetAcctPosValue_UAL(Acct_Number:CHAR, Currency_OUT:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	Возвращает значение остатка по счету на дату по акцептированным документам.
			
			GetAcctClientName_UAL(Acct_Number:CHAR, ShowErrorMsg:LOGICAL): CHAR
			====================================================================
			| Возвращает название клиента, если счет клиентский.
*/

FUNCTION GetAcctPosValue_UAL RETURNS DECIMAL (
		INPUT inAcct AS CHAR,
		INPUT inCur  AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE VAR acctCur AS CHAR.
		DEFINE VAR acctPos AS DECIMAL.
		DEFINE VAR lstSince AS DATE.
		
		DEFINE BUFFER bfrAcct FOR acct.
		DEFINE BUFFER bfrAcctPos FOR acct-pos.
		DEFINE BUFFER bfrAcctCur FOR acct-cur.
		DEFINE BUFFER bfrOpEntry FOR op-entry.
		
		/* Определим код валюты */
		/* acctCur = SUBSTRING(inAcct, 6, 3). */
		IF inCur = "" THEN inCur = "810".
		acctCur = inCur.
		
		/* Проверка: существует ли счет? */
		FIND FIRST bfrAcct WHERE
			bfrAcct.acct = inAcct
			NO-LOCK NO-ERROR.
		IF AVAIL bfrAcct THEN
			DO:
				/* Инициализируем */
				lstSince = bfrAcct.open-DATE.

				/* Найдем остаток по счету на последний закрытый день */
				IF acctCur = "810" THEN
					DO:
						FIND LAST bfrAcctPos WHERE
							bfrAcctPos.acct = inAcct
							AND
							bfrAcctPos.since LE inDate
							NO-LOCK NO-ERROR.
						IF AVAIL bfrAcctPos THEN
							ASSIGN 
								acctPos = bfrAcctPos.balance
								lstSince = bfrAcctPos.since + 1.
					END.
				ELSE
					DO:
						FIND LAST bfrAcctCur WHERE
							bfrAcctCur.acct = inAcct
							AND
							bfrAcctCur.since LE inDate
							NO-LOCK NO-ERROR.
						IF AVAIL bfrAcctCur THEN
							ASSIGN 
								acctPos = bfrAcctCur.balance
								lstSince = bfrAcctCur.since + 1.
					END.
				/*
				outErrorStr = "Найденный остаток по счету " + inAcct + " в валюте " + acctCur + " на дату " 
					+ STRING(inDate,"99/99/9999") + " равен " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).
				*/
				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
					bfrOpEntry.acct-db = inAcct
					:
							IF bfrAcct.side = "П" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
				END.
				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
				  bfrOpEntry.acct-cr = inAcct
					:
							IF bfrAcct.side = "П" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
				END.
			END.
		ELSE
			outErrorStr = "Cчет " + inAcct + " не найден!" + CHR(10).  
		
		/* Выдаем ошибки на экран */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uacctlib.i:GetAcctPosValue_UAL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = acctPos.
		RETURN outValue.

		/* Конец функции GetAcctPosValue_UAL */		
END FUNCTION.

FUNCTION GetAcctClientName_UAL RETURNS CHAR (
		INPUT inAcct AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.

		DEF BUFFER bfrAcct FOR acct.
		DEF BUFFER bfrCustCorp FOR cust-corp.
		DEF BUFFER bfrPerson FOR person.
		
		/* Найдем счет */
		FIND FIRST bfrAcct WHERE	
			bfrAcct.acct = inAcct
			NO-LOCK NO-ERROR.
		IF AVAIL bfrAcct THEN
			DO:
				IF bfrAcct.cust-cat = "Ю" THEN
					DO:
						FIND FIRST bfrCustCorp WHERE
							bfrCustCorp.cust-id = bfrAcct.cust-id
							NO-LOCK NO-ERROR.
						IF AVAIL bfrCustCorp THEN
							outValue = bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp.
					END.
				IF bfrAcct.cust-cat = "Ч" THEN
					DO:
						FIND FIRST bfrPerson WHERE
							bfrPerson.person-id = bfrAcct.cust-id
							NO-LOCK NO-ERROR.
						IF AVAIL bfrPerson THEN
							outValue = bfrPerson.name-LAST + " " + bfrPerson.first-names.
					END.	
			END.
		ELSE
			outErrorStr = "Cчет " + inAcct + " не найден!" + CHR(10).  
			
		/* Выдаем ошибки на экран */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uacctlib.i:GetAcctClientName_UAL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
	  /* Конец функции GetAcctClientName_UAL */
END FUNCTION.
