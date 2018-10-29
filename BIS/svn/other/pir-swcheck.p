/* ------------------------------------------------------
     Copyright: ООО КБ "Пpоминвестрасчет"
     Базируется: -
     Причина: ТЗ на выгрузку Клиент-банк -> БИС -> SWIFT
     Что делает: Подготавливает поля 50, 59, 70  к выгрузке в SWIFT
     Как работает: по выбранным в броузере документов записям, процедура 
                   заполняет файл в необходимом формате
     Параметры: <каталог_экспорта>
     Место запуска: броузер документов
------------------------------------------------------ */

/** Глобальные системные определения */
{globals.i}
{ulib.i} 

/** используем информацию из броузера */
{tmprecid.def}

DEF VAR tag50 AS CHAR INIT "". /**  Клиент - заказчик */
DEF VAR tag59 AS CHAR INIT "". /**  Клиент - бенефициар */
DEF VAR tag70 AS CHAR INIT "". /**  Информация о платеже */

DEF VAR i AS INTEGER NO-UNDO INIT 0.
DEF VAR j AS INTEGER NO-UNDO INIT 0.
DEF VAR tmpStr AS CHAR NO-UNDO FORMAT "x(250)" VIEW-AS EDITOR SIZE 37 BY 6.
DEF VAR tmpStr2 AS CHAR NO-UNDO FORMAT "x(250)" VIEW-AS EDITOR SIZE 37 BY 6. 
DEF VAR SKIP1 AS CHAR NO-UNDO INIT "".
DEF FRAME fSet WITH CENTERED NO-LABELS TITLE "Проверте данные".

SKIP1 = CHR(13) + CHR(10).

