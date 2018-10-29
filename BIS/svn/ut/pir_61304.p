{globals.i}
def var dr as char NO-UNDO.
def var i as dec init 0 NO-UNDO.
def var oTable AS TTable NO-UNDO.
oTable = new TTable(5).

for each acct where acct.acct begins "61304" and (acct.close-date >= date(06,30,2012) or acct.close-date eq ?)
		no-lock:
	dr = GetXattrValueEx("acct",acct.acct + "," + acct.currency,"Страна","").
	if dr eq "" then do:
		find first loan-acct where loan-acct.acct eq acct.acct no-lock no-error.
		if avail(loan-acct) then do:
			find first loan where loan.cont-code eq loan-acct.cont-code no-lock no-error.
			if loan.cust-cat eq "Ч" then do:
				find first person where person.person-id eq loan.cust-id no-lock no-error. 		
/*				if person.country ne "rus" then do:*/
/*				if acct.currency ne "" and person.country ne "rus" then do:*/
					i = i + 1.
					oTable:AddRow().
					oTable:AddCell(i).
					oTable:AddCell(acct.acct).
					oTable:AddCell(person.person-id).
					oTable:AddCell(person.name-last + " " + person.first-names).
					oTable:AddCell(person.country).
/*				end.*/
			end.
		end.	
	end.
end.
OUTPUT TO "./61304drstrana.log".
oTable:show().
OUTPUT CLOSE.
DELETE OBJECT oTable.
