/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    copyright: (c) 1992-1998 ��� "������᪨� ���ଠ樮��� ��⥬�"
     filename: NAMEACLB.P
      comment: �����⥭⭠� ��楤�� ��� ��ࠡ�⪨ ������������ ����७����
               ��� �������.
   parameters:
         uses:
      used by:
      created: 12/05/01 kostik
     Modified: 12.10.2002 11:44 GORM     (0007334)    ��������� �㭪樨
                          ������         - ������������ ⨯� �������
                          ��⠎�����    - ��� ������ �������
                          ��⠎���焮�   - ��� ����砭�� �������
                          �ப���        - �ப ����⢨� ������� (� ����)
                          ����᪠���     - ��㯯� �᪠
     Modified: 27/12/2002  kraw (0011991) �맮� GetCustName � input-output ��ࠬ��஬
     Modified: 21.11.2007 jadv (0069015) ��������� �㭪樨:
                          �����⠊�   - ��⪮� ������������ ������            
                          ������     - ������������ ��ꥪ�, 㪠������� �
                                           ������� ���ᯥ祭��
                          �������   - ��⪮� ������������ ��ꥪ�, 㪠������� �
                                           ������� ���ᯥ祭��
                          ���⠢��       - ��業⭠� �⠢�� �������
*/

{globals.i}
{def-wf.i}
{pick-val.i}
{nameaclb.i}
{intrface.get pbase}
{intrface.get tmess}
{intrface.get i254}
{intrface.get bill}
{intrface.get xclass}

ASSIGN THIS-PROCEDURE:PRIVATE-DATA =
   "parssen library,���������,������,��������,������,������,��⠎�����,��⠎���焮�,�ப���,����᪠���,~
������,����������,�������,�������,����������,���������,���������,����⎡��,~
��롎���,��⎡��,�������,�㬎���,�����⠊�,������,�������,��㤑��,���⠢��,~
����_������,����_����,����_���,������_���,������_���,������_���,������_�����,�����,�������儮�,����儮���⠑���".
RETURN.

/* �-�� ��������� ��ࠬ���, ��।������ � ��楤��� */
/* ��᫥ ࠧ��� ��ப�  ��ࠬ��஢ ����஬             */
{getprm.lib}

/* g-bill.p */
PROCEDURE ����_������:
   {g-bill.i ����}
   IF {assigned sec-code.series} THEN
      pick-value = sec-code.series + " " + SUBSTRING(sec-code.number, LENGTH(sec-code.series) + 1).
   ELSE
      pick-value = sec-code.number.
END PROCEDURE. /* ����_������ */

PROCEDURE ����_����:
   {g-bill.i ����}

   DEFINE BUFFER cust-role FOR cust-role.

   FIND FIRST cust-role
        WHERE cust-role.file-name  EQ "sec-code"
          AND cust-role.surrogate  EQ sec-code.sec-code
          AND cust-role.class-code EQ "Bill_Issuer"
      NO-LOCK NO-ERROR.
   IF AVAILABLE cust-role THEN
      pick-value = cust-role.cust-name.
END PROCEDURE. /* ����_���� */

PROCEDURE ����_���:
   {g-bill.i ����}
   RUN GetBillInfo IN h_bill (sec-code.sec-code,
                              OUTPUT pick-value).
END PROCEDURE. /* ����_��� */

PROCEDURE ������_���:
   {g-bill.i ������}
   pick-value = deal-loan.doc-num.
END PROCEDURE. /* ������_��� */

PROCEDURE ������_���:
   {g-bill.i ������}

   DEFINE VARIABLE vCodeCode AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vClass    AS CHARACTER   NO-UNDO.

   vClass    = "�᭮���".
   vCodeCode = GetXAttrValueEx("loan",
                               deal-loan.contract + "," + deal-loan.cont-code,
                               vClass,
                               "").
   pick-value = GetCodeNameEx(vClass, vCodeCode, "").
END PROCEDURE. /* ������_��� */

PROCEDURE ������_���:
   {g-bill.i ������}
   pick-value = deal-loan.comment.
END PROCEDURE. /* ������_��� */

