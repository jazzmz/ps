{pirsavelog.p}

/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2002 ’ŽŽ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: i56_20r.p
      Comment: Žâç¥â "Š áá®¢ ï ª­¨£  ãç¥â ...."
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
   LABEL "®ª §ë¢ âì ®¡®à®âë" NO-UNDO.
DEFINE VARIABLE mlgShowTitle AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "’¨âã«ì­ë© «¨áâ" NO-UNDO.
DEFINE VARIABLE mlgShowSign AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "‡ ¢¥à¨â¥«ì­ ï ­ ¤¯¨áì" NO-UNDO.
DEFINE VARIABLE mShowAcct   AS LOGICAL INITIAL NO VIEW-AS TOGGLE-BOX
   LABEL "®ª §ë¢ âì «¨æ¥¢ë¥ áç¥â "  NO-UNDO.

DEFINE FRAME fFr
   mlgShowTurn  SKIP
   mlgShowTitle SKIP
   mlgShowSign  SKIP
   mShowAcct    SKIP
   WITH SIDE-LABELS CENTERED OVERLAY TITLE COLOR brigth-white "[ ‚¢¥¤¨â¥ ¯ à ¬¥âàë ¯¥ç â¨ ]".

DEFINE TEMP-TABLE ByCurrency
   FIELD Currency AS CHAR
   FIELD Val AS DEC
   FIELD Rub AS DEC
.

DEFINE VARIABLE mHd AS CHARACTER  NO-UNDO EXTENT 6.

ON RETURN OF mlgShowTurn, mlgShowTitle, mlgShowSign, mShowAcct IN FRAME fFr
   APPLY "GO":U TO SELF.

