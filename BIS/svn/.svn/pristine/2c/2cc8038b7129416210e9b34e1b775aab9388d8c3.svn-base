/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* Сверка документов по клиент-банку. 			*/
/* Запуск из БМ->Печать->Отчеты по клиент-банк-> 	*/
/* Сверка документов БК					*/
/* Гончаров А.Е. 17.10.2013				*/

{globals.i}
{getdates.i}
{setdest.i}
{pir-kb.fun}

define variable remote_com as character init "ssh mover@beryllium /usr/local/iBank2Bisquit/bin/docs.sh" no-undo.
define variable IBP491 as character init "IBP491" no-undo.
define variable oTable as TTable2 no-undo.
define variable oTable2 as TTable2 no-undo.
define variable oTable3 as TTable2 no-undo.
define variable oTable1Flag as logical init false no-undo.
define variable oTable2Flag as logical init false no-undo.
define variable oTable3Flag as logical init false no-undo.

define temp-table bufBnkLst no-undo
	field doc_id as character
	field num_doc as character
	field status_doc as character
	field amount as character.

function cmpstatus returns logical (input bis_status as character, kb_status as character).
	define variable rStatus as logical init false no-undo.
	case kb_status:
		when "3" then if (bis_status eq "В") or (bis_status eq "АК") then rStatus = true.
		when "4" then if (bis_status ge "ПКБ") and (bis_status le "ФБП") then rStatus = true.
		when "5" then if bis_status ge "√" then rStatus = true.
		when "6" then if bis_status eq "А" then rStatus = true.
	end case.
	return rStatus.
end.

remote_com = remote_com + " " + kbdate(beg-date) + " " + kbdate(end-date).

Function UserFIO returns character (input iUser as character).
	define variable rFio as character init "" no-undo.
	find first _user where (_user._userid = iUser) no-lock no-error.
	if available _user then rFio = _user._user-name.
	return rFio.
end.

os-command silent value ('rm -f ./result.xml').
os-command silent value (remote_com).
os-command silent value ('scp mover@beryllium:/usr/local/iBank2Bisquit/recon/result.xml ./').

empty temp-table bufBnkLst.
temp-table bufBnkLst:read-xml("file","./result.xml","empty",?,?,?,?).

oTable = new tTable2(4).
oTable:addRow().
oTable:addCell("Номер").
oTable:addCell("Статус БИС").
oTable:addCell("Статус КБ").
oTable:addCell("Сумма").
oTable:setcolWidth(1, 10).
oTable:setcolWidth(2, 10).
oTable:setcolWidth(3, 14).
oTable:setcolWidth(4, 20).

oTable2 = new tTable2(2).
oTable2:addRow().
oTable2:addCell("Номер").
oTable2:addCell("Сумма").
oTable2:setcolWidth(1, 10).
oTable2:setcolWidth(2, 20).

oTable3 = new tTable2(3).
oTable3:addRow().
oTable3:addCell("Номер").
oTable3:addCell("Сумма").
oTable3:addCell("Дата").
oTable3:setcolWidth(1, 10).
oTable3:setcolWidth(2, 20).
oTable3:setcolWidth(3, 20).

for each bufbnklst:
	find last op-impexp where (op-reference eq (IBP491 + string(integer(bufbnklst.doc_id),"99999999"))) no-lock no-error.
	if available op-impexp then do:
		find first op where (op.op eq op-impexp.op) no-lock no-error.
		if available op then do: /* документ есть в бисе, сверяем */
			if op.op-date eq ? and op.op-status eq "А" then do: /*Документ аннулирован в БИСе*/
				if not cmpstatus (op.op-status, bufbnklst.status_doc) then do:
					oTable1Flag = true.
					oTable:addRow().
					oTable:addCell(bufbnklst.num_doc).
					oTable:addCell(op.op-status).
					oTable:addCell(convstatus(bufbnklst.status_doc)).
					oTable:addCell(bufbnklst.amount).
				end.
			end.
			if op.op-date ge beg-date and op.op-date le end-date then
				if not cmpstatus (op.op-status, bufbnklst.status_doc) then do:
					oTable1Flag = true.
					oTable:addRow().
					oTable:addCell(bufbnklst.num_doc).
					oTable:addCell(op.op-status).
					oTable:addCell(convstatus(bufbnklst.status_doc)).
					oTable:addCell(bufbnklst.amount).
				end.
		end.
	end.
	else do: /* документа нет в бисе, но есть в кб, выводим в отдельную таблицу */
		if bufbnklst.status_doc ge "2" and bufbnklst.status_doc le "6"  then do:
			oTable2Flag = true.
			oTable2:addRow().
			oTable2:addCell(bufbnklst.num_doc).
			oTable2:addCell(bufbnklst.amount).
		end.
	end.
end.

for each op-impexp where 
	op-impexp.op-date ge beg-date and 
	op-impexp.op-date le end-date no-lock:
 	find first bufbnklst where (IBP491 + string(integer(bufbnklst.doc_id),"99999999")) eq op-impexp.op-reference no-lock no-error.
	if not available bufbnklst then do:
		find first op where 	op.op eq op-impexp.op and 
					op.op-date ge beg-date and 
					op.op-date le end-date and
					op.user-id eq "BNK-CL" no-lock no-error.
		if available op then do:
			find first op-entry where op-entry.op eq op.op no-lock no-error.
				if available op-entry then do:
					oTable3Flag = true.
					oTable3:addRow().
					oTable3:addCell(op.doc-num).
					if op-entry.amt-rub ne 0 then oTable3:addCell(op-entry.amt-rub). else oTable3:addCell(op-entry.amt-cur).
					oTable3:addCell(op.op-date).
				end.
		end.
	end.
end.

put unformatted "Сверка документов по Клиент-Банку за период " string(beg-date,"99.99.9999") " - " string(end-date,"99.99.9999") skip (1).
if oTable1Flag then do:
	put unformatted "Документы, по которым есть расхождения " skip (1).
	oTable:Show().
	put unformatted skip (1).
end.
else do:
	put unformatted "Документов с несоответствиями по статусам нет." skip (1).
end.

put unformatted skip (1).
if oTable2Flag then do:
	put unformatted "Документы, отсутствующие в ИБС БИСквит " skip (1).
	oTable2:Show().
	put unformatted skip (1).
end.

put unformatted skip (1).
/* if oTable3Flag then do:
	put unformatted "Документы, отсутствующие в КБ " skip (1).
	oTable3:Show().
	put unformatted skip (1).
end.*/

	
put unformatted "Отчёт создан: " UserFIO(USERID("bisquit")) " " string(today,"99.99.9999") ". " skip (1). 
{preview.i}
delete object oTable.
delete object oTable2.
delete object oTable3.
