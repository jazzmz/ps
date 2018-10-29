/****************************
 * Отчет по гарантиям которые попадают
 * в ОВП без установленного 
 * признака вхождения в ОВП.
 ****************************
 * Автор: Маслов Д. А.
 * Заявка: #1205
 * Дата создания: 08.08.12
 *****************************/

{globals.i}

DEF VAR oAcct AS TAcct                   NO-UNDO.
DEF VAR currDate AS DATE INIT 07/31/2012 NO-UNDO.
DEF VAR currPos  AS DEC                  NO-UNDO.

DEF VAR oTable AS TTable                 NO-UNDO.

oTable = NEW TTable(4).

{getdate.i}

currDate = end-date.

for each loan where loan.currency ne "" and (loan.close-date EQ ? OR loan.close-date gt end-date) NO-LOCK:
	for each loan-acct of loan no-lock:
		if can-do("91414*,91311*,91312*",loan-acct.acct) then do:
			oAcct = NEW TAcct(loan-acct.acct).
			currPos = oAcct:getLastPos2Date(currDate).
                        oTable:addRow().
			oTable:addCell(loan-acct.acct).
			oTable:addCell(loan-acct.acct-type). 
			oTable:addCell(loan.cont-code). 
			oTable:addCell(oAcct:getXAttr("f634_dec")).  
			DELETE OBJECT oAcct.
		end.
	end.
end.
{setdest.i}
PUT UNFORMATTED "*** ПРОВЕРОЧНЫЙ ОТЧЕТ ОВП ***" SKIP.
oTable:show().
{preview.i}
DELETE OBJECT oTable.