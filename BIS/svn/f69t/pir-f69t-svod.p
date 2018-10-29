/********************************************
 * Выгрузка класса f69t                     *
 *                                          *
 ********************************************
 * Автор        : Красков А.С.              *
 * Дата создания: 28.05.13                  *
 * Заявка       : #3101                     *
 ********************************************/

 DEF INPUT PARAM in-data-id LIKE DataBlock.Data-Id NO-UNDO.

 {globals.i}

  def var oTable as TTable2.

/* DEF BUFFER currDataBlock FOR DataBlock.*/

  oTable = new tTable2(3).
  oTable:colsWidthList="10,40,40".

	/* FIND FIRST currDataBlock WHERE currDataBlock.Data-Id EQ in-data-id NO-LOCK.*/
for each formula where formula.DataClass-Id = "f_69t" 
    NO-LOCK
    BY formula.order:
  
    FOR EACH DataLine WHERE Dataline.Data-id EQ in-data-id 
                        and dataline.Sym1 = formula.Var-Id
                        NO-LOCK:
        oTable:AddRow().
/*        oTable:addCell(formula.order). */
        oTable:AddCell(REPLACE(REPLACE(formula.Var-Id,"f_",""),"_",".")).
        oTable:AddCell(formula.var-name).
        oTable:AddCell(TRIM(STRING(DataLine.Val[1],"->>>,>>>,>>>,>>>,>>>,>>>,>>9.99"))).

    END.
end.

{setdest.i}
  oTable:show().
{preview.i}


DELETE OBJECT oTable.