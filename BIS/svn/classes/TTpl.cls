using Progress.Lang.*.                        /* Подключаем системные классы Прогресс */

/*
Класс шаблонизатор.
 Входные данные: файл с текстовыми метками - якорями;
 Внутренние данные: Таблица соответствия якоря --> текстовому значению или объекту, объект должен
 реализовывать интерфейс ITplElement
*/

CLASS TTpl:
      /**************************************************
       *                                                                             *
       * Класс шаблонизатор                                        *
       *                                                                             *
       **************************************************/
      

/* Таблица соответствия якорь --> подставляемое значение */
 DEFINE PROTECTED TEMP-TABLE anchor-value NO-UNDO
                                 FIELD code AS CHARACTER
                                 FIELD code-value-object AS CLASS OBJECT
                                 .

/* Таблица соответствия якорь ---> параметр для его подставляемого объекта  ---> значение параметра подставляемого объекта */
 DEFINE PROTECTED TEMP-TABLE anchor-param-value NO-UNDO
                                FIELD code AS CHARACTER
                                FIELD paramName AS CHARACTER
                                FIELD paramValue AS CHARACTER
                                .

 
{set-prop.i &aa="filename"  &bb="cFileName" &cc="CHAR" &perms="PROTECTED"}
{set-prop.i &aa="RunTime"   &bb="iRunTime"  &cc="INTEGER"}     /* Время работы шаблона */
{set-prop.i &aa="encoding"  &bb="cEncoding" &cc="CHARACTER" &init="'ibm866'"} /* Кодировка файла шаблона */

{set-prop.i &aa="isInit"    &bb="lIsInit"   &cc="LOGICAL"   &init="FALSE" perms="PRIVATE"}     /* Инициализирован шаблон */

DEF PROTECTED VAR SPC AS INTEGER INITIAL 35 LABEL "Код разделителя якоря".
DEFINE PUBLIC PROPERTY splitter AS CHARACTER
        GET:
                RETURN CHR(SPC).
        END GET.
        SET (INPUT cProp AS CHARACTER):
                SPC = ASC(cProp).
        END SET.


 CONSTRUCTOR TTpl(INPUT cTemplateFile AS CHAR):
   RunTime = TIME.
   fileName = cTemplateFile. 
   setServiceTags().                                /* Устанавливаем сервисные тэги */
 END CONSTRUCTOR.
 
 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT cValue AS CHARACTER):
                /******************************************************
                 *                                                                                 *
                 * Добавляет значение в таблицу соответствия  *
                 * якорь <--> подставляемое значение                         *
                 * Для случая, когда подменяем строкой,                 *
                 * чтобы не пугать народ философией,                 *
                 * что все есть объект прячем, что строка                 *
                 * это тоже класс                                                          *
                 *                                                                                 *
                 * ******************************************************/
                DEF VAR oObject AS CLASS Object NO-UNDO.

                oObject = new TCharacter(IF cValue = ? THEN "" ELSE cValue).

                addAnchorValue(cAnchor,oObject).

                oObject = ?.
 END METHOD.

 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT iValue AS INTEGER):

                addAnchorValue(cAnchor,STRING(iValue)).

 END METHOD.

 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT daValue AS DATE):
                addAnchorValue(cAnchor,STRING(daValue,"99.99.9999")).
 END METHOD.

 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT dValue AS DECIMAL):
        DEF VAR cValue    AS CHAR         NO-UNDO.
        DEF VAR cNewValue AS CHAR INIT "" NO-UNDO.
        DEF VAR oSysClass AS TSysClass    NO-UNDO.
        DEF VAR i         AS INT          NO-UNDO.

        DEF VAR p1 AS CHARACTER INITIAL "" NO-UNDO.
        DEF VAR p2 AS CHARACTER INITIAL "" NO-UNDO.

        cValue = STRING(dValue).

        oSysClass = new TSysClass().

        p1 = ENTRY(1,cValue,".").

         IF NUM-ENTRIES(cValue,".") > 1 THEN 
                DO:
                        p2 = "." + ENTRY(2,cValue,".").                
                 END.

        DO i = 0 TO LENGTH(p1) - 1:
                /* Идем в обратном порядке */
                IF oSysClass:getRemainder(i + 1,3,0) = 0 THEN cNewValue = "," + SUBSTR(p1,LENGTH(p1) - i,1) + cNewValue.
                ELSE  cNewValue = SUBSTR(p1,LENGTH(p1) - i,1) + cNewValue. 
        END. /* DO */
        IF SUBSTR(cNewValue,1,1) = "," THEN SUBSTR(cNewValue,1,1) = "".

        cNewValue = cNewValue + p2.

        addAnchorValue(cAnchor,cNewValue).
        DELETE OBJECT oSysClass.

 END METHOD.

METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT cValue AS CLASS Object):
                /********************************************************
                 *                                                                                   *
                 * Добавляет значение в таблицу соответствия   *
                 * якоро <--> подставляемое значение,                  *
                 * объект таблица.                                                          *
                 *                                                                                  *
                 *******************************************************/
        IF TYPE-OF(cValue,"ITplElement") THEN
              DO:
                        CREATE anchor-value.
                                 ASSIGN
                                        code = cAnchor
                                        code-value-object = cValue
                                  .
                END.
                ELSE
                        DO:
                                        /* Здесь должны пульнуть ошибку переданный класс не поддерживается */
                        END.
END METHOD.

METHOD PROTECTED VOID saveParamValue(INPUT cAnchor AS CHARACTER,INPUT cParamValue AS CHARACTER):
                                /*******************************************************************
                                 * Парсит и сохраняет название параметра его значение            *
                                 * для якоря cAnchor                                                                    *
                                ********************************************************************/
        DEF VAR cParam AS CHARACTER         NO-UNDO.
        DEF VAR cValue AS CHARACTER INIT "" NO-UNDO.

        cParam = ENTRY(1,cParamValue,"=").
        IF NUM-ENTRIES(cParamValue,"=")  = 2 THEN cValue = ENTRY(2,cParamValue,"=").
        cValue = LEFT-TRIM(cValue,'"').
        cValue = RIGHT-TRIM(cValue,'"').

        CREATE anchor-param-value.
        ASSIGN
                code = cAnchor
                paramName  = cParam
                paramValue = cValue
        .
END METHOD.

