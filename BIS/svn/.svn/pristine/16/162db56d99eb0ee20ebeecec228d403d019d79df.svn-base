{pirsavelog.p}

/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011 
     Filename: pirexpcredzalog.p
      Comment: Экспорт данных в формате afx для договоров залога по кредитным договорам (ЮрЛ и ФизЛ)
       Launch: Запуск из броузера кредитных договоров
   Parameters: Полное имя файла экспорта
         Uses:
      Used by:
      Created: Ситов С.А., 23.08.2011 
<Как_работает> : Реализованы процедуры для экспорта каждой конструкции. После сбора 
		всей информации по выделеному в броузере договору эти процедуры вызываются с 
		соответсвующими параметрами.
<Особенности_реализации> Процедура создана на основе pirexocredfizlim.p 
		ПОЭТОМУ в коде есть неиспользуемые поля, но они пригодятся при доработке! 
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/



{globals.i}		/** Глобальные определения */
{tmprecid.def}		/** Подключение возможности использовать информацию броузера */
{intrface.get strng}
{ulib.i}		/** Библиотека моих собственных функций */


		/** Подпрограммы экспорта конструкций */


FUNCTION exp_agr_debtor RETURNS CHAR 
	(
	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR, INPUT arg3 AS CHAR,
	INPUT arg4 AS CHAR, INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
	INPUT arg7 AS CHAR, INPUT arg8 AS CHAR, INPUT arg9 AS CHAR,
	INPUT arg10 AS CHAR,INPUT arg11 AS CHAR,INPUT arg12 AS CHAR,
	INPUT arg13 AS CHAR,INPUT arg14 AS CHAR,INPUT arg15 AS CHAR,
	INPUT arg16 AS CHAR,INPUT arg17 AS CHAR
	).
			
	DEFINE VAR construction AS CHAR.
	
	construction =                "<agr_debtor>"   + CHR(13) + CHR(10).
	construction = construction + "number="        + arg1  + CHR(13) + CHR(10).
	construction = construction + "summa="         + arg2  + CHR(13) + CHR(10).
	construction = construction + "currency="      + arg3  + CHR(13) + CHR(10).
	construction = construction + "platz="         + arg4  + CHR(13) + CHR(10).
	construction = construction + "opendate="      + arg5  + CHR(13) + CHR(10).
	construction = construction + "enddate="       + arg6  + CHR(13) + CHR(10).
	construction = construction + "rate="          + arg7  + CHR(13) + CHR(10).
	construction = construction + "fullpercent="   + arg8  + CHR(13) + CHR(10).
	construction = construction + "kredittype="    + arg9  + CHR(13) + CHR(10).
	construction = construction + "kreditlimtype=" + arg10 + CHR(13) + CHR(10).
	construction = construction + "intpay="        + arg11 + CHR(13) + CHR(10).
	construction = construction + "firstpay="      + arg12 + CHR(13) + CHR(10).
	construction = construction + "firstper="      + arg13 + CHR(13) + CHR(10).
	construction = construction + "vo="            + arg14 + CHR(13) + CHR(10).
	construction = construction + "eqcur="         + arg15 + CHR(13) + CHR(10).
	construction = construction + "eqdig="         + arg16 + CHR(13) + CHR(10).
	construction = construction + "eqsum="         + arg17 + CHR(13) + CHR(10).
	construction = construction + "</agr_debtor>" + CHR(13) + CHR(10).
			
	RETURN construction.

END FUNCTION.


