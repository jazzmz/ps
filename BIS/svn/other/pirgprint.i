IF filters.recid-table = "op" THEN DO: 
	CREATE tmprecid.
	tmprecid.id = RECID(op).
END.
IF filters.recid-table = "op-entry" THEN DO:
	CREATE tmprecid.
	tmprecid.id = RECID({&tabl}).
END.
