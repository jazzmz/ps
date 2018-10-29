/**************************
 * Реализация хэша
 ***************************/
CLASS TAArray IMPLEMENTS IIteration, IDumpable:

DEF PROTECTED TEMP-TABLE tbl_aarray NO-UNDO
						   FIELD id      AS INT64
						   FIELD code    AS CHAR
						   FIELD val     AS CHAR
						   INDEX idx_code IS PRIMARY code   
						   INDEX idx_id id
						.


{set-prop.i &aa="length"   &cc="INT64"   &init="0"     &perms="PRIVATE"}
{set-prop.i &aa="curr"     &cc="INT64"   &init="0"     &perms="PRIVATE"}
{set-prop.i &aa="defValue" &cc="CHAR"    &init=?       &perms="PRIVATE" &perm="PRIVATE"}
{set-prop.i &aa="EOA"      &cc="LOGICAL" &init="TRUE"  &perms="PRIVATE" &perm="PROTECTED"}

CONSTRUCTOR TAArray():

END METHOD.

/**
 * @param CHAR cDefValue Значение возвращаемое
 * при отсутствии значения в массиве.
 **/
CONSTRUCTOR TAArray(INPUT cDefValue AS CHAR):
 defValue = cDefValue.
END CONSTRUCTOR.    

/*******

  Метод добавляет значение в хэш

 *******/

METHOD VOID setH(INPUT cKey AS INT,INPUT cValue AS INT):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS INT,INPUT cValue AS CHAR):
   setH(STRING(cKey),cValue).
END METHOD.



METHOD VOID setH(INPUT cKey AS INT64,INPUT cValue AS INT64):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.


METHOD VOID setH(INPUT cKey AS DATE,INPUT cValue AS DECIMAL):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS DATE,INPUT cValue AS CHAR):
   setH(STRING(cKey),cValue).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHAR,INPUT cValue AS DATE):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS DECIMAL):
   setH(cKey,STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS INT64):
   setH(cKey,STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS LOG):
   setH(cKey,STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS CHARACTER):

/***************************
 *			   *
 * Устанавливаем указатель *
 * на первую запись.       *
 *			   *
 ****************************/ 
EOA = FALSE.
FIND FIRST tbl_aarray WHERE code = cKey EXCLUSIVE-LOCK NO-ERROR.

	IF AVAILABLE(tbl_aarray) THEN DO:
	   tbl_aarray.val = cValue.
	END.
	ELSE DO:
		length = length + 1.
		CREATE tbl_aarray.

		ASSIGN
			tbl_aarray.id   = length
			tbl_aarray.code = cKey
			tbl_aarray.val  = cValue
		.
	  END.
END METHOD.

METHOD PUBLIC TAArray push(INPUT cValue AS INT64):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS INT):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS RECID):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS LOG):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS DEC):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.




METHOD PUBLIC TAArray push(INPUT cValue AS CHAR):
  THIS-OBJECT:setH(STRING(THIS-OBJECT:length),cValue).
  RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC CHAR pop():
   DEF VAR cRes AS CHAR INIT ? NO-UNDO.
   FIND LAST tbl_aarray EXCLUSIVE-LOCK NO-ERROR.

   IF AVAILABLE(tbl_aarray) THEN DO:
    cRes = tbl_aarray.val.
    DELETE tbl_aarray.
    length = length - 1.
   END.


   RETURN cRes.
END METHOD.

METHOD PUBLIC CHAR delete(INPUT cKey AS CHAR):
   DEF VAR cRes AS CHAR INIT ? NO-UNDO.

   FIND LAST tbl_aarray WHERE code = cKey EXCLUSIVE-LOCK NO-ERROR.

   IF AVAILABLE(tbl_aarray) THEN DO:
     cRes = tbl_aarray.val.
     DELETE tbl_aarray.
     length = length - 1.
   END.

  RETURN cRes.
END METHOD.

/*****************************
 * Получаем значение 
 *****************************/
METHOD CHAR get(INPUT cKey AS CHARACTER):

	FIND FIRST tbl_aarray WHERE tbl_aarray.code = cKey NO-LOCK NO-ERROR.
	
	IF AVAILABLE(tbl_aarray) THEN DO:
		RETURN tbl_aarray.val.
	END.

	RETURN defValue.
END METHOD.

METHOD DECIMAL getInDec(INPUT cKey AS CHAR):
    RETURN DECIMAL(get(cKey)).
