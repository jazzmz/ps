{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪠ ����権 �।���� ������஢ ��� �.808 �ࠢ�筮.
                ���ᮢ �.�., 28.08.2009
*/

{globals.i}           /** �������� ��।������ */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get date}   /** �㭪樨 ��� ࠡ��� � ��⠬� */
{intrface.get instrum}
{intrface.get loan}
{intrface.get i254}
{intrface.get db2l}
{intrface.get rsrv}
{ulib.i}              /** ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */

{sh-defs.i}

{pir_exf_exl.i}
{getdates.i}
{exp-path.i &exp-filename = "'kred_op.xls'"}

/******************************************* ��।������ ��६����� � ��. */
DEF INPUT PARAM inParam    AS CHARACTER.
DEF VAR cParam       AS CHAR     NO-UNDO.
DEF VAR lIsprav      AS LOGICAL  NO-UNDO.
DEF VAR cLDogVO      AS CHAR     INIT ""  NO-UNDO.
DEF VAR cLCurrVO     AS CHAR     INIT ""  NO-UNDO.
DEF VAR cLKursVO     AS CHAR     INIT ""  NO-UNDO.
DEF VAR cLDataVO     AS CHAR     INIT ""  NO-UNDO.
DEF VAR iVO          AS INTEGER  NO-UNDO.
DEF VAR cCurrVO      AS CHAR     NO-UNDO.
DEF VAR nKursVO      AS DECIMAL  NO-UNDO.
DEF VAR dDataVO      AS DATE     NO-UNDO.

DEF VAR cTmpStr      AS CHAR     NO-UNDO.
DEF VAR iNumOE       AS INTEGER  NO-UNDO.
DEF VAR cTypeList    AS CHAR     INIT "!���ᥫ�,!������,!��࠭⨨,!�������,*" NO-UNDO.
DEF VAR cOpList      AS CHAR     INIT "1,2,4,5,50,32,33,136,137,504,505"       NO-UNDO.
DEF VAR cOpListDR    AS CHAR     INIT            "32,33,136,137"               NO-UNDO.
/*
DEF VAR cDogList     AS CHAR     INIT "��-23/08,��-35/09,��-145/04,��-161/04"  NO-UNDO.
DEF VAR cDogList     AS CHAR     INIT "39/09,43/09,42/09,44/09,48/09,49/09,50/09,51/09,��-28/08,52/09,53/09,69/08"  NO-UNDO.
*/
DEF VAR cDogList     AS CHAR     INIT "*"  NO-UNDO.
DEF VAR dCurs0       AS DECIMAL  NO-UNDO.
DEF VAR dOpDate      AS DATE     NO-UNDO.
DEF VAR cLoan-Num    AS CHAR     NO-UNDO.
DEF VAR cLoan-Cont   AS CHAR     NO-UNDO.
DEF VAR cLoan-Curr   AS CHAR     NO-UNDO.
DEF VAR cAcct-Rsrv   AS CHAR     NO-UNDO.
DEF VAR cAcct-PrRsrv AS CHAR     NO-UNDO.
DEF VAR cDRPrich     AS CHAR     NO-UNDO.
DEF VAR cDRRsrvN     AS CHAR     NO-UNDO.
DEF VAR cDRPrRsrvN   AS CHAR     NO-UNDO.
DEF VAR cDRNew       AS CHAR     NO-UNDO.
DEF VAR cOps         AS CHAR     NO-UNDO.
DEF VAR cErrAnl      AS CHAR     NO-UNDO.
DEF VAR cVnimanie    AS CHAR     NO-UNDO.
DEF VAR nOb1         AS DECIMAL  NO-UNDO.
DEF VAR nOb2         AS DECIMAL  NO-UNDO.

DEF VAR dOpDate0     AS DATE     NO-UNDO.
DEF VAR nCred0       AS DECIMAL  NO-UNDO.
DEF VAR nCred1       AS DECIMAL  NO-UNDO.
DEF VAR nPrCred0     AS DECIMAL  NO-UNDO.
DEF VAR nPrCred1     AS DECIMAL  NO-UNDO.
DEF VAR nObesp1      AS DECIMAL  NO-UNDO.
DEF VAR nObesp0      AS DECIMAL  NO-UNDO.
DEF VAR nPrObesp1    AS DECIMAL  NO-UNDO.
DEF VAR nPrObesp0    AS DECIMAL  NO-UNDO.
DEF VAR nRsrv0       AS DECIMAL  NO-UNDO.
DEF VAR nRsrv1       AS DECIMAL  NO-UNDO.
DEF VAR nPrRsrv0     AS DECIMAL  NO-UNDO.
DEF VAR nPrRsrv1     AS DECIMAL  NO-UNDO.
DEF VAR nRisk0       AS DECIMAL  NO-UNDO.
DEF VAR nRisk1       AS DECIMAL  NO-UNDO.

DEF VAR nSVydCr      AS DECIMAL  NO-UNDO.
DEF VAR nSGashCr     AS DECIMAL  NO-UNDO.
DEF VAR nSGashPrCr   AS DECIMAL  NO-UNDO.
DEF VAR nSIzmCrVO    AS DECIMAL  NO-UNDO.
DEF VAR nSIzmRsrv    AS DECIMAL  NO-UNDO.
DEF VAR nSIzmPrRsrv  AS DECIMAL  NO-UNDO.
DEF VAR nSProsroch   AS DECIMAL  NO-UNDO.

DEF VAR nIVCred      AS DECIMAL  NO-UNDO.
DEF VAR nIGCred      AS DECIMAL  NO-UNDO.
DEF VAR nIPros       AS DECIMAL  NO-UNDO.
DEF VAR nIKurs       AS DECIMAL  NO-UNDO.
DEF VAR nIProc       AS DECIMAL  NO-UNDO.
DEF VAR nIObesp      AS DECIMAL  NO-UNDO.
DEF VAR nIPrCred     AS DECIMAL  NO-UNDO.
DEF VAR nIPrPros     AS DECIMAL  NO-UNDO.
DEF VAR nIPrKurs     AS DECIMAL  NO-UNDO.
DEF VAR nIPrProc     AS DECIMAL  NO-UNDO.
DEF VAR nIPrObesp    AS DECIMAL  NO-UNDO.
DEF VAR nKontRsrv    AS DECIMAL  NO-UNDO.
DEF VAR nKontPrRsrv  AS DECIMAL  NO-UNDO.

DEF VAR lFirstStr    AS LOGICAL  NO-UNDO.
DEF VAR I            AS INTEGER  NO-UNDO.
DEF VAR N            AS INTEGER  NO-UNDO.
DEF VAR nVr          AS DECIMAL  NO-UNDO.
DEF VAR lObesp       AS LOGICAL  NO-UNDO.

