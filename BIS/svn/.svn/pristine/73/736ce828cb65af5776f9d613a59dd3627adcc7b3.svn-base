/* ООО "ПИР Банк" Управление автоматизации 2013г.	*/
/* p-шка, позволяющая сделать множественный выбор в 	*/
/* браузере. 						*/
/* Гончаров А.Е. 29.04.2013				*/

define input parameter iParam as character no-undo.
define input parameter Level as int64 no-undo.


define variable mTs as character no-undo.

{globals.i}
{intrface.get xclass}
{tmprecid.def}
{empty tmprecid}

mTs   = pick-value.



run dlclass.p (iParam, iParam, GetCodeName("", iParam),level).
if can-find(first tmprecid) then do:
	pick-value = "".
	for each tmprecid, first code where recid(code) eq tmprecid.id:
		case iParam:
			when "PirОценкаРиска" then do: 
				{additem2.i pick-value code.val ;}. 
			end.
			when "ОКВЭД" then do: 
				{additem2.i pick-value code.code ;}. 
			end.
		end.
	end.
end.
if mTs = '*' then mTs = ''.
if {assigned pick-value} then  
   pick-value = mTs + (if mTs <> '' then ';' else '') + pick-value. 
   
{intrface.del}

