CLASS TTableDBF INHERITS TTable:

DEFINE PROTECTED VARIABLE cEncoding AS CHARACTER INITIAL "ibm866" NO-UNDO.

DEFINE PROPERTY encoding AS CHARACTER
    GET:
 	 RETURN cEncoding.
    END GET.
  SET (INPUT cProp AS CHARACTER):
		cEncoding = cProp.
    END SET.
 
DEFINE PROTECTED VARIABLE cColLength AS CHARACTER INITIAL "" NO-UNDO.
DEFINE PROTECTED VARIABLE iRowLength AS INTEGER INITIAL 1 NO-UNDO.
DEFINE PROTECTED VARIABLE cFileName AS CHARACTER NO-UNDO.

DEF PRIVATE VAR cColName AS CHARACTER LABEL "Наименование столбцов через запятую" NO-UNDO.	/* Дурацкий способ, уже второй раз */

METHOD PUBLIC INTEGER getFieldRight(INPUT iFieldNum AS INTEGER):
 DEF VAR i AS INTEGER NO-UNDO.
 DEF VAR iRes AS INTEGER INITIAL 0 .

    DO i = 1 TO iFieldNum:
      iRes = iRes + INTEGER(ENTRY(i,cColLength)). 
    END.
  RETURN i.
END METHOD.

METHOD PROTECTED VOID fillSetting(INPUT iRecNum AS INTEGER,INPUT aArr AS INTEGER EXTENT):
                        /********************************************
                         * Функция парсит массив байт             *
                         * и заполняет свойства полей и DBF.  *
                         ********************************************/
	DEF VAR i AS INTEGER NO-UNDO.
	DEF VAR tmpName AS CHARACTER INITIAL "" NO-UNDO.

        IF iRecNum <> -1 THEN
         DO:   
            /* Парсим описание полей */     
            iRowLength = iRowLength + aArr[17].
            cColLength = cColLength + STRING(aArr[17]) + ",".
		DO i = 1 TO 11:
			tmpName = tmpName + STRING(CHR(aArr[i],"ibm866",encoding)).
		END.	    
		cColName = cColName + TRIM(tmpName) + ",".
          END.
          ELSE
             DO:
			/* Здесь определяем количество записей в таблице 
			    Разряды 5-8 (с учетом отсчета от 1) меняем местами старший становиться младшим, 
			    младщий старшим.
			   11-12 количество байтов занимаемых записью iRowLength.
			   Дурацкая тема, но похоже придется из 10ой системы исчисления
			    преобразовывать в hex, затем формировать число в шестнадцатерички
			    с учетом изменения разрядов, и затем переводить в десятичную систему исчесления.
			 */
			   
			
	     END.
END METHOD.

CONSTRUCTOR TTableDBF(INPUT cFN AS CHARACTER):
	SUPER().
	cFileName = cFN.
END CONSTRUCTOR.

METHOD PUBLIC VOID LOAD():
			/*************************************************
			 * 												 *
			 * Импортирует таблицы из DBF					 *
			 *												 *
			 *************************************************/
&SCOPED-DEFINE iPirHeaderSize 32 	/* Количество байт в описании записи */

DEF VAR i   AS INTEGER INITIAL 0 NO-UNDO.  	/* Счетчик прочитанных байтов из заголовка */                          
DEF VAR iWn AS INTEGER           NO-UNDO.       /* Номер прочитанного байта относительно начала описания свойств */

DEF VAR oSysClass AS TSysClass NO-UNDO.		/* Подключаем служебные функции */

DEF VAR aRecSetting AS INTEGER EXTENT {&iPirHeaderSize} NO-UNDO.   /* Временный массив  с описание полей/DBF */
DEF VAR isFind13 AS LOGICAL INITIAL true NO-UNDO.  				 /* Заголовок отделяется от тела 13 кодом? */

/*
 Фактически отражения оопианий по 32 байта
 на количество полей в записи. 
Так как первое поле является описание самого DBF
файла, то не учитываем его. 
*/

DEF VAR iFieldCount AS INTEGER INITIAL -1 NO-UNDO. 

/* 
Длина строки в байтах. 
Начинаем с единицы, так как для каждой строки 
указывается признак удаления в 1 байт. 
*/

/********************
Алгоритм:
Состоит из 3х шагов:
 1. Шаг определяем количество полей в таблице;
 2. Шаг определяем свойства каждого из полей;
 3. Получаем данные.
**********************/
oSysClass = new TSysClass().

/************ Шаг 1, 2 ***********************/

/* ПАРСИМ ЗАГЛОВОК DBF ФАЙЛА */

INPUT FROM VALUE(cFileName) BINARY NO-CONVERT.

REPEAT WHILE LASTKEY <> -2:
  READKEY.
        IF LASTKEY  = 13 AND i >= 32 THEN
                                        DO:
                                                isFind13 = true.
						LEAVE.
                                        END.  /* Конец заголовка */
                                        ELSE
                                         DO:
                                       
                                          iWn = oSysClass:getRemainder(i,{&iPirHeaderSize},1).
                                          aRecSetting[iWn] = LASTKEY.

                                           IF iWn = {&iPirHeaderSize} THEN 
                                                DO:
						                          fillSetting(iFieldCount,aRecSetting).
                                                  iFieldCount = iFieldCount + 1.
                                                END.
                                          i = i + 1.
                                          END. /* Не конец заголовка */
END. /* REPEAT по всему заголовку */

/********** Конец шагов 1,2 **************/

createTable(iFieldCount).


/**************** Шаг 3************************/


DEF VAR iCurrRow AS INTEGER INITIAL 0 LABEL "Текущая строка" NO-UNDO.
DEF VAR iCurCol AS INTEGER INITIAL ? LABEL "Текущий столбец" NO-UNDO.
DEF VAR iCurrCharInField AS INTEGER LABEL "Номер байта от начала записи" NO-UNDO.
i = 0. /* Количество байт, прочитанных от начала тела */

DEF VAR cField AS CHARACTER INITIAL "" LABEL "Содержимое поля" NO-UNDO.



/* ПАРСИМ ТЕЛО DBF ФАЙЛА */
SUBSTRING(cColLength,LENGTH(cColLength),1) = "".

 REPEAT WHILE LASTKEY <> 26 AND LASTKEY <> -2:
  READKEY.

   iCurrCharInField = oSysClass:getRemainder(i,iRowLength ,0).  /* Текущий байт относительно начала записи */
    
         /* Этот байт не указатель на удаление */
        IF iCurCol <> oSysClass:getLineSegment(iCurrCharInField,cColLength) AND iCurrCharInField <> 1 THEN
           DO:
	       /* Новый номер столбца не равен, старому. ТО есть столбец закончился */
                addCell(TRIM(cField)).
                cField = "".
           END.
           IF iCurrCharInField <> 0 THEN cField = cField + CHR(LASTKEY,'ibm866',cEncoding).
     
    IF iCurrCharInField = 0 AND LASTKEY <> 26 THEN
        DO:         
          addRow().
        END.  
	iCurCol = oSysClass:getLineSegment(iCurrCharInField,cColLength).
   i = i + 1. 
 END.

INPUT CLOSE.

DELETE OBJECT oSysClass.

END METHOD.

END CLASS.