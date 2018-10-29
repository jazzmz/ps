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
{pir_exf_exl.i}

DEFINE VARIABLE cXL     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE summ    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE summ1   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE acct-db AS CHARACTER  NO-UNDO.
DEFINE VARIABLE acct-cr AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dop     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE DR-type AS CHARACTER  NO-UNDO.

RUN g-prompt.p("CHARACTER", "Прим", "x(10)", "--",
               "Примечание", 20, ",", "", ?,?,OUTPUT dop).
   IF (dop = ?)
   THEN RETURN.

cXL = "oe" + REPLACE(dop, ".", "") + ".xls".
{exp-path.i &exp-filename = cXL}

/*******************************************  */
PUT UNFORMATTED XLHead(dop, "DCCCCCCNNCC", "74,50,30,50,150,150,50,110,110,50,50").

cXL = XLCell("Дата")
    + XLCell("N док")
    + XLCell("Kod")
    + XLCell("KodDR")
    + XLCell("ДЕБЕТ")
    + XLCell("КРЕДИТ")
    + XLCell("Валюта")
    + XLCell("Сумма в вал.")
    + XLCell("Сумма в руб.")
    + XLCell("Прим")
    + XLCell("Индекс")
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

/*******************************************  */

FOR EACH tmprecid
   NO-LOCK,
   FIRST op-entry
      WHERE (RECID(op-entry) EQ tmprecid.id)
      NO-LOCK,
   FIRST op OF op-entry
      NO-LOCK:

   ASSIGN
      acct-db = IF (op-entry.acct-db NE ?) THEN op-entry.acct-db ELSE ""
      acct-cr = IF (op-entry.acct-cr NE ?) THEN op-entry.acct-cr ELSE ""
      DR-type = GetXAttrValueEx("op", STRING(op.op), "ШифрПл", "")
   .

   IF (op-entry.acct-cat EQ "d")
   THEN 
      ASSIGN 
         summ  = op-entry.amt-rub
         summ1 = op-entry.amt-rub
      .
   ELSE DO:
      ASSIGN 
         summ  = op-entry.amt-cur
         summ1 = op-entry.amt-rub
      .
      IF (op-entry.currency EQ "")
      THEN
         ASSIGN 
            summ  = op-entry.amt-rub
            summ1 = op-entry.amt-rub
         .
   END.

   cXL = XLDateCell(op-entry.op-date)
       + XLCell(op.doc-num)
       + XLCell(op.doc-type)
       + XLCell(DR-type)
       + XLCell(acct-db)
       + XLCell(acct-cr)
       + XLCell(op-entry.currency)
       + XLNumECell(summ)
       + XLNumCell(summ1)
       + XLCell(dop)
       + XLCell(STRING(op-entry.op-date, "99.99.9999") + op.doc-num + op.doc-type
              + DR-type + acct-db + acct-cr + op-entry.currency
              + (IF (summ EQ 0) THEN "" ELSE STRING(summ)) + STRING(summ1))
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

END.

PUT UNFORMATTED XLEnd().
{intrface.del}
