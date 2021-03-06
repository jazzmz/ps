/** 
		��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007

		��।������ ��騥 ��� ��� ⨯�� �����.
		
		���� �.�., 08.05.2007 16:10
		
		<���_����᪠����>
		<��ࠬ���� ����᪠>
		<���_ࠡ�⠥�>
		<�ᮡ������_ॠ����樨>
		
		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

*/

/** ���ଠ�� � ��, ��ࠦ����� � ����� */
DEF TEMP-TABLE ttCorporation NO-UNDO
	FIELD fullName AS CHAR
	FIELD shortName AS CHAR
	FIELD foreignLanguageName AS CHAR
	FIELD opf AS CHAR /* �࣠����樮���-�ࠢ���� �ଠ */
	FIELD ogrn AS CHAR /* �����ᨩ᪨� ���㤠��⢥��� ॣ����樮��� ����� */
	FIELD registrationDate AS DATE /* ��� ॣ����樨 */
	FIELD registrationPlace AS CHAR /* ���� ॣ����樨 */
	FIELD addressOfStay AS CHAR /* ���� ���� ��宦����� */
	FIELD addressOfPost AS CHAR /* ���⮢� ���� */
	FIELD tel AS CHAR /* ����䮭� */
	FIELD fax AS CHAR /* ���� */
	FIELD inn AS CHAR
	FIELD iin AS CHAR /* ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१����� */
	FIELD struct AS CHAR /* �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢) */
	FIELD capital AS CHAR /* �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� ����⠫� */
	FIELD exist AS CHAR /* ���������/��������� �� ᢮��� ���⮭�宦����� */
	FIELD riskLevel AS CHAR /* �஢��� �᪠ */
	FIELD riskInfo AS CHAR /* ���᭮����� �᪠ */
	FIELD firstAcctOpenDate AS DATE /* ��� ������ ��ࢮ�� ��� */
	FIELD inputDate AS DATE /* ��� ���������� ������ */
	FIELD modifDate AS DATE /* ��� ��������� ������ */
	FIELD userNameOpenAcct AS CHAR /* ����㤭��, ����訩 ��� */
	FIELD userPostOpenAcct AS CHAR /* ��������� ���㤭��� */
	FIELD userNameAssent AS CHAR /* ����㤭��, �⢥न�訩 ����⨥ ��� */
	FIELD userPostAssent AS CHAR
	FIELD userNameInput AS CHAR /* ����㤭��, ��������訩 ������ � �����஭��� ���� */
	FIELD userPostInput AS CHAR 
	FIELD userNamePrint AS CHAR /* ����㤭��, ��७��訩 ������ �� �㬠��� ���⥫� */
	FIELD userPostPrint AS CHAR
	FIELD otherBanks AS CHAR /* ���ଠ�� � ��㣨� ������ ������ */
	FIELD businessImage AS CHAR /* �������� � ९��樨 ������ */
	.
	
