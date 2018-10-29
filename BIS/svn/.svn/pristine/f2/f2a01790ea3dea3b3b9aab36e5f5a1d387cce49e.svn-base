/* pir_poln2.p - âç¥â ¯® ¯®«­®¬®ç¨ï¬ ª«¨¥­â®¢ 2 (¢ª«îç¥­ë ¤ ­­ë¥ â®«ìª® à.«¨æ)
   …—€’œ/’—…’›  ‹ˆ–…‚›Œ ‘—…’€Œ/€‡…
   01/02/12 SStepanov ¤®¡ ¢«¥­® ¢ ¬ áªã áç¥â®¢ 30109* ¯® § ¯à®áã Š ¯¨â ­®¢®© Œ.ƒ.
*/

{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}

def var typk as char no-undo.
def var blok as logical no-undo.
/* def var mBes as logical no-undo. */


/* ¢à¥¬¥­­ë¥ â ¡«¨æë ¤«ï åà ­¥­¨ï ®â®¡à ­­ëå áç¥â®¢  */
define TEMP-TABLE ttTable NO-UNDO
	field facct as char
	Field fdate as char.

define TEMP-TABLE ttTable2 NO-UNDO
	field facct as char
	Field fdate as char.

define TEMP-TABLE ttTable3 NO-UNDO
	field facct as char
	Field fdate as date.



/* message "OK" view-as alert-box. */
 
RUN messmenu.p(
       10,
       "[Š«¨¥­âë]",
       "",
       "‚á¥," +
       " ­ª-Š«¨¥­â," +
       "Šà®¬¥  ­ª-Š«¨¥­â ," +
       "‚á¥ á ¡«®ª¨à®¢ ­­ë¬¨ áç¥â ¬¨").

typk = "".
blok = NO.
/* mBes = NO. */

CASE INTEGER(pick-value):
   WHEN 1 THEN typk = "".
   WHEN 2 THEN typk = "b".
   WHEN 3 THEN typk = "n".
   WHEN 4 THEN blok = YES.
   OTHERWISE RETURN.
END CASE.

MESSAGE "‚ë¢®¤¨âì ª«¨¥­â®¢ á ¡¥ááà®ç­ë¬¨ ¯®«­®¬®ç¨ï¬¨?"
        VIEW-AS ALERT-BOX QUESTION
        BUTTONS YES-NO
        UPDATE mBes AS LOGICAL.

{setdest.i &cols=80}

def var symb as char no-undo.
def var polndt as char no-undo.
def var dtt as date no-undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "¡à ¡ âë¢ ¥âáï " + STRING(end-date,"99/99/9999") + STRING(" ","X(55)").

   PUT UNFORMATTED "                              âç¥â ¯® ¯®«­®¬®ç¨ï¬  " SKIP.
   Put unformatted "                          ­  " beg-date " - " end-date SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED  "|         ‘ç¥â         |                  ‘à®ª ¯®«­®¬®ç¨©               |" SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.

 FOR EACH acct WHERE CAN-DO("4*,30109*", acct.acct)
                        AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )
                         NO-LOCK BREAK BY acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      IF NOT blok THEN 
         IF UPPER(SUBSTR(acct.acct-status,1,4))="‹Š" THEN NEXT.

      IF typk EQ "b" THEN
         IF UPPER(TRIM(GetXAttrValue("cust-corp",STRING(acct.cust-id),"Š« ­ª"))) NE "„€" THEN NEXT.
      ELSE IF typk EQ "n" THEN
         IF UPPER(TRIM(GetXAttrValue("cust-corp",STRING(acct.cust-id),"Š« ­ª"))) EQ "„€" THEN NEXT.

      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

    /*  IF (sh-bal EQ 0)  THEN NEXT.*/

      polndt = TRIM(GetXAttrValue("acct", acct.acct + "," + acct.currency,"à¨¬1")).
 
   IF polndt NE "" THEN 
   DO:
      if polndt matches "*¡¥á*" or polndt matches "*¡/á*" then 
       do:
         create ttTable2.
         ttTable2.facct = acct.acct.
	       ttTable2.fdate = polndt.
	       update.	 
       end.
      else
       do:
        
        dtt = DATE(polndt) NO-ERROR.
  
        IF ERROR-STATUS:ERROR THEN 
        do: /* ¥¯à ¢¨«ì­ë© ä®à¬ â ¤ âë */
         create ttTable.
         ttTable.facct = acct.acct.
	       ttTable.fdate = polndt.
	       update.	 
        end.
        ELSE 
        do: 
         IF dtt>=beg-date and dtt<=end-date THEN 
         do:
         create ttTable3.
         ttTable3.facct = acct.acct.
	       ttTable3.fdate = dtt.
	       update.	 
         end.
        end.
/*            PUT UNFORMATTED  "| " acct.acct FORMAT "x(20)" " | " string(dtt,"99/99/9999") "|" acct.acct-status FORMAT "x(8)" SKIP.
*/
       end.
  END.

/*ª®­¥æ for*/
 end.
 
for each ttTable3 by fdate:
      PUT UNFORMATTED  "| " ttTable3.facct FORMAT "x(20)" " | " string(ttTable3.fdate,"99/99/9999") "                                     |" SKIP.
end.



   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.

   PUT UNFORMATTED "    âç¥â ¯® áç¥â ¬ á ­¥ª®àà¥ªâ­® § ¯®«­¥­­ë¬ à¥ª¢¨§¨â®¬ ˆŒ1 " skip.
   Put unformatted "                          ­  " beg-date " - " end-date SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED  "|        ‘ç¥â        | ‘à®ª ¯®«­®¬®ç¨©  ‡€‹… …Š…Š’!!!       |" SKIP.
   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.

 for each ttTable:
   PUT UNFORMATTED  "|" ttTable.facct FORMAT "x(20)" "| " ttTable.fdate FORMAT "x(48)" " |"  SKIP.
 end.


   PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.
   PUT UNFORMATTED " " skip.

   IF mBes THEN DO:
      PUT UNFORMATTED "    âç¥â ¯® áç¥â ¬ á ¡¥ááà®ç­ë¬¨ ¯®«­®¬®ç¨ï¬" skip.
      Put unformatted "                          ­  " beg-date " - " end-date SKIP.
      PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
      PUT UNFORMATTED  "|        ‘ç¥â        | ‘à®ª ¯®«­®¬®ç¨©                                  |" SKIP.
      PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   
      for each ttTable2:
         PUT UNFORMATTED  "|" ttTable2.facct FORMAT "x(20)" "| " ttTable2.fdate FORMAT "x(48)" " |"  SKIP.
      end.
      PUT UNFORMATTED  "+-----------------------------------------------------------------------+" SKIP.
   END.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").


{preview.i}
