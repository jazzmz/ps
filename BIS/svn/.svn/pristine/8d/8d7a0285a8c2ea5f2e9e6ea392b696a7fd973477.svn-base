/* Запускает процедуры из параметров метода BeforeCalc. Неявно, но по заявке #1182
   Никитина Ю.А. 28.01.13
*/
{globals.i}
{sv-calc.i}
{intrface.get xclass}  /* для updatesigns */

def var Param-BeforeCalc as char no-undo.
def var DataClass_dr as char no-undo.
DEF VAR oAArray  AS TAArray   NO-UNDO.
DEF VAR oAArray_dr  AS TAArray   NO-UNDO.
DEF VAR key1     AS CHAR NO-UNDO.

/*считываем параметры из метода BeforeCalc*/
Param-BeforeCalc = Get-DClass-Params(entry(1,DataBlock.DataClass-id,"@"),'BeforeCalc','',DataBlock.End-Date).

/*Загружаем в массив ДР pir_proc с класса. в ДР записано какие и когда запускали процедуры.*/
DataClass_dr = GetXAttrValue("dataclass",dataclass.DataClass-Id,"pir_proc").
oAArray_dr = NEW TAArray().
oAArray_dr:loadSplittedList(DataClass_dr,"=",FALSE).

/* параметры записываем в массив. теперь параметры метода будут храниться в массиве, а не в Param-BeforeCalc*/
oAArray = NEW TAArray().
oAArray:loadSplittedList(Param-BeforeCalc,",",TRUE).

{foreach oAArray key1 Param-BeforeCalc}

/* message Param-BeforeCalc view-as alert-box.*/
/* в параметре должны быть написаны процедуры через запятую, которые хотим запустить перед рассчетом класса. */
/* смотрим запускали мы сегодня процедуры из параметров или нет. Если не запукали, то запускам. */
    if not oAArray_dr:hasCode(Param-BeforeCalc) or oAArray_dr:get(Param-BeforeCalc) <> STRING(DATE(Today), "99/99/9999") then do:
/* проверяем есть ли эрка процедуры из параметра */
	    IF Search(Param-BeforeCalc + ".r") EQ ? then do:
/* проверяем есть ли пэшка процедуры из параметра */
    		if Search(Param-BeforeCalc + ".p") EQ ? THEN do:
	            MESSAGE COLOR MESSAGE SKIP
			"Процедура" + Param-BeforeCalc + ".p" SKIP
			"не обнаружена."
	            VIEW-AS ALERT-BOX.
		end.
	        else do:
			RUN Value(Param-BeforeCalc + ".p").
			oAArray_dr:setH(Param-BeforeCalc,STRING(DATE(Today), "99/99/9999")).                         
			run normdbg in h_debug (0,"Внимание!", "Запущена процедура " + Param-BeforeCalc). /* вывод сообщения на экран после рассчета блока данных */   
		end.
	    end.
	    else do:
		RUN Value(Param-BeforeCalc + ".r").
		oAArray_dr:setH(Param-BeforeCalc,STRING(DATE(Today), "99/99/9999")).                         
		run normdbg in h_debug (0,"Внимание!", "Запущена процедура " + Param-BeforeCalc). /* вывод сообщения на экран после рассчета блока данных */   
	    end.
    end.
{endforeach oAArray}

DataClass_dr = oAArray_dr:toDataLine("=",False).
UpdateSignsEx("dataclass",dataclass.DataClass-Id, "pir_proc", DataClass_dr).

DELETE OBJECT oAArray_dr.
DELETE OBJECT oAArray.
return "".
