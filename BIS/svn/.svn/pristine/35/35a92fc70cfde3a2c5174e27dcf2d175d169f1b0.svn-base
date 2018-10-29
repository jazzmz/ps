USING Progress.Lang.*.
CLASS TSDraw IMPLEMENTS ITableDraw:

{set-prop.i &aa="p" &cc="TTable2"}
{set-prop.i &aa="colsHideList" &cc="CHAR"}


CONSTRUCTOR TSDraw():

END CONSTRUCTOR.

METHOD PUBLIC VOID setParent(INPUT p AS TTable2):
	THIS-OBJECT:p = CAST(p,TTable2).
END METHOD.

METHOD PUBLIC VOID show():

DEF VAR oRow          AS TAArray    NO-UNDO.
DEF VAR key1          AS CHAR       NO-UNDO.
DEF VAR val1          AS CHAR       NO-UNDO.
DEF VAR currColWidth  AS INT        NO-UNDO.
DEF VAR colWidthArray AS INT EXTENT NO-UNDO.
DEF VAR i             AS INT        NO-UNDO.

DEF VAR currLine      AS INT64           NO-UNDO.
DEF VAR currSubLine   AS INT  INIT 1     NO-UNDO.
DEF VAR isLast        AS LOG  INIT FALSE NO-UNDO.
DEF VAR shouldShow    AS CHAR INIT ""    NO-UNDO.
DEF VAR currColumn    AS INT64           NO-UNDO.


colsHideList = THIS-OBJECT:p:getProperty("colsHideList").

/*********************************
 * Теперь столбцы можно скрывать *
 *********************************/

IF colsHideList = ? THEN DO:
   colsHideList = FILL("0",THIS-OBJECT:p:getColCount()).
END.

IF LENGTH(colsHideList) < THIS-OBJECT:p:getColCount() THEN DO:
   colsHideList = colsHideList + FILL("0",THIS-OBJECT:p:getColCount() - LENGTH(colsHideList)).
END.


/**
 * Убираем сплитеры, так как потом
 * с этой строкой будет легче работать.
 **/
colsHideList = REPLACE(colsHideList,",","").




IF NOT (THIS-OBJECT:getColCount() > 0 AND THIS-OBJECT:p:getRowCount() > 0) THEN RETURN.

EXTENT(colWidthArray) = THIS-OBJECT:getColCount().

/*****************************************
 * Запоминаем ширину столбцов в массиве  *
 * для ускорения.                        *
 *****************************************/
DO i = 1 TO THIS-OBJECT:getColCount():
  colWidthArray[i] = INT(THIS-OBJECT:p:getColWidth(i)).
  shouldShow       = shouldShow + "1".
END.


DO i = 1 TO THIS-OBJECT:p:getColCount():
 IF SUBSTRING(colsHideList,i,1) = "1" THEN NEXT.
 currColumn = i - getHideBefore(i).
 PUT UNFORMATTED getTopBorder(currColumn,colWidthArray[currColumn]).
END.

 PUT UNFORMATTED SKIP.

THIS-OBJECT:p:rewind().

/**
 * Коротко алгоритм следующий:
 * 1. До тех пор пока есть строки в таблице считываем следующую строку;
 *    1.1 Затем пока требуется выводить текст;
 *        1.1.1 Устанавливаем подстроку currSubLine в значение 1;
 *        1.1.2 Перебираем все столбцы в строке;
 *             1.1.1.1 Разбиваем значение столбца по ширине;
 *             1.1.1.2 Выводим подстроку currSubLine, получившуюся в результате разбиения
 *             значения стоблца на подстроки;
 *             1.1.1.3 Если в результате разбиения хотя бы в одном из столбце есть еще не нарисованные
 *            строки
 **/

