{pirsavelog.p}

DEFINE VARIABLE suppress AS LOGICAL FORMAT "Ñ†/ç•‚" INIT YES NO-UNDO.
DEFINE VARIABLE cName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE t-recid  AS RECID     NO-UNDO.
DEFINE VARIABLE ss       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE Valuta   AS CHARACTER NO-UNDO.
DEFINE STREAM   xl.
DEFINE VARIABLE nFxl     AS INTEGER   NO-UNDO. /* çÆ¨•‡ ®‚•‡†Ê®® §´Ô ‰Æ‡¨®‡Æ¢†≠®Ô ®¨•≠® ‰†©´† */
DEFINE VARIABLE cFxl     AS CHARACTER NO-UNDO. /* à¨Ô ‰†©´† · ≠Æ¨•‡Æ¨ ®‚•‡†Ê®® */
DEFINE VARIABLE cCat     AS CHARACTER NO-UNDO. /* Katalog */
/*DEFINE VAR	beg-date AS DATE NO-UNDO.*/
/*DEFINE VAR	end-date AS DATE NO-UNDO.*/

{globals.i}
{tmprecid.def}
{sh-defs.i}

DEFINE temp-table w no-undo
  FIELD branch-id as char
  FIELD name      as char
  FIELD bal       like acct.bal-acct
  FIELD acct      as char
  FIELD acct-cor  as char    initial "" format "x(20)"           column-label "äÆ‡‡•·Ø.·Á•‚"
  FIELD currency  as char
  FIELD date      as date              format "99.99.9999"       column-label "Ñ†‚†Date" 
  FIELD datec     as CHAR              format "x(14)"            column-label "Ñ†‚†"  /* §´Ô Ø•Á†‚® ‚Æ´Ï™Æ */
  FIELD sort      as char    initial "5"
  FIELD in-ost    as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "ÇÂ.Æ·‚†‚Æ™"
  FIELD db        as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "é°Æ‡Æ‚Î!ÑÅ"
  FIELD cr        as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "é°Æ‡Æ‚Î!äê"
  FIELD out       as decimal initial 0 format "->>>,>>>,>>9.99"  column-label "à·Â.Æ·‚."
  index main acct currency date sort
.
DEFINE temp-table ws NO-UNDO /* Æ°Æ‡Æ‚Î ØÆ ·Á•‚†¨ §´Ô ØÆ§†¢´•≠®Ô Ø•Á†‚® ·Á•‚Æ¢ · ≠„´•¢Î¨® Æ°Æ‡Æ‚†¨® */
  FIELD w-recid  as RECID
  FIELD days-db  as decimal
  FIELD days-cr  as decimal
  index main w-recid
.

{pir_exf_exl.i}
/* {getdates.i} */
ASSIGN
	beg-date = TODAY - 1     
	end-date = TODAY - 1 
.
     
DO WHILE holiday(beg-date):
	ASSIGN
		beg-date = beg-date - 1
		end-date = end-date - 1
	.
END.



/* MESSAGE "èÆ§†¢´Ô‚Ï Ø„·‚Î• ·‡Æ™® ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE suppress. */ 
ASSIGN 	suppress = YES .


/*********************************************/
PROCEDURE PrShapka:

  put unformatted "é°Æ‡Æ‚≠Æ-·†´Ï§Æ¢†Ô ¢•§Æ¨Æ·‚Ï ß† " beg-date  skip(2).
  put unformatted "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" skip.
  put unformatted "≥             äãàÖçí             ≥     çÆ¨•‡ ·Á•‚†      ≥    ÇÂ.Æ·‚†‚Æ™   ≥   é°Æ‡Æ‚Î  ÑÅ   ≥   é°Æ‡Æ‚Î  äê   ≥     à·Â.Æ·‚.    ≥" skip.


END PROCEDURE.

PROCEDURE PrZagol:
  DEFINE INPUT PARAMETER c1 AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER c2 AS CHAR NO-UNDO.

  PUT UNFORMATTED "∆ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕµ" SKIP.
  PUT UNFORMATTED "≥" c1 FORMAT "x(32)"            "≥" c2 FORMAT "x(22)"  "≥" SPACE (17)    "≥" SPACE (17)    "≥" SPACE (17)    "≥" SPACE (17)    "≥" SKIP .


