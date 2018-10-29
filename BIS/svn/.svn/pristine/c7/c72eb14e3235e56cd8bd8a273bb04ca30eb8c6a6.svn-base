{globals.i}
{tmprecid.def}
{intrface.get tmess}
{ulib.i}

DEF INPUT PARAMETER currDate AS DATE    NO-UNDO.
DEF INPUT PARAMETER cAcct    AS CHAR    NO-UNDO.
DEF INPUT PARAMETER rate     AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER badRate  AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER showLog  AS Logical NO-UNDO.
def OUTPUT PARAMETER result as char NO-UNDO.


DEF VAR oAcct    AS TAcct   NO-UNDO.

def var oTPL     AS TTpl NO-UNDO.

DEF VAR oAArray  AS TAArray NO-UNDO.
DEF VAR res      AS TAArray NO-UNDO.
DEF VAR res1      AS TAArray NO-UNDO.

def var summPlus as Decimal Extent 5.
def var summMinus as Decimal Extent 5.

DEF VAR oAArray1 AS TAArray NO-UNDO.
DEF VAR oAArrayD AS TAArray NO-UNDO.

DEF VAR iDate    AS DATE    NO-UNDO.
DEF VAR nextDate AS DATE    NO-UNDO.
DEF VAR minDate  AS DATE    NO-UNDO.

DEF VAR key1     AS CHAR    NO-UNDO.
DEF VAR value1   AS CHAR    NO-UNDO.



DEF VAR nextPos  AS DECIMAL NO-UNDO.

DEF VAR currPos  AS DECIMAL NO-UNDO.

DEF VAR oLoan    AS TLoan   NO-UNDO.
DEF VAR oRes     AS TAArray NO-UNDO.

                    
oAcct = new TAcct(cAcct).

oAArray      = new TAArray().
res          = new TAArray().
res1         = new TAArray().
oAArrayD     = new TAArray().

/**
 * Часть №2.
 * Строим графики
 * стабильности.
 * Попутно строим графики возврата по штрафной ставке.
 * Попробуем ставку до востребования определить,
 * как пропорциональную к основной ставке.
 **/
minDate  = oAcct:open-date.

DO iDate = oAcct:open-date TO currDate:
     nextDate = iDate + 1.
     currPos = oAcct:getLastPos2Date(iDate).
     nextPos = oAcct:getLastPos2Date(nextDate).
     IF currPos <> nextPos THEN DO:
        oAArray:setH(STRING(minDate) + "-" + STRING(nextDate),currPos).
        oAArrayD:setH(STRING(minDate) + "-" + STRING(nextDate),ROUND(currPos * badRate / rate,2)).
        minDate = nextDate.
     END.
END.


/*******************
 * Часть №3.
 * Переоцениваем графики
 * стабильности.
 *******************/
DEF VAR dPGood    AS DECIMAL        NO-UNDO.
DEF VAR dMGood    AS DECIMAL        NO-UNDO.
DEF VAR dPBad     AS DECIMAL        NO-UNDO.
DEF VAR dMBad     AS DECIMAL        NO-UNDO.

DEF VAR dResP AS DECIMAL INIT 0 NO-UNDO.
DEF VAR dResM AS DECIMAL INIT 0 NO-UNDO.

DEF VAR key2   AS CHARACTER NO-UNDO.
DEF VAR value2 AS CHARACTER NO-UNDO.

DEF VAR dDateBeg AS DATE    NO-UNDO.
DEF VAR dDateEnd AS DATE    NO-UNDO.
DEF VAR dSum     AS DECIMAL NO-UNDO.

{foreach oAArray key1 value1}
  dDateBeg = DATE(ENTRY(1,key1,"-")).
  dDateEnd = DATE(ENTRY(2,key1,"-")) - 1.
  dSum     = DECIMAL(value1).

  IF dSum > 0 THEN DO:
      oAArray1 = TSysClass:doRevision(dSum,dDateBeg,dDateEnd,oAcct:currency).
        dPGood = IF DECIMAL(oAArray1:get("p+")) <> ? THEN DECIMAL(oAArray1:get("p+")) ELSE 0.
        dMGood = IF DECIMAL(oAArray1:get("p-")) <> ? THEN DECIMAL(oAArray1:get("p-")) ELSE 0.
        res:setH(STRING(dDateBeg) + "|" + STRING(dDateEnd) + "|" + STRING(dSum) + "|p+",STRING(dPGood)).
        res:setH(STRING(dDateBeg) + "|" + STRING(dDateEnd) + "|" + STRING(dSum) + "|p-",STRING(dMGood)).
     DELETE OBJECT oAArray1.
  END.
{endforeach oAArray}


