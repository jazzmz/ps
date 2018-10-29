{pirsavelog.p}

/*-----------------------------------------------------------------------------
               Å†≠™Æ¢·™†Ô ®≠‚•£‡®‡Æ¢†≠≠†Ô ·®·‚•¨† Åàë™¢®‚
    Copyright: (C) 1992-2001 íéé "Å†≠™Æ¢·™®• ®≠‰Æ‡¨†Ê®Æ≠≠Î• ·®·‚•¨Î"
     Filename: swomr.p
      Comment: è•Á†‚Ï ·¢Æ§≠Æ£Æ ¨•¨Æ‡®†´Ï≠Æ£Æ Æ‡§•‡† 
   Parameters:
         Uses: 
      Used by:
      Created: 04/03/2004 kraw
     Modified: 
---------------------------------------------------------------------------*/
{globals.i}
{tmprecid.def}
/*{wordwrap.def}*/
{pp-uni.var}
/*{pp-uni.prg}*/
{flt-val.i}

DEFINE VARIABLE mNumb    AS   INTEGER                  NO-UNDO.
DEFINE VARIABLE mAmt     LIKE op-entry.amt-rub         NO-UNDO.
DEFINE VARIABLE mAmtS    LIKE op-entry.amt-rub         NO-UNDO.
DEFINE VARIABLE mDetails AS   CHARACTER EXTENT 2       NO-UNDO.
DEFINE VARIABLE mDate    AS   CHARACTER FORMAT "x(29)" NO-UNDO. 
DEFINE VARIABLE mAmtStr  AS   CHARACTER EXTENT 3       NO-UNDO.
DEFINE VARIABLE mStrTMP1 AS   CHARACTER                NO-UNDO.
DEFINE VARIABLE mStrTMP2 AS   CHARACTER                NO-UNDO.

{strtout3.i}
mDate = STRING( CAPS({term2str DATE(GetFltVal('op-date1')) DATE(GetFltVal('op-date2')) YES}), "x(30)" ).

ASSIGN
   mNumb = 0
   mAmt  = 0
.

PUT UNFORMATTED "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" SKIP.
PUT UNFORMATTED "≥        ëÇéÑçõâ åÖåéêàÄãúçõâ éêÑÖê èé ÑéäìåÖçíÄå Ñçü áÄ  " + mDate +                  "                                                             ≥"  SKIP.
PUT UNFORMATTED "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP.
PUT UNFORMATTED "≥è‡Æ¢•·‚® ØÆ ≠®¶•„™†ß†≠≠Î¨ ·Á•‚†¨ ·´•§„ÓÈ®• ß†Ø®·®:                                                                                                  ≥" SKIP.
PUT UNFORMATTED "√ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP.
PUT UNFORMATTED "≥ÑÆ™.N ≥               Ñ•°•‚              ≥              ä‡•§®‚              ≥  ë„¨¨† ¢ ≠†Ê.¢†´.  ≥ ç†ß≠†Á•≠®•                                       ≥" SKIP.
PUT UNFORMATTED "√ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP.

ASSIGN
   mAmt  = 0
   mAmtS = 0
   mNumb = 0
.

FOR EACH tmprecid,
   EACH op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
   EACH op-entry OF op NO-LOCK BREAK BY op.op BY op-entry.acct-db BY op-entry.acct-cr:

   ASSIGN
      mAmt  = mAmt  + op-entry.amt-rub
      mAmtS = mAmtS + op-entry.amt-rub
   .

   IF FIRST-OF(op.op) THEN
   DO:
      mDetails[1] = op.details.
      mDetails[2] = "".
      {wordwrap.i &s=mDetails &l=50 &n=2}
   END.

   IF LAST-OF(op-entry.acct-cr) THEN
   DO:
