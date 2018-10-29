/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: OPENPRT.P
      Comment: �⠭���⭠� ��楤�� ����
   Parameters:
         Uses:
      Used by:
      Created: 08/09/04 ilvi (21766)
     Modified: 
*/
{globals.i}
{tmprecid.def}

DEFINE VARIABLE summ    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE summ1   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE acct-db AS CHARACTER  NO-UNDO.
DEFINE VARIABLE acct-cr AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dop     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE DR-type AS CHARACTER  NO-UNDO.

{get-fmt.i &obj='" + 'b' + ""-Acct-Fmt"" + "'}
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

RUN g-prompt.p("CHARACTER", "�ਬ", "x(10)", "--",
               "�ਬ�砭��", 20, ",", "", ?,?,OUTPUT dop).
   IF (dop = ?)
   THEN RETURN.

{setdest.i &cols = 140 &custom = " IF YES THEN 0 ELSE "}

FOR EACH tmprecid
   NO-LOCK,
   FIRST op-entry
      WHERE (RECID(op-entry) EQ tmprecid.id)
      NO-LOCK,
   FIRST op OF op-entry
      NO-LOCK
   WITH FRAME brw:

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
   .
   DOWN.
END.

{preview.i}
