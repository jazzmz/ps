{pirsavelog.p}
/** 
   ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009

   ���� �� �������� ����祭�� ������⠬.
   ���ᮢ �.�., 10.09.2010
*/

{globals.i}           /* �������� ��।������ */
{intrface.get i254}
{lshpr.pro}           /* �����㬥��� ��� ���� ��ࠬ��஢ ������� */
{sh-defs.i}
{ulib.i}
/******************************************* ��।������ ��६����� � ��. */

DEFINE VARIABLE iI        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iJ        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iK        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDolg     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE daTmp     AS DATE      NO-UNDO.
DEFINE VARIABLE daOtch    AS DATE      NO-UNDO.
DEFINE VARIABLE dP0       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP2       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP7       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dP10       AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dSumP0    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumP7    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSumP10   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dT1       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dT2       AS DECIMAL   NO-UNDO.
DEFINE BUFFER   transh    FOR loan.

DEFINE TEMP-TABLE ttTr NO-UNDO
   FIELD cNDog   AS CHARACTER
   FIELD dSumm0  AS DECIMAL
   FIELD daKr    AS DATE
   FIELD daPr    AS DATE
.
DEFINE TEMP-TABLE ttPK NO-UNDO
   FIELD cNDog   AS CHARACTER
   FIELD cCurr   AS CHARACTER
   FIELD dProc   AS DECIMAL
   FIELD dSumm0  AS DECIMAL
   FIELD dSumm7  AS DECIMAL
   FIELD dSumm10 AS DECIMAL
   FIELD cClName AS CHARACTER
   FIELD iClID   AS INTEGER
   FIELD cTel    AS CHARACTER EXTENT 10
   FIELD iTelN   AS INTEGER
.

/****************************************************** */
FUNCTION fTelMail RETURNS INTEGER
   (INPUT-OUTPUT inArr AS CHARACTER EXTENT 10,
    INPUT        inStr AS CHARACTER,
    INPUT        inLen AS INTEGER,
    INPUT        inNum AS INTEGER):

   DEFINE VARIABLE cT  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iM  AS INTEGER   NO-UNDO.

   IF (LENGTH(inStr) LE inLen)
   THEN DO:
      inArr[inNum] = inStr.
      RETURN 1.
   END.
   ELSE DO:
      cT = SUBSTRING(inStr, 1, inLen).
      iM = R-INDEX(cT, ",").
      IF (iM NE 0)
      THEN DO:
         inArr[inNum] = SUBSTRING(cT, 1, iM).
         RETURN fTelMail(inArr, SUBSTRING(inStr, iM + 1), inLen, inNum + 1) + 1.
      END.
      ELSE DO:
         iM = R-INDEX(cT, "@").
         IF (iM NE 0)
         THEN DO:
            inArr[inNum] = SUBSTRING(cT, 1, iM).
            RETURN fTelMail(inArr, SUBSTRING(inStr, iM + 1), inLen, inNum + 1) + 1.
         END.
         ELSE DO:
            inArr[inNum] = cT.
            RETURN fTelMail(inArr, SUBSTRING(inStr, inLen + 1), inLen, inNum + 1) + 1.
         END.
      END.
   END.

END FUNCTION.


/******************************************* ��������� */
{getdate.i}
daOtch   = end-date.
/*
end-date = end-date - 1.

DO WHILE holiday(end-date):
   end-date = end-date - 1.
END.
*/
{setdest.i}
/****************************************************** */

FOR EACH loan
   WHERE ((loan.class-code  EQ "l_agr_with_per") OR (loan.class-code  EQ "l_agr_with_diff"))
     AND (loan.contract    EQ '�।��')
     AND (loan.open-date   LE end-date)
     AND ((loan.close-date GE end-date)
       OR (loan.close-date EQ ?))
   NO-LOCK:

   put screen col 1 row 24 "��ࠡ��뢠���� " + loan.doc-ref + "           ".

   lDolg   = NO.
   dSumP0  = 0.0.
   dSumP7  = 0.0.
/*   RUN STNDRT_PARAM(loan.contract, loan.cont-code, 10, end-date, OUTPUT dSumP10, OUTPUT dT1, OUTPUT dT2).*/
/*
   RUN GET_PARAM(loan.contract, loan.cont-code, 10, end-date, OUTPUT dSumP10, OUTPUT daTmp).
*/
/*      message loan.cont-code VIEW-AS ALERT-BOX.	*/
   FOR EACH transh
      WHERE ((transh.class-code  EQ "loan_trans_ov") OR (transh.class-code  EQ "loan_trans_diff"))
        AND (transh.contract    EQ '�।��')
        AND (transh.cont-code   BEGINS loan.cont-code)
        AND (transh.open-date   LE end-date)
        AND ((transh.close-date GE end-date)
          OR (transh.close-date EQ ?))
      NO-LOCK:
