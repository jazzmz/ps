{globals.i}           /** Глобальные определения */
{intrface.get tmess}  /** Служба системных сообщений */

DEFINE VARIABLE cZgl1  AS CHARACTER INIT "  Просматривать период:"       FORMAT "x(33)" NO-UNDO
   VIEW-AS TEXT        SIZE 33 BY 1.
DEFINE VARIABLE cZgl2  AS CHARACTER INIT "  Отбирать операции с суммой:" FORMAT "x(33)" NO-UNDO
   VIEW-AS TEXT        SIZE 33 BY 1.
DEFINE VARIABLE daBeg  AS DATE FORMAT "99.99.9999"  NO-UNDO
   VIEW-AS FILL-IN     SIZE 10 BY 1.
DEFINE VARIABLE daEnd  AS DATE FORMAT "99.99.9999"  NO-UNDO
   VIEW-AS FILL-IN     SIZE 10 BY 1.
DEFINE VARIABLE nBeg   AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99"  NO-UNDO
   VIEW-AS FILL-IN     SIZE 22 BY 1.
DEFINE VARIABLE nEnd   AS DECIMAL FORMAT ">>>,>>>,>>>,>>>,>>9.99"  NO-UNDO
   VIEW-AS FILL-IN     SIZE 22 BY 1.

IF (gend-date NE ?)
THEN DO:
   daBeg = gend-date.
   daEnd = gend-date.
END.
ELSE DO:
   daBeg = TODAY - 1.
   daEnd = TODAY - 1.
END.

nBeg  = 0.0.
nEnd  = 999999999999999.99.

   DEFINE FRAME fDates
      cZgl1    AT ROW 1 COL  1 NO-LABEL
      daBeg    AT ROW 2 COL  1 LABEL "с"
      daEnd    AT ROW 2 COL 16 LABEL "по"
      cZgl2    AT ROW 3 COL  1 NO-LABEL
      nBeg     AT ROW 4 COL  1 LABEL "от"
      nEnd     AT ROW 5 COL  1 LABEL "до"
      WITH KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE
         AT COL 15 ROW 10
         TITLE " Условие выборки: "
         SIZE 32 BY 7.

UPDATE UNLESS-HIDDEN
   cZgl1 cZgl2
   daBeg daEnd
   nBeg  nEnd
   WITH FRAME fDates.

ASSIGN
   daBeg
   daEnd
   nBeg
   nEnd
   NO-ERROR.

HIDE FRAME fDates.

IF (daEnd = ?)
THEN daEnd = daBeg.