/** ���ଠ�� � ��, ��ࠦ����� � ����� */
DEF TEMP-TABLE ttPerson NO-UNDO
	FIELD lastName AS CHAR /* ������� */
	FIELD firstName AS CHAR /* ��� */
	FIELD patronymic AS CHAR /* ����⢮ */
	FIELD birthDate AS DATE /* ��� ஦����� */
	FIELD birthPlace AS CHAR /* ���� ஦����� */
	FIELD nationality AS CHAR /* �ࠦ����⢮ */
	FIELD document AS CHAR /* ���㬥��, 㤮�⮢����騩 ��筮��� */
	FIELD migrationCard AS CHAR /* ����� ����樮���� ����� */
	FIELD visa AS CHAR /* ����� � ����: ⨯ � ���. ���ଠ�� */
	FIELD visaSeries AS CHAR /* ���� ���� */
	FIELD visaNumber AS CHAR /* ����� ���� */
	FIELD visaNationality AS CHAR /* �ࠦ����⢮ � ���� */
	FIELD visaTarget AS CHAR /* ���� ����� */
	FIELD visaPeriodBegin AS DATE /* ��� ��砫� �ப� �ॡ뢠��� */
	FIELD visaPeriodEnd AS DATE /* ��� ���� �ப� �ॡ뢠��� */
	FIELD visaOrderBegin AS DATE /* ��� ��砫� ����⢨� �ࠢ� �ॡ뢠��� */
	FIELD visaOrderEnd AS DATE /* ��� ���� ����⢨� �ࠢ� �ॡ뢠��� */
	FIELD addressOfLaw AS CHAR /* ���� ॣ����樨 */
	FIELD addressOfStay AS CHAR /* ���� �ॡ뢠��� */
	FIELD inn AS CHAR
	FIELD hasRelationToForeignBoss AS CHAR /* ����� �� �⭮襭��� � �����࠭�� ��������� ��殬 */
	FIELD isForeignBoss AS CHAR /* ����� � �����࠭��� �������⭮� ��� */
	FIELD fromFamilyOfForeignBoss AS CHAR /* ����� � ᥬ����� த�⢥ � �����࠭�� ��������� ��殬 */ 
	FIELD tel AS CHAR
	FIELD fax AS CHAR
	FIELD riskLevel AS CHAR /* �஢��� �᪠ */
	FIELD riskInfo AS CHAR /* ���᭮����� �᪠ */
	FIELD firstAcctOpenDate AS DATE /* ��� ������ ��ࢮ�� ��� */
	FIELD inputDate AS DATE /* ��� ���������� ������ */
	FIELD modifDate AS DATE /* ��� ��������� ������ */
	FIELD userNameOpenAcct AS CHAR /* ����㤭��, ����訩 ��� */
	FIELD userPostOpenAcct AS CHAR /* ��������� ���㤭��� */
	FIELD userNameAssent AS CHAR /* ����㤭��, �⢥न�訩 ����⨥ ��� */
	FIELD userPostAssent AS CHAR
	FIELD userNameInput AS CHAR /* ����㤭��, ��������訩 ������ � �����஭��� ���� */
	FIELD userPostInput AS CHAR 
	FIELD userNamePrint AS CHAR /* ����㤭��, ��७��訩 ������ �� �㬠��� ���⥫� */
	FIELD userPostPrint AS CHAR
	.
	
/** ���ଠ�� �� �������㠫쭮� �।�ਭ���⥫�. ��᫥����� �� ttPerson */
DEFINE TEMP-TABLE ttBusinessmen NO-UNDO LIKE ttPerson
	FIELD ogrn AS CHAR /* ��� ���� */
	FIELD registrationDate AS DATE /* ��� ॣ����樨 */
	FIELD registrationPlace AS CHAR /* ���� ॣ����樨 */
	FIELD addressOfPost AS CHAR /* ���⮢� ���� */
	FIELD otherBanks AS CHAR /* ���ଠ�� � ��㣨� ������ ������ */
	FIELD businessImage AS CHAR /* �������� � ९��樨 ������ */
	.

/** ���ଠ�� � �����-������, ��ࠦ����� � ����� */
DEF TEMP-TABLE ttBank NO-UNDO
	FIELD fullName AS CHAR
	FIELD shortName AS CHAR
	FIELD foreignLanguageName AS CHAR
	FIELD opf AS CHAR /* �࣠����樮���-�ࠢ���� �ଠ */
	FIELD ogrn AS CHAR /* �����ᨩ᪨� ���㤠��⢥��� ॣ����樮��� ����� */
	FIELD registrationDate AS DATE /* ��� ॣ����樨 */
	FIELD registrationPlace AS CHAR /* ���� ॣ����樨 */
	FIELD addressOfStay AS CHAR /* ���� ���� ��宦����� */
	FIELD addressOfPost AS CHAR /* ���⮢� ���� */
	FIELD tel AS CHAR /* ����䮭� */
	FIELD fax AS CHAR /* ���� */
	FIELD inn AS CHAR
	FIELD iin AS CHAR /* ��� ��� ��� �����࠭��� �࣠����樨 - ��� ��१����� */
	FIELD okpo AS CHAR /* ��� ���� */
	FIELD bic AS CHAR /* ��� ����� (��� १����⮢) */
	FIELD struct AS CHAR /* �������� �� �࣠��� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢) */
	FIELD capital AS CHAR /* �������� � ����稭� ��ॣ����஢������ � ����祭���� ��⠢���� ����⠫� */
	FIELD exist AS CHAR /* ���������/��������� �� ᢮��� ���⮭�宦����� */
	FIELD riskLevel AS CHAR /* �஢��� �᪠ */
	FIELD riskInfo AS CHAR /* ���᭮����� �᪠ */
	FIELD firstAcctOpenDate AS DATE /* ��� ������ ��ࢮ�� ��� */
	FIELD inputDate AS DATE /* ��� ���������� ������ */
	FIELD modifDate AS DATE /* ��� ��������� ������ */
	FIELD userNameOpenAcct AS CHAR /* ����㤭��, ����訩 ��� */
	FIELD userPostOpenAcct AS CHAR /* ��������� ���㤭��� */
	FIELD userNameAssent AS CHAR /* ����㤭��, �⢥न�訩 ����⨥ ��� */
	FIELD userPostAssent AS CHAR
	FIELD userNameInput AS CHAR /* ����㤭��, ��������訩 ������ � �����஭��� ���� */
	FIELD userPostInput AS CHAR 
	FIELD userNamePrint AS CHAR /* ����㤭��, ��७��訩 ������ �� �㬠��� ���⥫� */
	FIELD userPostPrint AS CHAR
	.
	
