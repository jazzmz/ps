CLASS T1294 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}
 {set-prop.i &aa="itogNach1%"  &cc="DEC" &init="0"}
 {set-prop.i &aa="itogNach2%"  &cc="DEC" &init="0"}


  CONSTRUCTOR T1294():
    SUPER().
    oTable1  = NEW TTable2().
    oTable2  = NEW TTable2().
    currYear = YEAR(dBegDate).
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
           DEF VAR dDiff   AS DEC NO-UNDO.
           DEF VAR percent AS DEC NO-UNDO.
           DEF VAR fprice  AS DEC NO-UNDO.
           DEF VAR field9  AS DEC NO-UNDO.

           fprice  = DECIMAL(oAArray:get("fprice")).
           dDiff   = getMarketPrice() - fprice.
           percent = DECIMAL(oAArray:get("percent")).

           field9  = ROUND(percent / fprice * dDiff,2).

           oTable1:addRow()
                  :addCell(iCountIsDepended)
                  :addCell(oAArray:get("name-short"))
                  :addCell(STRING(DEC(oAArray:get("loan-pos")),">>>,>>>,>>>,>>9.99"))
                  :addCell(oAArray:get("cont-code") + " " + oAArray:get("open-date"))
                  :addCell(STRING(fprice,">>>,>>>,>>>,>>9.99"))
                  :addCell(STRING(percent,">>>,>>>,>>>,>>9.99"))
                  :addCell(STRING(getMarketPrice(),">9.99"))
                  :addCell(STRING(dDiff,"->>>,>>>,>>>,>>9.99"))
                  :addCell(STRING(field9,"->>>,>>>,>>>,>>9.99"))
           .

           upNalog = upNalog + (IF field9 > 0 THEN field9 ELSE 0).
           itogNach1% = itogNach1% + percent.

  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         DEF VAR percent AS DEC NO-UNDO.
         percent = DEC(oAArray:get("percent")).

         oTable2:addRow() 
                :addCell(iCountIsNotDepended) 
                :addCell(oAArray:get("name-short")) 
                :addCell(STRING(DEC(oAArray:get("loan-pos")),">>>,>>>,>>>,>>9.99")) 
                :addCell(oAArray:get("cont-code") + " " + oAArray:get("open-date")) 
                :addCell(STRING(DEC(oAArray:get("fprice")),">>>,>>9.99")) 
                :addCell(STRING(percent,">>>,>>>,>>>,>>9.99"))
         .

         itogNach2% = itogNach2% + percent.
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
           :addCell("8=7-5")
           :addCell("9=6/5*8").

    oTable2:addRow()
           :addCell(1)
           :addCell(2)
           :addCell(3)
           :addCell(4)
           :addCell(5)
           :addCell(6).

 END METHOD.

 METHOD PROTECTED OVERRIDE LOG onAfterBuild():
      oTable1:addRow()
             :addCell("Итого:")
             :fillCells(4,"")
             :addCell(STRING(itogNach1%,"->>>,>>>,>>>,>>9.99"))
             :fillCells(2,"")
             :addCell(STRING(upNalog,"->>>,>>>,>>>,>>9.99")).

      oTable2:addRow()
             :addCell("Итого:")
             :fillCells(4,"")
             :addCell(STRING(itogNach2%,"->>>,>>>,>>>,>>9.99")).
      SUPER:onAfterBuild().
 END METHOD.


 DESTRUCTOR PUBLIC T1294():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.