/*по заявке #1021 Отчет по классификатору Podftentr cо списком льготного контроля ПОДФТ */

def buffer dl1 for dataline.
def buffer dl2 for dataline.
def buffer dl3 for dataline.
def var oTable as TTable NO-UNDO.
def var count as int init 0 no-undo.
oTable = new TTable(3).
oTable:colsWidthList="4,50,50".
oTable:addRow().
oTable:addCell(" ").
oTable:addCell("Дебет счета").
oTable:addCell("Кредит счета").

FOR each dl1 WHERE dl1.data-id EQ 483749 AND dl1.sym1  EQ '' NO-LOCK,      
    each dl2 WHERE dl2.data-id EQ 483749 AND dl2.sym1  EQ dl1.Sym3 NO-LOCK, 
    each dl3 WHERE dl3.data-id EQ 483749 AND dl3.sym1  EQ dl2.Sym3 NO-LOCK.

/*display dl1.sym2 dl2.sym2.  */
count = count + 1.
oTable:addRow().
oTable:addCell(count).
oTable:addCell(trim(dl1.sym2)).
oTable:addCell(trim(dl2.sym2)).

end.    

{setdest.i}

PUT UNFORMATTED "                        Список счетов льготного контроля на " TODAY Skip.
                                                                           
oTable:show().



{preview.i}

DELETE OBJECT oTable.