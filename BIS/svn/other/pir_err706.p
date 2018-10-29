{pirsavelog.p}

/**  ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009
*/

{globals.i}            /** �������� ��।������ */
{tmprecid.def}         /** ���ଠ�� �� ��㧥� */
{intrface.get xclass}  /** ࠡ�� � ����奬��    */
{intrface.get strng}   /** ࠡ�� � ��ப���     */
{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEF VAR cDR      AS CHAR             NO-UNDO.
DEF VAR cVal     AS CHAR             NO-UNDO.
DEF VAR cS       AS CHAR             NO-UNDO.
DEF VAR I        AS INTEGER          NO-UNDO.
DEF VAR l706     AS LOGICAL          NO-UNDO.
DEF VAR l706ispr AS LOGICAL          NO-UNDO.

/******************************************* ��������� */

{getdates.i}
{setdest.i} /* �뢮� � preview */

I = 0.
FOR EACH op-entry
   WHERE (op-entry.op-date GE beg-date)
     AND (op-entry.op-date LE end-date)
   NO-LOCK:

   l706     = NO.
   l706ispr = NO.

   IF (SUBSTRING(op-entry.acct-db, 1, 5) EQ "70606")
   THEN DO:
      cVal = SUBSTRING(op-entry.acct-cr, 6, 3).
      cDR  = GetXAttrValue("acct", op-entry.acct-db + ",", "f102_cur").
      l706 = YES.
      l706ispr = SUBSTRING(op-entry.acct-cr, 1, 5) EQ "70606".
   END.

   IF (SUBSTRING(op-entry.acct-cr, 1, 5) EQ "70601")
   THEN DO:
      cVal = SUBSTRING(op-entry.acct-db, 6, 3).
      cDR  = GetXAttrValue("acct", op-entry.acct-cr + ",", "f102_cur").
      l706 = YES.
      l706ispr = SUBSTRING(op-entry.acct-db, 1, 5) EQ "70601".
   END.

   IF l706ispr
      OR (l706 AND (((cDR EQ "yes") AND (cVal EQ "810"))
                 OR ((cDR NE "yes") AND (cVal NE "810")))
         )
   THEN DO:

      IF (I EQ 0) THEN
         /* ����� 蠯�� */
         PUT UNFORMATTED SKIP
         "                              ��������� ��������" SKIP(1)
         "���������������������������������������������������������������������������������������������������������������Ŀ" SKIP
         "�  N   �    ����    �  �������� � ��� � ���.��� �        �����         �        ������        �      �����      �" SKIP
         "� �/�  �            �           �     � f102_cur�                      �                      �                 �" SKIP
         "���������������������������������������������������������������������������������������������������������������Ĵ" SKIP
         .

      I = I + 1.
      FIND FIRST op WHERE op.op EQ op-entry.op
         NO-ERROR.

      PUT UNFORMATTED
       "� " I FORMAT ">>>9"
      " � " op-entry.op-date FORMAT "99/99/9999"
      " � " op.doc-num FORMAT "x(9)"
      " � " cVal FORMAT "xxx"
      " � " cDR  FORMAT "x(7)"
      " � " op-entry.acct-db FORMAT "x(20)"
      " � " op-entry.acct-cr FORMAT "x(20)"
      .
      IF (op-entry.amt-cur EQ 0)
      THEN PUT UNFORMATTED
         " � " op-entry.amt-rub FORMAT "->>>,>>>,>>9.99"
         " �" SKIP.
      ELSE PUT UNFORMATTED
         " � " op-entry.amt-cur FORMAT "->>>,>>>,>>9.99"
         " �" SKIP.

   END.

END.

IF (I EQ 0)
THEN
   PUT UNFORMATTED SKIP(5)
   " ��������� �������� �� ����������." SKIP(1)
   .
ELSE
   PUT UNFORMATTED
   "�����������������������������������������������������������������������������������������������������������������" SKIP
   .

{preview.i}