/** ���ଠ�� � �룮���ਮ���⥫� ��, ��ࠦ����� � ����� */
DEF TEMP-TABLE ttBeneficiaryCorp NO-UNDO LIKE ttCorporation
	FIELD benefitInfo AS CHAR /* �������� � �룮�� */
	.

/** ���ଠ�� � �룮���ਮ���⥫� ��, ��ࠦ����� � ����� */
DEF TEMP-TABLE ttBeneficiaryPers NO-UNDO LIKE ttPerson
  FIELD benefitInfo AS CHAR /* �������� � �룮�� */
  .
  
/** ���ଠ�� � �룮���ਮ���⥫� ��, ��ࠦ����� � ����� */
DEF TEMP-TABLE ttBeneficiaryBusinessmen NO-UNDO LIKE ttBusinessmen
	FIELD benefitInfo AS CHAR /* �������� � �룮�� */
	FIELD opf AS CHAR /* �࣠����殭��-�ࠢ���� �ଠ */
	.
  	
/** ���ଠ�� � ��業���� */
DEF TEMP-TABLE ttLicense NO-UNDO
	FIELD typeName AS CHAR /* ��� ��業���㥬�� ���⥫쭮�� */
	FIELD number AS CHAR /* ����� ��業��� */
	FIELD openDate AS DATE /* ��� �뤠� */
	FIELD issue AS CHAR /* ��� �뤠�� */
	FIELD endDate AS DATE /* ��� ����砭�� ����⢨� */
	.

DEF VAR i AS INTEGER NO-UNDO. /* ����� */
DEF VAR str AS CHAR EXTENT 200 NO-UNDO. /* ����� ������ */
DEF VAR tmpStr AS CHAR NO-UNDO.

DEF VAR notExistMessage AS CHAR INIT "(���������)" NO-UNDO.

/** �㭪�� ���� ᨬ���쭮� ���ଠ樨. �� �� ������⢨� �뢮����� ᮮ⢥����饥 ᮮ�饭�� */
FUNCTION PrintStringInfo RETURNS CHAR (INPUT str AS CHAR) :
	IF str = ? OR str = "" THEN RETURN notExistMessage. ELSE RETURN str.
END FUNCTION.

/** �㭪�� ���� ���� . �� �� ������⢨� �뢮����� ᮮ⢥����饥 ᮮ�饭�� */
FUNCTION PrintDateInfo RETURNS CHAR (INPUT d AS DATE) :
	IF d = ? THEN RETURN notExistMessage. ELSE RETURN STRING(d, "99.99.9999").
END FUNCTION.

/** �����頥� ���� �⫨�� �� "BIS" ��� ���짮��⥫�, ᮧ���訩 ��� ����訩 ��������� � ������ */
FUNCTION GetFirstHistoryUserid RETURNS CHAR (INPUT iTabl     AS CHARACTER,
                                    			INPUT iMasterId AS CHARACTER ).

   FIND FIRST history WHERE history.file-name EQ iTabl
                       AND history.field-ref EQ iMasterId
                       AND NOT CAN-DO("BIS", history.user-id) 
      NO-LOCK NO-ERROR.

   IF AVAILABLE history THEN
      RETURN history.user-id.
   ELSE
      RETURN "".
END.

