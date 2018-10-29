{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: chkstore.p
      Comment: Автономный склад. Отчет для сверки складского учета и бухучета
   Parameters:
         Uses:
      Used by:
      Created: 27/06/2003 kraw (0015092)
     Modified:
*/
{globals.i}
{a-defs.i}

{vprgrs.i}

DEFINE VARIABLE c_prog     AS CHARACTER         FORMAT "x(1)"         NO-UNDO.
DEFINE VARIABLE quont      AS INTEGER INITIAL 0 FORMAT ">>>9"         NO-UNDO.
DEFINE VARIABLE mA-qty     AS INTEGER                                 NO-UNDO.
DEFINE VARIABLE mBal       AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 NO-UNDO.
DEFINE VARIABLE mQuanFact  AS INTEGER                                 NO-UNDO.
DEFINE VARIABLE mDiff      AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 NO-UNDO.
DEFINE VARIABLE mBalDiff   AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 NO-UNDO.
DEFINE VARIABLE mBalSkl    AS DECIMAL FORMAT ">,>>>,>>9.99" INITIAL 0 NO-UNDO.
DEFINE VARIABLE mSumTmp    AS DECIMAL                                 NO-UNDO.
DEFINE VARIABLE mCQuan     AS DECIMAL           FORMAT ">,>>>,>>9.99" NO-UNDO.

DEFINE VARIABLE vAcct LIKE acct.acct     NO-UNDO.
DEFINE VARIABLE vCurr LIKE acct.currency NO-UNDO.


DEFINE STREAM logstr.

DEFINE FRAME fmess
      "Формирование отчета для сверки складского учета и бухучета  "
      c_prog
   WITH CENTERED ROW 9 OVERLAY NO-LABELS.
PAUSE 0.
{getdate.i}

{setdest.i &cols = 160 &stream="stream logstr"}
PUT STREAM logstr UNFORMATTED "Отчет для сверки складского учета и бухучета" SKIP(2).
PUT STREAM logstr UNFORMATTED end-date SKIP(2).
PUT STREAM logstr UNFORMATTED  SKIP(2).
PUT STREAM logstr UNFORMATTED  
"N пп Инв. номер   Наименование                        Остаток     Остаток       Отклонение    Остаток     Остаток      Отклонение"
SKIP
"                                                      на складе   по бухучету                 на складе   на балансе   "
SKIP.
PUT STREAM logstr UNFORMATTED  
"---- ------------ ----------------------------------- ------------ ------------ ------------ ------------ ------------ ------------"
SKIP.

FOR EACH loan WHERE loan.contract EQ "СКЛАД" AND loan.close-date EQ ? OR loan.close-date GE end-date 
NO-LOCK:
   RUN vprgrs(OUTPUT c_prog).        /* "крутилка", чтобы показать, что процесс идет */
   COLOR DISPLAY bright-yellow c_prog WITH FRAME fmess.
   DISPLAY c_prog WITH FRAME fmess.
   PAUSE 0.                          /* кончилась "крутилка" */

   FIND FIRST loan-acct OF loan WHERE loan-acct.contract EQ "СКЛАД"
                                  AND loan-acct.acct-type EQ "СКЛАД-авто" 
   NO-LOCK 
   NO-ERROR.

   IF AVAILABLE(loan-acct) THEN
   DO:

      quont = quont + 1.
      FIND FIRST acct OF loan-acct NO-LOCK NO-ERROR.

      ASSIGN
         vAcct      = acct.acct
         vCurr      = acct.currency
         mQuanFact  = 0
      .

      FOR EACH kau WHERE kau.kau  BEGINS loan.contract + "," 
                                       + loan.cont-code + ","
                     AND kau.acct     EQ vAcct
                     AND kau.currency EQ vCurr 
      NO-LOCK:
         RUN GetKauPos IN h_umc (INPUT  kau.kau,
                                 INPUT  "авто",
                                 INPUT  end-date,
                                 OUTPUT mSumTmp,
                                 OUTPUT mCQuan
                                ).

         mQuanFact  = mQuanFact + mCQuan.
	 mBalSkl    = mSumTmp.
      END.     
      FIND FIRST loan-acct OF loan WHERE loan-acct.contract EQ "СКЛАД"
                                     AND loan-acct.acct-type EQ "СКЛАД-учет" 
      NO-LOCK 
      NO-ERROR.

      mA-qty = 0.
      IF AVAILABLE(loan-acct) THEN
      DO:
         FIND FIRST acct OF loan-acct NO-LOCK NO-ERROR.

         ASSIGN
            vAcct  = acct.acct
            vCurr  = acct.currency
         .

         FOR EACH kau WHERE kau.kau  BEGINS loan.contract + "," 
                                          + loan.cont-code + ","
                          AND kau.acct     EQ vAcct
                          AND kau.currency EQ vCurr:

            RUN GetKauPos IN h_umc (INPUT  kau.kau,
                                    INPUT  "учет",
                                    INPUT  end-date,
                                    OUTPUT mSumTmp,
                                    OUTPUT mCQuan
                                   ).
            mA-qty = mA-qty + mCQuan.
	    mBal = mSumTmp.
         END.
      END.

      mDiff = mQuanFact - mA-qty.
      mBalDiff = mBal - mBalSkl.
      FIND FIRST asset OF loan NO-LOCK NO-ERROR.
      PUT STREAM logstr quont " ".
      PUT STREAM logstr loan.cont-code FORMAT "x(12)" " ".
      PUT STREAM logstr asset.name FORMAT "x(35)" " ".
      PUT STREAM logstr mQuanFact " ".
      PUT STREAM logstr mA-qty  " ".
      IF mDiff NE 0 THEN
         PUT STREAM logstr mDiff FORMAT "->>>>>>>9.99" "     ".
	 ELSE PUT STREAM logstr "                 ".
      PUT STREAM logstr mBalSkl  " ".
      PUT STREAM logstr mBal  " ".
      IF mBalDiff NE 0 THEN
         PUT STREAM logstr mBalDiff FORMAT "->>>>>>>9.99" " ".
	 ELSE PUT STREAM logstr " ".
      PUT STREAM logstr SKIP.
      .
   END.
END.
HIDE FRAME fmess NO-PAUSE.
PUT STREAM logstr UNFORMATTED  
"---- ------------ ----------------------------------- ------------ ------------ ------------ ------------ ------------ ------------"
SKIP.
{preview.i &stream="stream logstr"}
