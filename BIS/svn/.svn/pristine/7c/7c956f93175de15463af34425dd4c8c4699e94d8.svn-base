 USING Progress.Lang.*.

CLASS TTable IMPLEMENTS ITplElement:
/**********************************************
 * Для для вывода таблицы в разных форматах    *
***********************************************/
DEF PROTECTED VAR hTBuffer AS HANDLE  NO-UNDO.
DEF PROTECTED VAR oItog    AS TAArray NO-UNDO.

/********************************************  ВНУТРЕННЯЯ ТАБЛИЦА **************************************/

DEF PROTECTED TEMP-TABLE ttCellBuffer NO-UNDO
                                 FIELD x-beg AS INTEGER
                                 FIELD y-beg AS INTEGER
                                 FIELD x-end AS INTEGER
                                 FIELD y-end AS INTEGER
                                 FIELD TableCell AS CLASS OBJECT
                 		 FIELD cDataFormat AS CHARACTER INITIAL "CHARACTER"
                                . 		 
/****************************************** КОНЕЦ ВНУТРЕННЕЙ ТАБЛИЦЫ ******************************/

DEF PRIVATE VAR iCurrField AS INTEGER INITIAL 1 NO-UNDO.


DEF PRIVATE VAR itabWidth AS INTEGER INITIAL 0 LABEL "Ширина таблицы, без учета разделителей"          NO-UNDO.
DEF PRIVATE VAR ccolsHeaderList AS CHARACTER INITIAL "" LABEL "Заголовки столбцов через запятую"       NO-UNDO.
DEF PRIVATE VAR crowsHeaderList AS CHARACTER INITIAL "" LABEL "Заголовки строк через запятую"          NO-UNDO.
DEF PRIVATE VAR ccolsFormatList AS CHARACTER INITIAL "" LABEL "Форматирование столбцов через запятую"  NO-UNDO.


DEF PROTECTED VAR icolWidthByDef AS INTEGER INITIAL 1 LABEL "Ширина столбца по-умолчанию"  NO-UNDO.

DEF PROTECTED VAR isInTpl AS LOGICAL INITIAL false LABEL "Указывает используется ли компонент в шаблонизаторе"  NO-UNDO.

DEF PROTECTED VAR aColsWidth AS INTEGER EXTENT LABEL "Массив с шириной столбцов. Вычисляется как максимальное по длине значение поля"  NO-UNDO.
DEF PRIVATE VAR aColsName AS CHARACTER EXTENT LABEL "Наименование столбцов"  NO-UNDO.
DEF PRIVATE VAR aRowHeight AS INTEGER EXTENT LABEL "Высота строк"  NO-UNDO.

/****** С форматами очень узкое место !!! ЭТО НАДО БУДЕТ ПЕРЕДЕЛЫВАТЬ !!! ***********/
DEF PRIVATE VAR aColsFormat AS CHARACTER EXTENT LABEL "Формат столбца"  NO-UNDO.

DEF PROTECTED VAR iRow0Width AS INTEGER INITIAL 0  LABEL "Ширина заголовка строк"  NO-UNDO.

{set-prop.i &aa="inTableHandle" &bb="hTTable" &cc="HANDLE" permv="PROTECTED" perms="PROTECTED"}

{set-prop.i &aa="colsCount" &bb="iColsCount" &cc="INTEGER" &perms="PRIVATE"}                 /* Устанавливает количество столбцов таблицы */
{set-prop.i &aa="InnerBorder" &bb="linnerBorder" &cc="LOGICAL" &init = "true"}                     /* Внутренние рамки: ДА, НЕТ        */

{set-prop.i &aa="colsWidthList" &bb="ccolsWidthList" &cc="CHARACTER"}                                     /* Ширина столбцов через запятую*/



{set-prop.i &aa="colsAlignList" &bb="ccolsAlignLis" &cc="CHARACTER"}                                         /* Выравнивание в ячейках по ширине, через запятую */
{set-prop.i &aa="height" &bb="itabHeight" &cc="INTEGER" &perms="PROTECTED"}                 /* Высота таблицы */
{set-prop.i &aa="currRow" &bb="icurrRow"  &cc="INTEGER" &perms="PROTECTED"}        /* Текущая строка в которую производится вставка ячеек */

{set-prop.i &aa="breakon" &bb="ibreakon" &cc="INTEGER"}                                     /* кол-во строк после которого разрыв страницы*/

{set-prop.i &aa="breakonRows" &bb="ibreakonRows" &cc="INTEGER"}                                     /* кол-во строк после которого разрыв страницы*/
{set-prop.i &aa="lastpageRows" &bb="ilastpageRows" &cc="INTEGER"}                                     /* кол-во которые должны остаться на последней странице*/

