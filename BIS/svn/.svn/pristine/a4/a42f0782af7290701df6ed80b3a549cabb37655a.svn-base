/********************************
 * Обработка определения	*
 * требуемой переоценки.        *
 * ОЖидается, что будет выбран
 * счет начисления процентов.
 ********************************
 * Заявка: #880                 *
 * Автор: Маслов Д. А.          *
 ********************************/

 DEF INPUT PARAM cParam AS CHARACTER NO-UNDO. 

{globals.i}
{tmprecid.def}
{intrface.get tmess}

{ulib.i}

def var TempDate as Date    NO-UNDO.
def var tempSTR1 as CHAR    NO-UNDO.
def var TempSTR2 as CHAR    NO-UNDO.


DEF VAR currDate AS DATE    NO-UNDO.

DEF VAR cAcct    AS CHAR    NO-UNDO.

DEF VAR oAcct    AS TAcct   NO-UNDO.

def var oTPL     AS TTpl NO-UNDO.

DEF VAR oAArray  AS TAArray NO-UNDO.
DEF VAR res      AS TAArray NO-UNDO.
DEF VAR res1      AS TAArray NO-UNDO.

def var summPlus  as Decimal Extent 3 NO-UNDO.
def var summMinus as Decimal Extent 3 NO-UNDO.

DEF VAR oAArray1 AS TAArray NO-UNDO.
DEF VAR oAArrayD AS TAArray NO-UNDO.

DEF VAR iDate    AS DATE    NO-UNDO.
DEF VAR nextDate AS DATE    NO-UNDO.
DEF VAR minDate  AS DATE    NO-UNDO.

DEF VAR key1     AS CHAR    NO-UNDO.
DEF VAR value1   AS CHAR    NO-UNDO.

DEF VAR rate     AS DECIMAL LABEL "Основная ставка" NO-UNDO.
DEF VAR badRate  AS DECIMAL LABEL "Штрафная ставка" NO-UNDO.

DEF VAR nextPos  AS DECIMAL NO-UNDO.

DEF VAR currPos  AS DECIMAL NO-UNDO.

DEF VAR oLoan    AS TLoan   NO-UNDO.
DEF VAR oRes     AS TAArray NO-UNDO.

DEF FRAME inpPercent
    "Введите основную % ставку: " Rate NO-LABEL SKIP
    "Введите штрафную  % ставку:" badRate NO-LABEL SKIP
.


FIND FIRST tmprecid NO-LOCK. 

IF NOT AVAILABLE(tmprecid) THEN MESSAGE COLOR WHITE/RED "Не найден tmprecid" VIEW-AS ALERT-BOX.

find first acct where RECID(acct) = tmprecid.id NO-LOCK NO-ERROR.

cAcct = acct.acct.

oAcct = new TAcct(cAcct).

{getdate.i}
currDate = end-date.

RUN Fill-SysMes IN h_tmess ("","",3,"Выберите вариант расчет|Ввод вручную,Из договора ЧВ,Из договора ЮР").


/***
 * Часть №1.
 * Определяем ставку по вкладу.
 ***/
CASE pick-value:
    WHEN "1" THEN DO:
          /**
           * Вводим параметры вручную.
           **/
       ENABLE ALL WITH FRAME inpPercent.
       WAIT-FOR "GO" OF FRAME inpPercent.

       ASSIGN
        Rate    = DECIMAL(Rate:SCREEN-VALUE)
        badRate = DECIMAL(badRate:SCREEN-VALUE)
       .

    END.
    WHEN "2" THEN DO:
          /**
           * Определяем параметры из договора ЧВ.
           **/
          oLoan   = TLoan:initByAcct("dps",cAcct,currDate).

          IF oLoan = ? THEN DO:
            MESSAGE COLOR WHITE/RED "Не найден договор вклада для счета: " cAcct VIEW-AS ALERT-BOX.              
          END.

          Rate    = GetDpsCommission_ULL(oLoan:cont-code, "commission", currDate, false).         
          badRate = 0.01.
          DELETE OBJECT oLoan NO-ERROR.

    END.
    WHEN "3" THEN DO:
          oLoan   = TLoan:initByAcct("Депоз",cAcct,currDate).

          IF oLoan = ? THEN DO:
            MESSAGE COLOR WHITE/RED "Не найден договор вклада для счета: " cAcct VIEW-AS ALERT-BOX.              
          END.

          oRes    = oLoan:getCommisionValue(currDate).
          Rate    = DECIMAL(TRIM(oRes:get("%Деп"),'%')).
          badRate = 0.01.

          DELETE OBJECT oRes  NO-ERROR.
          DELETE OBJECT oLoan NO-ERROR.
    END.
