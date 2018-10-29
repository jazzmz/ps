/*****************************************
 *     Информационное сообщение          *
 *    о договорах сгруппированных        *
 *    в ПОС.                             *
 *     Информационные сообщения по       *
 *				         *
 *          !!! ВНИМАНИЕ !!!             *
 *				         *
 * Первый параметр это ЭРБ               *
 * принадлежит {debt,baddebt,%,bad%}     *
 * допускается использовать сумму.       *
 * Второй параметр это резерв            *
 * принадлежит {debt,baddebt,%,bad%}.    *
 * Третий параметр это шаблон.           *
 *****************************************
 ********************************
 * Заявка       : #903          *
 * Автор        : Маслов Д. А.  *
 * Дата создания: 10.04.2012    *
 ********************************/
{globals.i}

{intrface.get loan}
{intrface.get count}
{intrface.get date}
{intrface.get xclass}
{intrface.get i254}

{pir-gp.i}

DEF INPUT PARAM cParam AS CHAR NO-UNDO.

DEF VAR calcBaseList AS CHAR NO-UNDO.
DEF VAR calcResList  AS CHAR NO-UNDO.
DEF VAR template     AS CHAR NO-UNDO.

def var BaseSensetiveToLastWorDay as CHAR INIT "%" NO-UNDO.

DEF VAR oTpl         AS TTpl NO-UNDO.

calcBaseList = ENTRY(1,cParam,"|").
calcResList  = ENTRY(2,cParam,"|").
template     = ENTRY(3,cParam,"|").

oTpl = new TTpl(template).




DEF VAR currDate AS DATE NO-UNDO.

DEF VAR posName  AS CHAR NO-UNDO.

DEF VAR oTable1 AS TTable NO-UNDO.
DEF VAR oTable2 AS TTable NO-UNDO.
DEF VAR oTable3 AS TTable NO-UNDO.
DEF VAR oTable4 AS TTable NO-UNDO.
DEF VAR oTable5 AS TTable NO-UNDO.
DEF VAR oTable6 AS TTable NO-UNDO.

DEF VAR oTableItog AS TTable NO-UNDO.

DEF VAR oTableKurs AS TTable NO-UNDO.

DEF VAR i  AS INT INIT 0 NO-UNDO.
DEF VAR i1 AS INT INIT 0 NO-UNDO.
DEF VAR i2 AS INT INIT 0 NO-UNDO.
DEF VAR i3 AS INT INIT 0 NO-UNDO.
DEF VAR i4 AS INT INIT 0 NO-UNDO.
DEF VAR i5 AS INT INIT 0 NO-UNDO.
DEF VAR i6 AS INT INIT 0 NO-UNDO.

DEF VAR showZero   AS LOGICAL INIT FALSE NO-UNDO.
DEF VAR cClassCode AS CHARACTER          NO-UNDO.
DEF VAR cMainClassCode AS CHARACTER          NO-UNDO.
def var lastworkday as logical INIT NO NO-UNDO.
DEF VAR currTable AS TTable    NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR oClient   AS TClient   NO-UNDO.

DEF VAR p%       AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR p%V      AS DECIMAL INITIAL 0 NO-UNDO.

DEF VAR oSumP%1  AS TAArray NO-UNDO.
DEF VAR oSumP%2  AS TAArray NO-UNDO.
DEF VAR oSumP%3  AS TAArray NO-UNDO.
DEF VAR oSumP%4  AS TAArray NO-UNDO.
DEF VAR oSumP%5  AS TAArray NO-UNDO.
DEF VAR oSumP%6  AS TAArray NO-UNDO.

DEF VAR oSumPb%1  AS TAArray NO-UNDO.
DEF VAR oSumPb%2  AS TAArray NO-UNDO.
DEF VAR oSumPb%3  AS TAArray NO-UNDO.
DEF VAR oSumPb%4  AS TAArray NO-UNDO.
DEF VAR oSumPb%5  AS TAArray NO-UNDO.
DEF VAR oSumPb%6  AS TAArray NO-UNDO.

DEF VAR findInMainLoan AS LOG NO-UNDO. /* Где ищем на охватах или на траншах */

DEF VAR oTablePos12 AS TTable NO-UNDO.


DEF VAR oLoan     AS TLoan   NO-UNDO.

DEF VAR pb%       AS DECIMAL INITIAL 0 NO-UNDO.
DEF VAR pbV%      AS DECIMAL INITIAL 0 NO-UNDO.


oSysClass = new TSysClass().


{getdate.i}
currDate = end-date.

if (LastMonDate(currDate) <> PrevWorkDay(LastMonDate(currDate) + 1)) and (currDate =  PrevWorkDay(LastMonDate(currDate) + 1)) then lastworkday = true.


