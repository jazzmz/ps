CLASS TTableFast IMPLEMENTS ITplElement:
/**********************************************
 * Для для вывода таблицы в разных форматах    *
***********************************************/
DEF PROTECTED VAR hTBuffer AS HANDLE.

DEF PRIVATE VAR iCurrField AS INTEGER INITIAL 1.


DEF PRIVATE VAR itabWidth AS INTEGER INITIAL 0 LABEL "Ширина таблицы, без учета разделителей".
DEF PRIVATE VAR ccolsHeaderList AS CHARACTER INITIAL "" LABEL "Заголовки столбцов через запятую".
DEF PRIVATE VAR crowsHeaderList AS CHARACTER INITIAL "" LABEL "Заголовки строк через запятую".



DEF PROTECTED VAR icolWidthByDef AS INTEGER INITIAL 1 LABEL "Ширина столбца по-умолчанию".

DEF PROTECTED VAR isInTpl AS LOGICAL INITIAL false LABEL "Указывает используется ли компонент в шаблонизаторе".

DEF PROTECTED VAR aColsWidth AS INTEGER EXTENT LABEL "Массив с шириной столбцов. Вычисляется как максимальное по длине значение поля".

DEF PRIVATE VAR aColsName AS CHARACTER EXTENT LABEL "Наименование столбцов".

DEF PROTECTED VAR iRow0Width AS INTEGER INITIAL 0  LABEL "Ширина заголовка строк".

{set-prop.i &aa="inTableHandle" &bb="hTTable" &cc="HANDLE" permv="PROTECTED" perms="PROTECTED"}

{set-prop.i &aa="colsCount" &bb="iColsCount" &cc="INTEGER" &perms="PRIVATE"}	/* Устанавливает количество столбцов таблицы */
{set-prop.i &aa="InnerBorder" &bb="linnerBorder" &cc="LOGICAL" &init = "true"}		/* Внутренние рамки: ДА, НЕТ				*/
{set-prop.i &aa="colsWidthList" &bb="ccolsWidthList" &cc="CHARACTER"}			/* Ширина столбцов через запятую*/
{set-prop.i &aa="colsAlignList" &bb="ccolsAlignLis" &cc="CHARACTER"}			/* Выравнивание в ячейках по ширине, через запятую */
{set-prop.i &aa="height" &bb="itabHeight" &cc="INTEGER" &perms="PROTECTED"}	/* Высота таблицы */
{set-prop.i &aa="wordwrap" &bb="lisWW" &cc="LOGICAL" &init = "true"}				/* Разбивать по словам */

/* Список с именами заголовков */
DEFINE PROPERTY colsHeaderList AS CHARACTER
	GET:
		RETURN ccolsHeaderList.
	END GET.

	SET (INPUT cProp AS CHARACTER):
		DEFINE VARIABLE i AS INTEGER.		

		 DO i = 1 TO  NUM-ENTRIES(cProp):
					aColsWidth[i] = MAXIMUM(aColsWidth[i],LENGTH(ENTRY(i,cProp))).
		 END.

		ccolsHeaderList = cProp.
	END SET.

/* Список с именами заголовков строк */
DEFINE PROPERTY rowsHeaderList AS CHARACTER
	GET:
		RETURN crowsHeaderList.
	END GET.

	SET (INPUT cProp AS CHARACTER):
		DEF VAR i AS INTEGER.
		DO i = 1 TO NUM-ENTRIES(cProp):
			iRow0Width = MAXIMUM(iRow0Width,LENGTH(ENTRY(i,cProp))).
		END.
		crowsHeaderList = cProp.
	END SET.




/* Ширина таблицы */
DEFINE PROPERTY width AS INTEGER
	GET:	
		DEFINE VARIABLE i AS INTEGER.
		DEFINE VARIABLE tmpWidth AS INTEGER.

		DO i = 1 TO ColsCount:
			tmpWidth = tmpWidth + getColWidth(i).
		END.
		RETURN tmpWidth.
	END GET.
       PRIVATE SET (INPUT cProp AS INTEGER):
		itabWidth = cProp.
	END SET.

/* Высота таблицы */




METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL):
	IsInTpl = cProp.
END METHOD.

CONSTRUCTOR TTableFast():
END CONSTRUCTOR.
CONSTRUCTOR TTableFast(INPUT iCols AS INTEGER):
createTable(iCols).
END CONSTRUCTOR.

