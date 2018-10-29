/*
Выбирает банки, имеющих открытые счета ЛОРО или НОСТРО на дату . В таблицу записываем Наим, Счет, адрес юрид, адрес факт
Заявка #2333
Никитина Ю.А. 04.02.2013
*/

{globals.i}
{getdate.i}
{pir_xf_def.i}

DEF VAR oTable AS TTable2 NO-UNDO.
DEF VAR ii AS int init 0 NO-UNDO.
oTable= new TTable2(5).
oTable:colsWidthList="5,30,30,30,30".
oTable:addRow()
      :addCell("Номер п/п")
      :addCell("Наименование клиента")
      :addCell("Счет")
      :addCell("Адрес юридический")
      :addCell("Адрес фактический").


for each banks no-lock:
    FIND FIRST acct WHERE  acct.cust-cat EQ "Б" AND 
		acct.cust-id  EQ banks.bank-id AND 
	        (acct.close-date EQ ? OR acct.close-date >= end-date) AND 
        	acct.open-date<= end-date 
		and CAN-DO("ЛОРО,НОСТРО",acct.contract)
    NO-LOCK NO-ERROR.
    if avail(acct) then do:	
    oTable:addRow().
    ii = ii + 1.
    oTable:addCell(ii).
    oTable:addCell(banks.short-name).
    oTable:addCell(acct.acct).

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Б'
         AND cust-ident.cust-id        EQ banks.bank-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    oTable:addCell(IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE " ").

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Б'
         AND cust-ident.cust-id        EQ banks.bank-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    oTable:addCell(IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE " ").
    end.
end.

{setdest.i}
oTable:Show().
{preview.i}

DELETE OBJECT oTable.
