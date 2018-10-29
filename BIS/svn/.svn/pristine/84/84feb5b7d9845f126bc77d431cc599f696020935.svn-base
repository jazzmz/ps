/*Процедура для поиска модернизации по ОС
заявка 957 */
{globals.i}

{tmprecid.def}

def var oTable as TTable.
DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */
DEF VAR count AS INTEGER INIT 0 NO-UNDO.



oTable = new TTable(6).

oTable:colsWidthList="4,14,12,12,13,13".

oTable:addRow().
oTable:addCell("").
oTable:addCell("Номер карточки ОС").
oTable:addCell("Дата модернизации").
oTable:addCell("Сумма модернизации").
oTable:addCell("Значение доп.реквизита СуммаАмор").
oTable:addCell("Значение доп.реквизита СуммаАморНУ").
oTable:SetAlign(1,1,"Center").
oTable:SetAlign(2,1,"Center").
oTable:SetAlign(3,1,"Center").
oTable:SetAlign(4,1,"Center").
oTable:SetAlign(5,1,"Center").
oTable:SetAlign(6,1,"Center").



{getdate.i}

{init-bar.i "Обработка договоров"}

for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.


for each tmprecid, first loan where RECID(loan) EQ tmprecid.id NO-LOCK:

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


    for each loan-acct where loan-acct.acct-type = "ОС-нал-учет" 
			   and loan-acct.contract = loan.contract 
			   and loan-acct.cont-code = loan.cont-code NO-LOCK:
	 for each op-entry where (op-entry.acct-db = loan-acct.acct)
			      and op-entry.op-date <= end-date NO-LOCK,
	       FIRST op where op.op = op-entry.op
                          and CAN-DO("7012b2*",op.op-kind) NO-LOCK:	

                        count = count + 1.

			oTable:addRow().
			oTable:addCell(count).
			oTable:addCell(loan.cont-code).
			oTable:addCell(op.op-date).
			oTable:addCell(op-entry.amt-rub).
			oTable:addCell(GetXattrValue("Loan",loan.contract + "," + loan.cont-code,"СуммаАмор")).
			oTable:addCell(GetXattrValue("Loan",loan.contract + "," + loan.cont-code,"СуммаАморНУ")).


	end.
    END.

 vLnCountInt = vLnCountInt + 1.


END.


{setdest.i}
oTable:show().
{preview.i}

DELETE OBJECT oTable.