METHOD PROTECTED CHARACTER parseAnchor(INPUT cAnchor AS CHARACTER):
                        /****************************************************************************************************************************************
                         *                                                                                                                                                                                                                *
                         * Метод парсит якорь на наличие параметров.                                                                                                                                 *
                         * Алгоритм следующий:                                                                                                                                                                   *
                         * По всем буквам якоря                                                                                                                                                                   *        
                         *   Берем букву                                                                                                                                                                                   *
                         *   Если найден пробел, и этот пробел не внутри значения параметра                                                                                           *
                         *       Смотрим найдено ли уже имя якоря,                                                                                                                                           *
                         *               Если имя еще не найдено, то есть это первый параметр (пустой) запоминаем имя якоря                                           *
                         *               Если имя якоря уже найдено вызываем сохранение и дальйшую обработку параметра и его значения                   *
                         *  Если эта буква не пробел                                                                                                                                                                   *
                         *   Формирует строку tmpStr                                                                                                                                                           *
                         *   Если найденная буква ", то для первого вхождения устанавливаем isValue в значение ИСТИНА                                           *
                         *  (то есть началось значение параметр, для второго вхождение значение параметра закончилось.                                   *
                         *                                                                                                                                                                                                                *
                         *                                                                                                                                                                                                               *
                         ****************************************************************************************************************************************/
        DEF VAR i         AS INT             NO-UNDO.
        DEF VAR strLength AS INT             NO-UNDO.
        DEF VAR isValue   AS LOG  INIT false NO-UNDO.
        DEF VAR cCurrChar AS CHAR            NO-UNDO.
        DEF VAR tmpStr    AS CHAR INIT ""    NO-UNDO.
        DEF VAR cName AS CHARACTER INIT ?    NO-UNDO.

        DEF VAR oSysClass AS TSysClass NO-UNDO.

        cAnchor = TRIM(cAnchor).  /* Избавляемся от лишних пробелов */

        oSysClass = new TSysClass().
                cAnchor = oSysClass:REPLACE_ASCII(cAnchor,13," ").        /* Делаем перевод строки пробелом */
                cAnchor = oSysClass:REPLACE_ASCII(cAnchor,10,"").  /* Удаляем возврат коретки */
        DELETE OBJECT oSysClass.

        cAnchor = cAnchor + " ".          /* Добавляем концевой пробел. Без него не будет парситься последний параметр        */

        

        strLength = LENGTH(cAnchor).

         DO i = 1 TO strLength:
                   cCurrChar = SUBSTRING(cAnchor,i,1).
                   IF cCurrChar = " " AND NOT isValue THEN 
                        DO:
                           IF cName = ? THEN cName = tmpStr.
                                                 ELSE  saveParamValue(cName,tmpStr).
                                tmpStr = "".
                        END.
                        ELSE
                           DO:
                                tmpStr = tmpStr + cCurrChar.
                                IF cCurrChar = '"' THEN isValue = NOT isValue.
                          END.        /* Конец если буква " */
         END.                        /* Конец по всей строке */
   RETURN cName.        
END METHOD.

METHOD PROTECTED VOID showAnchorValue(INPUT cAnchor AS CHARACTER):

                                /****************************************************************
                                 *                                                                                                *
                                 * Метод производит рисование якорей.                               *
                                 * Алгоритм:                                                                               *
                                 *    1. Подготавливаем якорь из шаблона;                               *
                                 *    2. Проверяем является ли он подстановкой из НП;    *
                                 *    3. Создаем объект для рисования и передаем ему    *
                                 * свойства из шаблона;                                                       *
                                 *    4. Рисуем на экране.                                                       *
                                 *                                                                                               *
                                 ****************************************************************/

        DEF VAR cName AS CHAR NO-UNDO.        /* Название якоря */

        
        cName = parseAnchor(cAnchor).        /* Получаем только название якоря, все параметры хранятся в доп таблице */

                /*******************************************************
                 *                                                                                 *
                 * Проверяем подходит ли якорь под шаблон         *
                 * значения настроечного параметра.                         *
                 * Значением из НП считаем шаблон вида                 *
                 * НП|ИмяЗначениеБД                                                 *
                 * Допускается несколько вложений:                         *
                 * НП|Значение1|Значение2                                         *
                 * Если подходит, то пытаемся взять значение   *
                 * из БД, если находим то подставляем новый   *
                 * якорь. Если нет, то ничего не делаем                 *
                 *                                                                                 *
                 ******************************************************/

                /*************************************************************
                 * P.S. Можно посмотреть на ситуацию более широко  *
                 * в БИСКВИТЕ должны быть классы описывающие     *
                 * среду (например, ДАТА, ПОЛЬЗОВАТЕЛЬ и т.д.)       *
                 *  поэтому парсинг НП вынесем в отдельный метод,  *
                 * чтобы затем можно было добавить обработку          *
                 * объектов.                                                                          *
                 *************************************************************/

        /******************************
         *    СПЕЦ ЯКОРЬ NEW-PAGE     *
         ******************************/
        IF cName = "NEW-PAGE" THEN DO:
          PAGE.
          RETURN.
        END.
        /******************************
         *    КОНЕЦ СПЕЦ ЯКОРЯ        *
         ******************************/

        IF CAN-DO("НП|*",cName) THEN
                DO:
                        /* Нашли системный объект */
                        /* Вызываем метод парсинга системных объектов */
                        setSysClassTags(cName).
                END.

        
        FIND FIRST anchor-value WHERE anchor-value.code = cName NO-ERROR.

        IF AVAILABLE(anchor-value) THEN DO:
                FOR EACH anchor-param-value WHERE anchor-param-value.code = cName:
                    CAST(anchor-value.code-value-object,ITplElement):setPropertyByStr(paramName,paramValue).
                END.
                CAST(anchor-value.code-value-object,ITplElement):setIsInTpl(true).
                CAST(anchor-value.code-value-object,ITplElement):show().
        END. ELSE PUT UNFORMATTED CHR(SPC) + cAnchor + CHR(SPC).

