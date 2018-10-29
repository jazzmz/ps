/*
                 ������᪠� ��⥣�஢����� ��⥬� �������
      Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
       Filename: PP-I254.P
        Comment: ������⥪� �㭪権 ��� ���᫥��� ������⥫��, �易����
                 � ���⮬ १�ࢠ �� ��㤠� (�������� 254-�)
     Parameters:
           Uses:
        Used by:
        Created: 12.07.2004 AMAM
         Modify: 21.01.2008 jadv (0085692) ��������� �㭪樨 LnFormRsrvDiskBad(),
                                  LnFormRsrvVProcGood(), LnFormRsrvVDiskGood()
                                  � ��楤�� LnFormRsrvVek.
         Modify: 20.02.2008 jadv (0086632) ��ࠡ�⪠ LnFormRsrvProc � LnCalcRsrvProc
         Modify: 18.09.2008 jadv (0098607) �� �맮�� LnCollateralValueEx �� ClcAcctDeriv ��।��� ������ "", �.�. �㡫�

   F/P  Name                   Comment
   ���  �������������������  ����������������������������������������������������
   F    LnRsrvRate           �����頥� ���祭�� �⠢�� १�ࢨ஢���� �� ��������
                             �� 㪠������ ����
   F    LnPrincipal          �����頥� ����� ����稭� �᭮����� ����� �� ��������
                             �� 㪠������ ����. ��� ������஢ � �祭�ﬨ �㤥�
                             �����饭� ���� �㬬� �᭮����� ����� �� �ᥬ �࠭蠬.
   F    LnGoodDebt           �����頥� ����稭� ��筮� ������������ �� ��������
                             �� 㪠������ ����. ��� ������஢ � �祭�ﬨ �㤥�
                             �����饭� ���� �㬬� ��筮� ������������ �� �ᥬ
                             �࠭蠬.
   F    LnBadDebt            �����頥� ����稭� ����祭��� ������������ ��
                             �������� �� 㪠������ ����. ��� ������஢ � �祭�ﬨ
                             �㤥� �����饭� ���� �㬬� ����祭��� ������������
                             �� �ᥬ �࠭蠬.
   F    LnSyndLoan           �����頥� �ਧ��� ������� - ���� �� �� ᨭ���஢�����
                             ��㤮�.
   F    LnOptionClause       �����頥� �ਧ��� ��樮���� �����ન �� ������⭮��
                             ��������.
   F    LnPartAmt            �����頥� ��� �।�⭮�� ������� ����� �㬬� �।��,
                             �ਢ��祭��� �� �⮬� �������� �� ���⭨��� ᨭ���஢������
                             �।��.
   F    LnPersRisk           �����頥� �ਧ��� ������ �������㠫��� �����樥�⮢
                             १�ࢨ஢���� �� �࠭蠬 �।�⭮�� ������� � �祭�ﬨ.
   F    LnRsrvCheck          �����頥� �����᪮� ���祭�� ������, �᫨ १�� ������
                             ���뢠���� � ��ࠬ���� �������, ���� - ���祭�� ����.
   F    LnCalcRsrv           �����頥� ����稭� ���⭮�� १�ࢠ �� ��������. �᫨
                             �� ������� �� ������� ��� १�ࢠ, � �㭪�� �����頥�
                             ����. �� ������ࠬ � �祭�ﬨ ����� १�� �㤥�
                             ��।���� ��� ��� �࠭襩 �������.
   F   LnPledge              �����頥� �業���� �⮨����� ��ꥪ� ���ᯥ祭�� ���
                             ��� ���祭�� �����樥�� ᭨����� �⮨���� � ������
                             ����⢠ ���ᯥ祭��.
   F   LnCollateralValue     ������ ���� �㬬� ���ᯥ祭�� �� �᭮����� ����� �� 㪠�������
                             �������� � ��⮬ ������ ����⢠ ���ᯥ祭�� � �����樥�� ᭨�����
                             �⮨���� ���ᯥ祭��.
   F   LnCollateralValueAll  ������ ����� �㬬� ���ᯥ祭�� �� 㪠������� �������� �
                             ��⮬ ������ ����⢠ ���ᯥ祭�� � �����樥�� ᭨�����
                             �⮨���� ���ᯥ祭��.
 F   LnCollateralValueAllEx  ������ ����� �㬬� ���ᯥ祭�� �� 㪠������� �������� (�
                             ��⮬/��� ���) ������ ����⢠ ���ᯥ祭�� � �����樥��
                             ᭨����� �⮨���� ���ᯥ祭��.
   F   LnUncoveredLoan       ������ �����ᯥ祭��� ���� ����,�⭮������� �
                             �⤥�쭮�� ��������. �� ࠡ�⠥� � ������ࠬ� ⨯� "��祭��".
   F   LnCollateralValueAgr  ������ ���� �㬬� ���ᯥ祭��, ��ॣ����஢������ ��
                             ᮣ��襭�� � �࠭襢�� �।�⭮� �����, �⭮������� �
                             ������� �࠭��.
   F   LnFormRsrv            �����頥� ����稭� �ନ�㥬��� १�ࢠ �� ��������.
                             �᫨ � ������� �� ������� ��� १�ࢠ, � �㭪��
                             ������� ����. �� ������ࠬ � �祭�ﬨ �ନ�㥬�
                             १�� �㤥� ��।���� ��� ��� �࠭襩 �������.
   F   LnFormRsrvGoodDebt    �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮�������
                             � ��筮� ������������ �� ��������.
   F   LnFormRsrvBadDebt     �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮�������
                             � ����祭��� ������������ �� ��������.
 F LnFormRsrvGoodDebtTransh  �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮�������
                             � ��筮� ������������ �� ��������.
                             �।�����祭� ��� ���� १�ࢠ, �⭮��饣��� � �࠭��.
                             �����頥� 0 �� ������ࠬ ⨯� "��祭��".
 F LnFormRsrvBadDebtTransh   �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮�������
                             � ����祭��� ������������ �� ��������.
                             �।�����祭� ��� ���� १�ࢠ, �⭮��饣��� � �࠭��.
                             �����頥� 0 �� ������ࠬ ⨯� "��祭��".
   F   LnGetGrRiska          ��।������ ��㯯� �᪠ �� ���祭�� �����樥��
                             १�ࢨ஢����.
   F   LnRsrvDate            �����頥� ���祭�� �⠢�� १�ࢨ஢���� �� ��������
                             �� 㪠������ ����.
   P   LnGetRiskGrOnDate     ��।������ ��㯯� �᪠ �� ���祭�� �����樥��
                             १�ࢨ஢����.
   P   LnPersRsrvOnDate
   F   re_history_risk       ��।������ ��㯯� �᪠ ������� �� ���� �� ���ਨ.
   F   LnPledgeQuality       �����頥� �⮨����� ��ꥪ� ���ᯥ祭�� � ��⮬
                             ���祭�� �����樥�� ᭨����� �⮨���� � ������
                             ����⢠ ���ᯥ祭��.
   F   RegulationNeed        �㭪�� 䨪������ ��������� 䠪�஢, ������� ��
                             ࠧ��� १�ࢠ.
   F   LnCalcRsrvTransh      �����頥� ����稭� ���⭮�� १�ࢠ �� ��������. �᫨
                             �� ������� �� ������� ��� १�ࢠ, � �㭪�� �����頥�
                             ����. ��� ������஢, ������ ⨯ "��祭��" �����頥� ����.
   F   LnFormRsrvTransh      �����頥� ����稭� �ନ�㥬��� १�ࢠ �� ��������.
                             �᫨ � ������� �� ������� ��� १�ࢠ, � �㭪��
                             ������� ����. ��� ������஢, ������ ⨯ "��祭��"
                             �����頥� ����.
   F   LnRsrvBal             �����頥� ���⮪ १�ࢠ �� ��筮� � ����祭���
                             ������������, 䠪��᪨ ᮧ������� �� ��������, �� 㪠������
                             ����.
   F   LnRsrvBalGoodDebt     �����頥� ���⮪ १�ࢠ �� ��筮� ������������, 䠪��᪨
                             ᮧ������� �� �������� �� 㪠������ ����.
   F   LnRsrvBalBadDebt      �����頥� ���⮪ १�ࢠ �� ����祭��� ������������,
                             䠪��᪨ ᮧ������� �� �������� �� 㪠������ ����.
   F   LnRsrvBalTransh       �����頥� ���⮪ १�ࢠ �� ��筮� � ����祭���
                             ������������, 䠪��᪨ ᮧ������� �� ��������, �� 㪠������
                             ����. �᫨ ������� ����� ⨯ "��祭��" �����頥� ����.
 F LnRsrvBalGoodDebtTransh   �����頥� ���⮪ १�ࢠ �� ��筮� ������������, 䠪��᪨
                             ᮧ������� �� ��������, �� 㪠������ ����. �᫨ ������� �����
                             ⨯ "��祭��" �����頥� ����.
 F LnRsrvBalBadDebtTransh    �����頥� ���⮪ १�ࢠ �� ����祭��� ������������,
                             䠪��᪨ ᮧ������� �� ��������, �� 㪠������ ����.
                             �᫨ ������� ����� ⨯ "��祭��" �����頥� ����.
 P LnTurnoverDb              ����� ����稭� �㬬�୮�� ����� �� �।��⠢����� ���� �
                             ������⥫쭮� ��८業�� � ��砫� ���⭮�� �����.
 F LnAvgTurnoverDb           ����� ����稭� �।���� ����� �� �।��⠢����� ���� �
                             ��८業�� � ��砫� ���⭮�� ����� � ����� १����
                             iCurrency.
 F LnIsOffShoreOperation     ��।���� ���� �� ��㤠 ����樥� � १����⮬ ����.
 F LnOffShoreCode            ��।���� ��� ���୮� ����, � ���ன �⭮���� �������.
 P LnORsrvCalcBase           ����� ���� ��� ��।������ �������쭮� ����稭� �ନ�㥬���
                             १�ࢠ.
 F LnORsrvRate               �����頥� ࠧ��� ���� ���᫥��� � १�� ��� ����,
                             �।��⠢������ १������ ���୮� ����.
 F Get_QualityGar            �����頥� ���祭�� ��⥣�ਨ ����⢠ ���ᯥ祭�� �� ����.
 F Get_VidObespech           �����頥� ���祭�� ���� ���ᯥ祭�� �� ����.
 F GetLast_QualityGar        �����頥� ��᫥����, 㪠������ ���祭�� ��⥣�ਨ ����⢠
                             ���ᯥ祭��.
 F Set_QualityGar            ������� ������ ��⥣�ਨ ����⢠ �� ���ᯥ祭��.

 F Get_NachBal               ��।����, ��� ������� ��業�� - �� ������ ��� ��������� (0083188)
 F GetChanges_GrRiska        ��।���� 䠪� ��������� � ⥪�饬 ��� ��㯯� �᪠ (0083188)
 F LnFormRsrvDiskBad         ����� १�ࢠ ��� ����祭���� ��᪮��.
 F LnFormRsrvVProcGood       ����� १�ࢠ ��� �� �� ��業⠬.
 F LnFormRsrvVDiskGood       ����� १�ࢠ ��� �� �� ��᪮���.
 F LnFormRsrvVek             ����� १�ࢠ ��⥭��� ���ᥫ�� �� ���᫥��� ��業⠬/��᪮���.
 F LnFormRsrvVb              ����� १�ࢠ �� �᫮��� ��易⥫��⢠� 
 F LnGetExtraditionSum       �����頥� �㬬� �뤠����� �।��.                             
 
*/

{globals.i}             /* �������� ����⠭�� */
{intrface.get instrum}  /* �㭪樨 ࠡ��� � 䨭��ᮢ묨 �����㬥�⠬� */
{intrface.get xclass}   /* �㭪樨 ࠡ��� � ����奬�� */
{intrface.get comm}     /* �����㬥��� ��� ࠡ��� � ������ﬨ */
{intrface.get loan}     /* �����㬥��� ��� ࠡ��� � ⠡��窮� loan. */
{intrface.get date}     /* �����㬥��� ��� ࠡ��� � ��⠬�. */
{intrface.get refer}    /* ������⥪� ��� ࠡ��� � �㦡�� "��ࠢ�筨��". */
{intrface.get db2l}
{intrface.get tmess}
{gr-rsrv.pro}
{sh-defs.i}
{tt-cr.def}
{ppi254.api}
DEF STREAM out_s.

DEFINE TEMP-TABLE tt-Loan NO-UNDO
   FIELD ContCode AS CHARACTER
   FIELD DocRef   LIKE loan.doc-ref
INDEX pi IS UNIQUE ContCode.

/* ⠡��� ��� ���᫥��� LnGetProvAcct */
DEFINE TEMP-TABLE tt-Loan-ob NO-UNDO
   FIELD ContCode       AS CHARACTER
   FIELD Acct           AS CHARACTER
   FIELD ObSum          AS DECIMAL   /* ���� �㬬� ���ᯥ祭�� */
   FIELD TranshSum      AS DECIMAL   /* ���� �㬬� ��� �࠭襩 */
   FIELD AcctSum        AS DECIMAL   /* ���� �㬬� � ࠬ��� �����⭮�� ��� */
   FIELD IfLast         AS LOGICAL   /* �ਧ��� ��᫥����/�� ��᫥���� ��� */
   FIELD IfTransh       AS LOGICAL   /* �ਧ��� �࠭� / �� �࠭� */
INDEX pu IS UNIQUE ContCode Acct.

/* ��� ��⨬���樨 �뭮� �⥭�� ���祭�� �� � ��砫� ������⥪� (0095860) ????  */
DEF VAR mIfPutPtot    AS LOG  NO-UNDO.
DEF VAR mIfPutNotNull AS LOG  NO-UNDO.
DEF VAR mVerRel_Type  AS LOGICAL NO-UNDO .
DEF VAR mSpisBaseParam  AS CHARACTER NO-UNDO . /*���᮪ ��ࠬ��஢ ��筮� ������������*/
DEF VAR mSpisBaseParamP AS CHARACTER NO-UNDO . /*���᮪ ��ࠬ��஢ ����筮� ������������*/

ASSIGN
   mIfPutPtot    = FGetSetting("i254Stream", "", "") = "��"         /* ��।���� �뢮���� �� � OUTPUT STREAM out_s TO "loanrsrv.log"  */
   mIfPutNotNull = FGetSetting("i254StrTNull", "", "") = "���"      /* ��।����, �㦭� �� �뢮���� �㫥�� �࠭� � "loanrsrv.log" */
.

FUNCTION LnRsrvOffShore RETURNS DECIMAL (INPUT iContract AS CHAR,
                                         INPUT iContCode AS CHAR,
                                         INPUT iDate     AS DATE,
                                         INPUT iCurrency AS CHAR,
                                         INPUT iResult   AS DEC) FORWARD.

/*
  �����頥� ��� ����䥫� ���஬� �ਭ������� �������
 */
FUNCTION IsPortfolioLoan RETURNS CHAR
   (iContract AS CHAR,
    iContCode AS CHAR):

   DEF VAR vBag AS CHAR NO-UNDO.

   vBag = GetXAttrValueEx("loan",
                          iContract + "," + iContCode,
                          "UniformBag",
                          "").

   RETURN (IF NUM-ENTRIES(iContCode," ") = 2 THEN
              (IF NOT {assignex vBag}
               THEN IsPortfolioLoan(iContract,ENTRY(1,iContCode," "))
               ELSE vBag)
           ELSE vBag).

END FUNCTION.

FUNCTION loanNotFound RETURN LOGICAL (iContCode AS CHAR) :
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "�訡��    ��� ������� : " iContCode FORMAT "X(22)"
         ".  ������� �� ������."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
END FUNCTION.

/*----------------------------------------------------------------------------
  Function   : LnFInside
  Name       :
  Purpose    : ��।������, �室�� - �� ����稭� � ��������
  Parameters :
  Notes      :
  ----------------------------------------------------------------------------*/
