/* #3672						*/
/* �모�뢠�� �� tmprecid ���㬥��� �����⮢, 		*/
/* �� ���� ������ �⮨� ���४ ��������믨᮪ � NO	*/
/* (������ ᪠���, �� ��� �� �㦭� �믨᪨)		*/
/* � ����᪠�� op-print			 		*/
/* 12.09.2013�. ��� ����				*/
/* ��᪮� �.�., ����஢ �.�.				*/

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
			if acct.cust-cat ne "�" then
				if logical (GetXattrValueEx ("acct", acct.acct + "," + acct.currency, "��������믨᮪", "YES")) then rPrn = true.
		end.

		find first acct where acct.acct = op-entry.acct-cr no-lock no-error.
		if available acct then do:
			if acct.cust-cat ne "�" then
				if logical (GetXattrValueEx("acct",  acct.acct + "," + acct.currency, "��������믨᮪", "YES")) then rPrn = true.
		end.
		if not rPrn then delete tmprecid.
end.

if search(rProc + ".r") <> ? then
	run value (rProc + ".r").
	else if search(rProc + ".p") <> ? then run value(rProc + ".p").
		else message "��楤�� " rProc "�� �������!" view-as alert-box.