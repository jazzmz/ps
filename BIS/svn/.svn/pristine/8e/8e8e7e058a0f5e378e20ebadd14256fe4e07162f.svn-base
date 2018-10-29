/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: Ž€Ž Š "PŽŒˆ‚…‘’€‘—…’"
     Filename: pir-pko.p
      Comment: Žâç¥â ¯® ª«¨¥­âã ä®à¬¨àãîé¨© à¥¥áâà ¯« â¥¦¥© ¯® ­¤ä« ¨ ¯à®¢®¤®ª ¯® á­ïâ¨î ¤¥­ áà¥¤áâ¢
   Parameters: 
         Uses: Globals.I tmprecid.def SetDest.I Signatur.I Preview.I
      Used by: -
      Created: 20/10/2008 Templar
     Modified:
*/

{globals.i}

DEFINE VAR i	as int  no-undo.
DEFINE VAR client_id	as int  no-undo.

DEFINE VAR summadoc	as int  no-undo.
DEFINE VAR summadoc2	as int  no-undo.

DEFINE VAR date1		as date  no-undo.
DEFINE VAR v_name		as char  no-undo.
DEFINE VAR v_racct	as char  no-undo.


/*--------------------------------------- Main ------------------------------------------------------------------*/

DEFINE INPUT PARAM date2 AS DATE NO-UNDO.
MESSAGE "‚¢¥¤¨â¥ ¤ âã ä®à¬¨à®¢ ­¨ï ®âç¥â " UPDATE date2 .


{setdest.i}

{tmprecid.def}

FOR EACH tmprecid NO-LOCK,
FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK: 

 IF AVAIL cust-corp THEN 
	DO:

	v_Name = cust-corp.name-corp.
	client_id = cust-corp.cust-id.
	date1 = date2 - 45.

	PUT UNFORMATTED v_name SKIP.

	FOR EACH acct WHERE  acct.cust-id = client_id AND acct.cust-cat EQ "ž"  AND  acct.contract EQ " áç¥â":     
	DO:	
		v_racct = acct.acct .
			


	PUT UNFORMATTED  'à/á ' v_racct SKIP.
	PUT UNFORMATTED date1 ' - ' date2 SKIP(1).
	PUT UNFORMATTED "ÕÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸" SKIP
      	                "³   „ â    ³        ü ‘ç¥â        ³     ‘ã¬¬        ³             §­ ç¥­¨¥ ¯« â¥¦             ³" SKIP
            	        "ÆÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍµ" SKIP.
      


		/* ‘Ž‘Ž 1 : „‚€ æ¨ª« ! */
		/* ˆé¥¬ ¨­â¥à¥áãîé¨¥ ­ á ¤®ªã¬¥­âë */
		/* á­ ç «  ¢­¥è­¨¥ ¯« â¥¦¨ ­  40101 á ­¤ä« ¨ â¤	
		summadoc = 0.
		FOR each op WHERE op.ben-acct BEGINS '40101' AND CAN-DO ('*­¤ä«*,*­  ¤®å®¤ë*,*¯®¤®å®¤*',TRIM (op.details)) AND op.op-date >= date1 AND op.op-date <= date2 NO-LOCK,
			FIRST op-entry OF op WHERE ( (op-entry.acct-cr BEGINS '30102') AND ( op-entry.acct-db EQ v_racct )  ) NO-LOCK:
	 			PUT UNFORMATTED '| ' op.op-date  ' | '  op.ben-acct  ' | 'op-entry.amt-rub FORMAT "->>>,>>>,>>9.99" ' | ' op.details FORMAT "X(30)" ' |' SKIP.
				summadoc = summadoc + op-entry.amt-rub . 
			END.
		END.
		PUT UNFORMATTED '³ ˆâ®£® ' summadoc FORMAT "->>>,>>>,>>9.99" SKIP.

		 ¯®â®¬ á­ïâ¨ï á Š‘=40 
	
		summadoc2 = 0.
		FOR each op WHERE op.op-date >= date1 AND op.op-date <= 10/10/08 NO-LOCK,
			FIRST op-entry OF op WHERE ( (op-entry.acct-cr BEGINS '20202') AND ( op-entry.acct-db EQ v_racct ) AND (op-entry.symbol EQ "40" ) ) NO-LOCK:
 				PUT UNFORMATTED '| ' op.op-date  ' | '  op-entry.acct-cr  ' | 'op-entry.amt-rub FORMAT "->>>,>>>,>>9.99" ' | ' op.details FORMAT "X(30)" ' |' SKIP.
				summadoc2 = summadoc2 + op-entry.amt-rub . 
			END.
		END.
		PUT UNFORMATTED '| ˆâ®£® ' summadoc2 FORMAT "->>>,>>>,>>9.99" SKIP.
		*/


	/* ‘Ž‘Ž 2 : ®¤­¨¬ æ¨ª«®¬ */
	summadoc = 0.
	summadoc2 = 0.

		FOR each op WHERE op.op-date >= date1 AND op.op-date <= date2 NO-LOCK,
		FIRST op-entry OF op WHERE ((op-entry.acct-db EQ v_racct) AND ( op-entry.acct-cr BEGINS '30102' OR op-entry.acct-cr BEGINS '20202')) NO-LOCK:
	 		IF  op-entry.acct-cr BEGINS '30102' AND op.ben-acct BEGINS '40101' AND CAN-DO ('*­¤ä«*,*­  ¤®å®¤ë*,*¯®¤®å®¤*',TRIM (op.details)) THEN
			DO:	PUT UNFORMATTED '³ ' op.op-date  ' ³ '  op.ben-acct  ' ³ 'op-entry.amt-rub FORMAT "->>>,>>>,>>9.99" ' ³ ' op.details FORMAT "X(30)" ' ³' SKIP.
				summadoc = summadoc + op-entry.amt-rub .
			END.
			IF  op-entry.acct-cr BEGINS '20202' AND  op-entry.symbol EQ "40"	THEN
			DO:	PUT UNFORMATTED '³ ' op.op-date  ' ³ '  op-entry.acct-cr  ' ³ 'op-entry.amt-rub FORMAT "->>>,>>>,>>9.99" ' ³ ' op.details FORMAT "X(40)" ' ³' SKIP.
				summadoc2 = summadoc2 + op-entry.amt-rub . 
			END.
		END.
		END.

		PUT UNFORMATTED "ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" SKIP(1).	
		PUT UNFORMATTED ' ˆ’ŽƒŽ '  SKIP(1).
		PUT UNFORMATTED ' ‚­¥è­¨¥ ¤¥¡¥â®¢ë¥ ¯« â¥¦¨:            ' summadoc FORMAT "->>>,>>>,>>9.99" SKIP(1).
		PUT UNFORMATTED ' à®¢®¤ª¨ ¯® á­ïâ¨î ¤¥­. áà¥¤áâ¢:      ' summadoc2 FORMAT "->>>,>>>,>>9.99" SKIP.
		summadoc2 = summadoc2 / 10 .
		PUT UNFORMATTED ' å 0,10                                ' summadoc2 FORMAT "->>>,>>>,>>9.99" SKIP(2).
	END.
	END.
END.


{signatur.i}
{preview.i}
