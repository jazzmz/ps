CLASS T1935 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}


  CONSTRUCTOR T1935():
    SUPER().
    oTable1 = NEW TTable2(5).
    oTable2 = NEW TTable2(7).
    currYear = YEAR(dBegDate).
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
           DEF VAR dDiff   AS DEC NO-UNDO.
           DEF VAR market  AS DEC NO-UNDO.
           DEF VAR fprice  AS DEC NO-UNDO.
           DEF VAR field9  AS DEC NO-UNDO.
           DEF VAR field11 AS DEC NO-UNDO.

           market  = getMarketPrice() * 100.
           fprice  = ROUND(DEC(oAArray:get("cprice")),3) * 100.
           dDiff   = market - fprice.
           field11 = DECIMAL(oAArray:get("amt-rub")) * dDiff.

           IF field11 < 0 THEN field11 = 0.


           oTable1:addRow().
           oTable1:addCell(iCountIsDepended).
           oTable1:addCell(oAArray:get("op-date")).
           oTable1:addCell(oAArray:get("name-short")).
           oTable1:addCell(oAArray:get("amt-cur")).
           oTable1:addCell(oAArray:get("kurs-fact")).
           oTable1:addCell(oAArray:get("amt-rub")).
           oTable1:addCell(oAArray:get("middle")).
           oTable1:addCell(STRING(fprice,">>>,>>9.99")).
           oTable1:addCell(STRING(market,">>>,>>9.99")).
           oTable1:addCell(STRING(dDiff,"->>>,>>9.99")).
           oTable1:addCell(STRING(field11,">>>,>>>,>>>,>>9.99")).

           upNalog = upNalog + field11.

  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         oTable2:addRow().
           oTable2:addCell(iCountIsNotDepended).
           oTable2:addCell(oAArray:get("op-date")).
           oTable2:addCell(oAArray:get("name-short")).
           oTable2:addCell(oAArray:get("amt-cur")).
           oTable2:addCell(oAArray:get("kurs-fact")).
           oTable2:addCell(oAArray:get("amt-rub")).
           oTable2:addCell(oAArray:get("middle")).
           oTable2:addCell(STRING(ROUND(DEC(oAArray:get("cprice")),4) * 100,">9.99")).
  END METHOD.


 METHOD PROTECTED OVERRIDE LOG onAfterBuild():
      oTable1:addRow()
             :addCell("Итого:")
             :fillCells(9,"")
             :addCell(STRING(upNalog,">>>,>>>,>>>,>>9.99"))
      .
      SUPER:onAfterBuild().
 END METHOD.
 METHOD PROTECTED OVERRIDE LOG onBeforeBuild():
    whereCond = " AND CAN-DO(" + QUOTER(condition) + ",DataLine.Sym2) ".

    oTable1:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5")
           :addCell("6=4*5")
           :addCell("7")
           :addCell("8=100% * (5 - 7) / 7")
           :addCell("9")
           :addCell("10=9-8")
           :addCell("11=6*10")
     .

    oTable2:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5")
           :addCell("6=4*5")
           :addCell("7")
           :addCell("8=100% * (5 - 7) / 7")
     .

    SUPER:onBeforeBuild().
 END METHOD.


 DESTRUCTOR PUBLIC T1935():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.