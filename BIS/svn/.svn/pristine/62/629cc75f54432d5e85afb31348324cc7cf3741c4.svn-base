/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* Отправляет курсы на электронное табло. Заявка #3203.	*/
/* На входе ожидаем 4 числа с курсами покупки и продажи	*/
/* доллара и евро, а также настроечник, содержащий адрес*/
/* контроллера табло. Для "Виталика" это "PirTBoard".	*/
/* Гончаров А.Е. 27.06.2013				*/

{globals.i}

Function	TBoard_Set_Rates returns character
		(input iUBuy  as decimal,
		input iUSell as decimal,
		input iEBuy  as decimal,
		input iESell as decimal,
		input wTBoard as character).

	define variable iResult as logical no-undo.
	define variable oResult as char no-undo.
	define variable hWebService as handle no-undo.
	define variable hpt as handle no-undo.

	create server hWebService.
	hWebService:CONNECT("-WSDL " + FGetSetting(wTBoard,"","") + " ") no-error.
	if hWebService:CONNECTED() then do:
		run VitalikControllerPortType set hpt on server hWebService.
		run SetRate in hpt (string(time,"hh:mm:ss"),string(today,"99.99.99"),string(iUBuy,"99.99"), string(iEBuy, "99.99"), string(iUSell,"99.99"), string(iESell,"99.99"), output iResult).
		if not iResult then oResult = "Ошибка, курсы на табло не были установлены.".
		if iResult then oResult = "Курсы на табло установлены.".
		hWebService:disconnect().
		delete object hWebService.
	end.
	else oResult = "Невозможно подключиться к табло.".
	return oResult.
end function.
