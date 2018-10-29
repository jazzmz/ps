CLASS TBase:
   /****************************************************
    *                                                 *
    * Базовый класс. По сути предназначен             *
    * для работы с таблицами метосхемы                *
    * и дополнительными таблицами.                    *
    *                                                 *
    ****************************************************/
    

   {set-prop.i &aa="ClassType" &bb="cClassType"  &cc="CHARACTER" &perms="PROTECTED"}        /* Название таблицы на которой построен класс        */
   {set-prop.i &aa="Surrogate"  &bb="cSurrogate"   &cc="CHARACTER" &perms="PROTECTED"}	       /* Определяет суррогат объекта                                     */
   {set-prop.i &aa="ClassCode" &bb="cClassCode"  &cc="CHARACTER" &perms="PROTECTED"}	       /* Класс объекта.                                                                */

   /**********************************************
     *                                           *
     *  Предполагается, что определение класса   *
     * будет производиться в классе наследнике.  *
     * Конечно если бы была возможность в ABL    *
     * я бы сделал этот класс абстрактным        *
     * 						 *
  ************************************************/
CONSTRUCTOR TBase():

END CONSTRUCTOR.

METHOD PROTECTED LOGICAL isIndexed(INPUT cXAttrCode AS CHARACTER):
               /****************************************
                *                                     * 
                * Метод возвращает TRUE,              *
                * если реквизит индексируемй          *
                * и FALSE иначе.                      *
                *                                     *
                ****************************************/
               FIND FIRST xAttr WHERE xAttr.class-code=ClassCode AND xAttr.XAttr-code = cXAttrCode NO-LOCK NO-ERROR.

                    IF AVAILABLE(xAttr) THEN
          		     DO:
               			/* Доп. рек определен в метасхеме */
          	     		RETURN xAttr.indexed.
          		     END.
	                    ELSE DO:
                                 DISPLAY "Неопр. реквизит:" ClassCode "." cXattrCode.
                                 RETURN ?.		
                            END.

END METHOD.

/***
 * Возвращает значения темпорированных доп. реков в виде
 * dDate => Value.
 * @param CHAR cXAttrCode Наименование дополнительного реквизита
 * @param DATE dActionDate Дата до которой необходимо смотреть дополнительные реквизиты
 * @return TAArray
 ***/

METHOD PUBLIC TAArray getTemporalValues(INPUT cXAttrCode AS CHAR,INPUT dActionDate AS DATE):
 DEF VAR oAArray AS TAArray NO-UNDO.

 oAArray = NEW TAArray().
 IF isIndexed(cXAttrCode) THEN DO:
       FOR EACH tmpsigns WHERE tmpsigns.code=cXAttrCode 
                           AND tmpsigns.since <= dActionDate 
                           AND tmpsigns.file-name=ClassType 
                           AND tmpsigns.surrogate=cSurrogate NO-LOCK:
                                   oAArray:setH(since,code-value).
       END.
 END. ELSE DO:
       FOR EACH tmpsigns WHERE tmpsigns.code=cXAttrCode 
                           AND tmpsigns.since <= dActionDate 
                           AND tmpsigns.file-name=ClassType 
                           AND tmpsigns.surrogate=cSurrogate NO-LOCK:
                                   oAArray:setH(since, xattr-value).
       END.                                 
 END.

RETURN oAArray.
  
END METHOD.

  METHOD PROTECTED CHARACTER getValue(INPUT val1 AS CHARACTER,INPUT val2 AS CHARACTER,INPUT cXAttrName AS CHARACTER,INPUT cXAttrType AS CHARACTER):

                /*****************************************
		 * Определить где храниться	     *
		 * значение доп. река можно	     *
		 * по запросу в метасхему.	     * 
		 *				     * 
		 * Делать запрос для каждого доп.    *
		 * река весьма расточительно,	     *
		 * но пока у меня не сложилась	     *
		 * общая картина метасхемы лучше     *
		 * не могу ничего придумать	     *
		 * ОЧЕНЬ НЕКРАСИВЫЙ МЕТОД	     *	
		 * ПОЗЖЕ ПЕРЕДЕЛАТЬ!!!		     *
                 *****************************************/
    IF isIndexed(cXAttrName) THEN RETURN val1. ELSE RETURN val2.
	
END METHOD.   

METHOD PUBLIC CHARACTER getXAttr(INPUT cXAttrCode AS CHARACTER):

      FIND FIRST signs WHERE signs.file-name=ClassType AND signs.surrogate=Surrogate AND signs.code=cXAttrCode NO-LOCK NO-ERROR.

      IF AVAILABLE(signs) THEN        
          DO:
            IF isIndexed(cXAttrCode) THEN RETURN code-value. ELSE RETURN xattr-value.
          END.
          ELSE RETURN ?.   
END METHOD.

/**
 * Метод возвращает TRUE если 
 * темпорированный реквизит хотя 
 * бы один раз с течением времени изменял свое значение.
 * @param CHAR cXAttrCode  название темпорированного реквизита
 * @param DATE dActionDate дата раньше которой будет проверяться изменение
 * @return LOG
 **/
METHOD PUBLIC LOG isTmpAttrChanged(
                                   INPUT cXAttrCode AS CHAR,
                                   INPUT dActionDate AS DATE
                                   ):

  DEF VAR vOldVal AS CHAR INIT ?     NO-UNDO.
  DEF VAR vRes    AS LOG  INIT FALSE NO-UNDO.



  FOR EACH tmpsigns WHERE tmpsigns.file-name = THIS-OBJECT:ClassType
                      AND tmpsigns.surrogate = THIS-OBJECT:surrogate
                      AND tmpsigns.code      = cXAttrCode             
                      AND tmpsigns.since    <= dActionDate NO-LOCK:
    IF vOldVal <> ? AND vOldVal <> (IF isIndexed(cXAttrCode) THEN tmpsigns.code-value ELSE tmpsigns.xattr-value) THEN DO:
         vRes = TRUE.
         LEAVE.
    END.

    vOldVal = IF isIndexed(cXAttrCode) THEN tmpsigns.code-value ELSE tmpsigns.xattr-value.

  END.

 RETURN vRes.

