/*********************************
 * ������ � ����祭��         *
 * ���稪� ���஭���� ��娢�. *
 *********************************/
DEF VAR iCurrOut  AS INTEGER NO-UNDO.
iCurrOut = GetCounterCurrentValue("PirA2346U",TODAY). 	/* ����稫� ⥪�騩 ����� ���稪� */

IF iCurrOut EQ ? THEN DO:
	MESSAGE "�� ����饭 �ࢥ� ��⮭㬥�樨!\n���㧪� � ��娢 ����������" VIEW-AS ALERT-BOX.
RETURN "ERROR".
END.
SetCounterValue("PirA2346U",?,TODAY).			/* ��� �� ��� ���६���஢��� */