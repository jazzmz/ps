FUNCTION getDocNum RETURNS CHARACTER(INPUT bLoan AS HANDLE):

                        /*************************************************
			  *										      		*
			  * Номера в БИС хранятся в разных полях			*
			  * таблицы loan. Поэтому необходимо проверка		*
			  * какое из полей берем							*
			  *												*
			***************************************************/ 
 DEF VAR cResult AS CHARACTER.

        IF TRIM(bLoan::doc-ref) <> "" THEN cResult = bLoan::doc-ref.
	     ELSE
    	        DO:
		      IF TRIM(bLoan::doc-num) <> "" THEN cResult = bLoan::doc-num.
		      ELSE IF TRIM(bLoan::cont-code) <> "" THEN cResult = bLoan::cont-code.
	        END.
RETURN cResult.
END FUNCTION.
