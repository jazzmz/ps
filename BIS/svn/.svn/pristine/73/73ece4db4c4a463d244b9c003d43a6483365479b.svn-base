{bislogin.i}
{globals.i}
{sh-defs.i}


def temp-table tItog
     field dYear   as INT
     field dProfit as DEC
     field dReserv as DEC
     field acct-db as char
     field acct-cr as char
     field period as char.

def temp-table tItog2
     field dYear   as DEC
     field dProfit as DEC
     field dReserv as DEC
     field acct-db as char
     field acct-cr as char
     field period as char.

def temp-table tItog3
     field dYear   as INT
     field dProfit as DEC
     field dReserv as DEC
     field acct-db as char
     field acct-cr as char
     field period as char.

def temp-table tItog4
     field dYear   as INT
     field dProfit as DEC
     field dReserv as DEC
     field dPereoc as DEC 
     field period as char.


def temp-table tToFile
     field dYear   as INT
     field dProfit as DEC
     field dReserv as DEC 
     field dPereoc as DEC.


def temp-table tToFile2
     field dYear   as INT
     field dProfit as DEC
     field dReserv as DEC.

DEF VAR PrevTotal as dec.
DEF VAR PrevReserv as dec.
DEF VAR PrevPere as dec.

def var oTable as TTable.
def var oTable2 as TTable.
def var oTable3 as TTable.
def var oTable4  as TTable.
def var oTable5  as TTable.
def var oTable6  as TTable.


def var prevYear as dec no-undo.
def var iYear as int NO-UNDO.
def var i as int NO-UNDO.

/*первый график*/


oTable = new TTable(5).
oTable2 = new TTable(5).
oTable3 = new TTable(2).
oTable4 = new TTable(5).
oTable5 = new TTable(2).
oTable6 = new TTable(6).

FUNCTION CalcKvartal RETURNS DEC (INPUT iDate AS DATE, INPUT iAcct-list as CHAR):

 def var temp as dec INIT 0 NO-UNDO.

    for each acct where can-do(iAcct-list,acct.acct)
                    and (acct.close-date >= iDate OR acct.close-date = ?)
                    and acct.open-date <= iDate NO-LOCK:

                       RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              iDate,
                              iDate,
                              ?).

           temp = temp + ABS(sh-in-bal).
    END.

  RETURN temp.

END FUNCTION.

FUNCTION CalcOborot RETURNS DEC (INPUT iBeg-Date AS DATE, INPUT iEnd-Date AS DATE, INPUT iAcct-Db as CHAR, INPUT iAcct-cr as CHAR):

 def var temp as dec INIT 0 NO-UNDO.

  FOR EACH op-entry where op-entry.op-date >= iBeg-Date 
                      and op-entry.op-date <= iEnd-Date 
                      and CAN-DO(iAcct-Db,op-entry.acct-db) 
                      and CAN-DO(iAcct-cr,op-entry.acct-cr) 
                      and op-entry.acct-cat = "b" NO-LOCK.
  temp = temp + op-entry.amt-rub.

 END.


  RETURN temp.

END FUNCTION.




FOR EACH code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'График 1' /*and code.code = "PIR4158_2"*/ NO-LOCK.
  PrevTotal = 0.
	
  FOR EACH op-entry where op-entry.op-date >= DATE(ENTRY(1,code.description[2])) 
                      and op-entry.op-date <= DATE(ENTRY(2,code.description[2])) 
                      and CAN-DO(TRIM(code.val),op-entry.acct-db) 
                      and CAN-DO(TRIM(code.description[1]),op-entry.acct-cr) 
                      and op-entry.acct-cat = "b" NO-LOCK.
  PrevTotal = PrevTotal + op-entry.amt-rub.

 END.
  CREATE tItog.

 ASSIGN tItog.dYear = INT(code.name)
        tItog.dProfit = PrevTotal
        tItog.acct-db = TRIM(code.val)
        tItog.acct-cr = TRIM(code.description[1])
        tItog.period  = TRIM(code.description[2]).

