/****************************************
 * Отчет выводит информацию по клиентам
 * Д6. 
 ****************************************
 * Автор : Маслов Д. А.
 * Заявка: #2807
 * Дата  : 05.04.13
 *****************************************/

 {globals.i}
 {ulib.i}

 {intrface.get tmess}


 DEF BUFFER acct FOR acct.

 DEF VAR dBegDate AS DATE NO-UNDO.
 DEF VAR dEndDate AS DATE NO-UNDO.

 DEF VAR i        AS INT     NO-UNDO.

 def var temp as log no-undo.   

 DEF VAR oClient  AS TClient NO-UNDO.
 DEF VAR oTable   AS TTable2 NO-UNDO.
 DEF VAR oTpl     AS TTpl    NO-UNDO.

 DEF VAR oLoan    AS TLoan   NO-UNDO.
 DEF VAR oRates   AS TAArray NO-UNDO.
 DEF VAR oAArray  AS TAArray NO-UNDO.

 DEF VAR vLnCountInt AS INT INIT 1 NO-UNDO. /* Счетчик договоров */
 DEF VAR vLnTotalInt AS INT INIT 1 NO-UNDO. /* Общее количество договоров */

 DEF VAR NewMetodCode AS CHAR NO-UNDO.

 DEF VAR mResOperu      AS DEC INIT 0 NO-UNDO.
 DEF VAR mResKID        AS DEC INIT 0 NO-UNDO. 
 DEF VAR mResVal        AS DEC INIT 0 NO-UNDO.
 DEF VAR mResNal        AS DEC INIT 0 NO-UNDO.
 DEF VAR mDpsSum        AS DEC INIT 0 NO-UNDO.  
 DEF VAR mCashSum       AS DEC INIT 0 NO-UNDO.

 DEF VAR mResOperu2      AS DEC INIT 0 NO-UNDO.
 DEF VAR mResKID2        AS DEC INIT 0 NO-UNDO.
 DEF VAR mDpsSum2        AS DEC INIT 0 NO-UNDO.


 DEF VAR mResOperu2Total AS DEC INIT 0 NO-UNDO.
 DEF VAR mResKID2Total   AS DEC INIT 0 NO-UNDO.
 DEF VAR mResVal2Total   AS DEC INIT 0 NO-UNDO.
 DEF VAR mResNalTotal    AS DEC INIT 0 NO-UNDO.
 DEF VAR mDpsSum2Total   AS DEC INIT 0 NO-UNDO.
 DEF VAR mCashSumTotal   AS DEC INIT 0 NO-UNDO.

 DEF VAR mResOperuTotal AS DEC INIT 0 NO-UNDO.
 DEF VAR mResKIDTotal   AS DEC INIT 0 NO-UNDO.
 DEF VAR mResValTotal   AS DEC INIT 0 NO-UNDO.
 DEF VAR mDpsSumTotal   AS DEC INIT 0 NO-UNDO.

 DEF VAR cDpsLst         AS CHAR       NO-UNDO.


 DEF VAR mMdlPercent     AS DEC        NO-UNDO.
 DEF VAR mCurrDepPercent AS DEC        NO-UNDO.
 DEF VAR dCom            AS DEC INIT 0 NO-UNDO.
 DEF VAR dSum1           AS DEC INIT 0 NO-UNDO.
 DEF VAR dSum2           AS DEC INIT 0 NO-UNDO.
 DEF VAR dP              AS DEC INIT 0 NO-UNDO.

 DEF VAR key1            AS CHAR       NO-UNDO.
 DEF VAR val1            AS CHAR       NO-UNDO.

 DEF VAR mKID         AS DEC INIT 0    NO-UNDO.
 DEF VAR mKID840      AS DEC INIT 0    NO-UNDO.
 DEF VAR mKID978      AS DEC INIT 0    NO-UNDO.

 DEF VAR mKUSD        AS DEC           NO-UNDO.
 DEF VAR mKEUR        AS DEC           NO-UNDO.

 DEF VAR DA           AS DEC           NO-UNDO.
 DEF VAR DA2          AS DEC           NO-UNDO.

 DEF VAR showZero     AS LOG INIT TRUE NO-UNDO.
 DEF VAR iNum         AS INT INIT 0    NO-UNDO.
 DEF VAR currYear     AS DEC INIT 0    NO-UNDO.

 DEF VAR currGain    AS TAArray NO-UNDO.
 DEF VAR currGainNlg AS TAArray NO-UNDO.
 DEF VAR NewMetod AS LOG INIT FALSE NO-UNDO.



 DEF VAR oSysClass   AS TSysClass NO-UNDO.

 /****
  * ПЕРЕМЕННЫЕ ПОДВЕДЕНИЯ ИТОГОВ
  ****/

  DEF VAR kKID AS DEC INIT 0.03 NO-UNDO.
  DEF VAR kDps AS DEC INIT 0.25 NO-UNDO.
  DEF VAR kVal AS DEC INIT 0.25 NO-UNDO.
  DEF VAR kRKO AS DEC INIT 0.25 NO-UNDO.
  DEF VAR kNal AS DEC INIT 0.25 NO-UNDO.

  DEF VAR vAkr    AS DEC                     NO-UNDO.
  DEF VAR vAd     AS DEC                     NO-UNDO.
  DEF VAR vVal    AS DEC                     NO-UNDO.
  DEF VAR vARKO   AS DEC                     NO-UNDO.
  DEF VAR vAnal   AS DEC                     NO-UNDO.

  DEF VAR vTotal      AS DEC                 NO-UNDO.
  DEF VAR vTotalWPrev AS DEC                 NO-UNDO.

  DEF VAR vSb     AS DEC                     NO-UNDO.
  DEF VAR H1      AS DEC                     NO-UNDO.
  DEF VAR H2      AS DEC                     NO-UNDO.
  DEF VAR H3      AS DEC                     NO-UNDO.

  DEF VAR vCurrKPack   AS CHAR               NO-UNDO.
  DEF VAR vFindMask    AS CHAR               NO-UNDO.
  DEF VAR currTemplate AS CHAR               NO-UNDO.

  DEF VAR vTotalPrev      AS DEC INIT 0      NO-UNDO.
  DEF VAR vTotalPrevNlg   AS DEC INIT 0      NO-UNDO.
  DEF VAR vSumMdlPoint    AS DEC INIT 721928 NO-UNDO.

  DEF VAR baseByOpEntry   AS TAArray         NO-UNDO.

  DEF VAR dBaseNorm AS DEC NO-UNDO.
  DEF var dBaseNormNeg as DEC NO-UNDO.
  DEF VAR dNewNalogPoint AS DEC INIT 739536  NO-UNDO.

  DEF BUFFER bcode for code.
  DEF BUFFER bcode2 for code.

