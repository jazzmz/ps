{pirsavelog.p}

/*
                 ญชฎขแช ๏ จญโฅฃเจเฎข ญญ ๏ แจแโฅฌ  ‘ชขจโ
    Copyright: (C)  "pฎฌจญขฅแโเ แ็ฅโ"
     Filename: pir-pfkntrl.p
      Comment: ฅ็ โ์ เฅฅแโเ  คฎชใฌฅญโฎข ญ  ชฎญโเฎซฅ ”’
      Created: 09/11/2010 Borisov
*/
/******************************************************************************/
{globals.i}
{sh-defs.i}
{tmprecid.def}        /** แฏฎซ์งใฅฌ จญไฎเฌ ๆจ๎ จง กเฎใงฅเ  */
{repinfo.i}
{norm.i NEW}
{wordwrap.def}
{get-bankname.i}
{intrface.get xclass}
{intrface.get strng}
{leg207p.def}
{leg161p.fun}

/*============================================================================*/
DEFINE VARIABLE cPl     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPo     AS CHARACTER NO-UNDO.

DEFINE VARIABLE cNazn   AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE VARIABLE cKbeg   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKend   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKsrok  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKontr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iDelDat AS INTEGER   NO-UNDO.
DEFINE VARIABLE daZakr  AS DATE      NO-UNDO.
DEFINE VARIABLE cCurr   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dRur    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dCur    AS DECIMAL   NO-UNDO.
DEFINE BUFFER   oe      FOR op-entry.
DEFINE VARIABLE iNStr   AS INTEGER   INIT 8   NO-UNDO.
DEFINE VARIABLE iIStr   AS INTEGER   NO-UNDO.

{pir-pfmark.frm}
/* ----------------------------------------------------- */
FOR LAST acct-pos
   WHERE (acct-pos.acct-cat EQ "b")
   NO-LOCK
   BY acct-pos.since DESCENDING:

   daZakr = acct-pos.since.
   LEAVE.
END.

{setdest.i &cols=275 &custom = " IF YES THEN 0 ELSE "}

PUT UNFORMATTED
   "ฅฅแโเ ฏเฎฌ เชจเฎข ญญ๋ๅ ฎฏฅเ ๆจฉ ง  "
   IF (daBeg EQ daEnd)
   THEN (STRING(daEnd, "99.99.9999"))
   ELSE ("ฏฅเจฎค แ " + STRING(daBeg, "99.99.9999") + " ฏฎ " + STRING(daEnd, "99.99.9999"))
   SKIP
   "(ใแซฎขจฅ ข๋กฎเชจ: ฎโ " nBeg "เใก. คฎ " nEnd "เใก.)" SKIP(1)
.
iIStr = 1.

