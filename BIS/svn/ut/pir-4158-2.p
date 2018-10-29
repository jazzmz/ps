{bislogin.i}
{globals.i}

DEF TEMP-TABLE Itog
    field Id As CHAR
    field iYear as INT
    field dProfit as DEC.


    
def var i as int no-undo.
def var iDate as int no-undo.

def var dPer1beg as DATE no-undo.
def var dPer1end as DATE no-undo.
def var dPer2beg as DATE no-undo. 
def var dPer2end as DATE no-undo. 

def var oTable AS TTable no-undo.

def var subitog1 as dec no-undo.
def var subitog2 as dec no-undo.
def var subitog3 as dec no-undo.
def var subitog4 as dec no-undo.


FUNCTION CalcOborot RETURNS DEC (INPUT iBeg-Date AS DATE, INPUT iEnd-Date AS DATE, INPUT iAcct-Db as CHAR, INPUT iAcct-cr as CHAR):

 def var temp as dec INIT 0 NO-UNDO.
 /*делаем оптимизирующий быдлокод*/
  if iAcct-Db <> "" and iAcct-cr <> "" then DO:
  IF iAcct-db = "*" then do:

  FOR EACH bal-acct where CAN-DO(SUBSTRING(iAcct-cr,1,5),STRING(bal-acct.bal-acct)) NO-LOCK,
  EACH acct of bal-acct where CAN-DO(iAcct-cr,acct.acct) 
                  AND acct.open-date <= iEnd-Date
                  AND (acct.close-date >= iBeg-DATE or acct.close-date = ?)
                  NO-LOCK:



         FOR EACH op-entry where op-entry.op-date >= iBeg-Date 
                             and op-entry.op-date <= iEnd-Date 
                             and op-entry.acct-cr = acct.acct
                             and op-entry.acct-cat = "b" NO-LOCK.

            temp = temp + op-entry.amt-rub.


         END.

                                      

      END.
  END.       /*  IF iAcct-db = "*" then do:*/
  ELSE 
  DO:
  IF iAcct-cr = "*" then do:
  FOR EACH bal-acct where CAN-DO(SUBSTRING(iAcct-cr,1,5),STRING(bal-acct.bal-acct)) NO-LOCK,
  EACH acct of bal-acct where CAN-DO(iAcct-db,acct.acct) 
                  AND acct.open-date <= iEnd-Date
                  AND (acct.close-date >= iBeg-DATE or acct.close-date = ?)
                  NO-LOCK:

         FOR EACH op-entry where op-entry.op-date >= iBeg-Date 
                             and op-entry.op-date <= iEnd-Date 
                             and op-entry.acct-db = acct.acct
                             and op-entry.acct-cat = "b" NO-LOCK.
                temp = temp + op-entry.amt-rub.
         END.
      END.
  END.
  END. 

  IF iAcct-db <> "*" and iAcct-cr <> "*" then do:

  FOR EACH op-entry where op-entry.op-date >= iBeg-Date 
                      and op-entry.op-date <= iEnd-Date 
                      and CAN-DO(iAcct-Db,op-entry.acct-db) 
                      and CAN-DO(iAcct-cr,op-entry.acct-cr) 
                      and op-entry.acct-cat = "b" NO-LOCK.
  temp = temp + op-entry.amt-rub.


  END.

 END.
 END.

  RETURN temp.

END FUNCTION.

FUNCTION CalcSubCode RETURNS DEC (INPUT dYear AS int, INPUT SubCodes AS CHAR):

  def var temp as dec INIT 0 NO-UNDO.

  FOR EACH Itog WHERE CAN-DO(Subcodes,Itog.iD) AND itog.iyear = dYear NO-LOCK.
     temp = temp + Itog.dProfit. 
  END.
  RETURN temp.
END FUNCTION.


/*PROCEDURE*/ 

oTable = new TTAble(5).

oTable:colsWidthList="4,30,30,30,30".

