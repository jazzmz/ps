CLASS TDocHist INHERITS TDocument:
                      
CONSTRUCTOR TDocHist(INPUT iOp AS INTEGER):
  SUPER(iOp,TODAY).
END CONSTRUCTOR.

CONSTRUCTOR TDocHist(INPUT rOp AS RECID):
  SUPER(rOp).
END CONSTRUCTOR.
METHOD PUBLIC CHARACTER getModifAttrWValue(INPUT cAttrCode AS CHARACTER):
                                    /****************************************
                                     * Метод возвращает историю изменений
                                     * реквизита cAttrCode со значениями
                                     * через запятую
                                     ****************************************/


END METHOD.

METHOD PUBLIC CHARACTER whoModifAttr(INPUT cAttrCode AS CHARACTER):
                        /**********************************
                         *  Список людей которые изменяли *  
                         * реквизит cAttrCode             *
                         **********************************/
            DEF VAR cResult AS CHARACTER INITIAL "" NO-UNDO.

		
	    /**********************************
             *                                *
             * Если документ аннулирован,     *
             * то необходимо вывести всю      *
             * его истрорию.                  *
             *				      *
             **********************************/
            FOR EACH history WHERE history.file-name EQ ClassType 
			           AND (history.modif-date >= DocDate OR DocDate EQ ?)
                                   AND field-value MATCHES "*" + cAttrCode + "*" 
				   AND field-ref = STRING(doc-id) NO-LOCK:
                    cResult = cResult + history.user-id + ",".
            END.
        cResult = SUBSTRING(cResult,1,LENGTH(cResult) - 1).
        RETURN cResult.
END METHOD.

END CLASS.