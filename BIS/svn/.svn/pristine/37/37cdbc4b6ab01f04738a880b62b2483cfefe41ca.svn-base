CLASS T1938 INHERITS TF227Rep:

 {set-prop.i &aa="oTable1"     &cc="TTable2"}
 {set-prop.i &aa="oTable2"     &cc="TTable2"}


  CONSTRUCTOR T1938():
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

           market  = getMarketPrice().
           fprice  = DECIMAL(oAArray:get("fprice")) * 0.001.
           dDiff   = fprice - market.

           field4  = DEC(oAArray:get("amt-buy")).
           field5  = DEC(oAArray:get("amt-sell")).
           field6  = DEC(oAArray:get("fprice")).
           field7  = DEC(oAArray:get("cprice")).
           field8  = field7 - field6.
           field9  = DEC(oAArray:get("k-buy")).
           field10 = DEC(oAArray:get("k-sell")). 

           field11 = ROUND(field8 / 2 * field9 * field4,2).
           field12 = ROUND(field8 / 2 * field10 * field5,2).
           field13 = field11 + field12.



           oTable1:addRow().
           oTable1:addCell(iCountIsDepended).
           oTable1:addCell(oAArray:get("op-date")).
           oTable1:addCell(oAArray:get("name-short")).
           oTable1:addCell(field4).
           oTable1:addCell(field5).
           oTable1:addCell(field6).
           oTable1:addCell(field7).
           oTable1:addCell(field8).
           oTable1:addCell(field9).
           oTable1:addCell(field10).
           oTable1:addCell(field11).
           oTable1:addCell(field12).
           oTable1:addCell(field13).

           upNalog = upNalog + field13.

  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         oTable2:addRow().
           oTable2:addCell(iCountIsNotDepended).
           oTable2:addCell(oAArray:get("op-date")).
           oTable2:addCell(oAArray:get("name-short")).
           oTable2:addCell(oAArray:get("amt-buy")).
           oTable2:addCell(oAArray:get("amt-sell")).
           oTable2:addCell(oAArray:get("fprice")).
  END METHOD.

 METHOD PROTECTED OVERRIDE LOG onBeforeBuild():
    whereCond = " AND CAN-DO(" + QUOTER(condition) + ",DataLine.Sym2) ".
    SUPER:onBeforeBuild().
 END METHOD.


 DESTRUCTOR PUBLIC T1938():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.