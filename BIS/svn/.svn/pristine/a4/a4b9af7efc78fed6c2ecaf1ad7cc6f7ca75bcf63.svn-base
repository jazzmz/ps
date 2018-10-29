/*
Перенос задолженности на просрочку для проверки ф.401 раздел 1 графа 4
Автор: Никитина Ю.А.
Дата: 19.06.2013
*/

{globals.i}
{norm.i}
{getdates.i}

DEF VAR ResR	AS dec         NO-UNDO.
DEF VAR ResUSD	AS dec         NO-UNDO.
DEF VAR oSysClass 	 AS TSysClass 	NO-UNDO.
DEF VAR kursUSD 	 AS DEC 	NO-UNDO.
DEF VAR oTable  AS TTable    	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.

oTable = new TTable(5).
oTpl = new TTpl("f401g4s1.tpl").
oSysClass = NEW TSysClass().

oTable:AddRow().
oTable:AddCell("Счет Дт").
oTable:AddCell("Счет Кр").
oTable:AddCell("Сумма в руб.").
oTable:AddCell("Сумма в USD").
oTable:AddCell("Содержание").

FOR EACH op WHERE op.op-date GE beg-date AND op.op-date LE end-date NO-LOCK,
	EACH op-entry OF op where can-do("45817*",op-entry.acct-db) and can-do("45708*",op-entry.acct-cr) NO-LOCK:
		if avail(op-entry) then do:
			kursUSD = oSysClass:getCBRKurs(840,op-entry.op-date).
			ResR = ResR + op-entry.amt-rub.
			ResUSD = ResUSD + round((op-entry.amt-rub / kursUSD),2).
			oTable:AddRow().
			oTable:AddCell(op-entry.acct-db).
			oTable:AddCell(op-entry.acct-cr).
			oTable:AddCell(op-entry.amt-rub).
			oTable:AddCell(round((op-entry.amt-rub / kursUSD),2)).
			oTable:AddCell(op.details).
		end.
end.

oTable:AddRow().
oTable:AddCell("ИТОГО").
oTable:AddCell("").
oTable:AddCell(ResR).
oTable:AddCell(ResUSD).
oTable:AddCell("").

DELETE OBJECT oSysClass.

oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
