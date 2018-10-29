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
     Modified:
*/

{tmprecid.def}

{globals.i}
{intrface.get date}
{intrface.get axd}
{intrface.get asset}
{intrface.get xclass}
{intrface.get strng }
{intrface.get cdrep}
{intrface.get db2l}
{getcli.pro}
{branch.pro}    /* Интсрументы для работы с подразделениями */
{wordwrap.def}
/*СФ*/
{get-bankname.i}
DEF INPUT PARAM inParam AS CHAR NO-UNDO.
DEF VAR orderInfo AS CHAR NO-UNDO. /** Номер и дата приказа права подписи СФ */
DEF VAR accounterFIO AS CHAR NO-UNDO. /** ФИО лица подписывающего СФ за главного бухгалтера */
/** Buryagin end */
/** Buryagin added at 06.02.2009 9:51 */
DEF VAR bossFIO AS CHAR NO-UNDO. /** ФИО лица, подписывающего СФ за руководителя */
DEF VAR newBossFIO AS CHAR NO-UNDO.
DEF BUFFER bfrAsset FOR asset. /** Для поиска кода услуги и определения подписи руководителя */

def var btrim as logical INIT yes no-undo.  
def var btrim1 as logical no-undo. 
def var btrim2 as logical INIT yes no-undo.  


DEFINE VAR mSFNum         AS CHAR NO-UNDO. /*номер счёта-фактуры*/
DEFINE VAR mSFDate        AS DATE NO-UNDO. /*дата сф*/
DEFINE VAR mSFFixInfo     AS CHAR NO-UNDO. /*информация по исправлениям*/
DEFINE VAR mSFFixDate     AS DATE NO-UNDO. /*дата исправления*/
DEFINE VAR mSFFixNum      AS CHAR NO-UNDO. /*номер исправления*/
DEFINE VAR mSFTovar       AS LOG  NO-UNDO. /*ДР Товар*/
DEFINE VAR mSFSeller      AS CHAR NO-UNDO. /*продавец*/
DEFINE VAR mSFSellerAddr  AS CHAR NO-UNDO. /*продавец Адрес сф*/
DEFINE VAR mSFSellerINN   AS CHAR NO-UNDO. /*продавец INN сф*/
DEFINE VAR mSFSellerKPP   AS CHAR NO-UNDO. /*продавец KPP сф*/
DEFINE VAR mSFCurrInfo    AS CHAR NO-UNDO. /*код и наименование валюты сф*/
DEFINE VAR mSFCurrLine    AS CHAR NO-UNDO. /*прочерк под реквизитами сф*/
DEFINE VAR mSFCurrName    AS CHAR NO-UNDO. /*наименование сф*/

DEFINE VAR mIsEmptyKol       AS LOG  NO-UNDO. /*ДР не печатать количество*/

DEFINE VAR mSFBuyer       AS CHAR NO-UNDO. /*покупатель */
DEFINE VAR mSFBuyerAddr   AS CHAR NO-UNDO. /*покупатель Адрес сф*/
DEFINE VAR mSFBuyerINN    AS CHAR NO-UNDO. /*покупатель INN сф*/
DEFINE VAR mSFBuyerKPP    AS CHAR NO-UNDO. /*покупатель KPP сф*/
                         
                         
DEFINE VAR mSFOtprav      AS CHAR NO-UNDO. /*Грузоотправ сф*/
DEFINE VAR mSFOtpravAddr  AS CHAR NO-UNDO. /*Адрес Грузоотправ сф*/
DEFINE VAR mSFPoluch      AS CHAR NO-UNDO. /*Грузополучатель сф*/
DEFINE VAR mSFPoluchAddr  AS CHAR NO-UNDO. /*Адрес Грузополучателя сф*/
                         
DEFINE VAR mOpNum         AS CHAR NO-UNDO. /*Номер платёжного документа*/
DEFINE VAR mOpDate        AS DATE NO-UNDO. /*Дата платёжного документа*/
DEFINE VAR mDocNumDate    AS CHAR NO-UNDO. /*список номеров платежных документов и дат выдачи для проводок типа "sf-of-pay"*/
DEFINE VAR mDocNumLine    AS CHAR NO-UNDO. /*прочерк под списком номеров платежных документов*/
DEFINE VAR mSurrOp        AS CHAR NO-UNDO. /* Список суррогатов платежей, связанных со 
                                           ** счетом-фактурой */
                         
