tmpDEC[1] = 0.
tmpDEC[2] = 0.
tmpDEC[3] = 0.
tmpDEC[4] = 0.

FOR EACH acct WHERE 
					cust-cat = "{&cust-cat}"
					AND
					cust-id = {&cust-id}
					AND
					open-date LE end-date
					AND 
					(close-date GE beg-date OR close-date = ?) 
					NO-LOCK
:

			/** Обороты по дебету */
			FOR EACH op-entry WHERE 
					op-date GE beg-date 
					AND 
					op-date LE end-date
					AND 
					acct-db = acct.acct
					NO-LOCK
				:
					if acct-cr BEGINS ENTRY(1, acctList) THEN
						tmpDEC[1] = tmpDEC[1] + op-entry.amt-rub.
					if acct-cr BEGINS ENTRY(2, acctList) THEN
						tmpDEC[2] = tmpDEC[2] + op-entry.amt-rub.
			END.
			/** Обороты по кредиту */
			FOR EACH op-entry WHERE 
					op-date GE beg-date 
					AND 
					op-date LE end-date
					AND 
					acct-cr = acct.acct
					NO-LOCK
				:
					if acct-db BEGINS ENTRY(1, acctList) THEN
						tmpDEC[3] = tmpDEC[3] + op-entry.amt-rub.
					if acct-db BEGINS ENTRY(2, acctList) THEN
						tmpDEC[4] = tmpDEC[4] + op-entry.amt-rub.
			END.	
			
END.

/** Обороты по кассе */
IF tmpDEC[1] + tmpDEC[3] > 0 THEN
DO:
	CREATE tt-result.
	tt-result.clientName = {&clientName}.
	tt-result.type = 1.
	tt-result.oborotDB = tmpDEC[1].
	tt-result.oborotCR = tmpDEC[3].
	tt-result.oborotFULL = tmpDEC[1] + tmpDEC[3].
END.

IF tmpDEC[2] + tmpDEC[4] > 0 THEN
DO:
	CREATE tt-result.
	tt-result.clientName = {&clientName}.
	tt-result.type = 2.
	tt-result.oborotDB = tmpDEC[2].
	tt-result.oborotCR = tmpDEC[4].
	tt-result.oborotFULL = tmpDEC[2] + tmpDEC[4].
END.
	
