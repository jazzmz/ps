{pirsavelog.p}

/*
   ���� "��㤭�� �������������, �⭥ᥭ��� � 4 � 5 ��⥣�ਨ ����⢠"
   �� ��᭮���
   ���ᮢ �.�. 05.08.2009
*/

{globals.i}             		/* �������塞 �������� ����ன��*/
{ulib.i}                		/* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get comm}     	/* �����㬥��� ��� ࠡ��� � ������ﬨ */
{intrface.get xclass}   	/* �㭪樨 ࠡ��� � ����奬�� */
{intrface.get db2l}

/** ����������� **/
FUNCTION LnPrincipal2 RETURNS DECIMAL
   (INPUT iContract AS CHAR, INPUT iContCode AS CHAR,
    INPUT iDate     AS DATE, INPUT iCurrency AS CHAR, INPUT CC AS CHAR)
   FORWARD.

FUNCTION Get_QualityGar2 RETURNS CHAR
   (INPUT iFileName AS CHAR, INPUT iSurrogate AS CHAR, INPUT iSince AS DATE)
   FORWARD.

/* ================================================================================== */
DEF VAR cCurr        AS CHARACTER EXTENT 3 INITIAL ["840", "978", ""] NO-UNDO.
DEF VAR cTypeList    AS CHARACTER INIT "!���ᥫ�,!������,!��࠭⨨,!�������,*" NO-UNDO.
DEF VAR nCredVal     AS DECIMAL   NO-UNDO. /* �㬬� �।�� � ����� */
DEF VAR nCredRur     AS DECIMAL   NO-UNDO. /* �㬬� �।�� � �㡫�� */
DEF VAR nPrCredVal   AS DECIMAL   NO-UNDO. /* �㬬� ��.�।�� � ����� */
DEF VAR nPrCredRur   AS DECIMAL   NO-UNDO. /* �㬬� ��.�।�� � �㡫�� */
DEF VAR nSumVal      AS DECIMAL   NO-UNDO. /*   */
DEF VAR nSumRur      AS DECIMAL   NO-UNDO. /*   */
DEF VAR nSumRurItog  AS DECIMAL   NO-UNDO. /*   */

DEF VAR I            AS INTEGER   NO-UNDO.
DEF VAR J            AS INTEGER   NO-UNDO.

DEF VAR cClient      AS CHARACTER NO-UNDO. /* ������������ ����騪� */
DEF VAR cDogSogl     AS CHARACTER NO-UNDO. /* �� ��⠑��� */
DEF VAR loaninf      AS CHARACTER NO-UNDO. /* */
DEF VAR loannum      AS CHARACTER NO-UNDO. /* */
DEF VAR iGrRisk      AS INTEGER   NO-UNDO. /* ��㯯� �᪠ */
DEF VAR nPrRisk      AS DECIMAL   NO-UNDO. /* ��業� १�ࢨ஢���� */

/** ���������� **/
{getdate.i &DateLabel  = "��� ����"}

/* ============ ����� 蠯�� ���� ============================================== */
{setdest.i &cols=90} /* �뢮� � preview */

PUT UNFORMATTED SKIP(2)
"        ��㤭�� �������������, �⭥ᥭ��� � 4 � 5 ��⥣�ਨ ����⢠ �� " STRING(end-date) SKIP(2)
"���������������������������������������������������������������������������������������Ŀ" SKIP
"�  �  �       ������������ ��������       � � ���������� �   ����� �������   � ����������" SKIP
"� �/� �                                   �   ��������   �   �������������   � �������� �" SKIP
"���������������������������������������������������������������������������������������Ĵ" SKIP
.

nSumRurItog = 0.

