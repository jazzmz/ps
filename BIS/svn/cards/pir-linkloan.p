define input parameter iNum as character no-undo.
define input parameter iDate as character no-undo.
define output parameter cOut as character no-undo.
find first 	loan-acct where loan-acct.cont-code eq iNum and
		loan-acct.contract EQ 'card-pers' and
		loan-acct.since eq date(iDate) no-lock no-error.
if not available loan-acct then do:
	create loan-acct.
	assign
		loan-acct.contract  = "card-pers"
		loan-acct.cont-code = iNum
		loan-acct.acct-type = "SCS@"
		loan-acct.acct = "99999810000000000000"
		loan-acct.currency = ""
		loan-acct.since = date(iDate).
end.
cOut = "ok.".
