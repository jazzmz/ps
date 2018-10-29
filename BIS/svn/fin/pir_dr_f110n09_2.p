/* ���⠢��� �� f110_new = f110n09_2 ��� �.110. �롨ࠥ� ��� 47425 � ஫�� �।����. #1182
����⨭� �.�. 28.01.13
*/

{globals.i}
{intrface.get xclass}

DEF VAR ot AS TTable NO-UNDO.
DEF VAR drf110_new AS CHAR NO-UNDO.
DEF VAR i AS int NO-UNDO.

ot = new TTable(2).

ot:addRow().
ot:addCell(0).
ot:addCell("��⠭����� �� f110_new = f110n09_2").

for each loan-acct where string(loan-acct.acct) begins "47425" and loan-acct.acct-type eq "�।����" no-lock:
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