DEFINE TEMP-TABLE ttCredOp       NO-UNDO
   FIELD ttDogNum    AS CHARACTER 
   FIELD ttDogCurr   AS CHARACTER 
   FIELD ttOpDate    AS DATE
   FIELD ttSumCr     AS DECIMAL
   FIELD ttSumPrCr   AS DECIMAL
   FIELD ttObesp     AS DECIMAL
   FIELD ttPrObesp   AS DECIMAL
   FIELD ttRisk      AS DECIMAL
   FIELD ttOp        AS CHARACTER  INIT ""
   FIELD ttVydCr     AS DECIMAL    INIT 0
   FIELD ttGashCr    AS DECIMAL    INIT 0
   FIELD ttGashPrCr  AS DECIMAL    INIT 0
   FIELD ttIzmCrVO   AS DECIMAL    INIT 0
   FIELD ttProsroch  AS DECIMAL    INIT 0
   FIELD ttSumRsrv   AS DECIMAL    INIT 0
   FIELD ttIzmRsrv   AS DECIMAL    INIT 0
   FIELD ttSumPrRsrv AS DECIMAL    INIT 0
   FIELD ttIzmPrRsrv AS DECIMAL    INIT 0
   FIELD ttDRPrich   AS CHARACTER  INIT ""
   FIELD ttOps       AS CHARACTER  INIT ""
   FIELD ttErr       AS CHARACTER  INIT ""
.

FUNCTION LnPrincipal2 RETURNS DECIMAL
   (INPUT iContract  AS CHAR,
    INPUT iContCode  AS CHAR,
    INPUT iDate      AS DATE,
    INPUT iCurrency  AS CHAR,
    INPUT CC         AS CHAR)
   FORWARD.

FUNCTION CurToRurVO   RETURNS DECIMAL
   (INPUT iCurr      AS CHAR,
    INPUT iDate      AS DATE,
    INPUT iVO        AS INTEGER,
    INPUT iKurs      AS DECIMAL,
    INPUT iSumm      AS DECIMAL)
   FORWARD.

FUNCTION RurToCurVO   RETURNS DECIMAL
   (INPUT iCurr      AS CHAR,
    INPUT iDate      AS DATE,
    INPUT iVO        AS INTEGER,
    INPUT iKurs      AS DECIMAL,
    INPUT iSumm      AS DECIMAL)
   FORWARD.

/* = ��������㥬 ��ࠬ��� ��楤��� ======================================== */
lIsprav = ENTRY(1, inParam, "|") EQ "YES". /* ������ ��ࠢ����� */
cParam  = ENTRY(2, inParam, "|").

REPEAT I = 1 TO NUM-ENTRIES(cParam):

   cTmpStr = ENTRY(I, cParam).
   cLDogVO = cLDogVO + ENTRY(1, cTmpStr, ";") + ",".

   FIND FIRST loan
      WHERE (loan.cont-code EQ ENTRY(I, cLDogVO))
      NO-ERROR.
   IF NOT AVAIL loan
   THEN DO:
      MESSAGE "No loan " ENTRY(I, cLDogVO)
         VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
      NEXT.
   END.

   cLDataVO = cLDataVO
            + (IF (NUM-ENTRIES(cTmpStr, ";") GE 2)
               THEN ENTRY(2, cTmpStr, ";")
               ELSE STRING(loan.open-date))
            + ",".
   cLCurrVO = cLCurrVO
            + (IF (NUM-ENTRIES(cTmpStr, ";") EQ 3)
               THEN ENTRY(3, cTmpStr, ";")
               ELSE "840")
            + ",".
   cLKursVO = cLKursVO
            + STRING(FindRateSimple("�������", ENTRY(I, cLCurrVO), DATE(ENTRY(I, cLDataVO))))
            + ",".
END.

   cLDogVO  = TRIM(cLDogVO,  ",").
   cLDataVO = TRIM(cLDataVO, ",").
   cLCurrVO = TRIM(cLCurrVO, ",").
   cLKursVO = TRIM(cLKursVO, ",").

/* = ������뢠�� ������⢮ ������஢ ===================================== */
I = 0.
N = 0.
FOR EACH loan
   WHERE (loan.contract EQ "�।��")
     AND CAN-DO(cTypeList, loan.cont-type)
     AND (loan.Class-Code NE "mm_loan")
     AND (loan.open-date LE end-date)
     AND ((loan.close-date GE beg-date)
      OR  (loan.close-date EQ ?))
     AND (NUM-ENTRIES(loan.cont-code, " ") EQ 1)
     AND CAN-DO(cDogList, loan.cont-code)
   NO-LOCK BY loan.cont-code:

   N = N + 1.
END.

iNumOE = 0.

/* = �����⮢�� �६����� ⠡���� ========================================= */
{init-bar.i "��ନ�㥬 �६����� ⠡����"}

