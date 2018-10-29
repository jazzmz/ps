/** 
   ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2009

	Modified: 10/08/11 SStepanov ��������� ��᪠ ��� 425* ��� �૨� �� ������ ����⠭����
	  04/10/11 SStepanov �᫨ ��� ������, � �� ��������� ���� 1.14 "��� ������ ���"

		#843 ����� �� ��몥 ����ᮢ �����(pir_krupnye*.p) � ����⨥ ��⮢ � �����⨪�(pir_anketa.p)
		����� ����ᨫ�, �⮡� � ��� �뫠 ��㣠� �㭪樮���쭮��� �� ����� ��� ����� �ᥣ�� �����뢠�� ���� ������ ���
		PROCEDURE FirstKlAcctPODFT :
		����� ��� ��� �஬� ����� �� �����뢠�� ���� ������ ��� �᫨ �� ������ PROCEDURE FirstKlAcct :
  24/02/12 SStepanov ����⠭���� FirstKlAcctPODFT, FirstKlAcctAll, FirstKlAcct
  29/03/12 SStepanov v3 +PROCEDURE GetLastHistoryDateSince: - ���� �� ᮧ����� ��� ������஢�� ������ ������ � ���� +date-in

	Modified: 13/07/12 SSitov - ������� �㭪�� KlientCardPoAcct ��� ������ pir_anketa_pk.p
		  (��ࢮ��砫쭠� ����� �।�⠢�⥫� �� �������� �� (�11) �뫠 ॠ�������� ��אַ � pir_anketa.p,
		   ������ � ���쭥�襬 �뫠 �뢥���� � ��楤��� pir_anketa_pk.p)
*/

{intrface.get xclass} /* �㭪樨 ��� ࠡ��� � ����奬�� */

DEFINE VARIABLE notExistMessage AS CHARACTER INIT "(���������)" NO-UNDO.
DEFINE VARIABLE cKlList         AS CHARACTER INIT "��,��,��,�"    NO-UNDO.
/* ��᪨ ��⮢ �� ⨯�� ����⮢ */
DEFINE VARIABLE c_FL_balAcct AS CHARACTER INIT "40817*,40820*,42301*,42601*;!42.01*,423*,426*;40817*,40820*,423*,426*" NO-UNDO.
DEFINE VARIABLE c_IP_balAcct AS CHARACTER INIT "40802*,40807*;40802*,40807*".
DEFINE VARIABLE c_UL_balAcct AS CHARACTER INIT "405*,406*,407*,40807*,425*;405*,406*,407*,40807*" NO-UNDO.
DEFINE VARIABLE c_B_balAcct  AS CHARACTER INIT "30109*,30110*,30114*;30109*,30110*,30114*" NO-UNDO.

/* ========================================================================= */
/** �㭪�� ���� ᨬ���쭮� ���ଠ樨. �� �� ������⢨� �뢮����� ᮮ⢥����饥 ᮮ�饭�� */
FUNCTION PrintStringInfo RETURNS CHARACTER
   (INPUT cS AS CHARACTER) :

   IF {assigned cS}
   THEN RETURN cS.
   ELSE RETURN notExistMessage.
END FUNCTION.

/* ========================================================================= */
/** �㭪�� ���� ���� . �� �� ������⢨� �뢮����� ᮮ⢥����饥 ᮮ�饭�� */
FUNCTION PrintDateInfo RETURNS CHARACTER
   (INPUT daD AS DATE) :

   IF (daD = ?)
   THEN RETURN notExistMessage.
   ELSE RETURN STRING(daD, "99.99.9999").
END FUNCTION.


/* ========================================================================= */
/** �����頥� ���� �⫨�� �� "BIS" ��� ���짮��⥫�, ᮧ���訩 ��� ����訩 ��������� � ������ */
FUNCTION GetFirstHistoryUserid RETURNS CHARACTER
   (INPUT iTabl     AS CHARACTER,
    INPUT iMasterId AS CHARACTER):

   FIND FIRST history
      WHERE (history.file-name EQ iTabl)
        AND (history.field-ref EQ iMasterId)
        AND NOT CAN-DO("BIS", history.user-id)
      NO-LOCK NO-ERROR.

   IF AVAILABLE history
   THEN RETURN history.user-id.
   ELSE RETURN "".
END.