/**/

/**/

  FUNCTION CalcPrevTotal RETURNS LOG:
      def var tempChar as char no-undo.

      for each bcode2 where bcode2.class  = "PirStd6"	
                        and bcode2.parent = vFindMask
                            NO-LOCK
                        BY bcode2.code.

          TempChar = ENTRY(4,bcode2.code,"/")  + "/" + ENTRY(3,bcode2.code,"/")  + "/" + ENTRY(2,bcode2.code,"/").
          
          IF date(TempChar) <= dBegDate THEN
          ASSIGN 
           vTotalPrev = vTotalPrev + DEC(TRIM(bcode2.name))
           vTotalPrevNlg = vTotalPrevNlg + DEC(TRIM(bcode2.val))
           dBaseNormNeg = DEC(TRIM(bcode2.description[1])).	

      END.



  END FUNCTION.


/**/



    /*********
   * Кредитные операции по типу №2
   *********/
  FUNCTION calcKid2 RETURNS DEC(
                                    INPUT iClient  AS HANDLE,
                                    INPUT iK       AS DEC,
                                    INPUT iKUSD    AS DEC,
                                    INPUT iKEUR    AS DEC,
                                    INPUT iBegDate AS DATE,
                                    INPUT iEndDate AS DATE
                                   ):

     DEF VAR vClient       AS TClient        NO-UNDO.
     DEF VAR vAcct         AS TAcct          NO-UNDO.
     DEF VAR vPos          AS DEC     INIT 0 NO-UNDO.
     DEF VAR vDiff         AS DEC     INIT 0 NO-UNDO.
     DEF VAR vDelta        AS DEC     INIT 0 NO-UNDO.
     DEF VAR vPosIntervals AS TAArray        NO-UNDO.

     DEF VAR key1          AS CHAR           NO-UNDO.
     DEF VAR val1          AS CHAR           NO-UNDO.

     DEF BUFFER acct FOR acct.

     vClient = NEW TClient(iClient).
       FOR EACH acct WHERE acct.cust-cat = vClient:cust-cat AND acct.cust-id = vClient:PK 
                       AND acct.acct BEGINS "45" NO-LOCK:
          vDelta = 0.

          vAcct = NEW TAcct(acct.acct).
               vPosIntervals = vAcct:getStableIntervals(iBegDate,iEndDate).
            
               {foreach vPosIntervals key1 val1}
                   ASSIGN
                     vDiff = DATE(ENTRY(2,key1,"-")) - DATE(ENTRY(1,key1,"-"))
                     vPos  = vPos + DEC(val1) * vDiff / 365   
