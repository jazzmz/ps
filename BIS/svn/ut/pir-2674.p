/*процедура ищет документы полной оплаты по сейфам у которых не 
создана счет-фактура с ролью sf-out или sf-in, ожидается что у таких документов созданы обе счет-фактуры

Автор: Красков А.С.
Заявка: 2674*/

{bislogin.i}
{globals.i}
{getdates.i}
{intrface.get xclass}

DEF VAR bFindOut AS logical NO-UNDO.
DEF VAR bFindIN AS logical NO-UNDO.
DEF VAR oTable AS TTable2 NO-UNDO.
DEF VAR count AS INT INIT 0 NO-UNDO.

oTable = new TTable2(5).

FOR EACH op-entry WHERE op-entry.acct-db BEGINS "61304"
		    AND op-entry.acct-cr BEGINS "70601"
		    AND op-entry.op-date >= beg-date
		    AND op-entry.op-date <= end-date
		    AND op-entry.user-id BEGINS "06170"
		    NO-LOCK,
     FIRST op WHERE op.op = op-entry.op NO-LOCK:
             bFindOut = false.
	     bFindIN = false.
	     FOR EACH links WHERE (links.end-date = ? or links.end-date <= ?)
			      AND links.link-id EQ 27 
			      AND links.target-id = STRING(op-entry.op) + "," + STRING(op-entry.op-entry) 
  	 	 	 	  NO-LOCK:

  	 	 	      IF links.source-id BEGINS "sf-out" THEN bFindOut = true.
  	 	 	      IF links.source-id BEGINS "sf-in" THEN bFindIn = true.
	     END.

             IF NOT bFindOut OR NOT bFindIn THEN
                DO:
                   count = count + 1.
                   oTable:addRow().
		   oTable:addCell(count).
		   oTable:addCell(op.op-date).
		   oTable:addCell(op.op).
		   oTable:addCell(bFindOut).
		   oTable:addCell(bFindIn).
		END.
	

END.

{setdest.i}

  oTable:show().

{preview.i}

DELETE OBJECT oTable.