FUNCTION LnFInside RETURNS LOGICAL
   (INPUT  iFormula AS CHAR,
    INPUT  iKfc     AS DECIMAL,
    OUTPUT vMin     AS DECIMAL):

   DEFINE VARIABLE vMax AS DECIMAL    NO-UNDO INIT ?.
   DEFINE VARIABLE vVal AS CHARACTER  NO-UNDO.
   /* ������ ��।���� ���� */
   ASSIGN
      vVal = TRIM (iFormula, CHR (126))  /* ��ᥪ��� ⨫�� */
      vMin = DEC (ENTRY (1,vVal))
      vMax = DEC (ENTRY (NUM-ENTRIES (vVal),vVal))
   NO-ERROR.
   /* �訡�� - �� ���뢠�� */
   IF ERROR-STATUS:ERROR THEN RETURN NO.

   IF (vMax EQ ?) OR (vMax EQ vMin)
      THEN RETURN (iKfc LE vMin).
      ELSE RETURN (iKfc GE vMin AND iKfc LT vMax).

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnIsOffShoreOperation
  Name       : ������� �� ��㤠 ����樥� � १����⮬ ����
  Purpose    : ��।���� ���� �� ��㤠 ����樥� � १����⮬ ����.
               �����頥� �����᪮� ���祭��.
  Parameters : iContract - �����祭�� �������
               iContCode - ����� �������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnIsOffShoreOperation RETURNS LOGICAL (INPUT iContract AS CHAR,
                                                INPUT iContCode AS CHAR).

   DEFINE VARIABLE vCustCat AS CHARACTER        NO-UNDO.
   DEFINE VARIABLE vCustId  AS INT64          NO-UNDO.
   DEFINE VARIABLE vOfShore AS CHARACTER INIT ? NO-UNDO.

   DEFINE BUFFER b-loan FOR loan.

   RUN RE_B_LOAN IN h_Loan (iContract, iContCode, BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   FIND FIRST cust-role WHERE
              cust-role.file-name  = "loan"
          AND cust-role.surrogate  = iContract + "," + iContCode
          AND cust-role.Class-Code = "loan-cust-off-shore"
   NO-LOCK NO-ERROR.

   IF AVAIL cust-role THEN
      ASSIGN
         vCustCat = cust-role.cust-cat
         vCustId  = INT64(cust-role.cust-id)
         .
   ELSE
      ASSIGN
         vCustCat = b-loan.cust-cat
         vCustId  = b-loan.cust-id
         .

   CASE vCustCat:
      WHEN '�' THEN DO:
         FIND FIRST cust-corp WHERE cust-corp.cust-id = vCustId NO-LOCK NO-ERROR.
         IF AVAIL cust-corp THEN
            vOfShore = GetXAttrValueEx("cust-corp", STRING(vCustId), "����", ?).
      END.
      WHEN '�' THEN DO:
         FIND FIRST person WHERE person.person-id = vCustId NO-LOCK NO-ERROR.
         IF AVAIL person THEN
            vOfShore = GetXAttrValueEx("person", STRING(vCustId), "����", ?).
      END.
      WHEN '�' THEN DO:
         FIND FIRST banks WHERE banks.bank-id = vCustId NO-LOCK NO-ERROR.
         IF AVAIL banks THEN
            vOfShore = GetXAttrValueEx("banks", STRING(vCustId), "����", ?).
      END.
   END CASE.

   IF vOfShore <> ? AND vOfShore <> "" THEN RETURN TRUE.

   RETURN FALSE.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnOffShoreCode
  Name       : ��� ����, � ���஬� �⭮���� �������
  Purpose    : ��।���� ��� ���୮� ����, � ���ன �⭮���� �������.
               �����頥� ᨬ���쭮� ���祭��.
  Parameters : iContract - �����祭�� �������
               iContCode - ����� �������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnOffShoreCode RETURNS CHARACTER (INPUT iContract AS CHAR,
                                           INPUT iContCode AS CHAR).

   DEFINE VARIABLE vCustCat AS CHARACTER        NO-UNDO.
   DEFINE VARIABLE vCustId  AS INT64          NO-UNDO.
   DEFINE VARIABLE vOfShore AS CHARACTER INIT ? NO-UNDO.

   DEFINE BUFFER b-loan FOR loan.

   RUN RE_B_LOAN IN h_Loan (iContract, iContCode, BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   FIND FIRST cust-role WHERE
              cust-role.file-name  = "loan"
          AND cust-role.surrogate  BEGINS ENTRY(1, iContract + "," + iContCode, " ")
          AND cust-role.Class-Code = "loan-cust-off-shore"
   NO-LOCK NO-ERROR.

   IF AVAIL cust-role THEN
      ASSIGN
         vCustCat = cust-role.cust-cat
         vCustId  = INT64(cust-role.cust-id)
         .
   ELSE
      ASSIGN
         vCustCat = b-loan.cust-cat
         vCustId  = b-loan.cust-id
         .

   CASE vCustCat:
      WHEN '�' THEN DO:
         FIND FIRST cust-corp WHERE cust-corp.cust-id = vCustId NO-LOCK NO-ERROR.
         IF AVAIL cust-corp THEN
            vOfShore = GetXAttrValueEx("cust-corp", STRING(vCustId), "����", ?).
      END.
      WHEN '�' THEN DO:
         FIND FIRST person WHERE person.person-id = vCustId NO-LOCK NO-ERROR.
         IF AVAIL person THEN
            vOfShore = GetXAttrValueEx("person", STRING(vCustId), "����", ?).
      END.
      WHEN '�' THEN DO:
         FIND FIRST banks WHERE banks.bank-id = vCustId NO-LOCK NO-ERROR.
         IF AVAIL banks THEN
            vOfShore = GetXAttrValueEx("banks", STRING(vCustId), "����", ?).
      END.
   END CASE.

   IF vOfShore <> ? AND vOfShore <> "" THEN RETURN vOfShore.

   RETURN ?.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvRate
  Name       : �����樥�� १�ࢨ஢����
  Purpose    : �����頥� ���祭�� �⠢�� १�ࢨ஢���� �� �������� ��
               㪠������ ����

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvRate RETURNS DECIMAL (
   INPUT iContract AS CHAR,
   INPUT iContCode AS CHAR,
   INPUT iDate     AS DATE
):
   DEF VAR vRate AS DEC    NO-UNDO.
   DEF VAR vPos  AS CHAR   NO-UNDO. /* ��� ����. */

   DEF BUFFER loan FOR loan. /* ���������� ����. */

                        /* �᫨ ��㤠 �室�� � ���, � ��।��塞 �⠢�� �� ����. */
   vPos = LnInBagOnDate (iContract, iContCode, iDate).

   IF     vPos NE ?
   THEN DO:
      FIND FIRST loan WHERE
               loan.contract  EQ "���"
         AND   loan.cont-code EQ vPos
      NO-LOCK NO-ERROR.
      IF AVAIL loan THEN
      DO:
         vRate = DEC (fGetBagRate ((BUFFER loan:handle), "%���", iDate, "rate-comm")).
         IF vRate EQ ? THEN
            vRate = 0.
      END.
   END.
   ELSE DO:
      /* ���� �஭������᪨ ��᫥����� �����樥�� १�ࢨ஢���� �� �������� */
      RUN GET_COMM_LOAN_BUF IN h_Loan (iContract,
                                       iContCode,
                                       "%���",
                                       iDate,
                                       BUFFER comm-rate).

      IF AVAIL comm-rate THEN vRate = comm-rate.rate-comm.
      /* ������� �� ⨯� "�祭��" -> ᬮ�ਬ ������騩 ������� */
      ELSE IF     NOT CAN-FIND(loan WHERE loan.contract  EQ iContract
                                      AND loan.cont-code EQ iContCode
                                      AND loan.cont-type = "��祭��" )
              AND NUM-ENTRIES(iContCode, " ") = 2
           THEN
              vRate = (LnRsrvRate (iContract,
                                   ENTRY(1,iContCode, " "),
                                   iDate)).
   END.
   RETURN vRate.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvRateVb
  Name       : �����樥�� १�ࢨ஢����
  Purpose    : �����頥� ���祭�� �⠢�� १�ࢨ஢���� �� ���� �ਢ易�����
               � �������� �� 㪠������ ����
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iRole       - ஫� ���
               iDate       - ��� ����樨
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvRateVb RETURNS DECIMAL (
   INPUT iContract AS CHAR,
   INPUT iContCode AS CHAR,
   INPUT iRole     AS CHAR,
   INPUT iDate     AS DATE
):
   DEF VAR vRate     AS DEC   NO-UNDO.
   DEF VAR vFindAcct AS LOG  NO-UNDO. /* �᪠�� ���. */
   DEF VAR vChkDP    AS LOG  NO-UNDO. /* �஢����� ���祭�� �� �� ���. */

   DEF BUFFER loan      FOR loan.      /* ���������� ����. */
   DEF BUFFER loan-acct FOR loan-acct. /* ���������� ����. */
   DEF BUFFER comm-rate FOR comm-rate. /* ���������� ����. */

   MAIN:
   DO:
      FIND FIRST loan WHERE
                 loan.contract  EQ iContract
             AND loan.cont-code EQ iContCode
      NO-LOCK NO-ERROR.
      IF NOT AVAIL loan THEN
         LEAVE MAIN.
      CASE FGetSetting("����������", "", ""):
         WHEN "��" THEN
            vFindAcct = TRUE.
         WHEN "���" THEN
            vFindAcct = FALSE.
         WHEN "" THEN
            ASSIGN
               vFindAcct = TRUE
               vChkDP = TRUE
            .
            /* ��, �஬� ��� */
         OTHERWISE
            vFindAcct = LnInBagOnDate (loan.contract,
                                       loan.cont-code,
                                       loan.since) EQ ?.
      END CASE.
      IF vFindAcct THEN
         /* ����砥� १�� � ��� */
      DO:
         FIND LAST loan-acct WHERE
                   loan-acct.contract  EQ iContract
               AND loan-acct.cont-code EQ iContCode
               AND loan-acct.acct-type EQ iRole
               AND loan-acct.since     LE iDate
         NO-LOCK NO-ERROR.
         IF NOT AVAIL loan-acct THEN
            LEAVE MAIN.
         IF    NOT vChkDP
            OR GetXattrValueEx("acct",
                                loan-acct.acct + "," + loan-acct.currency,
                                "��������",
                                "") EQ "��" THEN
         DO:
            FIND LAST comm-rate WHERE
                      comm-rate.commission EQ "%���"
                  AND comm-rate.filial-id = shfilial
                  AND comm-rate.branch-id = ""
                  AND comm-rate.acct       EQ loan-acct.acct
                  AND comm-rate.currency   EQ loan-acct.currency
                  AND comm-rate.kau        EQ ""
                  AND comm-rate.min-value  EQ 0.00
                  AND comm-rate.period     EQ 0
                  AND comm-rate.since      LE iDate
            NO-LOCK NO-ERROR.
            IF AVAIL comm-rate THEN
               vRate = comm-rate.rate-comm.
            LEAVE MAIN.
         END.
      END.
         /* ����砥� १�� � ������� */
      vRate = LnRsrvRate (iContract,
                          iContCode,
                          iDate).
   END.
   RETURN vRate.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnPrincipal
  Name       : �᭮���� ����
  Purpose    : �����頥� ����� ����稭� �᭮����� ����� �� �������� ��
               㪠������ ����. ��� ������஢ � �祭�ﬨ �㤥� �����饭�
               ���� �㬬� �᭮����� ����� �� �ᥬ �࠭蠬.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnPrincipal RETURNS DECIMAL (INPUT iContract AS CHAR,
                                      INPUT iContCode AS CHAR,
                                      INPUT iDate     AS DATE,
                                      INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mspar      AS CHAR NO-UNDO. /* ᯨ᮪ ��ࠬ��஢ */
   DEF VAR mi         AS INT64  NO-UNDO.
   DEF VAR mpar       AS INT64  NO-UNDO.
   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* ����� ������� */
   DEF VAR vParamSumm AS DEC  EXTENT 10 NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.
   DEF VAR oResVer    AS CHARACTER NO-UNDO .
   DEF VAR oResVerP   AS CHARACTER NO-UNDO .

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   DEFINE VARIABLE vDoc-ref AS CHAR NO-UNDO.
   vDoc-ref = b-loan.doc-ref .

   Run GetSpisBaseParam IN THIS-PROCEDURE  (OUTPUT oResVer, OUTPUT oResVerP).
   mspar = "0,7,13". /* ��ࠬ���� ��� ���� �㬬 ���⪮� */
   IF oResVer <> "" THEN mspar = Trim(oResVer,",") + "," + Trim(oResVerP,",") .
   /* ������� �� ����� ⨯ "��祭��" */
   IF b-loan.cont-type <> "��祭��" THEN DO:
       DO mi = 1 TO NUM-ENTRIES(mspar):

          mpar = INT64(ENTRY(mi,mspar)).

          RUN RE_PARAM_EX IN h_Loan (
               mpar,                    /* ��� ��ࠬ��� */
               iDate,                   /* ��� ���� */
               b-loan.since,
               iContract,               /* ��� ������� */
               iContCode,               /* ����� ������� */
               OUTPUT vParamSumm[mi],   /* �㬬� ��ࠬ��� */
               OUTPUT vDb,              /* ����� ������ */
               OUTPUT vCr).             /* �।�⮢� ������ */

          vRes = vRes + IF b-loan.Currency <> iCurrency
                        THEN CurToCurWork("����",
                                          b-loan.currency,
                                          iCurrency,
                                          iDate,
                                          vParamSumm[mi])
                        ELSE vParamSumm[mi].

       END.

       IF mIfPutPtot
          AND NOT(mIfPutNotNull
                  AND NUM-ENTRIES(vDoc-ref, " ") = 2
                  AND vRes = 0 ) THEN
       DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
              "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
              ".  ���᫥��� ��饩 ������������ �� �������� (��筮� � ����祭���) �� "
              STRING(iDate, "99/99/9999") + "."
              SKIP.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
             ".  ���᮪ ��ࠬ��஢ ������� ��� ����: "
             mspar FORMAT "x(30)"
             SKIP.
          DO mi = 1 TO NUM-ENTRIES(mspar):
              PUT STREAM out_s UNFORMATTED
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ".  ��ࠬ��� "
                 INT64(ENTRY(mi,mspar)) FORMAT ">9"
                 ". ���⮪ � ����� "
                 b-loan.Currency FORMAT "x(3)"
                 ": "
                 vParamSumm[mi] FORMAT "->>>,>>>,>>>,>>9.99"
                 SKIP.
          END.
          OUTPUT STREAM out_s CLOSE.
       END.

   END.
   ELSE
   DO:
      /* ��� ��� �祭�� �������, �஬� ��, ����� ������ ����� iDate
         ��� ������� ࠭�� iDate
      */
      IF mIfPutPtot THEN
      DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
                  "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                  ".  ���᫥��� ��饩 ������������ �� �������� (��筮� � ����祭���) �� "
                  STRING(iDate, "99/99/9999") + "."
                  SKIP.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
             ".  ������� ����� ⨯ '��祭��'. ����� ����稭� ��饩 ������������ �㤥� �믮���� �� ���稭���� ������ࠬ."
             SKIP.
          OUTPUT STREAM out_s CLOSE.
      END.

      FOR EACH b-loan WHERE
               b-loan.contract = iContract
           AND b-loan.cont-code BEGINS iContCode
           AND NUM-ENTRIES(b-loan.cont-code, " ") = 2
           AND ENTRY(1, b-loan.cont-code, " ")    = iContCode
           AND b-loan.open-date <= iDate
      NO-LOCK:

         IF b-loan.close-date <> ? AND
            b-loan.close-date <= iDate
         THEN
            NEXT.

         vRes = vRes +  LnPrincipal(b-loan.contract,
                                    b-loan.cont-code,
                                    iDate,
                                    iCurrency).

      END. /*FOR EACH*/

   END.

   mResult = CurrRound(vRes,iCurrency).

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(vDoc-ref, " ") = 2
              AND mResult = 0) THEN
   DO:
       OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
          ".  ���� ������������� �� �������� � ����� "
          iCurrency FORMAT "x(3)"
          ": "
          mResult FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.
       OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnGoodDebt
  Name       : ��筠� �������������
  Purpose    : �����頥� ����稭� ��筮� ������������ �� �������� ��
               㪠������ ����. ��� ������஢ � �祭�ﬨ �㤥� �����饭�
               ���� �㬬� ��筮� ������������ �� �ᥬ �࠭蠬.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnGoodDebt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                     INPUT iContCode AS CHAR,
                                     INPUT iDate     AS DATE,
                                     INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mspar      AS CHAR NO-UNDO. /* ᯨ᮪ ��ࠬ��஢ */
   DEF VAR mi         AS INT64  NO-UNDO.
   DEF VAR mpar       AS INT64  NO-UNDO.
   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* ����� ������� */
   DEF VAR vParamSumm AS DEC EXTENT 10 NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.
   DEF VAR oResVer AS CHARACTER NO-UNDO .
   DEF VAR oResVerP AS CHARACTER NO-UNDO .

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   DEFINE VARIABLE vDoc-ref AS CHAR NO-UNDO.
   vDoc-ref = b-loan.doc-ref .

   ASSIGN
      mspar = "0,13"              /* ��ࠬ���� ��� ���� �㬬 ���⪮� */
      mLoanCurr = b-loan.Currency.

   Run GetSpisBaseParam IN THIS-PROCEDURE  (OUTPUT oResVer, OUTPUT oResVerP).
   IF oResVer <> "" THEN mspar = Trim(oResVer,",") .



   /* ������� �� ����� ⨯ "��祭��" */
   IF b-loan.cont-type <> "��祭��" THEN DO:
       DO mi = 1 TO NUM-ENTRIES(mspar):

          mpar = INT64(ENTRY(mi,mspar)).

          RUN RE_PARAM_EX IN h_Loan (
               mpar,                    /* ��� ��ࠬ��� */
               iDate,                   /* ��� ���� */
               b-loan.since,
               iContract,               /* ��� ������� */
               iContCode,               /* ����� ������� */
               OUTPUT vParamSumm[mi],       /* �㬬� ��ࠬ��� */
               OUTPUT vDb,              /* ����� ������ */
               OUTPUT vCr).             /* �।�⮢� ������ */

          vRes = vRes + IF b-loan.Currency <> iCurrency
                        THEN CurToCurWork("����",
                                          b-loan.currency,
                                          iCurrency,
                                          iDate,
                                          vParamSumm[mi])
                        ELSE vParamSumm[mi].
       END.
       IF mIfPutPtot
           AND NOT(mIfPutNotNull
                   AND NUM-ENTRIES(vDoc-ref, " ") = 2
                   AND vRes = 0) THEN
       DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
              "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
              ".  ���᫥��� ��筮� ������������ �� �������� �� "
              STRING(iDate, "99/99/9999") + "."
              SKIP.

          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
             ".  ���᮪ ��ࠬ��஢ ������� ��� ����: "
             mspar FORMAT "x(30)"
             SKIP.

          DO mi = 1 TO NUM-ENTRIES(mspar):
              PUT STREAM out_s UNFORMATTED
                 "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
                 ".  ��ࠬ��� "
                 INT64(ENTRY(mi,mspar)) FORMAT ">>>9"
                 ". ���⮪ � ����� "
                 b-loan.Currency FORMAT "x(3)"
                 ": "
                 vParamSumm[mi] FORMAT "->>>,>>>,>>>,>>9.99"
                 SKIP.
          END.
          OUTPUT STREAM out_s CLOSE.
       END.

   END.
   ELSE
   DO:
      /* ��� ��� �祭�� �������, �஬� ��, ����� ������ ����� iDate
         ��� ������� ࠭�� iDate
      */
      IF mIfPutPtot THEN
      DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
                  "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
                  ".  ���᫥��� ��筮� ������������ �� �������� �� "
                  STRING(iDate, "99/99/9999") + "."
                  SKIP.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
             ".  ������� ����� ⨯ '��祭��'. ����� ����稭� ��筮� ������������ �㤥� �믮���� �� ���稭���� ������ࠬ."
             SKIP.
          OUTPUT STREAM out_s CLOSE.
      END.

      FOR EACH b-loan WHERE
               b-loan.contract = iContract
           AND b-loan.cont-code BEGINS iContCode
           AND NUM-ENTRIES(b-loan.cont-code, " ") = 2
           AND ENTRY(1, b-loan.cont-code, " ")    = iContCode
           AND b-loan.open-date <= iDate
      NO-LOCK:

         IF b-loan.close-date <> ? AND
            b-loan.close-date <= iDate
         THEN
            NEXT.

         vRes = vRes +  LnGoodDebt(b-loan.contract,
                                   b-loan.cont-code,
                                   iDate,
                                   iCurrency).

      END. /*FOR EACH*/

   END.

   mResult = CurrRound(vRes,iCurrency).

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(vDoc-ref, " ") = 2
              AND mResult = 0) THEN
   DO:
       OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
          ".  ��筠� ������������� �� �������� � ����� "
          iCurrency FORMAT "x(3)"
          ": "
          mResult FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.
       OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnBadDebt
  Name       : ����祭��� �������������
  Purpose    : �����頥� ����稭� ����祭��� ������������ �� ��������
               �� 㪠������ ����. ��� ������஢ � �祭�ﬨ �㤥� �����饭�
               ���� �㬬� ����祭��� ������������ �� �ᥬ �࠭蠬.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnBadDebt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                    INPUT iContCode AS CHAR,
                                    INPUT iDate     AS DATE,
                                    INPUT iCurrency AS CHAR).

   DEF VAR mPrincipalSumm AS DEC NO-UNDO.
   DEF VAR mGoodDebtSumm  AS DEC NO-UNDO.
   DEF VAR mBadDebtSumm   AS DEC NO-UNDO.

   DEFINE BUFFER b-loan FOR loan.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   ASSIGN
      mPrincipalSumm = LnPrincipal(iContract,iContCode,iDate,iCurrency)
      mGoodDebtSumm  = LnGoodDebt (iContract,iContCode,iDate,iCurrency)
      mBadDebtSumm   = mPrincipalSumm - mGoodDebtSumm
      .

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND mPrincipalSumm = 0
              AND mGoodDebtSumm = 0)  THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ���᫥��� ����祭�� ������������ �� �������� �� "
      STRING(iDate, "99/99/9999") + "."
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  [����祭��� �������������] = [���� �������������] - [��筠� �������������]"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      "."
      mBadDebtSumm   FORMAT "->>>,>>>,>>>,>>9.99"
      " = "
      mPrincipalSumm FORMAT "->>>,>>>,>>>,>>9.99"
      " - "
      mGoodDebtSumm  FORMAT "->>>,>>>,>>>,>>9.99"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����祭��� ������������� �� �������� � ����� "
      iCurrency    FORMAT "x(3)"
      ": "
      mBadDebtSumm FORMAT "->>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mBadDebtSumm.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnSyndLoan
  Name       : �ਧ��� ᨭ���஢����� ����
  Purpose    : �����頥� �ਧ��� ������� - ���� �� �� ᨭ���஢�����
               ��㤮�.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnSyndLoan RETURNS LOGICAL (INPUT iContract AS CHAR,
                                     INPUT iContCode AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN FALSE.
   END.

   IF b-loan.contract = "�।��" AND
      GetXAttrValue("loan",iContract + ',' + iContCode,"�����।") EQ "����"
   THEN
      RETURN TRUE.  /* ������� ���� ᨭ���஢����� ��㤮� */
   ELSE
   IF NUM-ENTRIES(iContCode, " ") = 2 THEN
      RETURN LnSyndLoan(iContract,ENTRY(1,iContCode," ")).
   ELSE
      RETURN FALSE.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnOptionClause
  Name       : �ਧ��� ������ ��樮���� �����ન
  Purpose    : �����頥� �ਧ��� ��樮���� �����ન �� ������⭮�� ��������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnOptionClause RETURNS LOGICAL (INPUT iContract AS CHAR,
                                         INPUT iContCode AS CHAR).

   DEF BUFFER b-loan FOR loan.
   DEF BUFFER x-loan FOR loan.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF NUM-ENTRIES(iContCode, " ") = 2 AND
      CAN-FIND( FIRST x-loan WHERE
                      x-loan.cont-type = "��祭��"
                  AND x-loan.contract  = iContract
                  AND x-loan.cont-code = ENTRY(1,iContCode, " "))
   THEN
      RETURN (LnOptionClause(iContract,ENTRY(1,iContCode, " "))).
   ELSE
      RETURN (GetXAttrValue("loan",iContract + ',' + iContCode,"Option") EQ "��").

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnPartAmt
  Name       : �㬬� �����
  Purpose    : �����頥� ��� �।�⭮�� ������� ����� �㬬� �।��,
               �ਢ��祭��� �� �⮬� �������� �� ���⭨��� ᨭ���஢������
               �।��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnPartAmt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                    INPUT iContCode AS CHAR,
                                    INPUT iDate     AS DATE,
                                    INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan     FOR loan.
   DEFINE BUFFER b-loan-up  FOR loan.

   DEFINE VAR Result-Sum   AS DEC INIT 0 NO-UNDO.
   DEFINE VAR mContract    AS CHAR NO-UNDO.
   DEFINE VAR mContCode    AS CHAR NO-UNDO.
   DEFINE VAR mIsSyndLoan  AS LOG  NO-UNDO.
   DEFINE VAR mSyndLoan    AS CHAR NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN 0.00.
   END.

   DEFINE VARIABLE vDoc-ref AS CHAR NO-UNDO.
   DEFINE VARIABLE vDoc-ref1 AS CHAR NO-UNDO.
   vDoc-ref = b-loan.doc-ref .

   IF NOT LnSyndLoan(iContract,iContCode) THEN  RETURN 0.00.

   /* ��ࠡ��뢠���� �� �������� �������, ����� ����� ��뫪� �� ⥪�騩
      ��ࠡ��뢠��� �।��� �������, �� ����� ��樮���� �����ન � �� �����
      ������饣� �������, ����� ����� ��뫪� �� �� �� �।��� �������
   */

   FOR EACH signs WHERE
      signs.file-name = "loan" AND
      signs.code = "SyndLoanId" AND
      signs.surrogate BEGINS "�����"
   NO-LOCK:

      mSyndLoan = GetXAttrValue("loan",signs.surrogate,"SyndLoanId").

      IF mSyndLoan <> iContCode THEN NEXT.

      FIND FIRST b-loan WHERE b-loan.contract = ENTRY(1,signs.surrogate) AND
                        b-loan.cont-code      = ENTRY(2,signs.surrogate)
                        NO-LOCK NO-ERROR.
      IF AVAIL b-loan THEN DO:

         IF mIfPutPtot THEN
         DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
            ".  ������ ���ᨢ�� �������, ������騩 � ᨭ���஢����� �।��: "
            b-loan.cont-code FORMAT "x(22)"
            SKIP.
         OUTPUT STREAM out_s CLOSE.
         END.

         ASSIGN
            mIsSyndLoan = mSyndLoan = iContCode
            mContract   = b-loan.Contract
            mContCode   = b-loan.Cont-Code
         .

         IF     mIfPutPtot
            AND LnOptionClause(mContract,mContCode) THEN
         DO:
            OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
            PUT STREAM out_s UNFORMATTED
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  ������� "
               b-loan.doc-ref FORMAT "X(22)"
               " ����� �ਧ��� ��樮���� �����ન. �᭮���� ���� �� �������� �� �室�� � �㬬� �����."
               SKIP.
            OUTPUT STREAM out_s CLOSE.
         END.

         IF mIsSyndLoan AND
            (NOT (LnOptionClause(mContract,mContCode)) )
         THEN
         DO:
            IF NUM-ENTRIES(b-loan.cont-code, " ") = 2
               AND
               CAN-FIND( FIRST b-loan-up
                            WHERE
                               b-loan-up.cont-type = "��祭��" AND
                               b-loan-up.contract  = b-loan.contract AND
                               b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
                       )
            THEN
            DO:
               FIND FIRST b-loan-up
                        WHERE b-loan-up.cont-type = "��祭��" AND
                              b-loan-up.contract  = b-loan.contract AND
                              b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
                     NO-LOCK NO-ERROR.

               IF GetXAttrValue("loan",b-loan-up.contract + ","
                                     + b-loan-up.cont-code,"SyndLoanId") =
                  iContCode THEN NEXT.
            END.

            Result-Sum = Result-Sum + LnPrincipal(b-loan.contract,
                                                  b-loan.cont-code,
                                                  iDate,
                                                  iCurrency
                                                 ).
         END.
      END.
   END. /*FOR EACH*/

   vDoc-ref1 = IF AVAIL b-loan THEN b-loan.doc-ref
                               ELSE "".
   IF mIfPutPtot THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " vDoc-ref1 FORMAT "X(22)"
      ".  �㬬� ����� ������� "
      vDoc-ref FORMAT "X(22)"
      " � ����� "
      iCurrency  FORMAT "x(3)"
      ": "
      Result-Sum FORMAT "->>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN Result-Sum.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnPersRisk
  Name       : �ਧ��� ������ �������㠫��� �����樥�⮢ १�ࢨ஢����
               ��� �࠭襩
  Purpose    : �����頥� �ਧ��� ������ �������㠫��� �����樥�⮢
               १�ࢨ஢���� �� �࠭蠬 �।�⭮�� ������� � �祭�ﬨ.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnPersRisk RETURNS LOGICAL (INPUT iContract AS CHAR,
                                     INPUT iContCode AS CHAR,
                                     INPUT iDate     AS DATE).
   DEFINE BUFFER b-loan  FOR loan.

   DEF VAR mPrevRsrvRate AS DEC INIT ? NO-UNDO.
   DEF VAR mNextRsrvRate AS DEC INIT ? NO-UNDO.
   DEF VAR vFirst        AS LOG        NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF b-loan.cont-type NE "��祭��" THEN RETURN FALSE.

   vFirst = YES.

   FOR EACH b-loan WHERE
            b-loan.contract  = iContract
        AND b-loan.cont-code BEGINS iContCode + " "
        AND b-loan.cont-code <> iContCode
        AND b-loan.open-date <= iDate
   NO-LOCK:

      IF b-loan.close-date <> ? AND b-loan.close-date <= iDate THEN NEXT.

      mNextRsrvRate = LnRsrvRate(b-loan.contract,b-loan.cont-code,iDate).

      IF vFirst THEN mPrevRsrvRate = mNextRsrvRate.

      IF mNextRsrvRate <> mPrevRsrvRate THEN RETURN YES.

      ASSIGN
         mPrevRsrvRate = mNextRsrvRate
         vFirst        = NO
         .

   END. /*FOR EACH*/

   RETURN NO.

END FUNCTION.


/*---------------------------------------------------------------------------
  Function   : LnRsrvCheckType
  Name       : �஢�ઠ �� ஫� ��� ������� १�ࢠ �� �����⭮� �������
  Purpose    : �஢���� - ������ �� ������ ��� १�ࢠ � ��ࠬ���� �������

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iType       - ஫� ��� १�ࢠ
  Notes      :
  ---------------------------------------------------------------------------*/

FUNCTION LnRsrvCheckType RETURNS LOGICAL (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iType     AS CHAR).

   DEF BUFFER b-loan    FOR loan.
   DEF BUFFER loan      FOR loan.
   DEF BUFFER loan-cond FOR loan-cond.

   DEF VAR oResVer AS LOGICAL NO-UNDO INIT FALSE .
   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF b-loan.cont-type = "��祭��" AND
      NOT CAN-FIND(FIRST loan-cond WHERE loan-cond.contract  = b-loan.contract
                                     AND loan-cond.cont-code = b-loan.cont-code)
                                     AND GetXAttrInit(b-loan.class-code, "NOLoanCond") NE "��"
   THEN
   DO:
      IF mIfPutPtot THEN
      DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
            ".  ������� ����� ⨯ '��祭��' � �� ����� �᫮���. ��� ������஢ ⠪��� ���� ����� ��⠥��� ࠢ�� ���."
            SKIP.
         OUTPUT STREAM out_s CLOSE.
      END.
      RETURN FALSE.
   END.

   /* ��� �࠭� , �᫨ oResVer , � �� �஢��塞 rel_type */
   IF NUM-ENTRIES(b-loan.doc-ref, " ") = 2
   THEN DO:
      RUN GetVerifyRelType IN THIS-PROCEDURE  (OUTPUT oResVer).
      IF oResVer
      THEN
         RETURN TRUE.
   END.

   /* ஫� iType �� ᮤ�ন��� � ���.���祭�� ४����� rel_type
      ����� ������� */
   IF NOT CAN-DO( GetXAttrInit(b-loan.class-code,"rel_type"), iType)
   THEN
   DO:
      IF mIfPutPtot
        AND NOT(mIfPutNotNull
                AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
      DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
            ".  ����� ������� "
            b-loan.class-code FORMAT "x(12)"
            ". ��� ������஢ �⮣� ����� ����� (" + iType + ") ��⠥��� ࠢ�� ��� (rel_type)."
            SKIP.
         OUTPUT STREAM out_s CLOSE.
      END.
      RETURN FALSE.
   END.

   IF INDEX(b-loan.cont-code," ") <> 0 THEN
   DO:
      FOR EACH loan WHERE
               loan.contract = b-loan.contract
           AND loan.cont-code = ENTRY(1,b-loan.cont-code," ")
      NO-LOCK,
         FIRST loan-cond WHERE
               loan-cond.contract  = loan.contract
           AND loan-cond.cont-code = loan.cont-code
      NO-LOCK:
         IF CAN-DO(GetXAttrInit(loan.class-code,"rel_type"), iType)
            AND GetXAttrInit(b-loan.class-code,"NOLoanCond") NE "��"
         THEN
         DO:
            IF mIfPutPtot
               AND NOT mIfPutNotNull THEN
            DO:
               OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
               PUT STREAM out_s UNFORMATTED
                  "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
                  ".  ��� ������饣� ������� "
                  loan.doc-ref FORMAT "X(22)"
                  " ����� "
                  loan.class-code FORMAT "x(12)"
                  " ��⠭����� ���� १�ࢠ (rel_type)"
                  SKIP
                  "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
                  ".  ��� ⥪�饣� ������� "
                  b-loan.doc-ref FORMAT "X(22)"
                  " ����� (" + iType + ") �� �⮩ ��稭� ��⠥��� ࠢ�� ���."
                  SKIP.
               OUTPUT STREAM out_s CLOSE.
            END.
            RETURN FALSE.
         END.
         LEAVE.
      END.
   END.

   RETURN TRUE.

END FUNCTION.


/*---------------------------------------------------------------------------
  Function   : LnRsrvCheck
  Name       : �஢�ઠ ������� १�ࢠ �� �����⭮� �������
  Purpose    : �஢���� - ������ �� ������ ��� १�ࢠ � ��ࠬ���� �������

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
  Notes      :
  ---------------------------------------------------------------------------*/

FUNCTION LnRsrvCheck RETURNS LOGICAL (INPUT iContract AS CHAR,
                                      INPUT iContCode AS CHAR).

   RETURN LnRsrvCheckType (iContract,iContCode,"�।���").

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnCalcRsrv
  Name       : ������ १��
  Purpose    : �����頥� ����稭� ���⭮�� १�ࢠ �� ��������. �᫨ ��
               ������� �� ������� ��� १�ࢠ, � �㭪�� �����頥� ����.
               �� ������ࠬ � �祭�ﬨ ����� १�� �㤥� ��।���� ���
               ��� �࠭襩 �������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnCalcRsrv RETURNS DECIMAL (INPUT iContract AS CHAR,
                                     INPUT iContCode AS CHAR,
                                     INPUT iDate     AS DATE,
                                     INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan    FOR loan.
   DEF BUFFER loan      FOR loan.
   DEF BUFFER loan-cond FOR loan-cond.

   DEF VAR mSyndLoan  AS LOG NO-UNDO.           /* �ਧ��� ᨭ���஢����� ���� */
   DEF VAR mRsrvRate  AS DEC INIT 0 NO-UNDO.    /* �����樥�� १�ࢨ஢���� */
   DEF VAR mCalcRsrv  AS DEC INIT 0 NO-UNDO.    /* ����� १�� �� ᮣ��襭�� */
   DEF VAR mBasicDebt AS DEC INIT 0 NO-UNDO.    /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mPartAmt   AS DEC INIT 0 NO-UNDO.    /* �㬬� ����� �� ᮣ��襭�� */
   DEF VAR mCalcRsrvBase AS DEC INIT 0 NO-UNDO. /* ���� ���� १�ࢠ */
   DEF VAR mResult    AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).
   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ? .
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2)  THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ���᫥��� ��饩 ����稭� ����⭮�� १�ࢠ �� "
      STRING(iDate, "99/99/9999") + "."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   IF LnRsrvCheck(iContract, iContCode) = FALSE THEN RETURN 0.00.

   {i254.i &SetCalcRsrv = "YES"}

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnCalcRsrvTransh
  Name       : ������ १�� ��� �࠭襩
  Purpose    : �����頥� ����稭� ���⭮�� १�ࢠ �� ��������. �᫨ ��
               ������� �� ������� ��� १�ࢠ, � �㭪�� �����頥� ����.
               ��� ������஢-ᮣ��襭��(⨯ ��祭��) �����頥� 0.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnCalcRsrvTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                           INPUT iContCode AS CHAR,
                                           INPUT iDate     AS DATE,
                                           INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan    FOR loan.
   DEF BUFFER loan      FOR loan.
   DEF BUFFER loan-cond FOR loan-cond.

   DEF VAR mSyndLoan  AS LOG NO-UNDO.           /* �ਧ��� ᨭ���஢����� ���� */
   DEF VAR mRsrvRate  AS DEC INIT 0 NO-UNDO.    /* �����樥�� १�ࢨ஢���� */
   DEF VAR mCalcRsrv  AS DEC INIT 0 NO-UNDO.    /* ����� १�� �� ᮣ��襭�� */
   DEF VAR mBasicDebt AS DEC INIT 0 NO-UNDO.    /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mPartAmt   AS DEC INIT 0 NO-UNDO.    /* �㬬� ����� �� ᮣ��襭�� */
   DEF VAR mCalcRsrvBase AS DEC INIT 0 NO-UNDO. /* ���� ���� १�ࢠ */
   DEF VAR mResult    AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ���᫥��� ��饩 ����稭� ����⭮�� १�ࢠ �� "
      STRING(iDate, "99/99/9999") + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   IF b-loan.cont-type = "��祭��" THEN
   DO:
      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ������� ����� ⨯ '��祭��'. ��� ������஢ ⠪��� ���� ������ १�� ��⠥��� ࠢ�� ���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN 0.00.
   END.

   {i254.i &SetCalcRsrv = "YES" &SetNotRound = "YES"}

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnPledge
  Name       : �⮨����� ��ꥪ� ���ᯥ祭��
  Purpose    : �����頥� �業���� �⮨����� ��ꥪ� ���ᯥ祭�� ��� ���
               ���祭�� �����樥�� ᭨����� �⮨���� � ������ ����⢠
               ���ᯥ祭��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iIdnt       - �����䨪���
               iEndDate    - �ப
               iNN         - ?
               iDate       - ��� ����樨
               iDateRate   - ��� ������ ����
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnPledge RETURNS DECIMAL (INPUT iContract AS CHAR,
                                   INPUT iContCode AS CHAR,
                                   INPUT iIdnt     AS INT64,
                                   INPUT iEndDate  AS DATE,
                                   INPUT iNN       AS INT64,
                                   INPUT iDate     AS DATE,
                                   INPUT iDateRate AS DATE,
                                   INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan      FOR loan.
   DEF BUFFER b-term-obl  FOR term-obl.
   DEF BUFFER b-loan-acct FOR loan-acct.
   DEF BUFFER b-acct      FOR acct.

   DEF VAR acct-ost  AS DEC INIT 0 NO-UNDO. /* ���⮪ �� ��� */
   DEF VAR mObjCost  AS DEC NO-UNDO.        /* �⮨����� ��ꥪ� ���ᯥ祭�� */
   DEF VAR vAcctType AS CHAR NO-UNDO.
   DEF VAR vTmpStr   AS CHAR NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   /* ��।��塞 ᯮᮡ �業�� ��ꥪ� ���ᯥ祭�� */
   FIND FIRST b-term-obl WHERE
              b-term-obl.contract  = b-loan.contract
          AND b-term-obl.cont-code = b-loan.cont-code
          AND b-term-obl.idnt      = iIdnt
          AND b-term-obl.end-date  = iEndDate
          AND b-term-obl.nn        = iNN
      NO-LOCK NO-ERROR.

   IF NOT AVAIL b-term-obl THEN DO:
      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "�訡��      �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ��ꥪ� ���ᯥ祭�� �� ������."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN 0.0.
   END.

   IF b-term-obl.sop-date <= iDate THEN RETURN 0.00.

   IF b-term-obl.fop-offbal = 0 THEN
   DO:
      /* ᯮᮡ �業�� ��ꥪ� ���ᯥ祭�� - "�� ������� �����" */

      /* ���� ���, �易����� � ��ꥪ⮬ ���ᯥ祭�� */

      vTmpStr = GetXAttrValueEx("term-obl",
                                   iContract + ","
                                 + iContCode + ","
                                 + STRING(b-term-obl.idnt) + ","
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "�������",
                                   "0").
      vAcctType =    GetXAttrValue("term-obl",
                                   iContract + ","
                                 + iContCode + ","
                                 + STRING(b-term-obl.idnt) + ","
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                   "��������")
                   + IF vTmpStr = "0" THEN "" ELSE vTmpStr.


      RUN RE_L_ACCT IN h_Loan (iContract,
                               iContCode,
                               vAcctType,
                               iDate,
                               BUFFER b-loan-acct).

      IF NOT AVAIL b-loan-acct THEN DO:
         IF mIfPutPtot THEN
         DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "�訡��      �������: " b-loan.doc-ref FORMAT "X(22)"
            ".  �� ������ ��� �� ஫� "
            vAcctType FORMAT "x(12)"
            SKIP.
         OUTPUT STREAM out_s CLOSE.
         END.
         RETURN 0.00.
      END.

      FIND FIRST b-acct WHERE
                 b-acct.acct     = b-loan-acct.acct
             AND b-acct.currency = b-loan-acct.currency
      NO-LOCK NO-ERROR.

      IF NOT AVAIL b-acct THEN DO:
         IF mIfPutPtot THEN
         DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "�訡��      �������: " b-loan.doc-ref FORMAT "X(22)"
            ".  �� ������ ��� " b-loan-acct.acct FORMAT "X(20)"
             " � ����� " b-loan-acct.currency
            SKIP.
         OUTPUT STREAM out_s CLOSE.
         END.
         RETURN 0.00.
      END.

      /* ����塞 ���⮪ � ����� ��� */
      RUN acct-pos IN h_base (b-loan-acct.acct, b-acct.currency,
                              iDate, iDate, CHR(251)).
      acct-ost = (IF b-acct.currency = "" THEN sh-bal ELSE sh-val ).

      IF b-acct.side = "�" THEN DO:
         acct-ost = acct-ost * -1 .
         IF acct-ost < 0 THEN RETURN 0.00. /* ����襭 ०�� ���⪠ �� ���� */
      END.

      /* �ਢ���� � ����� ������� */
      IF b-loan-acct.currency <> iCurrency THEN
         ASSIGN
            acct-ost = CurToCur("����",                                    /*⨯ ����*/
                                b-loan-acct.currency,                         /*�� ������*/
                                iCurrency,                                    /*� ������*/
                                IF iDateRate EQ ? THEN iDate ELSE iDateRate,  /*���*/
                                acct-ost)                                     /*��ॢ������ �㬬�*/

            acct-ost = CurrRound ( acct-ost, iCurrency ).

      IF mIfPutPtot
         AND NOT(mIfPutNotNull
                 AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                 AND acct-ost = 0)  THEN
      DO:
        OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
        PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ��ꥪ� ���ᯥ祭�� "
          GetXAttrValueEx ("term-obl",
                           iContract + "," + iContCode + ",5,"
                         + STRING(b-term-obl.end-date) + ","
                         + STRING(b-term-obl.nn),
                           "��������",
                           "") FORMAT "x(22)"
          " "
          STRING(b-term-obl.fop-date, "99/99/9999")
          " / "
          b-term-obl.amt-rub  FORMAT "->>>>,>>>,>>>,>>9.99"
          " "
          b-term-obl.currency FORMAT "xxx"
          " / "
          GetXAttrValueEx ("term-obl",
                           iContract + "," + iContCode + ",5,"
                         + STRING(b-term-obl.end-date) + ","
                         + STRING(b-term-obl.nn),
                           "��������",
                           "") FORMAT "x(16)"
          " "
          INT64(GetXAttrValueEx ("term-obl",
                           iContract + "," + iContCode + ",5,"
                         + STRING(b-term-obl.end-date) + ","
                         + STRING(b-term-obl.nn),
                           "�������",
                           "")) FORMAT "->,>>>,>>9"
          " (id: "
          b-term-obl.idnt FORMAT "->,>>>,>>9"
          " "
          STRING(b-term-obl.end-date, "99/99/9999")
          " "
          b-term-obl.nn FORMAT "->,>>>,>>9"
          SKIP
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ����� �⮨���� ��ꥪ� ���ᯥ祭�� �� "
          STRING(iDate, "99/99/9999") + "."
          SKIP.

        PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ���ᮡ �業��: �� ����� ���. "
         SKIP
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ". ���: "
         b-loan-acct.acct  FORMAT "x(25)"
         ". ���������� ���⪠ � ����� "
         iCurrency FORMAT "x(3)"
         ": "
         acct-ost  FORMAT "->>>>,>>>,>>>,>>9.99"
         SKIP.
        OUTPUT STREAM out_s CLOSE.
      END.

      RETURN acct-ost.
   END.

   ELSE
   DO:
      IF b-term-obl.fop-offbal = 1 OR b-term-obl.fop-offbal = 2 THEN
      DO:
         /* ᯮᮡ �業�� ��ꥪ� ���ᯥ祭�� - "�� ������������ ���������"*/
         IF b-term-obl.fop-offbal = 1 THEN
         DO:
            /* �饬 ������ � ⥪�饩 �⮨���� ��ꥪ� ���ᯥ祭�� */
            FIND LAST instr-rate
               WHERE  instr-rate.instr-cat  = "collateral_value" AND
                      instr-rate.rate-type  = "fair_value"       AND
                      instr-rate.instr-code = iContract + "," + iContCode + ","
                                            + STRING(iIdnt) + ","
                                            + STRING(iEndDate) + ","
                                            + STRING(iNN)
                      AND
                      instr-rate.since <= iDate
            /* USE-INDEX instr-date */
               NO-LOCK NO-ERROR.

            IF NOT AVAIL instr-rate THEN  RETURN 0.00.
         END.

         /* ᯮᮡ �業�� ��ꥪ� ���ᯥ祭�� - "�� �������� ���������" */
         IF b-term-obl.fop-offbal = 2 THEN
         DO:
            /* ���� �뭮筮� 業� 䨭��ᮢ��� �����㬥��, �� �����
               ��뫠���� ��ꥪ� ���ᯥ祭��
            */
            FIND LAST instr-rate WHERE
                      instr-rate.instr-cat  = b-term-obl.cor-acct  AND
                      instr-rate.rate-type  = b-term-obl.suser-id  AND
                      instr-rate.instr-code = b-term-obl.fuser-id  AND
                      instr-rate.since <= iDate
                 USE-INDEX instr-date
                 NO-LOCK NO-ERROR.

            IF NOT AVAIL instr-rate THEN  RETURN 0.00.
         END.

         /* �⮨����� ��ꥪ� ���ᯥ祭�� */
         ASSIGN
            mObjCost = instr-rate.rate-instr / instr-rate.per * b-term-obl.sop-offbal
            mObjCost = CurrRound ( mObjCost, b-term-obl.currency ).

         /* �᫨ ����室��� �ਢ���� � ����� ������� */
         IF b-term-obl.currency <> iCurrency THEN
            ASSIGN
               mObjCost = CurToCur("����",                                    /*⨯ ����*/
                                   b-term-obl.currency,                          /*�� ������*/
                                   iCurrency,                                    /*� ������*/
                                   IF iDateRate EQ ? THEN iDate ELSE iDateRate,  /*���*/
                                   mObjCost)                                     /*��ॢ������ �㬬�*/

               mObjCost = CurrRound ( mObjCost, iCurrency ).

         IF mIfPutPtot
            AND NOT(mIfPutNotNull
                    AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                    AND mObjCost = 0) THEN
         DO:
           OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
           PUT STREAM out_s UNFORMATTED
              "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
              ".  ��ꥪ� ���ᯥ祭�� "
              GetXAttrValueEx ("term-obl",
                               iContract + "," + iContCode + ",5,"
                             + STRING(b-term-obl.end-date) + ","
                             + STRING(b-term-obl.nn),
                               "��������",
                               "") FORMAT "x(22)"
              " "
              STRING(b-term-obl.fop-date, "99/99/9999")
              " / "
              b-term-obl.amt-rub  FORMAT "->>>>,>>>,>>>,>>9.99"
              " "
              b-term-obl.currency FORMAT "xxx"
              " / "
              GetXAttrValueEx ("term-obl",
                               iContract + "," + iContCode + ",5,"
                             + STRING(b-term-obl.end-date) + ","
                             + STRING(b-term-obl.nn),
                               "��������",
                               "") FORMAT "x(16)"
              " "
              INT64(GetXAttrValueEx ("term-obl",
                               iContract + "," + iContCode + ",5,"
                             + STRING(b-term-obl.end-date) + ","
                             + STRING(b-term-obl.nn),
                               "�������",
                               "")) FORMAT "->,>>>,>>9"
              " (id: "
              b-term-obl.idnt FORMAT "->,>>>,>>9"
              " "
              STRING(b-term-obl.end-date, "99/99/9999")
              " "
              b-term-obl.nn FORMAT "->,>>>,>>9"
              SKIP
              "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
              ".  ����� �⮨���� ��ꥪ� ���ᯥ祭�� �� "
              STRING(iDate, "99/99/9999") + "."
              SKIP.
           OUTPUT STREAM out_s CLOSE.
         END.

         IF b-term-obl.fop-offbal = 1
            AND mIfPutPtot
            AND NOT(mIfPutNotNull
                    AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                    AND mObjCost = 0) THEN
         DO:
            OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
            PUT STREAM out_s UNFORMATTED
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  ���ᮡ �業��: �� �������㠫쭮� �⮨����."
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  [�⮨�. ����.] = [���� �� ���-�� ������] / [���-�� ������] * [���-�� ��ꥪ⮢ ���ᯥ祭��]"
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  "
               mObjCost FORMAT "->>>>,>>>,>>>,>>9.99"
               "("
               b-term-obl.currency FORMAT "x(3)"
               ") = "
               instr-rate.rate-instr FORMAT ">>>,>>>,>>9.99999"
               " / "
               instr-rate.per FORMAT ">>>,>>9"
               " * "
               b-term-obl.sop-offbal FORMAT ">>9"
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  ���������� � ����� "
               iCurrency FORMAT "x(3)"
               ": "
               mObjCost  FORMAT "->>>>,>>>,>>>,>>9.99"
               SKIP.
            OUTPUT STREAM out_s CLOSE.
         END.

         IF b-term-obl.fop-offbal = 2
            AND mIfPutPtot
            AND NOT(mIfPutNotNull
                    AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                    AND mObjCost = 0) THEN
         DO:
            OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
            PUT STREAM out_s UNFORMATTED
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  ���ᮡ �業��: �� ���஢�� 䨭��ᮢ��� �����㬥��."
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  ��� ��: "
               b-term-obl.cor-acct FORMAT "x(25)"
               ". ��� ��: "
               b-term-obl.fuser-id FORMAT "x(10)"
               ". ��� ���஢��: "
               b-term-obl.suser-id FORMAT "x(10)"
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  [�⮨�. ����.] = [���� �� ���-�� ������] / [���-�� ������] * [���-�� ��ꥪ⮢ ���ᯥ祭��]"
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  "
               mObjCost FORMAT "->>>>,>>>,>>>,>>9.99"
               "("
               b-term-obl.currency FORMAT "x(3)"
               ") = "
               instr-rate.rate-instr FORMAT ">>>,>>>,>>9.99999"
               " / "
               instr-rate.per FORMAT ">>>,>>9"
               " * "
               b-term-obl.sop-offbal FORMAT ">>9"
               SKIP
               "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
               ".  ���������� � ����� "
               iCurrency FORMAT "x(3)"
               ": "
               mObjCost  FORMAT "->>>>,>>>,>>>,>>9.99"
               SKIP.
            OUTPUT STREAM out_s CLOSE.
         END.

         RETURN mObjCost.

      END. /* fop-offbal = 1 or fop-offbal = 2 */

   END.

   RETURN 0.00.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : Get_QualityGar
  Name       : ���祭�� ��⥣�ਨ ����⢠ ���ᯥ祭��
  Purpose    : ����祭�� ���祭�� ��⥣�ਨ ����� ���ᯥ祭��, ����������
               �� ��।������� ����
  Parameters : iFileName  - ⠡���
               iSurrogate - ���ண�� ������� ���ᯥ祭��
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION Get_QualityGar RETURNS CHAR (INPUT iFileName  AS CHAR,
                                      INPUT iSurrogate AS CHAR,
                                      INPUT iSince     AS DATE).

   DEF BUFFER xterm-obl FOR term-obl.

   DEF VAR vReturn AS CHAR NO-UNDO INIT ?.
   DEF VAR vCRSurr AS CHAR NO-UNDO.

   /* �饬 �㦭� term-obl */
   FIND FIRST xterm-obl WHERE xterm-obl.contract  EQ ENTRY(1,iSurrogate)
                          AND xterm-obl.cont-code EQ ENTRY(2,iSurrogate)
                          AND xterm-obl.idnt      EQ INT64(ENTRY(3,iSurrogate))
                          AND xterm-obl.end-date  EQ DATE(ENTRY(4,iSurrogate))
                          AND xterm-obl.nn        EQ INT64(ENTRY(5,iSurrogate))
      NO-LOCK NO-ERROR.

   IF AVAIL xterm-obl THEN
   DO:
      /* �饬 comm-rate */
      FOR EACH comm-rate WHERE comm-rate.commission EQ "��玡�ᯥ�"
                           AND comm-rate.acct       EQ "0"
                           AND comm-rate.currency   EQ xterm-obl.currency
                           AND comm-rate.kau        EQ iSurrogate
                           AND comm-rate.min-value  EQ 0
                           AND comm-rate.period     EQ 0
                           AND comm-rate.since      LE iSince USE-INDEX kau NO-LOCK BY comm-rate.since DESCENDING:
          LEAVE.
      END.
      /* �᫨ �� ����, � ��।��塞 ���祭�� ��⥣�ਨ ����⢠
      ** �� ᮮ⢥�����饬� �� */
      IF AVAIL comm-rate THEN
      DO:
         vReturn = GetXAttrValueEx("comm-rate",STRING(comm-rate.comm-rate-id),"��玡�ᯥ�","?").
      END.
   END.

   RETURN vReturn.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : Get_VidObespech
  Name       : ���祭�� ���� ���ᯥ祭�� �� ��⥣�ਨ ����⢠
  Purpose    : ����祭�� ���祭�� ���� ���ᯥ祭��, ����������
               �� ��।������� ����
  Parameters : iSurrogate - ���ண�� ������� ���ᯥ祭��
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION Get_VidObespech RETURNS CHAR (INPUT iSurrogate AS CHAR,
                                       INPUT iSince     AS DATE).

   DEF BUFFER xterm-obl FOR term-obl.

   DEF VAR vReturn AS CHAR NO-UNDO INIT "?".
   DEF VAR vCRSurr AS CHAR NO-UNDO.

   /* �饬 �㦭� term-obl */
   FIND FIRST xterm-obl WHERE xterm-obl.contract  EQ ENTRY(1,iSurrogate)
                          AND xterm-obl.cont-code EQ ENTRY(2,iSurrogate)
                          AND xterm-obl.idnt      EQ INT64(ENTRY(3,iSurrogate))
                          AND xterm-obl.end-date  EQ DATE(ENTRY(4,iSurrogate))
                          AND xterm-obl.nn        EQ INT64(ENTRY(5,iSurrogate))
      NO-LOCK NO-ERROR.

   IF AVAIL xterm-obl THEN
   DO:
      /* �饬 comm-rate */
      FOR EACH comm-rate WHERE comm-rate.commission EQ "��玡�ᯥ�"
                           AND comm-rate.acct       EQ "0"
                           AND comm-rate.currency   EQ xterm-obl.currency
                           AND comm-rate.kau        EQ iSurrogate
                           AND comm-rate.min-value  EQ 0
                           AND comm-rate.period     EQ 0
                           AND comm-rate.since      LE iSince USE-INDEX kau NO-LOCK BY comm-rate.since DESCENDING:
          LEAVE.
      END.
      /* �᫨ �� ����, � ��।��塞 ���祭�� ���� ���ᯥ祭��
      ** �� ᮮ⢥�����饬� �� */
      IF AVAIL comm-rate THEN
      DO:
         vReturn = GetXAttrValueEx("comm-rate",STRING(comm-rate.comm-rate-id),"�117_�����","?").
      END.
   END.

   RETURN vReturn.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : GetLast_QualityGar
  Name       : ���祭�� ��⥣�ਨ ����⢠ ���ᯥ祭��
  Purpose    : ����祭�� ���祭�� ��⥣�ਨ ����� ���ᯥ祭��, ��᫥�����
               ��⠭���������
  Parameters : iFileName  - ⠡���
               iSurrogate - ���ண�� ������� ���ᯥ祭��
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION GetLast_QualityGar RETURNS CHAR (INPUT iFileName  AS CHAR,
                                          INPUT iSurrogate AS CHAR).

   DEF BUFFER xterm-obl FOR term-obl.

   DEF VAR vReturn AS CHAR NO-UNDO INIT "?".
   DEF VAR vCRSurr AS CHAR NO-UNDO.

   /* �饬 �㦭� term-obl */
   FIND FIRST xterm-obl WHERE xterm-obl.contract  EQ ENTRY(1,iSurrogate)
                          AND xterm-obl.cont-code EQ ENTRY(2,iSurrogate)
                          AND xterm-obl.idnt      EQ INT64(ENTRY(3,iSurrogate))
                          AND xterm-obl.end-date  EQ DATE(ENTRY(4,iSurrogate))
                          AND xterm-obl.nn        EQ INT64(ENTRY(5,iSurrogate))
      NO-LOCK NO-ERROR.

   IF AVAIL xterm-obl THEN
   DO:
      /* �饬 comm-rate */
      FOR EACH comm-rate WHERE comm-rate.commission EQ "��玡�ᯥ�"
                           AND comm-rate.acct       EQ "0"
                           AND comm-rate.currency   EQ xterm-obl.currency
                           AND comm-rate.kau        EQ iSurrogate
                           AND comm-rate.min-value  EQ 0
                           AND comm-rate.period     EQ 0 USE-INDEX kau NO-LOCK BY comm-rate.since DESCENDING:
          LEAVE.
      END.
      /* �᫨ �� ����, � ��।��塞 ���祭�� ��⥣�ਨ ����⢠
      ** �� ᮮ⢥�����饬� �� */
      IF AVAIL comm-rate THEN
      DO:
         vReturn = GetXAttrValueEx("comm-rate",STRING(comm-rate.comm-rate-id),"��玡�ᯥ�","?").
      END.
   END.

   RETURN vReturn.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : Set_QualityGar
  Name       : ��⠭���� ��⥣�ਨ ����⢠ �� ���ᯥ祭��
  Purpose    : �����뢠�� � �㦭�� ���� ���ଠ�� � ��⥣�ਨ ����⢠
               ���ᯥ祭��
  Parameters : iFileName  - ⠡���
               iSurrogate - ���ண�� ������� ���ᯥ祭��
               iValue     - ���祭�� ��⥣�ਨ ����⢠ ��� �����
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION Set_QualityGar RETURNS LOGICAL (INPUT iFileName  AS CHAR,
                                         INPUT iSurrogate AS CHAR,
                                         INPUT iValue     AS CHAR).

    DEF BUFFER xterm-obl FOR term-obl.
    DEF BUFFER comm-rate FOR comm-rate. /* ���������� ����. */

    DEF VAR vReturn  AS LOG    NO-UNDO.
    DEF VAR vCRSurr  AS CHAR   NO-UNDO.
    DEF VAR vComRate AS ROWID  NO-UNDO. /* ROWID comm-rate. */

    /* �饬 �㦭� term-obl */
    FIND FIRST xterm-obl WHERE xterm-obl.contract  EQ ENTRY(1,iSurrogate)
                           AND xterm-obl.cont-code EQ ENTRY(2,iSurrogate)
                           AND xterm-obl.idnt      EQ INT64(ENTRY(3,iSurrogate))
                           AND xterm-obl.end-date  EQ DATE(ENTRY(4,iSurrogate))
                           AND xterm-obl.nn        EQ INT64(ENTRY(5,iSurrogate))
       NO-LOCK NO-ERROR.

    IF AVAIL xterm-obl THEN
    blck:
    DO ON ERROR UNDO, LEAVE:

       /* ��� �㦭��� term-obl ᮧ���� comm-rate ��玡�ᯥ� */
       FIND FIRST comm-rate WHERE comm-rate.commission EQ "��玡�ᯥ�"
                              AND comm-rate.acct       EQ "0"
                              AND comm-rate.currency   EQ xterm-obl.currency
                              AND comm-rate.kau        EQ iSurrogate
                              AND comm-rate.min-value  EQ 0
                              AND comm-rate.period     EQ 0
                              AND comm-rate.since      EQ xterm-obl.fop-date USE-INDEX kau NO-ERROR.
       IF NOT AVAIL comm-rate THEN
       DO:
          CREATE comm-rate.
          ASSIGN
             comm-rate.commission = "��玡�ᯥ�"
             comm-rate.acct       = "0"
             comm-rate.currency   = xterm-obl.currency
             comm-rate.kau        = iSurrogate
             comm-rate.min-value  = 0
             comm-rate.period     = 0
             comm-rate.since      = xterm-obl.fop-date
             vComRate             = ROWID (comm-rate)
          NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
             LEAVE blck.
          RELEASE comm-rate NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
             LEAVE blck.

          FIND FIRST comm-rate WHERE ROWID (comm-rate) EQ vComRate
          NO-LOCK.

          vCRSurr = GetSurrogateBuffer("comm-rate",(BUFFER comm-rate:HANDLE)).

          /* �����뢠�� class-code */
          IF NOT UpdateSigns("��玡�ᯥ�",vCRSurr,"class-code","��玡�ᯥ�",?) THEN
          DO:
             RUN Fill-SysMes IN h_tmess ("","","1","�� 㤠���� �������� �� class-code �� ����� comm-rate. �����䨪��� �����:" + vCRSurr).
             LEAVE blck.
          END.

       END.
       ELSE
          vCRSurr = GetSurrogateBuffer("comm-rate",(BUFFER comm-rate:HANDLE)).
       /* �����뢠�� � �� comm-rate'a �㦭�� ��⥣��� ����⢠ */
       vReturn = UpdateSigns ("��玡�ᯥ�",vCRSurr,"��玡�ᯥ�",iValue,?).
    END.

    RETURN vReturn.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnCollateralValueAllEx
  Name       : �㬬� ���ᯥ祭�� �� ��㤥
  Purpose    : ������ ����� �㬬� ���ᯥ祭�� �� 㪠������� �������� �
               ��⮬ ������ ����⢠ ���ᯥ祭�� � �����樥�� ᭨�����
               �⮨���� ���ᯥ祭��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iDateRate   - ��� ������ ����
               iCurrency   - ��� ������
               iTypeCalc   - "all" - �� �墠�. �������� + �祭��
                             "one" - �� ������ �����⭮�� ��������
               iFlKK       - ���뢠�� �� ���ᯥ祭��?
               iFlGQIndex  - ���뢠�� ����-� ᭨����� �⮨���� ���ᯥ祭��?
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnCollateralValueAllEx RETURNS DECIMAL (INPUT iContract  AS CHAR,
                                                 INPUT iContCode AS CHAR,
                                                 INPUT iDate     AS DATE,
                                                 INPUT iDateRate AS DATE,
                                                 INPUT iCurrency AS CHAR,
                                                 INPUT iTypeCalc  AS CHAR,
                                                 INPUT iFlKK      AS LOG,
                                                 INPUT iFlGQIndex AS LOG).
   DEF BUFFER b-loan      FOR loan.
   DEF BUFFER b-term-obl  FOR term-obl.

   DEF VAR mDRGQ     AS CHAR NO-UNDO. /*�� term-obl.����⢮���� */
   DEF VAR mDRInDate AS CHAR NO-UNDO. /*�� term-obl.��⠏��� */
   DEF VAR mGQIndex  AS DEC  NO-UNDO. /*������ ����⢠ ���ᯥ祭��*/
   DEF VAR mDecrRate AS DEC  NO-UNDO. /*�����樥�� ᭨����� ����⢠ ���ᯥ祭��*/
   DEF VAR mGObjCost AS DEC  NO-UNDO. /*�⮨����� ��ꥪ� ���ᯥ祭��*/
   DEF VAR mGOSumm   AS DEC  NO-UNDO. /*�㬬� ���ᯥ祭�� �� ��ꥪ��*/
   DEF VAR mGQCode   AS CHAR NO-UNDO.
   DEF VAR mTotSumm  AS DEC  NO-UNDO.
   DEF VAR vFlKK     AS CHAR NO-UNDO.
   
   vFlKK = GetSysConf("���_���_��⥣�ਨ_����⢠").
   IF vFlKK EQ "yes" 
   THEN
      iFlKK = NO.
   ASSIGN
      iFlKK      = YES WHEN iFlKK      EQ ?
      iFlGQIndex = YES WHEN iFlGQIndex EQ ?
   .

   {empty tt-Loan}
   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
     OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
     PUT STREAM out_s UNFORMATTED
        "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
        ".  ����� �⮨���� ���ᯥ祭�� �� �������� �� "
        STRING(iDate, "99/99/9999") + "."
     SKIP.
     OUTPUT STREAM out_s CLOSE.
   END.
   
   IF b-loan.open-date <= iDate THEN DO:
      CREATE tt-Loan.
      ASSIGN
         tt-Loan.ContCode = b-loan.cont-code
         tt-Loan.DocRef   = b-loan.doc-ref
         .
   END.
      
   IF iTypeCalc  = "all" THEN DO:
      FOR EACH b-loan WHERE
               b-loan.contract  = iContract
           AND b-loan.cont-code = ENTRY(1, iContCode, " ")
           AND b-loan.open-date <= iDate
      NO-LOCK:
         FIND FIRST tt-loan WHERE
                    tt-Loan.ContCode = b-loan.cont-code
         NO-ERROR.
         IF NOT AVAIL tt-loan THEN DO:
            CREATE tt-Loan.
            ASSIGN
               tt-Loan.ContCode = b-loan.cont-code
               tt-Loan.DocRef   = b-loan.doc-ref
               .
         END.
      END.
      
      FOR EACH b-loan WHERE
               b-loan.contract = iContract
           AND b-loan.cont-code BEGINS (ENTRY(1, iContCode, " ") + " ")
           AND b-loan.open-date <= iDate
      NO-LOCK:
         FIND FIRST tt-loan WHERE
                    tt-Loan.ContCode = b-loan.cont-code
         NO-ERROR.
         IF NOT AVAIL tt-loan THEN DO:
            CREATE tt-Loan.
            ASSIGN
               tt-Loan.ContCode = b-loan.cont-code
               tt-Loan.DocRef   = b-loan.doc-ref
               .
         END.
      END.
   END.

   FOR EACH tt-Loan:
      FOR EACH b-term-obl WHERE
         b-term-obl.contract  = iContract AND
         b-term-obl.cont-code = tt-Loan.ContCode AND
         b-term-obl.idnt      = 5         AND
         ( NOT (b-term-obl.sop-date <> ? AND b-term-obl.sop-date <= iDate) )
      NO-LOCK:

         ASSIGN
            /* ���祭�� �� ����⢮���� */
            mDRGQ = Get_QualityGar("comm-rate",
                                   iContract + "," + tt-Loan.ContCode + ","
                                   + STRING(b-term-obl.idnt) + ","
                                   + STRING(b-term-obl.end-date) + ","
                                   + STRING(b-term-obl.nn),
                                   iDate)

            /* ���祭�� �� "��⠏��� */
            mDRInDate = GetXAttrValue("term-obl",
                                      iContract + "," + tt-Loan.ContCode + ","
                                      + STRING(b-term-obl.idnt) + ","
                                      + STRING(b-term-obl.end-date) + ","
                                      + STRING(b-term-obl.nn),
                                      "��⠏���").

         IF    (    mDRInDate       NE ?
                AND mDRInDate       NE "?"
                AND mDRInDate       NE ""
                AND DATE(mDRInDate) GT iDate)
            OR mDRGQ = "?"
            OR mDRGQ = ?
            OR mDRGQ = ""
         THEN
            NEXT.

         /* ���뢠�� ��⥣��� ����⢠: �᫨ ��, ��।��塞 ������ ��, �᫨ ��� - ������ = 100 */
         IF iFlKK THEN
         DO:
            /* ������ ����⢠ ���ᯥ祭�� �� �����䨪���� "����⢮����"*/
            mGQIndex  = DEC(GetCode("����⢮����", mDRGQ )).

            IF mGQIndex < 0 OR mGQIndex > 100 THEN DO:
               IF mIfPutPtot THEN
               DO:
                  OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
                  PUT STREAM out_s UNFORMATTED
                  "�訡��      �������: " tt-Loan.DocRef FORMAT "X(22)"
                  ".  �����४⭮� ���祭�� ������ ����⢠ ���ᯥ祭��. ���祭�� ������ ����⢠ ���ᯥ祭�� �ਭ������� ࠢ�� ���."
                  SKIP.
                  OUTPUT STREAM out_s CLOSE.
               END.
               mGQIndex = 0.
            END.
         END.
         ELSE
            mGQIndex = 100.

         IF iFlGQIndex THEN
            /* mDecrRate - �����.᭨����� �⮨���� ���ᯥ祭�� (�믮������ ����
               �����樥��, ��⠭��������� �� ��ꥪ�� ���ᯥ祭�� �� ���� iDate)
            */
            mDecrRate = GET_COMM("����",
                                 ?,
                                 b-term-obl.currency,
                                 iContract + "," + tt-Loan.ContCode + ","
                                 + STRING(b-term-obl.idnt) + ","
                                 + STRING(b-term-obl.end-date) + ","
                                 + STRING(b-term-obl.nn),
                                 0.00,
                                 0,
                                 iDate).
         ELSE
            mDecrRate = 100.

         IF mDecrRate = ? THEN mDecrRate = 100.
         IF mGQIndex  = ? THEN mGQIndex  = 0.

         ASSIGN
            /* �⮨����� ��ꥪ� ���ᯥ祭�� */
            mGObjCost = LnPledge(iContract, tt-Loan.ContCode, b-term-obl.idnt,
                                 b-term-obl.end-date, b-term-obl.nn,
                                 iDate, iDateRate,iCurrency)
            /* �㬬� ���ᯥ祭�� �� ��ꥪ�� */
            mGOSumm  = mGObjCost * mGQIndex / 100 * mDecrRate / 100
            mGOSumm  = CurrRound ( mGOSumm, iCurrency )
            mTotSumm = mTotSumm + mGOSumm
         .
         IF mIfPutPtot
            AND NOT(mIfPutNotNull
                    AND NUM-ENTRIES(tt-Loan.DocRef, " ") = 2
                    AND mGOSumm = 0) THEN
         DO:
             OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
             PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " tt-Loan.DocRef FORMAT "X(22)"
             ".  [�⮨�. ����. ���.] = [�⮨�. ��ꥪ� ����.] * [������ ����⢠] * [����. ����筮� �⮨�.]"
             SKIP
             "���ଠ��  �������: " tt-Loan.DocRef FORMAT "X(22)"
             "."
             mGOSumm   FORMAT "->>>>,>>>,>>>,>>9.99"
             " = "
             mGObjCost FORMAT "->>>>,>>>,>>>,>>9.99"
             " * "
             mGQIndex  FORMAT "->>>>,>>>,>>>,>>9.99"
             " % * "
             mDecrRate FORMAT "->>>>,>>>,>>>,>>9.99"
             SKIP.
             OUTPUT STREAM out_s CLOSE.
         END.
      END. /*FOR EACH*/

      IF mIfPutPtot
         AND NOT(mIfPutNotNull
             AND NUM-ENTRIES(tt-Loan.DocRef, " ") = 2
             AND mTotSumm = 0) THEN
      DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " tt-Loan.DocRef FORMAT "X(22)"
         ".  �⮨����� ���ᯥ祭�� �� �������� � ����� "
         iCurrency FORMAT "x(3)"
         ": "
         mTotSumm  FORMAT "->>>>,>>>,>>>,>>9.99999"
         SKIP.
         OUTPUT STREAM out_s CLOSE.
      END.

   END. /* LOAN */

   RETURN mTotSumm.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnCollateralValueAll
  Name       : �㬬� ���ᯥ祭�� �� ��㤥
  Purpose    : ������ ����� �㬬� ���ᯥ祭�� �� 㪠������� �������� �
               ��⮬ ������ ����⢠ ���ᯥ祭�� � �����樥�� ᭨�����
               �⮨���� ���ᯥ祭��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iDateRate   - ��� ������ ����
               iCurrency   - ��� ������
               iTypeCalc   - "all" - �� �墠�. �������� + �祭��
                             "one" - �� ������ �����⭮�� ��������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnCollateralValueAll RETURNS DECIMAL (INPUT iContract AS CHAR,
                                               INPUT iContCode AS CHAR,
                                               INPUT iDate     AS DATE,
                                               INPUT iDateRate AS DATE,
                                               INPUT iCurrency AS CHAR,
                                               INPUT iTypeCalc AS CHAR).
   RETURN LnCollateralValueAllEx(iContract,
                                 iContCode,
                                 iDate,
                                 iDateRate,
                                 iCurrency,
                                 iTypeCalc,
                                 YES,
                                 YES).
END FUNCTION.

/*----------------------------------------------------------------------------
  Procedure  : LnCollateralValueEx
  Purpose    : ������ ���� �㬬� ���ᯥ祭�� ��� �⭥ᥭ�� � �᭮����� �����
               � � �᫮��� ��易⥫��⢠�.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iDateRate   - ��� ������ ����
               iCurrency   - ��� ������
               oAmtLoan    - ���� �㬬� ���ᯥ祭�� �� �᭮����� �����
               oAmtAcct    - ���� �㬬� ���ᯥ祭�� �� �᫮��� ��易⥫��⢠�
  Notes      :
  ----------------------------------------------------------------------------*/
PROCEDURE LnCollateralValueEx.

    DEF INPUT  PARAM iContract AS CHAR NO-UNDO.
    DEF INPUT  PARAM iContCode AS CHAR NO-UNDO.
    DEF INPUT  PARAM iDate     AS DATE NO-UNDO.
    DEF INPUT  PARAM iDateRate AS DATE NO-UNDO.
    DEF INPUT  PARAM iCurrency AS CHAR NO-UNDO.
    DEF OUTPUT PARAM oAmtLoan  AS DEC  NO-UNDO.
    DEF OUTPUT PARAM oAmtAcct  AS DEC  NO-UNDO.

    DEF VAR vObespSumm   AS DEC  NO-UNDO.
    DEF VAR vAcctSumm    AS DEC  NO-UNDO.
    DEF VAR mLnkContCode AS CHAR NO-UNDO.
    DEF VAR vODSumm      AS DEC  NO-UNDO.
    DEF VAR i            AS INT64  NO-UNDO.
    DEF VAR vCalcMeth    AS CHAR NO-UNDO. /* �� ���ᮡ���� */
    DEF VAR vDoc-ref     AS CHAR NO-UNDO.
    DEF VAR vRoleSchVn   AS CHAR   NO-UNDO. 

    DEF BUFFER loan FOR loan.

    mb:
    DO ON ERROR UNDO, LEAVE:
 
       FIND FIRST loan WHERE
                 loan.contract  EQ iContract
             AND loan.cont-code EQ iContCode
       NO-LOCK NO-ERROR. 
       IF AVAIL loan THEN
          vDoc-ref = loan.doc-ref.
       vCalcMeth = GetXattrValueEx("loan",
                                   iContract + "," + iContCode,
                                   "���ᮡ����",
                                   "").
       IF NOT {assigned vCalcMeth} THEN
       DO:
          IF NOT AVAIL loan THEN
             LEAVE mb.
          vCalcMeth = GetXAttrInit(loan.class-code,
                                   "���ᮡ����").
          IF NOT {assigned vCalcMeth} THEN
             vCalcMeth = FGetSetting("���玡��", "���ᮡ����", ?). 
       END.

       /* ��।���� ���祭�� ����஥筮�� ��ࠬ��� ���玡��/����炭 */
       ASSIGN 
          vRoleSchVn    = FGetSetting("���玡��", "����炭", "").

       IF vCalcMeth EQ "�ய��樮���쭮" OR
          vCalcMeth EQ "�� �ॢ�襭��" THEN
       DO:
          ASSIGN
             vObespSumm = LnCollateralValueAll(iContract,iContCode,iDate,iDateRate,iCurrency,"all")
             oAmtLoan   = vObespSumm
          .

          /* �஢��塞 �ਭ���������� � ��� */
          mLnkContCode = LnInBagOnDate(iContract,
                                       ENTRY(1, iContCode, " "),
                                       iDate).

          IF mLnkContCode <> ? THEN
          DO:
             /* �᫨ �� ֐���࢏��� = ք��, � ��� ����䥫쭮� ���� ���ᯥ祭�� ��
                ���뢠���� ���� �� �� ᯮᮡ� ��।������ ���ᯥ祭�� (�.�. �㬬�
                ���ᯥ祭�� ��� �᭮����� ����� � ��� ��������� ࠢ�� 0). */
             IF FGetSetting("����࢏��",?,?) EQ "��" THEN
             DO:
                ASSIGN
                   oAmtLoan = 0
                   oAmtAcct = 0
                .
                LEAVE mb.
             END.
          END.

          /* �� ஫� ��⮢ �� �� - �饬 �� ��ࢮ�� ��������� ��� - ��� */
          sb:
          DO i = 1 TO NUM-ENTRIES(vRoleSchVn):
             FIND LAST loan-acct WHERE loan-acct.contract  EQ iContract
                                   AND loan-acct.cont-code EQ ENTRY(1, iContCode, " ")
                                   AND loan-acct.acct-type EQ ENTRY(i, vRoleSchVn)
                                   AND loan-acct.since     LE iDate
             NO-LOCK NO-ERROR.
             IF AVAIL loan-acct THEN
                LEAVE sb.
          END. /* sb */

          /* �᫨ ��� ⠪ � �� ��諨, � ��� �㬬� �⭮���� � �᭮����� ����� */
          IF NOT AVAIL loan-acct THEN
             LEAVE mb.

          /* ����塞 ���⮪ �� ��������� ���, �᫨ �� ࠢ�� 0, �
          ** ��� �㬬� �⭮���� � �᭮����� ����� */
          RUN acct-pos IN h_base (loan-acct.acct,loan-acct.currency,iDate,iDate,gop-status).
          vAcctSumm = IF loan-acct.currency EQ ""
                         THEN ABS(sh-bal)
                         ELSE ABS(sh-val) * findratesimple ('����',
                                                            loan-acct.currency,
                                                            iDate).
          IF vAcctSumm EQ 0 THEN
             LEAVE mb.

          /* ����塞 �㬬� �᭮����� ����� �� ��㤥, �᫨ �� ࠢ�� 0, �
          ** ��� �㬬� �⭮���� � �᫮��� ��易⥫��⢠� */
          vODSumm = LnPrincipal (iContract,
                                 ENTRY(1, iContCode, " "),
                                 iDate,
                                 "").

          IF vODSumm EQ 0 THEN
          DO:
             ASSIGN
                oAmtLoan = 0
                oAmtAcct = vObespSumm
             .
             LEAVE mb.
          END.

          IF vCalcMeth EQ "�ய��樮���쭮" THEN
          DO:
             /* �᫨ ��諨 �� �஢�ન � ���票� �� - "�ய��樮���쭮", ����� ����� �㬬� */
             /* �᫨ � �������⥫� ���� ��� ����.�᫮, � �� ���� ࠢ�� ��� */
             IF vODSumm + vAcctSumm LE 0 THEN
                oAmtLoan = 0.
             ELSE
                oAmtLoan = vObespSumm * vODSumm / ( vODSumm + vAcctSumm ).

             oAmtAcct = vObespSumm - oAmtLoan.
          END.
          ELSE /* �� - "�� �ॢ�襭��" */
             IF vObespSumm LE vODSumm THEN
                ASSIGN
                   oAmtLoan = vObespSumm
                   oAmtAcct = 0
                .
             ELSE
                ASSIGN
                   oAmtLoan = vODSumm
                   oAmtAcct = vObespSumm - vODSumm
                   oAmtAcct = IF oAmtAcct GT vAcctSumm THEN vAcctSumm
                                                       ELSE oAmtAcct
                .
       END.
       ELSE
          ASSIGN
             vObespSumm = LnCollateralValueAll(iContract,iContCode,iDate,iDateRate,iCurrency,"one")
             oAmtLoan   = vObespSumm
          .
       
       IF mIfPutPtot THEN
       DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
             ". ���ᮡ���� = " vCalcMeth SKIP.
          if vCalcMeth EQ "�ய��樮���쭮" THEN
             PUT STREAM out_s UNFORMATTED
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ". [����� �㬬� ����.�� ��] = ([���.�㬬� ����.] * [�㬬� ��]) / ([�㬬� ��] + [���.�� ���� � ஫ﬨ � �� ����炭]) "
                 oAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
                 " = ("
                 vObespSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 " * "
                 vODSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 ") / ("
                 vODSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 " + "
                 vAcctSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 ")" SKIP
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ". [����� �㬬� ����.�� ��] = [���.�㬬� ����.] - [����� �㬬� ����.�� ��] "
                 oAmtAcct FORMAT "->>>>,>>>,>>>,>>9.99"
                 " = "
                 vObespSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 " - "
                 oAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
                 SKIP.
          ELSE if vCalcMeth EQ "�� �ॢ�襭��" then
             PUT STREAM out_s UNFORMATTED
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ". [����� �㬬� ����.�� ��] = MIN([���.�㬬� ����.],[�㬬� ��]) "
                 oAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
                 " = MIN("
                 vObespSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 ","
                 vODSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 ")" SKIP
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ". [����� �㬬� ����.�� ��] = [���.�㬬� ����.] - [����� �㬬� ����.�� ��] "
                 oAmtAcct FORMAT "->>>>,>>>,>>>,>>9.99"
                 " = "
                 vObespSumm FORMAT "->>>>,>>>,>>>,>>9.99"
                 " - "
                 oAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
                 SKIP.
          ELSE
             PUT STREAM out_s UNFORMATTED
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ". [����� �㬬� ����.�� ��] = [���.�㬬� ����.] "
                 oAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
                 " = "
                 vObespSumm FORMAT "->>>>,>>>,>>>,>>9.99" SKIP
                 "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                 ". [����� �㬬� ����.�� ��] = 0 "
                 oAmtAcct FORMAT "->>>>,>>>,>>>,>>9.99"
                 " = "
                 "0" FORMAT "->>>>,>>>,>>>,>>9.99"
                 SKIP.
          OUTPUT STREAM out_s CLOSE.
       END.
    END. /* mb */

END PROCEDURE.

/*---------------------------------------------------------------------------
  Function   : LnCollateralValue
  Name       : �㬬� ���ᯥ祭�� �� ��㤥
  Purpose    : ������ ���� �㬬� ���ᯥ祭�� �� �᭮����� ����� �� 㪠�������
               �������� � ��⮬ ������ ����⢠ ���ᯥ祭�� � �����樥�� ᭨�����
               �⮨���� ���ᯥ祭��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnCollateralValue RETURNS DECIMAL (INPUT iContract AS CHAR,
                                            INPUT iContCode AS CHAR,
                                            INPUT iDate     AS DATE,
                                            INPUT iCurrency AS CHAR).
   DEF VAR oLoanObesp AS DEC  NO-UNDO.
   DEF VAR vAmtLoan   AS DEC  NO-UNDO.
   DEF VAR vAmtAcct   AS DEC  NO-UNDO.
   DEF VAR vTrObesp   AS DEC  NO-UNDO.
   DEF VAR vCorrFlg   AS LOG  NO-UNDO.
   DEF VAR vCalcMeth  AS CHAR NO-UNDO. /* �� ���ᮡ���� */
   DEF VAR vDoc-ref   AS CHAR NO-UNDO.
   DEF BUFFER b-loan  FOR loan.
   DEF BUFFER z-loan  FOR loan.

   MAIN:
   DO ON ERROR UNDO, LEAVE:
      
      FIND FIRST b-loan WHERE
                 b-loan.contract  EQ iContract
             AND b-loan.cont-code EQ iContCode
      NO-LOCK NO-ERROR.
      IF AVAIL b-loan THEN
         vDoc-ref = b-loan.doc-ref.
         /* ����塞 �㬬� ���ᯥ祭�� �� (�᭮����� �����) � �� (�᫮���� ��易⥫���) */
      RUN LnCollateralValueEx (iContract,
                               iContCode,
                               iDate,
                               ?,
                               iCurrency,
                               OUTPUT vAmtLoan,
                               OUTPUT vAmtAcct).
         /* ���ᯥ祭�� �� �� */
      oLoanObesp = vAmtLoan.
      vCalcMeth = GetXattrValueEx("loan",
                                  iContract + "," + iContCode,
                                  "���ᮡ����",
                                  "").
      IF NOT {assigned vCalcMeth} THEN
      DO:
         IF NOT AVAIL b-loan THEN
            LEAVE MAIN.
         vCalcMeth = GetXAttrInit(b-loan.class-code,
                                  "���ᮡ����").
         IF NOT {assigned vCalcMeth} THEN
            vCalcMeth = FGetSetting("���玡��", "���ᮡ����", ?).
      END.
         /* �஢��塞 ����室������ ���४�஢�� �㬬� ���ᯥ祭�� �� �� */
         /* �᫨ ���ᯥ祭�� �� �� ���� ����� (���� ��祣� � ���४�஢���),
         ** � mNpRas = �� "���玡��" -> "���ᮡ����" - ���ᮡ ���� ���ᯥ祭�� =
         ** "�ய��樮���쭮" ��� "�� �ॢ�襭��" */
      IF     (vAmtLoan NE 0)
         AND (vCalcMeth   EQ "�ய��樮���쭮"
           OR vCalcMeth   EQ "�� �ॢ�襭��") THEN
      DO:
         IF AVAIL b-loan THEN
         DO:
            IF b-loan.cont-type EQ "��祭��" THEN
               vCorrFlg = TRUE.     /* ������� 䫠� ���४�஢�� */
            ELSE
            DO:
                  /* ��।��塞, �� ���� �� ����� ������� �࠭襬:
                  ** ��⠥��� ���� �墠�뢠�騩 �������, �.�. �� cont-code �࠭�
                  ** ��।����� ����� - �� �� ࠡ�⠥� � �����䨫���쭮� ���� */
               FIND FIRST z-loan WHERE
                          z-loan.contract   EQ b-loan.contract
                  AND     z-loan.filial-id  EQ b-loan.filial-id
                  AND     z-loan.doc-ref    EQ ENTRY(1, b-loan.doc-ref, " ")
                  AND     RECID(z-loan)     NE RECID(b-loan)
               NO-LOCK NO-ERROR.
               IF AVAIL z-loan THEN
                  vCorrFlg = TRUE.     /* ������� 䫠� ���४�஢�� */
            END.
         END.
      END.
         /* �᫨ ������� ����� ⨯ "��祭��" ��� ���� �࠭襬 - �ॡ����
         ** ���४�஢�� ����祭��� �㬬� ���ᯥ祭�� �� �������� */
      IF vCorrFlg THEN
      DO:
            /* ����塞 ��� �㬬� ���ᯥ祭�� ������� ᮣ��襭��/�࠭� */
         vTrObesp = LnCollateralValueAll(iContract,
                                         iContCode,
                                         iDate,
                                         ?,
                                         iCurrency,
                                         "one").
            /* ���᫥� �㬬� ���ᯥ祭��, �⭮������� � ������� �祭��/�࠭��
            ** � ��⮬ ����, �⭮��饩�� � �� */
         oLoanObesp = IF vAmtLoan + vAmtAcct NE 0
                         THEN vTrObesp * vAmtLoan / (vAmtLoan + vAmtAcct)
                         ELSE 0.
      END.
   END.
   IF mIfPutPtot THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " vDoc-ref FORMAT "X(22)".
      IF vCorrFlg THEN
      DO:
         PUT STREAM out_s UNFORMATTED
             ". [�⮨�. ����. ᮣ�.] = ".
         PUT STREAM out_s UNFORMATTED
             IF (vAmtLoan + vAmtAcct) EQ 0 THEN "0.00"
             ELSE "[�⮨�. ����. ᮣ�./�࠭�] * [����� �㬬� ����.�� ��] / ([����� �㬬� ����.�� ��] + [����� �㬬� ����.�� ��]) ".
         PUT STREAM out_s UNFORMATTED
             oLoanObesp FORMAT "->>>>,>>>,>>>,>>9.99"
             " = ".
         IF vAmtLoan + vAmtAcct EQ 0 THEN
            PUT STREAM out_s UNFORMATTED "0.00" SKIP.
         ELSE
            PUT STREAM out_s UNFORMATTED
               vTrObesp FORMAT "->>>>,>>>,>>>,>>9.99"
               " * "
               vAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
                " / ("
               vAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
               " + "
               vAmtAcct FORMAT "->>>>,>>>,>>>,>>9.99"
               ")"
            SKIP.
      END.
      ELSE
         PUT STREAM out_s UNFORMATTED
             ". [�⮨�. ����. ᮣ�.] = [����� �㬬� ����.�� ��] "
             oLoanObesp FORMAT "->>>>,>>>,>>>,>>9.99"
             " = "
             vAmtLoan FORMAT "->>>>,>>>,>>>,>>9.99"
         SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
   
   RETURN oLoanObesp.
END FUNCTION.

/*----------------------------------------------------------------------------
  Procedure  : ClcAcctDeriv
  Purpose    : ���᫥��� �㬬 ��業⮢ �� ����
  Parameters : iAcct     - ���
               iBegDate  - ���
               loan      - ����� loan'a
               oProc1    - ��業� ��ࢮ� �����
               oProc2    - ��業� ��ன �����
               oOk       - ���� �ᯥ譮�� ࠡ��� ��楤���
  Notes      :
  ----------------------------------------------------------------------------*/
PROCEDURE ClcAcctDeriv.

    DEF INPUT  PARAM  iAcct     AS CHAR NO-UNDO.
    DEF INPUT  PARAM  iBegDate  AS DATE NO-UNDO.
    DEF PARAM  BUFFER loan      FOR loan.
    DEF OUTPUT PARAM  oProc1    AS DEC  NO-UNDO.
    DEF OUTPUT PARAM  oProc2    AS DEC  NO-UNDO.
    DEF OUTPUT PARAM  oParamFI  AS CHAR NO-UNDO.
    DEF OUTPUT PARAM  oRisk     AS CHAR NO-UNDO.
    DEF OUTPUT PARAM  oOk       AS LOG  NO-UNDO.

    DEF VAR mShBal      AS DEC   NO-UNDO.
    DEF VAR mAcctObesp  AS DEC   NO-UNDO.
    DEF VAR mLoanObesp  AS DEC   NO-UNDO.
    DEF VAR vFlDosrZakr AS CHAR  NO-UNDO.
    DEF VAR vSrok       AS CHAR  NO-UNDO.
    DEF VAR vFlProl     AS LOG   NO-UNDO.
    DEF VAR vEndDate    AS DATE  NO-UNDO.
    DEF VAR vCurDt      AS DATE  NO-UNDO.
    DEF VAR vCntDays    AS INT64 NO-UNDO.

    DEF BUFFER xacct     FOR acct.
    DEF BUFFER loan-acct FOR loan-acct.

    mb:
    DO ON ERROR UNDO, LEAVE:

       FIND code WHERE code.class EQ "��ࠬ��"
                   AND ENTRY(1,CODE.code,"_") EQ SUBSTRING(iAcct,1,5) NO-LOCK NO-ERROR.

       /* �����頥� ��, �᫨ ��諮�� ����� ����� ����� */
       IF NOT AMBIGUOUS code THEN
       DO:
          IF NOT AVAIL code THEN
             LEAVE mb.
       END.
       ELSE
       DO:
          /* �� �����䨪���� �ப��� �饬 �� ���� � ஫�� �।�� */
          FIND LAST loan-acct WHERE loan-acct.contract  EQ loan.contract
                                AND loan-acct.cont-code EQ loan.cont-code
                                AND loan-acct.acct-type EQ "�।��"
          NO-LOCK NO-ERROR.
          IF NOT AVAIL loan-acct THEN
             LEAVE mb.

          /* �����뢠�� ��� �� */
          /* ����砥� ��ࠬ��� �������� */
          vFlDosrZakr = GetXattrValueEx("loan",
                                        loan.contract + "," + loan.cont-code,
                                        "��������",
                                        "").
          /* �᫨ � �ࠢ�� ����筮�� ������� */
          IF vFlDosrZakr EQ '��' THEN
             vSrok = "� �ࠢ�� ����筮�� �������".
          /* ���� ����塞 ���� �� ������� ��������� ��� ��⪮���� */
          ELSE DO:
             /* ���뢠�� �஫������ �� ���� �ப� ��� ��� */
             vFlProl = (IF FGetSetting("���玡��","�ப","") EQ '� ��⮬' THEN
                           TRUE
                        ELSE FALSE).
             /* ����塞 ���� ����砭�� ������� */
             FIND LAST term-obl WHERE     term-obl.contract  = loan.contract 
                                      AND term-obl.cont-code = loan.cont-code
                                      AND term-obl.idnt      = 3 
                                      NO-LOCK NO-ERROR.
             IF NOT AVAIL term-obl THEN
                LEAVE mb.
             /* � ��⮬ �஫����樨 */
             IF vFlProl THEN
                vEndDate = term-obl.end-date.
             /* ��� ��� �஫����樨 */
             ELSE DO:
                vCurDt = term-obl.end-date.
                DO WHILE TRUE:
                   FIND FIRST pro-obl WHERE     pro-obl.contract   = term-obl.contract
                                            AND pro-obl.cont-code  = term-obl.cont-code
                                            AND pro-obl.idnt       = 3
                                            AND pro-obl.n-end-date = vCurDt 
                                            NO-LOCK NO-ERROR.
                   IF AVAIL pro-obl THEN
                      vCurDt = pro-obl.end-date.
                   ELSE 
                      LEAVE.
                END. 
                vEndDate = vCurDt.
             END.
             /* ������⢮ ���� �।�� */
             vCntDays = vEndDate - loan.open-date.
             /* ��������� (����� ����) ��� ��⪮���� */
             IF GoMonth(loan.open-date,12) LT vEndDate THEN 
                vSrok = "���������".
             ELSE
                vSrok = "��⪮����".
          END.
          FOR EACH code WHERE 
                   code.class   EQ "��ࠬ��"
               AND code.code    BEGINS SUBSTRING(iAcct,1,5) + '_'
               AND code.misc[1] EQ vSrok 
          NO-LOCK:
             /* ��� ⮫쪮 ��諨, ��室�� - �.�. �� 㦥 � �� ���� */
             LEAVE.
          END.
          IF NOT AVAIL code THEN
             LEAVE mb.
       END.

       /* �� �⮬ �⠯� � ��� ���� ���� ������ �� �����䨪��� ��ࠬ��, � ��� ����� � ࠡ�⠥� */
       IF NUM-ENTRIES(code.code,"_") NE 2 THEN
          LEAVE mb.
       ELSE
          ASSIGN
             oParamFI = ENTRY(2,code.code,"_")
             oRisk    = code.misc[2].

       FIND FIRST xacct WHERE xacct.acct EQ iAcct NO-LOCK NO-ERROR.
       IF NOT AVAIL xacct THEN
          LEAVE mb.

       RUN acct-pos IN h_base (xacct.acct,xacct.currency,iBegDate,iBegDate,gop-status).
       mShBal = ABS(sh-bal).

       /* ���⮪ �� ��� 0, � oProc1 = 100, oProc2 = 0 ᮮ⢥��⢥��� */
       IF mShBal EQ 0 THEN
       DO:
          ASSIGN
             oProc1 = 100
             oOk    = YES.
          LEAVE mb.
       END.
       ELSE
       DO:
          RUN LnCollateralValueEx (loan.contract,
                                   loan.cont-code,
                                   iBegDate,
                                   ?,
                                   "",
                                   OUTPUT mLoanObesp,
                                   OUTPUT mAcctObesp).
          IF mShBal < mAcctObesp THEN
             mAcctObesp = mShBal.

          ASSIGN
             oProc1 = mAcctObesp * 100 / mShBal
             oProc2 = 100 - oProc1
             oOk    = YES.
       END.
    END. /* mb */

END PROCEDURE.

/*---------------------------------------------------------------------------
  Function   : LnUncoveredLoan
  Name       : �����ᯥ祭��� ���� ����
  Purpose    : ������ �����ᯥ祭��� ���� ����,�⭮������� � �⤥�쭮��
               ��������. �� ࠡ�⠥� � ������ࠬ� ⨯� "��祭��".

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnUncoveredLoan RETURNS DECIMAL (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iDate     AS DATE,
                                          INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan FOR loan.

   DEF VAR mDebtSumm AS DEC NO-UNDO. /* �㬬� �᭮����� ����� */
   DEF VAR mGuarSumm AS DEC NO-UNDO. /* �㬬� ���ᯥ祭�� */
   DEF VAR mResult   AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� �����ᯥ祭��� �㬬� �।�� �� "
      STRING(iDate, "99/99/9999") + "."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   IF b-loan.cont-type = "��祭��" THEN  RETURN 0.00.

   ASSIGN
      /* �᭮���� ���� �� ��㤥 */
      mDebtSumm = LnPrincipal(iContract,iContCode,iDate,iCurrency)
      /* �㬬� ���ᯥ祭�� �� ��㤥 */
      mGuarSumm = LnCollateralValue(iContract,iContCode,iDate,iCurrency)
      mResult   = mDebtSumm - mGuarSumm.


   IF mIfPutPtot THEN
   DO:
       IF mResult < 0.00 THEN
       DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
             ".  ����४�஢����� �⮨����� ���ᯥ祭�� �ॢ�蠥� ����� �������������."
             SKIP.
          OUTPUT STREAM out_s CLOSE.
       END.
       ELSE IF NOT(mIfPutNotNull
                   AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                   AND mDebtSumm = 0
                   AND mGuarSumm = 0) THEN DO:

          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
              "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
              ".  [������. �㬬� �।��] = [���� ������.] - [�⮨�. ����. ���.]"
              SKIP.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
             "."
             mResult FORMAT "->>>>,>>>,>>>,>>9.99"
             " = "
             mDebtSumm FORMAT "->>>>,>>>,>>>,>>9.99"
             " - "
             mGuarSumm FORMAT "->>>>,>>>,>>>,>>9.99"
             SKIP.
          OUTPUT STREAM out_s CLOSE.
       END.
   END.

   RETURN (IF mResult < 0.00 THEN 0 ELSE mResult).

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnCollateralValueAgr
  Name       : ����� ���ᯥ祭�� ᮣ��襭��, �⭮������ � �࠭��
  Purpose    : ������ ���� �㬬� ���ᯥ祭��, ��ॣ����஢������ ��
               ᮣ��襭�� � �࠭襢�� �।�⭮� �����, �⭮������� � �������
               �࠭��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnCollateralValueAgr RETURNS DECIMAL (INPUT iContract AS CHAR,
                                               INPUT iContCode AS CHAR,
                                               INPUT iDate     AS DATE,
                                               INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan       FOR loan.
   DEF BUFFER b-upper-loan FOR loan.

   DEF VAR mUncovSumm     AS DEC NO-UNDO. /* �����ᯥ祭��� ���� �࠭� �� ⥪�饬� �������� */
   DEF VAR mGuarSumm      AS DEC NO-UNDO. /* �㬬� ���ᯥ祭�� �� ᮣ��襭�� */
   DEF VAR mUncovTrSumm   AS DEC NO-UNDO. /* �����ᯥ祭��� ���� ���� �� �࠭�� */
   DEF VAR mTotUncovSumm  AS DEC NO-UNDO. /* �����ᯥ祭��� ���� ���� �� ᮣ��襭�� */
   DEF VAR mResult        AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   DEFINE VARIABLE vDoc-ref AS CHAR NO-UNDO.
   vDoc-ref = b-loan.doc-ref.

   IF b-loan.cont-type = "��祭��" OR
      NUM-ENTRIES(b-loan.cont-code, " ") <> 2
   THEN  RETURN 0.00.

   /* �饬 ������騩 ������� */
   FIND FIRST b-upper-loan
      WHERE   b-upper-loan.cont-type = "��祭��" AND
              b-upper-loan.contract  = iContract AND
              b-upper-loan.cont-code = ENTRY(1,iContCode, " ")
   NO-LOCK NO-ERROR.

   IF NOT AVAIL b-upper-loan THEN  RETURN 0.00.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(vDoc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
      ".  ����� ��� �⮨���� ���ᯥ祭�� ᮣ��襭��, �⭮��饩�� � ������� �祭�� (�࠭��) �� "
      STRING(iDate, "99/99/9999") + "."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   /* �㬬� ���ᯥ祭�� �� ᮣ��襭��, ���᫥���� �� ������饬� �������� */
   mGuarSumm = LnCollateralValue(b-upper-loan.contract,
                                 b-upper-loan.cont-code,iDate,iCurrency).
   IF mGuarSumm = 0 THEN RETURN 0.00.

   /* �����ᯥ祭��� ���� �࠭� �� ⥪�饬� �������� */
   mUncovSumm = LnUncoveredLoan(iContract,iContCode,iDate,iCurrency).
   IF mUncovSumm = 0 THEN RETURN 0.00.

   /* ��� ��� �祭�� ������饣� �������, �஬� ��, ����� ������
      ����� iDate ��� ������� ࠭�� iDate
   */
   FOR EACH b-loan WHERE b-loan.contract   = b-upper-loan.contract  AND
                         b-loan.cont-code  BEGINS b-upper-loan.cont-code AND
                         NUM-ENTRIES(b-loan.cont-code, " ") = 2 AND
                         ENTRY(1, b-loan.cont-code, " ") = b-upper-loan.cont-code AND
                         b-loan.open-date <= iDate
                 NO-LOCK:

      IF b-loan.close-date <> ? AND b-loan.close-date <= iDate THEN NEXT.

      ASSIGN
         /* �����ᯥ祭��� ���� ���� �� ��।���� �祭�� */
         mUncovTrSumm = LnUncoveredLoan(b-loan.contract,
                                        b-loan.cont-code,iDate,iCurrency)
         /* �����ᯥ祭��� ���� ���� �� ᮣ��襭�� */
         mTotUncovSumm = mTotUncovSumm + mUncovTrSumm.
   END.
   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(vDoc-ref, " ") = 2
              AND mTotUncovSumm = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
      ".  �����ᯥ祭��� �㬬� �।�� �� �ᥬ �祭�� ������� "
      b-upper-loan.cont-code FORMAT "x(22)"
      " � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      mTotUncovSumm FORMAT "->>>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   mResult = mGuarSumm * mUncovSumm / mTotUncovSumm.

   IF  mIfPutPtot
      AND mTotUncovSumm <> 0.00 THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
         ".  [����� �⮨�. ����. ᮣ�.] = [�⮨�. ����. ᮣ�.] * [������. �㬬� �।��] / [���� ������. �㬬� �।��]"
         mResult FORMAT "->>>>,>>>,>>>,>>9.99"
         " = "
         mGuarSumm FORMAT "->>>>,>>>,>>>,>>9.99"
         " * "
         mUncovSumm FORMAT "->>>>,>>>,>>>,>>9.99"
         " / "
         mTotUncovSumm FORMAT "->>>>,>>>,>>>,>>9.99"
         SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(vDoc-ref, " ") = 2
              AND mResult = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
      ".  �⮨����� ���ᯥ祭�� ᮣ��襭��, �⭮������ � ������� �祭�� � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      CurrRound ( mResult, iCurrency ) FORMAT "->>>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN  CurrRound ( mResult, iCurrency ).

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrv
  Name       : ��ନ�㥬� १��
  Purpose    : �����頥� ����稭� �ନ�㥬��� १�ࢠ �� ��������. �᫨ �
               ������� �� ������� ��� १�ࢠ, � �㭪�� ������� ����.
               �� ������ࠬ � �祭�ﬨ �ନ�㥬� १�� �㤥� ��।����
               ��� ��� �࠭襩 �������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrv RETURNS DECIMAL (INPUT iContract AS CHAR,
                                     INPUT iContCode AS CHAR,
                                     INPUT iDate     AS DATE,
                                     INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan    FOR loan.
   DEF BUFFER loan      FOR loan.
   DEF BUFFER loan-cond FOR loan-cond.

   DEF VAR mSyndLoan  AS LOG NO-UNDO.           /* �ਧ��� ᨭ���஢����� ���� */
   DEF VAR mFormRsrv  AS DEC INIT 0 NO-UNDO.    /* �ନ�㥬� १�� �� ᮣ��襭�� */
   DEF VAR mRsrvRate  AS DEC INIT 0 NO-UNDO.    /* �����樥�� १�ࢨ஢���� */
   DEF VAR mBasicDebt AS DEC INIT 0 NO-UNDO.    /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mPartAmt   AS DEC INIT 0 NO-UNDO.    /* �㬬� ����� �� ᮣ��襭�� */
   DEF VAR mGuarSummTr   AS DEC  NO-UNDO.       /* �㬬� ���ᯥ祭�� */
   DEF VAR mGuarSummLoan AS DEC  NO-UNDO.       /* �㬬� ���ᯥ祭�� �� ᮣ��襭�� */
   DEF VAR mGuarSummPart AS DEC  NO-UNDO.       /* ���� �㬬� ���ᯥ祭�� ᮣ��襭�� */
   DEF VAR mCalcRsrvBase AS DEC  NO-UNDO.       /* ���� ���� १�ࢠ */
   DEF VAR mResult       AS DEC  NO-UNDO.
   DEF VAR mFlNotRound   AS CHAR NO-UNDO.       /* 䫠� �⬥�� ���㣫���� �� ���� १�ࢠ*/


   IF (FGetSetting("����࢏��",?,"���") = "��")
   THEN
      IF ({assignex LnInBagOnDate(iContract,iContCode,iDate)})
      THEN
         RETURN LnCalcRsrv(iContract,iContCode,iDate,iCurrency).

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).
   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
       AND NOT(mIfPutNotNull
               AND NUM-ENTRIES( b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� ��饩 ����稭� ��ନ�㥬��� १�ࢠ �� "
      STRING(iDate) + "."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.
   IF LnRsrvCheck(iContract, iContCode) = FALSE THEN RETURN 0.00.
   mFlNotRound = GetSysConf ("FlNotRound").
   IF mFlNotRound EQ "YES" THEN 
   DO:
      {i254.i &SetFormRsrv = "YES" &SetNotRound = "YES"}
   END.
   ELSE DO:
      {i254.i &SetFormRsrv = "YES"}
   END.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvTransh
  Name       : ��ନ�㥬� १�� ��� �࠭襩
  Purpose    : �����頥� ����稭� �ନ�㥬��� १�ࢠ �� ��������. �᫨ �
               ������� �� ������� ��� १�ࢠ, � �㭪�� ������� ����.
               ��� ������஢-ᮣ��襭�� (⨯ ��祭��) �ନ�㥬� १�� = 0.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                           INPUT iContCode AS CHAR,
                                           INPUT iDate     AS DATE,
                                           INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan    FOR loan.
   DEF BUFFER loan      FOR loan.
   DEF BUFFER loan-cond FOR loan-cond.

   DEF VAR mSyndLoan  AS LOG NO-UNDO.           /* �ਧ��� ᨭ���஢����� ���� */
   DEF VAR mFormRsrv  AS DEC INIT 0 NO-UNDO.    /* �ନ�㥬� १�� �� ᮣ��襭�� */
   DEF VAR mRsrvRate  AS DEC INIT 0 NO-UNDO.    /* �����樥�� १�ࢨ஢���� */
   DEF VAR mBasicDebt AS DEC INIT 0 NO-UNDO.    /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mPartAmt   AS DEC INIT 0 NO-UNDO.    /* �㬬� ����� �� ᮣ��襭�� */
   DEF VAR mGuarSummTr   AS DEC NO-UNDO.        /* �㬬� ���ᯥ祭�� */
   DEF VAR mGuarSummLoan AS DEC NO-UNDO.        /* �㬬� ���ᯥ祭�� �� ᮣ��襭�� */
   DEF VAR mGuarSummPart AS DEC NO-UNDO.        /* ���� �㬬� ���ᯥ祭�� ᮣ��襭�� */
   DEF VAR mCalcRsrvBase AS DEC NO-UNDO.        /* ���� ���� १�ࢠ */
   DEF VAR mResult       AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).
   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� ��饩 ����稭� ��ନ�㥬��� १�ࢠ �� "
      STRING(iDate) + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   IF b-loan.cont-type = "��祭��" THEN
   DO:
      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ������� ����� ⨯ '��祭��'. ��� ������஢ ⠪��� ���� ��ନ�㥬� १�� ��⠥��� ࠢ�� ���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN 0.00.
   END.

   {i254.i &SetFormRsrv = "YES" &SetNotRound = "YES"}

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvGoodDebt
  Name       : ��ନ�㥬� १�� �� ��筮� ������������
  Purpose    : �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮������� �
               ��筮� ������������ �� ��������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvGoodDebt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                             INPUT iContCode AS CHAR,
                                             INPUT iDate     AS DATE,
                                             INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan FOR loan.

   DEF VAR mFormRsrvSumm AS DEC NO-UNDO.
   DEF VAR mBasicDebt AS DEC INIT 0 NO-UNDO.    /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mFixedDebt AS DEC INIT 0 NO-UNDO.    /* ��筠� ������������� */
   DEF VAR mResult    AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).
   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� ����稭� �ନ�㥬��� १�ࢠ �� ��筮� ������������ �� "
      STRING(iDate) + "."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   /* �㬬� �ନ�㥬��� १�ࢠ */
   RUN SetSysConf IN h_base ("FlNotRound", "YES") .
   mFormRsrvSumm = LnFormRsrv(iContract,iContCode,iDate,iCurrency).    
   mFormRsrvSumm = CurrRound(mFormRsrvSumm,iCurrency).  
   RUN DeleteOldDataProtocol IN h_base ("FlNotRound").

   IF mFormRsrvSumm = 0.00 THEN  RETURN 0.00.

   ASSIGN
      /* �㬬� �᭮����� ����� */
      mBasicDebt = LnPrincipal(iContract,iContCode,iDate,iCurrency)

      /* �㬬� ��筮� ������������ */
      mFixedDebt = LnGoodDebt(iContract,iContCode,iDate,iCurrency).

   IF mFixedDebt = mBasicDebt THEN
   DO:
      IF mIfPutPtot
         AND NOT(mIfPutNotNull
                 AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                 AND mFixedDebt = 0) THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ��� ����祭��� ������������. ��ନ�㥬� १�� �� ��筮� ������������ ࠢ�� ��饬� ��ନ�㥬��� १���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN mFormRsrvSumm.
   END.

   /* ���� �᭮����� १�ࢠ, �⭮������ � ��筮� ������������ */
   mResult = CurrRound ( mFormRsrvSumm * mFixedDebt / mBasicDebt, iCurrency ).

   IF mIfPutPtot
       AND NOT(mIfPutNotNull
               AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
               AND mResult = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ������� ����祭��� �������������. ��ନ�㥬� १�� �� ��筮� ������������ �㤥� ����⠭ �ய��樮���쭮:"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  [��ନ�㥬� १�� �� ��筮� �������.] = [��騩 �ନ�㥬� १��] * [��筠� ������.] / [���� ������.]"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      "."
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " = "
      mFormRsrvSumm FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " * "
      mFixedDebt FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " / "
      mBasicDebt FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ��ନ�㥬� १�� �� ��筮� ������������ � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvBadDebt
  Name       : ��ନ�㥬� १�� �� ����祭��� ������������
  Purpose    : �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮������� �
               ����祭��� ������������ �� ��������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvBadDebt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                            INPUT iContCode AS CHAR,
                                            INPUT iDate     AS DATE,
                                            INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan FOR loan.

   DEF VAR mFormRsrvSumm    AS DEC NO-UNDO. /* �ନ�㥬� १�� */
   DEF VAR mFormRsrvSummFix AS DEC NO-UNDO. /* �ନ�㥬� १�� �� ��筮� �����.*/
   DEF VAR mBasicDebt       AS DEC INIT 0 NO-UNDO. /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mFixedDebt       AS DEC INIT 0 NO-UNDO. /* ��筠� ������������� */
   DEF VAR mResult          AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� ����稭� �ନ�㥬��� १�ࢠ �� ����祭��� ������������ �� "
      STRING(iDate) + "."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   /* �㬬� �ନ�㥬��� १�ࢠ */
   RUN SetSysConf IN h_base ("FlNotRound", "YES") .
   mFormRsrvSumm = LnFormRsrv(iContract,iContCode,iDate,iCurrency). 
   mFormRsrvSumm = CurrRound(mFormRsrvSumm,iCurrency).   
   RUN DeleteOldDataProtocol IN h_base ("FlNotRound").
   IF mFormRsrvSumm = 0.00 THEN  RETURN 0.00.

   /* �㬬� �ନ�㥬��� १�ࢠ �� ��筮� ������������ */
   mFormRsrvSummFix = LnFormRsrvGoodDebt(iContract,iContCode,iDate,iCurrency).   
   mFormRsrvSummFix = CurrRound(mFormRsrvSummFix,iCurrency).
   IF mFormRsrvSumm = 0.00 THEN  RETURN 0.00.

   /* १�� �� ����祭��� ������������ */
   mResult = mFormRsrvSumm - mFormRsrvSummFix.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND mResult = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ��ନ�㥬� १�� �� ����祭��� ������������ ࠢ�� ࠧ��� ����� ����稭�� ��饣� �ନ�㥬��� १�ࢠ � "
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����稭�� �ନ�㥬��� १�ࢠ �� ��筮� ������������."
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      "."
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
      " = "
      mFormRsrvSumm FORMAT "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
      " - "
      mFormRsrvSummFix FORMAT "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ��ନ�㥬� १�� �� ����祭��� ������������ � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvGoodDebtTransh
  Name       : ��ନ�㥬� १�� �� ��筮� ������������
  Purpose    : �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮������� �
               ��筮� ������������ �� ��������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvGoodDebtTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                                   INPUT iContCode AS CHAR,
                                                   INPUT iDate     AS DATE,
                                                   INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan FOR loan.

   DEF VAR mFormRsrvSumm AS DEC NO-UNDO.
   DEF VAR mBasicDebt AS DEC INIT 0 NO-UNDO.    /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mFixedDebt AS DEC INIT 0 NO-UNDO.    /* ��筠� ������������� */
   DEF VAR mResult    AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).
   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� ����稭� �ନ�㥬��� १�ࢠ �� ��筮� ������������ �� "
      STRING(iDate) + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   /* �㬬� �ନ�㥬��� १�ࢠ */
   mFormRsrvSumm = LnFormRsrvTransh(iContract,iContCode,iDate,iCurrency).

   IF mFormRsrvSumm = 0.00 THEN  RETURN 0.00.

   ASSIGN
      /* �㬬� �᭮����� ����� */
      mBasicDebt = LnPrincipal(iContract,iContCode,iDate,iCurrency)

      /* �㬬� ��筮� ������������ */
      mFixedDebt = LnGoodDebt(iContract,iContCode,iDate,iCurrency).

   IF mFixedDebt = mBasicDebt THEN
   DO:
      IF mIfPutPtot
         AND NOT(mIfPutNotNull
                 AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
                 AND mFixedDebt = 0) THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ��� ����祭��� ������������. ��ନ�㥬� १�� �� ��筮� ������������ ࠢ�� ��饬� ��ନ�㥬��� १���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN mFormRsrvSumm.
   END.

   /* ���� �᭮����� १�ࢠ, �⭮������ � ��筮� ������������ */
   mResult = CurrRound ( mFormRsrvSumm * mFixedDebt / mBasicDebt, iCurrency ).

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND mResult = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ������� ����祭��� �������������. ��ନ�㥬� १�� �� ��筮� ������������ �㤥� ����⠭ �ய��樮���쭮:"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  [��ନ�㥬� १�� �� ��筮� �������.] = [��騩 �ନ�㥬� १��] * [��筠� ������.] / [���� ������.]"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      "."
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " = "
      mFormRsrvSumm FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " * "
      mFixedDebt FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " / "
      mBasicDebt FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ��ନ�㥬� १�� �� ��筮� ������������ � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvBadDebtTransh
  Name       : ��ନ�㥬� १�� �� ����祭��� ������������
  Purpose    : �����頥� ���� �㬬� �ନ�㥬��� १�ࢠ, �⭮������� �
               ����祭��� ������������ �� ��������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvBadDebtTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                                  INPUT iContCode AS CHAR,
                                                  INPUT iDate     AS DATE,
                                                  INPUT iCurrency AS CHAR).
   DEF BUFFER b-loan FOR loan.

   DEF VAR mFormRsrvSumm    AS DEC NO-UNDO. /* �ନ�㥬� १�� */
   DEF VAR mFormRsrvSummFix AS DEC NO-UNDO. /* �ନ�㥬� १�� �� ��筮� �����.*/
   DEF VAR mBasicDebt       AS DEC INIT 0 NO-UNDO. /* �᭮���� ���� �� ᮣ��襭�� */
   DEF VAR mFixedDebt       AS DEC INIT 0 NO-UNDO. /* ��筠� ������������� */
   DEF VAR mResult          AS DEC NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
       AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����� ����稭� �ନ�㥬��� १�ࢠ �� ����祭��� ������������ �� "
      STRING(iDate) + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   /* �㬬� �ନ�㥬��� १�ࢠ */
   mFormRsrvSumm = LnFormRsrvTransh(iContract,iContCode,iDate,iCurrency).
   IF mFormRsrvSumm = 0.00 THEN  RETURN 0.00.

   /* �㬬� �ନ�㥬��� १�ࢠ �� ��筮� ������������ */
   mFormRsrvSummFix = LnFormRsrvGoodDebtTransh(iContract,iContCode,iDate,iCurrency).
   IF mFormRsrvSumm = 0.00 THEN  RETURN 0.00.

   /* १�� �� ����祭��� ������������ */
   mResult = mFormRsrvSumm - mFormRsrvSummFix.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND mResult = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ��ନ�㥬� १�� �� ����祭��� ������������ ࠢ�� ࠧ��� ����� ����稭�� ��饣� �ନ�㥬��� १�ࢠ � "
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ����稭�� �ନ�㥬��� १�ࢠ �� ��筮� ������������."
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      "."
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      " = "
      mFormRsrvSumm
      " - "
      mFormRsrvSummFix FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ��ନ�㥬� १�� �� ����祭��� ������������ � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      mResult FORMAT "->>,>>>,>>>,>>>,>>9.99"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*----------------------------------------------------------------------------
  Function   : LnGetGrRiska
  Purpose    : ��।������ ��㯯� �᪠ �� ���祭�� �����樥�� १�ࢨ஢����
  Parameters : pPRsrv  - ���祭�� �����樥�� १�ࢨ஢����
               iSince  - ��� १�ࢨ஢����
               opGRsrv - �����頥��� ���祭�� ��㯯� �᪠
  Notes      :
  ----------------------------------------------------------------------------*/
FUNCTION LnGetGrRiska RETURNS INT64
  (pPRsrv AS DEC,
   iSince AS DATE):

   DEF VAR opGRsrv    AS INT64  INIT ?  NO-UNDO.

   RUN LnGetRiskGrOnDate (       pPRsrv,
                                 iSince,
                          OUTPUT opGRsrv).

   IF opGRsrv = ? THEN opGRsrv = 1.

   RETURN opGRsrv.
END.

/*----------------------------------------------------------------------------
  Function   : PsGetGrRiska
  Purpose    : ��।������ ��㯯� �᪠ �� ���祭�� �����樥�� १�ࢨ஢����
               �᫨ ������� �⭮���� � ������ ���� ����
  Parameters : pPRsrv   - ���祭�� �����樥�� १�ࢨ஢����
               iCustCat - ⨯ ������ �������
               iSince   - ��� १�ࢨ஢����
               opGRsrv  - �����頥��� ���祭�� ��㯯� �᪠
  Notes      :
  ----------------------------------------------------------------------------*/
FUNCTION PsGetGrRiska RETURNS INT64
  (iRate    AS DEC,
   iCustCat AS CHAR,
   iSince   AS DATE):

   DEF VAR vReturn AS INT64 INIT ? NO-UNDO.

   GetRefCrVal ("����࢏��",
                "rate-comm",
                iSince,
                iCustCat,
                (TEMP-TABLE ttIndicate:HANDLE)).

   FOR EACH ttIndicate WHERE ttIndicate.fDec LE DEC(iRate) BY ttIndicate.fDec DESCENDING:
       LEAVE.
   END.

   IF AVAIL ttIndicate THEN
      vReturn = INT64(GetRefVal ("����࢏��",iSince, iCustCat + "," + STRING(ttIndicate.fdec,">>9.99999"))).

   IF vReturn = ? THEN vReturn = 1.

   RETURN vReturn.
END.

/*---------------------------------------------------------------------------
  Function   : LnRsrvDate
  Name       :
  Purpose    : �����頥� ���祭�� �⠢�� १�ࢨ஢���� �� �������� ��
               㪠������ ����

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvDate RETURNS DATE   (
   INPUT iContract AS CHAR,
   INPUT iContCode AS CHAR,
   INPUT iDate     AS DATE
):
   DEF VAR vRate AS DEC    NO-UNDO.
   DEF VAR vPos  AS CHAR   NO-UNDO. /* ��� ����. */

   DEFINE BUFFER b-loan    FOR loan.
   DEFINE BUFFER comm-rate FOR comm-rate.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.
                        /* �᫨ ��㤠 �室�� � ���, � ��।��塞 �⠢�� �� ����. */
   vPos = LnInBagOnDate (b-loan.contract, b-loan.cont-code, iDate).
   IF vPos NE ?
   THEN DO:
      FIND FIRST loan WHERE
               loan.contract  EQ "���"
         AND   loan.cont-code EQ vPos
      NO-LOCK NO-ERROR.
      IF AVAIL loan
         THEN RETURN DATE (fGetBagRate ((BUFFER loan:handle), "%���", iDate, "since")).
   END.
   /* ���� �஭������᪨ ��᫥����� �����樥�� १�ࢨ஢���� �� �������� */
   RUN GET_COMM_BUF IN h_comm ("%���",
                               ?,
                               b-loan.currency,
                               iContract + "," + iContCode,
                               0.00,
                               0,
                               iDate,
                               BUFFER comm-rate).

   IF AVAIL(comm-rate) THEN RETURN comm-rate.since.

   IF b-loan.cont-type = "��祭��" THEN RETURN ?.

   /* ������� �� ⨯� "�祭��" -> ᬮ�ਬ ������騩 ������� */
   IF NUM-ENTRIES(iContCode, " ") = 2
   THEN
      RETURN (LnRsrvDate (iContract,
                          ENTRY(1,iContCode, " "),
                          iDate)).

   RETURN ?.

END FUNCTION.



/*----------------------------------------------------------------------------
  Procedure  : LnGetRiskGrOnDate
  Purpose    : ��।������ ��㯯� �᪠ �� ���祭�� �����樥�� १�ࢨ஢����
  Parameters : pPRsrv  - ���祭�� �����樥�� १�ࢨ஢����
               iSince  - ��� १�ࢨ஢����
               opGRsrv - �����頥��� ���祭�� ��㯯� �᪠
  Notes      : !!!!  ��⮬ 㤠���� �ᯮ�짮���� �-��
  ----------------------------------------------------------------------------*/

DEFINE TEMP-TABLE ttLoanGrRiska NO-UNDO
   FIELD since   AS DATE
   FIELD grRiska AS INT64
   FIELD minVal  AS DECIMAL
   FIELD maxVal  AS DECIMAL
   FIELD cldate  AS DATE

   INDEX idx since DESC cldate DESC minVal maxVal DESC
.
DEFINE VARIABLE mLoanGetGrInitialized AS LOGICAL    NO-UNDO INIT NO.


PROCEDURE LnGetRiskGrOnDate:
   DEFINE INPUT  PARAMETER pPRsrv  AS DECIMAL         NO-UNDO.
   DEFINE INPUT  PARAMETER iSince  AS DATE            NO-UNDO.
   DEFINE OUTPUT PARAMETER opGRsrv AS INT64 INIT ?  NO-UNDO.
   DEFINE VARIABLE vGRsrv AS CHARACTER   NO-UNDO.
   RUN LnGetRiskGrList(pPRsrv,iSince,NO,OUTPUT vGRsrv).
   IF vGRsrv NE ""
   THEN
      opGRsrv = INT64(vGRsrv).
END PROCEDURE.

PROCEDURE LnGetRiskGrList:
   DEFINE INPUT  PARAMETER pPRsrv  AS DECIMAL         NO-UNDO.
   DEFINE INPUT  PARAMETER iSince  AS DATE            NO-UNDO.
   DEFINE INPUT  PARAMETER iAll    AS LOGICAL         NO-UNDO.
   DEFINE OUTPUT PARAMETER opGRsrv AS CHARACTER       NO-UNDO.

   DEFINE BUFFER DataClass FOR DataClass.
   DEFINE BUFFER Formula   FOR formula.
   DEFINE BUFFER bformula  FOR formula. /* ���������� ����. */
   DEFINE BUFFER ttGr      FOR ttLoanGrRiska.

   DEFINE VARIABLE mClDate AS DATE NO-UNDO.

   IF NOT mLoanGetGrInitialized THEN
   DO:
      EMPTY TEMP-TABLE ttLoanGrRiska.

      FOR FIRST DataClass WHERE
                DataClass.DataClass-ID EQ "�����"
      NO-LOCK:
         FOR EACH formula OF DataClass WHERE
                   formula.Misc[1] EQ Formula.DataClass-ID /* ����� "��ࢮ��" �஢��. ����⥫� = misc[1] */
         NO-LOCK:
            FIND FIRST bformula WHERE bformula.DataClass-Id EQ formula.DataClass-Id
                                  AND bformula.var-id       EQ formula.var-id
                                  AND bformula.since        GT formula.since
               NO-LOCK NO-ERROR.
            IF AVAIL bformula
            THEN
               mClDate = bformula.since - 1.
            ELSE
               mClDate = DATE(GetXAttrValueEX("formula",formula.DataClass-ID + "," + formula.Var-ID, "close-date", "{&BQ-MAX-DATE}")).

            CREATE ttLoanGrRiska.
            ASSIGN
               ttLoanGrRiska.since   = formula.since
               ttLoanGrRiska.grRiska = INT64(SUBSTR(formula.var-id,1,1))
               ttLoanGrRiska.MinVal  = DEC (REPLACE (ENTRY (1,formula.formula),CHR(126),""))
               ttLoanGrRiska.MaxVal  = DEC (REPLACE (ENTRY (NUM-ENTRIES (formula.formula),formula.formula),CHR(126),""))
               ttLoanGrRiska.cldate  = mClDate
            .
            /* �᫨ �� ��᫥���� ��㯯� �᪠, � ��ࠢ���⢮ ���� ������� */
            IF NUM-ENTRIES (formula.formula) EQ 1 THEN ttLoanGrRiska.MaxVal = ?.
            RELEASE ttLoanGrRiska.
         END.
      END.

      mLoanGetGrInitialized = YES.
   END.
/* �᫨ ��� �� ��।�����, ��⠭�������� ���� �� ���� ࠭�� ���ᨬ��쭮�
** ��� ���᪠ ��᫥���� ���� */
   IF iSince = ? THEN iSince = DATE("{&BQ-MAX-DATE}") - 1.
/* ���� �㦭�� ��㯯� �᪠ */
   Block-GrRisk:
   FOR EACH ttLoanGrRiska WHERE
              ttLoanGrRiska.MinVal LE pPRsrv
          AND(ttLoanGrRiska.MaxVal GE pPrsrv /* !!!GE �� ������ �� GT, �⮡� ���짮��⥫� ��� �롨��� ��, ���������� �� �࠭�筮� ���祭�� */
              OR ttLoanGrRiska.MaxVal EQ ?)
          AND ttLoanGrRiska.since  LE iSince
          AND ttLoanGrRiska.cldate GT iSince
   NO-LOCK
      BY ttLoanGrRiska.grRiska DESCENDING:
/* �᫨ ��諨 ���室���� */
      IF NOT CAN-DO(opGRsrv,STRING(ttLoanGrRiska.grRiska))
      THEN
         opGRsrv = opGRsrv + (IF opGRsrv EQ "" THEN ""ELSE ",") + STRING(ttLoanGrRiska.grRiska).
      IF NOT iAll
      THEN 
          LEAVE Block-GrRisk. 
   END.
   /* ��� ���४⭮�� ��।������ ��.�᪠ ��ன ����, � ���祭��� 1.00000 */
   IF    opGRsrv EQ ""
     AND pPRsrv  EQ 1
     AND iSince  LE 08/01/2004 THEN
        opGRsrv = "1".
END PROCEDURE.

PROCEDURE LnGetPersRsrvOnDate:
   DEFINE INPUT  PARAMETER pGRsrv AS INT64    NO-UNDO.
   DEFINE INPUT  PARAMETER iSince AS DATE       NO-UNDO.
   DEFINE OUTPUT PARAMETER opRes  AS DECIMAL    NO-UNDO INIT ?.

   DEFINE VARIABLE vMax AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE vMin AS DECIMAL    NO-UNDO.
   DEFINE VARIABLE vVal AS CHARACTER  NO-UNDO.

   DEFINE BUFFER formula FOR formula.
   /* �㫥��� ��㯯� �᪠ �� ������� */
   IF pGRsrv = 0 THEN
   DO:
      opRes = 0.
      RETURN.
   END.

   RUN Find_Formula (       "�����",
                            STRING(pGRsrv) + "��",
                            iSince,
                            NO,
                     BUFFER formula).
   IF NOT AVAIL (formula) THEN RETURN.

   IF NUM-ENTRIES (vVal) >= 2 THEN
   DO:
      ASSIGN
         vVal = TRIM (formula.formula, CHR (126))  /* ��ᥪ��� ⨫�� */
         vMin = DEC (ENTRY (1,vVal))
         vMax = DEC (ENTRY (NUM-ENTRIES (vVal),vVal))
      NO-ERROR.
      /* �訡�� - �� ���뢠�� */
      IF ERROR-STATUS:ERROR THEN RETURN.
   END.
   ELSE
   DO:
      ASSIGN
         vVal = TRIM (formula.formula, CHR (126))  /* ��ᥪ��� ⨫�� */
         vMin = DEC (ENTRY (1,vVal))
      NO-ERROR.
      /* �訡�� - �� ���뢠�� */
      IF ERROR-STATUS:ERROR THEN RETURN.
   END.

   opRes = vMin.
END.

/* ��।������ ��㯯� �᪠ ������� �� ���� �� ���ਨ. */
FUNCTION re_history_risk RETURNS INT64 (
   INPUT in_contract  AS CHARACTER,
   INPUT in_cont-code AS CHARACTER,
   INPUT ip_Date      AS DATE,
   INPUT ip_GrPrInt   AS INT64
):
   DEF VAR vReturnInt   AS INT64    NO-UNDO.
   DEF VAR vPos         AS CHAR   NO-UNDO. /* ��� ����. */
   DEF VAR vPosRate     AS DEC    NO-UNDO. /* ���祭�� ��業⭮� �⠢�� � ����. */
   DEF VAR vSurCom      AS CHAR   NO-UNDO. /* ���ண�� �⠢��. */

   DEF BUFFER loan      FOR loan.      /* ���������� ����. */
   DEF BUFFER comm-rate FOR comm-rate. /* ���������� ����. */

   vReturnInt = ip_GrPrInt.
                        /* �᫨ ��㤠 �室�� � ���, � ��।��塞 �⠢�� �� ����. */
   vPos = LnInBagOnDate (in_contract, in_cont-code, ip_Date).
   IF vPos  NE ?
   THEN DO:
      FIND FIRST loan WHERE
               loan.contract  EQ "���"
         AND   loan.cont-code EQ vPos
      NO-LOCK NO-ERROR.
      IF AVAIL loan
      THEN DO:
         FIND LAST comm-rate WHERE
                   comm-rate.commission EQ "%���"
               AND comm-rate.acct       EQ "0"
               AND comm-rate.currency   EQ ""
               AND comm-rate.kau        EQ "���," + loan.cont-code
               AND comm-rate.min-value  EQ 0
               AND comm-rate.period     EQ 0 
               AND comm-rate.since      LE ip_Date
         NO-LOCK NO-ERROR.
         IF NOT AVAIL comm-rate 
            AND LENGTH(loan.parent-contract) GT 0 THEN
            FIND LAST comm-rate WHERE
                      comm-rate.commission EQ "%���"
                  AND comm-rate.acct       EQ "0"
                  AND comm-rate.currency   EQ ""
                  AND comm-rate.kau        EQ "���," + loan.parent-cont-code
                  AND comm-rate.min-value  EQ 0
                  AND comm-rate.period     EQ 0 
                  AND comm-rate.since      LE ip_Date
            NO-LOCK NO-ERROR.
         IF AVAIL comm-rate THEN
         DO:
            vReturnInt = INT64 (GetXAttrValueEx("comm-rate",
                                                STRING(comm-rate.comm-rate-id),
                                                "��⥣���",
                                                ?)
                               ).
            IF vReturnInt EQ ? 
            THEN DO:
               vReturnInt = PsGetGrRiska (comm-rate.rate-comm,
                                          loan.cust-cat, 
                                          ip_Date).
               UpdateSigns("comm-rate",
                           STRING(comm-rate.comm-rate-id),
                           "��⥣���",
                           STRING(vReturnInt),
                           ?).
            END.
         END.
      END.
   END.
   ELSE DO:
      RUN GET_COMM_LOAN_BUF IN h_Loan (in_contract,
                                       in_cont-code,
                                       "%���",
                                       ip_date,
                                       BUFFER comm-rate).

      IF NOT AVAILABLE comm-rate              AND
         NUM-ENTRIES (in_cont-code, " ") = 2  AND
         NOT CAN-FIND (loan WHERE loan.contract  = in_contract
                              AND loan.cont-code = in_cont-code
                              AND loan.cont-type = "��祭��"
                       NO-LOCK)
      THEN
         /* ������� �� ⨯� "�祭��" -> ᬮ�ਬ ������騩 ������� */
         RUN GET_COMM_LOAN_BUF IN h_Loan (in_contract,
                                          ENTRY (1, in_cont-code, " "),
                                          "%���",
                                          ip_date,
                                          BUFFER comm-rate).
      IF AVAILABLE comm-rate
      THEN DO:
         vReturnInt = INT64 (GetXAttrValueEx("comm-rate",
                                           STRING(comm-rate.comm-rate-id),
                                           "��⥣���",
                                           ?)).
         IF vReturnInt EQ ?
         THEN
            vReturnInt = LnGetGrRiska(comm-rate.rate-comm,
                                      comm-rate.since).
      END.
   END.
   RETURN vReturnInt.
END FUNCTION.

/* ��⠭���� �����᪨� ���祭�� ��㯯� �᪠ � �����樥�� १�ࢨ஢���� */
PROCEDURE Set_Risk_From_History.
    DEF INPUT PARAM in_contract  AS CHARACTER NO-UNDO .
    DEF INPUT PARAM in_cont_code AS CHARACTER NO-UNDO .
    DEF INPUT PARAM ip_Date      AS DATE      NO-UNDO .
    DEF OUTPUT PARAM fl-o        AS INT64 NO-UNDO .

    DEF VAR grRisk  AS INT64 NO-UNDO .
    DEF VAR procRez AS DECIMAL NO-UNDO .
    DEF BUFFER loan FOR loan .
    DEF BUFFER yloan FOR loan .

    procRez = LnRsrvRate(in_contract,in_cont_code,ip_Date) .
    grRisk  = re_history_risk(in_contract,in_cont_code,ip_Date,1) .
    fl-o = -1.
    DO TRANSACTION ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE :
      FIND FIRST loan WHERE loan.contract = in_contract AND loan.cont-code = in_cont_code EXCLUSIVE-LOCK NO-WAIT NO-ERROR .
      IF NOT AVAIL loan THEN LEAVE .
      ASSIGN loan.gr-riska = grRisk
             loan.risk     = procRez .
      /* �᫨ ������� - ��祭�� �㦭� ����� ���४⨢� �� �� ���稭����
        �������- �࠭��, ��� ��� ��८�।������� ���祭��
        �����樥�� १�ࢨ஢���� */
      IF loan.cont-type = '��祭��'
      THEN RUN Set_Transh_Risk(loan.contract,loan.cont-code + ' ',
                               grRisk,procRez).
      fl-o  = 0.
    END.
END PROCEDURE .

PROCEDURE Set_Transh_Risk.
  DEF INPUT PARAM in_contract  AS CHAR NO-UNDO.
  DEF INPUT PARAM in_cont_code AS CHAR NO-UNDO .
  DEF INPUT PARAM in_gr        AS INT64 NO-UNDO .
  DEF INPUT PARAM in_risk      AS DECIMAL NO-UNDO .


  DEF BUFFER yloan FOR loan .
  DO TRANSACTION ON ERROR UNDO,RETURN ON ENDKEY UNDO,RETURN :
    FOR EACH yloan WHERE yloan.contract = in_contract
     AND yloan.cont-code begins in_cont_code :
     IF     GET_COMM ("%���",
                     ?,
                     yloan.currency,
                     in_contract + "," + yloan.cont-code,
                     0.00,
                     0,
                     01/01/3000) = ?
     THEN
        ASSIGN yloan.gr-riska = in_gr
               yloan.risk     = in_risk .
   END.
 END.
END PROCEDURE .

/*---------------------------------------------------------------------------
  Function   : LnPledgeQuality
  Name       : �⮨����� ��ꥪ� ���ᯥ祭��
  Purpose    : �����頥� �⮨����� ��ꥪ� ���ᯥ祭�� � ��⮬ ���祭��
               �����樥�� ᭨����� �⮨���� � ������ ����⢠ ���ᯥ祭��.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iIdnt       - �����䨪���
               iEndDate    - �ப
               iNN         - ?
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnPledgeQuality RETURNS DECIMAL (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iIdnt     AS INT64,
                                          INPUT iEndDate  AS DATE,
                                          INPUT iNN       AS INT64,
                                          INPUT iDate     AS DATE,
                                          INPUT iCurrency AS CHAR).

   DEF VAR mDRGQ     AS CHAR NO-UNDO. /*�� term-obl.����⢮���� */
   DEF VAR mDRInDate AS CHAR NO-UNDO. /*�� term-obl.��⠏��� */
   DEF VAR mGQIndex  AS DEC  NO-UNDO. /*������ ����⢠ ���ᯥ祭��*/
   DEF VAR mDecrRate AS DEC  NO-UNDO. /*�����樥�� ᭨����� ����⢠ ���ᯥ祭��*/
   DEF VAR mGObjCost AS DEC  NO-UNDO. /*�⮨����� ��ꥪ� ���ᯥ祭��*/
   DEF VAR mGOSumm   AS DEC  NO-UNDO. /*�㬬� ���ᯥ祭�� �� ��ꥪ��*/
   DEF VAR mGQCode   AS CHAR NO-UNDO.
   DEF VAR mTotSumm  AS DEC  NO-UNDO.

   DEFINE BUFFER b-loan FOR loan.
   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   ASSIGN
      /* ���祭�� �� ����⢮���� */
      mDRGQ = Get_QualityGar("comm-rate",
                             iContract + "," + iContCode + ","
                           + STRING(iIdnt) + ","
                           + STRING(iEndDate) + ","
                           + STRING(iNN),
                             iDate)

      /* ���祭�� �� "��⠏��� */
      mDRInDate = GetXAttrValue("term-obl",
                                iContract + "," + iContCode + ","
                              + STRING(iIdnt) + ","
                              + STRING(iEndDate) + ","
                              + STRING(iNN),
                                "��⠏���").

   IF (mDRInDate <> "?" AND mDRInDate <> ? AND mDRInDate <> "" AND DATE(mDRInDate) > iDate)
      OR mDRGQ = "?" OR mDRGQ = ? OR mDRGQ = ""
   THEN
      RETURN 0.00.

   IF GetSysConf("���_���_��⥣�ਨ_����⢠") EQ "yes" 
   THEN
      mGQIndex = 100.
   ELSE DO:
   /* ������ ����⢠ ���ᯥ祭�� �� �����䨪���� "����⢮����"*/
      mGQIndex  = DEC(GetCode("����⢮����", mDRGQ )).

      IF mGQIndex < 0 OR mGQIndex > 100 THEN DO:
         IF mIfPutPtot THEN
         DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "�訡��      �������: " b-loan.doc-ref FORMAT "X(22)"
            ".  �����४⭮� ���祭�� ������ ����⢠ ���ᯥ祭��. ���祭�� ������ ����⢠ ���ᯥ祭�� �ਭ������� ࠢ�� ���.".
         OUTPUT STREAM out_s CLOSE.
         END.
         mGQIndex = 0.
      END.
   END.
   /* mDecrRate - �����.᭨����� �⮨���� ���ᯥ祭�� (�믮������ ����
      �����樥��, ��⠭��������� �� ��ꥪ�� ���ᯥ祭�� �� ���� iDate)
   */
   mDecrRate = GET_COMM("����",
                        ?,
                        iCurrency,
                        iContract + "," + iContCode + ","
                        + STRING(iIdnt) + ","
                        + STRING(iEndDate) + ","
                        + STRING(iNN),
                        0.00,
                        0,
                        iDate).

   IF mDecrRate = ? THEN mDecrRate = 100.
   IF mGQIndex  = ? THEN mGQIndex  = 0.

   ASSIGN
      /* �⮨����� ��ꥪ� ���ᯥ祭�� */
      mGObjCost = LnPledge(iContract, iContCode, iIdnt, iEndDate, iNN,
                           iDate, ?, iCurrency)
      /* �㬬� ���ᯥ祭�� �� ��ꥪ�� */
      mGOSumm  = mGObjCost * mGQIndex / 100 * mDecrRate / 100
      mGOSumm  = CurrRound ( mGOSumm, iCurrency )
      mTotSumm = mTotSumm + mGOSumm.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND mTotSumm = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  [�⮨�. ����. ���.] = [�⮨�. ��ꥪ� ����.] * [������ ����⢠] * [����. ����筮� �⮨�.]"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      "."
      mGOSumm   FORMAT "->>>>,>>>,>>>,>>9.99"
      " = "
      mGObjCost FORMAT "->>>>,>>>,>>>,>>9.99"
      " * "
      mGQIndex  FORMAT "->>>>,>>>,>>>,>>9.99"
      " % * "
      mDecrRate FORMAT "->>>>,>>>,>>>,>>9.99"
      SKIP
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  �⮨����� ���ᯥ祭�� �� �������� � ����� "
      iCurrency FORMAT "x(3)"
      ": "
      mTotSumm  FORMAT "->>>>,>>>,>>>,>>9.99999"
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mTotSumm.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : RegulationNeed
  Name       : �㭪�� 䨪������ ��������� 䠪�஢, ������� �� ࠧ���
               १�ࢠ.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iPrevDate   - ��� �।��饣� �ॣ㫨஢���� १�ࢠ
               iCurrDate   - ��� ⥪�饣� �ॣ㫨஢���� १�ࢠ
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION RegulationNeed RETURNS LOGICAL (INPUT iContract AS CHAR,
                                         INPUT iContCode AS CHAR,
                                         INPUT iPrevDate AS DATE,
                                         INPUT iCurrDate AS DATE).

   DEFINE BUFFER b-loan FOR loan.
   DEFINE BUFFER b-upper-loan FOR loan.

   DEFINE VAR vPrevRsrvRate     AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrRsrvRate     AS DECIMAL NO-UNDO.
   DEFINE VAR vPrevPledgeSum    AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrPledgeSum    AS DECIMAL NO-UNDO.
   DEFINE VAR vPrevPrnAmt       AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrPrnAmt       AS DECIMAL NO-UNDO.
   DEFINE VAR vPrevPrnAmtTr     AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrPrnAmtTr     AS DECIMAL NO-UNDO.
   DEFINE VAR vPrevTotPrnAmt    AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrTotPrnAmt    AS DECIMAL NO-UNDO.
   DEFINE VAR vPrevGoodSum      AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrGoodSum      AS DECIMAL NO-UNDO.
   DEFINE VAR vPrevBadSum       AS DECIMAL NO-UNDO.
   DEFINE VAR vCurrBadSum       AS DECIMAL NO-UNDO.
   DEFINE VAR vSummParCurr      AS DECIMAL NO-UNDO.
   DEFINE VAR vSummParPrev      AS DECIMAL NO-UNDO.
   DEFINE VAR vSumm-Db          AS DECIMAL NO-UNDO. /* ����室��� ��� �맮�� STNDRT_PARAM */
   DEFINE VAR vSumm-Cr          AS DECIMAL NO-UNDO. /* ����室��� ��� �맮�� STNDRT_PARAM */

   RUN RE_B_LOAN IN h_Loan (iContract, iContCode, BUFFER b-loan).

   IF NOT AVAIL b-loan THEN RETURN FALSE.

   /* �஢�ઠ ��������� �᭮����� ����� */
   ASSIGN
      vPrevGoodSum = LnGoodDebt(iContract,
                                iContCode,
                                iPrevDate,
                                b-loan.currency)
      vCurrGoodSum = LnGoodDebt(iContract,
                                iContCode,
                                iCurrDate,
                                b-loan.currency)
      .

   IF vPrevGoodSum <> vCurrGoodSum THEN  RETURN TRUE.

   ASSIGN
       vPrevBadSum = LnBadDebt(iContract,
                              iContCode,
                              iPrevDate,
                              b-loan.currency)
      vCurrBadSum = LnBadDebt(iContract,
                              iContCode,
                              iCurrDate,
                              b-loan.currency)
      .

   IF vPrevBadSum <> vCurrBadSum THEN  RETURN TRUE.

   /* �஢�ન �� �������� �� ��業⠬ ( 33 ��ࠬ��� ) */
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    33,
                    iPrevDate,
                    OUTPUT vSummParPrev,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    33,
                    iCurrDate,
                    OUTPUT vSummParCurr,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).

   IF vSummParCurr <> vSummParPrev THEN RETURN TRUE.

   /* �஢�ન �� ��������� ���⭮� ���� �� ��業⠬ � ��⮬ ����権 �� ����襭�� ( 35 ��ࠬ��� ) */
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    35,
                    iPrevDate,
                    OUTPUT vSummParPrev,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    35,
                    iCurrDate,
                    OUTPUT vSummParCurr,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).

   IF vSummParCurr <> vSummParPrev THEN RETURN TRUE.

   /* �஢�ન �� �������� �� ��業⠬ ( 10 ��ࠬ��� ) */
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    10,
                    iPrevDate,
                    OUTPUT vSummParPrev,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    10,
                    iCurrDate,
                    OUTPUT vSummParCurr,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).

   IF vSummParCurr <> vSummParPrev THEN RETURN TRUE.

   /* �஢�ન �� �������� �� ᢮������� ������ ��業⠬ ( 19 ��ࠬ��� ) */
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    19,
                    iPrevDate,
                    OUTPUT vSummParPrev,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).
   RUN STNDRT_PARAM(iContract,
                    iContCode,
                    19,
                    iCurrDate,
                    OUTPUT vSummParCurr,
                    OUTPUT vSumm-Db,
                    OUTPUT vSumm-Cr).
   IF vSummParCurr <> vSummParPrev THEN RETURN TRUE.


   /* �஢�ઠ ��������� �᭮����� �����樥�� ᮧ����� १�ࢠ */
   vPrevRsrvRate = LnRsrvRate(iContract, iContCode, iPrevDate).
   vCurrRsrvRate = LnRsrvRate(iContract, iContCode, iCurrDate).

   IF vPrevRsrvRate <> vCurrRsrvRate THEN RETURN TRUE.

   /* �஢�ઠ ��������� �⮨���� ���ᯥ祭�� */
   FOR EACH term-obl WHERE
            term-obl.contract  = iContract
        AND term-obl.cont-code = iContCode
        AND term-obl.idnt      = 5
        AND ((term-obl.sop-date  > iPrevDate) OR
             (term-obl.sop-date  = ?))
   NO-LOCK:
      vPrevPledgeSum = LnPledgeQuality(iContract,
                                       iContCode,
                                       term-obl.idnt,
                                       term-obl.end-date,
                                       term-obl.nn,
                                       iPrevDate,
                                       term-obl.currency).

      vCurrPledgeSum = LnPledgeQuality(iContract,
                                       iContCode,
                                       term-obl.idnt,
                                       term-obl.end-date,
                                       term-obl.nn,
                                       iCurrDate,
                                       term-obl.currency).

      IF vPrevPledgeSum <> vCurrPledgeSum THEN RETURN TRUE.

   END. /*FOR EACH*/

   IF b-loan.cont-type = "��祭��" THEN
   DO:
      FOR EACH loan WHERE loan.contract = iContract
                      AND loan.cont-code BEGINS iContCode
                      AND NUM-ENTRIES(loan.cont-code, " ") = 2
                      AND ENTRY(1, loan.cont-code, " ") = iContCode
                      AND loan.open-date <= iCurrDate
      NO-LOCK:

         FOR EACH term-obl WHERE
                  term-obl.contract  = loan.contract
              AND term-obl.cont-code = loan.cont-code
              AND term-obl.idnt      = 5
              AND ((term-obl.sop-date  > iPrevDate) OR
                   (term-obl.sop-date = ?))
         NO-LOCK:
            vPrevPledgeSum = LnPledgeQuality(loan.contract,
                                             loan.cont-code,
                                             term-obl.idnt,
                                             term-obl.end-date,
                                             term-obl.nn,
                                             iPrevDate,
                                             term-obl.currency).

            vCurrPledgeSum = LnPledgeQuality(loan.contract,
                                             loan.cont-code,
                                             term-obl.idnt,
                                             term-obl.end-date,
                                             term-obl.nn,
                                             iCurrDate,
                                             term-obl.currency).

            IF vPrevPledgeSum <> vCurrPledgeSum THEN RETURN TRUE.

         END. /*FOR EACH term-obl*/

      END. /*FOR EACH loan*/

   END. /*IF "��祭��"*/
   ELSE DO:
      /* �஢�ઠ - �� ���� �� ⥪�騩 ������� �࠭襬 ������饣�
         �������. �᫨ ��, � �஢������ ��������� �㬬� ���ᯥ祭��,
         ��ॣ����஢������ �� ������饬 ������� � �⭮��饣��� �
         ������� �࠭��.
      */

      IF NUM-ENTRIES(iContCode, " ") = 2 THEN DO:

         FIND FIRST b-upper-loan WHERE
                    b-upper-loan.contract  = iContract
                AND b-upper-loan.cont-code = ENTRY(1, iContCode, " ")
                AND b-upper-loan.cont-type = "��祭��"
         NO-LOCK NO-ERROR.

         IF AVAIL(b-upper-loan) THEN DO:
            /*
               ��-�����, �ॡ�� �஢�ન ��������� �業�� ���ᯥ祭��
               (� ����� �⮣� ���ᯥ祭��) �� ������饬� ��������.
            */

            FOR EACH term-obl WHERE
                     term-obl.contract  = b-upper-loan.contract
                 AND term-obl.cont-code = b-upper-loan.cont-code
                 AND term-obl.idnt      = 5
                 AND ((term-obl.sop-date  > iPrevDate) OR
                      (term-obl.sop-date = ?))
            NO-LOCK:
               vPrevPledgeSum = LnPledgeQuality(b-upper-loan.contract,
                                                b-upper-loan.cont-code,
                                                term-obl.idnt,
                                                term-obl.end-date,
                                                term-obl.nn,
                                                iPrevDate,
                                                term-obl.currency).

               vCurrPledgeSum = LnPledgeQuality(b-upper-loan.contract,
                                                b-upper-loan.cont-code,
                                                term-obl.idnt,
                                                term-obl.end-date,
                                                term-obl.nn,
                                                iCurrDate,
                                                term-obl.currency).

               IF vPrevPledgeSum <> vCurrPledgeSum THEN RETURN TRUE.

            END. /*FOR EACH term-obl*/

            /*
               ��-�����, �ॡ�� �஢�ન ��������� ���� �᭮����� �����,
               �⭮��饩�� � ⥪�饬� �祭��, � ��饩 ������������
               �� �ᥬ �࠭蠬. ��������� ����� ���� �맢���, ���ਬ��,
               �뤠祩 ������ �࠭�.
            */

            /* ������������� �� �᭮����� ����� �� ⥪�饬� �������� */
            vPrevPrnAmt = LnPrincipal(iContract,iContCode,
                                      iPrevDate,b-loan.currency).

            vCurrPrnAmt = LnPrincipal(iContract,iContCode,
                                      iCurrDate,b-loan.currency).

            /* ��� ��� �祭�� ������饣� �������, �஬� ��, ����� ������
               ����� iPrevDate ��� ������� ࠭�� iPrevDate
            */
            FOR EACH loan WHERE
                     loan.contract = b-upper-loan.contract
                 AND loan.cont-code BEGINS b-upper-loan.cont-code
                 AND NUM-ENTRIES(loan.cont-code, " ") = 2
                 AND ENTRY(1, loan.cont-code, " ") = b-upper-loan.cont-code
                 AND b-loan.open-date <= iPrevDate
            NO-LOCK:

               IF loan.close-date <> ? AND loan.close-date <= iPrevDate THEN NEXT.

               /* ࠧ��� ���� �� ��।���� �祭�� */
               vPrevPrnAmtTr = LnPrincipal(loan.contract,loan.cont-code,
                                           iPrevDate,loan.currency).
               /* ࠧ��� ���� �� ᮣ��襭�� */
               vPrevTotPrnAmt = vPrevTotPrnAmt +  vPrevPrnAmtTr.
            END.

            /* ��� ��� �祭�� ������饣� �������, �஬� ��, ����� ������
               ����� iCurrDate ��� ������� ࠭�� iCurrDate
            */
            FOR EACH loan WHERE
                     loan.contract = b-upper-loan.contract
                 AND loan.cont-code BEGINS b-upper-loan.cont-code
                 AND NUM-ENTRIES(loan.cont-code, " ") = 2
                 AND ENTRY(1, loan.cont-code, " ") = b-upper-loan.cont-code
                 AND b-loan.open-date <= iCurrDate
            NO-LOCK:

               IF loan.close-date <> ? AND loan.close-date <= iCurrDate THEN NEXT.

               /* ࠧ��� ���� �� ��।���� �祭�� */
               vCurrPrnAmtTr = LnPrincipal(loan.contract,loan.cont-code,
                                           iCurrDate,loan.currency).
               /* ࠧ��� ���� �� ᮣ��襭�� */
               vCurrTotPrnAmt = vCurrTotPrnAmt +  vCurrPrnAmtTr.
            END.

            IF (vPrevTotPrnAmt > 0) AND (vCurrTotPrnAmt > 0) THEN
               IF (vPrevPrnAmt / vPrevTotPrnAmt) NE
                  (vCurrPrnAmt / vCurrTotPrnAmt) THEN RETURN YES.

            IF (vPrevTotPrnAmt > 0) AND (vCurrTotPrnAmt = 0) THEN RETURN YES.
            IF (vPrevTotPrnAmt = 0) AND (vCurrTotPrnAmt > 0) THEN RETURN YES.

         END.

      END.

   END.

   RETURN FALSE.

