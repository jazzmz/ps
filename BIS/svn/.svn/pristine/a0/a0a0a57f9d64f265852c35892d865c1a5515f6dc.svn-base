{globals.i}           /** Глобальные определения */
{intrface.get tmess}  /** Служба системных сообщений */

DEFINE VARIABLE cZgl1  AS CHARACTER INIT "    Просматривать период:" FORMAT "x(33)" NO-UNDO
   VIEW-AS TEXT        SIZE 33 BY 1.
DEFINE VARIABLE cZgl2  AS CHARACTER INIT "    Отбирать: "            FORMAT "x(33)" NO-UNDO
   VIEW-AS TEXT        SIZE 33 BY 1.
DEFINE VARIABLE daBeg  AS DATE FORMAT "99.99.9999"  NO-UNDO
   VIEW-AS FILL-IN     SIZE 10 BY 1.
DEFINE VARIABLE daEnd  AS DATE FORMAT "99.99.9999"  NO-UNDO
   VIEW-AS FILL-IN     SIZE 10 BY 1.
DEFINE VARIABLE iVar   AS INTEGER  NO-UNDO
   VIEW-AS RADIO-SET VERTICAL
   RADIO-BUTTONS 
      " Все, поставленные на контроль", 1,
      " Все, не снятые с контроля",     2,
      " До окончания контроля ",        3,
      " От начала контроля",            4.
DEFINE VARIABLE lLG1   AS LOGICAL               FORMAT " </>=" NO-UNDO
   VIEW-AS FILL-IN     SIZE 2 BY 1.
DEFINE VARIABLE iSrok1 AS INTEGER               FORMAT ">>9"   NO-UNDO
   VIEW-AS FILL-IN     SIZE 3 BY 1.
DEFINE VARIABLE cDen1  AS CHARACTER INIT "дней" FORMAT "x(4)"  NO-UNDO
   VIEW-AS TEXT        SIZE 4 BY 1.
DEFINE VARIABLE lLG2   AS LOGICAL               FORMAT " </>=" NO-UNDO
   VIEW-AS FILL-IN     SIZE 2 BY 1.
DEFINE VARIABLE iSrok2 AS INTEGER               FORMAT ">>9"   NO-UNDO
   VIEW-AS FILL-IN     SIZE 3 BY 1.
DEFINE VARIABLE cDen2  AS CHARACTER INIT "дней" FORMAT "x(4)"  NO-UNDO
   VIEW-AS TEXT        SIZE 4 BY 1.

daBeg = gbeg-date.
daEnd = TODAY.

DEFINE FRAME fDates
   cZgl1    AT ROW 1 COL  1 NO-LABEL
   daBeg    AT ROW 2 COL  1 LABEL "с"
   daEnd    AT ROW 2 COL 16 LABEL "по"
   cZgl2    AT ROW 3 COL  1 NO-LABEL
   iVar     AT ROW 4 COL  1 NO-LABEL
   lLG1     AT ROW 6 COL 27 NO-LABEL
   iSrok1   AT ROW 6 COL 30 NO-LABEL
   cDen1    AT ROW 6 COL 34 NO-LABEL
   lLG2     AT ROW 7 COL 27 NO-LABEL
   iSrok2   AT ROW 7 COL 30 NO-LABEL
   cDen2    AT ROW 7 COL 34 NO-LABEL
   WITH KEEP-TAB-ORDER OVERLAY
      SIDE-LABELS NO-UNDERLINE
      AT COL 15 ROW 10
      TITLE " Условие выборки: "
      SIZE 40 BY 9.

ASSIGN
   lLG1:HIDDEN      = YES
   iSrok1:HIDDEN    = YES
   cDen1:HIDDEN     = YES
   lLG2:HIDDEN      = YES
   iSrok2:HIDDEN    = YES
   cDen2:HIDDEN     = YES
   lLG1:SENSITIVE   = YES
   iSrok1:SENSITIVE = YES
   cDen1:SENSITIVE  = YES
   lLG2:SENSITIVE   = YES
   iSrok2:SENSITIVE = YES
   cDen2:SENSITIVE  = YES
   NO-ERROR.

ON F1, " " OF lLG1 IN FRAME fDates
DO:
   lLG1:SCREEN-VALUE = IF lLG1 THEN ">=" ELSE " <".
   lLG1 = NOT lLG1.
END.

ON F1, " " OF lLG2 IN FRAME fDates
DO:
   lLG2:SCREEN-VALUE = IF lLG2 THEN ">=" ELSE " <".
   lLG2 = NOT lLG2.
END.

ON VALUE-CHANGED OF iVar IN FRAME fDates
DO:
   ASSIGN iVar.

   CASE iVar:
      WHEN 1 THEN
         ASSIGN
            lLG1:HIDDEN    = YES
            iSrok1:HIDDEN  = YES
            cDen1:HIDDEN   = YES
            lLG2:HIDDEN    = YES
            iSrok2:HIDDEN  = YES
            cDen2:HIDDEN   = YES
            NO-ERROR.
      WHEN 2 THEN
         ASSIGN
            lLG1:HIDDEN    = YES
            iSrok1:HIDDEN  = YES
            cDen1:HIDDEN   = YES
            lLG2:HIDDEN    = YES
            iSrok2:HIDDEN  = YES
            cDen2:HIDDEN   = YES
            NO-ERROR.
      WHEN 3 THEN
         ASSIGN
            lLG2:HIDDEN    = YES
            iSrok2:HIDDEN  = YES
            cDen2:HIDDEN   = YES
            lLG1:HIDDEN    = NO
            iSrok1:HIDDEN  = NO
            cDen1:HIDDEN   = NO
            lLG1:SCREEN-VALUE    = IF lLG1 THEN " <" ELSE ">="
            iSrok1:SCREEN-VALUE  = "0"
            cDen1:SCREEN-VALUE   = cDen1
            NO-ERROR.
      WHEN 4 THEN
         ASSIGN
            lLG1:HIDDEN    = YES
            iSrok1:HIDDEN  = YES
            cDen1:HIDDEN   = YES
            lLG2:HIDDEN    = NO
            iSrok2:HIDDEN  = NO
            cDen2:HIDDEN   = NO
            lLG2:SCREEN-VALUE    = IF lLG2 THEN " <" ELSE ">="
            iSrok2:SCREEN-VALUE  = "0"
            cDen2:SCREEN-VALUE   = cDen2
            NO-ERROR.
   END CASE.
END.

UPDATE UNLESS-HIDDEN
   cZgl1 cZgl2
   daBeg daEnd
   iVar
   lLG1 iSrok1 cDen1
   lLG2 iSrok2 cDen2
   WITH FRAME fDates.

ASSIGN
   daBeg
   daEnd
   iVar
/*   lLG1 */
   iSrok1
/*   lLG2 */
   iSrok2
   NO-ERROR.

HIDE FRAME fDates.

IF (daEnd = ?)
THEN daEnd = daBeg.