END METHOD.

METHOD CHARACTER get(INPUT cKey AS DATE):
  RETURN get(STRING(cKey)).
END METHOD.

METHOD CHARACTER get(INPUT cKey AS INT):
  RETURN get(STRING(cKey)).
END METHOD.

METHOD CHARACTER get(INPUT cKey AS INT64):
  RETURN get(STRING(cKey)).
END METHOD.


METHOD VOID dump():
 FOR EACH tbl_aarray BY id:
   DISPLAY code FORMAT "x(20)" val FORMAT "x(20)".
 END.
END.

METHOD VOID dump(INPUT cFileName AS CHAR):
   TEMP-TABLE tbl_aarray:WRITE-XML("file",cFileName,YES,?,?,NO,NO).
END.
/*****************
 * Получаем значение и увеличиваем счетчик
 *****************/
METHOD CHARACTER get_(OUTPUT cKey AS CHARACTER):

   DEF VAR lRes AS CHAR NO-UNDO.

  /***********
   * Если в массиве ничего нет,
   * то возвращаем пусто и говорим,
   * что ничего нет.
   ***********/
  IF length <= 0 THEN DO:
       EOA = TRUE.
       lRes = ?.
  END. 
  ELSE DO:

    curr = curr + 1.

    FIND FIRST tbl_aarray WHERE tbl_aarray.id = curr NO-LOCK NO-ERROR.

	IF AVAILABLE(tbl_aarray) THEN DO:
         ASSIGN
	  cKey = tbl_aarray.code
          lRes = tbl_aarray.val
         .
	END.
                                        
    IF curr = length THEN EOA = TRUE.
 END.

 RETURN lRes.
END METHOD.

/**
 * Возвращает первое значение.
 **/
METHOD CHARACTER getFirst():

	FIND FIRST tbl_aarray NO-LOCK NO-ERROR.
	
	IF AVAILABLE(tbl_aarray) THEN DO:
		RETURN tbl_aarray.val.
	END.

	RETURN ?.

END METHOD.

/**
 * Возвращает последнее значение списка.
 **/
METHOD CHARACTER  getLast():
	FIND LAST tbl_aarray NO-LOCK NO-ERROR.
	
	IF AVAILABLE(tbl_aarray) THEN DO:
		RETURN tbl_aarray.val.
	END.

	RETURN ?.
END METHOD.

/******************
 * Сбрасываем счетчик
 *******************/
METHOD VOID reset_():
  curr = 0.
  IF length > 0 THEN  EOA = FALSE.
END METHOD.

METHOD PUBLIC LOGICAL EOI():
  RETURN EOA.
END METHOD.


METHOD PUBLIC CHARACTER save2str():
  DEF VAR cRes  AS CHARACTER INITIAL "" NO-UNDO.

  FOR EACH tbl_aarray NO-LOCK:
	cRes = cRes + tbl_aarray.val + ",".
  END.

  cRes = TRIM(cRes,",").
 RETURN cRes.
END METHOD.

/**
 * Производит наследование
 * свойств из массива oa в 
 * текущий массив.
 * @param TAArray oa Массив из которого будут 
 * наследоваться свойства.
 * @return TAArray
 **/
METHOD PUBLIC TAArray ext(INPUT oa AS TAArray):
 DEF VAR key1 AS CHARACTER NO-UNDO.
 DEF VAR val1 AS CHARACTER NO-UNDO.

 {foreach oa key1 val1}
    THIS-OBJECT:setH(key1,val1).
 {endforeach oa}

 RETURN THIS-OBJECT.
END METHOD.

 /**
  * Серилизует ЗНАЧЕНИЯ списка в строку. В качестве
  * разделителя используется ~n.
  * @return TAArray
  **/
METHOD PUBLIC LONGCHAR toDataLine():
  RETURN toDataLine(TRUE).
END METHOD.
/**
 * Метод сериализации в DataLine.
 *
 * Возможны два варианта запуска:
 * 1. Сохраняются только значения;
 * 2. Второй вариант сохраняются пары ключ --> значение.
 * @param LOG onlyValues Сохранять только значение
 * или в виде ключ значение.
 *
 **/
METHOD PUBLIC LONGCHAR toDataLine(INPUT onlyValues AS LOG):
   RETURN THIS-OBJECT:toDataLine("~n",onlyValues).
END METHOD.

