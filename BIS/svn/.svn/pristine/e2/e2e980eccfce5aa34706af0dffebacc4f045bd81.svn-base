/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 2009 У2-3 КБ "Пpоминвестрасчет"
     Filename: PIR_OPENPRT.P
      Comment: Выгрузка отфильтрованных проводок в XL (из стандартной процедуры печати)
      Created: 07/10/09 Борисов А.В.
     Modified: 
*/
{globals.i}
{tmprecid.def}
{pir_exf_exl.i}

DEFINE VARIABLE summ    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE summ1   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE acct-db AS CHARACTER  NO-UNDO.
DEFINE VARIABLE acct-cr AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cXL     AS CHARACTER  NO-UNDO.

{get-fmt.i &obj='" + 'b' + ""-Acct-Fmt"" + "'}
{exp-path.i &exp-filename = "'oe.xls'"}


/*******************************************  */
PUT UNFORMATTED XLHead("oe", "CDCCCCCNNC", "47,71,75,25,166,166,52,110,110,200").

cXL = XLCell("Статус")
    + XLCell("Дата")
    + XLCell("Номер док.")
    + XLCell("ЗО")
    + XLCell("Дебет")
    + XLCell("Кредит")
    + XLCell("Валюта")
    + XLCell("Сумма в вал.")
    + XLCell("Сумма в руб.")
    + XLCell("Содержание операции")
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
      acct-db = IF op-entry.acct-db NE ?
                THEN {out-fmt.i op-entry.acct-db fmt}
                ELSE ""
      acct-cr = IF op-entry.acct-cr NE ?
                THEN {out-fmt.i op-entry.acct-cr fmt}
                ELSE ""
   .

   IF op-entry.acct-cat EQ "d" THEN 
      ASSIGN 
         summ  = 0 /* op-entry.amt-rub */
         summ1 = op-entry.amt-rub
      .
   ELSE DO:
      ASSIGN 
         summ  = op-entry.amt-cur
         summ1 = op-entry.amt-rub
      .
      IF op-entry.currency EQ "" THEN
         ASSIGN 
            summ  = 0 /* op-entry.amt-rub */
            summ1 = op-entry.amt-rub
         .
   END.

   cXL = XLCell(op-entry.op-status)
       + XLDateCell(op-entry.op-date)
       + XLCell(op.doc-num)
       + XLCell(IF op-entry.prev-year THEN "ЗО" ELSE "")
       + XLCell(acct-db)
       + XLCell(acct-cr)
       + XLCell(op-entry.currency)
       + XLNumECell(summ)
       + XLNumCell(summ1)
       + XLCell(op.details)
       .
   PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

END.

PUT UNFORMATTED XLEnd().
{intrface.del}
