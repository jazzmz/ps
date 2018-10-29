{globals.i}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char init "" no-undo.
def output param restr as char init "" no-undo.

find first acct where recid(acct) eq recidl no-lock no-error.
if avail acct then do:
	find last comm-rate of acct where comm-rate.commission eq "%ê•ß"
            AND comm-rate.since LE end-date
            NO-LOCK no-error.
	if avail comm-rate then res = string(comm-rate.rate-comm).
end.
