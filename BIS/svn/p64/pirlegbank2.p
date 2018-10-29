{pirsavelog.p}
/* ------------------------------------------------------
     File: $RCSfile: pirlegbank2.p,v $ $Revision: 1.4 $ $Date: 2010-06-18 10:25:49 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: �ਪ�� 64 �� 03/10/2007
     �� ������: �ᯮ����� ����� � �ଠ� XML:Excel �� ������� �� ��ਮ�, 
                 ᮢ��襭��� �����⠬� ����� �१ ����-����ࠣ���.
     ��� ࠡ�⠥�: ����訢��� ��ਮ�, � ���஬ �㤥� �ந������� �롮ઠ ���㬥�⮢.
                   �����뢠�� ����� �� �६����� ⠡����. 
     ��ࠬ����: ��� 䠩�� �ᯮ��
     ���� ����᪠: �� ���� ����᪠ ��楤��.
     ����: $Author: borisov $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.3  2007/10/18 07:42:23  anisimov
     ���������: no message
     ���������:
     ���������: Revision 1.2  2007/10/16 06:42:38  buryagin
     ���������: To divide all number values of amount by 1000.
     ���������:
------------------------------------------------------ */

{globals.i}

/** �㭪樨 �� ࠡ�� � XML:Excel �ଠ⮬ */
{uxelib.i}

DEFINE INPUT PARAM iParam AS CHAR.

DEFINE TEMP-TABLE ttReport  NO-UNDO
   FIELD bankName         AS CHAR
   FIELD bankMainRegnCode AS CHAR    /** ������ ॣ. ����� (��ࢠ� ���� �� �������� ॣ.����� <����>/<䨫���>) */
   FIELD bankRegnCode2    AS INTEGER /** ॣ. ����� 䨫���� (2-� ���� �� �������� ॣ.����� <����>/<䨫���>) */
   FIELD bankBicCode      AS CHAR    /** ��� - �ᯮ������ ��� ��ॣ�樨. �᫨ ��������� ॣ.����� */
   FIELD outAmountAll     AS DECIMAL /** ��ࠢ���� �१ ���� �ᥣ� � �������� ������ �� */
   FIELD outAmountRub     AS DECIMAL /** ��ࠢ���� �१ ���� ⮫쪮 � ����� �� */
   FIELD inAmountAll      AS DECIMAL /** ����祭� �� ����� �ᥣ� � �������� ������ �� */
   FIELD inAmountRub      AS DECIMAL /** ����祭� �� ����� ⮫쪮 � ����� �� */
   FIELD sumAmountAll     AS DECIMAL
   .

DEFINE TEMP-TABLE ttReport2  NO-UNDO
   FIELD bankName         AS CHAR
   FIELD bankMainRegnCode AS CHAR    /** ������ ॣ. ����� (��ࢠ� ���� �� �������� ॣ.����� <����>/<䨫���>) */
   FIELD bankBicCode      AS CHAR    /** ��� - �ᯮ������ ��� ��ॣ�樨. �᫨ ��������� ॣ.����� */
   FIELD outAmountAll     AS DECIMAL /** ��ࠢ���� �१ ���� �ᥣ� � �������� ������ �� */
   FIELD outAmountRub     AS DECIMAL /** ��ࠢ���� �१ ���� ⮫쪮 � ����� �� */
   FIELD inAmountAll      AS DECIMAL /** ����祭� �� ����� �ᥣ� � �������� ������ �� */
   FIELD inAmountRub      AS DECIMAL /** ����祭� �� ����� ⮫쪮 � ����� �� */
   FIELD sumAmountAll     AS DECIMAL
   .

DEFINE VAR fileName     AS CHARACTER NO-UNDO. /** ������ ��� 䠩�� ��� �ᯮ�� */	
DEFINE VAR styleXmlCode AS CHARACTER NO-UNDO.
DEFINE VAR regnCode     AS CHARACTER NO-UNDO.
DEFINE VAR MainRegnCode AS CHARACTER NO-UNDO.
DEFINE VAR bicCode      AS CHARACTER NO-UNDO.
DEFINE VAR nSumIn       AS DECIMAL INIT 0 NO-UNDO.
DEFINE VAR nSumOut      AS DECIMAL INIT 0 NO-UNDO.
DEFINE VAR i            AS INTEGER INIT 0 NO-UNDO.
DEFINE VAR nOutAll      AS DECIMAL NO-UNDO.
DEFINE VAR nOutRub      AS DECIMAL NO-UNDO.
DEFINE VAR nInAll       AS DECIMAL NO-UNDO.
DEFINE VAR nInRub       AS DECIMAL NO-UNDO.

