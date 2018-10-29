{pirsavelog.p}

/** 
    ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
    
    ��ନ஢���� ������ ������ �ਤ��᪮�� ���.
    
    ���� �.�., 08.05.2007 14:22
    
    ����᪠���� �� ��㧥� �����⮢ ��.
    <��ࠬ���� ����᪠> : ��ப� � ���� ��ࠦ���� <���_��ࠬ���>=<���祭��_��ࠬ���>[,...]
                          ��ࠡ��뢠��� ��ࠬ����: �����⢥ऎ����� - ��� ���㤭��� ��� 䠬���� � ��������� 1.23.
                          �뢮����� � �㭪� 
    <���_ࠡ�⠥�> : ��� ������ �����, �뤥����� � ��㧥�, �������� ttCorporation (�. ������ pir_xf_def.i)
                     � ttLicense, �᫨ �� ����室���. ��᫥ ᡮ� �ᥩ ���ଠ樨 �ந�室�� �ନ஢���� ⥪��
                     ������, � ���� � �ଠ������ �� �ਭ� � �뢮����� � PreView.
    <�ᮡ������ ॠ����樨> : ��ࠡ�⪠ �ࠬ��஢ ॠ�������� �������㠫쭮 ��� ������ ��楤��� � �� ����.
    
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
/** ��� ���짮��⥫� �� ���� ������, ����� ���� ���� ��� */
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
    
    /** ��. ��।������ � pir_xf_def.i */
    CREATE ttCorporation.
    ttCorporation.opf = GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)).
    ttCorporation.fullName = ttCorporation.opf + " " + cust-corp.name-corp.
    ttCorporation.shortName = cust-corp.name-short.
    ttCorporation.foreignLanguageName = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "engl-name", "").
    ttCorporation.opf = GetCodeName("����।�",
                               GetCodeVal("����।�", cust-corp.cust-stat)
                        ).
    ttCorporation.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", "").
    ttCorporation.registrationDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegDate", "")).
    ttCorporation.registrationPlace = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "RegPlace", "").