/*                       vPos  = vPos + DEC(val1) * vDiff / (dEndDate - dBegDate) */
                   .
               {endforeach vPosIntervals}

          DELETE OBJECT vAcct.


    CASE acct.currency:
      WHEN "840" THEN DO:
             vPos = vPos + vDelta * iKUSD.       
      END.
      WHEN "978" THEN DO:
             vPos = vPos + vDelta * iKEUR.       
      END.     
      OTHERWISE DO:
             vPos = vPos + vDelta.
      END.
    END CASE.

       END.
     DELETE OBJECT vClient.     

    RETURN vPos.
  END FUNCTION.

  /*********
   * Депозитные операции по типу №2
   *********/

  FUNCTION calcDps2 RETURNS DEC(
                                    INPUT iClient  AS HANDLE,
                                    INPUT iK       AS DEC,
                                    INPUT iKUSD    AS DEC,
                                    INPUT iKEUR    AS DEC,
                                    INPUT iBegDate AS DATE,
                                    INPUT iEndDate AS DATE
                                   ):

     DEF VAR vClient AS TClient        NO-UNDO.
     DEF VAR vAcct   AS TAcct          NO-UNDO.
     DEF VAR vPos    AS DEC    INIT 0  NO-UNDO.

     DEF VAR vDiff         AS DEC     INIT 0 NO-UNDO.
     DEF VAR vDelta        AS DEC     INIT 0 NO-UNDO.
     DEF VAR vPosIntervals AS TAArray        NO-UNDO.

     DEF VAR key1          AS CHAR           NO-UNDO.
     DEF VAR val1          AS CHAR           NO-UNDO.

     DEF BUFFER acct FOR acct.


     vClient = NEW TClient(iClient).

       FOR EACH acct WHERE acct.cust-cat = vClient:cust-cat AND acct.cust-id = vClient:PK 
                       AND (acct.acct BEGINS "42"  AND NOT acct.acct BEGINS "42301") NO-LOCK:

          vDelta = 0.


          vAcct = NEW TAcct(acct.acct).
               vPosIntervals = vAcct:getStableIntervals(iBegDate,iEndDate).



                 {foreach vPosIntervals key1 val1}

                     
                       vDiff  = DATE(ENTRY(2,key1,"-")) - DATE(ENTRY(1,key1,"-")).
                      vDelta = vDelta + ROUND(DEC(val1) * vDiff / 365,2).  
  /*                       vDelta = vDelta + ROUND(DEC(val1) * vDiff / (dEndDate - dBegDate),2).  */
                       
                 {endforeach vPosIntervals}
 
    CASE acct.currency:
      WHEN "840" THEN DO:
             vPos = vPos + vDelta * iKUSD.       
      END.
      WHEN "978" THEN DO:
             vPos = vPos + vDelta * iKEUR.       
      END.     
      OTHERWISE DO:
             vPos = vPos + vDelta.
      END.
    END CASE.

          DELETE OBJECT vAcct.


    END. /* For each */
     DELETE OBJECT vClient.     


    RETURN vPos.
  END FUNCTION.

  /*********
   * Операции оперу по типу №2
   *********/
  FUNCTION calcOperu2 RETURNS DEC(
                                    INPUT iClient  AS HANDLE,
                                    INPUT iK       AS DEC,
                                    INPUT iKUSD    AS DEC,
                                    INPUT iKEUR    AS DEC,
                                    INPUT iBegDate AS DATE,
                                    INPUT iEndDate AS DATE
                                   ):

     DEF VAR vClient AS TClient        NO-UNDO.
     DEF VAR vAcct   AS TAcct          NO-UNDO.
     DEF VAR vPos    AS DEC     INIT 0 NO-UNDO.

     DEF VAR vDiff         AS DEC     INIT 0 NO-UNDO.
     DEF VAR vPosIntervals AS TAArray        NO-UNDO.

     DEF VAR key1          AS CHAR           NO-UNDO.
     DEF VAR val1          AS CHAR           NO-UNDO.
     DEF VAR vDelta        AS DEC  INIT 0    NO-UNDO.

     DEF BUFFER acct FOR acct.

     vClient = NEW TClient(iClient).
       FOR EACH acct WHERE acct.cust-cat = vClient:cust-cat AND acct.cust-id = vClient:PK 
                       AND (acct.acct BEGINS "42301" OR CAN-DO("Текущ,Расчет",acct.contract)) NO-LOCK:
          vDelta = 0.

          vAcct = NEW TAcct(acct.acct).
               vPosIntervals = vAcct:getStableIntervals(iBegDate,iEndDate).
                 {foreach vPosIntervals key1 val1}
                     ASSIGN
                       vDiff    = DATE(ENTRY(2,key1,"-")) - DATE(ENTRY(1,key1,"-"))                                     
                       vDelta     = vDelta +  DEC(val1) * vDiff / 365
                     .
                     .
                 {endforeach vPosIntervals}

          DELETE OBJECT vAcct.


    CASE acct.currency:
      WHEN "840" THEN DO:
             vPos = vPos + vDelta * iKUSD.       
      END.
      WHEN "978" THEN DO:
             vPos = vPos + vDelta * iKEUR.       
      END.     
      OTHERWISE DO:
             vPos = vPos + vDelta.
      END.
    END CASE.

       END.
     DELETE OBJECT vClient.     


    RETURN vPos.
  END FUNCTION.

  FUNCTION CalcTakeCash RETURNS DEC (INPUT iClient AS HANDLE,INPUT iBegDate AS DATE,INPUT iEndDate AS DATE):
           DEF VAR vCust-cat    AS CHAR  NO-UNDO.
           DEF VAR vPK          AS INT64 NO-UNDO.
           DEF VAR vBaseGetNal  AS DEC INIT 0 NO-UNDO.

              CASE iClient:NAME:
          WHEN "person" THEN DO:
             ASSIGN
              vCust-cat = "Ч"
              vPK       = iClient::person-id
             .
          END.
          WHEN "cust-corp" THEN DO:
             ASSIGN
              vCust-cat  = "Ю"
              vPK        = iClient::cust-id
             .
          END.
       END CASE.

   FOR EACH acct WHERE acct.cust-cat = vCust-cat AND acct.cust-id = vPK 
                   AND acct.open-date <= iEndDate AND (acct.close-date > iBegDate OR acct.close-date = ?) 
                   AND acct.acct BEGINS "40"
                    NO-LOCK:

                  FOR EACH op-entry WHERE op-entry.acct-db = acct.acct AND op-entry.acct-cr BEGINS "202" 
                                      AND iBegDate<=op-entry.op-date AND op-entry.op-date <=iEndDate AND op-entry.op-date <> ? NO-LOCK:
                      vBaseGetNal = vBaseGetNal + op-entry.amt-rub.
                  END.

   END.

   RETURN vBaseGetNal.

  END FUNCTION.
/**/



  /*****
   * Функция просчитывает операционные доходы
   * клиента
   ******/
  FUNCTION calcByOpEntry RETURNS TAArray(INPUT iClient AS HANDLE,INPUT iBegDate AS DATE,INPUT iEndDate AS DATE):
       DEF VAR vCust-cat    AS CHAR  NO-UNDO.
       DEF VAR vPK          AS INT64 NO-UNDO.
       DEF VAR vResNal      AS DEC INIT 0 NO-UNDO.
       DEF VAR vBaseNal     AS DEC INIT 0 NO-UNDO.
       DEF VAR vResOperu    AS DEC INIT 0 NO-UNDO.
       DEF VAR vResKID      AS DEC INIT 0 NO-UNDO.
       DEF VAR vResVal      AS DEC INIT 0 NO-UNDO.
       DEF VAR vRes         AS TAArray    NO-UNDO.


       DEF VAR vAcctLst     AS CHAR INIT "70601810000001111504,70601810000001111601,70601810100001111501,70601810100001111802,70601810200001111401,70601810200001111702,70601810300001111602,70601810400001111201,
