{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪠ �����⮢(��) ��� �ᯮ�� .
                ���ᨬ�� �.�., 23.10.2007
   �� ���졥 ������ �.�. � ������ ������� ���� "����饭�� �� �������", "�����", "����".
   rusinov 06.05.08 15:48
*/

/** �������� ��।������ */
{globals.i}
/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}
/** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get xclass}
/** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get strng}

{sh-defs.i}
{pir_exf_vrt.i}

/******************************************* ��।������ ��६����� � ��. */
DEF VAR FirstStr AS LOGICAL          NO-UNDO.
DEF VAR cXL      AS CHAR             NO-UNDO.
DEF VAR symb     AS CHAR INITIAL "-" NO-UNDO.
DEF VAR cNShort  AS CHAR             NO-UNDO. /* �������� ������ */
DEF VAR cId      AS CHAR             NO-UNDO.
DEF VAR cDate    AS CHAR             NO-UNDO.
DEF VAR cUser    AS CHAR             NO-UNDO. /* ����㤭��, �����訩 ���� */
DEF VAR cDolgn   AS CHAR             NO-UNDO. /* ��� ���������             */
DEF VAR cKlb     AS CHAR             NO-UNDO. /* ������-����               */
DEF VAR cAdr     AS CHAR             NO-UNDO. /* ���� ����              */

{pir_xf_def.i}  /* GetLastHistoryDate */

{pir_exf_exl.i}

{exp-path.i &exp-filename = "'ul.xls'"}

/******** ����㤭��, �����訩 ���� *********************/
FIND FIRST _user
   WHERE (_user._userid EQ USERID)
   NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValue("_user", _user._userid, "���������").

/******************************************* ��������� */
PUT UNFORMATTED XLHead("ul", "CCDCCCCCCCCDCCCCCCCCCCCCCCCCCCCDDDCDDCCCC", ",150").

cXL = XLCell("������������")
    + XLCell("���")
    + XLCell("��� ��������")
    + XLCell("������-����")
    + XLCell("C���饭�� �� �������")
    + XLCell("����饭��� ������������")
    + XLCell("������᪮� ������������")
    + XLCell("�࣠�.�ࠢ.�ଠ")
    + XLCell("����")
    + XLCell("�����")
    + XLCell("����")
    + XLCell("��� ॣ����樨")
    + XLCell("���� ॣ����樨")
    + XLCell("�ਤ��᪨� ����")
    + XLCell("�ਤ��᪨� ���� (����)")
    + XLCell("�����᪨� ����")
    + XLCell("�����᪨� ���� (����)")
    + XLCell("����䮭")
    + XLCell("����")
    + XLCell("���")
    + XLCell("���")
    + XLCell("������� (���)")
    + XLCell("�ᯮ����.�࣠�")
    + XLCell("��饥 ᮡ࠭��")
    + XLCell("����� ��४�஢")
    + XLCell("���⠢ ���")
    + XLCell("����⠫")
    + XLCell("������⢨� �࣠�� �ࠢ�����")
    + XLCell("����������(��)")
    + XLCell("pirOtherBanks")
    + XLCell("�業�� �᪠")
    + XLCell("��� ��ࢮ�� ���")
    + XLCell("��� ��砫�")
    + XLCell("��� ��᫥����� ���������")
    + XLCell("��業���")
    + XLCell("��� ������ ���")
    + XLCell("��� ������� ���")
    + XLCell("����⭨�, ����訩 ���")
    + XLCell("���������")
    + XLCell("����⭨�, ��⠢��訩 ����")
    + XLCell("���������")
    .

PUT UNFORMATTED XLRow(0) cXL XLRowEnd().