END PROCEDURE.

PROCEDURE PrStroka:
  DEFINE INPUT PARAMETER c1 AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER c2 AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER c3 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c4 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c5 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c6 AS DECIMAL NO-UNDO.

  PUT UNFORMATTED "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP .
  PUT UNFORMATTED "≥" c1 FORMAT "x(32)"            "≥ " c2 FORMAT "x(21)" "≥"
                      string(c3,"->,>>>,>>>,>>9.99") "≥"
                      string(c4,"->,>>>,>>>,>>9.99") "≥"
                      string(c5,"->,>>>,>>>,>>9.99") "≥"
                      string(c6,"->,>>>,>>>,>>9.99") "≥" SKIP .

END PROCEDURE.

PROCEDURE PrItogVal:
  DEFINE INPUT PARAMETER c2 AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER c3 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c4 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c5 AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER c6 AS DECIMAL NO-UNDO.

  PUT UNFORMATTED "∆ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕµ" SKIP.
  PUT UNFORMATTED "≥  àíéÉé :                       ≥" c2 FORMAT "x(22)"  "≥"
                   string(c3,"->,>>>,>>>,>>9.99")  "≥"
                   string(c4,"->,>>>,>>>,>>9.99")  "≥"
                   string(c5,"->,>>>,>>>,>>9.99")  "≥"
                   string(c6,"->,>>>,>>>,>>9.99")  "≥" SKIP .

END PROCEDURE.

PROCEDURE PrKonec:
  put unformatted "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" skip.


END PROCEDURE.

/* Ø•‡•¢Æ§®‚ ≠•ÆØ‡•§•´•≠≠Æ• ß≠†Á•≠®• ¢ ß≠†™ "¢ÆØ‡Æ·" ("?") */
FUNCTION GetNotEmpty CHAR (ipString AS CHAR):
   RETURN (IF (ipString EQ ?) THEN "?" ELSE (IF (ipString EQ "") THEN "--" ELSE ipString)).
END FUNCTION.

/*********************************************/

/* &GLOBAL-DEFINE ONLY-DEF-TABLE YES */
/* {flt-file.i NEW}   éØ‡•§•´•≠®• ‚†°´®Ê ‰®´Ï‚‡†. */

nFxl = 0.


  FOR EACH  acct WHERE  (acct.close-date EQ ? OR acct.close-date >= TODAY ) 
  	AND CAN-DO ('45815....000.050*,45817....000.050*,47423....000.050*,30233....000.050*',TRIM (acct.acct)) 
  	AND acct.acct-cat EQ 'b' NO-LOCK:

    RUN acct-pos IN h_base (acct.acct, acct.currency, beg-date, end-date, ?).

    cName = "".

    CASE acct.cust-cat:
       WHEN "û" THEN DO:
          FIND cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
          IF AVAIL cust-corp THEN 
             cName = TRIM(GetNotEmpty(cust-corp.name-short)).
       END.

       WHEN "ó" THEN DO:
          FIND FIRST person WHERE person.person-id = acct.cust-id NO-LOCK NO-ERROR.
          IF AVAIL person THEN
             cName = TRIM(GetNotEmpty(person.name-last)) + " " +
                     TRIM(GetNotEmpty(person.first-names)).
       END.

       WHEN "Å" THEN DO:
          FIND banks WHERE banks.bank-id = acct.cust-id NO-LOCK NO-ERROR.
          IF AVAIL banks THEN
             cName = TRIM(GetNotEmpty(banks.short-name)). 
       END.

       WHEN "Ç" THEN DO:
          cName = "*" + TRIM(acct.Details). 
       END.
    END CASE.

    IF acct.currency = "" THEN DO:
      IF NOT (suppress AND (sh-in-bal eq 0) AND (sh-db eq 0) AND (sh-cr eq 0) AND (sh-bal eq 0)) THEN DO:
        CREATE   w.
        ASSIGN   w.branch   = acct.branch-id
                 w.name     = cName /* substring(cName, 1, 32) */
                 w.bal      = acct.bal-acct
                 w.acct     = acct.acct  
                 w.currency = acct.currency
                 w.date     = beg-date
                 w.datec    = STRING(beg-date)
                 w.sort     = "0"
                 w.in-ost   = sh-in-bal
                 w.db       = sh-db
                 w.cr       = sh-cr
                 w.out      = sh-bal
        .
      END.
    END.
    ELSE
      IF NOT (suppress AND (sh-in-val eq 0) AND (sh-vdb eq 0) AND (sh-vcr eq 0) AND (sh-val eq 0)) THEN DO:
        create   w.
        assign   w.branch   = acct.branch-id
                 w.name     = cName /* substring(cName, 1, 32) */
                 w.bal      = acct.bal-acct
                 w.acct     = acct.acct  
                 w.currency = acct.currency
                 w.date     = beg-date
                 w.datec    = STRING(beg-date)
                 w.sort     = "0"
                 w.in-ost   = sh-in-val
                 w.db       = sh-vdb
                 w.cr       = sh-vcr
                 w.out      = sh-val
        .
      END.


  END. /* FOR EACH tmprecid */





  /* ÇÎ¢Æ§ ¢ ØÆ‚Æ™ */