{set-prop.i &aa="wordwrap" &bb="lisWW" &cc="LOGICAL" &init = "true"}                                        /* Разбивать по словам */
{set-prop.i &aa="isInit"         &bb="lisInit"   &cc="LOGICAL"  &init="false"}                                       /* Таблица инициализированна? */
{set-prop.i &aa="decFormat"         &bb="cDecFormat"   &cc="CHARACTER"}                                           /* Формат действительных чисел (глобальный) */

{set-prop.i &aa="showItog" &bb="lshowItog" &cc="LOGICAL" &init="false"}
/* Список форматирования столбцов */

{set-prop.i &aa="colsVisibleList" &bb="cColsVisibleList" &cc="CHARACTER"}

DEF PROPERTY colsFormatList AS CHARACTER
     GET:
            RETURN ccolsFormatList.
     END GET.
SET (INPUT cProp AS CHARACTER):

          /*************************************************************
           *                                                                                                                    *
           * Фактически заголовок таблицы это первая строка,                      *
           * поэтому добавляем первую строку  в таблицу                                *
           * значениями из списка                                                                           *
           *                                                                                                                    *
           *************************************************************/
          DEF VAR i AS INTEGER  NO-UNDO.
          DEF VAR  colFormat AS CHARACTER  NO-UNDO.

          IF NUM-ENTRIES(cProp,"|"  ) GT 0 THEN               DO:
                        DO i = 1 TO colsCount:
                                            IF ENTRY (i,cProp,"|") <> "" THEN aColsFormat[i] = ENTRY(i,cProp,"|").
                        END.
               END.
 END SET.

/* Список с именами заголовков */
DEF PROPERTY colsHeaderList AS CHARACTER
        GET:
                RETURN ccolsHeaderList.
        END GET.

        SET (INPUT cProp AS CHARACTER):

          /*************************************************************
           *                                                                                                                    *
           * Фактически заголовок таблицы это первая строка,                      *
           * поэтому добавляем первую строку  в таблицу                                *
           * значениями из списка                                                                           *
           *                                                                                                                    *
           *************************************************************/
          DEF VAR  i       AS INTEGER    NO-UNDO.
          DEF VAR  colHead AS CHARACTER  NO-UNDO.

          IF NUM-ENTRIES(cProp) GT 0 THEN
               DO:
                        addRow(1).
                        DO i = 1 TO colsCount:
                              colHead = ENTRY(i,cProp) NO-ERROR. /* Интересный язык ABL. 
                                                                              Предположим, что список состоит 
                                                                               из одного значения. 
                                                                               Тогда при i = 2 ENTRY не перезапишет colHead
                                                                                и colHead сохранит предыдущее значениею
                                                                                Поэтому необходимо обнулить colHead, что мы и делаем ниже
                                                                           */
                              IF colHead NE ? THEN addCell(ENTRY(i,cProp)). /*ELSE addCell("").                              */
                              colHead = ?.        
                        END.
               END.
 END SET.

/* Список с именами заголовков строк */
DEFINE PROPERTY rowsHeaderList AS CHARACTER
        GET:
                RETURN crowsHeaderList.
        END GET.

        SET (INPUT cProp AS CHARACTER):
                DEF VAR i AS INTEGER  NO-UNDO.
                DO i = 1 TO NUM-ENTRIES(cProp):
                        iRow0Width = MAXIMUM(iRow0Width,LENGTH(ENTRY(i,cProp))).
                END.
                crowsHeaderList = cProp.
        END SET.


/* Ширина таблицы */
DEFINE PROPERTY width AS INTEGER
        GET:        
                DEF VAR i        AS INTEGER  NO-UNDO.
                DEF VAR tmpWidth AS INTEGER  NO-UNDO.

                DO i = 1 TO ColsCount:
                        tmpWidth = tmpWidth + getColWidth(i).
                END.
                RETURN tmpWidth.
        END GET.
       PRIVATE SET (INPUT cProp AS INTEGER):
                itabWidth = cProp.
        END SET.


METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL):
        IsInTpl = cProp.
END METHOD.

CONSTRUCTOR TTable():

                                /*********************************************************
                                 *                                                                                                                 *
                                 * Пустой конструктор.                                                                  *
                                 * Может пригодиться в классах наследниках.      *
                                 *                                                                                                                 *
                                 **********************************************************/

END CONSTRUCTOR.

CONSTRUCTOR TTable(INPUT iCols AS INT):
                                /*********************************************************
                                 *                                                                                     *
                                 * Создаем таблицу по количеству столбцов.            *
                                 *                                                                                      *
                                 *********************************************************/