/* ========================================================================= */
FUNCTION RegGNI RETURNS CHARACTER
   (INPUT cR AS CHARACTER):

   IF    (cR EQ ?)
      OR (cR EQ "")
      OR (cR EQ "77")
      OR (cR EQ "78")
      OR (cR EQ "0")
      OR (cR EQ "00000")
      OR (cR EQ "00040")
      OR (cR EQ "00045")
   THEN
      RETURN "".
   ELSE
      CASE LENGTH(cR):
         WHEN 2 THEN
            RETURN REPLACE(REPLACE(GetCodeName ("���������", cR), "�������", "���."), "��⮭���� ����", "��") + ",".
         WHEN 5 THEN
            RETURN REPLACE(REPLACE(GetCodeName ("������",    cR), "�������", "���."), "��⮭���� ����", "��") + ",".
         OTHERWISE
            RETURN "".
      END CASE.
END.

/* ========================================================================= */
/* �८�ࠧ������ ���� � �ଠ� ����� � 㤮���⠥���� ����                   */
/* �ଠ� �����: ������,ࠩ��,��த,���.�㭪�,㫨�,���,�����,������,��஥��� */
/* ��祬 ���.2-5 ᮯ஢�������� ���������ﬨ �,�-�,� � �.�., � ���.6-9 ����������� ������ ��ࠬ� */
FUNCTION Kladr RETURNS CHARACTER
   (INPUT cReg AS CHARACTER, /* Country,GNI */
    INPUT cAdr AS CHARACTER):

   DEFINE VARIABLE cAdrPart AS CHARACTER EXTENT 9 INITIAL "".
   DEFINE VARIABLE cAdrKl   AS CHARACTER.
   DEFINE VARIABLE iI       AS INTEGER.
   DEFINE VARIABLE iNzpt    AS INTEGER.

   iNzpt = MINIMUM(NUM-ENTRIES(cAdr), 9).

   DO iI = 1 TO iNzpt:
      cAdrPart[iI] = ENTRY(iI, cAdr).
   END.

   IF (ENTRY(1, cReg) NE "RUS")
   THEN DO:
      FIND FIRST country
         WHERE (country.country-id EQ ENTRY(1, cReg))
         NO-LOCK NO-ERROR.
      cAdrKl = IF (AVAIL country) THEN TRIM(country.country-name) ELSE "".

      IF     (cAdrPart[1] NE "")
         AND (cAdrPart[1] NE "000000")
      THEN
         cAdrKl = TRIM(cAdrKl + "," + cAdrPart[1], ",").

      DO iI = 2 TO MINIMUM(iNzpt, 9) :
         IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + "," + cAdrPart[iI].
      END.
   END.
   ELSE DO:
      cAdrKl = TRIM((IF ((cAdrPart[1] NE "") AND (cAdrPart[1] NE "000000"))
                     THEN (cAdrPart[1] + ",")
                     ELSE "")
                   + RegGNI(ENTRY(2, cReg)), ",").
      DO iI = 2 TO MINIMUM(iNzpt, 5) :
         IF (cAdrPart[iI] NE "") THEN cAdrKl = cAdrKl + "," + cAdrPart[iI].
      END.

      IF     (cAdrPart[6] NE "")
         AND (iNzpt GE 6)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[6], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",�.")
                + cAdrPart[6].
      END.

      IF     (cAdrPart[9] NE "")
         AND (iNzpt EQ 9)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[9], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",���.")
                + cAdrPart[9].
      END.

      IF     (cAdrPart[7] NE "")
         AND (iNzpt GE 7)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[7], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",���.")
                + cAdrPart[7].
      END.

      IF     (cAdrPart[8] NE "")
         AND (iNzpt GE 8)
      THEN DO:
         iI = INTEGER(SUBSTRING(cAdrPart[8], 1, 1)) NO-ERROR.
         cAdrKl = cAdrKl
                + (IF (ERROR-STATUS:ERROR) THEN "," ELSE ",��.")
                + cAdrPart[8].
      END.
   END.

   RETURN TRIM(cAdrKl, ",").
END.

/* ========================================================================= */
/**  */
FUNCTION KlIndex RETURNS INTEGER
   (INPUT iKl AS CHARACTER):

   RETURN LOOKUP(iKl, cKlList).
END FUNCTION.

/* ========================================================================= */
/**  */
FUNCTION KlType RETURNS CHARACTER
   (INPUT iKl AS CHARACTER):

   DEFINE VARIABLE cKlTypeL AS CHARACTER INIT "�,�,�,�"    NO-UNDO.

   RETURN ENTRY(LOOKUP(iKl, cKlList), cKlTypeL).
END FUNCTION.

/* ========================================================================= */
/**  */
FUNCTION KlTabl RETURNS CHARACTER
   (INPUT iKl AS CHARACTER):

   DEFINE VARIABLE cKlTablL AS CHARACTER INIT "person,cust-corp,cust-corp,banks" NO-UNDO.

   RETURN ENTRY(LOOKUP(iKl, cKlList), cKlTablL).