findInMainLoan = (IF NUM-ENTRIES(cParam,"|") > 3 THEN TRUE ELSE FALSE).
cClassCode     = (IF findInMainLoan THEN ENTRY(1,oSysClass:getSetting("ОверКлассТранз","КлОхватТранш"),"|") ELSE ENTRY(2,oSysClass:getSetting("ОверКлассТранз","КлОхватТранш"),"|")).
 
MESSAGE "Подавлять нулевые?" VIEW-AS ALERT-BOX BUTTONS YES-NO SET showZero.
showZero = NOT showZero.

oTable1 = new TTable(6).
oTable2 = new TTable(6).
oTable3 = new TTable(6).
oTable4 = new TTable(6).
oTable5 = new TTable(6).
oTable6 = new TTable(6).

oTableItog  = NEW TTable(7).
oTablePos12 = NEW TTable(7). 

oSumP%1 = NEW TAArray("0").
oSumP%2 = NEW TAArray("0").
oSumP%3 = NEW TAArray("0").
oSumP%4 = NEW TAArray("0").
oSumP%5 = NEW TAArray("0").
oSumP%6 = NEW TAArray("0").

oSumPb%1 = NEW TAArray("0").
oSumPb%2 = NEW TAArray("0").
oSumPb%3 = NEW TAArray("0").
oSumPb%4 = NEW TAArray("0").
oSumPb%5 = NEW TAArray("0").
oSumPb%6 = NEW TAArray("0").

posName = getPosId("ПЛКарт",1).
{pir-getlinpos.i cClassCode currDate "\"ПЛКарт1,ПЛКарт2,ПЛКарт3,ПЛКарт4,ПЛКарт5,ПЛКарт6\""}
  oClient = new TClient(loan.cust-cat,loan.cust-id).
 
  DO i = 1 TO NUM-ENTRIES(calcBaseList,"+"):
    if lastworkday and can-do(BaseSensetiveToLastWorDay,ENTRY(i,calcBaseList,"+")) then 
	do:
	   p%  = p%  + oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,LastMonDate(currDate),ENTRY(i,calcBaseList,"+")),currDate).
           p%V  = p%V + getRsrvBase(loan.cont-code,LastMonDate(currDate),ENTRY(i,calcBaseList,"+")).
	end.
    else
        do:
            p%V  = p%V + getRsrvBase(loan.cont-code,currDate,ENTRY(i,calcBaseList,"+")).
   	    p%   = p%  + oSysClass:convert2rur(INT(loan.currency),getRsrvBase(loan.cont-code,currDate,ENTRY(i,calcBaseList,"+")),currDate).
        end.
  END.

  DO i = 1 TO NUM-ENTRIES(calcResList,"+"):
    pb%  = pb% + getRsrv(loan.cont-code,currDate,ENTRY(i,calcResList,"+")).
  END.



  IF p% > 0 OR showZero THEN DO:
  PUT UNFORMATTED loan.cont-code "|" p% SKIP.
    CASE term-obl.lnk-cont-code:
       WHEN getPosId("ПЛКарт",1) THEN DO:
	      currTable = oTable1.
          oSumP%1:incrementTo("r_" + loan.currency,p%).
          oSumP%1:incrementTo("v_" + loan.currency,p%V).
          oSumPb%1:incrementTo("",pb%).

          i1 = i1 + 1.
          i  = i1.
       END.
       WHEN getPosId("ПЛКарт",2) THEN DO:
  	  currTable = oTable2.
          oSumP%2:incrementTo("r_" + loan.currency,p%).
          oSumP%2:incrementTo("v_" + loan.currency,p%V).
          oSumPb%2:incrementTo("",pb%).

          i2 = i2 + 1.
          i  = i2.
       END.
       WHEN getPosId("ПЛКарт",3) THEN DO:
          currTable = oTable3.
          oSumP%3:incrementTo("r_" + loan.currency,p%).
          oSumP%3:incrementTo("v_" + loan.currency,p%V).
          oSumPb%3:incrementTo("",pb%).
          i3 = i3 + 1.
          i  = i3.
       END.
       WHEN getPosId("ПЛКарт",4) THEN DO:
          currTable = oTable4.
          oSumP%4:incrementTo("r_" + loan.currency,p%).
          oSumP%4:incrementTo("v_" + loan.currency,p%V).
          oSumPb%4:incrementTo("",pb%).
          i4 = i4 + 1.
          i  = i4.
       END.
       WHEN getPosId("ПЛКарт",5) THEN DO:
          currTable = oTable5.
          oSumP%5:incrementTo("r_" + loan.currency,p%).
          oSumP%5:incrementTo("v_" + loan.currency,p%V).
          oSumPb%5:incrementTo("",pb%).

          i5 = i5 + 1.
          i  = i5.
       END.
       WHEN getPosId("ПЛКарт",6) THEN DO:
          currTable = oTable6.
          oSumP%6:incrementTo("r_" + loan.currency,p%).
          oSumP%6:incrementTo("v_" + loan.currency,p%V).
          oSumPb%6:incrementTo("",pb%).

          i6 = i6 + 1.
          i  = i6.
       END.
  END CASE.
         currTable:addRow().
         currTable:addCell(i).
 	 currTable:addCell(oClient:name-short + TSysClass:markValuta(loan.currency)).
         currTable:addCell(loan.cont-code).
         currTable:addCell(loan.currency).
         currTable:addCell(p%V).
         currTable:addCell(p%).
         
 END.
  i = i + 1.
  DELETE OBJECT oClient.
  p%   = 0.
  p%V  = 0.
  pb%  = 0.

