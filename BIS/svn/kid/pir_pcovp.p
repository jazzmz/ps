{pirsavelog.p}
/** 
   ŽŽŽ Š "PŽŒˆ‚…‘’€‘—…’", “¯à ¢«¥­¨¥  ¢â®¬ â¨§ æ¨¨ (á) 2009

   ®à¨á®¢ €.‚., 10.08.2010
*/

{globals.i}           /** ƒ«®¡ «ì­ë¥ ®¯à¥¤¥«¥­¨ï */
{tmprecid.def}        /** ˆá¯®«ì§ã¥¬ ¨­ä®à¬ æ¨î ¨§ ¡à®ã§¥à  */
{intrface.get xclass} /** ”ã­ªæ¨¨ ¤«ï à ¡®âë á ¬¥â áå¥¬®© */
{intrface.get strng}  /** ”ã­ªæ¨¨ ¤«ï à ¡®âë á® áâà®ª ¬¨ */
{intrface.get instrum}

{ulib.i}
{sh-defs.i}
{pir_exf_exl.i}

/******************************************* Ž¯à¥¤¥«¥­¨¥ ¯¥à¥¬¥­­ëå ¨ ¤à. */
DEFINE INPUT PARAMETER cParam AS CHARACTER.
/*
cParam = "47423840600010502895;47425810300050502895".
*/
DEFINE VARIABLE cXL   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTmp  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iT    AS INTEGER    NO-UNDO.
DEFINE VARIABLE dRur  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dVal  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSRur AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dSVal AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dRRur AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dRVal AS DECIMAL    NO-UNDO.
DEFINE VARIABLE d9usd AS DECIMAL    NO-UNDO.
DEFINE VARIABLE d9eur AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dRate AS DECIMAL    NO-UNDO.
DEFINE VARIABLE d840  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE d978  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lFst  AS LOGICAL    INIT NO  NO-UNDO.
DEFINE BUFFER bRAcct FOR acct.

FUNCTION FIN RETURNS CHARACTER
   (INPUT cFIO AS CHARACTER).

   RETURN ENTRY(1, cFIO, " ") + " "
        + SUBSTRING(ENTRY(2, cFIO, " "), 1, 1) + "."
        + SUBSTRING(ENTRY(3, cFIO, " "), 1, 1) + ".".
END.

/******************************************* ¥ «¨§ æ¨ï */
{getdate.i}
{setdest.i &cols=200}

PUT UNFORMATTED
   SPACE(110) "‚ “¯à ¢«¥­¨¥ 9" SKIP
   "„«ï à áç¥â  Ž‚ §  " end-date FORMAT "99.99.9999" "£. á®®¡é ¥¬ á«¥¤ãîé¨¥ á¢¥¤¥­¨ï:" SKIP
   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                           " SKIP
   "³                    ³                        ³ Š®¤  ³ Šãàá  ³ ‘ã¬¬  ®áâ âª  ³ ‘ã¬¬  ®áâ âª ,³ƒàã¯¯ ³   §¬¥à  ³     ‘ã¬¬      ³     ‘ã¬¬      ³" SKIP
   "³    ®¬¥à áç¥â      ³ ¨¬¥­®¢ ­¨¥ ª®­âà £¥­â ³¢ «îâë³¢ «îâë ³    ¢ ¢ «îâ¥   ³  íª¢¨¢ «¥­â   ³à¨áª  ³®âç¨á«¥­¨©³áä®à¬¨à®¢ ­­®£®³áä®à¬¨à®¢ ­­®£®³" SKIP
   "³                    ³                        ³      ³       ³               ³   ¢ àã¡«ïå    ³      ³    ¢ %   ³à¥§¥à¢  ¢ ¢ «. ³à¥§¥à¢  ¢ àã¡. ³" SKIP
   "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
   .

ASSIGN
   dSRur = 0
   dSVal = 0
   dRRur = 0
   dRVal = 0
   d840  = FindRateSimple("“ç¥â­ë©", "840", end-date)
   d978  = FindRateSimple("“ç¥â­ë©", "978", end-date)
   NO-ERROR.

FOR EACH bal-acct
   WHERE (bal-acct.bal-acct EQ 30233)
      OR (bal-acct.bal-acct EQ 45510)