FOR EACH tmprecid
   NO-LOCK,
   FIRST op
   WHERE (RECID(op)   EQ tmprecid.id)
     AND (op.op-date  GE daBeg)
     AND (op.op-date  LE daEnd)
      NO-LOCK,
   FIRST oe OF op
   WHERE (oe.op-entry EQ 1)
      NO-LOCK
      BREAK BY oe.amt-rub DESCENDING:

   cPl = "".
   cPo = "".

   FOR EACH op-entry OF op
      NO-LOCK
      BY op-entry.op-entry:

      IF {assigned op-entry.acct-db}
      THEN RUN OneAcct(op-entry.acct-db, op.op-date, OUTPUT cPl).

      IF {assigned op-entry.acct-cr}
      THEN RUN OneAcct(op-entry.acct-cr, op.op-date, OUTPUT cPo).

      IF (cPl NE "") AND (cPo NE "")
      THEN LEAVE.
   END.

   cNazn[1] = op.details.
   {wordwrap.i &s=cNazn &n=5 &l=56}

   cKontr = GetXAttrValue("op", STRING(op.op), "PIRKontrol").

   IF (iIStr = 1)
   THEN
      PUT UNFORMATTED SKIP
         "ฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ" SKIP
         "ณ   ฎฌฅเ   ณ    โ    ณ          จฌฅญฎข ญจฅ         ณ    ’ฅซฅไฎญ    ณ         ณ        N เ/แ       ณ              ญช          ณ โ  เฅฃ. ณ โ  ฎโช- ณ       ‘ใฌฌ      ณ โ  ฏเฅค.ณ                                                        ณ" SKIP
         "ณ ฏเฎขฎคชจ  ณ ฏเฎขฎคชจ ณ         ฏซ โฅซ์้จช           ณ  ฏซ โฅซ์้จช   ณฏซ โฅซ์้จช  ณ     ฏซ โฅซ์้จช     ณ         ฏซ โฅซ์้จช        ณ ชซจฅญโ   ณเ๋โจ๏ เ/แ ณ     ฎฏฅเ ๆจจ    ณฎฏฅเ ๆจจ  ณ                                                        ณ" SKIP
         "รฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤด                    งญ ็ฅญจฅ ฏซ โฅฆ                    ณ" SKIP
         "ณฎค๋ 'ฎคฎงณฎค ข ซ๎โ๋ณ          จฌฅญฎข ญจฅ         ณ    ’ฅซฅไฎญ    ณ         ณ        N เ/แ       ณ              ญช          ณ โ  เฅฃ. ณ โ  ฎโช- ณ       ‘ใฌฌ      ณ โ  ฏเฅค.ณ                                                        ณ" SKIP
         "ณ ฎชใฌฅญโ' ณ ฎฏฅเ ๆจจ ณ          ฏฎซใ็ โฅซ๏          ณ   ฏฎซใ็ โฅซ๏  ณ ฏฎซใ็ โฅซ๏ ณ     ฏฎซใ็ โฅซ๏     ณ          ฏฎซใ็ โฅซ๏       ณ ชซจฅญโ   ณเ๋โจ๏ เ/แ ณ   ข ญ ๆ.ข ซ๎โฅ  ณฎฏฅเ ๆจจ  ณ                                                        ณ" SKIP
      .

   PUT UNFORMATTED SKIP
      "ฦอออออออออออุออออออออออุออออออออออออออออออออออออออออออุอออออออออออออออุออออออออออออุออออออออออออออออออออุอออออออออออออออออออออออออออุออออออออออุออออออออออุอออออออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออต" SKIP
      "ณ" op.doc-num                               FORMAT "x(11)"
      "ณ" op.op-date                               FORMAT "99.99.9999"
      "ณ" SUBSTRING(ENTRY(1, cPl, CHR(1)),  1, 30) FORMAT "x(30)"
      "ณ" ENTRY(2, cPl, CHR(1))                    FORMAT "x(15)"
      "ณ" ENTRY(3, cPl, CHR(1))                    FORMAT "x(12)"
      "ณ" ENTRY(4, cPl, CHR(1))                    FORMAT "x(20)"
      "ณ" SUBSTRING(ENTRY(5, cPl, CHR(1)),  1, 27) FORMAT "x(27)"
      "ณ" ENTRY(6, cPl, CHR(1))                    FORMAT "x(10)"
      "ณ" ENTRY(7, cPl, CHR(1))                    FORMAT "x(10)"
      "ณ" STRING(IF (oe.amt-cur NE 0.0) THEN oe.amt-cur ELSE oe.amt-rub, ">>,>>>,>>>,>>9.99")
      "ณ" ENTRY(8, cPl, CHR(1))                    FORMAT "x(10)"
      "ณ" cNazn[1]                                 FORMAT "x(56)"
      "ณ" SKIP
      "ณ           ณ          "
      "ณ" SUBSTRING(ENTRY(1, cPl, CHR(1)), 31, 30) FORMAT "x(30)"
      "ณ               ณ            ณ                    "
      "ณ" SUBSTRING(ENTRY(5, cPl, CHR(1)), 28, 27) FORMAT "x(27)"
      "ณ          ณ          ณ                 ณ          "
      "ณ" cNazn[2]                                 FORMAT "x(56)"
      "ณ" SKIP
      "รฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤด"
          cNazn[3]                                 FORMAT "x(56)"
      "ณ" SKIP
      "ณ" GetXAttrValue("op", STRING(op.op), "ฎคฎงฎชใฌฅญโ") FORMAT "x(11)"
      "ณ   " oe.currency                           FORMAT "x(3)"    "    "
      "ณ" SUBSTRING(ENTRY(1, cPo, CHR(1)),  1, 30) FORMAT "x(30)"
      "ณ" ENTRY(2, cPo, CHR(1))                    FORMAT "x(15)"
      "ณ" ENTRY(3, cPo, CHR(1))                    FORMAT "x(12)"
      "ณ" ENTRY(4, cPo, CHR(1))                    FORMAT "x(20)"
      "ณ" SUBSTRING(ENTRY(5, cPo, CHR(1)),  1, 27) FORMAT "x(27)"
      "ณ" ENTRY(6, cPo, CHR(1))                    FORMAT "x(10)"
      "ณ" ENTRY(7, cPo, CHR(1))                    FORMAT "x(10)"
      "ณ" STRING(oe.amt-rub, ">>,>>>,>>>,>>9.99")
      "ณ" ENTRY(8, cPo, CHR(1))                    FORMAT "x(10)"
      "ณ" cNazn[4]                                 FORMAT "x(56)"
      "ณ" SKIP
      "ณ           ณ          "
      "ณ" SUBSTRING(ENTRY(1, cPo, CHR(1)), 31, 30) FORMAT "x(30)"
      "ณ               ณ            ณ                    "
      "ณ" SUBSTRING(ENTRY(5, cPo, CHR(1)), 28, 27) FORMAT "x(27)"
      "ณ          ณ          ณ                 ณ          "
      "ณ" cNazn[5]                                 FORMAT "x(56)"
      "ณ" SKIP
   .
   IF (iIStr EQ iNSTR)
   THEN DO:
      iIStr = 1.

      IF NOT LAST(oe.amt-rub)
      THEN 
         PUT UNFORMATTED SKIP
            "ิอออออออออออฯออออออออออฯออออออออออออออออออออออออออออออฯอออออออออออออออฯออออออออออออฯออออออออออออออออออออฯอออออออออออออออออออออออออออฯออออออออออฯออออออออออฯอออออออออออออออออฯออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ" SKIP
            CHR(12).
   END.
   ELSE iIStr = iIStr + 1.
