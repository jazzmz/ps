{pirsavelog.p}

/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011 
     Filename: pirexpcredacct.p
      Comment: Экспорт данных в формате afx для доп.соглашения для выдачи овердрафта сотруднику
       Launch: Запуск из броузера кредитных договоров
   Parameters: Полное имя файла экспорта
         Uses:
      Used by:
      Created: Ситов С.А., 23.11.2011 
<Как_работает> : Реализованы процедуры для экспорта каждой конструкции. После сбора 
		всей информации по выделеному в броузере договору эти процедуры вызываются с 
		соответсвующими параметрами.
<Особенности_реализации> Процедура создана на основе pirexocredfiz.p 
		ПОЭТОМУ в коде есть неиспользуемые поля, но они пригодятся при доработке! 
     Modified: <mrusinov> <22.01.2014>
	       <В блок получения инфо по клиенту добавлен функционал для ф. Kladr - для более читабельного вида адресных данных - для Мастера Договоров.>                                           
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/


/** Глобальные определения */
{globals.i}
{ulib.i}
{pir_anketa.fun} /* mrusinov */

/** Переменные, используемые в т.ч. для функции Kladr в этой процедуре **/

DEF VAR cTfakt AS CHAR NO-UNDO.
DEF VAR cTprop AS CHAR NO-UNDO.
DEF VAR cTf-id AS CHAR NO-UNDO.
DEF VAR cTp-id AS CHAR NO-UNDO.

/** Подключение возможности использовать информацию броузера */
{tmprecid.def}

{intrface.get strng}

/** Подпрограммы экспорта конструкций */
FUNCTION exp_agree RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR,	INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
			INPUT arg7 AS CHAR,	INPUT arg8 AS CHAR,
			INPUT arg9 AS CHAR,	INPUT arg10 AS CHAR,
			INPUT arg11 AS CHAR,	INPUT arg12 AS CHAR,
			INPUT arg13 AS CHAR,	INPUT arg14 AS CHAR,
			INPUT arg15 AS CHAR,	INPUT arg16 AS CHAR,
			INPUT arg17 AS CHAR,	INPUT arg18 AS CHAR,
			INPUT arg19 AS CHAR,	INPUT arg20 AS CHAR,
			INPUT arg21 AS CHAR,	INPUT arg22 AS CHAR,
			INPUT arg23 AS CHAR,	INPUT arg24 AS CHAR,
			INPUT arg25 AS CHAR
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
			construction = construction + "lim_sum=" + arg19 + CHR(13) + CHR(10).
			construction = construction + "lim_srok=" + arg20 + CHR(13) + CHR(10).
			construction = construction + "fullpercent=" + arg21 + CHR(13) + CHR(10).
			construction = construction + "rate_rast=" + arg22 + CHR(13) + CHR(10).
			construction = construction + "rate_pen=" + arg23 + CHR(13) + CHR(10).
			construction = construction + "ds_number=" + arg24 + CHR(13) + CHR(10).
			construction = construction + "ds_opendate=" + arg25 + CHR(13) + CHR(10).
			construction = construction + "</agreement>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.

FUNCTION exp_client RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,  
			INPUT arg7 AS CHAR, INPUT arg8 AS CHAR,
			INPUT arg9 AS CHAR  /* mrusinov */
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<client>" + CHR(13) + CHR(10).
			construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "document=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "addressoflow=" + arg9 + CHR(13) + CHR(10). /* mrusinov */
			construction = construction + "addressoflife=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "acct=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "acct455=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "acct91317=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "sex=" + arg8 + CHR(13) + CHR(10).
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
DEF VAR out_file_name AS CHAR. 
DEF VAR account AS CHAR.
DEF VAR account455 AS CHAR.
DEF VAR account91317 AS CHAR.
DEF VAR ds_number AS CHAR.
DEF VAR ds_opendate AS DATE.
DEF VAR summa AS DECIMAL. 
DEF VAR rate AS DECIMAL.
DEF VAR rate_type AS CHAR.
DEF VAR firstpayloandate AS DATE.
DEF VAR firstpayratedate AS DATE.