{getdates.i}

/** ��� ������ �஢���� �� ��ਮ�, �� ������ ��� �।��� ���ன 㪠��� ��� ����� */
FOR EACH op-entry
   WHERE (op-entry.op-date GE beg-date)
     AND (op-entry.op-date LE end-date)
   NO-LOCK,
   FIRST acct
      WHERE ((acct.acct EQ op-entry.acct-db)
          OR (acct.acct EQ op-entry.acct-cr))
        AND (acct.contract EQ "�����")
      NO-LOCK,
   FIRST op OF op-entry
   NO-LOCK
   BREAK BY op-entry.op-date:

   IF FIRST-OF(op-entry.op-date)
   THEN
      put screen col 1 row 24 "��ࠡ��뢠���� " + STRING(op-entry.op-date).

   /** ������ ���� */
   /** �᫨ �� ��� ������ ������-���� �����, �� �᪫�祭��� ��襣� ��� ������ � ��� */
   IF (acct.cust-cat EQ "�")
   THEN DO:
      FIND FIRST banks
         WHERE (banks.bank-id EQ acct.cust-id)
         NO-LOCK NO-ERROR.
   END.
   ELSE DO:
      /** � �᫨ ��� ��� � ��� */
      FIND FIRST op-bank OF op
         WHERE (op-bank.bank-code-type EQ "���-9")
         NO-LOCK NO-ERROR.

      IF AVAIL op-bank
      THEN DO:
         FIND FIRST banks-code
            WHERE (banks-code.bank-code-type EQ op-bank.bank-code-type)
              AND (banks-code.bank-code      EQ op-bank.bank-code )
              NO-LOCK NO-ERROR.

         IF AVAIL banks-code
         THEN DO:
            FIND FIRST banks
               WHERE (banks.bank-id EQ banks-code.bank-id)
               NO-LOCK NO-ERROR.
         END.
      END.
   END.

   /** �᫨ ���� ������, ������ ��� ���.����� � ���*/
   IF AVAIL banks
   THEN DO:
      FIND FIRST banks-code
         WHERE (banks-code.bank-id        EQ banks.bank-id)
           AND (banks-code.bank-code-type EQ "REGN")
         NO-LOCK NO-ERROR.

      /** ���.����� */
      IF (AVAIL banks-code)
      THEN DO:
         MainRegnCode = ENTRY(1, banks-code.bank-code, "/").
         regnCode     = IF (NUM-ENTRIES(banks-code.bank-code, "/") GT 1)
                        THEN ENTRY(2, banks-code.bank-code, "/")
                        ELSE "0".
      END.
      ELSE DO:
         MainRegnCode = "".
         regnCode     = "0".
      END.
/*
      regnCode = IF (AVAIL banks-code)
                 THEN banks-code.bank-code
                 ELSE "".
      MainRegnCode = ENTRY(1, regnCode, "/").
*/

      /** ��� */
      FIND FIRST banks-code
         WHERE (banks-code.bank-id        EQ banks.bank-id)
           AND (banks-code.bank-code-type EQ "���-9")
         NO-LOCK NO-ERROR.

      bicCode  = IF (AVAIL banks-code)
                 THEN banks-code.bank-code
                 ELSE "".

      /** ttReport */
      IF     (MainRegnCode NE "")
         AND (bicCode      NE "")
      THEN
         FIND FIRST ttReport
            WHERE (ttReport.bankMainRegnCode EQ MainRegnCode)
              AND (ttReport.bankRegnCode2    EQ INTEGER(regnCode))
            NO-ERROR.

      IF (NOT AVAIL ttReport)
      THEN DO:
