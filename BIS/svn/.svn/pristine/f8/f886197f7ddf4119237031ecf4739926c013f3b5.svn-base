{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pirexpcredzal.p
      Comment: Экспорт данных в формате afx для МАСТЕРА ДОГОВОРОВ 
		по кред.договорам (ЮрЛ и ФизЛ)
   Parameters: Полное имя файла экспорта
         Uses:
      Created: Ситов С.А., 08.02.2012 
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
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

DEF VAR account AS CHAR.
DEF VAR account455 AS CHAR.
DEF VAR account91317 AS CHAR.
DEF VAR summa AS DECIMAL. 
DEF VAR rate AS DECIMAL.
DEF VAR rate_type AS CHAR.
DEF VAR firstpayloandate AS DATE.
DEF VAR firstpayratedate AS DATE.
DEF VAR cT AS CHAR.
DEF VAR addrfakt AS CHAR.

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
NO-LOCK,
FIRST loan-acct OF loan WHERE loan-acct.acct-type = "Кредит" 
NO-LOCK: 


	/** Открывающий тэг */	
	RUN Master_OutStr("<data>").


		/** КРЕДИТНЫЙ ДОГОВОР */

	RUN Master_OutStr("<agreement>").
	RUN Master_OutStr("number="		+ loan.cont-code).
	RUN Master_OutStr("open_date="		+ STRING(loan.open-date, "99/99/9999")).
	RUN Master_OutStr("end_date="		+ STRING(loan.end-date,  "99/99/9999")).
	RUN Master_OutStr("currency="		+ (if loan.currency = "" then "810" else loan.currency)).

	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	RUN Master_OutStr("summa="		+ STRING(summa)).

	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%Кред", loan.open-date, false, rate_type).
	RUN Master_OutStr("rate="		+ STRING(rate)).

	RUN Master_OutStr("firstpayratedate="	+ STRING(LastMonDate(loan.open-date), "99/99/9999")).
	RUN Master_OutStr("firstpayloandate="	+ STRING(LastMonDate(GoMonth(loan.open-date, 1)), "99/99/9999")).
	RUN Master_OutStr("rate_kind="		+ "fix").  
	RUN Master_OutStr("intpay="		+ loan-cond.int-period).  
	RUN Master_OutStr("intnextpaym="	+ (IF loan-cond.int-date = 31 THEN "tail" ELSE "every")).  
	RUN Master_OutStr("intpaydaym="	+ STRING(loan-cond.int-date)).  
	RUN Master_OutStr("intnextpayk="	+ (IF loan-cond.int-date = 31 THEN "tail" ELSE "every")).  
	RUN Master_OutStr("intpaydayk="	+ STRING(loan-cond.int-date)).  
	RUN Master_OutStr("pena_canfast_need="	+ "notneed").  
	RUN Master_OutStr("countmonth="	+ STRING(ROUND(MonInPer(loan.open-date, loan.end-date),0))).  
	RUN Master_OutStr("safe_need="		+ "notneed").  
	RUN Master_OutStr("guaranty_need="	+ (IF CAN-FIND(FIRST term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
					AND term-obl.class-code = "term-obl-gar") THEN "need" ELSE "notneed")
					).  
	RUN Master_OutStr("</agreement>").



		/** КЛИЕНТ */

	IF loan.cust-cat = "Ч" THEN
	  DO:
		FIND FIRST person WHERE
				person.person-id = loan.cust-id
		NO-LOCK NO-ERROR.

		IF AVAIL person THEN
		  DO:
			RUN Master_OutStr("<client>").

			RUN Master_OutStr("namecl="	+ person.name-last + " " + person.first-names).  
			RUN Master_OutStr("document="	+ person.document-id + ": " + person.document 
						+ ". Выдан: " + person.issue + " " 
						+ GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","")
						).
			RUN Master_OutStr("addressoflow="	+ Master_Kladr(person.country-id + "," 
							+ GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ"),person.address[1] + person.address[2])
							).  
			RUN Master_OutStr("addressoflife="	+ Master_GetClntAddr(person.person-id,"Ч","АдрФакт") ).

			RUN Master_OutStr("sex="	+ (IF person.gender THEN "M" ELSE "F")).  

			account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредРасч', loan.open-date, false).
			RUN Master_OutStr("acct="	+ account).  

			account455 = loan-acct.acct.
			RUN Master_OutStr("acct455="	+ account455).  

			account91317 = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'КредН', loan.open-date, false).
			RUN Master_OutStr("acct91317="	+ account91317).  

			RUN Master_OutStr("</client>").
		  END.
	  END.
	ELSE
	  DO:
		/* Сделать для клиента ЮЛ */
		MESSAGE "Счет не принадлежит частному лицу!" VIEW-AS ALERT-BOX.
		RETURN.
	  END.


		
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
	RUN Master_OutStr("procname=" + "pirexpcredfizall.p" ).
	RUN Master_OutStr("</expproc>").


	/** Завершающий тэг */					
	RUN Master_OutStr("</data>").

END.


OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
