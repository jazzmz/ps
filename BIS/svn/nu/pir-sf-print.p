{pirsavelog.p}
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2004 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: SF-PRINT.P
      Comment: ����� ��⮢-䠪���
   Parameters:
         Uses:
      Used by:
      Created: 27.01.2005 Dasu
     Modified: 19/06/2006 ZIAL (0060144) ���. ��ࠡ�⪨ �� ��⠬-䠪���. ���� d15.
     Modified: 22/06/2006 ZIAL (0060144) ���. ��ࠡ�⪨ �� ��⠬-䠪���. ���� d15.
     Modified: 03/07/2006 ZIAL (0060144) ���. ��ࠡ�⪨ �� ��⠬-䠪���. ���� d15.
     Modified: 06/07/2006 ZIAL (0060144) ���. ��ࠡ�⪨ �� ��⠬-䠪���. ���� d15.
     Modified: 17.01.2007 11:36 Buryagin ������� �맮� sf-print.i �� pir-sf-print.i
     Modified: 17.01.2007 11:57 Buryagin ������� ��६���� orderInfo, accounterFIO
                                ���� �ᯮ�짮����� ��ࠬ��� ��楤��� ��� ��।������
                                ���祭�� ���㪠������ ��६�����.
*/

/** Buryagin added at 17.01.2007 11:59 */
DEF INPUT PARAM inParam AS CHAR NO-UNDO.
DEF VAR orderInfo AS CHAR NO-UNDO. /** ����� � ��� �ਪ��� �ࠢ� ������ �� */
DEF VAR accounterFIO AS CHAR NO-UNDO. /** ��� ��� ������뢠�饣� �� �� �������� ��壠��� */
/** Buryagin end */
/** Buryagin added at 06.02.2009 9:51 */
DEF VAR bossFIO AS CHAR NO-UNDO. /** ��� ���, ������뢠�饣� �� �� �㪮����⥫� */
DEF VAR newBossFIO AS CHAR NO-UNDO.
DEF BUFFER bfrAsset FOR asset. /** ��� ���᪠ ���� ��㣨 � ��।������ ������ �㪮����⥫� */
/** Buryagin end */

{globals.i}
{ulib.i}
{intrface.get date}
{intrface.get axd}
{intrface.get asset}
{intrface.get xclass}
{intrface.get strng }
{intrface.get cdrep}
{getcli.pro}
{branch.pro}    /* �����㬥��� ��� ࠡ��� � ���ࠧ������ﬨ */
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{get-bankname.i}
/*��*/
DEFINE VAR mSFNum        AS CHAR NO-UNDO. /*����� ����-䠪����*/
DEFINE VAR mSFDate       AS DATE NO-UNDO. /*��� ��*/
DEFINE VAR mSFSeller     AS CHAR NO-UNDO. /*�த����*/
DEFINE VAR mSFSellerAddr AS CHAR NO-UNDO. /*�த���� ���� ��*/
DEFINE VAR mSFSellerINN  AS CHAR NO-UNDO. /*�த���� INN ��*/
DEFINE VAR mSFSellerKPP  AS CHAR NO-UNDO. /*�த���� KPP ��*/


DEFINE VAR mSFBuyer      AS CHAR NO-UNDO. /*���㯠⥫� */
DEFINE VAR mSFBuyerAddr  AS CHAR NO-UNDO. /*���㯠⥫� ���� ��*/
DEFINE VAR mSFBuyerINN   AS CHAR NO-UNDO. /*���㯠⥫� INN ��*/
DEFINE VAR mSFBuyerKPP   AS CHAR NO-UNDO. /*���㯠⥫� KPP ��*/


DEFINE VAR mSFOtprav     AS CHAR NO-UNDO. /*��㧮��ࠢ ��*/
DEFINE VAR mSFOtpravAddr AS CHAR NO-UNDO. /*���� ��㧮��ࠢ ��*/
DEFINE VAR mSFPoluch     AS CHAR NO-UNDO. /*��㧮�����⥫� ��*/
DEFINE VAR mSFPoluchAddr AS CHAR NO-UNDO. /*���� ��㧮�����⥫� ��*/