END.

PUT UNFORMATTED SKIP
   "ิอออออออออออฯออออออออออฯออออออออออออออออออออออออออออออฯอออออออออออออออฯออออออออออออฯออออออออออออออออออออฯอออออออออออออออออออออออออออฯออออออออออฯออออออออออฯอออออออออออออออออฯออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ" SKIP
.

{signatur.i &user-only = yes}
{preview.i}

/*************************************************/
PROCEDURE OneAcct:
DEFINE INPUT  PARAMETER inAcct AS CHARACTER.
DEFINE INPUT  PARAMETER inDate AS DATE.
DEFINE OUTPUT PARAMETER ioStr  AS CHARACTER.
/* ”ฎเฌ โ ข๋ๅฎคญฎฉ แโเฎชจ:
  1 - ฌ๏ ชซจฅญโ 
  2 - ’ฅซฅไฎญ
  3 - 
  4 - ‘็ฅโ
  5 -  ญช
  6 -  โ  เฅฃจแโเ ๆจจ ชซจฅญโ 
  7 -  โ  ฎโชเ๋โจ๏ แ็ฅโ 
  8 -  โ  ฏเฅค.ฎฏฅเ ๆจจ ฏฎ แ็ฅโใ
*/

DEFINE VARIABLE daLast   AS DATE       NO-UNDO.
DEFINE VARIABLE cKl      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTlf     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cINN     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAcct    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBank    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cdKlReg  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cdAcct   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cdPredOp AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lLastMv  AS LOGICAL    NO-UNDO.
DEFINE BUFFER   bop      FOR op.
DEFINE BUFFER   boe      FOR op-entry.
DEFINE BUFFER   bInst    FOR cust-role.

   CASE inAcct:
      WHEN ? THEN
         ASSIGN
            cName    = ""
            cTlf     = ""
            cINN     = ""
            cAcct    = ""
            cBank    = ""
            cdKlReg  = ""
            cdAcct   = ""
            cdPredOp = ""
            NO-ERROR.
      WHEN "30102810900000000491" THEN DO:
         IF {assigned op.name-ben}
         THEN DO:

            ASSIGN
               cName    = op.name-ben
               cTlf     = ""
               cINN     = op.inn
               cAcct    = op.ben-acct
               cdKlReg  = ""
               cdAcct   = ""
               cdPredOp = ""
               NO-ERROR.

            FIND FIRST op-bank
               WHERE (op-bank.op             EQ op.op)
                 AND (op-bank.op-bank-type   EQ "")
                 AND (op-bank.bank-code-type EQ "”-9")
               NO-LOCK NO-ERROR.

            IF AVAILABLE(op-bank)
            THEN DO:
               FIND FIRST banks-code OF op-bank
                  NO-ERROR.
               FIND FIRST banks OF banks-code
                  NO-ERROR.
               cBank = banks.name.
            END.
            ELSE
               cBank = "".
         END.
         ELSE
            ASSIGN
               cName    = cBankName
               cTlf     = "(495)742-0505"
               cINN     = "7708031739"
               cAcct    = inAcct
               cBank    = cBankName
               cdKlReg  = ""
               cdAcct   = ""
               cdPredOp = ""
               NO-ERROR.
      END.
      OTHERWISE DO:
         FIND FIRST acct
            WHERE (acct.acct EQ inAcct)
            NO-LOCK NO-ERROR.

         IF (AVAIL acct)
         THEN DO:

            lLastMv = YES.

            CASE acct.cust-cat:
               WHEN "" THEN DO:
                  FIND FIRST cust-corp
                     WHERE (cust-corp.cust-id EQ acct.cust-id)
                     NO-LOCK NO-ERROR.
                  IF AVAIL cust-corp
                  THEN
                     ASSIGN
                        cName   = cust-corp.name-short
                        cTlf    = GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "tel")
                        cINN    = cust-corp.inn
                        cdKlReg = GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "RegDate")
                        cAcct   = inAcct
                        cBank   = cBankName
                        NO-ERROR.
               END.
               WHEN "—" THEN DO:
                  FIND FIRST person
                     WHERE (person.person-id EQ acct.cust-id)
                     NO-LOCK NO-ERROR.
                  IF AVAIL person
                  THEN
                     ASSIGN
                        cName   = person.name-last + " " + person.first-names
                        cTlf    = GetXAttrValue("person", STRING(person.person-id), "tel")
                        cINN    = person.inn
                        cdKlReg = GetXAttrValue("person", STRING(person.person-id), "birthday")
                        cAcct   = inAcct
                        cBank   = cBankName
                        NO-ERROR.
               END.
               WHEN "" THEN DO:
                  FIND FIRST cust-role
                     WHERE (cust-role.file-name EQ "op")
                       AND (cust-role.surrogate EQ STRING(op.op))
                       AND CAN-DO("Benef-Cust,Order-Cust", cust-role.class-code)
                     NO-LOCK NO-ERROR.

                  IF AVAIL cust-role
                  THEN DO:
                     ASSIGN
                        lLastMv  = NO
                        cName    = cust-role.cust-name
                        cTlf     = ""
                        cINN     = ""
                        cdKlReg  = ""
                        cAcct    = ""
                        cdAcct   = ""
                        cdPredOp = ""
                        NO-ERROR.

                     FIND FIRST bInst
                        WHERE (bInst.file-name EQ "op")
                          AND (bInst.surrogate EQ STRING(op.op))
                          AND CAN-DO("Benef-Inst,Order-Inst", bInst.class-code)
                        NO-LOCK NO-ERROR.

                     cBank = IF (AVAIL bInst) THEN bInst.cust-name ELSE "".
                  END.
                  ELSE DO:
                     FIND FIRST banks
                        WHERE (banks.bank-id EQ acct.cust-id)
                        NO-LOCK NO-ERROR.

                     IF AVAIL banks
                     THEN
                        ASSIGN
                           cName   = banks.name
                           cTlf    = GetXAttrValue("banks", STRING(banks.bank-id), "tel")
                           cINN    = (IF (banks.inn NE ?) THEN banks.inn ELSE "")
                           cdKlReg = GetXAttrValue("banks", STRING(banks.bank-id), "RegDate")
                           cAcct   = ""
                           cBank   = ""
                           NO-ERROR.
                  END.
               END.
               WHEN "" THEN
                  ASSIGN
                     cName   = acct.Details
                     cTlf    = ""
                     cINN    = ""
                     cdKlReg = ""
                     cAcct   = inAcct
                     cBank   = cBankName
                     NO-ERROR.
            END CASE.

            IF lLastMv
            THEN DO:
               cdAcct   = STRING(acct.open-date, "99.99.9999").

               RUN acct-pos IN h_base(acct.acct, acct.currency, op.op-date - 1, op.op-date - 1, cdPredOp).

               IF (acct.currency EQ "")
               THEN cdPredOp = IF (lastmove NE ?) THEN STRING(lastmove, "99.99.9999") ELSE "".
               ELSE cdPredOp = IF (lastcurr NE ?) THEN STRING(lastcurr, "99.99.9999") ELSE "".
            END.

