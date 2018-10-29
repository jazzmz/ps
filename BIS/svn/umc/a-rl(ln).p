{pirsavelog.p}
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: a-rl(ln).p
      Comment: �����㬥��� ��� ����祭�� ������ �� ����窥 � ����� � �.�.
   Parameters:
         Uses:
      Used by:
      Created: 19/07/2004 fedm
     Modified: kuntash ��ࠡ�⪠ �� 33 ���� ��� ��
*/

DEF INPUT PARAMETER beg           AS DATE    NO-UNDO. /* ���.��� ��ਮ�� */
DEF INPUT PARAMETER dob           AS DATE    NO-UNDO. /* ���.��� ��ਮ�� */

{globals.i}

{intrface.get xclass}
{intrface.get umc}
{intrface.get date}
{intrface.get xobj}

{a-defs.i}
{a-rl(ln).def}

/* ��� �����⥭⭮� ������⥪� a-obj.p */
DEF VAR ht                        AS HANDLE  NO-UNDO.
/* ��⠭�������� ������⥪� ������� �㭪権 ��� */
RUN a-obj.p  PERSISTENT SET ht ("Main",  "", "").


/* ������ ������⥫�� �� ����窥 ��� */
PROCEDURE CalcCard:
   DEF INPUT PARAMETER iLnRecId   AS RECID   NO-UNDO.
   DEF INPUT PARAMETER iLevel     AS INT     NO-UNDO.
   DEF INPUT PARAMETER iPrmLst    AS CHAR    NO-UNDO.

   DEF BUFFER loan        FOR loan.
   DEF BUFFER asset       FOR asset.
   DEF BUFFER loan-acct   FOR loan-acct.
   DEF BUFFER kau-entry   FOR kau-entry.
   DEF BUFFER tt-val      FOR tt-val.

   /* ����� ������⥫� � ᯨ᪥ */
   DEF VAR vI                     AS INT     NO-UNDO.
   /* ��� ��� ���� ������⥫� */
   DEF VAR vDate                  AS DATE    NO-UNDO.
   /* ��� ��砫� ��ਮ�� ��� ���� ������⥫� */
   DEF VAR vTmpDate               AS DATE    NO-UNDO.
   DEF VAR vTmpSum                AS DEC     NO-UNDO.

   /* ��� �㭪樨 */
   DEF VAR vFun                   AS CHAR    NO-UNDO.
   /* ��� */
   DEF VAR vCod                   AS CHAR    NO-UNDO.
   /* ��� */
   DEF VAR vCod2                  AS CHAR    NO-UNDO.
   /* ������⢮ */
   DEF VAR vQty                   AS DECIMAL NO-UNDO.
   /* ������⢮ */
   DEF VAR vQty2                  AS DECIMAL NO-UNDO.
   /* �㬬� */
   DEF VAR vSum                   AS DECIMAL NO-UNDO.
   /* �㬬� */
   DEF VAR vSum2                  AS DECIMAL NO-UNDO.
   /* ��� ������ */
   DEF VAR vType                  AS CHAR    NO-UNDO.
   /* ��� ������⥫� ��� ���� */
   DEF VAR vCode                  AS CHAR    NO-UNDO.
   /* ��� �६������ �࠭���� ���. ������⥫�� */
   DEF VAR vStrTmp                AS CHAR    NO-UNDO.
   DEF VAR vStrTmp2               AS CHAR    NO-UNDO.
   /* ��᫮ ��� ���� ������⥫� */
   DEF VAR vITmp                  AS INT     NO-UNDO.

   FOR
      FIRST loan WHERE RECID(loan) EQ iLnRecId
        NO-LOCK,
      FIRST asset OF loan
        NO-LOCK:

      IF     mNullStr
         AND GetLoan-Pos(loan.contract,
                         loan.cont-code,
                         "-���",
                         dob) EQ 0 THEN
         NEXT.

      IF VALID-HANDLE(ht) THEN
         RUN Change IN ht (loan.contract, loan.cont-code, ?, "").

      /* ��ॡ�� ������⥫��, ����� ����室��� ������� */
      DO vI = 1 TO NUM-ENTRIES(iPrmLst):

         FIND FIRST tt-prm   WHERE
                    tt-prm.code EQ ENTRY(vI, iPrmLst)
            NO-LOCK NO-ERROR.

         IF NOT AVAILABLE tt-prm THEN
            NEXT.

         CREATE tt-val.
         ASSIGN tt-val.code      = tt-prm.code
                tt-val.surrogate = loan.contract + "," + loan.cont-code
                tt-val.level     = iLevel.

         ASSIGN
            vCode = TRIM(tt-val.code, "#")
            vType = "CHAR".

         IF tt-val.code MATCHES "*(*)" THEN
            RUN VALUE(ENTRY(1, tt-val.code, "("))
               (OUTPUT vSum,
                       beg,
                       dob,
                       TRIM(SUBSTR(tt-val.code,
                                   INDEX(tt-val.code,
                                   "(") + 1
                                  ), ")")
                     + "|" + STRING(iLnRecId)

               ) NO-ERROR.
         ELSE
         CASE vCode:
            WHEN "�"         THEN
            DO:
               ASSIGN
                  vType      = "INT"
                  mCntLin    = mCntLin + 1
                  tt-val.val = STRING(mCntLin).

               IF GetSysConf("SUBTOT:�") EQ ?
               THEN DO:
                  RUN SetSysConf IN h_base ("SUBTOT:�" , "1").
                  RUN SetSysConf IN h_base ("SUBTYPE:�", "INT").
               END.

               ELSE
                  RUN SetSysConf IN h_base ("SUBTOT:�",
                                            STRING(INT(GetSysConf("SUBTOT:�"))
                                                 + 1)).
               IF mLastLn THEN
                  RUN SetSysConf IN h_base ("TOT:�", tt-val.val).
            END.

            WHEN "�����"    THEN
                tt-val.val   = loan.contract.

            WHEN "����"      THEN
                tt-val.val   = loan.doc-ref.

            WHEN "�������"   THEN
                tt-val.val   = loan.cont-type.

            WHEN "��������"  THEN
                tt-val.val   = GetObjName("asset", GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)), YES).

            WHEN "�����"     THEN
                tt-val.val   = asset.unit.

            WHEN "������"    THEN
               ASSIGN
                  vType      = "DECIMAL"
                  tt-val.val = STRING(GetCostUMC(loan.contract + CHR(6)
                                               + loan.cont-code,
                                                 dob,
                                                 "",
                                                 ""
                                                )
                                     ).
            WHEN "������ਭ"
            THEN DO:
              vDate          = GetInDate (loan.contract,
                                          loan.cont-code,
                                          "�"
                                         ).
              FIND FIRST kau-entry      WHERE
                         kau-entry.op-date EQ     vDate
                     AND kau-entry.kau     BEGINS loan.contract + ","
                                                + loan.cont-code
                     AND kau-entry.debit   EQ     YES
                     AND kau-entry.kau-id  EQ     "���-���"
                 NO-LOCK NO-ERROR.

              IF AVAILABLE kau-entry THEN
              DO:
                 FIND FIRST op OF kau-entry NO-LOCK NO-ERROR.
                 IF AVAILABLE op THEN
                    tt-val.val = op.doc-num.
              END.
            END.
            WHEN "��⠏��"  THEN
               ASSIGN
                  tt-val.val = STRING(GetInDate (loan.contract,
                                                 loan.cont-code,
                                                 "�"
                                                ),
                                      "99.99.9999"
                                     ).

            WHEN "��⠂�"   THEN
            DO:
               RUN GetLoanDate IN h_umc (loan.contract,
                                         loan.cont-code,
                                         "-���",
                                         "Out",
                                         OUTPUT vTmpDate,
                                         OUTPUT vTmpSum
                                        ).
               ASSIGN
                  tt-val.val = STRING(vTmpDate,
                                      "99.99.9999"
                                     ).
               IF tt-val.val EQ "01.01.0001" THEN
                  tt-val.val = STRING(loan.close-date, "99.99.9999").
            END.

            WHEN "���ப���2" THEN
               ASSIGN
                  vType = "INT"
                  vDate = GetInDate (loan.contract,
                                     loan.cont-code,
                                     "�"
                                    )
                  vITmp = INT(GetXattrValue("loan",
                                            loan.contract + ","
                                          + loan.cont-code,
                                            "�ப��ᯫ"
                                           )
                             )
                  vITmp = vITmp + IF    vDate EQ 01/01/0001
                                     OR vDate EQ 01/01/9999 THEN
                                     0
                                  ELSE
                                     INT(MonInPer(vDate,
                                                  DATE(GetEntries(1,
                                                                  pick-value,
                                                                  "-",
                                                                  STRING(vDate)
                                                                 ))))
                  tt-val.val = IF    vITmp EQ ?
                                  OR vITmp EQ 0
                               THEN ""
                               ELSE STRING(vITmp)
               .


            /* �����ࠫ�� ������⥫� �� ⠡���� �����ᨩ */
            WHEN "����" OR
            WHEN "����" OR
            WHEN "���"  OR
            WHEN "���"  THEN
               ASSIGN
                  vType      = (IF vCode BEGINS "���"
                                THEN "INT"
                                ELSE "DECIMAL"
                               )
                  tt-val.val = STRING(GetSrokAmor(RECID(loan),
                                                  vCode,
                                                  dob
                                                 )
                                     ).

            WHEN "���" OR
            WHEN "���" THEN
               ASSIGN
                  vType      = "DECIMAL"
                  tt-val.val = STRING(ROUND(GetAmortNorm(loan.contract,
                                                         loan.cont-code,
                                                         dob,
                                                         SUBSTR(vCode, 3, 1)
                                                        ),
                                            2
                                           )
                                     ).
            WHEN "����" OR
            WHEN "���"  THEN
            DO:
               ASSIGN
                  vType      = "INT"
                  tt-val.val = GetXAttrValueEx("asset",
                                               loan.cont-type,
                                               "AmortGrMSFO",
                                               ""
                                              )
                  tt-val.val = GetCode ("����_������",
                                        tt-val.val
                                       ).

               IF vCode EQ "���" THEN
                  ASSIGN
                     vType      = "DECIMAL"
                     tt-val.val = STRING(ROUND(100 / INT(tt-val.val), 2)).
            END.

            WHEN "�㬍��" THEN
            DO:
               ASSIGN
                  vType      = "DECIMAL"
                  tt-val.val = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               "�㬬����",
                                               "?"
                                              ).
               IF tt-val.val EQ "?" THEN
                  ASSIGN
                     tt-val.val = GetXAttrValueEx("loan",
                                                  loan.contract + ","
                                                + loan.cont-code,
                                                  "���",
                                                  "0"
                                                 )
                     tt-val.val = STRING(GetLoan-Pos (loan.contract,
                                                      loan.cont-code,
                                                      "-���",
                                                      01/01/0001
                                                     ) * DECIMAL(tt-val.val)
                                                / (100 + DECIMAL(tt-val.val))
                                        ).
            END.

            WHEN "������" THEN /* ���� �த��� ����� ����筠� �⮨����� */
            DO:
               RUN GetLoanDate IN h_umc (loan.contract,
                                         loan.cont-code,
                                         "-���",
                                         "Out",
                                         OUTPUT vTmpDate,
                                         OUTPUT vTmpSum
                                        ).
               RUN GetAmtUMC (loan.contract,
                              loan.cont-code,
                              vTmpDate - 1,
                              OUTPUT vSum,
                              OUTPUT vQty
                             ).
               ASSIGN
                  vType      = "DECIMAL"
                  vSum       = DECIMAL(GetXAttrValueEx("loan",
                                                       loan.contract + ","
                                                     + loan.cont-code,
                                                       "�����த���",
                                                       "0"
                                                      )
                                      ) - vSum
                  tt-val.val = STRING(vSum).
            END.

            WHEN "�������" THEN
            DO:
               vType = "CHAR".
               RUN VALUE("�⤥�") IN ht (dob, OUTPUT tt-val.val)    NO-ERROR.
            END.

            WHEN "��������" THEN
            DO:
               vType = "CHAR".
               RUN VALUE("�⤥�") IN ht (dob, OUTPUT tt-val.val)    NO-ERROR.
               IF ERROR-STATUS:ERROR EQ NO THEN
                  tt-val.val = GetObjName("branch", tt-val.val, NO) NO-ERROR.
            END.
            WHEN "���" THEN
            DO:
               vType = "INT".
               RUN VALUE("���⢥�") IN ht (dob, OUTPUT vQty)       NO-ERROR.
               IF ERROR-STATUS:ERROR EQ NO THEN
                  tt-val.val = STRING(vQty) NO-ERROR.
            END.

            WHEN "����" THEN
            DO:
               ASSIGN
                  vType      = "CHAR"
                  vStrTmp    = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               "����",
                                               "")
                  tt-val.val = IF vStrTmp EQ ""
                               THEN "�� ����������"
                               ELSE GetCodeName("����", vStrTmp)
               .
            END.

            WHEN "������" THEN
            DO:
               vType = "CHAR".
               RUN VALUE("���⢥�") IN ht (dob, OUTPUT vQty)       NO-ERROR.
               IF ERROR-STATUS:ERROR EQ NO THEN
                  tt-val.val = GetObjName("employee",
                                          shFilial + "," + STRING(vQty),
                                          NO)                       NO-ERROR.
            END.

            WHEN "����" THEN
            DO:
               ASSIGN
                  vType   = "CHAR"
                  vStrTmp = GetLast-Kau(loan.contract,
                                        loan.cont-code,
                                        GetSysConf("in-dt:RoleSfx"),
                                        dob
                                       )
               .

               IF vStrTmp NE ?
               THEN DO:
                  vStrTmp2 = ENTRY(2,GetKauItem("���",
                                                vStrTmp,
                                                "���-���"
                                               )
                                  ).
                  IF vStrTmp2 NE "?" THEN
                     ASSIGN
                        tt-val.val = GetObjName("employee",
                                                shFilial + "," + vStrTmp2, NO)
                     .
               END.
            END.

            WHEN "���"  THEN
                 tt-val.val = STRING(asset.precious-1).
            WHEN "���" THEN
                 tt-val.val = STRING(asset.precious-2).
            WHEN "����" THEN
                 tt-val.val = STRING(asset.precious-3).
            WHEN "���"  THEN
                 tt-val.val = STRING(asset.precious-4).

            WHEN "�㬬�����" THEN
            DO:
               ASSIGN
                  vType = "DECIMAL"
                  vDate = GoMonth(FirstMonDate(dob), 1)
                  vSum  = 0
               .
               RUN VALUE("�㬬�����") IN ht (vDate, OUTPUT vSum) NO-ERROR.

               IF    ERROR-STATUS:ERROR
                  OR vSum      EQ 0 THEN
               DO:
                  RUN GetYearAmortNorm IN h_umc (       loan.contract,
                                                        loan.cont-code,
                                                        vDate,
                                                        "�",
                                                 OUTPUT vSum
                                                ).
                  vSum = ROUND(GetCostUMC(loan.contract + CHR(6)
                                        + loan.cont-code,
                                          dob,
                                          "",
                                          ""
                                         ) * vSum / 1200, 2).

               END.
               tt-val.val = STRING(vSum).
            END.

            WHEN "������-���" THEN
               ASSIGN
                  tt-val.val = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               "����������",
                                               loan.cont-type
                                              )
                  vType      = GetXAttrEx     (loan.class-code,
                                               vCode,
                                               "Data-Type"
                                              ).

            /* ��� ��⠫쭮� */
            OTHERWISE
            DO:
               ASSIGN
                  vFun  = ENTRY(1, vCode, "-")
                  vCod2 = ""
               .
               /* �������騩 �� ���� ���, �ਢ易��� �� ஫�
               ** ���ਬ��, ��-��� - ��� ���.
               */
               IF vFun EQ "��" THEN
               FOR LAST loan-acct OF loan WHERE
                        loan-acct.acct-type  EQ loan.contract + SUBSTR(vCode, 3)
                    AND loan-acct.since      LE dob
                  NO-LOCK:
                  tt-val.val  = DelFilFromAcct(loan-acct.acct).
               END.
               /* ����� ������⥫� �� ����窥
               ** {�㭪��}{�|�}-{���䨪� ஫�}[��|��]-{���. ����䨪����}, ���:
               ** �㭪��:
               ** �� - ��ࢮ��砫쭠� �⮨�����
               ** �� - ���⮪ �� ����窥
               ** �� - ����筠� �⮨�����
               ** �� - ����⮢� ������
               ** �� - �।�⮢� ������
               **
               ** ��筥��� �㭪樨:
               ** �  - ������⢮
               ** �  - �㬬�
               **
               ** ���䨪� ஫�: ���, ����, ���,..
               **
               ** ���. ����䨪����
               ** �  - 䠪��᪮� ���祭��. ���. ४����� "���������"
               ** �  - �८�ࠧ����� ���� � ᫮��. �ᯮ������ � a-rl(ln).def
               **
               ** ����䨪��� ����:
               ** �� - �� ��砫� ����� ���⭮� ����
               ** �� - �� ��砫� ���� ���⭮� ����
               ** �� - �� ��砫� ��砫 (���� ��ࢮ� �஢����)
               */
               ELSE IF CAN-DO("��.,��.,��.,��.", vFun) AND
                    vCode NE "���-��" THEN
               DO:
                  /* ���䨪� ஫� ��-㬮�砭�� "-���" */
                  vCod = IF vCode EQ vFun
                         THEN "-���"
                         ELSE SUBSTR(vCode, LENGTH(vFun) + 2).

                  /* ���࠭塞 ���. ����䨪��� */
                  IF vCod MATCHES "*-�*" THEN
                     ASSIGN
                        vCod2 = vCod
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2)
                     .
                  IF      vCod MATCHES "*��" THEN
                     ASSIGN
                        vDate = DATE(MONTH(dob), 1, YEAR(dob))
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*��" THEN
                     ASSIGN
                        vDate = DATE(1, 1, YEAR(dob))
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*��" THEN
                     ASSIGN
                        vDate = beg
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*��" THEN
                     ASSIGN
                        vDate = 01/01/0001
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE IF vCod MATCHES "*��" THEN
                     ASSIGN
                        vDate = ?
                        vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).
                  ELSE
                     ASSIGN
                        vDate = dob.

                  CASE SUBSTR(vFun, 1, 2):
                     WHEN "��" THEN
                       RUN VALUE("GetLoanPos" + (IF vDate = ? THEN "-" ELSE ""))
                                      (       loan.contract,
                                              loan.cont-code,
                                              vCod,
                                              vDate,
                                       OUTPUT vSum,
                                       OUTPUT vQty
                                      ).
                     WHEN "��" THEN DO:
                       RUN VALUE("GetLoanPos" + (IF vDate = ? THEN "-" ELSE ""))
                                      (       loan.contract,
                                              loan.cont-code,
                                              "-���",
                                              vDate,
                                       OUTPUT vSum,
                                       OUTPUT vQty
                                      ).
                       RUN VALUE("GetLoanPos" + (IF vDate = ? THEN "-" ELSE ""))
                                      (       loan.contract,
                                              loan.cont-code,
                                              "-����",
                                              vDate,
                                       OUTPUT vSum2,
                                       OUTPUT vQty2
                                      ).
                       vSum = vSum - vSum2.
                     END.
                     WHEN "��" OR
                     WHEN "��" THEN
                        RUN GetLoanTurn(       loan.contract,
                                               loan.cont-code,
                                               vCod,
                                               "",
                                               beg,
                                               vDate,
                                               (vFun BEGINS "�"),
                                        OUTPUT vSum,
                                        OUTPUT vQty
                                       ).
                  END CASE.

                  IF     vCod2                     MATCHES "*-�*"
                     AND GetSysConf("in-dt:absen") EQ      "YES"
                     AND CAN-DO("��, Yes, True",
                                GetXattrValueEx("Loan",
                                Work-Module + ","
                              + Loan.Cont-Code,
                                "���������",
                                ""             )
                               ) THEN
                     ASSIGN
                        vQty = 0
                        vSum = 0
                     .

                  IF SUBSTR(vFun, 3, 1) EQ "�" THEN
                     ASSIGN
                        vType      = "INT"
                        tt-val.val = STRING(vQty).
                  ELSE
                     ASSIGN
                        vType      = "DECIMAL"
                        tt-val.val = STRING(vSum).
               END.

               ELSE IF CAN-DO("�����,����,����",vCode) THEN
                  FOR EACH  kau-entry            WHERE
                            kau-entry.kau-id        EQ "���-���"
                        AND kau-entry.kau           BEGINS loan.contract + "," +
                                                           loan.cont-code + ","
                        AND kau-entry.op-date       LE dob
                        AND kau-entry.debit         EQ NO
                     NO-LOCK,
                     FIRST op-entry OF kau-entry WHERE
                           op-entry.acct-cr         EQ     kau-entry.acct
                       AND op-entry.acct-db         BEGINS "612"
                        NO-LOCK,
                     FIRST op OF op-entry
                        NO-LOCK
                     BY kau-entry.op-date DESC
                     BY kau-entry.op      DESC:

                     ASSIGN
                        vType      = "CHAR"
                        vType      = "DATE" WHEN vCode EQ "����"
                     .
                     CASE vCode:
                        WHEN "�����" THEN
                           RUN GetDocTypeName IN h_op
                              (
                                 INPUT op.doc-type
                              , OUTPUT tt-val.val
                              ) .
                        WHEN "����"  THEN
                           tt-val.val = STRING(op-entry.op-date,"99/99/9999").
                        WHEN "����"  THEN
                           tt-val.val = ", " + op.doc-num.
                     END CASE.
                     LEAVE.
                  END.
               ELSE IF CAN-DO("�������,������,������",vCode) THEN
                  FOR EACH  kau-entry      WHERE
                            kau-entry.kau-id  EQ "���-���"
                        AND kau-entry.kau     BEGINS loan.contract + "," +
                                                     loan.cont-code + ","
                        AND kau-entry.op-date LE dob
                        AND     CAN-FIND (FIRST op       OF kau-entry NO-LOCK)
                        AND NOT CAN-FIND (FIRST op-entry OF kau-entry NO-LOCK)
                        NO-LOCK,
                     FIRST op OF kau-entry
                        NO-LOCK
                     BY kau-entry.op-date DESC
                     BY kau-entry.op      DESC:

                     ASSIGN
                        vType      = "CHAR"
                        vType      = "DATE" WHEN vCode EQ "������"
                     .
                     CASE vCode:
                        WHEN "�������" THEN
                           RUN GetDocTypeName IN h_op
                              (
                                 INPUT op.doc-type
                              , OUTPUT tt-val.val
                              ) .
                        WHEN "������"  THEN
                           tt-val.val = STRING(kau-entry.op-date,"99/99/9999").
                        WHEN "������"  THEN
                           tt-val.val = ", " + op.doc-num.
                     END CASE.
                     LEAVE.
                  END.
               /* ��� ���.४����� ����窨:
               **    �ப��ᯫ, ���
               ** ��� 業����:
               **    ������
               ** ��� ������⥫� �� ��ࢮ� ����⮢�� �㡯஢����
               */
               ELSE
               DO:
                  ASSIGN
                     tt-val.val = GetXAttrValueEx("loan",
                                                  loan.contract + ","
                                                + loan.cont-code,
                                                  vCode,
                                                  "?"
                                                 )
                     vType      = GetXAttrEx     (loan.class-code,
                                                  vCode,
                                                  "Data-Type"
                                                 ).

                  IF tt-val.val EQ "?" THEN
                     ASSIGN
                        tt-val.val = GetXAttrValueEx("asset",
                                                     loan.cont-type,
                                                     vCode,
                                                     "?"
                                                    )
                        vType      = GetXAttrEx     ("asset",
                                                     vCode,
                                                     "Data-Type"
                                                    ).

                  IF NOT CAN-DO("INTEGER,DECIMAL", vType) THEN
                     vType = "CHAR".

                  /* ������ ������⥫� �� ��ࢮ� ����⮢�� �㡯஢���� */
                  IF tt-val.val EQ "?" THEN
                  DO:
                     IF mKEType EQ "ᯨ�" THEN
                     FOR EACH  kau-entry      WHERE
                               kau-entry.kau-id  EQ     "���-���"
                           AND kau-entry.kau     BEGINS loan.contract + "," +
                                                        loan.cont-code + ","
                           AND kau-entry.debit   EQ     NO
                           AND kau-entry.op-date LE     dob
                        NO-LOCK
                        BY kau-entry.kau-id
                        BY kau-entry.op-date DESCENDING
                        BY kau-entry.op      DESCENDING:

                        RUN CalcKE IN hLn (RECID(kau-entry),
                                           iLevel + 1,
                                           tt-val.code
                                          ).
                        LEAVE.
                     END.
                     ELSE
                     FOR EACH  kau-entry      WHERE
                               kau-entry.kau-id  EQ "���-���"
                           AND kau-entry.kau     BEGINS loan.contract + "," +
                                                        loan.cont-code + ","
                           AND kau-entry.debit   EQ YES
                           AND kau-entry.op-date LE dob
                        NO-LOCK
                        BY kau-entry.kau-id
                        BY kau-entry.op-date
                        BY kau-entry.op:

                        RUN CalcKE IN hLn (RECID(kau-entry),
                                           iLevel + 1,
                                           tt-val.code
                                          ).
                        LEAVE.
                     END.
                  END.
               END.
            END.
         END CASE.

         /* �����, ����।����, ��㤠筮 ���᫥��� ������⥫� 㤠�塞 */
         IF    tt-val.val EQ ""
            OR tt-val.val EQ "?"
            OR tt-val.val EQ ? THEN
            DELETE tt-val.
         ELSE
         DO:
            tt-val.type = vType.
            RELEASE tt-val.
         END.

         IF tt-prm.class EQ "" THEN
            ASSIGN
               tt-prm.class  = "loan"
               tt-prm.level  = iLevel.
      END.
   END.

   RETURN.

