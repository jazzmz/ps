/** �����誠, ����� ����� ���� �ᯮ�짮���� � ࠡ�� �࠭���権, 
    �᭮������ �� ��楤�� pirustrt.p 
*/

/** ��� ���� ���, � ���஬ �믮��﫠�� �࠭����� */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** ᮡ�⢥��� ��� �࠭���樨, ����� �믮��﫠�� */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** ���짮��⥫�, ����� ����᪠� �࠭����� */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.
/** �����䨪��� �࠭���樨 op-transaction.op-transaction */
DEFINE INPUT PARAMETER in-op-transaction AS CHAR NO-UNDO.



/*MESSAGE " BEGIN CHECK! " VIEW-AS ALERT-BOX.*/

FIND FIRST pc-trans WHERE pc-trans.pctr-status = '���' NO-LOCK NO-ERROR .

IF AVAIL pc-trans THEN 
DO:
    MESSAGE "�� ��� ���������� ������� ���������� !!! " VIEW-AS ALERT-BOX.
    RETURN ERROR.
END.    
ELSE 
DO:
    /* MESSAGE " ��� OK! " VIEW-AS ALERT-BOX. */
    RETURN.
END.