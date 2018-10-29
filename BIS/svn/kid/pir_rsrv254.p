{pirsavelog.p}

/*
   ��ᯮ�殮��� �� १�ࢠ� 232-�
   ���� �.�. 10.01.2006 10:19

   �᫮�����, �� ��㧥� ��࠭� ⮫쪮 "�ࠢ����" ���㬥���, �.�. �,
   ����� ������ �⮡ࠦ����� � �����饬 �ᯮ�殮���.

Modified: 20.05.2009 Borisov - ��������� ������� ���ᯥ祭��
*/

{globals.i} /* �������塞 �������� ����ன��*/

{ulib.i}    /* ������⥪� �㭪権 ��� ࠡ��� � ��⠬� */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get xclass}   /* �㭪樨 ࠡ��� � ����奬�� */
{intrface.get count}


/** ����������� **/
FUNCTION LnPrincipal2 RETURNS DECIMAL (INPUT iContract AS CHAR, INPUT iContCode AS CHAR,
                      INPUT iDate AS DATE, INPUT iCurrency AS CHAR, INPUT CC AS CHAR)
   FORWARD.
/* ============================================== */
DEF VAR oTable AS TTable       NO-UNDO.
DEF VAR oTpl     AS TTpl           NO-UNDO.
DEF VAR oDoc   AS TDocument NO-UNDO.

oTpl = new TTpl("pir_rsrv254.tpl").


DEF INPUT PARAM inParam    AS CHARACTER.
DEF VAR acct_rsrv          AS CHARACTER NO-UNDO. /* ��� १�ࢠ: ��।���� � ��࠭�� ��� � �⮩ ��६����� */
DEF VAR acct_main_no       AS CHARACTER NO-UNDO. /* ��������ᮢ� ���, ����� �������� � ���� �⮫��� */
DEF VAR acct_main_cur      AS CHARACTER NO-UNDO.
DEF VAR acct_main_pos      AS DECIMAL   NO-UNDO. /* ������ �� ���� */
DEF VAR acct_main_pos_rur  AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_calc_pos AS DECIMAL   NO-UNDO.
DEF VAR acct_rsrv_real_pos AS DECIMAL   NO-UNDO.

/* �㬬� ����樨 */
DEF VAR amt_create  AS DECIMAL   NO-UNDO.
DEF VAR amt_delete  AS DECIMAL   NO-UNDO.

DEF VAR client_name AS CHARACTER NO-UNDO.
DEF VAR loaninf     AS CHARACTER NO-UNDO.
DEF VAR grrisk      AS INTEGER   NO-UNDO.
DEF VAR prrisk      AS DECIMAL   NO-UNDO.
DEF VAR obesp       AS DECIMAL   NO-UNDO.
DEF VAR o2          AS DECIMAL   NO-UNDO. /* obesp usl dog - ne isp */
DEF VAR ob-cat      AS CHARACTER NO-UNDO.
DEF VAR iob-cat     AS DECIMAL   NO-UNDO.
DEF VAR loannum     AS CHARACTER NO-UNDO.
DEF VAR vSurr       AS CHARACTER NO-UNDO. /* ���ண�� ��易⥫��⢠ */

/* �⮣��� ���祭�� */
DEF VAR total_pos         AS DECIMAL NO-UNDO.
DEF VAR total_pos_rur     AS DECIMAL NO-UNDO.
DEF VAR total_pos_usd     AS DECIMAL NO-UNDO.
DEF VAR total_pos_eur     AS DECIMAL NO-UNDO.
DEF VAR total_calc_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_real_rsrv   AS DECIMAL NO-UNDO.
DEF VAR total_create_rsrv AS DECIMAL NO-UNDO.
DEF VAR total_delete_rsrv AS DECIMAL NO-UNDO.

