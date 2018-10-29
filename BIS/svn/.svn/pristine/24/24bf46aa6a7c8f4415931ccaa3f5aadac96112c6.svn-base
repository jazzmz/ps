/* Проставляет ДР f110_new = f110n09_2 для ф.110. Выбирает счета 47425 с ролью КредРезП. #1182
Никитина Ю.А. 28.01.13
*/

{globals.i}
{intrface.get xclass}

DEF VAR ot AS TTable NO-UNDO.
DEF VAR drf110_new AS CHAR NO-UNDO.
DEF VAR i AS int NO-UNDO.

ot = new TTable(2).

ot:addRow().
ot:addCell(0).
ot:addCell("Установлен ДР f110_new = f110n09_2").

for each loan-acct where string(loan-acct.acct) begins "47425" and loan-acct.acct-type eq "КредРезП" no-lock:
	if avail(loan-acct) then do:
		drf110_new = GetXAttrValue("acct",loan-acct.acct + "," + loan-acct.currency,"f110_new").
		if drf110_new eq "" then do:
			UpdateSignsEx("acctb",loan-acct.acct + ',' + loan-acct.currency, "f110_new", "f110n09_2").
			i = i + 1.
			ot:addRow().
			ot:addCell(i).
			ot:addCell(loan-acct.acct).
		end.
	end.
end.

OUTPUT TO "./f110_new.log".
OUTPUT CLOSE.
DELETE OBJECT ot.