END.
/*
FOR EACH code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'График 2' and code.name begins "2" /*and code.code = "PIR4158_2"*/ NO-LOCK.
  PrevTotal = 0.

  FOR EACH op-entry where op-entry.op-date >= DATE(ENTRY(1,code.description[2])) 
                      and op-entry.op-date <= DATE(ENTRY(2,code.description[2])) 
/*                     and CAN-DO(TRIM(code.val),op-entry.acct-db) */
                      and CAN-DO(TRIM(code.description[1]),op-entry.acct-cr) 
                      and op-entry.acct-cat = "b" NO-LOCK.
  PrevTotal = PrevTotal + op-entry.amt-rub.

 END.
  CREATE tItog2.

 ASSIGN tItog2.dYear = INT(code.name)
        tItog2.dProfit = PrevTotal
        tItog2.acct-db = TRIM(code.val)
        tItog2.acct-cr = TRIM(code.description[1])
        tItog2.period  = TRIM(code.description[2]).

END.

FOR EACH code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'График 3' /*and code.code = "PIR4158_2"*/ NO-LOCK.
  PrevTotal = 0.

  FOR EACH op-entry where op-entry.op-date >= DATE(ENTRY(1,code.description[2])) 
                      and op-entry.op-date <= DATE(ENTRY(2,code.description[2])) 
/*                      and CAN-DO(TRIM(code.val),op-entry.acct-db) */
                      and CAN-DO(TRIM(code.description[1]),op-entry.acct-cr) 
                      and op-entry.acct-cat = "b" NO-LOCK.
  PrevTotal = PrevTotal + op-entry.amt-rub.

 END.
  CREATE tItog3.

 ASSIGN tItog3.dYear = INT(code.name)
        tItog3.dProfit = PrevTotal
        tItog3.acct-db = TRIM(code.val)
        tItog3.acct-cr = TRIM(code.description[1])
        tItog3.period  = TRIM(code.description[2]).

END.


 */

for each tItog by tItog.dYear:
   oTable:addRow().
   oTable:addCell(tItog.dYear).
   oTable:addCell(tItog.dProfit).
   oTable:addCell(tItog.period).
   oTable:addCell(tItog.acct-db).
   oTable:addCell(tItog.acct-cr).

   find first tToFile where tToFile.dYear = tItog.dYear NO-ERROR.

   if not available (tToFile) THEN CREATE tToFile.
   ASSIGN
   tToFile.dYear = tItog.dYear
   tToFile.dProfit = tToFile.dProfit + tItog.dProfit.

END.

                     
for each tItog2 by tItog2.dYear:
   oTable2:addRow().
   oTable2:addCell(tItog2.dYear).
   oTable2:addCell(tItog2.dProfit).
   oTable2:addCell(tItog2.period).
   oTable2:addCell(tItog2.acct-db).
   oTable2:addCell(tItog2.acct-cr).

   find first tToFile where tToFile.dYear = tItog2.dYear NO-ERROR.

   if not available (tToFile) THEN CREATE tToFile.

   ASSIGN
   tToFile.dYear = tItog2.dYear
   tToFile.dReserv = tToFile.dReserv + tItog2.dProfit.
  

END.

for each tItog3 by tItog3.dYear:
   oTable4:addRow().
   oTable4:addCell(tItog3.dYear).
   oTable4:addCell(tItog3.dProfit).
   oTable4:addCell(tItog3.period).
   oTable4:addCell(tItog3.acct-db).
   oTable4:addCell(tItog3.acct-cr).

   find first tToFile where tToFile.dYear = tItog3.dYear NO-ERROR.

   if not available (tToFile) THEN CREATE tToFile.

   ASSIGN
   tToFile.dYear = tItog3.dYear
   tToFile.dPereoc = tToFile.dPereoc + tItog3.dProfit.
  

END.




OUTPUT TO "1.txt". 

for each tToFile by tToFile.dYear:
    PUT UNFORMATTED STRING(tToFile.dYear) + CHR(9) + STRING(tToFile.dProfit) SKIP.
   oTable3:addRow().
   oTable3:addCell(tToFile.dYear).
   oTable3:addCell(tToFile.dProfit - tToFile.dReserv).
end.

OUTPUT CLOSE.

