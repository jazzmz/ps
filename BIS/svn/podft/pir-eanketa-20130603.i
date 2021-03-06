/***  ��� ������ ������ ��� �� �� ������ � 03/06/13 - 16/06/13  ***/

/* ���������� ��६����� cAnketa

DEFINE VARIABLE cAnketa  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iKl      AS INTEGER    NO-UNDO.

iKl EQ  2   - ��
*/

IF iKl = 2 THEN
DO:

           cAnketa = "~
                   ������ ������� - ��������������� ���������������|~
      |~
      |~
     2.1.  �������, ���, ����⢮: #2#|~
     2.2.  ��� ஦�����: #40#|~
     2.3.  ���� ஦�����: #42#|~
     2.4.  �ࠦ����⢮: #43#|~
     2.5.  ���㬥��, 㤮�⮢����騩 ��筮���: #45#|~
     2.6.  ���㬥��, ���⢥ত��騩 �ࠢ� �� �ॡ뢠��� (�஦������) � ���ᨩ᪮� �����樨 �����࠭���� �ࠦ������ ��� ��� ��� �ࠦ����⢠: #47#|~
     2.7.  ���� ���� ��⥫��⢠ (ॣ����樨): #17#|~
     2.8.  ���� ���� �ॡ뢠��� (�஦������): #19#|~
     2.9.  ���⮢� ����: #20#|~
     2.10. ���: #26#|~
     2.11. ����� ���⠪��� ⥫�䮭��: #21#|~
                      䠪� (��. ����): #22#|~
     2.12. ���㤠��⢥��� ॣ����樮��� �����: #14#|~
     2.13. ��� ॣ����樨: #15#|~
     2.14. ���� ॣ����樨 (��த, �������): #16#|~
     2.15. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: #30#|~
     2.16. ������������ �।���� �࣠����権, � ������ ������ ���㦨������ (࠭�� ���㦨�����): #35#|~
     2.17. �������� � ������� ९��樨 ������: #36#|~
     2.18. �஢��� �᪠: #37#|~
     2.19. ���᭮����� �業�� �஢�� �᪠: #38#|~
     2.20. ��� ������ ��ࢮ�� ������᪮�� ��� (������): #60#|~
     2.21. ��� ���������� ������ ������: #61#|~
     2.22. ��� ���������� ������ ������: #62#|~
     2.23. ����⭨� �����, ����訩 ���#63#|~
     2.24. ����⭨� �����, �⢥न�訩 ����⨥ ���#64#|~
     2.25. ����⭨� �����, ��������訩 ������ ������ � �����஭��� ����#65#|~
     2.26. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � �����஭��� ����, �� �㬠��� ���⥫�#66#|~
    |".

END.
ELSE 
DO:

      MESSAGE "������ �ଠ ������ ������ �� " end-date " ������� ⮫쪮 ��� �� !" VIEW-AS ALERT-BOX.
      cAnketa = "".

END.


FUNCTION UserFIO RETURNS CHARACTER
   (INPUT cUsr AS CHARACTER).

   FIND FIRST _user
      WHERE (_user._userid = cUsr)
      NO-LOCK NO-ERROR.

   IF AVAIL _user
   THEN
      RETURN "|       �������, ���, ����⢮: " + _user._user-name
           + "|       ���������: " + GetXAttrValue("_user", _user._userid, "���������").
   ELSE
      RETURN "|       �������, ���, ����⢮: " + PrintStringInfo("")
           + "|       ���������: " + PrintStringInfo("").

END.
