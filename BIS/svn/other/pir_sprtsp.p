{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��������� ����権 � ��� �� ��ਮ�
                ���ᮢ �.�.
*/

{globals.i}           /** �������� ��।������ */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */
{ulib.i}
{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEFINE VARIABLE cXL    AS CHARACTER NO-UNDO.
DEFINE VARIABLE dSUMT  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dKMSK  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dKMSSC AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSUM   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dKOM   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dDS    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dDK    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSS    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dSK    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dKomm  AS DECIMAL   NO-UNDO.
DEFINE BUFFER   ustr   FOR loan.

{pir_exf_exl.i}

{getdates.i}
{exp-path.i &exp-filename = "'SprTSP.xls'"}

/******************************************* ��������� */
PUT UNFORMATTED XLHead(STRING(beg-date, "99.99.9999") + "-" + STRING(beg-date, "99.99.9999"),
                       "DCCCCCNNN", "96,96,102,62,120,120,110,110,130").

cXL = XLCell("��� ����樨")
    + XLCell("��� ����樨")
    + XLCell("����� �����")
    + XLCell("��� �����")
    + XLCell("����� ���ன�⢠")
    + XLCell("��業� �����ᨨ")
    + XLCell("�㬬� ����樨")
    + XLCell("�㬬� �����ᨨ")
    + XLCell("�㬬� �����饭��")
    .
PUT UNFORMATTED XLRow(0) cXL XLRowEnd() XLRow(2).

ASSIGN
   dDS = 0
   dDK = 0
   dSS = 0
   dSK = 0
   NO-ERROR.

FOR FIRST tmprecid 
   NO-LOCK,
   FIRST loan
      WHERE RECID(loan) EQ tmprecid.id
   NO-LOCK,
   EACH ustr
      WHERE (ustr.contract   EQ "card-equip")
        AND (ustr.class-code EQ "card-equip")
        AND (ustr.parent-cont-code EQ loan.cont-code)
   NO-LOCK,
   EACH pc-trans
      WHERE CAN-DO("TransAcquiring,UCSAcq,UCSCard", pc-trans.class-code)
        AND (pc-trans.sur-equip  EQ ("card-equip," + ustr.cont-code))
        AND (pc-trans.proc-date  GE beg-date)
        AND (pc-trans.proc-date  LE end-date)
   NO-LOCK
   BREAK BY ustr.doc-num
         BY pc-trans.proc-date
         BY pc-trans.cont-date:

   FIND FIRST pc-trans-amt
      WHERE (pc-trans-amt.pctr-id  EQ pc-trans.pctr-id)
        AND (pc-trans-amt.amt-code EQ "����")
      NO-LOCK NO-ERROR.
   dSUM = pc-trans-amt.amt-cur.

   FIND FIRST pc-trans-amt
      WHERE (pc-trans-amt.pctr-id  EQ pc-trans.pctr-id)
        AND (pc-trans-amt.amt-code EQ "�����")
      NO-LOCK NO-ERROR.
   dKOM = pc-trans-amt.amt-cur.

   IF (NOT pc-trans.dir)
   THEN
      ASSIGN
         dSUM = - dSUM
         dKOM = - dKOM
         NO-ERROR.

   ASSIGN
      dDS = dDS + dSUM
      dDK = dDK + dKOM
      dSS = dSS + dSUM
      dSK = dSK + dKOM
      NO-ERROR.

   CASE pc-trans.pl-sys:
      WHEN "DC"   THEN dKomm = 4.0.
      WHEN "AMEX" THEN dKomm = 0.0.
      WHEN "JC"   THEN dKomm = 1.8.
      OTHERWISE DO:
         dKomm = 0.0.
         FOR EACH loan-cond
            WHERE (loan-cond.contract  EQ loan.contract)
              AND (loan-cond.cont-code EQ loan.cont-code)
              AND (loan-cond.since     LE pc-trans.cont-date)
            NO-LOCK
            BY loan-cond.since DESCENDING:

            dKomm = DECIMAL(SUBSTR(loan-cond.class-code, 4, 2)) / 10.0.
            LEAVE.
         END.
      END.
   END CASE.

   cXL = XLDateCell(pc-trans.cont-date)
       + XLCell(pc-trans.pctr-code)
       + XLCell(pc-trans.num-card)
       + XLCell(pc-trans.pl-sys)
       + XLCell(ustr.doc-num)
       + XLNumECell(dKomm)
       + XLNumECell(dSUM)
       + XLNumECell(dKOM)
       + XLNumECell(dSUM - dKOM)
       .
   PUT UNFORMATTED cXL XLRowEnd().

   IF LAST-OF(pc-trans.proc-date)
   THEN DO:
      cXL = XLCell("�����饭�� �� " + STRING(pc-trans.proc-date, "99.99.9999"))
          + XLEmptyCells(6)
          + XLNumECell(dDS)
          + XLNumECell(dDK)
          + XLNumECell(dDS - dDK)
          .
      PUT UNFORMATTED XLRow(1) cXL XLRowEnd().

      ASSIGN
         dDS = 0
         dDK = 0
         NO-ERROR.

      IF LAST-OF(ustr.doc-num)
      THEN DO:
         cXL = XLEmptyCell()
             + XLCell("����� �� ���ன��� " + ustr.doc-num)
             + XLEmptyCells(5)
             + XLNumECell(dSS)
             + XLNumECell(dSK)
             + XLNumECell(dSS - dSK)
             .
         PUT UNFORMATTED XLRow(2) cXL XLRowEnd() XLRow(2) XLRowEnd() XLRow(2).

         ASSIGN
            dSS = 0
            dSK = 0
            NO-ERROR.
      END.
      ELSE
         PUT UNFORMATTED XLRow(1).

   END.
   ELSE
      PUT UNFORMATTED XLRow(0).

END.

PUT UNFORMATTED XLRowEnd() XLEnd().

{intrface.del}