END FUNCTION.

/* ========================================================================= */
/**  */
FUNCTION UL-IP RETURNS CHARACTER
   (INPUT piStat     AS CHARACTER):    /* cust-stat */

   RETURN IF (piStat EQ "��") OR (piStat EQ "�����")
          THEN "��" ELSE "��".
END FUNCTION.

/* ========================================================================= */
/* �����頥� �६� ��᫥����� ��������� ����� ������ ���㤭����� �⤥���� ���ࠧ������� */
PROCEDURE GetLastHistoryDate:
   DEFINE INPUT  PARAMETER iKl       AS CHARACTER.  /* ��,��,��,� */
   DEFINE INPUT  PARAMETER iKlId     AS INTEGER.    /* cust-id    */
   DEFINE INPUT  PARAMETER iSince    AS DATE.
   DEFINE OUTPUT PARAMETER oLastDate AS DATE.
   DEFINE OUTPUT PARAMETER oUser     AS CHARACTER.

   DEFINE VARIABLE dLastDate  AS DATE      NO-UNDO.
   DEFINE VARIABLE cUser      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cUprList   AS CHARACTER INIT "�-5,�-6,�-11,�-17"                NO-UNDO.
   DEFINE VARIABLE cAdrList   AS CHARACTER EXTENT 4
                                 INIT ["����ய,�������", "�����,�������,�������",
                                       "�����,�������"  , "�����,�������"]         NO-UNDO.

   DEFINE VARIABLE cFldList   AS CHARACTER                                         NO-UNDO.
   DEFINE VARIABLE iKlType    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cKlTabl    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cKlType    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSurr      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE I          AS INTEGER   NO-UNDO.
   DEFINE VARIABLE J          AS INTEGER   NO-UNDO.

   IF (SUBSTRING(iKl, 1, 2) EQ "��")
   THEN DO:
      cUprList = "�-7".
      iKl      = SUBSTRING(iKl, 3, LENGTH(iKl) - 2).
   END.

   iKlType   = KlIndex(iKl).
   cKlTabl   = KlTabl(iKl).
   cKlType   = KlType(iKl).

   CASE iKl:
      WHEN "��" THEN
         cFldList = "name-last,first-names,phone[1],phone[2],fax,*��᪎��,*�業����᪠,"
                  + "*FirstAccDate,birthday,*BirthPlace,country-id,inn,"
                  + "*��������,*VisaNum,*country-id2,*�������삨���,"
                  + "*�����ॡ뢑,*�����ॡ뢏�,*�����ࠢ�ॡ�,*�����ࠢ�ॡ��,"
                  + "*�����_����,*�⭎���_����,*�⥯�����_����,"
                  + "address[1],address[2],*PlaceOfStay,*���������,*�����������,"
                  + "document,document-id,*Document4Date_vid,issue".
      WHEN "��" THEN
         cFldList = "name-corp,cust-stat,*���,*RegDate,*RegPlace,*tel,fax,inn,"
                  + "*pirOtherBanks,*pirBusImage,*��᪎��,*�業����᪠,*FirstAccDate,"
                  + "*BirthDay,*BirthPlace,*country-id,*document-id,*document,*Document4Date_vid,"
                  + "*issue,*��������,*VisaNum,*country-id2,*�������삨���,"
                  + "*�����ॡ뢑,*�����ॡ뢏�,*�����ࠢ�ॡ�,*�����ࠢ�ॡ��,"
                  + "*�����_����,*�⭎���_����,*�⥯�����_����,"
                  + "addr-of-low[1],addr-of-low[2],*PlaceOfStay,*����,"
                  + "*�����������,*���������,addr-of-post[1],addr-of-post[2]".
      WHEN "��" THEN
         cFldList = "name-corp,name-short,*engl-name,cust-stat,*���,*RegDate,*RegPlace,"
                  + "*tel,fax,inn,*���,*������,*���⠢��,*���⠢���,*��⠢���,*�����࣓�ࠢ,"
                  + "*pirOtherBanks,*pirBusImage,*��᪎��,*�業����᪠,*FirstAccDate,"
                  + "addr-of-low[1],addr-of-low[2],*PlaceOfStay,*���������,*�����������".
      WHEN "�"  THEN
         cFldList = "name,*pirFullName,short-name,*pirShortName,*engl-name,*bank-stat,"
                  + "*����,*RegDate,*RegPlace,*tel,*fax,*���,inn,*���,*������,*��⠢���,"
                  + "*�����࣓�ࠢ,*��᪎��,*�業����᪠,*FirstAccDate,"
                  + "law-address,mail-address".
   END CASE.

   dLastDate = iSince.
   cUser     = "".

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
         THEN DO:
            IF (history.modify EQ "W")
            THEN
            DO I = 1 TO (NUM-ENTRIES(history.field-value) - 2) BY 2:
               DO J = 1 TO NUM-ENTRIES(cFldList):
                  IF (ENTRY(I, history.field-value) EQ ENTRY(J, cFldList))
                  /* ��諨 ��᫥���� �ࠢ�� */
                  THEN DO:
                     dLastDate = history.modif-date.
                     cUser     = history.user-id.
                     LEAVE CustHist.
                  END.
               END.
            END.
            IF (history.modify EQ "C")
            THEN DO:
               dLastDate = history.modif-date.
               cUser     = history.user-id.
               LEAVE CustHist.
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
               cUser     = history.user-id.
               LEAVE AddrHist.
            END.
         END.
      END.
   END.

   IF (cUser EQ "")
   THEN DO:

      FIND FIRST history
         WHERE history.file-name EQ cKlTabl
           AND history.field-ref EQ STRING(iKlId)
           AND ((history.modify  EQ "C")
             OR (history.modify  EQ "W"))
         NO-LOCK NO-ERROR.

      IF AVAILABLE history
      THEN DO:
         cUser     = history.user-id.
         dLastDate = history.modif-date.
      END.

      IF     (iSince    NE 01/01/1900)
         AND (dLastDate GT iSince)
      THEN
         dLastDate = iSince.
   END.

   oLastDate = dLastDate.
   oUser     = cUser.
