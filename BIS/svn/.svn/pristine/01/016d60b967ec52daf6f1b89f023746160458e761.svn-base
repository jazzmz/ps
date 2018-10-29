CLASS TCharacter IMPLEMENTS ITplElement:

DEFINE PRIVATE VARIABLE isInTpl AS LOGICAL INITIAL false.

DEFINE PRIVATE VARIABLE iWidth AS INTEGER LABEL "Ширина текста".

DEF PRIVATE TEMP-TABLE ttObject2XML
				FIELD cProp AS CHARACTER
				FIELD cValue     AS CHARACTER
			    .

{set-prop.i &aa="colspan"   &bb="iColSpan"   &cc="INTEGER" &init="1"}
{set-prop.i &aa="rowspan"  &bb="iRowSpan" &cc="INTEGER" &init="1"}
{set-prop.i &aa="align"       &bb="cAlign"        &cc="CHARACTER" &init="\"right\""}			  /*Выравнивание текста left|center|right*/
{set-prop.i &aa="height"     &bb="iHeight"      &cc="INTEGER" &init="1"}					              /* Высота ячейки */
{set-prop.i &aa="mode"      &bb="cMode"      &cc="CHARACTER"}                               			 /*Режим отображения upper|lower|normal */

{set-prop.i &aa="x-beg" &bb="cX-beg"  &cc="INTEGER"}
{set-prop.i &aa="x-end" &bb="cX-end"  &cc="INTEGER"}

{set-prop.i &aa="top"	   &bb="iTop"		&cc="INTEGER" &init="1"}					     /* Толщина верхней границы */
{set-prop.i &aa="bottom"	   &bb="iBottom"	&cc="INTEGER" &init="1"}					 /* Толщина нижней границы */
{set-prop.i &aa="left"	   &bb="iLeft"		&cc="INTEGER" &init="1"}					     /* Толщина левой границы */
{set-prop.i &aa="right"	   &bb="iRight"		&cc="INTEGER" &init="1"}					 /* Толщина верхней границы */

{set-prop.i &aa="posInTable"	   &bb="cposInTable" &cc="INTEGER" &init="1"}			 /* Где располагается ячейка in=1;leftEdge=2; topEnge=4; bottomEdge=8; leftEdge=16, их можно складывать */


{set-prop.i &aa="isVisible" &bb="lisVisible"  &cc="LOGICAL" &init="true"}                            	/* Показывать/Не показывать на в таблице*/
{set-prop.i &aa="split"        &bb="cSplit"	       &cc="CHARACTER" &init="\"0\""}							/* Выводить только часть. Пока умеет разбивать, только "," */
{set-prop.i &aa="sbstr"        &bb="cSbStr"	    &cc="CHARACTER"}					       /* Выводить только часть. Формат первый <начало_разбиения>,<кол_во_символов> */





DEFINE TEMP-TABLE ttWordWrap
				   FIELD iNumber AS INTEGER
				   FIELD cText AS CHARACTER
                                   INDEX idx_inumber iNumber
				  .


DEFINE PROPERTY width AS INTEGER
	GET:
		RETURN iWidth.
	END.
	SET (INPUT cProp AS INTEGER):
		iWidth = cProp.
		wordWrap().	/* Говорим провести разбивку по ширине */
	END.

DEF PRIVATE VAR cValue AS CHARACTER.
DEF PROPERTY content AS CHARACTER
    GET:
          RETURN cValue.
    END GET.
    SET (INPUT cProp AS CHARACTER):
        	cValue = cProp.
        	width = LENGTH(cValue).	
    END SET.

CONSTRUCTOR TCharacter(INPUT cStr AS CHARACTER):
    content = cStr.
END CONSTRUCTOR.

CONSTRUCTOR TCharacter(INPUT cStr AS INTEGER):
        content = STRING(cStr).
END CONSTRUCTOR.

