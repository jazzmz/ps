CLASS T1933 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}
 {set-prop.i &aa="itog1"       &cc="DEC"}
 {set-prop.i &aa="itog2"       &cc="DEC"}


  CONSTRUCTOR T1933():
    SUPER().
    oTable1 = NEW TTable2(5).
    oTable2 = NEW TTable2(7).
    currYear = YEAR(dBegDate).
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
           DEF VAR dDiff   AS DEC NO-UNDO.
           DEF VAR percent AS DEC NO-UNDO.
           DEF VAR fprice  AS DEC NO-UNDO.
           DEF VAR field9  AS DEC NO-UNDO.

           fprice  = ROUND(DEC(oAArray:get("fprice")),2).
           dDiff   = marketPrice - fprice.
           percent = DECIMAL(oAArray:get("percent")).

           field9  = percent / fprice * dDiff.

           oTable1:addRow().
           oTable1:addCell(iCountIsDepended).
           oTable1:addCell(oAArray:get("acct")).
           oTable1:addCell(oAArray:get("name-short")).
           oTable1:addCell(oAArray:get("op-date")).
           oTable1:addCell(oAArray:get("count")).
           oTable1:addCell(STRING(fprice,">>>,>>>,>>>,>>9.99")).
           oTable1:addCell(STRING(marketPrice,"->>>,>>>,>>>,>>9.99")).
           oTable1:addCell(STRING(dDiff,"->>>,>>>,>>>,>>9.99")).

           upNalog = upNalog + (IF dDiff > 0 THEN dDiff ELSE 0).
           itog1   = itog1 + fprice.
  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         DEF VAR com AS DEC NO-UNDO.
         com = ROUND(DEC(oAArray:get("fprice")),2).

         oTable2:addRow() 
                :addCell(iCountIsNotDepended) 
                :addCell(oAArray:get("acct")) 
                :addCell(oAArray:get("name-short")) 
                :addCell(oAArray:get("op-date")) 
                :addCell(oAArray:get("count")) 
                :addCell(STRING(com,">>>,>>>,>>>,>>9.99"))
          .
        itog2 = itog2 + com.
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
           :addCell("8=7-6")
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
           :addCell("Итого:")
           :fillCells(4,"")
           :addCell(STRING(itog1,">>>,>>>,>>>,>>9.99"))
           :addCell("")
           :addCell(STRING(upNalog,">>>,>>>,>>>,>>9.99"))
    .

    oTable2:addRow()
           :addCell("Итого:")
           :fillCells(4,"")
           :addCell(STRING(itog2,">>>,>>>,>>>,>>9.99"))
    .

      SUPER:onAfterBuild().

 END METHOD.


 DESTRUCTOR PUBLIC T1933():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.