END PROCEDURE.

/* ========================================================================= */
/* �����頥� �६� ��᫥����� ��������� ����� ������ ���㤭����� �⤥���� ���ࠧ������� */
PROCEDURE GetLastHistoryDateSince:
   DEFINE INPUT  PARAMETER iKl       AS CHARACTER.  /* ��,��,��,� */
   DEFINE INPUT  PARAMETER iKlId     AS INTEGER.    /* cust-id    */
   DEFINE INPUT  PARAMETER iSince    AS DATE.
   DEFINE OUTPUT PARAMETER oLastDate AS DATE.
   DEFINE OUTPUT PARAMETER oUser     AS CHARACTER.

   DEFINE VARIABLE dLastDate  AS DATE      NO-UNDO.
   DEFINE VARIABLE cUser      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cUprList   AS CHARACTER INIT "�-5,�-6,�-11,�-17"                NO-UNDO.
   DEFINE VARIABLE cAdrList   AS CHARACTER EXTENT 4
                                 INIT ["����ய,�������", "�����,�������,�������",
                                       "�����,�������"  , "�����,�������"]         NO-UNDO.

   DEFINE VARIABLE cFldList   AS CHARACTER                                         NO-UNDO.
   DEFINE VARIABLE iKlType    AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cKlTabl    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cKlType    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cSurr      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE I          AS INTEGER   NO-UNDO.
   DEFINE VARIABLE J          AS INTEGER   NO-UNDO.

   IF (SUBSTRING(iKl, 1, 2) EQ "��")
   THEN DO:
      cUprList = "�-7".
      iKl      = SUBSTRING(iKl, 3, LENGTH(iKl) - 2).
   END.

   iKlType   = KlIndex(iKl).
   cKlTabl   = KlTabl(iKl).
   cKlType   = KlType(iKl).

   CASE iKl:
      WHEN "��" THEN
         cFldList = "name-last,first-names,phone[1],phone[2],fax,*��᪎��,*�業����᪠,date-in,"
                  + "*FirstAccDate,birthday,*BirthPlace,country-id,inn,"
                  + "*��������,*VisaNum,*country-id2,*�������삨���,"
                  + "*�����ॡ뢑,*�����ॡ뢏�,*�����ࠢ�ॡ�,*�����ࠢ�ॡ��,"
                  + "*�����_����,*�⭎���_����,*�⥯�����_����,"
                  + "address[1],address[2],*PlaceOfStay,*���������,*�����������,"
                  + "document,document-id,*Document4Date_vid,issue".
      WHEN "��" THEN
         cFldList = "name-corp,cust-stat,*���,*RegDate,*RegPlace,*tel,fax,inn,date-in,"
                  + "*pirOtherBanks,*pirBusImage,*��᪎��,*�業����᪠,*FirstAccDate,"
                  + "*BirthDay,*BirthPlace,*country-id,*document-id,*document,*Document4Date_vid,"
                  + "*issue,*��������,*VisaNum,*country-id2,*�������삨���,"
                  + "*�����ॡ뢑,*�����ॡ뢏�,*�����ࠢ�ॡ�,*�����ࠢ�ॡ��,"
                  + "*�����_����,*�⭎���_����,*�⥯�����_����,"
                  + "addr-of-low[1],addr-of-low[2],*PlaceOfStay,*����,"
                  + "*�����������,*���������,addr-of-post[1],addr-of-post[2]".
      WHEN "��" THEN
         cFldList = "name-corp,name-short,*engl-name,cust-stat,*���,*RegDate,*RegPlace,date-in,"
                  + "*tel,fax,inn,*���,*������,*���⠢��,*���⠢���,*��⠢���,*�����࣓�ࠢ,"
                  + "*pirOtherBanks,*pirBusImage,*��᪎��,*�業����᪠,*FirstAccDate,"
                  + "addr-of-low[1],addr-of-low[2],*PlaceOfStay,*���������,*�����������".
      WHEN "�"  THEN
         cFldList = "name,*pirFullName,short-name,*pirShortName,*engl-name,*bank-stat,date-in,"
                  + "*����,*RegDate,*RegPlace,*tel,*fax,*���,inn,*���,*������,*��⠢���,"
                  + "*�����࣓�ࠢ,*��᪎��,*�業����᪠,*FirstAccDate,"
                  + "law-address,mail-address".
   END CASE.

   dLastDate = iSince.
   cUser     = "".

   /* ��ᬠ�ਢ��� ����� ������ */
   CustHist:
   FOR EACH history
      WHERE history.file-name EQ cKlTabl
        AND history.field-ref EQ STRING(iKlId)
        AND history.modif-date >= iSince
        AND history.modif-time >= 0

      NO-LOCK
 	USE-INDEX file-hist-id