/*      message loan.cont-code VIEW-AS ALERT-BOX.	               */

      RUN STNDRT_PARAM(transh.contract, transh.cont-code, 10, end-date, OUTPUT dP10, OUTPUT dT1, OUTPUT dT2).
      RUN STNDRT_PARAM(transh.contract, transh.cont-code,  0, end-date, OUTPUT dP0 , OUTPUT dT1, OUTPUT dT2).
      RUN STNDRT_PARAM(transh.contract, transh.cont-code,  2, end-date, OUTPUT dP2 , OUTPUT dT1, OUTPUT dT2).
      RUN STNDRT_PARAM(transh.contract, transh.cont-code,  7, end-date, OUTPUT dP7 , OUTPUT dT1, OUTPUT dT2).
/*
      RUN GET_PARAM(transh.contract, transh.cont-code,  0, end-date, OUTPUT dP0 , OUTPUT daTmp).
      RUN GET_PARAM(transh.contract, transh.cont-code,  7, end-date, OUTPUT dP7 , OUTPUT daTmp).
*/
      dSumP10 = dSumP10 + dP10.
      dSumP0  = dSumP0 + dP0 + dP2.
      dSumP7  = dSumP7 + dP7.

      IF ((dP0 + dP2) NE 0.0)
      THEN DO:

         lDolg = YES.
         CREATE ttTr.
         ASSIGN
            ttTr.cNDog  = transh.doc-ref
            ttTr.dSumm0 = dP0
            NO-ERROR.

         FOR FIRST loan-int
            WHERE (loan-int.cont-code EQ transh.cont-code)
              AND (loan-int.contract  EQ '�।��')
              AND (loan-int.id-d      EQ 0)
              AND (loan-int.id-k      EQ 3)
            NO-LOCK:

            ASSIGN
               ttTr.daKr   = loan-int.mdate
               ttTr.daPr   = loan-int.mdate + 45
               NO-ERROR.
            DO WHILE holiday(ttTr.daPr):
               ttTr.daPr = ttTr.daPr + 1.
            END.
         END.

      END.
   END.

   IF lDolg
   THEN DO:
      CREATE ttPK.

      FIND FIRST person
         WHERE (person.person-id EQ loan.cust-id)
         NO-LOCK NO-ERROR.

      ASSIGN
         ttPK.cNDog   = loan.doc-ref
         ttPK.cCurr   = loan.currency
         ttPK.dProc   = GetCredLoanCommission_ULL(loan.doc-ref, "%�।", end-date, NO) * 100
         ttPK.dSumm0  = dSumP0
         ttPK.dSumm7  = dSumP7
         ttPK.dSumm10 = dSumP10
         ttPK.iClID   = loan.cust-id
         ttPK.cClName = (IF AVAIL person
                         THEN (person.name-last + " "
                            + SUBSTRING(ENTRY(1, person.first-names, " "), 1, 1) + "."
                            + SUBSTRING(ENTRY(2, person.first-names, " "), 1, 1) + ".")
                         ELSE "")
         ttPK.iTelN   = fTelMail(ttPK.cTel,
                        IF AVAIL person
                        THEN TRIM(GetXAttrValue("person", STRING(loan.cust-id), "����䮭3") + ","
                                + GetXAttrValue("person", STRING(loan.cust-id), "e-mail"), ",")
                        ELSE "",
                        16, 1)
         NO-ERROR.
   END.
END.

/****************************************************** */
PUT UNFORMATTED
   "                                     �����" SKIP
   "      �� " STRING(daOtch, "99.99.9999") "������� ᫥���騥 ������������ �� �����⠬:" SKIP(1)
   "������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP
   "�N �        ���           � ��� �뤠稳     �㬬�     �����⠳��� ����襭�ﳊ��-�� ���������䮭, e-mail �  �ਬ�砭��  �" SKIP
   "�  �                      �            �               �      �  (��������)  ��� �����.  �                �              �" SKIP
.