END METHOD.

/*************************************
 * Производит компиляцию шаблона.   *
 * Необходим для использования      *
 * вложенных шаблонов.              *
 ************************************/
METHOD PROTECTED VOID doCompileTemplate():


END METHOD.

METHOD PROTECTED VOID parseFile():
                                /***************************************************************
                                 * Корявый способ, но пока                                                      *
                                 * не познаю способ создания делегатов или нечто              *
                                 * подобного только так.                                                      *
                                 * Алгоритм:                                                                              *
                                 * 1. Просматриваем файл - шаблон;                                      *
                                 * 2. Нашли якорь, вызываем процедуру обработки              *
                                 * якоря;                                                                                      *
                                 * 3. Нашли текст шаблона, просто выводим его в файл *
                                 * Параметр cTypeTransform - тип преобразования               *
                                 ****************************************************************/

DEF VAR lFlag  AS LOG  INITIAL false NO-UNDO.
DEF VAR anchor AS CHAR INITIAL ""    NO-UNDO.

doCompileTemplate().
  
   INPUT FROM VALUE(SEARCH(THIS-OBJECT:filename)) CONVERT SOURCE encoding.

   REPEAT:
   READKEY.

      CASE LASTKEY:
        WHEN -2 THEN LEAVE.      
        WHEN 13 THEN DO:
                                                /* Нашли перевод строки */
                                                /*
                                                        Смотрим где находиться перевод строки, если в якоре, 
                                                        то ничего не делаем. 
                                                        Если вне якоря, то есть это элемент оформления, то выводим перевод строки 
                                                */
                                                IF lFlag THEN anchor = anchor + CHR(LASTKEY). ELSE PUT UNFORMATTED SKIP.
                                 END.

        WHEN SPC THEN
                    DO:
                        /* Здесь  выделяем  якорь. */
                       IF lFlag  THEN 
                                  DO:
                                                /* Нашли закрывающий тэг якоря, значит можно выполнять преобразование */
                                           showAnchorValue(anchor).
                                    lFlag = FALSE.
                                    anchor = "".
                                  END.
                                 ELSE
                                     DO:
                                        lFlag = TRUE.
                                     END.
                      
                    END.
        OTHERWISE
                DO:
                   IF lFlag THEN anchor = anchor + CHR(LASTKEY).
                   ELSE PUT UNFORMATTED CHR(LASTKEY).         
                END.
      END CASE.
END.

END METHOD.

 METHOD PUBLIC VOID show():
                                        /*********************************************************************
                                         * Выполняет преобразование txt -> замена якорей -> экран   *
                                         *********************************************************************/
   RunTime = TIME - iRunTime.
   IF SEARCH(THIS-OBJECT:filename) <> ? THEN DO:
       parseFile().
   END. ELSE DO:
       parseBlank().
   END.
   
 END METHOD.
/**
 * Метод выводит содержимое как будто
 * якоря идут друг за другом.
 **/
METHOD PROTECTED VOID parseBlank():
    PUT UNFORMATTED "*** ВНИМАНИЕ НЕ НАЙДЕН ШАБЛОН ***" SKIP.
    PUT UNFORMATTED "*** WARNING OBJECT DIDN'T FIND TEMPLATE ***" SKIP.
    PUT UNFORMATTED SKIP.
    PUT UNFORMATTED SKIP.
    
    FOR EACH anchor-value NO-LOCK:
        PUT UNFORMATTED "*** " anchor-value.code " ***" SKIP.
        showAnchorValue(anchor-value.code).
        PUT UNFORMATTED "****" SKIP.
    END.
