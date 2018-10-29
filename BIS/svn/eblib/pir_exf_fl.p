{pirsavelog.p}
/** 
                ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪠ �����⮢(��) ��� �ᯮ�� .
                ���ᨬ�� �.�., 23.10.2007
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
DEF VAR cTmpStr  AS CHAR             NO-UNDO. 
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

{exp-path.i &exp-filename = "'fl.xls'"}

/******** ����㤭��, �����訩 ���� *********************/
FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValueEx("_user", _user._userid, "���������", "").

/******************************************* ��������� */
PUT UNFORMATTED XLHead("fl", "CCDCDCCCCCCCCCDDDDCCCCCCCCCDDDDDCCCC", ",150").
PUT UNFORMATTED XLRow(0) .

cTmpStr = XLCell("���") +
          XLCell("���") +
          XLCell("��� ��������") +
          XLCell("������-����") +
          XLCell("��� ஦�����") +
          XLCell("���� ஦�����") +
          XLCell("�ࠦ����⢮") +
          XLCell("��ᯮ��� �����") +
          XLCell("����樮���� ����") +
          XLCell("����") +
          XLCell("���� ���(�����)") +
          XLCell("���� �����") +
          XLCell("�ࠦ����⢮ �� ����") +
          XLCell("���� �����") +
          XLCell("��砫� �����") +
          XLCell("����� �����") +
          XLCell("�����ࠢ�ॡ�") +
          XLCell("�����ࠢ�ॡ��") +
          XLCell("����") +
          XLCell("���� (����)") +
          XLCell("�����᪨� ����") +
          XLCell("�����᪨� ���� (����)") +
          XLCell("���") + 
          XLCell("����䮭") +
          XLCell("����") +
          XLCell("����������(��)") +
          XLCell("�業�� �᪠") +
          XLCell("��� ��ࢮ�� ���") +
          XLCell("��� ��砫�") +
          XLCell("��� ��᫥����� ��������") +
          XLCell("��� ������ ���") +
          XLCell("��� ������� ���") +
          XLCell("����⭨�, ����訩 ���") +
          XLCell("���������") +
          XLCell("����⭨�, ��⠢��訩 ����") +
          XLCell("���������").

PUT UNFORMATTED cTmpStr XLRowEnd() .

FOR EACH tmprecid NO-LOCK,
   FIRST person WHERE RECID(person) = tmprecid.id NO-LOCK:

   FirstStr = YES.

   FOR EACH acct WHERE  acct.cust-cat EQ "�"  AND 
                        acct.cust-id EQ person.person-id
                        NO-LOCK BREAK BY acct :

   IF VrTest(acct.acct, acct.currency, acct.open-date, acct.close-date)
   THEN DO:

      put screen col 1 row 24 "��ࠡ��뢠���� " + TRIM(acct.acct) + STRING(" ","X(45)").
      put screen col 77 row 24 "(" + symb + ")" .
      CASE symb :
         WHEN "\\"  THEN symb = "|".
         WHEN "|"   THEN symb = "/".
         WHEN "/"   THEN symb = "-".
         WHEN "-"   THEN symb = "\\".
      END CASE.

      cNShort = person.name-last + " " + person.first-names.
      cId     = STRING(person.person-id).

      /** ������ ������-���� */
      FIND FIRST mail-user WHERE (LOOKUP(acct.acct, mail-user.acct) > 0) NO-LOCK NO-ERROR.
      cKlb = (IF AVAIL mail-user THEN SUBSTRING(mail-user.file-exp ,28 ,5) ELSE "").

      PUT UNFORMATTED XLRow(0) .

      IF FirstStr THEN DO:
         cDate = GetXAttrValueEx("person", cId, "FirstAccDate", "").

         cTmpStr = XLCell(cNShort) +
/*                      person.name-last + " " + ENTRY(1, person.first-names, " ") + " " + 
                        (IF NUM-ENTRIES(person.first-names, " ") > 1 THEN ENTRY(2, person.first-names, " ") ELSE "")
*/
                   XLCell(TRIM(acct.acct)) +
                   XLDateCell(lastmove) +
                   XLCell(cKlb) +
                   XLDateCell(person.birthday) +
                   XLCell(GetXAttrValueEx("person", cId, "BirthPlace", "")).

         /** ������ �ࠦ����⢮ */
         FIND FIRST country WHERE country.country-id = person.country-id NO-LOCK NO-ERROR.
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL country THEN country.country-name ELSE "").

         /** ������ ���㬥�� */
         FIND FIRST cust-ident
            WHERE cust-ident.cust-cat   = "�"
              AND cust-ident.Class-code = "p-cust-ident"
              AND cust-ident.cust-id    = person.person-id
              AND cust-ident.close-date EQ ?
            NO-LOCK NO-ERROR.

