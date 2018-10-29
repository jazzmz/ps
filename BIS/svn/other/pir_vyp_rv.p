{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪠ ����権 �।���� ������஢ ��� �.808 �ࠢ�筮.
                ���ᮢ �.�., 28.08.2009
*/

{globals.i}           /** �������� ��।������ */
{pick-val.i}
{chkacces.i}
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get date}   /** �㭪樨 ��� ࠡ��� � ��⠬� */
{intrface.get instrum}

{sh-defs.i}
{ulib.i}

{pir_exf_exl.i}
{getdates.i}
DEFINE VARIABLE oClient AS TClient NO-UNDO.

{exp-path.i &exp-filename = "'Vyp.xls'"}
/******************************************* ��।������ ��६����� � ��. */
DEF VAR cXL       AS CHAR     NO-UNDO.
DEF VAR cKl       AS CHAR     NO-UNDO.
DEF VAR cINN      AS CHAR     NO-UNDO.

/******************************************* ��������� */
{tmprecid.def}          /* ������ �⬥⮪. */

PUT UNFORMATTED XLHead("Klient", "DCCCCCCCNNNNC", "71,83,70,150,200,200,110,150,110,110,110,110,200").

FOR EACH tmprecid NO-LOCK,
   FIRST acct
      WHERE recid(acct) = tmprecid.id
      NO-LOCK:

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, beg-date, cXL).
   oClient = new TClient(acct.acct).

   cXL = XLRow(0)
       + XLCell("�믨᪠ �� ���� " + acct.acct + " �� ��ਮ� � "
                + STRING(beg-date, "99.99.9999") + " �� " + STRING(end-date, "99.99.9999"))
       + XLRowEnd() + XLRow(0)
       + XLCell(oClient:name-short
                + " (���: " + oClient:getInnByDate(end-date) + " )")
       + XLEmptyCells(6)
       + XLCell("�室�騩 ���⮪ �� ���:")
       + XLEmptyCell() + XLNumCell(ABS(sh-in-bal))
       + (IF (acct.currency NE "")
          THEN (XLEmptyCell() + XLNumCell(ABS(sh-in-val)))
          ELSE "")
       + XLRowEnd()
       .
   DELETE OBJECT oClient.

   PUT UNFORMATTED XLRow(2) XLRowEnd() cXL.

   cXL = XLCell("���")
       + XLCell("N ���㬥��")
       + XLCell("��� �����")
       + XLCell("����.���")
       + XLCell("�������� �����")
       + XLCell("�������� ����ࠣ���")
       + XLCell("��� ����ࠣ���")
       + XLCell("��� ����ࠣ���")
       + XLCell("�� � �㡫��")
       + XLCell("�� � �㡫��")
       + (IF (acct.currency NE "")
          THEN (XLCell("�� � �����")
              + XLCell("�� � �����"))
          ELSE "")
       + XLCell("����ঠ��� ����樨")
       .
   PUT UNFORMATTED XLRow(2) cXL XLRowEnd() .

   FOR EACH op
      WHERE (op.op-date >= beg-date)
        AND (op.op-date <= end-date)
        AND NOT (op.doc-num BEGINS "�")
      NO-LOCK,
      EACH op-entry OF op
         WHERE (op-entry.acct-db EQ acct.acct)
            OR (op-entry.acct-cr EQ acct.acct)
      NO-LOCK
      BREAK BY op-entry.op-date:

      cXL = XLDateCell(op-entry.op-date)
          + XLCell(op.doc-num).

      FIND FIRST op-bank
         WHERE (op-bank.op EQ op.op)
           AND (op-bank.op-bank-type   EQ "")
           AND (op-bank.bank-code-type EQ "���-9")
         NO-LOCK NO-ERROR.

      IF AVAILABLE(op-bank)
      THEN DO:
         FIND FIRST banks-code OF op-bank
            NO-ERROR.
         FIND FIRST banks OF banks-code
            NO-ERROR.
         cXL = cXL 
             + XLCell(op-bank.bank-code)
             + XLCell(op-bank.corr-acct)
             + XLCell(banks.name)
             + XLCell(op.name-ben)
             + XLCell(op.inn)
             + XLCell(op.ben-acct).
      END.
      ELSE DO:
         cXL = cXL + XLEmptyCells(3).

         IF (op-entry.acct-db EQ acct.acct)
         THEN DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-cr, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-rec").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-cr, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".
            cXL = cXL
                + XLCell(cKl)
                + XLCell(cINN)
                + XLCell(op-entry.acct-cr).
         END.
         ELSE DO:
            cKl = GetAcctClientName_UAL(op-entry.acct-db, false).
            IF (cKl NE "")
            THEN DO:
               cINN = GetXAttrValue("op", STRING(op.op), "inn-send").
               IF (cINN = "")
               THEN cINN = GetClientInfo_ULL(GetAcctClientID_ULL(op-entry.acct-db, FALSE), "inn", FALSE).
            END.
            ELSE cINN = "".
            cXL = cXL
                + XLCell(cKl)
                + XLCell(cINN)
                + XLCell(op-entry.acct-db).
         END.
      END.

      IF (op-entry.acct-db EQ acct.acct)
      THEN cXL = cXL + XLNumCell(op-entry.amt-rub) + XLEmptyCell().
      ELSE cXL = cXL + XLEmptyCell() + XLNumCell(op-entry.amt-rub).

      IF (acct.currency NE "")
      THEN DO:
         IF (op-entry.acct-db EQ acct.acct)
         THEN cXL = cXL + XLNumCell(op-entry.amt-cur) + XLEmptyCell().
         ELSE cXL = cXL + XLEmptyCell() + XLNumCell(op-entry.amt-cur).
      END.

      cXL = cXL + XLCell(op.details).

      IF FIRST-OF(op-entry.op-date)
      THEN PUT UNFORMATTED XLRow(1) cXL XLRowEnd().
      ELSE PUT UNFORMATTED XLRow(0) cXL XLRowEnd().
   END.

   RUN acct-pos IN h_base(acct.acct, acct.currency, beg-date, end-date, cXL).
   cXL = XLRow(2)
       + XLCell("�⮣� :") + XLEmptyCells(6)
       + XLCell("������ :")
       + XLNumCell(sh-db) + XLNumCell(sh-cr)
       + (IF (acct.currency NE "")
          THEN (XLNumCell(sh-vdb) + XLNumCell(sh-vcr))
          ELSE "")
       + XLRowEnd() + XLRow(0) + XLEmptyCells(7)
       + XLCell("���⮪ �� ��� :")
       + XLEmptyCell() + XLNumCell(ABS(sh-bal))
       + (IF (acct.currency NE "")
          THEN (XLEmptyCell() + XLNumCell(ABS(sh-val)))
          ELSE "")
       + XLRowEnd()
       .
   PUT UNFORMATTED cXL.
END.

PUT UNFORMATTED XLEnd().

{intrface.del}