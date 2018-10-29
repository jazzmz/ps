CLASS T1936 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}


  CONSTRUCTOR T1936():
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

           market  = getMarketPrice().
           fprice  = DECIMAL(oAArray:get("fprice")) * 0.001.
           dDiff   = fprice - market.



           oTable1:addRow().
           oTable1:addCell(iCountIsDepended).
           oTable1:addCell(oAArray:get("op-date")).
           oTable1:addCell(oAArray:get("name-short")).
           oTable1:addCell(oAArray:get("amt-cur")).
           oTable1:addCell(oAArray:get("kurs-fact")).
           oTable1:addCell(oAArray:get("amt-rub")).
           oTable1:addCell(oAArray:get("middle")).
           oTable1:addCell(fprice).
           oTable1:addCell(market).
           oTable1:addCell(dDiff).
           oTable1:addCell(upNalog).

           upNalog = upNalog + dDiff.

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
           oTable2:addCell(oAArray:get("fprice")).
  END METHOD.


 METHOD PROTECTED OVERRIDE LOG onBeforeBuild():
    whereCond = " AND CAN-DO(" + QUOTER(condition) + ",DataLine.Sym2) ".
    SUPER:onBeforeBuild().
 END METHOD.


 DESTRUCTOR PUBLIC T1936():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.