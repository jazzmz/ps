{pirsavelog.p}
/** 
    ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
    ��ନ��� ������ ������ - �������㠫쭮�� �।�ਭ���⥫�
    
    ���� �.�., 14.05.2007 11:23
    
    <���_����᪠����> : ����᪠���� �� ��㧥� �����⮢ ��.
    <��ࠬ���� ����᪠> : ��ப� � ���� ��ࠦ���� <���_��ࠬ���>=<���祭��_��ࠬ���>[,...]
                          ��ࠡ��뢠��� ��ࠬ����: �����⢥ऎ����� - ��� ���㤭��� ��� 䠬���� � ��������� 1.23.
                          �뢮����� � �㭪�
    <���_ࠡ�⠥�>
    <�ᮡ������_ॠ����樨> : �� ᬮ��� �� �, �� ���� ���ଠ樨 ������� �� ⠡��� cust-corp, ��� �࠭���� ���������
                               ���ଠ樨 �ᯮ��㥬 ⠡���� ttBusinessmen, �.�. ��� � �筮�� ���室��.
    
    ��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
              <���ᠭ�� ���������>

    ��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
              <���ᠭ�� ���������>

*/

/** �������� ��।������ */
{globals.i}

/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}

/* �㤥� �ᯮ�짮���� ��७�� �� ᫮��� */
{wordwrap.def}

{parsin.def}
/** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get xclass}
/** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get strng}

/******************************************* ��।������ ��६����� � ��. */

DEFINE INPUT PARAMETER iParam AS CHAR.

/** ��� ���짮��⥫� �� ���� ������, ����� �⢥ত��� ����⨥ ��� */
DEFINE VARIABLE userIdAssent AS CHAR NO-UNDO.
DEFINE VARIABLE userOpenAcct AS CHAR NO-UNDO.
DEFINE VARIABLE cAcct        AS CHAR NO-UNDO.
DEFINE VARIABLE dAcct        AS DATE NO-UNDO.

{pir_xf_def3.i}


/******************************************* ��������� */

/** ������ �室���� ��ࠬ��� */
userIdAssent = GetParamByNameAsChar(iParam, "�����⢥ऎ�����", "").


FOR EACH tmprecid NO-LOCK,
    FIRST cust-corp WHERE RECID(cust-corp) = tmprecid.id NO-LOCK
  :
/******************************************* ��᢮���� ���祭�� ��६���� � ��. */

    CREATE ttBusinessmen.
    ttBusinessmen.lastName = TRIM(ENTRY(1, cust-corp.name-corp, " ")).
    ttBusinessmen.firstName = (IF NUM-ENTRIES(cust-corp.name-corp, " ") > 1 THEN ENTRY(2, cust-corp.name-corp, " ") ELSE "").
    ttBusinessmen.patronymic = (IF NUM-ENTRIES(cust-corp.name-corp, " ") > 2 THEN ENTRY(3, cust-corp.name-corp, " ") ELSE "").
    ttBusinessmen.birthDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthDay", "")).
    ttBusinessmen.birthPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "BirthPlace", "").
    
    /** ������ �ࠦ����⢮ */
    FIND FIRST country WHERE country.country-id = cust-corp.country-id NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBusinessmen.nationality = country.country-name.
    
    /** ����६ ���ଠ�� � ��業���� */
    FOR EACH cust-ident WHERE cust-ident.cust-cat EQ "�"
                               AND cust-ident.cust-id  EQ cust-corp.cust-id 
                               AND cust-ident.class-code = "cust-lic"
      NO-LOCK:

        CREATE ttLicense.
        ttLicense.typeName = GetCodeName("�����愥��", cust-ident.cust-code-type).
        ttLicense.number = cust-ident.cust-code.
        ttLicense.openDate = cust-ident.open-date.
        ttLicense.issue = cust-ident.issue.
        ttLicense.endDate = cust-ident.close-date.

    END.

    /** ������ ���㬥��. ��ଠ� ��ப�: <���_���㬥��> <�����> <�����_�뤠�> <���_�뤠�> */
    ttBusinessmen.document = GetCodeName("�������", 
                        GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document-id", "")) 
                        + " "  + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "document", "")
                        + " �뤠� " + STRING(DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Document4Date_vid", "")), "99.99.9999")
                        + " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "issue", "").
     
     ttBusinessmen.migrationCard = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "��������", "").
     ttBusinessmen.visa = GetCodeName("VisaType", GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "VisaType", "")) 
         + " " + GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "Visa", "").
     ttBusinessmen.visaSeries = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "VisaNum", "").
     ttBusinessmen.visaNumber = (IF NUM-ENTRIES(ttBusinessmen.visaSeries, " ") > 1 THEN ENTRY(2, ttBusinessmen.visaSeries, " ") ELSE "").
     ttBusinessmen.visaSeries = ENTRY(1, ttBusinessmen.visaSeries, " ").
    
    /** ������ �ࠦ����⢮ �� ���� */
    FIND FIRST country WHERE country.country-id = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "country-id2", "") NO-LOCK NO-ERROR.
    IF AVAIL country THEN ttBusinessmen.visaNationality = country.country-name.
    
    ttBusinessmen.visaTarget = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�������삨���", "").
    ttBusinessmen.visaPeriodBegin = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����ॡ뢑", "")).
    ttBusinessmen.visaPeriodEnd = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����ॡ뢏�", "")).
    ttBusinessmen.visaOrderBegin = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����ࠢ�ॡ�", "")).
    ttBusinessmen.visaOrderEnd = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����ࠢ�ॡ��", "")).

