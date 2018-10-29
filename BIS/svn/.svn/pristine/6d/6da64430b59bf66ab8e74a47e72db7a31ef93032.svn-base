/** 
	Инклюдник, вызываемый из процедуры pirsfopsigns.p, для чтения 
	изформации из БД. 
*/

tmpStr = GetXAttrValueEx("op",STRING(op.op),"PIRSFDetails","").
if tmpStr <> "" then 
	do:
		detailsIsExists = yes.
		detailsServCode = ENTRY(2,tmpStr).
		detailsServName = ENTRY(1,tmpStr).
		IF detailsServName = "" THEN detailsServName = GetAssetName(shFilial, detailsServCode).
		detailsServCount = INT(ENTRY(3,tmpStr)).
	end.
	
tmpStr = GetXAttrValueEx("op",STRING(op.op),"PIRSFInfo","").
if tmpStr <> "" then 
	do:
		infoIsExists = yes.
		infoSfType = ENTRY(1,tmpStr).
		infoPayType = ENTRY(2,tmpStr).
		infoSummaType = ENTRY(3,tmpStr).
		if num-entries(tmpStr) = 5 then 
			do:
				infoNeedLoan = "Да".
				infoLoanType = ENTRY(1,ENTRY(5,tmpStr), ".").
				infoLoanContCode = ENTRY(2,ENTRY(5,tmpStr), ".").
				infoLoan = infoLoanContCode.
				if infoLoanType = "АХД" then
					do:
						find first loan where loan.contract = "АХД" and loan.cont-code = infoLoanContCode no-lock no-error.
						if avail loan then infoLoan = loan.doc-num.
					end.
			end.
	end.
	
tmpStr = GetXAttrValueEx("op", STRING(op.op),"PIRSFNumber","").
if tmpStr <> "" then 
	do:
		numberIsExists = YES.
		sfNumber = ENTRY(1,tmpStr).
		sfDate = DATE(ENTRY(2,tmpStr)).
	end.
	
tmpStr = GetXAttrValueEx("op", STRING(op.op),"PIRSFAmount","").
if tmpStr <> "" then 
	do:
		amountIsExists = YES.
		sfAmount = DEC(tmpStr).
	end.