/*      BY history.file-name
      BY history.modif-date DESCENDING
      BY history.modif-time DESCENDING
*/
      :

      FIND FIRST _user
         WHERE _user._userid = history.user-id
         NO-LOCK NO-ERROR.

/* MESSAGE cKlTabl STRING(iKlId) iSince history.modif-date history.user-id (AVAILABLE _user) (history.modify EQ "W") VIEW-AS ALERT-BOX.  */

      IF AVAILABLE _user
      THEN DO:
/* SSV         IF CAN-DO(cUprList, GetXAttrValue("_user", _user._userid, "group-id"))
         THEN DO: */
            IF (history.modify EQ "W")
            THEN
            DO I = 1 TO (NUM-ENTRIES(history.field-value) - 2) BY 2:
               DO J = 1 TO NUM-ENTRIES(cFldList):
/* MESSAGE ENTRY(I, history.field-value) ENTRY(J, cFldList) VIEW-AS ALERT-BOX.   */
                  IF (ENTRY(I, history.field-value) EQ ENTRY(J, cFldList))
                  /* ��諨 ��᫥���� �ࠢ�� */
                  THEN DO:
                     dLastDate = history.modif-date.
                     cUser     = history.user-id.
/* MESSAGE dLastDate cUser VIEW-AS ALERT-BOX.  */
                     LEAVE CustHist.
                  END.
               END.
            END.
            IF (history.modify EQ "C")
            THEN DO:
               dLastDate = history.modif-date.
               cUser     = history.user-id.
               LEAVE CustHist.
            END.
         END.
/*      END. */
   END.
/* SSV <<
   / * ��ᬠ�ਢ��� ����� ���ᮢ, ��業���, 㤮�⮢�७�� ��筮�� * /
   FOR EACH cust-ident
      WHERE ((cust-ident.class-code EQ "cust-lic")
          OR (cust-ident.class-code EQ "p-cust-adr")
          OR (cust-ident.class-code EQ "p-cust-ident")
          OR (cust-ident.class-code EQ "cust-bank"))
        AND (cust-ident.cust-cat    EQ cKlType)
        AND (cust-ident.cust-id     EQ iKlId)
      NO-LOCK:

      / * ����砥��� �� ��� ���� � ������ * /
      IF (cust-ident.class-code EQ "p-cust-adr")
        AND NOT CAN-DO(cAdrList[iKlType], cust-ident.cust-code-type)
      THEN NEXT.

      / * ����砥��� �� ��� �����䨪��� ����� � ������ * /
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
           AND history.modif-date >= dLastDate
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
               cUser     = history.user-id.
               LEAVE AddrHist.
            END.
         END.
      END.
   END.
SSV >> */
/*
   IF (cUser EQ "")
   THEN DO:

      FIND FIRST history
         WHERE history.file-name EQ cKlTabl
           AND history.field-ref EQ STRING(iKlId)
           AND ((history.modify  EQ "C")
             OR (history.modify  EQ "W"))
         NO-LOCK NO-ERROR.

      IF AVAILABLE history
      THEN DO:
         cUser     = history.user-id.
         dLastDate = history.modif-date.
      END.

      IF     (iSince    NE 01/01/1900)
         AND (dLastDate GT iSince)
      THEN
         dLastDate = iSince.
   END.
*/
   oLastDate = dLastDate.
   oUser     = cUser.