METHOD PROTECTED CHARACTER formatText(INPUT cAlign AS CHARACTER,INPUT cText AS CHARACTER):
		DEF VAR dDiff  AS INT          NO-UNDO.
		DEF VAR result AS CHAR INIT "" NO-UNDO.

		dDiff = LENGTH(cText) - width.			/* Длина строки меньше, чем отводимое под нее поле */

		IF  dDiff < 0 THEN
				DO:
						CASE cAlign:
							WHEN "right"    THEN   result = align4Right(dDiff,cText).
							WHEN "center" THEN   result = align4Center(dDiff,cText).
							WHEN "left"	  THEN   result = align4Left(dDiff,cText).
							WHEN  "no"	  THEN   result = cText.
							OTHERWISE		      result = align4Right(dDiff,cText).
						END CASE.
				END.
				 ELSE
					DO:
							result = SUBSTRING(cText,1,width).
					END.
   RETURN result.

END METHOD.

METHOD PRIVATE CHARACTER align4Left(INPUT dDiff AS INTEGER,INPUT cFieldValue AS CHARACTER):
			/*****************************************
			 * Выравнивание по правому краю   *
			 *****************************************/
		DEF VAR i      AS INT              NO-UNDO.
		DEF VAR result AS CHAR INIT ""     NO-UNDO.
				result = cFieldValue.
					DO i = 1 TO ABS(dDiff):
						result = result + " ".
					END.

			RETURN result.
END METHOD.

METHOD PRIVATE CHARACTER align4Right(INPUT dDiff AS INTEGER,INPUT cFieldValue AS CHARACTER):
			/****************************************
			 * Выравнивание по правому краю *
			 ****************************************/
		DEF VAR i      AS INT          NO-UNDO.
		DEF VAR result AS CHAR INIT "" NO-UNDO.
		result = FILL(" ",ABS(dDiff)) + cFieldValue.
		RETURN result.
END METHOD.

METHOD PRIVATE CHARACTER align4Center(INPUT dDiff AS INTEGER,INPUT cFieldValue AS CHARACTER):
		DEF VAR i           AS INT          NO-UNDO.
		DEF VAR result      AS CHAR INIT "" NO-UNDO.
		DEF VAR halfDiff    AS DECIMAL      NO-UNDO.
		DEF VAR halfDiffPos AS DECIMAL      NO-UNDO.

		DEF VAR leftDiff  AS INT NO-UNDO.
		DEF VAR rightDiff AS INT NO-UNDO.
		halfDiff = ABS(dDiff) / 2.
		halfDiffPos = halfDiff - TRUNCATE(halfDiff,0).

		IF halfDiffPos > 0 THEN 
							DO: 
								leftDiff = TRUNCATE(halfDiff,0) + 1.
								rightDiff = TRUNCATE(halfDiff,0).
							END.
							ELSE
							  DO:
								leftDiff = halfDiff.
								rightDiff = leftDiff.
							  END.

						result = FILL(" ",leftDiff) + cFieldValue + FILL(" ",rightDiff).
   RETURN result.
END METHOD.

METHOD PUBLIC VOID show():
			/********************************************************
			 *										   *
			 * Рисует на экране всю фразу.				   *
			 *										   *
			 ********************************************************/
	DEFINE VARIABLE cOutStr AS CHARACTER NO-UNDO.

	/* Преобразование с учетом маленький большой регистр */
	CASE cMode:
	      WHEN "upper" THEN cOutStr = CAPS(content).
	      WHEN "lower" THEN cOutStr = LC(content).
	      OTHERWISE 		cOutStr = content.
	 END CASE.

	/* 
	    Преобразование с учетом делителей строки .
            НЕОБХОДИМО ПЕРЕДЕЛАТЬ!!!!!!!
	*/
	IF split NE "0" THEN cOutStr = ENTRY(INTEGER(split),cOutStr).

	cOutStr = formatText(align,cOutStr).
	PUT UNFORMATTED cOutStr.
END METHOD.

METHOD PUBLIC VOID show(INPUT iLine AS INTEGER):
		     /**************************************************************
		      *											         *
		      * Рисует на экране подстроку фразы с номером iLine *
		      *												 *
		      **************************************************************/
	PUT UNFORMATTED getValue(iLine).
