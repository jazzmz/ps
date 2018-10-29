/***************************
 * Процедура контроля	   *
 * связанных документов	   *
 ***************************/

{globals.i}
{flt-file.i}
{intrface.get instrum}
{def-wf.i new}
{op-115fl.def}


DEF PARAMETER BUFFER bOp FOR op.
DEF INPUT  PARAMETER iParam   AS CHARACTER NO-UNDO.

/*** ВНИМАНИЕ ЭТА ПЕРЕМЕННАЯ ОБЯЗАТЕЛЬНО БЕЗ NO-UNDO ***/
DEF OUTPUT PARAMETER oResult1 AS LOGICAL  INIT NO.


DEF VAR vstatus         LIKE op.op-status      NO-UNDO.
DEF VAR iTrans          LIKE op.op-transaction NO-UNDO.


DEF VAR cur-op-date     AS DATE      NO-UNDO.
DEF VAR flager  	AS INT64     NO-UNDO.
DEF VAR iDocCount	AS INT	     NO-UNDO.
DEF VAR shDo		AS LOGICAL   NO-UNDO INIT FALSE.
DEF VAR trList          AS CHAR      NO-UNDO INIT "!*".
DEF VAR sc		AS CHARACTER NO-UNDO INIT "".
DEF VAR roleList	AS CHARACTER NO-UNDO.

DEF VAR oSysClass	AS TSysClass NO-UNDO.
DEF VAR oUser		AS TUser     NO-UNDO.
DEF VAR p_QUEST  	AS LOGICAL   NO-UNDO INIT TRUE.
DEF VAR mRetVal 	AS CHARACTER NO-UNDO.


 /*******************************
  * Получаем список,            *
  * ролей с кодом 05            *
  * для определения связанных   *
  * транзакций.                 *
  *******************************
  *
  * Автор: Маслов Д. А.
  * Заявка: #758
  * Дата: 19.09.11
  *
  ********************************/
 oUser     = new TUser().
	 roleList = oUser:getRoleList("05*").
 DELETE OBJECT oUser.

 /**
  * Получаем список связанных транзакций.
  **/
 oSysClass = new TSysClass().
    trList = oSysClass:getCodeValue("PirLnkTrList",roleList,"!*").
 DELETE OBJECT oSysClass.

action:
DO TRANSACTION ON ERROR UNDO, RETURN:

 oResult1 = YES.


IF CAN-DO(trList,bOp.op-kind) THEN DO:

/****************************
 * Считаем документы        *
 * связанные с аннулируемым.*
 ****************************/

FOR EACH op WHERE op.op-transaction EQ bOp.op-transaction 
			AND op.op NE bOp.op
			AND op.op-status GT "А" NO-LOCK:

	iTrans = op.op-transaction.
	ACCUMULATE op.op (COUNT).

END. /* FOR EACH */

iDocCount = (ACCUM COUNT op.op).

IF iDocCount > 0 THEN DO:
sc = GetSysConf("pir-lnk-op" + STRING(iTrans)).

IF NOT {assigned sc} THEN DO:

	MESSAGE "С документом связано еще " iDocCount  " документов.\n"
		"Удалять текущий документ вместе со связанными?" 
	         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET vChoice AS LOGICAL.
    shDo = (IF vChoice EQ ? THEN NO ELSE vChoice).

IF NOT shDo THEN DO: 
 MESSAGE "Действие отменено пользователем!" VIEW-AS ALERT-BOX.
 RUN DeleteOldDataProtocol IN h_base ("pir-lnk-op" + STRING(iTrans)).
 UNDO ACTION. 
