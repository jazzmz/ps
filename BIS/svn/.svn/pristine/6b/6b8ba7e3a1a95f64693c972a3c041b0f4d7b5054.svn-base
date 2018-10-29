DEF INPUT PARAM ipDataID AS INT64 NO-UNDO.

{globals.i}
{norm.i}


MESSAGE ipDataId VIEW-AS ALERT-BOX.

/**
 * Пронумеруем операции.
 **/

DEF VAR i AS INT64 INIT 1 NO-UNDO.



FOR EACH DataLine WHERE Data-Id EQ ipDataID 
                    AND NOT LOGICAL(DataLine.Sym3) 
                    BREAK BY Sym2 BY val[9]:
   
   IF FIRST-OF(DataLine.Sym2) THEN DO:
     i = 1.
   END.

   DataLine.val[3]=i.
   i = i + 1.
END.
