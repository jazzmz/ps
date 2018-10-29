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

{exp-path.i &exp-filename = "'ip.xls'"}

/******** ����㤭��, �����訩 ���� *********************/
FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValueEx("_user", _user._userid, "���������", "").

/******************************************* ��������� */
PUT UNFORMATTED XLHead("ip", "CCDCDCCCCCCCCCCDDDDCCCCCDCCCCCCCDDDDDCCCC", ",150").
PUT UNFORMATTED XLRow(0) .

cTmpStr = XLCell("������������") +
          XLCell("���") +
          XLCell("��� ��������") +
          XLCell("������-����") +
          XLCell("��� ஦�����") +
          XLCell("���� ஦�����") +
          XLCell("�ࠦ����⢮") +
          XLCell("��業���") +
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
          XLCell("����") +
          XLCell("��� ॣ����樨") +
          XLCell("���� ॣ����樨") +
          XLCell("���") +
          XLCell("����䮭") +
          XLCell("����") +
          XLCell("����������(��)") +
          XLCell("pirOtherBanks") +
          XLCell("�業�� �᪠") +
          XLCell("��� ��ࢮ�� ���") +
          XLCell("��� ��砫�") +
          XLCell("��� ��᫥����� ���������") +
          XLCell("��� ������ ���") +
          XLCell("��� ������� ���") +
          XLCell("����⭨�, ����訩 ���") +
          XLCell("���������") +
          XLCell("����⭨�, ��⠢��訩 ����") +
          XLCell("���������").

PUT UNFORMATTED cTmpStr XLRowEnd() .

FOR EACH tmprecid NO-LOCK,
   FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK:

   cId = STRING(cust-corp.cust-id).

   IF (cust-corp.cust-stat EQ "��") OR 
      (cust-corp.cust-stat EQ "�����") OR
      (GetXAttrValueEx("cust-corp", cId, "�।�ਭ���⥫�", "") EQ "�।��")
   THEN DO:

