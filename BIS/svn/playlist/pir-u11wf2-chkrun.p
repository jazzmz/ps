/** �����誠, ����� ����� ���� �ᯮ�짮���� � ࠡ�� �࠭���権, 
    �᭮������ �� ��楤�� pirustrt.p 
*/

/** ��� ���� ���, � ���஬ �믮��﫠�� �࠭����� */
DEFINE INPUT PARAMETER in-op-date AS DATE  NO-UNDO.
/** ᮡ�⢥��� ��� �࠭���樨, ����� �믮��﫠�� */
DEFINE INPUT PARAMETER in-op-kind AS CHAR  NO-UNDO.
/** ���짮��⥫�, ����� ����᪠� �࠭����� */
DEFINE INPUT PARAMETER in-user-id AS CHAR  NO-UNDO.



/**  ����� 2-�� �������� ��� �������� ⮫쪮 � ��.���, ᫥���饬 
�� ��室��/�ࠧ����� ����
*/

{gdate.i}
IF NOT( IsHoliday(in-op-date - 1) ) THEN
  DO:
     MESSAGE COLOR WHITE/RED 
        "����� 2-�� �������� ��� �������� ⮫쪮 � ��.���, ᫥���饬 �� ��室��/�ࠧ����� ����! ��室�� �� �࠭���樨!"
        VIEW-AS ALERT-BOX TITLE "������" .
     RETURN ERROR. 
  END.
