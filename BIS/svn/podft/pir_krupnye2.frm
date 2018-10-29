{globals.i}           /** Глобальные определения */
{intrface.get tmess}  /** Служба системных сообщений */

DEFINE VARIABLE dPorog  AS DECIMAL  FORMAT ">>>,>>>,>>>,>>>,>>9" INIT 100000000 NO-UNDO
   VIEW-AS FILL-IN    SIZE 30 BY 1
   LABEL  "Порог".
DEFINE VARIABLE lNeStnd AS LOGICAL                   NO-UNDO
   VIEW-AS TOGGLE-BOX SIZE 30 BY 1
   LABEL "Нестандартный вариант".
DEFINE VARIABLE iMes    AS INTEGER FORMAT ">9"       NO-UNDO
   VIEW-AS FILL-IN    SIZE  2 BY 1
   LABEL  "Месяц".
DEFINE VARIABLE iGod    AS INTEGER FORMAT "9999"     NO-UNDO
   VIEW-AS FILL-IN    SIZE  4 BY 1
   LABEL  "Год".
DEFINE VARIABLE daBegYP AS DATE FORMAT "99.99.9999"  INIT 01/01/2010 NO-UNDO
   VIEW-AS FILL-IN    SIZE 10 BY 1
   LABEL  "Начало".
DEFINE VARIABLE daBegY  AS DATE FORMAT "99.99.9999"  INIT 01/01/2010 NO-UNDO
   VIEW-AS FILL-IN    SIZE 10 BY 1.
DEFINE VARIABLE daBegM  AS DATE FORMAT "99.99.9999"  INIT 01/01/2010 NO-UNDO
   VIEW-AS FILL-IN    SIZE 10 BY 1.
DEFINE VARIABLE daEndYP AS DATE FORMAT "99.99.9999"  INIT 01/01/2010 NO-UNDO
   VIEW-AS FILL-IN    SIZE 10 BY 1
   LABEL  "Конец".
DEFINE VARIABLE daEndY  AS DATE FORMAT "99.99.9999"  INIT 01/01/2010 NO-UNDO
   VIEW-AS FILL-IN    SIZE 10 BY 1.
DEFINE VARIABLE daEndM  AS DATE FORMAT "99.99.9999"  INIT 01/01/2010 NO-UNDO
   VIEW-AS FILL-IN    SIZE 10 BY 1.
DEFINE VARIABLE cZgl1   AS CHARACTER INIT " Период 1    Период 2    Период 3" FORMAT "x(33)" NO-UNDO
   VIEW-AS FILL-IN    SIZE 33 BY 1.
DEFINE VARIABLE cZgl2   AS CHARACTER INIT "(Пред.год)     (год)     (Месяц) " FORMAT "x(33)" NO-UNDO
   VIEW-AS FILL-IN    SIZE 33 BY 1.

DEFINE FRAME fDates
   dPorog  AT ROW 1 COL  5
   lNeStnd AT ROW 2 COL  2
   iMes    AT ROW 3 COL  5
   iGod    AT ROW 3 COL 16
   cZgl1   AT ROW 4 COL 10 NO-LABEL
   cZgl2   AT ROW 5 COL 10 NO-LABEL
   daBegYP AT ROW 6 COL  2
   daEndYP AT ROW 7 COL  3
   daBegY  AT ROW 6 COL 22 NO-LABEL
   daEndY  AT ROW 7 COL 22 NO-LABEL
   daBegM  AT ROW 6 COL 34 NO-LABEL
   daEndM  AT ROW 7 COL 34 NO-LABEL
   WITH KEEP-TAB-ORDER OVERLAY
      SIDE-LABELS NO-UNDERLINE
      AT COL 5 ROW 5
      SIZE 47 BY 9.

DEFINE VARIABLE iYM     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iMes1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iGod1   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cListN  AS CHARACTER NO-UNDO.

