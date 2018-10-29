/* 
	 дату

*/

/** Подгружаем функции для работы с датами. */
{intrface.get date}

/** Предопределения, чтобы в самой библиотеке можно было использовать функции */
FUNCTION GetDpsCommission_ULL RETURN DECIMAL (INPUT inLoan AS CHAR,	INPUT inTypeComm AS CHAR,	INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL) FORWARD.


/** Реализация */

FUNCTION StrToWin_ULL RETURNS CHARACTER (INPUT arg1 AS CHARACTER).
/* Вход: arg1:строка
** Выход: строка в кодировке windows-1251
*/
	RETURN CODEPAGE-CONVERT(arg1,"1251",SESSION:CHARSET).
END FUNCTION.

FUNCTION GetAcctPosValue_UAL2 RETURNS DECIMAL (
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
		DEFINE BUFFER bfrOp      FOR op.
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
				
				outErrorStr = "Найденный остаток по счету " + inAcct + " в валюте " + acctCur + " на дату " 
					+ STRING(inDate,"99/99/9999") + " равен " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).
				
				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
					bfrOpEntry.acct-db = inAcct
					:
					 FIND FIRST bfrOp of bfrOpEntry no-lock no-error.
					 FIND FIRST tmprecid where RECID(bfrOp) eq tmprecid.id no-lock no-error.
					 IF avail tmprecid or bfrOpEntry.op-status GT "ФА" then 
					 DO:
					    IF bfrAcct.side = "П" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos + bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos + bfrOpEntry.amt-cur.
						END.			
				END.
				
				outErrorStr = outErrorStr + "Найденная сумма проводок по дебету по счету в незакрытых днях " + inAcct + " в валюте " + acctCur + " на дату " 
					+ STRING(inDate,"99/99/9999") + " изменила остаток до значения " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).

				FOR EACH bfrOpEntry WHERE
					bfrOpEntry.op-DATE GE lstSince
					AND
					bfrOpEntry.op-DATE LE inDate
					AND
				  bfrOpEntry.acct-cr = inAcct
				  :
					 FIND FIRST bfrOp of bfrOpEntry no-lock no-error.
					 FIND FIRST tmprecid where RECID(bfrOp) eq tmprecid.id no-lock no-error.
					 IF avail tmprecid or bfrOpEntry.op-status GT "ФА" then
					 DO:
					 		IF bfrAcct.side = "П" THEN 
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
							ELSE
								IF acctCur = "810" THEN
									acctPos = acctPos - bfrOpEntry.amt-rub.
								ELSE
									acctPos = acctPos - bfrOpEntry.amt-cur.
					  END.				
				END.

				outErrorStr = outErrorStr + "Найденная сумма проводок по кредиту по счету в незакрытых днях " + inAcct + " в валюте " + acctCur + " на дату " 
					+ STRING(inDate,"99/99/9999") + " изменила остаток до значения " + STRING(acctPos,"->>>,>>>,>>>,>>>,>>9.99") + CHR(10).

			END.
		ELSE
			outErrorStr = "Cчет " + inAcct + " не найден!" + CHR(10).  
		
		/* Выдаем ошибки на экран */
		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция ulib.i:GetAcctPosValue_UAL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = acctPos.
		RETURN outValue.

		/* Конец функции GetAcctPosValue_UAL2 */		
		END FUNCTION.
		