FUNCTION exp_debtor RETURNS CHAR 
	(
	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR, INPUT arg3 AS CHAR,
	INPUT arg4 AS CHAR, INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
	INPUT arg7 AS CHAR, INPUT arg8 AS CHAR, INPUT arg9 AS CHAR,
	INPUT arg10 AS CHAR,INPUT arg11 AS CHAR,INPUT arg12 AS CHAR,
	INPUT arg13 AS CHAR,INPUT arg14 AS CHAR,INPUT arg15 AS CHAR,
	INPUT arg16 AS CHAR
	).
			
	DEFINE VAR construction AS CHAR.
	
	construction =                "<debtor>"   + CHR(13) + CHR(10).
	construction = construction + "type="       + arg1  + CHR(13) + CHR(10).
	construction = construction + "name="       + arg2  + CHR(13) + CHR(10).
	construction = construction + "nametp="     + arg3  + CHR(13) + CHR(10).
	construction = construction + "agent="      + arg4  + CHR(13) + CHR(10).
	construction = construction + "agentdocum=" + arg5  + CHR(13) + CHR(10).
	construction = construction + "agentpasp="  + arg6  + CHR(13) + CHR(10).
	construction = construction + "fldocum="    + arg7  + CHR(13) + CHR(10).
	construction = construction + "sex="        + arg8  + CHR(13) + CHR(10).
	construction = construction + "birthday="   + arg9  + CHR(13) + CHR(10).
	construction = construction + "birthplace=" + arg10 + CHR(13) + CHR(10).
	construction = construction + "inn="        + arg11 + CHR(13) + CHR(10).
	construction = construction + "ogrn="       + arg12 + CHR(13) + CHR(10).
	construction = construction + "addrur="     + arg13 + CHR(13) + CHR(10).
	construction = construction + "acct="       + arg14 + CHR(13) + CHR(10).
	construction = construction + "phone="      + arg15 + CHR(13) + CHR(10).
	construction = construction + "garant_no="  + arg16 + CHR(13) + CHR(10).
	construction = construction + "<debtor>" + CHR(13) + CHR(10).
			
	RETURN construction.

END FUNCTION.


FUNCTION exp_garant RETURNS CHAR 
	(
	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR, INPUT arg3 AS CHAR,
	INPUT arg4 AS CHAR, INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
	INPUT arg7 AS CHAR, INPUT arg8 AS CHAR, INPUT arg9 AS CHAR,
	INPUT arg10 AS CHAR,INPUT arg11 AS CHAR,INPUT arg12 AS CHAR,
	INPUT arg13 AS CHAR,INPUT arg14 AS CHAR
	).
			
	DEFINE VAR construction AS CHAR.
	
	construction =                "<garant>"   + CHR(13) + CHR(10).
	construction = construction + "type="       + arg1  + CHR(13) + CHR(10).
	construction = construction + "name="       + arg2  + CHR(13) + CHR(10).
	construction = construction + "nametp="     + arg3  + CHR(13) + CHR(10).
	construction = construction + "agent="      + arg4  + CHR(13) + CHR(10).
	construction = construction + "agentdocum=" + arg5  + CHR(13) + CHR(10).
	construction = construction + "fldocum="    + arg6  + CHR(13) + CHR(10).
	construction = construction + "sex="        + arg7  + CHR(13) + CHR(10).
	construction = construction + "birthday="   + arg8  + CHR(13) + CHR(10).
	construction = construction + "birthplace=" + arg9  + CHR(13) + CHR(10).
	construction = construction + "inn="        + arg10 + CHR(13) + CHR(10).
	construction = construction + "ogrn="       + arg11 + CHR(13) + CHR(10).
	construction = construction + "addrur="     + arg12 + CHR(13) + CHR(10).
	construction = construction + "acct="       + arg13 + CHR(13) + CHR(10).
	construction = construction + "phone="      + arg14 + CHR(13) + CHR(10).
	construction = construction + "<garant>" + CHR(13) + CHR(10).
			
	RETURN construction.

END FUNCTION.



