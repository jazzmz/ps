/*
Выбирает клиентов нерезидентов, имеющих открытые счета на дату . В таблицу записываем Наим, Счет, адрес юрид/прописки, адрес факт/почтовый
Заявка #2298
Никитина Ю.А. 30.01.2013
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
      :addCell("Адрес юридический / прописки")
      :addCell("Адрес фактический / почтовый").


for each cust-corp where cust-corp.country-id ne "RUS" no-lock:
    FIND FIRST acct WHERE  acct.cust-cat EQ "Ю" AND 
		acct.cust-id  EQ cust-corp.cust-id AND 
	        (acct.close-date EQ ? OR acct.close-date >= end-date) AND 
        	acct.open-date<= end-date 
		AND can-do("405*,406*,407*,40807*,40802*,40804*,40805*,40814*,40815*",acct.acct)  /*список счетов взят из письма от Капитановой #1142 */
		/*and CAN-DO("Расчет", acct.contract) */
    NO-LOCK NO-ERROR.
    if avail(acct) then do:	
    oTable:addRow().
    ii = ii + 1.
    oTable:addCell(ii).
    oTable:addCell(cust-corp.name-short).
    oTable:addCell(acct.acct).
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрЮр'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    oTable:addCell(IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE " ").

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ю'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    oTable:addCell(IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE " ").
    end.
end.

for each person where person.country-id ne "RUS" no-lock:
    FIND FIRST acct WHERE  acct.cust-cat EQ "Ч" AND 
		acct.cust-id  EQ person.person-id AND 
	        (acct.close-date EQ ? OR acct.close-date >= end-date) AND 
        	acct.open-date<= end-date 
		AND can-do("40817*,40820*,42301*,42601*",acct.acct)   /*список счетов взят из письма от Капитановой #1142 */
		/*and CAN-DO("Текущ,Депоз", acct.contract)*/
    NO-LOCK NO-ERROR.
    if avail(acct) then do:	
    oTable:addRow().
    ii = ii + 1.
    oTable:addCell(ii).
    oTable:addCell(person.name-last + " " + person.first-names).
    oTable:addCell(acct.acct).

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ч'
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ 'АдрПроп'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    oTable:addCell(IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE " ").

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ 'Ч'
         AND cust-ident.cust-id        EQ person.person-id
         AND cust-ident.cust-code-type EQ 'АдрФакт'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    oTable:addCell(IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE " ").
    end.
end.

for each banks where banks.country-id ne "RUS" no-lock:
    FIND FIRST acct WHERE  acct.cust-cat EQ "Б" AND 
		acct.cust-id  EQ banks.bank-id AND 
	        (acct.close-date EQ ? OR acct.close-date >= end-date) AND 
        	acct.open-date<= end-date 
		and acct.contract eq "Лоро"
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
         AND cust-ident.cust-code-type EQ 'АдрПочт'
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
