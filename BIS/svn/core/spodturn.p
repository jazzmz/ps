/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) ’ŽŽ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: SPODTURN.P
      Comment: ‚¥¤®¬®áâì ®¡®à®â®¢ ¯® ®âà ¦¥­¨î á®¡ëâ¨© ¯®á«¥ ®âç¥â­®© ¤ âë
   Parameters:
         Uses:
      Used by:
      Created: 27.12.2004 12:58 sadm
     Modified: 27.12.2004 13:01 sadm     
     Modified: 
*/

&SCOPED-DEFINE report-width 245

{globals.i}
{wordwrap.def}
{tmprecid.def}
{empty tmprecid}

DEFINE BUFFER bop-entry FOR op-entry.

DEFINE VARIABLE mAcctDb   LIKE op-entry.acct-db.
DEFINE VARIABLE mAcctCr   LIKE op-entry.acct-cr.
DEFINE VARIABLE mAmtRubDb LIKE op-entry.amt-rub.
DEFINE VARIABLE mAmtEquDb LIKE op-entry.amt-rub.
DEFINE VARIABLE mAmtTotDb LIKE op-entry.amt-rub.
DEFINE VARIABLE oAmtTotDb LIKE op-entry.amt-rub.
DEFINE VARIABLE oAmtTotCr LIKE op-entry.amt-rub.
DEFINE VARIABLE mAmtRubCr LIKE op-entry.amt-rub.
DEFINE VARIABLE mAmtEquCr LIKE op-entry.amt-rub.
DEFINE VARIABLE mAmtTotCr LIKE op-entry.amt-rub.
DEFINE VARIABLE mBankName AS   CHARACTER NO-UNDO FORMAT "X(60)".
DEFINE VARIABLE mDetails  AS   CHARACTER NO-UNDO FORMAT "X(50)" EXTENT 10.
DEFINE VARIABLE i         AS   INT64   NO-UNDO.

DEFINE FRAME frDetails
   "³" mAcctDb "³" mAmtRubDb "³" mAmtEquDb "³" mAmtTotDb "³" mAcctCr "³" mAmtRubCr "³" mAmtEquCr "³" mAmtTotCr "³" mDetails[1] "³"
   WITH WIDTH {&report-width} NO-LABELS NO-BOX.
DEFINE FRAME frEnd
   "                                                                   ˆ’ŽƒŽ:" oAmtTotDb "                                                                  ˆ’ŽƒŽ: " oAmtTotCr 
   skip (2)
   "ãª®¢®¤¨â¥«ì" SPACE(50) "ƒ« ¢­ë© ¡ãå£ «â¥à"
   WITH WIDTH {&report-width} NO-LABELS NO-BOX.

{getdates.i}

mBankName = fGetSetting (" ­ª", ?, "").

{setdest.i &cols={&report-width}}

DISPLAY
   &IF DEFINED (p12) &THEN
      "à¨«®¦¥­¨¥ 12 " AT 229 SKIP
      "ª à ¢¨« ¬ ¢¥¤¥­¨ï ¡ãå£ «â¥àáª®£® ãç¥â " AT 203 SKIP
      "¢ ªà¥¤¨â­ëå ®à£ ­¨§ æ¨ïå, à á¯®«®¦¥­­ëå" AT 203 SKIP
      "­  â¥àà¨â®à¨¨ ®áá¨©áª®© ”¥¤¥à æ¨¨"      AT 203 SKIP
   &ENDIF
   mBankName SKIP
   FILL("Ä", MAXIMUM(36, LENGTH(mBankName))) FORMAT "X(60)" SKIP
   "" + (IF end-date GE DATE("21/08/2010") /* ® ¨­áâàãªæ¨¨ 2477-“ á 21.08.2010 */
         THEN "(¯®«­®¥ ¨«¨ á®ªà é¥­­®¥ ä¨à¬¥­­®¥ ­ ¨¬¥­®¢ ­¨¥ ªà¥¤¨â­®© ®à£ ­¨§ æ¨¨)"
         ELSE "(­ ¨¬¥­®¢ ­¨¥ ªà¥¤¨â­®© ®à£ ­¨§ æ¨¨)") FORMAT "X(215)" SKIP (1)
   "             ‚¥¤®¬®áâì ®¡®à®â®¢"            AT &IF DEFINED (p12) &THEN 1 &ELSE 40 &ENDIF SKIP
   &IF DEFINED (p12) EQ 0 &THEN
      "à¨«®¦¥­¨¥ 12 " AT 215 SKIP
   &ENDIF
   " ¯® ®âà ¦¥­¨î á®¡ëâ¨© ¯®á«¥ ®âç¥â­®© ¤ âë"  AT &IF DEFINED (p12) &THEN 1 &ELSE 40 &ENDIF SKIP
   "              § "                           AT &IF DEFINED (p12) &THEN 1 &ELSE 40 &ENDIF term2str(beg-date, end-date) FORMAT "X(20)" SKIP(1)
   "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" SKIP
   "³                                        Ž¡®à®âë ¯® ¤¥¡¥âã                                    ³                                       Ž¡®à®âë ¯® ªà¥¤¨âã                                    ³              ‘®¤¥à¦ ­¨¥ ®¯¥à æ¨¨                   ³" SKIP
   "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                                                    ³" SKIP