PROCEDURE ������_�����:
   {g-bill.i ������}

   DEFINE VARIABLE vName     AS CHARACTER   NO-UNDO EXTENT 2.
   DEFINE VARIABLE vCustInn  AS CHARACTER   NO-UNDO.

   RUN GetCustName IN h_base
      (deal-loan.cust-cat,
       deal-loan.cust-id,
       ?,
       OUTPUT vName[1],
       OUTPUT vName[2],
       INPUT-OUTPUT vCustInn
      ).
   pick-value = TRIM(vName[1] + " " + vName[2]).
END PROCEDURE. /* ������_����� */
/* g-bill.p -- E n d */

/* �������  ������� ���ᯥ祭�� */
PROCEDURE  GetNumG .
  DEF INPUT PARAM iAcctType AS CHAR NO-UNDO .
  DEF PARAM BUFFER b-term-obl FOR term-obl .

  DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
  DEFINE VAR vVidOb    AS CHARACTER NO-UNDO. /* ��� ������� ���ᯥ祭�� */
  DEFINE VAR vNumPP    AS CHARACTER NO-UNDO.

  DEFINE BUFFER buf-loan FOR loan.

  /* �饬 �।��� ������� */
   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").
   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ vCOntCode
   NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan THEN RETURN .
   FOR EACH b-term-obl WHERE
            b-term-obl.contract  = buf-loan.contract
        AND b-term-obl.cont-code = buf-loan.cont-code
        AND b-term-obl.idnt      = 5
     NO-LOCK:

     ASSIGN
         vVidOb = GetXAttrValueEx ("term-obl",
                                   b-term-obl.contract + ","
                                 + b-term-obl.Cont-Code + ",5,"
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "��������",
                                   "")
         vNumPP = GetXAttrValueEx ("term-obl",
                                   b-term-obl.contract + ","
                                 + b-term-obl.Cont-Code + ",5,"
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "�������",
                                   "").
        IF vVidOb + (IF vNumPP = "0" THEN "" ELSE vNumPP ) = iAcctType
        THEN LEAVE .
  END.
END PROCEDURE .

PROCEDURE ���������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vFIO        AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vClName     AS CHARACTER NO-UNDO EXTENT 3.

   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.

   IF AVAIL buf-loan THEN
   DO:
      RUN GetCustName IN h_base ( buf-loan.cust-cat, buf-loan.cust-id, "",
                                  OUTPUT       vClName[1],
                                  OUTPUT       vClName[2],
                                  INPUT-OUTPUT vClName[3] ).
      pick-value = vClName[1] + " " + vClName[2].
   END.
END PROCEDURE.

PROCEDURE ������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = buf-loan.doc-ref.
END PROCEDURE.

PROCEDURE ��������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""��������"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND loan WHERE loan.contract  EQ vContract
               AND loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                     THEN vCOntCode
                                     ELSE ENTRY(1,vCOntCode," ")
      NO-LOCK NO-ERROR.
   IF AVAIL loan THEN pick-value = loan.doc-num.
END PROCEDURE.

PROCEDURE ������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vName1      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vName2      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vInn        AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").
   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN DO:
      RUN GetCustName IN h_base (buf-loan.cust-cat,
                                 buf-loan.cust-id,
                                 ?,
                                 OUTPUT vName1,
                                 OUTPUT vName2,
                                 INPUT-OUTPUT vInn).
      pick-value = (IF vName1 NE ? THEN (vName1 + " ")
                                   ELSE "") +
                   (IF vName2 NE ? THEN vName2
                                   ELSE "").
   END.
END PROCEDURE.

PROCEDURE ������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN DO:
      FOR FIRST code WHERE 
            (   code.class = "�������" 
            AND code.code  = buf-loan.cont-type )
         OR (   code.class = "�������"
            AND code.code  = buf-loan.cont-type )
         NO-LOCK: 
      END.
      IF AVAILABLE code THEN pick-value = code.name.
   END.
END PROCEDURE.

PROCEDURE ��㤑��:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.

   DEFINE BUFFER buf-loan  FOR loan.
   DEFINE BUFFER loan-acct FOR loan-acct.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""��㤑��"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan WHERE 
        buf-loan.contract  EQ vContract
    AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN DO:
      FIND FIRST loan-acct WHERE 
                 loan-acct.Contract  EQ "�।��"
             AND loan-acct.cont-code EQ vContCode 
             AND loan-acct.acct-type EQ "�।��"
      NO-LOCK NO-ERROR.  
   IF AVAIL loan-acct THEN pick-value = loan-acct.acct.
   END.