/*
    ttBusinessmen.addressOfLaw = DelDoubleChars(
        (IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
         THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
         ELSE cust-corp.addr-of-low[1]
        ),
    "," ).
    ttBusinessmen.addressOfStay = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", "").
    IF ttBusinessmen.addressOfStay = "" THEN ttBusinessmen.addressOfStay = ttBusinessmen.addressOfLaw.
    ttBusinessmen.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "PlaceOfStay", "").
    IF ttBusinessmen.addressOfPost = "" THEN ttBusinessmen.addressOfPost = ttBusinessmen.addressOfStay.
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ '�����'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBusinessmen.addressOfLaw = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ '�������'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBusinessmen.addressOfStay = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ '�������'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttBusinessmen.addressOfPost = IF AVAIL(cust-ident) THEN Kladr(cust-ident.issue) ELSE ?.

    ttBusinessmen.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", "").
    ttBusinessmen.registrationDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegDate", "")).
    ttBusinessmen.registrationPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegPlace", "").
    
    ttBusinessmen.inn = cust-corp.inn.
    IF ttBusinessmen.inn = "000000000000" OR ttBusinessmen.inn = "0" THEN ttBusinessmen.inn = "".

    ttBusinessmen.hasRelationToForeignBoss = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�⭎���_����","").
    ttBusinessmen.isForeignBoss = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����_����","").
    ttBusinessmen.fromFamilyOfForeignBoss = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�⥯�����_����","").

    ttBusinessmen.tel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", "").
    ttBusinessmen.fax = cust-corp.fax.
    
    ttBusinessmen.riskLevel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "��᪎��", "").
    ttBusinessmen.otherBanks = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirOtherBanks", "").
    ttBusinessmen.businessImage = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirBusImage", "").
    
/*
    tmpStr = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�業����᪠", "").
    ttBusinessmen.riskInfo = GetCode("Pir�業����᪠", tmpStr).
    if ttBusinessmen.riskInfo = ? then ttBusinessmen.riskInfo = tmpStr.
*/
    tmpStr = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�業����᪠", "").
    ttBusinessmen.riskInfo = GetCode("Pir�業����᪠", tmpStr).
    /** �᫨ �� ���� tmpStr ����� � �����䨪��� ���, � � ⮬ �� �����䨪���
       �饬 ���祭�� � ����� �� ttBusinessmen.riskLevel */
    if ttBusinessmen.riskInfo = ? and tmpStr = "" then 
      ttBusinessmen.riskInfo = GetCode("Pir�業����᪠", ttBusinessmen.riskLevel).
    /** �᫨ ����� ��祣� �� �ࠡ�⠫� � ���祭�� �� ��᢮���, � ��� �㤥� ����� */
    if ttBusinessmen.riskInfo = ? then
      ttBusinessmen.riskInfo = tmpStr.

    ttBusinessmen.firstAcctOpenDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "FirstAccDate", "")).
    ttBusinessmen.inputDate = ttBusinessmen.firstAcctOpenDate.
    ttBusinessmen.modifDate = GetLastHistoryDate("��", cust-corp.cust-id, ttBusinessmen.inputDate).

    
    /** ������ ���㤭���, ����襣� ���  */
    cAcct = "".
    dAcct = DATE("01/01/2005").
    FOR EACH acct WHERE cust-cat = "�" AND cust-id = cust-corp.cust-id 
                    AND contract = "�����" NO-LOCK BY open-date:
      cAcct = acct.acct.
      dAcct = acct.open-date.
      userOpenAcct = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "���������", acct.user-id).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBusinessmen.userNameOpenAcct = _user._user-name.
        ttBusinessmen.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "���������", "").
      END.
      LEAVE.
    END.
       /* �᫨ ��� ���⭮�� ��� */
    IF cAcct = ""
    THEN DO:
      FOR EACH acct WHERE cust-cat = "�" AND cust-id = cust-corp.cust-id 
                    NO-LOCK BY open-date:
        cAcct = acct.acct.
        dAcct = acct.open-date.
        userOpenAcct = GetXAttrValueEx("acct", acct.acct + "," + acct.currency, "���������", acct.user-id).
        FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
        IF AVAIL _user THEN DO:
          ttBusinessmen.userNameOpenAcct = _user._user-name.
          ttBusinessmen.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "���������", "").
        END.
        LEAVE.
      END.
    END.
       /* �᫨ ��� �� ������ ��� */
    IF cAcct = ""
    THEN DO:
      ttBusinessmen.userNameOpenAcct = "��� ������ ���".
      ttBusinessmen.userPostOpenAcct = "".
      userOpenAcct = "".
    END.

    /** ������ ���㤭���, ��������襣� ������ � ���஭��� ���� */
       /* �᫨ ���㤭�� �� ������ �� ���� ��� ��� ��������� � ��᪢�� */
    IF userOpenAcct = ? OR userOpenAcct = "" OR dAcct > DATE("27/07/2005")
    THEN DO:
      userOpenAcct = GetFirstHistoryUserid("cust-corp", STRING(cust-corp.cust-id)).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBusinessmen.userNameInput = _user._user-name.
        ttBusinessmen.userPostInput = GetXAttrValueEx("_user", _user._userid, "���������", "").
      END.
    END.
    ELSE DO:
      ttBusinessmen.userNameInput = ttBusinessmen.userNameOpenAcct.
      ttBusinessmen.userPostInput = ttBusinessmen.userPostOpenAcct.
    END.

    /** ������ ���㤭���, �⢥न�襣� ����⨥ ���. �� �室��� ��ࠬ��� ��楤���. */
    IF cAcct = ""
    THEN DO:
      ttBusinessmen.userNameAssent = "��� ������ ���".
      ttBusinessmen.userPostAssent = "".
    END.
    ELSE DO:
      FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttBusinessmen.userNameAssent = _user._user-name.
        ttBusinessmen.userPostAssent = GetXAttrValueEx("_user", _user._userid, "���������", "").
      END.
    END.
    /** ������ ���㤭���, ��७��襣� ������ �� �㬠��� ���⥫� */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttBusinessmen.userNamePrint = _user._user-name.
      ttBusinessmen.userPostPrint = GetXAttrValueEx("_user", _user._userid, "���������", "").
    END.
    

        