END FUNCTION.

/*=*/
/*---------------------------------------------------------------------------
  Function   : LnRsrvBal
  Name       : ���⮪ १�ࢠ
  Purpose    : �����頥� ���⮪ १�ࢠ �� ��筮� � ����祭��� ������������,
               䠪��᪨ ᮧ������� �� ��������, �� 㪠������ ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvBal RETURNS DECIMAL (INPUT iContract AS CHAR,
                                    INPUT iContCode AS CHAR,
                                    INPUT iDate     AS DATE,
                                    INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mspar      AS CHAR NO-UNDO. /* ᯨ᮪ ��ࠬ��஢ */
   DEF VAR mi         AS INT64  NO-UNDO.
   DEF VAR mpar       AS INT64  NO-UNDO.
   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* ����� ������� */
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   mspar = "21,46". /* ��ࠬ���� ��� ���� १�ࢠ �� �������� */

   DO mi = 1 TO NUM-ENTRIES(mspar):

      mpar = INT64(ENTRY(mi,mspar)).

      RUN RE_PARAM IN h_Loan ( mpar,                 /* ��� ��ࠬ��� */
                               iDate,                /* ��� ���� */
                               iContract,            /* ��� ������� */
                               iContCode,            /* ����� ������� */
                               OUTPUT vParamSumm,    /* �㬬� ��ࠬ��� */
                               OUTPUT vDb,           /* ����� ������ */
                               OUTPUT vCr).          /* �।�⮢� ������ */

      vRes = vRes + vParamSumm.

   END.

   IF iCurrency <> "" THEN
      vRes = CurToCurWork("����", "", iCurrency, iDate, vRes).

   mResult = CurrRound(vRes,iCurrency).

   IF mResult < 0.00 THEN mResult = ABSOLUTE(mResult).
                     ELSE mResult = 0.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND vRes = 0)  THEN
   DO:
       OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ���᫥��� ���⪠ १�ࢠ, 䠪��᪨ ᮧ������� �� ��������, �� "
          STRING(iDate, "99/99/9999") + "."
          SKIP.

       DO mi = 1 TO NUM-ENTRIES(mspar):
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
             ".  ��ࠬ��� "
             mpar FORMAT ">9"
             ". ���⮪ � ��樮���쭮� �����: "
             vParamSumm FORMAT "->>>,>>>,>>>,>>9.99"
             SKIP.
       END.

       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ����稭� ���⪠ १�ࢠ, 䠪��᪨ ᮧ������� �� ��������, � ����� "
          iCurrency FORMAT "x(3)"
          ": "
          mResult FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.
       OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvBalGoodDebt
  Name       : ���⮪ १�ࢠ
  Purpose    : �����頥� ���⮪ १�ࢠ �� ��筮� ������������, 䠪��᪨
               ᮧ������� �� ��������, �� 㪠������ ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvBalGoodDebt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                            INPUT iContCode AS CHAR,
                                            INPUT iDate     AS DATE,
                                            INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mpar       AS INT64  NO-UNDO.
   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* ����� ������� */
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   mpar = 21. /* ��ࠬ��� ��� ���� १�ࢠ */

   RUN RE_PARAM IN h_Loan ( mpar,                 /* ��� ��ࠬ��� */
                            iDate,                /* ��� ���� */
                            iContract,            /* ��� ������� */
                            iContCode,            /* ����� ������� */
                            OUTPUT vParamSumm,    /* �㬬� ��ࠬ��� */
                            OUTPUT vDb,           /* ����� ������ */
                            OUTPUT vCr).          /* �।�⮢� ������ */

   vRes = vParamSumm.

   IF iCurrency <> "" THEN
      vRes = CurToCurWork("����", "", iCurrency, iDate, vRes).

   mResult = CurrRound(vRes,iCurrency).

   IF mResult < 0.00 THEN mResult = ABSOLUTE(mResult).
                     ELSE mResult = 0.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND vRes = 0)  THEN
   DO:
       OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ���᫥��� ���⪠ १�ࢠ �� ��筮� ������������, 䠪��᪨ ᮧ������� �� ��������, �� "
          STRING(iDate, "99/99/9999") + "."
          SKIP.


       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ��ࠬ��� "
          mpar FORMAT ">9"
          ". ���⮪ � ��樮���쭮� �����: "
          vParamSumm FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.

       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ����稭� ���⪠ १�ࢠ �� ��筮� ������������, 䠪��᪨ ᮧ������� �� ��������, � ����� "
          iCurrency FORMAT "x(3)"
          ": "
          mResult FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.
       OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvBalBadDebt
  Name       : ���⮪ १�ࢠ
  Purpose    : �����頥� ���⮪ १�ࢠ �� ����祭��� ������������, 䠪��᪨
               ᮧ������� �� ��������, �� 㪠������ ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvBalBadDebt RETURNS DECIMAL (INPUT iContract AS CHAR,
                                           INPUT iContCode AS CHAR,
                                           INPUT iDate     AS DATE,
                                           INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mpar       AS INT64  NO-UNDO.
   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* ����� ������� */
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   mpar = 46. /* ��ࠬ��� ��� ���� १�ࢠ */

   RUN RE_PARAM IN h_Loan ( mpar,                 /* ��� ��ࠬ��� */
                            iDate,                /* ��� ���� */
                            iContract,            /* ��� ������� */
                            iContCode,            /* ����� ������� */
                            OUTPUT vParamSumm,    /* �㬬� ��ࠬ��� */
                            OUTPUT vDb,           /* ����� ������ */
                            OUTPUT vCr).          /* �।�⮢� ������ */

   vRes = vParamSumm.

   IF iCurrency <> "" THEN
      vRes = CurToCurWork("����", "", iCurrency, iDate, vRes).

   mResult = CurrRound(vRes,iCurrency).

   IF mResult < 0.00 THEN mResult = ABSOLUTE(mResult).
                     ELSE mResult = 0.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2
              AND vRes = 0) THEN
   DO:
       OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ���᫥��� ���⪠ १�ࢠ �� ����祭��� ������������, 䠪��᪨ ᮧ������� �� ��������, �� "
          STRING(iDate, "99/99/9999") + "."
          SKIP.

       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ��ࠬ��� "
          mpar FORMAT ">9"
          ". ���⮪ � ��樮���쭮� �����: "
          vParamSumm FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.

       PUT STREAM out_s UNFORMATTED
          "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
          ".  ����稭� ���⪠ १�ࢠ �� ����祭��� ������������, 䠪��᪨ ᮧ������� �� ��������, � ����� "
          iCurrency FORMAT "x(3)"
          ": "
          mResult FORMAT "->>>,>>>,>>>,>>9.99"
          SKIP.
       OUTPUT STREAM out_s CLOSE.
   END.

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvBalTransh
  Name       : ���⮪ १�ࢠ
  Purpose    : �����頥� ���⮪ १�ࢠ �� ��筮� � ����祭��� ������������,
               䠪��᪨ ᮧ������� �� ��������, �� 㪠������ ����. �᫨ �������
               ����� ⨯ "��祭��" �����頥� ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvBalTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iDate     AS DATE,
                                          INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan    FOR loan.
   DEFINE BUFFER b-loan-up FOR loan.

   DEF VAR vPartRes   AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  INIT ? NO-UNDO.
   DEF VAR vPos       AS DEC  NO-UNDO.
   DEF VAR vAgrPos    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ���᫥��� ���⪠ १�ࢠ, 䠪��᪨ ᮧ������� �� ��������, �� "
      STRING(iDate, "99/99/9999") + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.
   IF b-loan.cont-type = "��祭��" THEN
   DO:
      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ������� ����� ⨯ '��祭��'. ��� ������஢ ⠪��� ���� ���⮪ १�ࢠ ��⠥��� ࠢ�� ���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN 0.00.
   END.

   IF NUM-ENTRIES(b-loan.cont-code, " ") = 2 AND
      CAN-FIND( FIRST b-loan-up WHERE
                      b-loan-up.cont-type = "��祭��"
                  AND b-loan-up.contract  = b-loan.contract
                  AND b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
              )
   THEN
   DO:
      FIND FIRST b-loan-up WHERE
                 b-loan-up.cont-type = "��祭��"
             AND b-loan-up.contract  = b-loan.contract
             AND b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
         NO-LOCK NO-ERROR.

      IF CAN-DO(GetXAttrInit(b-loan-up.class-code,"rel_type"), "�।���") THEN
      DO:
         vPos    = LnPrincipal(iContract, iContCode, iDate, iCurrency).
         vAgrPos = LnPrincipal(b-loan-up.contract,
                               b-loan-up.cont-code,
                               iDate,
                               iCurrency).

         /* ���� १�ࢠ �� ᮧ������� �� ������饬 ������� */
         vPartRes = IF vAgrPos = 0 THEN 0 ELSE vPos / vAgrPos.

         vRes = vPartRes * LnRsrvBal(b-loan-up.contract,
                                     b-loan-up.cont-code,
                                     iDate,
                                     iCurrency).
         mResult = Round(vRes,2).

      END.
   END.

   IF mResult = ? THEN
      mResult = LnRsrvBal(iContract, iContCode, iDate, iCurrency).

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvBalGoodDebtTransh
  Name       : ���⮪ १�ࢠ �� ��筮� ������������
  Purpose    : �����頥� ���⮪ १�ࢠ �� ��筮� ������������, 䠪��᪨
               ᮧ������� �� ��������, �� 㪠������ ����. �᫨ ������� �����
               ⨯ "��祭��" �����頥� ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvBalGoodDebtTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                                  INPUT iContCode AS CHAR,
                                                  INPUT iDate     AS DATE,
                                                  INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan    FOR loan.
   DEFINE BUFFER b-loan-up FOR loan.

   DEF VAR vPartRes   AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  INIT ? NO-UNDO.
   DEF VAR vPos       AS DEC  NO-UNDO.
   DEF VAR vAgrPos    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ���᫥��� ���⪠ १�ࢠ �� ��筮� ������������, 䠪��᪨ ᮧ������� �� ��������, �� "
      STRING(iDate, "99/99/9999") + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   IF b-loan.cont-type = "��祭��" THEN
   DO:
      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ������� ����� ⨯ '��祭��'. ��� ������஢ ⠪��� ���� ���⮪ १�ࢠ ��⠥��� ࠢ�� ���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN 0.00.
   END.

   IF NUM-ENTRIES(b-loan.cont-code, " ") = 2 AND
      CAN-FIND( FIRST b-loan-up WHERE
                      b-loan-up.cont-type = "��祭��"
                  AND b-loan-up.contract  = b-loan.contract
                  AND b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
              )
   THEN
   DO:
      FIND FIRST b-loan-up WHERE
                 b-loan-up.cont-type = "��祭��"
             AND b-loan-up.contract  = b-loan.contract
             AND b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
         NO-LOCK NO-ERROR.

      IF CAN-DO(GetXAttrInit(b-loan-up.class-code,"rel_type"), "�।���") THEN
      DO:
         vPos     = LnGoodDebt(iContract, iContCode, iDate, iCurrency).
         vAgrPos  = LnGoodDebt(b-loan-up.contract,
                               b-loan-up.cont-code,
                               iDate,
                               iCurrency).

         /* ���� १�ࢠ �� ᮧ������� �� ������饬 ������� */
         vPartRes = IF vAgrPos = 0 THEN 0 ELSE vPos / vAgrPos.

         vRes = vPartRes * LnRsrvBalGoodDebt(b-loan-up.contract,
                                             b-loan-up.cont-code,
                                             iDate,
                                             iCurrency).
         mResult = Round(vRes,2).

      END.
   END.

   IF mResult = ? THEN
      mResult = LnRsrvBalGoodDebt(iContract, iContCode, iDate, iCurrency).

   RETURN mResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnRsrvBalBadDebtTransh
  Name       : ���⮪ १�ࢠ �� ����祭��� ������������
  Purpose    : �����頥� ���⮪ १�ࢠ �� ����祭��� ������������, 䠪��᪨
               ᮧ������� �� ��������, �� 㪠������ ����. �᫨ ������� �����
               ⨯ "��祭��" �����頥� ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvBalBadDebtTransh RETURNS DECIMAL (INPUT iContract AS CHAR,
                                                 INPUT iContCode AS CHAR,
                                                 INPUT iDate     AS DATE,
                                                 INPUT iCurrency AS CHAR).
   DEFINE BUFFER b-loan    FOR loan.
   DEFINE BUFFER b-loan-up FOR loan.

   DEF VAR vPartRes   AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  INIT ? NO-UNDO.
   DEF VAR vPos       AS DEC  NO-UNDO.
   DEF VAR vAgrPos    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(b-loan.doc-ref, " ") = 2) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
      ".  ���᫥��� ���⪠ १�ࢠ �� ����祭��� ������������, 䠪��᪨ ᮧ������� �� ��������, �� "
      STRING(iDate, "99/99/9999") + " (�����: ���� �� �࠭蠬)."
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   IF b-loan.cont-type = "��祭��" THEN
   DO:
      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " b-loan.doc-ref FORMAT "X(22)"
         ".  ������� ����� ⨯ '��祭��'. ��� ������஢ ⠪��� ���� ���⮪ १�ࢠ ��⠥��� ࠢ�� ���."
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      RETURN 0.00.
   END.

   IF NUM-ENTRIES(b-loan.cont-code, " ") = 2 AND
      CAN-FIND( FIRST b-loan-up WHERE
                      b-loan-up.cont-type = "��祭��"
                  AND b-loan-up.contract  = b-loan.contract
                  AND b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
              )
   THEN
   DO:
      FIND FIRST b-loan-up WHERE
                 b-loan-up.cont-type = "��祭��"
             AND b-loan-up.contract  = b-loan.contract
             AND b-loan-up.cont-code = ENTRY(1,b-loan.cont-code, " ")
         NO-LOCK NO-ERROR.

      IF CAN-DO(GetXAttrInit(b-loan-up.class-code,"rel_type"), "�।���") THEN
      DO:
         vPos    = LnBadDebt(iContract, iContCode, iDate, iCurrency).
         vAgrPos = LnBadDebt(b-loan-up.contract,
                             b-loan-up.cont-code,
                             iDate,
                             iCurrency).

         /* ���� १�ࢠ �� ᮧ������� �� ������饬 ������� */
         vPartRes = IF vAgrPos = 0 THEN 0 ELSE vPos / vAgrPos.

         vRes = vPartRes * LnRsrvBalBadDebt(b-loan-up.contract,
                                            b-loan-up.cont-code,
                                            iDate,
                                            iCurrency).
         mResult = Round(vRes,2).

      END.
   END.

   IF mResult = ? THEN
      mResult = LnRsrvBalBadDebt(iContract, iContCode, iDate, iCurrency).

   RETURN mResult.