/***************
 * Переоцениваем штрафную
 * ставку.
 ***************/
{foreach oAArrayD key1 value1}
  dDateBeg = DATE(ENTRY(1,key1,"-")).
  dDateEnd = DATE(ENTRY(2,key1,"-")) - 1.
  dSum     = DECIMAL(value1).

  IF dSum > 0 THEN DO:
      oAArray1 = TSysClass:doRevision(dSum,dDateBeg,dDateEnd,oAcct:currency).
        dPBad = IF DECIMAL(oAArray1:get("p+")) <> ? THEN DECIMAL(oAArray1:get("p+")) ELSE 0.
        dMBad = IF DECIMAL(oAArray1:get("p-")) <> ? THEN DECIMAL(oAArray1:get("p-")) ELSE 0.
        res1:setH(STRING(dDateBeg) + "|" + STRING(dDateEnd) + "|" + STRING(dSum) + "|p+",STRING(dPBad)).
        res1:setH(STRING(dDateBeg) + "|" + STRING(dDateEnd) + "|" + STRING(dSum) + "|p-",STRING(dMBad)).
     DELETE OBJECT oAArray1.
  END.
{endforeach oAArrayD}


/************************
 * Часть №4.
 * Выводим содержимое таблицы
 * по расчету
 ************************/
DEF VAR oTable  AS TTable NO-UNDO.
DEF VAR oTable1 AS TTable NO-UNDO.
oTable = new TTable(5).
{foreach res key1 value1}
  oTable:addRow().
  oTable:addCell(ENTRY(1,key1,"|")).
  oTable:addCell(ENTRY(2,key1,"|")).
  oTable:addCell(ENTRY(3,key1,"|")).
if ENTRY(4,key1,"|") = "p+" then do:
  oTable:addCell("p-").
  summMinus[1] = summMinus[1] + DECIMAL(value1).
end.
else
do:
  oTable:addCell("p+").
  summPlus[1] = summPlus[1] + DECIMAL(value1).
end.
  oTable:addCell(value1).
{endforeach res}

oTable1 = new TTable(5).
{foreach res1 key1 value1}
  oTable1:addRow().
  oTable1:addCell(ENTRY(1,key1,"|")).
  oTable1:addCell(ENTRY(2,key1,"|")).
  oTable1:addCell(ENTRY(3,key1,"|")).
if ENTRY(4,key1,"|") = "p+" then 
do:
  oTable1:addCell("p-").
  summMinus[2] = summMinus[2] + DECIMAL(value1).
end.
else
do:
  oTable1:addCell("p+").
  summPlus[2] = summPlus[2] + DECIMAL(value1).

end.
  oTable1:addCell(value1).
{endforeach res1}

DEF VAR res3   AS TAArray   NO-UNDO.
res3 = new TAArray().

{foreach res key1 value1}
   {foreach res1 key2 value2}
     IF ENTRY(1,key1,"|")=ENTRY(1,key2,"|") AND ENTRY(2,key1,"|")=ENTRY(2,key2,"|") AND ENTRY(4,key1,"|")=ENTRY(4,key2,"|") THEN DO:
         IF ENTRY(4,key2,"|") = "p+" THEN DO:
            res3:setH(ENTRY(1,key1,"|") + "|" + ENTRY(2,key1,"|") + "|" + "p+",STRING(DECIMAL(value2) - DECIMAL(value1))).
         END. ELSE DO:
            res3:setH(ENTRY(1,key1,"|") + "|" + ENTRY(2,key1,"|") + "|" + "p-",STRING(DECIMAL(value2) - DECIMAL(value1))).
         END.
     END.
   {endforeach res1}
{endforeach res}

DEF VAR oTable3 AS TTable NO-UNDO.

oTable3 = new TTable(4).
{foreach res3 key1 value1}
  oTable3:addRow().
  oTable3:addCell(ENTRY(1,key1,"|")).
  oTable3:addCell(ENTRY(2,key1,"|")).
if ENTRY(3,key1,"|") = "p+" then 
do:
  oTable3:addCell("p-").
   
/* message ENTRY(3,ENTRY(2,key1,"|"),"/") SUBSTRING(STRING(YEAR(TODAY)),3,2) VIEW-AS ALERT-BOX.*/

  if ENTRY(3,ENTRY(2,key1,"|"),"/") = SUBSTRING(STRING(YEAR(TODAY)),3,2) then 
    do:
       summMinus[5] = summMinus[5] + DECIMAL(value1). /* здесь храним переоценку "-" за текущий год */
    end.
  else
    do:
       summMinus[4] = summMinus[4] + DECIMAL(value1). /* здесь храним переоценку "-" за прошлый год */
    end.

  summMinus[3] = summMinus[3] + DECIMAL(value1).
  /*if entry(2)*/

