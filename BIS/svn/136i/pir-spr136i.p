/*
               ������᪠� ��⥣�஢����� ��⥬� �������
     Filename: ree-136i.p
      Comment: '136-� ' c 01/11/10
*/

FUNCTION StrDate RETURNS CHARACTER
   (INPUT inDat AS DATE):

   DEFINE VARIABLE cTMonths AS CHARACTER EXTENT 12
      INIT [" ﭢ��� ", " 䥢ࠫ� ", " ���� ", " ��५� ", " ��� ", " ��� ",
            " ��� ", " ������ ", " ᥭ���� ", " ������ ", " ����� ", " ������� "] NO-UNDO.

   RETURN STRING(DAY(inDat), "99") + cTMonths[MONTH(inDat)] + STRING(YEAR(inDat), "9999") + " ����".
END FUNCTION.
/* -------------------------------------------------------------- */
{globals.i}
DEFINE VARIABLE mKasNum   AS INTEGER NO-UNDO.

/* ����� ���ࠧ������� � ���짮��⥫�� */
PAUSE 0.
UPDATE
   mKasNum LABEL "����� ॥���     "
   WITH FRAME enter-cond
      WIDTH 60
      SIDE-LABELS
      CENTERED
      ROW 10
      TITLE "[ �롥�� ���ࠧ������� � ���짮��⥫� ]"
      OVERLAY
   EDITING:

   READKEY.
   APPLY LASTKEY.
END.
HIDE FRAME enter-cond.


FIND _user
   WHERE (_user._userid EQ USERID)
   NO-LOCK NO-ERROR.

{setdest.i &cols=80}

{get-bankname.i}

PUT UNFORMATTED
   SKIP(3)
   "������ (᮪�饭���)                " cBankName     SKIP
   "�ଥ���� ������������"                                             SKIP
   "㯮�����祭���� �����"                                              SKIP
   "(������������ 䨫����)"                                             SKIP(1)
   "�������樮��� �����               " FGetSetting("REGN","","")     SKIP
   "㯮�����祭���� �����"                                              SKIP
   "(���浪��� ����� 䨫����)"                                         SKIP(1)
   "���⮭�宦����� (����)             " FGetSetting("����_��","","") SKIP
   "㯮�����祭���� �����"                                              SKIP
   "(䨫����)"                                                          SKIP(1)
   "������������ ����७����            " cBankName     SKIP
   "������୮�� ���ࠧ�������          " FGetSetting("����_��","","") SKIP
   "㯮�����祭���� ����� � ���"                                        SKIP
   "���⮭�宦����� (����)"                                            SKIP(1)
   "��� ���������� ��ࠢ��             " gend-date                     SKIP
   "                                    ���� ����� ���"                 SKIP(1)
   "���浪��� ����� ��ࠢ��            " STRING(mKasNum)               SKIP
   "� �祭�� ࠡ�祣� ���"                                             SKIP(2)
   "                                     �������"                       SKIP
   "               �� ������⢨� ����権 � ����筮� ����⮩ � 祪���." SKIP(3)
   "       � �祭�� ࠡ�祣� ��� " + StrDate(gend-date) + " ����樨 � ����筮� ����⮩" SKIP
   "� 祪���, �������騥 ����祭�� � ������ (�ਫ������ 1 � ������樨 ����� ���ᨨ"      SKIP
   "�� 16.09.2010�. � 136-�), � ���� N " + STRING(mKasNum) + " ������⢮����."           SKIP(7)
   "���ᮢ� ࠡ�⭨�      __________________       "
   + ENTRY(1, _user._user-name, " ") + " "
   + SUBSTRING(ENTRY(2, _user._user-name, " "), 1, 1) + "."
   + SUBSTRING(ENTRY(3, _user._user-name, " "), 1, 1) + "." SKIP
   "                           (�������)" SKIP
.
{preview.i}
