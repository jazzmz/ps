/** 
	Инклюдник, вызываемый из процедуры pirsfopsigns.p, для чтения 
	изформации из БД. 
*/

tmpStr = GetXAttrValueEx("op",STRING(op.op),"PIRSFDetails","").
if tmpStr <> "" then 
	do:
		detailsServName = ENTRY(1,tmpStr).
		detailsServCode = ENTRY(2,tmpStr).
		detailsServCount = INT(ENTRY(3,tmpStr)).
	end.
	
tmpStr = GetXAttrValueEx("op",STRING(op.op),"PIRSFInfo","").
if tmpStr <> "" then 
	do:
		infoSfType = ENTRY(1,tmpStr).
		infoPayType = ENTRY(2,tmpStr).
		infoSummaType = ENTRY(3,tmpStr).
		if num-entries(tmpStr) = 5 then 
			do:
				infoNeedLoan = "Да".
				infoLoanType = ENTRY(1,ENTRY(5,tmpStr), ".").
				infoLoan = ENTRY(2,ENTRY(5,tmpStr), ".").
			end.
	end.