METHOD PROTECTED VOID createTable(INPUT iCols AS INTEGER):
		/*********************************************************************
		 *												       *
		 * 1. Заполняем внутренние свойства по-умолчанию.	       *
		 * 2. Создаем внутреннюю таблицу;					       *
		 * Создаем таблицу. Для ее создания необходимо	               *
		 * количество столбцов.							               *
		 *												       *
		 *********************************************************************/
		DEFINE VARIABLE i AS INTEGER.

		 ColsCount = iCols.
		
		 EXTENT(aColsWidth) = ColsCount.		/* Задаем количество столбцов для массива ширины */
		 EXTENT(aColsName) = ColsCount.       		/* Задаем внутреннее наименование столбцов            */

		 DO i = 1 TO ColsCount:
			aColsWidth[i] = icolWidthByDef.		/* Заполняем значением по-умолчанию */
			aColsName[i] = "field" + STRING(i).	/* Если иное не оговорено, то столбцы именются field<номер> */
	 	 END.

  	         CREATE TEMP-TABLE hTTable.

		DO i = 1 TO ColsCount:
			hTTable:ADD-NEW-FIELD(getColName(i),"CHARACTER").
        	END.
	   hTTable:TEMP-TABLE-PREPARE("hTTable").
	   hTBuffer = hTTable:DEFAULT-BUFFER-HANDLE.

END METHOD.


METHOD PROTECTED CHARACTER getColName(INPUT i AS INTEGER):
						/**********************************************************
						 * 										      *
						 * Возвращает внутренее наименование столбца    *
						 *										       *
						***********************************************************/
		RETURN aColsName[i].

END METHOD.

METHOD PROTECTED CHARACTER getColHeader(INPUT i AS INTEGER):
					/*********************************************************
					 * 										    *
					 * Возвращает заголовок столбца с номером i	    *
					 *										    *
					 *********************************************************/

	IF i <=  NUM-ENTRIES(colsHeaderList) THEN
		DO:
			IF ENTRY(i,colsHeaderList) <> "" THEN RETURN ENTRY(i,colsHeaderList).
		END.
   RETURN "".
END METHOD.

METHOD PROTECTED CHARACTER getRowHeader(INPUT i AS INTEGER):
					/*********************************************************
					 * 										    *
					 * Возвращает заголовок столбца с номером i	    *
					 *										    *
					 *********************************************************/

	IF i <=  NUM-ENTRIES(rowsHeaderList) THEN
		DO:
			IF ENTRY(i,rowsHeaderList) <> "" THEN RETURN ENTRY(i,rowsHeaderList).
		END.
   RETURN "".
END METHOD.

METHOD PROTECTED CHARACTER getColAlign(INPUT i AS INTEGER):
					/**************************************************************
					 * 										            *
					 * Возвращает выравнивание в столбце с номером i	    *
					 *										            *
					 *************************************************************/

	IF i <=  NUM-ENTRIES(colsAlignList) THEN
		DO:
			IF ENTRY(i,colsAlignList) <> "" THEN RETURN ENTRY(i,colsAlignList).
		END.
   RETURN "".
END METHOD.

METHOD PROTECTED INTEGER getColWidth(INPUT i AS INTEGER):
					/*********************************************************
					 * 										    *
					 * Возвращает ширину столбца с номером i	    *
					 *										    *
					 *********************************************************/
IF i <=  NUM-ENTRIES(colsWidthList) THEN
    DO:
	        IF ENTRY(i,colsWidthList) <> ""  THEN RETURN INTEGER(ENTRY(i,colsWidthList)).
    END.
  RETURN aColsWidth[i].
END METHOD.

METHOD PUBLIC VOID addRow():
				     /*******************************************
				      *								     *
				      * Добавляет строку к таблице	     *
				      *								     *
				      *******************************************/
	hTBuffer:BUFFER-CREATE().
	iCurrField = 1.
	height = height + 1.

END METHOD.


METHOD PUBLIC VOID addCell(INPUT cValue AS CHARACTER):
				    /**********************************************
				     *									 *
				     * Добавляет ячейку к строке таблицы     *
				     *									 *
				     ***********************************************/
	IF cValue EQ ? THEN cValue = "".

	hTBuffer:BUFFER-FIELD(getColName(iCurrField)):BUFFER-VALUE = cValue.
	aColsWidth[iCurrField] = MAXIMUM(LENGTH(cValue),aColsWidth[iCurrField]).
	iCurrField = iCurrField + 1.
END METHOD.

METHOD PUBLIC VOID addCell(INPUT dValue AS DECIMAL):
				    /**********************************************
				     *									 		    *
				     * Добавляет ячейку к строке таблицы     		    *
				     *									 		    *
				     ***********************************************/
	addCell(STRING(dValue)).
END METHOD.

