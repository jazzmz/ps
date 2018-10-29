{pirsavelog.p}

DEF INPUT PARAM in-param AS CHAR.

/* !!! pir_selfpr.p
   ������ �஢���� ����� ��⠬� ������ ������
   ���ᮢ �.�. 03.07.2009
*/

{globals.i} /* �������塞 �������� ����ன��*/
{tmprecid.def}

{intrface.get loan}
{intrface.get xclass}   /* �㭪樨 ࠡ��� � ����奬�� */

DEF VAR iDbCust     AS INTEGER   NO-UNDO.
DEF VAR cDbCat      AS CHARACTER NO-UNDO.
DEF VAR iCrCust     AS INTEGER   NO-UNDO.
DEF VAR cCrCat      AS CHARACTER NO-UNDO.

DEF VAR iAll        AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbUl       AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbFl       AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iSelf       AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbUlSelf   AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbFlSelf   AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDr         AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbUlDr     AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbFlDr     AS INTEGER   INIT 0 NO-UNDO.

DEF VAR dSAll       AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSUl        AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSFl        AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSSelf      AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSUlSelf    AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSFlSelf    AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSDr        AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSUlDr      AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSFlDr      AS DECIMAL   INIT 0 NO-UNDO.

DEF VAR summ        AS DECIMAL   NO-UNDO.
DEF VAR summ1       AS DECIMAL   NO-UNDO.
DEF VAR acct-db     AS CHARACTER NO-UNDO.
DEF VAR acct-cr     AS CHARACTER NO-UNDO.
DEF VAR dop         AS CHARACTER NO-UNDO.
DEF VAR DR-type     AS CHARACTER NO-UNDO.

RUN g-prompt.p("CHARACTER", "�ਬ", "x(10)", "--",
               "�ਬ�砭��", 20, ",", "", ?,?,OUTPUT dop).
   IF (dop = ?)
   THEN RETURN.

{setdest.i &cols = 140 &custom = " IF YES THEN 0 ELSE "} /* �뢮� � preview */

{get-fmt.i &obj = '" + 'b' + ""-Acct-Fmt"" + "'}
FORM
   op-entry.op-date  FORMAT "99/99/99"
   op.doc-num                                   COLUMN-LABEL 'N ���'
   op.doc-type       FORMAT "xxxxx"             COLUMN-LABEL 'Kod'
   DR-type           FORMAT "xxxxx"             COLUMN-LABEL 'KodDR'
   acct-db           FORMAT "x(24)"             COLUMN-LABEL '�����'
   acct-cr           FORMAT "x(24)"             COLUMN-LABEL '������'
   op-entry.currency FORMAT "xxx"
   summ              FORMAT "->>>>>>>>>>>>9.99" COLUMN-LABEL '�㬬.���'
   summ1             FORMAT "->>>>>>>>>>>>9.99" COLUMN-LABEL '�㬬 ��'
   dop               FORMAT "x(10)"             COLUMN-LABEL '�ਬ'
WITH FRAME brw WIDTH 140 DOWN.

/* ����� ���� ==================================================================== */
PUT UNFORMATTED
"                                   1 �஢���� ����� ��⠬� ������ ������" SKIP(2)
/*
"�    ����     ����� �����. �� �����                    ������                   ���      ����� � ���. ���." SKIP
"---- -------- ------------ -- ------------------------ ------------------------ ---- ---------------------" SKIP
*/
.

/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... =========================== */
FOR EACH tmprecid
   NO-LOCK,
   FIRST op-entry
      WHERE (RECID(op-entry) EQ tmprecid.id)
      NO-LOCK,
   FIRST op OF op-entry
      NO-LOCK
   WITH FRAME brw:

   IF (op-entry.acct-db EQ ?) OR (op-entry.acct-cr EQ ?) THEN NEXT.
   iAll  = iAll + 1.
   dSAll = dSAll + op-entry.amt-rub.

   FIND FIRST acct WHERE acct.acct = op-entry.acct-db
      NO-ERROR.
   ASSIGN
      iDbCust = acct.cust-id
      cDbCat  = acct.cust-cat
   .

   FIND FIRST acct WHERE acct.acct = op-entry.acct-cr
      NO-ERROR.
   ASSIGN
      iCrCust = acct.cust-id
      cCrCat  = acct.cust-cat
   .

   IF (cDbCat EQ "�") THEN
      ASSIGN
         iDbUl = iDbUl + 1
         dSUl  = dSUl + op-entry.amt-rub
      .
   IF (cDbCat EQ "�") THEN
      ASSIGN
         iDbFl = iDbFl + 1
         dSFl  = dSFl + op-entry.amt-rub
      .

   IF (iDbCust EQ iCrCust) AND (cDbCat EQ cCrCat) AND (cDbCat NE "�")
   THEN DO:
      iSelf  = iSelf  + 1.
      dSSelf = dSSelf + op-entry.amt-rub.

      IF (cDbCat EQ "�") THEN
         ASSIGN
            iDbUlSelf = iDbUlSelf + 1
            dSUlSelf  = dSUlSelf + op-entry.amt-rub
         .
      IF (cDbCat EQ "�") THEN
         ASSIGN
            iDbFlSelf = iDbFlSelf + 1
            dSFlSelf  = dSFlSelf + op-entry.amt-rub
         .
