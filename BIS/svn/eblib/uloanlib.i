/*
		Udgin Loan Library (ULL).
		
		Библиотека функций для работы с кредитными и депозитными договорами.
		
		Бурягин Е.П., 27.12.2005 11:04
		
		Добавлено: Бурягин Е.П., 16.02.2006 11:52 - новые процедуры 2 раздела
		
		Описания функций выполнены в нотации языка Pascal (хоть здесь можно понятно излагать мысли :-(  )
		
		Все функции классифицированны по группам.
			1) Получение информации по кредитному(ым) договору(ам)
			2) Получение информации по кредитным и депозитным договорам, в зависимости от типа договора, 
			   передаваемого в процедуру
*/

/* 

		1 класс функций. 
		Предназначены для получения информации о кредитном договоре
		
		Список:
			
			GetCredLoanParamValue_ULL(Loan_Number:CHAR, Param_Code:INTEGER, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	Возвращает значение субаналитического параметра договора на дату.
			|	Если договор имеет течения/линии, то процедура просматривает каждое, и значения запрашиваемого параметра
			|	суммируются.
			
			GetCredLoanCommission_ULL(Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| Возвращает значение заданной процентной ставки по договору на дату.
			
			GetCredLoanAcct_ULL(Loan_Number:CHAR, Account_Role:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| Возвращает номер действующего на дату счета с заданной ролью из картотеки счетов кредитного договора 

			GetCredLoanInfo_ULL(Loan_Number:CHAR, Info_Name:CHAR, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| Возвращает информацию по кредитному договору:
			|
			| Значение 							Возвращаемый 
			| Info_Name							результат
			| -------------					----------------
			|	client_name						Наименование клиента
			|	open_date							Дата открытия(регистрации) договора

			
		2 класс функций	С 16.02.2006 11:43
		
		Список:
			
			GetLoanParamValue_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Param_Code:INTEGER, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			===================================================================================
			|	Возвращает значение субаналитического параметра договора на дату.
			|	Если договор имеет течения/линии, то процедура просматривает каждое, и значения запрашиваемого параметра
			|	суммируются.
			
			GetLoanCommission_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Commission_Code:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| Возвращает значение заданной процентной ставки по договору на дату.
			
			GetDpsCommission_ULL(Loan_Number:CHAR, Commission_Type:CHAR, MinSumma:DECIMAL, Date:DATE, ShowErrorMsg:LOGICAL): DECIMAL
			=====================================================================================
			| Возвращает значение заданной процентной ставки по договору на дату
			| 
			| Commission_Type
			|	Возможные значение									Описание
			| -------------------									---------------------
			| "commission"												Значение основной ставки
			| "pen-commi"													Значение штрафной ставки
			
			GetLoanAcct_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Account_Role:CHAR, Date:DATE, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| Возвращает номер действующего на дату счета с заданной ролью из картотеки счетов кредитного договора 

			GetLoanInfo_ULL(Loan_Type:CHAR, Loan_Number:CHAR, Info_Name:CHAR, ShowErrorMsg:LOGICAL): CHAR
			=========================================================================
			| Возвращает информацию по кредитному договору:
			|
			| Значение 							Возвращаемый 
			| Info_Name							результат
			| -------------					----------------
			|	client_name						Наименование клиента
			|	open_date							Дата открытия(регистрации) договора

			

*/


FUNCTION GetCredLoanParamValue_ULL RETURNS DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inParam AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanVar FOR loan-Var.
		
		/* Реализация */
		/** 
		 * Значение различных параметров хранится в различных таблицах. Так, например, текущее значение 
		 * параметра 4 хранится в непосредственно с таблице loan в поле interest[1], а в таблицу loan-var 
		 * заносится запись о погашении процентов. Другие значения хранятся в таблице loan-var
		 */
		
		FOR EACH bfrLoan WHERE
				bfrLoan.contract = "Кредит"
				AND
				(
					bfrLoan.cont-code = inLoan
					OR
					bfrLoan.cont-code begins inLoan + " "
				)
				AND
				bfrLoan.open-date LE inDate
				NO-LOCK
			:
				IF bfrLoan.since LT inDate THEN
					DO:
						outErrorStr = outErrorStr + "Договор " + bfrLoan.cont-code 
								+ " пересчитан на дату меньшую, чем дата " + STRING(inDate,"99/99/9999") 
								+ ". Параметры договора не учитываются в расчете!" + CHR(10).
						NEXT.
					END.
				IF inParam = 4 THEN
					DO:
						outValue = loan.interest[1].
					END.
				ELSE 
					DO:
						FIND LAST bfrLoanVar WHERE 
							bfrLoanVar.contract = bfrLoan.contract
							AND
							bfrLoanVar.cont-code = bfrLoan.cont-code
							AND
							bfrLoanVar.since LE inDate
							AND
							bfrLoanVar.amt-id = inParam
							NO-LOCK NO-ERROR.
				
						IF AVAIL bfrLoanVar THEN
							outValue = outValue + balance.
						ELSE
							outErrorStr = outErrorStr + "Значение параметра " + STRING(inParam) + " договора " + bfrLoan.cont-code + " на дату " + STRING(inDate,"99/99/9999") + " не определено!" + CHR(10).
					END.
				
		/* EACH bfrLoan */ 
		END.

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanParamValue_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* Конец функции GetCredLoanParamValue_ULL */		
END FUNCTION.

