{globals.i}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char no-undo.
def output param restr as char init "" no-undo.

find first loan where recid(loan) eq recidl no-lock no-error.
if avail loan then do:
       	find last loan-acct where loan-acct.contract EQ loan.contract
                       	AND loan-acct.cont-code EQ loan.cont-code
       	               	AND loan-acct.since LE end-date 
       			AND loan-acct.acct-type eq "ä‡•§è‡" 
       			no-lock no-error.
	if avail loan-acct then do:
		res = loan-acct.acct.
	end.
end.
else res = "".