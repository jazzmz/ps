/*
Читает файл -парам-.csv с параметрами, выгруженными из Анализа
Бакланов А.В. 24.09.2013
*/

{globals.i}

DEF OUTPUT PARAMETER iRes AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER iBegDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate AS DATE NO-UNDO.
DEF INPUT PARAMETER iType AS CHARACTER NO-UNDO. /*ПАРАМ,ВАЛ*,*СТАВКА*/
DEF VAR filnm AS CHARACTER NO-UNDO.
DEF VAR tmpStr AS CHARACTER NO-UNDO.
DEF VAR iType1 AS CHARACTER NO-UNDO.
DEF VAR iDate AS DATE NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR kUSD AS DECIMAL NO-UNDO.
DEF VAR kEUR AS DECIMAL NO-UNDO.
DEF VAR iRub AS CHARACTER NO-UNDO.
DEF VAR iVal AS CHARACTER NO-UNDO.
DEF VAR iValR AS CHARACTER NO-UNDO.

filnm = "/home2/bis/quit41d/imp-exp/doc/analiz/data/" + ENTRY(1,iType) + ".csv".

oSysClass = NEW TSysClass().
kUSD = oSysClass:getCbrKurs(840,iEndDate).
kEUR = oSysClass:getCbrKurs(978,iEndDate).
DELETE OBJECT oSysClass.

iRes = 0.
INPUT FROM VALUE(filnm).
REPEAT:
	IMPORT UNFORMATTED tmpStr.
	iDate = DATE(REPLACE(ENTRY(1,tmpStr,";"),".","/")).
	iRub = ENTRY(2,tmpStr,";").
	iVal = ENTRY(3,tmpStr,";").
	iValR = ENTRY(4,tmpStr,";").
	IF iDate = iEndDate AND ENTRY(3,iType) = "1" THEN iRes = DEC(TRIM(iRub)) + DEC(TRIM(iValR)).
	IF iDate = iEndDate AND ENTRY(3,iType) = "0" THEN 
	   DO: 
		IF ENTRY(2,iType) = "руб" THEN iRes = DEC(TRIM(iRub)).
	   	IF ENTRY(2,iType) = "вал" THEN iRes = DEC(TRIM(iValR)).
	   END.
END.
INPUT CLOSE.

RETURN "".