{pirsavelog.p}

/*          
    Copyright: (C) ОАО КБ "Пpоминвестрасчет" , Управление автоматизации
     Filename: pir-closelistfl.p
      Comment: Обходной лист для заркытия клиента ФЛ 
		Запускается из браузера клиентов (ФЛ)
      Used by:
      Created: 11.01.2011 - Ситов С.А.
*/


{globals.i}		/** Глобальные определения */
{ulib.i}		/** Библиотека моих собственных функций */
{tmprecid.def}		/** Используем информацию из броузера */
{intrface.get strng}


DEF VAR classname AS CHAR init "" NO-UNDO.
DEF VAR username  AS CHAR init "" NO-UNDO.


{setdest.i}

                                               	
FOR FIRST tmprecid NO-LOCK,   
	FIRST person WHERE RECID(person) = tmprecid.id NO-LOCK:

/*  PUT UNFORM "ID-Клиентa:" person.person-id SKIP .*/

  PUT UNFORM "" SKIP(2) .
  PUT UNFORM "Клиент: " person.name-last " " person.first-name SKIP .
  PUT UNFORM "Дата рождения: " person.birthday FORMAt ("99/99/9999") SKIP .
  PUT UNFORM  GetClientInfo_ULL("Ч," + STRING(person.person-id), "ident:Паспорт;ДокНерез", false) SKIP.
  PUT UNFORM "Адрес юридический: " DelDoubleChars(person.address[1] + " " + person.address[2],",") SKIP .
  PUT UNFORM "Адрес фактический: " DelDoubleChars(GetClientInfo_ULL("Ч," + STRING(person.person-id), "addr:АдрФакт", false), ",") SKIP .
  PUT UNFORM "" SKIP(3) .




  PUT UNFORM "			Счета клиента: " SKIP .
  PUT UNFORM "" SKIP(1) .

  FOR EACH acct WHERE acct.cust-id = person.person-id 
	AND acct.close-date = ? 
	AND acct.cust-cat = 'Ч' NO-LOCK:

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

  FOR EACH loan WHERE loan.cust-id = person.person-id 
	AND NOT( loan.class-code = "loan_trans_ov" OR loan.class-code begins("proxy") )
	AND (loan.close-date = ? OR ( loan.class-code = "pir_l_save" AND loan.close-date > today) )
	AND loan.loan-status <> "Завершен"
	AND loan.cust-cat = 'Ч'
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
		  	"   Ответственный: " GetXAttrValueEx ("_user", _user._userid, "group-id", "_____ " ) FORMAT "X(5)"  " "  username FORMAT "X(20)" 
		SKIP(1).
		PUT UNFORM 
		  FILL(" ",66) " Дата: _______  Подпись _______"  
		SKIP(1) .		

	  END.

  END.



END.

{preview.i}


