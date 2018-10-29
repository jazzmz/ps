{globals.i}
{tmprecid.def}
{getdate.i}

def var oTable AS TTable NO-UNDO.
def var cClient AS CHAR INIT "" NO-UNDO.
def var cKAU AS CHAR INIT "" NO-UNDO. 
def var bDisp AS LOGICAL INIT FALSE NO-UNDO.
def var count as int init 0 NO-UNDO.
DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

DEF TEMP-TABLE tOp NO-UNDO
		     FIELD tamt LIKE op-entry.amt-rub
		     FIELD tdetails LIKE op.details.

{setdest.i}
PUT UNFORMATTED "                             Реестр операций по договорам за " STRING(end-date) SKIP(1).

{init-bar.i "Обработка договоров"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id and (loan.class-code = "loan-transh" or loan.class-code = "l_agr_with_per" or loan.class-code = "loan_allocat") NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.



FOR EACH tmprecid,
         first loan where RECID(loan) EQ tmprecid.id and (loan.class-code = "loan-transh" or loan.class-code = "l_agr_with_per" or loan.class-code = "loan_allocat") NO-LOCK.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }



         if loan.cust-cat = "Ч" then do:
              
            FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
            cClient = person.name-last + " " + person.first-names.

         end.

         if loan.cust-cat = "Ю" then do:
              
            FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
            cClient = cust-corp.name-short.

         end.

         oTable = new TTable(5).

         oTable:AddRow().
         oTable:AddCell("Клиент").
         oTable:AddCell("Договор").
         oTable:AddCell("Счет").
         oTable:AddCell("Сумма").
         oTable:AddCell("Содержание").

         oTable:AddRow().
         oTable:AddCell(cClient).
         oTable:AddCell(loan.cont-code).
         oTable:AddCell("").
         oTable:AddCell("").
         oTable:AddCell("").

         for each loan-acct where loan-acct.cont-code = loan.cont-code and CAN-DO ("!7*,*",loan-acct.acct) NO-LOCK. /* and loan-acct.acct-type <> "КредРасч"*/
        

/*                 message loan-acct.acct loan-acct.acct-type VIEW-AS ALERT-BOX.*/


                  for each op-entry where op-entry.op-date = end-date and
                                         (op-entry.acct-db = loan-acct.acct or op-entry.acct-cr = loan-acct.acct) and
                                          op-entry.currency = loan.currency and
                                          op-entry.op-status <> "В",
                                           first op where op.op = op-entry.op and CAN-DO ("!pirpco21,!pirpco31,pirp*",op.op-kind) NO-LOCK.


         if (op-entry.kau-db <> ? and op-entry.kau-db <> "") then cKAU = ENTRY(2, op-entry.kau-db).
         if (op-entry.kau-cr <> ? and op-entry.kau-cr <> "") and (SUBSTRING(ckau,1,2) <> "ПК") then cKAU = ENTRY(2, op-entry.kau-cr).
         if ckau = "" then cKau = "Проводка не привязана".

        if NOT CAN-FIND(tOp where (top.tamt = op-entry.amt-rub) and (top.tdetails = SUBSTRING(op.details,1,42)) NO-LOCK) then 
        do:
        CREATE tOp.
        ASSIGN
              top.tamt = op-entry.amt-rub
	      top.tdetails = SUBSTRING(op.details,1,42).

/*	  message "gfdas" VIEW-AS ALERT-BOX.*/

          oTable:AddRow().
          oTable:AddCell("").
          oTable:AddCell(CKau).
          oTable:AddCell(loan-acct.acct).
          if (loan.currency = "810" or loan.currency = "" or loan.currency = ?) then 
          oTable:AddCell(op-entry.amt-rub).
          else
          oTable:AddCell(op-entry.amt-cur).
          oTable:AddCell(SUBSTRING(op.details,1,42)).
          bDisp = true.
          end.
        end.

        end.

       if bDisp then do: 
	oTable:show().
	count = count + 1.
	PUT UNFORMATTED  SKIP(1).
        bDisp = false.
        end.
       DELETE OBJECT oTable.
           vLnCountInt = vLnCountInt + 1.

end.
	PUT UNFORMATTED "Всего договоров:" STRING(count) SKIP(1).
  
{preview.i}