/**
 * Серилизует список.
 * @param cSplitter  CHAR разделитель
 * @param onlyValues LOG  если TRUE, то будут выгружаться также и ключи списка
 * @return LONGCHAR
 */
METHOD PUBLIC LONGCHAR toDataLine(INPUT cSplitter AS CHAR,INPUT onlyValues AS LOG):
    DEF VAR key1 AS CHAR         NO-UNDO.
    DEF VAR val1 AS CHAR         NO-UNDO.
    DEF VAR cRes AS CHAR INIT "" NO-UNDO.
    
    cRes = "".
    {foreach THIS-OBJECT key1 val1}
         IF val1 <> ? THEN DO:         
          cRes = cRes + (IF onlyValues THEN cSplitter + val1 ELSE cSplitter + key1 + cSplitter + val1).
         END.
    {endforeach THIS-OBJECT}
    cRes = SUBSTRING(cRes,2).
    RETURN cRes.
END METHOD.

/**
 * Загрузить список из строки.
 * @param cDataLine  LONGCHAR строка со списком
 * @param onlyValues LOG      если истина, то из списка загружаются только значения. Иначе считается, что в строке ключ и соответствующее ему значение списка
 * @return TAArray
 **/
METHOD PUBLIC TAArray loadDataLine(INPUT cDataLine AS LONGCHAR,INPUT onlyValues AS LOG):
 RETURN THIS-OBJECT:loadSplittedList(cDataLine,"~n",onlyValues).
END METHOD.

/**
 * Наполняет объект-список значениями.
 * @param cDataLine  LONGCHAR список значений
 * @param cSplitter  CHAR     разделитель списка
 * @param onlyValues LOG      если LOG то нечетные элементы списка считаются ключами, а четные значениями по этим ключам.
 * @return TAArray
 **/

METHOD PUBLIC TAArray loadSplittedList(INPUT cDataLine AS LONGCHAR,INPUT cSplitter AS CHAR,INPUT onlyValues AS LOG):
    DEF VAR i AS INT NO-UNDO.

    IF NOT onlyValues THEN DO:
      DO i = 0 TO NUM-ENTRIES(cDataLine,cSplitter) / 2 - 1:
         THIS-OBJECT:setH(STRING(ENTRY(2 * i + 1,cDataLine,cSplitter)),STRING(ENTRY(2 * (i + 1),cDataLine,cSplitter))).
      END.
    END.

    IF onlyValues THEN DO:
            THIS-OBJECT:loadList(cDataLine,cSplitter).
    END.

  RETURN THIS-OBJECT.
END METHOD.


/**
 * Загружает список где каждое ключ => значение хранится на новой строке. 
 * @param cDataLine LONGCHAR содержимое файла.
 * @param cSplitter CHAR     разделитель значений списка
 * @return TAArray
 **/
METHOD PUBLIC TAArray loadListInLines(INPUT cDataLine AS LONGCHAR,INPUT cSplitter AS CHAR):
  DEF VAR i       AS INT64    NO-UNDO.
  DEF VAR currRow AS LONGCHAR NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(cDataLine,"~n"):
      currRow = ENTRY(i,cDataLine,"~n").

      THIS-OBJECT:setH(ENTRY(1,currRow,cSplitter),ENTRY(2,currRow,cSplitter)).
  END.
 RETURN THIS-OBJECT.
END METHOD.


/**
 * Жалкое подобие преобразовать в JSON
 * @result JSON
 **/
METHOD PUBLIC LONGCHAR toJSON():
    DEF VAR key1 AS CHAR         NO-UNDO.
    DEF VAR val1 AS CHAR         NO-UNDO.
    DEF VAR cRes AS CHAR INIT "" NO-UNDO.
    
    cRes = "\{".
    {foreach THIS-OBJECT key1 val1}
        cRes = cRes + "\"" + key1 + "\":\"" + (IF val1 = ? THEN "" ELSE val1) + "\",".
    {endforeach THIS-OBJECT}
    cRes = TRIM(cRes,",").
    cRes = cRes + "\}".
    RETURN cRes.
END METHOD.  

METHOD PUBLIC LONGCHAR toJSON2():
   DEF VAR vRes AS LONGCHAR NO-UNDO.

   TEMP-TABLE tbl_aarray:DEFAULT-BUFFER-HANDLE:WRITE-JSON("LONGCHAR",vRes,TRUE).

 RETURN vRes.
END METHOD.

/*** 
 * Загружаем
 */
