{pirsavelog.p}

/*
   ���ଠ�� � ���� १�ࢠ
   ���ᮢ �.�. 05.08.2009
*/

{globals.i}             /* �������塞 �������� ����ன��*/
{ulib.i}                /* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get comm}     /* �����㬥��� ��� ࠡ��� � ������ﬨ */
{intrface.get xclass}   /* �㭪樨 ࠡ��� � ����奬�� */
{intrface.get db2l}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** ����������� **/
FUNCTION LnPrincipal2 RETURNS DECIMAL
   (INPUT iContract AS CHAR, INPUT iContCode AS CHAR,
    INPUT iDate     AS DATE, INPUT iCurrency AS CHAR, INPUT CC AS CHAR)
   FORWARD.

FUNCTION Get_QualityGar2 RETURNS CHAR
   (INPUT iFileName AS CHAR, INPUT iSurrogate AS CHAR, INPUT iSince AS DATE)
   FORWARD.

/* ================================================================================== */
DEF VAR cAcctRsrv    AS CHARACTER NO-UNDO. /* ��� १�ࢠ */
DEF VAR cAcctPrRsrv  AS CHARACTER NO-UNDO. /* ��� ��.१�ࢠ */
DEF VAR nCredVal     AS DECIMAL   NO-UNDO. /* �㬬� �।�� � ����� */
DEF VAR nCredRur     AS DECIMAL   NO-UNDO. /* �㬬� �।�� � �㡫�� */
DEF VAR nPrCredVal   AS DECIMAL   NO-UNDO. /* �㬬� ��.�।�� � ����� */
DEF VAR nPrCredRur   AS DECIMAL   NO-UNDO. /* �㬬� ��.�।�� � �㡫�� */
DEF VAR nRsrv        AS DECIMAL   NO-UNDO. /* �㬬� १�ࢠ */
DEF VAR nPrRsrv      AS DECIMAL   NO-UNDO. /* �㬬� ��.१�ࢠ */
DEF VAR nRsrvClc     AS DECIMAL   NO-UNDO. /* ������� १�� (��� ���ᯥ祭��) */
DEF VAR nPrRsrvClc   AS DECIMAL   NO-UNDO. /* ������� ��.१�� (��� ���ᯥ祭��) */
DEF VAR nRsrvTst     AS DECIMAL   NO-UNDO. /* ������ १�ࢠ � ���ᯥ祭��� */
DEF VAR nPrRsrvTst   AS DECIMAL   NO-UNDO. /* ������ ��.१�ࢠ � ���ᯥ祭��� */
DEF VAR nObesp       AS DECIMAL   NO-UNDO. /* ���ᯥ祭�� */
DEF VAR nPrObesp     AS DECIMAL   NO-UNDO. /* ��.���ᯥ祭�� */
DEF VAR nObespClc    AS DECIMAL   NO-UNDO. /* ������ ���ᯥ祭�� �� �訡��*/

DEF VAR iVR          AS INTEGER FORMAT "9" INITIAL 1 NO-UNDO. /* ��ਠ�� ���� */

DEF VAR cClient      AS CHARACTER NO-UNDO. /* ������������ ����騪� */
DEF VAR cDogCurr     AS CHARACTER NO-UNDO. /* ����� ������� */
DEF VAR cDogSogl     AS CHARACTER NO-UNDO. /* �� ��⠑��� */
DEF VAR loaninf      AS CHARACTER NO-UNDO. /* */
DEF VAR loannum      AS CHARACTER NO-UNDO. /* */
DEF VAR iGrRisk      AS INTEGER   NO-UNDO. /* ��㯯� �᪠ */
DEF VAR nPrRisk      AS DECIMAL   NO-UNDO. /* ��業� १�ࢨ஢���� */
DEF VAR cObCat       AS CHARACTER NO-UNDO. /* ��⥣��� ���ᯥ祭�� */
DEF VAR iObCat       AS DECIMAL   NO-UNDO. /* ����-� ���ᯥ祭�� */
DEF VAR vSurr        AS CHARACTER NO-UNDO. /* ���ண�� ��易⥫��⢠ */

/** ���������� **/