/*  nFxl = nFxl + 1.*/

  IF HOLIDAY(TODAY) = NO 
  THEN   cFxl = "/home2/bis/quit41d/imp-exp/pcard/vip/out/prosro4ka.rpt".
  ELSE   cFxl = "/home2/bis/quit41d/imp-exp/pcard/vip/prosro4ka.rpt"
  .


  {setdest.i &cols=80 &filename = cFxl }


  RUN PrShapka.

  FOR EACH w, 
    FIRST acct   WHERE ((acct.acct = w.acct) AND (acct.currency = w.currency)) no-lock 
    BREAK BY w.currency BY w.bal BY w.name:
       
    IF FIRST-OF (w.currency) THEN DO:
      IF (w.currency EQ "") THEN valuta = "RUB".
        ELSE DO:
          FIND currency WHERE (currency.currency EQ w.currency) NO-LOCK NO-ERROR.
          valuta = IF (AVAIL currency) THEN CAPS(currency.i-currency) ELSE "çÖàáÇÖëíçÄü".
        END.
      RUN PrZagol("  ÇÄãûíÄ", valuta).
    END.

    IF FIRST-OF (w.bal) THEN
      RUN PrZagol("  ÅÄãÄçëéÇõâ ëóÖí", string(w.bal)).

    accumulate w.in-ost   (sub-total by w.bal  by w.currency)
               w.db       (sub-total by w.bal  by w.currency)
               w.cr       (sub-total by w.bal  by w.currency)
               w.out      (sub-total by w.bal  by w.currency)
    . 

    RUN PrStroka(caps(w.name), w.acct, w.in-ost, w.db, w.cr, w.out).

    IF LAST-OF(w.bal) THEN
      RUN PrItogVal("ÅÄã.ëóÖí " + string(w.bal), ACCUM SUB-TOTAL BY w.bal w.in-ost, ACCUM SUB-TOTAL by w.bal w.db,
                                               ACCUM SUB-TOTAL BY w.bal w.cr,     ACCUM SUB-TOTAL by w.bal w.out).

    IF LAST-OF(w.currency) THEN
      RUN PrItogVal("ÇÄãûíÄ " + valuta, ACCUM SUB-TOTAL by w.currency w.in-ost, ACCUM SUB-TOTAL by w.currency w.db,
                                      ACCUM SUB-TOTAL by w.currency w.cr,     ACCUM SUB-TOTAL by w.currency w.out).

  END. /* FOR EACH w */

  RUN PrKonec.
  OUTPUT STREAM xl CLOSE.

 /* {preview.i}*/

  FOR EACH w:
    DELETE w.
  END.

/*END.*/