END.
 
oLoan = NEW TLoan("ПОС",getPosId("ПЛКарт",1)).
   oTableItog:addRow().
    oTableItog:addCell(getPosId("ПЛКарт",1)).
    oTableItog:addCell(oSumP%1:getInDec("v_")).
    oTableItog:addCell(oSumP%1:getInDec("v_840")).
    oTableItog:addCell(oSumP%1:getInDec("v_978")).
    oTableItog:addCell(DECIMAL(oSumP%1:get("r_")) + DECIMAL(oSumP%1:get("r_840")) + DECIMAL(oSumP%1:get("r_978"))).
    oTableItog:addCell(oSumPb%1:getInDec("")).
    oTableItog:addCell(oLoan:getKK(currDate,"Баланс")).
DELETE OBJECT oLoan.

oLoan = NEW TLoan("ПОС",getPosId("ПЛКарт",2)).
  oTableItog:addRow().
    oTableItog:addCell(getPosId("ПЛКарт",2)).
    oTableItog:addCell(oSumP%2:getInDec("v_")).
    oTableItog:addCell(oSumP%2:getInDec("v_840")).
    oTableItog:addCell(oSumP%2:getInDec("v_978")).
    oTableItog:addCell(DECIMAL(oSumP%2:get("r_")) + DECIMAL(oSumP%2:get("r_840")) + DECIMAL(oSumP%2:get("r_978"))).
    oTableItog:addCell(oSumPb%2:getInDec("")).
    oTableItog:addCell(oLoan:getKK(currDate,"Баланс")).

 oTablePos12:addRow().
    oTablePos12:addCell(getPosId("ПЛКарт",1) + "+" + getPosId("ПЛКарт",2)).
    oTablePos12:addCell(oSumP%1:getInDec("v_") + oSumP%2:getInDec("v_")).
    oTablePos12:addCell(oSumP%1:getInDec("v_840") + oSumP%2:getInDec("v_840")).
    oTablePos12:addCell(oSumP%1:getInDec("v_978") + oSumP%2:getInDec("v_840")).
    oTablePos12:addCell(DECIMAL(oSumP%1:get("r_")) + DECIMAL(oSumP%1:get("r_840")) + DECIMAL(oSumP%1:get("r_978")) + 
    DECIMAL(oSumP%2:get("r_")) + DECIMAL(oSumP%2:get("r_840")) + DECIMAL(oSumP%2:get("r_978"))).
    oTablePos12:addCell(oSumPb%1:getInDec("") + oSumPb%2:getInDec("")).
    oTablePos12:addCell(oLoan:getKK(currDate,"Баланс")).
DELETE OBJECT oLoan.




oLoan = NEW TLoan("ПОС",getPosId("ПЛКарт",3)).
  oTableItog:addRow().
    oTableItog:addCell(getPosId("ПЛКарт",3)).
    oTableItog:addCell(oSumP%3:getInDec("v_")).
    oTableItog:addCell(oSumP%3:getInDec("v_840")).
    oTableItog:addCell(oSumP%3:getInDec("v_978")).
    oTableItog:addCell(DECIMAL(oSumP%3:get("r_")) + DECIMAL(oSumP%3:get("r_840")) + DECIMAL(oSumP%3:get("r_978"))).
    oTableItog:addCell(oSumPb%3:getInDec("")).
    oTableItog:addCell(oLoan:getKK(currDate,"Баланс")).
DELETE OBJECT oLoan.

oLoan = NEW TLoan("ПОС",getPosId("ПЛКарт",4)).
oTableItog:addRow().
   oTableItog:addCell(getPosId("ПЛКарт",4)).
   oTableItog:addCell(oSumP%4:getInDec("v_")).
   oTableItog:addCell(oSumP%4:getInDec("v_840")).
   oTableItog:addCell(oSumP%4:getInDec("v_978")).
   oTableItog:addCell(DECIMAL(oSumP%4:get("r_")) + DECIMAL(oSumP%4:get("r_840")) + DECIMAL(oSumP%4:get("r_978"))).
   oTableItog:addCell(oSumPb%4:getInDec("")).
   oTableItog:addCell(oLoan:getKK(currDate,"Баланс")).