/* ��� ��� ��࠭��� ������஢ �믮��塞... */
FOR EACH tmprecid NO-LOCK,
   FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
:
   /* �᫨ �࠭� - �ய����� */
   IF NUM-ENTRIES(loan.cont-code, " ") GT 1 THEN NEXT.

   /* ============ ���� ���� �஢������ ���� ===================================== */
   FORM
      "1 - ����� �뤠���� ��㤠"
      "2 - ��᫥���� ��������� �।�⭮�� �᪠"
      "3 - �� �஬������� ����"
      iVR LABEL "�������" VALIDATE ( iVR < 4, "���������騩 ��ਠ�� !!!")
      WITH FRAME fVR 
      OVERLAY SIDE-LABELS 1 COL CENTERED ROW 5 
      TITLE COLOR BRIGHT-WHITE "[ ������ ��ਠ�� ���� ��� ������� " + loan.cont-code + " : ]"
      WIDTH 60.

   DO 
      ON ENDKEY UNDO , RETURN
      ON ERROR  UNDO , RETRY
   :
      UPDATE iVR WITH FRAME fVR.
   END.

   end-date = 01/01/1000.
   CASE iVR:
      WHEN 1 THEN DO:
         FOR EACH comm-rate
            WHERE (comm-rate.commission EQ "%���")
              AND (comm-rate.acct       EQ "0")
              AND (comm-rate.kau        EQ loan.contract + "," + loan.cont-code)
         NO-LOCK BY comm-rate.since:
            end-date = comm-rate.since.
            nPrRisk  = comm-rate.rate-comm.

            FIND FIRST loan-int
               WHERE (loan-int.contract EQ loan.contract)
                 AND (ENTRY(1, loan-int.cont-code, " ") EQ loan.cont-code)
                 AND (loan-int.id-d EQ 0)
               NO-ERROR.
            IF AVAIL(loan-int) THEN DO:
               end-date = loan-int.op-date.
            END.
            LEAVE.
         END.
         MESSAGE "��ࢠ� ��㤠 �� �������� " + loan.cont-code + " �뤠�� " + STRING(end-date) + "," skip
            "�㬬� = " + STRING(loan-int.amt-rub) + ",  % �᪠ = " + STRING(nPrRisk) 
            VIEW-AS ALERT-BOX.
      END.
      WHEN 2 THEN DO:
         FOR EACH comm-rate
            WHERE comm-rate.commission = "%���"
              AND comm-rate.acct       = "0"
              AND comm-rate.kau        = loan.contract + "," + loan.cont-code
         NO-LOCK BY comm-rate.since DESCENDING:
            end-date = comm-rate.since.
            nPrRisk  = comm-rate.rate-comm.
            LEAVE.
         END.
         MESSAGE "��᫥���� ��������� ����⢠ ������� " + loan.cont-code skip
            "�ந��諮 " + STRING(end-date) + ",  % �᪠ = " + STRING(nPrRisk) 
            VIEW-AS ALERT-BOX.
      END.
      WHEN 3 THEN DO:
         {getdate.i &DateLabel  = "��� ���� १�ࢠ"}
         nPrRisk  = LnRsrvRate(loan.contract, loan.cont-code, end-date).
         MESSAGE "�� �������� " + loan.cont-code + " �� ���� " + STRING(end-date) skip
            "��⠭����� % �᪠ = " + STRING(nPrRisk) 
            VIEW-AS ALERT-BOX.
      END.
   END CASE.

   HIDE FRAME fVR.

   IF end-date EQ 01/01/1000
   THEN DO:
      MESSAGE.
      NEXT.
   END.

   iGrRisk = LnGetGrRiska(nPrRisk, end-date).

   /* ============ ����� 蠯�� ���� ============================================== */
   {setdest.i &cols=170} /* �뢮� � preview */

   PUT UNFORMATTED SKIP(5)
   "                                         ���������� � ������� �������" SKIP(1)
   .

   IF (iVR EQ 1)
   THEN
      PUT UNFORMATTED
      "�������������������������������������" +                      "����������������������������������������������������������������������������������������������������Ŀ" SKIP
      "�                                   �" +                      "  ����� �������  �����  ����� �������  � ����������     ������    � ����� ������������ ������ ��������" SKIP
      "�       ������������ ��������       �" +                      "  �������������  �   �  �������������  � �������� �   ����������  �     � ���. �     �    � ������   �" SKIP
      "�                                   �" +                      "� ������ ���������   �      � ���.     �� % ���-���    �������    ���������� ���������   ����������� �" SKIP
      "�������������������������������������" +                      "����������������������������������������������������������������������������������������������������Ĵ" SKIP
      .
   ELSE
      PUT UNFORMATTED
      "�������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
      "�                                   �                         �������� �� ����� ����� ������� �� ������ ����������     ������    � ����� ������������ ������ ��������" SKIP
      "�       ������������ ��������       �    � �������� � ����    �� ������ ���������   �      � ���.     � �������� �   ����������  �     � ���. �     �    � ������   �" SKIP
      "�                                   �                         �                 �   �                 �� % ���-���    �������    ���������� ���������   ����������� �" SKIP
      "�������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      .

   /* ============ �������� ������ ======================================== */
   cClient = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).
   loaninf = loan.cont-code + " �� ".
   loannum = loan.cont-code.

   cDogSogl = GetXAttrValue("loan", "�।��," + loan.cont-code, "��⠑���").
   IF (cDogSogl NE "")
   THEN loaninf = loaninf + cDogSogl.
   ELSE loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").

   /* ============ �㬬� �᭮����� � ��.�।�⮢ ======================================== */
   nCredVal    = LnPrincipal2(loan.contract, loan.cont-code, end-date, loan.currency, "Main").
   nPrCredVal  = LnPrincipal2(loan.contract, loan.cont-code, end-date, loan.currency, "Pr").
   nCredRur    = ROUND(CurToCur("�������", loan.currency, "", end-date, nCredVal), 2).
   nPrCredRur  = ROUND(CurToCur("�������", loan.currency, "", end-date, nPrCredVal), 2).
   cDogCurr    = IF (loan.currency EQ "") THEN "810" ELSE loan.currency.

   /* ============ ���ᯥ祭�� ======================================== */
   RUN LnCollateralValueEx(loan.contract, loan.cont-code, end-date, ?, loan.currency, OUTPUT nObesp, OUTPUT nPrObesp).
   nObesp   = ROUND(nObesp,   2).
   nPrObesp = ROUND(nPrObesp, 2).

   /* ============ ��⥣��� ���ᯥ祭�� ============================================ */
   cObCat = "".
   iObCat = 0.

   IF ((nObesp + nPrObesp) NE 0)
   THEN DO:
      FOR EACH term-obl
         WHERE term-obl.cont-code EQ loannum
           AND term-obl.idnt      EQ 5
         NO-LOCK:

         vSurr  = term-obl.contract + "," + 
                  term-obl.cont-code + "," + 
                  STRING(term-obl.idnt) + "," +
                  STRING(term-obl.end-date) + "," + 
                  STRING(term-obl.nn).
         cObCat = Get_QualityGar2 ("comm-rate", vSurr, end-date).

         IF (cObCat NE "") AND (cObCat NE "?")
         THEN DO:
            /* ������ ����⢠ ���ᯥ祭�� �� �����䨪���� "����⢮����"*/
            iObCat  = DECIMAL(GetCode("����⢮����", cObCat)).
            IF (iObCat EQ ?) THEN iObCat = 0.

            LEAVE.
         END.
      END.

      IF cObCat EQ "" THEN 
         MESSAGE "�� ������� ���ᯥ祭�� ��� ������� " + loannum
            VIEW-AS ALERT-BOX.
   END.

   /* ============ ����� =========================================================== */
   cAcctRsrv   = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।���", end-date, false).
   nRsrv       = ABS(GetAcctPosValue_UAL(cAcctRsrv, "810", end-date, NO)).
   nRsrvClc    = ROUND(nCredRur * nPrRisk / 100, 2).

   nRsrvTst = IF (nCredVal GT nObesp)
              THEN (ROUND(CurToCur("�������", loan.currency, "", end-date,
                                   (nCredVal - nObesp) * nPrRisk / 100), 2))
              ELSE 0.

   /* ============ ��.१�� ======================================================== */
   IF (nPrCredVal NE 0)
   THEN DO:
      cAcctPrRsrv = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।���1", end-date, false).
      nPrRsrv     = ABS(GetAcctPosValue_UAL(cAcctPrRsrv, "810", end-date, NO)).
      nPrRsrvClc  = ABS(ROUND(nPrCredRur * nPrRisk / 100, 2)).
      nPrRsrvTst  = IF (nPrCredVal GT nPrObesp)
                    THEN (ROUND(CurToCur("�������", loan.currency, "", end-date,
                                         (nPrCredVal - nPrObesp) * nPrRisk / 100), 2))
                    ELSE 0.
   END.
   ELSE DO:
      cAcctPrRsrv = "".
      nPrRsrv     = 0.
      nPrRsrvClc  = 0.
      nPrRsrvTst  = 0.
      nPrObesp    = 0.
   END.

   nObesp   = ROUND(CurToCur("�������", loan.currency, "", end-date, nObesp),   2).
   nPrObesp = ROUND(CurToCur("�������", loan.currency, "", end-date, nPrObesp), 2).

   /* ============ �஢�ઠ ���� १�ࢠ ========================================= */
   IF (ABS(nRsrvTst - nRsrv) GE 0.05)
   THEN DO:
      nObespClc = ROUND(nCredRur - (nRsrv * 100 / nPrRisk), 2).
      MESSAGE "���ࠢ���� ���� ��� ������� " + loannum
         skip "Obesp = " STRING(nObesp)
         skip "d.b.  = " STRING(nObespClc)
         VIEW-AS ALERT-BOX.
      nObesp    = nObespClc.
   END.

   /* ============ �஢�ઠ ���� ��.१�ࢠ ====================================== */
   IF (ABS(nPrRsrvTst - nPrRsrv) GE 0.05)
   THEN DO:
      nObespClc = ROUND(nPrCredRur - (nPrRsrv * 100 / nPrRisk), 2).
      MESSAGE "���ࠢ���� ���� ��� ������� " + loannum
         skip "Obesp = " STRING(nObesp)
         skip "d.b.  = " STRING(nObespClc)
         VIEW-AS ALERT-BOX.
      nPrObesp  = nObespClc.
   END.

   IF iObCat NE 0
   THEN
      ASSIGN
         nObesp   = nObesp   / (iObCat / 100)
         nPrObesp = nPrObesp / (iObCat / 100)
      NO-ERROR.

   /* ============ ����� ���� ======================================== */
   ASSIGN
      nCredVal = nCredVal + nPrCredVal
      nCredRur = nCredRur + nPrCredRur
      nRsrvClc = nRsrvClc + nPrRsrvClc
      nRsrv    = nRsrv    + nPrRsrv
      nObesp   = nObesp   + nPrObesp
   NO-ERROR.

   /* �뢮��� ��ப� ⠡���� */
   PUT UNFORMATTED 
      "�" cClient FORMAT "x(35)".
   IF (iVR GT 1)
      THEN PUT UNFORMATTED "�" loaninf FORMAT "x(25)".
   PUT UNFORMATTED 
      "�" nCredVal      FORMAT "->,>>>,>>>,>>9.99"
      "�" cDogCurr      FORMAT "xxx"
      "�" nCredRur      FORMAT "->,>>>,>>>,>>9.99"
      "�" iGrRisk       FORMAT ">>"
      "�" nPrRisk       FORMAT ">>9.99" "%"
      "�" nRsrvClc      FORMAT   "->>>,>>>,>>9.99".
   IF nObesp EQ 0
      THEN PUT UNFORMATTED "�" SPACE(15) .
      ELSE PUT UNFORMATTED "�" nObesp  FORMAT "->>>,>>>,>>9.99" .
   PUT UNFORMATTED 
      "�" cObCat        FORMAT "x(2)"
      "�" nRsrv         FORMAT "->>>,>>>,>>9.99"
      "�" SKIP
      "������������������������������������". 
   IF (iVR GT 1)
      THEN PUT UNFORMATTED "��������������������������".
   PUT UNFORMATTED 
      "�������������������������������������������������������������������������������������������������������" SKIP(4).

   /* ������ � ������� */
   PUT UNFORMATTED
      "�ᯮ���⥫� " /* SPACE(20) ENTRY(1, inParam) */ SKIP(4)
      "��砫쭨� �4" /* SPACE(20) ENTRY(2, inParam) */ SKIP(2)
      (IF (iVR NE 1) THEN STRING(end-date, "99.99.9999") ELSE "") SKIP(1)
      .

   /* �⮡ࠦ��� ᮤ�ন��� preview */
   {preview.i}

