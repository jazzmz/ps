{pirsavelog.p}

/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2007

		Производит экспорт данных в формате afx по кредитному договору.
		
		Бурягин Е.П., 06.06.2007 9:19
		
		<Как_запускается> : Из броузера кредитных договоров
		<Параметры запуска> : полное имя файла экспорта.
		<Как_работает> : Реализованы подпрограммы для экспорта каждой конструкции. После сбора 
										 всей информации по выделеному в броузере договору эти подпрограммы вызываются с 
										 соответсвующими параметрами.
		<Особенности_реализации>
		
		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>

*/

/** Глобальные определения */
{globals.i}

/** Библиотека моих собственных функций */
{ulib.i}

/** Подключение возможности использовать информацию броузера */
{tmprecid.def}

{intrface.get strng}

/** Подпрограммы экспорта конструкций */
FUNCTION exp_agree RETURNS CHAR (
																	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
																	INPUT arg3 AS CHAR,	INPUT arg4 AS CHAR,
																	INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
																	INPUT arg7 AS CHAR,	INPUT arg8 AS CHAR,
																	INPUT arg9 AS CHAR ).
			
			DEFINE VAR construction AS CHAR.
			
			construction =                "<agreement>" + CHR(13) + CHR(10).
			construction = construction + "number=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "currency=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "open_date=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "summa=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "end_date=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "rate=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "firstpayratedate=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "firstpayloandate=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "minsumma=" + arg9 + CHR(13) + CHR(10).
			construction = construction + "</agreement>" + CHR(13) + CHR(10).
			
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
			construction = construction + "addressoflow=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "addressoflife=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "acct=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "</client>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.

/** Реализация */
/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

/* Первый параметр */
DEF VAR out_file_name AS CHAR. 
DEF VAR account AS CHAR.
DEF VAR summa AS DECIMAL. 
DEF VAR rate AS DECIMAL.
DEF VAR rate_type AS CHAR.
DEF VAR firstpayloandate AS DATE.
DEF VAR firstpayratedate AS DATE.

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
         NO-LOCK 
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	
	PUT UNFORMATTED StrToWin_ULL(exp_agree(
				loan.cont-code,
				(if loan.currency = "" then "810" else loan.currency), 
				STRING(loan.open-date,"99/99/9999"), 
				STRING(summa),
				STRING(loan.end-date,"99/99/9999"),
				STRING(rate),
				STRING(LastMonDate(loan.open-date), "99/99/9999"),
				STRING(LastMonDate(GoMonth(loan.open-date, 1)), "99/99/9999"),
				STRING(0))).
				
					
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
							DelDoubleChars(person.address[1] + " " + person.address[2], ","), 
							"",
							account
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