DEFINE VAR mOpNum        AS CHAR NO-UNDO. /*����� ����񦭮�� ���㬥��*/
DEFINE VAR mOpDate       AS DATE NO-UNDO. /*��� ����񦭮�� ���㬥��*/

DEFINE VAR mPRDNum       AS CHAR NO-UNDO. 
DEFINE VAR mPRDDate      AS CHAR NO-UNDO. 

DEFINE VAR mType         AS CHAR    NO-UNDO.
DEFINE VAR mTotalSumm    AS DECIMAL NO-UNDO.
DEFINE VAR mNalogSumm    AS DECIMAL NO-UNDO.
DEFINE VAR mIsOut        AS LOG     NO-UNDO. /*���⠢������ ��� ��� ��*/
DEFINE VAR mNameSrv      AS CHAR NO-UNDO.    /* ������������ ��㣨 */

DEFINE VAR mBranchId     AS CHAR NO-UNDO.
DEFINE VAR mStrParentId  AS CHAR NO-UNDO.

DEFINE VAR mSubCode      AS CHAR NO-UNDO.

DEF VAR mCode AS CHAR NO-UNDO.
DEF VAR mAcct AS CHAR NO-UNDO.

DEF VAR Monthes AS CHAR NO-UNDO INIT "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������".
DEFINE VAR mListOp            AS CHAR NO-UNDO.
DEFINE STREAM sfact.

DEF VAR mI AS INT NO-UNDO. /* ���稪 */
DEF VAR mJ AS INT NO-UNDO.
DEF VAR mPage AS INT NO-UNDO.
DEF VAR mLeng AS INT NO-UNDO INIT 197.
DEF VAR mLengBody AS INT NO-UNDO INIT 10.
DEF VAR mLs AS INT NO-UNDO INIT 15.

DEF VAR mSignName1 AS CHAR NO-UNDO.
DEF VAR mSignName2 AS CHAR NO-UNDO.
DEF VAR mSignName3 AS CHAR NO-UNDO.
DEF VAR mSignStr1 AS CHAR NO-UNDO.
DEF VAR mSignStr2 AS CHAR NO-UNDO.
DEF VAR mSignStr3 AS CHAR NO-UNDO.

{setdest.i &cols=120 &STREAM="stream sfact" }/*⠡��� ��� ���*/
DEFINE TEMP-TABLE ttServ NO-UNDO
   FIELD NameServ    AS CHAR     /*������������ ��㣨*/
   FIELD Edin        AS CHAR     /*������ ����७��*/
   FIELD Quant       AS DECIMAL  /*������⢮*/
   FIELD Price       AS DECIMAL  /*業� �� �������*/
   FIELD SummOut     AS DECIMAL  /*�㬬� ��� ������*/
   FIELD Akciz       AS DECIMAL  /*�㬬� ��樧�*/
   FIELD Nlog        AS DECIMAL  /*�⠢�� ������*/
   FIELD NalogSumm   AS DECIMAL  /*�㬬� ������*/
   FIELD TotalSumm   AS DECIMAL  /*�㬬� � �������*/
   FIELD Contry      AS CHAR     /*��࠭� �ந�宦�����*/
   FIELD GTDNum      AS CHAR     /*����� ���*/
.

/** Buryagin added at 17.01.2007 12:01 */
IF NUM-ENTRIES(inParam) = 2 THEN
	ASSIGN 
		accounterFIO = ENTRY(1, inParam)
		orderInfo = ENTRY(2, inParam).
ELSE
	DO:
		MESSAGE "�������: �騡�� ��ࠡ�⪨ ��ࠬ��� ��楤���!" VIEW-AS ALERT-BOX.
		RETURN ERROR.
	END.
/** Buryagin end */	

mPage = 0.

