/*
#4106 �������� �.�.
����� ����� ����㯨�襣� �/� � ����᫥���� ��௫��� �� ���㫨஢����
� ���������� ���ଠ樨 � ����� ��� �ନ஢���� �஢���� ����᫥��� �/�
*/

{bislogin.i}
{globals.i}
{tmprecid.def}

{intrface.get xclass}

DEFINE VAR Doc_YN AS LOGICAL NO-UNDO INIT NO.

FOR EACH tmprecid,
    FIRST op WHERE RECID(op) EQ tmprecid.id.

if op.user-id eq "BNK-CL" then do:
	message "�� 㢥७�, �� ��ࠫ� �ࠢ���� ���㬥��? ����ঠ��� ��࠭����: " op.details view-as alert-box buttons yes-no SET Doc_YN.
	IF Doc_YN THEN DO:

	create code.
		code.class	 = "PIR4106".
		code.parent	 = "PIR4106".
		code.code	 = string(op.op).
		code.val	 = string(op-date).
	find first op-entry where op-entry.op = op.op no-lock no-error.
	if available op-entry then do: 
		code.description[1] = op-entry.acct-db.
		code.name = "���㬥�� �" + string(op.doc-num) + ", �㬬�: " + string(op-entry.amt-rub) + "�.".
		end.
        
	op.op-status = "�".
	op.op-date = ?.
        
	end.
end.
END.

MESSAGE "��⮢�!" VIEW-AS ALERT-BOX.

{intrface.del}