Main:
DO ON ERROR UNDO, LEAVE:

   DO ON ERROR  UNDO, LEAVE
      ON ENDKEY UNDO, LEAVE:
      UPDATE 
         mlgShowTurn 
         mlgShowTitle 
         mlgShowSign 
         mShowAcct 
      WITH FRAME fFr.
   END.
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
         "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP
         "  (­ ¨¬¥­®¢ ­¨¥ ªà¥¤¨â­®© ®à£ ­¨§ æ¨¨)"   SKIP
         SKIP(10)
         "Šˆƒ€":C{&repwidth} SKIP(1)
         "ãç¥â  ¤¥­¥¦­®© ­ «¨ç­®áâ¨ ¨ ¤àã£¨å æ¥­­®áâ¥©":C{&repwidth} SKIP(1)
         "                                 §  " YEAR(DataBlock.end-date) " £." SKIP
         SKIP(10)
         "                                              ç â     " {strdate.i DataBlock.end-date} SKIP(1)
         "                                             Žª®­ç¥­  ~"___~"____________£." SKIP(1)
         SKIP(10)
         "‡ ¯¨á¨ ¢ ­ áâ®ïé¥© ª­¨£¥ ¯à®¨§¢®¤ïâáï":C{&repwidth} SKIP
         "¤® ¯®«­®£® ¥¥ ¨á¯®«ì§®¢ ­¨ï":C{&repwidth} SKIP
      .
      PAGE.
   END.
   
   IF NOT mShowAcct 
   THEN ASSIGN       
         mHd[1] = "ÄÄÄÄÄ"
         mHd[2] = "NoNo "
         mHd[3] = "áç¥- "
         mHd[4] = "â®¢  "
         mHd[5] = "     "
         mHd[6] = mHd[1].
   ELSE ASSIGN
         mHd[1] = "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
         mHd[2] = "     NoNo áç¥â®¢    "
         mHd[3] = "                    "
         mHd[4] = mHd[3]
         mHd[5] = mHd[3]
         mHd[6] = mHd[1].
   
   PUT UNFORMATTED
      "                                                  Œ¥áïæ " {rsdate.i MONTH(DataBlock.end-date)} SKIP(1)
      "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ" + mHd[1] + "ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" SKIP
      "³                                   ³" + mHd[2] + "³ Žáâ â®ª ­  " DataBlock.end-date + 1 FORMAT "99.99.9999" "         ³" SKIP
      "³           ¨¬¥­®¢ ­¨¥             ³" + mHd[3] + "ÃÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
      "³                                   ³" + mHd[4] + "³Š®«-¢® ³         ‘ã¬¬          ³" SKIP
      "³                                   ³" + mHd[5] + "³  ¤®ª. ³                       ³" SKIP
      "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅ" + mHd[6] + "ÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄ´" SKIP
   .
   RUN PrintDataLine ("„¥­¥¦­ ï ­ «¨ç­®áâì","",0,0,YES).
   /* æ¨ª«  « ­á */
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
      /* ‡ £®«®¢®ª */
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
      /* ‚ «îâ  */
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
            RUN PrintDataLine(ByCurrency.Currency,"…¤. ¢ «îâë",?,ByCurrency.Val,NO).
            RUN PrintDataLine(""            ,"ã¡. íª¢¨¢ «¥­â",?,ByCurrency.Rub,NO). 
            IF mLgShowTurn THEN
            DO:
               RUN PrintDataLine 
                  ( FILL(" ",28) + "à¨å®¤",
                    "",
                    ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[6],
                    ACCUM TOTAL BY DataLine.Sym3 DataLine.Val[2],
                    NO).
               RUN PrintDataLine 
                  ( FILL(" ",28) + " áå®¤",
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
               ( FILL(" ",28) + "à¨å®¤",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[6],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[2],
                 NO).
            RUN PrintDataLine 
               ( FILL(" ",28) + " áå®¤",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[7],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[3],
                 NO).
         END.
         RUN PrintDataLine 
            ( FILL(" ",27) + "Žáâ â®ª",
              "",
              ?,
              ACCUM TOTAL BY DataLine.Sym1 sh-bal,
              NO).
      END.
   END.
   RUN PrintDataLine ("","",0,0,YES).
   IF NOT mShowAcct THEN
   DO:
      RUN PrintDataLine ("‚ â®¬ ç¨á«¥:","",0,0,YES).
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
   RUN PrintDataLine ("„àã£¨¥ æ¥­­®áâ¨:","",0,0,YES).
   /* æ¨ª« ‚­¥¡ « ­á */
   FOR EACH DataLine OF DataBlock WHERE 
        NOT DataLine.Sym1 BEGINS "20202"
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
      /*  ª®¯«¥­¨¥ áã¬¬ë */
      ACCUMULATE 
         sh-bal (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         sh-val (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
	 DataLine.Val[6] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         DataLine.Val[7] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         DataLine.Val[2] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
         DataLine.Val[3] (TOTAL BY DataLine.Sym1 BY DataLine.Sym3)
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
      
      /* ‚ «îâ  */
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
         .
         IF mShowAcct THEN
         DO:
            RUN PrintDataLine(ByCurrency.Currency,"…¤. ¢ «îâë",?,ByCurrency.Val,NO).
            RUN PrintDataLine(""            ,"ã¡. íª¢¨¢ «¥­â",?,ByCurrency.Rub,NO).
         END.
         RELEASE ByCurrency.
      END.
      
      
      IF LAST-OF(DataLine.Sym1) THEN DO:         
         RUN PrintDataLine
            (ENTRY(1,DataLine.Txt,"~n"),
             IF mShowAcct 
                THEN "‚á¥£®" 
                ELSE DataLine.Sym1,
             ?,
             /* ACCUM TOTAL BY DataLine.Sym1 sh-bal */ "",
             NO).
         IF mlgShowTurn THEN DO:
            RUN PrintDataLine 
               ( FILL(" ",28) + "à¨å®¤",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[6],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[2],
                 NO).
            RUN PrintDataLine 
               ( FILL(" ",28) + " áå®¤",
                 "",
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[7],
                 ACCUM TOTAL BY DataLine.Sym1 DataLine.Val[3],
                 NO).
         END.
         IF NOT mShowAcct THEN
         FOR EACH ByCurrency BREAK BY ByCurrency.Currency:
            IF FIRST (ByCurrency.Currency) THEN
               RUN PrintDataLine ("‚ â®¬ ç¨á«¥:","",0,0,YES).
               
            RUN PrintDataLine(ByCurrency.Currency,"",?,ByCurrency.Val,NO).
            IF LAST (ByCurrency.Currency) THEN
               RUN PrintDataLine ("","",0,0,YES).
            
         END.
      END.
   END.
   PUT UNFORMATTED
      "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ" + mHd[1] + "ÅÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄ´" SKIP
      " „®«¦­®áâ­ë¥ «¨æ , ®â¢¥âáâ¢¥­­ë¥     " + mHd[5] + "³                               ³" SKIP
      " §  á®åà ­­®áâì æ¥­­®áâ¥©            " + mHd[5] + "³                               ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      "     ç «ì­¨ª „4                     " + mHd[5] + "³       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
      "     (¤®«¦­®áâì)                     " + mHd[5] + "³                               ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      "  ç «ì­¨ª “12 (‡ ¢.ª áá®©)          " + mHd[5] + "³       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
      "     (¤®«¦­®áâì)                     " + mHd[5] + "³ ¯®¤¯¨á¨                       ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      " ‘ ¤ ­­ë¬¨ ¡ãå£ «â¥àáª®£® ãç¥â  á¢¥à¥­®:" + SUBSTR (mHd[5],5) + " ³                               ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      " ƒ« ¢­ë© ¡ãå£ «â¥à                   " + mHd[5] + "³       ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
      "                                     " + mHd[5] + "³                               ³" SKIP
   .
   PAGE.
   
   IF mlgShowSign THEN DO:
      PUT UNFORMATTED
         FStrCenter(mchBankName[1], {&repwidth}) SKIP
         "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ":C{&repwidth} SKIP
         "  (­ ¨¬¥­®¢ ­¨¥ ªà¥¤¨â­®© ®à£ ­¨§ æ¨¨)":C{&repwidth}   SKIP
         SKIP(10)
         "‡€‚…ˆ’…‹œ€Ÿ €„ˆ‘œ":C{&repwidth} SKIP
         SKIP(10)
         "ˆâ®£® ¢ ­ áâ®ïé¥© ª­¨£¥ á®¤¥à¦¨âáï ¯à®­ã¬¥à®¢ ­­ëå ¨":C{&repwidth} SKIP(1)
         "¯à®è­ãà®¢ ­­ëå_____________________________________________«¨áâ®¢":C{&repwidth} SKIP
         "         (ª®«¨ç¥áâ¢® «¨áâ®¢ ãª §ë¢ ¥âáï ¯à®¯¨áìî)":C{&repwidth} SKIP(1)
         "á No______ ¯® No______ ¢ª«îç¨â¥«ì­®":C{&repwidth} SKIP
         SKIP(10)
         "„®«¦­®áâ­ë¥ «¨æ , ®â¢¥âáâ¢¥­­ë¥" SKIP
         "§  á®åà ­­®áâì æ¥­­®áâ¥©" SKIP
         SKIP(2)
         "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP
         "    (¤®«¦­®áâì)             (¯®¤¯¨áì)"      SKIP
         SKIP(2)
         "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP
         "    (¤®«¦­®áâì)             (¯®¤¯¨áì)"      SKIP
         SKIP(2)
         "ƒ« ¢­ë© ¡ãå£ «â¥à      ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" SKIP
         "                            (¯®¤¯¨áì)"      SKIP
         SKIP(1)
         {strdate.i DataBlock.end-date}               SKIP
         SKIP(1)
         "Œ.." SKIP
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
      InfoString = "³" + STRING(NAME[Wrap],"x(35)") + "³" 
      + (IF Wrap = 1 THEN STRING(ENTRY(1,i-sym,'_'),FILL ("9",LENGTH (mHd[1]))) ELSE FILL (" ",LENGTH (mHd[1]))).
      IF Wrap EQ 1 AND NOT i-empt THEN DO:
         IF i-dqty EQ ? THEN
            {additem3.i InfoString "FILL(' ',7)" 179 }
         ELSE
            {additem3.i InfoString "STRING(i-dqty,'>>>>>>9')" 179 }
         IF i-val EQ 0 THEN DO:
            {additem3.i InfoString "FILL(' ', 20)" 179 }   
            {additem3.i InfoString "FILL(' ', 2)" 179 }   
         END.
         ELSE   
            {additem3.i InfoString "REPLACE(STRING(i-Val, OutputFormat), '.', '³')" 179 }
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
