/*�㦭� ��� ���⭮�� �� 㤠���� */
/* {pirsavelog.p} */
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009
*/

{globals.i}           /** �������� ��।������ */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */

{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEFINE VARIABLE cDR  AS CHAR     NO-UNDO.
DEFINE BUFFER   oe1  FOR op-entry.

{pir_exf_exl.i}
{getdates.i}

/******************************************* ��������� */
FOR EACH oe1
   WHERE (oe1.op-date GE beg-date)
     AND (oe1.op-date LE end-date)
     AND (CAN-DO("�।��*47.", oe1.kau-db)
      OR  CAN-DO("�।��*47.", oe1.kau-cr))
   NO-LOCK:

   cDR = GetXAttrValue("op-entry", STRING(oe1.op) + "," + STRING(oe1.op-entry), "��爧�����ࢠ").
   IF SUBSTRING(cDR, 1, 1) = "1" THEN SUBSTRING(cDR, 3, 1) = "4".
   IF SUBSTRING(cDR, 1, 1) = "2" THEN SUBSTRING(cDR, 3, 1) = "5".

   IF NOT UpdateSigns("op-entry", STRING(oe1.op) + "," + STRING(oe1.op-entry), "��爧�����ࢠ", cDR, NO)
   THEN DO:
      FIND FIRST op WHERE op.op EQ oe1.op
         NO-ERROR.
      MESSAGE "??? " + STRING(oe1.op-date) + " " + op.doc-num + " " + cDR
         VIEW-AS ALERT-BOX.
   END.
END.

{intrface.del}
