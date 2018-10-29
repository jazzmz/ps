/*
#4166 
ООО ПИР Банк Гончаров А.Е.

Расчет кассовой сомнительности. Часть I.
1. Просматриваем все операции за день с символами по списку;
2. При нахождении операции из пункта 1, смотрим в предыдущий опердень и ищем там 
   операции с кредитом - дебет из пункта 1;
3. Если нашли операцию из пункта 2, добавляем найденную в пункте 1 операцию в отчёт.


*/


define variable ksymbols as character init "42,46,47,51,53,54,55,58,60,61" no-undo.
define variable befdate as date no-undo.
define variable oTable as TTable2 no-undo.
define variable vLnCountInt as integer no-undo.
define variable vLnTotalInt as integer no-undo.
define buffer fop-entry for op-entry.

{pir-logit.i}

{globals.i}
{getdate.i}
{gdate.i}
{setdest.i}

Function UserFIO returns character (input iUser as character).
	define variable rFio as character init "" no-undo.
	find first _user where (_user._userid = iUser) no-lock no-error.
	if available _user then rFio = _user._user-name.
	return rFio.
end.


/* Подготовим прогресс-бар */
put screen col 2 row 24 "Инициализация..." .
for each op-entry where op-entry.op-date eq end-date no-lock:
    vLnTotalInt = vLnTotalInt + 1.
end.

put unformatted "                             Расчет кассовой сомнительности" skip.
put unformatted skip(1).

{init-bar.i "Обрабатываю данные..."}

oTable = new TTable2(4).
oTable:addRow().
oTable:addCell("Номер документа").
oTable:addCell("Р/с клиента").
oTable:addCell("Название клиента").
oTable:addCell("Содержание операции").
oTable:setcolWidth(1, 10).
oTable:setcolWidth(2, 20).
oTable:setcolWidth(3, 30).
oTable:setcolWidth(4, 20).

befdate = DecWDay(end-date,1). /* Предыдущий рабочий день */

/* Цикл по всем проводкам заданного дня */
for each op-entry where 
	op-entry.op-date eq end-date and
	op-entry.acct-cr begins "202" and
	can-do (op-entry.symbol, ("*" + ksymbols + "*")) no-lock:
	{move-bar.i vLnCountInt vLnTotalInt}
	message op-entry.op view-as alert-box.
		/* Если нашли проводку, отвечающую заданным условиям, смотрим проводки в предыдущем рабочем дне */
		for each fop-entry where
			fop-entry.op-date eq befdate and
			fop-entry.acct-cr eq op-entry.acct-db no-lock:
			/* Нашли сомнительную операцию и добавляем её в таблицу */
				find first op where op.op eq fop-entry.op.
				if available op then do:
					oTable:addRow().
					oTable:addCell(op.doc-num).
					oTable:addCell(op.ben-acct).
					oTable:addCell(op.name-ben).
					oTable:addCell(op.details).
				end.
		end.
	vLnCountInt = vLnCountInt + 1.
end.

put unformatted "Операций по кассе в операционном дне " string(end-date,"99.99.9999") ": " string(vLnTotalInt) skip.
put unformatted "Предыдущий операционный день, в котором искался приход: " string(befdate,"99.99.9999") skip.
put unformatted skip (1) "Отчёт создан: " UserFIO(USERID("bisquit")) " " string(today,"99.99.9999") ". " skip (1). 
{preview.i}
delete object oTable.