/******************************************* . */
      FirstStr = YES.

      FOR EACH acct WHERE  acct.cust-cat EQ "�"  AND 
                           acct.cust-id EQ cust-corp.cust-id
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

         cNShort = cust-corp.name-corp.

         /** ������ ������-���� */
         FIND FIRST mail-user WHERE (LOOKUP(acct.acct, mail-user.acct) > 0) NO-LOCK NO-ERROR.
         cKlb = (IF AVAIL mail-user THEN SUBSTRING(mail-user.file-exp ,28 ,5) ELSE "").

         PUT UNFORMATTED XLRow(0) .

         IF FirstStr THEN DO:
            cDate = STRING(DATE(GetXAttrValueEx("cust-corp", cId, "FirstAccDate", "")),"99.99.9999").
            cTmpStr = XLCell(cust-stat + " " + TRIM(ENTRY(1, cNShort, " ") + " " +
                         (IF NUM-ENTRIES(cNShort, " ") > 1 THEN (ENTRY(2, cNShort, " ") + " ") ELSE "") +
                         (IF NUM-ENTRIES(cNShort, " ") > 2 THEN ENTRY(3, cNShort, " ") ELSE ""))) +
                      XLCell(TRIM(acct.acct)) +
                      XLDateCell(lastmove) +
                      XLCell(cKlb) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "BirthDay", ""))) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "BirthPlace", "")).

            /** ������ �ࠦ����⢮ */
            FIND FIRST country WHERE country.country-id = cust-corp.country-id NO-LOCK NO-ERROR.
            cTmpStr = cTmpStr +
                      XLCell(IF AVAIL country THEN country.country-name ELSE "").

            /** ������ ����� ��業���  */
            FIND FIRST cust-ident WHERE cust-ident.cust-cat EQ "�"
                                    AND cust-ident.cust-id  EQ cust-corp.cust-id
                                    AND cust-ident.class-code = "cust-lic" NO-LOCK NO-ERROR.
            cTmpStr = cTmpStr +
                      XLCell(IF AVAIL cust-ident THEN
                              (GetCodeName("�����愥��", cust-ident.cust-code-type) + " " +
                               cust-ident.cust-code + " " + STRING(cust-ident.open-date, "99.99.9999") + " " +
                               cust-ident.issue     + " " + STRING(cust-ident.close-date,"99.99.9999")) ELSE "").

            /** ������ ���㬥�� */
            cTmpStr = cTmpStr +
                      XLCell((IF GetXAttrValueEx("cust-corp", cId, "document-id", "") <> "" 
                               THEN GetCodeName("�������", GetXAttrValueEx("cust-corp", cId, "document-id", "")) 
                               ELSE " ") + " " + 
                              GetXAttrValueEx("cust-corp", cId, "document", "") + " �뤠� " +
                              (IF DATE(GetXAttrValueEx("cust-corp", cId, "Document4Date_vid", "")) EQ ? 
                               THEN " " 
                               ELSE STRING(DATE(GetXAttrValueEx("cust-corp", cId, "Document4Date_vid", "")), "99.99.9999")) + " " +
                              GetXAttrValueEx("cust-corp", cId, "issue", "")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "��������", "")).

            IF GetCodeName("VisaType", GetXAttrValueEx("cust-corp", cId, "VisaType", "")) <> ? THEN 
            cTmpStr = cTmpStr +
                      XLCell(GetCodeName("VisaType",GetXAttrValueEx("cust-corp", cId, "VisaType", "")) 
                              + " " + GetXAttrValueEx("cust-corp", cId, "Visa", "")) +
                      XLCell(IF NUM-ENTRIES(GetXAttrValueEx("cust-corp", cId, "VisaNum", ""), " ") > 1 
                              THEN ENTRY(2, GetXAttrValueEx("cust-corp", cId, "VisaNum", ""), " ") 
                              ELSE " " ) +
                      XLCell(ENTRY(1, GetXAttrValueEx("cust-corp", cId, "VisaNum", ""), " ")).
            ELSE
            cTmpStr = cTmpStr +
                      XLEmptyCell() +
                      XLEmptyCell() +
                      XLEmptyCell().

            /** ������ �ࠦ����⢮ �� ���� */
            FIND FIRST country WHERE country.country-id = GetXAttrValueEx("cust-corp", cId, "country-id2", "") NO-LOCK NO-ERROR.
            cTmpStr = cTmpStr +
                      XLCell(IF AVAIL country THEN country.country-name ELSE "") +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "�������삨���", "")) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "�����ॡ뢑", ""))) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "�����ॡ뢏�", ""))) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "�����ࠢ�ॡ�", ""))) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "�����ࠢ�ॡ��", ""))).

            FIND FIRST cust-ident WHERE
                     cust-ident.cust-cat       EQ '�'
                 AND cust-ident.cust-id        EQ cust-corp.cust-id
                 AND cust-ident.cust-code-type EQ '�����'
                 AND cust-ident.class-code     EQ "p-cust-adr"
                 AND cust-ident.close-date     EQ ?
            NO-ERROR.
            cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

            cTmpStr = cTmpStr +
                      XLCell(cAdr) +
                      XLCell(DelDoubleChars((IF cust-corp.addr-of-low[1] = cust-corp.addr-of-low[2] 
                              THEN cust-corp.addr-of-low[1] ELSE cust-corp.addr-of-low[1] + "," + cust-corp.addr-of-low[2]),",")).

            FIND FIRST cust-ident WHERE
                     cust-ident.cust-cat       EQ '�'
                 AND cust-ident.cust-id        EQ cust-corp.cust-id
                 AND cust-ident.cust-code-type EQ '�������'
                 AND cust-ident.class-code     EQ "p-cust-adr"
                 AND cust-ident.close-date     EQ ?
            NO-ERROR.
            cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".

            cTmpStr = cTmpStr +
                      XLCell(cAdr) +
                      XLCell(DelDoubleChars(GetXAttrValueEx("cust-corp", cId, "PlaceOfStay", ""),",")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "����", "")) +
                      XLDateCell(DATE(GetXAttrValueEx("cust-corp", cId, "RegDate", ""))) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "RegPlace", "")) +
                      XLCell(cust-corp.inn) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "tel", "")) +
                      XLCell(cust-corp.fax) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "��᪎��", "")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "pirOtherBanks", "")) +
                      XLCell(GetXAttrValueEx("cust-corp", cId, "�業����᪠", "")) +
                      XLDateCell(DATE(cDate)) +
                      XLDateCell(IF cDate = "" THEN cust-corp.date-in ELSE DATE(cDate)) +
                      XLDateCell(GetLastHistoryDate("cust-corp", cId)).

            FirstStr = NO.    
         END.
         ELSE DO:
            cTmpStr = XLCell(cust-stat + " " + TRIM(ENTRY(1, cNShort, " ") + " " +
                         (IF NUM-ENTRIES(cNShort, " ") > 1 THEN (ENTRY(2, cNShort, " ") + " ") ELSE "") +
                         (IF NUM-ENTRIES(cNShort, " ") > 2 THEN ENTRY(3, cNShort, " ") ELSE ""))) +
                      XLCell(TRIM(acct.acct)) +
                      XLDateCell(lastmove) +
                      XLCell(cKlb) +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell() + XLEmptyCell() +
                      XLEmptyCell() + XLEmptyCell() + XLEmptyCell().
         END.

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
END.

PUT UNFORMATTED XLEnd().
put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

{intrface.del}