DEF TEMP-TABLE ttPlan NO-UNDO
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
   FIRST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code NO-LOCK,
   FIRST loan-acct of loan WHERE  loan-acct.acct-type = "Кредит" NO-LOCK
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
	account455 = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'Кредит', loan.open-date, false).
	account455 = loan-acct.acct.
	account91317 = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредН', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	
	FIND FIRST acct WHERE acct.acct = account NO-LOCK NO-ERROR.
	IF GetXAttrValue("acct",acct.acct + "," + acct.currency,"ДогОткрЛС") <> "" THEN
	  DO:
		ds_number   = ENTRY(2,GetXAttrValue("acct",acct.acct + "," + acct.currency,"ДогОткрЛС"), ",") .
		ds_opendate = DATE(ENTRY(1,GetXAttrValue("acct",acct.acct + "," + acct.currency,"ДогОткрЛС"), ",")) .
	  END.
	ELSE 
	  DO:
		ds_number   = "" .
		ds_opendate = ? .
	  END.



	PUT UNFORMATTED
	 StrToWin_ULL(
			exp_agree(
				loan.cont-code,
				(if loan.currency = "" then "810" else loan.currency), 
				STRING(loan.open-date,"99/99/9999"), 
				STRING(loan.end-date,"99/99/9999"),
				STRING(summa),
				"15", /* rate - процентаная ставка - ПОСТОЯННАЯ ДЛЯ ДАННОГО КРЕДИТА*/
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
				STRING(summa),  /*lim_sum макс. сумма лимита*/
				"45" ,  /* lim_srok макс. срок*/
				"" ,    /*fullpercent полная процентная ставка*/
				"",     /*rate_rast процентная ставка при увольнении */
				"73",   /*rate_pen  неустойка*/
                                STRING(ds_number)   ,            /* номер доп соглашения */
                                STRING(ds_opendate,"99/99/9999") /* дата  доп соглашения */	
			)
		).
				
					
	/* Информация по клиенту */ /* mrusinov - взято из pirexpdpsagr.p */ 
	IF loan.cust-cat = "Ч" THEN
		DO:
			FIND FIRST person WHERE
				person.person-id = loan.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL person THEN
				DO:
            			/* #4384 Поиск по фактическому адресу и его экспорт в мастер договоров */
				FIND LAST cust-ident WHERE
			                cust-ident.cust-code-type = "АдрФакт"
			                AND (cust-ident.close-date EQ ? OR cust-ident.close-date >= gend-date) 
			                AND cust-ident.class-code EQ 'p-cust-adr'
			                AND cust-ident.cust-cat EQ 'Ч'
			                AND cust-ident.cust-id EQ person.person-id
			            NO-LOCK NO-ERROR.
			       IF (AVAIL cust-ident) THEN DO:
		                cTfakt = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                		       + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
			               + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
			               + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
				cTf-id = cust-ident.issue.
				END. 
            		       ELSE DO:
	                       cTfakt = "".
			       cTf-id = "".
				END.			
            			/* #4384 Поиск по адресу прописки и его экспорт в мастер договоров */
				FIND LAST cust-ident WHERE
			                cust-ident.cust-code-type = "АдрПроп"
			                AND (cust-ident.close-date EQ ? OR cust-ident.close-date >= gend-date) 
			                AND cust-ident.class-code EQ 'p-cust-adr'
			                AND cust-ident.cust-cat EQ 'Ч'
			                AND cust-ident.cust-id EQ person.person-id
			            NO-LOCK NO-ERROR.
			       IF (AVAIL cust-ident) THEN DO:
		                cTprop = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                		       + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
			               + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
			               + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "КодРегГНИ").
				cTp-id = cust-ident.issue.
				END. 
            		       ELSE DO:
	                       cTprop = "".
			       cTp-id = "".
				END.	

					PUT UNFORMATTED StrToWin_ULL(exp_client(
							person.name-last + " " + person.first-names,
							person.document-id + ": " +	person.document + ". Выдан: " + person.issue + " " +
							GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid",""),
							DelDoubleChars(person.address[1] + " " + person.address[2], ","), 
							"",
							account,
							account455,
							account91317,
							(IF person.gender THEN "M" ELSE "F"),
							Kladr(cTfakt,cTf-id)
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
