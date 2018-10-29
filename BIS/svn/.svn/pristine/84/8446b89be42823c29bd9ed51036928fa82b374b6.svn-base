{globals.i}
{flt_var.def}
{def-wf.i}
{aux_var.def}

DEF INPUT PARAMETER op-kind-code AS CHAR  NO-UNDO. /*код стандартной транзакции*/

DEF VAR cAcct2     AS CHAR NO-UNDO.
DEF VAR isResident AS LOG  NO-UNDO.
DEF VAR nNeresRes  AS CHAR INIT ? NO-UNDO.



FOR EACH loan_ved NO-LOCK,
 FIRST op WHERE op.op EQ loan_ved.op AND acct-cat EQ "b",
   EACH op-entry OF op:
   find first loan-acct where loan-acct.acct = op-entry.acct-db
                          and loan-acct.since <= op.op-date
                          and loan-acct.contract = "Кредит"
                              NO-LOCK NO-ERROR.


   IF AVAILABLE loan-acct 
      THEN
      DO:

      END.
                                                    

/*      cAcct2     = SUBSTRING(op-entry.acct-db,1,5).
      isResident = NOT (IF getXAttrValueEx("bal-acct",cAcct2,"СчетНерез","Нет") = "Да" THEN YES ELSE NO).

      IF NOT isResident THEN DO:
             find first code where code.class  EQ 'PirChNerezDoc' 
                               AND code.parent EQ 'PirChNerezDoc' 
                               AND code.code   EQ op.doc-num.
                               NO-LOCK NO-ERROR.
             IF AVAILABLE code THEN op.doc-num = code.name.
      END.*/

  END.

/*END.*/



