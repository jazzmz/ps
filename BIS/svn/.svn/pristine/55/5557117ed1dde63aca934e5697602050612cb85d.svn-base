/***********************************************************
 *							   *	                              
 *				                           *
 * Процедура формирует распоряжение курсам для пластиковых *                                                                                                  *
 * карт							   *
 *                                                         *
 ***********************************************************
 * Автор: Красков С.А.                                     *
 * Дата создания: 27.10.2010                               *
 * заявка №479						   *
 ***********************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
DEF VAR oTable2 AS TTable NO-UNDO.
DEF VAR oTable3 AS TTable NO-UNDO.

DEF VAR PIRispl AS Char NO-UNDO.
DEF VAR userpost AS Char NO-UNDO.

DEF VAR dCurrDate AS DATE NO-UNDO.                  /* Текущая дата */
DEF VAR oTkurs AS TKurs NO-UNDO.
DEF VAR KursUSDBuy AS Decimal NO-UNDO.
DEF VAR KursUSDSell AS Decimal NO-UNDO.
DEF VAR KursEurBuy AS Decimal NO-UNDO.
DEF VAR KursEurSell AS Decimal NO-UNDO.
/*message end-date view-as Alert-box.*/
/*dCurrDate=gend-date.  */
dCurrDate = end-date.

oTkurs = new TKurs().

if (oTKurs:getCBRKurs(840,dCurrDate) <> ?) AND (oTKurs:getCBRKurs(978,dCurrDate) <> ?) then 
do:
   oTpl = new TTpl("pir-kurs3.tpl").

   KursUSDBuy = oTkurs:getCBRKurs(840,dCurrDate) * 0.995.
   KursUSDSell = oTkurs:getCBRKurs(840,dCurrDate) * 1.005.
   KursEURBuy = oTkurs:getCBRKurs(978,dCurrDate) * 0.995.
   KursEURSell = oTkurs:getCBRKurs(978,dCurrDate) * 1.005.

   oTable1 = new TTable(2).
   oTable1:addRow().
   oTable1:addCell(ROUND(KursUSDBuy,4)).
   oTable1:addCell(ROUND(KursUSDSell,4)).

   oTable2 = new TTable(2).
   oTable2:addRow().
   oTable2:addCell(ROUND(KursEURBuy,4)).
   oTable2:addCell(ROUND(KursEurSell,4)).


   oTable3 = new TTable(2).
   oTable3:addRow().
   oTable3:addCell(Round((KursEURBuy / KursUSDsell),4)).
   oTable3:addCell(Round((KursUSDBuy / KursEURSell),4)).


   oTpl:addAnchorValue("TABLE1",oTable1).
   oTpl:addAnchorValue("TABLE2",oTable2).
   oTpl:addAnchorValue("TABLE3",oTable3).

   oTpl:addAnchorValue("DATE",dCurrDate).

   oTpl:addAnchorValue("КУРС_USD",oTkurs:getCBRKurs(840,dCurrDate)).
   oTpl:addAnchorValue("КУРС_EUR",oTkurs:getCBRKurs(978,dCurrDate)).

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
   ELSE         IF PIRispl <> '0' THEN do:
  	           oTpl:addAnchorValue("USER_POST","Исполнитель:").
  	  	   end.



{setdest.i}
  oTpl:show().
{preview.i}

DELETE OBJECT oTable1.
DELETE OBJECT oTable2.
DELETE OBJECT oTable3.
DELETE OBJECT oTpl.
end.
else
        MESSAGE COLOR WHITE/RED "Не установлен курс ЦБ на" dCurrDate "!" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #646]".
DELETE OBJECT oTkurs.