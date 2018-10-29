CLASS T1932 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}
 {set-prop.i &aa="currType"    &cc="INT"}
 {set-prop.i &aa="itog2"       &cc="DEC"}
 {set-prop.i &aa="nach%1"      &cc="DEC" &init="0"}


  CONSTRUCTOR T1932():
    SUPER().
    oTable1 = NEW TTable2(5).
    oTable2 = NEW TTable2(7).
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):

           DEF VAR field4  AS DEC NO-UNDO.
           DEF VAR field5  AS DEC NO-UNDO.
           DEF VAR field6  AS DEC NO-UNDO.
           DEF VAR field7  AS DEC NO-UNDO.
           DEF VAR field8  AS DEC NO-UNDO.
           DEF VAR field9  AS DEC NO-UNDO.
           DEF VAR field10 AS DEC NO-UNDO.

                                               
           field4  = DEC(oAArray:get("fprice")).
           field5  = DEC(oAArray:get("nach%")).
           field6  = DEC(oAArray:get("ref%")).
           field7  = DEC(oAArray:get("max%")).

           /**
            * Для взаимозависимых у которых уже есть рынок
            * берем его. Иначе берем рынок текущего периода.
            **/
          

           field8  = (IF DEC(oAArray:get("PirMarketPrice")) > 0 AND oAArray:get("PirMarketPrice") <> ? THEN DEC(oAArray:get("PirMarketPrice")) ELSE marketPrice).          


           field9  = (IF field4 < field7 THEN field4 - field8 ELSE field7 - field8).
           field10 = ROUND(field5 / field4 * field9,2).

           oTable1:addRow() 
                  :addCell(iCountIsDepended) 
                  :addCell(oAArray:get("name-short")) 
                  :addCell(oAArray:get("cont-code") + " " + oAArray:get("open-date"))
                  :addCell(STRING(DEC(oAArray:get("loan-pos")),">>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(field4,">>>,>>>,>>9.99")) 
                  :addCell(STRING(field5,">>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(field6,">>9.99")) 
                  :addCell(STRING(field7,">>9.99")) 
                  :addCell(STRING(field8,">>9.99")) 
                  :addCell(STRING(field9,"->>9.99")) 
                  :addCell(STRING(field10,"->>>,>>>,>>>,>>9.99"))
           .
           upNalog = upNalog + (IF field10 > 0 THEN field10 ELSE 0).
           nach%1  = nach%1  + field5.
  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         DEF VAR n% AS DEC NO-UNDO.
         n% = DEC(oAArray:get("nach%")).

         oTable2:addRow() 
                :addCell(iCountIsNotDepended) 
                :addCell(oAArray:get("name-short")) 
                :addCell(oAArray:get("cont-code") + " " + oAArray:get("open-date")) 
                :addCell(STRING(DEC(oAArray:get("loan-pos")),">>>,>>>,>>>,>>9.99")) 
                :addCell(STRING(DEC(oAArray:get("fprice")),">>>,>>>,>>>,>>9.99")) 
                :addCell(STRING(n%,">>>,>>>,>>>,>>9.99"))
         .

      itog2 = itog2 + n%.

  END METHOD.


 METHOD PROTECTED OVERRIDE LOG onBeforeBuild():
    whereCond = " AND CAN-DO(" + QUOTER(condition) + ",DataLine.Sym2) ".

    oTable1:addRow()
           :addCell(1)
           :addCell(2)
           :addCell(3)
           :addCell(4)
           :addCell(5)
           :addCell(6)
           :addCell(7)
           :addCell(8)
           :addCell("9")
           :addCell("10=8-9")
           :addCell("11=6/5*10")
     .

    oTable2:addRow()
           :addCell(1)
           :addCell(2)
           :addCell(3)
           :addCell(4)
           :addCell(5)
           :addCell(6)
     .

    SUPER:onBeforeBuild().
 END METHOD.

 METHOD PROTECTED OVERRIDE LOG onAfterBuild():

    oTable1:addRow()
           :addCell("ИТОГО:")
           :fillCells(4,"")
           :addCell(STRING(nach%1,">>>,>>>,>>>,>>9.99"))
           :fillCells(4,"")
           :addCell(STRING(upNalog,">>>,>>>,>>>,>>9.99"))
     .

    oTable2:addRow()
           :addCell("Итого")
           :fillCells(4,"")
           :addCell(STRING(itog2,">>>,>>>,>>>,>>9.99"))
     .

      SUPER:onAfterBuild().
 END METHOD.

 METHOD PROTECTED OVERRIDE DECIMAL getMarketPrice():
         DEF BUFFER pDataBlock FOR DataBlock.
         DEF BUFFER pDataLine  FOR DataLine.

         FOR EACH pDataBlock WHERE pDataBlock.DataClass-id EQ 'f227_2' 
                               AND pDataBlock.Beg-Date EQ dBegDate AND pDataBlock.End-Date EQ dEndDate NO-LOCK,
            FIRST pDataLine WHERE pDataLine.data-id EQ pDataBlock.data-id AND CAN-DO(condition,pDataLine.Sym2) NO-LOCK:
             RETURN pDataLine.Val[2].
         END.
 END METHOD.


 DESTRUCTOR PUBLIC T1932():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.
