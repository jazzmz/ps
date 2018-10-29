{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: izvcrd2.p
      Comment: Извещение о постановке счета на картотеку №2
   Parameters:
         Uses: izvcrd2.frm izvcrd2.prg bank-id.i wordwrap
      Used by:
      Created: 08.11.2000
     Modified:
*/
Form "~n@(#) izvcrd2.p 1.0 Kostik Извещение о постановке счета на картотеку №2"
with frame sccs-id width 250.


{globals.i}
{wordwrap.def}
{pick-val.i}
{bank-id.i}

/**********/
Define Input Param rid As RecID No-Undo.

Define Variable Detail           As Character Extent   5 No-Undo.

Define VAR PlAcct           As Character            No-Undo.
Define VAR PlMFO            As Character            No-Undo.
Define VAR PlRKC            As Character Extent   2 No-Undo.

Define VAR PoAcct           As Character            No-Undo.
Define VAR PoMFO            As Character            No-Undo.
Define VAR PoName           As Character Extent   5 No-Undo.
Define VAR PoRKC            As Character Extent   2 No-Undo.

Define VAR Rub              As Character            No-Undo.
Define VAR theDate          As Character            No-Undo.
DEFINE VAR in-numdate       AS CHARACTER            NO-UNDO.
DEFINE VAR tmp-sett         AS CHARACTER            NO-UNDO.

DEF    VAR reason           AS CHARACTER EXTENT 2   NO-UNDO.

Def Var NameCli As Char  extent 2 No-undo.
DEFINE VAR sel-print AS LOGICAL NO-UNDO.

DEFINE BUFFER bop         FOR op.
DEFINE BUFFER bop-entry   FOR op-entry.
DEFINE BUFFER bop-bank    FOR op-bank.

DEFINE BUFFER dacct FOR acct.
DEFINE BUFFER cacct FOR acct.
/**********/
/* RUN morsw.p (rid). */
RUN pirmem-uni_m.p (rid).

if not PackagePrint then do:
  MESSAGE "Печатать извещение о постановке на картотеку!"
  VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE sel-print.
  IF NOT sel-print THEN RETURN.
end.
else do:
  if GetSysConf("print," + program-name(1)) = ? then do:
    message "Печатать извещение о постановке на картотеку!" skip
            "Да - печатать все, Нет - не печатать"
    VIEW-AS ALERT-BOX QUESTION BUTTONS Yes-No UPDATE sel-print.
    IF NOT sel-print THEN do:
      run setsysconf in h_base ("print," + program-name(1), "no").
      RETURN.
    end.
    else do:
      run setsysconf in h_base ("print," + program-name(1), "yes").
    end.
  end.
  else if GetSysConf("print," + program-name(1)) = "no" then return.
end.
/**********/
{pir_izvcrd2.prg}
{pir_izvcrd2.frm}

FIND op WHERE RECID(op) EQ rid NO-LOCK NO-ERROR.
FIND FIRST op-entry OF op      NO-LOCK NO-ERROR.
IF NOT AVAIL op-entry THEN RETURN.

CASE getTargetK(BUFFER op-entry:HANDLE):
   WHEN "k1" THEN DO:
       reason[1] = "не оплачено из-за приостановления операций".
       reason[2] = "по сч. N".
       
   END.
   WHEN "k2" THEN DO:
       reason[1] = "не оплачено из-за отсут. средств".
       reason[2] = "по сч. N".
   END.
END CASE.

RUN Get-DOC-IN(BUFFER op,
               BUFFER bop,
               BUFFER bop-entry).
IF AVAIL bop THEN DO:
   FIND bop-bank OF bop NO-LOCK NO-ERROR.
   IF NOT AVAIL bop-entry THEN DO:
      FIND signs WHERE signs.file-name EQ "op"
                   AND signs.code      EQ "acctbal"
                   AND signs.surrogate EQ STRING(bop.op)
                                       NO-LOCK NO-ERROR.
      FIND dacct WHERE dacct.acct        EQ     TRIM(signs.xattr-value)
                   AND dacct.currency    EQ     op-entry.currency
                                                 NO-LOCK NO-ERROR.

      FIND signs WHERE signs.file-name EQ "op"
                   AND signs.code      EQ "acctcorr"
                   AND signs.surrogate EQ STRING(bop.op)
                                       NO-LOCK NO-ERROR.
      FIND cacct WHERE cacct.acct        EQ     TRIM(signs.xattr-value)
                   AND cacct.currency    EQ     op-entry.currency
                                                NO-LOCK NO-ERROR.
   END.
   ELSE DO:
      FIND cacct WHERE cacct.acct        EQ     bop-entry.acct-cr
                   AND cacct.currency    EQ     op-entry.currency
                                                 NO-LOCK NO-ERROR.
      FIND dacct WHERE dacct.acct        EQ     bop-entry.acct-db
                   AND dacct.currency    EQ     op-entry.currency
                                                 NO-LOCK NO-ERROR.
   END.

   ASSIGN
      PlAcct = IF AVAIL dacct THEN dacct.acct
                              ELSE ""
      PlMFO  = bank-mfo-9
   .
   {getbank.i banks bank-mfo-9}
   PlRKC[1] = BankNameCity(BUFFER banks).


   tmp-sett  = get_set_my("НазнСчМБР").
   IF AVAIL cacct AND CAN-DO(tmp-sett,cacct.contract) THEN DO:
      IF AVAIL bop-bank THEN DO:
         FIND banks-code WHERE banks-code.bank-code-type EQ bop-bank.bank-code-type
                           AND banks-code.bank-code      EQ bop-bank.bank-code
                                                                   NO-LOCK NO-ERROR.
         IF AVAIL banks-code THEN DO:
            FIND banks OF banks-code NO-LOCK NO-ERROR.
            PoRKC[1] = BankNameCity(BUFFER banks).
            PoMFO    = banks-code.bank-code.
         END.
      END.
      ASSIGN
         PoAcct    = bop.ben-acct
         PoName[1] = bop.name-ben
      .
   END.
   ELSE IF AVAIL cacct THEN DO:
      {getcust.i &name = PoName
                 &pref = "c"
      }
      ASSIGN
         PoRKC[1]  = PlRKC[1]
         PoMFO     = PlMFO
         PoName[1] = PoName[1] + " " + PoName[2]
         PoName[2] = ""
         PoAcct    = cacct.acct
      .
   END.

   ASSIGN
      in-numdate  = bop.doc-num + "," + STRING(bop.doc-date,"99.99.9999")
   .
END.
ELSE DO:
   ASSIGN
      PlMFO  = bank-mfo-9
   .
   {getbank.i banks bank-mfo-9}
   PlRKC[1] = BankNameCity(BUFFER banks).

   RUN Get-Xattr-Val(BUFFER op).
   FIND bop-bank OF op NO-LOCK NO-ERROR.
   IF AVAIL bop-bank THEN DO:
      FIND banks-code WHERE banks-code.bank-code-type EQ bop-bank.bank-code-type
                        AND banks-code.bank-code      EQ bop-bank.bank-code
                                                                NO-LOCK NO-ERROR.
      IF AVAIL banks-code THEN DO:
         FIND banks OF banks-code NO-LOCK NO-ERROR.
         PoRKC[1] = BankNameCity(BUFFER banks).
         PoMFO    = banks-code.bank-code.
      END.
      ASSIGN
         PoAcct    = op.ben-acct
         PoName[1] = op.name-ben
      .
   END.
END.
   IF TRUNC(op-entry.amt-rub, 0) = op-entry.amt-rub THEN
      ASSIGN
         Rub       = STRING(STRING((IF op-entry.currency NE "" THEN op-entry.amt-cur
                                                               ELSE op-entry.amt-rub)
                                   * 100, "-zzzzzzzzzz999"), "x(12)=")
      .
   ELSE
      ASSIGN
         Rub       = STRING(STRING((IF op-entry.currency NE "" THEN op-entry.amt-cur
                                                               ELSE op-entry.amt-rub)
                                   * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      .
   TheDate    = STRING(op.doc-date,"99.99.9999").
{wordwrap.i &s=PlRKC &n=2 &l=48}
{wordwrap.i &s=PoRKC &n=2 &l=48}
{wordwrap.i &s=PoName &n=5 &l=48}
{strtout3.i &cols=80 &option=Paged}
DISPLAY
   op.doc-num
   Detail
   PlAcct
   PlMFO
   PlRKC
   PoAcct
   PoMFO
   PoName
   PoRKC
   TRIM(Rub) @ Rub
   theDate
   in-numdate
   reason[1]
   reason[2]
WITH FRAME out-doc.
DOWN WITH FRAME out-doc.
{endout3.i  &nofooter=yes}

