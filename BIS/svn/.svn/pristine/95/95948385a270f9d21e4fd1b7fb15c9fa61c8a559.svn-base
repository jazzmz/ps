/*****************************************
 *                                       *
 *  Обработка для определения            *
 * несписанных документов                *
 * по аналитическому учету.              *
 * Алгоритм:                             *
 * 1. Идем по всем привязанным           *
 * приходным документам счета 47416*;    *
 * 2. Находим все привязанные            *
 * соответствующие документы списания;   *
 *   2.1 Находим их сумм;                *
 * 3. Сравниваем сумму постановки +      *
 * полученную сумму списания;            *
 * 4. Если суммы не равны, то выводим    *
 * в отчет.                              *
 *  !!! ПРЕДПОЛАГАЕТСЯ, ЧТО ИСПРАВЛЕНИЯ  *
 *  !!! БУДУТ ПРОВОДИТСЯ СТАНДАРТНЫМ     *
 *  !!! ИНСТРУМЕНТОВ РАБОТЫ С КАРТОТЕКОЙ *
 ****************************************** 
 * Заявка: #432 . Этап №1 .
 * Дата создания: 28.09.10 17:13
 * Автор: Маслов Д. А.
 ***********************************/
 
DEF BUFFER bOpEntryIn FOR op-entry.
DEF BUFFER bOpEntryOut FOR op-entry.

DEF VAR oTable AS TTable NO-UNDO.

oTable = new TTable(5).
oTable:addRow().
oTable:addCell("Номер").
oTable:addCell("Дата").
oTable:addCell("ID документа").
oTable:addCell("Сумма постановки").
oTable:addCell("Сумма списания").

DEF VAR dSumm AS DECIMAL INITIAL 0 NO-UNDO.

FOR EACH bOpEntryIn WHERE bOpEntryIn.acct-cr EQ "47416810600000000001" AND bOpEntryIn.kau-cr <> "" NO-LOCK,
 FIRST op OF bOpEntryIn:
    /* ПО ВСЕМ ПОСТАНОВКАМ */

 FOR EACH bOpEntryOut WHERE bOpEntryOut.acct-db EQ "47416810600000000001" AND (bOpEntryOut.kau-db EQ STRING(bOpEntryIn.op) + "," OR bOpEntryOut.kau-db EQ STRING(bOpEntryIn.op) + ",1") NO-LOCK:
       dSumm = dSumm + bOpEntryOut.amt-rub.
   END.
   IF bOpEntryIn.amt-rub <> dSumm THEN 
      DO:
        ACCUMULATE bOpEntryIn.op (COUNT).
        oTable:addRow().
            oTable:addCell(op.doc-num).
            oTable:addCell(bOpEntryIn.op-date).
            oTable:addCell(bOpEntryIn.op).
            oTable:addCell(bOpEntryIn.amt-rub).
            oTable:addCell(dSumm).
      END.
   dSumm = 0.
END.
{setdest.i}
oTable:show().
PUT UNFORMATTED "Итого документов:".
PUT UNFORMATTED ACCUM COUNT bOpEntryIn.op SKIP.
{preview.i}
DELETE OBJECT oTable.