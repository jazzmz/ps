/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2003 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: PP-CUST.P
      Comment: ������⥪� ࠡ��� � �����⠬�
   Parameters:
         Uses:
      Used by:
      Created: 06.02.2004 NIK
     Modified: 12.03.2004 10:59 KSV      (0019947) ��������� ��楤��
                                         GetCustomerByIdnt ��� ���᪠ ������
                                         �� �����䨪����.
     Modified: 22.03.2004 18:39 KSV      (0019947) ��楤�� GetCustomerByIdnt
                                         ��ࠡ�⠭� ��� ���� �ࠢ�筨�
                                         �����䨪��஢ ��ꥪ⮢. ���������
                                         ��楤�� FltCustomerByIdnt,
                                         ��������� �᫮��� �⡮� ��ꥪ⮢
                                         �� �����䨪����.
     Modified: 01.04.2004 20:03 KSV      (0019702) ��������� ��楤��
                                         GetCustIdent, ��������� ���祭��
                                         �����䨪��� ��� ��ꥪ�.
     Modified: 02.04.2004 13:12 KSV      (0019947) ��ࠡ�⠭� ��楤��
                                         GetCustomerByIdnt, ���������
                                         ����������� �롮� �� ��⠬.
                                         ��ࠢ���� �訡�� � ���᪥ ��
                                         ���ࢠ�� � ��楤�� GetCustIdent.
     Modified: 19.04.2005 18:00 mkv      (0040652) ��ࠡ�⠭� ��楤��
                                         GetCustShortName, ���������
                                         ����������� ������ ���⪮�� ������������ ������.
     Modified: 30.06.2006 kraw (0052275) ��ॢ�� ��� �� counters;CNTUNK
     Modified: 09/11/2009 kraw (0118683) GetCustIDRWD, GetCustIDNom, GetCustIDIssue
     Modified: 20/04/2010 kraw (0126030) GetCustIDOpenDate
     Modified: 22/06/2010 kraw (0129707) ",�" � GetCustNameFormatted
     Modified: 08/12/2010 kraa (0111435) ��ࠡ�⠭� ��楤�� GetFirstUnassignedFieldManByRole.

*/

{globals.i}             /* �������� ��६���� ��ᨨ. */
{ppcust.def}            /* ��।������ ��६�����. */
{intrface.get db2l}     /* �����㬥�� ��� �������᪮� ࠡ��� � ��. */
{intrface.get tmess}    /* �����㬥��� ��ࠡ�⪨ ᮮ�饭��. */
{intrface.get isrv}
{intrface.get count}    /* ������⥪� ��� ࠡ��� � ���稪���. */
{intrface.get brnch}
{intrface.get acct}     /* ������⥪� ��� ࠡ��� � ��⠬�. */
{intrface.get strng}
{getcli.pro}
{innchk.i}

&GLOBAL-DEFINE CustIdntSurr    cust-ident.cust-code-type + ',' + ~
                               cust-ident.cust-code      + ',' + ~
                        STRING(cust-ident.cust-type-num)

/*------------------------------------------------------------------------------
  Purpose:     ���� ������ �� �����䨪����, �������饣� � 㪠����� 
               ���ࢠ� �६���
  Parameters:  iCodeType - ⨯ �����䨪���
               iCode     - ���祭�� �����䨪���
               iNum      - ���浪��� ����� �����䨪���
               iBegDate  - ��� ��砫� ����⢨� �����䨪���
               iEndDate  - ��� ����砭�� ����⢨� �����䨪���
               oCustCat  - ⨯ ������
               oCustID   - ����७��� �����䨪��� ������
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE GetCustomerByIdnt:
   DEFINE INPUT  PARAMETER iCodeType   AS CHARACTER         NO-UNDO.
   DEFINE INPUT  PARAMETER iCode       AS CHARACTER         NO-UNDO.
   DEFINE INPUT  PARAMETER iNum        AS INT64           NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate    AS DATE              NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate    AS DATE              NO-UNDO.
   DEFINE OUTPUT PARAMETER oCustCat    AS CHARACTER  INIT ? NO-UNDO.
   DEFINE OUTPUT PARAMETER oCustID     AS CHARACTER  INIT ? NO-UNDO.

   DEFINE VARIABLE vEndDate AS DATE       NO-UNDO.

   DEFINE BUFFER cust-ident FOR cust-ident.

   IF iBegDate = ? THEN iBegDate = {&BQ-MAX-DATE}.
   IF iEndDate = ? THEN iEndDate = {&BQ-MIN-DATE}.

   FOR EACH cust-ident WHERE
      cust-ident.cust-code-type = iCodeType AND
      cust-ident.cust-code      = iCode     AND 
      cust-ident.cust-type-num >= (IF iNum > 0 THEN iNum ELSE {&BQ-MIN-INT}) AND 
      cust-ident.cust-type-num <= (IF iNum > 0 THEN iNum ELSE {&BQ-MAX-INT}) AND 
      cust-ident.open-date     <= iBegDate   NO-LOCK:
      
      vEndDate = (IF cust-ident.close-date = ? 
                  THEN {&BQ-MAX-DATE} 
                  ELSE cust-ident.close-date).
      IF vEndDate < iEndDate THEN NEXT.

      IF oCustCat = ? THEN
         ASSIGN
            oCustCat = ""   
            oCustID  = "".

      {additem.i oCustCat cust-ident.cust-cat}
      {additem.i oCustID  STRING(cust-ident.cust-id)}
   END. /* End of FOR */
END PROCEDURE.


FUNCTION FrmtAddrStr RETURNS CHARACTER (ipAdrChar AS CHARACTER, ipRegCode AS CHARACTER ):
   DEFINE VAR opFrmtAddrStr AS CHARACTER NO-UNDO.
   DEFINE VAR DefFmtStr     AS CHARACTER INIT ",,,,,�.,���.,��.,���.,,,,," NO-UNDO.   
   DEFINE VAR vTag          AS CHARACTER NO-UNDO.
   DEFINE VAR i             AS INTEGER   NO-UNDO.   
   DEFINE VAR iRegName      AS CHARACTER NO-UNDO. 
   IF NUM-ENTRIES(ipAdrChar) LT 9 THEN RETURN ipAdrChar.
   DO i = 1 TO NUM-ENTRIES(ipAdrChar):
      vTag = "".
      IF {assigned "TRIM(ENTRY(i,ipAdrChar))"} THEN DO:
         vTag = (IF {assigned "ENTRY(i,DefFmtStr)"} 
                 THEN (ENTRY(i,DefFmtStr) + " ") 
                 ELSE "")  + ENTRY(i,ipAdrChar).
          
         {additem.i opFrmtAddrStr vTag}
      END.
   END.                   
   IF {assigned ipRegCode} AND NOT CAN-DO("00045,00040",ipRegCode) THEN DO:
      iRegName = GetCodeNameEx("������",ipRegCode,"") + ",".
      IF iRegName NE "," AND NUM-ENTRIES(opFrmtAddrStr) > 1 THEN
      ENTRY(2,opFrmtAddrStr) = iRegName + ENTRY(2,opFrmtAddrStr).
   END.
   
   RETURN opFrmtAddrStr.
END FUNCTION.


/*------------------------------------------------------------------------------
  Purpose:     �����頥� �᫮��� �⡮� ��ꥪ⮢ �� ���������� �����䨪����
  Parameters:  iCodeType   - ⨯ �����䨪�樨
               iCode       - ���祭�� �����䨪���
               iPrefix     - ��� ⠡����, �� ���ன ��ந��� �᫮���
               oFltExpr    - �����頥��� �᫮��� �⡮�
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE FiltCustomerByIdnt:
   DEFINE INPUT  PARAMETER iCodeType   AS CHARACTER            NO-UNDO.
   DEFINE INPUT  PARAMETER iCode       AS CHARACTER            NO-UNDO.
   DEFINE INPUT  PARAMETER iPrefix     AS CHARACTER            NO-UNDO.
   DEFINE OUTPUT PARAMETER oFltExpr    AS CHARACTER  INIT "NO" NO-UNDO.

   DEFINE VARIABLE vCustCat   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCustID    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE vCnt       AS INT64    NO-UNDO.
   DEFINE VARIABLE vNum       AS INT64    NO-UNDO.


   RUN GetCustomerByIdnt (iCodeType,iCode,0,?,?,OUTPUT vCustCat,OUTPUT vCustID).

   IF vCustCat = ? THEN RETURN.

   oFltExpr = "(".

   iPrefix = IF {assigned iPrefix} THEN iPrefix + "." ELSE "".
      
   vNum = NUM-ENTRIES(vCustCat).
   DO vCnt = 1 TO vNum:
      oFltExpr = oFltExpr + "(" + iPrefix + "cust-cat = '" + 
         ENTRY(vCnt,vCustCat) + "' AND " + 
         iPrefix + "cust-id = '" + 
         ENTRY(vCnt,vCustID) + "')" + (IF vCnt = vNum THEN ")" ELSE " OR ").
   END.
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose:     �����頥� ���祭�� �����䨪��� ��� 㪠������� ��ꥪ�, 
               ��������� � 㪠����� ���ࢠ� �६���.
  Parameters:  iCustCat  - ⨯ ������
               iCustID   - �����䨪��� ������
               iBegDate  - ��� ��砫� ����⢨� �����䨪���
               iEndDate  - ��� ����砭�� ����⢨� �����䨪���
               iCustType - ⨯ �����䨪�樨
               oIdent    - ᯨ᮪ ���祭�� �����䨪���, ࠧ������� CHR(1)
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE GetCustIdent:
   DEFINE INPUT  PARAMETER iCustCat    AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER iCustID     AS INT64    NO-UNDO.
   DEFINE INPUT  PARAMETER iBegDate    AS DATE       NO-UNDO.
   DEFINE INPUT  PARAMETER iEndDate    AS DATE       NO-UNDO.
   DEFINE INPUT  PARAMETER iCustType   AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER oIdent      AS CHARACTER  NO-UNDO.

   {getcustident.i
      &BegDate  = iBegDate
      &EndDate  = iEndDate
      &CustCat  = iCustCat  
      &CustId   = iCustID
      &CustType = iCustType
      &RetValue = oIdent
   }
   RETURN oIdent.
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose:     �����頥� ���⪮� ������������
  Parameters:  iCustCat   - ⨯ ������
               iCustID    - �����䨪��� ������
               oShortName - �����頥��� ������������
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE GetCustShortName:
   DEF INPUT  PARAM iCustCat   AS CHAR NO-UNDO.
   DEF INPUT  PARAM iCustID    AS INT64  NO-UNDO.
   DEF OUTPUT PARAM oShortName AS CHAR NO-UNDO.

   oShortName = "".
   case iCustCat:
      when "�" then do:
         find first banks where banks.bank-id eq iCustID no-lock no-error.
         if avail banks then
            oShortName = banks.short-name.
      end.
      when "�" then do:
         find first cust-corp where cust-corp.cust-id eq iCustID no-lock no-error.
         if avail cust-corp then
            oShortName = cust-corp.name-short.
      end.
      when "�" then do:
         find first person where person.person-id eq iCustID no-lock no-error.
         if avail person then
            oShortName = person.name-last.
      end.
   end case.
   if oShortName eq ? then oShortName = "".
END PROCEDURE.


/**************************************************************************/

/* �����頥� ���祭�� �� ������ */
FUNCTION ClientXattrVal RETURNS CHARACTER (vCat  AS CHARACTER,
                                           vID   AS INT64,
                                           vAttr AS CHARACTER
   ):
   DEFINE VARIABLE vRet AS CHARACTER NO-UNDO.

   CASE vCat:
   WHEN "�" THEN
      vRet = GetXAttrValueEx("person",    STRING(vID), vAttr, "").
   WHEN "�" THEN
      vRet = GetXAttrValueEx("cust-corp", STRING(vID), vAttr, "").
   WHEN "�" THEN
      vRet = GetXAttrValueEx("banks",     STRING(vID), vAttr, "").
   END CASE.
   RETURN vRet.
END FUNCTION.

/* �����頥� ���祭�� �� ������ */
FUNCTION ClientTempXattrVal RETURNS CHARACTER (vCat  AS CHARACTER,
                                               vID   AS INT64,
                                               vAttr AS CHARACTER,
                                               iEnd AS DATE 
   ):
   DEFINE VARIABLE vRet AS CHARACTER NO-UNDO.

   CASE vCat:
   WHEN "�" THEN
      vRet = GetTempXAttrValueEx("person",    STRING(vID), vAttr,iEnd, "").
   WHEN "�" THEN
      vRet = GetTempXAttrValueEx("cust-corp", STRING(vID), vAttr,iEnd, "").
   WHEN "�" THEN
      vRet = GetTempXAttrValueEx("banks",     STRING(vID), vAttr,iEnd, "").
   END CASE.
   RETURN vRet.
END FUNCTION.

/* �����頥� ���祭�� �� ���譥�� ������ �� ��� ���� � �/����
   �᫨ ���譨� ������ �� ������, � �����頥� - ? */
FUNCTION BenXattrVal RETURNS CHARACTER (vCat  AS CHARACTER,
                                        vID   AS INT64,
                                        vBIC  AS CHARACTER,
                                        vAcct AS CHARACTER, 
                                        vAttr AS CHARACTER
   ):
   DEFINE VARIABLE vRet AS CHARACTER NO-UNDO INIT ?.

   CASE vCat:
   WHEN "�" THEN
      FOR FIRST cust-corp WHERE cust-corp.cust-id   EQ vID
                            AND cust-corp.benacct   EQ vAcct
                            AND cust-corp.bank-code EQ vBIC
                NO-LOCK:
         vRet = ClientXattrVal(vCat, vID, "���").
      END.
   WHEN "�" THEN
      FOR FIRST person WHERE person.person-id EQ vID
                         AND person.benacct   EQ vAcct
                         AND person.bank-code EQ vBIC
                NO-LOCK:
         vRet = ClientXattrVal(vCat, vID, "���").
      END.
   END CASE.
   RETURN vRet.
END FUNCTION.

PROCEDURE getKPPacct:
/* �����頥� ��� ���⥫�騪�/�����⥫� �� ���� */
   DEFINE INPUT  PARAMETER iRequisite AS CHARACTER NO-UNDO. /* kpp-send/kpp-rec */
   DEFINE INPUT  PARAMETER iAcctSurr  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oValue     AS CHARACTER NO-UNDO.

   DEFINE VARIABLE iRetVal AS CHARACTER NO-UNDO.

   FOR FIRST acct WHERE acct.acct     EQ ENTRY(2, iAcctSurr)
                    AND acct.currency EQ ENTRY(1, iAcctSurr)
             NO-LOCK:

      /* ��� ����ਡ�����᪨�? */
      IF acct.cust-cat EQ "�" THEN DO:
         /* ��।��塞 �.�. ��� ����/����� ���ࠧ������� �� ���� ���ࠧ������� ��� */
         oValue = GetXAttrValueEx("branch", acct.branch-id, iRequisite, "").
         IF oValue EQ "" THEN DO:
            oValue = fGetSetting("�������", ?, "").
         END.
      END.
      ELSE DO:
         oValue = ClientXattrVal(acct.cust-cat, acct.cust-id, "���").
         /* ��୥� ��뫪� �� ������, �⮡� ����� �뫮 �������� ��� ��� */
         iRetVal = ENTRY(LOOKUP(acct.cust-cat, "�,�,�"), "person,cust-corp,banks") + "," + STRING(acct.cust-id).
      END.
   END.
   RETURN iRetVal.
