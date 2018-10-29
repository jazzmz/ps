CLASS TDoc INHERITS TBase 
           IMPLEMENTS IDoc:
	/**********************************
	 *
	 * Клас представляющий документ
         *
         ***********************************/

	/*****************************************************
	 * Определяем таблицу с ошибками		    *
	 * по документу.						    *
	 * Лучше использовать классы ошибок,          *
	 * но в ABL это есть только в новых версиях.  *
	 ****************************************************/

DEF TEMP-TABLE bufErrList NO-UNDO
			      FIELD iErrCode    AS CHARACTER
			      FIELD cErrDetails AS CHARACTER
			      FIELD class-code  AS CHARACTER		/* Класс ошибки */
			.

{set-prop.i &aa="user-id" &bb="cuser-id"  &cc="CHARACTER"}
{set-prop.i &aa="doc-num" &bb="cDoc-Num"  &cc="CHARACTER"}
{set-prop.i &aa="doc-status"  &bb="cDocStatus"   &cc="CHARACTER"}
{set-prop.i &aa="created" &bb="dtCreated" &cc="DATETIME"}
{set-prop.i &aa="doc-id"  &bb="idoc-id"   &cc="INTEGER" &perms="PROTECTED"}
{set-prop.i &aa="details" &bb="cDetails"  &cc="CHARACTER"}
{set-prop.i &aa="DocDate" &bb="dDocDate"  &cc="DATE" &perms="PROTECTED"}
{set-prop.i &aa="isErrorState" &bb="lisErrorState"  &cc="LOGICAL"  &init="FALSE"}

  CONSTRUCTOR TDoc():

  END CONSTRUCTOR.

METHOD PRIVATE VOID addError(INPUT iErrorCode AS CHARACTER,INPUT cDetails AS CHARACTER):
 addError(iErrorCode,cDetails,"common").
END METHOD.

METHOD PROTECTED VOID addError(INPUT iErrorCode AS CHARACTER,INPUT cDetails AS CHARACTER,INPUT cClassCode AS CHARACTER):
	/*******************************************************
	 * Метод добавляет новую ошибку к документу. *
	 *******************************************************/
	IF NOT CAN-FIND(bufErrList WHERE iErrCode = iErrorCode AND class-code = cClassCode)  THEN
		DO:
			isErrorState = TRUE.
			CREATE bufErrList.
			ASSIGN
					iErrCode = iErrorCode
					cErrDetails = cDetails
					class-code = cClassCode
				.
		END.

END METHOD.

METHOD PRIVATE VOID delError(INPUT iErrorCode AS CHARACTER):
		/*********************************************************
		 *										    *
		 *  Метод удаляет ошибку с кодом iErrorCode .     *
		 *  Если таблица с ошибками пустая, то документ *
		 * помечается как безошибочный				    *
		 *										   *
		*********************************************************/

END METHOD.

METHOD PUBLIC CHARACTER  getListErrorCode():
	RETURN getListErrorCode("*").
END METHOD.


METHOD PUBLIC CHARACTER  getListErrorDetails():
	RETURN getListErrorDetails("*").
END METHOD.

/*****************************************************
 * Метод возвращает перечень ошибок через	     *
 * запятую.					     *
 *****************************************************/
METHOD PUBLIC CHARACTER  getListErrorCode(INPUT cClassCode AS CHAR,INPUT iPrefix AS CHAR):

	DEF VAR cResult AS CHAR INITIAL "" NO-UNDO.

	FOR EACH bufErrList WHERE CAN-DO(cClassCode,class-code):
		cResult = cResult + iPrefix + STRING(bufErrList.iErrCode) + ",".
        END.
   RETURN cResult.
END METHOD.

METHOD PUBLIC CHARACTER  getListErrorCode(INPUT iClassCode AS CHAR):
   RETURN getListErrorCode(iClassCode,"").
END METHOD.

METHOD PUBLIC CHARACTER getListErrorDetails(INPUT cClassCode AS CHARACTER):
	      /************************************************************
		*
	        * Метод возвращает комментарии к ошибкам через
		* запятую
		*
		************************************************************/
	DEF VAR cResult AS CHARACTER INITIAL "".
	
	FOR EACH bufErrList WHERE CAN-DO(cClassCode,bufErrList.class-code):
		cResult = cResult + STRING(bufErrList.cErrDetails) + ",".
        END.
   
   RETURN cResult.
END METHOD.

DESTRUCTOR PUBLIC TDoc():
 EMPTY TEMP-TABLE bufErrList.
END DESTRUCTOR.


END CLASS.