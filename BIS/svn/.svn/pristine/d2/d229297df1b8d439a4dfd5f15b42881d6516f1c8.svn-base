{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2004 ЗАО "Банковские информационные системы"
     Filename: SF-PRINT.P
      Comment: Печать счетов-фактур
   Parameters:
         Uses:
      Used by:
      Created: 27.01.2005 Dasu
     Modified: 19/06/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 22/06/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 03/07/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 06/07/2006 ZIAL (0060144) АХД. Доработки по счетам-фактур. Патч d15.
     Modified: 17.01.2007 11:36 Buryagin заменил вызов sf-print.i на pir-sf-print.i
     Modified: 17.01.2007 11:57 Buryagin добавил переменные orderInfo, accounterFIO
                                Ввел использование параметра процедуры для определения
                                значения вышеуказанных переменных.
*/

/** Buryagin added at 17.01.2007 11:59 */
DEF INPUT PARAM inParam AS CHAR NO-UNDO.
DEF VAR orderInfo AS CHAR NO-UNDO. /** Номер и дата приказа права подписи СФ */
DEF VAR accounterFIO AS CHAR NO-UNDO. /** ФИО лица подписывающего СФ за главного бухгалтера */
/** Buryagin end */
/** Buryagin added at 06.02.2009 9:51 */
DEF VAR bossFIO AS CHAR NO-UNDO. /** ФИО лица, подписывающего СФ за руководителя */
DEF VAR newBossFIO AS CHAR NO-UNDO.
DEF BUFFER bfrAsset FOR asset. /** Для поиска кода услуги и определения подписи руководителя */
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
{branch.pro}    /* Интсрументы для работы с подразделениями */
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}
/*СФ*/
DEFINE VAR mSFNum        AS CHAR NO-UNDO. /*номер счёта-фактуры*/
DEFINE VAR mSFDate       AS DATE NO-UNDO. /*дата сф*/
DEFINE VAR mSFSeller     AS CHAR NO-UNDO. /*продавец*/
DEFINE VAR mSFSellerAddr AS CHAR NO-UNDO. /*продавец Адрес сф*/
DEFINE VAR mSFSellerINN  AS CHAR NO-UNDO. /*продавец INN сф*/
DEFINE VAR mSFSellerKPP  AS CHAR NO-UNDO. /*продавец KPP сф*/


DEFINE VAR mSFBuyer      AS CHAR NO-UNDO. /*покупатель */
DEFINE VAR mSFBuyerAddr  AS CHAR NO-UNDO. /*покупатель Адрес сф*/
DEFINE VAR mSFBuyerINN   AS CHAR NO-UNDO. /*покупатель INN сф*/
DEFINE VAR mSFBuyerKPP   AS CHAR NO-UNDO. /*покупатель KPP сф*/


DEFINE VAR mSFOtprav     AS CHAR NO-UNDO. /*Грузоотправ сф*/
DEFINE VAR mSFOtpravAddr AS CHAR NO-UNDO. /*Адрес Грузоотправ сф*/
DEFINE VAR mSFPoluch     AS CHAR NO-UNDO. /*Грузополучатель сф*/
DEFINE VAR mSFPoluchAddr AS CHAR NO-UNDO. /*Адрес Грузополучателя сф*/

DEFINE VAR mOpNum        AS CHAR NO-UNDO. /*Номер платёжного документа*/
DEFINE VAR mOpDate       AS DATE NO-UNDO. /*Дата платёжного документа*/

DEFINE VAR mPRDNum       AS CHAR NO-UNDO. 
DEFINE VAR mPRDDate      AS CHAR NO-UNDO. 

DEFINE VAR mType         AS CHAR    NO-UNDO.
DEFINE VAR mTotalSumm    AS DECIMAL NO-UNDO.
DEFINE VAR mNalogSumm    AS DECIMAL NO-UNDO.
DEFINE VAR mIsOut        AS LOG     NO-UNDO. /*выставленная или нет СФ*/
DEFINE VAR mNameSrv      AS CHAR NO-UNDO.    /* наименование услуги */

DEFINE VAR mBranchId     AS CHAR NO-UNDO.
DEFINE VAR mStrParentId  AS CHAR NO-UNDO.

DEFINE VAR mSubCode      AS CHAR NO-UNDO.

DEF VAR mCode AS CHAR NO-UNDO.
DEF VAR mAcct AS CHAR NO-UNDO.

DEF VAR Monthes AS CHAR NO-UNDO INIT "января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря".
DEFINE VAR mListOp            AS CHAR NO-UNDO.
DEFINE STREAM sfact.

DEF VAR mI AS INT NO-UNDO. /* счетчик */
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

{setdest.i &cols=120 &STREAM="stream sfact" }/*таблица для услуг*/
DEFINE TEMP-TABLE ttServ NO-UNDO
   FIELD NameServ    AS CHAR     /*Наименование услуги*/
   FIELD Edin        AS CHAR     /*Единица измерения*/
   FIELD Quant       AS DECIMAL  /*количество*/
   FIELD Price       AS DECIMAL  /*цена за единицу*/
   FIELD SummOut     AS DECIMAL  /*сумма без налога*/
   FIELD Akciz       AS DECIMAL  /*сумма акциза*/
   FIELD Nlog        AS DECIMAL  /*ставка налога*/
   FIELD NalogSumm   AS DECIMAL  /*сумма налога*/
   FIELD TotalSumm   AS DECIMAL  /*сумма с налогом*/
   FIELD Contry      AS CHAR     /*страна происхождения*/
   FIELD GTDNum      AS CHAR     /*Номер ГТД*/
