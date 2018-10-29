/*************************
 * Инклюдник проверяет
 * единственность исполнителя
 * и контролера для выбранных
 * документов.
 *************************/

DEF BUFFER chkBuf FOR op.
DEF BUFFER chkBufOpEntry FOR op-entry.

DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.

DEF VAR cRootPath AS CHARACTER INITIAL "/home2/bis/quit41d/imp-exp/docum/" NO-UNDO.   /* Обязательно наличие завершающего слэша */

DEF VAR cPath AS CHARACTER NO-UNDO.

/*** ПЕРЕМЕННЫЕ ДЛЯ ХРАНЕНИЯ ПОДСТАНОВОК ***/
DEF VAR cUserIdRep   AS CHARACTER NO-UNDO.
DEF VAR cUserInspRep AS CHARACTER NO-UNDO.
DEF VAR ipcsc AS INTEGER NO-UNDO.

DEF VAR isExistsUnload AS LOGICAL INITIAL FALSE NO-UNDO.	/* Есть ли в наборе документ, который уже выгружен?   */
DEF VAR isBadStatus    AS LOGICAL INITIAL FALSE NO-UNDO.	/* В отобранном наборе есть непотвержденный документ? */

DEF VAR dCurrDate AS DATE NO-UNDO.				/* Дата текущего опер. дня */
DEF VAR oSysClassPCS AS TSysClass NO-UNDO.

/*** Получаем значение счетчика нумерации ***/
{pir-c2346u.i}

oSysClassPCS = new TSysClass().
/**** 
      ЗАПУСК ВОЗМОЖЕН ИЗ ПРОВОДОК
      ИЛИ ДОКУМЕНТОВ. ПОЭТОМУ
      НЕОБХОДИМЫ РАЗНЫЕ ПРОХОДЫ
 ****/

&IF DEFINED(MULTI-FROM-ENTRY) &THEN
  FOR EACH tmprecid,
    FIRST chkBufOpEntry WHERE RECID(chkBufOpEntry) EQ tmprecid.id NO-LOCK,
     FIRST chkBuf WHERE chkBuf.op EQ chkBufOpEntry.op NO-LOCK BREAK BY chkBuf.user-id BY chkBuf.user-inspector:
&ELSE
FOR EACH tmprecid,
  FIRST chkBuf WHERE RECID(chkBuf) EQ tmprecid.id NO-LOCK BREAK BY chkBuf.user-id BY chkBuf.user-inspector:
&ENDIF

  IF FIRST-OF(chkBuf.user-id) THEN DO:
	 dCurrDate    = chkBuf.op-date.
         curr-user-id = chkBuf.user-id.
	 ACCUMULATE chkBuf.user-id (COUNT).
	END.
  
  IF FIRST-OF(chkBuf.user-inspector) THEN DO:
         curr-user-inspector = chkBuf.user-inspector.
         ACCUMULATE chkBuf.user-inspector (COUNT). 
	END.

IF INT64(getXAttrValue("op",STRING(chkBuf.op),"PirA2346U")) > 1000 THEN DO:
  /**********************
   * В выбранных документах,
   * найден уже выгруженный 
   * в архив.
   ***********************/
  isExistsUnload = TRUE.
  MESSAGE "В ОТОБРАННОМ НАБОРЕ СУЩЕСТВУЕТ УЖЕ ВЫГРУЖЕННЫЙ ДОКУМЕНТ!\nДАЛЬЕЙШАЯ ВЫГРУЗКА ЗАПРЕЩЕНА!" VIEW-AS ALERT-BOX.
  RETURN.
  LEAVE.
END.

  /************************
   *
   * В выбранных документах,
   * есть неподтвержденный документ.
   *
   *************************/

IF NOT CAN-DO(FGetSetting("PirEArch","PirPermitStatus","!*"),chkBuf.op-status) THEN DO:
  isBadStatus = TRUE.
  MESSAGE "В ОТОБРАННОМ НАБОРЕ СУЩЕСТВУЕТ НЕ ПОДТВЕРЖДЕННЫЙ ДОКУМЕНТ!\nДАЛЬНЕЙШАЯ ВЫГРУЗКА ЗАПРЕЩЕНА!" VIEW-AS ALERT-BOX.
  RETURN.
  LEAVE.
END.

END.

/*****
 * Проверка на попытку
 * выгрузки из закрытого
 * дня.
 *****/
IF oSysClassPCS:getLastCloseDate() >= dCurrDate 
   AND NOT CAN-DO(FGetSetting("PirEArch","WCUnCloseDate","!*"),USERID("bisquit")) THEN DO:
  MESSAGE "ВЫГРУЗКА ДОКУМЕНТОВ ИЗ ЗАКРЫТОГО ДНЯ В АРХИВ ЗАПРЕЩЕНА!" VIEW-AS ALERT-BOX.
  RETURN.
END.

&IF DEFINED(notCheckAuthorInspector)=0 &THEN
IF (ACCUM COUNT chkBuf.user-id) > 1 OR (ACCUM COUNT chkBuf.user-inspector) > 1 THEN DO:
	MESSAGE COLOR WHITE/RED "В ВЫБРАННЫХ ДОКУМЕНТАХ РАЗНЫЕ ИСПОЛНИТЕЛЬ ИЛИ КОНТРОЛЛЕР" VIEW-AS ALERT-BOX.
        RETURN "Error".
END.
&ENDIF

/*** ПРОИЗВОДИМ ЗАМЕНУ ИСПОЛНИТЕЛЕЙ И КОНТРОЛЛЕРОВ ***/

&IF DEFINED(ur) &THEN

/*** Получаем подстановку для исполнителя ***/
  cUserIdRep = GetCodeName("PirEarch","{&ur}").

  cUserIdRep = REPLACE(cUserIdRep,"USERID",USERID("bisquit")).

  IF NUM-ENTRIES(cUserIdRep) > 1 THEN DO:

	/*** В КЛАССИФИКАТОРЕ БОЛЬШЕ ОДНОЙ ЗАПИСИ ***/

	IF ENTRY(1,cUserIdRep) EQ "USER-ID" THEN DO:

 	  DO ipcsc = 2 TO (NUM-ENTRIES(cUserIdRep) - 1):
		IF curr-user-id = ENTRY(ipcsc,cUserIdRep) THEN DO:
			curr-user-id = ENTRY(ipcsc + 1,cUserIdRep).
		END.
	  END. /* END DO */

        END.    /* IF ENTRY */

  END.        /* END NUM-ENTRIES */

&ENDIF
&IF DEFINED(cr) &THEN
/*** Получаем подстановку для контроллера ***/

  cUserIdRep = GetCodeName("PirEarch","{&cr}").

  cUserIdRep = REPLACE(cUserIdRep,"USERID",USERID("bisquit")).

  IF NUM-ENTRIES(cUserIdRep) > 1 THEN DO:

	/*** В КЛАССИФИКАТОРЕ БОЛЬШЕ ОДНОЙ ЗАПИСИ ***/

	IF ENTRY(1,cUserIdRep) EQ "CNT-ID" THEN DO:

 	  DO ipcsc = 2 TO (NUM-ENTRIES(cUserIdRep) - 1):
		IF curr-user-inspector = ENTRY(ipcsc,cUserIdRep) THEN DO:
			curr-user-inspector = ENTRY(ipcsc + 1,cUserIdRep).
		END.
	  END. /* END DO */

        END.    /* IF ENTRY */

  END.        /* END NUM-ENTRIES */

/*** Получаем подстановку для контроллера ***/



&ENDIF

RELEASE chkBuf.
DELETE OBJECT oSysClassPCS.