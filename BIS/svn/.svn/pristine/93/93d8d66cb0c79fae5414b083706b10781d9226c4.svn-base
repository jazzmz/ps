/********
 * Инклюд создает и выводит
 * таблицу 2x2
 ********/

	oTable = new TTable(3).

	oTable:colsWidthList = "{&w1},{&w2},{&w3}".

	oTable:addRow().
	oTable:addCell({&c11}).
        oTable:addCell({&c12}).
	oTable:addCell({&c13}).


	oTable:addRow().
	oTable:addCell({&c21}).
        oTable:addCell({&c23}).


	oTable:setAlign(1,1,"left").
	oTable:setAlign(1,2,"left").
	oTable:setColspan(1,2,2).


	oTable:show().

	DELETE OBJECT oTable.
