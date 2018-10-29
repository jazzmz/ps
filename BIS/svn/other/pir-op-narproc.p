{globals.i}
{getdate.i}
def var oTableRub AS TTable.
def var oTableEUR AS TTable.
def var oTableUsd AS TTable.
def var countRub as Integer.
def var countEUR as Integer.
def var countUSD as Integer.
DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик документов */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество документов */


{init-bar.i "Обработка документов"}
	

oTableRub = new TTable(6). 
oTableEur = new TTable(6).
oTableUSD = new TTable(6).

oTableRub:addRow().
oTableRub:addCell("").
oTableRub:addCell("Договор").
oTableRub:addCell("Дебет").
oTableRub:addCell("Кредит").
oTableRub:addCell("Сумма нац.вал").
oTableRub:addCell("Сумма вал.договора").

oTableEur:addRow().
oTableEur:addCell("").
oTableEur:addCell("Договор").
oTableEur:addCell("Дебет").
oTableEur:addCell("Кредит").
oTableEur:addCell("Сумма нац.вал").
oTableEur:addCell("Сумма вал.договора").

oTableUsd:addRow().
oTableUsd:addCell("").
oTableUsd:addCell("Договор").
oTableUsd:addCell("Дебет").
oTableUsd:addCell("Кредит").
oTableUsd:addCell("Сумма нац.вал").
oTableUsd:addCell("Сумма вал.договора").

message end-date VIEW-AS ALERT-BOX.

for each op where op.op-date = end-date and op-kind = "pirpco60" NO-LOCK.
   for each op-entry where op-entry.op = op.op NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
   end.
end.

for each op where op.op-date = end-date and op-kind = "pirpco60" NO-LOCK.
   for each op-entry where op-entry.op = op.op NO-LOCK.
       find last loan-acct where loan-acct.acct = op-entry.acct-db NO-LOCK NO-ERROR.
       find last loan where loan.cont-code = loan-acct.cont-code NO-LOCK NO-ERROR.

             /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


/*       display loan.cont-code op.op op.op-date.*/
       if loan.currency = "840" then do:
          countUSD = countUSD + 1.
          oTableUsd:addRow().
	  oTableUsd:addCell(countUSD).
	  oTableUsd:addCell(loan.cont-code).
	  oTableUsd:addCell(op-entry.acct-db).
	  oTableUsd:addCell(op-entry.acct-cr).
	  oTableUsd:addCell(op-entry.amt-cur).
	  oTableUsd:addCell(op-entry.amt-rub).
       end.
       else
       if loan.currency = "978" then do:
          countEur = countEur + 1.
	  oTableEur:addRow().
	  oTableEur:addCell(countEUR).
	  oTableEur:addCell(loan.cont-code).
	  oTableEur:addCell(op-entry.acct-db).
	  oTableEur:addCell(op-entry.acct-cr).
	  oTableEur:addCell(op-entry.amt-cur).
	  oTableEur:addCell(op-entry.amt-rub).
       end.
       else
       do:
          countRub = countRub + 1.
	  oTableRub:addRow().
	  oTableRub:addCell(countRub).
	  oTableRub:addCell(loan.cont-code).
	  oTableRub:addCell(op-entry.acct-db).
	  oTableRub:addCell(op-entry.acct-cr).
	  oTableRub:addCell(op-entry.amt-rub).
	  oTableRub:addCell(op-entry.amt-rub).
       end.
    vLnCountInt = vLnCountInt + 1.
   end.
end.
{setdest.i}
PUT UNFORMATTED "Ведомость по операциям за " + STRING(end-date) SKIP(0).

PUT UNFORMATTED               "Валюта договора - 810"     SKIP(0).

oTableRub:Show().

PUT UNFORMATTED               "Валюта договора - 840"     SKIP(0).

oTableUsd:Show().

PUT UNFORMATTED               "Валюта договора - 978"     SKIP(0).
oTableEur:Show().
{preview.i}

DELETE OBJECT oTableRub.
DELETE OBJECT oTableUsd.
DELETE OBJECT oTableEur.
