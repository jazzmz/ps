CLASS T1934 INHERITS TF227Rep:
 {set-prop.i &aa="oTable1"  &cc="TTable2"}
 {set-prop.i &aa="oTable2"  &cc="TTable2"}

 {set-prop.i &aa="itog1"    &cc="DEC"}
 {set-prop.i &aa="itog2"    &cc="DEC"}



  CONSTRUCTOR T1934():
    SUPER().
    oTable1 = NEW TTable2(5).
    oTable2 = NEW TTable2(7).
    currYear = YEAR(dBegDate).
  END METHOD.

  METHOD PROTECTED OVERRIDE VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
           DEF VAR dDiff   AS DEC NO-UNDO.
           DEF VAR dCom    AS DEC NO-UNDO.

           DEF VAR field5  AS DEC NO-UNDO.
           DEF VAR field7  AS DEC NO-UNDO.
           DEF VAR field8  AS DEC NO-UNDO.
           DEF VAR field9  AS DEC NO-UNDO.

           DEF VAR toNu    AS DEC NO-UNDO.

           field5  = DEC(oAArray:get("amt-rub")).
           field7  = DEC(oAArray:get("cprice")).
           field8  = getMarketPrice().
           field9  = field8 - field7.


           dCom = DEC(oAArray:get("dCom")).
           toNu = field5 * field9.

           oTable1:addRow()
                  :addCell(iCountIsDepended) 
                  :addCell(oAArray:get("acct")) 
                  :addCell(oAArray:get("name-short")) 
                  :addCell(oAArray:get("op-date")) 
                  :addCell(STRING(field5,">>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(dCom,">>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(field7,">>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(field8,"->>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(field9,"->>>,>>>,>>>,>>9.99")) 
                  :addCell(STRING(toNu,"->>>,>>>,>>>,>>9.99"))
           .

           itog1   = itog1 + dCom.
           upNalog = upNalog + dDiff.

  END METHOD.


  METHOD PROTECTED OVERRIDE VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):
         DEF VAR dCom AS DEC NO-UNDO.

         dCom = DEC(oAArray:get("dCom")).

         oTable2:addRow() 
                :addCell(iCountIsNotDepended) 
                :addCell(oAArray:get("acct")) 
                :addCell(oAArray:get("name-short")) 
                :addCell(oAArray:get("op-date")) 
                :addCell(STRING(DEC(oAArray:get("amt-rub")),">>>,>>>,>>>,>>9.99")) 
                :addCell(STRING(dCom,">>>,>>>,>>>,>>9.99")) 
                :addCell(STRING(DEC(oAArray:get("fprice")),">>9.99"))
         .
         
      itog2 = itog2 + dCom.   

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
           :addCell("8")
           :addCell("9=8-7")
           :addCell("10=5*9")
     .

    oTable2:addRow()
           :addCell("1")
           :addCell("2")
           :addCell("3")
           :addCell("4")
           :addCell("5")
           :addCell("6")
           :addCell("7=6*100/5")
     .

    SUPER:onBeforeBuild().
 END METHOD.


 METHOD PROTECTED OVERRIDE LOG onAfterBuild():
    oTable1:addRow()
           :addCell("Итого:")
           :fillCells(4," ")
           :addCell(STRING(itog1,"->>>,>>>,>>>,>>9.99"))
           :fillCells(3," ")
           :addCell(STRING(upNalog,"->>>,>>>,>>>,>>9.99"))
    .

    oTable2:addRow()
           :addCell("Итого:")
           :fillCells(4," ")
           :addCell(STRING(itog2,"->>>,>>>,>>>,>>9.99"))
           :addCell("")
    .

      SUPER:onAfterBuild().
 END METHOD.

 DESTRUCTOR PUBLIC T1934():
   DELETE OBJECT oTable1 NO-ERROR.
   DELETE OBJECT oTable2 NO-ERROR.
 END DESTRUCTOR.
END CLASS.