/*
      {empty Info-Store}
      run Collection-Info.
      RUN for-pay("ÑÖÅÖí,èãÄíÖãúôàä,ÅÄçäèã,ÅÄçäÉé,ÅÄçäîàã",
               "èè",
               OUTPUT PlName[1],
               OUTPUT PlLAcct,
               OUTPUT PlRKC[1],
               OUTPUT PlCAcct,
               OUTPUT PlMFO).
*/
    FIND FIRST op-bank of op no-lock no-error.
    	IF avail op-bank then 
	do:
           PlName[1] = op.name-ben.
           PoName[1] = GetXattrValueEx("op",string(op.op),"name-rec","").
        end.
	ELSE 
	do:
	   PlName[1] = GetXattrValueEx("op",string(op.op),"name-send","").
           PoName[1] = op.name-ben.
        end.
      IF  PlName[1] = "" then
     DO:
      FIND FIRST acct WHERE acct.acct EQ op-entry.acct-db 
         NO-LOCK NO-ERROR.

      IF AVAILABLE acct THEN
      DO:
         
         IF acct.details NE ? AND acct.details NE "" THEN
         DO:
            PlName[1] = acct.details.
         END.
         ELSE
         DO:
            {getcust.i &name=PlName &offinn=YES &offsign=YES}

            IF PlName[1] EQ ? THEN 
               PlName[1] = "".

            IF PlName[2] EQ ? THEN 
               PlName[2] = "".
            PlName[1] = TRIM(PlName[1] + " " + PlName[2]).
         END.
      END.
     END. 
      /*{wordwrap.i &s=PlName &l=34 &n=2}*/
/*
      RUN for-rec("äêÖÑàí,èéãìóÄíÖãú,ÅÄçäèéã,ÅÄçäÉé,ÅÄçäîàã",
               "èè",
               OUTPUT PoName[1],
               OUTPUT PoAcct,
               OUTPUT PoRKC[1],
               OUTPUT PoCAcct,
               OUTPUT PoMFO).
*/

    IF PoName[1] = "" then
    DO:
      FIND FIRST acct WHERE acct.acct EQ op-entry.acct-cr 
         NO-LOCK NO-ERROR.

      IF AVAILABLE acct THEN
      DO:
         
         IF acct.details NE ? AND acct.details NE "" THEN
         DO:
            PoName[1] = acct.details.
         END.
         ELSE
         DO:
            {getcust.i &name=PoName &offinn=YES &offsign=YES}

            IF PoName[1] EQ ? THEN 
               PoName[1] = "".

            IF PoName[2] EQ ? THEN 
               PoName[2] = "".
            PoName[1] = TRIM(PoName[1] + " " + PoName[2]).
         END.
      END.
     END. 
      /*{wordwrap.i &s=PoName &l=34 &n=2}*/
      PUT UNFORMATTED "≥" 
                      op.doc-num FORMAT "x(6)" "≥" 
                      op-entry.acct-db FORMAT "x(34)" "≥" 
                      op-entry.acct-cr FORMAT "x(34)" "≥" 
                      mAmt FORMAT ">>>>>>>>>>>>>>>>9.99" "≥" 
                      mDetails[1]      FORMAT "x(50)" "≥" 
                      SKIP.
      PUT UNFORMATTED "≥      ≥" 
                      PlName[1] FORMAT "x(34)" "≥" 
                      PoName[1] FORMAT "x(34)" "≥" 
                       "                    ≥" 
                      mDetails[2]      FORMAT "x(50)" "≥" 
                      SKIP.
      ASSIGN
         mAmt  = 0
         mNumb = mNumb + 1
      .
   END.

END.


PUT UNFORMATTED "√ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP.
PUT UNFORMATTED "≥ à‚Æ£Æ:" mNumb FORMAT ">>>>>9" " Ø‡Æ¢." FILL(" ",58) mAmtS FORMAT ">>>>>>>>>>>>>>>>9.99" FILL(" ",51) "≥" SKIP.
PUT UNFORMATTED "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ" SKIP.


RUN x-amtstr.p (mAmtS, '', YES, YES,
                OUTPUT mStrTMP1, OUTPUT mStrTMP2).

mAmtStr = mStrTMP1 + ' ' + mStrTMP2.

{wordwrap.i &s=mAmtStr &n=3 &l=170}

PUT UNFORMATTED  " à‚Æ£Æ: "  mAmtStr[1]  SKIP.

IF LENGTH(mAmtStr[2]) > 0 THEN
   PUT UNFORMATTED  "        "  mAmtStr[2]  SKIP.

IF LENGTH(mAmtStr[3]) > 0 THEN
   PUT UNFORMATTED  "        "  mAmtStr[3]  SKIP.

PUT UNFORMATTED SKIP(1).

PUT UNFORMATTED "è‡®´Æ¶•≠®Ô ≠† ____ ´®·‚†Â." SKIP(2).
PUT UNFORMATTED "Å„Â£†´‚•‡"+  FILL("_", 15) +  FILL(" ", 10) + "äÆ≠‚‡Æ´•‡" +  FILL("_", 15) SKIP.

PUT UNFORMATTED SKIP(3).
{endout3.i}