/*
    ttCorporation.addressOfStay = DelDoubleChars(
        (IF cust-corp.addr-of-low[1] <> cust-corp.addr-of-low[2] 
         THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2] 
         ELSE cust-corp.addr-of-low[1]
        ),
    "," ).
    ttCorporation.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", "").
*/
    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ '�����'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttCorporation.addressOfStay = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE ?.

    FIND FIRST cust-ident WHERE
             cust-ident.cust-cat       EQ '�'
         AND cust-ident.cust-id        EQ cust-corp.cust-id
         AND cust-ident.cust-code-type EQ '�������'
         AND cust-ident.class-code     EQ "p-cust-adr"
         AND cust-ident.close-date     EQ ?
    NO-ERROR.
    ttCorporation.addressOfPost = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE ?.

    ttCorporation.tel = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "tel", "").
    ttCorporation.fax = cust-corp.fax.
    ttCorporation.inn = cust-corp.inn.
    ttCorporation.iin = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "���", "").

    tmpStr                      = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "���⠢��", "").
    ttCorporation.struct        = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "������", "")
       + IF ((tmpStr EQ "") OR (tmpStr EQ "���")) THEN "" ELSE (";" + CHR(10) + "����� ��४�஢: " + tmpStr).
    tmpStr                      = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "���⠢���", "").
    ttCorporation.struct        = ttCorporation.struct
       + IF ((tmpStr EQ "") OR (tmpStr EQ "���")) THEN "" ELSE (";" + CHR(10) + "�ᯮ���⥫�� ����������� �࣠�: " + tmpStr).
    ttCorporation.capital       = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "��⠢���", "").
    ttCorporation.exist         = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����࣓�ࠢ", "").
    ttCorporation.riskLevel     = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "��᪎��", "").
    ttCorporation.otherBanks    = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirOtherBanks", "").
    ttCorporation.businessImage = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "pirBusImage", "").
    
    tmpStr                      = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�業����᪠", "").
    ttCorporation.riskInfo      = GetCode("Pir�業����᪠", tmpStr).
    /** �᫨ �� ���� tmpStr ����� � �����䨪��� ���, � � ⮬ �� �����䨪���
       �饬 ���祭�� � ����� �� ttCorporation.riskLevel */
    if ttCorporation.riskInfo = ? and tmpStr = "" then 
      ttCorporation.riskInfo = GetCode("Pir�業����᪠", ttCorporation.riskLevel).
    /** �᫨ ����� ��祣� �� �ࠡ�⠫� � ���祭�� �� ��᢮���, � ��� �㤥� ����� */
    if ttCorporation.riskInfo = ? then
       ttCorporation.riskInfo = tmpStr.
    
    ttCorporation.firstAcctOpenDate = DATE(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "FirstAccDate", "")).
    ttCorporation.inputDate = (IF ttCorporation.firstAcctOpenDate = ? THEN cust-corp.date-in ELSE ttCorporation.firstAcctOpenDate).
    ttCorporation.modifDate = GetLastHistoryDate("��", cust-corp.cust-id, ttCorporation.inputDate).
    
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
        ttCorporation.userNameOpenAcct = _user._user-name.
        ttCorporation.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "���������", "").
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
          ttCorporation.userNameOpenAcct = _user._user-name.
          ttCorporation.userPostOpenAcct = GetXAttrValueEx("_user", _user._userid, "���������", "").
        END.
        LEAVE.
      END.
    END.
       /* �᫨ ��� �� ������ ��� */
    IF cAcct = ""
    THEN DO:
      ttCorporation.userNameOpenAcct = "��� ������ ���".
      ttCorporation.userPostOpenAcct = "".
      userOpenAcct = "".
    END.

    /** ������ ���㤭���, ��������襣� ������ � ���஭��� ���� */
       /* �᫨ ���㤭�� �� ������ �� ���� ��� ��� ��������� � ��᪢�� */
    IF userOpenAcct = ? OR userOpenAcct = "" OR dAcct > DATE("27/07/2005")
    THEN DO:
      userOpenAcct = GetFirstHistoryUserid("cust-corp", STRING(cust-corp.cust-id)).
      FIND FIRST _user WHERE _user._userid = userOpenAcct NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttCorporation.userNameInput = _user._user-name.
        ttCorporation.userPostInput = GetXAttrValueEx("_user", _user._userid, "���������", "").
      END.
    END.
    ELSE DO:
      ttCorporation.userNameInput = ttCorporation.userNameOpenAcct.
      ttCorporation.userPostInput = ttCorporation.userPostOpenAcct.
    END.

    /** ������ ���㤭���, �⢥न�襣� ����⨥ ���. �� �室��� ��ࠬ��� ��楤���. */
    IF cAcct = ""
    THEN DO:
      ttCorporation.userNameAssent = "��� ������ ���".
      ttCorporation.userPostAssent = "".
    END.
    ELSE DO:
      FIND FIRST _user WHERE _user._userid = userIdAssent NO-LOCK NO-ERROR.
      IF AVAIL _user THEN DO:
        ttCorporation.userNameAssent = _user._user-name.
        ttCorporation.userPostAssent = GetXAttrValueEx("_user", _user._userid, "���������", "").
      END.
    END.
    /** ������ ���㤭���, ��७��襣� ������ �� �㬠��� ���⥫� */
    FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
    IF AVAIL _user THEN DO:
      ttCorporation.userNamePrint = _user._user-name.
      ttCorporation.userPostPrint = GetXAttrValueEx("_user", _user._userid, "���������", "").
    END.
    

        