FOR EACH code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'Пирожок' and CAN-DO("!NR*,MR_0*,PR_04",code.code) NO-LOCK BREAK BY code.

  if FIRST-OF(code.code) THEN 
     DO:
        oTable:addRow().
        oTable:addCell(code.description[3]).
        oTable:setColspan(1,oTable:currRow,5).
        oTable:addRow().
        oTable:addCell("").
        oTable:addCell("").
        oTable:addCell(ENTRY(1,code.val,"|")).
        oTable:addCell(ENTRY(1,code.val,"|")).
        oTable:addCell(code.description[1]).
        oTable:addRow().
        oTable:addCell("").
        oTable:addCell("").
        oTable:addCell(ENTRY(1,code.description[2],"|")).
        oTable:addCell(ENTRY(1,code.description[2],"|")).
        oTable:addCell(ENTRY(2,code.description[2],"|")).
     END.
  DO iDate = INT(ENTRY(1,code.name)) to INT(ENTRY(2,code.name)):
     dPer1beg = DATE(REPLACE(ENTRY(1,ENTRY(1,code.description[2],"|")),"YEAR",STRING(iDATE))).
     dPer1end = DATE(REPLACE(ENTRY(2,ENTRY(1,code.description[2],"|")),"YEAR",STRING(iDATE))).                                   
     dPer2beg = DATE(REPLACE(ENTRY(1,ENTRY(2,code.description[2],"|")),"YEAR",STRING(iDATE + 1))).
     dPer2end = DATE(REPLACE(ENTRY(2,ENTRY(2,code.description[2],"|")),"YEAR",STRING(iDATE + 1))).
     if code.code <> "MR_04" THEN subitog1 = CalcOborot(dPer1beg,dPer1end,"*",ENTRY(1,code.val,"|")). 
     subitog2 = CalcOborot(dPer1beg,dPer1end,ENTRY(1,code.val,"|"),"*").          
     subitog3 = CalcOborot(dPer2beg,dPer2end,"*",code.description[1]).

     if code.code = "MR_04" THEN subitog1 = CalcOborot(dPer1beg,dPer1end,"*","70601810600001210203,70601810900001210204,70601810700001210213,70601810000001210214,70601810300001210215,70601810600001210216,70601810500001210219,70601810200001220101,70601810500001620304,70601810800001620305,70601810000001620325,70601810300001620326,70601810200001710103,70601810500001710104,70601810500001710201,70601810800001710202,70601810600001720201,70601810900001720202,70601810100001111501,70601810400001111502"). 


     if NUM-ENTRIES(code.val,"|") = 2 then subitog4 = CalcSubCode(iDate,ENTRY(2,code.val,"|")). else subitog4 = 0.

     CREATE Itog.
     ASSIGN 
           Itog.Id = code.code
           Itog.iYear = iDate
           dProfit =  subitog1 
                     - subitog2 
                     + subitog3 - subitog4. 


   oTable:addRow().
   oTable:addCell(itog.iYear).
   oTable:addCell(itog.dProfit).
   oTable:addCell(subitog1).
   oTable:addCell(subitog2).
   oTable:addCell(subitog3).

  END.


END.            
              
/*MESSAGE "посчитали первый блок"  VIEW-AS ALERT-BOX.

FOR EACH code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'Пирожок' and CAN-DO("NR_08",code.code) NO-LOCK BREAK BY code.

  if FIRST-OF(code.code) THEN 
     DO:
        oTable:addRow().
        oTable:addCell(code.description[3]).
        oTable:setColspan(1,oTable:currRow,5).
        oTable:addRow().
        oTable:addCell("").
        oTable:addCell("").
        oTable:addCell(ENTRY(1,code.val,"|")).
        oTable:addCell(ENTRY(1,code.val,"|")).
        oTable:addCell(code.description[1]).
        oTable:addRow().
        oTable:addCell("").
        oTable:addCell("").
        oTable:addCell(ENTRY(1,code.description[2],"|")).
        oTable:addCell(ENTRY(1,code.description[2],"|")).
        oTable:addCell(ENTRY(2,code.description[2],"|")).
     END.
  DO iDate = INT(ENTRY(1,code.name)) to INT(ENTRY(2,code.name)):
     dPer1beg = DATE(REPLACE(ENTRY(1,ENTRY(1,code.description[2],"|")),"YEAR",STRING(iDATE + 1))).
     dPer1end = DATE(REPLACE(ENTRY(2,ENTRY(1,code.description[2],"|")),"YEAR",STRING(iDATE + 1))).                                   
     dPer2beg = DATE(REPLACE(ENTRY(1,ENTRY(2,code.description[2],"|")),"YEAR",STRING(iDATE + 1))).
     dPer2end = DATE(REPLACE(ENTRY(2,ENTRY(2,code.description[2],"|")),"YEAR",STRING(iDATE + 1))).


     subitog1 = CalcOborot(dPer1beg,dPer1end,ENTRY(1,code.val,"|"),ENTRY(1,code.description[1],"|")). 

/*     subitog2 = CalcOborot(dPer1beg,dPer1end,ENTRY(1,code.val,"|"),"*").          
     subitog3 = CalcOborot(dPer2beg,dPer2end,"*",code.description[1]).*/
     subitog2 = 0.
     subitog3 = 0.

     if NUM-ENTRIES(code.val,"|") = 2 then subitog2 = CalcOborot(dPer1beg,dPer1end,ENTRY(2,code.val,"|"),ENTRY(2,code.description[1],"|")). else subitog2 = 0.

     CREATE Itog.
     ASSIGN 
           Itog.Id = code.code
           Itog.iYear = iDate
           dProfit =  subitog1 
                     - subitog2 
/*                     + subitog3 - subitog4 */.  


   oTable:addRow().
   oTable:addCell(itog.iYear).
   oTable:addCell(itog.dProfit).
   oTable:addCell(subitog1).
   oTable:addCell(subitog2).
   oTable:addCell(subitog3).

  END.


END.                          

  */
/*Группируем если были разбивки по периодам.*/

FOR EACH code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'Пирожок_GR' NO-LOCK:

   for each itog where can-do (code.name,Itog.Id): 
      Itog.Id = ENTRY(1,code.name).

   end.

END. 

OUTPUT TO pirog.txt.

FOR EACH ITOG BY iYear:

find first code WHERE code.class EQ 'PIR4158' AND code.parent EQ 'Пирожок' and code.code = itog.id NO-LOCK NO-ERROR.
	
PUT UNFORMATTED STRING(iYear) + CHR(9) + STRING(dProfit) + CHR(9) + id + CHR(9) + code.description[3] SKIP.

END.

OUTPUT CLOSE.

/**/




/*
for each itog:
   oTable:addRow().
   oTable:addCell(itog.iYear).
   oTable:addCell(itog.dProfit).
end.                              */

{setdest.i}
  oTable:show().
{preview.i}


DELETE OBJECT oTable.