/* �८�ࠧ������ ���� � �ଠ� ����� � 㤮���⠥���� ����                   */
/* �ଠ� �����: ������,ࠩ��,��த,���.�㭪�,㫨�,���,�����,������,��஥��� */
/* ��祬 ���.2-5 ᮯ஢�������� ���������ﬨ �,�-�,� � �.�., � ���.6-9 ����������� ������ ��ࠬ� */
FUNCTION Kladr RETURNS CHARACTER (INPUT cAdr AS CHARACTER).

   DEFINE VARIABLE cAdrPart AS CHARACTER EXTENT 9 INITIAL "".
   DEFINE VARIABLE cAdrDop  AS CHARACTER EXTENT 9 INITIAL ['', ',', ',', ',', ',', ',�.', ',���.', ',��.', ',���.'].
   DEFINE VARIABLE cAdrKl   AS CHARACTER.
   DEFINE VARIABLE iI       AS INTEGER.
   DEFINE VARIABLE iNzpt    AS INTEGER.

   iNzpt = MINIMUM(NUM-ENTRIES(cAdr), 9).

   DO iI = 1 TO iNzpt:
      cAdrPart[iI] = ENTRY(iI, cAdr).
   END.

   cAdrKl = IF (cAdrPart[1] NE "") THEN cAdrPart[1] ELSE "".
   DO iI = 2 TO MINIMUM(iNzpt, 6) :
      IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + cAdrDop[iI] + cAdrPart[iI].
   END.

   IF (cAdrPart[9] NE "") AND (iNzpt EQ 9) THEN cAdrKl = cAdrKl + cAdrDop[9] + cAdrPart[9].
   IF (cAdrPart[7] NE "") AND (iNzpt GE 7) THEN cAdrKl = cAdrKl + cAdrDop[7] + cAdrPart[7].
   IF (cAdrPart[8] NE "") AND (iNzpt GE 8) THEN cAdrKl = cAdrKl + cAdrDop[8] + cAdrPart[8].

   RETURN cAdrKl.
END.

/** ���� �� cl_anket.p. ����� ��� ���뢠���� vHistoryDate 
    �����頥� �६� ��᫥����� ��������� */