DEFINE VAR mPRDNum        AS CHAR NO-UNDO. 
DEFINE VAR mPRDDate       AS CHAR NO-UNDO. 

DEFINE VAR temp-amt-rub     AS DEC NO-UNDO.     /*стоимость*/
DEFINE VAR temp-amt-rub-nds AS DEC NO-UNDO. /*стоимость без ндс*/
DEFINE VAR temp-ao          as LOG NO-UNDO.
                         
DEFINE VAR mType          AS CHAR NO-UNDO.
DEFINE VAR mTotalSumm     AS DEC  NO-UNDO.
DEFINE VAR mNalogSumm     AS DEC  NO-UNDO.
DEFINE VAR mPriceSumm     AS DEC  NO-UNDO.

DEFINE VAR mIsOut         AS LOG  NO-UNDO. /*выставленная или нет СФ*/
DEFINE VAR mNameSrv       AS CHAR NO-UNDO.    /* наименование услуги */
                         
DEFINE VAR mBranchId      AS CHAR NO-UNDO.
DEFINE VAR mStrParentId   AS CHAR NO-UNDO.
DEFINE VAR mBranch        AS CHAR NO-UNDO.

DEFINE VAR mSfBankRek     AS CHAR NO-UNDO. /* Значение НП "СчФБанкРек" */ 
DEFINE VAR mSfPodrazd     AS CHAR NO-UNDO. /* Значение НП "СчФПодраз" */  
                         
DEFINE VAR mSubCode       AS CHAR NO-UNDO.

DEFINE VAR mStrSeller     AS CHAR NO-UNDO EXTENT 10. /* продавец */
DEFINE VAR mStrSellerAddr AS CHAR NO-UNDO EXTENT 10. /* продавец Адрес сф */
DEFINE VAR mStrBuyer      AS CHAR NO-UNDO EXTENT 10. /* покупатель */
DEFINE VAR mStrBuyerAddr  AS CHAR NO-UNDO EXTENT 10. /* покупатель Адрес сф */
DEFINE VAR mStrOtprav     AS CHAR NO-UNDO EXTENT 10. /* Грузоотправ сф + Адрес*/
DEFINE VAR mStrPoluch     AS CHAR NO-UNDO EXTENT 10. /* Грузополучатель сф + Адрес*/
DEFINE VAR mWide          AS INT64  NO-UNDO.
DEFINE VAR mBrShortName   AS CHARACTER   NO-UNDO. /* Короткое наим-е филиала */
DEFINE VAR mNameGO        AS CHARACTER   NO-UNDO.
DEFINE VAR mAdresGO       AS CHARACTER   NO-UNDO.

DEF VAR mCode      AS CHAR NO-UNDO.
DEF VAR mAcct      AS CHAR NO-UNDO.
DEF VAR mSchFStKl  AS CHAR NO-UNDO. /* Значение НП СчФСтКл */
DEF VAR Monthes    AS CHAR NO-UNDO INIT "января,февраля,марта,апреля,мая,июня,июля,августа,сентября,октября,ноября,декабря".
DEF VAR mListOp AS CHAR NO-UNDO.

DEFINE STREAM sfact.

DEF VAR mI AS INT64 NO-UNDO. /* счетчик */
DEF VAR mJ AS INT64 NO-UNDO.
DEF VAR mPage AS INT64 NO-UNDO.
DEF VAR mLeng AS INT64 NO-UNDO INIT 197.
DEF VAR mLengBody AS INT64 NO-UNDO INIT 10.
DEF VAR mLs AS INT64 NO-UNDO INIT 0.

DEF VAR mSignName1 AS CHAR NO-UNDO.
DEF VAR mSignName2 AS CHAR NO-UNDO.
DEF VAR mSignName3 AS CHAR NO-UNDO.
DEF VAR mSignStr1 AS CHAR NO-UNDO.
DEF VAR mSignStr2 AS CHAR NO-UNDO.
DEF VAR mSignStr3 AS CHAR NO-UNDO.
DEF VAR mMaxRow AS INT64  NO-UNDO.

DEF VAR cPlatNumbers as CHAR EXTENT 10 NO-UNDO.
DEF VAR iCycle AS INT NO-UNDO.

DEFINE VARIABLE i AS INT64 NO-UNDO.