FOR EACH TMPRECID NO-LOCK:
   FIND FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id /*��諨 ��*/
      NO-LOCK NO-ERROR.
   /*��।��塞 ��६���� ��� ��*/
   RUN SFAttribsNames(INPUT loan.contract,
                      INPUT loan.cont-code,

                      OUTPUT mSFSeller,
                      OUTPUT mSFSellerAddr,
                      OUTPUT mSFSellerINN,
                      OUTPUT mSFSellerKPP,

                      OUTPUT mSFBuyer,    
                      OUTPUT mSFBuyerAddr,
                      OUTPUT mSFBuyerINN,
                      OUTPUT mSFBuyerKPP,
                      
                      OUTPUT mSFOtprav,    
                      OUTPUT mSFOtpravAddr,
                      OUTPUT mSFPoluch,
                      OUTPUT mSFPoluchAddr).

   if TRIM(mSFOtprav) = "�� ��" then mSFOtprav = "-".                   
   mSFSeller = cBankNameFull + ", " + cBankName.                      

   mSFBuyer = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
   mSFPoluch = mSFBuyer.
/*
   mSFBuyerAddr = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_address", false).
*/
   mSFPoluchAddr = mSFBuyerAddr.

   RUN SFAttribs_Nums (INPUT loan.contract,
                       INPUT loan.cont-code,

                       OUTPUT mSFNum,  
                       OUTPUT mSFDate,
                       OUTPUT mOpNum, 
                       OUTPUT mOpDate
                      ).

   IF mSFNum EQ ? THEN mSFNum = "".
   IF mOpNum EQ ? THEN mOpNum = "".