/*
FUNCTION GetLastHistoryDate RETURNS DATE
   (INPUT iTabl     AS CHARACTER,
    INPUT iMasterId AS CHARACTER ).

   FIND LAST history
      WHERE history.file-name EQ iTabl
        AND history.field-ref EQ iMasterId
      NO-LOCK NO-ERROR.

   IF AVAILABLE history
   THEN RETURN history.modif-date.
   ELSE RETURN ?.
END.
*/
/* �����頥� �६� ��᫥����� ��������� ����� ������ ���㤭����� �⤥���� ���ࠧ������� */
FUNCTION GetLastHistoryDate RETURNS DATE
   (INPUT iKl    AS CHARACTER,  /* ��,��,��,� */
    INPUT iKlId  AS INTEGER,    /* cust-id    */
    INPUT iSince AS DATE).

   DEFINE VARIABLE dLastDate  AS DATE      NO-UNDO.
   DEFINE VARIABLE cUprList   AS CHARACTER INIT "�-5,�-6,�-11,�-17"                NO-UNDO.
   DEFINE VARIABLE cKlList    AS CHARACTER INIT "��,��,��,�"                       NO-UNDO.
   DEFINE VARIABLE cTabList   AS CHARACTER INIT "cust-corp,cust-corp,person,banks" NO-UNDO.
   DEFINE VARIABLE cTipeList  AS CHARACTER INIT "�,�,�,�"                          NO-UNDO.
   DEFINE VARIABLE cAdrList   AS CHARACTER EXTENT 4
                                 INIT ["�����,�������", "�����,�������,�������",
                                       "����ய,�������", "�����,�������"]         NO-UNDO.
   DEFINE VARIABLE cFldList   AS CHARACTER EXTENT 4                                NO-UNDO.
   /*         ��      */
   cFldList[1] = "name-corp,name-short,*engl-name,cust-stat,*����,*RegDate,*RegPlace,"
               + "*tel,fax,inn,*���,*������,*���⠢��,*��⠢���,*�����࣓�ࠢ,"
               + "*pirOtherBanks,*pirBusImage,*��᪎��,*�業����᪠,*FirstAccDate,"
               + "addr-of-low[1],addr-of-low[2],*PlaceOfStay".
   /*         ��      */
   cFldList[2] = "name-corp,cust-stat,*����,*RegDate,*RegPlace,*tel,fax,inn,"
               + "*pirOtherBanks,*pirBusImage,*��᪎��,*�業����᪠,*FirstAccDate,"
               + "*BirthDay,*BirthPlace,country-id,*document-id,*document,*Document4Date_vid,*issue,"
               + "*��������,*VisaNum,*country-id2,*�������삨���,"
               + "*�����ॡ뢑,*�����ॡ뢏�,*�����ࠢ�ॡ�,*�����ࠢ�ॡ��,"
               + "*�����_����,*�⭎���_����,*�⥯�����_����,"
               + "addr-of-low[1],addr-of-low[2],*PlaceOfStay,*����".
   /*         ��      */
   cFldList[3] = "name-last,first-names,phone,fax,*��᪎��,*�業����᪠,*FirstAccDate,"
               + "birthday,*BirthPlace,country-id,"
               + "*��������,*VisaNum,*country-id2,*�������삨���,"
               + "*�����ॡ뢑,*�����ॡ뢏�,*�����ࠢ�ॡ�,*�����ࠢ�ॡ��,"
               + "*�����_����,*�⭎���_����,*�⥯�����_����,"
               + "address[1],address[2],*PlaceOfStay".
   /*         �       */
   cFldList[4] = "name,*pirFullName,short-name,*pirShortName,*engl-name,*bank-stat,"
               + "*����,*RegDate,*RegPlace,*tel,*fax,*���,*������,*��⠢���,*�����࣓�ࠢ,"
               + "*��᪎��,*�業����᪠,*FirstAccDate,"
               + "�ਤ. ����,����. ����".

   DEFINE VARIABLE iKlType    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cKlTabl    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cKlType    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSurr      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE I          AS INTEGER   NO-UNDO.
   DEFINE VARIABLE J          AS INTEGER   NO-UNDO.

   iKlType   = LOOKUP(iKl, cKlList).
   cKlTabl   = ENTRY(iKlType, cTabList).
   cKlType   = ENTRY(iKlType, cTipeList).
   dLastDate = iSince.

   /* ��ᬠ�ਢ��� ����� ������ */
   CustHist:
   FOR EACH history
      WHERE history.file-name EQ cKlTabl
        AND history.field-ref EQ STRING(iKlId)
      NO-LOCK
      BY history.modif-date DESCENDING
      BY history.modif-time DESCENDING
      :

      FIND FIRST _user
         WHERE _user._userid = history.user-id
         NO-LOCK NO-ERROR.

      IF AVAILABLE _user
      THEN DO:
         IF CAN-DO(cUprList, GetXAttrValue("_user", _user._userid, "group-id"))
         THEN
         DO I = 1 TO (NUM-ENTRIES(history.field-value) - 2) BY 2:
            DO J = 1 TO NUM-ENTRIES(cFldList[iKlType]):
               IF (ENTRY(I, history.field-value) EQ ENTRY(J, cFldList[iKlType]))
               /* ��諨 ��᫥���� �ࠢ�� */
               THEN DO:
                  dLastDate = history.modif-date.
                  LEAVE CustHist.
               END.
            END.
         END.
      END.
   END.

   /* ��ᬠ�ਢ��� ����� ���ᮢ, ��業���, 㤮�⮢�७�� ��筮�� */
   FOR EACH cust-ident
      WHERE ((cust-ident.class-code EQ "cust-lic")
          OR (cust-ident.class-code EQ "p-cust-adr")
          OR (cust-ident.class-code EQ "p-cust-ident")
          OR (cust-ident.class-code EQ "cust-bank"))
        AND (cust-ident.cust-cat    EQ cKlType)
        AND (cust-ident.cust-id     EQ iKlId)
      NO-LOCK:

      /* ����砥��� �� ��� ���� � ������ */
      IF (cust-ident.class-code EQ "p-cust-adr")
        AND NOT CAN-DO(cAdrList[iKlType], cust-ident.cust-code-type)
      THEN NEXT.

      /* ����砥��� �� ��� �����䨪��� ����� � ������ */
      IF (cust-ident.class-code EQ "cust-bank")
        AND NOT CAN-DO("���,���-9", cust-ident.cust-code-type)
      THEN NEXT.

      cSurr = cust-ident.cust-code-type + ","
            + cust-ident.cust-code      + ","
            + STRING(cust-ident.cust-type-num)
            .

      AddrHist:
      FOR EACH history
         WHERE history.file-name  EQ "cust-ident"
           AND history.field-ref  EQ cSurr
           AND history.modif-date GT dLastDate
         NO-LOCK
         BY history.modif-date DESCENDING
         BY history.modif-time DESCENDING
         :

         FIND FIRST _user
            WHERE _user._userid = history.user-id
            NO-LOCK NO-ERROR.

         IF AVAILABLE _user
         THEN DO:
            IF CAN-DO(cUprList, GetXAttrValue("_user", _user._userid, "group-id"))
            /* ��諨 ��᫥���� �ࠢ�� */
            THEN DO:
               dLastDate = history.modif-date.
               LEAVE AddrHist.
            END.
         END.
      END.
   END.

   RETURN dLastDate.
END.