END PROCEDURE.

PROCEDURE ��⠎�����:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""��⠎�����"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.open-date).
END PROCEDURE.

PROCEDURE ��⠎���焮�:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""��⠎���焮�"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.end-date).
END PROCEDURE.

PROCEDURE �ப���:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""�ப���"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.end-date - buf-loan.open-date).
END PROCEDURE.

PROCEDURE ����᪠���:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.

   pick-value = "".
   IF param-count GT 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""����᪠���"":" param-count "(������ ���� �� ����� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ IF getparam(1,param-str) NE "ᮣ���"
                                  THEN vCOntCode
                                  ELSE ENTRY(1,vCOntCode," ")
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = String(buf-loan.gr-riska).
END PROCEDURE.

/*�����頥 �������� ��*/
PROCEDURE ������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
        DEFINE VARIABLE vName1      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vName2      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vInn        AS CHARACTER NO-UNDO.

   DEFINE BUFFER buf-loan  FOR loan.
        DEFINE BUFFER buf-asset FOR asset.

   pick-value = "".
   IF param-count NE 0 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 0) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").
   FIND buf-loan WHERE
        buf-loan.contract  EQ vContract
    AND buf-loan.cont-code EQ vCOntCode NO-LOCK NO-ERROR.
     IF AVAIL buf-loan THEN DO:
        FIND FIRST buf-asset OF buf-loan NO-LOCK NO-ERROR.
        IF AVAILABLE buf-asset THEN pick-value = buf-asset.NAME.
     END.
END PROCEDURE.

/* ����������� */
/*  ������� ����� ������� ���ᯥ祭��   */

PROCEDURE ����������.
        DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

        DEFINE VAR iAcctType AS CHAR NO-UNDO .
        DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
        IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
        END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* ������ ������� ���ᯥ祭�� ��� ஫� iAcctType */
     pick-value = GetXAttrValueEx ("term-obl",
                                       b-term-obl.contract + ","
                                     + b-term-obl.Cont-Code + ",5,"
                                     + STRING(b-term-obl.end-date) + ","
                                     + STRING(b-term-obl.nn),
                                       "��������",
                                       "").

END PROCEDURE .

PROCEDURE ����������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHARACTER NO-UNDO.
   DEF BUFFER  b-term-obl FOR term-obl .
   DEF BUFFER code FOR code .


   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   iAcctType = getparam(1,param-str).

   FOR EACH code WHERE code.class  = "��������" AND
                       code.parent = "��������"
   NO-LOCK:
      IF iAcctType BEGINS code.code THEN
      DO:
         pick-value = code.name.
         RETURN.
      END.
   END.

END PROCEDURE.

PROCEDURE �������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.
   DEFINE VAR vObKind   AS CHARACTER NO-UNDO. /* ��� ���ᯥ祭�� */
   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   DEF BUFFER code FOR code .
    pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   vObKind  = GetXAttrValueEx ("term-obl",
                                        b-term-obl.contract + ","
                                      + b-term-obl.Cont-Code + ",5,"
                                      + STRING(b-term-obl.end-date) + ","
                                      + STRING(b-term-obl.nn),
                                        "�����",
                                        "") .
   IF   vObKind  =  ''
   THEN RETURN .
   FOR EACH code WHERE code.class = "�����" AND code.parent = "�����"
   NO-LOCK:
      IF code.code = vObKind THEN
      DO:
         pick-value = code.name.
         RETURN.
      END.
   END.

END PROCEDURE.

PROCEDURE �������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = GetXAttrValueEx ("term-obl",
                                   b-term-obl.contract + ","
                                 + b-term-obl.Cont-Code + ",5,"
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "�������",
                                   "").

 END PROCEDURE .

PROCEDURE ���������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = STRING(b-term-obl.fop-date,"99/99/9999").

END PROCEDURE .

PROCEDURE ���������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = STRING(b-term-obl.end-date,"99/99/9999").

END PROCEDURE .

PROCEDURE ����⎡��:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.


   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = GetXAttrValueEx ("term-obl",
                                       b-term-obl.contract + ","
                                     + b-term-obl.cont-code + ",5,"
                                     + STRING(b-term-obl.end-date) + ","
                                     + STRING(b-term-obl.nn),
                                       "��⠏���",
                                       "").

END PROCEDURE.

