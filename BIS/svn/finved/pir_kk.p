{globals.i}
{intrface.get i254}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as int no-undo.
def output param restr as char init "" no-undo.

def var PrRisk  as DEC	 	NO-UNDO.
def var GrRisk  as int	 	NO-UNDO.
DEF VAR POS 	as char 	NO-UNDO.

find first loan where recid(loan) eq recidl no-lock no-error.
if avail loan then do:
  	PrRisk = LnRsrvRate(loan.contract, loan.cont-code, end-date). /* коэф. резервирования */
	GrRisk = LnGetGrRiska(PrRisk, end-date).                      /* категория качества */
	/* в ПОСе */
	POS = LnInBagOnDate(loan.contract,loan.cont-code,end-date - 1).
	/* если в Посе, то КК будет другая*/	
	if POS ne ? then GrRisk = PsGetGrRiska(PrRisk,loan.cust-cat,end-date - 1) .
	res = GrRisk.
end.
else res = 0.