END CASE.

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
      /**
       * В doRevision "сидит" переоценка
       * включая пограничную справа дату.
       * Групо говоря, в этой функции расчитывается переоценка
       * между dDateEnd и dDateEnd + 1
       **/
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

if ENTRY(4,key1,"|") = "p-" then do:
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

if ENTRY(4,key1,"|") = "p-" then 
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
if ENTRY(3,key1,"|") = "p-" then 
do:
  oTable3:addCell("p-").
  summMinus[3] = summMinus[3] + DECIMAL(value1).
end.
else
do:
  oTable3:addCell("p+"). 
  summPlus[3] = summPlus[3] + DECIMAL(value1).
end.
  oTable3:addCell(value1).
{endforeach res3}



if cParam = "СПОД" then oTpl = new TTpl("pir-rasp-per880spod.tpl").
else oTpl = new TTpl("pir-rasp-per880.tpl").


oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("TABLE1",oTable1).
oTpl:addAnchorValue("TABLE2",oTable3).

oTpl:addAnchorValue("cAcct",oAcct:acct).


oTpl:addAnchorValue("DATE",STRING(end-date)).

if oAcct:activity = "А" THEN 
  DO:

    oTpl:addAnchorValue("SummaPlus1",SummPlus[1]).
    oTpl:addAnchorValue("SummaPlus2",SummPlus[2]).
    oTpl:addAnchorValue("SummaPlus3",SummPlus[3]).

    oTpl:addAnchorValue("SummaMinus1",SummMinus[1]).
    oTpl:addAnchorValue("SummaMinus2",SummMinus[2]).
    oTpl:addAnchorValue("SummaMinus3",SummMinus[3]).

  END.

if oAcct:activity = "П" THEN 
  DO:

    oTpl:addAnchorValue("SummaPlus1",SummMinus[1]).
    oTpl:addAnchorValue("SummaPlus2",SummMinus[2]).
    oTpl:addAnchorValue("SummaPlus3",SummMinus[3]).

    oTpl:addAnchorValue("SummaMinus1",SummPlus[1]).
    oTpl:addAnchorValue("SummaMinus2",SummPlus[2]).
    oTpl:addAnchorValue("SummaMinus3",SummPlus[3]).

  END.

 
if cParam <> "СПОД" then 
DO:
oTpl:addAnchorValue("ThisYear","  * за текущий год " + CHR(10) + 
"  - #ACCT3# для р+ " + CHR(10) + 
"  - #ACCT4# для p-").
     oTpl:addAnchorValue("YEAR_OTCH","после сдачи год.отчета").
end.

if cParam = "СПОД" then oTpl:addAnchorValue("YEAR_OTCH","до сдачи год.отчета т.е. СПОД").
if oAcct:currency = "840" then oTpl:addAnchorValue("VAL","долларах США").
if oAcct:currency = "826" then oTpl:addAnchorValue("VAL","фунтов").
if oAcct:currency = "978" then oTpl:addAnchorValue("VAL","евро").



/*   */

TempDate = 01/01/1099.

for each code where code.class = "PirRasp" and code.parent = "PirRasp" 
		and code.name = "pir-rasp-per880"
		and code.val MATCHES "*" + oAcct:currency + "*" + cParam
		and code.description[3] MATCHES "*" + oAcct:activity + "*" 
		NO-LOCK: 

    if date(code.description[2]) >= Tempdate and date(code.description[2]) <= currDate then 
       do:                         	 
          Tempdate = date(code.description[2]).
          if can-do("*Текущий*",code.val) then tempstr1 = code.description[1].
          if can-do("*Прошлый" + cParam,code.val) then tempstr2 = code.description[1].



       end.
end.


if tempstr2 <> ? and tempstr2 <> "" then do:

   oTpl:addAnchorValue("ACCT1",Entry(1,tempstr2)).
   oTpl:addAnchorValue("ACCT2",Entry(2,tempstr2)).
end.

if tempstr1 <> ? and tempstr1 <> "" and cParam <> "СПОД" then do:
   oTpl:addAnchorValue("ACCT3",Entry(1,tempstr1)).
   oTpl:addAnchorValue("ACCT4",Entry(2,tempstr1)).
end.


/*   */


oTpl:addAnchorValue("rate",STRING(rate,">9.999")).
oTpl:addAnchorValue("badRate",STRING(badRate,">9.999")).

{setdest.i}
oTpl:show().
{preview.i}

/**
 * Покажем, что получилось.
 **/

DELETE OBJECT oAcct.
DELETE OBJECT oTable.
DELETE OBJECT oTable1.

DELETE OBJECT oAArray.
DELETE OBJECT oAArrayD.
DELETE OBJECT res.
DELETE OBJECT res1.
DELETE OBJECT res3.

{intrface.del}