{globals.i}
{norm.i}

DEF INPUT PARAM in-data-id LIKE DataBlock.data-id NO-UNDO.
DEF VAR oTable    AS TTable2    NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR itogSym1 as dec init 0 NO-UNDO.
DEF VAR preSym1 as char init "start" NO-UNDO.
 
oTable = new TTable2(6).
oTpl = new TTpl("pir_410.tpl").

oTable:addRow().
oTable:addCell("Код актива (обязательства)"). 
oTable:addCell("Номер лицевого счета"). 
oTable:addCell("Код сектора дебитора (кредитора)"). 
oTable:addCell("Код страны дебитора (кредитора)"). 
oTable:addCell("Номер актива (обязательства)"). 
oTable:addCell("Сумма актива (обязательства) в долларах США"). 

FIND FIRST DataBlock WHERE DataBlock.Data-Id = in-data-id NO-LOCK NO-ERROR.
FOR EACH Dataline OF DataBlock NO-LOCK by substring(Dataline.sym1,1,2) 
		by (if (substring(Dataline.sym1,1,2) = "1А") or (substring(Dataline.sym1,1,2) = "1П") then dec(substring(Dataline.sym1,3,6)) else int(substring(Dataline.sym1,1,1))):
        if (Dataline.sym1 <> preSym1) and (preSym1 ne "start") and (itogSym1 <> 0) then do:
		oTable:addRow().
		oTable:addCell("Итог по " + preSym1). 
	        oTable:addCell(" "). 
	        oTable:addCell(" "). 
	        oTable:addCell(" "). 
	        oTable:addCell(" "). 
		oTable:addCell(itogSym1). 
		itogSym1 = 0.
	end.
	oTable:addRow().
	preSym1 = Dataline.sym1.
	oTable:addCell(Dataline.sym1). 
        oTable:addCell(substr(Dataline.sym4,1,20)). 
	oTable:addCell(Dataline.sym2). 
	oTable:addCell(Dataline.sym3). 
	oTable:addCell(substr(Dataline.sym4,22,3)). 
	oTable:addCell(Dataline.val[1]). 
	itogSym1 = itogSym1 + Dataline.val[1].
end.

oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
