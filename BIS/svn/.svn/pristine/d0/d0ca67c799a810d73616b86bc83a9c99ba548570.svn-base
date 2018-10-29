/*
               Å†≠™Æ¢·™†Ô ®≠‚•£‡®‡Æ¢†≠≠†Ô ·®·‚•¨† Åàë™¢®‚
    Copyright: (C) 1992-2002 íéé "Å†≠™Æ¢·™®• ®≠‰Æ‡¨†Ê®Æ≠≠Î• ·®·‚•¨Î"
     Filename: DEPPR(A.P
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
{intrface.get xclass}
{tmprecid.def}
DEFINE INPUT PARAMETER iParmStr AS CHARACTER.
DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

DEFINE VARIABLE prn-tit   AS CHARACTER NO-UNDO.
DEFINE VARIABLE schet     AS CHARACTER NO-UNDO.
DEFINE VARIABLE flag-side AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE ttDep NO-UNDO
   FIELD depo_acct   AS CHARACTER
   FIELD reg_num     AS CHARACTER
   FIELD acct        AS CHARACTER
   FIELD side        AS CHARACTER
   FIELD qty         AS DECIMAL

   INDEX dep side depo_acct reg_num acct
.
beg-date = TODAY - INTEGER(iParmStr).
end-date = TODAY - INTEGER(iParmStr).

{getdaydir.i}

cFileName = getDayDir('/home2/bis/quit41d/imp-exp/Arhiv',INTEGER(iParmStr)) + '/deppr.txt'.

FORM HEADER 
   CAPS(dept.name-bank) 
      FORMAT "x(55)" AT 1
   PAGE-NUMBER FORMAT "ã®·‚zz9" TO 85 SKIP(1)
   "èêéÇÖêéóçÄü ÇÖÑéåéëíú éëíÄíäéÇ ãàñÖÇõï ëóÖíéÇ ÑÖèé" 
                     AT 1 SKIP(2)
   "Ñ†‚† ·Æ·‚†¢´•≠®Ô ¢•§Æ¨Æ·‚®: " + STRING(end-date,"99/99/9999") 
      FORMAT "x(40)"      SKIP(1)
   "íÄÅãàñÄ éëíÄíäéÇ"     SKIP(2)
WITH FRAME prn11 WIDTH 150 PAGE-TOP. 

FORM  
   schet            
      COLUMN-LABEL "äéÑ!ëóÖíÄ ÑÖèé"
      FORMAT       "x(15)"
   sec-cod.reg-num  
      COLUMN-LABEL "çéåÖê ÉéëìÑÄêëíÇÖççéâ!êÖÉàëíêÄñàà ÇõèìëäÄ!ñÖççõï ÅìåÄÉ"
      FORMAT       "x(21)"
   acct.acct        
      COLUMN-LABEL "äéÑ ãàñÖÇéÉé!ëóÖíÄ ÑÖèé  "
      FORMAT       "x(25)"
   acct-qty.qty
      COLUMN-LABEL "  éëíÄíéä !ñÖççõï ÅìåÄÉ"
      FORMAT       "->>>>>>>>>>>>>9.9999999"
WITH FRAME prn WIDTH 150 DOWN.

acct-qty.qty:FORMAT IN FRAME prn = GetFmtQty("", "acct", 23, 7).

PAUSE 0.
{setdest.i &cols=85 &filename=cFileName}
FIND FIRST dept NO-LOCK.
{justamin}

VIEW FRAME prn11.
 
FOR EACH bal-acct WHERE bal-acct.acct-cat EQ "d"
NO-LOCK,

EACH acct OF bal-acct WHERE  acct.open-date  LE end-date
                        AND (acct.close-date EQ ?
                         OR  acct.close-date GE end-date)
                        AND  acct.filial-id  EQ shFilial
NO-LOCK,

FIRST tmprecid WHERE RECID(acct) EQ tmprecid.id
NO-LOCK,

FIRST sec-code WHERE sec-code.sec-code EQ acct.currency
NO-LOCK

   BREAK BY bal-acct.bal-acct:

   RUN acct-qty IN h_base (acct.acct,
                           acct.currency,
                           end-date,
                           end-date,
                           ?).
   schet = GetXattrValueEx("acct",
                           acct.acct + "," + acct.currency,
                           "Ñ•ØÆ",
                           "").
   IF NOT {assigned schet} THEN
      schet = "".

   CREATE ttDep.
   ASSIGN
      ttDep.depo_acct = schet
      ttDep.reg_num   = sec-cod.reg-num
      ttDep.acct      = acct.acct
      ttDep.side      = acct.side
      ttDep.qty       = sh-in-qty
   .
END.

FOR EACH ttDep NO-LOCK WITH FRAME prn:

   IF flag-side NE ttDep.side THEN
   DO:
      IF ttDep.side EQ "Ä" THEN DISPLAY "Ä™‚®¢≠Î• ·Á•‚†"  @ schet "" @ acct-qty.qty.
                           ELSE DISPLAY "è†··®¢≠Î• ·Á•‚†" @ schet "" @ acct-qty.qty.
      DOWN.
   END.

   DISPLAY
      ttDep.depo_acct @ schet
      ttDep.reg_num   @ sec-cod.reg-num
      ttDep.acct      @ acct.acct
      ttDep.qty WHEN ttDep.qty NE 0 @ acct-qty.qty
   .
   DOWN.

   flag-side = ttDep.side.
END.