END PROCEDURE.

PROCEDURE getKPPben:
/* �����頥� ��� ���譥�� ������ �� ���� � ���� � ��� */
   DEFINE INPUT  PARAMETER iBIC       AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iAcct      AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iINN       AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oValue     AS CHARACTER NO-UNDO.

   DEFINE VARIABLE mSearchStr AS CHARACTER NO-UNDO.

   /* ��।��塞 ��� �� ����⥪� �����⥫�� */
   RUN GetRecipientValue (iBIC,
                          iAcct,
                          (IF iINN <> "" THEN iINN ELSE CHR(4)),
                          "���",
                          OUTPUT oValue
                         ).
   IF oValue NE "" THEN RETURN.

   /* �᫨ � ����⥪� �����⥫�� �� ��諨, � ��।��塞 ��� �� �ࠢ�筨�� ����ﭭ�� �����⥫�� */
   client-recepient-search:
   FOR EACH client-recepient
       BREAK BY client-recepient.cust-cat BY client-recepient.cust-id
      :
      IF FIRST-OF(client-recepient.cust-id) THEN DO:
         oValue = BenXattrVal(client-recepient.cust-cat, client-recepient.cust-id, iBIC, iAcct, "���").
         IF oValue NE ? THEN
            LEAVE client-recepient-search.
         ELSE
            oValue = "".
      END.
   END.
END PROCEDURE.

PROCEDURE getKPP:
/* ��⮬���᪮� ��।������ ��� ���⥫�騪�/�����⥫� �� ���㬥�� */
   DEFINE INPUT  PARAMETER iOpRowID   AS ROWID NO-UNDO.
   DEFINE INPUT  PARAMETER iRequisite AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oKPP       AS CHARACTER NO-UNDO.

   DEFINE VARIABLE mFlagGo     AS INT64   NO-UNDO.
   DEFINE VARIABLE mMbrMask    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE mDbIsMbr    AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE mCrIsMbr    AS LOGICAL   NO-UNDO.

   mMbrMask = fGetSetting("�����猁�", ?, "�����").

   FOR FIRST op WHERE ROWID(op) EQ iOpRowID NO-LOCK:
      FOR FIRST op-entry OF op NO-LOCK:
         /* ��।��塞 ⨯ ���㬥�� */
         mDbIsMbr = CAN-FIND(FIRST acct
                             WHERE acct.acct EQ op-entry.acct-db
&IF DEFINED(oracle) NE 0 &THEN
                               AND op-entry.currency BEGINS op-entry.currency
&ENDIF
                               AND CAN-DO(mMbrMask, acct.contract) NO-LOCK).
         mCrIsMbr = CAN-FIND(FIRST acct
                             WHERE acct.acct EQ op-entry.acct-cr
&IF DEFINED(oracle) NE 0 &THEN
                               AND op-entry.currency BEGINS op-entry.currency
&ENDIF
                               AND CAN-DO(mMbrMask, acct.contract) NO-LOCK).

         mFlagGo =
            IF NOT mDbIsMbr AND mCrIsMbr THEN
               1 /* ��砫�� */
            ELSE IF mDbIsMbr AND NOT mCrIsMbr THEN
               2 /* �⢥�� */
            ELSE IF NOT mDbIsMbr AND NOT mCrIsMbr THEN
               0 /* ����७��� */
            ELSE
               3 /* �࠭���� */
         .

         FOR FIRST op-bank OF op NO-LOCK:
         END.

         CASE mFlagGo:
            WHEN 0 THEN /* ����७��� */
               IF iRequisite EQ "kpp-rec" THEN DO:
                  RUN getKPPacct(iRequisite,
                                 op-entry.currency + "," + op-entry.acct-cr,
                                 OUTPUT oKPP
                  ).
               END.
               ELSE DO:
                  RUN getKPPacct(iRequisite,
                                 op-entry.currency + "," + op-entry.acct-db,
                                 OUTPUT oKPP
                  ).
               END.
            WHEN 1 THEN /* ��砫�� */
               IF iRequisite EQ "kpp-rec" THEN DO:
                  IF AVAILABLE op-bank THEN DO:
                     RUN getKPPben(op-bank.bank-code, op.ben-acct, op.inn, OUTPUT oKPP).
                  END.
               END.
               ELSE DO:
                  RUN getKPPacct(iRequisite,
                                 op-entry.currency + "," + op-entry.acct-db,
                                 OUTPUT oKPP
                  ).
               END.
            WHEN 2 THEN /* �⢥�� */
               IF iRequisite EQ "kpp-rec" THEN DO:
                  RUN getKPPacct(iRequisite,
                                 op-entry.currency + "," + op-entry.acct-cr,
                                 OUTPUT oKPP
                  ).
               END.
               ELSE IF AVAILABLE op-bank THEN DO.
                  RUN getKPPben(op-bank.bank-code, op.ben-acct, op.inn, OUTPUT oKPP).
               END.
         END CASE.
      END. /* FOR FIRST op-entry OF op NO-LOCK: */
   END. /* FOR FIRST op WHERE ROWID(op) EQ iOpRowID NO-LOCK: */
END PROCEDURE.

/******************************************************************************
 * �����頥� ��ப� �뤠� + ��� �뤠� ���㬥�� 䨧���
 ******************************************************************************/
FUNCTION fGetDocIssue RETURNS CHARACTER (
   INPUT iPersID AS INT64
):
   DEFINE VARIABLE vRetVal AS CHARACTER INIT "" NO-UNDO.
   FOR FIRST person WHERE person.person-id EQ iPersID NO-LOCK:
      vRetVal = TRIM(person.issue + " " +
                     GetXattrValueEx("person", STRING(person.person-id),
                                     "Document4Date_Vid",
                                     ""
                     )
                ).
   END.
   RETURN vRetVal.
END FUNCTION.

/* �����頥� ��ப� ��� �뤠� ���㬥��  (��� 䨧���) */
FUNCTION fGetDocIssueOrg RETURNS CHARACTER (INPUT iPersID AS INT64):
   DEFINE VARIABLE vRetVal AS CHARACTER INIT "" NO-UNDO.
   FOR FIRST person WHERE person.person-id EQ iPersID NO-LOCK:
      vRetVal = TRIM(person.issue).
   END.
   RETURN vRetVal.
END FUNCTION.

/* �����頥� ���� �뤠� ���㬥��  (��� 䨧���) */
FUNCTION fGetDocIssueDate RETURNS CHARACTER (INPUT iPersID AS INT64):
   DEFINE VARIABLE vRetVal AS CHARACTER INIT "" NO-UNDO.
   vRetVal = GetXattrValueEx("person", 
                             STRING(iPersId),
                             "Document4Date_Vid",
                             "").
   RETURN vRetVal.
END FUNCTION.

/* �����頥� ��� �뤠� ��� ���� ���ࠧ������� �� 㤮�⮢�७�� ��筮�� (��� 䨧���) */
FUNCTION fGetDocIssueClear RETURNS CHARACTER (INPUT iPersID AS INT64):
   DEFINE VARIABLE vRetVal AS CHARACTER INIT "" NO-UNDO.
   DEFINE BUFFER xperson     FOR person.
   DEFINE BUFFER xcust-ident FOR cust-ident.
   FIND FIRST xperson WHERE xperson.person-id = iPersId NO-LOCK NO-ERROR.
   IF AVAIL xperson THEN DO:
      FIND FIRST xcust-ident WHERE xcust-ident.cust-cat       = "�"
                               AND xcust-ident.cust-id        = xperson.person-id
                               AND xcust-ident.cust-code-type = xperson.document-id
                               AND xcust-ident.cust-code      = xperson.document
      NO-LOCK NO-ERROR.
      IF AVAIL xcust-ident THEN vRetVal = xcust-ident.issue.
   END.
   RETURN vRetVal.
END FUNCTION.

/* �����頥� ���� ���ࠧ������� �� 㤮�⮢�७�� ��筮�� (��� 䨧���) */
FUNCTION fGetDocIssueKP RETURNS CHARACTER (INPUT iPersID AS INT64):
   DEFINE VARIABLE vRetVal AS CHARACTER INIT "" NO-UNDO.
   DEFINE BUFFER xperson     FOR person.
   DEFINE BUFFER xcust-ident FOR cust-ident.
   FIND FIRST xperson WHERE xperson.person-id = iPersId NO-LOCK NO-ERROR.
   IF AVAIL xperson THEN DO:
      FIND FIRST xcust-ident WHERE xcust-ident.cust-cat       = "�"
                               AND xcust-ident.cust-id        = xperson.person-id
                               AND xcust-ident.cust-code-type = xperson.document-id
                               AND xcust-ident.cust-code      = xperson.document
      NO-LOCK NO-ERROR.
      IF AVAIL xcust-ident
      THEN vRetVal = GetXattrValueEx("cust-ident",
                                     GetSurrogateBuffer("cust-ident",(BUFFER xcust-ident:HANDLE)),
                                     "���ࠧ�",
                                     "").
   END.
   RETURN vRetVal.
END FUNCTION.

/* ����祭�� ��砫� ���. */
FUNCTION GetUnkBeg RETURNS CHARACTER:
   RETURN SUBSTR(GetThisUserOtdel(), 1, INT64(FGetSetting("���","��砫�","0"))).
END FUNCTION.

/* ����祭�� ������ ���. */
FUNCTION NewUnk RETURNS DECIMAL (iFile AS CHARACTER):
   DEFINE VARIABLE vUnk         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vUnkFormat   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vOtdel       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vUnkBeg      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vNextUnk     AS DECIMAL DECIMALS 0 INIT ? NO-UNDO.
   DEFINE VARIABLE vAlreadyOrd  AS INT64   NO-UNDO.
   DEFINE VARIABLE vAlreadySurr AS CHARACTER NO-UNDO.

   vUnkFormat = GetXAttrEx(iFile,"���","data-format").
   IF vUnkFormat EQ ? THEN
      RETURN ?.

   ASSIGN 
      vOtdel  = GetUserBranchId(USERID("bisquit"))
      vUnkBeg = GetUnkBeg()
   .

   IF AvailCode("Counters", "CNTUNK") <> YES THEN
   DO:
      vUnk = GetMaxSigns("banks,person,cust-corp",
                         "���",
                         vUnkBeg).
   
      vUnk = IF vUnk NE "" 
             THEN vUnk
             ELSE vUnkBeg + SUBSTR(STRING(0, vUnkFormat),
                                   LENGTH(vUnkBeg) + 1).

      IF LENGTH(vUnk) > LENGTH(vUnkFormat) THEN DO:
         MESSAGE "��ଠ� 㭨������ ����஢ �����⮢ (���) ��� �����" iFile
                 "��⠢���" STRING(LENGTH(vUnkFormat)) "ᨬ�����, ����������"
                 "�������� ᫥���饥 ���祭�� " vNextUnk
                 (IF LENGTH(vUnkBeg) > 0 THEN "� ��䨪ᮬ '" + vUnkBeg + "'" ELSE "") "!" SKIP
                 "������� � ������������!"
         VIEW-AS ALERT-BOX ERROR.
         RETURN ?.
      END.

      vUnk = STRING(DECIMAL(vUnk) + 1,vUnkFormat) NO-ERROR.
         
      IF NOT vUnk BEGINS vUnkBeg 
         OR ERROR-STATUS:ERROR THEN DO:
         MESSAGE "�����稫��� ����㯭� 㭨����� ����� �����⮢ (���)!" SKIP
                 "������� � ������������!"
         VIEW-AS ALERT-BOX ERROR.
         RETURN ?.
      END.
   END.
   ELSE
   DO:
      _sch_free_unk:
      REPEAT:
         vNextUnk = ?.
         vNextUnk = DECIMAL(SendData("COUNTER;CNTUNK_" + vUnkBeg + "_0,CNTUNK,NEXT,0", 5)) NO-ERROR.

         IF vNextUnk = ? OR ERROR-STATUS:ERROR THEN DO:
            MESSAGE "�����稫��� ����㯭� 㭨����� ����� �����⮢ (���)"
                    (IF LENGTH(vUnkBeg) > 0 THEN "� ��䨪ᮬ '" + vUnkBeg + "'" ELSE "") "!" SKIP
                    "������� � ������������!"
            VIEW-AS ALERT-BOX ERROR.
            RETURN ?.
         END.
         
         IF LENGTH(vUnkBeg) + LENGTH(STRING(vNextUnk)) > LENGTH(vUnkFormat) THEN DO:
            MESSAGE "��ଠ� 㭨������ ����஢ �����⮢ (���) ��� �����" iFile
                    "��⠢���" STRING(LENGTH(vUnkFormat)) "ᨬ�����, ����������"
                    "�������� ᫥���饥 ���祭�� " vNextUnk
                    (IF LENGTH(vUnkBeg) > 0 THEN "� ��䨪ᮬ '" + vUnkBeg + "'" ELSE "") "!" SKIP
                    "������� � ������������!"
            VIEW-AS ALERT-BOX ERROR.
            RETURN ?.
         END.
         
         vUnk = STRING(vNextUnk, vUnkFormat).

         IF LENGTH(vUnkBeg) > 0 THEN
            vUnk = vUnkBeg + SUBSTR(vUnk, LENGTH(vUnkBeg) + 1) NO-ERROR.

         RUN FindSignsByVal IN h_xclass ("person,cust-corp,banks",
                                         "���",
                                         vUnk,
                                         OUTPUT vAlreadyOrd,
                                         OUTPUT vAlreadySurr).
         IF vAlreadyOrd <> 0
         THEN NEXT _sch_free_unk.

         LEAVE _sch_free_unk.
      END.
   END.
   RETURN DECIMAL(vUnk).
END FUNCTION.

/*�������� ������ ���*/
FUNCTION new-unk RETURNS CHARACTER (ipFileName  AS CHARACTER, /*��� �����*/
                                    ipSurrogate AS CHARACTER  /*�������� �����䨪���*/):
   DEFINE VARIABLE flag-unk   AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vUnk       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vUnkFormat AS CHARACTER NO-UNDO.

   {getflagunk.i &class-code="ipFileName" &flag-unk="flag-unk"}
   IF NOT flag-unk THEN RETURN ?.

   vUnkFormat = GetXAttrEx(ipFileName,"���","data-format").
   IF vUnkFormat EQ ? THEN
      RETURN ?.

   vUnk = STRING(NewUnk(ipFileName), vUnkFormat).
   IF vUnk <> ? THEN DO:
      IF NOT UpdateSigns(ipFileName, ipSurrogate, "���", vUnk, ?)
      THEN vUnk = ?.
   END.

   RETURN vUnk.
END FUNCTION.