&GLOB  STR1 'К платёжно-расчётному документу'
{setdest.i &cols=120 &STREAM="stream sfact" &filename="'_spool_sf.tmp'"}

/*таблица для услуг*/
DEFINE TEMP-TABLE ttServ NO-UNDO
   FIELD NameServ    AS CHAR     /*Наименование услуги*/
   FIELD Edin        AS CHAR     /*Единица измерения*/
   FIELD EdinName    AS CHAR     /*Условное обозначение единицы измерения*/
   FIELD Quant       AS DECIMAL  /*количество*/
   FIELD Price       AS DECIMAL  /*цена за единицу*/
   FIELD SummOut     AS DECIMAL  /*сумма без налога*/
   FIELD Akciz       AS DECIMAL  /*сумма акциза*/
   FIELD Nlog        AS DECIMAL  /*ставка налога*/
   FIELD NalogSumm   AS DECIMAL  /*сумма налога*/
   FIELD TotalSumm   AS DECIMAL  /*сумма с налогом*/
   FIELD Contry      AS CHAR     /*страна происхождения*/
   FIELD ContryName  AS CHAR     /*наименование страны происхождения*/
   FIELD GTDNum      AS CHAR     /*Номер ГТД*/
   FIELD Curr        AS CHAR     /*Валюта*/
.

DEF BUFFER b-loan FOR loan. /* Локализация буффера. */

mPage = 0.

IF NUM-ENTRIES(inParam) = 2 THEN
	ASSIGN 
		accounterFIO = ENTRY(1, inParam,";")
		orderInfo = ENTRY(2, inParam,";").
ELSE
	DO:
		MESSAGE "ПИРБанк: Ощибка обработки параметра процедуры!" VIEW-AS ALERT-BOX.
		RETURN ERROR.
	END.



mSchFStKl = FGetSetting ("СчФСтКл","","?").

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

   RUN SFAttribs_Nums (INPUT loan.contract,
                       INPUT loan.cont-code,

                       OUTPUT mSFNum,  
                       OUTPUT mSFDate,
                       OUTPUT mOpNum, 
                       OUTPUT mOpDate
                      ).
   


   if loan.contract = 'sf-out' and GetXattrValue("cust-corp",STRING(loan.cust-id),"Pir-Sf-adr") <> "" then 
      mSFBuyerAddr = GetXattrValue("cust-corp",STRING(loan.cust-id),"Pir-Sf-adr").


                         
                      
   ASSIGN
      mDocNumDate = ""
      mSFNum = "" WHEN mSFNum EQ ?
      mOpNum = "" WHEN mOpNum EQ ?
   .
   IF loan.loan-status EQ "Аннулир" THEN
      mSFFixInfo = GetXattrValue("loan",loan.contract + "," + loan.cont-code,"НомДатКорр").

   mSFTovar = GetXattrValue("loan",loan.contract + "," + loan.cont-code,"Товар") EQ "Да".

   IF {assigned loan.currency} THEN
   DO:
      mSFCurrName = GetBufferValue("currency","WHERE currency.currency EQ " + QUOTER(loan.currency),"name-currenc").
      ASSIGN
/*         mSFCurrInfo = "код " + loan.currency + " наименование " + mSFCurrName
         mSFCurrLine = "           ───              " + FILL("─",LENGTH(mSFCurrName))*/
         mSFCurrInfo = "наименование " + mSFCurrName + " код " + loan.currency
         mSFCurrLine = "             " + FILL("─",LENGTH(mSFCurrName)) + "     ___"
         .
   END.
   ELSE
      ASSIGN    
         mSFCurrInfo = "наименование российский рубль код 643"
         mSFCurrLine = "                    ────────────────     ───"
         .

/*   IF (loan.cont-type EQ "а/о") or (loan.cont-type EQ "п/о") THEN */  
   DO:
      mSurrOp = GetLinks(loan.class-code,             /* ID класса     */
                loan.contract + "," + loan.cont-code, /* ID(cуррогат) объекта   */
                ?,                                    /* Направление связи: s | t | ?         */
                "sf-op-pay",                          /* Список кодов линков в CAN-DO формате */
                ";",                                  /* Разделитель результирующего списка   */
                ?).

  btrim = yes.
  btrim2 = yes.
      DO mI=1 TO NUM-ENTRIES(mSurrOp,";"):
               FOR EACH op WHERE 
                        op.op = INT64(ENTRY(1,ENTRY(mI,mSurrOp,";"),",")) 
                   NO-LOCK:

