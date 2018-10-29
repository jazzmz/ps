CLASS TDocCollectWPos INHERITS TDocCollectBase:

  DEFINE PRIVATE VARIABLE dminPos AS DECIMAL INITIAL 0 		     NO-UNDO.
  DEFINE PRIVATE VARIABLE dmaxPos AS DECIMAL INITIAL 999999999999999 NO-UNDO.
  DEFINE PRIVATE VARIABLE cAcct AS CHARACTER			     NO-UNDO.
  
  DEFINE PUBLIC PROPERTY minPos AS DECIMAL
    GET:
      RETURN dminPos.
    END GET.
    SET (INPUT cProp AS DECIMAL):
      dminPos = cProp.
    END SET.

    DEFINE PUBLIC PROPERTY maxPos AS DECIMAL
      GET:
        RETURN dmaxPos.
      END GET.
      SET (INPUT cProp AS DECIMAL):
        dmaxPos = cProp.
      END SET.

    DEFINE PUBLIC PROPERTY filter-acct AS CHARACTER
      GET:
         RETURN cAcct.
      END GET.
      SET (INPUT cProp AS CHARACTER):
         isAcctAND=false.
         acct-db=cProp.
         acct-cr=cProp.
         cAcct = cProp.
      END SET.
      
CONSTRUCTOR TDocCollectWPos():
  SUPER().
END CONSTRUCTOR.

METHOD PROTECTED OVERRIDE CHARACTER getQuery():

    DEFINE VARIABLE cQuery AS CHARACTER.

    cQuery = "FOR EACH bOpEntry WHERE (bOpEntry.op-date >= " + QUOTER(date-beg) + " 
		       AND bOpEntry.op-date <=" + QUOTER(date-end) + " AND bOpEntry.acct-db EQ 
			" + QUOTER(acct-db) + ") OR (bOpEntry.op-date >= " + QUOTER(date-beg) + " 
			AND bOpEntry.op-date <= " + QUOTER(date-end) + " AND bOpEntry.acct-cr EQ " + QUOTER(acct-cr) + ") 
			NO-LOCK,FIRST bOp OF bOpEntry WHERE NO-LOCK BY bOpEntry.op-date BY bOpEntry.amt-rub INDEXED-REPOSITION".

  RETURN cQuery.

END METHOD.

METHOD PROTECTED OVERRIDE VOID setBuffers(INPUT hQuery AS HANDLE):
  hQuery:SET-BUFFERS(BUFFER bOpEntry:HANDLE,BUFFER bOp:HANDLE).
END METHOD.

METHOD PROTECTED OVERRIDE LOGICAL additionalFilterByTDoc(INPUT oDoc AS TDocument):
        /***********************************
         * Перегружаем метод доп. отбора   *
         ***********************************/
        DEFINE VARIABLE dPos AS DECIMAL.
       
        dPos = oDoc:getPos(cAcct).        
        
        IF dPos GE minPos AND dPos LE maxPos THEN
           DO:
               RETURN TRUE.
           END.
           ELSE RETURN FALSE.
END METHOD.

END CLASS.