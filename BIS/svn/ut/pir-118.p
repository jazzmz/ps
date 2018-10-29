{globals.i}

DEF VAR ot AS TTable NO-UNDO.
ot = new TTable(2).

def var i as dec NO-UNDO.
i = 0.

for each acct where can-do("50706..........1....,50705..........1....",acct.acct) and acct.contract eq "" :  
	acct.contract = "ñÅìÁ•‚".
	i = i + 1.
	ot:addRow().
	ot:addCell(i).
	ot:addCell(acct.acct).

end.

OUTPUT TO "./118contract.log".
ot:show().
OUTPUT CLOSE.
DELETE OBJECT ot.
