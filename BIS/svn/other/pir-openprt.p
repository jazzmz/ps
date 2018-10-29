/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: OPENPRT.P
      Comment: Стандартная процедура печати
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
   op.doc-num                                   COLUMN-LABEL 'N док'
   op.doc-type       FORMAT "xxxxx"             COLUMN-LABEL 'Kod'
   DR-type           FORMAT "xxxxx"             COLUMN-LABEL 'KodDR'
   acct-db           FORMAT "x(24)"             COLUMN-LABEL 'ДЕБЕТ'
   acct-cr           FORMAT "x(24)"             COLUMN-LABEL 'КРЕДИТ'
   op-entry.currency FORMAT "xxx"
   summ              FORMAT "->>>>>>>>>>>>9.99" COLUMN-LABEL 'Сумм.вал'
   summ1             FORMAT "->>>>>>>>>>>>9.99" COLUMN-LABEL 'Сумм руб'
   dop               FORMAT "x(10)"             COLUMN-LABEL 'Прим'
WITH FRAME brw WIDTH 140 DOWN.

RUN g-prompt.p("CHARACTER", "Прим", "x(10)", "--",
               "Примечание", 20, ",", "", ?,?,OUTPUT dop).
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
      DR-type = GetXAttrValueEx("op", STRING(op.op), "ШифрПл", "")
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