/******************************************* ��ନ஢���� ���⭮� ��� ������ */
    
    str[1] = "1.1. ������ ������������: " + PrintStringInfo(ttCorporation.fullName) + CHR(10) 
           + "1.2. ��⪮� ������������: " + PrintStringInfo(ttCorporation.shortName) + CHR(10)
           + "1.3. ������������ �� �����࠭��� �몥: " + PrintStringInfo(ttCorporation.foreignLanguageName) + CHR(10)
           + "1.4. �࣠����樮��� �ࠢ���� �ଠ: " + PrintStringInfo(ttCorporation.opf) + CHR(10)
           + "1.5. ���㤠��⢥��� ॣ����樮��� �����: " + PrintStringInfo(ttCorporation.ogrn) + CHR(10)
           + "1.6. ��� ॣ����樨: " + PrintDateInfo(ttCorporation.registrationDate) + CHR(10)
           + "1.7. ���� ॣ����樨 (��த, �������), ������������ ॣ�������饣� �࣠��: " + 
                 PrintStringInfo(ttCorporation.registrationPlace) + CHR(10)
           + "1.8. ���� ���⮭�宦�����: " + PrintStringInfo(ttCorporation.addressOfStay) + CHR(10)
           + "1.9. ���⮢� ����: " + PrintStringInfo(ttCorporation.addressOfPost) + CHR(10)
           + "1.10. ����� " + CHR(10) 
            + "#tab���⠪��� ⥫�䮭��: " + PrintStringInfo(ttCorporation.tel) + CHR(10)
           + "#tab䠪ᮢ: " + PrintStringInfo(ttCorporation.fax) + CHR(10)
           + "1.11. ��� - ��� १�����: " + PrintStringInfo(ttCorporation.inn) + CHR(10)
           + "1.12. ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१�����: " + PrintStringInfo(ttCorporation.iin) + CHR(10)
           + "1.13. �������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮��, �������饩 ��業��஢����: " + CHR(10)
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
    
    str[1] = str[1] + "1.14. �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢ �࣠��� �ࠢ����� �ਤ��᪮�� ���): "
                        + PrintStringInfo(ttCorporation.struct) + CHR(10)
                    + "1.15. �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� (᪫���筮��) ����⠫� ��� ����稭� ��⠢���� 䮭��, �����⢠:"
                        + PrintStringInfo(ttCorporation.capital) + CHR(10)
                    + "1.16. �������� � ������⢨� ��� ������⢨� �� ᢮��� ���⮭�宦����� �ਤ��᪮�� ���, ��� ����ﭭ� �������饣� �࣠�� �ࠢ�����, "
                        + "����� �࣠�� ��� ���, ����� ���� �ࠢ� ����⢮���� �� ����� �ਤ��᪮�� ��� ��� ����७����: " 
                        + PrintStringInfo(ttCorporation.exist) + CHR(10)
                    + "1.17. ������������ �।���� �࣠����権, � ������ ������ ���㦨������ (࠭�� ���㦨�����): " + PrintStringInfo(ttCorporation.otherBanks) + CHR(10)
                    + "1.18. �������� � ������� ९��樨 ������: " + PrintStringInfo(ttCorporation.businessImage) + CHR(10)
                    + "1.19. �஢��� �⥯��� �᪠: " + PrintStringInfo(ttCorporation.riskLevel) + CHR(10)
                    + "1.20. ���᭮����� �業�� �⥯��� �᪠: " + PrintStringInfo(ttCorporation.riskInfo) + CHR(10)
                    + "1.21. ��� ������ ��ࢮ�� ������᪮�� ��� (������): " 
                        + PrintDateInfo(ttCorporation.firstAcctOpenDate) + CHR(10)
                    + "1.22. ��� ���������� ������ ������: " + PrintDateInfo(ttCorporation.inputDate) + CHR(10)
                    + "1.23. ��� ���������� ������ ������: " + PrintDateInfo(ttCorporation.modifDate) + CHR(10)
                    + "1.24. ����⭨� �����, ����訩 ��� " + CHR(10)
                        + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttCorporation.userNameOpenAcct) + CHR(10)
                        + "#tab���������: " + PrintStringInfo(ttCorporation.userPostOpenAcct) + CHR(10)
                    + "1.25. ����⭨� �����, �⢥न�訩 ����⨥ ���" + CHR(10)
                        + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttCorporation.userNameAssent) + CHR(10)
                        + "#tab���������: " + PrintStringInfo(ttCorporation.userPostAssent) + CHR(10)
                    + "1.26. ����⭨� �����, ��������訩 ������ ������ � ���஭��� ����" + CHR(10)
                        + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttCorporation.userNameInput) + CHR(10)
                        + "#tab���������: " + PrintStringInfo(ttCorporation.userPostInput) + CHR(10)
                    + "1.27. ������� 㯮�����祭���� ࠡ�⭨�� �����, ��७��襣� ������ ������, ����������� � ���஭��� ����,"
                        + " �� �㬠��� ���⥫�" + CHR(10)
                        + "#tab�������, ���, ����⢮: " + PrintStringInfo(ttCorporation.userNamePrint) + CHR(10)
                        + "#tab���������: " + PrintStringInfo(ttCorporation.userPostPrint) + CHR(10).
    
    
    {wordwrap.i &s=str &n=200 &l=80}
    
    {setdest.i}
    PUT UNFORMATTED SPACE(77) "�. ��-1" SKIP(1)
                    SPACE(30) "������ ������� - ������������ ����" SKIP
                    SPACE(28) "(�� ��饣��� �।�⭮� �࣠����樥�)" SKIP(2).
    
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


