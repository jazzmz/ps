/** ��� ���� ���, � ���஬ �믮��﫠�� �࠭����� */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** ᮡ�⢥��� ��� �࠭���樨, ����� �믮��﫠�� */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** ���짮��⥫�, ����� ����᪠� �࠭����� */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.
/** �����䨪��� �࠭���樨 op-transaction.op-transaction */
DEFINE INPUT PARAMETER in-op-transaction AS CHAR NO-UNDO.

/** ��᫥������ ����⨥ ctrl+c � ������ ࠡ��� ��
    �᫨ ����⨥ �뫮, � op-transaction �� ᮧ������ �, ᫥����⥫쭮,
    �� ��।����� � ������ ��楤��� �஢�ન */
IF TRIM(in-op-transaction) = "" THEN 
	RETURN ERROR.
ELSE
	RETURN.