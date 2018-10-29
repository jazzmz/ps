{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
      ���⠭����/��⨥ ����஫� �����
*/

{globals.i}           /** �������� ��।������ */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{intrface.get xclass} /** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get strng}  /** �㭪樨 ��� ࠡ��� � ��ப��� */
{get-bankname.i}
{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEF VAR cXL   AS CHAR     NO-UNDO.
DEF VAR iI    AS INTEGER  NO-UNDO.

{pir_exf_exl.i}
{exp-path.i &exp-filename = "'ReestrPODFT.xls'"}

/******************************************* ��������� */
/* PUT UNFORMATTED XLHead("op", "CCDCDDCCCCDDCCCCNNCC", "28,70,71,200,71,71,150,200,71,200,71,71,150,200,71,30,110,110,200,137").*/
PUT UNFORMATTED XLHead("op", "CCDCCDDCCCCCDDCCCCNNCC�", "28,70,71,200,120,71,71,150,200,71,200,150,71,71,120,200,71,30,110,110,200,137").


cXL = XLCell("N")
    + XLCell("����� ���㬥��")
    + XLCell("��� ���㬥��")

    + XLCell("������������ ���⥫�騪�")

    + XLCell("��� ���⥫�騪�")

    + XLCell("��� ॣ����樨 ���⥫�騪�")
    + XLCell("��� ")
    + XLCell("�/� ���⥫�騪�")
    + XLCell("���� ���⥫�騪�")
    + XLCell("��� ����� ���⥫�騪�")

    + XLCell("������������ �����⥫�")

    + XLCell("��� �����⥫�")

    + XLCell("��� ॣ����樨 �����⥫�")
    + XLCell("��� ")
    + XLCell("�/� �����⥫�")
    + XLCell("���� �����⥫�")
    + XLCell("��� ����� �����⥫�")

    + XLCell("����� �஢����")
    + XLCell("�㬬� (���)")
    + XLCell("�㬬� (��)")
    + XLCell("�����祭�� ���⥦�")
    + XLCell("��� ������⥫쭮�� ���㬥��")
    + XLCell("��� �����筮�� ���㬥��")
    .

PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .

iI = 0.

FOR EACH tmprecid
   NO-LOCK,
   FIRST op
      WHERE (RECID(op) EQ tmprecid.id)
        AND NOT (op.doc-num BEGINS "�")
      NO-LOCK
   BY op.op-date
   BY op.op-status
   BY op.user-id
   BY op.op:

   iI = iI + 1.

   FOR EACH op-entry OF op
      NO-LOCK:

      cXL = XLCell(STRING(iI))
          + XLCell(op.doc-num)
          + XLDateCell(op.op-date)
          .
      RUN OneAcct(op-entry.acct-db, INPUT-OUTPUT cXL).
      RUN OneAcct(op-entry.acct-cr, INPUT-OUTPUT cXL).

      cXL = cXL
          + XLCell(op-entry.currency)
          + XLNumECell(IF (op-entry.currency EQ "") THEN 0 ELSE op-entry.amt-cur)
          + XLNumCell(amt-rub)
          + XLCell(op.details)
          + XLCell(GetXAttrValue("op", STRING(op.op), "��������㬥��"))
          + XLCell(GetXAttrValue("op", STRING(op.op), "������������"))
          .
      PUT UNFORMATTED XLRow(0) cXL XLRowEnd() .
   END.
END.

PUT UNFORMATTED XLEnd().

{intrface.del}

/* ========================================================================= */
FUNCTION LookLastMove RETURNS DATE
  (INPUT in-acct     AS CHARACTER,
   INPUT in-currency AS CHARACTER,
   INPUT in-since    AS DATE).

   DEFINE VARIABLE cTm      AS CHARACTER NO-UNDO.

   RUN acct-pos IN h_base(in-acct, in-currency, in-since, in-since, cTm).
   RETURN (IF (in-currency = "") THEN lastmove ELSE lastcurr).

END FUNCTION.

/*************************************************/
PROCEDURE OneAcct:
DEFINE INPUT        PARAMETER inAcct AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER ioXL   AS CHARACTER.

DEFINE VARIABLE daLast  AS DATE       NO-UNDO.
DEFINE VARIABLE cKl     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE daKl    AS DATE       NO-UNDO.
DEFINE VARIABLE cINN    AS CHARACTER  init "" NO-UNDO.

   CASE inAcct:
      WHEN ? THEN DO:
         ioXL = ioXL
              + XLEmptyCells(7). /*�뫮 6*/ 
      END.
      WHEN "30102810900000000491" THEN DO:
         IF {assigned op.name-ben}
         THEN DO:

            ioXL = ioXL
                 + XLCell(op.name-ben)
                 + XLCell("") /*���*/
                 + XLCell("")
                 + XLCell("")
                 + XLCell(op.ben-acct)
                 .
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
               ioXL = ioXL
                    + XLCell(banks.name)
                    + XLCell(op-bank.bank-code)
                    .
            END.
            ELSE
               ioXL = ioXL
                    + XLEmptyCells(3). /*�뫮 2 */
         END.
         ELSE DO:
            ioXL = ioXL
                 + XLCell(cBankName)
                 + XLCell("")
                 + XLCell("")
                 + XLCell(inAcct)
                 + XLCell(cBankName)
                 + XLCell("044585491")
                 .
         END.
      END.
      OTHERWISE DO:

         FIND FIRST acct
            WHERE (acct.acct EQ inAcct)
            NO-LOCK NO-ERROR.

         IF (AVAIL acct)
         THEN DO:
            cKl  = "".
            daKl = ?.
            cINN = "".

            CASE acct.cust-cat:
               WHEN "�" THEN DO:
                  FIND FIRST cust-corp
                     WHERE cust-corp.cust-id = acct.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL cust-corp
                  THEN DO:
                     cKl  = cust-corp.cust-stat + " " + cust-corp.name-corp.
                     daKl = DATE(GetXAttrValue("cust-corp", STRING(acct.cust-id), "RegDate")).
		     cINN = cust-corp.inn.
                  END.
               END.
               WHEN "�" THEN DO:
                  FIND FIRST person
                     WHERE person.person-id = acct.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL person
                  THEN DO:
                     cKl  = person.name-LAST + " " + person.first-names.
                     daKl = person.birthday.
		     cINN = person.inn.
                  END.
               END.
               WHEN "�" THEN DO:
                  FIND FIRST banks
                     WHERE banks.bank-id = acct.cust-id
                     NO-LOCK NO-ERROR.
                  IF AVAIL banks
                  THEN DO:
                     cKl  = banks.name.
                     daKl = DATE(GetXAttrValue("banks", STRING(acct.cust-id), "RegDate")).
		     cINN = banks.inn.
                  END.
               END.
               WHEN "�" THEN DO:
                  cKl  = acct.Details.
               END.
            END CASE.

            ioXL = ioXL
                 + XLCell(cKl)
                 + XLCell(cINN) /*���*/
                 + XLDateCell(daKl)
                 + XLDateCell(LookLastMove(acct.acct, acct.currency, op.op-date - 1))
                 .
         END.
         ELSE
            ioXL = ioXL
                 + XLCell("")
                 + XLCell("")
                 + XLCell("")
                 + XLCell("") /*���*/
                 .

         ioXL = ioXL
              + XLCell(inAcct)
              + XLCell(cBankName)
              + XLCell("044585491")
              .
      END.
   END CASE.

END PROCEDURE.
