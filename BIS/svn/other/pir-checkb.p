/*
                ญชฎขแช ๏ จญโฅฃเจเฎข ญญ ๏ แจแโฅฌ  ‘ชขจโ
    Copyright: €  "P…‘’€‘—…’"
     Filename: pir-nost.p
      Comment: ฅคฎฌฎแโ์ เ แ็ฅโญ๋ๅ แ็ฅโฎข แ ง ค ญญ๋ฌ ญฅแญจฆ ฅฌ๋ฌ ฎแโ โชฎฌ
   Parameters: 
         Uses: Globals.I SetDest.I getdate.i Signatur.I Preview.I
      Used by: -
      Created: 04/09/2009 Templar
     Modified:
*/



DEFINE VAR name_cl AS CHAR  NO-UNDO.
DEFINE VAR schetchik AS INT  NO-UNDO.

{globals.i}

{getdate.i}

{setdest.i}


{wordwrap.def}
{tmprecid.def}
{intrface.get xclass}
{intrface.get count}

ASSIGN schetchik = 0 .


PUT UNFORMATTED '         ‘ฏจแฎช แ็ฅโฎข แ ฏเจข๏งชฎฉ ช  ญช-ชซจฅญโใ           '  SKIP(1) .
PUT UNFORMATTED "ีออออออออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ" SKIP
                "ณ      แ็ฅโญ๋ฉ แ็ฅโ     ณ                             จฌฅญฎข ญจฅ ชซจฅญโ                              ณ" SKIP
                "ณ                        ณ                                                                             ณ" SKIP
                "ฦออออออออออออออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออต" SKIP.


FOR each acct where  acct.acct begins "4" AND  acct.cust-cat = ""  AND ( acct.close-date = ? OR acct.close-date >= beg-date )   NO-LOCK: 
DO:

/*		PUT UNFORMATTED acct.acct .*/

		FIND FIRST cust-role WHERE 	cust-role.Class-Code = 'ClientBank' AND
					cust-role.open-date <= beg-date AND
					ENTRY(1,cust-role.surrogate) eq acct.acct AND
					(cust-role.close-date > beg-date OR
					 cust-role.close-date eq ?)
					 NO-LOCK NO-ERROR.
					 
		IF AVAIL cust-role then 
		DO:

			FIND FIRST cust-corp WHERE cust-corp.cust-id = acct.cust-id .
			IF AVAIL cust-corp THEN name_cl = cust-corp.name-corp. 
			PUT UNFORMATTED 'ณ  ' acct.acct  '  ณ ' name_cl FORMAT 'X(75)' ' ณ' SKIP.
			schetchik = schetchik + 1 .

      		END.




END.  
END.

PUT UNFORMATTED "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู" SKIP.


PUT UNFORMATTED ' โฎฃฎ แ็ฅโฎข   ' schetchik    SKIP(1) .

{signatur.i}

{preview.i}
 
  