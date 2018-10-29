{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪮� ���� ��� ��������.
*/

/** �������� ��।������ */
{globals.i}
/** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get xclass}
/** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get strng}

{sh-defs.i}

/******************************************* ��।������ ��६����� � ��. */
DEFINE VARIABLE cTmpStr  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cId      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFxl     AS CHARACTER NO-UNDO. /* ��� 䠩�� */
DEFINE STREAM   xl.

/* {pir_xf_def.i}  GetLastHistoryDate */

{pir_exf_exl.i}

/* �뢮� � ��⮪ xl */

OUTPUT STREAM xl CLOSE.
cFxl = STRING(YEAR(TODAY)) + STRING(MONTH(TODAY), "99") + STRING(DAY(TODAY), "99").
cFxl = "/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/besp" + cFxl + ".xls".

REPEAT:
   {getfile.i &filename = cFxl &mode = create} 
   LEAVE.
END.

OUTPUT STREAM xl THROUGH unix-dos > VALUE(fname).

/********************************************/
PUT STREAM xl UNFORMATTED XLHead("besp", "CCCCC", "410,81,70,49,450") XLRow(0).

cTmpStr = XLCell("������������ �����") +
          XLCell("��� �����") +
          XLCell("���") +
          XLCell("���") +
          XLCell("����. �����").

PUT STREAM xl UNFORMATTED cTmpStr XLRowEnd() XLRow(2).

put screen col 1 row 24 color normal "��ନ��� 䠩� ����".
/* ������ ���� */
FOR EACH banks NO-LOCK:

   cId = STRING(banks.bank-id).
   IF GetXAttrValueEx("banks", cId, "uer", "") = "4"
   THEN DO:

      FIND FIRST banks-code OF banks WHERE banks-code.bank-code-type = "���-9" NO-LOCK NO-ERROR.
      cTmpStr = XLCell(banks.name) +
                XLCell(IF AVAIL banks-code THEN banks-code.bank-code ELSE "") +
                XLCell(GetXAttrValue("banks", cId, "���")) +
                XLCell(STRING(banks.bank-id)) +
                XLCell(banks.law-address).
      PUT STREAM xl UNFORMATTED cTmpStr XLRowEnd() XLRow(0).

   END.
END.

put screen col 1 row 24 color normal "��ନ��� 䠩� ����-��".
/* ������ ����-�� */
FOR EACH banks NO-LOCK:

   cId = STRING(banks.bank-id).
   IF (GetXAttrValueEx("banks", cId, "uer", "") = "3") AND
      (CAN-DO("!*���*,!����,!��,*", banks.bank-type))
   THEN DO:

      FIND FIRST banks-code OF banks WHERE banks-code.bank-code-type = "���-9" NO-LOCK NO-ERROR.
      cTmpStr = XLCell(banks.name) +
                XLCell(IF AVAIL banks-code THEN banks-code.bank-code ELSE "") +
                XLCell(GetXAttrValue("banks", cId, "���")) +
                XLCell(STRING(banks.bank-id)) +
                XLCell(banks.law-address).
      PUT STREAM xl UNFORMATTED cTmpStr XLRowEnd() XLRow(0).

   END.
END.

PUT STREAM xl UNFORMATTED XLRowEnd() XLEnd().
OUTPUT STREAM xl CLOSE.

put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
