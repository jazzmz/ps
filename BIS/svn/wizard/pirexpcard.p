{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pirexpcard.p
      Comment: Экспорт данных в формате afx для МАСТЕРА ДОГОВОРОВ 
		по пластиковым договорам
   Parameters: Полное имя файла экспорта
       Launch: Из браузера договоров по ПК
         Uses:
      Created: Старая процедура создана неизвестно кем (точно до 08.11.2011г.)
	Basis: 
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



/** Глобальные определения */
{globals.i}


{ulib.i}		/** Библиотека ПИР функций */
{pir_expmaster.fun}     /** Библиотека функций для Мастера */

/** Подключение возможности использовать информацию броузера */
{tmprecid.def}

{intrface.get strng}

/** Подпрограммы экспорта конструкций */
FUNCTION exp_agree RETURNS CHAR (
																	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
																	INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
																	INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
																	INPUT arg7 AS CHAR, INPUT arg8 AS CHAR, 
																	INPUT arg9 AS CHAR).
	
			DEFINE VAR construction AS CHAR.
			
			construction =                "<plagreement>" + CHR(13) + CHR(10).
			/** replace нужен для замены русской С на латинскую С (спасибо Пластиководам ;) */
			construction = construction + "number=" + REPLACE(arg1, "С", "C") + CHR(13) + CHR(10).
			construction = construction + "date=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "accountmain=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "accountcurusdmain=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "accountcureurmain=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "accountminpos=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "card=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "currency=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "dateaccountosn=" + arg9 + CHR(13) + CHR(10).
			construction = construction + "</plagreement>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.

FUNCTION exp_client RETURNS CHAR (
																		INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
																		INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
																		INPUT arg5 AS CHAR ).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<client>" + CHR(13) + CHR(10).
			construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "document=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "address=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "phone=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "birthday=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "</client>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.

/** Следующая функция создана на основе GetLoanAcct_ULL_sur (ulib.i, Маслов Д.А., 3-ий вариант) */
/** Причина: есть договора, у которых дата открытия счетов позже даты открытия договора  */
/** Примечание: Решение временное */
/** Описание: GetLoanAcct_ULL_sur(Loan_Type:CHAR, Loan_Number:CHAR, Account_Role:CHAR): CHAR */
/** Назначение: Возвращает номер счета с заданной ролью из картотеки счетов кредитного договора */

FUNCTION GetLoanAcct_ULL_sur RETURNS CHAR(
		INPUT inLoanType AS CHAR,
		INPUT inLoan AS CHAR,
		INPUT inRole AS CHAR).

		/* Обпределение внутренних переменных */
		DEFINE VAR outValue AS CHAR init "" NO-UNDO.
		DEFINE BUFFER bfrLoan FOR loan.
		DEFINE BUFFER bfrLoanAcct FOR loan-acct.
		DEFINE BUFFER bfrAcct FOR acct.

		FIND FIRST bfrLoan WHERE bfrLoan.cont-code = inLoan NO-LOCK NO-ERROR.
 		FIND LAST bfrLoanAcct OF bfrLoan WHERE bfrLoanAcct.contract = inLoanType
			AND bfrLoanAcct.acct-type = inRole NO-LOCK NO-ERROR.

		IF AVAIL bfrLoanAcct THEN
			DO:
			      FIND FIRST bfrAcct OF bfrLoanAcct WHERE bfrAcct.close-date = ? NO-LOCK NO-ERROR.
				IF avail bfrAcct THEN
					outValue = bfrLoanAcct.acct.
			END.
			
		RETURN outValue.	
END FUNCTION.



/** Реализация */
/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR NO-UNDO.

/* Первый параметр */
DEF VAR out_file_name AS CHAR NO-UNDO. 
DEF VAR account AS CHAR NO-UNDO.
DEF VAR account_usd AS CHAR NO-UNDO.
DEF VAR account_eur AS CHAR NO-UNDO.
DEF VAR account_minpos AS CHAR NO-UNDO.
DEF VAR accountosn AS CHAR NO-UNDO.
DEF VAR dateaccountosn AS CHAR INIT "" NO-UNDO.

DEF BUFFER card FOR loan.
DEF BUFFER tmpAcct FOR acct.

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/buryagin/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED StrToWin_ULL("<data>" + CHR(13) + CHR(10)).

FOR FIRST tmprecid 
         NO-LOCK,
   FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id 
         NO-LOCK,
   FIRST card WHERE card.contract = "card"
                AND card.parent-contract = loan.contract
                AND card.parent-cont-code = loan.cont-code
                AND card.loan-work = YES
                AND CAN-DO("АКТ,ЗВЛ,ИЗГ",card.loan-status)
                AND card.close-date = ?
                NO-LOCK 
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@', loan.open-date, false).
	account_usd = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@840', loan.open-date, false).
	account_eur = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@978', loan.open-date, false).
	account_minpos = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SGP@' + loan.currency, loan.open-date, false).
	
	IF account = "" THEN
		account = GetLoanAcct_ULL_sur(loan.contract, loan.cont-code, 'SCS@').		
	IF account_usd = "" THEN
		account_usd = GetLoanAcct_ULL_sur(loan.contract, loan.cont-code, 'SCS@840').
	IF account_eur = "" THEN
		account_eur = GetLoanAcct_ULL_sur(loan.contract, loan.cont-code, 'SCS@978').
	IF account_minpos = "" THEN
		account_minpos = GetLoanAcct_ULL_sur(loan.contract, loan.cont-code, 'SGP@' + loan.currency).
	
	/* определяем основной карточный счет */
	CASE loan.currency :
	  WHEN "" THEN accountosn = account .
	  WHEN "840" THEN accountosn = account_usd .
	  WHEN "978" THEN accountosn = account_eur .
	END CASE.

	FIND FIRST tmpAcct WHERE tmpAcct.acct = accountosn NO-LOCK NO-ERROR.
	IF avail(tmpAcct) THEN
		dateaccountosn = STRING(tmpAcct.open-date,"99/99/9999").

	PUT UNFORMATTED StrToWin_ULL(exp_agree(
				loan.cont-code,
				STRING(loan.open-date,"99/99/9999"), 
				account, account_usd, account_eur, account_minpos,
				card.doc-num,
				loan.currency,
				dateaccountosn
				)).
				
					
	/* Информация по клиенту */
	IF loan.cust-cat = "Ч" THEN
		DO:
			FIND FIRST person WHERE
				person.person-id = loan.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL person THEN
				DO:
					PUT UNFORMATTED StrToWin_ULL(exp_client(person.name-last + " " + person.first-names,
							person.document-id + ": " +	person.document + ". Выдан: " + person.issue + " " +
							GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid",""),
							Master_Kladr(person.country-id + "," + GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ"),person.address[1] + person.address[2]), 
							person.phone[1],
							STRING(person.birthday, "99.99.9999")
						)
					).
				END.
		END.
	ELSE
		DO:
			MESSAGE "Счет не принадлежит клиенту частному лицу!" VIEW-AS ALERT-BOX.
			RETURN.
		END.

END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