OUTPUT TO "2.txt". 

for each tToFile by tToFile.dYear:
    PUT UNFORMATTED STRING(tToFile.dYear) + CHR(9) + STRING(tToFile.dProfit - tToFile.dReserv) SKIP.
end.

OUTPUT CLOSE.


OUTPUT TO "3.txt". 

for each tToFile by tToFile.dYear:
    PUT UNFORMATTED STRING(tToFile.dYear) + CHR(9) + STRING(tToFile.dProfit - tToFile.dReserv - tToFile.dPereoc) SKIP.
   oTable5:addRow().
   oTable5:addCell(tToFile.dYear).
   oTable5:addCell(tToFile.dProfit - tToFile.dReserv - tToFile.dPereoc).
end.

OUTPUT CLOSE.



OUTPUT TO VALUE("sc1.plt") CONVERT TARGET "UTF-8".

PUT UNFORMATTED "set terminal svg font ""Times New Roman,16"" size 1250, 1000" SKIP.
PUT UNFORMATTED "set output " + CHR(39) + "1.svg" + CHR(39) SKIP.
PUT UNFORMATTED "set encoding utf8" SKIP.
PUT UNFORMATTED "set xlabel ""Год"" " SKIP.
PUT UNFORMATTED "set ylabel ""Руб."" " SKIP.
PUT UNFORMATTED "set grid ytics" SKIP.
PUT UNFORMATTED "set grid xtics" SKIP.
PUT UNFORMATTED "set decimalsign locale" SKIP.
PUT UNFORMATTED "set format y ""%'12.0f""" SKIP.
PUT UNFORMATTED "set style data boxes" SKIP.
PUT UNFORMATTED "set boxwidth 0.95 absolute" SKIP.
PUT UNFORMATTED "set style fill solid 1 border lt -1 " SKIP.
PUT UNFORMATTED "plot " + CHR(39) + "1.txt" + CHR(39) + " u 1:2 ti ""Валовая прибыль"" " SKIP.

OUTPUT CLOSE.


OUTPUT TO VALUE("sc2.plt") CONVERT TARGET "UTF-8".

PUT UNFORMATTED "set terminal svg font ""Times New Roman,16"" size 1250, 1000" SKIP.
PUT UNFORMATTED "set output " + CHR(39) + "2.svg" + CHR(39) SKIP.
PUT UNFORMATTED "set encoding utf8" SKIP.
PUT UNFORMATTED "set xlabel ""Год"" " SKIP.
PUT UNFORMATTED "set ylabel ""Руб."" " SKIP.
PUT UNFORMATTED "set grid ytics" SKIP.
PUT UNFORMATTED "set grid xtics" SKIP.
PUT UNFORMATTED "set decimalsign locale" SKIP.
PUT UNFORMATTED "set format y ""%'12.0f""" SKIP.
PUT UNFORMATTED "set style data boxes" SKIP.
PUT UNFORMATTED "set boxwidth 0.95 absolute" SKIP.
PUT UNFORMATTED "set style fill solid 1 border lt -1 " SKIP.
PUT UNFORMATTED "plot " + CHR(39) + "2.txt" + CHR(39) + " u 1:2 ti ""Валовая прибыль - резерв"" " SKIP.

OUTPUT CLOSE.

OUTPUT TO VALUE("sc3.plt") CONVERT TARGET "UTF-8".

PUT UNFORMATTED "set terminal svg font ""Times New Roman,16"" size 1250, 1000" SKIP.
PUT UNFORMATTED "set output " + CHR(39) + "3.svg" + CHR(39) SKIP.
PUT UNFORMATTED "set encoding utf8" SKIP.
PUT UNFORMATTED "set xlabel ""Год"" " SKIP.
PUT UNFORMATTED "set ylabel ""Руб."" " SKIP.
PUT UNFORMATTED "set grid ytics" SKIP.
PUT UNFORMATTED "set grid xtics" SKIP.
PUT UNFORMATTED "set decimalsign locale" SKIP.
PUT UNFORMATTED "set format y ""%'12.0f""" SKIP.
PUT UNFORMATTED "set style data boxes" SKIP.
PUT UNFORMATTED "set boxwidth 0.95 absolute" SKIP.
PUT UNFORMATTED "set style fill solid 1 border lt -1 " SKIP.
PUT UNFORMATTED "plot " + CHR(39) + "3.txt" + CHR(39) + " u 1:2 ti ""Валовая прибыль  - резерв - переоценка"" " SKIP.