DO WHILE NOT THIS-OBJECT:p:valid():
  oRow = THIS-OBJECT:p:next(OUTPUT currLine). 

  DO WHILE INDEX(shouldShow,"1") > 0:

    {foreach oRow key1 val1}

     IF SUBSTRING(colsHideList,INT64(key1),1) = "1" THEN NEXT.

       currColumn = INT64(key1) - getHideBefore(INT64(key1)).



        currColWidth = colWidthArray[currColumn].

        PUT UNFORMATTED "│" THIS-OBJECT:FSPACE(
                                              wordWrap(val1,currColWidth,currSubLine,OUTPUT isLast),
                                              currColWidth,
                                              (IF currLine = 0 THEN "center" ELSE "right")
                                              ).
        SUBSTRING(shouldShow,currColumn,1) = STRING(INT64(NOT isLast)).
    {endforeach oRow}
    PUT UNFORMATTED "│" SKIP.
    currSubLine = currSubLine + 1.
  END.

  IF NOT THIS-OBJECT:p:valid() THEN DO:

   DO i = 1 TO THIS-OBJECT:p:getColCount():
    IF SUBSTRING(colsHideList,i,1) = "1" THEN NEXT.
    currColumn = i - getHideBefore(i).
    PUT UNFORMATTED getInnerBorder(currColumn,colWidthArray[currColumn]).
   END.
   PUT UNFORMATTED SKIP.

  END.

  currSubLine = 1.
  shouldShow  = FILL("1",THIS-OBJECT:getColCount()).
END. /*  DO WHILE */

DO i = 1 TO THIS-OBJECT:p:getColCount():
 IF SUBSTRING(colsHideList,i,1) = "1" THEN NEXT.
 currColumn = i - getHideBefore(i).
 PUT UNFORMATTED getDownBorder(currColumn,colWidthArray[currColumn]).
END.
 PUT UNFORMATTED SKIP.
END METHOD.




/**
 * @VAR CHAR cStr Исходная строка
 * @VAR INT width  требуемая ширина
 * @VAR CHAR type Тип выравнивания {left,center,right}
 * @RETURN CHAR 
 * Функция заливает
 * строку пробелами,
 * до заданной ширины.
 **/
METHOD PROTECTED CHAR FSPACE(INPUT cStr AS CHAR,INPUT width AS INT,INPUT type AS CHAR):
   DEF VAR diff  AS INT NO-UNDO.
   DEF VAR ldiff AS INT NO-UNDO.

   diff = width - LENGTH(cStr).

  IF diff > 0 THEN DO:
   CASE type:
   WHEN "right" THEN DO:
      cStr = FILL(" ",diff) + cStr.    
   END.
   WHEN "left" THEN DO:
      cStr = cStr + FILL(" ",diff).    
   END.
   WHEN "center" THEN DO:
      ldiff = ROUND(diff / 2,0).
      cStr = FILL(" ",ldiff) + cStr + FILL(" ",diff - ldiff).
   END.
   END CASE.
  END.

 RETURN cStr.
END METHOD.    


METHOD INT calcWordWrap(INPUT cStr AS CHAR,INPUT width AS INT):
    DEF VAR currLine  AS INT INIT 1 NO-UNDO.
    DEF VAR strCount  AS INT INIT 0 NO-UNDO.
    DEF VAR i         AS INT        NO-UNDO.
    DEF VAR lastSpace AS INT        NO-UNDO.
    
    DEF VAR c        AS CHAR NO-UNDO.
    
DO WHILE cStr <> "" AND LENGTH(cStr) > width:
  DO i = 1 TO LENGTH(cStr):
      c = SUBSTRING(cStr,i,1).
      IF c = " " THEN lastSpace = i.
      IF i = width THEN DO:

          IF c = " " OR lastSpace = 0 THEN DO:
              SUBSTRING(cStr,1,i) = "".
              strCount = strCount + 1.
              LEAVE.
          END. /* IF c = "" */ ELSE DO:
              SUBSTRING(cStr,1,lastSpace) = "".
              strCount = strCount + 1.
              LEAVE.
          END.
      END. 
  END.
  currLine = currLine + 1.  
END. /* WHILE */
RETURN strCount.
END METHOD.