END PROCEDURE.

/* ========================================================================= */
/* �����頥� �६� ��᫥����� ��������� ����� ������ ���㤭����� �⤥���� ���ࠧ������� */
PROCEDURE GetLastAnketaDate:
   DEFINE INPUT  PARAMETER iKl       AS CHARACTER.  /* ��,��,��,� */
   DEFINE INPUT  PARAMETER iKlId     AS INTEGER.    /* cust-id    */
   DEFINE OUTPUT PARAMETER oLastDate AS DATE.
   DEFINE OUTPUT PARAMETER oUser     AS CHARACTER.

   DEFINE VARIABLE cKlTabl    AS CHARACTER NO-UNDO.

   cKlTabl   = KlTabl(iKl).
   oUser     = GetXAttrValue(cKlTabl, STRING(iKlId), "pirSotrObnAnk").

/*   FIND FIRST acct
      WHERE (acct.cust-cat EQ KlType(iKl))
        AND (acct.cust-id  EQ iKlId)
      NO-LOCK NO-ERROR.

   IF     (NOT AVAIL acct)
      AND (iKl NE "�")
   THEN
      oLastDate = 01/01/2099.
   ELSE*/
      oLastDate = DATE(GetTempXAttrValueEx(cKlTabl, STRING(iKlId), "��⠎��������",end-date,"01/01/2098")).

END PROCEDURE.

/* ========================================================================= */
/*  */
FUNCTION KlientAcctList RETURNS CHARACTER
   (INPUT pcKl    AS CHARACTER):  /* ��,��,��,� */

   CASE pcKl:
      WHEN "��" THEN
         RETURN c_FL_balAcct.
/*         RETURN "40817810*,40820810*,42301810*,42601810*;!42.01*,423..810*,426..810*;"
              + "!.....810*,40817*,40820*,42301*,42601*;!.....810*,!42.01*,423*,426*;"
              + "40817*,40820*,423*,426*".
*/
      WHEN "��" THEN
         RETURN c_IP_balAcct.
/*
         RETURN "40802810*;!.....810*,40802*;40802*".
*/
      WHEN "��" THEN
         RETURN c_UL_balAcct.
/*
         RETURN "405..810*,406..810*,407..810*,40807810*;"
              + "!.....810*,405*,406*,407*,40807*;405*,406*,407*,40807*".
*/
      WHEN "�"  THEN
         RETURN c_B_balAcct.
/*
         RETURN "30109810*,30110810*,30114810*;!.....810*,30109*,30110*,30114*;"
              + "30109*,30110*,30114*".
*/
   END CASE.
   RETURN "".
END FUNCTION. /* KlientAcctList */

/* ========================================================================= */
/*  */
FUNCTION KlientMainAcct RETURNS CHARACTER
   (INPUT iKlCat    AS CHARACTER,
    INPUT iKlId     AS INTEGER,
    INPUT iKlOPF    AS CHARACTER):

   DEFINE VARIABLE cAcctL   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cKlCat   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iI       AS INTEGER   NO-UNDO.

   CASE iKlCat:
      WHEN "person" THEN
         ASSIGN
            cKlCat = "�"
            cAcctL = "40817810*,40820810*;42301810*,42601810*;"
                   + "40817*,40820*;42301*,42601*;"
                   + "!42.01*,423..810*,426..810*;"
                   + "!42.01*,423*,426*;*"
            NO-ERROR.
      WHEN "banks"  THEN
         ASSIGN
            cKlCat = "�"
            cAcctL = "30109810*,30110810*,30114810*;"
                   + "30109*,30110*,30114*;*"
            NO-ERROR.
      WHEN "cust-corp" THEN DO:
         IF CAN-DO("��,�����,�������,������", iKlOPF)
         THEN
            cAcctL = "40802810*,40807810*;"
                   + "40802*,40807*;*".
         ELSE
            cAcctL = "!*3......,!*3.....,405..810*,406..810*,407..810*,40807810*;"
                   + "!*3......,!*3.....,405*,406*,407*,40807*;*".
         cKlCat = "�".
      END.
   END CASE.

   DO iI = 1 TO NUM-ENTRIES(cAcctL, ";"):
      FOR EACH acct
         WHERE (acct.cust-cat   EQ cKlCat)
           AND (acct.cust-id    EQ iKlId)
           AND (acct.close-date EQ ?)
           AND CAN-DO(ENTRY(iI, cAcctL, ";"), acct.acct)
         NO-LOCK
         BY acct.open-date:

         RETURN acct.acct.
      END.
   END.