/*
      PUT UNFORMATTED
         op-entry.op-status FORMAT "x(4)" SPACE
         op-entry.op-date   FORMAT "99/99/99" SPACE
         op.doc-num         FORMAT "x(12)" SPACE(4)
         {out-fmt.i op-entry.acct-db fmt} FORMAT "x(24)" SPACE
         {out-fmt.i op-entry.acct-cr fmt} FORMAT "x(24)" SPACE
         op-entry.currency  FORMAT "x(4)" SPACE
         op-entry.amt-rub   FORMAT "->,>>>,>>>,>>>,>>9.99" SPACE
      SKIP.
*/
      ASSIGN
         acct-db = IF op-entry.acct-db NE ? 
                   THEN {out-fmt.i op-entry.acct-db fmt}
                   ELSE ""
         acct-cr = IF op-entry.acct-cr NE ? 
                   THEN {out-fmt.i op-entry.acct-cr fmt}
                   ELSE ""
         DR-type = GetXAttrValueEx("op", STRING(op.op), "������", "")
      .
      IF op-entry.acct-cat EQ "d" THEN 
         ASSIGN 
            summ  = op-entry.amt-rub
            summ1 = op-entry.amt-rub
         .
      ELSE DO:
         ASSIGN 
            summ  = op-entry.amt-cur
            summ1 = op-entry.amt-rub
         .
         IF op-entry.currency EQ "" THEN
            ASSIGN 
               summ  = op-entry.amt-rub
               summ1 = op-entry.amt-rub
            .
      END.

	UpdateSigns ( "op", string(op.op) , "f251_exc", in-param, YES ).

      DISPLAY
         op-entry.op-date
         op.doc-num
         op.doc-type
         DR-type
         acct-db
         acct-cr
         op-entry.currency
         summ
         summ1
         dop
	 GetXAttrValueEx("op", STRING(op.op), "f251_exc", "NO")
      .
      DOWN.
   END.

END.

PUT UNFORMATTED
   SKIP "�ᥣ� �஢���� 'ᠬ��� ᥡ�' : " iSelf FORMAT ">>>>>9"
   SKIP "======================================================="
   SKIP "�ᥣ� �஢���� : " iAll  FORMAT ">>>>>9" " , �� ��� 'ᠬ��� ᥡ�' : " iSelf     FORMAT ">>>>>9" " (ࠧ����� : " (iAll - iSelf)      FORMAT ">>>>>9" " )"
   SKIP "  �� ��⮢ �� : " iDbUl FORMAT ">>>>>9" " , �� ��� 'ᠬ��� ᥡ�' : " iDbUlSelf FORMAT ">>>>>9" " (ࠧ����� : " (iDbUl - iDbUlSelf) FORMAT ">>>>>9" " )"
   SKIP "  �� ��⮢ �� : " iDbFl FORMAT ">>>>>9" " , �� ��� 'ᠬ��� ᥡ�' : " iDbFlSelf FORMAT ">>>>>9" " (ࠧ����� : " (iDbFl - iDbFlSelf) FORMAT ">>>>>9" " )"
   SKIP "======================================================="
   SKIP .

PUT UNFORMATTED
   SKIP "������������������������������������������������������Ŀ"
   SKIP "�                     � ���-�� �         �㬬�         �"
   SKIP "������������������������������������������������������Ĵ"
   SKIP "�     �� ��⮢ ��    �        �                       �"
   SKIP "� �ᥣ�               � " iDbUl     FORMAT ">>>>>9" " � " dSUl     FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
   SKIP "� '������ ᥡ�'       � " iDbUlSelf FORMAT ">>>>>9" " � " dSUlSelf FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
/* SKIP "�   ��㣨� �᪫�祭�� � " iDbUlDr   FORMAT ">>>>>9" " � " dSUlDr   FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
*/ SKIP "� ���⮪             � " (iDbUl - iDbUlSelf - iDbUlDr) FORMAT ">>>>>9" " � "
                                   (dSUl  - dSUlSelf  - dSUlDr)  FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
   SKIP "������������������������������������������������������Ĵ"
   SKIP "�     �� ��⮢ ��    �        �                       �"
   SKIP "� �ᥣ�               � " iDbFl     FORMAT ">>>>>9" " � " dSFl     FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
   SKIP "� '������ ᥡ�'       � " iDbFlSelf FORMAT ">>>>>9" " � " dSFlSelf FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
/* SKIP "�   ��㣨� �᪫�祭�� � " iDbFlDr   FORMAT ">>>>>9" " � " dSFlDr   FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
*/ SKIP "� ���⮪             � " (iDbFl - iDbFlSelf - iDbFlDr) FORMAT ">>>>>9" " � "
                                   (dSFl  - dSFlSelf  - dSFlDr)  FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
   SKIP "������������������������������������������������������͵"
   SKIP "�     �����           �        �                       �"
   SKIP "� �ᥣ�               � " iAll  FORMAT ">>>>>9" " � " dSAll  FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
   SKIP "� '������ ᥡ�'       � " iSelf FORMAT ">>>>>9" " � " dSSelf FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
/* SKIP "�   ��㣨� �᪫�祭�� � " iDr   FORMAT ">>>>>9" " � " dSDr   FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
*/ SKIP "� ���⮪             � " (iAll  - iSelf  - iDr)  FORMAT ">>>>>9" " � "
                                   (dSAll - dSSelf - dSDr) FORMAT "->,>>>,>>>,>>>,>>9.99" " �"
   SKIP "��������������������������������������������������������"
   SKIP .

/* �⮡ࠦ��� ᮤ�ন��� preview */
{preview.i}