END METHOD.
METHOD PROTECTED VOID setServiceTags():
                                        /*************************************************************
                                         *                                                                                           *
                                         * Метод проставляет служебные тэги                                   *
                                         * Служебный тэг - это тэг начинающийся с                           *
                                         * конструкции Get-<что-либо>, значение которого           *
                                         * определяется в самом шаблонизаторе                           *
                                         * Сервисный тэг может принимать значение НП           *
                                         * если совпадает с ним по имени.                                   *
                                         *                                                                                           *
                                         *************************************************************/
DEF VAR oSysClass AS TSysClass NO-UNDO.
oSysClass = new TSysClass().

addAnchorValue("GET-RUNTIME",RunTime).                               /* В миллисекундах */
addAnchorValue("GET-DATE",TODAY).                                    /* Текущая дата */
addAnchorValue("GET-TIME",STRING(TIME,"HH:MM:SS")).                  /* Время в формате hh:mm:ss */
addAnchorValue("GET-USERFIO",oSysClass:getUserFIO()).                /* ФИО текущего пользователя */
addAnchorValue("GET-USERPOST",oSysClass:getUserPost()).              /* Должность пользователя */
addAnchorValue("GET-USERFIOSHORT",oSysClass:getUserFIO(USERID("bisquit"),"F i. o.")).
DELETE OBJECT oSysClass.

END METHOD.


METHOD PROTECTED VOID setSysClassTags(INPUT cClass AS CHARACTER):
                                        /***********************************************************************************
                                         * Якорь является не простым текстовым якорем,                                             *
                                         * а указателем на системный объект.                                                                     *
                                         * Поэтому надо подставить соответствующие значения.                              *
                                         * ПОКА УМЕЕТ РАБОТАТЬ ТОЛЬКО С НАСТРОЕЧНЫМИ ПАРАМЕТРАМИ!!!   *
                                         ***********************************************************************************/

   DEF VAR oSysClass   AS TSysClass NO-UNDO.
   DEF VAR currSetting AS CHAR      NO-UNDO.
   DEF VAR bankName     AS CHAR      NO-UNDO.
   DEF VAR bankNameFull AS CHAR      NO-UNDO.

   currSetting = ENTRY(2,cClass,"|").

   oSysClass = new TSysClass().

    /***
     * В связи с необходимостью обеспечения
     * темпорированности наименования банка.
     ***/
    IF    currSetting = "Банк" 
       OR currSetting = "БанкСтар" THEN DO:
             RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).
             addAnchorValue(cClass,bankName).
       END.

    IF     currSetting = "БанкПолное" 
        OR currSetting = "БанкПолноеСтар" THEN DO:
             RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).
             addAnchorValue(cClass,bankNameFull).
       END.

       


         CASE NUM-ENTRIES(cClass,"|"):
               WHEN 2 THEN DO:
                  addAnchorValue(cClass,oSysClass:getSetting(ENTRY(2,cClass,"|"))).
               END.
               WHEN 3 THEN DO:
                  addAnchorValue(cClass,oSysClass:getSetting(ENTRY(2,cClass,"|"),ENTRY(3,cClass,"|"))).
               END.
         END CASE.

 DELETE OBJECT oSysClass.

END METHOD.

DESTRUCTOR TTpl():
                                /****************************************************************
                                 *                                                              *
                                 * Я тебя породил я тебя и убью.                                *
                                 *                                                              *
                                 *****************************************************************/
FOR EACH anchor-value:
  DELETE OBJECT anchor-value.code-value-object NO-ERROR.
END.

EMPTY TEMP-TABLE anchor-value.
EMPTY TEMP-TABLE anchor-param-value.
END DESTRUCTOR.

END CLASS.