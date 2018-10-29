{globals.i}

def input param end-date as date no-undo.
def input param recidl as RECID no-undo.
def output param res as char init "" no-undo.
def output param restr as char init "" no-undo.

find first acct where recid(acct) eq recidl no-lock no-error.
if avail acct then do:
	/* нашли счет резерва */
        Find first xlink WHERE TRUE AND NOT xlink.hidden AND xlink.class-code EQ acct.class-code 
		 	AND xlink.link-code eq "acct-reserve"
		NO-LOCK no-error.
	if avail xlink then do:
		find last links WHERE links.link-id = xlink.link-id AND links.source-id = acct.acct + "," + acct.currency
			AND links.beg-date <= end-date  
			AND ( links.end-date >= end-date OR links.end-date = ?) 
			/*AND xlink.link-direction BEGINS "s" */ NO-LOCK no-error.
		if avail links then do:
		    	res = string(links.target-id).
		end.
	end.
	/* если счет резерва не найдет, но есть процент резервирования , то пишем Внимание. */ 
	if res eq "" then do:
        	find last comm-rate of acct where comm-rate.commission eq "%Рез"
                    AND comm-rate.since LE end-date
                    NO-LOCK no-error.
        	if avail comm-rate AND comm-rate.rate-comm <> 0 then restr = "ВНИМАНИЕ!".
	end.
end.
