/*
#3762 Проставляет ДР на счете для книги открытых счетов.
Никитина Ю.А.
*/
{globals.i}
{getdate.i}
{intrface.get xclass}

def var dr  as char        no-undo.
def var dr2 as char        no-undo.
def var i   as int  init 0 no-undo.
DEF VAR ot  AS TTable      NO-UNDO.

ot = new TTable(3).

for each acct where (acct.close-date gt end-date or acct.close-date eq ?) and acct.acct-cat EQ "b" 
		and acct.acct begins "455"
		no-lock:
	dr = GetXAttrValueEx("acct",acct.acct + "," + acct.currency,"ДогОткрЛС","").
	if dr eq "" then do:
		find first loan-acct where loan-acct.acct eq acct.acct no-lock no-error.
		if avail loan-acct /* and (loan-acct.cont-code begins "КЛ" or loan-acct.cont-code begins "ПК") */  then do:
			find first loan where loan.cont-code eq loan-acct.cont-code or loan.cont-code eq entry(1,loan-acct.cont-code," ") 
				no-lock no-error.
			if avail loan then do:
				dr2 = GetXAttrValueEx("loan",loan.contract + "," + loan.cont-code,"ДатаСогл","").
				i = i + 1.
                         	ot:addRow().
                         	ot:addCell(i).
                         	ot:addCell(acct.acct).
				if loan-acct.cont-code begins "MM" then do:
	                                ot:addCell(dr2 + "," + string(loan.doc-num)).
/*					UpdateSigns(string(acct.Class-Code),acct.acct + "," + acct.currency,"ДогОткрЛС",
						dr2 + "," + string(loan.doc-num),?).
*/
				end.
				else do:
					ot:addCell(dr2 + "," + string(loan.cont-code)).
/*					UpdateSigns(string(acct.Class-Code),acct.acct + "," + acct.currency,"ДогОткрЛС",
						dr2 + "," + string(loan.cont-code),?).
*/
				end.
			end.
		end.
	end.
end.

OUTPUT TO "./ks_dr.log".
ot:show().
OUTPUT CLOSE.
DELETE OBJECT ot.