/*                 mDocNumDate = mDocNumDate + (if mI = 1 then '' else FILL(' ',mLengBody + mLs + LENGTH({&STR1}))) + '  ' + "№" 
                     + STRING(OP.doc-num,"x(10)") + "от" + " " + STRING(OP.op-date,"99/99/9999") + " " + '~n' .  
*/               

/*                   mDocNumDate = mDocNumDate + (if LENGTH(mDocNumDate) <> 0 and btrim1 then ', ' else ' ') + " №" + STRING(OP.doc-num /*,"x(10)" */) + " от" + " " + STRING(OP.op-date,"99/99/9999") . */

                   cPlatNumbers[1] = cPlatNumbers[1] + (if LENGTH(cPlatNumbers[1]) <> 0 and btrim1 then ', ' else ' ') + " №" + STRING(OP.doc-num /*,"x(10)" */) + " от" + " " + STRING(OP.op-date,"99/99/9999") . 


                   btrim1 = true.



/*		   if LENGTH(mDocNumDate) >= 160 and btrim then
		   do: 
		        mDocNumDate = mDocNumDate + '~n' + FILL(' ',mLengBody + mLs + LENGTH({&STR1}) + 1).
                        btrim = false.
			btrim1 = false.

		  end.	

		   if LENGTH(mDocNumDate) >= 320 and btrim2 then
		   do: 
		        mDocNumDate = mDocNumDate + '~n' + FILL(' ',mLengBody + mLs + LENGTH({&STR1}) + 1).
                        btrim2 = false.
			btrim1 = false.
		  end.*/



               END.
	end.


               	{wordwrap.i &s=cPlatNumbers &l=160 &n=10}
               	
              mDocNumDate = cPlatNumbers[1].
	do iCycle = 2 to 10:
		if cPlatNumbers[iCycle] ne "" then do:
				mDocNumDate = mDocNumDate + '~n' + FILL(' ',mLengBody + mLs + LENGTH({&STR1}) + 1)  + cPlatNumbers[iCycle].
		end.
	do iCycle = 1 to 10:
                 cPlatNumbers[iCycle] = "".
	end.


