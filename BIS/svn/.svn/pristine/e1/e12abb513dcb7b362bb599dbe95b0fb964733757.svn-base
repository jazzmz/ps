{globals.i}
{flt_var.def}
{def-wf.i}
{aux_var.def}

DEF INPUT PARAMETER op-kind-code AS CHAR  NO-UNDO. /*код стандартной транзакции*/

DEF VAR cAcct2     AS CHAR NO-UNDO.
DEF VAR isResident AS LOG  NO-UNDO.
DEF VAR nNeresRes  AS CHAR INIT ? NO-UNDO.

nNeresRes = GetXAttrValueEx("op-kind",op-kind-code,"ПирНомерНерРез",?).

IF nNeresRes <> ? THEN DO:

FOR EACH loan_ved NO-LOCK,
 FIRST op WHERE op.op EQ loan_ved.op AND acct-cat EQ "b",
   EACH op-entry OF op:
      cAcct2     = SUBSTRING(op-entry.acct-db,1,5).
      isResident = NOT (IF getXAttrValueEx("bal-acct",cAcct2,"СчетНерез","Нет") = "Да" THEN YES ELSE NO).

      IF isResident THEN DO:
        ASSIGN
             op.doc-num = ENTRY(1,nNeresRes,",").
      END. ELSE DO:
             op.doc-num = ENTRY(2,nNeresRes,",").
      END.
  END.

END.




