{pirsavelog.p}
/** 
   ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009

   ���� �� ���饭� % 47427.
   ���ᮢ �.�., 10.09.2010
*/

{globals.i}           /* �������� ��।������ */
{tmprecid.def}        /* �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{intrface.get loan}   /* �����㬥��� ��� ࠡ��� � ⠡��窮� loan. */
{intrface.get i254}
{sh-defs.i}
{ulib.i}

/******************************************* ��।������ ��६����� � ��. */
DEFINE INPUT PARAM icAcct AS CHARACTER NO-UNDO.

DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPos      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCur      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFst      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dRate     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dBal      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumm     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iNStr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE daSince   AS DATE      NO-UNDO.
DEFINE VARIABLE daPred    AS DATE      NO-UNDO.
DEFINE BUFFER   loan-cred FOR loan-acct.

/******************************************* ��������� */
{getdate.i}
daPred = end-date - 1.

DO WHILE holiday(daPred):
   daPred = daPred - 1.
END.

{setdest.i}

IF (icAcct BEGINS "474")
THEN
   PUT UNFORMATTED 
      "                               ���������  �������" SKIP
      "�����騬 ᮮ�頥�, �� �� ����� �।�⭮�� �⤥�� ��ࠢ����� 5 �� " STRING(end-date, "99.99.9999") SKIP
      "�� ������ ����� ������� ᫥���騥 �ॡ������ �� ����祭�� ��業��� ��室�� �� ��㤠�, " SKIP
      "��㯯�஢���� � ����䥫� ����த��� ���, ��ࠦ����� �� �����ᮢ�� ���� 47427:" SKIP(1)
   .
ELSE
   PUT UNFORMATTED 
      "�����騬 ᮮ�頥�, �� �� ����� �।�⭮�� �⤥�� ��ࠢ����� 5 �� " STRING(end-date, "99.99.9999") SKIP
      "�� ������ ����� ������� ᫥���騥 �।���, ��㯯�஢���� � ����䥫� ����த��� ���:" SKIP(1)
   .

FOR EACH acct
   WHERE CAN-DO(icAcct, STRING(acct.bal-acct))
     AND ((acct.close-date   EQ ?)
       OR (acct.close-date   GE end-date))
   NO-LOCK,
   LAST loan-acct
      WHERE (loan-acct.acct     EQ acct.acct)
        AND (loan-acct.currency EQ acct.currency)
        AND (loan-acct.since    LE end-date)
        AND (NUM-ENTRIES(loan-acct.cont-code, " ") EQ 1)
      NO-LOCK,
   FIRST loan
      WHERE (loan.cont-code     EQ loan-acct.cont-code)
        AND (loan.contract      EQ loan-acct.contract)
        AND ((loan.Class-Code    EQ "l_agr_with_per") OR (loan.Class-Code    EQ "l_agr_with_diff"))
      NO-LOCK
   BREAK BY acct.currency BY loan.doc-ref:

   IF FIRST-OF(acct.currency)
   THEN DO:
      cCur  = IF (acct.currency = "840") THEN "USD" ELSE (
              IF (acct.currency = "978") THEN "EUR" ELSE "RUR").
      dSumm = 0.
      iNStr = 0.
      lFst  = TRUE.
   END.

   dRate   = LnRsrvRate(loan.contract, loan.cont-code, daPred).

   daSince = LnRsrvDate(loan.contract, loan.cont-code, end-date).
   cPos    = LnInBagOnDate (loan.contract, loan.cont-code, daPred).
   RUN acct-pos IN h_base(acct.acct, acct.currency, end-date, end-date, cTmp).
   dBal    = ABS(IF (acct.currency EQ "") THEN sh-in-bal ELSE sh-in-val).

   IF     (dBal  NE 0.0)
      AND (dRate EQ 1.5)
   THEN DO:

      IF lFst
      THEN DO:
         PUT UNFORMATTED
            "    ������ " cCur SKIP
            "    ������                             ����� ���                  ���⮪"  SKIP
            "����������������������������������������������������������������������������" SKIP
         .
         lFst = FALSE.
      END.

      dSumm = dSumm + dBal.
      iNStr = iNStr + 1.

      PUT UNFORMATTED
         iNStr FORMAT ">>9 "
         GetAcctClientName_UAL(acct.acct, NO) FORMAT "x(34)" " "
         acct.acct
/*         loan.cont-code FORMAT "x(12)" */
         dBal FORMAT " ->>>,>>>,>>9.99"
         (IF (cPos NE ?) THEN "" ELSE (" �� � ��� " + loan.cont-code))
         SKIP.
   END.

   IF LAST-OF(acct.currency)
      AND (dSumm NE 0)
   THEN
      PUT UNFORMATTED
         "����������������������������������������������������������������������������" SKIP
         "    �����:                             ������ " cCur "          "
         dSumm FORMAT " ->>>,>>>,>>9.99" SKIP(1)
      .

END.
/*
IF (icAcct BEGINS "474")
THEN
   PUT UNFORMATTED SKIP(1)
      "��砫쭨� �⤥�� ���㦨����� ��ᨨ                        ��ﭮ�� �.�."  SKIP(1)
      "��砫쭨� � 11                                               �᪠���� �.�." SKIP
   .
ELSE
*/
   PUT UNFORMATTED SKIP(1)
      "��砫쭨� �।�⭮�� �⤥��"  SKIP(1)
      "��砫쭨� � 5" SKIP
   .

{preview.i}
{intrface.del}
