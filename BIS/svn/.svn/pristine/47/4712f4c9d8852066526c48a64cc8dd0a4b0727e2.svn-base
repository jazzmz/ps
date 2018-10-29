/*
Перенос задолженности на просрочку для проверки ф.401 раздел 1 графа 4
Автор: Никитина Ю.А.
Дата: 19.06.2013
*/

{globals.i}
{norm.i}
{getdates.i}

DEF VAR ResR	AS dec         NO-UNDO.
DEF VAR ResV	AS dec         NO-UNDO.
DEF VAR ResUSD	AS dec         NO-UNDO.
DEF VAR oSysClass 	 AS TSysClass 	NO-UNDO.
DEF VAR kursUSD 	 AS DEC 	NO-UNDO.
DEF VAR oTable  AS TTable    	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.

oTable = new TTable(6).
oTpl = new TTpl("f401g2s1.tpl").
oSysClass = NEW TSysClass().

oTable:AddRow().
oTable:AddCell("Счет Дт").
oTable:AddCell("Счет Кр").
oTable:AddCell("Сумма в руб.").
oTable:AddCell("Сумма в вал.").
oTable:AddCell("Сумма в USD").
oTable:AddCell("Содержание").
/*
FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
	EACH op-entry OF op where can-do("47426*,47411*",op-entry.acct-db) and can-do("40807*,40820*,70606*",op-entry.acct-cr) NO-LOCK:
		if avail(op-entry) then do:
			find first loan-acct where loan-acct.acct eq op-entry.acct-db no-lock no-error.
			find first loan of loan-acct no-lock no-error.
			if avail(loan) then do:
			    	find first loan-acct of loan where loan-acct.acct-type eq "loan-dps-t" or loan-acct.acct-type eq "Депоз"  no-lock no-error.
				if avail(loan-acct) then do:
					if can-do("!423*,!422*,!421*,42.01*,42.02*,42.03*,42.04*,42.05*",loan-acct.acct) then do: /* краткосрочные */
                        			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
                        			ResR = ResR + op-entry.amt-rub.
                        			ResV = ResV + op-entry.amt-cur.
                        			ResUSD = ResUSD + round((op-entry.amt-rub / kursUSD),2).
                        			oTable:AddRow().
                        			oTable:AddCell(op-entry.acct-db).
                        			oTable:AddCell(op-entry.acct-cr).
                        			oTable:AddCell(op-entry.amt-rub).
                        			oTable:AddCell(op-entry.amt-cur).
                        			oTable:AddCell(round((op-entry.amt-rub / kursUSD),2)).
                        			oTable:AddCell(op.details).
					end.
				end. 
			end.			
		end.
end.
*/
FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
     	EACH op-entry OF op where can-do("70606*",op-entry.acct-db) and can-do("47426*,47411*",op-entry.acct-cr) NO-LOCK:
               	if avail(op-entry) then do:
               		find first loan-acct where loan-acct.acct eq op-entry.acct-cr no-lock no-error.
               		find first loan of loan-acct no-lock no-error.
               		if avail(loan) then do:
               		    	find first loan-acct of loan where loan-acct.acct-type eq "loan-dps-t" or loan-acct.acct-type eq "Депоз"  no-lock no-error.
               			if avail(loan-acct) then do:
               				if can-do("!423*,!422*,!421*,42.01*,42.02*,42.03*,42.04*,42.05*",loan-acct.acct) then do: /* краткосрочные */
                        			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
                        			ResR = ResR + op-entry.amt-rub.
                        			ResV = ResV + op-entry.amt-cur.
                        			ResUSD = ResUSD + round((op-entry.amt-rub / kursUSD),2).
                        			oTable:AddRow().
                        			oTable:AddCell(op-entry.acct-db).
                        			oTable:AddCell(op-entry.acct-cr).
                        			oTable:AddCell(op-entry.amt-rub).
                        			oTable:AddCell(op-entry.amt-cur).
                        			oTable:AddCell(round((op-entry.amt-rub / kursUSD),2)).
                        			oTable:AddCell(op.details).
        				end.
             			end. 
               		end.			
               	end.
end.
FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
     	EACH op-entry OF op where can-do("47426*,47411*",op-entry.acct-db) and can-do("70606*",op-entry.acct-cr) NO-LOCK:
               	if avail(op-entry) then do:
               		find first loan-acct where loan-acct.acct eq op-entry.acct-db no-lock no-error.
               		find first loan of loan-acct no-lock no-error.
               		if avail(loan) then do:
               		    	find first loan-acct of loan where loan-acct.acct-type eq "loan-dps-t" or loan-acct.acct-type eq "Депоз"  no-lock no-error.
               			if avail(loan-acct) then do:
               				if can-do("!423*,!422*,!421*,42.01*,42.02*,42.03*,42.04*,42.05*",loan-acct.acct) then do: /* краткосрочные */
                        			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
                        			ResR = ResR + op-entry.amt-rub.
                        			ResV = ResV + op-entry.amt-cur.
                        			ResUSD = ResUSD + round((op-entry.amt-rub / kursUSD),2).
                        			oTable:AddRow().
                        			oTable:AddCell(op-entry.acct-db).
                        			oTable:AddCell(op-entry.acct-cr).
                        			oTable:AddCell(op-entry.amt-rub).
                        			oTable:AddCell(op-entry.amt-cur).
                        			oTable:AddCell(round((op-entry.amt-rub / kursUSD),2)).
                        			oTable:AddCell(op.details).
        				end.
             			end. 
               		end.			
               	end.
end.

oTable:AddRow().
oTable:AddCell("ИТОГО").
oTable:AddCell("").
oTable:AddCell(ResR).
oTable:AddCell(ResV).
oTable:AddCell(ResUSD).
oTable:AddCell("").

DELETE OBJECT oSysClass.

oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