METHOD PUBLIC VOID loadJSON(INPUT iJSONStr AS CHAR):
    DEF VAR lJSONStr AS LONGCHAR NO-UNDO.

    THIS-OBJECT:length = 0.

    lJSONStr = iJSONStr.

    TEMP-TABLE tbl_aarray:READ-JSON("LONGCHAR",lJSONStr,"EMPTY").

    FOR EACH tbl_aarray NO-LOCK:
       THIS-OBJECT:length = THIS-OBJECT:length + 1.
    END.


END METHOD.

METHOD PUBLIC STATIC TAArray loadJSON2(INPUT iJSONStr AS CHAR):
     DEF VAR oAArray AS TAArray NO-UNDO.

     oAArray = NEW TAArray().
     oAArray:loadJSON(iJSONStr).

 RETURN oAArray.
END METHOD.

/**
 * Серилизует список. В качестве разделителя используется "," (запятая). Выгружаются только значения списка.
 * @return CHAR
 **/
METHOD PUBLIC CHAR toList():
 RETURN STRING(THIS-OBJECT:toDataLine(",",TRUE)).
END METHOD.

/**
 * Серилизует список. В качестве разделителя используется "," (запятая).
 * @param onlyValue LOG Если истина, то выгружаются только значения, иначе выгружаются ключи и значения.
 * @return CHAR
 **/

METHOD PUBLIC CHAR toList(INPUT onlyValues AS LOG):
   RETURN STRING(THIS-OBJECT:toDataLine(",",onlyValues)).
END METHOD.

/**
 * Загружает серилизованные ЗНАЧЕНИЯ списка. В качестве ключей берутся целые числа от 0 до ДЛИНЫ списка
 * @param cList LONGCHAR строка со списком
 * @param cSplitter CHAR разделитель
 * @return TAArray
 */
METHOD PUBLIC TAArray loadList(INPUT cList AS LONGCHAR,INPUT cSpliter AS CHAR):
   DEF VAR i AS INT NO-UNDO.
   DO i = 1 TO NUM-ENTRIES(cList,cSpliter):
       THIS-OBJECT:push(STRING(ENTRY(i,cList,cSpliter))).
   END.
 RETURN THIS-OBJECT.   
END METHOD.

/**
 * Загружает список разделенный запятыми. В качестве ключей берутся целые числа от 0 до ДЛИНЫ списка
 * @param cList LONGCHAR строка со списком
 * @return TAArray
 **/
METHOD PUBLIC TAArray loadList(INPUT cList AS LONGCHAR):
  THIS-OBJECT:loadList(cList,",").
  RETURN THIS-OBJECT.
END METHOD.
/**
 * Увеличивает значение массива hash на dSum
 * @param CHAR hash Элемент который увеличиваем
 * @param DECIMAL dSum Сумма на которую увеличиваем
 * @result TArray
 **/
METHOD PUBLIC TAArray incrementTo(INPUT hash AS CHAR,INPUT dSum AS DECIMAL):
    DEF VAR dRes AS DECIMAL NO-UNDO.
    DEF VAR val1 AS CHAR    NO-UNDO.
    val1 = IF THIS-OBJECT:get(hash) <> ? THEN THIS-OBJECT:get(hash) ELSE "0".
    dRes = DECIMAL(val1). 
    THIS-OBJECT:setH(hash,dRes + dSum).
    RETURN THIS-OBJECT.
END METHOD.

/**
 * Выдампливает внутреннее представление
 * в файл.
 * @param CHAR cFileName Имя XML файла.
 **/
METHOD PUBLIC VOID SAVE-XML(INPUT cFileName AS CHAR):
    TEMP-TABLE tbl_aarray:WRITE-XML("file",cFileName,YES,?,?,NO,NO).
END METHOD.

/**
 * Очистить содержимое списка.
 **/
METHOD PUBLIC VOID empty():
 EMPTY TEMP-TABLE tbl_aarray.
 length = 0.
 THIS-OBJECT:reset_().
END METHOD.

/**
 * Метод проверяет наличие в списке значения с кодом cCode
 * @param cCode CHAR ключ для проверки
 * @return LOG
 **/

METHOD PUBLIC LOG hasCode(INPUT cCode AS CHAR):
  RETURN THIS-OBJECT:get(cCode) <> ?.
END METHOD.

END CLASS.
/***
 {foreach oar key value}
    {&out} key value.
  {endforeach oar}
*/