/*
            IF (acct.currency EQ "")
            THEN DO:
               FOR EACH acct-pos OF acct
                  WHERE (acct-pos.since  LT inDate)
                  NO-LOCK
                  BY acct-pos.since DESCENDING:

                  cdPredOp = STRING(acct-pos.since, "99.99.9999").
                  LEAVE.
               END.

               IF (inDate GT daZakr)
               THEN
                  FOR EACH boe
                     WHERE (boe.op-date  GT daZakr)
                       AND (boe.op-date  LT inDate)
                       AND ((boe.acct-cr EQ acct.acct)
                         OR (boe.acct-db EQ acct.acct))
                     NO-LOCK
                     BY boe.op-date DESCENDING:

                     cdPredOp = IF (boe.op-date GT DATE(cdPredOp))
                                THEN STRING(boe.op-date, "99.99.9999")
                                ELSE cdPredOp.
                     LEAVE.
                  END.
            END.
            ELSE DO:
               FOR EACH acct-cur OF acct
                  WHERE (acct-cur.since  LT inDate)
                  NO-LOCK
                  BY acct-cur.since DESCENDING:

                  cdPredOp = STRING(acct-cur.since, "99.99.9999").
                  LEAVE.
               END.

               IF (inDate GT daZakr)
               THEN
                  FOR EACH boe
                     WHERE (boe.op-date  GT daZakr)
                       AND (boe.op-date  LT inDate)
                       AND ((boe.acct-cr EQ acct.acct)
                         OR (boe.acct-db EQ acct.acct))
                     NO-LOCK,
                  EACH bop OF boe
                     WHERE NOT (bop.doc-num BEGINS "")
                     NO-LOCK
                     BY boe.op-date DESCENDING:

                     cdPredOp = IF (boe.op-date GT DATE(cdPredOp))
                                THEN STRING(boe.op-date, "99.99.9999")
                                ELSE cdPredOp.
                     LEAVE.
                  END.
            END.
*/
         END.
         ELSE
            ASSIGN
               cName    = ""
               cTlf     = ""
               cINN     = ""
               cdKlReg  = ""
               cdAcct   = ""
               cdPredOp = ""
               cAcct = inAcct
               cBank = cBankName
               NO-ERROR.
      END.
   END CASE.

   ioStr = cName   + CHR(1)
         + cTlf    + CHR(1)
         + cINN    + CHR(1)
         + cAcct   + CHR(1)
         + cBank   + CHR(1)
         + cdKlReg + CHR(1)
         + cdAcct  + CHR(1)
         + cdPredOp.

END PROCEDURE.