/*
         IF     (regnCode NE "")
            AND (regnCode NE MainRegnCode)
         THEN DO:
            FIND FIRST banks-code
               WHERE (banks-code.bank-code-type EQ "REGN")
                 AND (banks-code.bank-code      EQ MainRegnCode)
                 NO-LOCK NO-ERROR.

            IF AVAIL banks-code
            THEN DO:
               FIND FIRST banks
                  WHERE (banks.bank-id EQ banks-code.bank-id)
                  NO-LOCK NO-ERROR.
            END.
         END.
*/

         CREATE ttReport.
         ttReport.bankName         = banks.short-name.
         ttReport.bankMainRegnCode = MainRegnCode.
         ttReport.bankRegnCode2    = INTEGER(regnCode).
         ttReport.bankBicCode      = bicCode.
      END.

      /** ���࠭�� �㬬� */
      IF (acct.acct EQ op-entry.acct-db)
      THEN DO:
         ttReport.inAmountAll = ttReport.inAmountAll + op-entry.amt-rub.
         nSumIn  = nSumIn  + op-entry.amt-rub.
         IF (op-entry.currency EQ "")
         THEN
            ttReport.inAmountRub = ttReport.inAmountRub + op-entry.amt-rub.
      END.
      ELSE DO:
         ttReport.outAmountAll = ttReport.outAmountAll + op-entry.amt-rub.
         nSumOut = nSumOut + op-entry.amt-rub.
         IF (op-entry.currency EQ "")
         THEN
            ttReport.outAmountRub = ttReport.outAmountRub + op-entry.amt-rub.
      END.
   END.
END. /** EACH op-entry */

put screen col 1 row 24 color normal STRING(" ","X(80)").

FOR EACH ttReport:
   ttReport.sumAmountAll = ttReport.inAmountAll + ttReport.outAmountAll.
END.

FOR EACH ttReport
   BREAK BY ttReport.bankMainRegnCode
   :

   IF FIRST-OF(ttReport.bankMainRegnCode)
   THEN
      ASSIGN
         i       = 0
         nOutAll = 0
         nOutRub = 0
         nInAll  = 0
         nInRub  = 0
      NO-ERROR.

   ASSIGN
      i       = i + 1
      nOutAll = nOutAll + ttReport.outAmountAll
      nOutRub = nOutRub + ttReport.outAmountRub
      nInAll  = nInAll  + ttReport.inAmountAll
      nInRub  = nInRub  + ttReport.inAmountRub
   NO-ERROR.

   IF     LAST-OF(ttReport.bankMainRegnCode)
      AND (i GT 1)
   THEN DO:
      CREATE ttReport2.
      ASSIGN
         ttReport2.outAmountAll = nOutAll
         ttReport2.outAmountRub = nOutRub
         ttReport2.inAmountAll  = nInAll
         ttReport2.inAmountRub  = nInRub
         ttReport2.sumAmountAll = nOutAll + nInAll
         ttReport2.bankMainRegnCode = ttReport.bankMainRegnCode
         ttReport2.bankBicCode      = ttReport.bankBicCode
         ttReport2.bankName         = ""
      NO-ERROR.

      FIND FIRST banks-code
         WHERE (banks-code.bank-code-type EQ "REGN")
           AND (banks-code.bank-code      EQ ttReport.bankMainRegnCode)
           NO-LOCK NO-ERROR.

      IF AVAIL banks-code
      THEN DO:
         FIND FIRST banks
            WHERE (banks.bank-id EQ banks-code.bank-id)
            NO-LOCK NO-ERROR.
         IF (AVAIL banks)
         THEN
            ttReport2.bankName = banks.short-name.
      END.
   END.
END.

/*******************************************************************************/
fileName = "/home/bis/quit41d/imp-exp/users/" + LC(userid) + "/" + ENTRY(1, iParam).
/*
fileName = "./" + ENTRY(1, iParam).
*/
OUTPUT TO VALUE(fileName).

styleXmlCode = CreateExcelStyle("Center", "Center", 2, "t1") +
               CreateExcelStyle("Right", "Center", 2, "t2") +
               CreateExcelStyle("Right", "Center", 1, "s2") +
               CreateExcelStyle("Left", "Center", 1, "s1").

PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).
PUT UNFORMATTED CreateExcelWorksheet("����").

