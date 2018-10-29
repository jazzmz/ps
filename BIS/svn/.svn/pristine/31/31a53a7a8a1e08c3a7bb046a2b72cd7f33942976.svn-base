/*
                ญชฎขแช ๏ จญโฅฃเจเฎข ญญ ๏ แจแโฅฌ  ‘ชขจโ
    Copyright: €  "P…‘’€‘—…’"
     Filename: pir-migr.p
      Comment: โ็ฅโ ฏฎ จแโฅช่จฌ แเฎช ฌ ขจง จ ฌจฃเ ๆจฎญญ๋ๅ ช เโ
   Parameters: 
         Uses: Globals.I Signatur.i preview.i Tmprecid.def
      Used by: -
      Created: 08/10/2008 Templar
     Modified:
*/

/** ซฎก ซ์ญ๋ฅ ฎฏเฅคฅซฅญจ๏ */
{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR client_id	as int  no-undo.

DEFINE VAR vAcct	as char  no-undo.
DEFINE VAR vName	as char  no-undo.
DEFINE VAR vVisa	as char  no-undo.
DEFINE VAR vOkonpreb	as char  no-undo.
DEFINE VAR vOkonprav	as char  no-undo.


/*--------------------------------------- Main ------------------------------------------------------------------*/

DEFINE INPUT PARAM tekdate AS DATE NO-UNDO.
MESSAGE "ขฅคจโฅ ค โใ ฏเฎขฅเชจ " UPDATE tekdate.

{setdest.i}
PUT UNFORMATTED '’—…’  €, €– €’€ ‘ ‘’… ‘' SKIP(1) .

PUT UNFORMATTED "ีออออออออออออออออออออออออัอออออออออออออออออออออออออออออออออัออออออออออออออออออออออออออออออออออออออออออออัออออออออออออัออออออออออออธ" SKIP
                "ณ      แ็ฅโญ๋ฉ แ็ฅโ     ณ       จฌฅญฎข ญจฅ ชซจฅญโ        ณ     €ญชฅโ : แขฅคฅญจ๏ ฎ ข๊ฅงคญฎฉ ขจงฅ       ณ จฃเ.ช เโ  ณ จฃเ.ช เโ  ณ" SKIP
                "ณ                        ณ                                 ณ                                            ณฎชฎญ็. ฏเ ข ณฎชฎญ็.ฏเฅก-๏ณ" SKIP
                "ฦออออออออออออออออออออออออุอออออออออออออออออออออออออออออออออุออออออออออออออออออออออออออออออออออออออออออออุออออออออออออุออออออออออออต" SKIP.


FOR EACH person WHERE person.country-id NE "rus":

		Vname = person.name-last + ' ' + person.first-names.
		vAcct = "".
		client_id = person.person-id.

		FOR EACH signs WHERE  signs.file-name = "person"  AND  signs.surrogate = STRING(client_id)  :
			IF signs.code EQ "จฃเเ ขเฅกฎ" Then Vokonpreb = signs.code-value .
			IF signs.code EQ "จฃเเฅก๋ขฎ" Then Vokonprav = signs.code-value .
			IF signs.code EQ "Visa" Then Vvisa = signs.xattr-value .
		END.

		FIND FIRST acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "—"  AND  acct.contract EQ "’ฅชใ้" no-lock no-error.     
			if AVAIL acct THEN 
				DO:	
					vAcct = acct.acct .
				END.
		
	IF DATE(vokonpreb) < tekdate AND Vacct <> ""  THEN	
	PUT UNFORMATTED "ณ " Vacct FORMAT "X(22)"  " ณ " Vname FORMAT "x(31)" " ณ " Vvisa FORMAT "x(42)" " ณ " Vokonprav " ณ " Vokonpreb " ณ"  SKIP.

END.

PUT UNFORMATTED "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤู" SKIP.

{signatur.i}
{preview.i}