METHOD PUBLIC VOID addCell(INPUT iValue AS INTEGER):
				    /**********************************************
				     *									 		    *
				     * Добавляет ячейку к строке таблицы     		    *
				     *									 		    *
				     ***********************************************/
	addCell(STRING(iValue)).
END METHOD.

METHOD PUBLIC VOID addCell(INPUT daValue AS DATE):
				    /**********************************************
				     *									 		    *
				     * Добавляет ячейку к строке таблицы     		    *
				     *									 		    *
				     ***********************************************/
addCell(STRING(daValue)).
END METHOD.

METHOD PROTECTED VOID showInnerLine():
				/***************************************************
				 *									    *
				 * Рисует внутренню строку таблицы		    *
				 *									    *
				 ***************************************************/
	DEF VAR iLength AS INTEGER.
	iLength = width + ColsCount + iRow0Width.
	IF iRow0Width = 0 THEN iLength = iLength - 1.
	PUT UNFORMATTED "║" FILL("-",iLength) "║" SKIP.
END METHOD.

METHOD PROTECTED VOID showOuterLine(INPUT lPutSkip AS LOGICAL):
				/***************************************************
				 *									    			    *
				 * Рисует внешную строку таблицы		    		    *
				 *									    			    *
				 ***************************************************/
	DEF VAR iLength AS INTEGER.
	iLength = width + ColsCount + iRow0Width.
	IF iRow0Width = 0 THEN iLength = iLength - 1.

	PUT UNFORMATTED "║" FILL("═",iLength) "║".
	IF lPutSkip THEN PUT UNFORMATTED SKIP.
END METHOD.

METHOD PRIVATE VOID showRow(INPUT iRow AS INTEGER):
				/***************************************************
				 *									    *
				 * Метод рисует на экране строку таблицы     *
				 *									    *
				 ****************************************************/
	DEF VAR i AS INTEGER.
	DEF VAR j AS INTEGER.

	DEF VAR maxHeight AS INTEGER INITIAL 1.
	DEF VAR oCharacter AS TCharacter.

	/* 
		Возможны два варианта рисования:
		1. Указана опция переносить по словам;
		2. По словам не переносим, то есть либо обрезаем, либо подбираем ширину
			Для первого случая алгоритм вывода состоит из двух шагов
				1.  На первом шаге определяем максимальную по высоте фразу;
				2. На втором шаге выводим построчно строку.
			Для второго случая алгоритм состоит только из второго шага.
	*/
	IF wordwrap THEN
		DO:
			/* Определяем высоту фразы */
			DO i = 1 TO ColsCount:
				oCharacter = new TCharacter(hTBuffer:BUFFER-FIELD(getColName(i)):BUFFER-VALUE).
				   oCharacter:align = getColAlign(i).
		  	           oCharacter:width = getColWidth(i).
				   maxHeight = MAXIMUM(maxHeight,oCharacter:height).
				DELETE OBJECT oCharacter.				
			END.
		END.

	DO j = 1 TO maxHeight:
		/* По всем строкам фразы */
		/* Начало линии */
			PUT UNFORMATTED "║".
			/* Здесь рисуем заголовок строк */
			IF iRow0Width <> 0 THEN
			  DO:
				oCharacter = new TCharacter(getRowHeader(iRow + 1)).
				      oCharacter:align = "center".
				      oCharacter:width = iRow0Width.
				      oCharacter:show(j).			   
			        DELETE OBJECT oCharacter.
				IF  i <> ColsCount  	THEN PUT UNFORMATTED "|".
			  END.
		 
		DO i = 1 TO  ColsCount: 
			oCharacter = new TCharacter(hTBuffer:BUFFER-FIELD(getColName(i)):BUFFER-VALUE).
			      oCharacter:align = getColAlign(i).
			      oCharacter:width = getColWidth(i).
			      oCharacter:show(j).			   
			     DELETE OBJECT oCharacter.

		    	IF InnerBorder THEN 
						DO:
							IF  i <> ColsCount  	THEN PUT UNFORMATTED "|".
						END.
						ELSE IF i <> ColsCount THEN PUT UNFORMATTED " ".
		END. /* Конец по столбцам */
	 PUT UNFORMATTED "║" SKIP.
	  PUT UNFORMATTED SKIP.
        END. /* Конец по строкам фраз, то есть конец строки */

END METHOD.

METHOD PUBLIC VOID show():
			/********************************************
			 *								 *
			 * Рисует таблицу					 *
			 *								 *
			 ********************************************/
   DEFINE VARIABLE hQuery AS HANDLE.
   DEFINE VARIABLE i AS INTEGER.
   DEFINE VARIABLE iRowAI AS INTEGER INITIAL 1 LABEL "Счетчик выводимых строк".
   DEFINE VARIABLE oCharacter AS TCharacter.