END.

   RUN SetSysConf IN h_base ("pir-lnk-op" + STRING(iTrans),iDocCount).

         FOR EACH op WHERE op.op-transaction EQ bOp.op-transaction 
			   AND op.op NE bOp.op
			   AND op.op-status GT "А" EXCLUSIVE-LOCK:

	                   ASSIGN
		              cur-op-date = ?
		              vstatus = "А"
			   .
			

                         /*****************************************
                          *
                          * По #1090 подключена
                          * проверка прав доступа.
                          *
                          *****************************************
                          *
                          * Автор  : Маслов Д. А. Maslov D. A.
                          * Создано: 14.08.12
                          * Заявка : #1090
                          ******************************************/
			 RUN CheckOpRight IN h_base(RECID(op),?,"Ann") NO-ERROR.

                         IF ERROR-STATUS:ERROR THEN DO:
                              MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                              RUN DeleteOldDataProtocol IN h_base ("pir-lnk-op" + STRING(iTrans)).
                              UNDO ACTION, RETURN.
                         END. ELSE DO:

	                 {chst(op.i &open-undo  = "DO: RUN DeleteOldDataProtocol IN h_base ('pir-lnk-op' + STRING(iTrans)). undo action, return 'Ошибка проведения операции.'.  END. "
                                    &kau-undo   = "DO: RUN DeleteOldDataProtocol IN h_base ('pir-lnk-op' + STRING(iTrans)). undo action,  return 'Ошибка проведения операции.'. END. "
                                    &xattr-undo = "DO: RUN DeleteOldDataProtocol IN h_base ('pir-lnk-op' + STRING(iTrans)). undo action, return 'Ошибка проведения операции.'. END. "
                                    &undo       = "DO:  RUN DeleteOldDataProtocol IN h_base ('pir-lnk-op' + STRING(iTrans)). undo action, return 'Ошибка проведения операции.'. END. "
                                    &visa="choice eq 1"}
                          END.
           END. /* END sc */

         END. /* FOR EACH */


END. /* Есть линкованные документы */
END. /* Если транзакция линкованная */

RUN DeleteOldDataProtocol IN h_base ("pir-lnk-op" + STRING(iTrans)).
/*************************************************************************************************/


/***************************
 * Аннулирование связанных документов
 * по связи PirLnkCom.
 ***************************
 * 
 * Автор : Токарев В. Tokarev V.
 * Заявка: #1303
 *
 ****************************/


FOR FIRST xlink WHERE xlink.link-code = "PirLnkCom" NO-LOCK,

 FIRST links WHERE  ( (INT64(links.source-id) = bOp.op
                      AND links.link-id = xlink.link-id)
                   OR (INT64(links.target-id) = bOp.op
                      AND links.link-id = xlink.link-id)
                     ) NO-LOCK:

  IF AVAILABLE links THEN
    DO:
      FIND FIRST op WHERE op.op NE bOp.op
                      AND op.op-status GT "А"
                      AND op.op = (if bop.op = INT64(links.target-id)
                                   then int64(links.source-id)
                                   else int64(links.target-id)
                                   ) NO-LOCK NO-ERROR.

      IF AVAILABLE op THEN
        DO:

          MESSAGE "Документ имеет <ДопСвязь> с другим документом.\n"
                  " Дата документа:" op.op-date  "\n"
                  "Номер документа:" op.doc-num  "\n"
                  "Номер операции:" op.op  "\n"
                  "Удалять текущий документ вместе со связанным?"
                  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO SET p_Choice AS LOGICAL.
 
          p_QUEST = p_Choice.
          IF NOT p_QUEST THEN DO: UNDO ACTION. END.

           ASSIGN
            cur-op-date = ?
            vstatus = "А"
           .

          FIND CURRENT op EXCLUSIVE-LOCK NO-WAIT NO-ERROR.


 	  RUN CheckOpRight IN h_base(RECID(op),?,"Ann") NO-ERROR.

          IF ERROR-STATUS:ERROR THEN DO:

                 MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX ERROR BUTTONS OK.
                 UNDO ACTION, RETURN.

          END.

          {chst(op.i
                    &open-undo = "UNDO action, RETURN 'Ошибка при аннулировании документа'"
                   }

           /******************************************************************************/

        END.
    END.

END.  /*** FOR  ***/
/*************************************************************************************************/

END. /* END ACTION */


{intrface.del}