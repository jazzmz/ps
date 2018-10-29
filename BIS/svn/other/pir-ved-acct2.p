{pirsavelog.p}

{globals.i}             /* ซฎก ซ์ญ๋ฅ ฏฅเฅฌฅญญ๋ฅ แฅแแจจ. */

DEFINE VARIABLE mCustName AS CHARACTER /*  จฌฅญฎข ญจฅ ชซจฅญโ  */
   FORMAT "x(40)"
   EXTENT 10
   NO-UNDO.

DEFINE VARIABLE mBalAcctMask  AS CHARACTER NO-UNDO. /**/
DEFINE VARIABLE mCurrencyMask  AS CHARACTER NO-UNDO. /**/

DEFINE TEMP-TABLE tmprwd
   FIELD fAcct     AS CHAR    /* ซ๏ แฎเโจเฎขชจ  */
   FIELD fAcct2     AS CHAR    /* ซ๏ แฎเโจเฎขชจ  */
  INDEX idxL fAcct.

{getdate.i}
{wordwrap.def}
{sh-defs.i}

mBalAcctMask = "401*,402*,403*,404*,405*,406*,407*,40802".

RUN getstr2.p("…’… €‘“ ‘—…’€",mBalAcctMask,OUTPUT mBalAcctMask).
RUN getstr2.p("…’… €’“",mCurrencyMask,OUTPUT mCurrencyMask).



{justamin}
                        /* ”ฎเฌจเใฅฌ แ็ฅโ  คซ๏ ฎโ็ฅโ . */
FOR EACH acct WHERE CAN-DO (mBalAcctMask, STRING(acct.bal-acct)) AND CAN-DO (mCurrencyMask, STRING(acct.currency)) NO-LOCK:
   CREATE tmprwd.
   ASSIGN
      tmprwd.fAcct      = SUBSTRING(acct.acct,1,8) + "00000000" + SUBSTRING(acct.acct,17,4)
      tmprwd.fAcct2     = acct.acct
   .
END.

{setdest.i &nodef="/*" &cols=90}

      PUT UNFORMATTED
         "ฅคฎฌฎแโ์ เ แ็ฅโญ๋ๅ แ็ฅโฎข ญ  " + STRING(end-date,"99/99/9999") SKIP.

   PUT UNFORMATTED "ีอออออออออออออออออออออออออัออออออออออออออออออออออออออออออออออออออออัออออออออธ" SKIP
                   "ณ      แ็ฅโญ๋ฉ แ็ฅโ      ณ         จฌฅญฎข ญจฅ ชซจฅญโ             ณ โชเ๋โ ณ" SKIP
                   "ฦอออออออออออออออออออออออออุออออออออออออออออออออออออออออออออออออออออุออออออออต" SKIP.
FOR EACH tmprwd,
   FIRST acct WHERE acct.acct = tmprwd.fAcct2
                AND (acct.close-date GT end-date
                OR   acct.close-date EQ ?)
      NO-LOCK
   BREAK BY tmprwd.fAcct:

   {getcust.i &name="mCustName" &OFFinn = "/*"}
   mCustName[1] = mCustName[1] + " " + mCustName[2].
   {wordwrap.i &s=mCustName &n=10 &l=40}


   PUT UNFORMATTED "ณ" +
                   STRING(acct.acct, "x(25)") +
                   "ณ" +
                   STRING(mCustName[1], "x(40)") +
                   "ณ" +
                   STRING(acct.open-date, "99/99/99") +
                   "ณ" SKIP.


END.

   PUT UNFORMATTED "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤู" SKIP.

{preview.i}