/* = ���� �� ������ࠬ =======  */
FOR EACH loan
   WHERE (loan.contract EQ "�।��")
     AND CAN-DO(cTypeList, loan.cont-type)
     AND (loan.Class-Code NE "mm_loan")
     AND (loan.open-date LE end-date)
     AND ((loan.close-date GE beg-date)
      OR  (loan.close-date EQ ?))
     AND (NUM-ENTRIES(loan.cont-code, " ") EQ 1)
     AND CAN-DO(cDogList, loan.cont-code)
   NO-LOCK BY loan.cont-code:

   cLoan-Num    = loan.cont-code.
   cLoan-Cont   = loan.contract.
   cLoan-Curr   = loan.currency.
   iVO          = LOOKUP(cLoan-Num, cLDogVO).

   /*   put screen col 1 row 24 "��ࠡ��뢠���� " + cLoan-Num + "          ". */
   I = I + 1.
   {move-br2.i I N}

   IF (loan.open-date LT beg-date)
   THEN DO:
      dOpDate      = PrevOpDay(beg-date).
      iVO          = LOOKUP(cLoan-Num, cLDogVO).
      IF (iVO NE 0)
      THEN IF (dOpDate LT DATE(ENTRY(iVO, cLDataVO)))
      THEN iVO = 0.

      cAcct-Rsrv   = GetLoanAcct_ULL(cLoan-Cont, cLoan-Num, "�।���", dOpDate, false).
      cAcct-PrRsrv = GetLoanAcct_ULL(cLoan-Cont, cLoan-Num, "�।���1", dOpDate, false).

      CREATE ttCredOp.
      ttCredOp.ttDogNum    = cLoan-Num.
      ttCredOp.ttDogCurr   = IF (iVO EQ 0) THEN cLoan-Curr ELSE ENTRY(iVO, cLCurrVO).
      ttCredOp.ttOpDate    = dOpDate.
      ttCredOp.ttSumCr     = LnPrincipal2(cLoan-Cont, cLoan-Num, dOpDate, cLoan-Curr, "Main").
      ttCredOp.ttSumPrCr   = LnPrincipal2(cLoan-Cont, cLoan-Num, dOpDate, cLoan-Curr, "Pr").

      IF (iVO NE 0)
      THEN DO:
         ttCredOp.ttSumCr   = RurToCurVO(ENTRY(iVO, cLCurrVO), dOpDate, iVO,
                               DECIMAL(ENTRY(iVO, cLKursVO)), ttCredOp.ttSumCr).
         ttCredOp.ttSumPrCr = RurToCurVO(ENTRY(iVO, cLCurrVO), dOpDate, iVO,
                               DECIMAL(ENTRY(iVO, cLKursVO)), ttCredOp.ttSumPrCr).
      END.

      RUN LnCollateralValueEx("�।��", cLoan-Num, dOpDate, ?, cLoan-Curr, OUTPUT nOb1, OUTPUT nOb2).
      ttCredOp.ttObesp     = nOb1.
      ttCredOp.ttPrObesp   = nOb2.

      ttCredOp.ttRisk      = LnRsrvRate(cLoan-Cont, cLoan-Num, dOpDate).
      ttCredOp.ttSumRsrv   = ABS(GetAcctPosValue_UAL(cAcct-Rsrv, "810", dOpDate, NO)).
      ttCredOp.ttSumPrRsrv = ABS(GetAcctPosValue_UAL(cAcct-PrRsrv, "810", dOpDate, NO)).
   END.

   /* = ���� �� ������ ������� =======  */
   FOR EACH loan-int
      WHERE (ENTRY(1, loan-int.cont-code, " ") EQ cLoan-Num)
        AND (loan-int.mdate GE beg-date)
        AND (loan-int.mdate LE end-date)
      NO-LOCK,
      FIRST chowhe
         WHERE (chowhe.id-d EQ loan-int.id-d)
           AND (chowhe.id-k EQ loan-int.id-k)
           AND CAN-DO(cOpList, STRING(chowhe.id-op))
         NO-LOCK
      BY loan-int.mdate BY chowhe.id-op:

      cDRPrich = "".

      CREATE ttCredOp.
      ttCredOp.ttOp = STRING(chowhe.id-op).

      IF (chowhe.id-op NE 1)
      THEN DO:
         FIND FIRST op-entry
            WHERE (op-entry.op EQ loan-int.op)
              AND (op-entry.op-entry EQ loan-int.op-entry)
            NO-ERROR.

         /* �᫨ �஫������ - �ய����� */
         IF AVAIL op-entry
         THEN DO:
            cDRPrich = GetXAttrValue("op-entry",
                          STRING (op-entry.op) + "," + STRING (op-entry.op-entry),
                          "��爧�����ࢠ").
            IF    (NUM-ENTRIES(op-entry.kau-db) EQ 3)
              AND (NUM-ENTRIES(op-entry.kau-cr) EQ 3)
            THEN
               IF    (ENTRY(3, op-entry.kau-db) EQ "4")
                 AND (ENTRY(3, op-entry.kau-cr) EQ "5")
               THEN ttCredOp.ttOp = "�".
         END.
      END.

      dOpDate      = loan-int.mdate.
      iVO          = LOOKUP(cLoan-Num, cLDogVO).
      IF (iVO NE 0)
      THEN IF (dOpDate LT DATE(ENTRY(iVO, cLDataVO)))
      THEN iVO = 0.

      cAcct-Rsrv   = GetLoanAcct_ULL(cLoan-Cont, cLoan-Num, "�।���", dOpDate, false).
      cAcct-PrRsrv = GetLoanAcct_ULL(cLoan-Cont, cLoan-Num, "�।���1", dOpDate, false).

      ttCredOp.ttDogNum    = cLoan-Num.
      ttCredOp.ttDogCurr   = IF (iVO EQ 0) THEN cLoan-Curr ELSE ENTRY(iVO, cLCurrVO).
      ttCredOp.ttOpDate    = dOpDate.
      ttCredOp.ttRisk      = LnRsrvRate(cLoan-Cont, cLoan-Num, dOpDate).
      ttCredOp.ttSumCr     = LnPrincipal2(cLoan-Cont, cLoan-Num, dOpDate, cLoan-Curr, "Main").
      ttCredOp.ttSumPrCr   = LnPrincipal2(cLoan-Cont, cLoan-Num, dOpDate, cLoan-Curr, "Pr").

      IF (iVO NE 0)
      THEN DO:
         ttCredOp.ttSumCr   = RurToCurVO(ENTRY(iVO, cLCurrVO), dOpDate, iVO,
                               DECIMAL(ENTRY(iVO, cLKursVO)), ttCredOp.ttSumCr).
         ttCredOp.ttSumPrCr = RurToCurVO(ENTRY(iVO, cLCurrVO), dOpDate, iVO,
                               DECIMAL(ENTRY(iVO, cLKursVO)), ttCredOp.ttSumPrCr).
      END.

      ttCredOp.ttSumRsrv   = ABS(GetAcctPosValue_UAL(cAcct-Rsrv, "810", dOpDate, NO)).
      ttCredOp.ttSumPrRsrv = ABS(GetAcctPosValue_UAL(cAcct-PrRsrv, "810", dOpDate, NO)).
      ttCredOp.ttDRPrich   = cDRPrich.
      IF (ttCredOp.ttDRPrich NE "") THEN ttCredOp.ttDRPrich = ttCredOp.ttDRPrich + ",".

      RUN LnCollateralValueEx("�।��", cLoan-Num, dOpDate, ?, cLoan-Curr, OUTPUT nOb1, OUTPUT nOb2).
