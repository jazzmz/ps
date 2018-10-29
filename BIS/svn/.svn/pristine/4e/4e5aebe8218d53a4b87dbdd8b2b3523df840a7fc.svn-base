/*процедура ищет счета привязанные к договору с двумя ролями
как выяснилось это критично для договоров по физ-лицам

автор Красков А.С.*/

{bislogin.i}
{globals.i}
def var oTable as TTable NO-UNDO.
def buffer bloan-acct for loan-acct.
oTable = new TTable(5).
for each loan-acct where loan-acct.contract = "ЉаҐ¤Ёв" and  CAN-DO("!7*,*",loan-acct.acct)
 no-lock,
 first loan where loan-acct.contract = loan.contract and loan-acct.cont-code = loan.cont-code and (loan.close-date > 01/01/13 or loan.close-date = ?) no-lock:
  for each bloan-acct where bloan-acct.acct = loan-acct.acct
                        and bloan-acct.cont-code = loan-acct.cont-code
                        and bloan-acct.contract = loan-acct.contract
                        and bloan-acct.since = loan-acct.since
                        and bloan-acct.acct-type <> loan-acct.acct-type
                        no-lock.
  oTable:addRow().
  oTable:addCell(bloan-acct.cont-code).
  oTable:addCell(bloan-acct.acct).
  oTable:addCell(bloan-acct.acct-type).
  oTable:addCell(bloan-acct.since).
  oTable:addCell(bloan-acct.acct-type).
                        
/*  display bloan-acct.cont-code.
  display bloan-acct.acct.
  display bloan-acct.acct-type.
  display bloan-acct.since.
  display loan-acct.acct-type.*/
  
  end.




end.
{setdest.i}
oTable:show().
{preview.i}
