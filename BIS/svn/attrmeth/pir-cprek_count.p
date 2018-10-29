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
/* От pir-cprek.p отличается тем, что перед             */
/* копирование проверяет наличие страны в таблице       */
/* country (валидация). В данный момент вешается на     */
/* доп.рек country-id2                                  */
/* Гончаров А.Е. 04.06.2013				*/
/* 05.08 доработана для вызова из pp-cust.p		*/

{globals.i}
{gxattr.i}

define input parameter iSurr as character no-undo.
define input parameter iValue as character no-undo.
define input parameter iParam as character no-undo.
define input parameter iDr as character no-undo.

find first country where country.country-id eq iValue no-lock no-error.
if not avail country then return error.

if iSurr NE ? then do:
	SetTempSign (iParam, iSurr, iDr, iValue).	
end.