FUNCTION GetCredLoanCommission_ULL RETURNS DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inComm AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrCommRate FOR comm-rate.
		
		/* Реализация */
		FIND LAST bfrCommRate WHERE 
				bfrCommRate.commission = inComm
				AND
				bfrCommRate.kau = "Кредит," + inLoan
				AND
				bfrCommRate.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrCommRate THEN
			outValue = bfrCommRate.rate-comm / 100.
		ELSE
			outErrorStr = "Значение комиссии " + inComm + " на дату " + STRING(inDate,"99/99/9999") + " не найдено!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanCommission_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* Конец функции GetCredLoanCommission_ULL */
END FUNCTION.

FUNCTION GetCredLoanAcct_ULL RETURNS CHAR (
		INPUT inLoan AS CHAR,
		INPUT inRole AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* Обпределение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.

		/* Реализация */
		FIND LAST bfrLoanAcct WHERE
				bfrLoanAcct.contract = "Кредит"
				AND
				bfrLoanAcct.cont-code = inLoan
				AND
				bfrLoanAcct.acct-type = inRole
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrLoanAcct THEN
			outValue = bfrLoanAcct.acct.
		ELSE
			outErrorStr = "В картотеке счетов кредитного договора " + inLoan + " счет с ролью " 
					+ inRole + " не найден на дату " + STRING(inDate,"99/99/9999") + "!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanAcct_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
				
		/* Конец функции GetCredLoanAcct_ULL */
END FUNCTION.

FUNCTION GetCredLoanInfo_ULL RETURNS CHAR (
		INPUT inLoan AS CHAR,
		INPUT inName AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL).

		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrCustCorp FOR cust-corp.
		DEFINE BUFFER bfrSigns FOR signs.
		DEFINE BUFFER bfrPerson FOR person.
		/* Реализация */
		
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = "Кредит"
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				/* Дата открытия договора */
				IF inName = "open_date" THEN
					DO:
						/* Дата открытия в системе может быть перекрыта датой регистрации, 
						   значение которой хранится в доп.реквизите договора.
						*/
						FIND FIRST bfrSigns WHERE
							bfrSigns.code = "ДатаСогл"
							AND
							bfrSigns.file-name = "loan"
							AND
							bfrSigns.surrogate = "Кредит," + bfrLoan.cont-code
							NO-LOCK NO-ERROR.
						IF AVAIL bfrSigns THEN
							RETURN bfrSigns.code-value.
						
						/* Если доп.реквизита нет, то */
						RETURN STRING(bfrLoan.open-date, "99/99/9999").
					END.
				/* Наименование клиента */
				IF inName = "client_name" THEN
					DO:
						IF bfrLoan.cust-cat = "Ю" THEN
							DO:
								FIND FIRST bfrCustCorp WHERE bfrCustCorp.cust-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrCustCorp THEN	
									RETURN TRIM(bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp).
							END.
						IF bfrLoan.cust-cat = "Ч" THEN
							DO:
								FIND FIRST bfrPerson WHERE bfrPerson.person-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrPerson THEN
									RETURN bfrPerson.name-last + " " + bfrPerson.first-names.
							END.
					END.
			END.
		ELSE
			outErrorStr = outErrorStr + "Договор " + inLoan + " не найден в БД!" + CHR(10).

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanInfo_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = "".
		RETURN outValue.

		/* Конец функции GetCredLoanInfo_ULL */		
END FUNCTION.

/** 2 класс функций С 16.02.2006 11:44 */

FUNCTION GetLoanParamValue_ULL RETURNS DECIMAL (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inParam AS INTEGER,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL ).
		
		/* Определение внутренних переменных */
		DEFINE VAR tmpDate AS DATE.
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanVar FOR loan-Var.
		DEFINE BUFFER bfrLoanInt FOR loan-int.
		
		/* Реализация */
		/** 
		 * Значение различных параметров хранится в различных таблицах. Так, например, текущее значение 
		 * параметра 4 хранится в непосредственно с таблице loan в поле interest[1], а в таблицу loan-var 
		 * заносится запись о погашении процентов. Другие значения хранятся в таблице loan-var
		 */
		
		FOR EACH bfrLoan WHERE
				bfrLoan.contract = inLoanType
				AND
				(
					bfrLoan.cont-code = inLoan
					OR
					bfrLoan.cont-code begins inLoan + " "
				)
				AND
				bfrLoan.open-date LE inDate
				NO-LOCK
			:
				IF bfrLoan.since LT inDate THEN
					DO:
						outErrorStr = outErrorStr + "Договор " + bfrLoan.cont-code 
								+ " пересчитан на дату меньшую, чем дата " + STRING(inDate,"99/99/9999") 
								+ ". Параметры договора не учитываются в расчете!" + CHR(10).
						NEXT.
					END.
				IF inParam = 4 THEN
					DO:
						outValue = loan.interest[1].
					END.
				ELSE 
					DO:
						FIND LAST bfrLoanVar WHERE 
							bfrLoanVar.contract = bfrLoan.contract
							AND
							bfrLoanVar.cont-code = bfrLoan.cont-code
							AND
							bfrLoanVar.since LE inDate
							AND
							bfrLoanVar.amt-id = inParam
							NO-LOCK NO-ERROR.
				
						IF AVAIL bfrLoanVar THEN 
							DO:
							outValue = outValue + balance.
							tmpDate = bfrLoanVar.since.
							END.
						ELSE
							DO:
							outErrorStr = outErrorStr + "Значение параметра " + STRING(inParam) + " договора " + bfrLoan.cont-code + " на дату " + STRING(inDate,"99/99/9999") + " не определено!" + CHR(10).
							tmpDate = bfrLoan.open-date.
							END.
						
						FOR EACH bfrLoanInt WHERE 
							bfrLoanInt.contract = bfrLoan.contract
							AND
							bfrLoanInt.cont-code = bfrLoan.cont-code
							AND
							bfrLoanInt.mdate GT tmpDate
							AND
							bfrLoanInt.mdate LE inDate
							AND
							bfrLoanInt.id-k = inParam
							NO-LOCK
							:
							outValue = outValue - amt-rub.
						END.

						FOR EACH bfrLoanInt WHERE 
							bfrLoanInt.contract = bfrLoan.contract
							AND
							bfrLoanInt.cont-code = bfrLoan.cont-code
							AND
							bfrLoanInt.mdate GT tmpDate
							AND
							bfrLoanInt.mdate LE inDate
							AND
							bfrLoanInt.id-d = inParam
							NO-LOCK
							:
							outValue = outValue + amt-rub.
						END.
							
					END.
				
		/* EACH bfrLoan */ 
		END.

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanParamValue_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* Конец функции GetCredLoanParamValue_ULL */		
END FUNCTION.

FUNCTION GetLoanCommission_ULL RETURNS DECIMAL (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inComm AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrCommRate FOR comm-rate.
		
		/* Реализация */
		FIND LAST bfrCommRate WHERE 
				bfrCommRate.commission = inComm
				AND
				bfrCommRate.kau = inLoanType + "," + inLoan
				AND
				bfrCommRate.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrCommRate THEN
			outValue = bfrCommRate.rate-comm / 100.
		ELSE
			outErrorStr = "Значение комиссии " + inComm + " на дату " + STRING(inDate,"99/99/9999") + " не найдено!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanCommission_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.

		/* Конец функции GetCredLoanCommission_ULL */
END FUNCTION.

FUNCTION GetDpsCommission_ULL RETURN DECIMAL (
		INPUT inLoan AS CHAR,
		INPUT inTypeComm AS CHAR,
		INPUT inBalance AS DECIMAL,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS DECIMAL.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.
		DEFINE BUFFER bfrSigns FOR signs.
		DEFINE BUFFER bfrCommRate FOR comm-rate.
		
		/** Реализация */
		FIND FIRST bfrLoan WHERE
			bfrLoan.contract = "dps"
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN DO:
			FIND LAST bfrLoanAcct WHERE
				bfrLoanAcct.contract = bfrLoan.contract
				AND
				bfrLoanAcct.cont-code = bfrLoan.cont-code
				AND
				CAN-DO("loan-dps-t,loan-dps-p",bfrLoanAcct.acct-type)
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
			IF AVAIL bfrLoanAcct THEN DO:
				FIND FIRST bfrSigns WHERE 
					bfrSigns.code = inTypeComm
					AND
					file-name = "op-template"
					AND
					surrogate BEGINS bfrLoan.op-kind
					NO-LOCK NO-ERROR.
				IF AVAIL bfrSigns THEN DO:
					FIND LAST bfrCommRate WHERE
						bfrCommRate.commission = bfrSigns.code-value
						AND
						bfrCommRate.currency = bfrLoan.currency
						AND
						bfrCommRate.since LE bfrLoan.open-DATE
						AND
						bfrCommRate.min-value LE ABS(inBalance)
						AND
						bfrCommRate.period LE (bfrLoan.end-date - bfrLoan.open-date)
						AND
						(
							bfrCommRate.acct = "0"
							OR
							bfrCommRate.acct = bfrLoanAcct.acct
						)
						/*USE-INDEX comm-rate*/
						NO-LOCK NO-ERROR.
					IF AVAIL bfrCommRate THEN
						outValue = bfrCommRate.rate-comm / 100.
				END.
			END.
		END.
		RETURN outValue.
END FUNCTION.


FUNCTION GetLoanAcct_ULL RETURNS CHAR (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inRole AS CHAR,
		INPUT inDate AS DATE,
		INPUT inShowErrorMsg AS LOGICAL).
		
		/* Обпределение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.

		/* Реализация */
		FIND LAST bfrLoanAcct WHERE
				bfrLoanAcct.contract = inLoanType
				AND
				bfrLoanAcct.cont-code = inLoan
				AND
				CAN-DO(inRole, bfrLoanAcct.acct-type)
				AND
				bfrLoanAcct.since LE inDate
				NO-LOCK NO-ERROR.
		IF AVAIL bfrLoanAcct THEN
			outValue = bfrLoanAcct.acct.
		ELSE
			outErrorStr = "В картотеке счетов договора " + inLoan + " счет с ролью " 
					+ inRole + " не найден на дату " + STRING(inDate,"99/99/9999") + "!".

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanAcct_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		RETURN outValue.
				
		/* Конец функции GetCredLoanAcct_ULL */
END FUNCTION.

FUNCTION GetLoanInfo_ULL RETURNS CHAR (
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inName AS CHAR,
		INPUT inShowErrorMsg AS LOGICAL).

		/* Определение внутренних переменных */
		DEFINE VAR outErrorStr AS CHAR.
		DEFINE VAR outValue AS CHAR.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrCustCorp FOR cust-corp.
		DEFINE BUFFER bfrSigns FOR signs.
		DEFINE BUFFER bfrPerson FOR person.
		/* Реализация */
		
		FIND FIRST bfrLoan WHERE 
			bfrLoan.contract = inLoanType
			AND
			bfrLoan.cont-code = inLoan
			NO-LOCK NO-ERROR.
		IF AVAIL bfrLoan THEN
			DO:
				/* Дата открытия договора */
				IF inName = "open_date" THEN
					DO:
						/* Дата открытия в системе может быть перекрыта датой регистрации, 
						   значение которой хранится в доп.реквизите договора.
						*/
						FIND FIRST bfrSigns WHERE
							bfrSigns.code = "ДатаСогл"
							AND
							bfrSigns.file-name = "loan"
							AND
							bfrSigns.surrogate = bfrLoan.contract + "," + bfrLoan.cont-code
							NO-LOCK NO-ERROR.
						IF AVAIL bfrSigns THEN
							RETURN bfrSigns.code-value.
						
						/* Если доп.реквизита нет, то */
						RETURN STRING(bfrLoan.open-date, "99/99/9999").
					END.
				/* Наименование клиента */
				IF inName = "client_name" THEN
					DO:
						IF bfrLoan.cust-cat = "Ю" THEN
							DO:
								FIND FIRST bfrCustCorp WHERE bfrCustCorp.cust-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrCustCorp THEN	
									RETURN TRIM(bfrCustCorp.cust-stat + " " + bfrCustCorp.name-corp).
							END.
						IF bfrLoan.cust-cat = "Ч" THEN
							DO:
								FIND FIRST bfrPerson WHERE bfrPerson.person-id = bfrLoan.cust-id NO-LOCK NO-ERROR.
								IF AVAIL bfrPerson THEN
									RETURN bfrPerson.name-last + " " + bfrPerson.first-names.
							END.
					END.
			END.
		ELSE
			outErrorStr = outErrorStr + "Договор " + inLoan + " не найден в БД!" + CHR(10).

		IF outErrorStr <> "" AND inShowErrorMsg THEN 
			DO:
				outErrorStr = "*** Функция uloanlib.i:GetCredLoanInfo_ULL сообщает ***" + CHR(10) + outErrorStr.
				MESSAGE outErrorStr VIEW-AS ALERT-BOX.
			END.
			
		outValue = "".
		RETURN outValue.

		/* Конец функции GetCredLoanInfo_ULL */		
END FUNCTION.

			
