{globals.i}
{tmprecid.def}
{ulib.i}

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик документов */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество документов */

DEF VAR oTable1 AS TTable.
DEF VAR oTpl AS TTpl.
DEF VAR oTAcct AS TAcct.

def var i AS integer.
def var J AS integer.
def var count AS Integer INIT 0.
DEF VAR dItog AS DEC INIT 0.
Def Var dOstKredit AS DEC INIT 0.
def var rate as DEC INIT 0.
DEF VAR FIO AS CHAR.


DEF BUFFER bfrLoan-acct FOR loan-acct.


if not can-find (first tmprecid)
then do:
    message "Нет ни одного выбранного документа!"
    view-as alert-box.
    return.
end.

{init-bar.i "Обработка документов"}

for each tmprecid, first op where RECID(op) EQ tmprecid.id  NO-LOCK.
    vLnTotalInt = vLnTotalInt + 1.
end.

oTable1 = new TTable(10).

oTable1:addRow().
oTable1:addCell("№ п/п").
oTable1:addCell("Наименование заемщика").
oTable1:addCell("Сумма задолженности").
oTable1:addCell("период").
oTable1:addCell("период").
oTable1:addCell("Сумма").
oTable1:addCell("%% ").
oTable1:addCell("ВАЛ").
oTable1:addCell("Дебет").
oTable1:addCell("Кредит").

oTable1:addRow().
oTable1:addCell(" ").
oTable1:setBorder(1,oTable1:height,1,0,0,1).
oTable1:addCell("№ договора, дата").
oTable1:setBorder(2,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(3,oTable1:height,1,0,0,1).
oTable1:addCell("С").
oTable1:setBorder(4,oTable1:height,1,0,0,1).
oTable1:addCell("по").
oTable1:setBorder(5,oTable1:height,1,0,0,1).
oTable1:addCell("нач.%").
oTable1:setBorder(6,oTable1:height,1,0,0,1).
oTable1:addCell("ст").
oTable1:setBorder(7,oTable1:height,1,0,0,1).
oTable1:addCell(" ").
oTable1:setBorder(8,oTable1:height,1,0,0,1).
oTable1:addCell("счета").
oTable1:setBorder(9,oTable1:height,1,0,0,1).
oTable1:addCell("счета").
oTable1:setBorder(10,oTable1:height,1,0,1,1).

DO i=1 to 2:
  do j=1 to 10:
   oTable1:setAlign(j,i,"center").
  end.
end.


FOR EACH tmprecid,
    first op where RECID(op) EQ tmprecid.id NO-LOCK.
             /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

    find first op-entry where op-entry.op = op.op NO-LOCK NO-ERROR.
    IF AVAILABLE(op-entry) then do:
       find first loan-acct where loan-acct.acct = op-entry.acct-db and loan-acct.acct-type = "КредТ" NO-LOCK NO-ERROR.
       IF AVAILABLE(loan-acct) then do:
           find first loan where loan.cont-code = loan-acct.cont-code and loan.contract = loan-acct.contract NO-LOCK NO-ERROR.
           dOstKredit = 0.

           for each bfrLoan-acct where loan.cont-code = bfrloan-acct.cont-code and bfrloan-acct.acct-type = "Кредит" NO-LOCK.
               oTAcct = new TAcct(bfrLoan-acct.acct).
               dOstKredit = dOstKredit + oTAcct:GetLastPos2Date(op.op-date).
	       DELETE OBJECT oTAcct. 	
           end.

           if loan.cust-cat eq "Ч" then 
           do:
              FIND FIRST person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.
              FIO = person.name-last + " " +  person.first-names.
           end.
           if loan.cust-cat eq "Ю" then 
           do:
	      FIND FIRST cust-corp where cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR.
              FIO = cust-corp.name-short.
           END.

	   count = count + 1.

           rate = GetLoanCommission_ULL(loan.contract,loan.cont-code,"%Кред",op.op-date, false).
           oTable1:addRow().
	   oTable1:addCell(count).
	   oTable1:addCell(FIO).	
	   oTable1:addCell(dOstKredit).
	   oTable1:addCell(MAX(FirstMonDate(op.op-date),loan.open-date)).
	   oTable1:addCell(op.op-date).
	   if (op-entry.currency = "") OR (op-entry.currency = "810") then oTable1:addCell(op-entry.amt-rub). else oTable1:addCell(op-entry.amt-cur).
	   oTable1:addCell(STRING(rate * 100,">>9.99") + "%").	
	   oTable1:addCell(loan.currency).
	   oTable1:addCell(op-entry.acct-db).
	   oTable1:addCell(op-entry.acct-cr).

           if (op-entry.currency = "") OR (op-entry.currency = "810") then dItog = dItog + (op-entry.amt-rub). else dItog = dItog + (op-entry.amt-cur).

           oTable1:addRow().
	   oTable1:addCell(" ").
	   oTable1:setBorder(1,oTable1:height,1,0,0,1).
	   oTable1:addCell(getMainLoanAttr("Кредит",loan.cont-code,"№ %cont-code от %ДатаСогл")).
	   oTable1:setBorder(2,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(3,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(4,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(5,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(6,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(7,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(8,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(9,oTable1:height,1,0,0,1).
	   oTable1:addCell(" ").
	   oTable1:setBorder(10,oTable1:height,1,0,1,1).

       end.
       else MESSAGE COLOR WHITE/RED "СЧЕТ ПО ДЕБИТУ НЕ ПРИВЯЗАН К ДОГОВОРУ С РОЛЬЮ КредТ!" VIEW-AS ALERT-BOX TITLE "Ошибка".
    end.
    else MESSAGE COLOR WHITE/RED "НЕ НАЙДЕНА ПРОВОДКА!" VIEW-AS ALERT-BOX TITLE "Ошибка".

    vLnCountInt = vLnCountInt + 1.
END.

oTable1:addRow().
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(dItog).
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").
oTable1:addCell(" ").


oTpl = new TTpl("pir-rasp-pct15.tpl").

oTpl:addAnchorValue("DATE",op.op-date).
oTpl:addAnchorValue("Table1",oTable1).

{setdest.i}
  oTpl:show().
{preview.i}
DELETE OBJECT oTpl.