END.

/* ========================================================== */
FUNCTION LnPrincipal2 RETURNS DECIMAL (INPUT iContract AS CHAR,
                                       INPUT iContCode AS CHAR,
                                       INPUT iDate     AS DATE,
                                       INPUT iCurrency AS CHAR,
                                       INPUT CC        AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mLoanCurr  AS CHAR NO-UNDO.
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF b-loan.cont-type <> "��祭��"
   THEN DO:
      IF CC = "Main"
      THEN DO:
         RUN RE_PARAM IN h_Loan ( 0, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).
      END.
      ELSE DO:
         RUN RE_PARAM IN h_Loan ( 7, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).
         RUN RE_PARAM IN h_Loan (13, iDate, iContract, iContCode, OUTPUT vParamSumm, OUTPUT vDb, OUTPUT vCr).
         vRes = vRes + vParamSumm.
      END.

      IF b-loan.Currency <> iCurrency
         THEN vRes = CurToCurWork("����", b-loan.currency, iCurrency, iDate, vRes).
   END.

   ELSE DO:
      vRes = 0.
      FOR EACH b-loan WHERE
               b-loan.contract = iContract
           AND b-loan.cont-code BEGINS iContCode
           AND NUM-ENTRIES(b-loan.cont-code, " ") = 2
           AND ENTRY(1, b-loan.cont-code, " ")    = iContCode
           AND b-loan.open-date <= iDate
         NO-LOCK:

         IF b-loan.close-date <> ? AND
            b-loan.close-date <= iDate
         THEN
            NEXT.

         vRes = vRes +  LnPrincipal2(b-loan.contract, b-loan.cont-code, iDate, iCurrency, CC).
      END. /*FOR EACH*/
   END.

   mResult = CurrRound(vRes,iCurrency).
   RETURN mResult.

END FUNCTION. /* LnPrincipal2  */

/*---------------------------------------------------------------------------
  Function   : Get_QualityGar2 (��� �஢�ન term-obl)
  Name       : ���祭�� ��⥣�ਨ ����⢠ ���ᯥ祭��
  Purpose    : ����祭�� ���祭�� ��⥣�ਨ ����� ���ᯥ祭��, ����������
               �� ��।������� ����
  Parameters : iFileName  - ⠡���
               iSurrogate - ���ண�� ������� ���ᯥ祭��
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION Get_QualityGar2 RETURNS CHAR (INPUT iFileName  AS CHAR,
                                       INPUT iSurrogate AS CHAR,
                                       INPUT iSince     AS DATE).

   DEF VAR vReturn AS CHAR NO-UNDO INIT "?".
   DEF VAR vCRSurr AS CHAR NO-UNDO.

   /* �饬 comm-rate */
   FOR EACH comm-rate WHERE comm-rate.commission EQ "��玡�ᯥ�"
                        AND comm-rate.acct       EQ "0"
                        AND comm-rate.kau        EQ iSurrogate
                        AND comm-rate.min-value  EQ 0
                        AND comm-rate.period     EQ 0
                        AND comm-rate.since      LE iSince
      NO-LOCK BY comm-rate.since DESCENDING:

      LEAVE.
   END.

   /* �᫨ �� ����, � ��।��塞 ���祭�� ��⥣�ਨ ����⢠
   ** �� ᮮ⢥�����饬� �� */
   IF AVAIL comm-rate THEN
   DO:
      vCRSurr = GetSurrogateBuffer("comm-rate",(BUFFER comm-rate:HANDLE)).
      vReturn = GetXAttrValueEx("comm-rate",vCRSurr,"��玡�ᯥ�","?").
   END.

   RETURN vReturn.

END FUNCTION.
