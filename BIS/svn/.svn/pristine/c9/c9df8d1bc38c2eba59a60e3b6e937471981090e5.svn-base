/*
               KSV Editor
    Copyright: (C) 2000-2006 Serguey Klimoff (bulklodd)
     Filename: F212#.P
      Comment: форма #F212# (метод Calc) 
   Parameters:
         Uses:
      Used by:
      Created: 26.02.2007 15:01 SALN    
     Modified: 26.02.2007 15:01 SALN     0067723
*/


{sv-calc.i}
{intrface.get strng}
{intrface.get tmess}        /* Служба системных сообщений */

{f212.pro}   /* процедуры для ф.212 */

DEFINE VARIABLE mI       AS INTEGER INIT 1   NO-UNDO.

DEFINE VARIABLE dDateBeg AS DATE  NO-UNDO.
DEFINE VARIABLE dDateEnd AS DATE  NO-UNDO.
DEFINE VARIABLE oF212    AS TF212 NO-UNDO.

/* 
#1: Изменения: Маслов Д. А. 
Получаем начальную и конечные даты 
*/

FIND FIRST DataBlock WHERE Data-Id=in-Data-id NO-LOCK NO-ERROR.
   ASSIGN
         dDateBeg=DataBlock.Beg-Date
         dDateEnd=DataBlock.End-Date

        .
 oF212 = new TF212(dDateBeg,dDateEnd). 
 oF212:calc().
 
/* #1:Конец изменений Маслов */
 
/* Заполнение класса */
TR:
DO TRANSACTION ON ERROR UNDO TR,RETURN ERROR
   ON STOP UNDO TR,RETURN ERROR:

   {for_form.i
      &AND = " AND SUBSTRING(b-formula.var-id,1,1) NE 's'"
      &BY = "BY b-formula.order" } 

      CREATE TDataLine.
      
      ASSIGN TDataLine.Data-Id = in-Data-Id
             TDataLine.Sym1 = STRING(mI,"99")
      .
      TDataLine.Sym2 = GetNumber(b-formula.var-id).
      TDataLine.Txt  = b-formula.var-name.

/*#2: Изменения: Маслов Д. А. */

      IF mI EQ 2 THEN TDataLine.Val[1] = oF212:obslCount.


      IF mI EQ 3 THEN TDataLine.Val[1] = oF212:controlCount.


      IF mI EQ 4 THEN TDataLine.Val[1] = oF212:controlCountClose.

      IF mI EQ 5 THEN TDataLine.Val[1] = oF212:withLimitCash.


      IF mI EQ 6 THEN TDataLine.Val[1] = oF212:limitCash.


      IF mI EQ 7 THEN TDataLine.Val[1] = oF212:isControlCount.      

/*#2: Конец изменений: Маслов Д. А. */
      mI = mI + 1.
   END.

END.
DELETE OBJECT oF212.
{intrface.del}
RETURN "".


