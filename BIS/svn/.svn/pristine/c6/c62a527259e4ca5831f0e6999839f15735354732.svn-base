CLASS TLastOpEntry INHERITS TOpEntry:

  DEFINE BUFFER bOpEntry1 FOR op-entry. /* Дополнительный буффер для op-entry */


CONSTRUCTOR PUBLIC TLastOpEntry(INPUT cAcct AS CHARACTER,INPUT dDate AS DATE): 
	SUPER().      
	FIND LAST bOpEntry WHERE (bOpEntry.acct-db=cAcct OR bOpEntry.acct-cr=cAcct) AND bOpEntry.op-date<>? AND bOpEntry.op-date<=dDate NO-LOCK NO-ERROR.
        fillOpEntry(BUFFER bOpEntry:HANDLE).
  END METHOD.

END CLASS.