FOR EACH tmprecid
   NO-LOCK,
   FIRST cust-corp
      WHERE (RECID(cust-corp) = tmprecid.id)
      NO-LOCK:

   FirstStr = YES.

   FOR EACH acct
      WHERE (acct.cust-cat EQ "�")
        AND (acct.cust-id  EQ cust-corp.cust-id)
      NO-LOCK
      BREAK BY acct:

   IF VrTest(acct.acct, acct.currency, acct.open-date, acct.close-date)
   THEN DO:

      put screen col  1 row 24 "��ࠡ��뢠���� " + TRIM(acct.acct) + STRING(" ","X(45)").
      put screen col 77 row 24 "(" + symb + ")" .
      CASE symb :
         WHEN "\\"  THEN symb = "|".
         WHEN "|"   THEN symb = "/".
         WHEN "/"   THEN symb = "-".
         WHEN "-"   THEN symb = "\\".
      END CASE.

      cNShort = cust-corp.name-short.
      cId     = STRING(cust-corp.cust-id).

      /** ������ ������-���� */
      FIND FIRST mail-user
         WHERE (LOOKUP(acct.acct, mail-user.acct) > 0)
         NO-LOCK NO-ERROR.

      cKlb = (IF (AVAIL mail-user)
              THEN SUBSTRING(mail-user.file-exp ,28 ,5)
              ELSE "").

      PUT UNFORMATTED XLRow(0).

      IF FirstStr THEN DO:
         cDate = GetXAttrValue("cust-corp", cId, "FirstAccDate").
         cXL = XLCell(GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)) + " " + cust-corp.name-corp)
             + XLCell(TRIM(acct.acct))
             + XLDateCell(lastmove)
             + XLCell(cKlb)
             + XLCell(GetXAttrValue("cust-corp", cId, "mess"))
             + XLCell(cNShort)
             + XLCell(GetXAttrValue("cust-corp", cId, "engl-name"))
             + XLCell(GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)))
             + XLCell(GetXAttrValue("cust-corp", cId, "����"))
             + XLCell(GetXAttrValue("cust-corp", cId, "�����"))
             + XLCell(cust-corp.okpo)
             + XLDateCell(DATE(GetXAttrValue("cust-corp", cId, "RegDate")))
             + XLCell(GetXAttrValue("cust-corp", cId, "RegPlace"))
             .

         FIND FIRST cust-ident
            WHERE cust-ident.cust-cat       EQ "�"
              AND cust-ident.cust-id        EQ cust-corp.cust-id
              AND cust-ident.cust-code-type EQ "�����"
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
            NO-ERROR.

         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cXL = cXL
             + XLCell(cAdr)
             + XLCell(DelDoubleChars((IF (cust-corp.addr-of-low[1] NE cust-corp.addr-of-low[2])
                      THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2]
                      ELSE cust-corp.addr-of-low[1]),",")).

         FIND FIRST cust-ident
            WHERE cust-ident.cust-cat       EQ '�'
              AND cust-ident.cust-id        EQ cust-corp.cust-id
              AND cust-ident.cust-code-type EQ '�������'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
            NO-ERROR.

         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cXL = cXL
             + XLCell(cAdr)
             + XLCell(GetXAttrValue("cust-corp", cId, "����"))
             + XLCell(GetXAttrValue("cust-corp", cId, "tel"))
             + XLCell(cust-corp.fax)
             + XLCell(cust-corp.inn)
             + XLCell(GetXAttrValue("cust-corp", cId, "���"))
             + XLCell(GetXAttrValue("cust-corp", cId, "������"))
             + XLCell(GetXAttrValue("cust-corp", cId, "�ᯮ���࣠�"))
             + XLCell(GetXAttrValue("cust-corp", cId, "��鑮�࠭��"))
             + XLCell(GetXAttrValue("cust-corp", cId, "���⠢��"))
             + XLCell(GetXAttrValue("cust-corp", cId, "���⠢���"))
             + XLCell(GetXAttrValue("cust-corp", cId, "��⠢���"))
             + XLCell(GetXAttrValue("cust-corp", cId, "�����࣓�ࠢ"))
             + XLCell(GetXAttrValue("cust-corp", cId, "��᪎��"))
             + XLCell(GetXAttrValue("cust-corp", cId, "pirOtherBanks"))
             + XLCell(GetXAttrValue("cust-corp", cId, "�業����᪠"))
             + XLDateCell(DATE(cDate))
             + XLDateCell(IF cDate = "" THEN cust-corp.date-in ELSE DATE(cDate))
             + XLDateCell(GetLastHistoryDate("cust-corp", cId)).

         /** ������ ����� ��業���  */
         FIND FIRST cust-ident
            WHERE cust-ident.cust-cat   EQ "�"
              AND cust-ident.cust-id    EQ cust-corp.cust-id
              AND cust-ident.class-code EQ "cust-lic"
            NO-LOCK NO-ERROR.

         IF AVAIL cust-ident
         THEN
            cXL = cXL
                + XLCell(GetCodeName("�����愥��", cust-ident.cust-code-type) + " " +
                         cust-ident.cust-code + " " + STRING(cust-ident.open-date,"99.99.9999") + " " +
                         cust-ident.issue + " " + STRING(cust-ident.close-date,"99.99.9999")).
         ELSE
            cXL = cXL
                + XLEmptyCell().

         FirstStr = NO.
      END.
         ELSE
         cXL = XLCell(GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)) + " " + cust-corp.name-corp)
             + XLCell(TRIM(acct.acct))
             + XLDateCell(lastmove)
             + XLCell(cKlb)
             + XLCell(GetXAttrValue("cust-corp", cId, "mess"))
             + XLEmptyCells(30).

      cXL = cXL
          + XLDateCell(acct.open-date)
          + XLDateCell(acct.close-date).

      FIND FIRST _user
         WHERE (_user._userid EQ acct.user-id)
         NO-LOCK NO-ERROR.

      IF AVAIL _user THEN 
         cXL = cXL
             + XLCell(_user._user-name)
             + XLCell(GetXAttrValue("_user", _user._userid, "���������"))
             .
      ELSE
         cXL = cXL
             + XLEmptyCell()
             + XLEmptyCell()
             .

      cXL = cXL
          + XLCell(cUser)
          + XLCell(cDolgn)
          .

      PUT UNFORMATTED cXL XLRowEnd() .
   END.
   END.
END.

PUT UNFORMATTED XLEnd().
put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
