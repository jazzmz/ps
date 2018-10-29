/* 27.07.2013											*/
/* БИС, похоже, сломал функцию updatesigns. Временное решение для работоспособности анкет 	*/
/* Гончаров А.Е. ПИР Банк									*/


function SetTempSign returns logical (input iFile-name as char, iSurr as char, iRek as char, iValue as char).
	define variable oLog as logical init true no-undo.
        find last tmpsigns where tmpsigns.file-name = iFile-name
		and tmpsigns.code = iRek
		and tmpsigns.surrogate = iSurr
		and tmpsigns.since = gend-date
		no-error.

	if not available tmpsigns then do:
		create tmpsigns.
	end.
	assign 
		tmpsigns.file-name = iFile-name
		tmpsigns.surrogate = iSurr
		tmpsigns.code = iRek
		tmpsigns.since = gend-date
		tmpsigns.code-value = iValue
		no-error.
	if error-status:ERROR then oLog = false.
	return oLog.
end function.