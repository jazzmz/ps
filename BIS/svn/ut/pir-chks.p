/*
   Транзакция изменяет кассовые символы
   по счетам выделенным в браузере счетов
   за период дат указанным в глобальных параметрах
   с выдачей подтверждающего запроса
*/

{globals.i}

{wordwrap.def}

/*******************************************************************   Служебные переменные **************************************************************/

DEFINE VARIABLE lChoice AS LOG NO-UNDO.
DEFINE VARIABLE lQueryResult AS LOGICAL NO-UNDO.
DEFINE VARIABLE lChoiceDirectOp AS LOG NO-UNDO.
DEFINE VARIABLE iCountChanges AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE cOldKassSymbol AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewKassSymbol AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
DEFINE VARIABLE cTextQuery AS CHARACTER NO-UNDO.

{tmprecid.def}        /** Используем информацию из броузера */

/*********************************************************** Конец определения служебных переменных ************************************************/


FUNCTION  CreateMessageHeader RETURNS CHARACTER (cOpNumber AS CHARACTER, cOpDate AS DATE, cCreate AS CHARACTER, dSum AS DECIMAL,cAcctDb AS CHARACTER,cAcctCr AS CHARACTER).

/*******************************************
 *		                                *
 * Функция формирует заголовок        *
 * окна запроса.			*
 *				*
 *******************************************/
DEFINE VARIABLE str AS CHARACTER NO-UNDO.
 str="Изменить проводку в документе " + cOpNumber + " в " + STRING(cOpDate) + " введенный "  + cCreate + "\n На сумму " + STRING(dSum) + "\n По дебету " + cAcctDb + "\n По кредету " + cAcctCr.
 RETURN str.
END.


PROCEDURE changeOpEntry:
/**************************************************************
 *				                             *
 * Процедура производи изменение проводки               *
  *					              *
  ***************************************************************/
  DEFINE INPUT PARAMETER iOpID AS INTEGER.
  DEFINE INPUT PARAMETER cOldKassSymbol AS CHARACTER.
  DEFINE INPUT PARAMETER cNewKassSymbol AS CHARACTER.
 

DO:
    DISABLE TRIGGERS  FOR LOAD OF op-entry.
    UPDATE op-entry SET op-entry.symbol=cNewKassSymbol WHERE op-entry.op=iOpID AND op-entry.symbol=cOldKassSymbol.
END.

END.

   MESSAGE "Изменяем приходный документ ?"  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lChoiceDirectOp.
   
   if lChoice EQ YES THEN
      DO:
            
      END.
      
   MESSAGE "Введите старый кассовый символ ? " UPDATE cOldKassSymbol.
   MESSAGE "Введите новый кассовый символ  ? " UPDATE cNewKassSymbol.
     
   
   CREATE QUERY hQuery.
   hQuery:SET-BUFFERS(BUFFER op-entry:HANDLE).
   
    FOR EACH tmprecid, FIRST acct WHERE tmprecid.id=RECID(acct):
            /* По всем счетам */
             
              cTextQuery = "FOR EACH op-entry WHERE op-entry.<cond1>=" + QUOTER(acct.acct) + " AND op-entry.symbol=" + QUOTER(cOldKassSymbol) + " AND " +  QUOTER(gbeg-date) + "<=op-entry.op-date AND op-entry.op-date<=" + QUOTER(gend-date).

              IF lChoiceDirectOp THEN 
                 DO:
                    cTextQuery = REPLACE(cTextQuery,"<cond1>","acct-cr").
                  END.
                      ELSE
                          DO:
                          	cTextQuery = REPLACE(cTextQuery,"<cond1>","acct-db").
                           END.            
	
	lQueryResult = hQuery:QUERY-PREPARE(cTextQuery).

	IF lQueryResult THEN
	    DO:
	             
	              hQuery:QUERY-OPEN().

		          hQuery:GET-FIRST(NO-LOCK).
		          REPEAT WHILE NOT hQuery:QUERY-OFF-END:

			 /********************** По всем документам ******************/
     	                                           FIND FIRST op WHERE op.op=op-entry.op.
	          	                                 DO:
		                                       MESSAGE CreateMessageHeader(op.doc-num,op.op-date,op.user-id,op-entry.amt-rub,op-entry.acct-db,op-entry.acct-cr) VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lChoice.

			                        IF lChoice EQ YES THEN
			                              DO:
			                                   /* Необходимо выполнить изменение */
			                                  RUN changeOpEntry(op.op,cOldKassSymbol,cNewKassSymbol).
			                              END. /* Конец положительного ответа оператора */			                  
	          	                                 END. /* Конец по всем документа */
	          	                /********************** По всем документам ***************/
	          	                
	          	                  hQuery:GET-NEXT(NO-LOCK).
		            END. /* Конец по всем проводка */	           
	             hQuery:QUERY-CLOSE().
	   END. /* Если запрос не содержит ошибок */
	
    END. /* Конец  по выбранным счетам */        