.

/** Buryagin added at 17.01.2007 12:01 */
IF NUM-ENTRIES(inParam) = 2 THEN
	ASSIGN 
		accounterFIO = ENTRY(1, inParam)
		orderInfo = ENTRY(2, inParam).
ELSE
	DO:
		MESSAGE "ПИРБанк: Ощибка обработки параметра процедуры!" VIEW-AS ALERT-BOX.
		RETURN ERROR.
	END.
/** Buryagin end */	

mPage = 0.

FOR EACH TMPRECID NO-LOCK:
   FIND FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id /*нашли СФ*/
      NO-LOCK NO-ERROR.
   /*определяем переменные для СФ*/
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

   if TRIM(mSFOtprav) = "ОН ЖЕ" then mSFOtprav = "-".                   
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
   mBranchId = TRIM(GetXAttrValueEx("_user",loan.user-id,"Отделение","")).
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

   mBranchId = TRIM(GetXAttrValueEx("_user",loan.user-id,"Отделение","")).

   IF FGetSetting("СчФБанкРек",?,"") EQ "Нет" THEN
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
               mSFSellerINN = GetXAttrValue("branch",mBranchId,"ИНН")
               mSFSellerKPP = GetXAttrValue("branch",mBranchId,"КПП")
            .
         END.
         ELSE IF loan.contract EQ "sf-in" THEN
         DO:
            ASSIGN   
               mSFBuyer =  branch.Name
               mSFBuyerAddr = branch.address
               mSFBuyerINN = GetXAttrValue("branch",mBranchId,"ИНН")
               mSFBuyerKPP = GetXAttrValue("branch",mBranchId,"КПП")
            .
         END.
      END.
   END.
   ELSE IF FGetSetting("СчФБанкРек",?,"") EQ "" THEN
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
               mSFSellerINN = GetXAttrValue("branch",mStrParentId,"ИНН")
               mSFSellerKPP = GetXAttrValue("branch",mStrParentId,"КПП")
            .
         END.
         ELSE IF loan.contract EQ "sf-in" THEN
         DO:
            ASSIGN   
               mSFBuyer =  branch.Name
               mSFBuyerAddr = branch.Address
               mSFBuyerINN = GetXAttrValue("branch",mStrParentId,"ИНН")
               mSFBuyerKPP = GetXAttrValue("branch",mStrParentId,"КПП")
            .
         END.
      END.
   END.


   bossFIO = "null".
   newBossFIO = bossFIO.
   
   /*смотрим и записываем услуги*/
   FOR EACH term-obl WHERE 
            term-obl.contract  = loan.contract
        AND term-obl.cont-code = loan.cont-code
   NO-LOCK:
      
      CREATE ttServ.

      /** Фамили босса задана в справочнике услуг в поле "Комментарий" услуги. 
          Специализированной функции для возвращения комментария услуги в базовой
          библиотеке pp-asset.p нет, поэтому "лезем" в Базу здесь и берем значение
          
          Если bossFIO <> "null" и bossFIO <> asset.comment, то bossFIO = ""  
          Если bossFIO <> "", то bossFIO := asset.comment 
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
         ttServ.Quant  = term-obl.ratio      /* кол-во */
         ttServ.Price = term-obl.price       /* цена */
         ttServ.Akciz = term-obl.dsc-int-amt /* Акциз */
         ttServ.Nlog  = term-obl.rate        /* Ставка НДС */
         ttServ.NalogSumm = term-obl.int-amt /* Сумма НДС */
         ttServ.TotalSumm = term-obl.amt-rub /* Общая сумма */
         ttServ.SummOut = term-obl.amt-rub - term-obl.int-amt /*сумма без налога*/
         ttServ.GTDNum = GetXattrValueEx("term-obl",
                          term-obl.contract + "," + term-obl.cont-code
                          + "," + STRING(term-obl.idnt) + "," 
                          + STRING(term-obl.end-date) + "," 
                          + STRING(term-obl.nn),
                          "declare",
                          "")                             /* Номер ГТД */
        /** Buryagin commented at 19.02.2007 10:37 
        ttServ.contry = GetAssetCountry(loan.filial-id, term-obl.symbol) *//* Страна */
        ttServ.contry = (IF ttServ.GTDNum = "" THEN "" ELSE GetAssetCountry(loan.filial-id, term-obl.symbol))
        /** Buryagin end */
      . 
      RELEASE ttServ.
   END.

   /* делаем перевод страницы перед печатью счет-фактуры, кроме первой */
   
   IF mPage = 0 THEN mPage = 1.
   ELSE PAGE STREAM sfact.
    
   /** Buryagin commented at 17.01.2007 10:14 
   {sf-print.i}
   */
   
   /** Buryagin added at 17.01.2007 10:14 */
   {pir-sf-print.i}
   

   /*печатаем*/
   {empty ttServ}

END.
{preview.i &STREAM="STREAM sfact"}

{intrface.del}