/*
   mBranchId = TRIM(GetXAttrValueEx("_user",loan.user-id,"�⤥�����","")).
   FIND FIRST branch WHERE 
              branch.Branch-Id EQ mBranchId
      NO-LOCK NO-ERROR.
   IF AVAIL branch 
   THEN 
      ASSIGN
         mGBName  = branch.CFO-name
         mRukName = branch.mgr-name
      .
*/

   mBranchId = TRIM(GetXAttrValueEx("_user",loan.user-id,"�⤥�����","")).

   IF FGetSetting("�甁������",?,"") EQ "���" THEN
   DO:
      FIND FIRST branch WHERE 
                 branch.Branch-Id EQ mBranchId
         NO-LOCK NO-ERROR.
      IF AVAIL branch THEN 
      DO:
         IF loan.contract EQ "sf-out" THEN
         DO:
            ASSIGN   
               mSFSeller =  branch.Name
               mSFSellerAddr = branch.Address
               mSFSellerINN = GetXAttrValue("branch",mBranchId,"���")
               mSFSellerKPP = GetXAttrValue("branch",mBranchId,"���")
            .
         END.
         ELSE IF loan.contract EQ "sf-in" THEN
         DO:
            ASSIGN   
               mSFBuyer =  branch.Name
               mSFBuyerAddr = branch.address
               mSFBuyerINN = GetXAttrValue("branch",mBranchId,"���")
               mSFBuyerKPP = GetXAttrValue("branch",mBranchId,"���")
            .
         END.
      END.
   END.
   ELSE IF FGetSetting("�甁������",?,"") EQ "" THEN
   DO:
      RUN GetBranchParent_Type(INPUT mBranchId, INPUT "00", INPUT-OUTPUT mStrParentId).

      FIND FIRST branch WHERE 
                 branch.Branch-Id EQ mStrParentId
         NO-LOCK NO-ERROR.
      IF AVAIL branch THEN 
      DO:
         IF loan.contract EQ "sf-out" THEN
         DO:
            ASSIGN   
               mSFSeller =  branch.Name
               mSFSellerAddr = branch.Address
               mSFSellerINN = GetXAttrValue("branch",mStrParentId,"���")
               mSFSellerKPP = GetXAttrValue("branch",mStrParentId,"���")
            .
         END.
         ELSE IF loan.contract EQ "sf-in" THEN
         DO:
            ASSIGN   
               mSFBuyer =  branch.Name
               mSFBuyerAddr = branch.Address
               mSFBuyerINN = GetXAttrValue("branch",mStrParentId,"���")
               mSFBuyerKPP = GetXAttrValue("branch",mStrParentId,"���")
            .
         END.
      END.
   END.


   bossFIO = "null".
   newBossFIO = bossFIO.
   
   /*ᬮ�ਬ � �����뢠�� ��㣨*/
   FOR EACH term-obl WHERE 
            term-obl.contract  = loan.contract
        AND term-obl.cont-code = loan.cont-code
   NO-LOCK:
      
      CREATE ttServ.

      /** ������ ���� ������ � �ࠢ�筨�� ��� � ���� "�������਩" ��㣨. 
          ���樠����஢����� �㭪樨 ��� �����饭�� ��������� ��㣨 � �������
          ������⥪� pp-asset.p ���, ���⮬� "�����" � ���� ����� � ��६ ���祭��
          
          �᫨ bossFIO <> "null" � bossFIO <> asset.comment, � bossFIO = ""  
          �᫨ bossFIO <> "", � bossFIO := asset.comment 
      */
      
      FIND FIRST bfrAsset WHERE
      			 bfrAsset.cont-type EQ term-obl.symbol
      			 AND
      			 bfrAsset.filial-id EQ loan.filial-id
      			 NO-LOCK NO-ERROR.
      IF AVAIL bfrAsset THEN DO:
        newBossFIO = TRIM(GetXAttrValueEx("asset", bfrAsset.filial-id + "," + bfrAsset.cont-type, "PIRsignSF", "")).
      	IF bossFIO <> "null" AND bossFIO <> newBossFIO THEN bossFIO = "".
      	IF bossFIO <> "" THEN bossFIO = newBossFIO.
      END. ELSE
      	bossFIO = "". 
      if bfrAsset.cont-type = "10000060" then 
      ASSIGN
	    mSFPoluch = "-"
	    mSFPoluchAddr = "".
 
      ASSIGN 
         mNameSrv = SFAssetName(term-obl.contract + "," +
                                term-obl.cont-code + "," + 
                                STRING(term-obl.idnt) + "," + 
                                STRING(term-obl.end-date) + "," +
                                STRING(term-obl.nn),
                                term-obl.symbol)
         ttServ.NameServ = SplitStr(mNameSrv,30,'~n')
         ttServ.Edin = GetAssetUnit(loan.filial-id,term-obl.symbol)
         .
                          
      ASSIGN         
         ttServ.Quant  = term-obl.ratio      /* ���-�� */
         ttServ.Price = term-obl.price       /* 業� */
         ttServ.Akciz = term-obl.dsc-int-amt /* ��樧 */
         ttServ.Nlog  = term-obl.rate        /* �⠢�� ��� */
         ttServ.NalogSumm = term-obl.int-amt /* �㬬� ��� */
         ttServ.TotalSumm = term-obl.amt-rub /* ���� �㬬� */
         ttServ.SummOut = term-obl.amt-rub - term-obl.int-amt /*�㬬� ��� ������*/
         ttServ.GTDNum = GetXattrValueEx("term-obl",
                          term-obl.contract + "," + term-obl.cont-code
                          + "," + STRING(term-obl.idnt) + "," 
                          + STRING(term-obl.end-date) + "," 
                          + STRING(term-obl.nn),
                          "declare",
                          "")                             /* ����� ��� */
        /** Buryagin commented at 19.02.2007 10:37 
        ttServ.contry = GetAssetCountry(loan.filial-id, term-obl.symbol) *//* ��࠭� */
        ttServ.contry = (IF ttServ.GTDNum = "" THEN "" ELSE GetAssetCountry(loan.filial-id, term-obl.symbol))
        /** Buryagin end */
      . 
      RELEASE ttServ.
   END.

   /* ������ ��ॢ�� ��࠭��� ��। ������ ���-䠪����, �஬� ��ࢮ� */
   
   IF mPage = 0 THEN mPage = 1.
   ELSE PAGE STREAM sfact.
    
   /** Buryagin commented at 17.01.2007 10:14 
   {sf-print.i}
   */
   
   /** Buryagin added at 17.01.2007 10:14 */
   {pir-sf-print.i}
   

   /*���⠥�*/
   {empty ttServ}

END.
{preview.i &STREAM="STREAM sfact"}

{intrface.del}
