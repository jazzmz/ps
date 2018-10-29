{pirsavelog.p}

/** 
		ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (с) 2011

		Экспорт данных в формате afx для доверенности по пластиковым картам
		
		Ситов С.А., 11.01.2011

		<Как_запускается> : Из броузера доверенностей на клиенте
		<Параметры запуска> : полное имя файла экспорта.
		<Как_работает> : Реализованы процедуры для экспорта каждой конструкции. После сбора 
						всей информации по выделеному в броузере договору эти процедуры вызываются с 
						соответсвующими параметрами.
		Изменено: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>)
		          <Описание изменения>
*/



FUNCTION cnv RETURNS CHARACTER (INPUT arg1 AS CHARACTER).

/* Вход: arg1:строка
** Выход: строка в кодировке windows-1251
*/
	RETURN CODEPAGE-CONVERT(arg1,"1251",SESSION:CHARSET).

END FUNCTION.


FUNCTION expcli RETURNS CHARACTER (INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
                                   INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
                                   INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
                                   INPUT arg7 AS CHAR, INPUT arg8 AS CHAR
                                   ).

	DEFINE VARIABLE construction AS CHARACTER.
	
	construction = 				  "<client>" + CHR(13) + CHR(10).
	construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "document=" + arg2 + CHR(13) + CHR(10).	
	construction = construction + "addressreg=" + arg3 + CHR(13) + CHR(10).
	construction = construction + "addressfact=" + arg4 + CHR(13) + CHR(10).
	construction = construction + "birthday=" + arg5 + CHR(13) + CHR(10).
	construction = construction + "phone=" + arg6 + CHR(13) + CHR(10).
	construction = construction + "email=" + arg7 + CHR(13) + CHR(10).
	construction = construction + "cardnum=" + arg8 + CHR(13) + CHR(10).
	construction = construction + "</client>" + CHR(13) + CHR(10).

	RETURN construction.

END FUNCTION.

FUNCTION expagent RETURNS CHARACTER (INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
                                   INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
                                   INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
                                   INPUT arg7 AS CHAR 
                                   ).

	DEFINE VARIABLE construction AS CHARACTER.
	
	construction = 				  "<agent>" + CHR(13) + CHR(10).
	construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "document=" + arg2 + CHR(13) + CHR(10).	
	construction = construction + "addressreg=" + arg3 + CHR(13) + CHR(10).
	construction = construction + "addressfact=" + arg4 + CHR(13) + CHR(10).
	construction = construction + "birthday=" + arg5 + CHR(13) + CHR(10).
	construction = construction + "phone=" + arg6 + CHR(13) + CHR(10).
	construction = construction + "email=" + arg7 + CHR(13) + CHR(10).
	construction = construction + "</agent>" + CHR(13) + CHR(10).

	RETURN construction.

END FUNCTION.

FUNCTION expproxy RETURNS CHARACTER (INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
                                   INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
                                   INPUT arg5 AS CHAR, INPUT arg6 AS CHAR,
                                   INPUT arg7 AS CHAR, INPUT arg8 AS CHAR,
                                   INPUT arg9 AS CHAR, INPUT arg10 AS CHAR,
                                   INPUT arg11 AS CHAR 
                                   ).

	DEFINE VARIABLE construction AS CHARACTER.
	
	construction = 				  "<proxy>" + CHR(13) + CHR(10).
	construction = construction + "num=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "status=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "opendate=" + arg3 + CHR(13) + CHR(10).
	construction = construction + "enddate=" + arg4 + CHR(13) + CHR(10).
	construction = construction + "closedate=" + arg5 + CHR(13) + CHR(10).
	construction = construction + "allowed=" + arg6 + CHR(13) + CHR(10).
	construction = construction + "comment=" + arg7 + CHR(13) + CHR(10).
	construction = construction + "drcashinpk=" + arg8 + CHR(13) + CHR(10).
	construction = construction + "drgetvip=" + arg9 + CHR(13) + CHR(10).
	construction = construction + "drgetpin=" + arg10 + CHR(13) + CHR(10).
	construction = construction + "drgetpk=" + arg11 + CHR(13) + CHR(10).		

	construction = construction + "</proxy>" + CHR(13) + CHR(10).

	RETURN construction.

END FUNCTION.