END FUNCTION.

/*----------------------------------------------------------------------------

  Procedure  : LnTurnoverDb
  Name       : ����� �㬬�୮�� ����� �� �뤠� �।�� � ��८業�� � ��砫�
               �����.
  Purpose    : ����� ����稭� �㬬�୮�� ����� �� �।��⠢����� ���� �
               ������⥫쭮� ��८業�� � ��砫� ���⭮�� �����.
               �����頥� ����稭�:
               - �㬬��� ����� �� �뤠� ����, � ����� १����(oTurnoverDb);
               - �㬬��� ����� �� ������⥫쭮� ��८業�� ����, � �����
                 १����(VRevalDb);
               - ������⢮ ����樮���� ���� � ��砫� ����� �� ���� ���� (oCounter).
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
               oTurnoverDb - �㬬��� ����� �� �뤠� ���� � ����� १����
               oRevalDb    - �㬬��� ����� �� ������⥫쭮� ��८業�� ���� �
                             ����� १����
               oCounter    - ������⢮ ����樮���� ���� � ��砫� ����� �� ����
                             ����
  Notes      :
  ----------------------------------------------------------------------------*/
PROCEDURE LnTurnoverDb.
   DEF INPUT  PARAM iContract    AS CHARACTER NO-UNDO.
   DEF INPUT  PARAM iContCode    AS CHARACTER NO-UNDO.
   DEF INPUT  PARAM iDate        AS DATE      NO-UNDO.
   DEF INPUT  PARAM iCurrency    AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM oTurnoverDb  AS DECIMAL   NO-UNDO.
   DEF OUTPUT PARAM oRevalDb     AS DECIMAL   NO-UNDO.
   DEF OUTPUT PARAM oCounter     AS INT64   NO-UNDO.

   DEFINE BUFFER b-loan    FOR loan.
   DEFINE BUFFER b-op-date FOR op-date.

   DEFINE VARIABLE vbDate        AS DATE     NO-UNDO.
   DEFINE VARIABLE vPrevOpDate   AS DATE     NO-UNDO.
   DEFINE VARIABLE vReval        AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vRevalDb      AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vSumDb        AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vPrincipalY   AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vLoanRateY    AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vLoanRateT    AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vCurRateY     AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vCurRateT     AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vFromFirstDay AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE vByCalendDays AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE vFromOpenDate AS LOGICAL  NO-UNDO.
   DEFINE VARIABLE vDaysNbr      AS INT64  NO-UNDO.
   DEFINE VARIABLE vspar         AS CHAR NO-UNDO. /* ᯨ᮪ ��ࠬ��஢ */
   DEFINE VARIABLE oResVer    AS CHARACTER NO-UNDO .
   DEFINE VARIABLE oResVerP    AS CHARACTER NO-UNDO .

   vspar = "0,7,13". /* ��ࠬ���� ��� ���� �㬬 ���⪮� */
   Run GetSpisBaseParam IN THIS-PROCEDURE  (OUTPUT oResVer, OUTPUT oResVerP).
   IF oResVer <> "" THEN vspar = Trim(oResVer,",") + "," + Trim(oResVerP,",") .


   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN.
   END.

   vFromFirstDay = (FGetSetting("�������","����⍠猥�","���") = "��").
   vByCalendDays = (FGetSetting("�������","���������","��")     = "��").
   vFromOpenDate = (FGetSetting("�������","��瑤����","��")     = "��").

   vDaysNbr      = INT64(FGetSetting("�������","�������ਮ��","30")) NO-ERROR.
   IF (vDaysNbr = ?) OR (vDaysNbr LE 0) THEN vDaysNbr = 30.

   vbDate = IF vFromFirstDay THEN FirstMonDate(iDate)
                             ELSE (iDate - vDaysNbr + 1).
   IF vFromOpenDate THEN vbDate = MAX(vbDate, b-loan.open-date).

   vDaysNbr = iDate - vbDate + 1.

   ASSIGN
      vRevalDb = 0.00
      vSumDb   = 0.00
      oCounter = 0.

   IF b-loan.cont-type <> "��祭��" THEN

      FOR EACH b-op-date WHERE
               b-op-date.op-date >= vbDate
           AND b-op-date.op-date <= iDate
      NO-LOCK BY b-op-date.op-date:

         oCounter = oCounter + IF vFromOpenDate AND (b-op-date.op-date < b-loan.open-date) THEN 0 ELSE 1.

         /* ��� �।��饣� ����樮����� ��� */
         FIND LAST op-date WHERE op-date.op-date < b-op-date.op-date NO-LOCK NO-ERROR.

         vPrevOpDate = IF AVAIL op-date THEN op-date.op-date
                                        ELSE b-op-date.op-date.

         ASSIGN
           vLoanRateT = IF b-loan.Currency <> ""
                        THEN FindRate("����", b-loan.Currency, b-op-date.op-date)
                        ELSE 1

           vCurRateT  = IF iCurrency <> ""
                        THEN FindRate("����", iCurrency, b-op-date.op-date)
                        ELSE 1
           .

         IF b-op-date.op-date >= b-loan.open-date THEN DO:

            vRevalDb = 0.00.

            IF b-loan.Currency <> iCurrency THEN DO:
               /* ����稭� �᭮����� ����� �� �������� � ����� ������� */
               vPrincipalY = LnPrincipal(iContract,iContCode,vPrevOpDate,b-loan.Currency).

               /* ���� ����� ������ ������� � ������ १���� �� �।��騩 �
                  ⥪�騩 ����樮��� ����
               */
               ASSIGN
                  vLoanRateY = IF b-loan.Currency <> ""
                               THEN FindRate("����", b-loan.Currency, vPrevOpDate)
                               ELSE 1

                  vCurRateY  = IF iCurrency <> ""
                               THEN FindRate("����", iCurrency, vPrevOpDate)
                               ELSE 1
                  .

               /* ����稭� ��८業�� �᭮����� ����� � ����� १���� */
               vReval = CurrRound(vPrincipalY * vLoanRateT / vCurRateT, iCurrency) -
                        CurrRound(vPrincipalY * vLoanRateY / vCurRateY, iCurrency).

               IF vReval > 0 THEN vRevalDb = vReval.
            END.

            vSumDb = 0.

            FOR EACH loan-int WHERE
                     loan-int.contract  = iContract
                 AND loan-int.cont-code = iContCode
                 AND loan-int.mdate     > vPrevOpDate
                 AND loan-int.mdate    <= b-op-date.op-date
                 AND loan-int.mdate    >= vbDate
                 AND loan-int.id-d = 0
                 AND NOT CAN-DO(vspar, STRING(loan-int.id-k))  /* 0,7,13 */
            NO-LOCK:
               vSumDb = vSumDb + IF vLoanRateT = vCurRateT THEN loan-int.amt-rub ELSE
                        CurrRound(loan-int.amt-rub * vLoanRateT / vCurRateT, iCurrency).
            END.

         END.

         ASSIGN
            oRevalDb    = oRevalDb + vRevalDb
            oTurnoverDb = oTurnoverDb + vSumDb.

      END. /*FOR EACH b-op-date*/


   ELSE /* ��祭�� */

      FOR EACH b-op-date WHERE
               b-op-date.op-date >= vbDate
           AND b-op-date.op-date <= iDate
      NO-LOCK BY b-op-date.op-date:

         oCounter = oCounter + IF vFromOpenDate AND (b-op-date.op-date < b-loan.open-date) THEN 0 ELSE 1.

         /* ��� �।��饣� ����樮����� ��� */
         FIND LAST op-date WHERE op-date.op-date < b-op-date.op-date NO-LOCK NO-ERROR.

         vPrevOpDate = IF AVAIL op-date THEN op-date.op-date
                                        ELSE b-op-date.op-date.

         ASSIGN
            vLoanRateT = IF b-loan.Currency <> ""
                         THEN FindRate("����", b-loan.Currency, b-op-date.op-date)
                         ELSE 1

            vCurRateT  = IF iCurrency <> ""
                         THEN FindRate("����", iCurrency, b-op-date.op-date)
                         ELSE 1
            .

         FOR EACH loan WHERE
                  loan.contract = iContract
              AND loan.cont-code BEGINS iContCode
              AND NUM-ENTRIES(loan.cont-code, " ") = 2
              AND ENTRY(1, loan.cont-code, " ") = iContCode
              AND loan.open-date <= iDate
              AND NOT (loan.close-date <> ? AND loan.close-date <= vbDate)
         NO-LOCK:

            IF b-op-date.op-date >= loan.open-date THEN DO:

               vRevalDb = 0.00.

               IF loan.Currency <> iCurrency THEN DO:
                  /* ����稭� �᭮����� ����� �� �������� � ����� ������� */
                  vPrincipalY = LnPrincipal(iContract,iContCode,vPrevOpDate,loan.Currency).

                  /* ���� ����� ������ ������� � ������ १���� */
                  ASSIGN
                     vLoanRateY = IF loan.Currency <> ""
                                  THEN FindRate("����", loan.Currency, vPrevOpDate)
                                  ELSE 1

                     vCurRateY  = IF iCurrency <> ""
                                  THEN FindRate("����", iCurrency, vPrevOpDate)
                                  ELSE 1
                     .

                  /* ����稭� ��८業�� �᭮����� ����� � ����� १���� */
                  vReval = CurrRound(vPrincipalY * vLoanRateT / vCurRateT, iCurrency) -
                           CurrRound(vPrincipalY * vLoanRateY / vCurRateY, iCurrency).

                  IF vReval > 0 THEN vRevalDb = vReval.
               END.

               vSumDb = 0.

               FOR EACH loan-int WHERE
                        loan-int.contract  = iContract
                    AND loan-int.cont-code = loan.cont-code
                    AND loan-int.mdate     > vPrevOpDate
                    AND loan-int.mdate    <= b-op-date.op-date
                    AND loan-int.mdate    >= vbDate
                    AND loan-int.id-d = 0
                    AND NOT CAN-DO(vspar, STRING(loan-int.id-k)) /* 0,7,13 */
               NO-LOCK:
                  vSumDb = vSumDb + IF vLoanRateT = vCurRateT THEN loan-int.amt-rub ELSE
                           CurrRound(loan-int.amt-rub * vLoanRateT / vCurRateT, iCurrency).
               END.

            END.

            ASSIGN
               oRevalDb    = oRevalDb + vRevalDb
               oTurnoverDb = oTurnoverDb + vSumDb.

         END. /* FOR EACH b-loan*/

      END. /*FOR EACH b-op-date*/

  IF vByCalendDays THEN oCounter = vDaysNbr.

