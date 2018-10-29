using Progress.Lang.*.

CLASS TDocCollect INHERITS TDocCollectBase:

/*************************

  Класс-коллекция документов, удовлетворяющих указанным условиям.
  Автор: Маслов Д. А.
  Дата создания: 25.04.2009
  Дата модификации: 22.07.2009

**************************/

CONSTRUCTOR TDocCollect():
	SUPER().
END CONSTRUCTOR.

METHOD PROTECTED OVERRIDE CHARACTER getQuery():
             /***************************************
              * Формирует запрос на основе          *
              * установленных полей                 *
              ***************************************/             

 DEFINE VARIABLE cQuery AS CHARACTER. 
 
 cQuery = "FOR EACH bOp WHERE bOp.op-date>=" + STRING(date-beg) + " AND bOp.op-date<=" + STRING(date-end) + " <#MIN_OP_COND#> 
 AND bOp.user-id MATCHES '" + user-id + "' AND bOp.doc-num MATCHES '" + doc-num + "' AND bOp.ben-acct MATCHES '" + acct-rcpt + "' <#DOC_TYPE#> <#BEG_DOC_STATUS#> <#END_DOC_STATUS#>,FIRST bOpEntry OF bOp
 WHERE CAN-DO('" + acct-db + "',bOpEntry.acct-db) <#ACCT_COND#> CAN-DO('" + acct-cr + "',bOpEntry.acct-cr) <#KASS_SYMBOL#>".

 /* Отбор по OP.OP */
 IF beg-op NE ? THEN cQuery = REPLACE(cQuery,"<#MIN_OP_COND#>","AND bOp.op>" + QUOTER(beg-op)).
  ELSE cQuery = REPLACE(cQuery,"<#MIN_OP_COND#>","").

 /* Отбор по кассовому символу */
 IF kassSymbol NE ? THEN cQuery = REPLACE(cQuery,"<#KASS_SYMBOL#>","AND symbol=" + QUOTER(STRING(kassSymbol))).
  				    ELSE cQuery = REPLACE(cQuery,"<#KASS_SYMBOL#>","").


 /* Отбор по типу документа */
  IF doc-type NE "*" AND doc-type NE ? THEN cQuery = REPLACE(cQuery,"<#DOC_TYPE#>"," AND CAN-DO('"+ doc-type + "',TRIM(bOp.doc-type))").
								      ELSE cQuery = REPLACE(cQuery,"<#DOC_TYPE#>","").
     
 /* Добавляем отбор по статусам документа */  
  IF beg-status NE ? THEN cQuery = REPLACE(cQuery,"<#BEG_DOC_STATUS#>"," AND bOp.op-status >= " + QUOTER(beg-status)).
				  ELSE cQuery = REPLACE(cQuery,"<#BEG_DOC_STATUS#>","").

  IF end-status NE ? THEN cQuery = REPLACE(cQuery,"<#END_DOC_STATUS#>"," AND bOp.op-status <= " + QUOTER(end-status)).
				  ELSE cQuery = REPLACE(cQuery,"<#END_DOC_STATUS#>","").

/* Логическое условие на основании которого осуществляется поиск счетов */
 IF isAcctAND THEN cQuery = REPLACE(cQuery,"<#ACCT_COND#>","AND").
              ELSE cQuery = REPLACE(cQuery,"<#ACCT_COND#>","OR").

 cQuery = REPLACE(cQuery,"<#SORT_ORDER#>",sortOrder).
 
RETURN cQuery.
END METHOD.

METHOD PROTECTED OVERRIDE VOID setBuffers(INPUT hQuery AS HANDLE):
   hQuery:SET-BUFFERS(BUFFER bOp:HANDLE,BUFFER bOpEntry:HANDLE).
END METHOD.

END CLASS.