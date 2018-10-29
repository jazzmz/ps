/*
Читает файл DCARD_xxxxxxxx.NEW с параметрами для Анализа
Бакланов А.В. 12.09.2013
*/

{pirsavelog.p}
{globals.i}
{intrface.get instrum}
{sh-defs.i}
{norm.i}

DEF OUTPUT PARAMETER iRes AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iType AS CHARACTER NO-UNDO. /*ПАРАМ,ВАЛ*/
DEF VAR filnm AS CHARACTER NO-UNDO.
DEF VAR tmpStr AS CHARACTER NO-UNDO.
DEF VAR iType1 AS CHARACTER NO-UNDO.
DEF VAR iDate AS CHARACTER NO-UNDO.
DEF VAR kRub AS CHARACTER NO-UNDO.
DEF VAR kVal AS CHARACTER NO-UNDO.

/*
filnm = "'analiz/DCARD_' string(day(iEndDate),'99') + string(month(iEndDate),'99')
		 + string(year(iEndDate),'9999') + '.NEW'".
filnm = "DCARD_23042013.NEW".*/

filnm = "/home2/bis/quit41d/imp-exp/doc/analiz/DCARD_" + string(day(iEndDate),'99') + string(month(iEndDate),'99')
		 + string(year(iEndDate),'9999') + ".NEW".

INPUT FROM VALUE(filnm).
REPEAT:
	IMPORT UNFORMATTED tmpStr.
	iType1 = TRIM(SUBSTRING (tmpStr, 1, 14)).
	iDate = TRIM(SUBSTRING (tmpStr, 21, 8)).
	kRub = TRIM(SUBSTRING (tmpStr, 44, 14)).
	kVal = TRIM(SUBSTRING (tmpStr, 58, 14)).
	IF ENTRY(1,iType) = iType1 THEN 
	   DO: 
		IF ENTRY(2,iType) = "руб" THEN iRes = DEC(TRIM(kRub)).
	   	IF ENTRY(2,iType) = "вал" THEN iRes = DEC(TRIM(kVal)).
	   END.
END.
INPUT CLOSE.

RETURN "".