END FUNCTION. /* KlientMainAcct */

/* ========================================================================= */
/*  */
PROCEDURE FirstKlAcctAll :
   DEFINE INPUT  PARAMETER iKl        AS CHARACTER.  /* ��,��,��,� */
   DEFINE INPUT  PARAMETER iKlId      AS INTEGER.    /* cust-id    */
   DEFINE INPUT  PARAMETER pPODFTversoin AS LOG.
   DEFINE OUTPUT PARAMETER oAcct      AS CHARACTER.
   DEFINE OUTPUT PARAMETER oOpenDate  AS DATE.
   DEFINE OUTPUT PARAMETER oCloseDate AS DATE.
   DEFINE OUTPUT PARAMETER oUser      AS CHARACTER.

   DEFINE VARIABLE cKlType    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAcct      AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAcctList  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTmpAL     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iALNum     AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iI         AS INTEGER    NO-UNDO.
   DEFINE VARIABLE lPred      AS LOGICAL    NO-UNDO.
   DEFINE VARIABLE daNeprer   AS DATE       NO-UNDO.

   cKlType   = KlType(iKl).
   cAcctList = KlientAcctList(iKl).

   cAcct     = "".
   iALNum    = NUM-ENTRIES(cAcctList, ";").

   lOpenAcct:
   DO iI = 1 TO (iALNum - 1):

      cTmpAL = ENTRY(iI, cAcctList, ";").

      FOR EACH acct
         WHERE acct.cust-cat   EQ cKlType
           AND acct.cust-id    EQ iKlId
           AND acct.close-date EQ ?
           AND NOT CAN-DO("�����,�����,��*", acct.contract)
           AND CAN-DO(cTmpAL, acct.acct)
         NO-LOCK
         BY acct.open-date:

         ASSIGN
            cAcct      = acct.acct
            oOpenDate  = acct.open-date
            oCloseDate = ?
            oUser      = GetXAttrValue("acct", cAcct + "," + acct.currency, "���������")
         .
         LEAVE lOpenAcct.
      END.
   END.

   /* �஢��塞 ������� ��� */
  IF (cAcct EQ "")
   THEN DO:

      cTmpAL = ENTRY(iALNum, cAcctList, ";").

      FOR EACH acct
         WHERE acct.cust-cat   EQ cKlType
           AND acct.cust-id    EQ iKlId
           AND acct.close-date NE ?
           AND NOT CAN-DO("�����,�����,��*", acct.contract)
           AND CAN-DO(cTmpAL, acct.acct)
         NO-LOCK
         BY acct.open-date:

         ASSIGN
             cAcct      = acct.acct
/* oOpenDate  = acct.open-date 	  04/10/11 SStepanov �᫨ ��� ������, � �� ��������� ���� 1.14 "��� ������ ���" */
            oCloseDate = acct.close-date
            oUser      = GetXAttrValue("acct", cAcct + "," + acct.currency, "���������")
         .
         IF pPODFTversoin = YES
	   THEN oOpenDate  = acct.open-date.
         LEAVE.
      END.
   END.
/**/
   /* �஢��塞 ��� ������� ��᫥ ��� ������ ��� �� ���� ���� �� ������ = "�����뢭�" */
   lPred = (cAcct NE "").
   DO WHILE lPred:

      lPred = NO.

      daNeprer = oOpenDate - 1.
      DO WHILE holiday(daNeprer):
         daNeprer = daNeprer - 1.
      END.

      lNextAcct:
      DO iI = 1 TO (iALNum - 1):

         cTmpAL = ENTRY(iI, cAcctList, ";").

         FOR EACH acct
            WHERE acct.cust-cat   EQ cKlType
              AND acct.cust-id    EQ iKlId
              AND acct.close-date GE daNeprer
              AND acct.open-date  LE daNeprer
              AND NOT CAN-DO("�����,�����,��*", acct.contract)
              AND CAN-DO(cTmpAL, acct.acct)
            NO-LOCK
            BY acct.open-date:

            ASSIGN
               cAcct     = acct.acct
               oOpenDate = acct.open-date
               oUser     = GetXAttrValue("acct", cAcct + "," + acct.currency, "���������")
               lPred     = YES
            .
            LEAVE lNextAcct.
         END.
      END.
   END.
   oAcct = cAcct.

