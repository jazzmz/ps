/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* Сверка комиссии по клиент-банку. 			*/
/* Запуск из БМ->Печать->Отчеты по клиент-банк-> 	*/
/* Сверка списания комиссии				*/
/* Гончаров А.Е. 07.08.2013				*/

{globals.i}
{getdate.i}
{setdest.i}

define temp-table bufBnkLst
	field client as character
	field acct as character
	field isactive as logical.
define temp-table tt2
	field cust-cat as character
	field cust-id as integer
	field active-kb as logical
	field active-bis as logical
	field comission as logical.
define temp-table tt3
	field cust-cat as character
	field cust-id as integer
	field acct-num as character.

define variable oTable as TTable2 no-undo.
define variable ClientName as character no-undo.
define variable iParm as logical no-undo.

function transbool returns character (input iParm as logical).
	if iParm then return "Да". else return "Нет".
end.

Function UserFIO returns character (input iUser as character).
	define variable rFio as character init "" no-undo.
	find first _user where (_user._userid = iUser) no-lock no-error.
	if available _user then rFio = _user._user-name.
	return rFio.
end.

os-command silent value ('rm -f ./fileout.xml').
os-command silent value ('ssh mover@beryllium "/usr/local/iBank2Bisquit/bin/accounts.sh"').
os-command silent value ('scp mover@beryllium:/usr/local/iBank2Bisquit/comission/fileout.xml ./').

empty temp-table bufBnkLst.
temp-table bufBnkLst:read-xml("file","./fileout.xml","empty",?,?,?,?).

for each bufbnklst where bufbnklst.acct ne "40702810700001123475":
	for each acct where acct.acct eq bufbnklst.acct:
		find first tt2 where tt2.cust-id eq acct.cust-id and tt2.cust-cat eq acct.cust-cat no-lock no-error.
		if not available tt2 then
			do:
				create tt2.
				assign
				tt2.cust-cat = acct.cust-cat
				tt2.cust-id  = acct.cust-id
				tt2.active-kb   = bufbnklst.isactive.
			end.
               	create tt3.
		assign
			tt3.cust-id  = acct.cust-id
			tt3.cust-cat = acct.cust-cat
			tt3.acct-num = acct.acct.
	end.
end.

for each tt2:
	tt2.comission = false.
	tt2.active-bis = false.
	for each tt3 where tt2.cust-cat eq tt3.cust-cat and tt2.cust-id eq tt3.cust-id:
		find last cust-role where cust-role.file-name EQ "acct" and 
					  cust-role.surrogate EQ (tt3.acct-num + ",") and
					  cust-role.class-code eq "ClientBank" no-lock no-error.
		if not tt2.active-bis and available cust-role then do:
			if cust-role.close-date LE end-date then tt2.active-bis = false.
				else tt2.active-bis = true.
			find first op-entry where 
				op-entry.op-date eq end-date and 
				op-entry.acct-db eq tt3.acct-num and 
				can-do("70601810900101210201,70601810800001210207", op-entry.acct-cr) no-lock no-error.
			if not tt2.comission and available op-entry then tt2.comission = true.
		end.
	end.
end.

oTable = new tTable2(4).
oTable:addRow().
oTable:addCell("Клиент").
oTable:addCell("Комиссия").
oTable:addCell("Активен БИС").
oTable:addCell("Активен КБ").
oTable:setcolWidth(1, 37).
oTable:setcolWidth(2, 11).
oTable:setcolWidth(3, 11).
oTable:setcolWidth(4, 11).

for each tt2:
	if (tt2.active-bis ne tt2.active-kb) or (not tt2.comission and tt2.active-kb) then do:

ClientName = "".

		case tt2.cust-cat:
			when "Ч" then do: 
				find first person where person.person-id eq tt2.cust-id no-lock no-error.
				if available person then ClientName = person.name-last + " " + person.first-names.
			end.
			when "Ю" then do:
				find first cust-corp where cust-corp.cust-id eq tt2.cust-id no-lock no-error.
				if available cust-corp then ClientName = cust-corp.name-short.
			end.
		end case.
		oTable:addRow().
		oTable:addCell(ClientName).
		oTable:addCell(string(transbool(tt2.comission))).
		oTable:addCell(string(transbool(tt2.active-bis))).
		oTable:addCell(string(transbool(tt2.active-kb))).
	end.
end.

put unformatted "                  Сверка комиссии по Клиент-Банку на " string(end-date,"99.99.9999") "." skip (1).
oTable:Show().
put unformatted skip (1).
put unformatted "Отчёт создан: " UserFIO(USERID("bisquit")) " " string(today,"99.99.9999") ". " skip (1).
{preview.i}
delete object oTable.