/* �㭪�� �����頥� ��� ������. */
FUNCTION GetUnk RETURNS CHAR (INPUT ipCustCatChar AS CHAR,   /* ��� ������. */
                              INPUT ipCustIdInt   AS INT64 /* ����� ������. */ ):

   RETURN IF ipCustCatChar EQ "�"
          THEN ""
          ELSE getXAttrValue((IF ipCustCatChar EQ "�"
                              THEN "cust-corp"
                              ELSE IF ipCustCatChar EQ "�"
                                   THEN "person"
                                   ELSE "banks"),
                              STRING(ipCustIdInt),
                              "���").

END FUNCTION.

/* ����祭�� ���� ������, �� ������⢨� - ������� */
FUNCTION UNKg RETURN CHAR (INPUT infile AS CHAR,
                           INPUT insurr AS CHAR):
   DEFINE VARIABLE vUnkg AS CHARACTER NO-UNDO.
   RUN GetClientUNKg (infile, insurr, NO, OUTPUT vUnkg).
   RETURN vUnkg.
END FUNCTION.

/* ����祭�� ������ ����� ����. */
PROCEDURE GetNewUnkgNumber:
   DEFINE INPUT  PARAMETER iFile   AS CHARACTER NO-UNDO.        /* banks/cust-corp/person */
   DEFINE INPUT  PARAMETER iSilent AS LOGICAL   NO-UNDO.        /* YES - �� �뢮���� ᮮ�饭��, �������� �訡�� � RETURN-VALUE */
   DEFINE OUTPUT PARAMETER oUnkg   AS INT64   NO-UNDO INIT ?. /* ���� ��� */
   
   DEFINE VARIABLE vRetVal AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vUnkg   AS CHARACTER NO-UNDO.

   /* �஢�ઠ �� ࠧ�襭�� �����樨 ���� */
   IF FGetSetting("���", "�������", "���") <> "���" THEN DO:

      IF AvailCode("Counters", "CNTUNKg") <> YES THEN DO:
         /* ��� ���稪� */
         vUnkg = GetMaxSigns("banks,person,cust-corp", "����", "").
         vUnkg = STRING(DECIMAL(vUnkg) + 1,{&UNKg-Format}) NO-ERROR.
      END.
      ELSE vUnkg = STRING(GetCounterNextValue("CNTUNKg",?),{&UNKg-Format}) NO-ERROR.
      
      IF NOT {assigned vUnkg}
      OR ERROR-STATUS:ERROR
      OR ERROR-STATUS:GET-MESSAGE(1) GT "" THEN DO:
         /* �訡�� �����樨 */
         vRetVal = "�����稫��� ����㯭� ����! ������� � ������������!".
         IF iSilent = NO THEN MESSAGE vRetVal VIEW-AS ALERT-BOX ERROR.
      END.
      ELSE oUnkg = INT64(vUnkg).

   END.

   RETURN vRetVal.
END PROCEDURE.