PROCEDURE ��롎���:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.


   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   pick-value = STRING(b-term-obl.sop-date,"99/99/9999").

END PROCEDURE.

PROCEDURE ��⎡��:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.


   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* ������ ������� ���ᯥ祭�� ��� ஫� iAcctType */
   pick-value =  Get_QualityGar ("comm-rate",
                                 b-term-obl.contract + "," + 
                                 b-term-obl.cont-code + ",5," + 
                                 STRING(b-term-obl.end-date) + "," + 
                                 STRING(b-term-obl.nn), 
                                 in-op-date).
   IF    pick-value EQ "?"
      OR pick-value EQ ?
   THEN
      pick-value = "".

END PROCEDURE.

PROCEDURE �������:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR vKeepCurr AS CHARACTER NO-UNDO.
   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .

   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* ������ ������� ���ᯥ祭�� ��� ஫� iAcctType */
       vKeepCurr = GetXAttrValueEx ("term-obl",
                                          b-term-obl.contract + ","
                                        + b-term-obl.cont-code + ",5,"
                                        + STRING(b-term-obl.end-date) + ","
                                        + STRING(b-term-obl.nn),
                                          "�����⠎���",
                                          ?)    .

            pick-value = IF (vKeepCurr = ? OR vKeepCurr = "") AND
                            b-term-obl.currency <> "" AND
                            b-term-obl.currency <> ?
                         THEN b-term-obl.currency
                         ELSE FGetSetting("�����悠�",?,"")    .


END PROCEDURE.

PROCEDURE �㬎���:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VAR vKeepCurr AS CHARACTER NO-UNDO.
   DEFINE VAR iAcctType AS CHAR NO-UNDO .
   DEF BUFFER  b-term-obl FOR term-obl .
   pick-value = "".
   IF param-count NE 1 THEN DO:
                MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""������"":" param-count "(������ ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.

   iAcctType = getparam(1,param-str).
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl
   THEN RETURN .
   /* ������ ������� ���ᯥ祭�� ��� ஫� iAcctType */
    vKeepCurr = GetXAttrValueEx ("term-obl",
                                       b-term-obl.contract + ","
                                     + b-term-obl.cont-code + ",5,"
                                     + STRING(b-term-obl.end-date) + ","
                                     + STRING(b-term-obl.nn),
                                       "�����⠎���",
                                       ?).

         IF vKeepCurr = ? OR vKeepCurr = ""  or b-term-obl.currency = '' THEN
            pick-value = STRING(b-term-obl.amt-rub).
         ELSE
            IF vKeepCurr = "810" OR vKeepCurr = "RUR" THEN
               pick-value = GetXAttrValueEx ("term-obl",
                                             b-term-obl.contract + ","
                                           + b-term-obl.cont-code + ",5,"
                                           + STRING(b-term-obl.end-date) + ","
                                           + STRING(b-term-obl.nn),
                                             "�㬬���悠�",
                                             ?).

END PROCEDURE.


/* ����祭�� ��⪮�� ������������ ������ */
PROCEDURE �����⠊�:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vCustName AS CHARACTER NO-UNDO.

   DEFINE BUFFER buf-loan FOR loan.

   ASSIGN
      pick-value = ""
      vContract  = GetCustomField("ContractCreateLoan")
      vContCode  = GetCustomField("ContCodeCreateLoan").

   IF param-count NE 0 THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�訡�筮� ������⢮ ��ࠬ��஢ "
         + "��।��� � �㭪�� ~"�����⠊�~": param-count (������ ���� 0).").
      RETURN.
   END.

   FIND buf-loan WHERE buf-loan.contract  EQ vContract
                   AND buf-loan.cont-code EQ vContCode
                   NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�� ������ �।��� ������� " + 
          vContCode + ".").
      RETURN.
   END.

   RUN GetCustNameShort IN h_base (buf-loan.cust-cat,
                                   buf-loan.cust-id,
                                   OUTPUT vCustName).
   ASSIGN
      pick-value = vCustName.

END PROCEDURE.