END PROCEDURE.

/* ������ ������⥫�� �� �㡯஢���� ����窨 ��� */
PROCEDURE CalcKE:
   DEF INPUT PARAMETER iKERecId   AS RECID   NO-UNDO.
   DEF INPUT PARAMETER iLevel     AS INT     NO-UNDO.
   DEF INPUT PARAMETER iPrmLst    AS CHAR    NO-UNDO.

   DEF BUFFER acct        FOR acct.
   DEF BUFFER loan        FOR loan.
   DEF BUFFER xloan       FOR loan.
   DEF BUFFER kau-entry   FOR kau-entry.
   DEF BUFFER op-entry    FOR op-entry.
   DEF BUFFER tt-val      FOR tt-val.

   DEF BUFFER op          FOR op.
   DEF BUFFER xop         FOR op.
   DEF BUFFER xkau-entry  FOR kau-entry.
   DEF BUFFER xloan-acct  FOR loan-acct.

   /* ����� ������⥫� � ᯨ᪥ */
   DEF VAR vI                     AS INT     NO-UNDO.
   /* ��᫮ ��� ���� ������⥫� */
   DEF VAR vITmp                  AS INT     NO-UNDO.
   /* ��� ��� ���� ������⥫� */
   DEF VAR vDate                  AS DATE    NO-UNDO.
   /* ��� �㭪樨 */
   DEF VAR vFun                   AS CHAR    NO-UNDO.
   /* ��� */
   DEF VAR vCod                   AS CHAR    NO-UNDO.
   /* ������⢮ */
   DEF VAR vQty                   AS DECIMAL NO-UNDO.
   /* �㬬� */
   DEF VAR vSum                   AS DECIMAL NO-UNDO.
   DEF VAR vSum2                  AS DECIMAL NO-UNDO.
   /* ��� ������ */
   DEF VAR vType                  AS CHAR    NO-UNDO.
   /* ��� �㡯஢���� */
   DEF VAR vKEType                AS CHAR    NO-UNDO.
   /* ��� ������⥫� ��� ���� */
   DEF VAR vCode                  AS CHAR    NO-UNDO.
   /* ������ � ���᫥��� ����⨧�樨 */
   DEF VAR vOp                    AS INT     NO-UNDO.

   FIND FIRST kau-entry WHERE RECID(kau-entry) EQ iKERecId
      NO-LOCK NO-ERROR.

   IF NOT AVAILABLE kau-entry THEN
      RETURN.

   vOp = kau-entry.op.

   FIND FIRST loan        WHERE
              loan.contract  EQ ENTRY(1, kau-entry.kau)
          AND loan.cont-code EQ ENTRY(2, kau-entry.kau)
      NO-LOCK NO-ERROR.

   IF NOT AVAILABLE loan THEN
      RETURN.
   FIND FIRST asset OF loan NO-LOCK NO-ERROR.

   vKEType = GetKEType(BUFFER kau-entry).

   /* ��ॡ�� ������⥫��, ����� ����室��� ������� */
   DO vI = 1 TO NUM-ENTRIES(iPrmLst):

      FIND FIRST tt-prm   WHERE
                 tt-prm.code EQ ENTRY(vI, iPrmLst)
         NO-LOCK NO-ERROR.

      IF NOT AVAILABLE tt-prm THEN
         NEXT.

      CREATE tt-val.
      ASSIGN tt-val.code      = tt-prm.code
             tt-val.surrogate =      STRING(kau-entry.op)
                              + ","+ STRING(kau-entry.op-entry)
                              + ","+ STRING(kau-entry.kau-entry)
             tt-val.level     = iLevel.

     ASSIGN
        vCode = TRIM(tt-val.code, "#")
        vType = "CHAR".

      CASE vCode:
         WHEN "�" THEN
            ASSIGN
               vType      = "INT"
               mCntLin    = mCntLin + 1
               tt-val.val = STRING(mCntLin).

         WHEN "���"   THEN
             tt-val.val  = vKEType.

         WHEN "����"     THEN
             tt-val.val  = loan.doc-ref.
         WHEN "���������" THEN DO:
             FOR FIRST xop WHERE
                       xop.op EQ vOp
             NO-LOCK:
                tt-val.val  = GetInvNumSrc(RECID(xop)).
             END.
         END.
         WHEN "��������" THEN
             tt-val.val  = GetObjName("asset", GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)), YES).
         WHEN "���ப��ᯫ" THEN
            ASSIGN
               vDate = GetInDate (loan.contract,
                                  loan.cont-code,
                                  "�"
                                 )
               vITmp = INT(GetXattrValue("loan",
                                       loan.contract + "," + loan.cont-code,
                                       "�ப��ᯫ"
                                      )
                        )
               vITmp = vITmp + IF    vDate EQ 01/01/0001
                                  OR vDate EQ 01/01/9999 THEN
                                  0
                               ELSE
                                  INT(MonInPer(vDate,kau-entry.op-date))
               tt-val.val = IF vITmp EQ ? OR vITmp EQ 0 THEN ""
                            ELSE STRING(vITmp)
            .
         WHEN "��⠏��" THEN
            ASSIGN
               tt-val.val  = STRING(GetInDate (loan.contract,
                                               loan.cont-code,
                                               "�"
                                              ),
                                    "99.99.9999"
                                   ).

         WHEN "��ઠ�" THEN DO:
            tt-val.val = GetXattrValue("loan",
                                       loan.contract + "," + loan.cont-code,
                                       "��ઠ"
                                      ).

            {additem2.i
            tt-val.val
            "GetXattrValue('loan',loan.contract + ',' + loan.cont-code,'����')" ", "
            }
            ASSIGN tt-val.val = TRIM(tt-val.val)
                   tt-val.val = TRIM(tt-val.val,",")
            .
         END.
         WHEN "�����"    THEN
             tt-val.val  = asset.unit.
         WHEN "������"    THEN
            ASSIGN
               vType      = "DECIMAL"
               tt-val.val = STRING(GetCostUMC(loan.contract + CHR(6)
                                            + loan.cont-code,
                                              dob,
                                              "",
                                              ""
                                             )
                                  ).

         WHEN "���"  THEN
              tt-val.val = STRING(asset.precious-1).
         WHEN "���" THEN
              tt-val.val = STRING(asset.precious-2).
         WHEN "����" THEN
              tt-val.val = STRING(asset.precious-3).
         WHEN "���"  THEN
              tt-val.val = STRING(asset.precious-4).
         WHEN "�������" THEN
         DO:
            IF vKEType EQ "���" THEN
               tt-val.val  = "(��८業��)".
            ELSE IF vKEType EQ "���" THEN
            FOR FIRST op-entry OF kau-entry
               NO-LOCK:
               IF op-entry.acct-cr BEGINS "701" THEN
                  tt-val.val  = "(����祭� ������������)".
            END.
            tt-val.val = GetObjName("asset", loan.cont-type, YES) + tt-val.val.
         END.

         WHEN "���" THEN
            tt-val.val  = STRING(kau-entry.op-date, "99.99.9999").

         WHEN "���-��" THEN
            ASSIGN
               vType      = "DECIMAL"
               tt-val.val = STRING(kau-entry.qty).
         WHEN "�㬬�"  THEN

         DO:
