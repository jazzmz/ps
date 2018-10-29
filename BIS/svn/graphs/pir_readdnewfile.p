/*
Читает файл Dxxxxxx.NEW с параметрами для Анализа
Бакланов А.В. 11.09.2013
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
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR kUSD AS DECIMAL NO-UNDO.
DEF VAR kEUR AS DECIMAL NO-UNDO.
DEF VAR iRub AS CHARACTER NO-UNDO.
DEF VAR iUSD AS CHARACTER NO-UNDO.
DEF VAR iEur AS CHARACTER NO-UNDO.
DEF VAR tempDate AS DATE NO-UNDO.

tempDate = iEndDate + 1.

PROCEDURE makename:
DEF INPUT PARAM tDate AS DATE NO-UNDO.
filnm = "/home2/bis/quit41d/imp-exp/doc/analiz/D" + ENTRY(3,string(tDate,"99/99/99"),"/") + string(month(tDate),'99') + 
         string(day(tDate),'99') + ".NEW".
END PROCEDURE.

RUN makename(tempDate).

/*
filnm = "'analiz/D' + string(year(iEndDate),'9999') + string(month(iEndDate),'99') + 
         string(day(iEndDate),'99') + '.NEW'".
filnm = "D130424.NEW".*/

oSysClass = NEW TSysClass().
kUSD = oSysClass:getCbrKurs(840,iEndDate).
kEUR = oSysClass:getCbrKurs(978,iEndDate).
DELETE OBJECT oSysClass.

DO WHILE SEARCH(filnm) = ?:
	tempDate = tempDate + 1.
	RUN makename(tempDate).
	END.
INPUT FROM VALUE(filnm).

REPEAT:
	IMPORT UNFORMATTED tmpStr.
	iType1 = TRIM(SUBSTRING (tmpStr, 1, 6)).
	iDate = TRIM(SUBSTRING (tmpStr, 21, 10)).
	iRub = TRIM(SUBSTRING (tmpStr, 31, 16)).
	iUsd = TRIM(SUBSTRING (tmpStr, 47, 16)).
	iEur = TRIM(SUBSTRING (tmpStr, 63, 16)).
	IF ENTRY(1,iType) = iType1 THEN 
	   DO: 
		IF ENTRY(2,iType) = "руб" THEN iRes = DEC(TRIM(iRub)).
	   	IF ENTRY(2,iType) = "вал" THEN iRes = DEC(TRIM(iUsd)) * kUSD + DEC(TRIM(iEur)) * kEUR.
	   END.
END.
INPUT CLOSE.

RETURN "".