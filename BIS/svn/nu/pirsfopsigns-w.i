/** 
	Инклюдник, вызываемый из процедуры pirsfopsigns.p, для записи 
	изформации в БД. 
*/

/** Плановая дата */
op.contract-date = DATE(op.contract-date:SCREEN-VALUE IN FRAME editFrame).

/** Сохраняем PIRSFDetails */
tmpStr = detailsServName:SCREEN-VALUE + "," + detailsServCode:SCREEN-VALUE + "," + STRING(detailsServCount:SCREEN-VALUE).
if detailsIsExists then
	do:
		find first signs where code = "PIRSFDetails" and file-name = "op" and surrogate = STRING(op.op) NO-ERROR.
		if avail signs then signs.xattr-value = tmpStr.
	end.
else
	do:
		create signs.
		assign 
			signs.code = "PIRSFDetails"
			signs.file-name = "op"
			signs.surrogate = STRING(op.op)
			signs.xattr-value = tmpStr.
	end.
	
/** Сохраним PIRSFInfo */
tmpStr = infoSfType:SCREEN-VALUE + "," + infoPayType:SCREEN-VALUE + "," + infoSummaType:SCREEN-VALUE + ",1".
if  infoNeedLoan:SCREEN-VALUE IN FRAME editFRAME = "Да" 
		and 
		infoLoanType:SCREEN-VALUE  IN FRAME editFRAME <> "" 
		and 
		infoLoan:SCREEN-VALUE IN FRAME editFRAME <> "" 
then 
	tmpStr = tmpStr + "," + infoLoanType:SCREEN-VALUE + "." + TRIM(infoLoanContCode).
	
if infoIsExists then
	do:
		find first signs where code = "PIRSFInfo" and file-name = "op" and surrogate = STRING(op.op) NO-ERROR.
		if avail signs then signs.xattr-value = tmpStr.
	end.
else
	do:
		create signs.
		assign 
			signs.code = "PIRSFInfo"
			signs.file-name = "op"
			signs.surrogate = STRING(op.op)
			signs.xattr-value = tmpStr.
	end.
	
/** Сохраним PIRSFNumber */
tmpStr = sfNumber:SCREEN-VALUE + "," + sfDate:SCREEN-VALUE.
if sfNumber:SCREEN-VALUE <> "" and sfDate:SCREEN-VALUE <> "" then 
	do:
		if numberIsExists then
			do:
				find first signs where code = "PIRSFNumber" and file-name = "op" and surrogate = STRING(op.op) NO-ERROR.
				if avail signs then signs.xattr-value = tmpStr.
			end.
		else
			do:
				create signs.
				assign
					signs.code = "PIRSFNumber"
					signs.file-name = "op"
					signs.surrogate = STRING(op.op)
					signs.xattr-value = tmpStr.
			end.
	end.

/** Сохраним PIRSFAmount */
if DEC(sfAmount:SCREEN-VALUE) > 0 then 
	do:
		if amountIsExists then 
			do:
				find first signs where code = "PIRSFAmount" and file-name = "op" and surrogate = STRING(op.op) NO-ERROR.
				if avail signs then signs.code-value = sfAmount:SCREEN-VALUE.
			end.
		else
			do:
				create signs.
				assign
					signs.code = "PIRSFAmount"
					signs.file-name = "op"
					signs.surrogate = STRING(op.op)
					signs.code-value = sfAmount:SCREEN-VALUE.
			end.
	end.