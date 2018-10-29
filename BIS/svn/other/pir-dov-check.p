/*
                ญชฎขแช ๏ จญโฅฃเจเฎข ญญ ๏ แจแโฅฌ  ‘ชขจโ
    Copyright: €  "P…‘’€‘—…’"
     Filename: pir-dov-check.p
      Comment: ฅคฎฌฎแโ์ แฎ แเฎช ฌจ คฎขฅเฅญญฎแโฅฉ ฏฎ ชซจฅญโ ฌ. 
   Parameters: 
         Uses: Globals.I SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 28/04/2009 Templar
     Modified: 01/02/12 SStepanov คฎก ขซฅญฎ ข ฌ แชใ แ็ฅโฎข 30109* ฏฎ ง ฏเฎแใ  ฏจโ ญฎขฎฉ ..
*/

{globals.i}

DEFINE VAR client_id as int  no-undo.
DEFINE VAR client_name as char  no-undo.
DEFINE VAR corp_id as int  no-undo.
DEFINE VAR corp_name as char  no-undo.
DEFINE VAR symb as char no-undo.
DEFINE VAR schet as char no-undo.

DEFINE TEMP-TABLE tt-custcorp
	FIELD name AS CHAR 
	FIELD typedov AS CHAR 
	FIELD schet AS CHAR
	FIELD date1 AS DATE
	FIELD date2 AS DATE
	INDEX main date2 ASCENDING name ASCENDING.



DEFINE TEMP-TABLE tt-person
	FIELD name AS CHAR 
	FIELD typedov AS CHAR 
	FIELD schet AS CHAR
	FIELD date1 AS DATE
	FIELD date2 AS DATE
	INDEX main date2 ASCENDING name ASCENDING.



/*--------------------------------------- Main ------------------------------------------------------------------*/



{getdates.i}

symb = "-".


{setdest.i &cols=80 }

PUT UNFORMATTED '          โ็ฅโ ฏฎ แเฎช ฌ คฅฉแโขจ๏ คฎขฅเฅญญฎแโฅฉ       ' SKIP(1) .


/*------------------------------------------------------------------------------------------------------*/




									
FOR EACH cust-corp :
DO:	
	corp_id = cust-corp.cust-id .

	
	/**   ญคจช โฎเ เ กฎโ๋   **/
	put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
   	   CASE symb :
	          WHEN "\\"  THEN symb = "|".
	          WHEN "|"   THEN symb = "/".
	          WHEN "/"   THEN symb = "-".
	          WHEN "-"   THEN symb = "\\".
	      END CASE.

	FOR EACH cust-role WHERE cust-role.file-name EQ "cust-corp" AND cust-role.surrogate EQ STRING(corp_id) 
	AND CAN-DO ("เ ขฎ_คฎข_ฏฎคฏจแจ,เ ขฎ_ฏฅเขฎฉ_ฏฎคฏจแจ",cust-role.class-code)
	AND cust-role.close-date GE beg-date AND cust-role.close-date LE end-date :		

		FIND FIRST acct WHERE 	acct.cust-cat = '' AND acct.cust-id = corp_id AND 
					(acct.close-date EQ ? OR  acct.close-date GE beg-date ) AND
					CAN-DO ('’ฅชใ้, แ็ฅโ',acct.contract) NO-LOCK NO-ERROR.
	
			IF AVAIL acct THEN DO:
				CREATE tt-custcorp .
				tt-custcorp.name = cust-corp.name-corp .
				tt-custcorp.schet = acct.acct .
				tt-custcorp.typedov = cust-role.class-code .
				tt-custcorp.date1 = cust-role.open-date .
				tt-custcorp.date2 = cust-role.close-date .
			END.	


		END.
	END.
END.


FOR EACH banks :
  DO:	
	client_id = banks.bank-id.

	/**   ญคจช โฎเ เ กฎโ๋   **/
	put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
   	   CASE symb :
	          WHEN "\\"  THEN symb = "|".
	          WHEN "|"   THEN symb = "/".
	          WHEN "/"   THEN symb = "-".
	          WHEN "-"   THEN symb = "\\".
	      END CASE.

	FOR EACH cust-role WHERE cust-role.file-name EQ "banks" 
				AND cust-role.surrogate EQ STRING(client_id) 
				AND CAN-DO ("เ ขฎ_คฎข_ฏฎคฏจแจ,เ ขฎ_ฏฅเขฎฉ_ฏฎคฏจแจ",cust-role.class-code)  
				AND cust-role.close-date GE beg-date
				AND cust-role.close-date LE end-date :

	FIND FIRST acct WHERE 	acct.cust-cat = ''
			    AND acct.cust-id = client_id
			    AND (acct.close-date EQ ? OR  acct.close-date GE beg-date )
			    AND CAN-DO ('ฎเฎ',acct.contract)
			NO-LOCK NO-ERROR.

		IF AVAIL acct THEN DO:
				CREATE tt-custcorp.
				tt-custcorp.name    = banks.name.
				tt-custcorp.schet   = acct.acct .
				tt-custcorp.typedov = cust-role.class-code .
				tt-custcorp.date1   = cust-role.open-date .
				tt-custcorp.date2   = cust-role.close-date .
			END.	
		

    END.
  END.
