{pirsavelog.p}

/*
               Å†≠™Æ¢·™†Ô ®≠‚•£‡®‡Æ¢†≠≠†Ô ·®·‚•¨† Åàë™¢®‚
    Copyright: (C) 1992-2002 íéé "Å†≠™Æ¢·™®• ®≠‰Æ‡¨†Ê®Æ≠≠Î• ·®·‚•¨Î"
     Filename: i56_20r.p
      Comment: é‚Á•‚ "ä†··Æ¢†Ô ™≠®£† „Á•‚†...."
   Parameters:
         Uses:
      Used by:
      Created: 04/07/2002 Gunk
     Modified: 
*/
DEFINE INPUT PARAMETER iDataID LIKE DataBlock.Data-ID NO-UNDO.

{norm.i}
{sh-defs.i}
{globals.i}
{chkacces.i}
{intrface.get strng}

DEFINE VARIABLE mchBankName AS CHARACTER EXTENT 3 FORMAT "x(40)" NO-UNDO.

DEFINE VARIABLE mlgShowTurn AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "èÆ™†ßÎ¢†‚Ï Æ°Æ‡Æ‚Î" NO-UNDO.
DEFINE VARIABLE mlgShowTitle AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "í®‚„´Ï≠Î© ´®·‚" NO-UNDO.
DEFINE VARIABLE mlgShowSign AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "á†¢•‡®‚•´Ï≠†Ô ≠†§Ø®·Ï" NO-UNDO.
DEFINE VARIABLE mShowAcct   AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "èÆ™†ßÎ¢†‚Ï ´®Ê•¢Î• ·Á•‚†"  NO-UNDO.

DEFINE FRAME fFr
   mlgShowTurn  SKIP
   mlgShowTitle SKIP
   mlgShowSign  SKIP
   mShowAcct    SKIP
   WITH SIDE-LABELS CENTERED OVERLAY TITLE COLOR brigth-white "[ Ç¢•§®‚• Ø†‡†¨•‚‡Î Ø•Á†‚® ]".

DEFINE TEMP-TABLE ByCurrency
   FIELD Currency AS CHAR
   FIELD Val AS DEC
   FIELD Rub AS DEC
   FIELD Kol AS DEC
.

DEFINE VARIABLE mHd AS CHARACTER  NO-UNDO EXTENT 6.

ON RETURN OF mlgShowTurn, mlgShowTitle, mlgShowSign, mShowAcct IN FRAME fFr
   APPLY "GO":U TO SELF.