OUTPUT CLOSE.

/*СТРОЕМ СЛЕДУЮЩИЕ ПОКВАРТАЛЬНЫЕ ГРАФИКИ*/

Message "Посчитали первую группы графиков" VIEW-AS ALERT-BOX.
def var cAcctss AS CHAR INIT "70603810300001510201,70603810600001510202" NO-UNDO.
def var cAcctss2 AS CHAR INIT "707*00001510201,707*00001510202" NO-UNDO.
def var SubTotal as DEC EXTENT 3 NO-UNDO.

DO iYear = 2009 to 2013: 
       SubTotal[1] = 0.
       SubTotal[2] = 0.
       SubTotal[3] = 0.

       if iYear = 2013 then cAcctss = "70603810800001510206,70603810100001510207,70603810400001510208,70603810700001510209,70603810100001510210,70603810400001510211".
       ELSE cAcctss = "70603810300001510201,70603810600001510202".

       if iYear = 2013 then cAcctss2 = "707*00001510206,707*00001510207,707*00001510208,707*00001510209,707*00001510210,707*00001510211".
       ELSE cAcctss2 = "707*00001510201,707*00001510202".

       PrevTotal  = CalcKvartal(DATE("01/04/" + STRING(iYear)),"70601*,70602*,70603*,70604*,70605*").
       PrevReserv = CalcOborot(DATE("01/01/" + STRING(iYear)),DATE("31/03/" + STRING(iYear)),"*","70601810*000016305*").
       PrevPere   = CalcOborot(DATE("01/01/" + STRING(iYear)),DATE("31/03/" + STRING(iYear)),"*",cAcctss).
       SubTotal[1] = PrevTotal.
       CREATE tItog4.
       ASSIGN 
             tItog4.dYear   = iYear
             tItog4.dProfit = PrevTotal
             tItog4.dReserv = PrevReserv
             tItog4.dPereoc = PrevPere
             tItog4.period  = STRING(iYear) + " 1 кв.".
 

       PrevTotal  = CalcKvartal(DATE("01/07/" + STRING(iYear)),"70601*,70602*,70603*,70604*,70605*") - SubTotal[1].
       PrevReserv = CalcOborot(DATE("01/04/" + STRING(iYear)),DATE("30/06/" + STRING(iYear)),"*","70601810*000016305*").
       PrevPere   = CalcOborot(DATE("01/04/" + STRING(iYear)),DATE("30/06/" + STRING(iYear)),"*",cAcctss).
       SubTotal[2] = PrevTotal.
       CREATE tItog4.
       ASSIGN 
             tItog4.dYear   = iYear
             tItog4.dProfit = PrevTotal
             tItog4.dReserv = PrevReserv
             tItog4.dPereoc = PrevPere
             tItog4.period  = STRING(iYear) + " 2 кв.".
                                    
       PrevTotal  = CalcKvartal(DATE("01/10/" + STRING(iYear)),"70601*,70602*,70603*,70604*,70605*") - SubTotal[2] - SubTotal[1].
       PrevReserv = CalcOborot(DATE("01/07/" + STRING(iYear)),DATE("30/09/" + STRING(iYear)),"*","70601810*000016305*").
       PrevPere   = CalcOborot(DATE("01/07/" + STRING(iYear)),DATE("30/09/" + STRING(iYear)),"*",cAcctss).
       SubTotal[3] = PrevTotal.
       CREATE tItog4.
       ASSIGN 
             tItog4.dYear   = iYear
             tItog4.dProfit = PrevTotal
             tItog4.dReserv = PrevReserv
             tItog4.dPereoc = PrevPere
             tItog4.period  = STRING(iYear) + " 3 кв.".

    if iYear <> 2013 then do:


       PrevReserv = CalcOborot(DATE("01/10/" + STRING(iYear)),DATE("31/12/" + STRING(iYear)),"*","70601810*000016305*").
       PrevPere   = CalcOborot(DATE("01/10/" + STRING(iYear)),DATE("31/12/" + STRING(iYear)),"*",cAcctss).

       prevYear = 0.
       for each tItog where tItog.dYear = iYear.
           prevYear = prevYear + tItog.dProfit.
       END.

       CREATE tItog4.
       ASSIGN 
             tItog4.dYear   = iYear
             tItog4.dProfit = prevYear - SubTotal[1] - SubTotal[2] - SubTotal[3] 
             tItog4.dReserv = PrevReserv
             tItog4.dPereoc = PrevPere
             tItog4.period  = STRING(iYear) + " 4 кв.".

      END.