createTable(iCols).
END CONSTRUCTOR.

CONSTRUCTOR TTable(INPUT iCols AS INT64):
 createTable(iCols).
END CONSTRUCTOR.


METHOD PROTECTED VOID createTable(INPUT iCols AS INT64):
                /*********************************************************************
                 *                                                                                                                                        *
                 * 1. Заполняем внутренние свойства по-умолчанию.                  *
                 * 2. Создаем внутреннюю таблицу;                                                       *
                 * Создаем таблицу. Для ее создания необходимо                  *
                 * количество столбцов.                                                                                      *
                 *                                                                                                                                        *
                 *********************************************************************/
                DEF VAR i AS INTEGER NO-UNDO.

		oItog = new TAArray().

		DO i=1 TO iCols:
		  oItog:setH("f" + STRING(i),0).
                  colsVisibleList = colsVisibleList + "1" + ",".
                END.

                colsVisibleList=TRIM(colsVisibleList,",").

                IF NOT isInit THEN
                    DO:
                         /*
                                Таблица еще не инициализированна.
                                Инициализируем ее
                         */
                         ColsCount = iCols.
                
                         EXTENT(aColsWidth) = ColsCount.                /* Задаем количество столбцов для массива ширины */
             EXTENT(aColsFormat) = ColsCount.    /* Задаем кол-во столбцов формата */

                         DO i = 1 TO ColsCount:
                            /*********** ИНИЦИАЛИЗИРУЕМ МАССИВ ***************/
                                aColsWidth[i] = icolWidthByDef.                
                aColsFormat[i] = ?.
                          END.
        
                        isInit = TRUE.
                  END.
END METHOD.


METHOD PROTECTED INTEGER getColWidth(INPUT i AS INTEGER):
                                        /*********************************************************
                                         *                                                                                                                  *
                                         * Возвращает ширину столбца с номером i                *
                                         *                                                                                                                 *
                                         *********************************************************/

IF i <=  NUM-ENTRIES(colsWidthList) THEN
    DO:
                IF ENTRY(i,colsWidthList) <> ""  THEN RETURN INTEGER(ENTRY(i,colsWidthList)).
    END.
  RETURN aColsWidth[i].
END METHOD.

/******************* МЕТОДЫ НАПОЛНЕНИЯ ТАБЛИЦЫ ************************/

/**
 * @var CHARACTER cRow  строка по которой будет создана строка
 * @var CHARACTER cDelim строка по которой будет разбиваться
 * @result void
 **/
METHOD PUBLIC VOID addRow(INPUT cRow AS CHARACTER,INPUT cDelim AS CHARACTER):

          DEF VAR i AS INT NO-UNDO.
	
	  addRow().

          DO i = 1 TO NUM-ENTRIES(cRow,cDelim):
		addCell(ENTRY(i,cRow,cDelim)).
          END.

END METHOD.

METHOD PUBLIC VOID addRow():
                                     /*******************************************
                                      *                                                                                      *
                                      * Добавляет строку к таблице               *
                                      *                                                                                      *
                                      *******************************************/
        iCurrField = 1.
        height = height + 1.
     currRow = height.

END METHOD.

METHOD PUBLIC VOID addRow(INPUT iRow AS INTEGER):
                                     /*******************************************
                                      *                                                                                                                *
                                      *         Добавляет строку в позицию iRow             *
                                      * при этом уже существующие строки              *
                                      * смещаются на 1у позицию вниз.                     *
                                      *                                                                                                                    *
                                      *******************************************/
         height = height + 1.
         iCurrField = 1.

         IF iRow <= height THEN
          DO:
                    /* Строка лежит в таблице */
             currRow = iRow.

             FOR EACH ttCellBuffer WHERE y-beg>=iRow:
                     ASSIGN
                             y-beg = y-beg + 1
                             y-end = y-end + 1
                      .
              END. /* Конец сдвиг строк */

              END.    /* Конец если строка < высоты таблицы */
          ELSE
             DO:
                    /* Строка вне таблицы поэтому просто добавляем еще одну */
                    addRow().
             END.

END METHOD.

