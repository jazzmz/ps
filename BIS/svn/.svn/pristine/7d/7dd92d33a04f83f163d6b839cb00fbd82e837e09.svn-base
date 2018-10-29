{globals.i}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char no-undo.
def output param restr as char init "" no-undo.

def var PrRisk  as DEC	 	NO-UNDO.
def var GrRisk  as int	 	NO-UNDO.
DEF VAR POS 	as char 	NO-UNDO.

find first loan where recid(loan) eq recidl no-lock no-error.
if avail loan then do:
	res = loan.cont-code.
end.
else res = "".