FUNCTION exp_agr_garant RETURNS CHAR 
	(
	INPUT arg1 AS CHAR, INPUT arg2 AS CHAR, INPUT arg3 AS CHAR,
	INPUT arg4 AS CHAR, INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
	INPUT arg7 AS CHAR, INPUT arg8 AS CHAR, INPUT arg9 AS CHAR,
	INPUT arg10 AS CHAR,INPUT arg11 AS CHAR,INPUT arg12 AS CHAR,
	INPUT arg13 AS CHAR,INPUT arg14 AS CHAR,INPUT arg15 AS CHAR,
	INPUT arg16 AS CHAR,INPUT arg17 AS CHAR,INPUT arg18 AS CHAR,
	INPUT arg19 AS CHAR,INPUT arg20 AS CHAR,INPUT arg21 AS CHAR,
	INPUT arg22 AS CHAR,INPUT arg23 AS CHAR,INPUT arg24 AS CHAR,
	INPUT arg25 AS CHAR,INPUT arg26 AS CHAR,INPUT arg27 AS CHAR
	).
			
	DEFINE VAR construction AS CHAR.
	
	construction =                "<agr_garant>"   + CHR(13) + CHR(10).
	construction = construction + "object="          + arg1  + CHR(13) + CHR(10).
	construction = construction + "object_1="        + arg2  + CHR(13) + CHR(10).
	construction = construction + "object_2="        + arg3  + CHR(13) + CHR(10).
	construction = construction + "object_3="        + arg4  + CHR(13) + CHR(10).
	construction = construction + "object_4="        + arg5  + CHR(13) + CHR(10).
	construction = construction + "object_5="        + arg6  + CHR(13) + CHR(10).
	construction = construction + "object_7="        + arg7  + CHR(13) + CHR(10).
	construction = construction + "object_8="        + arg8  + CHR(13) + CHR(10).
	construction = construction + "authorityreg="    + arg9  + CHR(13) + CHR(10).
	construction = construction + "authoritydoc="    + arg10 + CHR(13) + CHR(10).
	construction = construction + "egrulnum="        + arg11 + CHR(13) + CHR(10).
	construction = construction + "egruldata="       + arg12 + CHR(13) + CHR(10).
	construction = construction + "certifnum="       + arg13 + CHR(13) + CHR(10).
	construction = construction + "certifdata="      + arg14 + CHR(13) + CHR(10).
	construction = construction + "groundauthorityreg="    + arg15 + CHR(13) + CHR(10).
	construction = construction + "groundauthoritydoc="    + arg16 + CHR(13) + CHR(10).
	construction = construction + "groundegrulnum="        + arg17 + CHR(13) + CHR(10).
	construction = construction + "groundegruldata="       + arg18 + CHR(13) + CHR(10).
	construction = construction + "groundcertifnum="       + arg19 + CHR(13) + CHR(10).
	construction = construction + "groundcertifdata="      + arg20 + CHR(13) + CHR(10).
	construction = construction + "summa="           + arg21 + CHR(13) + CHR(10).
	construction = construction + "timebuhrep="      + arg22 + CHR(13) + CHR(10).
	construction = construction + "timenotarycert="  + arg23 + CHR(13) + CHR(10).
	construction = construction + "timegosregdoc="   + arg24 + CHR(13) + CHR(10).
	construction = construction + "notary="          + arg25 + CHR(13) + CHR(10).
	construction = construction + "court="           + arg26 + CHR(13) + CHR(10).
	construction = construction + "addrur="          + arg27 + CHR(13) + CHR(10).
	construction = construction + "<agr_garant>" + CHR(13) + CHR(10).
			
	RETURN construction.

END FUNCTION.





		/******************* Реализация ***********************/

		/*** Объявления ***/

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

DEF VAR i AS INT NO-UNDO.

DEF VAR total-amt AS DEC EXTENT 3 NO-UNDO.


		/*** Объявления ***/

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/sitov/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED StrToWin_ULL("<data>" + CHR(13) + CHR(10)).


FOR FIRST tmprecid NO-LOCK,
FIRST loan WHERE 
	RECID(loan) EQ tmprecid.id NO-LOCK,
FIRST loan-cond WHERE loan-cond.contract = loan.contract 
	AND loan-cond.cont-code = loan.cont-code 