/*         mDocNumLine = "                               ────────────    ─────────────────────────────────".       */

      END.
	       mDocNumLine = "".
               mDocNumDate = mDocNumDate + '~n'.
   END.
   
   IF mDocNumDate EQ "" THEN
   DO:
      ASSIGN
         mDocNumDate = '-' + '~n'
         mDocNumLine = "                               ─────────────────────────────────────────────────"
         .
   END.   
   
   ASSIGN
      mSfBankRek = FGetSetting("СчФБанкРек",?,"")
      mSfPodrazd = FGetSetting("СчФПодраз",?,"")
      mBranchId = TRIM(GetXAttrValueEx("_user",loan.user-id,"Отделение",""))
   .

      /* Обработка НП "СчФБанкРек" */
   mBranch = ?.
   IF mSfBankRek EQ "Нет" THEN
      mBranch = mBranchId.
   ELSE IF mSfBankRek EQ ? THEN
   DO:
      RUN GetBranchParent_Type(INPUT mBranchId, INPUT "00", INPUT-OUTPUT mStrParentId).
      mBranch = mStrParentId.
   END.
   ELSE IF mSfBankRek EQ "Да"
       AND mSfPodrazd EQ "Да" 
   THEN
      IF loan.contract EQ "sf-out" THEN
         mSFSellerKPP  = GetXAttrValue("branch", mBranchId, "КПП").
      ELSE IF loan.contract EQ "sf-in" THEN
         mSFBuyerKPP  = GetXAttrValue("branch", mBranchId, "КПП").

   IF mBranch NE ? THEN 
      FIND FIRST branch WHERE 
                 branch.Branch-Id EQ mBranch
      NO-LOCK NO-ERROR.
   IF AVAIL branch THEN 
   DO:
      mBrShortName = branch.short-name.
      IF loan.contract EQ "sf-out" THEN
      DO:
         ASSIGN   
            mSFSeller =  branch.Name
            mSFSellerAddr = branch.Address
            mSFSellerINN = GetXAttrValue("branch",mBranch,"ИНН")
            mSFSellerKPP = GetXAttrValue("branch",mBranch,"КПП")
         .
      END.
      ELSE IF loan.contract EQ "sf-in" THEN
      DO:
         ASSIGN   
            mSFBuyer =  branch.Name
            mSFBuyerAddr = branch.address
            mSFBuyerINN = GetXAttrValue("branch",mBranch,"ИНН")
            mSFBuyerKPP = GetXAttrValue("branch",mBranch,"КПП")
         .
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
      mIsEmptyKol = false.
      mNameSrv = "".
      FIND FIRST bfrAsset WHERE
      			 bfrAsset.cont-type EQ term-obl.symbol
      			 AND
      			 bfrAsset.filial-id EQ loan.filial-id
      			 NO-LOCK NO-ERROR.
      IF AVAIL bfrAsset THEN DO:
        newBossFIO = TRIM(GetXAttrValueEx("asset", bfrAsset.filial-id + "," + bfrAsset.cont-type, "PIRsignSF", "")).
      	IF bossFIO <> "null" AND bossFIO <> newBossFIO THEN bossFIO = "".
      	IF bossFIO <> "" THEN bossFIO = newBossFIO.
      	if TRIM(GetXAttrValueEx("asset", bfrAsset.filial-id + "," + bfrAsset.cont-type, "PirCommentIsName", "")) = "ДА" then  mNameSrv = REPLACE(loan.comment,",01",""). 
        if TRIM(GetXAttrValueEx("asset", bfrAsset.filial-id + "," + bfrAsset.cont-type, "PirEmptyKol", "")) = "ДА" then  mIsEmptyKol = true.
        if TRIM(GetXAttrValueEx("asset", bfrAsset.filial-id + "," + bfrAsset.cont-type, "PirEmptyBuyer", "")) = "ДА" then 
            DO:
               mSfBuyer = "-".
	       mSfBuyerAddr = "-".

	    END.
      END. ELSE
      	bossFIO = "". 




      FIND FIRST currency WHERE currency.currency EQ loan.currency NO-LOCK NO-ERROR.
      if mNameSrv = "" then  
         mNameSrv = SFAssetName(term-obl.contract + "," +
                                term-obl.cont-code + "," + 
                                STRING(term-obl.idnt) + "," + 
                                STRING(term-obl.end-date) + "," +
                                STRING(term-obl.nn),
                                term-obl.symbol).
      ASSIGN 
         ttServ.NameServ = SplitStr(mNameSrv,30,'~n')
         ttServ.Edin = SFAssetUnit(term-obl.contract         + ","
                                 + term-obl.cont-code        + ","
                                 + STRING(term-obl.idnt)     + ","
                                 + STRING(term-obl.end-date) + ","
                                 + STRING(term-obl.nn), 
                                   term-obl.symbol)
         ttServ.EdinName = GetCodeNameEx("Unit",ttServ.Edin,"")
         ttServ.Edin     = SplitStr(ttServ.Edin,4,'~n')
         .
         if ttServ.Edin = "мес" then
		assign 
		      ttServ.Edin = "362"
                      ttServ.EdinName = "мес".
         if ttServ.Edin = "шт" then
		assign 
		      ttServ.Edin = "796"
                      ttServ.EdinName = "шт".
         if ttServ.Edin = "день" then
		assign 
		      ttServ.Edin = "359"
                      ttServ.EdinName = "сут;".
         if ttServ.Edin = "нед" then
		assign 
		      ttServ.Edin = "360"
                      ttServ.EdinName = "нед".

         if ttServ.Edin = "366" then
		assign 
		      ttServ.Edin = "366"
                      ttServ.EdinName = "г;".


        temp-amt-rub =  term-obl.amt-rub.
        temp-amt-rub-nds = term-obl.amt-rub - term-obl.int-amt.

        temp-ao = false.
      DO mI=1 TO NUM-ENTRIES(mSurrOp,";"):
        if (GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFInfo", "")) <> "" then do:               
      	 if Entry(2,(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFInfo", ""))) = 'а/о' /*если документ по авансовой оплате то смотрим */
	    then do:
		if DEC(GetXAttrValueEx("op", ENTRY(1,ENTRY(mI,mSurrOp,";")), "PIRSFAmount", "")) = temp-amt-rub then temp-amt-rub-nds = 0.
	    end. 
	      temp-ao = true.
          END.
         end.

         

      ASSIGN
         ttServ.Curr      = IF loan.currency EQ "" THEN "Российский рубль"
                                                   ELSE (IF AVAIL currency THEN currency.name-currenc
                                                                           ELSE "")
         ttServ.Quant     = term-obl.ratio     /* кол-во */
         ttServ.Price     = term-obl.price     /* цена */
         ttServ.Akciz     = term-obl.dsc-int-amt /* Акциз */
         ttServ.Nlog      = term-obl.rate        /* Ставка НДС */
         ttServ.NalogSumm = term-obl.int-amt     /* Сумма НДС */
         ttServ.TotalSumm = term-obl.amt-rub     /* Общая сумма */
         ttServ.SummOut   = temp-amt-rub-nds /*сумма без налога*/
         ttServ.GTDNum    = GetXattrValueEx("term-obl",
                                            term-obl.contract + "," + term-obl.cont-code
                                            + "," + STRING(term-obl.idnt) + "," 
                                            + STRING(term-obl.end-date) + "," 
                                            + STRING(term-obl.nn),
                                            "declare",
                                            "")   /* Номер ГТД */
        ttServ.contry = SFAssetCountryAttr(term-obl.contract         + "," 
                                         + term-obl.cont-code        + ","
                                         + STRING(term-obl.idnt)     + ","
                                         + STRING(term-obl.end-date) + ","
                                         + STRING(term-obl.nn), 
                                           term-obl.symbol,
                                           "country-alt-id") /* Страна */
         ttServ.ContryName = SFAssetCountryAttr(term-obl.contract         + "," 
                                         + term-obl.cont-code        + ","
                                         + STRING(term-obl.idnt)     + ","
                                         + STRING(term-obl.end-date) + ","
                                         + STRING(term-obl.nn), 
                                           term-obl.symbol,
                                           "country-name") /* Страна */  
         ttServ.ContryName = SplitStr(ttServ.ContryName,12,'~n') 
         .        
      RELEASE ttServ.
   END.

   /* делаем перевод страницы перед печатью счет-фактуры, кроме первой */
   
   IF mPage = 0 THEN mPage = 1.
   ELSE PAGE STREAM sfact.
    
   ASSIGN 
      mStrSellerAddr = mSFSellerAddr
      mStrBuyerAddr  = mSFBuyerAddr 
   .

   IF     mSchFStKl NE "?" 
      AND mSchFStKl NE " " 
   THEN 
      IF (loan.cust-cat EQ "Ю" 
         AND GetXAttrValueEx("cust-corp",STRING(loan.cust-id),"Предпр","") NE "" )
         OR (loan.cust-cat EQ "Ч" 
         AND GetXAttrValueEx("person",STRING(loan.cust-id),"Предпр","") NE "" )
      THEN
         IF loan.contract EQ "sf-in"
            AND NOT mSFSeller BEGINS mSchFStKl THEN
               mStrSeller[1] = mSchFStKl + " " + mSFSeller.
         ELSE
            IF loan.contract EQ "sf-out" 
               AND NOT mSFBuyer BEGINS mSchFStKl THEN
                  mStrBuyer[1] = mSchFStKl + " " + mSFBuyer.
   
   IF INDEX(mStrSeller[1],mSFSeller) EQ 0 THEN
      mStrSeller = mSFSeller.
   IF INDEX(mStrBuyer[1],mSFBuyer)   EQ 0 THEN
      mStrBuyer  = mSFBuyer.     

   /* Для определения как выводить Продавца, определим, есть ли ссылка на 
   ** договор класса axd-use-agent и в зависимости от этого выводим */
   FIND FIRST b-loan WHERE b-loan.cont-code EQ loan.parent-cont-code
                       AND b-loan.class     EQ "axd-use-agent"
                       AND b-loan.contract  EQ "АХД"
   NO-LOCK NO-ERROR.
   IF NOT AVAIL b-loan THEN
   DO:
      IF loan.contract EQ "sf-out" THEN
         mStrSeller[1] = mStrSeller[1] + " " + mBrShortName.
      ELSE
      IF loan.contract EQ "sf-in" THEN
      DO:
         IF CAN-DO("Ю,П",loan.cust-cat) THEN
         DO:
            FIND FIRST cust-corp WHERE cust-corp.cust-id EQ loan.cust-id NO-LOCK NO-ERROR.
            IF AVAIL cust-corp THEN
               mStrSeller[1] = cust-corp.name-corp + " " + cust-corp.name-short.
         END.
         IF loan.cust-cat EQ "Б" THEN
         DO:
            FIND FIRST banks WHERE banks.bank-id EQ loan.cust-id NO-LOCK NO-ERROR.
            IF AVAIL banks THEN
               mStrSeller[1] = banks.name + " " + banks.short-name.
         END.
      END.
   END.

   IF loan.cust-cat EQ "Ю" THEN
   DO:
      FIND FIRST cust-corp WHERE cust-corp.cust-id EQ loan.cust-id NO-LOCK NO-ERROR.
      IF AVAIL cust-corp THEN
         ASSIGN
            mNameGO  = GetXAttrValueEx("cust-corp",
                                       STRING(cust-corp.cust-id),
                                       "NameGO",
                                       "")
            mAdresGO = GetXAttrValueEx("cust-corp",
                                       STRING(cust-corp.cust-id),
                                       "AdresGO",
                                       "")
         .
   END.



   IF     {assigned mNameGO}
      AND {assigned mAdresGO} THEN
   DO:
      IF loan.contract EQ "sf-in" THEN
         ASSIGN
            mStrSeller     = mNameGO
            mStrSellerAddr = mAdresGO
         .
      ELSE
         ASSIGN
            mStrBuyer     = mNameGO
            mStrBuyerAddr = mAdresGO
         .
   END.
   
   IF    loan.cont-type EQ "а/о"
      OR loan.cont-type EQ "а/п"
      OR NOT mSFTovar THEN
      ASSIGN
         mStrOtprav     = '-'
         mStrPoluch     = '-'
      .
   ELSE
   DO:
      IF     mSfBankRek EQ "Нет"
         AND mSfPodrazd EQ "Нет" 
      THEN
         ASSIGN
            mStrOtprav     = ""  
            mStrPoluch     = "" 
         .
      ELSE
      DO:
         IF     mSchFStKl NE "?" 
            AND mSchFStKl NE " " 
         THEN 
            IF (loan.cust-cat EQ "Ю" 
               AND GetXAttrValueEx("cust-corp",STRING(loan.cust-id),"Предпр","") NE "" )
               OR (loan.cust-cat EQ "Ч" 
               AND GetXAttrValueEx("person",STRING(loan.cust-id),"Предпр","") NE "" )
            THEN
               IF loan.contract EQ "sf-in" 
                  AND NOT mSFOtprav BEGINS mSchFStKl THEN
                     mStrOtprav[1] = mSchFStKl + " " + mSFOtprav + " " + mSFOtpravAddr.
               ELSE
                  IF loan.contract EQ "sf-out"
                     AND NOT mSFPoluch BEGINS mSchFStKl THEN
                     mStrPoluch[1] = (IF mSFPoluch NE "-" THEN mSchFStKl ELSE "") + " " + 
                                      mSFPoluch + " " + mSFPoluchAddr.


           
         IF INDEX(mStrOtprav[1],mSFOtprav) EQ 0 THEN
            mStrOtprav = mSFOtprav + " " + mSFOtpravAddr.
         IF INDEX(mStrPoluch[1],mSFPoluch) EQ 0 THEN
            mStrPoluch = mSFPoluch + " " + mSFPoluchAddr.     
      END.
   END.

if CAN-DO("СВОД ПО*",mStrSeller[1]) then
do:
 mStrSeller[1] = cBankName.
end.



 if CAN-DO("СВОД ПО*",mStrBuyer[1]) then
do:
 mStrBuyer[1] = cBankName.
end.


if TRIM(REPLACE(mSFSellerINN,"0","")) = "" then mSFSellerINN = "".
if TRIM(REPLACE(mSFBuyerKPP,"0","")) = "" then mSFBuyerKPP = "".

if TRIM(REPLACE(mSFBuyerINN,"0",""))  = "" then mSFBuyerINN = "".
if TRIM(REPLACE(mSFBuyerKPP,"0",""))  = "" then mSFBuyerKPP = "".

mStrBuyer[1] = REPLACE(mStrBuyer[1],"Индивидуальный предприниматель ИП","ИП").

 

   {pir-sf-print_2.i}

   /*печатаем*/
   {empty ttServ}

END.
{preview.i &STREAM="STREAM sfact" &FILENAME = "'_spool_sf.tmp'"}

{intrface.del}
