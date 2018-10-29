{globals.i}
{getdate.i}

/***
 *
 * Копируем данные из связанных субъектов в банковские реквизиты.
 * Заявка: #1657
 * Автор: Никитина Ю. А. Nikitina Y. A.
 *
 ***/

/*for each op-impexp where op-impexp.op-date eq end-date no-lock:
	message "3" op-impexp.op. pause.
end.
*/

def var dr as char no-undo. 
def var acct-db as char no-undo. 
def var acct-cr as char no-undo. 
def var contract-db as char no-undo. 
def var contract-cr as char no-undo. 

for each op where op.op-date eq end-date no-lock:
        find first msg-impexp where msg-impexp.msg-cat EQ "op" 
				and msg-impexp.object-id eq string(op.op) 
				no-lock no-error.
	if avail(msg-impexp) then do:
		find first op-entry of op no-lock no-error.
	   	if avail(op-entry) then do:
			find first acct where acct.acct eq op-entry.acct-db no-lock no-error.
			if avail(acct) then do:
			  	acct-db = acct.acct.
				contract-db =  acct.contract.
			end.
			find first acct where acct.acct eq op-entry.acct-cr no-lock no-error.
			if avail(acct) then do:
			  	acct-cr = acct.acct.
				contract-cr =  acct.contract.
			end.
			/* говорим пользователю, что есть Банк-посредник, но он не заполнен в Связанных субъектах */
			dr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + "," + msg-impexp.msg-type + ",0","pirSwift56", "").
			if dr <> "" then do:
				message COLOR WHITE/RED "на документе " op.doc-num " от " op.op-date " нужно установить в Связанных субъектах 
						и в Банковских реквизитах Банк-посредник !" VIEW-AS ALERT-BOX. pause.
			end.
			dr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + "," + msg-impexp.msg-type + ",0","pirSwift52", "").
			if dr <> "" and CAN-DO("НОСТРО",contract-db) then do:
				find first cust-role WHERE cust-role.file-name EQ "op" AND cust-role.surrogate EQ string(op.op) 
					and cust-role.Class-Code eq "Order-Inst" no-lock no-error.
				if not avail(cust-role) then do:
					message COLOR WHITE/RED "на документе " op.doc-num " от " op.op-date " нужно установить в Связанных субъектах 
						и в Банковских реквизитах Банк-отправитель !" VIEW-AS ALERT-BOX. pause.
				end.
			end.
			dr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + "," + msg-impexp.msg-type + ",0","pirSwift57", "").
			if dr <> "" and CAN-DO("НОСТРО",contract-cr) then do:
				find first cust-role WHERE cust-role.file-name EQ "op" AND cust-role.surrogate EQ string(op.op) 
					and cust-role.Class-Code eq "Benef-Inst" no-lock no-error.
				if not avail(cust-role) then do:
					message COLOR WHITE/RED "на документе " op.doc-num " от " op.op-date " нужно установить в Связанных субъектах 
						и в Банковских реквизитах Банк-бенефициар !" VIEW-AS ALERT-BOX. pause.
	                	end.
			end.
		end.
	end.
 	/*заполняем из связанных субъектов в банковские реквизиты*/
	find first cust-role WHERE cust-role.file-name EQ "op" AND cust-role.surrogate EQ string(op.op) 
				and cust-role.Class-Code eq "Order-Inst" no-lock no-error.
	if avail(cust-role) then do:
		find first op-bank where op-bank.op eq op.op 
				and op-bank.op-bank-type eq "send"
				and op-bank.bank-code-type eq cust-role.cust-code-type
				and op-bank.bank-code eq cust-role.cust-code 
				no-lock no-error.
		if not avail(op-bank) then do:
			create op-bank.
			op-bank.op = op.op.
			op-bank.op-bank-type = "send".
			op-bank.bank-code-type = cust-role.cust-code-type.
			op-bank.bank-code = cust-role.cust-code.
		end.
	end.

	find first cust-role WHERE cust-role.file-name EQ "op" AND cust-role.surrogate EQ string(op.op) 
				and cust-role.Class-Code eq "Benef-Inst" no-lock no-error.
	if avail(cust-role) then do:
		find first op-bank where op-bank.op eq op.op 
				and op-bank.op-bank-type eq "ben"
				and op-bank.bank-code-type eq cust-role.cust-code-type
				and op-bank.bank-code eq cust-role.cust-code 
				no-lock no-error.
		if not avail(op-bank) then do:
			create op-bank.
			op-bank.op = op.op.
			op-bank.op-bank-type = "ben".
			op-bank.bank-code-type = cust-role.cust-code-type.
			op-bank.bank-code = cust-role.cust-code.
		end.
	end.
end. 