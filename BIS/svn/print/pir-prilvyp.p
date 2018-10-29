/* #3672						*/
/* Выкидываем из tmprecid документы клиентов, 		*/
/* на счетах которых стоит допрек ПирПечатьВыписок в NO	*/
/* (клиент сказал, что ему не нужны выписки)		*/
/* и запускаем op-print			 		*/
/* 12.09.2013г. ПИР Банк				*/
/* Красков А.С., Гончаров А.Е.				*/

{globals.i}
{tmprecid.def}
{intrface.get xclass}

define variable rProc as char init "op-print" no-undo.
define variable rPrn as logical no-undo.

for each tmprecid,
	each op where recid(op) eq tmprecid.id no-lock,
	each op-entry of op no-lock:
		rPrn = false.

		find first acct where acct.acct = op-entry.acct-db no-lock no-error.
		if available acct then do:
			if acct.cust-cat ne "В" then
				if logical (GetXattrValueEx ("acct", acct.acct + "," + acct.currency, "ПирПечатьВыписок", "YES")) then rPrn = true.
		end.

		find first acct where acct.acct = op-entry.acct-cr no-lock no-error.
		if available acct then do:
			if acct.cust-cat ne "В" then
				if logical (GetXattrValueEx("acct",  acct.acct + "," + acct.currency, "ПирПечатьВыписок", "YES")) then rPrn = true.
		end.
		if not rPrn then delete tmprecid.
end.

if search(rProc + ".r") <> ? then
	run value (rProc + ".r").
	else if search(rProc + ".p") <> ? then run value(rProc + ".p").
		else message "Процедура " rProc "не найдена!" view-as alert-box.