DEF VAR traceOn           AS LOGICAL INITIAL false NO-UNDO. /* �뢮� �訡�� �� �࠭ */
DEF VAR tmpStr    AS CHARACTER NO-UNDO. /* �६����� ��� ࠡ��� */
DEF VAR PIRbos    AS CHARACTER NO-UNDO. /* �������� � ������ */
DEF VAR PIRbosFIO AS CHARACTER NO-UNDO.
DEF VAR userPost  AS CHARACTER NO-UNDO.

DEF BUFFER bfrLA  FOR loan-acct.

DEF VAR DATE-rasp AS DATE NO-UNDO. /* ��� �ᯮ�殮��� */
/* ������ �뤥������ � ��㧥� ���㬥�⮢ */

{tmprecid.def}
/**** ��᫮� ���㧪� � ��娢 ***/
&IF DEFINED(arch2)<>0 &THEN
&GLOBAL-DEFINE wsd 1
{pir-out2arch.i}
curr-user-inspector = FGetSetting("PirEArch","RepInspCredit",?). /* #3718 */
&ENDIF



/** �஢�ઠ �室�饣� ��ࠬ��� =================================================== */
IF NUM-ENTRIES(inParam) <> 2 
THEN DO:
   MESSAGE "�������筮� ���-�� ��ࠬ��஢. ������ ���� <���_���㬥��>,<���_�㪮����⥫�_��_PIRBoss>" 
      VIEW-AS ALERT-BOX.
   RETURN.
END.

PIRbos      =  ENTRY(1, FGetSetting("PIRboss", ENTRY(2, inParam), "")).
PIRbosFIO = ENTRY(2, FGetSetting("PIRboss", ENTRY(2, inParam), "")).

/** ���������� **/

/* �� ��ࢮ� ����樨 ������ ���� ���� */
DATE-rasp = gend-date.

oTable = new TTable(16).

