/***********************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение курсам для             *     
 *  операционной и постоперационной кассы                  *
 *                                                         *
 ***********************************************************
 * Автор: Красков А.С.                                     *
 * Дата создания: 28.10.2010                               *
 * заявка №479                                                   *
 ***********************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
/*{getdate.i}*/

/** Входной параметр операционная/постоперационная касса*/
DEFINE INPUT PARAM iParam AS CHAR NO-UNDO.
DEF VAR iParam1 AS CHAR NO-UNDO.
DEF VAR TmpSTR AS CHAR NO-UNDO.

DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
DEF VAR oTable2 AS TTable NO-UNDO.
DEF VAR oTDTInput AS TDTInput NO-UNDO.

DEF VAR PIRispl AS Char NO-UNDO.
DEF VAR userpost AS Char NO-UNDO.

DEF VAR dCurrDate AS DATE NO-UNDO.                  /* Текущая дата */
DEF VAR PdateTime AS DATETIME NO-UNDO.
DEF VAR mHour AS INTEGER NO-UNDO.
DEF VAR mMinute AS INTEGER NO-UNDO.
DEF VAR minleft AS INTEGER NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR KursUSDBuy AS Decimal NO-UNDO.
DEF VAR KursUSDSell AS Decimal NO-UNDO.
DEF VAR KursEurBuy AS Decimal NO-UNDO.
DEF VAR KursEurSell AS Decimal NO-UNDO.
DEF VAR Param_S AS Char NO-UNDO.

oSysClass = new TSysClass().
oTDTInput = new TDTInput(7).
oTDTInput:X= 190.
oTDTInput:Y= 70.
oTDTInput:Show().

ASSIGN
   iParam1 = ENTRY(1, iParam)
.
/*iParam1 = "Пос".            */

if oTDTInput:isSet then
do:
dCurrDate = Date(oTDTInput:beg-datetime).
    
minleft = MTIME(oTDTInput:beg-datetime) / 60000.
mMinute = minleft - TRUNCATE(minleft / 60,0) * 60.  
mhour = TRUNCATE(minleft / 60,0).   

IF (iParam1="Пос") THEN Param_s = "НалПокПос".
ELSE Param_s = "НалПок".
IF (iParam1="Доп") THEN Param_s = "НалПок".

ASSIGN
KursUSDBuy = ROUND((oSysClass:getKursByType(Param_s,840,dCurrDate)),4)
KursEURBuy = ROUND((oSysClass:getKursByType(Param_s,978,dCurrDate)),4).

IF iParam1="Пос" THEN Param_s = "НалПрПос".
ELSE Param_s = "НалПр".
IF (iParam1="Доп") THEN Param_s = "НалПр".

ASSIGN
KursEURSell = ROUND((oSysClass:getKursByType(Param_s,978,dCurrDate)),4)
KursUSDSell = ROUND((oSysClass:getKursByType(Param_s,840,dCurrDate)),4).

if ((iparam="Пос") and ((oSysClass:getCBRKurs(840,dCurrDate + 1) <> ?) AND (oSysClass:getCBRKurs(840,dCurrDate + 1) <> ?)))
   OR((iparam <> "Пос") AND (oSysClass:getCBRKurs(840,dCurrDate) <> ?) AND (oSysClass:getCBRKurs(840,dCurrDate) <> ?)) then 
do:
  FORM
     KursUSDBuy
        FORMAT "99.9999" 
        LABEL  "Курс покупки USD"  
        HELP   "Курс покупки доллара США по наличному расчету"
     KursUSDSell
        FORMAT "99.9999" 
        LABEL  "Курс продажи USD"  
        HELP   "Курс продажи доллара США по наличному расчету"
     KursEURBuy
        FORMAT "99.9999" 
        LABEL  "Курс покупки EUR"  
        HELP   "Курс покупки евро по наличному расчету"
     KursEURSell
        FORMAT "99.9999" 
        LABEL  "Курс продажи EUR"  
        HELP   "Курс продажи евро по наличному расчету"
  WITH FRAME frParam 1 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ КУРС ]".

  PAUSE 0.

  UPDATE
     KursUSDBuy
     KursUSDSell
     KursEURBuy
     KursEURSell
  WITH FRAME frParam.

  HIDE FRAME frParam NO-PAUSE.



  IF iParam1="Пос" THEN oTpl = new TTpl("pir-kurs2p.tpl").
  ELSE oTpl = new TTpl("pir-kurs2.tpl").
  IF iParam1="Доп" THEN oTpl = new TTpl("pir-kurs2d.tpl").
  /**/
   oTpl:addAnchorValue("DATE",dCurrDate).

   IF iParam1="Пос" THEN dCurrDate = dCurrDate + 1.
   if (KursUSDBuy  > oSysClass:getCBRKurs(840,dCurrDate)) 
   OR (KursUSDSell < oSysClass:getCBRKurs(840,dCurrDate)) 
   OR (KursEURBuy  > oSysClass:getCBRKurs(978,dCurrDate))
   OR (KursEURSell < oSysClass:getCBRKurs(978,dCurrDate)) 
     THEN
       do:
          MESSAGE COLOR WHITE/RED "ОШИБКА УСТАНОВКИ КУРСА" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #646]".
       end.
     else
       do:
	  oTable1 = new TTable(2).
	  oTable1:addRow().
	  oTable1:addCell(KursUSDBuy).
	  oTable1:addCell(KursUSDSell).

	  oTable2 = new TTable(2).
	  oTable2:addRow().
	  oTable2:addCell(KursEURBuy).
	  oTable2:addCell(KursEurSell).

	  oTpl:addAnchorValue("TABLE1",oTable1).
	  oTpl:addAnchorValue("TABLE2",oTable2).

	  oTpl:addAnchorValue("Hour",mHour).

	  if mMinute = 0 then 
	    do:
	       TmpSTR = "00".
            end.
	  else
	    do: 
	       TmpSTR = String(mMinute).
	    end.
          oTpl:addAnchorValue("Minute",TmpSTR).
 
/*	  IF iParam1="Пос" THEN dCurrDate = dCurrDate + 1.*/

	  oTpl:addAnchorValue("DATENext",dCurrDate).
	  oTpl:addAnchorValue("КУРС_USD",oSysClass:getCBRKurs(840,dCurrDate)).
	  oTpl:addAnchorValue("КУРС_EUR",oSysClass:getCBRKurs(978,dCurrDate)).
  
	  IF PIRispl = "" 
	     THEN DO:

	          FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
	          IF AVAIL _user THEN DO:
                     userPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
                     oTpl:addAnchorValue("USER_POST",userPost).
                  END.
                  ELSE
                     oTpl:addAnchorValue("USER_POST","Исполнитель:").
             END.
             ELSE
                  IF PIRispl <> '0' THEN  oTpl:addAnchorValue("USER_POST","Исполнитель:"). 



          {setdest.i}
          oTpl:show().
          {preview.i}                              
	  DELETE OBJECT oTable1.
	  DELETE OBJECT oTable2.
       end.


   DELETE OBJECT oTpl.
   DELETE OBJECT oSysClass.
end.
else do:
if (iparam="Пос") then dCurrDate = dCurrDate + 1.
        MESSAGE COLOR WHITE/RED "Не установлен курс ЦБ на" dCurrDate "!" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #646]".
end.
end.
DELETE OBJECT oTDTInput.    