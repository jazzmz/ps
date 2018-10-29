{pirsavelog.p}
/*
		Печать договора открытия счета
		Бурягин Е.П., 18.01.2006 15:42
		
		Шаблон договора находится в файле, 
		имя которого передается в процедуру как параметр
*/
/* Глобальные определения */
{globals.i}

/* Перенос слов */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */
{setdest.i}

/* Параметры процедуры */
DEF INPUT PARAMETER iParam AS CHAR.

/* Месяца */
DEF VAR months AS CHAR NO-UNDO 
	INITIAL "января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря".
/* Переменные отчета */
DEF VAR agr_day AS INTEGER NO-UNDO.
DEF VAR agr_month AS INTEGER NO-UNDO.
DEF VAR agr_month_str AS CHAR NO-UNDO.
DEF VAR agr_year AS INTEGER NO-UNDO.
DEF VAR acct_client_name AS CHAR NO-UNDO.
DEF VAR acct_no AS CHAR NO-UNDO.
DEF VAR acct_client_address AS CHAR NO-UNDO.
DEF VAR acct_client_address_arr AS CHAR EXTENT 4 NO-UNDO.
DEF VAR acct_client_document AS CHAR NO-UNDO.
DEF VAR acct_client_document_arr AS CHAR EXTENT 4 NO-UNDO.

/* Спец.символ обозначающий границы дескриптора */
DEF VAR dc AS CHAR NO-UNDO.
dc = CHR(123).

/* Если дата договора найдена, то это истина */
DEF VAR found_date AS LOGICAL INITIAL false NO-UNDO.
/* Итератор */
DEF VAR i AS INTEGER NO-UNDO.
/* Выражение, Дескриптор, Формат */
DEF VAR expr AS CHAR NO-UNDO.
DEF VAR descriptor AS CHAR NO-UNDO.
DEF VAR desc_index AS INTEGER NO-UNDO.
DEF VAR d_format AS INTEGER NO-UNDO.
/* Имя файла шаблона: 1-ый параметр */
DEF VAR tpl_file_name AS CHAR NO-UNDO.
/* Переменная для разных нужд */
DEF VAR tmpStr AS CHAR NO-UNDO.
/* Текст шаблона */
/* DEF VAR tpl_string AS CHAR. */
/* Текст и Редактор шаблона */
DEF VAR tpl_string AS CHAR NO-UNDO 
		VIEW-AS EDITOR 
		SIZE 75 BY 16
		BUFFER-CHARS 90
		NO-WORD-WRAP
		SCROLLBAR-HORIZONTAL
		SCROLLBAR-VERTICAL.

/* Проверим кол-во входных параметров */
IF NUM-ENTRIES(iParam) < 1 THEN
	DO:
		MESSAGE "Ошибка в параметрах процедуры!" VIEW-AS ALERT-BOX.
		RETURN.
	END.
/* Возьмем из параметров имя файла шаблона договора */
tpl_file_name = ENTRY(1, iParam).
/* Загрузим из файла текст шаблона */
INPUT FROM VALUE(tpl_file_name).
REPEAT:
	IMPORT UNFORMATTED tmpStr.
	tpl_string = tpl_string + tmpStr + CHR(10).
END.
INPUT CLOSE.

/* Для первого счета, выбранного в брoузере выполняем... */
FOR FIRST tmprecid 
         NO-LOCK,
   FIRST acct WHERE 
         RECID(acct) EQ tmprecid.id 
         NO-LOCK 