END PROCEDURE.

/*---------------------------------------------------------------------------
  Function   : LnAvgTurnoverDb
  Name       : ����� �।���� ����� �� �뤠� �।�� � ��८業�� � ��砫�
               �����
  Purpose    : ����� ����稭� �।���� ����� �� �।��⠢����� ���� �
               ��८業�� � ��砫� ���⭮�� ����� � ����� १���� iCurrency.
               �����頥� ����稭�:
               - �।��� ����� �� �뤠� ���� � ��८業��, � �����
                 १����(vAvgTurnoverDb).
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnAvgTurnoverDb RETURNS DECIMAL (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iDate     AS DATE,
                                          INPUT iCurrency AS CHAR).

   DEFINE VARIABLE vTurnoverDb  AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vRevalDb     AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vCounter     AS INT64  NO-UNDO.

   DEFINE BUFFER b-loan FOR loan.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.

   RUN LnTurnoverDb ( iContract,
                      iContCode,
                      iDate,
                      iCurrency,
                      OUTPUT vTurnoverDb,
                      OUTPUT vRevalDb,
                      OUTPUT vCounter ).

   IF vCounter = 0 THEN
      RETURN 0.00.
   ELSE
      RETURN CurrRound((vTurnoverDb + vRevalDb) / vCounter, iCurrency).

END FUNCTION.

/*----------------------------------------------------------------------------
  Procedure  : LnORsrvCalcBase
  Name       : ����� ���� ��� ��।������ �������쭮� ����稭� �ନ�㥬���
               १�ࢠ.
  Purpose    : ����� ���� ��� ��।������ �������쭮� ����稭� �ନ�㥬���
               १�ࢠ.
               �����頥� ����稭�:
                 oPP - ��।������ ��� ������ �� ���� ����稭 (� ����� १����):
                       1) �㡫��� ���������� ���⪠ ��� �� ��᫥���� ࠡ�稩
                          ���� �����;
                       2) �।��������� ����� ����⮢� ����� � ��⮬
                          ����⮢�� ����⮢, ���᫮������� ��८業���.
                 oP = 50% * (oPP - C) + C � ����� १����, ���
                      � - ���⮪ ��㤭�� ������������;
                      � - 䠪��᪨ ��ନ஢���� १�� �� �������� ���� �� ��㤠�
                          ��� ������ �������������.
                 oIsBadDebt - �ਧ��� ����������� ������������.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
               oPP         -
               oP          -
               oIsBadDebt  -
  Notes      :
  ----------------------------------------------------------------------------*/
