{globals.i}
{tmprecid.def}        /** Используем информацию из броузера */
{getdate.i}

{setdest.i}

PUT UNFORMATTED "Дополнительные реквизиты по состоянию на " STRING(gend-date, "99.99.99") SKIP.

FOR EACH tmprecid NO-LOCK
	, FIRST person
		WHERE RECID(person) 	= tmprecid.id
		NO-LOCK
	BY person.name-last
:

       	DEF VAR v_cust-code-type AS CHARACTER   NO-UNDO INIT "АдрФакт,АдрПроп".
       	DEF VAR vAddress     AS CHARACTER   NO-UNDO EXTENT 2.
       	DEF VAR j            AS INT         NO-UNDO.
       	DEF VAR vKodReg	     AS CHARACTER   NO-UNDO COLUMN-LABEL "КодРег".
	vKodReg = "".
       	DO j = 1 TO NUM-ENTRIES(v_cust-code-type):
        	FIND FIRST cust-ident
               		WHERE (    cust-ident.close-date = ?
                   		OR cust-ident.close-date >= gend-date)
                   		AND cust-ident.class-code   = 'p-cust-adr'
                   		AND cust-ident.cust-cat     = 'Ч'
                   		AND cust-ident.cust-id      = person.person-id
                   		AND cust-ident.cust-code-type   = ENTRY(j, v_cust-code-type)   
                			NO-LOCK NO-ERROR.
		IF AVAIL cust-ident THEN DO:
            		vAddress[j] = (IF AVAIL cust-ident THEN cust-ident.issue ELSE "").
			DEF VAR cSurr AS CHAR NO-UNDO.
    			cSurr = cust-ident.cust-code-type + ','
          			+ cust-ident.cust-code      + ','
          			+ STRING(cust-ident.cust-type-num).

			IF cust-ident.cust-code-type = "АдрПроп"
  			  THEN vKodReg = REPLACE(GetXAttrValue("cust-ident", cSurr, "КодРег"), "000", "").
		END.
		ELSE ASSIGN
			vAddress[1]	= ""
			vAddress[2]	= ""
		.
       	END.

  DEF VAR vOKATO_302 AS CHAR NO-UNDO COLUMN-LABEL "ОКАТО_302".
  vOKATO_302 = GetXAttrValue("person", STRING(person.person-id), "ОКАТО_302").

  IF vOKATO_302 <> "" AND vOKATO_302 <> vKodReg
    THEN DISP
		person.name-last + ' ' + person.first-name FORMAT "X(50)"
		vOKATO_302
		vKodReg
  			WITH WIDTH 240.
END.

{preview.i}
