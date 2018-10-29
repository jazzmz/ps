/**********************************
 * Отчет движение по ПОС за день.
 **********************************/

{globals.i}

DEF VAR currDate AS DATE INIT 02/01/2012 NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.

DEF BUFFER bTerm-obl1 FOR term-obl.
DEF BUFFER bTerm-oblDown FOR term-obl.


{getdate.i}
currDate = end-date.

{tpl.create}

oTable = new TTable(3).


 FOR EACH term-obl WHERE term-obl.contract EQ "Кредит" 
		 AND term-obl.idnt EQ 128 
		 AND term-obl.end-date = currDate 
		NO-LOCK,
   FIRST loan WHERE loan.cont-code EQ term-obl.cont-code NO-LOCK:


 FIND LAST bTerm-oblDown WHERE bterm-oblDown.contract EQ "Кредит" 
		 AND bterm-oblDown.cont-code EQ loan.cont-code 
		 AND bterm-oblDown.idnt EQ 128 
		 AND bterm-oblDown.end-date < currDate 
		NO-LOCK NO-ERROR.
/*
 FIND LAST bTerm-obl1 WHERE bterm-obl1.contract EQ "Кредит" 
		 AND bterm-obl1.cont-code EQ loan.cont-code 
		 AND bterm-obl1.idnt EQ 128 
		 AND bterm-obl1.end-date > currDate 
		NO-LOCK NO-ERROR.
*/
  oTable:addRow().
  oTable:addCell(loan.cont-code).
  oTable:addCell((IF AVAILABLE(bterm-oblDown) THEN bterm-oblDown.lnk-cont-code ELSE "X")).
  oTable:addCell(term-obl.lnk-cont-code).
  /*oTable:addCell((IF AVAILABLE(bterm-obl1) THEN bterm-obl1.lnk-cont-code ELSE "X")).*/
END.

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("currDate",currDate).
{tpl.show}
DELETE OBJECT oTable.

{tpl.delete}