PROCEDURE LnORsrvCalcBase.
   DEF INPUT  PARAM iContract    AS CHARACTER NO-UNDO.
   DEF INPUT  PARAM iContCode    AS CHARACTER NO-UNDO.
   DEF INPUT  PARAM iDate        AS DATE      NO-UNDO.
   DEF INPUT  PARAM iCurrency    AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM oPP          AS DECIMAL   NO-UNDO.
   DEF OUTPUT PARAM oP           AS DECIMAL   NO-UNDO.
   DEF OUTPUT PARAM oIsBadDebt   AS LOGICAL   NO-UNDO.

   DEFINE VARIABLE vPrincipal       AS DECIMAL  NO-UNDO. /*���⮪ ������������ �� ��㤥*/
   DEFINE VARIABLE vAvgTurnoverDb   AS DECIMAL  NO-UNDO. /*�।��������� �����*/
   DEFINE VARIABLE vBadDebtCategory AS INT64 INIT ? NO-UNDO. /*��⥣��� ����⢠ ��� oP*/
   DEFINE VARIABLE vGrRiska         AS INT64 INIT ? NO-UNDO. /*��⥣��� ����⢠ ����*/

   DEF BUFFER comm-rate FOR comm-rate.

   vPrincipal       = LnPrincipal(iContract,iContCode,iDate,iCurrency).
   vAvgTurnoverDb   = LnAvgTurnoverDb(iContract,iContCode,iDate,iCurrency).
   oPP              = MAXIMUM(vPrincipal, vAvgTurnoverDb).
   oP               = CurrRound( 0.5 * (oPP - vPrincipal), iCurrency) + vPrincipal.

   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(iContCode, " ") = 2
              AND vPrincipal = 0
              AND vAvgTurnoverDb = 0) THEN
   DO:
   OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
   PUT STREAM out_s UNFORMATTED
      "���ଠ��  �������: " iContCode FORMAT "x(22)"
      ".  [����稭� ��] = ��������( [���� ������.], [�।��� ����⮢� �����])" SKIP
      "���ଠ��  �������: " iContCode FORMAT "x(22)"
      ".  " STRING(oPP, "->>>,>>>,>>>,>>9.99") " = "
      "��������(" STRING(vPrincipal, "->>>,>>>,>>>,>>9.99") ", "
      STRING(vAvgTurnoverDb, "->>>,>>>,>>>,>>9.99") ")."
      SKIP
      "���ଠ��  �������: " iContCode FORMAT "x(22)"
      ".  [����稭� �] = 0.5 * ([����稭� ��] - [���� ������.]) + [���� ������.]." SKIP
      "���ଠ��  �������: " iContCode FORMAT "x(22)"
      ".  " STRING(oP, "->>>,>>>,>>>,>>9.99") " = "
      "0.5 * (" STRING(oPP, "->>>,>>>,>>>,>>9.99") " - "
      STRING(vPrincipal, "->>>,>>>,>>>,>>9.99") ") + "
      STRING(vPrincipal, "->>>,>>>,>>>,>>9.99")
      SKIP.
   OUTPUT STREAM out_s CLOSE.
   END.

   /*���� �� ��㤠 �����������:*/
   vBadDebtCategory = INT64(FGetSetting("�������", "��������㤠����", "0")) NO-ERROR.
   IF vBadDebtCategory = ? THEN vBadDebtCategory = 0.

   /* �᫨ ����஥�� ��ࠬ��� "��������㤠����" ����� ���祭�� 0, �
      �� ��㤠 ��⠥��� ���筮�: oIsBadDebt = NO */

   IF vBadDebtCategory = 0 THEN oIsBadDebt = NO.
   ELSE DO:
      /*�����樥�� १�ࢨ஢���� ���� */
      RUN GET_COMM_LOAN_BUF IN h_Loan (iContract,
                                       iContCode,
                                       "%���",
                                       iDate,
                                       BUFFER comm-rate).

      /*��⥣��� ����⢠ ���� - ��㯯� �᪠*/
      IF AVAIL comm-rate THEN
         vGrRiska = LnGetGrRiska(comm-rate.rate-comm, iDate).

      IF (vGrRiska = 0) OR (vGrRiska = ?) THEN vGrRiska = 1.

      IF vGrRiska < vBadDebtCategory THEN oIsBadDebt = NO.
                                     ELSE oIsBadDebt = YES.
   END.

END PROCEDURE.

/*---------------------------------------------------------------------------
  Function   : LnORsrvRate
  Name       : ���� ���᫥��� � १�� ��� ����樨 � १����⮬ ���୮� ����.
  Purpose    : �����頥� ࠧ��� ���� ���᫥��� � १�� ��� ����,
               �।��⠢������ १������ ���୮� ����.

  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION LnORsrvRate RETURNS DECIMAL (
   INPUT iContract AS CHAR,
   INPUT iContCode AS CHAR,
   INPUT iDate     AS DATE
):
   DEFINE VARIABLE vRate    AS DECIMAL NO-UNDO.
   DEFINE VARIABLE vOfShore AS CHARACTER INIT ? NO-UNDO.
   DEFINE VARIABLE vOSGroup AS CHARACTER INIT ? NO-UNDO.
   DEFINE VARIABLE vPos     AS CHARACTER NO-UNDO. /* ��� ����. */

   DEFINE BUFFER b-loan FOR loan.
   DEFINE BUFFER b-code FOR code.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF NOT AVAIL b-loan THEN
   DO:
      IF mIfPutPtot THEN
         loanNotFound (iContCode).
      RETURN ?.
   END.
                        /* �᫨ ��㤠 �室�� � ���, � ��।��塞 �⠢�� �� ����. */
   vPos = LnInBagOnDate (b-loan.contract, b-loan.cont-code, iDate).
   IF vPos NE ?
   THEN DO:
      FIND FIRST loan WHERE
               loan.contract  EQ "���"
         AND   loan.cont-code EQ vPos
      NO-LOCK NO-ERROR.
      IF AVAIL loan
         THEN RETURN DEC (fGetBagRate ((BUFFER loan:handle), "%���", iDate, "rate-comm")).
   END.
   /* ���� �஭������᪨ ��᫥����� �����樥�� १�ࢨ஢���� �� �������� */
   vRate = GET_COMM ("%����",
                     ?,
                     b-loan.currency,
                     iContract + "," + iContCode,
                     0.00,
                     0,
                     iDate).

   IF vRate <> ? THEN RETURN vRate.

   /* ������� �� ⨯� "�祭��" -> ᬮ�ਬ ������騩 ������� */
   IF NUM-ENTRIES(iContCode, " ") = 2
   THEN
      RETURN LnORsrvRate(iContract,
                         ENTRY(1,iContCode, " "),
                         iDate).

   /* �᫨ �� ����� �������㠫�� �����樥�� १�ࢨ஢���� �� ��������,
      � �ᯮ��㥬 �⠢�� १�ࢨ஢���� ��� ���୮� ����. */
   vOfShore = LnOffShoreCode(iContract,iContCode).

   IF (vOfShore <> ?) AND (vOfShore <> "") THEN DO:
     vOSGroup = ENTRY(1,vOfShore,".").

     FIND FIRST b-code WHERE
                b-code.class  = "������"
            AND b-code.parent = "������"
            AND b-code.code   = vOSGroup
     NO-LOCK NO-ERROR.

     IF AVAILABLE(b-code) THEN DO:
       vRate = DECIMAL(b-code.val) NO-ERROR.
       IF vRate >= 0 THEN RETURN vRate.
     END.
   END.

   RETURN 0.00.

END FUNCTION.


/*---------------------------------------------------------------------------
  Function   : LnRsrvOffShore
  Name       :
  Purpose    : �ᯮ����⥫쭠� �㭪�� ��� LnFormRsrv � LnCalcRsrv.
               ���४���� ���祭�� �ନ�㥬��� � ���⭮�� १�ࢠ ���
               �����⮢ - १����⮢ ������� ���.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ��� ������
               iResult     - ࠧ��� १�ࢠ
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION LnRsrvOffShore RETURNS DECIMAL (INPUT iContract AS CHAR,
                                         INPUT iContCode AS CHAR,
                                         INPUT iDate     AS DATE,
                                         INPUT iCurrency AS CHAR,
                                         INPUT iResult   AS DEC).

   DEFINE VARIABLE vORsrvRate AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE oPP        AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE oP         AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE vRes       AS DECIMAL  NO-UNDO.
   DEFINE VARIABLE oIsBadDebt AS LOGICAL  NO-UNDO.

   vRes = iResult.

   IF LnIsOffShoreOperation(iContract,iContCode) THEN
   DO:

      IF mIfPutPtot THEN
      DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " iContCode FORMAT "x(22)"
         ".  ������ � १����⮬ ���୮� ����. "
         SKIP.
      OUTPUT STREAM out_s CLOSE.

      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " iContCode FORMAT "x(22)"
         ".  �।���⥫쭮 ����⠭��� ����稭� १�ࢠ: "
         STRING(iResult, "->>>,>>>,>>>,>>9.99")
         SKIP.
      OUTPUT STREAM out_s CLOSE.
      END.
      vORsrvRate = LnORsrvRate(iContract,iContCode,iDate).

      RUN LnORsrvCalcBase(iContract,
                          iContCode,
                          iDate,
                          iCurrency,
                          OUTPUT oPP,
                          OUTPUT oP,
                          OUTPUT oIsBadDebt).

      IF oIsBadDebt = YES THEN DO:

          vRes = MAX(iResult, CurrRound(iResult * (100 - vORsrvRate) / 100, iCurrency) +
                              CurrRound(oP * vORsrvRate / 100, iCurrency) ).

          IF mIfPutPtot THEN
          DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  ����������� �������������. " SKIP
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  [����ࢊ���] = ��������( [����࢏।���], "
             " [����࢏।���] * (100 - [%����])/100 + "
             " [����稭� �] * [%����]/100 ) " SKIP
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  " STRING(vRes, "->>>,>>>,>>>,>>9.99") " = "
             "��������( " STRING(iResult, "->>>,>>>,>>>,>>9.99") " * "
             " (100 - " STRING(vORsrvRate, "->>9.999999") ") / 100, "
             "(" STRING(oP, "->>>,>>>,>>>,>>9.99") " * "
             STRING(vORsrvRate, "->>9.999999") " / 100)."
             SKIP.
          OUTPUT STREAM out_s CLOSE.

          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  �⪮�४�஢�����          ����稭� १�ࢠ: "
             STRING(vRes, "->>>,>>>,>>>,>>9.99")
             SKIP.
          OUTPUT STREAM out_s CLOSE.
          END.

          RETURN vRes.
      END.
      ELSE DO:

          vRes = MAX(iResult, CurrRound(oPP * vORsrvRate / 100, iCurrency) ).

          IF mIfPutPtot THEN
          DO:
          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  [����ࢊ���] = ��������( [����࢏।���], "
             "[����稭� ��] * [%����]/100 ) " SKIP
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  " STRING(vRes, "->>>,>>>,>>>,>>9.99") " = "
             "��������( " STRING(iResult, "->>>,>>>,>>>,>>9.99") ", "
             STRING(oPP, "->>>,>>>,>>>,>>9.99") " * "
             STRING(vORsrvRate, "->>9.999999") " / 100)."
             SKIP.
          OUTPUT STREAM out_s CLOSE.

          OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
          PUT STREAM out_s UNFORMATTED
             "���ଠ��  �������: " iContCode FORMAT "x(22)"
             ".  �⪮�४�஢�����          ����稭� १�ࢠ: "
             STRING(vRes, "->>>,>>>,>>>,>>9.99")
             SKIP.
          OUTPUT STREAM out_s CLOSE.
          END.

          RETURN vRes.
      END.
   END.

   RETURN iResult.

END FUNCTION.

/* ��� ��᫥����� ��������� १�ࢠ, ���易����  � ���������� ���� */

PROCEDURE GET_DATE_RES.
   DEF INPUT PARAM iContract AS CHAR     NO-UNDO.
   DEF INPUT PARAM iContCode AS CHAR     NO-UNDO.
   DEF INPUT PARAM iDate     AS DATE     NO-UNDO .
   DEF INPUT PARAM iIdInt    AS INT64  NO-UNDO.

   DEF OUTPUT PARAM oDate AS DATE INIT ? NO-UNDO .

   DEFINE VARIABLE vListIdInt AS CHARACTER   NO-UNDO INIT "46,88,350,351,356,357,354,355".
   DEFINE VARIABLE vListType  AS CHARACTER   NO-UNDO INIT "�।���1,�।�����,�।����,�।�����,�।������,�।�������,�।����,�।������".
   DEFINE VARIABLE vNomType   AS INT64     NO-UNDO.

   DEF BUFFER loan FOR loan .
   DEF BUFFER loan-int FOR loan-int .
   DEF BUFFER xloan-int FOR loan-int .

   RUN RE_B_LOAN IN h_Loan (iContract, iContCode, BUFFER loan).
   IF AVAIL loan THEN DO:
      vNomType = LOOKUP(STRING(iIdInt),vListIdInt).
      IF LnRsrvCheckType(iContract,
                         iContCode,
                         IF vNomType NE 0
                         THEN ENTRY(vNomType,vListType)
                         ELSE "�।���"
                        )  /* �஢��塞, ������ �� �� �������� ��������� १�� */
      THEN DO:
         /* �饬 �������� �� ��������� १�ࢠ �� ��筮� ������������ */
         FOR EACH loan-int OF LOAN WHERE loan-int.mdate LE iDate NO-LOCK BY loan-int.mdate
         DESCENDING :
            IF loan-int.id-d =  iIdInt
            OR loan-int.id-k =  iIdInt
            THEN DO :
               oDate = loan-int.mdate .
               LEAVE .
            END.
         END.
      END.
   END.
END PROCEDURE.

/**/
PROCEDURE GET_CR:

   DEF INPUT PARAMETER iCommission  AS CHAR  NO-UNDO.
   DEF INPUT PARAMETER iAcct        AS CHAR  NO-UNDO.
   DEF INPUT PARAMETER iCurrency    AS CHAR  NO-UNDO.
   DEF INPUT PARAMETER iKau         AS CHAR  NO-UNDO.
   DEF INPUT PARAMETER iMinVlaue    AS INT64   NO-UNDO.
   DEF INPUT PARAMETER iPeriod      AS INT64   NO-UNDO.
   DEF OUTPUT PARAMETER TABLE FOR tt-cr.

   DEF BUFFER comm-rate FOR comm-rate.


   EMPTY TEMP-TABLE tt-cr.
   FOR EACH comm-rate WHERE
            comm-rate.commission = "%१" AND
            comm-rate.acct = "0" AND
            comm-rate.currency = iCurrency AND
            comm-rate.kau = iKau AND
            comm-rate.min-value = 0 AND
            comm-rate.period = 0 USE-INDEX kau NO-LOCK:

      CREATE tt-cr.
      ASSIGN
         tt-cr.recid-comm-rate = RECID(comm-rate)
         tt-cr.rate-comm = comm-rate.rate-comm
         tt-cr.since = comm-rate.since
      .

   END.

END PROCEDURE.

/*---------------------------------------------------------------------------
  Function   : Changes_GrRiska
  Name       : ��������� ��㯯� �᪠ � ⥪�饬 ���
  Purpose    : ��।���� 䠪� ��������� � ⥪�饬 ��� ��㯯� �᪠
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  ---------------------------------------------------------------------------*/

FUNCTION Changes_GrRiska RETURNS CHAR (
                      INPUT iContract AS CHAR,
                      INPUT iContCode AS CHAR,
                      INPUT iDate     AS DATE
):

   DEFINE VARIABLE oResult        AS CHARACTER NO-UNDO INIT "0".
   DEFINE VARIABLE vGrToday       AS INT64   NO-UNDO.
   DEFINE VARIABLE vGrPast        AS INT64   NO-UNDO.
   DEFINE VARIABLE vGrParam       AS INT64   NO-UNDO.
   /* ��室�� ���㠫��� ��㯯� �᪠ */
   ASSIGN
      vGrParam   =   INT64(FGetSetting("�302�","���ਧ���", "?"))
      vGrToday   =   re_history_risk(iContract,iContCode,iDate,?)
      /* ��室�� ��㯯� �᪠ �� �।��騩 ���� */
      vGrPast = re_history_risk(iContract,iContCode,iDate - 1,?)
   .
   /* �᫨ � �।���� ���� ��� ����ᥩ � ��⥣�ਨ �᪠ � �����頥� 0 */
   IF vGrPast NE ? THEN
   DO:
      IF vGrToday NE vGrPast
      THEN DO:
         IF     (vGrPast <= vGrParam)
            AND (vGrToday > vGrParam)
         THEN
            oResult = "2".
         ELSE IF (vGrPast > vGrParam) AND (vGrToday <= vGrParam)
         THEN
            oResult = "1".
      END.
   END.

   IF oResult EQ "0" THEN
      oResult = IF vGrToday > vGrParam
                THEN "3"
                ELSE "4".

   RETURN oResult.
END FUNCTION.
/*---------------------------------------------------------------------------
  Function   : GetChanges_GrRiska
  Name       : ��������� ��㯯� �᪠ � ⥪�饬 ���
  Purpose    : ��।���� 䠪� ��������� � ⥪�饬 ��� ��㯯� �᪠
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  ---------------------------------------------------------------------------*/

FUNCTION GetChanges_GrRiska RETURNS CHAR (
                      INPUT iContract AS CHAR,
                      INPUT iContCode AS CHAR,
                      INPUT iDate     AS DATE
):

   DEFINE VARIABLE oResult        AS CHARACTER NO-UNDO INIT "0".
   oResult = Changes_GrRiska (iContract,iContCode,iDate).
   IF oResult > "2" THEN oResult = "0".

   RETURN oResult.
END FUNCTION.
/*---------------------------------------------------------------------------
  Function   : Get_NachBal
  Name       : ��� ������� ��業��
  Purpose    : ��।���� ��� ������� ��業�� - �� ������ ��� ���������
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  ---------------------------------------------------------------------------*/
FUNCTION Get_NachBal RETURNS CHAR (
                      INPUT iContract AS CHAR,
                      INPUT iContCode AS CHAR,
                      INPUT iDate     AS DATE
):

    DEFINE VARIABLE oResult      AS CHAR NO-UNDO.
    oResult = Changes_GrRiska (iContract,iContCode,iDate).
    CASE oResult:
       WHEN "1" THEN  oResult = "2".
       WHEN "2" THEN  oResult = "1".
       WHEN "3" THEN  oResult = "2".
       WHEN "4" THEN  oResult = "1".
    END CASE.

    RETURN oResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnCalcRsrvProc
  Name       : ����� �����樥�� १�ࢨ஢����
  Purpose    : ����� �����樥�� १�ࢨ஢���� ( ��������� ��� ����祭��� � ���᫥���� ��業⮢ )
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
  ---------------------------------------------------------------------------*/
FUNCTION LnCalcRsrvProc RETURNS DEC (INPUT iContract  AS CHAR,
                                     INPUT iContCode  AS CHAR,
                                     INPUT iDate      AS DATE,
                                     INPUT iCurrency  AS CHAR):

   DEF VAR vParam     AS CHAR NO-UNDO INIT "21,46". /* ���᮪ ��ࠬ��஢ */
   &SCOPED-DEFINE   vParamNe0 "88" /* �᫨ �᭮���� ���� ������� �� �� 0 ��ࠬ���.*/
   DEF VAR vI         AS INT64  NO-UNDO.
   DEF VAR vSm-Tot    AS DEC EXTENT 2 NO-UNDO.
   DEF VAR vSm-Db     AS DEC  NO-UNDO.
   DEF VAR vSm-Cr     AS DEC  NO-UNDO.
   DEF VAR vSh-Bal    AS DEC  NO-UNDO.
   DEF VAR vSm-TNC    AS DEC EXTENT 2 NO-UNDO. /* �㬬� �� ��ࠬ��� � ���.����� */
   DEF VAR vCurr      AS CHAR NO-UNDO. /* �����, � ���ன ���뢠���� ��ࠬ��� */
   DEF VAR vNpOkr     AS CHAR NO-UNDO. /* ���祭�� �� ���㣫�� */
   DEF VAR vRetVal    AS DEC  NO-UNDO. /* �����頥��� ���祭�� */
   DEF VAR vRate      AS DEC  NO-UNDO. /* �����頥��� ���祭�� */
   DEF VAR vDoc-ref   AS CHAR NO-UNDO.
   DEF VAR vLnPrin    AS DEC  NO-UNDO.
   DEF VAR vLastDate  AS DATE NO-UNDO.
   DEF VAR vDateInt46 AS DATE NO-UNDO.
   DEF VAR vDateInt21 AS DATE NO-UNDO.
   DEF VAR vTmpSum    AS DEC  NO-UNDO.
   DEF VAR vSumParT   AS DEC  NO-UNDO.
   DEF VAR vCodOstpar AS INT  NO-UNDO.
   DEF VAR vResProcSt AS LOG  NO-UNDO.

   DEF BUFFER loan  FOR loan.
   DEF BUFFER bloan FOR loan. /* ���������� ����. */
   
   FIND FIRST bloan WHERE bloan.contract  EQ iContract
                      AND bloan.cont-code EQ iContCode
      NO-LOCK NO-ERROR.
   IF AVAIL bloan 
   THEN DO:
      vSh-Bal = 0.
      vCodOstpar = INT64(GetParCode(bloan.class-code,'����᭄���')) NO-ERROR. 
      IF vCodOstpar NE 0 
      THEN
         vParam = {&vParamNe0}.
         /* ��।��塞, ������� �� १�� �� �⮬ ������� */
      IF LnRsrvCheckType(iContract, iContCode, "�।����") THEN
      DO:
         IF vCodOstpar EQ 0
         THEN
            vLnPrin = LnPrincipal (iContract, iContCode, iDate, iCurrency).
         ELSE DO:
            RUN STNDRT_PARAM_EX(bloan.contract,
                                bloan.cont-code,           /* ������� ��� �࠭� */
                                vCodOstpar, /* ��ࠬ��� */
                                iDate,                /* ��� */
                                bloan.since,
                                OUTPUT vLnPrin,           /* �㬬� �� ��ࠬ���� */
                                OUTPUT vSm-Db,
                                OUTPUT vSm-Cr).
            IF bloan.Currency <> iCurrency
            THEN 
               vLnPrin = CurToCurWork("����",
                                      bloan.currency,
                                      iCurrency,
                                      iDate,
                                      vLnPrin).
         END.      
   
         vResProcSt = FGetSetting("���琥���","�����揮�⠢","���") EQ "��".  
         IF    vLnPrin NE 0 
            OR vResProcSt THEN
            vLastDate = iDate.
         ELSE
         DO:
            vLastDate = {&BQ-MIN-DATE}.
            /* ���� �� �������� � ��� �࠭蠬 ��� cont-type = "��祭��" */
            FOR EACH loan WHERE
                    (loan.contract  EQ iContract
                 AND loan.cont-code EQ iContCode)             /* ��� ������� */
               OR   (loan.contract  EQ iContract
                 AND loan.cont-code BEGINS(iContCode) + " ")  /* ��� �࠭�  */
            NO-LOCK:
   
               FIND LAST loan-int WHERE
                         loan-int.contract  EQ loan.contract
                     AND loan-int.cont-code EQ loan.cont-code
                     AND loan-int.id-d      EQ 21
                     AND loan-int.mdate     LE iDate
               NO-LOCK NO-ERROR.
   
               vDateInt21 = IF AVAIL loan-int THEN loan-int.mdate ELSE {&BQ-MIN-DATE}.
   
               FIND LAST loan-int WHERE
                         loan-int.contract  EQ loan.contract
                     AND loan-int.cont-code EQ loan.cont-code
                     AND loan-int.id-d      EQ 46
                     AND loan-int.mdate     LE iDate
               NO-LOCK NO-ERROR.
   
               vDateInt46 = IF AVAIL loan-int THEN loan-int.mdate ELSE {&BQ-MIN-DATE}.
   
               ASSIGN
                  vLastDate = MAX(vLastDate,vDateInt21,vDateInt46)
               .
            END.
            vLastDate = IF vLastDate NE ? THEN vLastDate - 1 ELSE iDate.
            IF vLastDate NE iDate 
            THEN DO:
            
               IF vCodOstpar EQ 0
               THEN
                  vLnPrin = LnPrincipal (iContract, iContCode, vLastDate, iCurrency).
               ELSE DO:
                  RUN STNDRT_PARAM_EX(iContract,
                                      iContCode,           /* ������� ��� �࠭� */
                                      vCodOstpar,          /* ��ࠬ��� */
                                      vLastDate,           /* ��� */
                                      bloan.since,
                                      OUTPUT vLnPrin,      /* �㬬� �� ��ࠬ���� */
                                      OUTPUT vSm-Db,
                                      OUTPUT vSm-Cr).
                  IF bloan.Currency NE iCurrency
                  THEN 
                     vLnPrin = CurToCurWork("����",
                                            bloan.currency,
                                            iCurrency,
                                            vLastDate,
                                            vLnPrin).
               
               END.
            END.
         END.
   
         /* ���� �� �������� � ��� �࠭蠬 ��� cont-type = "��祭��" */
         FOR EACH loan WHERE
                 (loan.contract  EQ iContract
              AND loan.cont-code EQ iContCode)             /* ��� ������� */
            OR   (loan.contract  EQ iContract
              AND loan.cont-code BEGINS(iContCode) + " ")  /* ��� �࠭�  */
         NO-LOCK:
            ASSIGN
                vDoc-ref  = loan.doc-ref
                vSumParT = 0.
            
               /* ���� �� ��ࠬ��ࠬ �� ᯨ᪠ vParam �������(�࠭�) */
            DO vI = 1 TO NUM-ENTRIES(vParam):
               RUN STNDRT_PARAM_EX(iContract,
                                   loan.cont-code,         /* ������� ��� �࠭� */
                                   INT64(ENTRY(vI, vParam)), /* ��ࠬ��� */
                                   vLastDate,              /* ��� */
                                   loan.since,
                                   OUTPUT vSm-Tot[vI],         /* �㬬� �� ��ࠬ���� */
                                   OUTPUT vSm-Db,
                                   OUTPUT vSm-Cr).
                  /* ��ॢ��� �㬬� ��ࠬ��� � ��樮������ ������ */
               RUN GetParP IN h_loan (RECID(loan),
                                      INT64(ENTRY(vI, vParam)),
                                      vSm-Tot[vI],
                                      OUTPUT vTmpSum,
                                      OUTPUT vCurr).
                  /* �᫨ ��� ���� ������ ����� �⫨筠� �� ��樮���쭮�,
                  ** ��ॢ���� �㬬� � �������� ������ */
               IF iCurrency NE vCurr THEN
                  vSm-TNC[vI] = CurToCurWork ("����",
                                              vCurr,
                                              iCurrency,
                                              vLastDate,
                                              vSm-Tot[vI]).
               ELSE
                  vSm-TNC[vI] = vSm-Tot[vI].
                  /* ������������� �㬬� �� ��ࠬ��ࠬ � �����, �������� �室�� ��ࠬ��஬ 
                     ���⠥�, �.�. � ���४⭮� ������� ��ࠬ���� �� vParam 
                     ����� ����⥫쭮� ���祭�� => �⮣ �㤥� ������⥫�� ��� ���� % १�ࢠ */
               ASSIGN
                   vSh-Bal = vSh-Bal - vSm-TNC[vI]
                   vSumParT = vSumParT - vSm-TNC[vI]. /*�� �㦭� ⮫쪮 ��⮪���*/
            END.
              /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
            IF mIfPutPtot
              AND NOT(mIfPutNotNull
                      AND NUM-ENTRIES(vDoc-ref, " ") = 2
                      AND vSumParT = 0) THEN
            DO:
               OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
               PUT STREAM out_s UNFORMATTED
                  "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                  ".  ����� �-� १�ࢠ � ��⮬ ���ᯥ祭��: "
               SKIP.
               DO vI = 1 TO NUM-ENTRIES(vParam):
                   PUT STREAM out_s UNFORMATTED
                     "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                     ".  ��ࠬ���: " ENTRY(vI, vParam)
                     ", ���⮪ � ����� ��ࠬ���: " TRIM(STRING(vSm-Tot[vI], "->>>>>>>>>>>>>>9.99"))
                     ", � ����� " iCurrency " �㬬� ���⪠: " TRIM(STRING(vSm-TNC[vI], "->>>>>>>>>>>>>>9.99"))
                  SKIP.
               END.
               OUTPUT STREAM out_s CLOSE.
            END.
         END.
      END.
      
         /* else �� �ᯮ������ � � ��� �� ����뢠���� vSh-Bal,
            ����� �ந�������� ���� ⮫쪮 vLnPrin
         */
      vRate   = LnRsrvRate (iContract,
                            iContCode,
                            iDate).
      IF vLnPrin EQ 0 THEN
      DO:
         IF vResProcSt THEN
            vRetVal = vRate.
         ELSE
            vRetVal = 0.
      END.
      ELSE
         vRetVal = vSh-Bal / vLnPrin * 100. 
      IF ABS(vRate) LT ABS(vRetVal) THEN
         vRetVal = vRate.

      ASSIGN
         vNpOkr  = FGetSetting("���㣫��",?,"")
         vRetVal = IF vNpOkr EQ ""
                     THEN ROUND(vRetVal, 7)
                     ELSE ROUND(vRetVal, INT64(vNpOkr))
      .
   
      vDoc-ref  = bloan.doc-ref.
         /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
      IF mIfPutPtot
         AND NOT(mIfPutNotNull
                 AND NUM-ENTRIES(vDoc-ref, " ") = 2
                 AND vRetVal = 0) THEN
      DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
            ".  ��ନ஢���� १�� �� ��ࠬ��ࠬ <" vParam ">: " 
            /* 㬭����� �� -1, �⮡� �뫮, ��� � ���ﭨ� ������� */
            TRIM(STRING(vSh-Bal * -1, "->>>>>>>>>>>>>>9.99")) SKIP
            "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
            ".  %��� � ��⮬ ���ᯥ祭��: " TRIM(STRING(vRetVal, "->>>>>>9.99<<<"))
         SKIP.
         IF vNpOkr NE "" THEN
            PUT STREAM out_s UNFORMATTED
            "���㣫���� %��� �� (������): " vNpOkr SKIP.
         OUTPUT STREAM out_s CLOSE.
      END.
   END.

   RETURN vRetVal.
