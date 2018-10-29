CLASS T1937 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}


  CONSTRUCTOR T1937():
    SUPER().
    oTable1 = NEW TTable2(5).
    oTable2 = NEW TTable2(7).
    currYear = YEAR(dBegDate).
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
           DEF VAR dDiff   AS DEC NO-UNDO.
           DEF VAR market  AS DEC NO-UNDO.
           DEF VAR fprice  AS DEC NO-UNDO.

           DEF VAR field4  AS DEC NO-UNDO.
           DEF VAR field5  AS DEC NO-UNDO.
           DEF VAR field6  AS DEC NO-UNDO.
           DEF VAR field7  AS DEC NO-UNDO.
           DEF VAR field8  AS DEC NO-UNDO.
           DEF VAR field9  AS DEC NO-UNDO.
           DEF VAR field10 AS DEC NO-UNDO.
           DEF VAR field11 AS DEC NO-UNDO.
           DEF VAR field12 AS DEC NO-UNDO.
           DEF VAR field13 AS DEC NO-UNDO.

           market  = marketPrice.
           fprice  = DEC(oAArray:get("fprice")).
           dDiff   = fprice - market.

           field4  = DEC(oAArray:get("amt-buy")).
           field5  = DEC(oAArray:get("amt-sell")).
           field6  = DEC(oAArray:get("fprice")).
           field7  = marketPrice.
           field8  = field7 - field6.
           field9  = DEC(oAArray:get("k-buy")).
           field10 = DEC(oAArray:get("k-sell")). 

           field11 = ROUND(field8 / 2 * field9  * field4,2).
           field12 = ROUND(field8 / 2 * field10 * field5,2).
           field13 = field11 + field12.

           IF field13 < 0 THEN field13 = 0.



           oTable1:addRow().
           oTable1:addCell(iCountIsDepended).
           oTable1:addCell(oAArray:get("op-date")).
           oTable1:addCell(oAArray:get("name-short")).
           oTable1:addCell(STRING(field4,"->>>,>>>,>>>,>>>,>>9.99")).
           oTable1:addCell(STRING(field5,"->>>,>>>,>>>,>>>,>>9.99")).
           oTable1:addCell(STRING(field6 * 100,">>9.99")).
           oTable1:addCell(STRING(field7 * 100,">>9.99")).
           oTable1:addCell(STRING(field8 * 100,"->>9.99")).
           oTable1:addCell(field9).
           oTable1:addCell(field10).
           oTable1:addCell(STRING(field11,"->>>,>>>,>>>,>>>,>>9.99")).
           oTable1:addCell(STRING(field12,"->>>,>>>,>>>,>>>,>>9.99")).
           oTable1:addCell(STRING(field13,"->>>,>>>,>>>,>>>,>>9.99")).

           upNalog = upNalog + field13.

  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         oTable2:addRow().
           oTable2:addCell(iCountIsNotDepended).
           oTable2:addCell(oAArray:get("op-date")).
           oTable2:addCell(oAArray:get("name-short")).
           oTable2:addCell(STRING(DEC(oAArray:get("amt-buy")),"->>>,>>>,>>>,>>>,>>9.99")).
           oTable2:addCell(STRING(DEC(oAArray:get("amt-sell")),"->>>,>>>,>>>,>>>,>>9.99")).
           oTable2:addCell(STRING(DEC(oAArray:get("fprice")) * 100,">>9.99")).
  END METHOD.

 METHOD PROTECTED OVERRIDE LOG onBeforeBuild():
    whereCond = " AND CAN-DO(" + QUOTER(condition) + ",DataLine.Sym2) ".

    oTable1:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5")
           :addCell("6")
           :addCell("7")
           :addCell("8=7-6")
           :addCell("9")
           :addCell("10")
           :addCell("11=8/2*9*4")
           :addCell("12=8/2*10*5")
           :addCell("13=11+12")
     .

    oTable2:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5")
           :addCell("6")
     .


    SUPER:onBeforeBuild().
 END METHOD.

 METHOD PROTECTED OVERRIDE LOG onAfterBuild():
      oTable1:addRow()
             :addCell("Итого:")
             :fillCells(11,"")
             :addCell(STRING(upNalog,">>>,>>>,>>>,>>9.99"))
      .
      SUPER:onAfterBuild().
 END METHOD.




 DESTRUCTOR PUBLIC T1937():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.