/*      OR (bal-acct.bal-acct EQ 47423) */ /* 2011.09.19 Sitov S.: “¡à ­® ¯® ¯à®áì¡¥ ãï­®¢®© .ƒ.*/
      OR (bal-acct.bal-acct EQ 60323)
      OR (bal-acct.bal-acct EQ 91604)
   NO-LOCK,
   EACH acct OF bal-acct
      WHERE CAN-DO("!.....810*,30233*050....,45510*050....,47423*050....,60323*15.....,91604978300010504827", acct.acct)
      NO-LOCK
      BREAK BY bal-acct.bal-acct
      BY acct.currency
      BY acct.acct:

   dRate = IF (acct.currency EQ "840") THEN d840 ELSE d978.

   CASE bal-acct.bal-acct:
      WHEN 30233 THEN
         ASSIGN
            cTmp = acct.acct
            SUBSTRING(cTmp, 1, 9) = "30226810."
            NO-ERROR.
      WHEN 45510 THEN
         ASSIGN
            cTmp = acct.acct
            SUBSTRING(cTmp, 1, 9) = "45515810."
            NO-ERROR.
      WHEN 47423 THEN
         ASSIGN
            cTmp = acct.acct
            SUBSTRING(cTmp, 1, 9) = "47425810."
            NO-ERROR.
      WHEN 60323 THEN
         ASSIGN
            cTmp = acct.acct
            SUBSTRING(cTmp, 1, 9) = "60324810."
            NO-ERROR.
      WHEN 91604 THEN
         ASSIGN
            cTmp = acct.acct
            SUBSTRING(cTmp, 1, 9) = "47425810."
            NO-ERROR.
   END CASE.

   RUN acct-pos IN h_base(acct.acct, acct.currency, end-date, end-date, cTmp).

   IF (sh-val NE 0)
   THEN DO:

      ASSIGN
         dRur = sh-bal
         dVal = sh-val
         dSRur = dSRur + dRur
         dSVal = dSVal + dVal
         NO-ERROR.

      IF (bal-acct.bal-acct NE 91604)
      THEN DO:
         iT = LOOKUP(acct.acct, ENTRY(1, cParam, ";")).
         IF (iT NE 0)
         THEN
            FIND FIRST bRAcct
               WHERE (bRAcct.acct EQ ENTRY(iT, ENTRY(2, cParam, ";")))
               NO-LOCK NO-ERROR.
         ELSE
            FIND FIRST bRAcct
               WHERE CAN-DO(cTmp, bRAcct.acct)
               NO-LOCK NO-ERROR.

         IF (AVAIL bRAcct)
         THEN DO:
            RUN acct-pos IN h_base(bRAcct.acct, bRAcct.currency, end-date, end-date, cTmp).
            ASSIGN
               sh-bal = ABS(sh-bal)
               sh-val = ROUND(sh-bal / dRate, 2)
               dRRur  = dRRur + sh-bal
               dRVal  = dRVal + sh-val
               NO-ERROR.
         END.
         ELSE
            ASSIGN
               sh-val = 0
               sh-bal = 0
               NO-ERROR.
      END.
      ELSE
         ASSIGN
            sh-val = 0
            sh-bal = 0
/*
            dRRur = dRRur + dRur
            dRVal = dRVal + dVal
*/
            NO-ERROR.

      cTmp = GetAcctClientName_UAL(acct.acct, NO).
      cTmp = IF (cTmp NE "") THEN FIN(cTmp) ELSE acct.details.

      IF (bal-acct.bal-acct NE 91604)
      THEN DO:
         IF lFst
         THEN
            PUT UNFORMATTED
               "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
               .
         lFst = NO.

         PUT UNFORMATTED
            "³" acct.acct
            "³" cTmp FORMAT "x(24)"
            "³  " acct.currency
           " ³" dRate FORMAT "99.9999"
            "³" dVal  FORMAT ">>>>,>>>,>>9.99"
            "³" dRur  FORMAT ">>>>,>>>,>>9.99"
            "³   5  "
            "³    " (IF (bal-acct.bal-acct EQ 91604) THEN "  0   " ELSE "100   ")
            "³" sh-val FORMAT ">>>>,>>>,>>9.99"
            "³" sh-bal FORMAT ">>>>,>>>,>>9.99"
            "³" SKIP
         .
      END.
   END.

   IF     LAST-OF(acct.currency)
      AND (dSVal NE 0)
   THEN DO:

      IF (STRING(bal-acct.bal-acct) EQ "91604")
      THEN IF (acct.currency EQ "840")
         THEN  d9usd = dSVal.
         ELSE  d9eur = dSVal.
      ELSE
         PUT UNFORMATTED
            "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
            "³                    "
            "  ˆ’ŽƒŽ ¯®  " + STRING(bal-acct.bal-acct) + " " + acct.currency + " :  "
            "      "
           "         "
            "³" dSVal  FORMAT ">>>>,>>>,>>9.99"
            "³" dSRur  FORMAT ">>>>,>>>,>>9.99"
            "³      "
            "           "
            "³" dRVal FORMAT ">>>>,>>>,>>9.99"
            "³" dRRur FORMAT ">>>>,>>>,>>9.99"
            "³" SKIP
         .

      ASSIGN
         dSRur = 0
         dSVal = 0
         dRRur = 0
         dRVal = 0
         lFst  = YES
         NO-ERROR.
   END.
END.

FIND FIRST _user
   WHERE (_user._userid = USERID)
   NO-LOCK NO-ERROR.

PUT UNFORMATTED
   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" SKIP(2)
/*   "                  ŠŽ’Ž‹œ›… ‘“ŒŒ› „‹Ÿ €‘—…’€ Ž‚" SKIP
   "                           ‡  " end-date FORMAT "99.99.9999" "£." SKIP(1)
   "ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ" SKIP
   "‘ã¬¬  ®áâ âª®¢ ­  áç¥â å 91604 (¢ «)    " d9usd FORMAT ">>>>,>>>,>>9.99" "  „®««.‘˜€" SKIP
   "                                        " d9eur FORMAT ">>>>,>>>,>>9.99" "  …¢à®" SKIP
   "ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ" SKIP
   "‘ã¬¬  ®áâ âª®¢ ­  áç¥â å 91604 ¤«ï Ž‚  " 0 FORMAT ">>>>,>>>,>>9.99" "  „®««.‘˜€" SKIP
   "91604*(100%-¥§¥à¢ ¢ %)                 " 0 FORMAT ">>>>,>>>,>>9.99" "  …¢à®" */ SKIP(2)
   "ˆá¯®«­¨â¥«ì  ___________________ / " + FIN(_user._user-name) + " /" SKIP
   .
{preview.i}
{intrface.del}