METHOD CHAR getInnerBorder(INPUT x AS INT64,INPUT width AS INT):
   DEF VAR leftInner     AS CHAR INIT "├" NO-UNDO.
   DEF VAR rightInner    AS CHAR INIT "┤" NO-UNDO.
   DEF VAR middleInner   AS CHAR INIT "┼" NO-UNDO.
   DEF VAR horizontal    AS CHAR INIT "─" NO-UNDO.

    
    IF THIS-OBJECT:getColCount() = 1 THEN DO:
           RETURN leftInner + FILL(horizontal,width) + rightInner.
    END.

    IF x = 1 THEN DO:
            RETURN leftInner + FILL(horizontal,width) + middleInner.
       END.

    IF x = THIS-OBJECT:getColCount() THEN DO:
           RETURN FILL(horizontal,width) + rightInner.
    END.

    RETURN FILL(horizontal,width) + middleInner.
END METHOD.

METHOD CHAR getDownBorder(INPUT x AS INT64,INPUT width AS INT):
   DEF VAR leftDown     AS CHAR INIT "└" NO-UNDO.
   DEF VAR rightDown    AS CHAR INIT "┘" NO-UNDO.
   DEF VAR middleDown   AS CHAR INIT "┴" NO-UNDO.
   DEF VAR horizontal AS CHAR INIT "─" NO-UNDO.

    /**
     * Если таблица вырожденная в один столбец.
     **/
    IF THIS-OBJECT:getColCount() = 1 THEN DO:
           RETURN leftDown + FILL(horizontal,width) + rightDown.
    END.

    IF x = 1 THEN DO:
            RETURN leftDown + FILL(horizontal,width) + middleDown.
       END.

    IF x = THIS-OBJECT:getColCount() THEN DO:
           RETURN FILL(horizontal,width) + rightDown.
    END.

    RETURN FILL(horizontal,width) + middleDown.
      
END METHOD.

METHOD CHAR getTopBorder(INPUT x AS INT64,INPUT width AS INT):
   DEF VAR leftTop     AS CHAR INIT "┌" NO-UNDO.
   DEF VAR rightTop    AS CHAR INIT "┐" NO-UNDO.
   DEF VAR middleTop   AS CHAR INIT "┬" NO-UNDO.
   DEF VAR horizontal  AS CHAR INIT "─" NO-UNDO.

    /**
     * Если таблица вырожденная в один столбец.
     **/
    IF THIS-OBJECT:getColCount() = 1 THEN DO:
           RETURN leftTop + FILL(horizontal,width) + rightTop.
    END.

    IF x = 1 THEN DO:
            RETURN leftTop + FILL(horizontal,width) + middleTop.
       END.

    IF x = THIS-OBJECT:getColCount() THEN DO:
           RETURN FILL(horizontal,width) + rightTop.
    END.

    RETURN FILL(horizontal,width) + middleTop.
      
END METHOD.