METHOD PROTECTED VOID addCell(INPUT cValue AS CHARACTER,cType AS CHARACTER):
                                    /***********************************************
                                     *                                                                    *
                                     * Добавляет ячейку к строке таблицы      *
                                      *                                                                          *
                                     ***********************************************/
        DEF VAR tmpTCharacter AS TCharacter NO-UNDO.

    IF cValue EQ ? THEN cValue = "".

        tmpTCharacter = new TCharacter(cValue).

        CREATE ttCellBuffer.

        ASSIGN
                        x-beg = iCurrField
                        y-beg = currRow
                        x-end = x-beg + tmpTCharacter:colspan - 1
                        y-end = y-beg + tmpTCharacter:rowspan - 1
                        TableCell = tmpTCharacter
            cDataFormat = cType
        .

	tmpTCharacter = ?.

	IF cType = "DECIMAL" THEN DO:
		oItog:setH("f" + STRING(iCurrField),DECIMAL(oItog:get("f" + STRING(iCurrField))) + DECIMAL(cValue)).
	END.
        iCurrField = iCurrField + 1.
END METHOD.

METHOD PUBLIC VOID addCell(INPUT cValue AS CHARACTER):
                                    /***********************************************
                                     *                                                                    *
                                     * Добавляет ячейку к строке таблицы      *
                                      *                                                                          *
                                     ***********************************************/
                    addCell(cValue,"CHARACTER").
END METHOD.

METHOD PUBLIC VOID addCell(INPUT dValue AS DECIMAL):
                                    /**********************************************
                                     *                                                                                             *
                                     * Добавляет ячейку к строке таблицы                         *
                                     *                                                                                             *
                                     ***********************************************/
        IF decFormat NE ? AND decFormat NE "" THEN addCell(STRING(dValue,decFormat),"DECIMAL").
                                                                                ELSE addCell(STRING(dValue),"DECIMAL").
END METHOD.

METHOD PUBLIC VOID addCell(INPUT iValue AS INTEGER):
                                    /**********************************************
                                     *                                                                                             *
                                     * Добавляет ячейку к строке таблицы                         *
                                     *                                                                                             *
                                     ***********************************************/
        addCell(STRING(iValue),"INTEGER").
END METHOD.

METHOD PUBLIC VOID addCell(INPUT daValue AS DATE):
                                    /**********************************************
                                     *                                                                                             *
                                     * Добавляет ячейку к строке таблицы                         *
                                     *                                                                                             *
                                     ***********************************************/
addCell(STRING(daValue),"DATE").
END METHOD.

/*****************  КОНЕЦ МЕТОДОВ НАПОЛНЕНИЯ ***********************/

METHOD PUBLIC VOID show():
        DEF VAR oSysClass     AS TSysClass             NO-UNDO.
        DEF VAR oCell         AS TCharacter            NO-UNDO.
        DEF VAR i             AS INTEGER               NO-UNDO.
        DEF VAR j             AS INTEGER               NO-UNDO.
        DEF VAR tempvar       AS INTEGER INITIAL 0     NO-UNDO.
        DEF VAR counter       AS INTEGER INITIAL 0     NO-UNDO.
        DEF VAR counterRows   AS INTEGER INITIAL 0     NO-UNDO.
        DEF VAR tmpWidth      AS INTEGER INITIAL 0     NO-UNDO.
        DEF VAR lastpage      AS LOGICAL INITIAL FALSE NO-UNDO.
        DEF VAR NADO          AS LOGICAL INITIAL FALSE NO-UNDO.
        DEF VAR LastPutedPage AS LOGICAL INITIAL FALSE NO-UNDO.

  IF showItog THEN DO:
	addRow().
	DO i = 1 TO colsCount:
		addCell(oItog:get("f" + STRING(i))).
	END.
  END.

