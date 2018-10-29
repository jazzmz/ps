{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2010
     Filename: pirexpcredgarant.p
      Comment: Экспорт данных в формате afx для МАСТЕРА ДОГОВОРОВ 
		по Договорам поручительства (ФЛ и ЮЛ). 
   Parameters: Полное имя файла экспорта
   Parameters: 
       Launch: КиД - Активы - Картотека кредитных договоров - на договоре Ctrl+G - МАСТЕР ДОГОВОРОВ - ПИР: Эксп. Дог. поручительства
         Uses:
      Created: Sitov S.A., 07.02.2011
	Basis: -
     Modified: Sitov S.A., 12.03.2012, Изменение типовых форм договоров. 
*/
/* ========================================================================= */




{globals.i}		/** Глобальные определения */
{tmprecid.def}		/** Подключение возможности использовать информацию броузера */
{intrface.get strng}
{ulib.i}		/** Библиотека ПИР-функций */
{pir_expmaster.fun}     /** Библиотека функций для Мастера */




/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

  /* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

  /* Первый параметр */
DEF VAR out_file_name AS CHAR. 

DEF VAR account	  AS CHAR NO-UNDO.
DEF VAR summa 	  AS DECIMAL NO-UNDO. 
DEF VAR rate      AS DECIMAL NO-UNDO.
DEF VAR rate_type AS CHAR NO-UNDO.
DEF VAR clienttype	  AS CHAR NO-UNDO.
DEF VAR clientname	  AS CHAR NO-UNDO.
DEF VAR clientaddress	  AS CHAR NO-UNDO.
DEF VAR clientaddressoflife  AS CHAR NO-UNDO.
DEF VAR clientogrn	  AS CHAR NO-UNDO.

DEF VAR cKlP	  AS CHAR INIT "" NO-UNDO.

DEF VAR usershortname AS CHAR NO-UNDO.



/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */


IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/ssitov/tmp/new_data.afx".


  /** Задаем вывод в файл */		
OUTPUT TO VALUE(out_file_name).

FOR FIRST tmprecid 
NO-LOCK,
FIRST loan WHERE RECID(loan) EQ tmprecid.id 
NO-LOCK,
FIRST loan-cond WHERE loan-cond.contract = loan.contract 
		AND loan-cond.cont-code = loan.cont-code 
NO-LOCK: 


	/** Открывающий тэг */	
	RUN Master_OutStr("<data>").


		/** КРЕДИТНЫЙ ДОГОВОР */

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	
	   /* Если заемщик - юридическое лицо */
	IF loan.cust-cat = "Ю" THEN
	    DO:
		FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
		IF AVAIL cust-corp THEN
		  DO:
		    clienttype = "Ю" .  

		    IF cust-corp.cust-stat = "ИП" THEN 
			clientname = cust-corp.name-corp .
		    ELSE  
			clientname = GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"FullName","")  .

		    clientaddress = Master_GetClntAddr(cust-corp.cust-id,"Ю","АдрЮр") .
		    clientaddressoflife = Master_GetClntAddr(cust-corp.cust-id,"Ю","АдрФакт") .

		    clientogrn = GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"ОГРН","") .

		  END.
	    END.

	  /* Если заемщик - физическое лицо */
	ELSE IF loan.cust-cat = "Ч" THEN
	    DO:
		FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.
		IF AVAIL person THEN
		  DO:
		    clienttype = "Ч" .
		    clientname = person.name-last + " " + person.first-names
		    		+ " (" + person.document-id + ": " +	person.document + ". Выдан: " + person.issue 
		    		+ " " + GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","") + ")" .
		    clientaddress = Master_Kladr(person.country-id + "," 
				+ GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ"),person.address[1] + person.address[2]) .
		    clientaddressoflife = Master_GetClntAddr(person.person-id,"Ч","АдрФакт") .
		    clientogrn = GetXAttrValueEx("person",string(person.person-id),"ОГРН","") .	
		  END.
	    END.


	RUN Master_OutStr("<agreement>").
	RUN Master_OutStr("clienttype="	+ clienttype ).
	RUN Master_OutStr("clientname="	+ clientname ).
	RUN Master_OutStr("clientaddress=" + clientaddress ).
	RUN Master_OutStr("clientaddressoflife=" + clientaddressoflife ).
	RUN Master_OutStr("clientogrn="	+ clientogrn ).
	RUN Master_OutStr("number="	+ loan.cont-code ) . 	
	RUN Master_OutStr("open_date="	+ STRING(loan.open-date,"99/99/9999") ).
	RUN Master_OutStr("end_date=" 	+ STRING(loan.end-date,"99/99/9999") ).
	RUN Master_OutStr("summa=" 	+ STRING(summa) ).
	RUN Master_OutStr("currency=" 	+ (if loan.currency = "" then "810" else loan.currency) ).
	RUN Master_OutStr("rate="	+ STRING(rate) ).	
	RUN Master_OutStr("</agreement>").




		/** ДОГОВОР ПОРУЧИТЕЛЬСТВА - возможно будет заполняться из Бисквита */

	RUN Master_OutStr("<grtagreement>").
	RUN Master_OutStr("number="	+ "" ) . 
	RUN Master_OutStr("open_date="	+ "" ).
	RUN Master_OutStr("mustpen_rate=" + "" ).
	RUN Master_OutStr("</grtagreement>").



		/** ПОРУЧИТЕЛЬ - возможно будет заполняться из Бисквита */

	RUN Master_OutStr("<guarantor>").
	RUN Master_OutStr("name="	+ "" ).
	RUN Master_OutStr("agent="     	+ "" ).
	RUN Master_OutStr("agentorder="	+ "" ).
	RUN Master_OutStr("address=" 	+ "" ).
	RUN Master_OutStr("addressoflife=" + "" ).
	RUN Master_OutStr("docum="     	+ "" ).
	RUN Master_OutStr("ogrn="	+ "" ).
	RUN Master_OutStr("inn=" 	+ "" ).
	RUN Master_OutStr("tel=" 	+ "" ).
	RUN Master_OutStr("acct="	+ "" ).
	RUN Master_OutStr("bankname=" 	+ "" ).
	RUN Master_OutStr("bankbic=" 	+ "" ).
	RUN Master_OutStr("bankacct=" 	+ "" ).
	RUN Master_OutStr("</guarantor>").



		/** Договор банковского счета - возможно будет заполняться из Бисквита */

	RUN Master_OutStr("<bankacctagreement>").
	RUN Master_OutStr("number="	+ "" ).
	RUN Master_OutStr("open_date="	+ "" ).
	RUN Master_OutStr("</bankacctagreement>").



		/** Дополнительноt соглашениt к Договору банковского счета - возможно будет заполняться из Бисквита */

	RUN Master_OutStr("<dopsbnkactagreement>").
	RUN Master_OutStr("number=" 	+ "" ).
	RUN Master_OutStr("open_date="	+ "" ).
	RUN Master_OutStr("period=" 	+ "" ).
	RUN Master_OutStr("summa=" 	+ "" ).
	RUN Master_OutStr("currency=" 	+ "" ).
	RUN Master_OutStr("rate=" 	+ "" ).
	RUN Master_OutStr("</dopsbnkactagreement>").




		/** ПОЛЬЗОВАТЕЛЬ */					

	RUN Master_OutStr("<user>").

	FIND FIRST _user WHERE _user._userid = LC(userid("bisquit")) NO-LOCK NO-ERROR.
	RUN Master_OutStr("username=" + _user._user-name).

	usershortname = GetEntries(1,_user._user-name," ","") + " " +
			SUBSTRING(GetEntries(2,_user._user-name," ",""),1,1) + "." +
			SUBSTRING(GetEntries(3,_user._user-name," ",""),1,1) + "." .
	RUN Master_OutStr("usershortname=" + usershortname ).

	RUN Master_OutStr("userpost=" + GetXAttrValueEx("_user", _user._userid, "Должность", "") ).
	RUN Master_OutStr("</user>").



		/** ПРОЦЕДУРА ВЫГРУЗКИ */					

	RUN Master_OutStr("<expproc>").
	RUN Master_OutStr("procname=" + "pirexpcredgarant.p" ).
	RUN Master_OutStr("</expproc>").


	/** Завершающий тэг */					
	RUN Master_OutStr("</data>").

END. /* END_FOR */


OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
