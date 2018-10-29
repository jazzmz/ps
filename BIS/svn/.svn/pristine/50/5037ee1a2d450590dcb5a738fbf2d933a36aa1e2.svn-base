/*******************************
 * Проверочная ведомость по группам.
 * Выводит информацию в виде:
 *   1. Код операции;
 *   2. Номер операции;
 *   3. Цена операции.
 *
 * Отчет необходим для проверки корректности
 * расчета рыночной стоимости.
 *******************************/
DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.

DEF BUFFER currDataBlock   FOR DataBlock.
DEF BUFFER pDataBlock FOR DataBlock.
DEF BUFFER pDataLine  FOR DataLine.

DEF VAR dBegDate AS DATE NO-UNDO.
DEF VAR dEndDate AS DATE NO-UNDO.


DEF VAR oTable   AS TTable2 NO-UNDO.



FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK.
  ASSIGN
     dBegDate = currDataBlock.Beg-Date
     dEndDate = currDataBlock.End-Date
    .
{setdest.i}
 
 FOR EACH pDataBlock WHERE pDataBlock.DataClass-id EQ 'f227_1' 
                       AND pDataBlock.Beg-Date     EQ dBegDate
                       AND pDataBlock.End-Date     EQ dEndDate,
                       EACH PDataLine WHERE PDataLine.data-id EQ pDataBlock.data-id
                                        AND NOT LOGICAL(PDataLine.Sym3) 
                                        BREAK BY pDataLine.Sym2 BY pDataLine.val[3]:  
      IF FIRST-OF(pDataLine.Sym2) THEN DO:
	oTable = new TTable2(3).
	oTable:colsHeaderList="Код операции,Номер,Стоимость".
      END.
	       oTable:addRow().
	       oTable:addCell(pDataLine.Sym2).
	       oTable:addCell(pDataLine.val[3]).
	       oTable:addCell(pDataLine.val[9]).

      IF LAST-OF(pDataLine.Sym2) THEN DO:
        oTable:show().
        DELETE OBJECT oTable.
      END.
 END.


{preview.i}