END METHOD.

METHOD PUBLIC CHARACTER getValue(INPUT iLine AS INTEGER):
            /************************************
             * В случае если содержимое                   *
             * разбивается по строкам, то                  *
             * метод возвращает содержимое            *
             *************************************/
	DEF VAR cStr    AS CHARACTER NO-UNDO.
	DEF VAR cOutStr AS CHARACTER NO-UNDO.

	cStr = getWordWrap(iLine).

	CASE cMode:
	      WHEN "upper" THEN cOutStr = CAPS(cStr).
	      WHEN "lower" THEN cOutStr = LC(cStr).
	      OTHERWISE 		cOutStr = cStr.
	 END CASE.
	cOutStr = formatText(align,cStr).
	RETURN cOutStr.
END METHOD.


METHOD PUBLIC VOID setPropertyByStr(INPUT cPropertyName AS CHARACTER,INPUT cPropertyValue AS CHARACTER):
	CASE cPropertyName:
		WHEN "mode"  THEN mode = cPropertyValue.
		WHEN "align"  THEN align = cPropertyValue.
		WHEN "width"  THEN width = INTEGER(cPropertyValue).
		WHEN "split"  THEN  split = cPropertyValue.
	END CASE.
END METHOD.

METHOD PUBLIC VOID setIsInTpl(INPUT cProp AS LOGICAL):
	isInTpl = cProp.
END METHOD.


METHOD PRIVATE INTEGER getSubStr(INPUT cStr AS CHARACTER):
					/***************************************************************
					 * 

					 ***************************************************************/
  DEF VAR iPos      AS INTEGER   NO-UNDO.
  DEF VAR oSysClass AS TSysClass NO-UNDO.

    oSysClass = new TSysClass().
	    iPos = oSysClass:strPos(cStr," ","last").
    DELETE OBJECT oSysClass.

    IF iPos = ? THEN RETURN LENGTH(cStr).
 	               ELSE RETURN iPos.
END METHOD.

METHOD PUBLIC CHARACTER getWordWrap(INPUT iRow AS INTEGER):
   FIND FIRST ttWordWrap WHERE iNumber = iRow NO-ERROR.
   IF AVAILABLE(ttWordWrap) THEN   RETURN cText.
						ELSE RETURN "".
END METHOD.

METHOD PRIVATE VOID wordWrap():
					/********************************************************************************
					 *															*
					 * Дано:														*
					 * Задана фраза F шириной WF состоящая из слов неизвестной		*
					 * длины. Известно, что слова разделяются пробелами. 				*
					 * Известна ширина рамки WB в которой будет размещаться фраза.    *
					 * WB < = WF													*
					 * Найти:														*
					 * Разбиение фразы F на подстроки Fn шириной WB, так, чтобы		*
					 *  слова разбивались на строки только в случае, когда ширина 		*
					 * слова заведомо больше ширины рамки.							*
					 ********************************************************************************
					 * 	Перенос по словам в столбце								*
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


   EMPTY TEMP-TABLE ttWordWrap.
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
										  ELSE
											DO:
											    oSysClass = new TSysClass().
											    IF oSysClass:strPos(SUBSTRING(tmpStr,1,width)," ","last") = ? THEN iLength = width.
																		      		ELSE  
																					DO:
																					 iLength = oSysClass:strPos(SUBSTRING(tmpStr,1,width)," ","last").
																					END.
   											    DELETE OBJECT oSysClass.
											END.
							     END.
				  END.
			      CREATE ttWordWrap.
                              ASSIGN
					  iNumber = iStep
					  cText = SUBSTRING(tmpStr,1,iLength)
			      .
                              SUBSTRING(tmpStr,1,iLength) = "".
                        END. /* Конец цикла */
  height = iStep.  
END METHOD.

