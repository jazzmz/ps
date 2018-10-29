{globals.i}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char init "" no-undo.
def output param restr as char init "" no-undo.

find first acct where recid(acct) eq recidl no-lock no-error.
if avail acct then do:
    	res = GetTempXAttrValueEx("acct",acct.acct + "," + acct.currency,"dealenddate",end-date,"").
	if date(res) LT end-date then do:
		restr = "‚ˆŒ€ˆ…!".
	end.
.
end.
