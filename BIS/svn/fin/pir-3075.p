{globals.i}
{tmprecid.def}
{getdates.i}

DEF VAR oAcct   AS TAcct NO-UNDO.
DEF VAR oTable  AS TTable2 NO-UNDO.
DEF VAR oClient AS TClient NO-UNDO.
DEF VAR count AS INT INIT 0 NO-UNDO.

def var TotalAmtAcct AS DECIMAL NO-UNDO.
def var TotalAmtClient AS DECIMAL NO-UNDO.


DEF VAR cMask AS CHAR INIT "40*" LABEL "Список счетов" NO-UNDO.

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик документов */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество документов */

DEF VAR cCust-cat as CHAR NO-UNDO.
DEF VAR iCust-id  as INT  NO-UNDO.

DEF VAR dDate as DATE NO-UNDO.

{init-bar.i "Обработка счетов клиентов"}

oTable = new TTable2(4).

   oTable:AddRow().
   oTable:AddCell(" ").
   oTable:AddCell("Номер л/с").
   oTable:addCell("Наименование клиента").
   oTable:AddCell("Остаток в рублях"). 


PAUSE 0.

UPDATE SKIP(1) cMask FORMAT "x(40)" SKIP(1)
  WITH FRAME fMain OVERLAY ROW 10 CENTERED SIDE-LABELS TITLE "[ Введите маску счетов ]".

HIDE FRAME fMain.



FOR EACH tmprecid:    
   oClient = new TClient(tmprecid.id).
   FOR EACH acct WHERE can-do(cMask,acct.acct)
                   AND acct.cust-cat = oClient:cust-cat
                   AND acct.cust-id  = oClient:PK
                   AND acct.open-date <= end-date 
                   AND (acct.close-date = ? or acct.close-date > end-date) NO-LOCK:
            vLnTotalInt = vLnTotalInt + 1.
   END.
   DELETE OBJECT oClient.
END.


FOR EACH tmprecid:    

   count = count + 1.
   oClient = new TClient(tmprecid.id).
   TotalAmtClient = 0.

   oTable:AddRow().
   oTable:AddCell(count).
   oTable:AddCell(" ").
   oTable:addCell(oClient:name-short).
   oTable:AddCell(" "). 

   FOR EACH acct WHERE can-do(cMask,acct.acct)
                   AND acct.cust-cat = oClient:cust-cat
                   AND acct.cust-id  = oClient:PK
                   AND acct.open-date <= end-date 
                   AND (acct.close-date = ? or acct.close-date > end-date) NO-LOCK:

             /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

       TotalAmtAcct = 0.

       oAcct = new TAcct(acct.acct).

       do dDate = beg-date to end-date: 
          TotalAmtAcct = TotalAmtAcct + oAcct:getLastPos2Date(dDate,CHR(251),810).
       end.
       TotalAmtClient = TotalAmtClient + TotalAmtAcct.

       oTable:AddRow().
       oTable:AddCell("").
       oTable:addCell(acct.acct).
       oTable:AddCell(oClient:name-short).
       oTable:AddCell(ROUND((TotalAmtAcct / (end-date - beg-date + 1)),2)). 

       DELETE OBJECT oAcct.
       vLnCountInt = vLnCountInt + 1.
   END.

   oTable:AddRow().
   oTable:AddCell(" ").
   oTable:AddCell(" ").
   oTable:addCell(" ").
   oTable:AddCell(ROUND((TotalAmtClient / (end-date - beg-date + 1)),2)). 
   DELETE OBJECT oClient.

   oTable:AddRow().
   oTable:AddCell(" ").
   oTable:AddCell(" ").
   oTable:AddCell(" ").
   oTable:AddCell(" ").
END.

{setdest.i}
   PUT UNFORMAT "Средний остаток по счетам клиентов за период с " String(beg-date) " по " STRING(end-date) SKIP. 
   oTable:show().
{preview.i}

DELETE OBJECT oTable.