DO J = 1 TO 3:
   PUT UNFORMATTED
      "� � ������ " + (IF (cCurr[J] EQ "") THEN "810" ELSE cCurr[J])
      SPACE(74) "�" SKIP
      .
   nSumVal = 0.
   nSumRur = 0.
   I       = 0.

   FOR EACH loan
      WHERE (loan.currency EQ cCurr[J])
        AND (loan.contract EQ "�।��")
        AND CAN-DO(cTypeList, loan.cont-type)
        AND (loan.Class-Code NE "mm_loan")
        AND (NUM-ENTRIES(loan.cont-code, " ") EQ 1)
        AND (loan.close-date GE end-date)
      NO-LOCK
      BY loan.cont-code:

      nPrRisk = LnRsrvRate(loan.contract, loan.cont-code, end-date).
      iGrRisk = LnGetGrRiska(nPrRisk, end-date).

      IF (iGrRisk LT 4)
      THEN NEXT.

      /* ============ �㬬� �᭮����� � ��.�।�⮢ ======================================== */
      ASSIGN
         nCredVal    = LnPrincipal2(loan.contract, loan.cont-code, end-date, loan.currency, "Main")
         nPrCredVal  = LnPrincipal2(loan.contract, loan.cont-code, end-date, loan.currency, "Pr")
         nCredRur    = ROUND(CurToCur("�������", loan.currency, "", end-date, nCredVal), 2)
         nPrCredRur  = ROUND(CurToCur("�������", loan.currency, "", end-date, nPrCredVal), 2)
         nCredVal = nCredVal + nPrCredVal
         nCredRur = nCredRur + nPrCredRur
         nSumVal  = nSumVal  + nCredVal
         nSumRur  = nSumRur  + nCredRur
      NO-ERROR.

      /* ============ ����� ���� ======================================== */
      IF (nCredVal NE 0)
      THEN DO:
         /* ============ �������� ������ ======================================== */
         cClient = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
         loaninf = loan.cont-code + " �� ".
         loannum = loan.cont-code.
         I = I + 1.
/*
         cDogSogl = GetXAttrValue("loan", "�।��," + loan.cont-code, "��⠑���").
         IF (cDogSogl NE "")
         THEN loaninf = loaninf + cDogSogl.
         ELSE loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").
*/
         /* �뢮��� ��ப� ⠡���� */
         PUT UNFORMATTED
            "�" I         FORMAT ">>>>" " "
            "�" cClient   FORMAT "x(35)"
            "�" loannum   FORMAT "x(14)"
            "� " nCredVal FORMAT "->,>>>,>>>,>>9.99"
           " �" iGrRisk   FORMAT ">>>>>" "     "
            "�" SKIP
            .
         IF (cCurr[J] NE "") THEN
         PUT UNFORMATTED
            "�     "
            "�" SPACE(35)
            "�" SPACE(14)
            "�(" nCredRur FORMAT "->,>>>,>>>,>>9.99"
           ")�" SPACE(10)
            "�" SKIP
            .
      END.

   END. /* �� ������ࠬ */

   nSumRurItog = nSumRurItog + nSumRur.

   PUT UNFORMATTED
   "���������������������������������������������������������������������������������������Ĵ" SKIP
   "� ����� � ������ " + (IF (cCurr[J] EQ "") THEN "810" ELSE cCurr[J]) SPACE(38)
   " " nSumVal FORMAT "->,>>>,>>>,>>9.99" "            �" SKIP.

   IF (cCurr[J] NE "")
   THEN PUT UNFORMATTED
   "�" SPACE(57)
   "(" nSumRur FORMAT "->,>>>,>>>,>>9.99" ")           �" SKIP.

   PUT UNFORMATTED
   "���������������������������������������������������������������������������������������Ĵ" SKIP
   .

END. /* �� ����� */

PUT UNFORMATTED
"� �����" SPACE(52)
nSumRurItog FORMAT "->,>>>,>>>,>>9.99" "            �" SKIP
"�����������������������������������������������������������������������������������������" SKIP
.

/* ������ � ������� */
/*
PUT UNFORMATTED
   "�ᯮ���⥫� " SKIP(4)
   "��砫쭨� �4" SKIP(2)
   .
*/
/* �⮡ࠦ��� ᮤ�ন��� preview */
{preview.i}

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