METHOD PUBLIC VOID LOADFROM(INPUT cXMLSTR AS LONGCHAR):
			/************************************************************
			 *											 *
			 * Метод наполняет объект данными из XML		 *
			 *											 *
			 *************************************************************/

	DEF VAR cTmp            AS CHAR   NO-UNDO.
	DEF VAR ttObjectFromXML AS HANDLE NO-UNDO.
	DEF VAR hBuffer         AS HANDLE NO-UNDO.
	DEF VAR hQuery          AS HANDLE NO-UNDO.

	CREATE TEMP-TABLE ttObjectFromXML.
	ttObjectFromXML:READ-XML("LONGCHAR",cXMLSTR,"EMPTY",?,?,?,?).
	CREATE BUFFER hBuffer FOR TABLE ttObjectFromXML:DEFAULT-BUFFER-HANDLE BUFFER-NAME "ObjectFromXML".

	CREATE QUERY hQuery.
	hQuery:SET-BUFFERS(hBuffer).

	hQuery:QUERY-PREPARE("FOR EACH objectFromXML").
	hQuery:QUERY-OPEN().
        hQuery:GET-FIRST().

		REPEAT WHILE NOT hQuery:QUERY-OFF-END:
			cTmp = hBuffer::cProp.
			CASE cTmp:
				WHEN  "colspan"  THEN colspan = INTEGER(hBuffer::cValue).
				WHEN  "rowspan" THEN rowspan = INTEGER(hBuffer::cValue).
				WHEN  "align"	      THEN align = hBuffer::cValue.
				WHEN  "mode"     THEN mode = hBuffer::cValue.
				WHEN "top"          THEN top = INTEGER(hBuffer::cValue).
				WHEN "bottom"    THEN bottom = INTEGER(hBuffer::cValue).
				WHEN "left"          THEN left = INTEGER(hBuffer::cValue).
				WHEN "right"	      THEN right = INTEGER(hBuffer::cValue).
				WHEN "posInTable" THEN posInTable = hBuffer::cValue.
			END CASE.
			hQuery:GET-NEXT().
		END.			
END METHOD.
METHOD PUBLIC LONGCHAR SERIALIZE():
			/******************************************************
			 *										 *
			 *	Метод сохраняет состояние объект		 *
			 * в XML.			 						 *
			 * Без рефлексии это жесткое занятие.		 *
			 *										 *
			 ******************************************************/
			DEF VAR cResult      AS LONGCHAR NO-UNDO.

			/********************************************************
			 Надо будет переделать это проще, чтобы 
			 на этапе задания свойства, оно автоматически
			 добавлялось в таблицу.
			**********************************************************/
			DEF VAR ttObject2XML AS HANDLE   NO-UNDO.
			DEF VAR hTBuffer     AS HANDLE   NO-UNDO.

			CREATE BUFFER hTBuffer FOR TABLE ttObject2XML:DEFAULT-BUFFER-HANDLE BUFFER-NAME "Object2XML".

			CREATE TEMP-TABLE ttObject2XML.
			ttObject2XML:ADD-NEW-FIELD("cProp","CHARACTER").
			ttObject2XML:ADD-NEW-FIELD("cValue","CHARACTER").

CREATE ttObject2XML.
	ASSIGN
		 hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "colspan"
		cValue = STRING(colspan)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "rowspan"
		cValue = STRING(rowspan)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "align"
		cValue = STRING(align)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "height"
		cValue = STRING(height)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "mode"
		cValue = STRING(mode)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "top"
		cValue = STRING(top)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "bottom"
		cValue = STRING(bottom)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "left"
		cValue = STRING(left)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "right"
		cValue = STRING(right)
	.
CREATE ttObject2XML.
	ASSIGN
		hTBuffer:BUFFER-FIELD("cProp"):BUFFER-VALUE = "posInTable"
		cValue = STRING(posInTable)
	.

ttObject2XML:WRITE-XML("LONGCHAR",cResult,?,?,?,?,?).
RETURN cResult.
END METHOD.

METHOD PUBLIC CHAR getProperty(INPUT cPropertyName AS CHAR):
  RETURN "".
END METHOD.

END CLASS.