/*    END.         */

END.

oTable6:AddRow().
oTable6:AddCell("Период").
oTable6:AddCell("Прибыль").
oTable6:AddCell("Резерв").
oTable6:AddCell("Переоценка").
oTable6:AddCell("Прибыль - Резерв").
oTable6:AddCell("Прибыль - Резерв - Переоценка").



FOR EACH tItog4 by tItog4.period:

oTable6:AddRow().
oTable6:AddCell(tItog4.period).
oTable6:AddCell(TRIM(STRING(tItog4.dProfit,"->>>,>>>,>>>,>>>,>>>,>>9.99"))).
oTable6:AddCell(TRIM(STRING(tItog4.dReserv,"->>>,>>>,>>>,>>>,>>>,>>9.99"))).
oTable6:AddCell(TRIM(STRING(tItog4.dPereoc,"->>>,>>>,>>>,>>>,>>>,>>9.99"))).
oTable6:AddCell(TRIM(STRING(tItog4.dProfit - tItog4.dReserv,"->>>,>>>,>>>,>>>,>>>,>>9.99"))).
oTable6:AddCell(TRIM(STRING(tItog4.dProfit - tItog4.dReserv - tItog4.dPereoc,"->>>,>>>,>>>,>>>,>>>,>>9.99"))).

END.




OUTPUT TO "4.txt". 
i = 0.
for each tItog4 by tItog4.period:
    i = i + 1.
    PUT UNFORMATTED STRING(i) + CHR(9) + STRING(tItog4.dProfit) SKIP.
end.

OUTPUT CLOSE.

OUTPUT TO "5.txt". 
i = 0.

for each tItog4 by tItog4.period:
    i = i + 1.
    PUT UNFORMATTED STRING(i) + CHR(9) + STRING(tItog4.dProfit - tItog4.dReserv) SKIP.
end.

OUTPUT CLOSE.


OUTPUT TO "6.txt". 
i = 0.

for each tItog4 by tItog4.period:
    i = i + 1.
    PUT UNFORMATTED STRING(i) + CHR(9) + STRING(tItog4.dProfit - tItog4.dReserv - tItog4.dPereoc) SKIP.
end.

OUTPUT CLOSE.



/**/

{setdest.i}

 PUT UNFORMATTED "Табл.1 Валовая прибыль" SKIP.
 oTable:show().
 PUT UNFORMATTED  SKIP(2).
 PUT UNFORMATTED "Табл.2 Резерв" SKIP.
 oTable2:show().
 PUT UNFORMATTED  SKIP(2).
 PUT UNFORMATTED "Табл.3 Переоценка" SKIP.
 oTable4:show().
 PUT UNFORMATTED  SKIP(2).
 PUT UNFORMATTED "Табл.4 Табл.1 - Табл.2." SKIP.
 oTable3:show().
 PUT UNFORMATTED  SKIP(2).
 PUT UNFORMATTED "Табл.5 Табл.1 - Табл.2 - Табл.3" SKIP.
 oTable5:show().
 PUT UNFORMATTED  SKIP(2).
 PUT UNFORMATTED "Табл.6 Поквартально" SKIP.
 oTable6:show().


{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTable2.
DELETE OBJECT oTable3.
DELETE OBJECT oTable4.
DELETE OBJECT oTable5.
DELETE OBJECT oTable6.