/*
      ttCredOp.ttObesp     = ROUND(nOb1, 2).
      ttCredOp.ttPrObesp   = ROUND(nOb2, 2).
*/
      ttCredOp.ttObesp     = nOb1.
      ttCredOp.ttPrObesp   = nOb2.

      CASE ttCredOp.ttOp:
         WHEN "1" OR WHEN "2" THEN
            ttCredOp.ttProsroch  = loan-int.amt-rub.
         WHEN "4"
            THEN DO:
               IF (op-entry.acct-cr EQ "70605810300001520202") /* ����⭠� �����ઠ (����) */
               THEN
                  ASSIGN
                     ttCredOp.ttOp = "4v"
                     ttCredOp.ttIzmCrVO = loan-int.amt-rub
                  NO-ERROR.
               ELSE ttCredOp.ttVydCr    = loan-int.amt-rub.
            END.
         WHEN "32" THEN
            ttCredOp.ttIzmRsrv   = loan-int.amt-rub.
         WHEN "136" THEN
            ttCredOp.ttIzmPrRsrv = loan-int.amt-rub.
         WHEN "5"
            THEN DO:
               IF (op-entry.acct-db EQ "70610810300002420202") /* ����⭠� �����ઠ (����) */
               THEN
                  ASSIGN
                     ttCredOp.ttOp = "5v"
                     ttCredOp.ttIzmCrVO = - loan-int.amt-rub
                  NO-ERROR.
               ELSE ttCredOp.ttGashCr   = - loan-int.amt-rub.
            END.
         WHEN "50" THEN
            ttCredOp.ttGashPrCr  = - loan-int.amt-rub.
         WHEN "33" THEN
            ttCredOp.ttIzmRsrv   = - loan-int.amt-rub.
         WHEN "137" THEN
            ttCredOp.ttIzmPrRsrv = - loan-int.amt-rub.
         WHEN "504" THEN
            ASSIGN
               ttCredOp.ttOp = "504v"
               ttCredOp.ttIzmCrVO = loan-int.amt-rub
            NO-ERROR.
         WHEN "505" THEN
            ASSIGN
               ttCredOp.ttOp = "505v"
               ttCredOp.ttIzmCrVO = - loan-int.amt-rub
            NO-ERROR.
      END CASE.

      IF CAN-DO(cOpListDR, ttCredOp.ttOp) THEN iNumOE = iNumOE + 1.
      ttCredOp.ttErr = IF (CAN-DO(cOpListDR, ttCredOp.ttOp) AND (ttCredOp.ttDRPrich EQ ""))
                       THEN "!" ELSE "".

      IF AVAIL op-entry
      THEN ttCredOp.ttErr = ttCredOp.ttErr + (IF (dOpDate NE op-entry.op-date) THEN "d" ELSE "").
   END.

   IF (iVO NE 0)
   THEN DO:
      dOpDate = DATE(ENTRY(iVO, cLDataVO)).
      IF (dOpDate GE beg-date)
      THEN DO:

         FIND FIRST ttCredOp
            WHERE (ttCredOp.ttDogNum EQ cLoan-Num)
              AND (ttCredOp.ttOpDate EQ dOpDate)
            NO-ERROR.

         IF NOT AVAIL ttCredOp
         THEN DO:
            cAcct-Rsrv   = GetLoanAcct_ULL(cLoan-Cont, cLoan-Num, "�।���", dOpDate, false).
            cAcct-PrRsrv = GetLoanAcct_ULL(cLoan-Cont, cLoan-Num, "�।���1", dOpDate, false).

            CREATE ttCredOp.
            ttCredOp.ttDogNum    = cLoan-Num.
            ttCredOp.ttDogCurr   = ENTRY(iVO, cLCurrVO).
            ttCredOp.ttOpDate    = dOpDate.
            ttCredOp.ttSumCr     = RurToCurVO(ENTRY(iVO, cLCurrVO), dOpDate, iVO,
                                    DECIMAL(ENTRY(iVO, cLKursVO)),
                                    LnPrincipal2(cLoan-Cont, cLoan-Num, dOpDate, cLoan-Curr, "Main")).
            ttCredOp.ttSumPrCr   = RurToCurVO(ENTRY(iVO, cLCurrVO), dOpDate, iVO,
                                    DECIMAL(ENTRY(iVO, cLKursVO)),
                                    LnPrincipal2(cLoan-Cont, cLoan-Num, dOpDate, cLoan-Curr, "Pr")).
            ttCredOp.ttRisk      = LnRsrvRate(cLoan-Cont, cLoan-Num, dOpDate).
            ttCredOp.ttSumRsrv   = ABS(GetAcctPosValue_UAL(cAcct-Rsrv, "810", dOpDate, NO)).
            ttCredOp.ttSumPrRsrv = ABS(GetAcctPosValue_UAL(cAcct-PrRsrv, "810", dOpDate, NO)).

            RUN LnCollateralValueEx("�।��", cLoan-Num, dOpDate, ?, cLoan-Curr, OUTPUT nOb1, OUTPUT nOb2).
            ttCredOp.ttObesp     = nOb1.
            ttCredOp.ttPrObesp   = nOb2.
         END.
      END.
   END.
END.

/* = �뢮��� ��������� XL-䠩�� ============================================ */
{init-bar.i "��襬 XL-䠩�              "}

PUT UNFORMATTED XLHead("op", "CDCNNNNNNNNINNNNNNNCCCCCNNNNNNNNNNNNN",
                           /* 1234567890123456789012345678901234567  */
                       "74,71,31,53,57,100,100,100,100,100,100,50,100,100,100,100,100,100,100,100,100,100,20,20,75,75,75,75,75,75,75,75,75,75,75,75,75").
                      /* 1  2  3  4  5   6   7   8   9  10  11 12  13  14  15  16  17  18  19  20  21  22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37*/

cTmpStr = XLCell("�������")            /*  1 */
        + XLCell("���")               /*  2 */
        + XLCell("Curr")               /*  3 */
        + XLCell("Kurs")               /*  4 */
        + XLCell("% �᪠")            /*  5 */
        + XLCell("�㬬� �।��")      /*  6 */
        + XLCell("�㬬� ��.�।��")   /*  7 */
        + XLCell("���ᯥ祭��")        /*  8 */
        + XLCell("��.���ᯥ祭��")     /*  9 */
        + XLCell("�㬬� १�ࢠ")      /* 10 */
        + XLCell("�㬬� ��.१�ࢠ")   /* 11 */
        + XLCell("��")                 /* 12 */
        + XLCell("+ �।��")           /* 13 */
        + XLCell("- �।��")           /* 14 */
        + XLCell("- ��.�।��")        /* 15 */
        + XLCell("+/- �।�₎")       /* 16 */
        + XLCell("����窠")          /* 17 */
        + XLCell("+/- �����")         /* 18 */
        + XLCell("+/- ��.१��")      /* 19 */
        + XLCell("�� ��稭�")         /* 20 */
        + XLCell("�� New���")          /* 21 */
        + XLCell("�� New��")           /* 22 */
        + XLCell("ErrDog")             /* 23 */
        + XLCell("!!!")                /* 24 */
        + XLCell("d ����")            /* 25 */
        + XLCell("d %")                /* 26 */
        + XLCell("d ��.�।��")      /* 27 */
        + XLCell("d ���.�।��")      /* 28 */
        + XLCell("d �뭮��")          /* 29 */
        + XLCell("d ����-�")          /* 30 */
        + XLCell("d ��.����")         /* 31 */
        + XLCell("d ��.%")             /* 32 */
        + XLCell("d ��.�।��")       /* 33 */
        + XLCell("d ��.�뭮��")       /* 34 */
        + XLCell("d ��.����-�")       /* 35 */
        + XLCell("����஫� ���.")      /* 36 */
        + XLCell("����஫� ��.���.")   /* 37 */
        .

PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd() .

