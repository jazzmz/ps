/*
#3721 Формирование книги регистрации платежных поручений
Бакланов А.В. 16.12.2013
c модификацией с учетом распространения на все внешние платежи Банка
16.01.2014
*/

{globals.i}
{bislogin.i}
{getdates.i}

{intrface.get xclass}

DEF INPUT PARAM iOpKind AS CHAR NO-UNDO.
DEF VAR oBank AS TBank NO-UNDO.
DEF VAR oTpl AS TTpl NO-UNDO.
DEF VAR oTable AS TTable NO-UNDO.

DEF TEMP-TABLE Tres NO-UNDO
         field iden  	  as int
         field numdate    as char
         field name       as char
	 field namebank   as char
	 field racct	  as char
	 field detail	  as char
         field summ   	  as char.

oTpl = new TTpl("pir-knppmbk.tpl").
oTable = NEW TTable(6).

for each op where /*op.op-kind = iOpKind and*/ op.op-date <= end-date and op.op-date >= beg-date NO-LOCK:
	find first op-entry where op-entry.op = op.op no-lock no-error.
	if available op-entry and GetXAttrValueEx("op", STRING(op.op), "ПИРКнигаРег", "") = "yes" then do:

		CREATE Tres.

		find first op-bank where op-bank.op = op.op no-lock no-error.
		if available op-bank then do:
		oBank = NEW TBank(bank-code).

		ASSIGN
			Tres.iden = INT(op.doc-num)
			Tres.numdate = op.doc-num + " от " + string(day(op.op-date),'99') + "." + string(month(op.op-date),'99') + "." + string(year(op.op-date),'9999')
			Tres.name = op.name-ben
			Tres.namebank = oBank:bank-name
			Tres.detail = IF NUM-ENTRIES(op.details,CHR(10)) > 1 THEN ENTRY(1,op.details,CHR(10)) + " " + ENTRY(2,op.details,CHR(10)) ELSE ENTRY(1,op.details,CHR(10))
			Tres.summ = string(op-entry.amt-rub,">>>,>>>,>>>,>>>,>>>,>>9.99") + "=".
		
                IF op.ben-acct = "" THEN ASSIGN Tres.racct = oBank:corr-acct.
			ELSE ASSIGN Tres.racct = op.ben-acct.
	
		end.
	end.
end.

for each Tres WHERE Tres.numdate <> "" by Tres.iden:
		oTable:addRow().
		oTable:addCell(Tres.numdate).
		oTable:addCell(Tres.name).
		oTable:addCell(Tres.namebank).
		oTable:addCell(Tres.racct).
		oTable:addCell(Tres.detail).
		oTable:addCell(Tres.summ).
end.

oTpl:addAnchorValue("OpDate1",string(day(beg-date),'99') + "." + string(month(beg-date),'99') + "." + string(year(beg-date),'9999')).
oTpl:addAnchorValue("OpDate2",string(day(end-date),'99') + "." + string(month(end-date),'99') + "." + string(year(end-date),'9999')).
oTpl:addAnchorValue("Tabledoc",oTable).

{setdest.i}
oTpl:show().
{preview.i}

DELETE OBJECT oBank.
DELETE OBJECT oTable.

{intrface.del}