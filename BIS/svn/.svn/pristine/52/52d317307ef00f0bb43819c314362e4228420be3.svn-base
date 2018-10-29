{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-swom.p,v $ $Revision: 1.2 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ŽŽŽ Š "p®¬¨­¢¥áâà áç¥â"
 §­ ç¥­¨¥    : à®æ¥¤ãà  ®âç¥â  à¥¥áâà  ¯à¨­ïâ®© ­ «¨ç­®áâ¨.
à¨ç¨­ 		    : ‚ ¨á®¢®© ¯à®æ¥¤ãà¥ ¯à®¨áå®¤¨â à §¤¥«¥­¨¥ ¤®ªã¬¥­â  ¯® Š‘
 à ¬¥âàë     : iRecOp - ááë«ª  ­  ã¤ «ï¥¬ãî § ¯¨áì op-entry
€¢â®à         : $Author: anisimov $ 

----------------------------------------------------- */
{globals.i}
{tmprecid.def}
{pp-uni.var}
{flt-val.i}

{get-bankname.i}

DEFINE VARIABLE mNumb    AS   INTEGER                  NO-UNDO.
DEFINE VARIABLE mAmt     LIKE op-entry.amt-rub         NO-UNDO.
DEFINE VARIABLE mAmtS    LIKE op-entry.amt-rub         NO-UNDO.
DEFINE VARIABLE mDetails AS   CHARACTER EXTENT 3       NO-UNDO.
DEFINE VARIABLE mDate    AS   CHARACTER FORMAT "x(29)" NO-UNDO. 
DEFINE VARIABLE mAmtStr  AS   CHARACTER EXTENT 3       NO-UNDO.
DEFINE VARIABLE mStrTMP1 AS   CHARACTER                NO-UNDO.
DEFINE VARIABLE mStrTMP2 AS   CHARACTER                NO-UNDO.

{strtout3.i}
mDate = STRING( CAPS({term2str DATE(GetFltVal('op-date1')) DATE(GetFltVal('op-date2')) YES}), "x(30)" ).

PUT UNFORMATTED cBankName skip(1).
PUT UNFORMATTED "¥£¨áâà æ¨®­­ë© ­®¬¥à ã¯®«­®¬®ç¥­­®£® ¡ ­ª  : 2655" skip.
PUT UNFORMATTED "€¤à¥á ®¯¥à æ¨®­­®© ª ááë : 121099, £.Œ®áª¢ , ®¢¨­áª¨© ¡-à ¤.3 áâà.1" skip(1).
PUT UNFORMATTED "                           ……‘’ ˆŸ’Ž‰ „……†Ž‰ €‹ˆ—Ž‘’ˆ" skip.
PUT UNFORMATTED "           „‹Ÿ Ž‘“™…‘’‚‹…ˆŸ ……‚Ž„€ „……†›• ‘…„‘’‚ Ž Ž“—…ˆž ”ˆ‡ˆ—…‘ŠŽƒŽ ‹ˆ–€" skip.
PUT UNFORMATTED "                             …‡ Ž’Š›’ˆŸ €ŠŽ‚‘ŠŽƒŽ ‘—…’€" skip.
PUT UNFORMATTED "                                 ‡€ " mDate skip(1). 
                             

ASSIGN
   mNumb = 0
   mAmt  = 0
.
PUT UNFORMATTED "ÚÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" skip.
PUT UNFORMATTED "³      ³           ‚­®á¨â¥«ì          ³  ‘ã¬¬  ¯¥à¥¢®¤  ³          ¨¬¥­®¢ ­¨¥ ®¯¥à æ¨¨          ³" skip.
PUT UNFORMATTED "ÃÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" skip.

ASSIGN
   mAmt  = 0
   mAmtS = 0
   mNumb = 1
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
      mDetails[3] = "".
      {wordwrap.i &s=mDetails &l=40 &n=3}
   END.

   IF LAST-OF(op-entry.acct-cr) THEN
   DO:

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
      PUT UNFORMATTED "³" 
                      string(mNumb) FORMAT "x(6)" "³" 
                      PoName[1] FORMAT "x(30)" "³" 
                      mAmt FORMAT ">>,>>>,>>>,>>9.99" "³" 
                      mDetails[1]      FORMAT "x(40)" "³" 
                      SKIP.
      IF LENGTH(mDetails[2]) > 0 THEN                
      PUT UNFORMATTED "³      ³" 
                      FORMAT "x(38)" "³" 
                      "                 ³" 
                      mDetails[2]      FORMAT "x(40)" "³" 
                      SKIP.
      IF LENGTH(mDetails[3]) > 0 THEN                 
      PUT UNFORMATTED "³      ³" 
                      FORMAT "x(38)" "³" 
                      "                 ³" 
                      mDetails[3]      FORMAT "x(40)" "³" 
                      SKIP.
                      
      ASSIGN
         mAmt  = 0
         mNumb = mNumb + 1
      .
   END.

END.

PUT UNFORMATTED "ÀÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" skip(1).
PUT UNFORMATTED  " ˆâ®£® §  ¤¥­ì ¯® à¥¥áâàã" skip.
PUT UNFORMATTED  " Š®«-¢® ¤®ªã¬¥­â®¢      "  string(mNumb - 1) FORMAT "x(6)"  "­  ®¡éãî áã¬¬ã" mAmtS FORMAT ">,>>>,>>>,>>>,>>9.99" skip.

RUN x-amtstr.p (mAmtS, '', YES, YES,
                OUTPUT mStrTMP1, OUTPUT mStrTMP2).
mAmtStr = mStrTMP1 + ' ' + mStrTMP2.
{wordwrap.i &s=mAmtStr &n=3 &l=80}
PUT UNFORMATTED  " " mAmtStr[1]  SKIP(1).
IF LENGTH(mAmtStr[2]) > 0 THEN
   PUT UNFORMATTED  "        "  mAmtStr[2]  SKIP.

IF LENGTH(mAmtStr[3]) > 0 THEN
   PUT UNFORMATTED  "        "  mAmtStr[3]  SKIP.

PUT UNFORMATTED SKIP(1).
PUT UNFORMATTED "Š áá®¢ë© à ¡®â­¨ª _____________________" SKIP.
{endout3.i}