/* = ���� �� �६����� ⠡��� ============================================= */
FOR EACH ttCredOp
   BREAK BY ttDogNum BY ttOpDate.

   ACCUMULATE ttVydCr     (TOTAL BY ttOpDate).
   ACCUMULATE ttGashCr    (TOTAL BY ttOpDate).
   ACCUMULATE ttGashPrCr  (TOTAL BY ttOpDate).
   ACCUMULATE ttIzmCrVO   (TOTAL BY ttOpDate).
   ACCUMULATE ttIzmRsrv   (TOTAL BY ttOpDate).
   ACCUMULATE ttIzmPrRsrv (TOTAL BY ttOpDate).
   ACCUMULATE ttProsroch  (TOTAL BY ttOpDate).

   IF FIRST-OF(ttDogNum)
   THEN lFirstStr = True.

   IF FIRST-OF(ttOpDate)
   THEN
      ASSIGN
         cDRPrich = ""
         cOps     = ""
      .

   ASSIGN
      cDRPrich = cDRPrich + ttCredOp.ttDRPrich
      cOps     = cOps + ttCredOp.ttOp + ttCredOp.ttErr + ","
   .

   /* = �������� �⮣� �� ���� ============================================= */
   IF LAST-OF(ttOpDate)
   THEN DO:

      iVO = LOOKUP(ttCredOp.ttDogNum, cLDogVO).
      IF (iVO NE 0)
      THEN DO:
         IF (ttCredOp.ttOpDate LT DATE(ENTRY(iVO, cLDataVO)))
         THEN iVO = 0.
         ELSE nKursVO = DECIMAL(ENTRY(iVO, cLKursVO)).
      END.

      ASSIGN
         nCred1      = ttCredOp.ttSumCr
         nPrCred1    = ttCredOp.ttSumPrCr
         nObesp1     = ttCredOp.ttObesp
         nPrObesp1   = ttCredOp.ttPrObesp
         nRsrv1      = ttCredOp.ttSumRsrv
         nPrRsrv1    = ttCredOp.ttSumPrRsrv
         nRisk1      = ttCredOp.ttRisk
         nSVydCr     = ACCUM TOTAL BY ttOpDate ttVydCr
         nSGashCr    = ACCUM TOTAL BY ttOpDate ttGashCr
         nSGashPrCr  = ACCUM TOTAL BY ttOpDate ttGashPrCr
         nSIzmCrVO   = ACCUM TOTAL BY ttOpDate ttIzmCrVO
         nSIzmRsrv   = ACCUM TOTAL BY ttOpDate ttIzmRsrv
         nSIzmPrRsrv = ACCUM TOTAL BY ttOpDate ttIzmPrRsrv
         nSProsroch  = ACCUM TOTAL BY ttOpDate ttProsroch
         cDRPrich    = SUBSTRING(cDRPrich, 1, LENGTH(cDRPrich) - 1)
         cOps        = SUBSTRING(cOps,     1, LENGTH(cOps)     - 1)
         cVnimanie   = ""
         cErrAnl     = ""
         nIVCred     = 0
         nIGCred     = 0
         nIPros      = 0
         nIKurs      = 0
         nIProc      = 0
         nIObesp     = 0
         nIPrCred    = 0
         nIPrPros    = 0
         nIPrKurs    = 0
         nIPrProc    = 0
         nIPrObesp   = 0
         cDRNew     = ""
         cDRRsrvN   = ""
         cDRPrRsrvN = ""
      NO-ERROR.

      /* = �᫨ �� ��� �� �� "��⠪�" => ��ࠡ��뢠�� =================== */
      IF (ttCredOp.ttOpDate GE beg-date)
      THEN DO:

         /* = ��砫�� ���祭�� ��� ������ ������� ======================= */
         IF lFirstStr
         THEN
            ASSIGN
               dOpDate0  = ttCredOp.ttOpDate
               nCred0    = 0
               nPrCred0  = 0
               nObesp0   = nObesp1
               nPrObesp0 = nPrObesp1
               nRsrv0    = 0
               nPrRsrv0  = 0
               nRisk0    = nRisk1
            NO-ERROR.

         /* = �஢��塞 �訡�� �����⨪� =================================== */
            /* �㬬�୮� ��������� �।�� � ��.�।�� � �।.���� */
         IF ((nCred0 + nPrCred0 + nSVydCr + nSGashCr + nSGashPrCr) NE (nCred1 + nPrCred1))
            AND (iVO EQ 0)
         THEN cErrAnl = "!0".
            /* ��������� �।�� � �।.���� */
         IF ((nCred0 + nSVydCr + nSGashCr - nSProsroch) NE nCred1)
            AND (iVO EQ 0)
         THEN cErrAnl = cErrAnl + "!Cr".
            /* ��������� ��.�।�� � �।.���� */
         IF ((nPrCred0 + nSGashPrCr + nSProsroch) NE nPrCred1)
            AND (iVO EQ 0)
         THEN cErrAnl = cErrAnl + "!Pr".
            /* �㬬� १�ࢠ */
         nVr = ROUND(CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, 0,
                     (nCred1 - nObesp1) * nRisk1 / 100.0), 2).
         IF (ABS(nVr - nRsrv1) GT 0.02)
            AND (iVO EQ 0)
         THEN cErrAnl = cErrAnl + "!Rz=" + STRING(nVr).
            /* �㬬� ��.१�ࢠ */
         nVr = ROUND(CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, 0,
                     (nPrCred1 - nPrObesp1) * nRisk1 / 100.0), 2).
         IF (ABS(nVr - nPrRsrv1) GT 0.02)
            AND (iVO EQ 0)
         THEN cErrAnl = cErrAnl + "!PRz=" + STRING(nVr).
            /* ��������� �㬬� १�ࢠ */
         IF ((nRsrv0 + nSIzmRsrv) NE nRsrv1)
            AND (iVO EQ 0)
         THEN cErrAnl = cErrAnl + "!Dr".
            /* ��������� �㬬� ��.१�ࢠ */
         IF ((nPrRsrv0 + nSIzmPrRsrv) NE nPrRsrv1)
            AND (iVO EQ 0)
         THEN cErrAnl = cErrAnl + "!Dp".

         /* = ����塞 ��稭� ��������� १�ࢠ ========================== */
         IF (nSIzmRsrv NE 0)
         THEN DO:
         IF (nCred1 EQ 0) AND (nCred0 EQ (- nSGashCr))
         THEN
            nIGCred  = nSIzmRsrv.
         ELSE DO:
            IF    (iVO NE 0)
              AND (nRisk0 EQ nRisk1)
              AND (nObesp0 EQ nObesp1)
              AND (nSIzmPrRsrv EQ 0)
              AND ((nSVydCr EQ 0) OR (nSGashCr EQ 0))
            THEN
               ASSIGN
                  nIKurs  = ROUND(nSIzmCrVO * nRisk1 / 100, 2)
                  nIVCred = ROUND(nSVydCr   * nRisk1 / 100, 2)
                  nIGCred = ROUND(nSGashCr  * nRisk1 / 100, 2)
               NO-ERROR.
            ELSE DO:
               lObesp = FALSE.
               /* ��������� ��業� १�ࢨ஢���� */
               IF (nRisk1 NE nRisk0)
               THEN
                  nIProc   = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                        (nCred0 - nObesp0) * nRisk1 / 100.0)
                           - nRsrv0.
               /* �뭮� �� ������ */
               IF (nSProsroch NE 0)
               THEN DO:
                  nIPros   = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                         (nCred0 - nSProsroch - nObesp0) * nRisk1 / 100.0)
                              - nRsrv0 - nIProc.
                  nVr      = - CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                          nSProsroch * nRisk1 / 100.0).
                  IF (ABS(nIPros - nVr) LE 0.03)
                  THEN nIPros = nVr.
               END.
               /* ��襭�� �।�� */
               IF (nSGashCr NE 0)
               THEN DO:
                  nIGCred  = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                        (nCred0 - nSProsroch + nSGashCr - nObesp0) * nRisk1 / 100.0)
                             - nRsrv0 - nIProc - nIPros.
                  nVr      = - CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                        (- nSGashCr) * nRisk1 / 100.0).
                  IF (ABS(nIGCred - nVr) LE 0.03)
                  THEN nIGCred = nVr.
               END.
               /* ��������� ���ᯥ祭�� */
               IF    (nObesp1 NE nObesp0)
                 AND ((nSProsroch NE 0) OR (nSGashCr NE 0))
               THEN DO:
                  nIObesp  = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                        ((IF (nSVydCr GT 0) THEN (nCred0 - nSProsroch + nSGashCr)
                                          ELSE nCred1) - nObesp1) * nRisk1 / 100.0)
                           - nRsrv0 - nIProc - nIPros - nIGCred.
                  lObesp   = TRUE.
               END.
               /* ��������� ���� */
               IF (ttCredOp.ttDogCurr NE "") AND NOT lFirstStr
               THEN
                  nIKurs   = CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, nKursVO,
                                        ((IF (nSVydCr GT 0) THEN (nCred0 - nSProsroch + nSGashCr)
                                          ELSE nCred1) - (IF lObesp THEN nObesp1 ELSE nObesp0)) * nRisk1 / 100.0)
                           - nRsrv0 - nIProc - nIPros - nIGCred - nIObesp.
               /* �뤠� �।�� */
               IF (nSVydCr GT 0)
               THEN DO:
                  nIVCred  = CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, nKursVO,
                                        (nCred1 - (IF lObesp THEN nObesp1 ELSE nObesp0)) * nRisk1 / 100.0)
                             - nRsrv0 - nIProc - nIPros - nIGCred - nIObesp - nIKurs.
                  nVr      = CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, nKursVO,
                                        nSVydCr * nRisk1 / 100.0).
                  IF (ABS(nIVCred - nVr) LE 0.03)
                  THEN nIVCred = nVr.
               END.
               /* ��������� ���ᯥ祭�� */
               IF (nObesp1 NE nObesp0) AND NOT lObesp
               THEN
                  nIObesp  = CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, nKursVO,
                                        (nCred1 - nObesp1) * nRisk1 / 100.0)
                           - nRsrv0 - nIProc - nIPros - nIGCred - nIVCred - nIKurs.
            END.
         END.
         END.

         nIProc  = ROUND(nIProc,  2).
         nIPros  = ROUND(nIPros,  2).
         nIVCred = ROUND(nIVCred, 2).
         nIGCred = ROUND(nIGCred, 2).
         nIKurs  = ROUND(nIKurs,  2).
         nIObesp = ROUND(nIObesp, 2).

         /* = ����塞 ��稭� ��������� ��.१�ࢠ ======================= */
         IF (nSIzmPrRsrv NE 0)
         THEN DO:
         IF (nPrCred1 EQ 0)
         THEN
            nIPrCred = nSIzmPrRsrv.
         ELSE DO:
            IF    (iVO NE 0)
              AND (nRisk0 EQ nRisk1)
              AND (nObesp0 EQ nObesp1)
              AND (nSIzmRsrv EQ 0)
            THEN
               ASSIGN
                  nIPrProc  = 0
                  nIPrObesp = 0
                  nIPrKurs  = ROUND(nSIzmCrVO * nRisk1 / 100, 2)
                  nIPrCred  = ROUND(nSVydCr   * nRisk1 / 100, 2)
               NO-ERROR.
            ELSE DO:
               /* ��������� ��業� १�ࢨ஢���� */
               IF (nRisk1 NE nRisk0)
               THEN
                  nIPrProc  = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                         (nPrCred0 - nPrObesp0) * nRisk1 / 100.0)
                            - nPrRsrv0.
               /* �뭮� �� ������ */
               IF (nSProsroch NE 0)
               THEN
                  nIPrPros  = - nIPros.
               /* ��襭�� �।�� */
               IF (nSGashPrCr NE 0)
               THEN DO:
                  nIPrCred  = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                         (nPrCred1 - nPrObesp0) * nRisk1 / 100.0)
                              - nPrRsrv0 - nIPrProc - nIPrPros.
                  nVr       = - CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                           (- nSGashPrCr) * nRisk1 / 100.0).
                  IF (ABS(nIPrCred - nVr) LE 0.03)
                  THEN nIPrCred = nVr.
               END.
               /* ��������� ���ᯥ祭�� */
               IF (nPrObesp1 NE nPrObesp0)
               THEN
                  nIPrObesp = CurToRurVO(ttCredOp.ttDogCurr, dOpDate0, iVO, nKursVO,
                                         (nPrCred1 - nPrObesp1) * nRisk1 / 100.0)
                            - nPrRsrv0 - nIPrProc - nIPrPros - nIPrCred.
               /* ��������� ���� */
               IF (ttCredOp.ttDogCurr NE "") AND NOT lFirstStr
               THEN
                  nIPrKurs  = CurToRurVO(ttCredOp.ttDogCurr, ttCredOp.ttOpDate, iVO, nKursVO,
                                         (nPrCred1 - nPrObesp1) * nRisk1 / 100.0)
                            - nPrRsrv0 - nIPrProc - nIPrPros - nIPrCred - nIPrObesp.
            END.
         END.
         END.

         nIPrProc  = ROUND(nIPrProc,  2).
         nIPrCred  = ROUND(nIPrCred,  2).
         nIPrKurs  = ROUND(nIPrKurs,  2).
         nIPrObesp = ROUND(nIPrObesp, 2).

         /* = ����஫� �㬬� ��稭 ��������� १�ࢮ� ======================== */
         nKontRsrv   = nSIzmRsrv - nIKurs - nIProc - nIPros - nIVCred - nIGCred - nIObesp.
         IF (nKontRsrv NE 0)
         THEN DO:
            IF      (nIKurs  NE 0)
            THEN nIKurs  = nIKurs  + nKontRsrv.
            ELSE IF (nIProc  NE 0)
            THEN nIProc  = nIProc  + nKontRsrv.
            ELSE IF (nIObesp NE 0)
            THEN nIObesp = nIObesp + nKontRsrv.
            ELSE IF (nIVCred NE 0)
            THEN nIVCred = nIVCred + nKontRsrv.
            ELSE IF (nIGCred NE 0)
            THEN nIGCred = nIGCred + nKontRsrv.
            ELSE IF (nIPros  NE 0)
            THEN nIPros  = nIPros  + nKontRsrv.
         END.
         nKontPrRsrv = nSIzmPrRsrv - nIPrKurs - nIPrProc - nIPrPros - nIPrCred - nIPrObesp.
         IF (nKontPrRsrv NE 0)
         THEN DO:
            IF      (nIPrKurs  NE 0)
            THEN nIPrKurs  = nIPrKurs  + nKontPrRsrv.
            ELSE IF (nIPrCred  NE 0)
            THEN nIPrCred  = nIPrCred  + nKontPrRsrv.
            ELSE IF (nIPrProc  NE 0)
            THEN nIPrProc  = nIPrProc  + nKontPrRsrv.
            ELSE IF (nIPrObesp NE 0)
            THEN nIPrObesp = nIPrObesp + nKontPrRsrv.
            ELSE IF (nIPrPros  NE 0)
            THEN nIPrPros  = nIPrPros  + nKontPrRsrv.
         END.

         /* = ��ନ஢���� ����� �� ��爧�����ࢠ ============================ */
         cDRRsrvN   = (IF (nIPros    NE 0) THEN ("2_0=" + STRING(- nIPros)    + ",") ELSE "")
                    + (IF (nIVCred   NE 0) THEN ("1_1=" + STRING(nIVCred)     + ",") ELSE "")
                    + (IF (nIGCred   NE 0) THEN ("2_2=" + STRING(- nIGCred)   + ",") ELSE "")
                    + (IF (nIProc    GT 0) THEN ("1_2=" + STRING(nIProc)      + ",") ELSE "")
                    + (IF (nIProc    LT 0) THEN ("2_3=" + STRING(- nIProc)    + ",") ELSE "")
                    + (IF (nIKurs    GT 0) THEN ("1_3=" + STRING(nIKurs)      + ",") ELSE "")
                    + (IF (nIKurs    LT 0) THEN ("2_4=" + STRING(- nIKurs)    + ",") ELSE "")
                    + (IF (nIObesp   GT 0) THEN ("1_4=" + STRING(nIObesp)     + ",") ELSE "")
                    + (IF (nIObesp   LT 0) THEN ("2_5=" + STRING(- nIObesp)   + ",") ELSE "")
                    .
         cDRPrRsrvN = (IF (nIPrPros  NE 0) THEN ("1_0=" + STRING(nIPrPros)    + ",") ELSE "")
                    + (IF (nIPrCred  NE 0) THEN ("2_2=" + STRING(- nIPrCred)  + ",") ELSE "")
                    + (IF (nIPrProc  GT 0) THEN ("1_2=" + STRING(nIPrProc)    + ",") ELSE "")
                    + (IF (nIPrProc  LT 0) THEN ("2_3=" + STRING(- nIPrProc)  + ",") ELSE "")
                    + (IF (nIPrKurs  GT 0) THEN ("1_3=" + STRING(nIPrKurs)    + ",") ELSE "")
                    + (IF (nIPrKurs  LT 0) THEN ("2_4=" + STRING(- nIPrKurs)  + ",") ELSE "")
                    + (IF (nIPrObesp GT 0) THEN ("1_4=" + STRING(nIPrObesp)   + ",") ELSE "")
                    + (IF (nIPrObesp LT 0) THEN ("2_5=" + STRING(- nIPrObesp) + ",") ELSE "")
                    .
         cDRNew     = cDRRsrvN + cDRPrRsrvN.
         cDRRsrvN   = IF (cDRRsrvN   NE "") THEN SUBSTRING(cDRRsrvN,   1, LENGTH(cDRRsrvN)   - 1) ELSE "".
         cDRPrRsrvN = IF (cDRPrRsrvN NE "") THEN SUBSTRING(cDRPrRsrvN, 1, LENGTH(cDRPrRsrvN) - 1) ELSE "".
         cDRNew     = SUBSTRING(cDRNew, 1, LENGTH(cDRNew) - 1).

         /* = �஢��塞 ࠧ���� ��ண� � ������ �� =========================== */
         IF (cVnimanie NE "vvv")
         THEN DO:
            IF (NUM-ENTRIES(cDRPrich) NE NUM-ENTRIES(cDRNew))
            THEN cVnimanie = "***".
            ELSE
               REPEAT I = 1 TO NUM-ENTRIES(cDRPrich):
                  IF (LOOKUP(ENTRY(I, cDRNew), cDRPrich) EQ 0)
                  THEN DO:
                     cVnimanie = "***".
                     LEAVE.
                  END.
               END.
         END.

         /* = �஡㥬 ������� ���� �� ======================================= */
         IF    (cVnimanie NE "")
           AND (cVnimanie NE "vvv")
         THEN DO:
            FOR EACH loan-int
               WHERE (loan-int.cont-code EQ ttCredOp.ttDogNum)
                 AND (loan-int.mdate EQ ttCredOp.ttOpDate)
               NO-LOCK,
               FIRST chowhe
                  WHERE (chowhe.id-d EQ loan-int.id-d)
                    AND (chowhe.id-k EQ loan-int.id-k)
                    AND CAN-DO(cOpListDR, STRING(chowhe.id-op))
                  NO-LOCK,
               FIRST op-entry
                  WHERE (op-entry.op EQ loan-int.op)
                    AND (op-entry.op-entry EQ loan-int.op-entry)
                  NO-LOCK:

               IF    (op-entry.amt-rub EQ ABS(nSIzmRsrv))
                 AND ((chowhe.id-op EQ 32) OR (chowhe.id-op EQ 33))
               THEN cVnimanie = cVnimanie
                              + IF lIsprav THEN
                                (IF UpdateSigns("op-entry", STRING (op-entry.op) + "," + STRING (op-entry.op-entry),
                                                "��爧�����ࢠ", cDRRsrvN, NO)
                                 THEN " !Rs" ELSE " xRs")
                                ELSE " !Rs".
               ELSE
               IF    (op-entry.amt-rub EQ ABS(nSIzmPrRsrv))
                 AND ((chowhe.id-op EQ 136) OR (chowhe.id-op EQ 137))
               THEN cVnimanie = cVnimanie
                              + IF lIsprav THEN
                                (IF UpdateSigns("op-entry", STRING (op-entry.op) + "," + STRING (op-entry.op-entry),
                                                "��爧�����ࢠ", cDRPrRsrvN, NO)
                                 THEN " !Pr" ELSE " xPr")
                                ELSE " !Pr".
            END.
         END.

      END.  /* �᫨ �� ��� �� �� "��⠪�" */

      /* = �����뢠�� ����� ��ப� � 䠩� ���� ========================= */
      cTmpStr = XLCell(ttCredOp.ttDogNum)         /*  1 - �������          */
              + XLDateCell(ttCredOp.ttOpDate)     /*  2 - ���             */
              + XLCell(ttCredOp.ttDogCurr)        /*  3 - Curr             */
              + XLNumCell(FindRateSimple("�������", ttCredOp.ttDogCurr, ttCredOp.ttOpDate))
                                                  /*  4 - Kurs             */
              + XLNumCell(ttCredOp.ttRisk)        /*  5 - % �᪠          */
              + XLNumECell(ttCredOp.ttSumCr)      /*  6 - �㬬� �।��    */
              + XLNumECell(ttCredOp.ttSumPrCr)    /*  7 - �㬬� ��.�।�� */
              + XLNumECell(ttCredOp.ttObesp)      /*  8 - ���ᯥ祭��      */
              + XLNumECell(ttCredOp.ttPrObesp)    /*  9 - ��.���ᯥ祭��   */
              + XLNumECell(ttCredOp.ttSumRsrv)    /* 10 - �㬬� १�ࢠ    */
              + XLNumECell(ttCredOp.ttSumPrRsrv)  /* 11 - �㬬� ��.१�ࢠ */
              + XLCell(cOps)                      /* 12 - ��               */
              + XLNumECell(nSVydCr)               /* 13 - + �।��         */
              + XLNumECell(nSGashCr)              /* 14 - - �।��         */
              + XLNumECell(nSGashPrCr)            /* 15 - - ��.�।��      */
              + XLNumECell(nSIzmCrVO)             /* 16 - +/- �।�₎     */
              + XLNumECell(nSProsroch)            /* 17 - ����窠        */
              + XLNumECell(nSIzmRsrv)             /* 18 - +/- �����       */
              + XLNumECell(nSIzmPrRsrv)           /* 19 - +/- ��.१��    */
              + XLCell(cDRPrich)                  /* 20 - �� ��稭�       */
              + XLCell(cDRRsrvN)                  /* 21 - �� New���        */
              + XLCell(cDRPrRsrvN)                /* 22 - �� New��         */
              + XLCell(cErrAnl)                   /* 23 - ErrDog           */
              + XLCell(cVnimanie)                 /* 24 - !!!              */
              + XLNumECell(nIKurs)                /* 25 - d ����          */
              + XLNumECell(nIProc)                /* 26 - d %              */
              + XLNumECell(nIVCred)               /* 27 - d ��.�।��    */
              + XLNumECell(nIGCred)               /* 28 - d ���.�।��    */
              + XLNumECell(nIPros)                /* 29 - d �뭮��        */
              + XLNumECell(nIObesp)               /* 30 - d ����-�        */
              + XLNumECell(nIPrKurs)              /* 31 - d ��.����       */
              + XLNumECell(nIPrProc)              /* 32 - d ��.%           */
              + XLNumECell(nIPrCred)              /* 33 - d ��.�।��     */
              + XLNumECell(nIPrPros)              /* 34 - d ��.�뭮��     */
              + XLNumECell(nIPrObesp)             /* 35 - d ��.����-�     */
              + XLNumECell(nKontRsrv)             /* 36 - ����஫� ���.    */
              + XLNumECell(nKontPrRsrv)           /* 37 - ����஫� ��.���. */
              .
      IF lFirstStr
      THEN PUT UNFORMATTED XLRow(2) cTmpStr XLRowEnd().
      ELSE PUT UNFORMATTED XLRow(0) cTmpStr XLRowEnd().

      /* = ��७�� �⮣�� �� ᫥������ ���� ================================ */
      ASSIGN
         lFirstStr = FALSE
         dOpDate0  = ttCredOp.ttOpDate
         nCred0    = nCred1
         nPrCred0  = nPrCred1
         nObesp0   = nObesp1
         nRsrv0    = nRsrv1
         nPrRsrv0  = nPrRsrv1
         nRisk0    = nRisk1
      NO-ERROR.

   END.  /* IF LAST-OF(ttOpDate) */
