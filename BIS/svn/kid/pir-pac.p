/*********************************
 * Отображает договора у которых
 * нет действующих траншей.
 * Выполнено в результате
 * перехода на использование ПОС
 *********************************
 *
 * Заявка:
 * Автор: Маслов Д. А. Maslov D. A.
 * Дата создания:
 *
 *********************************/
{globals.i}
{tmprecid.def}

DEF VAR oTable   AS TTable    NO-UNDO.
DEF VAR mainLoan AS CHARACTER NO-UNDO.
DEF VAR c	 AS INTEGER INITIAL 0.
DEF VAR res      AS CHARACTER INITIAL "" NO-UNDO.
DEF BUFFER bloan FOR loan.

oTable = new TTable(1).
FOR EACH tmprecid,
 FIRST bloan WHERE RECID(bloan)=tmprecid.id:
  mainLoan = bloan.cont-code.
  
 FIND FIRST loan WHERE loan.contract="Кредит" 
			    AND loan.class-code="loan_trans_diff" 
			    AND ENTRY(1,loan.cont-code," ") = mainLoan 
			    AND loan.close-date=? NO-LOCK NO-ERROR.
 IF NOT AVAILABLE(loan)
 THEN DO:   
     oTable:addRow().
     oTable:addCell(mainLoan).
     res = res + mainLoan + ",".
     c = c + 1.
 END.
END.

     oTable:addRow().
     oTable:addCell("Итого:" + STRING(c)).

{setdest.i}
/*oTable:show().*/
PUT UNFORMATTED res SKIP.
{preview.i}
DELETE OBJECT oTable.