/*
            ASSIGN
               vType      = "DECIMAL"
               vSum       = (IF kau-entry.debit
                             THEN   kau-entry.amt-rub
                             ELSE - kau-entry.amt-rub
                            ).
            FOR FIRST acct WHERE
                      acct.acct     = kau-entry.acct
                 AND  acct.currency = kau-entry.currency
                 AND  acct.side     = "�"
               NO-LOCK:
               vSum = - vSum.
            END.
*/
            ASSIGN
               vType      = "DECIMAL"
               vSum       = ABS(kau-entry.amt-rub)
               tt-val.val = STRING(vSum)
            .
         END.

         WHEN "�㬬���"  THEN

         DO:
            ASSIGN
               vType      = "DECIMAL"
               vSum       = ABS(kau-entry.amt-rub / kau-entry.qty)
               tt-val.val = STRING(vSum)
            .
         END.
         WHEN "����"
         THEN DO:

            FIND FIRST xop WHERE xop.op EQ vOp NO-LOCK NO-ERROR.

            IF AVAIL xop THEN
               FOR
                  EACH  op                WHERE
                        op.op-trans          EQ xop.op-trans
                        NO-LOCK ,
                  LAST  xloan-acct        WHERE
                        xloan-acct.contract  EQ loan.contract
                    AND xloan-acct.cont-code EQ loan.cont-code
                    AND xloan-acct.acct-type EQ loan.contract + "-����"
                    AND xloan-acct.since     LE op.op-date
                        NO-LOCK,

                   EACH xkau-entry OF op  WHERE
                        xkau-entry.acct      EQ xloan-acct.acct
                    AND xkau-entry.currency  EQ xloan-acct.currency
                        NO-LOCK
                  :

                  vSum2 = vSum2 + (IF xkau-entry.debit
                                   THEN
                                      xkau-entry.amt-rub
                                   ELSE
                                      (- xkau-entry.amt-rub)
                                  ).

               END.

            ASSIGN
               vType      = "DECIMAL"
               tt-val.val = STRING(vSum2)
            .

         END.

         WHEN "���"
         THEN DO:
            ASSIGN
               vType      = "DECIMAL"
               vSum       = vSum - vSum2
               tt-val.val = STRING(vSum)
            .

         END.

         WHEN "�䏥�" THEN
         DO:
            vType = "DECIMAL".

            FIND FIRST asset OF loan NO-LOCK NO-ERROR.

            FIND FIRST instr-rate                        WHERE
                       instr-rate.instr-cat                 EQ "overcode"
                   AND ENTRY(1, instr-rate.instr-code, "/") EQ asset.commission
                   AND instr-rate.since                     GE loan.open-date
               NO-LOCK NO-ERROR.

            IF     AVAIL instr-rate
               AND NUM-ENTRIES(instr-rate.instr-code, "/") GT 1
               AND NOT CAN-DO(ENTRY(2, instr-rate.instr-code, "/"),
                              STRING(kau-entry.op)) THEN
               RELEASE instr-rate.

            IF NOT AVAIL instr-rate THEN
            FOR EACH instr-rate        WHERE
                     instr-rate.instr-cat EQ "overcode"
                 AND instr-rate.since     GE loan.open-date
               NO-LOCK:

               IF NUM-ENTRIES(instr-rate.instr-code, "/") GT 1 THEN

                  IF CAN-DO(ENTRY(1, instr-rate.instr-code, "/"),
                            asset.commission
                           ) AND
                     CAN-DO(ENTRY(2, instr-rate.instr-code, "/"),
                            STRING(kau-entry.op)
                           ) THEN
                     tt-val.val = STRING(instr-rate.rate-instr) .
            END.

            IF AVAILABLE instr-rate THEN
               tt-val.val = STRING(instr-rate.rate-instr) .
         END.

         WHEN "�����⮨�" THEN
         DO:
            vType = "DECIMAL".
            RUN VALUE("�����⮨�") IN ht (kau-entry.op-date, OUTPUT vSum) NO-ERROR.
            tt-val.val = STRING(vSum).
         END.
         WHEN "�����⮨�2" THEN
         DO:
            vType = "DECIMAL".
            RUN VALUE("�����⮨�") IN ht (DATE(GetEntries(       1,
                                                                  pick-value,
                                                                  "-",
                                                                  STRING(vDate))),
                                                           OUTPUT vSum) NO-ERROR.
            tt-val.val = STRING(vSum).
         END.

         WHEN "������-���" THEN
            ASSIGN
               tt-val.val = GetXAttrValueEx("loan",
                                            loan.contract + ","
                                          + loan.cont-code,
                                            "����������",
                                            loan.cont-type
                                           )
               vType      = GetXAttrEx     (loan.class-code,
                                            vCode,
                                            "Data-Type"
                                           ).

         /* ��� ��⠫쭮� */
         OTHERWISE
         DO:
            vFun = ENTRY(1, vCode, "-").

            /* ����� ������⥫� �� ����窥
            ** {�㭪��}{�|�}-{���䨪� ஫�}[��|��] , ���:
            ** �㭪��:
            ** �� - ��ࢮ��砫쭠� �⮨�����
            ** �� - ���⮪ �� ����窥
            ** �� - ����筠� �⮨�����
            ** �� - ����⮢� ������
            ** �� - �।�⮢� ������
            **
            ** ��筥��� �㭪樨:
            ** �  - ������⢮
            ** �  - �㬬�
            **
            ** ���䨪� ஫�: ���, ����, ���,..
            **
            ** ����䨪��� ����:
            ** �� - �� ���� ���भ� �㡯஢����
            */
            IF     CAN-DO("��.,��.,��.", vFun)
               AND vKEType NE "���"
               AND vCode   NE "���-��" THEN
            DO:
               vCod = SUBSTR(vCode, LENGTH(vFun) + 2).

               ASSIGN
                  vDate = kau-entry.op-date
                  vCod  = SUBSTR(vCod, 1, LENGTH(vCod) - 2).

               CASE SUBSTR(vFun, 1, 2):
                  WHEN "��" THEN
                     RUN GetLoanPos (       loan.contract,
                                            loan.cont-code,
                                            vCod,
                                            vDate,
                                     OUTPUT vSum,
                                     OUTPUT vQty
                                    ).
                  WHEN "��" OR
                  WHEN "��" THEN
                     RUN GetLoanTurn(       loan.contract,
                                            loan.cont-code,
                                            vCod,
                                            "",
                                            beg,
                                            vDate,
                                            (vFun BEGINS "�"),
                                     OUTPUT vSum,
                                     OUTPUT vQty
                                    ).
 /* ��������� kuntash ��� ���᫥��� ����筮� �⮨���� */
                  WHEN "��" THEN 
                  		 DO:	
                       RUN GetLoanPos (       loan.contract,
                                            loan.cont-code,
                                            "���",
                                            vDate - 1,
                                     OUTPUT vSum,
                                     OUTPUT vQty
                                    ).
 
                      RUN GetLoanPos (       loan.contract,
                                            loan.cont-code,
                                            "����",
                                            vDate - 1,
                                     OUTPUT vSum2,
                                     OUTPUT vQty
                                    ).
                   		 vSum = vSum - vSum2.             
                       END.         
