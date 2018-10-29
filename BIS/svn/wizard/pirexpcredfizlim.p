{pirsavelog.p}

/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2010

		Производит экспорт данных в формате afx по кредитной линии физического лица.
		
		Бурягин Е.П., 12.10.2010, 10:20
		
		<Как_запускается> : Из броузера кредитных договоров
		<Параметры запуска> : полное имя файла экспорта.
		<Как_работает> : Реализованы процедуры для экспорта каждой конструкции. После сбора 
						всей информации по выделеному в броузере договору эти процедуры вызываются с 
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
			INPUT arg5 AS CHAR, 
			INPUT arg6 AS CHAR,
			INPUT arg7 AS CHAR,	INPUT arg8 AS CHAR,
			INPUT arg9 AS CHAR,	INPUT arg10 AS CHAR,
			INPUT arg11 AS CHAR,	INPUT arg12 AS CHAR,
			INPUT arg13 AS CHAR,	INPUT arg14 AS CHAR,
			INPUT arg15 AS CHAR,	INPUT arg16 AS CHAR,
			INPUT arg17 AS CHAR,	INPUT arg18 AS CHAR,
			INPUT arg19 AS CHAR
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction =                "<agreement>" + CHR(13) + CHR(10).
			construction = construction + "number=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "currency=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "open_date=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "end_date=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "summa=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "rate=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "firstpayratedate=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "firstpayloandate=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "rate_kind=" + arg9 + CHR(13) + CHR(10).
			construction = construction + "intpay=" + arg10 + CHR(13) + CHR(10).
			construction = construction + "intnextpaym=" + arg11 + CHR(13) + CHR(10).
			construction = construction + "intpaydaym=" + arg12 + CHR(13) + CHR(10).
			construction = construction + "intnextpayk=" + arg13 + CHR(13) + CHR(10).
			construction = construction + "intpaydayk=" + arg14 + CHR(13) + CHR(10).
			construction = construction + "pena_canfast_need=" + arg15 + CHR(13) + CHR(10).
			construction = construction + "countmonth=" + arg16 + CHR(13) + CHR(10).
			construction = construction + "safe_need=" + arg17 + CHR(13) + CHR(10).
			construction = construction + "guaranty_need=" + arg18 + CHR(13) + CHR(10).
			construction = construction + "safe_need=notneed" + CHR(13) + CHR(10).
			construction = construction + "lim_type=" + arg19 + CHR(13) + CHR(10).
			construction = construction + "lim_items=1" + CHR(13) + CHR(10).
			construction = construction + "</agreement>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.

FUNCTION exp_client RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, INPUT arg6 AS CHAR  
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<client>" + CHR(13) + CHR(10).
			construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "document=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "addressoflow=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "addressoflife=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "acct=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "sex=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "</client>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.


FUNCTION exp_plan RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, INPUT arg6 AS CHAR
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<plan>" + CHR(13) + CHR(10).
			construction = construction + "id=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "date=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "payment=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "int=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "amt=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "pos=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "</plan>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.

FUNCTION exp_guaranty RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<guaranty>" + CHR(13) + CHR(10).
			construction = construction + "kind=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "name=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "no=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "open_date=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "checked=checked" + CHR(13) + CHR(10).
			construction = construction + "</guaranty>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.


/** Реализация */
/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

/* Первый параметр */
DEF VAR out_file_name AS CHAR NO-UNDO. 
DEF VAR account AS CHAR NO-UNDO.
DEF VAR summa AS DECIMAL NO-UNDO. 
DEF VAR rate AS DECIMAL NO-UNDO.
DEF VAR rate_type AS CHAR NO-UNDO.
DEF VAR firstpayloandate AS DATE NO-UNDO.
DEF VAR firstpayratedate AS DATE NO-UNDO.

DEF TEMP-TABLE ttPlan 
	FIELD id AS INT
	FIELD pdate AS DATE
	FIELD amt-all AS DEC
	FIELD amt-int AS DEC
	FIELD amt AS DEC
	FIELD pos AS DEC
	INDEX idx id pdate.

DEF VAR i AS INT NO-UNDO.