IF height > 0 THEN
     DO:

        /* В таблице есть хоть она строка */

        /* Сделаем пересчет ширины без учета colspan ячеек */
        DO i = 1 TO colsCount:

                FOR EACH ttCellBuffer WHERE ttCellBuffer.x-beg = i:

            /******* НЕПОСРЕДСТВЕННО ВЫВОД ЯЧЕЙКИ ********/

                          IF ttCellBuffer.cDataFormat = "DECIMAL" AND aColsFormat[x-beg] <> ? THEN 
                                        DO:
                                            /* БОЛЕЕ ЖЕСТОКОГО СПОСОБА РАБОТЫ С ФОРМАТАМИ Я НЕ ВИДЕЛ!!!
                                                НАДО ПЕРЕДЕЛЫВАТЬ!!!
                                            */
                                            CAST(TableCell,TCharacter):content = STRING(DECIMAL(CAST(TableCell,TCharacter):content),aColsFormat[x-beg]).
                                         END.

            /************ КОНЕЦ ВЫВОДА ЯЧЕЙКИ **************/

                        IF CAST(ttCellBuffer.TableCell,TCharacter):colspan = 1 THEN tmpWidth = MAXIMUM(tmpWidth,CAST(ttCellBuffer.TableCell,TCharacter):width).
                END.
                aColsWidth[i] = tmpWidth.
                tmpWidth = 0.
        END. /* Конец по всем столбцам */

        EXTENT(aRowHeight) = height NO-ERROR.         /* Зарезервировали место для высоты строк с учетом переноса слов */



        DO i = 1 TO height:
                aRowHeight[i] = 1.
        END.
        
           setColWidth().                                        /* Установили ширину столбцов с учетом colspan */
	
        /* Нашли максимальную высоту для каждой строки с учетом разбиения по словам */
          FOR EACH ttCellBuffer:
                aRowHeight[y-beg] = MAXIMUM(aRowHeight[y-beg],CAST(TableCell,TCharacter):height).
          END.

        /* для того чтобы N последних строк улетало на следующую страницу нужно посчитать скока строк будет всего */
           if ibreakonRows > 0 then ibreakon = ibreakonRows.
           if ibreakonRows > 0 then 
             do:
                counterRows = 0.
                DO i = 1 TO height:
                     DO j = 1 TO aRowHeight[i]:
                     counterRows = counterRows + 1.
                     END.
                END.
                if (counterRows modulo ibreakonRows <> 0) then NADO = YES.                
             end.
        /* посчитали кол-во строк в таблице */





        DO i = 1 TO height:
                                        /* По всем строкам */
                                        /* Производим отрисовку разделителя два строки i */
                        showLine(i,"top").
                        DO j = 1 TO aRowHeight[i]:
                                        /* Учитываем перенос по словам */

                                FOR EACH ttCellBuffer WHERE y-beg = i:
                                         /* Выводим данные */
                        /* !!! ВНИМАНИЕ !!! ЭТИ СТРОЧКИ НЕЛЬЗЯ МЕНЯТЬ МЕСТАМИ !!! */
/*                                                IF ttCellBuffer.x-beg = 1 THEN PUT UNFORMATTED "│". ELSE PUT UNFORMATTED "│".*/

						PUT UNFORMATTED "│".
                                                CAST(TableCell,TCharacter):show(j).

                                 END.
                                counter = counter + 1.
                                PUT UNFORMATTED "│" SKIP.
                         END.
/*                                IF ibreakon > 0 and ibreakon <> (height - 1) then IF (i MODULO ibreakon) = 0 and LastPutedPage = no and NADO then PAGE.*/
                                IF ibreakonRows > 0 and ibreakonRows <> (height - 1) and LastPutedPage = no then IF (counter MODULO ibreakonRows) = 0 and NADO then 
                                   do:                
                                        PAGE.
/*					message "PAGE" VIEW-AS ALERT-BOX.*/
                                        counter = 0.
                                        if NADO = YES then do:
                                           counterRows = counterRows - ibreakonRows.
                                              if lastpage = yes then         LastPutedPage = yes.
                                           if (((counterRows - ibreakonRows) < lastpageRows) or (counterRows - ibreakonRows = 0)) and lastpage = no then 
                                             do:
                                                   DO while (counterRows - ibreakonRows) <= (lastpageRows - 1): ibreakonRows = ibreakonRows - 1. END.
                                                lastpage = yes.
                                             end.
                                        end.
                                   end.             

                        PUT UNFORMATTED SKIP.
                showLine(i,"bottom").
        END.

 END. /* Конец если есть строки */
END METHOD.


METHOD PROTECTED INTEGER getSplitter(INPUT iX AS INTEGER, INPUT iY AS INTEGER):

        DEF BUFFER currTableCell FOR ttCellBuffer.
        DEF BUFFER nearTableCell FOR ttCellBuffer.

        DEF VAR iRes AS INTEGER INITIAL 0 NO-UNDO.
        DEF VAR i    AS INTEGER           NO-UNDO.
        
        
      FIND FIRST currTableCell WHERE x-beg=iX AND y-beg=iY NO-ERROR.

        /* Смотрим слева */
        FIND LAST nearTableCell WHERE nearTableCell.x-beg < iX AND nearTableCell.y-beg = iY NO-ERROR.

                IF AVAILABLE(nearTableCell) THEN IF CAST(nearTableCell.TableCell,TCharacter):top = 1 THEN iRes = iRes + 1.



        /* Смотрим сверху */
        FIND LAST nearTableCell WHERE nearTableCell.x-beg=iX AND nearTableCell.y-beg<iY NO-ERROR.
                IF AVAILABLE(nearTableCell) THEN DO: IF CAST(nearTableCell.TableCell,TCharacter):left = 1 THEN iRes = iRes + 2. END.
                ELSE 
                        DO:
                                FIND LAST nearTableCell WHERE nearTableCell.x-beg<iX AND nearTableCell.y-beg<iY NO-ERROR.
                                IF AVAILABLE(nearTableCell) THEN IF CAST(nearTableCell.TableCell,TCharacter):right = 1 AND nearTableCell.x-end = colsCount THEN iRes = iRes + 2.
                        END.


