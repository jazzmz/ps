/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* Инклюдим этот файл. Вызываем функцию InstaStatement	*/
/* (дата опердня,счёт). Например:			*/
/* InstaStatement (10/07/2013, "40702810400001123186").	*/
/* Функция кладёт на вход бисмарку запрос на выписку.	*/
/* Гончаров А.Е. 06.11.2013				*/

function RandomString returns character (input iCol as integer).
	define variable i as integer no-undo.
	define variable oResult as character init "" no-undo.
	Do i = 1 to iCol:
		oResult = oResult + chr(random(97,122)).
	end.
	return oResult.
end function.

function InstaStatement returns logical (input iDate as date, iAcct as character).
	define variable saveDir as character init "/home2/bis/quit41d/imp-exp/bifit/in/" no-undo.
	define variable fileName as character init ".tel" no-undo.
	define variable skip1 as character init "" no-undo.
	define variable tag20 as character no-undo.
	define variable tDate as character no-undo.
	define variable lcom as character init "chmod 777 " no-undo.
	skip1 = chr(13) + chr(10).
	filename = "100" + RandomString(4) + string(day(today),"99") + filename.
	output to value(saveDir + fileName).
	put unformatted "YZYZ" skip1 skip1 "FROM:iBank2" skip1 "TO:Bisquit" skip1.
	put unformatted "DATE:"entry(3,STRING(today,"99/99/99"),"/") + entry(2,STRING(today,"99/99/99"),"/")  + entry(1,STRING(today,"99/99/99"),"/") skip1.
	put unformatted "TIME:"entry(1,STRING(time,"HH:MM:SS"),":") + entry(2,STRING(time,"HH:MM:SS"),":")   + entry(3,STRING(time,"HH:MM:SS"),":") skip1 skip.
	put unformatted "::920 ЗАПРОС О СОСТОЯНИИ СЧЕТА" skip1 skip1.
	tag20 = string(year(today),"9999") + string (month (today),"99") + string(day(today),"99") + string (time) + string(random(0,999),"999") + skip1.
	put unformatted ":20:" tag20.
	put unformatted ":12:940" skip1.
	put unformatted ":25:" iAcct skip1.
	tDate = entry(3,STRING(iDate,"99/99/99"),"/") + entry(2,STRING(iDate,"99/99/99"),"/")  + entry(1,STRING(iDate,"99/99/99"),"/").
	put unformatted ":31F:" tDate "/" tDate skip1 skip1.
	put unformatted "NNNN" skip1.
	output close.
	lcom = lcom + saveDir + fileName.
	os-command silent value (lcom).
	return true.
end function.