/* ����祭�� ���� ������, �� ������⢨� - ������� */
PROCEDURE GetClientUNKg:
   DEFINE INPUT  PARAMETER iFile   AS CHARACTER NO-UNDO.        /* banks/cust-corp/person */
   DEFINE INPUT  PARAMETER iSurr   AS CHARACTER NO-UNDO.        /* ���ண�� */
   DEFINE INPUT  PARAMETER iSilent AS LOGICAL   NO-UNDO.        /* YES - �� �뢮���� ᮮ�饭��, �������� �訡�� � RETURN-VALUE */
   DEFINE OUTPUT PARAMETER oUNKg   AS CHARACTER NO-UNDO INIT ?. /* ��� */

   DEFINE VARIABLE vRetVal  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vUnkg    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vNewUnkg AS INT64   NO-UNDO.
   
   /* �஢�ઠ �� ࠧ�襭�� �����樨 ���� */
   IF FGetSetting("���", "�������", "���") <> "���" THEN DO:

      /* �஢�ઠ �� ����⢮����� */
      vUnkg = GetXAttrValueEx(iFile,iSurr,"����",?).
      IF {assigned vUNKg}
      THEN oUNKg = vUnkg.
      ELSE DO:
         /* ������� ������ ����� */
         RUN GetNewUnkgNumber (iFile, iSilent, OUTPUT vNewUnkg).
         vRetVal = RETURN-VALUE.
         IF vNewUnkg <> ? THEN DO:
            /* ���� ����� ᣥ���஢�� ��୮ */
            vUNKg = STRING(vNewUnkg, {&UNKg-Format}).
            IF vUNKg <> ? THEN DO:
               IF UpdateSigns(iFile, iSurr, "����", vUNKg, ?)
               THEN oUNKg   = vUNKg.
               ELSE vRetVal = "���������� ᮧ���� ����=""" + oUNKg + """ ��� " + iFile.
            END.
         END.
      END.

   END.

   RETURN vRetVal.
END PROCEDURE.

/* ��⮤ �஢�ન ���祭�� ४����� ���. */
PROCEDURE ChkUpdUnk$.
   DEF INPUT  PARAM iClassCode AS CHAR   NO-UNDO. /* ����� ��ꥪ�. */
   DEF INPUT  PARAM iSurrogate AS CHAR   NO-UNDO. /* ���ண�� ��ꥪ�. */
   DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* ���祭�� ��ꥪ�. */
   DEFINE VAR vFlagUnk AS LOGICAL NO-UNDO.
   DEFINE VAR vError   AS LOGICAL NO-UNDO.
   DEFINE VAR vRetVal  AS CHAR    NO-UNDO.
   
   {getflagunk.i &class-code="iClassCode" &flag-unk="vFlagUnk"}
   IF vFlagUnk THEN DO:
      RUN ChkUpdNumCode(iClassCode,
                        iSurrogate,
                        "���",     
                        iValue) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN ASSIGN
         vError  = YES
         vRetVal = RETURN-VALUE
      .
   END.

   IF vError
   THEN RETURN ERROR vRetVal.
   ELSE RETURN vRetVal.
END PROCEDURE.

/* ��⮤ �஢�ન ���祭�� ४����� ����. */
PROCEDURE ChkUpdUnkg$.
   DEF INPUT  PARAM iClassCode AS CHAR   NO-UNDO. /* ����� ��ꥪ�. */
   DEF INPUT  PARAM iSurrogate AS CHAR   NO-UNDO. /* ���ண�� ��ꥪ�. */
   DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* ���祭�� ��ꥪ�. */
   
   DEF VAR vMsg AS CHAR   NO-UNDO. /* ����饭�� �� �訡��. */
   DEF VAR vUnk AS CHAR   NO-UNDO. /* ���祭�� ��. */

   DEFINE VARIABLE vFile AS INT64   NO-UNDO.
   DEFINE VARIABLE vSurr AS CHARACTER NO-UNDO.

   IF LENGTH (TRIM (iValue)) GT 9 /* ���⪠� ��訢�� */
      THEN vMsg = "������ ����� ����.".
   ELSE DO:
      vUnk = GetXattrValueEx (iClassCode, iSurrogate, '����', ?).
      IF vUnk NE iValue
      THEN DO:
         RUN FindSignsByVal IN h_xclass ("banks,person,cust-corp",
                                         '����',
                                         iValue,
                                         OUTPUT vFile,
                                         OUTPUT vSurr).
         IF     vFile GT 0 
            AND (   ENTRY(vFile,"banks,person,cust-corp") NE iClassCode
                 OR vSurr NE iSurrogate )
            THEN vMsg = "��� ���� ⠪�� ����.".
      END.
   END.
   IF vMsg NE ""
      THEN RETURN ERROR vMsg.
   
END PROCEDURE.

PROCEDURE ChkUpdNumCode PRIVATE.
   DEF INPUT  PARAM iClassCode AS CHAR   NO-UNDO. /* ����� ��ꥪ�. */
   DEF INPUT  PARAM iSurrogate AS CHAR   NO-UNDO. /* ���ண�� ��ꥪ�. */
   DEF INPUT  PARAM iCode      AS CHAR   NO-UNDO. /* ���ண�� ��ꥪ�. */
   DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* ���祭�� ��ꥪ�. */

   DEF VAR vMsg AS CHAR   NO-UNDO. /* ����饭�� �� �訡��. */
   DEF VAR vUnk AS CHAR   NO-UNDO. /* ���祭�� ��. */

   DEFINE VARIABLE vFile AS INT64   NO-UNDO.
   DEFINE VARIABLE vSurr AS CHARACTER NO-UNDO.

                           /* ���� ���ᠭ�� ��. */
   FIND FIRST xattr WHERE
              xattr.class-code EQ iClassCode
          AND xattr.xattr-code EQ iCode
   NO-LOCK.
   IF LENGTH (STRING ("0",xattr.data-format)) NE LENGTH (TRIM (iValue))
      THEN vMsg = "������ ����� " + iCode + ".".
   ELSE DO:
      vUnk = GetXattrValueEx (iClassCode, iSurrogate, iCode, ?).
      IF vUnk NE iValue
      THEN DO:
         RUN FindSignsByVal IN h_xclass ("banks,person,cust-corp",
                                         iCode,
                                         iValue,
                                         OUTPUT vFile,
                                         OUTPUT vSurr).
         IF     vFile GT 0 
            AND (   ENTRY(vFile,"banks,person,cust-corp") NE iClassCode
                 OR vSurr NE iSurrogate )
            THEN vMsg = "��� ���� ⠪�� " + iCode + ".".
      END.
   END.
   IF vMsg NE ""
      THEN RETURN ERROR vMsg.
   RETURN.
END PROCEDURE.


/* ��⮤ �஢�ન ���祭�� ४����� Date-out. */
PROCEDURE ChkUpdDate-out.
   DEF INPUT  PARAM iClassCode AS CHAR   NO-UNDO. /* ����� ��ꥪ�. */
   DEF INPUT  PARAM iSurrogare AS CHAR   NO-UNDO. /* ���ண�� ��ꥪ�. */
   DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* ���祭�� ��ꥪ�. */

   DEF BUFFER acct FOR acct. /* ���������� ����. */
   DEF BUFFER loan FOR loan. /* ���������� ����. */

   DEF VAR vCustCat  AS CHAR   NO-UNDO. /* ��� ������. */
   DEF VAR vDate     AS DATE   NO-UNDO. /* ���祭�� ����. */
   DEF VAR vErrMsg   AS CHAR   NO-UNDO. /* ����饭�� �� �訡��. */
   
   vDate = DATE (iValue) NO-ERROR.
   IF ERROR-STATUS:ERROR
   THEN vErrMsg = ERROR-STATUS:GET-MESSAGE (1).
   ELSE DO:
      /* �᫨ ��� �� ��⠭������ � �஢�ન �� �ॡ����� */
      IF vDate EQ ? THEN
         RETURN.
      CASE iClassCode:
         WHEN "person"     THEN vCustCat = "�".
         WHEN "cust-corp"  THEN vCustCat = "�".
         WHEN "banks"      THEN vCustCat = "�".
      END CASE.

      FOR FIRST acct WHERE
               acct.cust-cat     EQ vCustCat
         AND   acct.cust-id      EQ INT64 (iSurrogare)
         AND  (acct.close-date   EQ ?
            OR acct.close-date   GT vDate)
      NO-LOCK:
         vErrMsg = "� ������ ���� ������ ��� '" + acct.acct     + 
                                      "' � ����� '" + acct.currency + "'.".
      END.
      IF vErrMsg EQ ""
      THEN FOR FIRST loan WHERE
               loan.cust-cat     EQ vCustCat
         AND   loan.cust-id      EQ INT64 (iSurrogare)
         AND  (loan.close-date   EQ ?
            OR loan.close-date   GT vDate)
        AND    loan.Class-Code   EQ 'bankrupt'
      NO-LOCK:
         FIND FIRST class WHERE class.Class-Code EQ loan.Class-Code NO-LOCK.
         vErrMsg = "� ������ ���� ������ �������� '" 
                 + (IF CAN-DO("���,sf-in,sf-out",loan.contract)
                    THEN loan.doc-num
                    ELSE loan.cont-code) 
                 + "' � ����ᮬ '" + class.Name  
                 + "("             + loan.Class-Code 
                 + ")'.".
      END.
   END.
   IF vErrMsg NE ""
      THEN RETURN ERROR vErrMsg.
   RETURN.
END PROCEDURE.

/* �����頥� ���祭�� ��� ����. */
FUNCTION GetAdrStr RETURNS CHAR (
   INPUT vAdrChar    AS CHAR,    /* ᨬ���쭠� ��ப� */
   INPUT iFieldChar  AS CHAR     /* ������������ ��� ���� */ 
):
   DEF VAR vEntryInt AS INT64  NO-UNDO.  /* ���-�� ��⥩ � ���� */
   DEF VAR vRetChar  AS CHAR NO-UNDO.  /* ࠡ. ��६. - �����頥��� ���祭�� */
   vRetChar = "".
   
   vEntryInt = NUM-ENTRIES (vAdrChar).
   IF iFieldChar EQ "������"   AND vEntryInt >= 1  THEN vRetChar = ENTRY (1, vAdrChar).
   IF iFieldChar EQ "ࠩ��"    AND vEntryInt >= 2  THEN vRetChar = ENTRY (2, vAdrChar).
   IF iFieldChar EQ "��த"    AND vEntryInt >= 3  THEN vRetChar = ENTRY (3, vAdrChar).
   IF iFieldChar EQ "�㭪�"    AND vEntryInt >= 4  THEN vRetChar = ENTRY (4, vAdrChar).
   IF iFieldChar EQ "㫨�"    AND vEntryInt >= 5  THEN vRetChar = ENTRY (5, vAdrChar).
   IF iFieldChar EQ "���"      AND vEntryInt >= 6  THEN vRetChar = ENTRY (6, vAdrChar).
   IF iFieldChar EQ "�����"   AND vEntryInt >= 7  THEN vRetChar = ENTRY (7, vAdrChar).
   IF iFieldChar EQ "������" AND vEntryInt >= 8  THEN vRetChar = ENTRY (8, vAdrChar).
   IF iFieldChar EQ "��஥���" AND vEntryInt >= 9  THEN vRetChar = ENTRY (9, vAdrChar).
   RETURN vRetChar.
END FUNCTION.

/* �८�ࠧ������ �ଠ�஢����� ��ப� ����   */
FUNCTION fGetStrAdr RETURNS CHAR (INPUT ipAdrChar AS CHAR):
   DEF VAR opAdrChar AS CHAR NO-UNDO.

   IF    NUM-ENTRIES(ipAdrChar) EQ 9
      OR NUM-ENTRIES(ipAdrChar) EQ 8 
   THEN
      opAdrChar = /* ������ */
                 (IF ENTRY(1, ipAdrChar) EQ "000000"
                  THEN ""
                  ELSE ENTRY(1, ipAdrChar) + ", ") +
                 /* ࠩ�� */
                 ENTRY(2, ipAdrChar) + (IF ENTRY(2, ipAdrChar) EQ "" THEN "" ELSE ", ") +
                 /* ��த */
                 ENTRY(3, ipAdrChar) + (IF ENTRY(3, ipAdrChar) EQ "" THEN "" ELSE ", ") +
                 /* ��ᥫ���� �㭪� */
                 ENTRY(4, ipAdrChar) + (IF ENTRY(4, ipAdrChar) EQ "" THEN "" ELSE ", ") +
                 /* 㫨� */
                 ENTRY(5, ipAdrChar) + (IF ENTRY(5, ipAdrChar) EQ "" THEN "" ELSE ", ") +
                 /* ��� */
                 (IF INDEX(ENTRY(6, ipAdrChar), "�") NE 0 OR ENTRY(6, ipAdrChar) EQ ""
                  THEN ""
                  ELSE "�.") +
                 ENTRY(6, ipAdrChar) + (IF ENTRY(6, ipAdrChar) EQ "" THEN "" ELSE ", ") +
                 /* ��஥��� */
                 (IF NUM-ENTRIES(ipAdrChar) EQ 9
                 THEN ((IF INDEX(ENTRY(9, ipAdrChar), "���") NE 0 OR ENTRY(9, ipAdrChar) EQ ""
                        THEN ""
                        ELSE "���.") +
                        TRIM(ENTRY(9, ipAdrChar)) + (IF ENTRY(9, ipAdrChar) EQ "" THEN "" ELSE ", "))
                 ELSE "" ) +
                 /* ����� */
                 (IF INDEX(ENTRY(7, ipAdrChar), "�") NE 0 OR ENTRY(7, ipAdrChar) EQ ""
                  THEN ""
                  ELSE "�.") +
                 ENTRY(7, ipAdrChar) + (IF ENTRY(7, ipAdrChar) EQ "" THEN "" ELSE ", ") +
                 /* ������ */
                 (IF INDEX(ENTRY(8, ipAdrChar), "�") NE 0 OR ENTRY(8, ipAdrChar) EQ ""
                  THEN ""
                  ELSE "��.") +
                 ENTRY(8, ipAdrChar)
      .
   ELSE
      opAdrChar = ipAdrChar.
   RETURN IF opAdrChar EQ ? THEN "?" ELSE opAdrChar.
END FUNCTION.

/* ��⠭�������� ���祭�� ஫� ��ꥪ� "������" / "���". */
PROCEDURE SetClientRole.
   DEF INPUT  PARAM iHBuffer  AS HANDLE NO-UNDO.   /* �����⥫� �� ��ꥪ�. */
   DEF INPUT  PARAM iCustCat  AS CHAR   NO-UNDO.   /* ��� ������. */
   DEF INPUT  PARAM iClient   AS LOG    NO-UNDO.   /* ������ / �� ������. */

   DEF BUFFER cust-role FOR cust-role. /* ���������� ����. */

   DEF VAR vClassSrc AS CHAR   NO-UNDO. /* ����� ��� ���᪠. */
   DEF VAR vClassCr  AS CHAR   NO-UNDO. /* ����� ��� ᮧ�����. */
   DEF VAR vCustId   AS INT64    NO-UNDO. /* ��� ������. */
   DEF VAR vFileName AS CHAR   NO-UNDO. /* ������ �易����� ��ꥪ�. */
   DEF VAR vSurr     AS CHAR   NO-UNDO. /* ID �易����� ��ꥪ�. */
   DEF VAR vH        AS HANDLE NO-UNDO. /* �����⥫� �� ���� *-id. */
                        /* ��।���� ⨯ ������ �� ���� *-id. */
   CASE iCustCat:
      WHEN "�"
      THEN ASSIGN
         vFileName   = "person"
         vH          = iHBuffer:BUFFER-FIELD ("person-id")
      NO-ERROR.
      WHEN "�"
      THEN ASSIGN
         vFileName   = "cust-corp"
         vH          = iHBuffer:BUFFER-FIELD ("cust-id")
      NO-ERROR.
      WHEN "�"
      THEN ASSIGN
         vFileName   = "banks"
         vH          = iHBuffer:BUFFER-FIELD ("bank-id")
      NO-ERROR.
   END CASE.
                        /* ��।�� 㪠��⥫� �� �� ��ꥪ�. */
   IF NOT VALID-HANDLE (vH)
      THEN RETURN ERROR.
   ASSIGN
      vClassSrc   = IF iClient   THEN {&NoBankClient} ELSE {&BankClient}
      vClassCr    = IF iClient   THEN {&BankClient}   ELSE {&NoBankClient}
      vCustId     = vH:BUFFER-VALUE
      vSurr       = STRING (vCustId)
      vFileName   = "branch"
      vSurr       = ShFilial
   .
                        /* ���� ஫�, ������ ����室��� ᮧ����. */
   FIND FIRST cust-role WHERE
            cust-role.cust-cat   EQ iCustCat
      AND   cust-role.cust-id    EQ STRING (vCustId)
      AND   cust-role.Class-Code EQ vClassCr
      AND   cust-role.file-name  EQ vFileName
      AND   cust-role.surrogate  EQ vSurr USE-INDEX cust-id
   NO-LOCK NO-ERROR.
                        /* �᫨ ஫� ���, � ᮧ����. */
   IF NOT AVAIL cust-role THEN
   DO
   ON ERROR  UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE:
                        /* ����塞 �� ���� ஫�. */
      FOR EACH cust-role WHERE
               cust-role.cust-cat   EQ iCustCat
         AND   cust-role.cust-id    EQ STRING (vCustId)
         AND   cust-role.Class-Code EQ vClassSrc
         AND   cust-role.file-name  EQ vFileName
         AND   cust-role.surrogate  EQ vSurr
      EXCLUSIVE-LOCK:
         DELETE cust-role.
      END.
                        /* ������� ஫�. */
      CREATE cust-role.
      ASSIGN
         cust-role.cust-cat   =  iCustCat
         cust-role.cust-id    =  STRING (vCustId)
         cust-role.class-code =  vClassCr
         cust-role.file-name  =  vFileName
         cust-role.surrogate  =  vSurr
      .
      RELEASE cust-role.
   END.
   RETURN.
END PROCEDURE.

/* �뤠�� ᯨ᮪ ��易⥫��� ��� ���������� ���ਡ�⮢
** � ����ᨬ��� �� ����� ஫�� ��ꥪ�.*/
PROCEDURE GetFieldManListByRole:
   DEFINE INPUT  PARAMETER iFileName AS CHAR   NO-UNDO. /* �������� ⠡���� */
   DEFINE INPUT  PARAMETER iSurrogate AS CHAR  NO-UNDO. /* ���ண�� */
   
   DEFINE OUTPUT PARAMETER oList     AS CHAR   NO-UNDO. /* ���᮪ ����� */

   DEFINE VAR vCustCat    AS CHAR    NO-UNDO INIT "�".
   DEFINE VAR vImaginRole AS CHAR    NO-UNDO. /* ���᮪ ��⥭樠���� ஫��. */
   DEFINE VAR vClass      AS CHAR    NO-UNDO. /* ���᮪ ����ᮢ - ஫�� ���짮��⥫�. */
   DEFINE VAR vManFields  AS CHAR    NO-UNDO.
   DEFINE VAR vCnt        AS INT64 NO-UNDO. /* ���稪. */
   DEFINE BUFFER xcust-role FOR cust-role. /* ���������� ����. */

   ASSIGN
      vCustCat    = ENTRY(LOOKUP(iFileName,"cust-corp,person,banks"),"�,�,�")
      vImaginRole = GetXclassAllChilds ("ImaginRole")
   .
   /* ����ࠥ� ��⥭樠��� ������ ஫�� �� ���짮��⥫�. */
   FOR EACH xcust-role WHERE
            xcust-role.cust-cat   EQ vCustCat
      AND   xcust-role.cust-id    EQ iSurrogate
      AND   CAN-DO (vImaginRole, xcust-role.class-code)
   NO-LOCK:
      {additem.i vClass xcust-role.class-code}
   END.
   /* ����ࠥ� ��易⥫�� ��� ���������� ����. */
   DO vCnt = 1 TO NUM-ENTRIES(vClass):
      vManFields = "".
      vManFields = GetXAttrEx(ENTRY(vCnt,vClass),"��紐���","Initial").
      {additem.i oList vManFields}
   END.

   RETURN.
END PROCEDURE.

/* �뤠�� ������������� ���� ��易⥫쭮�
** � ����ᨬ��� �� ����� ஫�� ��ꥪ�.*/
PROCEDURE GetFirstUnassignedFieldManByRole:
   DEFINE INPUT  PARAMETER iFileName     AS CHAR                   NO-UNDO. /* �������� ⠡���� */
   DEFINE INPUT  PARAMETER iHBuffer      AS HANDLE                 NO-UNDO. /* �����⥫� �� ������. */
   DEFINE INPUT  PARAMETER iMain         AS CHAR                   NO-UNDO.  /* 㪠��⥫� �� �஢��� �᭮����/��� ४����⮢ 
                                                                                "main" - ⮫쪮 �᭮��� ४������  
                                                                                "dp" - ⮫쪮 ��� ४������ 
                                                                                "all" - �� ४������ */   
   DEFINE OUTPUT PARAMETER oXAttrCode    LIKE xattr.xattr-code     NO-UNDO. /* ��� ���ਡ�� */
   DEFINE OUTPUT PARAMETER oXAttrName    LIKE xattr.name           NO-UNDO. /* ������������ ���ਡ�� */

   DEFINE VAR vFieldMan  AS CHAR    NO-UNDO. /* ���᮪ ��易⥫��� �����. */
   DEFINE VAR vSurrogate AS CHAR    NO-UNDO.
   DEFINE VAR vCnt       AS INT64 NO-UNDO. /* ���稪. */
   DEFINE VAR vErr       AS LOGICAL NO-UNDO. /* ���� �訡��. */
   DEFINE VAR vClXttr    AS CHAR    NO-UNDO. /* ����� ��।���� �஢��塞��� ४����� */
   DEFINE VAR vCdXttr    AS CHAR    NO-UNDO. /* ��� ��।���� �஢��塞��� ४����� */
   DEFINE BUFFER xxattr FOR xattr. /* ���������� ����. */

   ASSIGN
      oXAttrCode = ""
      oXAttrName = ""
   .
   vSurrogate  = GetSurrogateBuffer(iFileName,iHBuffer).
   RUN GetFieldManListByRole (iFileName, vSurrogate, OUTPUT vFieldMan).
   IF NOT {assigned vFieldMan}
      THEN RETURN.

   /* ��ॡ�ࠥ� ��易⥫�� ४������ ��ꥪ�. */
   _check_fields:
   DO vCnt = 1 TO NUM-ENTRIES(vFieldMan):
      vClXttr = IF NUM-ENTRIES(ENTRY(vCnt, vFieldMan),".") > 1
                THEN ENTRY(1,ENTRY(vCnt, vFieldMan),".")
                ELSE iFileName.
      vCdXttr = IF NUM-ENTRIES(ENTRY(vCnt, vFieldMan),".") > 1
                THEN ENTRY(2,ENTRY(vCnt, vFieldMan),".")
                ELSE ENTRY(1,ENTRY(vCnt, vFieldMan),".").
      IF vClXttr NE iFileName
         THEN NEXT.

      FIND FIRST xxattr WHERE xxattr.class-code = vClXttr
                          AND xxattr.xattr-code = vCdXttr
      NO-LOCK NO-ERROR.
      IF AVAIL xxattr THEN DO:

         /* ��� �᭮���� ४����⮢ ⠡����. */          
         IF iMain EQ "main" OR iMain EQ "all" THEN DO:
            IF xxattr.Progress-Field THEN DO:
               CASE xxattr.DATA-TYPE:
                  WHEN "INTEGER"    THEN vErr = (0  = iHBuffer:BUFFER-FIELD (xxattr.xattr-code):BUFFER-VALUE).
                  WHEN "DATE"       THEN vErr = (?  = iHBuffer:BUFFER-FIELD (xxattr.xattr-code):BUFFER-VALUE).
                  WHEN "LOGICAL"    THEN vErr = (?  = iHBuffer:BUFFER-FIELD (xxattr.xattr-code):BUFFER-VALUE).
                  WHEN "CHARACTER"  THEN vErr = ("" = iHBuffer:BUFFER-FIELD (xxattr.xattr-code):BUFFER-VALUE).
                  WHEN "DECIMAL"    THEN vErr = (0  = iHBuffer:BUFFER-FIELD (xxattr.xattr-code):BUFFER-VALUE).
               END CASE.
               IF vErr THEN DO:
                  ASSIGN
                     oXAttrCode = xxattr.xattr-code
                     oXAttrName = xxattr.name
                  .
                  LEAVE _check_fields.
               END.
            END.             
         END.
         /* ��� �������⥫��� ४����⮢ ⠡����. */
         IF iMain EQ "dp" OR iMain EQ "all" THEN DO:
            IF NOT xxattr.Progress-Field THEN DO:
               IF GetXAttrValueEx (iFileName, vSurrogate, xxattr.xattr-code, ?) = ?
               THEN DO:
                  ASSIGN
                     oXAttrCode = xxattr.xattr-code
                     oXAttrName = xxattr.name
                  .
                  LEAVE _check_fields.
               END.                 
            END.              
         END.

      END.
   END.

   RETURN.
END PROCEDURE.

/* �஢���� ��易⥫쭮��� ���������� �����
** � ����ᨬ��� �� ����� ஫�� ��ꥪ�.*/
PROCEDURE ChkFieldManByRole.
   DEFINE INPUT PARAMETER iFileName AS CHAR   NO-UNDO. /* �������� ⠡���� */
   DEFINE INPUT PARAMETER iHBuffer  AS HANDLE NO-UNDO. /* �����⥫� �� ������. */
   DEFINE VAR vXattrCode    LIKE xattr.xattr-code NO-UNDO.
   DEFINE VAR vXattrName    LIKE xattr.name NO-UNDO.
   DEFINE VAR vIsProgrField LIKE xattr.Progress-Field NO-UNDO.

   RUN GetFirstUnassignedFieldManByRole (iFileName, iHBuffer, "all", OUTPUT vXattrCode, OUTPUT vXattrName).
   IF {assigned vXattrCode} THEN DO:
      RUN Fill-SysMes IN h_tmess ("", "", "0",
         "�� �������� ��易⥫�� ४����� """ + vXattrCode +
         """ (" + vXattrName + ")."
         ).
      RETURN ERROR.
   END.
   RETURN.
END PROCEDURE.

/* �᫨ ������ ����� �ᥣ� ���� 㤮�⮢�७�� ��筮�� - �����頥��� ��� ��� 
   (�������筮 �����頥���� ���祭�� � ��㧥� ���㬥�⮢)
   
   �᫨ 㤮�⮢�७�� ����� ������ - �����頥��� ?.
   �᫨ 㤮�⮢�७�� ��� �� �᭮�� - ����� ��ப� */
FUNCTION GetSingleDoc RETURNS CHARACTER
  (INPUT          in-cat   AS CHAR,
   INPUT          in-id    AS CHAR ):
  
  DEFINE BUFFER b-cust-ident FOR cust-ident.

  /* FIND ��� ����䨪��� ��ࠢ��� */
  FIND b-cust-ident WHERE b-cust-ident.cust-cat  = in-cat 
                      AND b-cust-ident.cust-id   = INT64(in-id)
                    NO-LOCK NO-ERROR.
  IF AVAILABLE b-cust-ident THEN DO:
    RETURN b-cust-ident.cust-code-type        + "," + 
           b-cust-ident.cust-code             + "," + 
           STRING(b-cust-ident.cust-type-num) + "~001" + 
           b-cust-ident.cust-cat              + "~001" + 
           STRING(b-cust-ident.cust-id).
  END. 
  
  IF AMBIGUOUS b-cust-ident THEN RETURN ?.
  RETURN "".
END FUNCTION. 

/* �������⥫쭠� �஢�ઠ ����� ���� 
   �室�騥 ��ࠬ����: ��� ॣ���� ���
                       ��� ������
                       ��� ��த�
                       ��� ��ᥫ������ �㭪�
                       ��� 㫨��
                        
   �����頥�:         ���� ����*/
FUNCTION fChkDopGni RETURNS CHARACTER (
   INPUT iRegGniChar    AS CHARACTER,
   INPUT iCodeOblChar   AS CHARACTER,
   INPUT iCodeGorChar   AS CHARACTER,
   INPUT iCodePunktChar AS CHARACTER,
   INPUT iCodeUlChar    AS CHARACTER  ):

   IF iCodeOblChar <> "" AND
      iRegGniChar  <> "" AND
      iCodeOblChar BEGINS iRegGniChar
   THEN.
   ELSE iCodeOblChar   = "".

   IF iCodeGorChar <> "" AND
      iRegGniChar  <> "" AND
      iCodeGorChar BEGINS (IF iCodeOblChar <> ""
                           THEN SUBSTR(iCodeOblChar,1,5)
                           ELSE iRegGniChar)
   THEN .
   ELSE iCodeGorChar   = "".

   IF iCodePunktChar <> "" AND
      iRegGniChar    <> "" AND
      iCodePunktChar BEGINS (IF iCodeOblChar <> ""
                              THEN SUBSTR(iCodeOblChar,1,5)
                              ELSE iRegGniChar)
   THEN .
   ELSE iCodePunktChar   = "".

   IF iCodeUlChar <> "" AND
      iRegGniChar <> "" AND
    ((IF iCodePunktChar <> "" THEN iCodeUlChar BEGINS SUBSTRING(iCodePunktChar,1,11) ELSE NO) OR
     (IF iCodeGorChar   <> "" THEN iCodeUlChar BEGINS SUBSTRING(iCodeGorChar,1,11)   ELSE NO ))
   THEN .
   ELSE iCodeUlChar   = "".

   RETURN (IF iCodeOblChar  = "" AND
             iCodeGorChar   = "" AND
             iCodePunktChar = "" AND
             iCodeUlChar    = ""
         THEN ""
         ELSE (iCodeOblChar   + ","
             + iCodeGorChar   + ","
             + iCodePunktChar + ","
             + iCodeUlChar)).

END FUNCTION.

/* �஢�ઠ ����⢮����� � ��ꥪ� (�,�,�) ��⥭樠���� ஫�� (��⮬��� ����� ImaginRole)
** ������� ��� �஢�ન ��। 㤠������ ��ꥪ�, ���⮬� �� ����稨 ⠪�� ஫��
** ������ ����� "������� �� ��ꥪ�?" */
PROCEDURE CheckSubjectRole.
   DEF INPUT  PARAM iCustCat  AS CHAR          NO-UNDO.  /* ��⥣��� ��ꥪ� (�,�,�) */
   DEF INPUT  PARAM iCustId   AS INT64           NO-UNDO.  /* ����� ��ꥪ� */
   DEF OUTPUT PARAM oResult   AS LOG INIT YES  NO-UNDO.  /* १���� (YES-㤠����,NO-�� 㤠����) */

   DEF VAR vRoleList AS CHAR           NO-UNDO. /* ᯨ᮪ ��⥭樠���� ஫�� */
   DEF VAR vINN      AS CHAR           NO-UNDO. /* ��� */
   DEF VAR vi        AS INT64            NO-UNDO. /* ���稪 横�� */
   DEF VAR vName     AS CHAR EXTENT 2  NO-UNDO. /* ������������ ��ꥪ� */

   /* ᮡ�ࠥ� ᯨ᮪ ��⥭�. ஫�� - ��⮬��� ����� ImaginRole */
   vRoleList = GetXclassAllChildsEx("ImaginRole").
   /* ���� ��⥭樠���� ஫�� (ᯨ᮪ vRoleList) � ��ꥪ� */
   CYCLE:
   DO vi = 1 TO NUM-ENTRIES(vRoleList):
      FOR EACH cust-role WHERE cust-role.cust-cat   EQ iCustCat
                           AND cust-role.cust-id    EQ STRING(iCustId)
                           AND cust-role.Class-Code EQ ENTRY(vi,vRoleList)
      NO-LOCK:
         /* ��।����� ������������ ��ꥪ� */
         RUN GetCustName IN h_base(iCustCat,
                                   iCustID,
                                   ?,
                                   OUTPUT vName[1],
                                   OUTPUT vName[2],
                                   INPUT-OUTPUT vINN).
         pick-value = "NO". /* �।��⠭����� ��࠭�� �⢥� "���" */
         RUN Fill-SysMes IN h_tmess ("", "", "4", "� ��ꥪ� <" + STRING(iCustID) +
                                                  "> (" + TRIM(vName[1]) + " " + TRIM(vName[2]) +
                                                  ") �������� ஫�.~n" +
                                                  "������� ��ꥪ�?").
         oResult = pick-value EQ "YES".
         LEAVE CYCLE.
      END.  /* of FOR EACH cust-role */
   END.  /* of DO vi = 1 */
   RETURN.
END PROCEDURE.

/* �㭪��, ��।������ ���� �� ��ꥪ� �����⮬ ����� */
FUNCTION IsSubjClient RETURNS LOGICAL 
   (INPUT iCustCat AS CHARACTER,
    INPUT iCustId  AS INT64).
   
   DEFINE VARIABLE vResult AS LOGICAL NO-UNDO.

   DEF BUFFER banks     FOR banks.     /* ���������� ����. */
   DEF BUFFER person    FOR person.    /* ���������� ����. */
   DEF BUFFER cust-corp FOR cust-corp. /* ���������� ����. */
   
   vResult = ?.
   CASE iCustCat:
      WHEN "�" THEN
         FOR FIRST banks WHERE
                   banks.bank-id EQ iCustId NO-LOCK:
            vResult = banks.client.
         END.
      WHEN "�"
   OR WHEN "�" THEN
         vResult = GetValueByQuery ("cust-role",
                                    "class-code",
                                    "        cust-role.cust-cat   EQ '" + iCustCat + "'" + 
                                    "  AND   cust-role.cust-id    EQ '" + STRING (iCustId) + "'" +
                                    "  AND   cust-role.class-code EQ 'ImaginClient'"
                                    ) NE ?.
      OTHERWISE 
         vResult = YES.
   END CASE.
   RETURN vResult.
END FUNCTION.

PROCEDURE GetCustAdr.
   DEFINE INPUT PARAMETER iCustCat AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iCustID  AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER iDate    AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER iAdrType AS CHARACTER NO-UNDO.
   
   DEFINE OUTPUT PARAMETER TABLE FOR ttCustAddress.

   
   {cust-adr.obj
      &def-vars     = YES
   }
   DEFINE BUFFER cust-ident FOR cust-ident. /* ���������� ����. */   
   IF NOT {assigned iAdrType} THEN
      iAdrType = '*'.
   IF iDate = ? THEN
      iDate = gend-date.

   {empty ttCustAddress}

   FOR EACH cust-ident WHERE
            cust-ident.Class-code = "p-cust-adr"
        AND cust-ident.cust-cat   = iCustCat
        AND cust-ident.cust-id    = iCustID
        AND cust-ident.open-date  LE iDate
        AND CAN-DO(iAdrType,cust-ident.cust-code-type)
        AND (   cust-ident.close-date EQ ?
             OR cust-ident.close-date GE iDate)
   NO-LOCK:
      CREATE ttCustAddress.
      ASSIGN
         ttCustAddress.fFlAdrStr  = GetCode("������",cust-ident.cust-code-type) NE "0"
         ttCustAddress.fCodReg    = GetXattrValue("cust-ident",
                                                   cust-ident.cust-code-type + ',' + 
                                                   cust-ident.cust-code      + ',' + 
                                                   STRING(cust-ident.cust-type-num),
                                                   "������"
                                                 )
         ttCustAddress.fCodRegGNI = GetXattrValue("cust-ident",
                                                   cust-ident.cust-code-type + ',' + 
                                                   cust-ident.cust-code      + ',' + 
                                                   STRING(cust-ident.cust-type-num),
                                                   "���������"
                                                 )
         ttCustAddress.fCountryID = GetXattrValue("cust-ident",
                                                  cust-ident.cust-code-type + ',' + 
                                                  cust-ident.cust-code      + ',' + 
                                                  STRING(cust-ident.cust-type-num),
                                                  "country-id"
                                                 )
         ttCustAddress.fAdrStr    = fGetStrAdr(cust-ident.issue) 
         ttCustAddress.AdrStr    =  cust-ident.issue
         ttCustAddress.fCustCat   = cust-ident.cust-cat
         ttCustAddress.fCustID    = cust-ident.cust-id
         ttCustAddress.fTypeAdr   = cust-ident.cust-code-type
         ttCustAddress.fBegDate   = cust-ident.open-date 
         ttCustAddress.fEndDate   = cust-ident.close-date
         ttCustAddress.fCustNum   = cust-ident.cust-type-num
      .
      
      {cust-adr.obj 
         &addr-to-vars = YES
         &tablefield   = "TRIM(cust-ident.issue)"
      }
      ASSIGN
         ttCustAddress.fIndexInt  = vAdrIndInt
         ttCustAddress.fOblChar   = vOblChar  
         ttCustAddress.fGorChar   = vGorChar  
         ttCustAddress.fPunktChar = vPunktChar
         ttCustAddress.fUlChar    = vUlChar   
         ttCustAddress.fDomChar   = vDomChar  
         ttCustAddress.fKorpChar  = vKorpChar 
         ttCustAddress.fKvChar    = vKvChar   
         ttCustAddress.fStrChar   = vStrChar  
      .
   END.
END PROCEDURE.

/* �����㬥�� ������� ���⭮ GetCustAdr - ��࠭�� ���ଠ�� �� ����� ttCustAddress � cust-ident � �㦭�� �ଠ�. */
PROCEDURE SetCustAdr.
   DEFINE INPUT PARAMETER iCustCat AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iCustID  AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER iDate    AS DATE      NO-UNDO.
   DEFINE INPUT PARAMETER iAdrType AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER TABLE FOR ttCustAddress.
   
   {cust-adr.obj
      &def-vars = YES
   }

   DEFINE VARIABLE mDateStr AS CHARACTER   NO-UNDO.

   IF NOT {assigned iAdrType} THEN
      iAdrType = '*'.
   IF iDate = ? THEN
      iDate = gend-date.

   FOR EACH ttCustAddress WHERE  ttCustAddress.fCustCat EQ iCustCat
                            AND  ttCustAddress.fCustID  EQ iCustID
                            AND  ttCustAddress.fBegDate LE iDate
                            AND (ttCustAddress.fEndDate EQ ?
                             OR  ttCustAddress.fEndDate GE iDate)
                            AND CAN-DO(iAdrType, ttCustAddress.fTypeAdr)
   NO-LOCK:

      mDateStr = STRING(YEAR(ttCustAddress.fBegDate), "9999") + STRING(MONTH(ttCustAddress.fBegDate), "99") + STRING(DAY(ttCustAddress.fBegDate), "99").

      FIND FIRST cust-ident WHERE cust-ident.cust-code-type EQ ttCustAddress.fTypeAdr
                              AND cust-ident.cust-code      EQ mDateStr
                              AND cust-ident.cust-type-num  EQ ttCustAddress.fCustNum EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL cust-ident THEN
         CREATE cust-ident.

      ASSIGN
         cust-ident.class-code     = "p-cust-adr"
         cust-ident.cust-cat       = ttCustAddress.fCustCat
         cust-ident.cust-id        = ttCustAddress.fCustID
         cust-ident.cust-code-type = ttCustAddress.fTypeAdr
         cust-ident.open-date      = ttCustAddress.fBegDate
         cust-ident.close-date     = ttCustAddress.fEndDate
         cust-ident.cust-code      = mDateStr
         cust-ident.cust-type-num  = ttCustAddress.fCustNum
         vAdrIndInt                = ttCustAddress.fIndexInt
         vOblChar                  = ttCustAddress.fOblChar
         vGorChar                  = ttCustAddress.fGorChar
         vPunktChar                = ttCustAddress.fPunktChar
         vUlChar                   = ttCustAddress.fUlChar
         vDomChar                  = ttCustAddress.fDomChar
         vKorpChar                 = ttCustAddress.fKorpChar
         vKvChar                   = ttCustAddress.fKvChar
         vStrChar                  = ttCustAddress.fStrChar
      .
      {cust-adr.obj 
         &vars-to-addr = YES
         &tablefield   = "cust-ident.issue"
      }

      VALIDATE cust-ident.

      UpdateSigns(cust-ident.class-code,
                  cust-ident.cust-code-type + ',' + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num),
                  "������",
                  ttCustAddress.fCodReg,
                  ?).

      UpdateSigns(cust-ident.class-code,
                  cust-ident.cust-code-type + ',' + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num),
                  "���������",
                  ttCustAddress.fCodRegGNI,
                  ?).

      UpdateSigns(cust-ident.class-code,
                  cust-ident.cust-code-type + ',' + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num),
                  "country-id",
                  ttCustAddress.fCountryID,
                  ?).
   END.
END PROCEDURE.

/* ����祭�� ���ଠ樨 � ⨯� �������� ���� ��ꥪ� */
PROCEDURE GetTypeMainAdr.
   DEFINE INPUT  PARAMETER iCustCat     AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oAdrType     AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oAdrCntXattr AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vAdrInit AS CHARACTER NO-UNDO.

   oAdrType = fGetSetting(iCustCat + "�������",?,"").
   
   CASE iCustCat:
      WHEN '�' THEN vAdrInit = "�����".
      WHEN '�' THEN vAdrInit = "����ய".
   END CASE.

   IF NUM-ENTRIES(oAdrType) GT 1 THEN
      ASSIGN
         oAdrCntXattr = ENTRY(2,oAdrType)
         oAdrType     = ENTRY(1,oAdrType)
      .
   ELSE
      ASSIGN
         oAdrCntXattr = "country-id2"
         oAdrType     = vAdrInit
      .
   IF GetCode('������',oAdrType) = ? THEN
      oAdrType = vAdrInit.
   IF GetXattrEx(IF iCustCat = '�' 
                 THEN "cust-corp" 
                 ELSE "person",oAdrCntXattr,"name") = ? THEN
      oAdrCntXattr = "country-id2".
END PROCEDURE.

/* ����஭����� ���ᮢ � �᭮���� ����窮� ��ꥪ�*/
PROCEDURE SyncAdrSubjToCident.
   DEFINE INPUT PARAMETER iHBuffer  AS HANDLE    NO-UNDO.   /* �����⥫� �� ��ꥪ�. */
   DEFINE INPUT PARAMETER iCustCat  AS CHARACTER NO-UNDO.   /* ��� ������. */
   DEFINE INPUT PARAMETER iDate     AS DATE      NO-UNDO.   /* ��� ����� */
   DEFINE INPUT PARAMETER iAdrType  AS CHARACTER NO-UNDO.   /* ��� ���� */
   
   DEFINE BUFFER bCustIdent FOR cust-ident. /* ���������� ����. */
   DEFINE BUFFER cust-ident FOR cust-ident. /* ���������� ����. */

   DEFINE VARIABLE vAdrType        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vAdrCntXattr    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vFlagAv         AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vFileName       AS CHARACTER NO-UNDO. /* ������ �易����� ��ꥪ�. */
   DEFINE VARIABLE vH              AS HANDLE    NO-UNDO. /* �����⥫� �� ���� *-id. */
   DEFINE VARIABLE vCustId         AS INT64   NO-UNDO. /* ��� ������. */
   DEFINE VARIABLE vCustAdr        AS CHARACTER NO-UNDO. /* ���� ������ �� ����窨 */
   DEFINE VARIABLE vCustCntry      AS CHARACTER NO-UNDO. /* ��࠭� ������ */
   
   IF iDate = ?  THEN iDate = TODAY.


   /* ��।���� ⨯ ������ �� ���� *-id. */
   CASE iCustCat:
      WHEN "�"
      THEN ASSIGN
         vFileName   = "person"
         vH          = iHBuffer:BUFFER-FIELD ("person-id")
         vCustAdr    = iHBuffer:BUFFER-FIELD ("address")   :BUFFER-VALUE(1)
         vCustCntry  = iHBuffer:BUFFER-FIELD ("country-id"):BUFFER-VALUE
      NO-ERROR.
      WHEN "�"
      THEN ASSIGN
         vFileName   = "cust-corp"
         vH          = iHBuffer:BUFFER-FIELD ("cust-id")
         vCustAdr    = iHBuffer:BUFFER-FIELD ("addr-of-low"):BUFFER-VALUE(1)
         vCustCntry  = iHBuffer:BUFFER-FIELD ("country-id"):BUFFER-VALUE
      NO-ERROR.
      WHEN "�"
      THEN ASSIGN
         vFileName   = "banks"
         vH          = iHBuffer:BUFFER-FIELD ("bank-id")
      NO-ERROR.
   END CASE.
   /* ��।�� 㪠��⥫� �� �� ��ꥪ�. */
   IF NOT VALID-HANDLE (vH)
      THEN RETURN ERROR.

   vCustId     = vH:BUFFER-VALUE.
   
   IF NOT {assigned iAdrType} THEN
      RUN GetTypeMainAdr (iCustCat,OUTPUT vAdrType,OUTPUT vAdrCntXattr).
   ELSE
      vAdrType = iAdrType.
   
   bl:
   FOR EACH cust-ident WHERE 
            cust-ident.cust-cat       EQ iCustCat
        AND cust-ident.cust-id        EQ vCustId
        AND cust-ident.cust-code-type EQ vAdrType 
        AND cust-ident.class-code     EQ "p-cust-adr"
   NO-LOCK:
      IF cust-ident.cust-code  = GetXattrValue(vFileName,
                                               STRING(vCustId),
                                               "�����������")
      THEN DO:
         vFlagAv = YES.
         LEAVE bl.
      END.

   END.

   /* ������� ���� */
   IF vFlagAv  
   THEN DO ON ERROR  UNDO, LEAVE
           ON ENDKEY UNDO, LEAVE:
      FIND FIRST bCustIdent WHERE 
           ROWID(bCustIdent) = ROWID(cust-ident) 
      EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL bCustIdent THEN DO:
         bCustIdent.issue  = vCustAdr.
         VALIDATE bCustIdent NO-ERROR.
         IF    ERROR-STATUS:ERROR
            OR RETURN-VALUE GT "" THEN
            RETURN ERROR (IF RETURN-VALUE GT ""
                          THEN RETURN-VALUE
                          ELSE ERROR-STATUS:GET-MESSAGE(1)). 
      END.
   END.
   ELSE 
      DO ON ERROR  UNDO, LEAVE
         ON ENDKEY UNDO, LEAVE:
         CREATE cust-ident NO-ERROR.
         ASSIGN
            cust-ident.cust-cat       = iCustCat
            cust-ident.cust-id        = vCustId
            cust-ident.cust-code-type = vAdrType
            cust-ident.cust-type-num  = NEXT-VALUE(cident-num-id)
            cust-ident.cust-code      = STRING(YEAR (iDate),"9999") +
                                        STRING(MONTH(iDate),"99")   +
                                        STRING(DAY  (iDate),"99")
            cust-ident.open-date      = iDate
            cust-ident.issue          = vCustAdr
            cust-ident.class-code     = "p-cust-adr"
         .
         VALIDATE cust-ident NO-ERROR.
         IF    ERROR-STATUS:ERROR
            OR RETURN-VALUE GT "" THEN
            RETURN ERROR (IF RETURN-VALUE GT ""
                          THEN RETURN-VALUE
                          ELSE ERROR-STATUS:GET-MESSAGE(1)). 
      END.


   IF  NOT UpdateSigns(vFileName, 
                       STRING(vCustId),
                       "�����������", 
                       cust-ident.cust-code,
                       ?)
    OR NOT UpdateSigns("p-cust-adr", 
                       {&CustIdntSurr},
                       "���뀤��", 
                       GetXattrValue(vFileName,
                                     STRING(vCustId),
                                     "���뀤��"
                                    ),
                       ?)
    OR NOT UpdateSigns("p-cust-adr", 
                       {&CustIdntSurr},
                       "������", 
                       GetXattrValue(vFileName,
                                     STRING(vCustId),
                                     "������"),
                       ?) 
    OR NOT UpdateSigns("p-cust-adr", 
                       {&CustIdntSurr},
                       "���������", 
                       GetXattrValue(vFileName,
                                     STRING(vCustId),
                                     "���������"),
                       ?) 
    OR NOT UpdateSigns("p-cust-adr", 
                       {&CustIdntSurr},
                       "country-id", 
                       GetXattrValueEx(vFileName,
                                       STRING(vCustId),
                                       vAdrCntXattr,vCustCntry),
                       ?)   
   THEN DO:
      RETURN ERROR "�訡�� ���������� �� �� ᮧ����� ����". 
   END.
   RETURN.

END PROCEDURE.

/* ����祭�� �� ⨯� ������ � ���� ���� ��� �� ��� ᨭ�஭���樨*/

PROCEDURE GetXattrAddress.
   DEFINE INPUT  PARAMETER iCustCat   AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iAdrType   AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oXattrCode AS CHARACTER NO-UNDO.

   CASE iCustCat:
      WHEN '�' THEN
         CASE iAdrType:
            WHEN "�������" THEN oXattrCode = 'PlaceOfStay'.
            WHEN "�������" THEN oXattrCode = '����'.
         END CASE.
      WHEN '�' THEN
         CASE iAdrType:
            WHEN '�������' THEN oXattrCode = 'PlaceOfStay'.
         END CASE.
   END CASE.

   IF GetXAttrEx(ENTRY(LOOKUP(iCustCat,'�,�,�') + 1,',person,cust-corp,banks'),
                 oXattrCode,
                 'Xattr-Code') = ? 
   THEN oXattrCode = "".

   RETURN oXattrCode.

END PROCEDURE.

/* ����祭�� �� ⨯� ������ � ���e �� ��� ���� ��� ᨭ�஭���樨 */
PROCEDURE GetCidenAddress.
   DEFINE INPUT  PARAMETER iCustCat   AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iXattrCode AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oAdrType   AS CHARACTER NO-UNDO.

   CASE iCustCat:
      WHEN '�' THEN
         CASE iXattrCode:
            WHEN 'PlaceOfStay' THEN oAdrType = "�������".
            WHEN '����'      THEN oAdrType = "�������".
         END CASE.
      WHEN '�' THEN
         CASE iXattrCode:
            WHEN 'PlaceOfStay' THEN oAdrType = '�������'.
         END CASE.
   END CASE.

   IF GetCode("������",oAdrType) = ? THEN 
      oAdrType = "".

   RETURN oAdrType.

END PROCEDURE.

/* ��ॢ���� ����।������� ���祭�� � ���� "�����" ("?") */
FUNCTION GetNotEmpty CHAR (ipString AS CHAR):
   RETURN IF ipString EQ ? THEN "?" ELSE ipString.
END FUNCTION.

/* ��楤�� GetCustInfoBlock - �����頥� ���ଠ�� � ������ ����� ������ (� ���ᨢ�)
** ��ࠬ����:
**        ipCustCat - ⨯ ������ (�,�,�)
**        ipCustId  - ��� ������
** output opResult  - ��ப� � ����묨 ࠧ������묨 ᨬ����� chr(1)
**    ���冷� ������:
**    ��� 䨧.���:  1  - �������
**                   2  - ���, �����⢮
**                   3  - ��� ��࠭�
**                   4  - ����
**                   5  - ⨯ ���㬥��
**                   6  - ���(�����) ���㬥��
**                   7  - ��� �뤠� (� �/�) + ��� �뤠� ���㬥��
**                   8  - ��� �뤠� ���㬥��
**                   9  - ��� �뤠� (� �/�)
**                   10 - ��� �뤠� (��� �/�)
**                   11 - ��� ���ࠧ�������
**
**                   13 - ���
**    ��� ��. ���
**    � ������   :   1 - ������ ������������
**                   2 - ���⮥
**                   3 - ��� ��࠭�
**                   4 - �ਤ��᪨� ����     
*/
PROCEDURE GetCustInfoBlock:
   DEFINE INPUT  PARAMETER ipCustCat  AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER ipCustId   AS INT64    NO-UNDO.
   DEFINE OUTPUT PARAMETER opResult   AS CHARACTER  NO-UNDO.
   DEFINE VAR vCodReg AS CHARACTER NO-UNDO.
   DEFINE VAR vBankInn AS CHARACTER NO-UNDO.
   opResult = "".
   vCodReg = GetXattrValueEx(IF ipCustCat EQ "�" THEN "person"
                 ELSE IF ipCustCat EQ "�" THEN "cust-corp"
                 ELSE IF ipCustCat EQ "�" THEN "banks" ELSE "",
                 STRING(ipCustId),
                 "������",
                 "").   
   CASE ipCustCat:
      WHEN "�" THEN DO:
         FIND FIRST person WHERE person.person-id = ipCustId NO-LOCK NO-ERROR.
         IF AVAIL person
         THEN opResult =
                          GetNotEmpty(person.name-last)
               + CHR(1) + GetNotEmpty(person.first-names)
               + CHR(1) + GetNotEmpty(person.country-id)
               + CHR(1) + GetNotEmpty(person.address[1] + " " + person.address[2])
               + CHR(1) + GetNotEmpty(person.document)
               + CHR(1) + GetNotEmpty(person.document-id)
               + CHR(1) + fGetDocIssue(person.person-id)
               + CHR(1) + fGetDocIssueDate(person.person-id)
               + CHR(1) + fGetDocIssueOrg(person.person-id)
               + CHR(1) + fGetDocIssueClear(person.person-id)
               + CHR(1) + fGetDocIssueKP(person.person-id)
               + CHR(1) + GetNotEmpty(FrmtAddrStr(person.address[1],vCodReg)) + " " + GetNotEmpty(FrmtAddrStr(person.address[2],vCodReg))
               + CHR(1) + /*"��� " +*/ GetNotEmpty(person.inn).
            .
      END. /* when "�" */

      WHEN "�" THEN DO:
         FIND cust-corp WHERE cust-corp.cust-id = ipCustId NO-LOCK NO-ERROR.
         IF AVAIL cust-corp 
            THEN opResult = GetNotEmpty(cust-corp.name-corp) 
                            + CHR(1) 
                            + CHR(1) + GetNotEmpty(cust-corp.country-id)
                            + CHR(1) + GetNotEmpty(cust-corp.addr-of-low[1]) 
                            + CHR(1)
                            + CHR(1)
                            + CHR(1)
                            + CHR(1)
                            + CHR(1)
                            + CHR(1)
                            + CHR(1)
                            + CHR(1) + GetNotEmpty(FrmtAddrStr(cust-corp.addr-of-low[1],vCodReg)) 
                            + CHR(1) + /*"��� " +*/ GetNotEmpty(cust-corp.inn) 
                            .
      END. /* when "�" */

      WHEN "�" THEN DO:
         FIND banks WHERE banks.bank-id = ipCustId NO-LOCK NO-ERROR.
          IF AVAIL banks 
             THEN DO:
                  vBankInn = GetBankInn ("bank-id", STRING (banks.bank-id)).
                  IF NOT {assigned vBankInn} THEN
                     vBankInn = "".
                  opResult = GetNotEmpty(banks.NAME)
                             + CHR(1)
                             + CHR(1) + GetNotEmpty(banks.country-id)
                             + CHR(1) + GetNotEmpty(banks.law-address)  
                             + CHR(1) 
                             + CHR(1) 
                             + CHR(1)
                             + CHR(1)
                             + CHR(1)
                             + CHR(1)
                             + CHR(1)
                             + CHR(1) + GetNotEmpty(FrmtAddrStr(banks.law-address,vCodReg)) 
                             + CHR(1) + /*"��� " +*/ GetNotEmpty(vBankInn)
                             .
             END.
      END. /* when "�" */

   END CASE.
END PROCEDURE.


/* ��楤�� GetCustInfo - �����頥� ���ଠ�� � ������ (�� ��ப��)
** ��ࠬ����:
**        ipType    - ��� �ॡ㥬�� ���ଠ樨 (���ᠭ� � �.GetCustInfoBlock � ᮮ⢥��⢨� � ⠡��楩)
**        ipCustCat - ⨯ ������ (�,�,�)
**        ipCustId  - ��� ������
** output opResult  - ��ப� � 㪠����묨 ����묨
*/
PROCEDURE GetCustInfo:
   DEFINE INPUT  PARAMETER ipType     AS INT64    NO-UNDO.
   DEFINE INPUT  PARAMETER ipCustCat  AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER ipCustId   AS INT64    NO-UNDO.
   DEFINE OUTPUT PARAMETER opResult   AS CHARACTER  NO-UNDO.

   IF ipType > 0 THEN DO:
      RUN GetCustInfoBlock (ipCustCat, ipCustId, OUTPUT opResult).
      IF NUM-ENTRIES(opResult, CHR(1)) < ipType
      THEN opResult = "".
      ELSE opResult = ENTRY(ipType, opResult, CHR(1)).
   END.
   ELSE opResult = "".
END PROCEDURE.


/* ��楤�� GetCustInfo2 - �����頥� ���ଠ�� � ������ (�� ��ப��), ������ ��।������ �� ���
** ��ࠬ����:
**        ipType     - ��� �ॡ㥬�� ���ଠ樨 (���ᠭ� � �.GetCustInfoBlock � ᮮ⢥��⢨� � ⠡��楩)
**        ipAcct     - ��� ������
**        ipCurrency - ��� ������ ���, �᫨ ��� ��ࠬ��� ����।���� (?)
**                     � ��� ����� ⮫쪮 �� ��楢��� ����
** output opResult   - ��ப� � 㪠����묨 ����묨
*/
PROCEDURE GetCustInfo2:
   DEFINE INPUT  PARAMETER ipType     AS INT64    NO-UNDO.
   DEFINE INPUT  PARAMETER ipAcct     AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER ipCurrency AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER opResult   AS CHARACTER  NO-UNDO.

   DEF VAR vCat AS CHAR   NO-UNDO.
   DEF VAR vID  AS INT64    NO-UNDO.

   IF ipCurrency NE ? THEN DO:
       IF ipCurrency EQ FGetSetting("�����悠�",?,"{&in-NC-Code}") THEN ipCurrency = "".
       FIND FIRST acct WHERE acct.acct     EQ ipAcct     AND
                             acct.currency EQ ipCurrency NO-LOCK NO-ERROR.
   END.
   ELSE DO:
       FIND FIRST acct WHERE acct.acct     EQ ipAcct NO-LOCK NO-ERROR.
   END.
   IF NOT AVAIL acct THEN opResult = "".
   ELSE 
   DO: 
      IF acct.cust-cat EQ "�" THEN
         /*�맮� �����㬥�� �� 44276 ��� ��।������ ������᪨� 
           ४����⮢ ����७���� ���*/
         RUN GetCustIdCli IN h_acct (acct.acct + "," + acct.currency,
                                     OUTPUT vCat,
                                     OUTPUT vID).
      ELSE
         ASSIGN vCat = acct.cust-cat
                vID  = acct.cust-id.
      RUN GetCustInfo (ipType, vCat, vID, OUTPUT opResult).
   END.

END PROCEDURE.

/* ��।����, १���� �� ������ ��� ��� */
PROCEDURE IsResident.
   DEFINE INPUT  PARAMETER iCustCat    AS CHARACTER        NO-UNDO.
   DEFINE INPUT  PARAMETER iCustId     AS INT64          NO-UNDO.
   DEFINE OUTPUT PARAMETER oResident   AS LOGICAL   INIT ? NO-UNDO.

   DEFINE VARIABLE vSCountry AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vCCountry AS CHARACTER   NO-UNDO.

   DEF BUFFER person    FOR person.
   DEF BUFFER cust-corp FOR cust-corp.
   DEF BUFFER banks     FOR banks.

   MAIN:
   DO ON ERROR  UNDO MAIN, LEAVE MAIN
      ON ENDKEY UNDO MAIN, LEAVE MAIN:

      /* ��ࠬ���� �㭪樨 �� ������ */
      IF    NOT {assigned iCustCat}
         OR iCustId EQ ?
         OR iCustId EQ 0 THEN
         UNDO MAIN, LEAVE MAIN.
      
      /* ��।��塞 ��� ��࠭� १�����⢠ */
      vSCountry = FGetSetting("������",?,"RUS").
      
      /* �� iCustCat ��।��塞 ⠡���� */
      CASE iCustCat:
         /* ��室�� ४����� ��ꥪ� ������ */
         WHEN "�" THEN 
         DO:
            FIND FIRST person WHERE person.person-id EQ iCustId 
               NO-LOCK NO-ERROR.
            IF AVAILABLE person THEN 
               vCCountry = person.country-id.
         END.
         WHEN "�" THEN 
         DO:
            FIND FIRST cust-corp WHERE cust-corp.cust-id EQ iCustId 
               NO-LOCK NO-ERROR.
            IF AVAILABLE cust-corp THEN 
               vCCountry = cust-corp.country-id.
         END.
         WHEN "�" THEN 
         DO:
            FIND FIRST banks WHERE banks.bank-id EQ iCustId 
               NO-LOCK NO-ERROR.
            IF AVAILABLE banks THEN 
               vCCountry = banks.country-id.
         END.
      END CASE.
   
      IF vCCountry NE "" THEN
      /* ��।��塞 १����⭮��� ������ */
         oResident = IF vCCountry EQ vSCountry THEN YES
                                               ELSE NO.         
   END.

END PROCEDURE.

/* ��楤�� GetRecipientValue - �����頥� ���ଠ�� ����⥪� �����⥫��
** ��ࠬ����:
**        iBIK       - ��� �� ���஬� �᪠�� �����⥫�
**        iAcct      - ����.��� �� ���஬� �᪠�� �����⥫�
**        iINN       - ��� �� ���஬� �᪠�� �����⥫� ��� CHR(4) �᫨ �� ���
**        iFields    - ����襭�� ����, �����頥�� � oValues �१ CHR(2)
**                     �������� ���祭��: ��� ����_���� ��� ��� ���
** output oValues    - ���祭�� ����襭��� �����
*/
PROCEDURE GetRecipientValue:
   DEFINE INPUT  PARAMETER iBIK    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iAcct   AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iINN    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iFields AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oValues AS CHARACTER NO-UNDO.
   DEFINE VAR vInt AS INT64 NO-UNDO.
   DEFINE BUFFER xxcode FOR code.
   /* ���� */
   IF {assigned iBIK} AND {assigned iAcct} THEN DO:
      IF iINN = CHR(4)
      /* CHR(4) - � ��� ��� */
      THEN FIND FIRST xxcode WHERE xxcode.class  = "recipient"
                               AND xxcode.parent = "recipient"
                               AND xxcode.code   BEGINS iBIK + "," + iAcct
           NO-LOCK NO-ERROR.
      ELSE FIND FIRST xxcode WHERE xxcode.class  = "recipient"
                               AND xxcode.parent = "recipient"
                               AND xxcode.code   = iBIK + "," + iAcct + "," + iINN
           NO-LOCK NO-ERROR.
   END.
   /* ������ ���祭�� */
   IF AVAIL xxcode
   THEN DO vInt = 1 TO NUM-ENTRIES(iFields):
      IF vInt > 1 THEN oValues = oValues + CHR(2).
      CASE ENTRY(vInt,iFields):
         WHEN "���"          THEN oValues = oValues + ENTRY(1,xxcode.code).
         WHEN "����_����"    THEN oValues = oValues + ENTRY(2,xxcode.code).
         WHEN "���"          THEN oValues = oValues + (IF xxcode.val     = ? THEN "" ELSE xxcode.val).
         WHEN "���"          THEN oValues = oValues + (IF xxcode.name    = ? THEN "" ELSE xxcode.name).
         WHEN "���"          THEN oValues = oValues + (IF xxcode.misc[3] = ? THEN "" ELSE xxcode.misc[3]).
         WHEN "����_�_�����" THEN oValues = oValues + (IF xxcode.misc[2] = ? THEN "" ELSE xxcode.misc[2]).
      END.
   END.
   ELSE oValues = FILL(CHR(2),NUM-ENTRIES(iFields) - 1).
   RETURN.
END PROCEDURE.

/* ��楤�� CreateUpdateRecipient - ���������� ������ �����⥫� � ����⥪�
                                     �����⥫�� ��� ���������� ���ଠ樨
** ��ࠬ����:
**        iBIK       - ��� �����⥫�
**        iAcct      - ����.��� �����⥫�
**        iINN       - ��� �����⥫�
**        iName      - ������������ �����⥫�
**        iKPP       - ��� �����⥫�
**        iBankAcct  - ��� �����⥫� � �����
**        iComm      - ������� �����⥫�
*/
PROCEDURE CreateUpdateRecipient:
   DEFINE INPUT PARAMETER iBIK      AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iAcct     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iINN      AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iName     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iKPP      AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iBankAcct AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iComm     AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER iFldToUpd AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vComm    AS INT64 NO-UNDO.
   DEFINE VARIABLE vInWrite AS LOGICAL NO-UNDO.
   DEFINE VARIABLE vNew     AS LOGICAL NO-UNDO.
   DEFINE BUFFER xxcode FOR code.

   &SCOPED-DEFINE LOCK_RECIPIENT ~
   IF NOT vInWrite THEN DO: ~
      FIND CURRENT xxcode EXCLUSIVE-LOCK. ~
      vInWrite = YES. ~
   END.

   DO TRANSACTION ON ERROR  UNDO, RETURN ERROR
                  ON ENDKEY UNDO, RETURN ERROR:
      iBIK = STRING(INT64(iBIK),"999999999").
      IF iINN = ? THEN iINN = "".
      FIND FIRST xxcode WHERE xxcode.class = "recipient"
                          AND xxcode.code  = STRING(INT64(iBIK),"999999999") + "," + iAcct + (IF iINN <> "" THEN "," + iINN ELSE "")
      NO-LOCK NO-ERROR.
      IF  NOT AVAIL xxcode
      AND iINN <> ""
      THEN FIND FIRST xxcode WHERE xxcode.class = "recipient"
                               AND xxcode.code  = STRING(INT64(iBIK),"999999999") + "," + iAcct
           NO-LOCK NO-ERROR.
      IF NOT AVAIL xxcode THEN DO:
         CREATE xxcode.
         ASSIGN
            vNew          = YES
            vInWrite      = YES
            xxcode.class  = "recipient"
            xxcode.parent = "recipient"
            xxcode.code   = STRING(INT64(iBIK),"999999999") + "," + iAcct + (IF iINN <> "" THEN "," + iINN ELSE "")
         .
      END.
      IF {assigned iName} THEN DO:
         IF xxcode.name <> iName
         AND (   vNew
              OR CAN-DO(iFldToUpd,"���")) THEN DO:
            {&LOCK_RECIPIENT}
            xxcode.name = iName.
         END.
      END.
      IF {assigned iINN} THEN DO:
         IF xxcode.code <> STRING(INT64(iBIK),"999999999") + "," + iAcct + "," + iINN THEN DO:
            {&LOCK_RECIPIENT}
            xxcode.code = STRING(INT64(iBIK),"999999999") + "," + iAcct + "," + iINN.
         END.
         IF xxcode.val <> iINN
         AND (   vNew
              OR CAN-DO(iFldToUpd,"���")) THEN DO:
            {&LOCK_RECIPIENT}
            xxcode.val = iINN.
         END.
      END.
      IF {assigned iComm} THEN DO:
         vComm = INT64(iComm) NO-ERROR.
         iComm = (IF vComm = ? OR vComm = 0 THEN "���" ELSE STRING(vComm)).
         IF xxcode.misc[1] <> iComm
         AND (   vNew
              OR CAN-DO(iFldToUpd,"��������")) THEN DO:
            {&LOCK_RECIPIENT}
            xxcode.misc[1] = iComm.
         END.
      END.
      IF {assigned iBankAcct} THEN DO:
         iBankAcct = REPLACE(iBankAcct,"-","").
         IF xxcode.misc[2] <> iBankAcct
         AND (   vNew
              OR CAN-DO(iFldToUpd,"����_�_�����")) THEN DO:
            {&LOCK_RECIPIENT}
            xxcode.misc[2] = iBankAcct.
         END.
      END.
      IF {assigned iKPP} THEN DO:
         IF xxcode.misc[3] <> iKPP
         AND (   vNew
              OR CAN-DO(iFldToUpd,"���")) THEN DO:
            {&LOCK_RECIPIENT}
            xxcode.misc[3] = iKPP.
         END.
      END.
      IF vInWrite THEN RELEASE xxcode.
   END.
   RETURN.
END PROCEDURE.

FUNCTION GetCustIDoc RETURNS CHARACTER (iCustCat AS CHARACTER,
                                        iCustID  AS INT64,
                                        iDate    AS DATE,
                                        iDocType AS CHARACTER):
   DEFINE BUFFER cust-ident FOR cust-ident.
   FIND LAST cust-ident
       WHERE cust-ident.cust-cat       EQ iCustCat
         AND cust-ident.cust-id        EQ iCustID
         AND cust-ident.class-code     EQ "p-cust-ident"
         AND cust-ident.cust-code-type EQ iDocType
         AND cust-ident.open-date      LE iDate
      NO-LOCK NO-ERROR.
   RETURN (IF AVAILABLE cust-ident
           THEN cust-ident.cust-code
           ELSE "").
END FUNCTION.

/* ���� � ᮧ����� (�� ����室����) ���� ��� ������ */
PROCEDURE SetUNKP.
   DEFINE INPUT  PARAMETER iCustCat  AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iCustID   AS INT64     NO-UNDO.
   DEFINE INPUT  PARAMETER iPC       AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iUNKP     AS CHARACTER   NO-UNDO.
   DEFINE INPUT  PARAMETER iDate     AS DATE        NO-UNDO.
   DEFINE OUTPUT PARAMETER oChanged  AS LOGICAL     NO-UNDO.
   DEFINE OUTPUT PARAMETER oCreated  AS LOGICAL     NO-UNDO.
   DEFINE OUTPUT PARAMETER oUNKPRID  AS ROWID       NO-UNDO.

   DEF BUFFER bCustIdent  FOR cust-ident.   

   MAIN:
   DO ON ERROR  UNDO MAIN, LEAVE MAIN
      ON ENDKEY UNDO MAIN, LEAVE MAIN:

      FIND LAST bCustIdent WHERE bCustIdent.cust-cat        EQ iCustCat
                             AND bCustIdent.cust-id         EQ iCustID
                             AND bCustIdent.cust-code-type  EQ iPC                             
                             AND bCustIdent.class-code      EQ "����"                             
                             AND bCustIdent.open-date       LE iDate
                             AND (    bCustIdent.close-date GE iDate
                                  OR  bCustIdent.close-date EQ ?)
         NO-LOCK NO-ERROR.
      IF AVAIL bCustIdent THEN
      DO:
         IF     bCustIdent.cust-code NE ?
            AND bCustIdent.cust-code NE iUNKP THEN
         DO:
            FIND CURRENT bCustIdent EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL bCustIdent THEN
               ASSIGN
                  bCustIdent.cust-code = iUNKP
                  oChanged             = YES
                  .
         END.

         oUNKPRID = ROWID(bCustIdent).
      END.
      ELSE
      DO:
         CREATE bCustIdent.
         ASSIGN
            bCustIdent.cust-cat       = iCustCat
            bCustIdent.cust-id        = iCustID
            bCustIdent.cust-code-type = iPC
            bCustIdent.cust-code      = iUNKP
            bCustIdent.open-date      = iDate
            bCustIdent.class-code     = "����"
            bCustIdent.issue          = "���"
            oCreated                  = YES
            oUNKPRID                  = ROWID(bCustIdent)
            .
      END.
   END.

END PROCEDURE.

/* ��ନ��� "��� �뤠�" �� ������ */
PROCEDURE MakeIssue:
   DEFINE INPUT  PARAMETER iIssue    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iPodrazd  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oIssueTot AS CHARACTER NO-UNDO.
   IF  {assigned iIssue}
   AND {assigned iPodrazd}
   THEN DO:
      IF NUM-ENTRIES(iIssue) < 2
      OR TRIM(ENTRY(NUM-ENTRIES(iIssue),iIssue)) <> TRIM(iPodrazd)
      THEN iIssue = iIssue + "," + iPodrazd.
   END.
   oIssueTot = iIssue.
END PROCEDURE.

FUNCTION GetCustIDRWD RETURNS ROWID (iCustCat AS CHARACTER,
                                     iCustID  AS INT64  ,
                                     iDate    AS DATE,
                                     iDocType AS CHARACTER):

   DEFINE BUFFER cust-ident FOR cust-ident.

   FIND LAST cust-ident WHERE cust-ident.cust-cat       EQ iCustCat
                          AND cust-ident.cust-id        EQ iCustID
                          AND cust-ident.class-code     EQ "p-cust-ident"
                          AND cust-ident.cust-code-type EQ iDocType
                          AND cust-ident.open-date      LE iDate
      NO-LOCK NO-ERROR.

   IF AVAILABLE cust-ident THEN
      RETURN ROWID(cust-ident).
   ELSE
      RETURN ?.

END FUNCTION.

FUNCTION GetCustIDNom RETURNS CHARACTER (iRWD AS ROWID):

   DEFINE BUFFER cust-ident FOR cust-ident.

   FIND FIRST cust-ident WHERE ROWID(cust-ident) EQ iRWD
      NO-LOCK NO-ERROR.

   IF AVAILABLE cust-ident THEN
      RETURN cust-ident.cust-code.
   ELSE
      RETURN "".
END FUNCTION.

FUNCTION GetCustIDIssue RETURNS CHARACTER (iRWD AS ROWID):

   DEFINE BUFFER cust-ident FOR cust-ident.

   FIND FIRST cust-ident WHERE ROWID(cust-ident) EQ iRWD
      NO-LOCK NO-ERROR.

   IF AVAILABLE cust-ident THEN
      RETURN cust-ident.issue.
   ELSE
      RETURN "".
END FUNCTION.

FUNCTION GetCustIDOpenDate RETURNS DATE (iRWD AS ROWID):

   DEFINE BUFFER cust-ident FOR cust-ident.

   FIND FIRST cust-ident WHERE ROWID(cust-ident) EQ iRWD
      NO-LOCK NO-ERROR.

   IF AVAILABLE cust-ident THEN
      RETURN cust-ident.open-date.
   ELSE
      RETURN ?.
END FUNCTION.

FUNCTION CalcSrokForDocument RETURNS DATE
      (iFormula   AS CHARACTER,
       iDateDoc   AS DATE,  /* ��� �뤠� ���㬥��*/
       iBirthDate AS DATE  /* ��� ஦�����*/
      ):
   DEFINE VAR vFirstSrok  AS INT64 NO-UNDO.
   DEFINE VAR vSecondSrok AS INT64 NO-UNDO.
   DEFINE VAR vLastSrok   AS INT64 NO-UNDO.
   DEFINE VAR i AS INTEGER NO-UNDO.
   DEFINE VAR oDate       AS DATE  NO-UNDO.
   DEFINE VAR oDate1       AS DATE  NO-UNDO.
   DEFINE VAR oDate2      AS DATE  NO-UNDO.
   DEFINE VAR oDate3       AS DATE  NO-UNDO.   
   
   IF iFormula   BEGINS "�" THEN DO:
      vFirstSrok  = INT64(REPLACE(ENTRY(1,iFormula),"�","")).
      vSecondSrok = IF NUM-ENTRIES(iFormula) GE 2 
                    THEN INT64(REPLACE(ENTRY(2,iFormula),"�",""))
                    ELSE 0.
      oDate = DATE(IF MONTH(iDateDoc) + vSecondSrok GT 12 
                   THEN (MONTH(iDateDoc) + vSecondSrok - 12)
                   ELSE (MONTH(iDateDoc) + vSecondSrok),
                   1,
                   YEAR(iDateDoc) + vFirstSrok + IF MONTH(iDateDoc) + vSecondSrok GT 12 THEN 1 ELSE 0).
      oDate = DATE(MONTH(oDate),DAY(iDateDoc),YEAR(oDate)) NO-ERROR.
      i = 1.
      DO WHILE ERROR-STATUS:ERROR:
         oDate = DATE(MONTH(oDate),DAY(iDateDoc) - i,YEAR(oDate)) NO-ERROR.
         i = i + 1.
      END.
   END.
   ELSE IF iFormula BEGINS "�" THEN DO:
      vFirstSrok =  INT64(REPLACE(ENTRY(1,iFormula,";"),"�","")).
      vSecondSrok = IF NUM-ENTRIES(iFormula,";") GE 2 
                    THEN INT64(REPLACE(ENTRY(2,iFormula,";"),"�",""))
                    ELSE 0.
      vLastSrok   = 100.              
/*    vAgeClient = YEAR(iDate) - YEAR(iBirthDate) - 
                   (IF (MONTH(iDate) EQ MONTH(iBirthDate) AND
                       DAY(iDate)   GT DAY(iBirthDate))  OR 
                       MONTH(iDate) GT MONTH(iBirthDate) THEN 0
                    ELSE 1).*/
      oDate1 = DATE(MONTH(iBirthDate),DAY(iBirthDate),YEAR(iBirthDate) + vFirstSrok) NO-ERROR.
      i = 1.
      DO WHILE ERROR-STATUS:ERROR:
         oDate1 = DATE(MONTH(oDate1),DAY(iBirthDate) - i,YEAR(oDate1)) NO-ERROR.
         i = i + 1.
      END.
      
      oDate2 = DATE(MONTH(iBirthDate),DAY(iBirthDate),YEAR(iBirthDate) + vSecondSrok) NO-ERROR.
      i = 1.
      DO WHILE ERROR-STATUS:ERROR:
         oDate2 = DATE(MONTH(oDate1),DAY(iBirthDate) - i,YEAR(oDate2)) NO-ERROR.
         i = i + 1.
      END.
      
      oDate3 = DATE(MONTH(iBirthDate),DAY(iBirthDate),YEAR(iBirthDate) + vLastSrok) NO-ERROR.
      i = 1.
      DO WHILE ERROR-STATUS:ERROR:
         oDate3 = DATE(MONTH(oDate3),DAY(iBirthDate) - i,YEAR(oDate3)) NO-ERROR.
         i = i + 1.
      END.

      IF iDateDoc <= oDate1 THEN
      oDate = oDate1.
      ELSE IF iDateDoc <= oDate2 THEN
      oDate = oDate2.
      ELSE IF iDateDoc <= oDate3 THEN
      oDate = oDate3.
      
   END.   
   RETURN oDate.   
END FUNCTION.

/* ��ନ��� ������������ � ����� �࣠����樮���-�ࠢ���� ���
   � ��⮬ ४����� ��ଠ⍠�� ������ � �� ��ଠ⍠�� */
PROCEDURE GetCustNameFormatted:
   DEFINE INPUT  PARAMETER iCustCat  AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iCustId   AS INT64   NO-UNDO.
   DEFINE OUTPUT PARAMETER oName     AS CHARACTER INIT ? NO-UNDO.

   DEFINE VAR vFormatNaim AS CHARACTER NO-UNDO.
   DEFINE VAR vEntry1     AS CHARACTER NO-UNDO.
   DEFINE VAR vEntry2     AS CHARACTER NO-UNDO.
   DEFINE VAR vDefFN      AS CHARACTER NO-UNDO.
   DEFINE VAR vCode       AS CHARACTER NO-UNDO.
   DEFINE BUFFER xcust-corp FOR cust-corp.

   IF iCustCat <> "�" THEN RETURN ERROR.

   IF  {assigned iCustCat}
   AND iCustId > 0 THEN DO:

      /** ᮣ��᭮ �ਪ��� 82 �� 6/08/2010 ��-㬮�砭�� ����� ������ �������� 
          ��⪮� ������������ ������ 
          commented by Buryagin 10/09/2010

      vFormatNaim = GetXAttrValueEx("cust-corp", STRING(iCustId), "��ଠ⍠��", "").
      IF NOT {assigned vFormatNaim}
      THEN ASSIGN
         vEntry1 = ?
         vEntry2 = ?
      .
      ELSE ASSIGN
         vEntry1 = ENTRY(1,vFormatNaim)
         vEntry2 = (IF NUM-ENTRIES(vFormatNaim) >= 2 THEN ENTRY(2,vFormatNaim) ELSE ?)
      .
      IF NOT {assigned vEntry1}
      OR NOT CAN-DO("�,�",vEntry1)
      OR NOT {assigned vEntry2}
      OR NOT CAN-DO("�,�",vEntry2)
      THEN DO:
         vDefFN = FGetSetting("��ଠ⍠��",?,"").
         IF NOT {assigned vEntry1}
         OR NOT CAN-DO("�,�",vEntry1)
         THEN DO:
            vEntry1 = ENTRY(1,vDefFN).
            IF vEntry1 = ?
            OR NOT CAN-DO(",�,�",vEntry1)
            THEN vEntry1 = "�".
         END.
         IF NOT {assigned vEntry2}
         OR NOT CAN-DO("�,�",vEntry2)
         THEN DO:
            vEntry2 = (IF NUM-ENTRIES(vDefFN) >= 2 THEN ENTRY(2,vDefFN) ELSE ?).
            IF NOT {assigned vEntry2}
            OR NOT CAN-DO("�,�",vEntry2)
            THEN vEntry2 = "�".
         END.
      END.

      */

      FIND FIRST xcust-corp WHERE xcust-corp.cust-id = iCustId NO-LOCK NO-ERROR.
      IF AVAIL xcust-corp THEN DO:
         IF {assigned xcust-corp.cust-stat} THEN DO:
            IF vEntry1 = "�"
            THEN DO:
               vCode = GetCodeVal("����।�",TRIM(xcust-corp.cust-stat)).
               vCode = GetCodeName("����।�",vCode).
               IF {assigned vCode}
               THEN oName = vCode.
               ELSE oName = xcust-corp.cust-stat.
            END.
            ELSE IF vEntry1 EQ "�" THEN
               oName = xcust-corp.cust-stat.
            ELSE
               oName = "".
         END.
         ELSE oName = "".
         IF {assigned oName} THEN oName = oName + " ".
         IF  vEntry2 = "�"
         AND {assigned xcust-corp.name-corp}
         THEN DO:
            IF xcust-corp.name-corp BEGINS oName THEN
               oName = xcust-corp.name-corp.
            ELSE
               oName = oName + xcust-corp.name-corp.
         END.
         ELSE DO: 
            IF xcust-corp.name-short BEGINS oName THEN
               oName = xcust-corp.name-short.
            ELSE
               oName = oName + xcust-corp.name-short.
         END.
		/****************
         * ����᭮ � ��� �ਭ﫨,
         * �� ������ ���⪮� ��������
         * ��� �࣠����樮���-�ࠢ���� ���
         * ᮡ�⢥�����.
         ****************/
         oName = xcust-corp.name-short.
      END.
      ELSE oName = ?.
   END.

   RETURN.
END PROCEDURE.

/* ��ନ��� ������������ � ����� �࣠����樮���-�ࠢ���� ���
   � ��⮬ ४����� ��ଠ⍠�� ������ � �� ��ଠ⍠�� */
PROCEDURE GetCustNameFormattedByAcct:
   DEFINE PARAMETER BUFFER xacct FOR acct.
   DEFINE INPUT PARAMETER iAcctNamePrior AS LOGICAL NO-UNDO.
   DEFINE OUTPUT PARAMETER oName AS CHARACTER INIT ? NO-UNDO.
   IF  (   iAcctNamePrior
        OR CAN-DO(FGetSetting("����獠��",?,""),STRING(xacct.bal-acct,"99999")))
   AND {assigned xacct.details}
   THEN ASSIGN oName = xacct.details.
   ELSE RUN GetCustNameFormatted (xacct.cust-cat, xacct.cust-id, OUTPUT oName).
   oName = TRIM(oName).
   RETURN.
END PROCEDURE.
/*******************************************************************************************/
/* ��।������ ������ � ��⥣�ਨ                                                        */
/*******************************************************************************************/
PROCEDURE GetAcctCat.
   def param buffer b-acct for acct.
   DEF OUTPUT PARAM oCat AS CHARACTER.
   DEF OUTPUT PARAM oId  LIKE acct.cust-id.
   IF b-acct.cust-cat EQ "�" THEN
   ASSIGN
       oCat = GetXAttrValueEx ("acct", b-acct.acct + "," + b-acct.currency, "�����",  "�")
       oId  = INT64(GetXAttrValueEx ("acct", b-acct.acct + "," + b-acct.currency, "IDCust",?)).
   ELSE ASSIGN
         oCat = b-acct.cust-cat
         oId  = b-acct.cust-id.
END PROCEDURE.

/*******************************************************************************************/
/* ���ନ஢���� ���짮��⥫� �� ᬥ�� ४����� country-id �� ������  */
/*******************************************************************************************/

PROCEDURE PirChkUpdCountryId.
   DEF INPUT  PARAM iClassCode AS CHAR   NO-UNDO. /* ����� ��ꥪ�. */
   DEF INPUT  PARAM iSurrogate AS CHAR   NO-UNDO. /* ���ண�� ��ꥪ�. */
   DEF INPUT  PARAM iValue     AS CHAR   NO-UNDO. /* ���祭�� ��ꥪ�. */

   DEF VAR vRekvizit AS CHAR   NO-UNDO. /* ���祭�� ����. */
   DEF VAR vErrMsg   AS CHAR   NO-UNDO. /* ����饭�� �� �訡��. */
   DEF VAR vClntCountrId AS CHAR INIT "" NO-UNDO. 

   DEF BUFFER bpers FOR person. 	
   DEF BUFFER bcorp FOR cust-corp. 	

   vRekvizit = STRING(iValue) NO-ERROR.

   IF ERROR-STATUS:ERROR THEN
      vErrMsg = ERROR-STATUS:GET-MESSAGE (1).
   ELSE DO:

      CASE iClassCode:
         WHEN  "person"  THEN 
	 DO:
		FIND FIRST bpers  WHERE bpers.person-id = INT64 (iSurrogate) NO-LOCK NO-ERROR.
		IF AVAIL(bpers) THEN
		   vClntCountrId = bpers.country-id .
	 END.
         WHEN  "cust-corp"  THEN 
	 DO:
		FIND FIRST bcorp  WHERE bcorp.cust-id = INT64 (iSurrogate) NO-LOCK NO-ERROR.
		IF AVAIL(bcorp) THEN
		   vClntCountrId = bcorp.country-id .
	 END.
      END CASE.

      IF vClntCountrId <> vRekvizit THEN
	 vErrMsg = "��������!!! �� ᬥ�� �ࠦ����⢠ ������ ����室��� ᬥ���� ��� ���!!!"  .

   END.

   IF vErrMsg NE "" THEN
	MESSAGE vErrMsg VIEW-AS ALERT-BOX .

/* �����㥬 ���४ ��� ���஠�����. ����஢ �.�. */

define variable rProc as character init "pir-cprek_count" no-undo.

if search(rProc + ".r") <> ? then run value (rProc + ".r")(iSurrogate, iValue, iClassCode, "country-id").
	else 
		if search(rProc + ".p") <> ?  then  run value (rProc + ".p")(iSurrogate, iValue, iClassCode, "country-id").
			else    message "��楤�� " rProc "�� �������!" view-as alert-box.

/* �����㥬 ���४ ��� ���஠�����. ����஢ �.�. */

   RETURN.
END PROCEDURE

