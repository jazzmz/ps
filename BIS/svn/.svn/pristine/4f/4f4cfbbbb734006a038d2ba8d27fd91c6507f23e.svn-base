/****************************************************
 * Отчет отклонение курсов валют,                   *
 * установленные Банком, от курсов валют ЦБ РФ,     *
 * установленные на ту же дату.                     *
 ****************************************************
 *                                                  *
 * Автор: Маслов Д. А. Maslov D. A.                 *
 * Дата : 23.03.13                                  *
 * Заявка: #2606                                    *
 *                                                  *
 *****************************************************/

 DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.

 {globals.i}

 DEF VAR dBegDate AS DATE    NO-UNDO.
 DEF VAR dEndDate AS DATE    NO-UNDO.

 DEF VAR oTable   AS TTable2 NO-UNDO.

 DEF VAR oCurr1   AS TAArray NO-UNDO.
 DEF VAR oCurr2   AS TAArray NO-UNDO.
 DEF VAR oCurr3   AS TAArray NO-UNDO.

 DEF VAR iDate    AS DATE    NO-UNDO.
 DEF VAR j        AS INT     NO-UNDO.


 DEF VAR currencyList AS CHAR INIT "840,978,826" NO-UNDO.
 DEF VAR currCurrency AS CHAR                    NO-UNDO.
 DEF VAR currCursPK   AS CHAR                    NO-UNDO.

 DEF VAR d6 AS DEC NO-UNDO.
 DEF VAR d7 AS DEC NO-UNDO.

 DEF VAR oSysClass    AS TSysClass               NO-UNDO.

 DEF BUFFER currDataBlock FOR DataBlock.


 FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK.
  ASSIGN
     dBegDate = currDataBlock.Beg-Date
     dEndDate = currDataBlock.End-Date
 .



 oCurr1 = NEW TAArray().
 oCurr2 = NEW TAArray().
 oCurr3 = NEW TAArray().
 
 oTable = NEW TTable2().

 oTable:addRow()
       :addCell("1")
       :addCell("2")
       :addCell("3")
       :addCell("4")
       :addCell("5")
       :addCell("6=100*(3-4)/3")
       :addCell("7=100*(3-5)/3")
  .


 oSysClass = NEW TSysClass().
 
 {tpl.create}

 /************************************
  * Часть №1. Получаем значения      *
  * курсов в удобном для нас виде.   *
  ************************************/
 FOR EACH instr-rate WHERE instr-rate.instr-cat EQ 'currency'
                       AND instr-rate.rate-instr >=0 
                       AND instr-rate.rate-type EQ "Учетный"
                       AND CAN-DO(currencyList,instr-rate.instr-code)
                       AND instr-rate.since >= dBegDate AND instr-rate.since <= dEndDate NO-LOCK:
       oCurr1:setH(instr-rate.instr-code + STRING(instr-rate.since),instr-rate.rate-instr).
 END.


 FOR EACH instr-rate WHERE instr-rate.instr-cat EQ 'currency'
                       AND instr-rate.rate-instr >=0 
                       AND instr-rate.rate-type EQ "НалПок"
                       AND CAN-DO(currencyList,instr-rate.instr-code)
                       AND instr-rate.since >= dBegDate AND instr-rate.since <= dEndDate NO-LOCK:
       oCurr2:setH(instr-rate.instr-code + STRING(instr-rate.since),instr-rate.rate-instr).
 END.

 FOR EACH instr-rate WHERE instr-rate.instr-cat EQ 'currency'
                       AND instr-rate.rate-instr >=0 
                       AND instr-rate.rate-type EQ "НалПр"
                       AND CAN-DO(currencyList,instr-rate.instr-code)
                       AND instr-rate.since >= dBegDate AND instr-rate.since <= dEndDate NO-LOCK:
       oCurr3:setH(instr-rate.instr-code + STRING(instr-rate.since),instr-rate.rate-instr).
 END.

 /*************************************
  * Часть №2. Вывод таблицы согласно ТЗ.
  *************************************/

  DO iDate = dBegDate TO dEndDate:

      IF oSysClass:isHoliday(iDate) THEN NEXT.

      DO j = 1 TO NUM-ENTRIES(currencyList):
         currCurrency = ENTRY(j,currencyList).
         currCursPK = currCurrency + STRING(iDate).

         d6 = ROUND(100 * (DEC(oCurr1:get(currCursPK)) - DEC(oCurr2:get(currCursPK))) / DEC(oCurr1:get(currCursPK)),2).
         d7 = ROUND(100 * (DEC(oCurr1:get(currCursPK)) - DEC(oCurr3:get(currCursPK))) / DEC(oCurr1:get(currCursPK)),2).

         oTable:addRow()
               :addCell(iDate)
               :addCell(currCurrency)
               :addCell(oCurr1:get(currCursPK))
               :addCell(oCurr2:get(currCursPK))
	       :addCell(oCurr3:get(currCursPK))
               :addCell(STRING(d6,"->>>,>>>,>>>,>>9.99"))
               :addCell(STRING(d7,"->>>,>>>,>>>,>>9.99"))
         .
      END.
  END.

 oTpl:addAnchorValue("TABLE",oTable).
 oTpl:addAnchorValue("YEAR",{term2str dBegDate dEndDate}).

 {tpl.show}

 DELETE OBJECT oCurr1.
 DELETE OBJECT oCurr2.
 DELETE OBJECT oCurr3.
 DELETE OBJECT oTable.
 DELETE OBJECT oSysClass.
 {tpl.delete}
