/*
                ­ª®¢áª ï ¨­â¥£à¨à®¢ ­­ ï á¨áâ¥¬  ˆ‘ª¢¨â
    Copyright: (C) 1992-2003 ’ŽŽ " ­ª®¢áª¨¥ ¨­ä®à¬ æ¨®­­ë¥ á¨áâ¥¬ë"
     Filename: I-OVTERM.P
      Comment: ‚ë¯®«­ï¥â ‚ë§®¢ ¯à®æ¥¤ãàë à áç¥â  £à ä¨ª®¢
   Parameters: iRLoan
               iRCond
               iAmount
         Uses:
      Used BY:
      Created: 11.09.2006 NIK
     Modified:
*/

DEFINE INPUT PARAMETER iRLoan    AS recid    NO-UNDO.
DEFINE INPUT PARAMETER iRCond    AS recid    NO-UNDO.
DEFINE INPUT PARAMETER iAmount   AS decimal  NO-UNDO.

DEFINE VAR mFlagSet        AS LOGICAL   INIT ?   NO-UNDO.
DEFINE VAR mSurrLoanCond   AS CHAR               NO-UNDO.
DEFINE VAR mCredOffSet     AS CHAR               NO-UNDO.
DEFINE VAR mIntOffSet      AS CHAR               NO-UNDO.
DEFINE VAR mDelayOffset    AS CHAR NO-UNDO.  /* á¤¢¨£ ¤ âë ®ª®­ç ­¨ï ¯« â.¯¥à¨®¤  (®á­.¤®«£) */
DEFINE VAR mDelayOffsetInt AS CHAR NO-UNDO.  /* á¤¢¨£ ¤ âë ®ª®­ç ­¨ï ¯« â.¯¥à¨®¤  (¯à®æ¥­âë) */
DEFINE VAR mOffset         AS CHAR NO-UNDO INIT ",->,<-".
DEFINE VAR mCondCount      AS INT64  NO-UNDO.

{form.def}
{ghandle.def}
{basefunc.def}
{exchange.equ}
{intrface.get xclass}

&GLOB NO-BASE-PROC YES
/*============================================================================*/

MAIN:
DO ON ERROR UNDO MAIN, RETRY MAIN:
   {do-retry.i MAIN}

   FIND FIRST loan-cond WHERE RECID(loan-cond) EQ iRCond NO-LOCK NO-ERROR. {&ON-ERROR}

 /**
  * #1053
  * Ž¦¨¤ ¥¬, çâ® ¡ã¤ãâ ãç¨âë¢ âìáï
  * ­ áâà®©ª¨ á ª« áá  ¤®£®¢®à 
  **/
   FIND FIRST loan      WHERE RECID(loan)      EQ iRLoan NO-LOCK NO-ERROR. {&ON-ERROR}

   ASSIGN
      mSurrLoanCond     = loan-cond.contract + "," + loan-cond.cont-code + "," + STRING(loan-cond.since)
      mCredOffset       = GetXattrInit(loan.class-code,"cred-offset")
      mOffset           = mCredOffset
      mIntOffSet        = GetXattrInit(loan.class-code,"int-offset")
      mDelayOffset      = GetXattrInit(loan.class-code,"delay-offset")
      mDelayOffsetInt   = GetXattrInit(loan.class-code,"delay-offset-int")
   .

   RUN SetSysConf IN h_base("ŽŸ‡€’…‹œ‘’‚€ Ž ‚Ž‡‚€’“ ‘„‚ˆƒ",
                            STRING(LOOKUP(mCredOffset,mOffset))).

   RUN SetSysConf IN h_base("‹€’…†ˆ Ž Ž–…’€Œ ‘„‚ˆƒ",
                            STRING(LOOKUP(mIntOffset, mCredOffset))).

   RUN SetSysConf IN h_base("ŽŸ‡. Ž ‚Ž‡‚€’“ ‘„‚ˆƒ ŽŠŽ.‘ŽŠ€",
                            STRING(LOOKUP(mDelayOffset,mDelayOffset))).
   
   RUN SetSysConf IN h_base("‹€’. Ž Ž–. ‘„‚ˆƒ ŽŠŽ.‘ŽŠ€",
                            STRING(LOOKUP(mDelayOffsetInt,mDelayOffsetInt))).

   FIND FIRST loan WHERE RECID(loan) EQ iRLoan NO-LOCK NO-ERROR. {&ON-ERROR}

   FOR EACH loan-cond WHERE loan-cond.contract  EQ loan.contract
                        AND loan-cond.cont-code EQ loan.cont-code
   NO-LOCK:
      mCondCount = mCondCount + 1.
   END.
   
   RUN mm-to.p (INPUT iRLoan,
                INPUT iRCond,
                INPUT iAmount,
                INPUT {&MOD_ADD},
                INPUT YES,
                INPUT YES,
                INPUT YES,
                INPUT YES,
                INPUT Loan.Risk,
                INPUT mCondCount).

   mFlagSet = YES.
END.

RUN SetSysConf IN h_base("ŽŸ‡€’…‹œ‘’‚€ Ž ‚Ž‡‚€’“ ‘„‚ˆƒ","").
RUN SetSysConf IN h_base("‹€’…†ˆ Ž Ž–…’€Œ ‘„‚ˆƒ",     "").

{intrface.del}
{doreturn.i mFlagSet}
/******************************************************************************/