/* ������������ ��ꥪ�, 㪠������� � ������� ���ᯥ祭�� */
PROCEDURE ������:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VAR iAcctType AS CHAR NO-UNDO.
   DEFINE VAR vName1    AS CHAR NO-UNDO.
   DEFINE VAR vName2    AS CHAR NO-UNDO.
   DEFINE VAR vInn      AS CHAR NO-UNDO.

   DEF BUFFER b-term-obl FOR term-obl.

   ASSIGN
      pick-value = ""
      iAcctType = getparam(1, param-str).

   IF param-count NE 1 THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�訡�筮� ������⢮ ��ࠬ��஢ "
         + "��।��� � �㭪�� ~"������~": param-count (������ ���� 1).").
      RETURN.
   END.

   /* ���� ������� ���ᯥ祭�� ��� ஫� iAcctType */
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�� ������ ������� ���ᯥ祭�� ��� "
         + " ஫� " + iAcctType + ".").
      RETURN.
   END.

   RUN GetCustName IN h_base (b-term-obl.symbol,
                              b-term-obl.fop,
                              ?,
                              OUTPUT vName1,
                              OUTPUT vName2,
                              INPUT-OUTPUT vInn).
   ASSIGN
      pick-value = (IF vName1 NE ? THEN vName1 + " " ELSE "") + 
                   (IF vName2 NE ? THEN vName2       ELSE "").

END PROCEDURE.


/* ��⪮� ������������ ��ꥪ�, 㪠������� � ������� ���ᯥ祭�� */
PROCEDURE �������:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE iAcctType AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vCustName AS CHARACTER NO-UNDO.

   DEF BUFFER b-term-obl FOR term-obl.

   ASSIGN
      pick-value = ""
      iAcctType = getparam(1, param-str).

   IF param-count NE 1 THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�訡�筮� ������⢮ ��ࠬ��஢ " + 
          "��।��� � �㭪�� ~"�������~": param-count (������ ���� 1).").
      RETURN.
   END.

   /* ���� ������� ���ᯥ祭�� ��� ஫� iAcctType */
   RUN GetNumG(iAcctType, BUFFER b-term-obl).
   IF NOT AVAIL b-term-obl THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�� ������ ������� ���ᯥ祭�� ��� "
         + "஫� " + iAcctType + ".").
      RETURN.
   END.

   RUN GetCustNameShort IN h_base (b-term-obl.symbol,
                                   b-term-obl.fop,  
                                   OUTPUT vCustName).
   ASSIGN 
      pick-value = vCustName.

END PROCEDURE.
   

/* ��業⭠� �⠢�� ������� */
PROCEDURE ���⠢��:
   DEFINE INPUT PARAMETER rid         AS RECID NO-UNDO.
   DEFINE INPUT PARAMETER in-op-date  AS DATE  NO-UNDO.
   DEFINE INPUT PARAMETER param-count AS INT64   NO-UNDO.
   DEFINE INPUT PARAMETER param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vCodeCom  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vClLoanDr AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vPosCCode AS INT64   NO-UNDO.

   DEFINE BUFFER buf-loan      FOR loan.
   DEFINE BUFFER buf-loan-cond FOR loan-cond.
   DEFINE BUFFER buf-comm-rate FOR comm-rate.

   ASSIGN
      pick-value = ""
      vContract  = GetCustomField("ContractCreateLoan")
      vContCode  = GetCustomField("ContCodeCreateLoan").

   FIND buf-loan WHERE buf-loan.contract  EQ vContract
                   AND buf-loan.cont-code EQ vContCode
                   NO-LOCK NO-ERROR.
   IF NOT AVAIL buf-loan THEN DO:
      RUN Fill-SysMes IN h_tmess ("","","-1","�� ������ �।��� ������� " 
         + vContCode + ".").
      RETURN.
   END.

   /* ��� ���� �����ᨨ, �᫨ "�।��", � "%�।", �᫨ "�����", � "%���" */
   ASSIGN
      vCodeCom = IF (TRIM(buf-loan.contract) EQ "�।��") THEN "%�।" ELSE "%���".

   /* �᫨ ��� ������� ��⮨� �� ���� ��⥩ */
   ASSIGN
      vPosCCode = INDEX(vContCode, " ").

   IF vPosCCode GT 0 THEN DO:
      /* ��।��塞 ��砫쭮� ���祭�� �� ����� ⥪�饣� �।�⭮�� ������� */
      vClLoanDr = GetXAttrValue("loan", vContract + "," + vContCode, "���������").

      /* �᫨ ��� �����ᨨ �室�� � ���.���祭�� �� ����� ������� 
      ** � ���� �⠢�� �த������ �� ⥪�饬 ������� ����: */
      IF LOOKUP(vCodeCom, vClLoanDr) EQ 0 THEN DO:

         /* �ந������ ���� ������饣� �������
         ** �.�. ��砫쭮� ���祭�� "���������" �� ᮤ�ন� �������� ���� �����ᨨ,
         ** � �� ����砥�, �� ���᫥��� ��業⮢ �� �������� �� ������ �믮������� */
         ASSIGN
            vContCode = SUBSTRING(vContCode, 1, vPosCCode - 1). 
         FIND buf-loan WHERE buf-loan.contract  EQ vContract
                         AND buf-loan.cont-code EQ vContCode
                         NO-LOCK NO-ERROR.
         IF NOT AVAIL buf-loan THEN DO:
            RUN Fill-SysMes IN h_tmess ("","","-1","�� ������ �।��� ������� " 
               + vContCode + ".").
            RETURN.
         END.
      END.
   END.
   
   /* �饬 ��ࢮ� �᫮��� �� �������� */
   FOR EACH buf-loan-cond WHERE buf-loan-cond.contract  EQ vContract
                            AND buf-loan-cond.cont-code EQ vContCode
                            NO-LOCK 
                            BY  buf-loan-cond.since:
      /* ��ࢠ� �⠢�� �� ��ࢮ�� �᫮��� ������� */
      FOR EACH buf-comm-rate WHERE buf-comm-rate.commi EQ vCodeCom
                               AND buf-comm-rate.kau   EQ vContract + "," + vContCode
                               AND buf-comm-rate.since GE buf-loan-cond.since 
                               NO-LOCK 
                               BY  buf-comm-rate.since:
         pick-value = STRING(buf-comm-rate.rate-comm).
         LEAVE.
      END.
      LEAVE.
   END.

