{pirsavelog.p}

/*
		Процедура экспорта данных для мастера подготовки документов
		Бурягин Е.П., 20.01.2006 14:29
*/


FUNCTION cnv RETURNS CHARACTER (INPUT arg1 AS CHARACTER).

/* Вход: arg1:строка
** Выход: строка в кодировке windows-1251
*/
	RETURN CODEPAGE-CONVERT(arg1,"1251",SESSION:CHARSET).

END FUNCTION.

FUNCTION expagr RETURNS CHARACTER (INPUT arg1 AS CHAR,INPUT arg2 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER  NO-UNDO.

	construction =                "<agreement>" + CHR(13) + CHR(10).
	construction = construction + "no=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "date=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "</agreement>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.

FUNCTION expacct RETURNS CHARACTER (INPUT arg1 AS CHARACTER, INPUT arg2 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER NO-UNDO.

	construction =                "<acct>" + CHR(13) + CHR(10).
	construction = construction + "no=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "cur=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "</acct>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.

FUNCTION expcli RETURNS CHARACTER (INPUT arg1 AS CHAR,
                                    INPUT arg2 AS CHAR,
                                    INPUT arg3 AS CHAR,
                                    INPUT arg4 AS CHAR,
                                    INPUT arg5 AS CHAR,
                                    INPUT arg6 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER NO-UNDO.
	DEF VAR tmp AS CHAR NO-UNDO.
	DEF VAR i AS INTEGER NO-UNDO.
	
	construction = 				  "<client>" + CHR(13) + CHR(10).
	construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
	DO i = 1 TO NUM-ENTRIES(arg2) :
		IF TRIM(ENTRY(i, arg2)) <> "" THEN
			DO:
				tmp = tmp + ENTRY(i, arg2).
				IF i < NUM-ENTRIES(arg2) THEN
					tmp = tmp + ",".
			END.
	END.			
	construction = construction + "address=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "document=" + arg3 + CHR(13) + CHR(10).
	construction = construction + "phone=" + arg4 + CHR(13) + CHR(10).
	construction = construction + "birthday=" + arg5 + CHR(13) + CHR(10).
	construction = construction + "address2=" + arg6 + CHR(13) + CHR(10).
	construction = construction + "</client>" + CHR(13) + CHR(10).

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
DEF VAR out_file_name AS CHAR NO-UNDO. 
/* Признак найденной даты договора */
DEF VAR found_date AS LOGICAL INITIAL false NO-UNDO.
DEF VAR agr_no AS CHAR NO-UNDO.
DEF VAR agr_day AS INTEGER NO-UNDO.
DEF VAR agr_month AS INTEGER NO-UNDO.
DEF VAR agr_month_str AS CHAR NO-UNDO.
DEF VAR agr_year AS INTEGER NO-UNDO.
DEF VAR acct_client_name AS CHAR NO-UNDO.
DEF VAR acct_no AS CHAR NO-UNDO.
DEF VAR acct_client_address AS CHAR NO-UNDO.
DEF VAR acct_client_document AS CHAR NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpStr2 AS CHAR NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/buryagin/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED cnv("<data>" + CHR(13) + CHR(10)).

/* Для первого счета, выбранного в брoузере выполняем... */
FOR FIRST tmprecid 
         NO-LOCK,
   FIRST acct WHERE 
         RECID(acct) EQ tmprecid.id 
         NO-LOCK 
: 
	/* Дата договора */
	tmpStr = GetXAttrValueEx("acct", (acct.acct + "," + acct.currency), "ДогОткрЛС","").
/** Buryagin commented at 23.04.2007 12:33 
	IF tmpStr = "" THEN
		tmpStr = GetXAttrValueEx("acct", (acct.acct + "," + acct.currency), "Прим3","").
	found_date = false.
	DO i = 1 TO NUM-ENTRIES(tmpStr," ") :
		IF NUM-ENTRIES(ENTRY(i,tmpStr," "),"/") = 3 OR
		   NUM-ENTRIES(ENTRY(i,tmpStr," "),".") = 3
		THEN
			DO:
				IF i = 1 THEN
					agr_no = ENTRY(i, tmpStr, " ").
				tmpStr2 = ENTRY(i,tmpStr," ").
				found_date = true.
			END.
	END.
	IF found_date = false THEN 
		MESSAGE "Программе не удалось найти дату договора ни в одном из доп.реквизитов счета 'Книга рег:дата и номер дог. об откр.','Примечание 3'!" 
			VIEW-AS ALERT-BOX.
	tmpStr = tmpStr2.
	IF NUM-ENTRIES(tmpStr, "/") = 3 THEN
		DO:
			agr_day = INTEGER(ENTRY(1,tmpStr,"/")).
			agr_month = INTEGER(ENTRY(2,tmpStr,"/")).
			agr_year = INTEGER(ENTRY(3,tmpStr,"/")).					
		END.
	IF NUM-ENTRIES(tmpStr, ".") = 3 THEN
		DO:
			agr_day = INTEGER(ENTRY(1,tmpStr,".")).
			agr_month = INTEGER(ENTRY(2,tmpStr,".")).
			agr_year = INTEGER(ENTRY(3,tmpStr,".")).					
		END.
	IF agr_year < 100 THEN
		IF agr_year > 80 THEN
			agr_year = agr_year + 1900.
		ELSE
			agr_year = agr_year + 2000.
	PUT UNFORMATTED cnv(expagr(agr_no, STRING(agr_day) + "/" + STRING(agr_month) + "/" + STRING(agr_year))).
*/

/** Buryagin added at 23.04.2007 12:34 */  
 	IF NUM-ENTRIES(tmpStr) = 2 THEN
  	DO:
  		PUT UNFORMATTED cnv(expagr(ENTRY(2,tmpStr), ENTRY(1,tmpStr))).
  	END.
  ELSE
    DO:
    	MESSAGE "Проверте правильность заполнения доп.реквизита 'Книга рег:дата и номер дог. об откр.' и соответствие значения его формату" VIEW-AS ALERT-BOX.
    	RETURN.
    END.
  	
	PUT UNFORMATTED cnv(expacct(acct.acct, (IF acct.currency = "" THEN "810" ELSE acct.currency))).
	/* Информация по клиенту */
	IF acct.cust-cat = "Ч" THEN
		DO:
			FIND FIRST person WHERE
				person.person-id = acct.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL person THEN
				DO:
					PUT UNFORMATTED cnv(expcli(person.name-last + " " + person.first-names,
							DelDoubleChars(person.address[1] + " " + person.address[2],","), 
							GetClientInfo_ULL("Ч," + STRING(person.person-id), "ident:Паспорт;ДокНерез", false),
/**
							person.document-id + ": " +	person.document + ". Выдан: " + REPLACE(REPLACE(person.issue, CHR(10), ""), CHR(13), "") + " " +
							GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid",""),
*/
							person.phone[1] + " " + person.phone[2],
							STRING(person.birthday, "99/99/9999"),
							DelDoubleChars(GetClientInfo_ULL("Ч," + STRING(person.person-id), "addr:АдрФакт", false), ",")
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

PUT UNFORMATTED cnv("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "Данные успешно экспортированы!" VIEW-AS ALERT-BOX.