70601810400001111502,70601810400001140201,70601810500001111703,70601810700001111202,70601810700001111503,70601810700001140202,70601810800001111704,70601810800001111801,70601810900001111701,
70601810600001111302,70601810500001111101,70601810800001111102,---,70601810100001111103,70601810600001111205,70601810900001111303,70601810800001111403,70601810300001111505,70601810600001111506,70601810600001111603,70601810100001111706,
70601810400001111803,70601810000001140203" NO-UNDO.

       DEF VAR vAcctValLst AS CHAR INIT "70601810500001220102" NO-UNDO. /* Счет доходов купли/продажи валюты */

       DEF VAR vAcctNalLst AS CHAR INIT "70601810600001210203,70601810000001210201" NO-UNDO.

       DEF BUFFER acct  FOR acct.
       DEF BUFFER signs FOR signs.
       
       CASE iClient:NAME:
          WHEN "person" THEN DO:
             ASSIGN
              vCust-cat = "Ч"
              vPK       = iClient::person-id
             .
          END.
          WHEN "cust-corp" THEN DO:
             ASSIGN
              vCust-cat  = "Ю"
              vPK        = iClient::cust-id
             .
          END.
       END CASE.

   FOR EACH acct WHERE acct.cust-cat = vCust-cat AND acct.cust-id = vPK 
                   AND acct.open-date <= iEndDate AND (acct.close-date > iBegDate OR acct.close-date = ?) 
                   AND acct.acct BEGINS "40"
                    NO-LOCK:


                  FOR EACH op-entry WHERE op-entry.acct-db = acct.acct AND op-entry.acct-cr BEGINS "7" NO-LOCK,
                           FIRST op WHERE op.op = op-entry.op AND CAN-DO("!Курс*,!Нуль,!Сальдо,*",op.op-kind) 
                                      AND iBegDate<=op-entry.op-date AND op-entry.op-date <=iEndDate AND op-entry.op-date <> ? NO-LOCK:



                         IF CAN-DO(vAcctLst,op-entry.acct-cr) THEN DO:
                              vResKID = vResKID + op-entry.amt-rub.
                              NEXT.
                         END.

                         IF CAN-DO(vAcctNalLst,op-entry.acct-cr) THEN DO:
                              vResNal = vResNal + op-entry.amt-rub.
                              NEXT.
                         END.


                         IF CAN-DO(vAcctLst,op-entry.acct-cr) THEN DO:
                              vResKID = vResKID + op-entry.amt-rub.
                              NEXT.
                         END.


                            vResOperu = vResOperu + op-entry.amt-rub.


                 END.


   END.

   vRes = NEW TAArray().

   vRes:setH("ResOperu",vResOperu).
   vRes:setH("ResVal",vResVal).
   vRes:setH("ResKID",vResKID).
   vRes:setH("ResNal",vResNal).


   RETURN vRes.

  END FUNCTION.


  FUNCTION calcByLoans RETURNS DECIMAL (
                                       INPUT iClient AS HANDLE,
                                       INPUT iBegDate AS DATE,
                                       INPUT iEndDate AS DATE,
                                       INPUT iKID     AS DEC,
                                       INPUT iKID840  AS DEC,
                                       INPUT iKID978  AS DEC
                                       ):

      DEF VAR oClient         AS TClient NO-UNDO.
      DEF VAR vCurrDepPercent AS DEC     NO-UNDO.
      DEF VAR vDpsLst         AS CHAR    NO-UNDO.
      DEF VAR vDpsSum         AS DEC     NO-UNDO.

      DEF VAR vCust-cat  AS CHAR  NO-UNDO.
      DEF VAR vPK        AS INT64 NO-UNDO.
    
      DEF VAR vClient    AS TClient NO-UNDO.
      DEF VAR oAcct    AS TAcct   NO-UNDO.

      DEF BUFFER loan FOR loan.

      vClient = NEW TClient(iClient).

       /*********************************************************
        *       ПРОСЧИТЫВАЕМ ДОХОДЫ ПО ЧАСТНЫМ ВКЛАДАМ          *
        *********************************************************/

       /**
        * Частные вклады
        **/

       FOR EACH loan WHERE loan.contract   = "dps"
                       AND loan.cust-cat   = vClient:cust-cat 
                       AND loan.cust-id    = vClient:PK
                       AND loan.cont-type BEGINS "Сроч"
                       AND loan.open-date <=  iEndDate AND (loan.close-date > iBegDate OR loan.close-date = ?) NO-LOCK:
        

         oLoan = NEW TLoan(loan.contract,loan.cont-code).
         oAcct   = oLoan:getAcct(oLoan:getMainRole(),iEndDate).

         vCurrDepPercent = getDpsRateComm(oLoan:HANDLE,iEndDate,TRUE) / 100.

         /**
          * Бывают случаи когда ставка не определена
          **/
         vCurrDepPercent = IF vCurrDepPercent = ? THEN 0 ELSE vCurrDepPercent.

         CASE oLoan:currency:
             WHEN "" THEN DO:
                vCurrDepPercent = iKID - vCurrDepPercent.
             END.
             WHEN "840" THEN DO:
                vCurrDepPercent = iKID840 - vCurrDepPercent.
             END.
             WHEN "978" THEN DO:
                vCurrDepPercent = iKID978 - vCurrDepPercent.
             END.
         END CASE.

         vDpsLst = vDpsLst + loan.cont-code + "/" + STRING(vCurrDepPercent * 100) + ", ".
         vDpsSum = vDpsSum + oAcct:calcPercent(iBegDate,iEndDate,vCurrDepPercent,TRUE).
         DELETE OBJECT oAcct.
         DELETE OBJECT oLoan.
       END.
         vDpsLst = TRIM(vDpsLst,", ").

       /**
        * Депозиты юр.лиц
        **/
       FOR EACH loan WHERE loan.contract   = "Депоз"
                       AND loan.cust-cat   = vClient:cust-cat 
                       AND loan.cust-id    = vClient:PK
                       AND NOT loan.class-code BEGINS "pir_"
                       AND loan.open-date <=  dEndDate AND (loan.close-date > dBegDate OR loan.close-date = ?) NO-LOCK:
        

         oLoan = NEW TLoan(loan.contract,loan.cont-code).
         oAcct   = oLoan:getAcct(oLoan:getMainRole(),dEndDate).

         oRates  = oLoan:getCommisionValue(dEndDate).
         mCurrDepPercent = DEC(TRIM(oRates:get("%Деп"),"%")) / 100 .

         vDpsLst = vDpsLst + loan.cont-code + "/" + STRING(mCurrDepPercent) + ",".
          

         vDpsSum = vDpsSum + oAcct:calcPercent(dBegDate,dEndDate,mCurrDepPercent,TRUE).

         DELETE OBJECT oRates.
         DELETE OBJECT oAcct.
         DELETE OBJECT oLoan.
       END.
        vDpsLst = TRIM(vDpsLst,", ").

       /*********************************************************
        *       КОНЕЦ ДОХОДОВ ПО ЧАСТНЫМ ВКЛАДАМ                *
        *********************************************************/
       DELETE OBJECT vClient.
      RETURN vDpsSum.
  END FUNCTION.



  /****
   * Выбираем по кому будем строить отчет
   ****/
  DO TRANSACTION:
    RUN browseld.p ("code",
                    "class"   + CHR(1) + "parent",
                    "PirStd6" + CHR(1) + "PirStd6",
                    "",
                    1).


    IF KEYFUNCTION(LASTKEY) = "END-ERROR" OR pick-value = ? THEN RETURN.

    vFindMask = pick-value.

    FIND FIRST code WHERE code.class  = "PirStd6" 
                      AND code.parent = "PirStd6" 
                      AND code.code   = vFindMask NO-LOCK.



    ASSIGN
      vFindMask    = code.code
      vCurrKPack   = code.name
      currTemplate = code.val
      currGain     = TAArray:loadJSON2(code.description[1])
      currGainNlg  = TAArray:loadJSON2(code.description[2])
    .

   if NUM-ENTRIES(vCurrKPack) >=4 then 
 	   ASSIGN
	    kKID  = DEC(ENTRY(1,vCurrKPack)) / 100
	    kDPS  = DEC(ENTRY(2,vCurrKPack)) / 100  
	    kVal  = DEC(ENTRY(3,vCurrKPack)) / 100
	    kRKO  = DEC(ENTRY(4,vCurrKPack)) / 100
	    NewMetod = false
	   .   
   else
	ASSIGN       
           NewMetod = true
           NewMetodCode = vCurrKPack.
  
  END.