/******************************************* ��ନ஢���� ���⭮� ��� ������ */
    
    str[1] = "1.1. �������: " + PrintStringInfo(ttBusinessmen.lastName) + " ���: " 
                + PrintStringInfo(ttBusinessmen.firstName) + " ����⢮: " 
                + PrintStringInfo(ttBusinessmen.patronymic) + CHR(10) 
           + "1.2. ��� ஦�����: " + PrintDateInfo(ttBusinessmen.birthDate) + CHR(10)
           + "1.3. ���� ஦�����: " + PrintStringInfo(ttBusinessmen.birthPlace) + CHR(10)
           + "1.4. �ࠦ����⢮: " + PrintStringInfo(ttBusinessmen.nationality) + CHR(10)
           + "1.5. ���㬥��, 㤮�⮢����騩 ��筮���: " + PrintStringInfo(ttBusinessmen.document) + CHR(10)
           + "1.6. ����� ����樮���� �����".
    
    IF ttBusinessmen.migrationCard = "" AND ttBusinessmen.visaSeries = "" THEN 
      str[1] = str[1] + ": " + PrintStringInfo("") + CHR(10).
    ELSE DO:
      str[1] = str[1] + "#tab����� ����樮���� �����: " + PrintStringInfo(ttBusinessmen.migrationCard) + CHR(10)
                      + "����� ���㬥��, ���⢥ত��饣� �ࠢ� �� �ॡ뢠��� (�஦������) � ��" + CHR(10)
                      + "#tab����: " + PrintStringInfo(ttBusinessmen.visaSeries) + CHR(10)
                      + "#tab����� ���㬥��: " + PrintStringInfo(ttBusinessmen.visaNumber) + CHR(10)
                      + "#tab�ࠦ����⢮: " + PrintStringInfo(ttBusinessmen.visaNationality) + CHR(10)
                      + "#tab���� �����: " + PrintStringInfo(ttBusinessmen.visaTarget) + CHR(10)
                      + "#tab�ப �ॡ뢠��� � " + PrintDateInfo(ttBusinessmen.visaPeriodBegin) 
                            + " �� " + PrintDateInfo(ttBusinessmen.visaPeriodEnd) + CHR(10)
                      + "#tab�ப ����⢨� �ࠢ� �ॡ뢠��� � " + PrintDateInfo(ttBusinessmen.visaOrderBegin) 
                            + " �� " + PrintDateInfo(ttBusinessmen.visaOrderEnd) + CHR(10).
    END.
    
    str[1] = str[1] + "1.7. ���� ���� ��⥫��⢠ (ॣ����樨): " + 
                 PrintStringInfo(ttBusinessmen.addressOfLaw) + CHR(10)
           + "1.8. ���� ���� �ॡ뢠��� (�஦������): " + PrintStringInfo(ttBusinessmen.addressOfStay) + CHR(10)
           + "1.9. ���⮢� ����: " + PrintStringInfo(ttBusinessmen.addressOfPost) + CHR(10)
           + "1.10. ���: " + PrintStringInfo(ttBusinessmen.inn) + CHR(10)
           + "1.11. �⭮襭�� � �����࠭�� �㡫��� ��������� ��栬 � �易��� � ���� ��栬 (�㦭�� �⬥��):" + CHR(10)
           + "  �����Ŀ  ������� �����࠭�� �㡫��-  �����Ŀ  ����� �⭮襭�� � �����࠭����"+ CHR(10)
           + "  � " + (IF ttBusinessmen.isForeignBoss > "" THEN "� �" ELSE "���") 
           + " �  �� ��������� ��殬         � " + (IF ttBusinessmen.hasRelationToForeignBoss + ttBusinessmen.fromFamilyOfForeignBoss > "" THEN "� �" ELSE "���") 
           + " �  �㡫�筮�� �������⭮�� ����" + CHR(10)
           + "  �������                                �������" + CHR(10).

     IF (ttBusinessmen.hasRelationToForeignBoss > "") AND (NUM-ENTRIES(ttBusinessmen.hasRelationToForeignBoss, ";") = 4) THEN 
       DO:
         str[1] = str[1] 
             + "�������, ��� � (�� ����稨) ����⢮: " + PrintStringInfo(ENTRY(1,ttBusinessmen.hasRelationToForeignBoss,";")) + CHR(10)
             + "���������� ���������: " + PrintStringInfo(ENTRY(2, ttBusinessmen.hasRelationToForeignBoss, ";")) + CHR(10)
             + "������������ ���㤠��⢠: " + PrintStringInfo(ENTRY(3,ttBusinessmen.hasRelationToForeignBoss,";")) + CHR(10)
             + "�⥯��� த�⢠ ��� ���� �⭮襭��: " + PrintStringInfo(ENTRY(4,ttBusinessmen.hasRelationToForeignBoss,";")) + CHR(10).
      END.
    ELSE IF (ttBusinessmen.fromFamilyOfForeignBoss > "") AND (NUM-ENTRIES(ttBusinessmen.fromFamilyOfForeignBoss, ";") = 4) THEN
      DO:
         str[1] = str[1] 
             + "�������, ��� � (�� ����稨) ����⢮: " + PrintStringInfo(ENTRY(1,ttBusinessmen.fromFamilyOfForeignBoss,";")) + CHR(10)
             + "���������� ���������: " + PrintStringInfo(ENTRY(2, ttBusinessmen.fromFamilyOfForeignBoss, ";")) + CHR(10)
             + "������������ ���㤠��⢠: " + PrintStringInfo(ENTRY(3,ttBusinessmen.fromFamilyOfForeignBoss,";")) + CHR(10)
             + "�⥯��� த�⢠ ��� ���� �⭮襭��: " + PrintStringInfo(ENTRY(4,ttBusinessmen.fromFamilyOfForeignBoss,";")) + CHR(10).
      END.