END METHOD.

METHOD PUBLIC CHARACTER getXAttr(INPUT cXAttrCode AS CHARACTER,INPUT dActionDate AS DATE):

                     /*********************************************
                      *                                		 *
                      * Функция возвращает значение              *
                      * доп. реквизитов объекта.                 *
                      * Захватывает при это темпориро-           *
                      * ванные.                                  *
                      * Алгоритм работы след.:                   *
                      * 1. Смотрим теморированный,               *
                      * классификатор cXAttrCode;                *
                      * 2. Если такой не установлен,             *
                      * то есть нет записи в БД,                 *
                      * то возвращаем значение обычного          *
                      * доп. реквизита.                          *
                      *********************************************/

 FIND LAST tmpsigns WHERE tmpsigns.code=cXAttrCode 
                      AND tmpsigns.since <= dActionDate 
                      AND tmpsigns.file-name=ClassType 
                      AND tmpsigns.surrogate=cSurrogate NO-LOCK NO-ERROR.

     IF AVAILABLE(tmpsigns) THEN
          IF isIndexed(cXAttrCode) THEN RETURN code-value. ELSE RETURN xattr-value.
     ELSE
          RETURN ?.
     
     
END METHOD.

 METHOD PUBLIC CHARACTER getXAttrWDef(INPUT cXAttrCode AS CHARACTER,INPUT cDefault AS CHARACTER):
                     /**********************************
                      * Возвращает значение доп. река  *
                      * в случае если он не установлен *
                      * возвращает значение cDefault   *
                      ***********************************/
      DEF VAR tmpXAttrRes AS CHARACTER.

      tmpXAttrRes = getXAttr(cXAttrCode).
      
       IF tmpXAttrRes EQ ? THEN RETURN cDefault.
                           ELSE RETURN tmpXAttrRes.
END METHOD.

 METHOD PUBLIC CHARACTER getXAttrWDef(INPUT cXAttrCode AS CHARACTER,INPUT dActionDate AS DATE,INPUT cDefault AS CHARACTER):
                    /***********************************************
                     * Возвращает значение доп. реквизита  *
                     * (обычного или темпорированного)          *
                     * в случае если он не установлен             *
                     * возвращает значение cDefault               *
                     ***********************************************/
      DEF VAR cResult AS CHARACTER NO-UNDO.
      
      cResult = getXAttr(cXAttrCode,dActionDate).
      IF cResult EQ ? THEN RETURN cDefault.
                      ELSE RETURN cResult.
 END METHOD.                     



 METHOD PUBLIC VOID setXAttr(INPUT cXAttrCode AS CHARACTER,INPUT cXAttrValue AS CHARACTER):

     FIND FIRST xAttr WHERE xAttr.class-code=ClassType AND xAttr.xattr-code=cXAttrCode NO-LOCK NO-ERROR.

          /***********************************************************
           *  Так как речь идет об установке доп. реквизита,  *
           * то сначала проверь его наличие в метасхеме.      *
           ************************************************************/

      IF AVAILABLE(xAttr) THEN
          DO:
             	   /* Доп. рек определен в метасхеме */
                   FIND FIRST signs WHERE signs.file-name=ClassType AND signs.surrogate=Surrogate AND signs.code=cXAttrCode NO-LOCK NO-ERROR.
                             
                            IF AVAILABLE(signs) THEN
                               DO:
                                   /* Доп. реквизит уже установлен и в таблице signs есть запись */
                         	     IF xAttr.indexed  THEN signs.code-value=cXAttrValue.  ELSE signs.xattr-value=cXAttrValue.
                               END.
                               ELSE
                                 DO:                                        
                                       CREATE signs.
                                              ASSIGN
                                                     signs.file-name=ClassType
                                                     signs.surrogate=cSurrogate
                                                     signs.code=cXAttrCode
                                              .
                                       	 IF xAttr.indexed  THEN signs.code-value=cXAttrValue. ELSE signs.xattr-value=cXAttrValue.
                                 END.
          END. /* Конец если доп. рек. установлен на метасхеме */
END METHOD.

METHOD PUBLIC VOID rmXAttr(INPUT cXAttrCode AS CHARACTER):
                    /**********************************
                     * Удаляет данные значение  *
                     * доп. реквизита.                    *
                     **********************************/

FIND FIRST signs WHERE signs.file-name=cClassType AND signs.surrogate=cSurrogate AND signs.code=cXAttrCode NO-ERROR.

 IF AVAILABLE(signs) THEN
   DO:
/*      DELETE signs.*/
   END.


END METHOD.

METHOD PUBLIC LOGICAL isValidXAttr(INPUT cXAttrCode AS CHARACTER):
		/*******************************************************
		 *										                                *
		 * Проверка допустимости использования доп.   *
           * реквизита                                                             *
		 *										                                *
		 ********************************************************/
	FIND FIRST xAttr WHERE xAttr.Class-Code=ClassType AND xAttr.xattr-code=cXAttrCode NO-LOCK NO-ERROR.
     IF AVAILABLE(xAttr) THEN RETURN TRUE. ELSE RETURN FALSE.
END METHOD.

METHOD PUBLIC VOID getHistory():
              /************************************
               * Возвращает всю историю объекта   *
               ************************************/
END METHOD.
END CLASS.