END.


PUT UNFORMATTED '                I. เจคจ็ฅแชจฅ ซจๆ         ' SKIP(1) .
PUT UNFORMATTED "ีอออออออออออออออออออออออออออออออออัออออออออออออออออออออออัออออออออออออออออออออออัออออออออออออัออออออออออออธ" SKIP
                "ณ             ซจฅญโ              ณ        ‘็ฅโ          ณ   ’จฏ คฎขฅเฅญญฎแโจ   ณ     โ     ณ     โ     ณ" SKIP
                "ณ                                 ณ                      ณ                      ณ   ญ ็ ซ    ณ ฎชฎญ็ ญจ๏  ณ" SKIP
                "ฦอออออออออออออออออออออออออออออออออุออออออออออออออออออออออุออออออออออออออออออออออุออออออออออออุออออออออออออต" SKIP.

FOR EACH tt-custcorp:

	PUT UNFORMATTED 'ณ' tt-custcorp.name FORMAT 'X(33)' 'ณ ' tt-custcorp.schet FORMAT 'X(20)'  ' ณ ' tt-custcorp.typedov FORMAT 'X(20)' ' ณ '  tt-custcorp.date1 FORMAT '99/99/9999'   ' ณ '  tt-custcorp.date2 FORMAT '99/99/9999' ' ณ'   SKIP.

END.

PUT UNFORMATTED "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤู" SKIP(2).                                                     


/*------------------------------------------------------------------------------------------------------*/


FOR EACH person :
  DO:	
	client_id = person.person-id.

	/**   ญคจช โฎเ เ กฎโ๋   **/
	put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
   	   CASE symb :
	          WHEN "\\"  THEN symb = "|".
	          WHEN "|"   THEN symb = "/".
	          WHEN "/"   THEN symb = "-".
	          WHEN "-"   THEN symb = "\\".
	      END CASE.

	FOR EACH cust-role WHERE cust-role.file-name EQ "person" 
				AND cust-role.surrogate EQ STRING(client_id) 
				AND CAN-DO ("เ ขฎ_คฎข_ฏฎคฏจแจ,เ ขฎ_ฏฅเขฎฉ_ฏฎคฏจแจ",cust-role.class-code)  
				AND cust-role.close-date GE beg-date AND cust-role.close-date LE end-date :

	FIND FIRST acct WHERE 	acct.cust-cat = '—' AND acct.cust-id = client_id AND 
				(acct.close-date EQ ? OR  acct.close-date GE beg-date ) AND
				CAN-DO ('’ฅชใ้, แ็ฅโ',acct.contract) NO-LOCK NO-ERROR.

		IF AVAIL acct THEN DO:
				CREATE tt-person .
				tt-person.name = person.name-last + ' ' + person.first-names.
				tt-person.schet = acct.acct .
				tt-person.typedov = cust-role.class-code .
				tt-person.date1 = cust-role.open-date .
				tt-person.date2 = cust-role.close-date .
			END.	
		

  END.
END.
END.


PUT UNFORMATTED '                II. ”จงจ็ฅแชจฅ ซจๆ         ' SKIP(1) .

PUT UNFORMATTED "ีอออออออออออออออออออออออออออออออออัออออออออออออออออออออออัออออออออออออออออออออออัออออออออออออัออออออออออออธ" SKIP
                "ณ             ซจฅญโ              ณ         ‘็ฅโ         ณ   ’จฏ คฎขฅเฅญญฎแโจ   ณ     โ     ณ     โ     ณ" SKIP
                "ณ                                 ณ                      ณ                      ณ   ญ ็ ซ    ณ ฎชฎญ็ ญจ๏  ณ" SKIP
                "ฦอออออออออออออออออออออออออออออออออุออออออออออออออออออออออุออออออออออออออออออออออุออออออออออออุออออออออออออต" SKIP.
 


FOR EACH tt-person:
	PUT UNFORMATTED 'ณ' tt-person.name FORMAT 'X(33)' 'ณ ' tt-person.schet FORMAT 'X(20)'  ' ณ ' tt-person.typedov FORMAT 'X(20)' ' ณ '  tt-person.date1 FORMAT '99/99/9999'   ' ณ '  tt-person.date2 FORMAT '99/99/9999' ' ณ'   SKIP.
END.



PUT UNFORMATTED "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤู" SKIP(2).                                                     


/*------------------------------------------------------------------------------------------------------*/

{signatur.i}
{preview.i}