END.     /* FOR EACH ttCredOp */

PUT UNFORMATTED XLRow(2) XLCell("�ᥣ� " + STRING(iNumOE) + " �஢���� � ��.") XLRowEnd().
PUT UNFORMATTED XLEnd().

put screen col 1 row 24 color normal STRING(" ","X(80)").
{intrface.del}

/* ========================================================== */
FUNCTION LnPrincipal2 RETURNS DECIMAL
   (INPUT iContract AS CHAR,
    INPUT iContCode AS CHAR,
    INPUT iDate     AS DATE,
    INPUT iCurrency AS CHAR,
    INPUT CC        AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mLoanCurr  AS CHARACTER NO-UNDO.
   DEF VAR vParamSumm AS DECIMAL   NO-UNDO.
   DEF VAR vDb        AS DECIMAL   NO-UNDO.
   DEF VAR vCr        AS DECIMAL   NO-UNDO.
   DEF VAR vRes       AS DECIMAL   NO-UNDO.
   DEF VAR mResult    AS DECIMAL   NO-UNDO.

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

/* ========================================================== */
FUNCTION CurToRurVO   RETURNS DECIMAL
   (INPUT iCurr      AS CHARACTER,
    INPUT iDate      AS DATE,
    INPUT iVO        AS INTEGER,
    INPUT iKurs      AS DECIMAL,
    INPUT iSumm      AS DECIMAL).

   DEFINE VARIABLE nKursAct AS DECIMAL.

   IF (iSumm LE 0)
   THEN RETURN 0.

   IF (iCurr NE "")
   THEN  nKursAct = FindRateSimple("�������", iCurr, iDate).
   ELSE RETURN iSumm.

   IF (iVO NE 0)
   THEN RETURN iSumm * MAXIMUM(nKursAct, iKurs).
   ELSE RETURN iSumm * nKursAct.
END FUNCTION. /* CurToRurVO  */

/* ========================================================== */
FUNCTION RurToCurVO   RETURNS DECIMAL
   (INPUT iCurr      AS CHARACTER,
    INPUT iDate      AS DATE,
    INPUT iVO        AS INTEGER,
    INPUT iKurs      AS DECIMAL,
    INPUT iSumm      AS DECIMAL).

   DEFINE VARIABLE nKursAct AS DECIMAL.

   nKursAct = FindRateSimple("�������", iCurr, iDate).
   IF (iVO NE 0)
   THEN nKursAct = MAXIMUM(nKursAct, iKurs).

   RETURN (iSumm / nKursAct).

END FUNCTION. /* CurToRurVO  */