end.
else
do:
  oTable3:addCell("p+"). 

  if ENTRY(3,ENTRY(2,key1,"|"),"/") = SUBSTRING(STRING(YEAR(TODAY)),3,2) then 
    do:
       summPlus[5] = summPlus[5] + DECIMAL(value1).  /*здесь храним переоценку "+" за текущий год*/
    end.
  else
    do:
       summPlus[4] = summPlus[4] + DECIMAL(value1). /*здесь храним переоценку "+" за прошлый год */
    end.


  summPlus[3] = summPlus[3] + DECIMAL(value1).
end.
  oTable3:addCell(value1).
{endforeach res3}




oTpl = new TTpl("pir-rasp-per880.tpl").

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("TABLE1",oTable1).
oTpl:addAnchorValue("TABLE2",oTable3).

oTpl:addAnchorValue("cAcct",oAcct:acct).


oTpl:addAnchorValue("DATE",STRING(end-date)).

oTpl:addAnchorValue("SummaPlus1",SummPlus[1]).
oTpl:addAnchorValue("SummaPlus2",SummPlus[2]).
oTpl:addAnchorValue("SummaPlus3",SummPlus[3]).

oTpl:addAnchorValue("SummaMinus1",SummMinus[1]).
oTpl:addAnchorValue("SummaMinus2",SummMinus[2]).
oTpl:addAnchorValue("SummaMinus3",SummMinus[3]).


/*
if oAcct:currency = "840" then 
do:
oTpl:addAnchorValue("VAL","долларах США").

oTpl:addAnchorValue("ACCT3","70603 810 3 0000 1510201").
oTpl:addAnchorValue("ACCT4","70608 810 2 0000 2410201").

if cParam = "СПОД" then 
   do:
      oTpl:addAnchorValue("YEAR_OTCH","до сдачи год.отчета т.е. СПОД").
      oTpl:addAnchorValue("ACCT1","70608 810 1 0000 2410201").
      oTpl:addAnchorValue("ACCT2","70601 810 2 0000 1510201").
   end.
else 
   do:
      oTpl:addAnchorValue("YEAR_OTCH","после сдачи год.отчета").
      oTpl:addAnchorValue("ACCT1","70601 810 5 0000 1720204").
      oTpl:addAnchorValue("ACCT2","70606 810 3 0000 2720204").
   end.

end.

if oAcct:currency = "978" then 
do:
oTpl:addAnchorValue("VAL","евро").

oTpl:addAnchorValue("ACCT3","70603 810 6 0000 1510202").
oTpl:addAnchorValue("ACCT4","70608 810 5 0000 2410202").

if cParam = "СПОД" then 
   do:
      oTpl:addAnchorValue("YEAR_OTCH","до сдачи год.отчета т.е. СПОД").
      oTpl:addAnchorValue("ACCT1","70708 810 4 0000 2410201").
      oTpl:addAnchorValue("ACCT2","70601 810 2 0000 1510201").
   end.
else 
   do:
      oTpl:addAnchorValue("YEAR_OTCH","после сдачи год.отчета").
      oTpl:addAnchorValue("ACCT1","70601 810 5 0000 1720204").
      oTpl:addAnchorValue("ACCT2","70601 810 3 0000 2720204").
   end.



end.*/

oTpl:addAnchorValue("rate",STRING(rate,">9.999")).
oTpl:addAnchorValue("badRate",STRING(badRate,">9.999")).

if showlog then do:

{setdest.i}
oTpl:show().
{preview.i}

end.

/**
 * Покажем, что получилось.
 **/
/*message "p+" SummPlus[3] SummPlus[4] SummPlus[5]  VIEW-AS ALERT-BOX.
message "p-" SummMinus[3] SummMinus[4] SummMinus[5]  VIEW-AS ALERT-BOX.*/

result = STRING(ABS(SummPlus[4])) + "," + STRING(ABS(SummPlus[5])) + "," + STRING(ABS(SummMinus[4])) + "," + STRING(ABS(SummMinus[5])).

DELETE OBJECT oAcct.
DELETE OBJECT oTable.
DELETE OBJECT oTable1.

DELETE OBJECT oAArray.
DELETE OBJECT oAArrayD.
DELETE OBJECT res.
DELETE OBJECT res1.
DELETE OBJECT res3.

{intrface.del}