/* �⫠������ ���ࠢ���� ������� 03.06.2009
DEFINE VARIABLE cT AS CHARACTER NO-UNDO.
IF AVAIL cust-ident
THEN DO:

   cT = GetCodeName("�������", cust-ident.cust-code-type) + " "
      + cust-ident.cust-code + " �뤠� "
      + STRING(cust-ident.open-date, "99.99.9999") + " "
      + REPLACE(cust-ident.issue,'\n','').
   IF cT EQ ? THEN
      MESSAGE cNShort SKIP
              GetCodeName("�������", cust-ident.cust-code-type) SKIP
              cust-ident.cust-code SKIP
              STRING(cust-ident.open-date, "99.99.9999") SKIP
              REPLACE(cust-ident.issue,'\n','') SKIP
         VIEW-AS ALERT-BOX ERROR.
END.
*/
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL cust-ident THEN (GetCodeName("�������", cust-ident.cust-code-type) + " " + cust-ident.cust-code
                           + " �뤠� " + STRING(cust-ident.open-date, "99.99.9999") + " " + REPLACE(cust-ident.issue,'\n','')) ELSE "") +
                   XLCell(GetXAttrValueEx("person", cId, "��������", "")).

         IF GetCodeName("VisaType", GetXAttrValueEx("person", cId, "VisaType", "")) <> ? THEN 
            cTmpStr = cTmpStr +
                      XLCell(GetCodeName("VisaType",GetXAttrValueEx("person", cId, "VisaType", "")) 
                             + " " + GetXAttrValueEx("person", cId, "Visa", "")) +
                      XLCell(IF NUM-ENTRIES(GetXAttrValueEx("person", cId, "VisaNum", ""), " ") > 1
                             THEN ENTRY(2, GetXAttrValueEx("person", cId, "VisaNum", ""), " ") ELSE " " ) +
                      XLCell(ENTRY(1, GetXAttrValueEx("person", cId, "VisaNum", ""), " ")).
         ELSE
            cTmpStr = cTmpStr +
                      XLEmptyCell() +
                      XLEmptyCell() +
                      XLEmptyCell().

         /** ������ �ࠦ����⢮ �� ���� */
         FIND FIRST country WHERE country.country-id = GetXAttrValueEx("person", cId, "country-id2", "") NO-LOCK NO-ERROR.
         cTmpStr = cTmpStr +
                   XLCell(IF AVAIL country THEN country.country-name ELSE "") +
                   XLCell(GetXAttrValueEx("person", cId, "�������삨���", "")) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "�����ॡ뢑", ""))) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "�����ॡ뢏�", ""))) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "�����ࠢ�ॡ�", ""))) +
                   XLDateCell(DATE(GetXAttrValueEx("person", cId, "�����ࠢ�ॡ��", ""))).

         FIND FIRST cust-ident WHERE
                  cust-ident.cust-cat       EQ '�'
              AND cust-ident.cust-id        EQ person.person-id
              AND cust-ident.cust-code-type EQ '�����'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
         NO-ERROR.
         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cTmpStr = cTmpStr +
                   XLCell(cAdr) +
                   XLCell(DelDoubleChars(IF person.address[1] = person.address[2] THEN person.address[1] 
                                         ELSE (person.address[1] + "," + person.address[2]), ",")).

         FIND FIRST cust-ident WHERE
                  cust-ident.cust-cat       EQ '�'
              AND cust-ident.cust-id        EQ person.person-id
              AND cust-ident.cust-code-type EQ '�������'
              AND cust-ident.class-code     EQ "p-cust-adr"
              AND cust-ident.close-date     EQ ?
         NO-ERROR.
         cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

         cTmpStr = cTmpStr +
                   XLCell(cAdr) +
                   XLCell(DelDoubleChars(GetXAttrValueEx("person", cId, "PlaceOfStay", ""), ",")) +
                   XLCell(person.inn) + 
                   XLCell(TRIM(person.phone[1] + " " + person.phone[2])) +
                   XLCell(person.fax) +
                   XLCell(GetXAttrValueEx("person", cId, "��᪎��", "")) +
                   XLCell(if GetCode("Pir�業����᪠", GetXAttrValueEx("person", cId, "�業����᪠", "")) = ? 
                          then GetXAttrValueEx("person", cId, "�業����᪠", "") 
                          else GetCode("Pir�業����᪠", GetXAttrValueEx("person", cId, "�業����᪠", ""))) +
                   XLDateCell(DATE(cDate)) +
                   XLDateCell(DATE(IF cDate = "" THEN GetXAttrValueEx("person", cId, "date-in", "") ELSE cDate)) +
                   XLDateCell(GetLastHistoryDate("person", cId)) .

         FirstStr = NO.
      END.
      ELSE
         cTmpStr = XLCell(cNShort) +
                   XLCell(TRIM(acct.acct)) +
                   XLDateCell(lastmove) +
                   XLCell(cKlb) +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                   XLEmptyCell() + XLEmptyCell().

      cTmpStr = cTmpStr +
                XLDateCell(acct.open-date) +
                XLDateCell(acct.close-date).

      FIND FIRST _user WHERE _user._userid = acct.user-id NO-LOCK NO-ERROR.
      IF AVAIL _user THEN 
         cTmpStr = cTmpStr +
                   XLCell(_user._user-name) +
                   XLCell(GetXAttrValueEx("_user", _user._userid, "���������", "")).
      ELSE
         cTmpStr = cTmpStr +
                   XLEmptyCell() +
                   XLEmptyCell().

      cTmpStr = cTmpStr +
                XLCell(cUser) +
                XLCell(cDolgn).

      PUT UNFORMATTED cTmpStr XLRowEnd().
   END.
   END.
END.

PUT UNFORMATTED XLEnd().

put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
