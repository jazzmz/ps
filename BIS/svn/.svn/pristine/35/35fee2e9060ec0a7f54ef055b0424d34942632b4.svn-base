{pirsavelog.p}

/*          
    Copyright: (C) ОАО КБ "Пpоминвестрасчет" , Управление автоматизации
     Filename: pir-closelistul.p
      Comment: Обходной лист для заркытия клиента ЮЛ 
		Запускается из браузера клиентов (ЮЛ)
      Used by:
      Created: 12.01.2011 - Ситов С.А.
*/


{globals.i}		/** Глобальные определения */
{ulib.i}		/** Библиотека моих собственных функций */
{tmprecid.def}		/** Используем информацию из броузера */
{intrface.get strng}


DEF VAR classname AS CHAR init "" NO-UNDO.
DEF VAR username AS CHAR init "" NO-UNDO.

{setdest.i}

                                               	
FOR FIRST tmprecid NO-LOCK,   
	FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK:

/*  PUT UNFORM "ID-Клиентa:" cust-corp.cust-id SKIP .*/
  IF cust-corp.cust-stat = "ИП" THEN
	 PUT UNFORM "Индивидуальный предприниматель " replace(cust-corp.name-corp,chr(34),"``") SKIP.
  ELSE   PUT UNFORM replace(GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"FullName",""),chr(34),"``") SKIP .
  PUT UNFORM "ИНН " cust-corp.inn "  ОГРН " GetXAttrValueEx("cust-corp",string(cust-corp.cust-id),"ОГРН","") SKIP .
  PUT UNFORM "Адрес юридический: " cust-corp.addr-of-low[1] SKIP .
  PUT UNFORM "Адрес почтовый: " cust-corp.addr-of-post[1] SKIP .
  PUT UNFORM "" SKIP(3) .




  PUT UNFORM "			Cчета клиента: " SKIP .
  PUT UNFORM "" SKIP(1) .

  FOR EACH acct WHERE acct.cust-id = cust-corp.cust-id 
	AND acct.close-date = ? 
	AND acct.cust-cat = 'Ю' NO-LOCK:

	IF avail(acct) THEN
	  DO:
		FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK NO-ERROR.
		PUT UNFORM acct.acct 
		  "    Ответственный: " GetXAttrValueEx ("_user", _user._userid, "group-id", "_____ " ) FORMAT "X(6)"  " "  FIOShort_ULL( _user._user-name, false)  FORMAT "X(20)"
		  " Дата: _______  Подпись _______"  
		SKIP(1) .		
	  END.

  END.

  PUT UNFORM "" SKIP(3) .
  PUT UNFORM "			Договоры клиента: " SKIP .
  PUT UNFORM "" SKIP(1) .

  FOR EACH loan WHERE loan.cust-id = cust-corp.cust-id 
	AND NOT( loan.class-code = "loan-tran-lin" OR loan.class-code begins("proxy") )
	AND (loan.close-date = ? OR ( loan.class-code = "pir_l_save" AND loan.close-date > today) )
	AND loan.loan-status <> "Завершен" 
	AND loan.cust-cat = 'Ю'
 	 NO-LOCK:  

	IF avail(loan) THEN
	  DO:

		FIND FIRST _user WHERE _user._userid = loan.user-id NO-LOCK NO-ERROR.

		FIND FIRST class WHERE class.class-code = loan.class-code NO-LOCK NO-ERROR.			
			if avail(class) then classname =  class.name.

		IF loan.class-code = "axd-sf" OR loan.class-code = "card" THEN 
			PUT UNFORM classname FORMAT "X(37)"  " " string(loan.doc-num +  " " + loan.loan-status) FORMAT "X(18)" . 

		IF loan.class-code = "pir_l_save" AND loan.close-date <> ? THEN 
			PUT UNFORM "Дог.сейф.ячейки  " string(loan.doc-ref +  "  " + loan.loan-status) FORMAT "X(19)" " оконоч-но: " loan.close-date . 

		IF NOT( CAN-DO("axd-sf,card",loan.class-code)  OR ( loan.class-code = "pir_l_save" AND loan.close-date <> ? )) THEN
			PUT UNFORM classname FORMAT "X(37)"  " " loan.cont-code FORMAT "X(20)" .

		IF num-entries(_user._user-name," " ) >= 2 THEN 
				username = FIOShort_ULL( _user._user-name, false) .
		ELSE username = _user._user-name .

		PUT UNFORM 
		  	"   Ответственный: " GetXAttrValueEx ("_user", _user._userid, "group-id", "_____ " ) FORMAT "X(5)"  " "  _user._user-name  FORMAT "X(20)"
		SKIP(1).
		PUT UNFORM 
		  FILL(" ",66) " Дата: _______  Подпись _______"  
		SKIP(1) .		

	  END.

  END.



END.

{preview.i}