Main:
DO ON ERROR UNDO, LEAVE:

  /* DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE:
      UPDATE 
         mlgShowTurn 
         mlgShowTitle 
         mlgShowSign 
         mShowAcct 
      WITH FRAME fFr.
   END.*/
   HIDE FRAME fFr NO-PAUSE.
   IF KEYFUNC (LASTKEY) EQ "end-error" THEN LEAVE Main.
   
   {fexp-chk.i
      &DataID = iDataID
   }
   mchBankName[1] = branch.name.
   
   &SCOP repwidth 91
   {setdest.i 
      &cols = {&repwidth}
   }
   
   IF mlgShowTitle THEN DO:
      PUT UNFORMATTED
         mchBankName[1] SKIP
         "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ" SKIP
         "  (≠†®¨•≠Æ¢†≠®• ™‡•§®‚≠Æ© Æ‡£†≠®ß†Ê®®)"   SKIP
         SKIP(10)
         "äçàÉÄ":C{&repwidth} SKIP(1)
         "„Á•‚† §•≠•¶≠Æ© ≠†´®Á≠Æ·‚® ® §‡„£®Â Ê•≠≠Æ·‚•©":C{&repwidth} SKIP(1)
         "                                 ß† " YEAR(DataBlock.end-date) " £." SKIP
         SKIP(10)
         "                                             ç†Á†‚†    " {strdate.i DataBlock.end-date} SKIP(1)
         "                                             é™Æ≠Á•≠† ~"___~"____________£." SKIP(1)
         SKIP(10)
         "á†Ø®·® ¢ ≠†·‚ÆÔÈ•© ™≠®£• Ø‡Æ®ß¢Æ§Ô‚·Ô":C{&repwidth} SKIP
         "§Æ ØÆ´≠Æ£Æ •• ®·ØÆ´ÏßÆ¢†≠®Ô":C{&repwidth} SKIP
      .
      PAGE.
   END.
   
   IF NOT mShowAcct 
   THEN ASSIGN       
         mHd[1] = "ƒƒƒƒƒ"
         mHd[2] = "NoNo "
         mHd[3] = "·Á•- "
         mHd[4] = "‚Æ¢  "
         mHd[5] = "     "
         mHd[6] = mHd[1].
   ELSE ASSIGN
         mHd[1] = "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ"
         mHd[2] = "     NoNo ·Á•‚Æ¢    "
         mHd[3] = "                    "
         mHd[4] = mHd[3]
         mHd[5] = mHd[3]
         mHd[6] = mHd[1].
   
   PUT UNFORMATTED
      "                                                  å•·ÔÊ " {rsdate.i MONTH(DataBlock.end-date)} SKIP(1)
      "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬" + mHd[1] + "¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø" SKIP
      "≥                                   ≥" + mHd[2] + "≥ é·‚†‚Æ™ ≠† " DataBlock.end-date + 1 FORMAT "99.99.9999" "         ≥" SKIP
      "≥          ç†®¨•≠Æ¢†≠®•             ≥" + mHd[3] + "√ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP
      "≥                                   ≥" + mHd[4] + "≥äÆ´-¢Æ ≥         ë„¨¨†         ≥" SKIP
      "≥                                   ≥" + mHd[5] + "≥  §Æ™. ≥                       ≥" SKIP
      "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈" + mHd[6] + "≈ƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒ¥" SKIP
   .
   RUN PrintDataLine ("Ñ•≠•¶≠†Ô ≠†´®Á≠Æ·‚Ï","",0,0,YES).
   /* Ê®™´ Å†´†≠· */
   FOR EACH DataLine OF DataBlock WHERE
            DataLine.Sym1 BEGINS "20202" 
      NO-LOCK,
      FIRST acct WHERE 
            acct.acct EQ DataLine.Sym4 
        AND acct.curr EQ DataLine.Sym3
      NO-LOCK
      BREAK BY DataLine.Sym1 
            BY DataLine.Sym3:
       
      RUN acct-pos IN h_BASE (acct.acct, acct.currency, DataBlock.beg-date, DataBlock.end-date,?).
      /* á†£Æ´Æ¢Æ™ */
      IF FIRST-OF(DataLine.Sym1) THEN 
         RUN PrintDataLine(ENTRY(1,DataLine.Txt,"~n"),
                           IF mShowAcct THEN "" ELSE DataLine.Sym1,
                           0,
                           0,
                           YES).
      
      ACCUMULATE sh-db           (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 sh-cr           (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 sh-val          (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 sh-bal          (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[6] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[7] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[2] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[3] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
      .
      IF mShowAcct THEN
      DO:
         RUN PrintDataLine 
            ( "",
              acct.acct,
              ?,
              IF DataLine.Sym3 = "" 
                 THEN sh-bal
                 ELSE sh-val,
              NO).
      END.
      /* Ç†´Ó‚† */
      IF LAST-OF(DataLine.Sym3) THEN DO:
         FIND FIRST currency WHERE currency.currency EQ DataLine.Sym3 NO-LOCK NO-ERROR.
         CREATE ByCurrency.
         ASSIGN ByCurrency.Val = IF DataLine.Sym3 = "" THEN
                                    ACCUM TOTAL BY DataLine.sym3 sh-bal
                                 ELSE
                                    ACCUM TOTAL BY DataLine.Sym3 sh-val
                ByCurrency.Rub = ACCUM TOTAL BY DataLine.sym3 sh-bal
                ByCurrency.Currency = currency.name-curr WHEN AVAIL currency.
         IF mShowAcct THEN
         DO:
            RUN PrintDataLine(ByCurrency.Currency,"Ö§. ¢†´Ó‚Î",?,ByCurrency.Val,NO).
            RUN PrintDataLine(""            ,"ê„°. Ì™¢®¢†´•≠‚",?,ByCurrency.Rub,NO). 
            IF mLgShowTurn THEN
            DO:
               RUN PrintDataLine 
                  ( FILL(" ",28) + "è‡®ÂÆ§",
                    "",
                    ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[6],
                    ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[2],
                    NO).
               RUN PrintDataLine 
                  ( FILL(" ",28) + "ê†·ÂÆ§",
                    "",
                    ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[7],
                    ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[3],
                    NO).
            END.
            RUN PrintDataLine ("","",0,0,YES).
         END.
      END.
      IF LAST-OF(DataLine.Sym1) THEN DO:
         IF mlgShowTurn THEN DO:
            RUN PrintDataLine 
               ( FILL(" ",28) + "è‡®ÂÆ§",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[6],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[2],
                 NO).
            RUN PrintDataLine 
               ( FILL(" ",28) + "ê†·ÂÆ§",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[7],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[3],
                 NO).
         END.
         RUN PrintDataLine 
            ( FILL(" ",27) + "é·‚†‚Æ™",
              "",
              ?,
              ACCUM TOTAL BY DataLine.Sym1 sh-bal,
              NO).
      END.
   END.
   RUN PrintDataLine ("","",0,0,YES).
   IF NOT mShowAcct THEN
   DO:
      RUN PrintDataLine ("Ç ‚Æ¨ Á®·´•:","",0,0,YES).
      RUN PrintDataLine ("","",0,0,YES).
      FOR EACH ByCurrency:
         RUN PrintDataLine(ByCurrency.Currency,
                           "",
                           ?,
                           ByCurrency.Val,
                           NO).
      END.
      RUN PrintDataLine ("","",0,0,YES).
   END.
   RUN PrintDataLine ("Ñ‡„£®• Ê•≠≠Æ·‚®:","",0,0,YES).
   /* Ê®™´ Ç≠•°†´†≠· */
   FOR EACH DataLine OF DataBlock WHERE 
        NOT DataLine.Sym1 BEGINS "20202" and DataLine.Sym2 EQ "o" 
      NO-LOCK,
      FIRST acct WHERE 
            acct.acct EQ DataLine.Sym4 
        AND acct.curr EQ DataLine.Sym3
      NO-LOCK
      BREAK BY DataLine.Sym1
            BY DataLine.Sym3:
      
      IF FIRST-OF (DataLine.Sym1) THEN EMPTY TEMP-TABLE ByCurrency.
      
      RUN acct-pos IN h_BASE (acct.acct, 
                              acct.currency, 
                              DataBlock.beg-date, 
                              DataBlock.end-date, 
                              ?).
      /* ç†™ÆØ´•≠®• ·„¨¨Î */
      ACCUMULATE 
         sh-bal (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         sh-val (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
	 DataLine.Val[6] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         DataLine.Val[7] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         DataLine.Val[2] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         DataLine.Val[3] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
	 DataLine.Val[5] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
      .
      
      IF mShowAcct THEN
         RUN PrintDataLine
            (IF FIRST-OF (DataLine.Sym1)
                THEN ENTRY(1,DataLine.Txt,"~n")
                ELSE "",
             acct.acct,
             ?,
             sh-bal,
             NO).
      
      /* Ç†´Ó‚† */
      IF LAST-OF(DataLine.Sym3) THEN
      FOR FIRST currency WHERE 
                currency.currency EQ DataLine.Sym3 
         NO-LOCK:
         CREATE ByCurrency.
         ASSIGN 
            ByCurrency.Rub = ACCUM TOTAL BY DataLine.sym3 sh-bal
	    ByCurrency.Val = IF DataLine.Sym3 = "" 
                                THEN ByCurrency.rub
                                ELSE (ACCUM TOTAL BY DataLine.Sym3 sh-val)
            ByCurrency.Currency = currency.name-curr WHEN AVAIL currency
	    ByCurrency.kol = IF ByCurrency.Val = 0
				THEN 0
				ELSE (ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[5])
         .
         IF mShowAcct THEN
         DO:
            RUN PrintDataLine(ByCurrency.Currency,"Ö§. ¢†´Ó‚Î",?,ByCurrency.Val,NO).
            RUN PrintDataLine(""            ,"ê„°. Ì™¢®¢†´•≠‚",?,ByCurrency.Rub,NO).
         END.
         RELEASE ByCurrency.
      END.
      
      
      IF LAST-OF(DataLine.Sym1) THEN DO:         
         RUN PrintDataLine
            (ENTRY(1,DataLine.Txt,"~n"),
             IF mShowAcct 
                THEN "Ç·•£Æ" 
                ELSE DataLine.Sym1,
             ?,
             /* ACCUM TOTAL BY DataLine.Sym1 sh-bal */ "",
             NO).
         IF mlgShowTurn THEN DO:
            RUN PrintDataLine 
               ( FILL(" ",28) + "è‡®ÂÆ§",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[6],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[2],
                 NO).
            RUN PrintDataLine 
               ( FILL(" ",28) + "ê†·ÂÆ§",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[7],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[3],
                 NO).
         END.
         IF NOT mShowAcct THEN
         FOR EACH ByCurrency BREAK BY ByCurrency.Currency:
            IF FIRST (ByCurrency.Currency) THEN
               RUN PrintDataLine ("Ç ‚Æ¨ Á®·´•:","",0,0,YES).
               
            RUN PrintDataLine(ByCurrency.Currency,"",ByCurrency.kol,ByCurrency.Val,NO).
	    /* Ø‡Æ·‚†¢´•≠Æ ™Æ´-¢Æ §Æ™„¨•≠‚Æ¢ */
            IF LAST (ByCurrency.Currency) THEN
               RUN PrintDataLine ("","",0,0,YES).
            
         END.
      END.
   END.
      /* Ê®™´ Ñ•ØÆß®‚†‡®© */
   FOR EACH DataLine OF DataBlock WHERE
            DataLine.Sym2 EQ "d"
      NO-LOCK,
      FIRST acct WHERE 
            acct.acct EQ DataLine.Sym4 
        AND acct.curr EQ DataLine.Sym3
      NO-LOCK
      BREAK BY DataLine.Sym1 
            BY DataLine.Sym3:
       
      RUN acct-pos IN h_BASE (acct.acct, acct.currency, DataBlock.beg-date, DataBlock.end-date,?).
      /* á†£Æ´Æ¢Æ™ */
      IF FIRST-OF(DataLine.Sym1) THEN 
         RUN PrintDataLine(/* ENTRY(1,DataLine.Txt,"~n")*/
			  "ñ•≠≠Î• °„¨†£® ≠† Â‡†≠•≠®® ¢ §•ØÆß®‚†‡®®"    
			    ,
                           IF mShowAcct THEN "" ELSE DataLine.Sym1,
                           0,
                           0,
                           YES).
      
      ACCUMULATE sh-db           (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 sh-cr           (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 sh-val          (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 sh-bal          (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[6] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[7] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[2] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
                 DataLine.Val[3] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
		             DataLine.Val[5] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
      .
      /* Ç†´Ó‚† */
      IF LAST-OF(DataLine.Sym1) THEN DO:
      /* FIND FIRST currency WHERE currency.currency EQ DataLine.Sym3
	                    and DataLine.Sym2 eq "d"   NO-LOCK NO-ERROR.*/
         CREATE ByCurrency.
         ASSIGN 
         ByCurrency.Rub = ACCUM TOTAL BY DataLine.sym1 sh-bal
		     ByCurrency.Val = ByCurrency.Rub /* IF DataLine.Sym2 eq "d" THEN
                                    ACCUM TOTAL BY DataLine.sym1 sh-bal
                                 ELSE
                                    ACCUM TOTAL BY DataLine.Sym1 sh-val*/
         ByCurrency.Currency = "Ç•™·•´Ï"
		     ByCurrency.kol = IF ByCurrency.Val = ?
				 THEN 0
				 ELSE (ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[5]).
         RELEASE ByCurrency.
      END.

   END.
   IF NOT mShowAcct THEN
   DO:
      RUN PrintDataLine ("Ç ‚Æ¨ Á®·´•:","",0,0,YES).
      FOR EACH ByCurrency where ByCurrency.Currency ne "ê„°´®":
         RUN PrintDataLine(/* ByCurrency.Currency ENTRY(1,DataLine.Txt,"~n") */
			                     "ëÁ•‚† ÑÖèé",
                           "",
                           ByCurrency.kol,
                           ByCurrency.Val,
                           NO).
      END.
      RUN PrintDataLine ("","",0,0,YES).
   END.
   PUT UNFORMATTED
      "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡" + mHd[1] + "≈ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒ¥" SKIP
      " ÑÆ´¶≠Æ·‚≠Î• ´®Ê†, Æ‚¢•‚·‚¢•≠≠Î•     " + mHd[5] + "≥                               ≥" SKIP
      " ß† ·ÆÂ‡†≠≠Æ·‚Ï Ê•≠≠Æ·‚•©            " + mHd[5] + "≥                               ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      "    ç†Á†´Ï≠®™ Ñ4                     " + mHd[5] + "≥       ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP
      "     (§Æ´¶≠Æ·‚Ï)                     " + mHd[5] + "≥                               ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      " ç†Á†´Ï≠®™ ì12 (á†¢.™†··Æ©)          " + mHd[5] + "≥       ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP
      "     (§Æ´¶≠Æ·‚Ï)                     " + mHd[5] + "≥ ØÆ§Ø®·®                       ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      " ë §†≠≠Î¨® °„Â£†´‚•‡·™Æ£Æ „Á•‚† ·¢•‡•≠Æ:" + SUBSTR (mHd[5],5) + " ≥                               ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      " É´†¢≠Î© °„Â£†´‚•‡                   " + mHd[5] + "≥       ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
      "                                     " + mHd[5] + "≥                               ≥" SKIP
   .
   PAGE.
   
   IF mlgShowSign THEN DO:
      PUT UNFORMATTED
         FStrCenter(mchBankName[1], {&repwidth}) SKIP
         "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ":C{&repwidth} SKIP
         "  (≠†®¨•≠Æ¢†≠®• ™‡•§®‚≠Æ© Æ‡£†≠®ß†Ê®®)":C{&repwidth}   SKIP
         SKIP(10)
         "áÄÇÖêàíÖãúçÄü çÄÑèàëú":C{&repwidth} SKIP
         SKIP(10)
         "à‚Æ£Æ ¢ ≠†·‚ÆÔÈ•© ™≠®£• ·Æ§•‡¶®‚·Ô Ø‡Æ≠„¨•‡Æ¢†≠≠ÎÂ ®":C{&repwidth} SKIP(1)
         "Ø‡ÆË≠„‡Æ¢†≠≠ÎÂ_____________________________________________´®·‚Æ¢":C{&repwidth} SKIP
         "         (™Æ´®Á•·‚¢Æ ´®·‚Æ¢ „™†ßÎ¢†•‚·Ô Ø‡ÆØ®·ÏÓ)":C{&repwidth} SKIP(1)
         "· No______ ØÆ No______ ¢™´ÓÁ®‚•´Ï≠Æ":C{&repwidth} SKIP
         SKIP(10)
         "ÑÆ´¶≠Æ·‚≠Î• ´®Ê†, Æ‚¢•‚·‚¢•≠≠Î•" SKIP
         "ß† ·ÆÂ‡†≠≠Æ·‚Ï Ê•≠≠Æ·‚•©" SKIP
         SKIP(2)
         "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ    ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ" SKIP
         "    (§Æ´¶≠Æ·‚Ï)             (ØÆ§Ø®·Ï)"      SKIP
         SKIP(2)
         "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ    ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ" SKIP
         "    (§Æ´¶≠Æ·‚Ï)             (ØÆ§Ø®·Ï)"      SKIP
         SKIP(2)
         "É´†¢≠Î© °„Â£†´‚•‡      ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ" SKIP
         "                            (ØÆ§Ø®·Ï)"      SKIP
         SKIP(1)
         {strdate.i DataBlock.end-date}               SKIP
         SKIP(1)
         "å.è." SKIP
      .
   END.
   {preview.i}
   
END.
{intrface.del}
RETURN "".
/* ================================= */
PROCEDURE PrintDataLine:
   DEFINE INPUT  PARAMETER i-name AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER i-sym  AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER i-Dqty AS DECIMAL    NO-UNDO.
   DEFINE INPUT  PARAMETER i-Val  AS DECIMAL    NO-UNDO.
   DEFINE INPUT  PARAMETER i-empt AS LOGICAL    NO-UNDO.
   {wordwrap.def}
   
   DEFINE VARIABLE NAME AS CHARACTER  NO-UNDO EXTENT 5.
   DEFINE VARIABLE Wrap AS INTEGER    NO-UNDO.
   DEFINE VARIABLE InfoString AS CHARACTER  NO-UNDO FORMAT "x(128)".
   NAME[1] = i-name.
   {wordwrap.i &s = NAME &l = 35 &n = 5 }
   DO Wrap = 1 TO 5:
      IF NAME[Wrap] EQ "" AND Wrap GE 2 THEN NEXT.
      InfoString = "≥" + STRING(NAME[Wrap],"x(35)") + "≥" 
      + (IF Wrap = 1 THEN STRING(ENTRY(1,i-sym,'_'),FILL ("9",LENGTH (mHd[1]))) ELSE FILL (" ",LENGTH (mHd[1]))).
      IF Wrap EQ 1 AND NOT i-empt THEN DO:
         IF i-dqty EQ ? THEN
            {additem3.i InfoString "FILL(' ',7)" 179 }
         ELSE
            {additem3.i InfoString "STRING(i-dqty,'>>>>>>9')" 179 }
         IF i-val EQ 0 and NAME[Wrap] NE "ëÁ•‚† ÑÖèé" THEN
         DO:
            {additem3.i InfoString "FILL(' ', 20)" 179 }   
            {additem3.i InfoString "FILL(' ', 2)" 179 }   
         END.
         ELSE   
            {additem3.i InfoString "REPLACE(STRING(i-Val, OutputFormat), '.', '≥')" 179 }
      END.
      ELSE DO:
         {additem3.i InfoString "FILL(' ',7)" 179 }
         {additem3.i InfoString "FILL(' ', 20)" 179 }   
         {additem3.i InfoString "FILL(' ', 2)" 179 }   
      END.
      InfoString = InfoString + CHR(179).
      PUT UNFORMATTED InfoString SKIP.
   END.

END PROCEDURE.