DELETE OBJECT oLoan.

oLoan = NEW TLoan("ПОС",getPosId("ПЛКарт",5)).
oTableItog:addRow().
   oTableItog:addCell(getPosId("ПЛКарт",5)).
   oTableItog:addCell(oSumP%5:getInDec("v_")).
   oTableItog:addCell(oSumP%5:getInDec("v_840")).
   oTableItog:addCell(oSumP%5:getInDec("v_978")).
   oTableItog:addCell(DECIMAL(oSumP%5:get("r_")) + DECIMAL(oSumP%5:get("r_840")) + DECIMAL(oSumP%5:get("r_978"))).
   oTableItog:addCell(oSumPb%5:getInDec("")).
   oTableItog:addCell(oLoan:getKK(currDate,"Баланс")).
DELETE OBJECT oLoan.

oLoan = NEW TLoan("ПОС",getPosId("ПЛКарт",6)).
oTableItog:addRow().
   oTableItog:addCell(getPosId("ПЛКарт",6)).
   oTableItog:addCell(oSumP%6:getInDec("v_")).
   oTableItog:addCell(oSumP%6:getInDec("v_840")).
   oTableItog:addCell(oSumP%6:getInDec("v_978")).
   oTableItog:addCell(DECIMAL(oSumP%6:get("r_")) + DECIMAL(oSumP%6:get("r_840")) + DECIMAL(oSumP%6:get("r_978"))).
   oTableItog:addCell(oSumPb%6:getInDec("")).
   oTableItog:addCell(oLoan:getKK(currDate,"Баланс")).
DELETE OBJECT oLoan.

oTableKurs = NEW TTable(2).
  oTableKurs:addRow().
  oTableKurs:addCell("840").
  oTableKurs:addCell(oSysClass:getCBRKurs(840,currDate)).
  oTableKurs:addRow().
  oTableKurs:addCell("978").
  oTableKurs:addCell(oSysClass:getCBRKurs(978,currDate)).

oTpl:addAnchorValue("CURRDATE",currDate).
oTpl:addAnchorValue("POS1",getPosId("ПЛКарт",1)).
oTpl:addAnchorValue("POS2",getPosId("ПЛКарт",2)).
oTpl:addAnchorValue("TABLE8",oTablePos12).
IF oTable1:height > 0 THEN oTpl:addAnchorValue("TABLE1",oTable1). ELSE oTpl:addAnchorValue("TABLE1","*** НЕТ ДАННЫХ ***").
IF oTable2:height > 0 THEN oTpl:addAnchorValue("TABLE2",oTable2). ELSE oTpl:addAnchorValue("TABLE2","*** НЕТ ДАННЫХ ***").
IF oTable3:height > 0 THEN oTpl:addAnchorValue("TABLE3",oTable3). ELSE oTpl:addAnchorValue("TABLE3","*** НЕТ ДАННЫХ ***").
IF oTable4:height > 0 THEN oTpl:addAnchorValue("TABLE4",oTable4). ELSE oTpl:addAnchorValue("TABLE4","*** НЕТ ДАННЫХ ***").
IF oTable5:height > 0 THEN oTpl:addAnchorValue("TABLE5",oTable5). ELSE oTpl:addAnchorValue("TABLE5","*** НЕТ ДАННЫХ ***").
IF oTable6:height > 0 THEN oTpl:addAnchorValue("TABLE62",oTable6). ELSE oTpl:addAnchorValue("TABLE62","*** НЕТ ДАННЫХ ***").

oTpl:addAnchorValue("TABLE7",oTableKurs).
oTpl:addAnchorValue("TABLE6",oTableItog).

{tpl.show}

DELETE OBJECT oSumP%1.
DELETE OBJECT oSumP%2.
DELETE OBJECT oSumP%3.
DELETE OBJECT oSumP%4.
DELETE OBJECT oSumP%5.
DELETE OBJECT oSumP%6.
DELETE OBJECT oSumPb%1.
DELETE OBJECT oSumPb%2.
DELETE OBJECT oSumPb%3.
DELETE OBJECT oSumPb%4.
DELETE OBJECT oSumPb%5.
DELETE OBJECT oSumPb%6.
DELETE OBJECT oTable1. 
DELETE OBJECT oTable2. 
DELETE OBJECT oTable3. 
DELETE OBJECT oTable4. 
DELETE OBJECT oTable5.
DELETE OBJECT oTable6.
DELETE OBJECT oTablePos12. 
DELETE OBJECT oTableItog.
DELETE OBJECT oTableKurs.
DELETE OBJECT oSysClass.
DELETE OBJECT oTpl.



{tpl.delete}
{intrface.del}