/* Смотрим границу справа */
                                                                        IF AVAILABLE(currTableCell) THEN IF CAST(currTableCell.TableCell,TCharacter):top = 1 THEN iRes = iRes + 4.

/*
  Смотрим границу снизу 
   Если это последняя ячейка,
   то смотрим границу справа  
*/
                                                                        IF AVAILABLE(currTableCell) THEN DO: IF CAST(currTableCell.TableCell,TCharacter):left = 1 THEN iRes = iRes + 8. END.
                                                                        ELSE
                                                                                DO:
                                                                                        FIND LAST nearTableCell WHERE nearTableCell.x-beg<iX AND nearTableCell.y-beg=iY NO-ERROR.
                                                                                        IF AVAILABLE(nearTableCell) THEN IF CAST(nearTableCell.TableCell,TCharacter):right = 1 THEN iRes = iRes + 8.
                                                                                END.
                                                                                        
                                                                

 RETURN iRes.
END METHOD.

METHOD PROTECTED INTEGER getSplitterDown(INPUT iX AS INTEGER, INPUT iY AS INTEGER):

        DEF BUFFER currTableCell FOR ttCellBuffer.
        DEF BUFFER nearTableCell FOR ttCellBuffer.

        DEF VAR iRes AS INTEGER INITIAL 0 NO-UNDO.
        DEF VAR i    AS INTEGER           NO-UNDO.

      FIND FIRST currTableCell WHERE x-beg=iX AND y-beg=iY NO-ERROR.

        /* Смотрим слева */
        FIND LAST nearTableCell WHERE nearTableCell.x-beg < iX AND nearTableCell.y-beg = iY NO-ERROR.
                IF AVAILABLE(nearTableCell) THEN IF CAST(nearTableCell.TableCell,TCharacter):bottom = 1 THEN  iRes = iRes + 1.

        /* Смотрим сверху */
                IF AVAILABLE(currTableCell) THEN  DO: IF CAST(currTableCell.TableCell,TCharacter):left = 1 THEN iRes = iRes + 2.  END.
                ELSE
                        DO:
                                FIND LAST nearTableCell WHERE nearTableCell.x-beg < iX AND nearTableCell.y-beg < iY NO-ERROR.
                                IF AVAILABLE(nearTableCell) THEN IF CAST(nearTableCell.TableCell,TCharacter):right = 1 THEN iRes = iRes + 2.
                        END.

        /* Смотрим границу справа */
                IF AVAILABLE(currTableCell) THEN IF CAST(currTableCell.TableCell,TCharacter):bottom = 1 THEN iRes = iRes + 4.

        /* Границы снизу никогда не будет, так как это нижняя строка */

 RETURN iRes.
END METHOD.

METHOD PROTECTED CHARACTER getCharByBin(INPUT iCode AS INTEGER):
                                                                        /******************************************************
                                                                         *
                                                                         * Функция преобразует десятичный код
                                                                         *  рамки в знаки для рисования
                                                                         *
                                                                         *******************************************************/
                                                                        CASE iCode:
                                                
                                                                                WHEN 3   THEN RETURN "┘".

                                                                                WHEN 5   THEN RETURN "┬".

                                                                                WHEN 6   THEN RETURN "└".

                                                                                WHEN 7   THEN RETURN "┴".

                                                                                WHEN 9   THEN RETURN "┐".

                                                                                WHEN 11 THEN RETURN "┤".

                                                                                WHEN 10 THEN RETURN "│".
                                                                                WHEN 12 THEN RETURN "┌".
                                                                                WHEN 13 THEN RETURN "┬".
                                                                                WHEN 14 THEN RETURN "├".
                                                                                WHEN 15 THEN RETURN "┼".
                                                                         END CASE.                                                
END METHOD.