/********************************************************************** VARS */

	/* Глобальные определения */
{globals.i}
{ulib.i}
{intrface.get strng}
{tmprecid.def}        /** Используем информацию из броузера */

	/* Входные параметры процедуры */
DEF INPUT PARAM iParam AS CHAR.

	/* Первый параметр */
DEF VAR out_file_name AS CHAR. 
DEF VAR agent-id AS INT NO-UNDO. 
DEF VAR n AS INT INIT 0 NO-UNDO .
DEF VAR allowed AS CHAR NO-UNDO .
DEF VAR loan-allowed AS CHAR INIT "" NO-UNDO .

DEFINE BUFFER cardloan FOR loan.


IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/sitov/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED cnv("<data>" + CHR(13) + CHR(10)).

	/* Для первой довереености, выбранной в браузере выполняем... */
  	
FOR FIRST tmprecid NO-LOCK,
    	FIRST loan WHERE RECID(loan) = tmprecid.id 
		AND loan.contract = "proxy"
		AND loan.class-code = "proxy-pircard"
		NO-LOCK:


	/* Информация по доверенности */

	/* Определяем типы и номера пластиковых карт */
	allowed = GetXattrValueEx("loan", string("proxy," + loan.cont-code), "loan-allowed", "") .
	DO n = 1 TO num-entries(allowed, ',') : 
		IF entry(n , allowed ,",") <> "" THEN
		  DO:
			FIND FIRST cardloan WHERE cardloan.doc-num = entry(n , allowed ,",") no-lock no-error.
			   IF avail(cardloan)THEN
				loan-allowed = loan-allowed + GetCodeName("КартыБанка", cardloan.sec-code ) + "/" +  entry(n , allowed ,",") + "," .
		  END.
	END.


	PUT UNFORMATTED cnv(expproxy(loan.doc-num,
							string(loan.loan-status) ,
							string(loan.open-date, "99/99/9999") ,
							string(loan.end-date, "99/99/9999")  ,
							( if loan.close-date <> ? then string(loan.close-date, "99/99/9999")  else ""  ) ,				
							loan-allowed ,
							/* GetXattrValueEx("loan",string("proxy," + loan.cont-code), "loan-allowed", "") ,*/
							"" ,				
							GetXattrValueEx("loan",string("proxy," + loan.cont-code), "pir-cashinpk", "") ,
							GetXattrValueEx("loan",string("proxy," + loan.cont-code), "pir-getvip", "") ,
							GetXattrValueEx("loan",string("proxy," + loan.cont-code), "pir-getpin", "") ,
							GetXattrValueEx("loan",string("proxy," + loan.cont-code), "pir-getpk", "") 							
							)
							).					

	
	/* Информация по клиенту */
	FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.
		IF AVAIL person THEN
			DO:
				PUT UNFORMATTED cnv(expcli(person.name-last + " " + person.first-names,
							GetClientInfo_ULL("Ч," + STRING(person.person-id), "ident:Паспорт;ДокНерез", false),						
							DelDoubleChars(person.address[1] + " " + person.address[2],","), 
							DelDoubleChars(GetClientInfo_ULL("Ч," + STRING(person.person-id), "addr:АдрФакт", false), ","),
							STRING(person.birthday, "99/99/9999"),
							person.phone[1] + " " + person.phone[2],
							GetXAttrValueEx("person", STRING(person.person-id),"e-mail",""),
							""
							)
							).
			END.
	
	/* Информация по доверенному лицу */
	agent-id = int(GetXattrValueEx("loan",string("proxy," + loan.cont-code), "agent-id", "")) .	
	FIND FIRST person WHERE person.person-id = agent-id NO-LOCK NO-ERROR.
		IF AVAIL person THEN
			DO:
				PUT UNFORMATTED cnv(expagent(person.name-last + " " + person.first-names,
							GetClientInfo_ULL("Ч," + STRING(person.person-id), "ident:Паспорт;ДокНерез", false),
							DelDoubleChars(person.address[1] + " " + person.address[2],","), 
							DelDoubleChars(GetClientInfo_ULL("Ч," + STRING(person.person-id), "addr:АдрФакт", false), ","),
							STRING(person.birthday, "99/99/9999"),
							person.phone[1] + " " + person.phone[2],
							GetXAttrValueEx("person", STRING(person.person-id),"e-mail","")
							)
							).				
			END.		
			
			
				
END.

PUT UNFORMATTED cnv("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.