/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... =========================== */
FOR EACH tmprecid NO-LOCK:

  oDoc = new TDocument(tmprecid.id).

   ASSIGN
      amt_create = 0
      amt_delete = 0
   .
   /* ������ ��� १�ࢠ � �஢����. �� ���� �� ������, ���� �� �।��� � ��稭����� � 4 
      ����⭮ ��࠭�� ���祭�� �㬬� �஢���� � ᮮ⢥�������� ��६�����  */
   IF oDoc:acct-db BEGINS "4" THEN
      ASSIGN
         acct_rsrv  = oDoc:acct-db
         amt_delete = oDoc:sum
      .
   IF oDoc:acct-cr BEGINS "4" THEN
      ASSIGN
         acct_rsrv  = oDoc:acct-cr
         amt_create = oDoc:sum
      .

   /* �᫨ ��-⠪� �� �� ������, �� �� �।��� ���, ��稭��騩�� �� 4 �� ������,
      �뤠�� ᮮ�饭�� � ��室�� �� ��楤��� */
   IF acct_rsrv = ""
   THEN DO:
      MESSAGE "� �஢���� ���㬥�� " + oDoc:doc-num + " ��� ��� १�ࢠ, ��稭��饣��� �� 4!" VIEW-AS ALERT-BOX.
      RETURN.
   END.

   /* ������ �������� ������ */
   client_name = GetAcctClientName_UAL(acct_rsrv, traceOn).

   /* ������ ���ଠ�� � ������� */
   loannum = "".
   FIND LAST bfrLA
      WHERE bfrLA.acct = acct_rsrv
        AND bfrLA.contract EQ "�।��"
      NO-LOCK NO-ERROR.
   IF AVAIL bfrLA
   THEN DO:
      
      FIND LAST loan
         WHERE loan.contract  = bfrLA.contract
           AND loan.cont-code = bfrLA.cont-code
         NO-LOCK NO-ERROR.

      IF AVAIL loan
      THEN DO:
         IF client_name = "" THEN 
            client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).

         loaninf = getMainLoanAttr("�।��",loan.cont-code,"%cont-code �� %��⠑���").
         loannum = loan.cont-code.

   /* ���� "������" ��� �१ �������  */
      /* �᫨ ��� �ਢ易� � ��������, � �㦭� �஠������஢��� ��� ஫�.
         ������ ᮮ⢥�⢨� ஫�� ��� १�ࢠ � "��������"
                 �।��� ....... �।��
                 �।���1....... �।�� 
      */

   IF bfrLA.acct-type = "�।���1" THEN
      acct_main_no = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", oDoc:DocDate, false).
   IF bfrLA.acct-type = "�।���"  THEN
      acct_main_no = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", oDoc:DocDate, false).
   acct_main_cur = SUBSTR(acct_main_no, 6, 3).

   /* ������ ���⮪ �� ������ ���� �� ���� */

   acct_main_pos     = LnPrincipal2 (loan.contract, loan.cont-code, DATE-rasp, loan.currency, bfrLA.acct-type).
   acct_main_pos_rur = CurToCur ("�������", acct_main_cur, "", DATE-rasp, acct_main_pos).

   /* ������ ����� १��. �� ᠬ�� ����, �� ������ �믮������ ��楤��� �� 䠪��᪨ 㦥 
      ��ନ஢���� १�� */
   acct_rsrv_calc_pos = ABS(GetAcctPosValue_UAL(acct_rsrv, "810", oDoc:DocDate, traceOn)).

   /* ������ ��ନ஢���� १��. ��᪮��� �ᯮ�殮��� �ନ����� �� 䠪��, �.�. �� �஢�����, �
      �㬬� ��ନ஢������ १�ࢠ = ���⮪ �� ��� १�ࢠ +- �㬬� �஢���� */
   acct_rsrv_real_pos = acct_rsrv_calc_pos - amt_create + amt_delete.

   /* ����������� �⮣��� �㬬� */
   total_pos = total_pos + acct_main_pos_rur.
   IF acct_main_cur = "810" THEN
      total_pos_rur = total_pos_rur + acct_main_pos.
   IF acct_main_cur = "840" THEN
      total_pos_usd = total_pos_usd + acct_main_pos.
   IF acct_main_cur = "978" THEN
      total_pos_eur = total_pos_eur + acct_main_pos.

   ASSIGN
      total_calc_rsrv = total_calc_rsrv + acct_rsrv_calc_pos
      total_real_rsrv = total_real_rsrv + acct_rsrv_real_pos
      total_create_rsrv = total_create_rsrv + amt_create
      total_delete_rsrv = total_delete_rsrv + amt_delete
   .

   /* ��।���� ��業��� �⠢�� � ��㯯� �᪠ */
   prrisk = LnRsrvRate(loan.contract, loan.cont-code, DATE-rasp).
   grrisk = LnGetGrRiska(prrisk, DATE-rasp).

   /* ��।���� ���ᯥ祭�� */
   RUN LnCollateralValueEx(loan.contract, loan.cont-code, DATE-rasp, ?, "", OUTPUT obesp, OUTPUT o2).

   ob-cat = "".

   IF obesp NE 0
   THEN DO:
      FOR EACH term-obl
         WHERE term-obl.cont-code EQ loannum
           AND term-obl.idnt      EQ 5
         NO-LOCK:

         vSurr  = term-obl.contract + "," + 
                  term-obl.cont-code + "," + 
                  STRING(term-obl.idnt) + "," +
                  STRING(term-obl.end-date) + "," + 
                  STRING(term-obl.nn).
         ob-cat = Get_QualityGar ("comm-rate", vSurr, DATE-rasp).

         /* ������ ����⢠ ���ᯥ祭�� �� �����䨪���� "����⢮����"*/
         iob-cat  = DECIMAL(GetCode("����⢮����", ob-cat )).

         IF (ob-cat NE "") AND (ob-cat NE "?") THEN LEAVE.
      END.

      IF ob-cat EQ "" THEN 
         MESSAGE "�� ������� ���ᯥ祭�� ��� ������� " + loannum
            VIEW-AS ALERT-BOX.
      END.

   IF ((acct_main_pos_rur GT obesp) AND (ABS(ROUND((acct_main_pos_rur - obesp) * prrisk / 100, 2) - acct_rsrv_calc_pos) GE 0.05)) OR
      ((acct_main_pos_rur LE obesp) AND (acct_rsrv_calc_pos NE 0))
   THEN DO:
      MESSAGE "���ࠢ���� ���� ��� ������� " + loannum
         skip "Obesp = " STRING(obesp)
         skip "d.b.  = " STRING(CurrRound(acct_main_pos_rur - (acct_rsrv_calc_pos * 100 / prrisk), ""))
         VIEW-AS ALERT-BOX.
      obesp = CurrRound(acct_main_pos_rur - (acct_rsrv_calc_pos * 100 / prrisk), "").
   END.
   IF iob-cat NE 0 THEN
      obesp = obesp / (iob-cat / 100).
   END.

  END.