NO-LOCK: 


		/* Информация по кредитному договору */

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	

	PUT UNFORMATTED
	 StrToWin_ULL(
		exp_agr_debtor(
			loan.cont-code,
			STRING(summa),
			(if loan.currency = "" then "810" else loan.currency), 
			"", /* место заключения кред. договора */
			STRING(loan.open-date,"99/99/9999"), 
			STRING(loan.end-date,"99/99/9999"),
			STRING(rate),
			"", /* fullpercent   */
			"", /* kredittype    */
			(IF GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "Режим", "НевозЛиния") = "НевозЛиния" THEN "v" ELSE "z"), /* kreditlimtype */
			loan-cond.int-period, /* intpay        */
			"", /* firstpay      */
			"", /* firstper      */
			"no", /* vo            */
			"", /* eqcur         */
			"", /* eqdig         */
			""  /* eqsum         */

		)
	).



		/*  Информация по клиенту (заемщику) */

	/* Если заемщик - юридическое лицо */
	IF loan.cust-cat = "Ю" THEN
		DO:
		FIND FIRST cust-corp WHERE
			cust-corp.cust-id = loan.cust-id
		NO-LOCK NO-ERROR.

		IF AVAIL cust-corp THEN
			DO:
			PUT UNFORMATTED StrToWin_ULL(exp_debtor(
					"urik" ,
					replace(GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"FullName",""),chr(34),"``") , 
					"", /* nametp */
					GetXAttrValueEx("cust-corp" , string(cust-corp.cust-id) , "ФИОрук" , " "), /* agent */ 
					"", /* agentdocum , в данном случае: на основании доверенности (устава) */
					"", /* agentpasp */
					"", /* fldocum , в данном случае: паспорт представителя ЮЛ */
					"М", /* sex М/Ж*/
					"", /* birthday */
					"", /* birthplace */
					cust-corp.inn ,
					GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"ОГРН","") ,
					DelDoubleChars(cust-corp.addr-of-low[1] + " " + cust-corp.addr-of-low[2], ",") ,
					account ,
                                        GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"tel","") ,
					"yes"  /* garant_no */
					)
				).
			END.
		END.

	/* Если заемщик - физическое лицо */
	ELSE IF loan.cust-cat = "Ч" THEN
		DO:
		FIND FIRST person WHERE
			person.person-id = loan.cust-id
		NO-LOCK NO-ERROR.

		IF AVAIL person THEN
			DO:
			PUT UNFORMATTED StrToWin_ULL(exp_debtor(
					"fizik" ,
					person.name-last + " " + person.first-names,
					person.name-last + " " + person.first-names,
					"", /* agent */
					"", /* agentdocum */
					"", /* agentpasp */
					GetCodeName("КодДокум", person.document-id) + ": " + person.document + ", выдан " + replace(GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid",""), "/", ".") + " года " + person.issue ,
					(IF person.gender THEN "M" ELSE "F") , 
					STRING(person.birthday, "99/99/9999"), 
					GetXAttrValueEx("person",string(person.person-id),"birthplace","") ,
					person.inn ,
					GetXAttrValueEx("person",string(person.person-id),"ОГРН","") ,
					DelDoubleChars(person.address[1] + " " + person.address[2], ","),
					account ,
                                        person.phone[1] + " " + person.phone[2], 
					"yes"  /* garant_no */
					)
				).
			END.
		END.




		/*  Информация по залогодателю */
		/*  Оставлена заготовка на будущее */

	PUT UNFORMATTED
	 StrToWin_ULL(
		exp_garant(
			"", "", "", "",	"",
			"", "", "", "",	"",
			"", "", "", ""
		)
	).



		/*  Информация по договору залога */
		/*  Оставлена заготовка на будущее */

	PUT UNFORMATTED
	 StrToWin_ULL(
		exp_agr_garant(
			"", "", "", "",	"",
			"", "", "", "",	"",
			"", "", "", "",	"",
			"", "", "", "",	"",
			"", "", "", "",	"",
			"", ""
		)
	).

		

	/* END. */
	
END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