ASSIGN
   iMes    = MONTH(TODAY)
   iGod    = YEAR(TODAY)
   iYM     = 12 * iGod + iMes - 2
   iMes    = (iYM MODULO 12) + 1
   iGod    = INTEGER(TRUNCATE(iYM / 12, 0))
   daBegM  = DATE(iMes, 1, iGod)
   daBegYP = DATE(iMes, 1, iGod - 1)
   iYM     = iYM + 1
   iMes1   = (iYM MODULO 12) + 1
   iGod1   = INTEGER(TRUNCATE(iYM / 12, 0))
   daEndM  = DATE(iMes1, 1, iGod1) - 1
   daEndY  = daEndM
   daBegY  = DATE(iMes1, 1, iGod1 - 1)
   daEndYP = daBegM - 1
   lNeStnd = NO
   daBegYP:HIDDEN    = YES
   daEndYP:HIDDEN    = YES
   daBegY:HIDDEN     = YES
   daEndY:HIDDEN     = YES
   daBegM:HIDDEN     = YES
   daEndM:HIDDEN     = YES
   cZgl1:HIDDEN      = YES
   cZgl2:HIDDEN      = YES
   daBegYP:SENSITIVE = YES
   daEndYP:SENSITIVE = YES
   daBegY:SENSITIVE  = YES
   daEndY:SENSITIVE  = YES
   daBegM:SENSITIVE  = YES
   daEndM:SENSITIVE  = YES
   NO-ERROR.

ON VALUE-CHANGED OF lNeStnd IN FRAME fDates
DO:
   ASSIGN lNeStnd.

   IF lNeStnd
   THEN
      ASSIGN
         iMes:HIDDEN    = YES
         iGod:HIDDEN    = YES
         daBegYP:HIDDEN = NO
         daEndYP:HIDDEN = NO
         daBegY:HIDDEN  = NO
         daEndY:HIDDEN  = NO
         daBegM:HIDDEN  = NO
         daEndM:HIDDEN  = NO
         cZgl1:HIDDEN   = NO
         cZgl2:HIDDEN   = NO
         daBegYP:SCREEN-VALUE = STRING(daBegYP, "99.99.9999")
         daEndYP:SCREEN-VALUE = STRING(daEndYP, "99.99.9999")
         daBegY:SCREEN-VALUE  = STRING(daBegY,  "99.99.9999")
         daEndY:SCREEN-VALUE  = STRING(daEndY,  "99.99.9999")
         daBegM:SCREEN-VALUE  = STRING(daBegM,  "99.99.9999")
         daEndM:SCREEN-VALUE  = STRING(daEndM,  "99.99.9999")
         cZgl1:SCREEN-VALUE   = cZgl1
         cZgl2:SCREEN-VALUE   = cZgl2
         .
   ELSE
      ASSIGN
         iMes:HIDDEN    = NO
         iGod:HIDDEN    = NO
         daBegYP:HIDDEN = YES
         daEndYP:HIDDEN = YES
         daBegY:HIDDEN  = YES
         daEndY:HIDDEN  = YES
         daBegM:HIDDEN  = YES
         daEndM:HIDDEN  = YES
         cZgl1:HIDDEN   = YES
         cZgl2:HIDDEN   = YES
         .
END.

ON LEAVE OF iMes IN FRAME fDates
DO:
   iMes = INTEGER(iMes:SCREEN-VALUE).
   IF    (iMes LE  0)
      OR (iMes GT 12)
   THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0", "Неправильный месяц!").
      RETURN NO-APPLY .
   END.
END.

UPDATE UNLESS-HIDDEN
   dPorog
   lNeStnd iMes iGod
   cZgl1 cZgl2
   daBegYP daEndYP
   daBegY  daEndY
   daBegM  daEndM
   WITH FRAME fDates.

ASSIGN lNeStnd.
IF lNeStnd
THEN
   ASSIGN
      daBegYP = DATE(daBegYP:SCREEN-VALUE)
      daEndYP = DATE(daEndYP:SCREEN-VALUE)
      daBegY  = DATE(daBegY:SCREEN-VALUE)
      daEndY  = DATE(daEndY:SCREEN-VALUE)
      daBegM  = DATE(daBegM:SCREEN-VALUE)
      daEndM  = DATE(daEndM:SCREEN-VALUE)
      cListN  = daBegM:SCREEN-VALUE + "-" + daEndM:SCREEN-VALUE
      .
ELSE
   ASSIGN
      iMes    = INTEGER(iMes:SCREEN-VALUE)
      iGod    = INTEGER(iGod:SCREEN-VALUE)
      daBegM  = DATE(iMes, 1, iGod)
      daBegYP = DATE(iMes, 1, iGod - 1)
      iYM     = 12 * iGod + iMes
      iMes1   = (iYM MODULO 12) + 1
      iGod1   = INTEGER(TRUNCATE(iYM / 12, 0))
      daEndM  = DATE(iMes1, 1, iGod1) - 1
      daEndY  = daEndM
      daBegY  = DATE(iMes1, 1, iGod1 - 1)
      daEndYP = daBegM - 1
      cListN  = STRING(daEndM + 1, "99.99.9999")
      .

HIDE FRAME fDates.
