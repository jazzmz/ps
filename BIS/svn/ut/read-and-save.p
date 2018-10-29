{bislogin.i}
{globals.i}

/***********************************************************
 * Обработка считывает XML файл, созданный по
 * образу и подобию таблицы acct-qty, затем загружает 
 * данные из него непосредственно в таблицу acct-qty.
 *
 * Пример XML:
 ************************************************************
<?xml version="1.0"?>
  <bufAcctQty xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <bufAcctQtyRow>
    <acct>50205810800010110002</acct>
    <currency/>
    <since>2013-01-09</since>
    <qty>0.0000000</qty>
   <debit>0.0000000</debit>
    <credit>5000</credit>
    <filial-id>0000</filial-id>
  </bufAcctQtyRow>
  <bufAcctQtyRow>
    <acct>50205810400010110004</acct>
    <currency/>
    <since>2013-01-09</since>
    <qty>0.0000000</qty>
    <debit>0.0000000</debit>
    <credit>5000</credit>
    <filial-id>0000</filial-id>
  </bufAcctQtyRow>
  <bufAcctQtyRow>
    <acct>50205810500010110001</acct>
    <currency/>
    <since>2013-01-09</since>
    <qty>0.0000000</qty>
    <debit>0.0000000</debit>
    <credit>10000</credit>
    <filial-id>0000</filial-id>
  </bufAcctQtyRow>
  <bufAcctQtyRow>
    <acct>50205810100010110003</acct>
    <currency/>
    <since>2013-01-09</since>
    <qty>0.0000000</qty>
    <debit>0.0000000</debit>
    <credit>10000</credit>
    <filial-id>0000</filial-id>
  </bufAcctQtyRow>
  <bufAcctQtyRow>
    <acct>50205810700010110005</acct>
    <currency/>
    <since>2013-01-09</since>
    <qty>30000</qty>
    <debit>30000</debit>
    <credit>0</credit>
    <filial-id>0000</filial-id>
  </bufAcctQtyRow>
  <bufAcctQtyRow>
    <acct>50205810700010110005</acct>
    <currency/>
    <since>2013-01-09</since>
    <qty>30000</qty>
    <debit>30000</debit>
    <credit>0</credit>
    <filial-id>0000</filial-id>
  </bufAcctQtyRow>
</bufAcctQty>
************************************************************
 * Автор : Маслов Д. А. Maslov D. A.
 * Заявка: #2706
 * Дата  : 26.03.13
 ***********************************************************/

DEF TEMP-TABLE bufAcctQty LIKE acct-qty.

DEF VAR dSum AS DEC INIT 0 NO-UNDO.

DEF VAR oTable AS TTable2  NO-UNDO.

oTable = NEW TTable2().
TEMP-TABLE bufAcctQty:READ-XML("file","./2.xml","empty",?,?,?,?).


FOR EACH bufAcctQty BY bufAcctQty.credit:
 dSum = dSum + bufAcctQty.credit.
 oTable:addRow()
       :addCell(bufAcctQty.acct)
       :addCell(bufAcctQty.debit)
       :addCell(bufAcctQty.credit)
       :addCell(bufAcctQty.qty)
 .
/*
 CREATE acct-qty.
 BUFFER-COPY bufAcctQty TO acct-qty.
*/
END.

{setdest.i}
 oTable:show().
{preview.i}
DELETE OBJECT oTable.

