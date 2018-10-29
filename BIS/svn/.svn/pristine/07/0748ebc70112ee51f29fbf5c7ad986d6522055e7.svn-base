FUNCTION isBankNerezCheck RETURNS LOGICAL(INPUT iRecOp AS RECID):
	
	/*************************************
	 * Фукнция проверяет является ли     *
	 * получателем денежных средств      *
	 * банк нерезидент.                  *
	 * Если получатель банк нерезидент,  *
	 * то проверяется сумма документа и  *
	 * наличие адреса в наименовании     *
         * получателя.                       *
	 *************************************
	 *                                   *
	 * Автор: Маслов Д. А. Maslov D. A.  *
	 * Заявка: #638                      *
	 * Дата создания: 18.02.11           *
	 *                                   *
	 *************************************/

	DEF VAR oDocument AS TPaymentOrder.

	DEF VAR cName AS CHARACTER.
	DEF VAR cBankNerList AS CHARACTER.
	DEF VAR dSumEdge AS DECIMAL.

	DEF VAR lRes AS LOGICAL.
	DEF VAR cStr1 AS CHARACTER.
	DEF VAR cError AS CHARACTER.
 
	

	oDocument = new TPaymentOrder(iRecOp).

	/*************************************************
	 * Получаем маску проверки счетов            *
	 * из НП. Если такого нет, то исключаем     *
	 * все документы из проверки.                    *
	 ************************************************/
	cBankNerList = FGetSetting("PirChkOp","PirBankNerList","!*").
	dSumEdge = DECIMAL(FGetSetting("PirChkOp","PirBankNerEdge","0")).


	IF  oDocument:direct EQ "out" AND CAN-DO(cBankNerList,oDocument:acct-rec) AND oDocument:sum >= dSumEdge THEN 
	    DO:

		/****************************************
		 *			       		*
		 * Банк является нерезидентом и         *
		 * сумма документа больше,		*
		 * пограничной.				*
		 *                                      *
                 ****************************************/

		cName = oDocument:name-send.

/*****************************************************************************************
 *                                                                                       *
 * Изначально предполагалось использование						 *
 * регулярного выражения.								 *
 * IF NOT ereg(cName,'^.*[/]{2}.*[/]{2}$',OUTPUT cStr1,INPUT-OUTPUT cError) THEN	 *
 * Но напоролся на ошибку в БИСе.							 *
 * Проинформировал Давыдову и заменил на CAN-DO .					 *
 *                                                                                       *
******************************************************************************************/

		IF NOT CAN-DO('*//*//*',cName) THEN
			DO:

   			  MESSAGE COLOR WHITE/RED "НЕПРАВИЛЬНОЕ НАИМЕНОВАНИЕ ПЛАТЕЛЬЩИКА! " SKIP
						  "ДОКУМЕНТ №" + oDocument:doc-num + " . На сумму: " + STRING(oDocument:sum) SKIP
			                           VIEW-AS ALERT-BOX TITLE "[ОШИБКА #638]".
				RETURN FALSE.
			END.			
	    END.	/* END oDocument:direct = "out" */

        DELETE OBJECT oDocument.
	RETURN TRUE.
END FUNCTION.
