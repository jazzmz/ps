/*
               Å†≠™Æ¢·™†Ô ®≠‚•£‡®‡Æ¢†≠≠†Ô ·®·‚•¨† Åàë™¢®‚
    Copyright: (C) 1992-2002 íéé "Å†≠™Æ¢·™®• ®≠‰Æ‡¨†Ê®Æ≠≠Î• ·®·‚•¨Î"
     Filename: OBOROT2.P
      Comment:
   Parameters:
         Uses:
      Used by:
      Created: Unknown
     Modified: 8/8/2002 Gunk
     Modified: 18.07.2006 OZMI (0054745) Ç ™Æ≠·‚‡„™Ê®ÔÂ for each „Á‚•≠ ‰®´®†´.
*/


{globals.i}
{sh-defs.i}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

def var prn-tit as char format "x(50)" NO-UNDO.
def var prn-tit1 as char format "x(40)" NO-UNDO.
def var q  as int extent 12 initial [1,1,1,4,4,4,7,7,7,10,10,10] no-undo.
def var h  as int extent 12 initial [1,1,1,1,1,1,7,7,7,7,7,7] no-undo.
def var menu-c as char extent 6 no-undo.
def var dat1 as date no-undo .

DEFINE VARIABLE summ1 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE summ2 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE summ3 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE summ4 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE mFmt  AS CHARACTER   NO-UNDO.

beg-date = TODAY - INTEGER(iParmStr).
end-date = TODAY - INTEGER(iParmStr).

{getdaydir.i}
cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(iParmStr)) + '/oborot2.txt'.

ASSIGN
   prn-tit = "ëìååÄêçÄü éÅéêéíçÄü ÇÖÑéåéëíú"
   prn-tit1 = "· " + STRING(beg-date) + " ØÆ " + STRING(end-date) + "(¢™´ÓÁ®‚•´Ï≠Æ)"
.
IF beg-date EQ end-date THEN
   prn-tit1 = "ß† " + STRING(beg-date).

FORM HEADER CAPS(dept.name-bank) FORMAT "x(55)" AT 5
   PAGE-NUMBER FORMAT "ã®·‚zz9" TO 85 SKIP
   prn-tit  AT 5 SKIP
   prn-tit1 AT 5 SKIP
WITH FRAME prn11 WIDTH 125 NO-BOX COL 3 PAGE-TOP.

FORM
   bal-acct.bal-acct
      COLUMN-LABEL "äéÑ!ëàçíÖíàíóÖëäéÉé!ëóÖíÄ ÑÖèé"
   summ1
      COLUMN-LABEL "éëíÄíéä çÄ!çÄóÄãé èÖêàéÑÄ"
      FORMAT       ">>>>,>>>,>>>,>>9.9999999"
   summ2
      COLUMN-LABEL "éÅéêéíõ èé!ÑÖÅÖíì!áÄ èÖêàéÑ"
      FORMAT       ">>>>,>>>,>>>,>>9.9999999"
   summ3
      COLUMN-LABEL "éÅéêéíõ èé!äêÖÑàíì!áÄ èÖêàéÑ"
      FORMAT       ">>>>,>>>,>>>,>>9.9999999"
   summ4
      COLUMN-LABEL "éëíÄíéä çÄ!äéçÖñ èÖêàéÑÄ"
      FORMAT       ">>>>,>>>,>>>,>>9.9999999"
WITH FRAME prn1 WIDTH 125 DOWN.

mFmt = GetFmtQty("", "bal-acct", 24, 5).

DO ON ERROR  UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE:

   PAUSE 0.
   {setdest.i &cols=125 &filename=cFileName}

   FIND FIRST dept NO-LOCK.
   {justamin}

   FOR EACH bal-acct WHERE bal-acct.acct-cat EQ "d"
                       AND CAN-FIND(FIRST acct WHERE acct.bal-acct EQ bal-acct.bal-acct) NO-LOCK
      BREAK BY bal-acct.side WITH FRAME prn1:

      VIEW FRAME prn11.

      ASSIGN
         summ1 = 0
         summ2 = 0
         summ3 = 0
         summ4 = 0
      .
      FOR EACH acct WHERE acct.bal-acct  EQ bal-acct.bal-acct
                      AND acct.filial-id EQ shFilial NO-LOCK:

         RUN acct-qty IN h_base (acct.acct,
                                 acct.currency,
                                 beg-date,
                                 end-date,
                                 "è").
         ASSIGN
            summ1 = summ1 + sh-in-qty
            summ2 = summ2 + sh-qdb
            summ3 = summ3 + sh-qcr
            summ4 = summ4 + sh-qty
         .
      END.

      ACCUM summ1 (TOTAL BY bal-acct.side).
      ACCUM summ2 (TOTAL BY bal-acct.side).
      ACCUM summ3 (TOTAL BY bal-acct.side).
      ACCUM summ4 (TOTAL BY bal-acct.side).

      ASSIGN
         summ1:FORMAT IN FRAME prn1 = mFmt
         summ2:FORMAT IN FRAME prn1 = mFmt
         summ3:FORMAT IN FRAME prn1 = mFmt
         summ4:FORMAT IN FRAME prn1 = mFmt
      .

      IF    summ1 NE 0
         OR summ2 NE 0
         OR summ3 NE 0
         OR summ4 NE 0 THEN
      DO:
         DISPLAY
            bal-acct.bal-acct
            summ1 WHEN summ1 GE 0 @ summ1
          - summ1 WHEN summ1 LT 0 @ summ1
            summ2
            summ3
            summ4 WHEN summ4 GE 0 @ summ4
          - summ4 WHEN summ4 LT 0 @ summ4
         .
         DOWN.
      END.

      IF LAST-OF(bal-acct.side) THEN
      DO:
         UNDERLINE
            bal-acct.bal-acct
            summ1
            summ2
            summ3
            summ4
         .
         DOWN.

         DISPLAY "à‚Æ£Æ ØÆ " @ bal-acct.bal-acct.

         DOWN.

         DISPLAY
            "ØÆ †™‚®¢„"  WHEN bal-acct.side EQ "Ä" @ bal-acct.bal-acct
            "ØÆ Ø†··®¢„" WHEN bal-acct.side EQ "è" @ bal-acct.bal-acct
            ACCUM TOTAL BY bal-acct.side summ1  WHEN (ACCUM TOTAL BY bal-acct.side summ1) GE 0 @ summ1
         - (ACCUM TOTAL BY bal-acct.side summ1) WHEN (ACCUM TOTAL BY bal-acct.side summ1) LT 0 @ summ1
            ACCUM TOTAL BY bal-acct.side summ2     @ summ2
            ACCUM TOTAL BY bal-acct.side summ3     @ summ3
            ACCUM TOTAL BY bal-acct.side summ4  WHEN (ACCUM TOTAL BY bal-acct.side summ4) GE 0 @ summ4
         - (ACCUM TOTAL BY bal-acct.side summ4) WHEN (ACCUM TOTAL BY bal-acct.side summ4) LT 0 @ summ4
         .
         UNDERLINE
            bal-acct.bal-acct
            summ1
            summ2
            summ3
            summ4
         .
         DOWN.
      END.
   END.
   {signatur.i} 
END.
