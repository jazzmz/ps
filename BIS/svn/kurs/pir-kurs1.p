/***********************************************************
 *                                                           *                                      
 *                                                           *
 * Процедура формирует распоряжение курсам для бухгалтерии.*                                                                                                  *
 *                                                                *
 *                                                         *
 ***********************************************************
 * Автор: Красков А.С.                                     *
 * Дата создания: 27.10.2010                               *
 * Заявка №479                                                   *
 ***********************************************************/

using Progress.Lang.*.
{tmprecid.def}
{globals.i}
{getdate.i}
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
DEF VAR oTable2 AS TTable NO-UNDO.
DEF VAR oTable3 AS TTable NO-UNDO.
DEF VAR oTable4 AS TTable NO-UNDO.

DEF VAR PIRispl AS Char NO-UNDO.
DEF VAR userpost AS Char NO-UNDO.

DEF VAR dCurrDate AS DATE NO-UNDO.                  /* Текущая дата */
DEF VAR oTKurs AS TKurs NO-UNDO.
DEF VAR KursUSDBuy AS Decimal NO-UNDO.
DEF VAR KursUSDSell AS Decimal NO-UNDO.
DEF VAR KursEurBuy AS Decimal NO-UNDO.
DEF VAR KursEurSell AS Decimal NO-UNDO.
/*message end-date view-as Alert-box.*/
/*dCurrDate=gend-date.  */
dCurrDate = end-date.

oTKurs = new TKurs().

if (oTKurs:getCBRKurs(840,dCurrDate) <> ?) AND (oTKurs:getCBRKurs(978,dCurrDate)<>?)  then 
do:

oTpl = new TTpl("pir-kurs1.tpl").

KursUSDBuy = ROUND((oTKurs:getKursByType("СрзВзшДБ",840,dCurrDate) * 0.995),4).
KursUSDSell = ROUND((oTKurs:getKursByType("СрзВзшКр",840,dCurrDate) * 1.005),4).
KursEURBuy = ROUND((oTKurs:getKursByType("СрзВзшДБ",978,dCurrDate) * 0.995),4).
KursEURSell = ROUND((oTKurs:getKursByType("СрзВзшКр",978,dCurrDate) * 1.005),4).

if KursUSDBuy > oTKurs:getCBRKurs(840,dCurrDate) then KursUSDBuy = oTKurs:getCBRKurs(840,dCurrDate).
if KursUSDSell < oTKurs:getCBRKurs(840,dCurrDate) then KursUSDSell = oTKurs:getCBRKurs(840,dCurrDate).
if KursEURBuy > oTKurs:getCBRKurs(978,dCurrDate) then KursEurBuy = oTKurs:getCBRKurs(978,dCurrDate).
if KursEURSell < oTKurs:getCBRKurs(978,dCurrDate) then KursEurSell = oTKurs:getCBRKurs(978,dCurrDate).

oTable1 = new TTable(2).
oTable1:addRow().
oTable1:addCell(KursUSDBuy).
oTable1:addCell(KursUSDSell).

oTable2 = new TTable(2).
oTable2:addRow().
oTable2:addCell(KursEURBuy).
oTable2:addCell(KursEurSell).

oTable3 = new TTable(2).
oTable3:addRow().
oTable3:addCell(Round(oTKurs:getKrossKurs("Buy",978,840,dCurrDate),4)).
oTable3:addCell(Round(oTKurs:getKrossKurs("Sell",978,840,dCurrDate),4)).

oTable4 = new TTable(2).
oTable4:addRow().
oTable4:addCell(Round(oTKurs:getKrossKurs("Buy",840,978,dCurrDate),4)).
oTable4:addCell(Round(oTKurs:getKrossKurs("Sell",840,978,dCurrDate),4)).


oTpl:addAnchorValue("TABLE1",oTable1).
oTpl:addAnchorValue("TABLE2",oTable2).
oTpl:addAnchorValue("TABLE3",oTable3).
oTpl:addAnchorValue("TABLE4",oTable4).

oTpl:addAnchorValue("DATE",dCurrDate).

oTpl:addAnchorValue("КУРС_USD",oTKurs:getCBRKurs(840,dCurrDate)).
oTpl:addAnchorValue("КУРС_EUR",oTKurs:getCBRKurs(978,dCurrDate)).

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
DELETE OBJECT oTable4.
DELETE OBJECT oTpl.
end.
else
        MESSAGE COLOR WHITE/RED "Не установлен курс ЦБ на" dCurrDate "!" VIEW-AS ALERT-BOX TITLE "[ОШИБКА #646]".
DELETE OBJECT oTKurs.