END PROCEDURE.

/* �����頥� �� � ������� */
PROCEDURE �����:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.

   pick-value = "".
   IF param-count NE 1 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""�����"":" param-count "(����� ���� 1) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   ASSIGN
      vContract = GetCustomField("ContractCreateLoan")
      vContCode = GetCustomField("ContCodeCreateLoan").
      
    pick-value = GetXattrValueEx("loan",vContract + "," + vContCode,getparam(1,param-str),"").

END PROCEDURE.


/**
 * SSitov: #1192
 * �����頥� ����� �墠�뢠�饣� �������
 **/

PROCEDURE �������儮�:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".

   IF param-count GT 0 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""�������儮�"":" param-count "(������ ���� �� ����� 0) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   IF NUM-ENTRIES(vContCode," ") > 1 THEN 
	vContCode = ENTRY(1,vCOntCode," ") .
   ELSE 
	vContCode =  vCOntCode .

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ vCOntCode
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN pick-value = buf-loan.doc-ref.  

END PROCEDURE.


/**
 * SSitov: #1192
 * �����頥� ��⠑��� � �墠�뢠�饣� ������� 
 **/
PROCEDURE ����儮���⠑���:
   DEF INPUT PARAM rid         AS RECID NO-UNDO.
   DEF INPUT PARAM in-op-date  AS DATE  NO-UNDO.
   DEF INPUT PARAM param-count AS INT64   NO-UNDO.
   DEF INPUT PARAM param-str   AS CHAR  NO-UNDO.

   DEFINE VARIABLE vContCode   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vContract   AS CHARACTER NO-UNDO.
   DEFINE BUFFER buf-loan FOR loan.
   
   pick-value = "".

   IF param-count GT 0 THEN DO:
      MESSAGE "�訡�筮� ������⢮ ��ࠬ��஢ ��।��� � �㭪�� ""����儮���⠑���"":" param-count "(������ ���� ࠭�� 0) !"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
   END.

   vContract = GetCustomField("ContractCreateLoan").
   vContCode = GetCustomField("ContCodeCreateLoan").

   IF NUM-ENTRIES(vContCode," ") > 1 THEN 
	vContCode = ENTRY(1,vCOntCode," ") .
   ELSE 
	vContCode =  vCOntCode .

   FIND buf-loan
      WHERE buf-loan.contract  EQ vContract
        AND buf-loan.cont-code EQ vCOntCode
   NO-LOCK NO-ERROR.
   IF AVAIL buf-loan THEN 
	pick-value = GetXattrValueEx("loan",vContract + "," + vContCode,"��⠑���","").

END PROCEDURE.