END FUNCTION.

   /* ===================================================--=-=-= */
   /* �ᯮ����⥫쭠� ��楤�� ��� LnFormRsrvProc, LnFormRsrvVb */
   /* �����頥� �㬬� - ������ ���� १�ࢠ                  */
PROCEDURE LnFormRsrvProc_Sm:
   DEF INPUT  PARAM iContract    AS CHAR NO-UNDO.  /* �����祭�� ������� */
   DEF INPUT  PARAM iContCode    AS CHAR NO-UNDO.  /* ����� ������� */
   DEF INPUT  PARAM iDate        AS DATE NO-UNDO.  /* ��� ����樨 */
   DEF INPUT  PARAM iAcctType    AS CHAR NO-UNDO.  /* ���� ��� */
   DEF INPUT  PARAM iCurrency    AS CHAR NO-UNDO.  /* ����� */
   DEF INPUT  PARAM iCheck       AS LOG  NO-UNDO.  /* ��। ���⮬ ����᪠�� LnRsrvCheckType ��� ஫� ��� १�ࢠ */
   DEF OUTPUT PARAM oRsrvBase    AS DEC  NO-UNDO.  /* ����⭠� ���� १�ࢠ */

   DEF VAR vI           AS INT64  NO-UNDO.
   DEF VAR vSm-Tot      AS DEC EXTENT 90 NO-UNDO. /* �㬬� �� ��ࠬ��� */
   DEF VAR vSumm        AS DEC  NO-UNDO. /* �㬬� ��� ��ࠬ��஢ */
   DEF VAR vSummInt     AS DEC  NO-UNDO. /* �㬬� ��ࠬ��஢ .��業⠬� �� loan.interest */
   DEF VAR vSm-TNC      AS DEC EXTENT 90 NO-UNDO. /* �㬬� �� ��ࠬ��� � ���.����� */
   DEF VAR vCurr        AS CHAR NO-UNDO. /* �����, � ���ன ���뢠���� ��ࠬ��� */
   DEF VAR CodOstpar    AS INT64  NO-UNDO.
   DEF VAR vDoc-ref     AS CHAR NO-UNDO.
   DEF VAR vParamP      AS CHAR NO-UNDO. /* ���᮪ �㬬��㥬�� ��ࠬ��஢ */
   DEF VAR vParamM      AS CHAR NO-UNDO. /* ���᮪ ���⠥��� ��ࠬ��஢ */
   DEF VAR vTypeRes     AS CHAR NO-UNDO. /* ���� ��� १�ࢠ */
   DEF VAR vSumParT     AS DEC  NO-UNDO.

   DEF BUFFER loan FOR loan.
   DEF BUFFER code FOR code.

   main:
   DO:
      IF    iAcctType EQ ""
         OR iAcctType EQ ? THEN
         LEAVE main.

      IF NOT GetCodeBuff("����ࢄ��", iAcctType, BUFFER code) THEN
         LEAVE main.

      ASSIGN
         vParamP  = code.misc[1]
         vParamM  = code.misc[2]
         vTypeRes = code.name
      .

      IF vParamM NE "" THEN
      DO:
         {additem.i vParamP vParamM}
      END.

      IF     iCheck
         AND NOT LnRsrvCheckType (iContract,
                                  iContCode,
                                  vTypeRes) THEN
         LEAVE main.

         /* ��।������ ���⭠� ���� ��� �㬬� ��ࠬ��஢ ������� �� iParam
         ** �᫨ ������� - �祭�� (loan.cont-type EQ "��祭��"), � ��।�����
         ** � ᫮���� �㬬� ��ࠬ��஢ � �� �ᥬ ��� �࠭蠬. */
      FOR EACH loan WHERE
              (loan.contract  EQ iContract
           AND loan.cont-code EQ iContCode)             /* ��� ������� */
         OR   (loan.contract  EQ iContract
           AND loan.cont-code BEGINS(iContCode) + " ")  /* ��� �࠭�  */
         NO-LOCK:
         ASSIGN
            vDoc-ref  = loan.doc-ref
            CodOstpar = GetParCode(loan.class-code,'����᭄���')
            vSumParT = 0
         .

         IF NUM-ENTRIES(vParamP) > 90 THEN DO:
             IF mIfPutPtot THEN
             DO:
               OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
               PUT STREAM out_s UNFORMATTED
                  "� �����䨪��� ����ࢄ�� ��� ஫� ��� " iAcctType
                   "������ ᫨誮� ����� ��ࠬ��஢ (����� 90). ���������� ���᫨�� ������ ���� १�ࢠ."
               SKIP.
               OUTPUT STREAM out_s CLOSE.
             END.
             LEAVE main.
         END.
            /* ���� �� ��ࠬ��ࠬ �� ᯨ᪠ iParam �������(�࠭�) */
         DO vI = 1 TO NUM-ENTRIES(vParamP):
            RUN Get_Param_Cur IN h_loan (INT64(ENTRY(vI, vParamP)),   /* ��ࠬ��� */
                                         CodOstpar,
                                         iContract,
                                         loan.cont-code,            /* ������� ��� �࠭� */
                                         iDate,                     /* ��� */
                                         iCurrency,
                                         OUTPUT vCurr,
                                         OUTPUT vSm-Tot[vI],
                                         OUTPUT vSm-TNC[vI]).
               /* ������������� �㬬� �� ��ࠬ��ࠬ � �����, �������� �室�� ��ࠬ��஬ */
            vSm-TNC[vI] =  ABS(vSm-TNC[vI]).
            IF LOOKUP(ENTRY(vI, vParamP), vParamM) GT 0 THEN
                ASSIGN
                   vSumm    = vSumm - vSm-TNC[vI]
                   vSumParT = vSumParT - vSm-TNC[vI].
            ELSE
                ASSIGN
                   vSumm    = vSumm + vSm-TNC[vI]
                   vSumParT = vSumParT + vSm-TNC[vI].
         END.
         /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
         IF mIfPutPtot
           AND NOT(mIfPutNotNull
                   AND NUM-ENTRIES(vDoc-ref, " ") = 2
                   AND vSumParT = 0) THEN
         DO:
           OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
           PUT STREAM out_s UNFORMATTED
              "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
              ".  ���� ���: " + iAcctType
           SKIP.
           DO vI = 1 TO NUM-ENTRIES(vParamP):
              PUT STREAM out_s UNFORMATTED
                  "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
                  ".  ��ࠬ���: " ENTRY(vI, vParamP)
                  ", ���⮪ � ����� ��ࠬ���: " TRIM(STRING(vSm-Tot[vI], "->>>>>>>>>>>>>>9.99"))
                  ", � ����� " iCurrency " �㬬� ���⪠: " TRIM(STRING(vSm-TNC[vI], "->>>>>>>>>>>>>>9.99"))
               SKIP.
           END.
           OUTPUT STREAM out_s CLOSE.
         END.
      END.
   END.  /* main */

   /* ��६ ���ᨬ�, �⮡� ����� ��९���� �� %% (���� ���� १�ࢠ �� ������ ���� ����⥫쭮�) */
   oRsrvBase = MAX(0,vSumm).
END PROCEDURE.    /* LnFormRsrvProc_Sm */


/*---------------------------------------------------------------------------
  Procedure  : LnFormRsrvProc
  Name       : ����� १�ࢠ ��� ��業⮢.
  Purpose    : ����� १�ࢠ ��� ��業⮢.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iAcctType   - ���� ���
               iCurrency   - �����
               iCheck      - ��। ���⮬ ����᪠�� LnRsrvCheckType ��� ஫� ��� १�ࢠ
               oRsrvProc   - �����樥�� १�ࢨ஢����
               oRsrvRate   - १�ࢠ ��� ��業⮢
  ---------------------------------------------------------------------------*/
PROCEDURE LnFormRsrvProc :

   DEF INPUT  PARAM iContract    AS CHAR NO-UNDO.
   DEF INPUT  PARAM iContCode    AS CHAR NO-UNDO.
   DEF INPUT  PARAM iDate        AS DATE NO-UNDO.
   DEF INPUT  PARAM iAcctType    AS CHAR NO-UNDO.  /* ���� ��� */
   DEF INPUT  PARAM iCurrency    AS CHAR NO-UNDO.
   DEF INPUT  PARAM iCheck       AS LOG  NO-UNDO.  /* ��। ���⮬ ����᪠�� LnRsrvCheckType ��� ஫� ��� १�ࢠ */
   DEF OUTPUT PARAM oRsrvProc    AS DEC  NO-UNDO.
   DEF OUTPUT PARAM oRsrvRate    AS DEC  NO-UNDO.

   DEF VAR vSumm        AS DEC  NO-UNDO.
   DEF VAR vDoc-ref     AS CHAR NO-UNDO.

   DEF BUFFER loan FOR loan.

      /* ����稬 ���� ��� ���� १�ࢠ */
   RUN LnFormRsrvProc_Sm (iContract,
                          iContCode,
                          iDate,
                          iAcctType,
                          iCurrency,
                          iCheck,
                          OUTPUT vSumm).
   ASSIGN
      oRsrvProc = LnCalcRsrvProc (iContract ,iContCode ,iDate ,iCurrency)
      oRsrvRate = ROUND (oRsrvProc * vSumm / 100, 2)
   .

   FIND FIRST loan WHERE
              loan.contract  EQ iContract
      AND     loan.cont-code EQ iContCode
   NO-LOCK NO-ERROR.
   IF AVAIL loan THEN
      vDoc-ref = loan.doc-ref.

      /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
   IF mIfPutPtot
       AND NOT(mIfPutNotNull
               AND NUM-ENTRIES(vDoc-ref, " ") = 2
               AND oRsrvRate = 0) THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
         ".  ����⭠� ����: " TRIM(STRING(vSumm,     "->>>>>>>>>>>>>>9.99")) SKIP
         "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
         ".  %���: "          TRIM(STRING(oRsrvProc, "->>>>>>>>9.99<<<")) SKIP
         "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
         ".  �㬬� १�ࢠ: " TRIM(STRING(oRsrvRate, "->>>>>>>>>>>>>>9.99"))
      SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.

END PROCEDURE.    /* LnFormRsrvProc */


/*---------------------------------------------------------------------------
  Function   : LnFormRsrvVb
  Name       : ����� १�ࢠ �� �᫮��� ��易⥫��⢠�
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
               iAcctType   - ���᮪ ஫�� ��⮢ (�१ "|")
               iDeriv      - �ਧ��� ��������� �� deriv �� ��� � 㪠������ ஫��.
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvVb RETURNS DEC (
   INPUT iContract AS CHAR,   /* �����祭�� ������� */
   INPUT iContCode AS CHAR,   /* ����� ������� */
   INPUT iDate     AS DATE,   /* �� ���� */
   INPUT iCurrency AS CHAR,   /* ����� */
   INPUT iAcctType AS CHAR,   /* ���᮪ ஫�� ��⮢ (�१ "|") */
   INPUT iDeriv    AS LOG,    /* �ਧ��� ��������� �� deriv �� ��� � 㪠������ ஫��. */
   INPUT iScreen   AS LOG):   /* �뢮���� �� �� ��࠭ ��⮪�� ���������� �� deriv ��� '��ଐ����' */

   DEF VAR vAcctType AS CHAR NO-UNDO.  /* ���� ��� */
   DEF VAR vRsrvProc AS DEC  NO-UNDO.  /* �����樥�� १�ࢨ஢���� */
   DEF VAR vRsrvRate AS DEC  NO-UNDO.  /* �㬬� १�ࢠ */
   DEF VAR vI        AS INT64  NO-UNDO.
   DEF VAR vSumm     AS DEC  NO-UNDO.  /* ���� ��� ���� १�ࢠ */
   DEF VAR vDoc-ref  AS CHAR NO-UNDO.
   DEF VAR vSumOb    AS DEC  NO-UNDO. /* ���� �㬬� ���ᯥ祭�� (�।����) */
   DEF VAR vAmtLoan  AS DEC  NO-UNDO. /* ����� �㬬� ���ᯥ祭�� �� �᭮����� ����� (����窠) */
   DEF VAR vAmtAcct  AS DEC  NO-UNDO. /* ����� �㬬� ���ᯥ祭�� �� �᫮��� ��易⥫��⢠� (�।���,�।�) */

   DEF BUFFER loan-acct FOR loan-acct.

   main:
   DO:
      IF NOT {assigned iAcctType} THEN
         LEAVE main.

         /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
      IF mIfPutPtot THEN
      DO:
         OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
         PUT STREAM out_s UNFORMATTED
            "���ଠ��  �������: " ENTRY(1, iContract, "@") FORMAT "X(22)"
         SKIP.
         OUTPUT STREAM out_s CLOSE.
      END.

         /* ��।���� ஫� ���, �� ���஬� ������� ��� १�ࢠ */
      blk:
      DO vI = 1 TO NUM-ENTRIES(iAcctType, ":"):
         FIND FIRST loan-acct WHERE
                    loan-acct.contract  EQ iContract
            AND     loan-acct.cont-code EQ iContCode
            AND     loan-acct.acct-type EQ ENTRY(vI, iAcctType, ":")
            AND     loan-acct.since     LE iDate
         NO-LOCK NO-ERROR.
         IF AVAIL loan-acct THEN
         DO:
            vAcctType = ENTRY(vI, iAcctType, ":").   /* ���������� ஫� ��� � ࠡ�⠥� ⮫쪮 � ��� */
            LEAVE blk.
         END.
      END.  /* blk */
         /* �᫨ ��� �� 㤠���� ���।��� - �㣠���� � ���� � ��室�� */
      IF NOT {assigned vAcctType} THEN
      DO:
         IF mIfPutPtot THEN
         DO:
            OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
            PUT STREAM out_s UNFORMATTED
               "�� �ਢ易� �� ���� ��� �� ᯨ᪠ ஫��: <" + iAcctType + ">."
            SKIP.
            OUTPUT STREAM out_s CLOSE.
         END.
         LEAVE main.
      END.
         /* ����稬 ���� ��� ���� १�ࢠ */
      RUN LnFormRsrvProc_Sm (iContract,
                             iContCode,
                             iDate,
                             vAcctType,
                             iCurrency,
                             NO,
                             OUTPUT vSumm).
	/********
         * ��᫮� �. �.
	 * ��ࠢ��� �訡�� ���㣫����.
         ********/
	vSumm = ROUND(vSumm,2).
         /* ���४��㥬 ������ ���� १�ࢨ஢���� � ��⮬ ���ᯥ祭��. */
      IF vAcctType EQ "�।����" THEN
            /* ��� �뤠���� ��࠭⨩ (�।����) �㬬� ���ᯥ祭��,
            ���᫥���� ��� ��� � ���� १�ࢠ, ������ � ������ ��ꥬ�. */
         ASSIGN
            vSumOb = LnCollateralValueAll (iContract,
                                           iContCode,
                                           iDate,
                                           ?,
                                           "",
                                           "all")
            vSumm = vSumm - vSumOb
         .
      ELSE IF CAN-DO("�।���,�।�", vAcctType) THEN
      DO:
            /* ��� ���ᯮ�짮������ �।���� ����� � ����⮢ (�।���, �।�)
            ������ � ���, �뤥������ ��� ��������ᮢ�� ��易⥫���. */
         RUN LnCollateralValueEx (iContract,
                                  iContCode,
                                  iDate,
                                  ?,
                                  "",
                                  OUTPUT vAmtLoan,
                                  OUTPUT vAmtAcct).
         vSumm = vSumm - vAmtAcct.
      END.

      IF vSumm GT 0 THEN
      DO:
            /* ��।��塞 �-� १�ࢨ஢���� */
         IF CAN-DO("�।����,�।���,�।�����,�।���,�।�",
                   vAcctType) THEN
         DO:
            ASSIGN
               vRsrvProc = LnRsrvRateVb (iContract, iContCode, vAcctType, iDate)
               vRsrvRate = ROUND (vRsrvProc * vSumm / 100, 2)
            .
         END.
            /* ������塞 �� deriv �� ��� � ஫�� vAcctType */
         IF iDeriv THEN
            RUN "setacdr1.p" (iContract,  /* �����祭�� ������� */
                              iContCode,  /* ����� ������� */
                              vAcctType,  /* ���� ��� */
                              iDate,      /* �� ���� */
                              iScreen).   /* �뢮���� �� ��⮪�� �� ��࠭ */


            /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
         IF mIfPutPtot
             AND NOT(mIfPutNotNull
                     AND NUM-ENTRIES(iContCode, " ") = 2
                     AND vRsrvRate = 0) THEN
         DO:
            FIND FIRST loan WHERE
                       loan.contract  EQ iContract
               AND     loan.cont-code EQ iContCode
            NO-LOCK NO-ERROR.
            IF AVAIL loan THEN
               vDoc-ref = loan.doc-ref.
            OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
            PUT STREAM out_s UNFORMATTED
               "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
               ".  ����⭠� ����: " TRIM(STRING(vSumm,     "->>>>>>>>>>>>>>9.99")) SKIP
               "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
               ".  %���: "          TRIM(STRING(vRsrvProc, "->>>>>>>>>>>>>>9.99")) SKIP
               "���ଠ��  �������: " vDoc-ref FORMAT "X(22)"
               ".  �㬬� १�ࢠ: " TRIM(STRING(vRsrvRate, "->>>>>>>>>>>>>>9.99"))
            SKIP.
            OUTPUT STREAM out_s CLOSE.
         END.
      END.
   END.  /* main */
   RETURN vRsrvRate.

END FUNCTION.    /* LnFormRsrvVb */


/*---------------------------------------------------------------------------
  Function   : LnFormRsrvProcGood
  Name       : ����� १�ࢠ ��� ��業⮢.
  Purpose    : ����� १�ࢠ ��� ��業⮢.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvProcGood RETURNS DEC (INPUT iContract  AS CHAR,
                                         INPUT iContCode  AS CHAR,
                                         INPUT iDate      AS DATE,
                                         INPUT iCurrency  AS CHAR):
   DEF VAR vRsrvProc  AS DEC  NO-UNDO.
   DEF VAR vRsrvRate  AS DEC  NO-UNDO.

      /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
   IF mIfPutPtot
      AND NOT(mIfPutNotNull
              AND NUM-ENTRIES(iContCode, " ") = 2) THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  ����� १�ࢠ �� ���� ��業⠬ �� " STRING(iDate, "99/99/9999") + "."
      SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।�" , /* ���� */
                       iCurrency,
                       TRUE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).

   RETURN vRsrvRate.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvProcBad
  Name       : ����� १�ࢠ ��� ����祭��� ��業⮢.
  Purpose    : ����� १�ࢠ ��� ����祭��� ��業⮢.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iAcct       - ����
               iCurrency   - �����
  ---------------------------------------------------------------------------*/

FUNCTION LnFormRsrvProcBad RETURNS DEC (INPUT iContract  AS CHAR,
                                        INPUT iContCode  AS CHAR,
                                        INPUT iDate      AS DATE,
                                        INPUT iCurrency  AS CHAR):
   DEF VAR vRsrvProc  AS DEC  NO-UNDO.
   DEF VAR vRsrvRate  AS DEC  NO-UNDO.

      /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
   IF mIfPutPtot
       AND NOT(mIfPutNotNull
               AND NUM-ENTRIES(iContCode, " ") = 2) THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  ����� १�ࢠ �� ����祭�� ��業⠬ �� " STRING(iDate, "99/99/9999") + "."
      SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।��%", /* ���᮪ ��ࠬ��஢ ��� ��।������ ���⭮� ���� */
                       iCurrency,
                       TRUE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvProcBadVb
  Name       : ����� १�ࢠ ��� ����祭��� ��業⮢ �� ���������.
  Purpose    : ����� १�ࢠ ��� ����祭��� ��業⮢ �� ���������.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iAcct       - ����
               iCurrency   - �����
  ---------------------------------------------------------------------------*/

FUNCTION LnFormRsrvProcBadVb RETURNS DEC (INPUT iContract  AS CHAR,
                                          INPUT iContCode  AS CHAR,
                                          INPUT iDate      AS DATE,
                                          INPUT iCurrency  AS CHAR):
   DEF VAR vRsrvProc  AS DEC  NO-UNDO.
   DEF VAR vRsrvRate  AS DEC  NO-UNDO.

      /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
   IF mIfPutPtot
       AND NOT(mIfPutNotNull
               AND NUM-ENTRIES(iContCode, " ") = 2) THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  ����� १�ࢠ �� ����祭�� ��業⠬ �� " STRING(iDate, "99/99/9999") + "."
      SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।��%B", /* ���᮪ ��ࠬ��஢ ��� ��।������ ���⭮� ���� */
                       iCurrency,
                       TRUE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.
END FUNCTION.