/* ---------------------------------------------------- */ 
               END CASE.

               IF SUBSTR(vFun, 3, 1) EQ "�" THEN
                  ASSIGN
                     vType      = "INT"
                     tt-val.val = STRING(vQty).
               ELSE
                  ASSIGN
                     vType      = "DECIMAL"
                     tt-val.val = STRING(vSum).
            END.
            ELSE DO:
               ASSIGN
                  tt-val.val = GetXAttrValueEx("loan",
                                               loan.contract + ","
                                             + loan.cont-code,
                                               vCode,
                                               "?"
                                              )
                  vType      = GetXAttrEx     (loan.class-code,
                                               vCode,
                                               "Data-Type"
                                              ).

               IF tt-val.val EQ "?" THEN
                  ASSIGN
                     tt-val.val = GetXAttrValueEx("asset",
                                                  loan.cont-type,
                                                  vCode,
                                                  "?"
                                                 )
                     vType      = GetXAttrEx     ("asset",
                                                  vCode,
                                                  "Data-Type"
                                                 ).

               IF NOT CAN-DO("INTEGER,DECIMAL", vType) THEN
                  vType = "CHAR".
            END.
         END.
      END CASE.

      /* ���������騥, ����।����, ��㤠筮 ���᫥��� ������⥫� 㤠�塞 */
      IF    tt-val.val EQ ""
         OR tt-val.val EQ "?"
         OR tt-val.val EQ ? THEN
         DELETE tt-val.
      ELSE
      DO:
         tt-val.type = vType.
         RELEASE tt-val.
      END.

      IF tt-prm.class EQ "" THEN
         ASSIGN
            tt-prm.class  = "kau-entry"
            tt-prm.level  = iLevel.
   END.

   RETURN.

END PROCEDURE.