/* �᭮���� ⥫� ⠡���� */
oTable:addRow().
oTable:addCell(acct_main_no + client_name + loaninf).
oTable:addCell(acct_main_pos).
oTable:addCell(acct_main_cur).
oTable:addCell(acct_main_pos_rur).
oTable:addCell(grrisk).
oTable:addCell(prrisk).
oTable:addCell(obesp).
oTable:addCell(ob-cat).
oTable:addCell(acct_rsrv_calc_pos).
oTable:addCell(acct_rsrv_real_pos).
oTable:addCell(amt_create).
oTable:addCell(amt_delete).

oTable:addCell(oDoc:acct-db).
oTable:addCell(oDoc:acct-cr).

DELETE OBJECT oDoc.


END.


/* �⮣� */
oTable:addRow().
oTable:addCell("�����:").
oTable:addCell(total_pos_rur).
oTable:addCell("810").
oTable:addCell(total_pos).
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell(total_calc_rsrv).
oTable:addCell(total_real_rsrv).
oTable:addCell(total_create_rsrv).
oTable:addCell(total_delete_rsrv).
oTable:addCell("").
oTable:addCell("").


oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_usd).
oTable:addCell("840").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:addRow().
oTable:addCell("").
oTable:addCell(total_pos_eur).
oTable:addCell("978").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").
oTable:addCell("").

oTable:setBorder(1,oTable:height,1,0,1,1).
oTable:setBorder(1,oTable:height - 1,1,0,1,1).
oTable:setAlign(1,oTable:height - 2,"center").

oTpl:addAnchorValue("TABLE",oTable).
oTpl:addAnchorValue("date-rasp",date-rasp).

{setdest.i &cols=220} /* �뢮� � preview */
	oTpl:show().
{preview.i}
DELETE OBJECT oTpl.

{send2arch.i}

/* ========================================================== */
FUNCTION LnPrincipal2 RETURNS DECIMAL (INPUT iContract AS CHAR,
                                       INPUT iContCode AS CHAR,
                                       INPUT iDate     AS DATE,
                                       INPUT iCurrency AS CHAR,
                                       INPUT CC        AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mLoanCurr  AS CHAR NO-UNDO. /* ������ �������� */
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF b-loan.cont-type <> "��祭��"
   THEN DO:
      IF CC = "�।���"
      THEN DO:
         RUN RE_PARAM IN h_Loan ( 0, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).
         RUN RE_PARAM IN h_Loan (13, iDate, iContract, iContCode, OUTPUT vParamSumm, OUTPUT vDb, OUTPUT vCr).
         vRes = vRes + vParamSumm.
      END.
      ELSE
         RUN RE_PARAM IN h_Loan ( 7, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).

      IF b-loan.Currency <> iCurrency
         THEN vRes = CurToCurWork("����", b-loan.currency, iCurrency, iDate, vRes).
   END.

   ELSE DO:
      vRes = 0.
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

         vRes = vRes +  LnPrincipal2(b-loan.contract, b-loan.cont-code, iDate, iCurrency, CC).
      END. /*FOR EACH*/
   END.

   mResult = CurrRound(vRes,iCurrency).

   RETURN mResult.

END FUNCTION.