END PROCEDURE. /* FirstKlAcctAll */

PROCEDURE FirstKlAcct :
   DEFINE INPUT  PARAMETER iKl        AS CHARACTER.  /* ��,��,��,� */
   DEFINE INPUT  PARAMETER iKlId      AS INTEGER.    /* cust-id    */
   DEFINE OUTPUT PARAMETER oAcct      AS CHARACTER.
   DEFINE OUTPUT PARAMETER oOpenDate  AS DATE.
   DEFINE OUTPUT PARAMETER oCloseDate AS DATE.
   DEFINE OUTPUT PARAMETER oUser      AS CHARACTER.

  RUN FirstKlAcctAll(iKl, iKlId, NO, OUTPUT oAcct, OUTPUT oOpenDate, OUTPUT oCloseDate, OUTPUT oUser).

END PROCEDURE. /* FirstKlAcct */

PROCEDURE FirstKlAcctPODFT :
   DEFINE INPUT  PARAMETER iKl        AS CHARACTER.  /* _<,__,"<,_ */
   DEFINE INPUT  PARAMETER iKlId      AS INTEGER.    /* cust-id    */
   DEFINE OUTPUT PARAMETER oAcct      AS CHARACTER.
   DEFINE OUTPUT PARAMETER oOpenDate  AS DATE.
   DEFINE OUTPUT PARAMETER oCloseDate AS DATE.
   DEFINE OUTPUT PARAMETER oUser      AS CHARACTER.

  RUN FirstKlAcctAll(iKl, iKlId, YES, OUTPUT oAcct, OUTPUT oOpenDate, OUTPUT oCloseDate, OUTPUT oUser).
END PROCEDURE. /* FirstKlAcctPODFT */

/* ========================================================================= */
/*  */
FUNCTION GetFirstAcctUser RETURNS CHARACTER
   (INPUT iKl        AS CHARACTER,  /* ��,��,��,� */
    INPUT iKlId      AS INTEGER,    /* cust-id    */
    INPUT iOpenDate  AS DATE):

   DEFINE VARIABLE cKlType    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cAcctList  AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cTmpAL     AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE iALNum     AS INTEGER    NO-UNDO.
   DEFINE VARIABLE iI         AS INTEGER    NO-UNDO.

   cKlType   = KlType(iKl).
   cAcctList = KlientAcctList(iKl).

   iALNum    = NUM-ENTRIES(cAcctList, ";").

   DO iI = 1 TO (iALNum - 1):

      cTmpAL = ENTRY(iI, cAcctList, ";").

      FOR EACH acct
         WHERE acct.cust-cat  EQ cKlType
           AND acct.cust-id   EQ iKlId
/*           AND acct.open-date EQ iOpenDate */
           AND CAN-DO(cTmpAL, acct.acct)
         NO-LOCK
         BY acct.open-date:

         RETURN GetXAttrValue("acct", acct.acct + "," + acct.currency, "���������").
      END.
   END.

   RETURN "".
END FUNCTION. /* GetFirstAcctUser */



/* ========================================================================= */
/* �����頥� �� ������ ��� ����� ���-�����, ���� ��砫� ����⢨� ����� � ��� ����砭�� */
FUNCTION KlientCardPoAcct RETURNS CHARACTER
   (INPUT iKlAcct    AS CHARACTER,
    INPUT iKlId      AS INTEGER    ):    /* person-id    */


   DEFINE VARIABLE cTmpCrd     AS CHARACTER  INIT "" NO-UNDO.

   FOR EACH loan-acct
     WHERE loan-acct.acct = iKlAcct
        AND loan-acct.contract BEGINS "card"
    NO-LOCK,
    FIRST loan
      WHERE loan.cust-id EQ iKlId
	AND loan.contract EQ "card"
        AND loan.parent-contract  EQ loan-acct.contract
        AND loan.parent-cont-code EQ loan-acct.cont-code
        AND loan.loan-work <> YES
        AND CAN-DO("���,���,���",loan.loan-status)
        AND loan.close-date = ?
    NO-LOCK:

	IF AVAIL (loan-acct) THEN
		cTmpCrd = loan.doc-num + "," + STRING(loan.open-date) + "," + STRING(loan.end-date).

    END.

    RETURN cTmpCrd.

END FUNCTION. /* KlientCardPoAcct */