METHOD PROTECTED VOID showLine(INPUT iY AS INTEGER,INPUT cType AS CHARACTER):

                                                        /**********************************************************
                                                         *                                                                                   *
                                                         * Метод выполняет рисование горизонтальной      *
                                                         * линии разделителя                                                  *
                                                         *                                                                                    *
                                                         ***********************************************************/
        DEF VAR currSplit AS INTEGER NO-UNDO.

        FOR EACH ttCellBuffer WHERE y-beg = iY BY x-beg:
                IF cType = "top"  THEN 
                                                DO:
                                                        currSplit = getSplitter(x-beg,y-beg).
                                                        PUT UNFORMATTED getCharByBin(currSplit).
                                                        IF CAST(TableCell,TCharacter):top >= 1 THEN PUT UNFORMATTED FILL("─",CAST(TableCell,TCharacter):width). ELSE PUT UNFORMATTED FILL(" ",CAST(TableCell,TCharacter):width).

                                                        IF ttCellBuffer.x-end = colsCount THEN 
                                                        DO:
                                                                /* Для последней ячейки выводим правую границу */
                                                                currSplit = getSplitter(x-beg + 1,y-beg).
                                                                PUT UNFORMATTED getCharByBin(currSplit).
                                                        END.

                                                        END.

                IF cType = "bottom" AND iY = height THEN 
                                                        DO:                                        
                                                                currSplit = getSplitterDown(x-beg,y-beg).                                
                                                        PUT UNFORMATTED getCharByBin(currSplit).
                                                        IF CAST(TableCell,TCharacter):bottom>= 1 THEN PUT UNFORMATTED FILL("─",CAST(TableCell,TCharacter):width). ELSE PUT UNFORMATTED FILL(" ",CAST(TableCell,TCharacter):width).

                                                        IF ttCellBuffer.x-end = colsCount THEN 
                                                        DO:
                                                                currSplit = getSplitterDown(x-beg + 1,y-beg).
                                                                PUT UNFORMATTED getCharByBin(currSplit).
                                                        END.

                                                        END.
        END.
PUT UNFORMATTED SKIP.

END METHOD.

METHOD PROTECTED VOID setColWidth():
                                                /****************************************************
                                                 *                                                                                                          *
                                                 * Метод осуществляет простановку                         *
                                                 * ширины ячеек с учетом colspan.                              *
                                                 * Внимание! Метод должен выполняться                 *
                                                 * в самый последний момент, когда                         *
                                                 * таблица уже сформирована!                                      *
                                                 *                                                                                                          *
                                                 ***************************************************/
        DEF VAR i AS INTEGER NO-UNDO.
        DEF VAR j AS INTEGER NO-UNDO.

        DO i = 1 TO height:
                                /* По всем строкам таблицы */

                FOR EACH ttCellBuffer WHERE ttCellBuffer.y-beg = i:
                                /* По всем столбцам таблицы */
                                ASSIGN CAST(TableCell,TCharacter):width = getColWidth(x-beg).

                        DO j = x-beg + 1 TO x-end:
                                        /* Здесь к ширине столбца прибавляем ширину на которую делается colspan */
                                        CAST(TableCell,TCharacter):width = CAST(TableCell,TCharacter):width + getColWidth(j) + 1.                                
                                        /* Где единица это учет рамки, которой кстати может и не быть, надо исправлять!!! */
                        END.        /* Конец увеличения ширины столбца */

                END.
          END.

END METHOD.

METHOD PUBLIC VOID setColspan(INPUT iX AS INTEGER,INPUT iY AS INTEGER,INPUT colspan AS INTEGER):
                                        /*************************************************
                                         *                                                                                                  *
                                         * Метод устанавливает свойство coslpan   *
                                         * для ячеейки с координатами (iX;iY)                *
                                         * Предполагается, что все ячейки                        *
                                         * лежащие справа от cosplan ячейки                   *
                                         * будут сдвинуты вправо на colspan                    *
                                         * единиц. Если Сумма (ячейка * colspan) >  *
                                         * количес-тво стобцов в таблице, то будет  *
                                         * ошибка.                                                                                *
                                         * Внимание: Не выполнять для одного             *
                                         * столбца setColSpan два раза,                                 *
                                         * будет ошибка! В текущей версии                         *
                                         * это исправлять не буду.                                              *
                                         *                                                                                                     *
                                         *                                                                                                  *
                                         **************************************************/

                FIND FIRST ttCellBuffer WHERE x-beg=iX AND y-beg=iY.        
                ASSIGN 
                                CAST(TableCell,TCharacter):colspan = colspan
                                ttCellBuffer.x-end = ttCellBuffer.x-beg + colspan - 1
                        .

                /* Должны перенести все столбцы вперед на colspan ячеек */
                FOR EACH ttCellBuffer WHERE x-beg > iX AND y-beg = iY:
                                        ttCellBuffer.x-beg = ttCellBuffer.x-beg + colspan - 1.
                                        ttCellBuffer.x-end=ttCellBuffer.x-beg + CAST(TableCell,TCharacter):colspan - 1.
                END.
END METHOD.

