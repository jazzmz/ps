/*
Процедура запускается из планировщика.
формирует список счетов у которых установлен 
доп.рек сконсальдо в значение "Предупреждение" и отправляет сообщение по почте


по заявке #2609

Автор: Красков А.С.

*/

{globals.i}
{intrface.get xclass}
DEFINE INPUT PARAMETER iParam AS CHAR.

DEF VAR oTable AS TTable2 NO-UNDO.
DEF BUFFER acct FOR acct.
DEF VAR count AS INT INIT 0 NO-UNDO.

oTable = new TTable2(3).


OUTPUT TO VALUE(ENTRY(1,iParam,';')) .
PUT UNFORMAT "To: " ENTRY(3,iParam,';') 									SKIP
						 "Content-Type: text/plain; charset = ibm866" SKIP
						 "Content-Transfer-Encoding: 8bit" 						SKIP
						 "Subject: Доп.рек СКонСальдо по счетам на " TODAY  SKIP(2).

FOR EACH acct WHERE (acct.contr-acct = "" OR acct.contr-acct = ?) 
               AND (acct.close-date > TODAY OR acct.close-date = ?)
	       AND acct.side <> "АП"
	       AND acct.acct-cat <> "n"
               and acct.acct-cat <> "u"
               NO-LOCK:

  IF GetXAttrValueEx("acct", acct.acct + "," + acct.currency,"СКонСальдо",?) = "Предупреждение" then 
	DO:
	   count = count + 1.
           oTable:addRow().
	   oTable:addCell(count).
           oTable:addCell(acct.acct).
	   oTable:addCell(GetXAttrValueEx("acct", acct.acct + "," + acct.currency,"СКонСальдо",?)).
	END.
END.

   PUT UNFORMATTED "Отчет об установленном доп.реквизите СКонСальдо за " TODAY SKIP(1).	
   oTable:show().

   PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP.
  
OUTPUT CLOSE.			  

IF Count NE 0 AND OPSYS = "UNIX" THEN DO:
	 OS-COMMAND SILENT VALUE(ENTRY(2,iParam,';') + " < " + ENTRY(1,iParam,';')).
END.

OS-DELETE VALUE(ENTRY(1,iParam,';')).


