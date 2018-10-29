{globals.i}
{getdate.i}
{sh-defs.i}

def var oTable as TTable NO-UNDO.
def var count as INT INIT 0 NO-UNDO.
def var totalrub as decimal NO-UNDO.
def var totalval as decimal NO-UNDO. 

def temp-table cust-acct no-undo
    field cust-id like cust-corp.cust-id
    field acct like acct.acct
    field amt-rub as decimal
    field amt-cur as decimal
    INDEX icust-id as primary cust-id.

def temp-table cust-itog no-undo
    field cust-id like cust-corp.cust-id
    field name-short like cust-corp.name-short
    field amt-rub as decimal
    field amt-cur as decimal
    INDEX icust-id as primary cust-id.


oTable = new TTable(5).
oTable:AddRow().
oTable:AddCell("").
oTable:AddCell("Клиент").
oTable:AddCell("Счет").
oTable:AddCell("Остаток руб").
oTable:AddCell("Остаток вал").

for each cust-corp NO-LOCK,
first cust-role where cust-role.cust-id = STRING(cust-corp.cust-id)
	          and cust-role.cust-cat = "Ю"
		  and cust-role.class-code = "ClientBank"
		  and cust-role.open-date <= end-date
		  and cust-role.close-date >= end-date
		  NO-LOCK:


	       totalval = 0.
	       totalrub = 0.

       for each acct where acct.cust-cat = cust-role.cust-cat 
		and acct.cust-id = cust-corp.cust-id
		and (acct.close-date >= end-date  or acct.close-date = ?)
		NO-LOCK,
		first mail-user where can-do(mail-user.acct,acct.acct) NO-LOCK.

                if CAN-DO("Расчет*,Транз*,Спец*",acct.contract)	then do:

                RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              ?).

               totalval = totalval + ABS(sh-val).
               totalrub = totalrub + ABS(sh-bal).

               if (ABS(sh-val) +  ABS(sh-bal)) > 0 then do:
               CREATE cust-acct.
	       ASSIGN 
		      cust-acct.cust-id = cust-corp.cust-id
		      cust-acct.acct = acct.acct
		      cust-acct.amt-rub = ABS(sh-bal)
		      cust-acct.amt-cur = ABS(sh-val).
	       end.
	       end.
      end.
if totalval + totalrub > 0 then do:
create cust-itog.
assign 
    cust-itog.cust-id    = cust-corp.cust-id
    cust-itog.name-short = cust-corp.name-short
    cust-itog.amt-rub    = totalrub
    cust-itog.amt-cur    = totalval.
end.

end.


for each cust-itog by cust-itog.amt-rub DESCENDING:
count = count + 1.

oTable:AddRow().
oTable:AddCell(count).
oTable:AddCell(cust-itog.name-short).
oTable:AddCell("").
oTable:AddCell("").
oTable:AddCell("").

    for each cust-acct where cust-acct.cust-id = cust-itog.cust-id NO-LOCK.
        oTable:AddRow().
	oTable:AddCell("").
	oTable:AddCell("").
	oTable:AddCell(cust-acct.acct).
	oTable:AddCell(cust-acct.amt-rub).
	oTable:AddCell(cust-acct.amt-cur).
    end.

        oTable:AddRow().
	oTable:AddCell("").
	oTable:AddCell("ИТОГО:").
	oTable:AddCell("").
	oTable:AddCell(cust-itog.amt-rub).
	oTable:AddCell(cust-itog.amt-cur).
       
end.

{setdest.i}
oTable:show().
{preview.i}

delete object oTable.