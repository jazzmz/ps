define input parameter vContCode as character no-undo.
define output parameter cResult as character no-undo init "ok".
define buffer loan-acct for loan-acct.

find first 	loan-acct where loan-acct.cont-code eq vContCode and
		loan-acct.contract EQ "card-pers" and
		loan-acct.acct-type = "SCS@" and
		loan-acct.acct = "99999810000000000000"
		exclusive-lock no-error.

if available loan-acct then
	delete loan-acct.
return.