/******************* РИСУЕМ ЗАГОЛОВОК   ***********************/
showOuterLine(true).
IF colsHeaderList <> "" THEN
 DO:
   PUT UNFORMATTED "║".
   IF iRow0Width <> 0 THEN 
		DO:
		      oCharacter = new TCharacter(getRowHeader(1)).
		      oCharacter:align = "center".
		     oCharacter:width = iRow0Width.
		     oCharacter:show().
	        DELETE OBJECT oCharacter.
		 PUT UNFORMATTED "║".
		END.
   DO i = 1 TO ColsCount:
	oCharacter = new TCharacter(getColHeader(i)).
	 oCharacter:align = "LEFT".
	 oCharacter:width = getColWidth(i).
         oCharacter:show().
        DELETE OBJECT oCharacter.
	PUT UNFORMATTED "║".
   END.
PUT UNFORMATTED SKIP.
showOuterLine(true).
END.

/*************************  РИСУЕМ ОСНОВНУЮ ЧАСТЬ		******************************/
  /* Выводим на экран таблицу */
   CREATE QUERY hQuery.
   hQuery:SET-BUFFERS(hTBuffer).
   hQuery:QUERY-PREPARE("FOR EACH hTTable").

   hQuery:QUERY-OPEN().

	        hQuery:GET-FIRST(NO-LOCK).

		REPEAT WHILE NOT hQuery:QUERY-OFF-END:
		IF InnerBorder AND iRowAI <> 1 THEN showInnerLine().		/* Не первая линия */
		         showRow(iRowAI).
		hQuery:GET-NEXT(NO-LOCK).
		iRowAI = iRowAI + 1.
		END. /* По всем строкам таблицы */
	     hQuery:QUERY-CLOSE().
	showOuterLine(NOT isInTpl).
DELETE OBJECT hQuery.
END METHOD.

METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHARACTER,INPUT cPropertyValue AS CHARACTER):
	CASE cPropertyName:
		WHEN "colsHeaderList" THEN colsHeaderList = cPropertyValue.
		WHEN "colsWidthList"	  THEN colsWidthList = cPropertyValue.
		WHEN "colsAlignList"	  THEN colsAlignList = cPropertyValue.
		WHEN "InnerBorder"	  THEN InnerBorder = LOGICAL(cPropertyValue).
		WHEN "wordwrap"		  THEN wordwrap = LOGICAL(cPropertyValue).
		WHEN "rowsHeaderList"  THEN rowsHeaderList = cPropertyValue.
	END CASE.
END METHOD.
METHOD PUBLIC CHAR getProperty(INPUT cPropertyName AS CHAR):
return "".
END METHOD.

METHOD PUBLIC LOGICAL COPY-TO(INPUT-OUTPUT hHandle AS HANDLE,INPUT cTableName AS CHARACTER):
						/*************************************************
						 *									                         *
						 * Метод копирует внутреннее содержимое 			 *
						 * в Dynamic TEMP-TABLE по указателю hHandle	 *
						 *												 *
						 *************************************************/

			DEF VAR hQuery AS HANDLE.
			DEF VAR hTTable AS HANDLE.

	/* Создаем таблицу по указателю с точно таким же определением, как у внутреннего представления */
	CREATE TEMP-TABLE hHandle.
	hHandle:CREATE-LIKE(inTableHandle).
	hHandle:TEMP-TABLE-PREPARE(cTableName).

	hTTable = inTableHandle.

   CREATE QUERY hQuery.
   hQuery:SET-BUFFERS(hTTable:DEFAULT-BUFFER-HANDLE).
   hQuery:QUERY-PREPARE("FOR EACH hTTable").
    hQuery:QUERY-OPEN().       
    hQuery:GET-FIRST().
       REPEAT WHILE NOT hQuery:QUERY-OFF-END:         
          hHandle:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
          hHandle:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(hTTable:DEFAULT-BUFFER-HANDLE).
          hQuery:GET-NEXT().
       END.

     hTTable = ?.
END METHOD.

METHOD PUBLIC VOID SAVE-TO(INPUT cFileName AS CHARACTER):
					/**************************************************
					 *												   *
					 * Метод сохраняет таблицу в указанный файл		   *
					 * Переопределяется в классах наследниках		   *
					 *												   *
					 **************************************************/

END METHOD.

DESTRUCTOR PUBLIC TTableFast():
/* EMPTY TEMP-TABLE hTTable. */
 DELETE OBJECT hTTable.
END DESTRUCTOR.

END CLASS.