/*****************************************************************************/
/*---------------------------------------------------------------------------
  Function   : LnFormRsrvDiskBad
  Name       : ����� १�ࢠ ��� ����祭���� ��᪮��.
  Purpose    : ����� १�ࢠ ��� ����祭���� ��᪮��.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvDiskBad RETURNS DEC (INPUT iContract AS CHAR,
                                        INPUT iContCode AS CHAR,
                                        INPUT iDate     AS DATE,
                                        INPUT iCurrency AS CHAR):
   DEF VAR vRsrvProc  AS DEC  NO-UNDO.
   DEF VAR vRsrvRate  AS DEC  NO-UNDO.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।��᪏�" , /* ���� */
                       iCurrency,
                       FALSE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvVProcGood
  Name       : ����� १�ࢠ ��� �� �� ��業⠬.
  Purpose    : ����� १�ࢠ ��� ��⥭��� ���ᥫ�� �� ��業⠬.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvVProcGood RETURNS DEC (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iDate     AS DATE,
                                          INPUT iCurrency AS CHAR):
   DEF VAR vRsrvProc AS DEC NO-UNDO.
   DEF VAR vRsrvRate AS DEC NO-UNDO.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।�" ,
                       iCurrency,
                       FALSE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvVProcBad
  Name       : ����� १�ࢠ ��� �� �� ����祭�� ��業⠬.
  Purpose    : ����� १�ࢠ ��� ��⥭��� ���ᥫ�� �� ����祭�� ��業⠬.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvVProcBad RETURNS DEC (INPUT iContract AS CHAR,
                                         INPUT iContCode AS CHAR,
                                         INPUT iDate     AS DATE,
                                         INPUT iCurrency AS CHAR):
   DEF VAR vRsrvProc AS DEC NO-UNDO.
   DEF VAR vRsrvRate AS DEC NO-UNDO.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।��%" ,
                       iCurrency,
                       FALSE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvVDiskGood
  Name       : ����� १�ࢠ ��� �� �� ��᪮���.
  Purpose    : ����� १�ࢠ ��� ��⥭��� ���ᥫ�� �� ��᪮���.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvVDiskGood RETURNS DEC (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iDate     AS DATE,
                                          INPUT iCurrency AS CHAR):
   DEF VAR vRsrvProc AS DEC NO-UNDO.
   DEF VAR vRsrvRate AS DEC NO-UNDO.

   RUN LnFormRsrvProc (iContract ,
                       iContCode ,
                       iDate ,
                       "�।��᪄�" ,
                       iCurrency,
                       FALSE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.

END FUNCTION.

/*---------------------------------------------------------------------------
  Procedure  : LnFormRsrvVek
  Name       : ����� १�ࢠ ��⥭��� ���ᥫ�� �� ���᫥��� ��業⠬/��᪮���.
  Purpose    : ����� १�ࢠ ��⥭��� ���ᥫ�� �� ���᫥��� ��業⠬/��᪮���
               � ��⮬ ��⥣�ਨ ����⢠.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iAcct       - ����
               iCurrency   - �����
               oRsrvProc   - �����樥�� १�ࢨ஢����
               oRsrvRate   - ���⠭�� १��
  ---------------------------------------------------------------------------*/
PROCEDURE LnFormRsrvVek:
   DEF INPUT  PARAMETER iContract AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iContCode AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iDate     AS DATE NO-UNDO.
   DEF INPUT  PARAMETER iAcct     AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iCurrency AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iCurrAcct AS CHAR NO-UNDO.
   DEF OUTPUT PARAMETER oRsrvProc AS DEC  NO-UNDO.
   DEF OUTPUT PARAMETER oRsrvRate AS DEC  NO-UNDO.

   DEF VAR vGrRisk AS INT64  NO-UNDO.  /* ��㯯� �᪠ ������� */
   DEF VAR vGrPrD  AS INT64  NO-UNDO.  /* ��㯯� �᪠ �� "���ਧ���" */
   DEF VAR vSumm   AS DEC  NO-UNDO.  /* ����⭠� ���� */
   DEF VAR vAmnt   AS DEC  NO-UNDO.  /* �㬬� � 㬥��襭�� ���⭮� ���� */

      /* ���祭�� ���� ��� ���� ���⪮� �� ��⠬ ������ �� ����஥� 䨫���
      ** ("> ���. � ������" -> "���⪨ ��:") �� 㬮�砭�� = gend-date */
   RUN acct-pos IN h_base (iAcct,
                           iCurrAcct,
                           iDate,
                           iDate,
                           ?).
   ASSIGN
      oRsrvProc = LnCalcRsrvProc(iContract ,iContCode ,iDate ,iCurrency)
      vGrRisk   = re_history_risk(iContract, iContCode, iDate, 2)
      vGrPrD    = INT64(FGetSetting("�302�", "���ਧ���", "2"))
   .

      /* �᫨ ��⥣��� ����⢠ ����� ��� ࠢ�� ����. �� "���ਧ���", �
      ** ���⭠� ���� ࠢ�� ����� �� ���                             */
   IF iCurrency EQ "" THEN
      vSumm = sh-bal.
   ELSE
      IF iCurrAcct EQ "" THEN
         vSumm = CurToCurWork("����",iCurrAcct,iCurrency,iDate,sh-bal).
      ELSE
         vSumm = CurToCurWork("����",iCurrAcct,iCurrency,iDate,sh-val).
      /* �㬬� � 㬥��襭�� ���⭮� ���� */
   IF vGrRisk GT vGrPrD THEN DO:
      RUN rsrv-sm.p (iContract, iContCode, iDate, vGrPrD, OUTPUT vAmnt).
      IF iCurrency NE "" THEN
         vAmnt = CurToCurWork("����","",iCurrency,iDate,vAmnt).
      vSumm = vSumm - vAmnt.
   END.

   oRsrvRate = ROUND (oRsrvProc * vSumm, 2).
      /* ��⮪���஢����, �᫨ �� "i254Stream" = �� */
   IF mIfPutPtot THEN
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  ����� १�ࢠ �� ���ᥫ�� ��業⠬/��᪮��� ��: " STRING(iDate, "99/99/9999")
         " ���: " iAcct " ���⮪: " (IF iCurrency = "" THEN sh-bal ELSE sh-val) SKIP
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  ��.�᪠ �� ��������: " vGrRisk ", ��.�᪠ �� <���ਧ���>: " vGrPrD SKIP
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  �㬬� �� �ਧ������� ��室�: " TRIM(STRING(vAmnt, "->>>>>>>>>>>>>>9.99")) SKIP
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  ����⭠� ����: " TRIM(STRING(vSumm, "->>>>>>>>>>>>>>9.99")) SKIP
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  %���: " TRIM(STRING(oRsrvProc, "->>>>>>>>9.99<<<")) SKIP
         "���ଠ��  �������: " ENTRY(1, iContCode, "@") FORMAT "X(22)"
         ".  �㬬� १�ࢠ: " TRIM(STRING(oRsrvRate, "->>>>>>>>>>>>>>9.99"))
      SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
END PROCEDURE.


/*---------------------------------------------------------------------------
  Function   : LnFormRsrvCom
  Name       : ����� १�ࢠ �� �������.
  Purpose    : ����� १�ࢠ �� �������.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
               iType       - ஫� ���
  ---------------------------------------------------------------------------*/
FUNCTION LnFormRsrvCom RETURNS DECIMAL (INPUT iContract AS CHARACTER,
                                        INPUT iContCode AS CHARACTER,
                                        INPUT iDate     AS DATE,
                                        INPUT iCurrency AS CHARACTER,
                                        INPUT iType     AS CHARACTER):

   DEF VAR vRsrvProc  AS DEC  NO-UNDO.
   DEF VAR vRsrvRate  AS DEC  NO-UNDO.

   RUN LnFormRsrvProc (iContract,
                       iContCode,
                       iDate,
                       iType,
                       iCurrency,
                       TRUE,
                       OUTPUT vRsrvProc,
                       OUTPUT vRsrvRate).
   RETURN vRsrvRate.
END FUNCTION.


/*---------------------------------------------------------------------------
  Procedure  : LnCollateralValAcct
  Name       : �����頥� �業���� �⮨����� ��ꥪ� ���ᯥ祭��.
  Purpose    : �����頥� �業���� �⮨����� ��ꥪ� ���ᯥ祭��.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
               iAcct       - ���
               oSum        - 業���� �⮨����� ��ꥪ� ���ᯥ祭��.
  ---------------------------------------------------------------------------*/
PROCEDURE LnCollateralValAcct:
   DEF INPUT  PARAMETER iContract AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iContCode AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iDate     AS DATE NO-UNDO.
   DEF INPUT  PARAMETER iAcct     AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iCurrency AS CHAR NO-UNDO.
   DEF OUTPUT PARAMETER oSum      AS DEC  NO-UNDO.

   DEF BUFFER loan      FOR loan.      /* ���������� ����. */
   DEF BUFFER loan-acct FOR loan-acct. /* ���������� ����. */
   DEF BUFFER term-obl  FOR term-obl.  /* ���������� ����. */

   DEF VAR vNomber            AS INT64    NO-UNDO.
   DEF VAR vSchet             AS INT64    NO-UNDO.
   DEF VAR vIndex             AS INT64    NO-UNDO.
   DEF VAR vLength            AS INT64    NO-UNDO.
   DEF VAR vAcctType          AS CHAR   NO-UNDO.
   DEF VAR vNN                AS INT64    NO-UNDO.
   DEF VAR vSurr              AS CHAR   NO-UNDO.
   DEF VAR vVidDogOb          AS CHAR   NO-UNDO. /* �� ��������. */
   DEF VAR vNomerPP           AS INT64    NO-UNDO. /* �� �������. */
   DEF VAR vAmtLoan           AS DEC    NO-UNDO. /* �㬬� �� �᭮����� �����. */
   DEF VAR vAmtAcct           AS DEC    NO-UNDO. /* �㬬� �� ��������ᮢ� ��易⥫��⢠�. */
   DEF VAR vSumAll            AS DEC    NO-UNDO. /* ���� �㬬� ���ᯥ祭�� �� ��������. */
   DEF VAR vMarkModeV         AS CHAR   NO-UNDO. /* ���ᮡ �業�� ���ᯥ祭��. */
   DEF VAR vQualityCategory   AS CHAR   NO-UNDO. /* ��⥣��� ����⢠. */
   DEF VAR vDecrRate          AS DEC    NO-UNDO. /* ����. ᭨����� �⮨����. */
   DEF VAR vRes               AS CHAR   NO-UNDO. /* ��� �뢮�� १���� � ��� */
   DEF VAR vIfPutPtotOld      AS LOG    NO-UNDO. /* ��� �࠭���� mIfPutPtot.*/

   ASSIGN
      vIfPutPtotOld  = mIfPutPtot
      mIfPutPtot     = NO
   .
   FIND FIRST loan WHERE loan.contract  EQ iContract
                     AND loan.cont-code EQ iContCode
      NO-LOCK NO-ERROR.
   IF AVAIL loan
   THEN DO:
      FIND LAST loan-acct WHERE loan-acct.contract   EQ loan.contract
                            AND loan-acct.cont-code  EQ loan.cont-code
                            AND loan-acct.acct       EQ iAcct
                            AND loan-acct.currency   EQ iCurrency
                            AND loan-acct.since      LE iDate
         NO-LOCK NO-ERROR.
      IF AVAIL loan-acct
      THEN DO:
         ASSIGN
            vLength = LENGTH(loan-acct.acct-type)
            vNomber = vLength + 1
         .

         DO vSchet = 0 TO vNomber - 1:
            INT64 (SUBSTRING(loan-acct.acct-type, vLength - vSchet , 1 ) ) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO: 
               IF GetCode("��������", SUBSTRING(loan-acct.acct-type,1, vLength - vSchet  ) ) NE ?  THEN
                  ASSIGN
                     vAcctType = SUBSTRING(loan-acct.acct-type,1, vLength - vSchet)
                     vNN       = INT64(SUBSTRING(loan-acct.acct-type, vLength - vSchet + 1,  vLength - (vLength - vSchet)))
                  NO-ERROR.
               LEAVE.
            END.
         END.

         IF vAcctType NE ""
         THEN DO:
            Block-term:
            FOR EACH term-obl WHERE (     term-obl.contract  EQ iContract
                                      AND term-obl.cont-code EQ iContCode
                                      AND term-obl.idnt      EQ 5
                                      AND term-obl.end-date  EQ ?
                                    )
                                    OR
                                    (     term-obl.contract  EQ iContract
                                      AND term-obl.cont-code EQ iContCode
                                      AND term-obl.idnt      EQ 5
                                      AND term-obl.end-date  GE iDate
                                    )
               NO-LOCK:
               ASSIGN
                  vSurr       = term-obl.contract         + ","
                              + term-obl.cont-code        + ","
                              + STRING(term-obl.idnt)     + ","
                              + STRING(term-obl.end-date) + ","
                              + STRING(term-obl.nn)
                  vVidDogOb   =     GetXAttrValue ("term-obl",vSurr,"��������")
                  vNomerPP    = INT64(GetXAttrValue ("term-obl",vSurr,"�������"))
               .
               IF      vVidDogOb EQ vAcctType
                  AND  vNomerPP  EQ vNN
               THEN LEAVE Block-term.

            END.
            IF AVAIL term-obl
            THEN DO:
               RUN LnCollateralValueEx (loan.contract,
                                        loan.cont-code,
                                        iDate,
                                        ?,
                                        iCurrency,
                                        OUTPUT vAmtLoan,
                                        OUTPUT vAmtAcct).
               ASSIGN
                  oSum              = LnPledgeQuality (term-obl.contract,
                                                       term-obl.cont-code,
                                                       term-obl.idnt,
                                                       term-obl.end-date,
                                                       term-obl.nn,
                                                       iDate,
                                                       iCurrency)
                  vSumAll           = LnCollateralValueAll (loan.contract,
                                                            loan.cont-code,
                                                            iDate,
                                                            ?,
                                                            iCurrency,
                                                            "all")
                  oSum              = IF vSumAll NE 0 THEN oSum * vAmtLoan / vSumAll ELSE 0
                  vMarkModeV        = GetCodeName("�業������",
                                            STRING(term-obl.fop-offbal + 1))
                  vQualityCategory  = Get_QualityGar ("comm-rate",
                                      vSurr,
                                      iDate)
                  vQualityCategory  = IF    vQualityCategory EQ ?
                                         OR vQualityCategory EQ "?"
                                      THEN ""
                                      ELSE vQualityCategory
                  vDecrRate         = GET_COMM("����",
                                              ?,
                                              term-obl.currency,
                                              vSurr,
                                              0.00,
                                              0,
                                              iDate)
                  vDecrRate         = IF vDecrRate EQ ?
                                      THEN 100
                                      ELSE vDecrRate
                  vRes              = "�⮨����� ��ꥪ⮢ ���ᯥ祭��:                     " + (IF oSum EQ ? THEN "?" ELSE STRING(oSum)) + "~n"
                                    + "�㬬� ������� ���ᯥ祭��:                         " + STRING(term-obl.amt-rub)                  + "~n"
                                    + "�����:                                             '" + iCurrency + "'"                           + "~n"
                                    + "���ᮡ �業�� ��ꥪ� ���ᯥ祭��:                  " + vMarkModeV                                + "~n"
                                    + "��⥣��� ����⢠ ���ᯥ祭��:                     " + vQualityCategory                          + "~n"
                                    + "�����樥�� ᭨����� �⮨����:                     " + STRING(vDecrRate)                         + "~n"
                                    + "����� �㬬� ���ᯥ祭�� �� �᭮����� �����:         " + STRING(vAmtLoan)                          + "~n"
                                    + "����� �㬬� ���ᯥ祭�� �� �᫮��� ��易⥫��⢠�: " + STRING(vAmtAcct)
               .
            END.
            ELSE
               vRes =   "�� ������� ���ᯥ祭�� ��� ������� "      +
                        "� �����祭��� '"           + iContract     +
                        "' � ����஬ '"             + iContCode     +
                        "' �������饥 �� '"        + STRING(iDate) +
                        "'." .
         END.
      END.
      ELSE
         vRes =   "��� '"                                     + iAcct         +
                  "' � ����� '"                               + iCurrency     +
                  "' �� �ਢ易� � �������� � �����祭��� '"   + iContract     +
                  "' � ����஬ '"                              + iContCode     +
                  "' �� '"                                     + STRING(iDate,"99/99/9999") +
                  "'." .
   END.
   ELSE
      vRes = "�� ������ ������� � �����祭��� '" + iContract     +
             "' � ����஬ '"                     + iContCode     + "'.".
   mIfPutPtot = vIfPutPtotOld.
   IF mIfPutPtot
   THEN DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED vRes SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
   RETURN.
END PROCEDURE.

/* �����㬥��, �������騩 �業���� �⮨����� ��ꥪ� ���ᯥ祭��,
** ��� ��� �������饣� �����樥��.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
               iAcct       - ���
               oSum        - 業���� �⮨����� ��ꥪ� ���ᯥ祭��. */
PROCEDURE LnPledgeAcct.
   DEF INPUT  PARAMETER iContract AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iContCode AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iDate     AS DATE NO-UNDO.
   DEF INPUT  PARAMETER iAcct     AS CHAR NO-UNDO.
   DEF INPUT  PARAMETER iCurrency AS CHAR NO-UNDO.
   DEF OUTPUT PARAMETER oSum      AS DEC  NO-UNDO.

   DEF BUFFER loan      FOR loan.      /* ���������� ����. */
   DEF BUFFER loan-acct FOR loan-acct. /* ���������� ����. */
   DEF BUFFER term-obl  FOR term-obl.  /* ���������� ����. */

   DEF VAR vNomber            AS INT64    NO-UNDO.
   DEF VAR vSchet             AS INT64    NO-UNDO.
   DEF VAR vIndex             AS INT64    NO-UNDO.
   DEF VAR vLength            AS INT64    NO-UNDO.
   DEF VAR vAcctType          AS CHAR   NO-UNDO.
   DEF VAR vNN                AS INT64    NO-UNDO.
   DEF VAR vSurr              AS CHAR   NO-UNDO.
   DEF VAR vVidDogOb          AS CHAR   NO-UNDO. /* �� ��������. */
   DEF VAR vNomerPP           AS INT64    NO-UNDO. /* �� �������. */
   DEF VAR vRes               AS CHAR   NO-UNDO. /* ��� �뢮�� १���� � ��� */
   DEF VAR vIfPutPtotOld      AS LOG    NO-UNDO. /* ��� �࠭���� mIfPutPtot.*/

   ASSIGN
      vIfPutPtotOld  = mIfPutPtot
      mIfPutPtot     = NO
   .
   FIND FIRST loan WHERE loan.contract  EQ iContract
                     AND loan.cont-code EQ iContCode
      NO-LOCK NO-ERROR.
   IF AVAIL loan
   THEN DO:
      FIND LAST loan-acct WHERE loan-acct.contract   EQ loan.contract
                            AND loan-acct.cont-code  EQ loan.cont-code
                            AND loan-acct.acct       EQ iAcct
                            AND loan-acct.currency   EQ iCurrency
                            AND loan-acct.since      LE iDate
         NO-LOCK NO-ERROR.
      IF AVAIL loan-acct
      THEN DO:
         ASSIGN
            vLength = LENGTH(loan-acct.acct-type)
            vNomber = vLength + 1
         .

         DO vSchet = 0 TO vNomber - 1:
            INT64 (SUBSTRING(loan-acct.acct-type, vLength - vSchet , 1 ) ) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO: 
               IF GetCode("��������", SUBSTRING(loan-acct.acct-type,1, vLength - vSchet  ) ) NE ?  THEN
                  ASSIGN
                     vAcctType = SUBSTRING(loan-acct.acct-type,1, vLength - vSchet)
                     vNN       = INT64(SUBSTRING(loan-acct.acct-type, vLength - vSchet + 1,  vLength - (vLength - vSchet)))
                  NO-ERROR.
               LEAVE.
            END.
         END.

         IF vAcctType NE ""
         THEN DO:
            Block-term:
            FOR EACH term-obl WHERE (     term-obl.contract  EQ iContract
                                      AND term-obl.cont-code EQ iContCode
                                      AND term-obl.idnt      EQ 5
                                      AND term-obl.end-date  EQ ?
                                    )
                                    OR
                                    (     term-obl.contract  EQ iContract
                                      AND term-obl.cont-code EQ iContCode
                                      AND term-obl.idnt      EQ 5
                                      AND term-obl.end-date  GE iDate
                                    )
               NO-LOCK:
               ASSIGN
                  vSurr       = term-obl.contract         + ","
                              + term-obl.cont-code        + ","
                              + STRING(term-obl.idnt)     + ","
                              + STRING(term-obl.end-date) + ","
                              + STRING(term-obl.nn)
                  vVidDogOb   =     GetXAttrValue ("term-obl",vSurr,"��������")
                  vNomerPP    = INT64(GetXAttrValue ("term-obl",vSurr,"�������"))
               .
               IF      vVidDogOb EQ vAcctType
                  AND  vNomerPP  EQ vNN
               THEN LEAVE Block-term.

            END.
            IF AVAIL term-obl
            THEN
               ASSIGN
                  oSum = LnPledge(term-obl.contract,
                                  term-obl.cont-code,
                                  term-obl.idnt,
                                  term-obl.end-date,
                                  term-obl.nn,
                                  iDate,
                                  ?,
                                  iCurrency)
               .
            ELSE
               vRes =   "�� ������� ���ᯥ祭�� ��� ������� "      +
                        "� �����祭��� '"           + iContract     +
                        "' � ����஬ '"             + iContCode     +
                        "' �������饥 �� '"        + STRING(iDate) +
                        "'." .
         END.
      END.
      ELSE
         vRes =   "��� '"                                     + iAcct         +
                  "' � ����� '"                               + iCurrency     +
                  "' �� �ਢ易� � �������� � �����祭��� '"   + iContract     +
                  "' � ����஬ '"                              + iContCode     +
                  "' �� '"                                     + STRING(iDate,"99/99/9999") +
                  "'." .
   END.
   ELSE
      vRes = "�� ������ ������� � �����祭��� '" + iContract     +
             "' � ����஬ '"                     + iContCode     + "'.".
   mIfPutPtot = vIfPutPtotOld.
   IF mIfPutPtot
   THEN DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED vRes SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
   RETURN.
END PROCEDURE.

/* ��।������ ��㯯� �᪠ �� �������� � ��⮬ �宦����� � ��� */
PROCEDURE LnGetGrRiskUchBag.

   DEF INPUT  PARAM iContract AS CHAR NO-UNDO. /* ������祭�� ������� */
   DEF INPUT  PARAM iContcode AS CHAR NO-UNDO. /* ����� ������� */
   DEF INPUT  PARAM iRes      AS DEC  NO-UNDO. /* �⠢�� १�ࢨ஢���� */
   DEF INPUT  PARAM iDate     AS DATE NO-UNDO. /* ��� */
   DEF OUTPUT PARAM oGrRsrv   AS INT64  NO-UNDO. /* ��㯯� �᪠ */

   DEF VAR vIsOnPos AS CHAR NO-UNDO. /* ��� ���䥫�, �᫨ ������� �ਢ易� � ����䥫� */

   DEF BUFFER loan FOR loan. /* ���������� �����. */

   mb:
   DO ON ERROR UNDO, LEAVE:
      /* ��室�� ������� */
      FIND FIRST loan WHERE loan.contract  EQ iContract
                        AND loan.cont-code EQ iContcode
      NO-LOCK NO-ERROR.
      IF NOT AVAIL loan THEN
         LEAVE mb.

      /* ��।��塞 - ��室���� �� �� �� ��।����� ���� � ���'� */
      vIsOnPos = LnInBagOnDate (iContract, iContcode, iDate).

      /* ������ � ����ᨬ��� �� ⮣� � ���'� ��㤠 ��� ��� ��।��塞 ��㯯� �᪠ */
      IF vIsOnPos EQ ? THEN
         oGrRsrv = LnGetGrRiska (iRes,iDate).
      ELSE
         oGrRsrv = PsGetGrRiska (iRes,loan.cust-cat,iDate).
   END.
END PROCEDURE.

FUNCTION GetLoanGrRisk RETURNS LOG (INPUT  iContract  AS CHAR,   /* ������祭�� ������� */
                                    INPUT  iContCode  AS CHAR,   /* ����� ������� */
                                    INPUT  iDate      AS DATE,   /* ��� */
                                    OUTPUT oRate      AS DEC,    /* �⠢�� */
                                    OUTPUT oGrRisk    AS INT64): /* ��㯯� �᪠ */

   DEF BUFFER comm-rate FOR comm-rate. /* ���������� ����. */

   DEFINE VARIABLE vOk AS LOGICAL     NO-UNDO.

   RUN GET_COMM_LOAN_BUF in h_Loan (iContract,
                                    iContCode,
                                    "%���",
                                    iDate,
                                    BUFFER comm-rate).
   IF AVAIL comm-rate 
   THEN DO:
      oRate   = comm-rate.rate-comm.
      oGrRisk = INT64 (GetXAttrValueEx("comm-rate",
                                       STRING(comm-rate.comm-rate-id),
                                       "��⥣���",
                                       ?)).
      IF oGrRisk EQ ? 
      THEN
          RUN LnGetRiskGrOnDate (       oRate,
                                        iDate,
                                 OUTPUT oGrRisk).
      vOk = TRUE.
   END.
   RETURN vOk.
END FUNCTION.

PROCEDURE GetRateGrRisk:
   DEF INPUT  PARAM iContract AS CHAR NO-UNDO. /* ������祭�� ������� */
   DEF INPUT  PARAM iContcode AS CHAR NO-UNDO. /* ����� ������� */
   DEF INPUT  PARAM iDate     AS DATE NO-UNDO. /* ��� */
   DEF OUTPUT PARAM oRate     AS DEC  NO-UNDO. /* �⠢�� */
   DEF OUTPUT PARAM oGrRisk   AS INT64  NO-UNDO. /* ��㯯� �᪠ */

   DEF BUFFER comm-rate FOR comm-rate. /* ���������� ����. */
   DEF BUFFER loan      FOR loan.      /* ���������� ����. */
   DEFINE VARIABLE vPos AS CHARACTER   NO-UNDO.
   vPos = LnInBagOnDate (iContract, iContCode, iDate).
   IF vPos NE ?
   THEN DO:
      FIND FIRST loan WHERE loan.contract  EQ "���"
                        AND loan.cont-code EQ vPos
         NO-LOCK NO-ERROR.
      IF AVAIL loan
      THEN DO:
         oRate   = DEC (fGetBagRate ((BUFFER loan:handle), "%���", iDate, "rate-comm")).
         oGrRisk = PsGetGrRiska   (oRate, loan.cust-cat, iDate).
      END.
   END.
   ELSE DO: 
       
      IF     NOT GetLoanGrRisk (iContract,
                                iContcode,
                                iDate,    
                                OUTPUT oRate,    
                                OUTPUT oGrRisk)  
         AND NOT CAN-FIND(loan WHERE loan.contract  EQ iContract
                                  AND loan.cont-code EQ iContCode
                                  AND loan.cont-type EQ "��祭��" )
                                  AND NUM-ENTRIES(iContCode, " ") = 2
      THEN 
         RUN GetRateGrRisk(iContract,
                             ENTRY(1,iContCode," "),
                             iDate,
                             OUTPUT oRate, 
                             OUTPUT oGrRisk).
   END.
   IF oGrRisk EQ ?
   THEN
      oGrRisk = 1.
END PROCEDURE.

/*---------------------------------------------------------------------------
  Function   : LnFormRsrvDam
  Name       : ���ࠡ���� �����㬥�� ��� ���� १�ࢠ �� �ॡ������ �� �����饭�� ��⪠.
  Purpose    : ���ࠡ���� �����㬥�� ��� ���� १�ࢠ �� �ॡ������ �� �����饭�� ��⪠.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - �����
---------------------------------------------------------------------------*/

FUNCTION LnFormRsrvDam RETURNS DEC (INPUT iContract  AS CHAR,
                                    INPUT iContCode  AS CHAR,
                                    INPUT iDate      AS DATE,
                                    INPUT iCurrency  AS CHAR):


   DEFINE BUFFER loan FOR loan. /* ���������� ����. */

   DEFINE VARIABLE vSumm     AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE vRsrvRate AS DECIMAL     NO-UNDO.
   DEFINE VARIABLE vResult   AS DECIMAL     NO-UNDO.

   FIND FIRST loan WHERE loan.contract  EQ iContract
                     AND loan.cont-code EQ iContcode
      NO-LOCK NO-ERROR.
   IF AVAIL loan
   THEN DO:
      RUN LnFormRsrvProc_Sm
                          (loan.contract,
                           loan.cont-code,
                           iDate,
                           "�।������",
                           iCurrency,
                           FALSE,
                           OUTPUT vSumm).
      vRsrvRate = LnRsrvRate (loan.contract,
                              loan.cont-code,
                              iDate).
      vResult = ROUND (vSumm * vRsrvRate / 100,  2).
   END.
   IF mIfPutPtot
      AND NOT(mIfPutNotNull
               AND NUM-ENTRIES(loan.doc-ref, " ") = 2
               AND vResult = 0)
   THEN DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��: �������:  "  loan.doc-ref  FORMAT "X(22)"
         ".  ����⭠� ����:                         " TRIM(STRING(vSumm,     "->>>>>>>>>>>>>>9.99")) SKIP
         "���ଠ��: �������:  "  loan.doc-ref  FORMAT "X(22)"
         ".  %���:                                   " TRIM(STRING(vRsrvRate, "->>>>>>>>>>>>>>9.99")) SKIP
         "���ଠ��: �������:  "  loan.doc-ref  FORMAT "X(22)"
         ".  �㬬� १�ࢠ �� �ॡ. �� ����. ��⪠: " TRIM(STRING(vResult,   "->>>>>>>>>>>>>>9.99")) SKIP
         .
      OUTPUT STREAM out_s CLOSE.
   END.

   RETURN vResult.

END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnWithGuarantee
  Name       : ���� �� � ���� ���ᯥ祭��
  Purpose    : ��।���� ���� �� � ���� ���ᯥ祭�� � ����⢨⥫쭮� �⮨������ > 0
               �����頥� �����᪮� ���祭��.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnWithGuarantee RETURNS LOGICAL (INPUT iContract AS CHAR,
                                          INPUT iContCode AS CHAR,
                                          INPUT iDate     AS DATE):
   DEF VAR vGurAmt AS DEC NO-UNDO.
   
   /* ����砥� �ࠢ������� �⮨����� ���ᯥ祭�� �� �ᥬ� �������� (ᮣ��襭�� + �࠭�) */
   vGurAmt = LnCollateralValueAll(iContract,iContCode,iDate,iDate,"","all").
    
   IF mIfPutPtot THEN 
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��: �������:  "  ENTRY(1,iContCode,"@")  FORMAT "X(22)" 
         ". ����稥 ���ᯥ祭��: " (IF vGurAmt GT 0 THEN "��" ELSE "���") SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
      
   IF vGurAmt GT 0 THEN
      RETURN TRUE.
   ELSE 
      RETURN FALSE.                                          
END FUNCTION.

/*---------------------------------------------------------------------------
  Function   : LnInitPayPerGuar
  Name       : �����頥� ����稭� ��業�, ������ ��⠢��� ��ࢮ��砫�� ����� �� �ࠢ������� �㬬� ���ᯥ祭��
  Purpose    : �����頥� ����稭� ��業�, ������ ��⠢��� ��ࢮ��砫�� ����� �� �ࠢ������� �㬬� ���ᯥ祭��
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ����� १����
---------------------------------------------------------------------------*/
FUNCTION LnInitPayPerGuar RETURNS DEC (INPUT iContract AS CHAR,
                                       INPUT iContCode AS CHAR,
                                       INPUT iDate     AS DATE,
                                       INPUT iCurrency AS CHAR):
   DEF VAR vInitPay AS DEC NO-UNDO.
   DEF VAR vGurAmt  AS DEC NO-UNDO.
   DEF VAR vProc    AS DEC NO-UNDO. 
   
   /* ����砥� �㬬� ��ࢮ��砫쭮�� ����� */
   vInitPay = DEC(GetXAttrValueEx("loan",
                                  STRING(iContract)    + "," +
                                  STRING(iContCode),
                                  "InitPay",
                                  "0")
                  ).
   /* ����砥� �ࠢ������� �⮨����� ���ᯥ祭�� �� ��।����� ���� (ᮣ��襭�� + �࠭�) */
   vGurAmt = LnCollateralValueAll(iContract,iContCode,iDate,iDate,iCurrency,"all").
   
   /* ����塞 ���� ��ࢮ��砫쭮�� ����� �� ���ᯥ祭�� � ��業�� */
   vProc = vInitPay * 100 / vGurAmt.  
   
   IF mIfPutPtot THEN 
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��: �������:  "  ENTRY(1,iContCode,"@")  FORMAT "X(22)" 
         ". ���⭮襭�� ��ࢮ��砫쭮�� ����� � ⥪�饩 �ࠢ������� �⮨���� ���ᯥ祭�� � ��業�� " 
         STRING(vProc,">>>,>>>,>>9.99") SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
    
   RETURN vProc.
END FUNCTION.
                                       
/*---------------------------------------------------------------------------
  Function   : LnMainDebtPerGuar
  Name       : �����頥� ����稭� ��業�, ������ ��⠢��� ���⮪ �᭮����� ����� �� �ࠢ������� �㬬� ���ᯥ祭��
  Purpose    : �����頥� ����稭� ��業�, ������ ��⠢��� ���⮪ �᭮����� ����� �� �ࠢ������� �㬬� ���ᯥ祭��
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
               iCurrency   - ����� १����
---------------------------------------------------------------------------*/
FUNCTION LnMainDebtPerGuar RETURNS DEC (INPUT iContract AS CHAR,
                                        INPUT iContCode AS CHAR,
                                        INPUT iDate     AS DATE,
                                        INPUT iCurrency AS CHAR):
   DEF VAR vDebt    AS DEC NO-UNDO.
   DEF VAR vGurAmt  AS DEC NO-UNDO.
   DEF VAR vProc    AS DEC NO-UNDO. 
   
   /* ����砥� �㬬� ���⪠ �� �᭮����� ����� �� ��।����� ���� */
   vDebt = LnPrincipal(iContract,iContCode,iDate,iCurrency).
   /* ����砥� �ࠢ������� �⮨����� ���ᯥ祭�� �� ��।����� ���� (ᮣ��襭�� + �࠭�) */
   vGurAmt = LnCollateralValueAll(iContract,iContCode,iDate,iDate,iCurrency,"all").
   
   /* ����塞 ���� ��ࢮ��砫쭮�� ����� �� ���ᯥ祭�� � ��業�� */
   vProc = vDebt * 100 / vGurAmt.  
   
   IF mIfPutPtot THEN 
   DO:
      OUTPUT STREAM out_s TO "loanrsrv.log" APPEND.
      PUT STREAM out_s UNFORMATTED
         "���ଠ��: �������:  "  ENTRY(1,iContCode,"@")  FORMAT "X(22)" 
         ". ���⭮襭�� ����稭� �᭮����� ����� � ⥪�饩 �ࠢ������� �⮨���� ���ᯥ祭�� � ��業�� " 
         STRING(vProc,">>>,>>>,>>9.99") SKIP.
      OUTPUT STREAM out_s CLOSE.
   END.
    
   RETURN vProc.
END FUNCTION.

PROCEDURE setVerifyRelType :
DEFINE INPUT PARAMETER iRel_Type AS LOGICAL NO-UNDO .
   ASSIGN
      mVerRel_Type = iRel_Type
      .
END PROCEDURE. /* setVerifyRelType */


PROCEDURE GetVerifyRelType :
DEFINE OUTPUT PARAMETER iRel_Type AS LOGICAL NO-UNDO .
    ASSIGN
      iRel_Type = mVerRel_Type
    .
END PROCEDURE. /* GetVerifyRelType */

PROCEDURE SetSpisBaseParam :
DEFINE INPUT PARAMETER iSpisBaseParam AS CHARACTER NO-UNDO .
DEFINE INPUT PARAMETER iSpisBaseParamP AS CHARACTER NO-UNDO .
   ASSIGN
      mSpisBaseParam = iSpisBaseParam
      mSpisBaseParamP = iSpisBaseParamP
      .
END PROCEDURE. /* setSpisBaseParam */


PROCEDURE GetSpisBaseParam :
DEFINE OUTPUT PARAMETER iSpisBaseParam AS CHARACTER NO-UNDO .
DEFINE OUTPUT PARAMETER iSpisBaseParamP AS CHARACTER NO-UNDO .
    ASSIGN
      iSpisBaseParam  = IF mSpisBaseParam  = ?  THEN "" ELSE mSpisBaseParam
      iSpisBaseParamP = IF mSpisBaseParamP = ? THEN "" ELSE mSpisBaseParamP
    .
END PROCEDURE. /* GetSpisBaseParam */

/*---------------------------------------------------------------------------
  Function   : LnGetExtraditionSum
  Name       : �����頥� �㬬� �뤠����� �।��.
  Purpose    : �����頥� �㬬� �뤠����� �।��.
  Parameters : iContract   - �����祭�� �������
               iContCode   - ����� �������
               iDate       - ��� ����樨
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnGetExtraditionSum RETURNS DECIMAL (INPUT iContract AS CHAR,
                                              INPUT iContCode AS CHAR,
                                              INPUT iDate     AS DATE).

   DEF VAR vExtrSum  AS DEC  INITIAL 0 NO-UNDO.
   DEF VAR vContType AS CHAR NO-UNDO.

   DEF BUFFER loan     FOR loan.
   DEF BUFFER loan-int FOR loan-int.

   FIND FIRST loan WHERE loan.contract  EQ iContract
                     AND loan.cont-code EQ iContCode
                   NO-LOCK NO-ERROR.

   IF AVAIL loan THEN
      vContType = loan.cont-type.

   IF vContType NE "��祭��" THEN
   DO:
      FOR EACH loan-int WHERE loan-int.contract  EQ iContract
                          AND loan-int.cont-code EQ iContCode
                          AND loan-int.mdate     LE iDate
                          AND loan-int.id-d      EQ 0
                          AND loan-int.id-k      EQ 3
                        NO-LOCK:
         vExtrSum = vExtrSum + loan-int.amt-rub.
      END.
   END. 
   ELSE IF vContType EQ "��祭��" THEN
   DO:
      FOR EACH loan WHERE loan.contract                    EQ iContract
                      AND loan.cont-code               BEGINS iContCode + " "
                      AND NUM-ENTRIES(loan.cont-code, " ") EQ 2
                      AND loan.open-date                   LE iDate
                    NO-LOCK:

         FOR EACH loan-int WHERE loan-int.contract  EQ loan.contract
                             AND loan-int.cont-code EQ loan.cont-code
                             AND loan-int.mdate     LE iDate
                             AND loan-int.id-d      EQ 0
                             AND loan-int.id-k      EQ 3             
                           NO-LOCK:
            vExtrSum = vExtrSum + loan-int.amt-rub.
         END.
      END.
   END.

   RETURN vExtrSum.

END FUNCTION. /* LnGetExtraditionSum */



/*---------------------------------------------------------------------------
  Function   : LnGetProvAcct
  Name       : �����頥� �㬬� ���ᯥ祭�� �� ����.
  Purpose    : �����頥� �㬬� ���ᯥ祭�� �� ����.
  Parameters : iAcct - ����� ��㤭��� ���.
  Parameters : iDate - ��� �� ������ �ந�������� ����.
  Notes      :
  ---------------------------------------------------------------------------*/
FUNCTION LnGetProvAcct RETURNS DECIMAL (INPUT iAcct AS CHAR,
                                        INPUT iDate AS DATE).
   /* ��६���� */
   DEFINE VARIABLE vProvSum   AS DECIMAL   NO-UNDO. /* ���� �㬬� ���ᯥ祭��, १���� �����頥�� �㭪樥� */
   DEFINE VARIABLE vObSum     AS DECIMAL   NO-UNDO. /* ���ᯥ祭�� ��� �墠�뢠�饣� */
   DEFINE VARIABLE vTranshSum AS DECIMAL   NO-UNDO. /* ���� �㬬� ���ᯥ祭�� �࠭襩, �� �᪫. ��������㥬��� �࠭� */
   DEFINE VARIABLE vCurSum    AS DECIMAL   NO-UNDO. /* ���� �㬬�  */
   DEFINE VARIABLE vCurStr    AS CHARACTER NO-UNDO. /* ���� ��ப� */
   DEFINE VARIABLE vQualityCategory AS CHARACTER NO-UNDO. /* ��⥣��� ����⢠ ���ᯥ祭�� */
   
   /* ���������� ���஢ */
   DEFINE BUFFER loan        FOR loan. 
   DEFINE BUFFER bloan       FOR loan. 
   DEFINE BUFFER acct        FOR acct.
   DEFINE BUFFER term-obl    FOR term-obl. 
   DEFINE BUFFER loan-acct   FOR loan-acct. 
   DEFINE BUFFER bloan-acct  FOR loan-acct.
   DEFINE BUFFER btt-Loan-ob FOR tt-Loan-ob.

   {empty tt-Loan-ob}
   {find-act.i &acct = iAcct}

   /* ���� �� ��� ��� */
   FOR EACH loan-acct WHERE loan-acct.acct      EQ acct.acct
                        AND loan-acct.currency  EQ acct.currency 
                        AND loan-acct.contract  EQ "�।��" 
                        AND loan-acct.since     LE iDate 
                        AND loan-acct.acct-type EQ "�।��"
                        AND NOT CAN-FIND (FIRST bloan-acct WHERE bloan-acct.contract  EQ loan-acct.contract
                                                             AND bloan-acct.cont-code EQ loan-acct.cont-code
                                                             AND bloan-acct.acct-type EQ loan-acct.acct-type
                                                             AND bloan-acct.since     LE iDate
                                                             AND bloan-acct.since     GT loan-acct.since NO-LOCK)

   NO-LOCK, 
      FIRST loan WHERE loan.contract  EQ loan-acct.contract 
                   AND loan.cont-code EQ loan-acct.cont-code 
                   AND loan.open-date LE iDate
                   AND loan.cont-type NE "��祭��" /* �᪫�砥� �墠�뢠�騥, �.�. �㤥� ����� �� �࠭蠬 */
                   AND ( loan.close-date EQ ? 
                      OR loan.close-date GT iDate )    
      NO-LOCK BREAK BY ENTRY(1, loan-acct.cont-code , " ") BY loan-acct.since :
      /* ���� ���ᯥ祭�� �� ⥪�饬� �������� */
      vCurSum = 0.
      FOR EACH term-obl WHERE (    term-obl.contract   EQ loan.contract
                               AND term-obl.cont-code  EQ loan.cont-code
                               AND term-obl.idnt       EQ 5
                               AND term-obl.end-date   GT iDate 
                               AND term-obl.fop-date   LE iDate )
                           OR
                              (    term-obl.contract   EQ loan.contract
                               AND term-obl.cont-code  EQ loan.cont-code
                               AND term-obl.idnt       EQ 5
                               AND term-obl.end-date   EQ ? 
                               AND term-obl.fop-date   LE iDate )
      NO-LOCK:
         vQualityCategory = Get_QualityGar ("comm-rate",
                                            term-obl.contract + ","
                                            + term-obl.cont-code + ",5,"
                                            + STRING(term-obl.end-date) + ","
                                            + STRING(term-obl.nn),
                                            iDate).
         /* �᫨ ��⥣��� ����⢠ ��� ���ᯥ祭�� �� ��।�����, � �� ��ࠡ��뢠�� ���ᯥ祭�� */
         IF    vQualityCategory EQ "?" 
            OR vQualityCategory EQ ""  THEN 
            NEXT.
         vCurStr =  GetXattrValueEx("term-obl", term-obl.contract + "," +
                                    term-obl.cont-code + "," +
                                    STRING(term-obl.idnt) + "," +
                                    STRING(term-obl.end-date) + "," +
                                    STRING(term-obl.nn),
                                    "��������",
                                    "").
         IF CAN-DO("�।��,�।�����,�।���", vCurStr) THEN            
            vCurSum = vCurSum + CurToBase("�������", term-obl.currency, iDate , term-obl.amt-rub).
      END.
      /* �࠭�, � ������ ���ᯥ祭�� �� �墠�뢠�饬 */
      IF     NUM-ENTRIES(loan.cont-code,' ') GT 1 
         AND vCurSum EQ 0 THEN
      DO:
         /* �饬 �墠�뢠�騩 ��� ��襣� �࠭� */
         FIND LAST  bloan-acct WHERE bloan-acct.contract  EQ loan.contract
                                 AND bloan-acct.cont-code EQ ENTRY(1, loan.cont-code , " ")
                                 AND bloan-acct.since     LE iDate
                                 AND bloan-acct.acct-type EQ "�।��"
         NO-LOCK NO-ERROR. 
         IF AVAIL bloan-acct  
            /* �� ������ �墠�뢠�饬� �� ����� �ன��� ���� 1� ࠧ, �� �� �� ������� ��譥�� */
            AND NOT CAN-FIND (FIRST tt-Loan-ob WHERE tt-Loan-ob.ContCode EQ bloan-acct.cont-code
                                                 AND tt-Loan-ob.Acct     EQ bloan-acct.acct ) THEN
         DO:
            ASSIGN 
               vObSum = 0
               vTranshSum = LnPrincipal(bloan-acct.contract, bloan-acct.cont-code, iDate, bloan-acct.currency) 
            . 
            /* ���� �㬬� ���ᯥ祭�� �� �墠�뢠�饬� */    
            FOR EACH term-obl WHERE (    term-obl.contract   EQ bloan-acct.contract
                                     AND term-obl.cont-code  EQ bloan-acct.cont-code 
                                     AND term-obl.idnt       EQ 5
                                     AND term-obl.end-date   GT iDate 
                                     AND term-obl.fop-date   LE iDate  )
                                 OR
                                    (    term-obl.contract   EQ bloan-acct.contract
                                     AND term-obl.cont-code  EQ bloan-acct.cont-code 
                                     AND term-obl.idnt       EQ 5
                                     AND  term-obl.end-date  EQ ? 
                                     AND term-obl.fop-date   LE iDate  )
            NO-LOCK:
               vQualityCategory = Get_QualityGar ("comm-rate",
                                                  term-obl.contract + ","
                                                  + term-obl.cont-code + ",5,"
                                                  + STRING(term-obl.end-date) + ","
                                                  + STRING(term-obl.nn),
                                                  iDate).
               /* �᫨ ��⥣��� ����⢠ ��� ���ᯥ祭�� �� ��।�����, � �� ��ࠡ��뢠�� ���ᯥ祭�� */
               IF    vQualityCategory EQ "?" 
                  OR vQualityCategory EQ ""  THEN 
                  NEXT.
               vCurStr =  GetXattrValueEx("term-obl", term-obl.contract + "," +
                                          term-obl.cont-code + "," +
                                          STRING(term-obl.idnt) + "," +
                                          STRING(term-obl.end-date) + "," +
                                          STRING(term-obl.nn),
                                          "��������",
                                          "") .
               IF CAN-DO("�।��,�।�����,�।���", vCurStr) THEN  
                  vObSum = vObSum + CurToBase("�������", term-obl.currency, iDate , term-obl.amt-rub).
            END. 

            /* ��室�� �� �ᥬ �������騬 �࠭蠬 � ࠬ��� �墠�뢠�饣� */
            FOR EACH bloan WHERE bloan.contract     EQ loan.contract
                             AND bloan.cont-code    BEGINS ENTRY(1, loan.cont-code , " ") + " "
                             AND bloan.cont-type    NE "��祭��"
                             AND bloan.open-date    LE iDate
                             AND ( bloan.close-date EQ ? 
                                OR bloan.close-date GT iDate )  
            NO-LOCK,
               LAST bloan-acct WHERE bloan-acct.contract  EQ bloan.contract
                                  AND bloan-acct.cont-code EQ bloan.cont-code
                                  AND bloan-acct.acct-type EQ "�।��"
                                  AND bloan-acct.since     LE iDate
               NO-LOCK BREAK BY ENTRY(1, bloan.cont-code , " ") BY bloan.open-date:
               /* ᬮ�ਬ ������� �� � ��� � �� ����� */
               FIND FIRST tt-Loan-ob WHERE tt-Loan-ob.ContCode EQ ENTRY(1, loan.cont-code , " ")
                                       AND tt-Loan-ob.Acct     EQ bloan-acct.acct
               NO-ERROR.
               IF NOT AVAIL tt-Loan-ob THEN 
               DO:
                  CREATE tt-Loan-ob. 
                  ASSIGN
                     tt-Loan-ob.ContCode  = ENTRY(1, loan.cont-code , " ")
                     tt-Loan-ob.Acct      = bloan-acct.acct   
                     tt-Loan-ob.ObSum     = vObSum    
                     tt-Loan-ob.TranshSum = vTranshSum 
                     tt-Loan-ob.IfTransh  = YES
                  .                   
               END.
               tt-Loan-ob.AcctSum   = tt-Loan-ob.AcctSum + LnPrincipal(bloan-acct.contract, bloan-acct.cont-code, iDate, bloan-acct.currency).  
               IF LAST-OF(ENTRY(1, bloan.cont-code , " ")) THEN
                  tt-Loan-ob.IfLast = YES.
            END.            
         END.
      END. ELSE 
      /* ��⠫�� �।��� ������� */
      DO:
         CREATE tt-Loan-ob. 
         ASSIGN
            tt-Loan-ob.ContCode  = loan.cont-code 
            tt-Loan-ob.Acct      = loan-acct.acct   
            tt-Loan-ob.ObSum     = vCurSum    
            tt-Loan-ob.TranshSum = 0  
            tt-Loan-ob.AcctSum   = LnPrincipal(loan-acct.contract, loan-acct.cont-code, iDate, loan-acct.currency)   
            tt-Loan-ob.IfLast    = NO  
            tt-Loan-ob.IfTransh  = NO
         .
      END.
   END.

   /* ���� */
   FOR EACH tt-Loan-ob WHERE tt-Loan-ob.Acct EQ iAcct
   NO-LOCK:
      /* ����� �।��� ������� */
      IF tt-Loan-ob.IfTransh EQ NO THEN
         vProvSum = vProvSum + MIN(tt-Loan-ob.ObSum , tt-Loan-ob.AcctSum ).   
      ELSE  
      /* �᫨ �࠭�, �� �� ��᫥����, � �ய���� */
      IF tt-Loan-ob.IfLast EQ NO THEN 
         /* �㬬� ���ᯥ祭�� �� ����� ���� ����� ᠬ��� �࠭� */
         vProvSum = vProvSum + MIN(ROUND(tt-Loan-ob.ObSum * tt-Loan-ob.AcctSum / tt-Loan-ob.TranshSum , 2)  , tt-Loan-ob.AcctSum ).
      ELSE 
      /* �᫨ �࠭� ��᫥����, � �饬 �訡�� ���㣫���� */ 
      IF tt-Loan-ob.IfLast EQ YES THEN 
      DO:
         FOR EACH btt-Loan-ob WHERE btt-Loan-ob.ContCode EQ tt-Loan-ob.ContCode 
                                AND btt-Loan-ob.acct     NE iAcct
         NO-LOCK:
            tt-Loan-ob.ObSum = tt-Loan-ob.ObSum - ROUND((btt-Loan-ob.ObSum * btt-Loan-ob.AcctSum / btt-Loan-ob.TranshSum), 2).
         END.
         vProvSum = vProvSum + MIN(tt-Loan-ob.ObSum , tt-Loan-ob.AcctSum).         
      END.
   END.
      
   RETURN vProvSum.

END FUNCTION. /* LnGetProvAcct */