DEF VAR total-amt AS DEC EXTENT 3 NO-UNDO.

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
   FIRST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code NO-LOCK 
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	
	PUT UNFORMATTED
	 
	 StrToWin_ULL(
			exp_agree(
				loan.cont-code,
				(if loan.currency = "" then "810" else loan.currency), 
				STRING(loan.open-date,"99/99/9999"), 
				STRING(loan.end-date,"99/99/9999"),
				STRING(summa),
				STRING(rate),
				STRING(LastMonDate(loan.open-date), "99/99/9999"),
				STRING(LastMonDate(GoMonth(loan.open-date, 1)), "99/99/9999"),
				"fix",
				loan-cond.int-period,
				(IF loan-cond.int-date = 31 THEN "tail" ELSE "every"),
				STRING(loan-cond.int-date),
				(IF loan-cond.int-date = 31 THEN "tail" ELSE "every"),
				STRING(loan-cond.int-date),
				"notneed",
				STRING(ROUND(MonInPer(loan.open-date, loan.end-date),0)),
				"notneed",
				(IF CAN-FIND(FIRST term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
						AND term-obl.class-code = "term-obl-gar") THEN "need" ELSE "notneed"),
				(IF GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "Режим", "НевозЛиния") = "НевозЛиния"
					THEN "v" ELSE "z")
			)
		).
				
					
	/* Информация по клиенту */
	IF loan.cust-cat = "Ч" THEN
		DO:
			FIND FIRST person WHERE
				person.person-id = loan.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL person THEN
				DO:
					PUT UNFORMATTED StrToWin_ULL(exp_client(
							person.name-last + " " + person.first-names,
							person.document-id + ": " +	person.document + ". Выдан: " + person.issue + " " +
							GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid",""),
							DelDoubleChars(person.address[1] + " " + person.address[2], ","), 
							"",
							account,
							(IF person.gender THEN "M" ELSE "F")
						)
					).
				END.
		END.
	ELSE
		DO:
			MESSAGE "Счет не принадлежит частному лицу!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		
	/** информация по обеспечению */
	FOR EACH term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-gar" NO-LOCK:
				PUT UNFORMATTED StrToWin_ULL(exp_guaranty(
						GetXAttrValueEx("term-obl", term-obl.contract + "," + term-obl.cont-code + "," 
								+ STRING(term-obl.idnt) + "," + STRING(term-obl.end-date) 
								+ "," + STRING(term-obl.nn), "ВидДогОб", ""),
						LC(GetCodeName("ВидОб", GetXAttrValueEx("term-obl", term-obl.contract + "," + term-obl.cont-code + "," 
								+ STRING(term-obl.idnt) + "," + STRING(term-obl.end-date) 
								+ "," + STRING(term-obl.nn), "ВидОб", ""))),
						GetXAttrValueEx("term-obl", term-obl.contract + "," + term-obl.cont-code + "," 
								+ STRING(term-obl.idnt) + "," + STRING(term-obl.end-date) 
								+ "," + STRING(term-obl.nn), "НомДогОб", ""),
						STRING(term-obl.end-date, "99/99/9999")
					)
				).
	END.
	
	/** график погашения */
	/** предварительно нужно собрать данные во временную таблицу */
	
	/** Этап 1. Выдача кредита */
	i = 1.
	FIND FIRST term-obl WHERE term-obl.contract = loan.contract 
			AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-sum" 
			AND term-obl.end-date <= loan.open-date
			NO-LOCK NO-ERROR.
	IF AVAIL term-obl THEN DO:
				CREATE ttPlan.
				ASSIGN 
					ttPlan.id = i
					ttPlan.pdate = term-obl.end-date
					ttPlan.amt-all = term-obl.amt-rub * (-1).
				i = i + 1.
	END.

	/** Этап 2. Платежи по процентам */
	FOR EACH term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-per" NO-LOCK:
			
			CREATE ttPlan.
			ASSIGN 
				ttPlan.id = i
				ttPlan.pdate = term-obl.end-date
				ttPlan.amt-int = term-obl.amt-rub.
			
			i = i + 1.
	END.
	
	/** Этап 3. Платежи по ссуде */
	FOR EACH term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-debt" NO-LOCK:
			
			FIND FIRST ttPlan WHERE ttPlan.pdate = term-obl.end-date NO-LOCK NO-ERROR.
			IF NOT AVAIL ttPlan THEN DO:
				CREATE ttPlan.
				ASSIGN 
					ttPlan.id = i
					ttPlan.pdate = term-obl.end-date.
				i = i + 1.
			END.
			ttPlan.amt = term-obl.amt-rub.
	END.
	
	/** Этап 4. Плановый остаток, выборка "шиворот на выворот" */
	FOR EACH ttPlan :
		FIND LAST term-obl WHERE term-obl.contract = loan.contract 
			AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-sum" 
			AND term-obl.end-date <= ttPlan.pdate
			NO-LOCK NO-ERROR.
		IF AVAIL term-obl THEN DO:
			ttPlan.pos = term-obl.amt-rub.
		END.
	END.
	
	/** Этап 5. Общая сумма платежа клиента 
	            Обработка всех записей в плане, кроме первой строки - выдачи кредита 
	*/
	FOR EACH ttPlan WHERE ttPlan.id > 1:
		ttPlan.amt-all = ttPlan.amt + ttPlan.amt-int.
	END.
	
	/** Этап 6. Итоги */
	total-amt[1] = 0.
	total-amt[2] = 0.
	total-amt[3] = 0.
	FOR EACH ttPlan :
		total-amt[1] = total-amt[1] + ttPlan.amt-all.
		total-amt[2] = total-amt[2] + ttPlan.amt-int.
		total-amt[3] = total-amt[3] + ttPlan.amt.
	END.
	CREATE ttPlan.
	ASSIGN 
		ttPlan.id = i
		ttPlan.pdate = 12/31/9999
		ttPlan.amt-all = total-amt[1]
		ttPlan.amt-int = total-amt[2]
		ttPlan.amt = total-amt[3].
	
	/** Этап 7. Экспорт */
	FOR EACH ttPlan NO-LOCK:
		PUT UNFORMATTED StrToWin_ULL(exp_plan(
					STRING(ttPlan.id),
					(IF ttPlan.pdate = 12/31/9999 THEN "ИТОГО:" ELSE STRING(ttPlan.pdate)),
					STRING(ttPlan.amt-all),
					STRING(ttPlan.amt-int),
					STRING(ttPlan.amt),
					STRING(ttPlan.pos)
				)
			).
	END.
	
END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
