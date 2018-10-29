{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
*/

{globals.i}           /** �������� ��।������ */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */

{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEF VAR cSurr AS CHAR     NO-UNDO.
DEF VAR cDR1  AS CHAR     NO-UNDO.
DEF VAR cDR2  AS CHAR     NO-UNDO.
DEF VAR cBeg  AS CHAR     NO-UNDO.
DEF VAR cEnd  AS CHAR     NO-UNDO.
DEF VAR cSrok AS CHAR     NO-UNDO.
DEF VAR cKod  AS CHAR     NO-UNDO.

/******************************************* ��������� */
FOR FIRST tmprecid
   NO-LOCK,
   FIRST op
      WHERE (RECID(op) EQ tmprecid.id)
      NO-LOCK:

   cSurr = STRING(op.op).
   cDR1  = GetXAttrValue("op", cSurr, "��������㬥��").
   cDR2  = GetXAttrValue("op", cSurr, "��������").
   cBeg  = GetXAttrValue("op", cSurr, "PIRKbegDate").
   cEnd  = GetXAttrValue("op", cSurr, "PIRKendDate").
   cSrok = GetXAttrValue("op", cSurr, "PIRKsrok").

   /* ===== ����饭�� 㦥 ��ࠢ���� */
   IF (cDR2 NE "")
   THEN DO:
      MESSAGE 
         "����饭�� �� ���㬥��� N " + op.doc-num + " �� " + STRING(op.op-date) SKIP
         "㦥 �뫮 ��ࠢ���� � ����� " + cDR2
         VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.
      RETURN.
   END.

   /* ===== ���㬥�� 㦥 ��� �� ����஫� */
   IF (cEnd NE "")
   THEN DO:
      MESSAGE 
         "���㬥�� N " + op.doc-num + " �� " + STRING(op.op-date) SKIP
         "㦥 ��� �� ����஫� � " + cBeg + " �� " + cEnd
         VIEW-AS ALERT-BOX MESSAGE BUTTONS OK.
      RETURN.
   END.

   IF (cBeg NE "")
   /* ===== ������� � ����஫� */
   THEN DO:
      RUN g-prompt.p("CHARACTER", "��� ��ࠢ�� � �� ��� ����", "x(10)", cDR1,
                     "������� � ����஫� ���㬥�� N " + op.doc-num + " �� " + STRING(op.op-date), 57, ",", "", ?, ?, OUTPUT cKod).
      IF (cKod EQ ?)
      THEN RETURN.

      UpdateSigns("op", cSurr, "PIRKendDate", STRING(TODAY, "99/99/9999"), NO).

      IF (cKod EQ "")
      THEN UpdateSigns("op", cSurr, "��������㬥��", "", YES).
      ELSE UpdateSigns("op", cSurr, "��������", cKod, YES).
   END.
   /* ===== �⠢�� �� ����஫� */
   ELSE DO:
      RUN g-prompt.p("DATE", "�ப ����஫� ��� ����", "99/99/9999", STRING(TODAY),
                     "�⠢�� �� ����஫� ���㬥�� N " + op.doc-num + " �� " + STRING(op.op-date, "99/99/9999"), 57, ",", "", ?, ?, OUTPUT cKod).
      IF (cKod EQ ?)
      THEN RETURN.
      ELSE UpdateSigns("op", cSurr, "PIRKsrok", STRING(DATE(cKod), "99/99/9999"), NO).

      IF (cDR1 EQ "")
      THEN UpdateSigns("op", cSurr, "��������㬥��", "6001", YES).

      UpdateSigns("op", cSurr, "PIRKbegDate", STRING(TODAY, "99/99/9999"), NO).
      UpdateSigns("op", cSurr, "PIRKontrol", "-", NO).
   END.

END.
{intrface.del}
