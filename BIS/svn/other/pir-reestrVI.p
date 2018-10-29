/*
#4228 Бакланов А.В.
Создание EXCEL файла с реестром клиентов для включения в Дисконтную программу
*/

{bislogin.i}
{globals.i}
{getdate.i}
{pir-reestrVI.i}

{intrface.get xclass}
{intrface.get date}

DEF BUFFER bloan FOR loan.
DEF VAR clnum AS CHAR NO-UNDO.
DEF VAR count AS INT INIT 0 NO-UNDO.
DEF VAR date1 AS CHAR NO-UNDO.
DEF VAR date2 AS CHAR NO-UNDO.
DEF VAR datein AS DATE NO-UNDO.
DEF VAR dateout AS DATE NO-UNDO.
DEF VAR tday AS CHAR NO-UNDO.

DEFINE VARIABLE cTMonths AS CHARACTER EXTENT 12
      INIT [" января ", " февраля ", " марта ", " апреля ", " мая ", " июня ",
            " июля ", " августа ", " сентября ", " октября ", " ноября ", " декабря "] NO-UNDO.

tday = CHR(34) + string(DAY(TODAY),"99") + CHR(34) + cTMonths[MONTH(TODAY)] + string(YEAR(TODAY)) + " г.".

OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/pcard/novikov/novikov" + string(YEAR(TODAY),"9999") + "-" + string(MONTH(TODAY),"99") + "-" + string(DAY(TODAY),"99") + ".xls") CONVERT TARGET "UTF-8".
PUT UNFORMATTED XLHead(tday) SKIP.

FOR EACH loan WHERE loan.contract EQ 'card-pers' AND loan.cust-cat  EQ 'Ч'
AND CAN-DO("card-loan-pers",loan.class-code)
AND CAN-DO("ОТКР,ЗАКР",loan.loan-status)
AND loan.open-date >= end-date
AND loan.cont-code BEGINS "I" NO-LOCK:

FIND FIRST person WHERE person.person-id = loan.cust-id no-lock no-error.
IF AVAILABLE person THEN DO:
	FOR EACH bloan WHERE true AND bloan.contract EQ 'card' AND bloan.parent-cont-code EQ loan.cont-code
		AND bloan.parent-contract EQ 'card-pers' NO-LOCK:
		clnum	= SUBSTRING(bloan.doc-num,5,1)
			+ SUBSTRING(bloan.doc-num,7,6)
			+ SUBSTRING(bloan.doc-num,14,2).
		count = count + 1.
		
		datein = LASTMONDATE(loan.open-date) + 1.
		dateout = datein + 364.
		date1 = string(YEAR(datein)) + "-" + string(MONTH(datein),"99") + "-" + string(DAY(datein),"99") + "T00:00:00.000".
		date2 = string(YEAR(dateout)) + "-" + string(MONTH(dateout),"99") + "-" + string(DAY(dateout),"99") + "T00:00:00.000".
		PUT UNFORMATTED XLAddRow(count,clnum,date1,date2) SKIP.
		END.
	END.
END.

PUT UNFORMATTED XLFoot(count).
OUTPUT CLOSE.

OUTPUT TO VALUE("/home2/bis/quit41d/imp-exp/pcard/novikov/compress.bat") CONVERT TARGET "UTF-8".
PUT UNFORMATTED "cd c:" + chr(92) + chr(34) + "program files" + chr(34) + chr(92) + "7-zip" + chr(92) SKIP.
PUT UNFORMATTED "7z.exe a -t7z -mx7 -p51973451 -mhe Q:" + chr(92) + "pcard" + chr(92) + "novikov" + chr(92) + "novikov" 
		+ string(YEAR(TODAY),"9999") + "-" + string(MONTH(TODAY),"99") + "-" + string(DAY(TODAY),"99") + ".7z Q:" 
		+ chr(92) + "pcard" + chr(92) + "novikov" + chr(92) + "novikov" + string(YEAR(TODAY),"9999") + "-" 
		+ string(MONTH(TODAY),"99") + "-" + string(DAY(TODAY),"99") + ".xls" SKIP.
OUTPUT CLOSE.

MESSAGE "Экспорт реестра закончен." VIEW-AS ALERT-BOX.
{intrface.del}