FOR EACH ttPK
   NO-LOCK
   BREAK BY ttPK.cCurr
   BY ttPK.cNDog:

   IF FIRST-OF(ttPK.cCurr)
   THEN DO:
      iI      = 0.
      dSumP7  = 0.0.
      dSumP10 = 0.0.
   END.

   IF FIRST(ttPK.cCurr)
   THEN DO:
      PUT UNFORMATTED
         "������������������������������������������������������������������������������������������������������������������������͵" SKIP
      .
   END.

   IF     FIRST-OF(ttPK.cCurr)
      AND NOT FIRST(ttPK.cCurr)
   THEN DO:
      PUT UNFORMATTED
         "������������������������������������������������������������������������������������������������������������������������͵" SKIP
      .
   END.

   iI      = iI + 1.
   dSumP7  = dSumP7  + ttPK.dSumm7.
   dSumP10 = dSumP10 + ttPK.dSumm10.

   iJ = 0.
   FOR EACH ttTr
      WHERE (ttTr.cNDog BEGINS ttPK.cNDog)
      NO-LOCK
      BREAK BY ttTr.cNDog:

      iJ = iJ + 1.
      PUT UNFORMATTED
         "�"  (IF FIRST(ttTr.cNDog) THEN STRING(iI, ">9") ELSE "  ")
         "�  " ttPK.cClName    FORMAT "x(20)"
         "� "  ttTr.daKr       FORMAT "99.99.9999"
        " �"   ttTr.dSumm0     FORMAT ">>>,>>>,>>9.99"
        " � " (IF (ttPK.cCurr EQ "840") THEN " USD " ELSE (
               IF (ttPK.cCurr EQ "978") THEN " EUR " ELSE " RUR "))
         "�  " ttTr.daPr       FORMAT "99.99.9999"
       "  � "  (IF ((ttTr.daPr - daOtch) LE 3) THEN STRING(ttTr.daPr - daOtch, "->>>>9") ELSE "      ")
     "    �"   (IF (iJ LE ttPK.iTelN) THEN ttPK.cTel[iJ] ELSE "") FORMAT "x(16)"
         "�              "
         "�" SKIP
      .
   END.

   DO WHILE (iJ LT ttPK.iTelN):

      iJ = iJ + 1.
      PUT UNFORMATTED
         "�  "
         "�  " "" FORMAT "x(20)"
         "� "  "" FORMAT "x(10)"
        " �"   "" FORMAT "x(14)"
        " �      "
         "�  " "" FORMAT "x(10)"
       "  �       "
     "    �"   ttPK.cTel[iJ] FORMAT "x(16)"
         "�              "
         "�" SKIP
      .
   END.

   PUT UNFORMATTED
      "�  ���������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      "�" ("  �����祭��� ������������� �� ������� " + ttPK.cClName + " ��⠢���") FORMAT "x(76)"
          STRING(ttPK.dSumm7, ">>>,>>>,>>9.99")
         (IF (ttPK.cCurr EQ "840") THEN " �����஢ ���" ELSE (
          IF (ttPK.cCurr EQ "978") THEN " ����        " ELSE " �㡫�� ��   "))
          "                 �" SKIP
      "�" ("  �����祭�� %% �� ������� " + ttPK.cClName + " ��⠢����") FORMAT "x(76)"
          STRING(ttPK.dSumm10, ">>>,>>>,>>9.99")
         (IF (ttPK.cCurr EQ "840") THEN " �����஢ ���" ELSE (
          IF (ttPK.cCurr EQ "978") THEN " ����        " ELSE " �㡫�� ��   "))
          "                 �" SKIP
      "�" ("  ���筠� ������������� ������ " + ttPK.cClName + " ��⠢���") FORMAT "x(76)"
          STRING(ttPK.dSumm0, ">>>,>>>,>>9.99")
         (IF (ttPK.cCurr EQ "840") THEN " �����஢ ���" ELSE (
          IF (ttPK.cCurr EQ "978") THEN " ����        " ELSE " �㡫�� ��   "))
          "                 �" SKIP
   .

   IF LAST-OF(ttPK.cCurr)
   THEN DO:
      PUT UNFORMATTED
         "������������������������������������������������������������������������������������������������������������������������͵" SKIP
         "�      �⮣� 45815 � "
            (IF (ttPK.cCurr EQ "840") THEN "����� USD:" ELSE (
             IF (ttPK.cCurr EQ "978") THEN "����� EUR:" ELSE "�㡫�� ��: "))
             "        "
             dSumP7 FORMAT ">>>,>>>,>>9.99"
             "                                                                   �" SKIP
         "�      �⮣� 45915 � "
            (IF (ttPK.cCurr EQ "840") THEN "����� USD:" ELSE (
             IF (ttPK.cCurr EQ "978") THEN "����� EUR:" ELSE "�㡫�� ��: "))
             "        "
             dSumP10 FORMAT ">>>,>>>,>>9.99"
             "                                                                   �" SKIP
      .
   END.
   ELSE DO:
      PUT UNFORMATTED
         "������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP
      .
   END.

END.

PUT UNFORMATTED
   "������������������������������������������������������������������������������������������������������������������������;" SKIP
.
{preview.i}
put screen col 1 row 24 color normal STRING(" ","X(80)").
{intrface.del}