&IF DEFINED (p12) &THEN
   "³   ®¬¥à «¨æ¥¢®£® áç¥â     ³      ‚ àã¡«ïå       ³ ¨­®áâà ­­ ï ¢ «îâ  ¢³        ˆâ®£®        ³   ®¬¥à «¨æ¥¢®£® áç¥â     ³       ‚ àã¡«ïå      ³ ¨­®áâà ­­ ï ¢ «îâ  ¢³        ˆâ®£®        ³                                                    ³" SKIP
&ELSE
   "³   ®¬¥à «¨æ¥¢®£® áç¥â     ³      ‚ àã¡«ïå       ³     ˆ­.¢ «îâ  ¢     ³        ˆâ®£®        ³   ®¬¥à «¨æ¥¢®£® áç¥â     ³       ‚ àã¡«ïå      ³     ˆ­.¢ «îâ  ¢     ³        ˆâ®£®        ³                                                    ³" SKIP
&ENDIF
   "³                           ³                     ³ àã¡«¥¢®¬ íª¢¨¢ «¥­â¥³                     ³                           ³                     ³ àã¡«¥¢®¬ íª¢¨¢ «¥­â¥³                     ³                                                    ³" SKIP
   "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´" SKIP
WITH WIDTH {&report-width} NO-LABEL FRAME frHeader.


FOR EACH op       WHERE op.op-date GE beg-date AND op.op-date LE end-date
                    AND op.op-status >= gop-status,
    EACH op-entry OF op
    NO-LOCK:

   IF GetXAttrValueEx("op-entry",
                      STRING(op-entry.op) + "," + STRING(op-entry.op-entry),
                      "‘Ž„",
                      "¥â") NE "„ " THEN
      NEXT.

   mAcctDb = IF op-entry.acct-db NE ? THEN op-entry.acct-db ELSE "".
   mAmtRubDb = IF op-entry.acct-db NE ? THEN op-entry.amt-rub ELSE 0.
   mAcctCr = IF op-entry.acct-cr NE ? THEN op-entry.acct-cr ELSE "".
   mAmtRubCr = IF op-entry.acct-cr NE ? THEN op-entry.amt-rub ELSE 0.

   /* ¯à®¢¥àª  ¢ «îâë áç¥â  ¤¥¡¥â  */
   IF CAN-FIND(acct WHERE acct.acct EQ mAcctDb AND acct.currency EQ "") THEN DO:
      mAmtEquDb = 0.
   END.
   ELSE DO:
      mAmtEquDb = mAmtRubDb.
      mAmtRubDb = 0.
   END.

   /* ¯à®¢¥àª  ¢ «îâë áç¥â  ªà¥¤¨â  */
   IF CAN-FIND(acct WHERE acct.acct EQ mAcctCr AND acct.currency EQ "") THEN DO:
      mAmtEquCr = 0.
   END.
   ELSE DO:
      mAmtEquCr = mAmtRubCr.
      mAmtRubCr = 0.
   END.

   ASSIGN
      mAmtTotDb = mAmtRubDb + mAmtEquDb
      mAmtTotCr = mAmtRubCr + mAmtEquCr
   .

    ACCUMULATE mAmtTotDb (total). 
    ACCUMULATE mAmtTotCr (total). 
    
     
   mDetails[1] = op.Details.
   {wordwrap.i &s=mDetails &l=INT64(mDetails[1]:WIDTH-CHARS) &n=EXTENT(mDetails)}

   DISPLAY mAcctDb
           mAmtRubDb WHEN mAcctDb NE ""
           mAmtEquDb WHEN mAcctDb NE ""
           mAmtTotDb WHEN mAcctDb NE ""
           mAcctCr   WHEN mAcctCr NE ""
           mAmtRubCr WHEN mAcctCr NE ""
           mAmtEquCr WHEN mAcctCr NE ""
           mAmtTotCr WHEN mAcctCr NE ""
           mDetails[1]
      WITH FRAME frDetails.

   /* ¬­®£®áâà®ç­ë© ¢ë¢®¤ ®á­®¢ ­¨ï ¯« â¥¦  */
   DO i = 2 TO EXTENT(mDetails) WITH FRAME frDetails:
      IF mDetails[i] EQ "" THEN
         LEAVE.
      DOWN.
      DISPLAY mDetails[i] @ mDetails[1].
   END.

   CREATE tmprecid. /* §é ¯®¬¨â­ ¥¬, çâ® ®¡à ¡®â «¨ ¯®«ã¯à®¢®¤ªã */
   tmprecid.id = RECID(op-entry).
END.

oAmtTotDb = accum  total  mAmtTotDb.
oAmtTotCr = accum  total  mAmtTotCr.

DISPLAY
   "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" SKIP
WITH WIDTH {&report-width} FRAME frFother NO-BOX.

DISPLAY
   oAmtTotDb format "->>>,>>>,>>>,>>9.99"
   oAmtTotCr format "->>>,>>>,>>>,>>9.99"
   SKIP(2)
WITH FRAME frEnd.


&IF DEFINED (p12) &THEN
   {signatur.i}
&ENDIF

{preview.i}
