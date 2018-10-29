/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* p-шка вешается на метод chkupd реквизита со след. 	*/
/* строкой параметров:					*/
/* ^surr,value,pir-e-fullname;Б				*/
/* где ^surr,value - константы, pir-e-fullname - имя	*/
/* доп.река, в который копируется значение текущего 	*/
/* доп.река, через точку с запятой указываем 		*/
/* принадлежность доп.река:				*/
/* Б - банк						*/
/* Ю - Юрик						*/
/* Ч - Физик						*/
/* Сделано для выведения анкет клиентов на отдельные 	*/
/* дополнительные реквизиты				*/
/* Гончаров А.Е. 08.05.2013				*/

{globals.i}
{gxattr.i}

define input parameter iSurr as character no-undo.
define input parameter iValue as character no-undo.
define input parameter iParam as character no-undo.

if iSurr NE ? then do:
	case entry(2,iParam):
		when "Б" then do:
			SetTempSign("banks", iSurr, entry(1,iParam), iValue).
		end.
		when "Ю" then do:
			SetTempSign("cust-corp", iSurr, entry(1,iParam), iValue).
		end.
		when "Ч" then do:
			SetTempSign("person", iSurr, entry(1,iParam), iValue).
		end.
	end case.
end.