METHOD PUBLIC VOID setBorder(INPUT iX AS INTEGER,INPUT iY AS INTEGER,INPUT left AS INTEGER,INPUT top AS INTEGER,INPUT right AS INTEGER,INPUT bottom AS INTEGER):
                                     /******************************************************
                                       *                                                                            *
                                       * Устанавливает границы ячейки.                            *
                                       *                                                                             *
                                       ******************************************************/
                FIND FIRST ttCellBuffer WHERE x-beg=iX AND y-beg=iY.        
                ASSIGN 
                                CAST(TableCell,TCharacter):left = left
                                CAST(TableCell,TCharacter):top = top
                                CAST(TableCell,TCharacter):right = right
                                CAST(TableCell,TCharacter):bottom = bottom
                                .


END METHOD.

METHOD PUBLIC VOID setAlign(INPUT iX AS INTEGER,INPUT iY AS INTEGER,INPUT cAlign AS CHARACTER):
                                  /******************************************************
                                   *                                                                                  *
                                   * Устанавливает выравнивание в ячейке           *
                                   * с координатами (iX;iY)                                           *
                                   *                                                                                  *
                                   *******************************************************/        
                                                                                
                FIND FIRST ttCellBuffer WHERE x-beg=iX AND y-beg=iY.        
                ASSIGN CAST(TableCell,TCharacter):align = cAlign.

END METHOD.

METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHARACTER,INPUT cPropertyValue AS CHARACTER):
        CASE cPropertyName:

                WHEN "colsHeaderList"   THEN colsHeaderList = cPropertyValue.
                WHEN "colsWidthList"    THEN colsWidthList = cPropertyValue.
                WHEN "colsAlignList"    THEN colsAlignList = cPropertyValue.
                WHEN "InnerBorder"      THEN InnerBorder = LOGICAL(cPropertyValue).
                WHEN "wordwrap"         THEN wordwrap = LOGICAL(cPropertyValue).
                WHEN "rowsHeaderList"   THEN rowsHeaderList = cPropertyValue.
                WHEN "breakon"          THEN breakon = integer(cPropertyValue).
                WHEN "breakonRows"      THEN breakonRows = integer(cPropertyValue).
                WHEN "lastpageRows"     THEN lastpageRows = integer(cPropertyValue).
	        WHEN "colspan"          THEN setColSpan(INTEGER(ENTRY(1,cPropertyValue)),INTEGER(ENTRY(2,cPropertyValue)),INTEGER(ENTRY(3,cPropertyValue))).
	        WHEN "align"            THEN setAlign(INTEGER(ENTRY(1,cPropertyValue)),INTEGER(ENTRY(2,cPropertyValue)),ENTRY(3,cPropertyValue)).
	        WHEN "colsFormatList"   THEN colsFormatList=cPropertyValue.
		WHEN "itog"             THEN showItog=TRUE.
		WHEN "colsVisibleList"  THEN colsVisibleList=cPropertyValue.
		WHEN "decFormat"        THEN decFormat=cPropertyValue.
        END CASE.

END METHOD.

METHOD PUBLIC CHAR getProperty(INPUT cPropertyName AS CHAR):
 RETURN "".
END METHOD.



METHOD PUBLIC LOGICAL COPY-TO(INPUT-OUTPUT hHandle AS HANDLE,INPUT cTableName AS CHARACTER):
                                                /*****************************************************************
                                                 *                                                                                                 *
                                                 * Метод копирует внутреннее содержимое                          *
                                                 * в Dynamic TEMP-TABLE по указателю hHandle                 *
                                                 *                                                                                                 *
                                                 *****************************************************************/

END METHOD.


/**
 * Выдампливает внутреннее представление
 * в файл.
 * @var CHAR cFileName Имя XML файла.
 **/
METHOD PUBLIC VOID SAVE-XML(INPUT cFileName AS CHAR):
    TEMP-TABLE ttCellBuffer:WRITE-XML("file",cFileName,YES,?,?,NO,NO).
END METHOD.
    

METHOD PUBLIC VOID SAVE-TO(INPUT cFileName AS CHARACTER):
                                        /********************************************************
                                         *
                                         * Абстрактный метод! Сохраняет данные в файл.
                                         *
                                         ********************************************************/

END METHOD.


DESTRUCTOR PUBLIC TTable():
                                        /**********************************************
                                         * 
                                         * Я тебя породил, я тебя и убью!!!
                                         *
                                          *********************************************/

 DELETE OBJECT oItog NO-ERROR.
 FOR EACH ttCellBuffer:

    DELETE OBJECT ttCellBuffer.TableCell.

 END. /* FOR EACH */

END DESTRUCTOR.

END CLASS.
