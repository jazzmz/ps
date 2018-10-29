/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* Загрузчик анкеты клиента #3124			*/
/* Логика работы:                                       */
/* Смотрим классификатор pir-eanketa и по заданной     */
/* дате берёт актуальную процедуру построение анкеты.   */
/* В качестве входного параметра требует: Ч, Ю, П, ВП - */
/* что-то одно из этого, соответственно, вешается на    */
/* физика, юрика, представителя или выгодопроиобретателя*/
/* Гончаров А.Е. 13.06.2013				*/

{globals.i} 
{getdate.i}

def var rProc as char no-undo.
def var Parms as char no-undo init "06000LPP;02000KEG;LOBYREVA;04000KIY,KLADR".
def input parameter iParam as char no-undo.

find last code where code.class eq 'pir-eanketa' and date(entry(1,code.val)) le end-date no-lock no-error.
if available(code) then do:
	rProc = code.code.
	Parms = iParam + "," + Parms.
	if search(rProc + ".r") <> ? then
		run value (rProc + ".r")(Parms).
	else
		if search(rProc + ".p") <> ? then run value(rProc + ".p")(Parms).
		else message "Процедура " rProc "не найдена!" view-as alert-box.

end.
else message "Данная форма анкеты не действует на" end-date "!" view-as alert-box.


