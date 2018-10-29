{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pirexpcardproxy.p
      Comment: Экспорт данных в формате afx для МАСТЕРА ДОГОВОРОВ 
		по доверенности для ПК
   Parameters: Полное имя файла экспорта
         Uses:
      Created: Ситов С.А., 16.02.2012
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

DEF VAR usershortname AS CHAR NO-UNDO.

DEF VAR n 		AS INT  INIT 0  NO-UNDO .
DEF VAR card_list 	AS CHAR INIT "" NO-UNDO .
DEF VAR cardtype_list	AS CHAR INIT "" NO-UNDO .
DEF VAR agent-id 	AS INT  NO-UNDO. 

DEFINE BUFFER card FOR loan.


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
FIRST loan WHERE RECID(loan) = tmprecid.id 
	   AND loan.contract = "proxy"
	   AND loan.class-code = "proxy-pircard"
NO-LOCK:


	/** Открывающий тэг */	
	RUN Master_OutStr("<data>").



		/** ДОВЕРЕННОСТЬ */					
	
	/* Перечень карт по доверенности (из ДопРека)*/

	card_list = GetXattrValueEx("loan", string("proxy," + loan.cont-code), "loan-allowed", "") .

	DO n = 1 TO NUM-ENTRIES(card_list, ',') : 
	  IF ENTRY(n, card_list ,",") <> "" THEN
	     DO:
		FIND FIRST card WHERE card.doc-num = ENTRY(n, card_list,",") no-lock no-error.
		IF avail(card) THEN
			cardtype_list = cardtype_list + GetCodeName("КартыБанка", card.sec-code ) + "/" +  ENTRY(n, card_list,",") + "," .
	     END.
	END.

	RUN Master_OutStr("<proxy>").
	RUN Master_OutStr("num="	+ loan.doc-num  ).
	RUN Master_OutStr("status="	+ STRING(loan.loan-status)  ).
	RUN Master_OutStr("opendate="	+ STRING(loan.open-date, "99/99/9999")  ).
	RUN Master_OutStr("enddate="	+ STRING(loan.end-date, "99/99/9999")  ).
	RUN Master_OutStr("closedate="	+ ( IF loan.close-date <> ? THEN STRING(loan.close-date,"99/99/9999") ELSE "")  ).
	RUN Master_OutStr("cardandtype="+ cardtype_list ).
	RUN Master_OutStr("comment="	+ ""  ).
	RUN Master_OutStr("drcashinpk="	+ GetXattrValueEx("loan",STRING("proxy," + loan.cont-code), "pir-cashinpk", "") ).
	RUN Master_OutStr("drgetvip="	+ GetXattrValueEx("loan",STRING("proxy," + loan.cont-code), "pir-getvip", "")   ).
	RUN Master_OutStr("drgetpin="	+ GetXattrValueEx("loan",STRING("proxy," + loan.cont-code), "pir-getpin", "")   ).
	RUN Master_OutStr("drgetpk="	+ GetXattrValueEx("loan",STRING("proxy," + loan.cont-code), "pir-getpk", "")    ).
	RUN Master_OutStr("</proxy>").



		/** ДОВЕРЕННОЕ ЛИЦО */

	agent-id = INT(GetXattrValueEx("loan",STRING("proxy," + loan.cont-code), "agent-id", "")) .	

	FIND FIRST person WHERE person.person-id = agent-id NO-LOCK NO-ERROR.

	IF AVAIL person THEN
	  DO:

	  RUN Master_OutStr("<agent>").
	  RUN Master_OutStr("fio="	+ person.name-last + " " + person.first-names).  
	  RUN Master_OutStr("document="	+ person.document-id + ": " + person.document 
					+ ". Выдан: " + person.issue + " " 
					+ GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","")
					).
	  /* RUN Master_OutStr("document=" GetClientInfo_ULL("Ч," + STRING(person.person-id), "ident:Паспорт;ДокНерез", false) ). */
	  RUN Master_OutStr("addressoflow="	+ Master_Kladr(person.country-id + "," 
						+ GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ"),person.address[1] + person.address[2])
						).
	  RUN Master_OutStr("addressoflife="	+ Master_GetClntAddr(person.person-id,"Ч","АдрФакт") ).
	  RUN Master_OutStr("sex="	+ (IF person.gender THEN "M" ELSE "F")).  
	  RUN Master_OutStr("phone="	+ person.phone[1] + " " + person.phone[2] ).
	  RUN Master_OutStr("email="	+ GetXAttrValueEx("person", STRING(person.person-id),"e-mail","") ).
	  RUN Master_OutStr("birthday="	+ STRING(person.birthday, "99/99/9999") ).
	  RUN Master_OutStr("</agent>").

	  END.



		/** КЛИЕНТ - доверитель */

	FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.

	IF AVAIL person THEN
	  DO:

	  RUN Master_OutStr("<client>").
	  RUN Master_OutStr("fio="	+ person.name-last + " " + person.first-names).  
	  RUN Master_OutStr("document="	+ person.document-id + ": " + person.document 
					+ ". Выдан: " + person.issue + " " 
					+ GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","")
					).
	  /* RUN Master_OutStr("document=" GetClientInfo_ULL("Ч," + STRING(person.person-id), "ident:Паспорт;ДокНерез", false) ). */
	  RUN Master_OutStr("addressoflow="	+ Master_Kladr(person.country-id + "," 
						+ GetXAttrValue("person", STRING(person.person-id), "КодРегГНИ"),person.address[1] + person.address[2])
						).
	  RUN Master_OutStr("addressoflife="	+ Master_GetClntAddr(person.person-id,"Ч","АдрФакт") ).
	  RUN Master_OutStr("sex="	+ (IF person.gender THEN "M" ELSE "F")).  
	  RUN Master_OutStr("phone="	+ person.phone[1] + " " + person.phone[2] ).
	  RUN Master_OutStr("email="	+ GetXAttrValueEx("person", STRING(person.person-id),"e-mail","") ).
	  RUN Master_OutStr("birthday="	+ STRING(person.birthday, "99/99/9999") ).
	  RUN Master_OutStr("</client>").

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
	RUN Master_OutStr("procname=" + "pirexpcardproxy.p" ).
	RUN Master_OutStr("</expproc>").


	/** Завершающий тэг */					
	RUN Master_OutStr("</data>").

				
END.


OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