METHOD PUBLIC CHAR wordWrap(INPUT content AS CHAR,INPUT width AS INT,INPUT iCurrLine AS INT,OUTPUT isLast AS LOG):
					/********************************************************************************
					 *                                                                             *
					 * Дано:								       *
					 * Задана фраза F шириной WF состоящая из слов неизвестной		       *
					 * длины. Известно, что слова разделяются пробелами. 			       *
					 * Известна ширина рамки WB в которой будет размещаться фраза.                 *
					 * WB < = WF								       *
					 * Найти:								       *
					 * Разбиение фразы F на подстроки Fn шириной WB, так, чтобы		       *
					 *  слова разбивались на строки только в случае, когда ширина 	 	       *
					 * слова заведомо больше ширины рамки.					       *
					 ********************************************************************************
					 * 	Перенос по словам в столбце					       *
					 *  Алгоритм:
					 *  1. Фраза F = "" (нечего переносить) => Выход;
					 *  2. Из фразы F выделяем символ CH1 стоящий на позиции = WB (ширина рамки);
					 *    3. CH1 может быть равен:
					 *		3.1 Пробелу, значит в подстроку берем фразу F1 от начала строки до WB;
					 *		3.2 Буква. Это значит либо WB попадает на начало/середину слова или на конец слова,
					 * 			3.3 Чтобы определить где находиться CH1 по отношению к слову
					 *			      смотрим символ CH2 на позиции WB + 1;
					 *			 3.4 CH2 = букве => это начало/середина слова,
					 * 				Находим последний пробел в фразе F1(начала строки;WB),
					 *				Пробела нет (вот такое длинное слово), то берем фразу F1(начало;WB);
					 *				Пробел есть, то берем фразу  F1(начало;позиция последнего пробела следующего за буквой).
					 * 			  3.5 CH2 = пробел или пусто (конец строки) => берем фразу F1(начало;WB)
					 *     4.  Вырезаем из фразы F фразу F1;
					 *     5. Повторяем алгоритм.
					 *
					 * Жадный алгоритм.
					 *********************************************************************************/
  DEF VAR iLength   AS INT          NO-UNDO.
  DEF VAR tmpStr    AS CHAR         NO-UNDO.
  DEF VAR iStep     AS INT INIT 0   NO-UNDO.
  DEF VAR ch1       AS CHAR         NO-UNDO.
  DEF VAR ch2       AS CHAR         NO-UNDO.	

  DEF VAR oSysClass AS TSysClass    NO-UNDO.
  DEF VAR oStr      AS TAArray      NO-UNDO.
  DEF VAR cRes      AS CHAR         NO-UNDO.

  isLast = FALSE.
  oSysClass = new TSysClass().
  oStr = NEW TAArray().


  tmpStr = TRIM(content). 

  REPEAT WHILE tmpStr <> "":
			      iStep = iStep + 1.
			     tmpStr = LEFT-TRIM(tmpStr).
			     IF width = LENGTH(tmpStr) THEN iLength = width.
			     ELSE
				DO:
			      		ch1 = SUBSTRING(tmpStr,width,1).
			      		IF ch1 = " " THEN iLength = width.
						  	  ELSE
							     DO:
								ch2 = SUBSTRING(tmpStr,width + 1,1).
								IF ch2 = " " THEN iLength = width.
										  ELSE DO:
								                          IF oSysClass:strPos(SUBSTRING(tmpStr,1,width)," ","last") = ? THEN iLength = width.
                                                                                             ELSE DO:
                                                                                                   iLength = oSysClass:strPos(SUBSTRING(tmpStr,1,width)," ","last").
                                                                                             END.
										   END.
							     END.
				  END.
                              oStr:setH(iStep,SUBSTRING(tmpStr,1,iLength)).
                              SUBSTRING(tmpStr,1,iLength) = "".
                        END. /* Конец цикла */

  IF iCurrLine = oStr:length THEN DO:
    isLast = TRUE.
    cRes = oStr:get(iCurrLine).
  END. ELSE DO:
    IF iCurrLine > oStr:length THEN DO:
       isLast = TRUE.
       cRes = "".
    END. ELSE DO:
        isLast = FALSE.
        cRes = oStr:get(iCurrLine).
    END.
  END.
  DELETE OBJECT oSysClass.
  DELETE OBJECT oStr.
 RETURN cRes.
END METHOD.

METHOD CHAR getBorder(INPUT x AS INT,INPUT y AS INT,INPUT isLastChar AS LOG):
END METHOD.

/**
 * Метод выводит количество столбцов
 * в таблице с учетом скрываемых столбцов
 **/
METHOD PROTECTED INT64 getColCount():
 DEF VAR parentColCount  AS INT64 NO-UNDO.
 DEF VAR hideColumnCount AS INT64 NO-UNDO.

 parentColCount   =  THIS-OBJECT:p:getColCount().
 hideColumnCount  =  NUM-ENTRIES(colsHideList,"1") - 1.

 hideColumnCount = IF hideColumnCount < 0 THEN 0 ELSE hideColumnCount.

 RETURN parentColCount - hideColumnCount.

END METHOD.

/**
 * 
 * Возвращает количество
 * скрытых столбцов до указанного.
 * @param INT64 currX
 * @return
 **/
METHOD PROTECTED INT64 getHideBefore(INPUT currX AS INT64):
  RETURN IF NUM-ENTRIES(SUBSTRING(colsHideList,1,currX),"1") - 1 < 0 THEN 0 ELSE NUM-ENTRIES(SUBSTRING(colsHideList,1,currX),"1") - 1.
END METHOD.

END CLASS.