/** Buryagin wrote but commented 
    ELSE
      DO:
        str[1] = str[1] 
        + "������ �ଠ� � ����� �� �.�. person.�⭎���_���� ��� person.�⥯�����_����. �㦭� ���� ��ப���� ���祭��, ࠧ�������� �窮� � ����⮩ <;>" + CHR(10).
      END.
*/

    str[1] = str[1] + "1.12. ����� " + CHR(10) 
            + "#tab���⠪��� ⥫�䮭��: " + PrintStringInfo(ttBusinessmen.tel) + CHR(10)
           + "#tab䠪ᮢ: " + PrintStringInfo(ttBusinessmen.fax) + CHR(10)
           + "1.13. ���㤠��⢥��� ॣ����樮��� �����: " + PrintStringInfo(ttBusinessmen.ogrn) + CHR(10)
           + "1.14. ��� ॣ����樨: " + PrintDateInfo(ttBusinessmen.registrationDate) + CHR(10)
           + "1.15. ���� ॣ����樨 (��த, �������): " + PrintStringInfo(ttBusinessmen.registrationPlace) + CHR(10)
           + "1.16. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: " + CHR(10)
           .
           
    /** �뢮��� ���ଠ�� � ��業���� */
    IF NOT CAN-FIND(FIRST ttLicense) THEN 
      /** �᫨ ���ଠ樨 � ��業���� ���, � ᮮ��塞 �� �⮬ */
      str[1] = str[1] + PrintStringInfo("") + CHR(10).
    ELSE
      FOR EACH ttLicense :
        str[1] = str[1] + "��� ��業���㥬�� ���⥫쭮��: " + PrintStringInfo(ttLicense.typeName) + CHR(10)
                        + "�����: " + PrintStringInfo(ttLicense.number) + CHR(10)
                        + "��� �뤠� ��業���: " + PrintDateInfo(ttLicense.openDate) + CHR(10)
                        + "��� �뤠��: " + PrintStringInfo(ttLicense.issue) + CHR(10)
                        + "�ப ����⢨� ��: " + PrintDateInfo(ttLicense.endDate) + "#cr" + CHR(10) .                
      END.
           
     str[1] = str[1] 
            + "1.17. ������������ �।���� �࣠����権, � ������ ������ ���㦨������ (࠭�� ���㦨�����): " + PrintStringInfo(ttBusinessmen.otherBanks) + CHR(10)
            + "1.18. �������� � ������� ९��樨 ������: " + PrintStringInfo(ttBusinessmen.businessImage) + CHR(10)
            + "1.19. �஢��� �⥯��� �᪠: " + PrintStringInfo(ttBusinessmen.riskLevel) + CHR(10)
           + "1.20. ���᭮����� �業�� �⥯��� �᪠: " + PrintStringInfo(ttBusinessmen.riskInfo) + CHR(10)
           + "1.21. ��� ������ ��ࢮ�� ������᪮�� ��� (������): " 
              + PrintDateInfo(ttBusinessmen.firstAcctOpenDate) + CHR(10)
           + "1.22. ��� ���������� ������ ������: " + PrintDateInfo(ttBusinessmen.inputDate) + CHR(10)
           + "1.23. ��� ���������� ������ ������: " + PrintDateInfo(ttBusinessmen.modifDate) + CHR(10)
           + "1.24. ����⭨� �����, ����訩 ��� " + CHR(10)
              + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttBusinessmen.userNameOpenAcct) + CHR(10)
               + "#tab���������: " + PrintStringInfo(ttBusinessmen.userPostOpenAcct) + CHR(10)
           + "1.25. ����⭨� �����, �⢥न�訩 ����⨥ ���" + CHR(10)
               + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttBusinessmen.userNameAssent) + CHR(10)
              + "#tab���������: " + PrintStringInfo(ttBusinessmen.userPostAssent) + CHR(10)
           + "1.26. ����⭨� �����, ��������訩 ������ ������ � ���஭��� ����" + CHR(10)
              + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttBusinessmen.userNameInput) + CHR(10)
              + "#tab���������: " + PrintStringInfo(ttBusinessmen.userPostInput) + CHR(10)
           + "1.27. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � ���஭��� ����,"
               + " �� �㬠��� ���⥫�" + CHR(10)
               + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttBusinessmen.userNamePrint) + CHR(10)
               + "#tab���������: " + PrintStringInfo(ttBusinessmen.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED /*SPACE(77) "�. ��-1" SKIP(1)*/
                    SPACE(10) "������ ������� - ��������������� ���������������" SKIP(2).
    
    DO i = 1 TO 200:
      IF str[i] <> "" THEN DO:
        str[i] = REPLACE(str[i], "#tab",CHR(9)).
        str[i] = REPLACE(str[i], "#cr", CHR(10)).
        PUT UNFORMATTED str[i] SKIP.
      END.
    END.
    
    {preview.i}

END.

{intrface.del}

