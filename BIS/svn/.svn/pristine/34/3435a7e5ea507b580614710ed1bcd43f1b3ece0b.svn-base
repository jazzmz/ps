{globals.i}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char no-undo.
def output param restr as char init "" no-undo.

find first loan where recid(loan) eq recidl no-lock no-error.
if avail loan then do:
       	find last pro-obl of loan where pro-obl.pr-date LE end-date 
       			no-lock no-error.
	if avail pro-obl then do:
		res = string(pro-obl.pr-date).
	end.
end.
else res = "".
