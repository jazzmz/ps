/****************************
 * Отчет по гарантиям которые попадают
 * в ОВП без установленного 
 * признака вхождения в ОВП.
 ****************************
 * Автор: Маслов Д. А.
 * Заявка: #1205
 * Дата создания: 08.08.12
 *****************************/

{globals.i}

DEF VAR oAcct AS TAcct                   NO-UNDO.
DEF VAR currDate AS DATE INIT 07/31/2012 NO-UNDO.
DEF VAR currPos  AS DEC                  NO-UNDO.

DEF VAR oTable AS TTable                 NO-UNDO.

oTable = NEW TTable(4).


{getdate.i}

currDate = end-date.

FOR EACH loan-acct WHERE CAN-DO("!КредВГар,!КредАккрВ,!КредАккрГВ,КредГар*,КредОб*,КредЦБум*,КредАккрВ,КредАккрГв,КредГар",loan-acct.acct-type) 
                     AND (loan-acct.currency EQ "840" OR loan-acct.currency EQ "978") NO-LOCK:
    oAcct = NEW TAcct(loan-acct.acct).
    currPos = oAcct:getLastPos2Date(currDate).

IF  currPos <> 0 THEN DO:

  IF loan-acct.acct-type BEGINS "КредОб" 
 AND CAN-DO("91414",SUBSTRING(loan-acct.acct,1,5)) THEN DO:
   oTable:addRow().
   oTable:addCell(loan-acct.acct).
   oTable:addCell(loan-acct.acct-type). 
   oTable:addCell(currPos). 
   oTable:addCell((IF oAcct:getXAttr("f634_dec") = "f634_acct" THEN "oK" ELSE "Ошибка")).  
  END.
 IF CAN-DO("!КредОб*,*",loan-acct.acct-type) THEN DO:
   oTable:addRow().
   oTable:addCell(loan-acct.acct).
   oTable:addCell(loan-acct.acct-type). 
   oTable:addCell(currPos). 
   oTable:addCell((IF oAcct:getXAttr("f634_dec") = "f634_acct" THEN "oK" ELSE "Ошибка")).  
 END.

END.
    DELETE OBJECT oAcct.
END.
{setdest.i}
PUT UNFORMATTED "*** ПРОВЕРОЧНЫЙ ОТЧЕТ ОВП ***" SKIP.
oTable:show().
{preview.i}
DELETE OBJECT oTable.