: 
	
	/* Подготовительные вычисления */
	/* Дата договора */
	tmpStr = GetXAttrValueEx("acct", (acct.acct + "," + acct.currency), "ДогОткрЛС","").
	IF tmpStr = "" THEN
		tmpStr = GetXAttrValueEx("acct", (acct.acct + "," + acct.currency), "Прим3","").
	/* Распарсим строку: */
	/* Проверим первый вариант */
	found_date = false.
	DO i = 1 TO NUM-ENTRIES(tmpStr," ") :
		IF NUM-ENTRIES(ENTRY(i,tmpStr," "),"/") = 3 OR
		   NUM-ENTRIES(ENTRY(i,tmpStr," "),".") = 3
		THEN
			DO:
				tmpStr = ENTRY(i,tmpStr," ").
				found_date = true.
			END.
	END.
	IF found_date = false THEN 
		MESSAGE "Программе не удалось найти дату договора ни в одном из доп.реквизитов счета 'Книга рег:дата и номер дог. об откр.','Примечание 3'!" 
			VIEW-AS ALERT-BOX.
	/* Распарсим дату */
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
	
	/* Месяц строкой */
	IF agr_month > 0 THEN
		agr_month_str = ENTRY(agr_month, months).
	ELSE
		agr_month_str = "".
		
	IF agr_year < 100 THEN
		IF agr_year > 80 THEN
			agr_year = agr_year + 1900.
		ELSE
			agr_year = agr_year + 2000.
	/* Информация по клиенту */
	IF acct.cust-cat = "Ч" THEN
		DO:
			FIND FIRST person WHERE
				person.person-id = acct.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL person THEN
				DO:
					acct_client_name = person.name-last + " " + person.first-names.
					acct_client_address = person.address[1] + " " + person.address[2].
					acct_client_document = person.document-id + ": " +
						person.document + ". Выдан: " + person.issue.
				END.
		END.
	ELSE
		DO:
			MESSAGE "Счет не принадлежит клиенту частному лицу!" VIEW-AS ALERT-BOX.
			RETURN.
		END.

	

	/* Перебираем все выражения */
	DO i = 1 TO NUM-ENTRIES(tpl_string, dc):
		IF SUBSTRING(ENTRY(i, tpl_string, dc),1,1) = "#" THEN
			/* Это действительно выражение */
			DO:
				expr = ENTRY(i, tpl_string, dc).
				/* Имя дескриптора */
				descriptor = SUBSTRING(ENTRY(1,expr),2).
				/* Длинна выводимого значения */
				IF NUM-ENTRIES(expr) > 2 THEN
					d_format = INTEGER(ENTRY(2, expr)).
				ELSE
					d_format = 0.
				IF NUM-ENTRIES(descriptor,"-") = 2 THEN
					desc_index = INTEGER(ENTRY(2,descriptor,"-")).
				ELSE
					desc_index = 0.
				/* ОБРАБОТКА ДЕСКРИПТОРОВ */
				IF descriptor BEGINS "AGR_DAY" THEN
					ENTRY(i, tpl_string, dc) = STRING(agr_day).
				IF descriptor BEGINS "AGR_MONTH_STR" THEN
					ENTRY(i, tpl_string, dc) = agr_month_str.
				IF descriptor BEGINS "AGR_YEAR" THEN
					ENTRY(i, tpl_string, dc) = STRING(agr_year).
				IF descriptor BEGINS "ACCT_CLIENT_NAME" THEN
					DO:
						acct_client_name = SUBSTRING(acct_client_name,1,d_format).
						acct_client_name = acct_client_name + FILL(" ",d_format - LENGTH(acct_client_name)).
						ENTRY(i, tpl_string, dc) = acct_client_name.
					END.
				IF descriptor BEGINS "ACCT_NO" THEN
					DO:
						acct_no = acct.acct.
						acct_no = SUBSTRING(acct_no,1,d_format).
						acct_no = acct_no + FILL(" ",d_format - LENGTH(acct_no)).
						ENTRY(i, tpl_string, dc) = acct_no.
					END.
				IF descriptor BEGINS "ACCT_CLIENT_ADDRESS" THEN
					DO:
						acct_client_address_arr[1] = acct_client_address.
						{wordwrap.i &s=acct_client_address_arr &l=d_format &n=4}
						ENTRY(i, tpl_string, dc) = acct_client_address_arr[desc_index].
					END.
				IF descriptor BEGINS "ACCT_CLIENT_DOCUMENT" THEN
					DO:
						acct_client_document_arr[1] = acct_client_document.
						{wordwrap.i &s=acct_client_document_arr &l=d_format &n=4}
						ENTRY(i, tpl_string, dc) = acct_client_document_arr[desc_index].
					END.
			END.
	END.
	
	
	/* Удалим все спец.символы */
	tpl_string = REPLACE(tpl_string, dc, "").

	/* Отобразим договор в форме для редактирования */
/*
	FORM tpl_string WITH FRAME main-frame NO-LABELS OVERLAY WITH TITLE "[Шаблон]" CENTERED ROW 5 1 COL.
	REPEAT:
		UPDATE tpl_string WITH FRAME main-frame.
		ENABLE tpl_string WITH FRAME main-frame.
	END.
 
	HIDE FRAME main-frame.
*/
PUT UNFORMATTED tpl_string SKIP.
{preview.i}

END.