/** обработка выбранных документов */
FOR EACH tmprecid NO-LOCK,
  FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
  FIRST op-entry WHERE op-entry.op = op.op NO-LOCK:

  /** Проверяем данные, в случае не соответсвия выводим на экран */

  /** Тег 50 */
    tmpStr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift50Cor", "?").
    IF tmpStr = "" OR tmpStr = "?" THEN DO:
	tmpStr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift50", "?").
        /** Обработка строки в удобочитаемый вид */
        tmpStr = CAPS(tmpStr).
	REPEAT WHILE INDEX(tmpStr,"~"") <> 0:
    	    SUBSTRING(tmpStr, INDEX(tmpStr,"~""), 1, "CHARACTER") = "~'".
  	END.
        /** очевидные исключения, для уменьшения количества симвлов */
        IF INDEX(tmpStr,"RUSSIAN FEDERATION, ") > 0 THEN
            SUBSTRING(tmpStr, INDEX(tmpStr,"RUSSIAN FEDERATION, "), 20, "CHARACTER") = "".
        IF INDEX(tmpStr,"RUSSIA, ") > 0 THEN
            SUBSTRING(tmpStr, INDEX(tmpStr,"RUSSIA, "), 8, "CHARACTER") = "".
        IF INDEX(tmpStr,"643,") > 0 THEN
            SUBSTRING(tmpStr, INDEX(tmpStr,"643,"), 4, "CHARACTER") = "RU/".
        tmpStr2 = "".
        j = INDEX(tmpStr,"=").
        IF tmpStr <> "?" THEN 
            tmpStr2 = ":50F:" + SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 2) + CHR(10).
        REPEAT WHILE INDEX(tmpStr,"~~") <> 0:
            j = INDEX(tmpStr,"~~").
            tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	    IF INDEX(tmpStr,"~~1/") > 0 THEN
		SUBSTRING(tmpStr, INDEX(tmpStr,"~~1/"), 3, "CHARACTER") = ",".
	    j = INDEX(tmpStr,"~~").
            IF j > 35 THEN DO:
		tmpStr2 = tmpStr2 + SUBSTRING(tmpStr, 1, 35) + CHR(10).	
		tmpStr = SUBSTRING(tmpStr, 1, 2) + SUBSTRING(tmpStr, 36, LENGTH(tmpStr) - 35).
	    END.
            IF tmpStr <> "?" THEN tmpStr2 = tmpStr2 + SUBSTRING(tmpStr, 1, INDEX(tmpStr,"~~") - 1) + CHR(10).
        END.
        tmpStr = tmpStr2.
    END.
    DISPLAY tmpStr WITH FRAME fSet.
    SET tmpStr WITH FRAME fSet.
    UpdateSignsEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift50Cor", tmpStr).

  /** Тег 59 */
    tmpStr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift59Cor", "?").
    IF tmpStr = "" OR tmpStr = "?" THEN DO:
	tmpStr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift59", "?").
        /** Обработка строки в удобочитаемый вид */
        tmpStr = CAPS(tmpStr).
        REPEAT WHILE INDEX(tmpStr,"~"") <> 0:
	    SUBSTRING(tmpStr, INDEX(tmpStr,"~""), 1, "CHARACTER") = "~'".
        END.
        REPEAT WHILE INDEX(tmpStr,"~'~'") <> 0:
	    SUBSTRING(tmpStr, INDEX(tmpStr,"~'~'"), 2, "CHARACTER") = "~'".
        END.
        tmpStr2 = "".
        j = INDEX(tmpStr,"=").
        IF tmpStr <> "?" THEN 
            tmpStr2 = ":59:" + SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1) + CHR(10).
        j = INDEX(tmpStr,"~~").
        tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
        j = INDEX(tmpStr,"~~").
        REPEAT WHILE INDEX(tmpStr,"~~") <> 0:
	    j = INDEX(tmpStr,"~~").
	    IF j > 35 THEN DO:
		tmpStr2 = tmpStr2 + SUBSTRING(tmpStr, 1, 35) + CHR(10).	
		tmpStr = SUBSTRING(tmpStr, 36, LENGTH(tmpStr) - 35).
	    END. ELSE DO:
		tmpStr2 = tmpStr2 + SUBSTRING(tmpStr, 1, j - 1) + CHR(10).	
		tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
            END.

	  /*  REPEAT WHILE j > 35:
	        tmpStr2 = tmpStr2 + SUBSTRING(tmpStr, 36, LENGTH(tmpStr) - 35) + CHR(10).
                tmpStr = SUBSTRING(tmpStr, 36, LENGTH(tmpStr) - 35).
            END.
            */    
        END.
	tmpStr = tmpStr2 + tmpStr.
	/* IF tmpStr <> "?" THEN PUT UNFORMATTED SUBSTRING(tmpStr, 1, INDEX(tmpStr,"~~") - 1) SKIP1.*/
    END.
    DISPLAY tmpStr WITH FRAME fSet.
    SET tmpStr WITH FRAME fSet.
    UpdateSignsEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift59Cor", tmpStr).

  /** Тег 70 */
    tmpStr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift70Cor", "?").
    IF tmpStr = "" OR tmpStr = "?" THEN DO:
	tmpStr = GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift70", "?").
        /** Обработка строки в удобочитаемый вид */
        tmpStr = CAPS(tmpStr).
        REPEAT WHILE INDEX(tmpStr,"~"") <> 0:
	    SUBSTRING(tmpStr, INDEX(tmpStr,"~""), 1, "CHARACTER") = "~'".
        END.
        REPEAT WHILE INDEX(tmpStr,"~'~'") <> 0:
	    SUBSTRING(tmpStr, INDEX(tmpStr,"~'~'"), 2, "CHARACTER") = "~'".
        END.
        tmpStr2 = "".
        j = INDEX(tmpStr,"=").
        IF tmpStr <> "?" THEN 
            tmpStr = ":70:" + SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
        REPEAT WHILE LENGTH(tmpStr) > 35:
	    tmpStr2 = tmpStr2 + SUBSTRING(tmpStr, 1, 35) + CHR(10).	
	    tmpStr = SUBSTRING(tmpStr, 36, LENGTH(tmpStr) - 35).
        END.
	tmpStr = tmpStr2 + tmpStr.
    END.
    DISPLAY tmpStr WITH FRAME fSet.
    SET tmpStr WITH FRAME fSet.
    UpdateSignsEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", "pirSwift70Cor", tmpStr).


pause 0.

END.



				