{getdates.i}

 ASSIGN
    dBegDate = beg-date
    dEndDate = end-date
    currYear = YEAR(dBegDate)
 .

  oSysClass = NEW TSysClass().
     mKUSD = oSysClass:getCbrKurs(840,dEndDate).
     mKEUR = oSysClass:getCbrKurs(978,dEndDate).
  DELETE OBJECT oSysClass.

 

 oTpl = NEW TTpl(currTemplate).

 oTable = NEW TTable2(). 
 if NOT NewMetod THEN 
    DO:
	 oTable:addRow()
	       :addCell(1)
	       :addCell(2)
	       :addCell(3)
	       :addCell(4)
	       :addCell(5)
	       :addCell(6)
	       :addCell(7)
	 .
	 oTable:setPropertyByStr("colsHideList","0,0,0," + (IF kDPS > 0 THEN "0" ELSE "1") + "," +  "," + (IF kRKO > 0 THEN "0" ELSE "1") + (IF kKid > 0 THEN "0" ELSE "1") + (IF kVal > 0 THEN "0" ELSE "1") + ",1").
    END.
 ELSE
 DO:
	 oTable:addRow()
	       :addCell(1)
	       :addCell(2)
	       :addCell(3)
	       :addCell(4)
	       :addCell(5)
	       :addCell(6)
	       :addCell(7)
	       :addCell(8)
	 .
        /* oTable:setPropertyByStr("colsHideList","0,0,0," + (IF kDPS > 0 THEN "0" ELSE "1") + "," +  "," + (IF kRKO > 0 THEN "0" ELSE "1") + (IF kKid > 0 THEN "0" ELSE "1") + (IF kVal > 0 THEN "0" ELSE "1")).*/
 END.
  MESSAGE "Подавлять нулевые?" VIEW-AS ALERT-BOX BUTTONS YES-NO SET showZero.
  showZero = NOT showZero.



 /*************************************
  *  ПРОСЧИТЫВАЕМ ДОХОДЫ ПО КРЕДИТАМ  *
  *************************************/
  oAArray = TLoan:getMdlPercent2("%Кред",dBegDate,dEndDate).
     mKID    = ROUND(DEC(oAArray:get("sum%")) / DEC(oAArray:get("sum")),4).
     mKid840 = ROUND(DEC(oAArray:get("sum%840")) / DEC(oAArray:get("sum840")),4).
     mKid978 = ROUND(DEC(oAArray:get("sum%978")) / DEC(oAArray:get("sum978")),4).
  DELETE OBJECT oAArray.


 /******************************************
  * ПРОСЧИТЫВАЕМ КОЛИЧЕСТВО ДЛЯ ГРАДУСНИКА *
  ******************************************/

  /* ДЛЯ ФИЗИКОВ */
    FOR EACH signs WHERE signs.file-name = "person" AND signs.code  = "Статистика" AND CAN-DO(vFindMask,signs.code-value) NO-LOCK,
     FIRST person WHERE person.person-id = INT64(signs.surrogate) NO-LOCK,
      FIRST acct WHERE acct.cust-cat = "Ч" AND acct.cust-id = person.person-id AND acct.open-date <= dEndDate AND (acct.close-date > dBegDate OR acct.close-date = ?) NO-LOCK:

          vLnTotalInt = vLnTotalInt + 1.
  END.


  /* ДЛЯ ЮРИКОВ */
    FOR EACH signs WHERE signs.file-name = "cust-corp" AND signs.code  = "Статистика" AND CAN-DO(vFindMask,signs.code-value) NO-LOCK,
     FIRST cust-corp WHERE cust-corp.cust-id = INT64(signs.surrogate) NO-LOCK,
      FIRST acct WHERE acct.cust-cat = "Ю" AND acct.cust-id = cust-corp.cust-id AND acct.open-date <= dEndDate AND (acct.close-date > dBegDate OR acct.close-date = ?) NO-LOCK:

          vLnTotalInt = vLnTotalInt + 1.
  END.

 /*******************************************
  *     КОНЕЦ РАССЧЕТА ДЛЯ ГРАДУСНИКА       *
  *******************************************/




 /******************************************
  *     НАЧИНАЕМ ОБРАБОТКУ КЛИЕНТОВ        *
  ******************************************/


 /******** ПРОСЧИТЫВАЕМ ФИЗЮКОВ ************/

 {init-bar.i "Обработка клиентов"}

  FOR EACH signs WHERE signs.file-name = "person" AND signs.code = "Статистика" AND CAN-DO(vFindMask,signs.code-value) NO-LOCK,
    FIRST person WHERE person.person-id = INT64(signs.surrogate) NO-LOCK:


    ASSIGN
       mResOperu   = 0
       mResKID     = 0
       mResVal     = 0
       mDpsSum     = 0

       mResNal     = 0
       mResOperu2  = 0
       mResKID2    = 0
       mDpsSum2    = 0
     .

      oClient = NEW TClient(BUFFER person:HANDLE).



     baseByOpEntry = calcByOpEntry(BUFFER person:HANDLE,dBegDate,dEndDate).
        ASSIGN
          mResOperu = DECIMAL(baseByOpEntry:get("ResOperu"))
          mResKID   = DECIMAL(baseByOpEntry:get("ResKID"))
          mResVal   = DECIMAL(baseByOpEntry:get("ResVal"))
        .

          mResNal   = DECIMAL(baseByOpEntry:get("ResNal")). 


      DELETE OBJECT baseByOpEntry.

      IF NewMetod THEN 
       ASSIGN
          mResKID2   = calcKID2(BUFFER person:HANDLE,1,mkUSD,mKEUR,dBegDate,dEndDate)
          mResOperu2 = calcOperu2(BUFFER person:HANDLE,1,mkUSD,mKEUR,dBegDate,dEndDate)
          mDpsSum2   = calcDps2(BUFFER person:HANDLE,1,mkUSD,mKEUR,dBegDate,dEndDate).
      else
          mDpsSum = calcByLoans(BUFFER person:HANDLE,dBegDate,dEndDate,1,mKID840,mKID978).


          mCashSum = CalcTakeCash(BUFFER person:HANDLE,dBegDate,dEndDate).

      IF NOT NewMetod and (showZero OR mDpsSum > 0 OR mResOperu > 0 OR mResKID > 0 OR mResVal > 0) THEN DO:

         iNum = iNum + 1.
  
         oTable:addRow()
               :addCell(iNum)
               :addCell(oClient:name-short)
               :addCell(oClient:date-in)
               :addCell(STRING(mDpsSum,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResOperu,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResKID,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResVal,">>>,>>>,>>>,>>9.99"))
         .
	
      END.
      ELSE 
          DO.

         iNum = iNum + 1.
  
         oTable:addRow()
               :addCell(iNum)
               :addCell(oClient:name-short)
               :addCell(oClient:date-in)
               :addCell(STRING(mDpsSum2,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResOperu2,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResKID2,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResVal,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResNal,">>>,>>>,>>>,>>9.99"))

         .

      END.



      ASSIGN
        mResOperuTotal = mResOperuTotal  + mResOperu
        mDpsSumTotal   = mDpsSumTotal    + IF mDpsSum = ? THEN 0 ELSE mDpsSum
        mResKIDTotal   = mResKIDTotal    + mResKID
        mResValTotal   = mResValTotal    + mResVal

        mDpsSum2Total   = mDpsSum2Total    + IF mDpsSum2 = ? THEN 0 ELSE mDpsSum2
        mResKID2Total   = mResKID2Total    + mResKID2
        mResValTotal   = mResValTotal    + mResVal
        mResOperu2Total = mResOperu2Total + mResOperu2
        mResNalTotal    = mResNalTotal    + mResNal
        mCashSumTotal   = mCashSumTotal   + mCashSum

      .

      {move-bar.i vLnCountInt vLnTotalInt}

      vLnCountInt = vLnCountInt + 1.
    
      DELETE OBJECT oClient.


 END.

  FOR EACH signs WHERE signs.file-name = "cust-corp" AND signs.code = "Статистика" AND CAN-DO(vFindMask,signs.code-value) NO-LOCK,
    FIRST cust-corp WHERE cust-corp.cust-id = INT64(signs.surrogate) NO-LOCK:


    ASSIGN
       mResOperu  = 0
       mResKID    = 0
       mResVal    = 0
       mDpsSum    = 0
     .

      oClient = NEW TClient(BUFFER cust-corp:HANDLE).



     baseByOpEntry = calcByOpEntry(BUFFER cust-corp:HANDLE,dBegDate,dEndDate).
      if NOT NewMetod then 
        ASSIGN
          mResOperu = DECIMAL(baseByOpEntry:get("ResOperu"))
          mResKID   = DECIMAL(baseByOpEntry:get("ResKID"))
          mResVal   = DECIMAL(baseByOpEntry:get("ResVal"))
        .
          mResNal   = DECIMAL(baseByOpEntry:get("ResNal")). 


      if NewMetod then 
        ASSIGN
          mResKID2   = calcKID2(BUFFER cust-corp:HANDLE,kKID,mkUSD,mKEUR,dBegDate,dEndDate)
          mResOperu2 = calcOperu2(BUFFER cust-corp:HANDLE,kRKO,mkUSD,mKEUR,dBegDate,dEndDate)
          mDpsSum2   = calcDps2(BUFFER cust-corp:HANDLE,kDPS,mkUSD,mKEUR,dBegDate,dEndDate).
      ELSE
          mDpsSum = calcByLoans(BUFFER cust-corp:HANDLE,dBegDate,dEndDate,mKID,mKID840,mKID978).



      DELETE OBJECT baseByOpEntry.

          mCashSum = CalcTakeCash(BUFFER cust-corp:HANDLE,dBegDate,dEndDate).


    IF NOT NewMetod and (showZero OR mDpsSum > 0 OR mResOperu > 0 OR mResKID > 0 OR mResVal > 0) THEN DO:

         iNum = iNum + 1.
  
         oTable:addRow()
               :addCell(iNum)
               :addCell(oClient:name-short)
               :addCell(oClient:date-in)
               :addCell(STRING(mDpsSum,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResOperu,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResKID,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResVal,">>>,>>>,>>>,>>9.99"))
         .
	
      END.
      ELSE 
          DO.

         iNum = iNum + 1.
  
         oTable:addRow()
               :addCell(iNum)
               :addCell(oClient:name-short)
               :addCell(oClient:date-in)
               :addCell(STRING(mDpsSum2,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResOperu2,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResKID2,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResVal,">>>,>>>,>>>,>>9.99"))
               :addCell(STRING(mResNal,">>>,>>>,>>>,>>9.99"))

         .

      END.


                  ASSIGN
        mResOperuTotal = mResOperuTotal  + mResOperu
        mDpsSumTotal   = mDpsSumTotal    + IF mDpsSum = ? THEN 0 ELSE mDpsSum
        mResKIDTotal   = mResKIDTotal    + mResKID
        mResValTotal   = mResValTotal    + mResVal

        mDpsSum2Total   = mDpsSum2Total    + IF mDpsSum2 = ? THEN 0 ELSE mDpsSum2
        mResKID2Total   = mResKID2Total    + mResKID2
        mResValTotal    = mResValTotal    + mResVal
        mResOperu2Total = mResOperu2Total + mResOperu2
        mResNalTotal    = mResNalTotal    + mResNal
        mCashSumTotal   = mCashSumTotal   + mCashSum
      .

      {move-bar.i vLnCountInt vLnTotalInt}

      vLnCountInt = vLnCountInt + 1.
    
      DELETE OBJECT oClient.


 END.
 if NOT NewMetod then 
 oTable:addRow()
       :addCell("Итого:")
       :addCell("")
       :addCell("")
       :addCell(STRING(mDpsSumTotal,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResOperuTotal,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResKIDTotal,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResValTotal,">>>,>>>,>>>,>>9.99"))
 .
 ELSE
 oTable:addRow()
       :addCell("Итого:")
       :addCell("")
       :addCell("")
       :addCell(STRING(mDpsSum2Total,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResOperu2Total,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResKID2Total,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResVal2Total,">>>,>>>,>>>,>>9.99"))
       :addCell(STRING(mResNalTotal,">>>,>>>,>>>,>>9.99"))
 .




 oTpl:addAnchorValue("TABLE",oTable).
 oTpl:addAnchorValue("YEAR",{term2str dBegDate dEndDate}).

 oTpl:addAnchorValue("K810",STRING(mKID * 100,">>>,>>>,>>>,>>9.99")).
 oTpl:addAnchorValue("K840",STRING(mKID840 * 100,">>>,>>>,>>>,>>9.99")).
 oTpl:addAnchorValue("K978",STRING(mKID978 * 100,">>>,>>>,>>>,>>9.99")).




 /*
 {foreach currGain key1 val1}
    IF YEAR(DATE(key1)) = currYear AND DATE(key1) <  dBegDate THEN DO: 
       vTotalPrev = vTotalPrev + DEC(val1).
    END.
 {endforeach currGain}

 {foreach currGainNlg key1 val1}
    IF YEAR(DATE(key1)) = currYear AND DATE(key1) <  dBegDate THEN DO: 
       vTotalPrevNlg = vTotalPrevNlg + DEC(val1).
    END.
 {endforeach currGainNlg}
*/
        temp = CalcPrevTotal().

 if NOT NewMetod then DO:
	 ASSIGN
	   vAkr         = ROUND(mResKIDTotal * kKID,2)
	   vAd          = ROUND(mDpsSumTotal * kDPS,2)
	   vVal         = ROUND(mResValTotal * kVal,2)
	   vARKO        = ROUND(mResOperuTotal    * kRKO,2)
	   vTotal       = vAkr + vAd + vVal + vARKO
	   vTotalWPrev  = vTotalPrev + vTotal           /* Учитываем доход за предыдующие периоды */
	   vSb          = (IF kDPS > 0 THEN mDpsSumTotal ELSE 0) + (IF kRKO > 0 THEN mResOperuTotal ELSE 0) + (IF kKID > 0 THEN mResKIDTotal ELSE 0) + (IF kVal > 0 THEN mResValTotal ELSE 0)
	   H1           = (IF vTotalWPrev > vSumMdlPoint THEN vSumMdlPoint ELSE vTotalWPrev) * 0.271 / 1.271
	   H2           = (IF vTotalWPrev > vSumMdlPoint THEN vTotalWPrev - vSumMdlPoint ELSE 0) * 0.1 / 1.10
	   H3           = (vTotalWPrev - H1 - H2) * 0.13
	   DA           = vTotalWPrev - (H1 + H2)
	   DA2          = DA - vTotalPrevNlg
	 .


	 oTpl:addAnchorValue("S1",STRING(vSb,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S2",STRING(vAkr,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S3",STRING(vAd,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S4",STRING(vVal,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S5",STRING(vARKO,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S6",STRING(vTotal,">>>,>>>,>>>,>>9.99")).

	 oTpl:addAnchorValue("kDPS",STRING(kDPS * 100,">9.99")).
	 oTpl:addAnchorValue("kRKO",STRING(kRKO * 100,">9.99")).
	 oTpl:addAnchorValue("kKID",STRING(kKID * 100,">9.99")).
	 oTpl:addAnchorValue("kVal",STRING(kVal * 100,">9.99")).

	 oTpl:addAnchorValue("DA",STRING(DA,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("DA2",STRING(DA2,">>>,>>>,>>>,>>9.99")).

	 oTpl:addAnchorValue("H1",STRING(H1,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("H2",STRING(H2,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("H3",STRING(H3,"->>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("WHOM",vFindMask).

 END.
 ELSE 
      DO:
  
DEF VAR PrevMax as DECIMAL NO-UNDO.
DEF VAR PrevBV as DECIMAL NO-UNDO.
DEF VAR CurrBV as DECIMAL NO-UNDO.
DEF VAR PrevK  AS CHAR NO-UNDO.
DEF VAR PrevResNalTotal as DEC NO-UNDO.






         PrevResNalTotal = mResNalTotal.


         if mCashSumTotal <= 10000000 then 
         DO:
            mResNalTotal = 0.
            oTpl:addAnchorValue("snal", "Сумма снятия наличных = " + TRIM(STRING(mCashSumTotal,">>>,>>>,>>>,>>9.99")) + CHR(10)).

         END.
            oTpl:addAnchorValue("snal","").
         
 
          /*считаем базу выплат за месяц*/
         FOR EACH bcode WHERE bcode.class  = vCurrKPack 
                           AND bcode.parent = vCurrKPack 
                           NO-LOCK.

             CurrBV = mDpsSum2Total   * DEC(ENTRY(1,bcode.description[1])) / 100 +
  		      mResOperu2Total * DEC(ENTRY(4,bcode.description[1])) / 100 +
                      mResKID2Total   * DEC(ENTRY(2,bcode.description[1])) / 100 + 
                      mResVal2Total   * DEC(ENTRY(3,bcode.description[1])) / 100 +
                      mResNalTotal    * DEC(ENTRY(5,bcode.description[1])) / 100.

             IF PrevMax < CurrBV then 
              DO:

                 IF CAN-DO("<,<=",bcode.val) then 
                    DO:
                       IF CurrBV <= DEC(bcode.name) then 
                        DO:
                          PrevBV    = CurrBv.
                          PrevMax   = DEC(bcode.name).
                          PrevK     = bcode.description[1].
                          dBaseNorm = dec(TRIM(bcode.description[2])).
                          
                        END.
                     END.
                 IF CAN-DO(">,>=",bcode.val) then 
                    DO:
                       IF CurrBV <= DEC(bcode.name) then 
                        DO:
                          PrevBV    = CurrBv.
                          PrevMax   = DEC(bcode.name).
                          PrevK     = bcode.description[1].
                          dBaseNorm = dec(TRIM(bcode.description[2])).
                          
                        END.
                    END.
                                     
              END.      
         END.                        


      


             
        kDPS   =      DEC(ENTRY(1,PrevK))  / 100. 
  	kKID   =      DEC(ENTRY(2,PrevK))  / 100. 
        kVal   =      DEC(ENTRY(3,PrevK))  / 100. 
        kRKO   =      DEC(ENTRY(4,PrevK))  / 100. 
        kNal   =      DEC(ENTRY(5,PrevK))  / 100.


         


	 ASSIGN
	   vAkr         = ROUND(mResKID2Total * kKID,2)
	   vAd          = ROUND(mDpsSum2Total * kDPS,2)
	   vVal         = ROUND(mResVal2Total * kVal,2)
	   vARKO        = ROUND(mResOperu2Total    * kRKO,2)
	   vANal        = ROUND(mResNalTotal    * kNal,2)
	   vTotal       = (IF PrevBV > dBaseNorm THEN vAkr + vAd + vVal + vARKO + vANal - dBaseNormNeg ELSE dBaseNorm)
	   vTotalWPrev  = vTotalPrev + vTotal           /* Учитываем доход за предыдующие периоды */
	   vSb          = PrevBV
	   H1           = (IF vTotalWPrev > dNewNalogPoint THEN dNewNalogPoint ELSE vTotalWPrev) * 0.302 / 1.302
	   H2           = (IF vTotalWPrev > dNewNalogPoint THEN vTotalWPrev - dNewNalogPoint ELSE 0) * 0.1 / 1.10
	   H3           = (vTotalWPrev - H1 - H2) * 0.13
	   DA           = vTotalWPrev - (H1 + H2)
	   DA2          = DA - vTotalPrevNlg 
	 .


	 oTpl:addAnchorValue("minNorm",STRING(dBaseNorm,">>>,>>>,>>>,>>9.99")).

	 oTpl:addAnchorValue("S1",STRING(PrevBV,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S2",STRING(vAkr,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S3",STRING(vAd,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S4",STRING(vVal,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S5",STRING(vARKO,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S6",STRING(vTotal,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S7",STRING(vAnal,">>>,>>>,>>>,>>9.99")).


	 oTpl:addAnchorValue("S10",STRING(vTotalPrev,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("S11",STRING(vTotalPrevNlg,">>>,>>>,>>>,>>9.99")).


	 oTpl:addAnchorValue("kDPS",STRING(kDPS * 100,">9.99")).
	 oTpl:addAnchorValue("kRKO",STRING(kRKO * 100,">9.99")).
	 oTpl:addAnchorValue("kKID",STRING(kKID * 100,">9.99")).
	 oTpl:addAnchorValue("kVal",STRING(kVal * 100,">9.99")).
	 oTpl:addAnchorValue("kNal",STRING(kNal * 100,">9.99")).

	 oTpl:addAnchorValue("DA",STRING(DA,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("DA2",STRING(DA2,">>>,>>>,>>>,>>9.99")).

	 oTpl:addAnchorValue("H1",STRING(H1,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("H2",STRING(H2,">>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("H3",STRING(H3,"->>>,>>>,>>>,>>9.99")).
	 oTpl:addAnchorValue("WHOM",vFindMask).
                                                                


                                          



      END.






 {tpl.show}


DELETE OBJECT oTable.
{tpl.delete}

	/***********************************
	 * Будем сохранять уже выплаченную *
	 * агенту прибыль.                 *
	 ***********************************
	 * Заявка: #3173                   *
	 * Дата  : 26.06.13                *
	 * Автор : Маслов Д. А.            *
	 ************************************/

	  RUN Fill-SysMes IN h_tmess ("","",3,"Будем фиксировать доход агента?|Зафиксировать,Пропустить").




	  IF pick-value = "1" THEN
          DO:

	/*	 IF Not NewMetod then
		  DO:

	
		    RUN VALUE(TSysClass:whatShouldIRun2("getper2")) ("Месяц",OUTPUT dBegDate,OUTPUT dEndDate).

		    currGain:setH("01/" + STRING(MONTH(dBegDate)) + "/" + STRING(YEAR(dBegDate)),vTotal).
		    currGainNlg:setH("01/" + STRING(MONTH(dBegDate)) + "/" + STRING(YEAR(dBegDate)),DA).


		    FIND CURRENT code EXCLUSIVE-LOCK.
    	
		    code.description[1] = STRING(currGain:toJSON2()).
		    code.description[2] = STRING(currGainNlg:toJSON2()).

		   END.
		 ELSE 
                  DO:    */
                     find first bcode2 where bcode2.parent = vFindMask
                                         and bcode2.class = "PirStd6"
                                         and bcode2.code = vFindMask + "/" + ENTRY(3,STRING(dBegDate,"99/99/9999"),"/") + "/" + ENTRY(2,STRING(dBegDate,"99/99/9999"),"/") + "/" + ENTRY(1,STRING(dBegDate,"99/99/9999"),"/")
                                         NO-ERROR.

                     IF NOT AVAILABLE bcode2 then Create bcode2.
                        ASSIGN
                              bcode2.parent = vFindMask
                              bcode2.class  = "PirStd6"
                              bcode2.code   = vFindMask + "/" + ENTRY(3,STRING(dBegDate,"99/99/9999"),"/") + "/" + ENTRY(2,STRING(dBegDate,"99/99/9999"),"/") + "/" + ENTRY(1,STRING(dBegDate,"99/99/9999"),"/")
                              bcode2.name   = STRING(DA)
                              bcode2.val    = String(DA2) 
                              .
                     

           /*       END.   */

	  END.    /* IF pick-value = "1" THEN */
 ELSE
  DO:
       /*храним предыдуший доход по новому, в дальнейшем всех агентов будет переводить на хранение в этой структуре */




  END.


 DELETE OBJECT currGain.
 DELETE OBJECT currGainNlg.

 {intrface.del}