PUT UNFORMATTED
   SetExcelColumnWidth( 1,  30) +
   SetExcelColumnWidth( 2, 220) +
   SetExcelColumnWidth( 3,  55) +
   SetExcelColumnWidth( 4,  55) +
   SetExcelColumnWidth( 5,  55) +
   SetExcelColumnWidth( 6,  60) +
   SetExcelColumnWidth( 7,  60) +
   SetExcelColumnWidth( 8,  60) +
   SetExcelColumnWidth( 9,  60) +
   SetExcelColumnWidth(10,  60) +
   SetExcelColumnWidth(11,  60) +
   SetExcelColumnWidth(12,  60) +
   CreateExcelRow(
      CreateExcelCell("String", "", "���᮫���஢���� ���� �� ������-����ࠣ��⠬ (������� �� 䨫����) �� ��ਮ� � " + STRING(beg-date, "99.99.9999") + " �� " + STRING(end-date, "99.99.9999") + " (� ���. ��.)")
   ) +
   CreateExcelRow(
      CreateExcelCell("String", "t1", "N �/�") +
      CreateExcelCell("String", "t1", "������������ �����-����ࠣ���") +
      CreateExcelCell("String", "t1", "���") +
      CreateExcelCell("String", "t1", "���.�����") +
      CreateExcelCell("String", "t1", "����� 䨫����") +
      CreateExcelCell("String", "t1", "���ࠢ���� �१ ��") +
      CreateExcelCell("String", "t1", "� �.�.� ����� ��") +
      CreateExcelCell("String", "t1", "����祭� �� ��") +
      CreateExcelCell("String", "t1", "� �.�.� ����� ��") +
      CreateExcelCell("String", "t1", "���ࠢ���� � % � �⮣�") +
      CreateExcelCell("String", "t1", "����祭� � % � �⮣�") +
      CreateExcelCell("String", "t1", "�㬬��� �����")
   ).

i = 0.
FOR EACH ttReport
   BY ttReport.bankMainRegnCode
   BY ttReport.bankRegnCode2
   :
   i = i + 1.
   PUT UNFORMATTED
      CreateExcelRow(
         CreateExcelCell("Number", "s2", STRING(i)) +
         CreateExcelCell("String", "s1", ttReport.bankName) +
         CreateExcelCell("String", "s1", ttReport.bankBicCode ) +
         CreateExcelCell("String", "s1", ttReport.bankMainRegnCode) +
         CreateExcelCell("Number", "s2", STRING(ttReport.bankRegnCode2)) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.outAmountAll / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.outAmountRub / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.inAmountAll  / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.inAmountRub  / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.outAmountAll * 100 / nSumOut, 2), ">>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.inAmountAll  * 100 / nSumIn , 2), ">>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport.sumAmountAll / 1000, 2), ">>>>>>>>>>>9.99")))
      ).
END.

/** �⮣� */
IF (i GT 0)
THEN DO:
   PUT UNFORMATTED
      CreateExcelRow(
         CreateExcelCellEx(5, "String", "t2", TRIM(STRING(ROUND(nSumOut / 1000, 2), ">>>>>>>>>>>9.99")), "0") +
         CreateExcelCellEx(7, "String", "t2", TRIM(STRING(ROUND(nSumIn  / 1000, 2), ">>>>>>>>>>>9.99")), "0")
      ) +
      CreateExcelRow(
         CreateExcelCell("String", "", "")
      ).
END.

i = 0.
FOR EACH ttReport2
   BY ttReport2.sumAmountAll DESCENDING
   :
   i = i + 1.
   PUT UNFORMATTED
      CreateExcelRow(
         CreateExcelCell("Number", "s2", STRING(i)) +
         CreateExcelCell("String", "s1", ttReport2.bankName) +
         CreateExcelCell("String", "s1", ttReport2.bankBicCode ) +
         CreateExcelCell("String", "s1", ttReport2.bankMainRegnCode) +
         CreateExcelCell("String", "s1", "") +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.outAmountAll / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.outAmountRub / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.inAmountAll  / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.inAmountRub  / 1000, 2), ">>>>>>>>>>>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.outAmountAll * 100 / nSumOut, 2), ">>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.inAmountAll  * 100 / nSumIn , 2), ">>9.99"))) +
         CreateExcelCell("String", "s2", TRIM(STRING(ROUND(ttReport2.sumAmountAll / 1000, 2), ">>>>>>>>>>>9.99")))
      ).
END.

PUT UNFORMATTED CloseExcelTag("Worksheet").
PUT UNFORMATTED CloseExcelTag("Workbook").

OUTPUT CLOSE.

MESSAGE "����� �ᯮ��஢���� � 䠩� " + fileName VIEW-AS ALERT-BOX.
