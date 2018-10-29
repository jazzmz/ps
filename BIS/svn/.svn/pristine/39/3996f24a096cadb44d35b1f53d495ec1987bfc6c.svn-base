FUNCTION get_set_my RETURNS CHARACTER (in-name AS CHARACTER):
DEFINE BUFFER idnt-setting FOR setting.
   IF NUM-ENTRIES(in-name) EQ 1 THEN DO:
      FIND FIRST idnt-setting WHERE idnt-setting.Code = in-name NO-LOCK NO-ERROR.
      IF NOT AVAIL idnt-setting THEN
      FIND FIRST idnt-setting WHERE idnt-setting.Sub-Code = in-name NO-LOCK NO-ERROR.
      RETURN IF AVAIL idnt-setting THEN idnt-setting.val
                                   ELSE ?.
   END.
   ELSE IF NUM-ENTRIES(in-name) EQ 2 THEN DO:
      FIND FIRST idnt-setting WHERE idnt-setting.Code     = ENTRY(1,in-name)
                                AND idnt-setting.Sub-Code = ENTRY(2,in-name) NO-LOCK NO-ERROR.
      RETURN IF AVAIL idnt-setting THEN idnt-setting.val
                                   ELSE ?.
   END.
END FUNCTION.

FUNCTION BankNameCity RETURN CHAR (BUFFER b FOR banks):
  RETURN {banknm.lf b} + (IF {bankct.lf b} <> '' THEN ', ' ELSE '') + {bankct.lf b}.
END FUNCTION.

PROCEDURE Get-DOC-IN:
DEFINE PARAMETER BUFFER op-in    FOR op       .
DEFINE PARAMETER BUFFER op-out   FOR op       .
DEFINE PARAMETER BUFFER open-out FOR op-entry .

DEFINE VARIABLE vOpOpB  AS CHAR NO-UNDO.

   vOpOpB = GetXAttrValueEx("op", string(op-in.op), "op-bal", "").
   IF vOpOpB NE "" THEN
   DO:  /*crd1crd2*/
      FIND FIRST op-out WHERE op-out.op EQ INT(vOpOpB)
                                         NO-LOCK NO-ERROR.
   END.
   ELSE DO:   /*crd2in*/
      FIND FIRST op-out WHERE op-out.op-transaction EQ op-in.op-transaction
                          AND op-out.acct-cat       EQ "b"
                                                            NO-LOCK NO-ERROR.
   END.
   IF NOT AVAIL op-out THEN
   DO:  /*crd1crd2*, но нет xattr("op-bal") найдем транзакцию карт1*/
      FIND FIRST op-out WHERE op-out.op EQ INT(entry(1, op-entry.kau-cr)) NO-LOCK NO-ERROR.
      IF avail op-out THEN
      DO:
         DEF VAR voptr LIKE op-out.op-transaction NO-UNDO.
         voptr = op-out.op-transaction.
         FIND FIRST op-out WHERE op-out.op-transaction EQ voptr
                             AND op-out.acct-cat       EQ "b"
                                                            NO-LOCK NO-ERROR.
      END.
   END.
   IF AVAIL op-out AND op-out.op-status GE "А" THEN
      FIND open-out OF op-out NO-LOCK NO-ERROR.

END PROCEDURE.

PROCEDURE Get-Xattr-Val:
   DEFINE PARAMETER BUFFER op-in FOR op.
   in-numdate = GetXAttrValueEx("op",string(op.op),"НомерДокПост",op-in.doc-num).
   in-numdate = in-numdate + "," + 
                GetXAttrValueEx("op",
                                STRING(op.op),"ДатаДокПост",
                                STRING(op.doc-date,"99.99.9999")).
   PlAcct = GetXAttrValueEx("op",string(op.op),"Acct-send","").

END PROCEDURE.

/**
 *
 * Функция возвращает картотеку куда
 * ставится документ. Если счет ДБ = 90902,
 * то картотека 2, если по счету ДБ = 90901, то 
 * картотека 1.
 * @param HANDLE hOp
 * @return CHAR
 **/
FUNCTION getTargetK RETURNS CHAR (INPUT hOp-Entry AS HANDLE):
  DEF VAR acct2 AS CHAR NO-UNDO.
  acct2    = SUBSTRING(hOp-Entry::acct-db,1,5).
  IF acct2 = "90902" THEN RETURN "k2". ELSE RETURN "k1".
END FUNCTION.