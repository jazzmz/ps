/** �����誠, ����� ����� ���� �ᯮ�짮���� � ࠡ�� �࠭���権, 
    �᭮������ �� ��楤�� pirustrt.p 
*/

/** ��� ���� ���, � ���஬ �믮��﫠�� �࠭����� */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** ᮡ�⢥��� ��� �࠭���樨, ����� �믮��﫠�� */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** ���짮��⥫�, ����� ����᪠� �࠭����� */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.



/**  ����������� � ����室����� �஢��� ��室 
*/

MESSAGE "� �� �஢��� �।�⮢� �஢���� (��室) ??? "
	VIEW-AS ALERT-BOX BUTTONS YES-NO 
	TITLE "��������������" 
	UPDATE choice AS LOGICAL.

IF choice = no THEN
	RETURN ERROR.




/**  ��࠭� � �裡 � ࠧ�������� ����-���� (����⨪� � �।���)
*/

/*
FIND FIRST op WHERE op.op-date		EQ	in-op-date
                AND op.op-status	LT	'�'
                AND op.user-id 		EQ  'PLASTIK' 

NO-LOCK NO-ERROR.
                      

IF AVAIL op THEN 
DO:
	MESSAGE "������! ������� �������������������� ��������� !!" VIEW-AS ALERT-BOX.
	RETURN ERROR.
END.
ELSE 
DO:
/*MESSAGE " ALL OK!" VIEW-AS ALERT-BOX.*/
RETURN.
END.
*/
