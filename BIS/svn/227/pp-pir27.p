
/*------------------------------------------------------------------------
    File        : pp-pir27.p
    Purpose     : 

    Syntax      :

    Description : ┴шсышюЄхър ЇєэъЎшщ фы  ЁрёўхЄр ёЄюшьюёЄш яю 227-╘╟

    Author(s)   : dmaslov
    Created     : Wed Jul 25 12:06:31 MSD 2012
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */



/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
/**
 * Заполняет доп. информацию по операции покупки валюты (безнал.).
 */
 {globals.i}
 {intrface.get xclass}
 {intrface.get comm}
 {ulib.i}
 
DEF VAR oOper10Count AS TAArray NO-UNDO.

PROCEDURE initProc:
    oOper10Count = NEW TAArray("0").
END PROCEDURE.
PROCEDURE delProc:
    DELETE OBJECT oOper10Count.
END PROCEDURE.

FUNCTION getOper10Info RETURNS TAArray():
  RETURN oOper10Count.
END FUNCTION.


/**
 * Конечно это функция должна работать по классификатору,
 * но пока увы нет.
 **/
FUNCTION getPeriod1 RETURNS CHAR(INPUT dDuration AS INT):
  IF dDuration < 366 THEN RETURN "0-1y".
  IF dDuration >= 366 AND dDuration <= 1830 THEN RETURN "1y-5y".
  IF dDuration >1830 THEN RETURN "5y-998y". 
END FUNCTION.

FUNCTION getPeriod2 RETURNS CHAR(
                                 INPUT cTypeOper AS CHAR,
                                 INPUT cVal      AS CHAR,
                                 INPUT dDuration AS INT
                                ):
  CASE cVal:
       WHEN "840" THEN DO:
         IF cTypeOper = "М" THEN DO:
            IF dDuration <= 370 THEN RETURN "0-1y".
            IF dDuration  > 370 THEN RETURN "1y-998y".
         END.

         IF cTypeOper = "К" THEN DO:
            IF dDuration <= 370 THEN RETURN "0-1y".
            IF dDuration >  370 THEN RETURN "1y-998y".
         END.

         IF cTypeOper = "КС" THEN DO:
            IF dDuration <= 275 THEN RETURN "0-0.75y".
            IF dDuration >  275 THEN RETURN "0.75y-998y".
         END.
       END.

      WHEN "978" THEN DO:
           IF dDuration <= 275 THEN RETURN "0-0.75y".
           IF dDuration  > 275 THEN RETURN "0.75y-998y".
      END.

      WHEN "" THEN DO:
           IF cTypeOper = "М" THEN DO:
                IF dDuration <= 275 THEN RETURN "0-0.75y".
                IF dDuration >  275 THEN RETURN "0.75y-998y".
           END. 

           IF cTypeOper = "К" THEN DO:
                IF dDuration <= 275 THEN RETURN "0-0.75y".
                IF dDuration >  275 THEN RETURN "0.75y-998y".
           END.

           IF cTypeOper = "КС" THEN RETURN "0-998y".

      END.
  END CASE.
END FUNCTION.

FUNCTION getPeriod3 RETURNS CHAR(INPUT iDuration AS INT):

  IF iDuration > 91 AND iDuration <= 95 THEN RETURN "0-0.25y".
  IF iDuration > 95 AND iDuration <= 185 THEN RETURN "0.25y-0.5y".
  IF iDuration >185 AND iDuration <= 275 THEN RETURN "0.5y-1y". 
  IF iDuration >275 AND iDuration <= 370 THEN RETURN "1y-5y". 
  IF iDuration >370 THEN RETURN "5y-998y". 

END FUNCTION.

FUNCTION getSumType RETURNS CHAR(INPUT dVal  AS CHAR,
                                 INPUT dType AS CHAR,
                                 INPUT dSum  AS DEC
                                ):

     CASE dVal:
       WHEN "840" THEN DO:
          CASE dType:
                WHEN "М" THEN DO:
                  IF dSum < 99999   THEN RETURN "1".
                  IF dSum >= 100000 THEN RETURN "2".
                END.
                WHEN "К" THEN DO:
                  IF dSum < 99999   THEN RETURN "1".
                  IF dSum >= 100000 THEN RETURN "2".
                END.
                WHEN "КС" THEN DO:
                  IF dSum < 1000000  THEN RETURN "1".
                  IF dSum >= 1000000 THEN RETURN "2".
                END.
          END CASE.
       END.
       WHEN "978" THEN DO:
           IF dSum <= 100000 THEN RETURN "1".
           IF dSum >  100000 THEN RETURN "2".
       END.
      WHEN "" THEN DO:
               CASE dType:
                WHEN "М" THEN DO:
                  IF dSum < 15000000   THEN RETURN "1".
                  IF dSum >= 15000000 THEN RETURN "2".
                END.
                WHEN "К" THEN DO:
                  IF dSum < 15000000   THEN RETURN "1".
                  IF dSum >= 15000000 THEN RETURN "2".
                END.
                WHEN "КС" THEN DO:
                  RETURN "1".
                END.
          END.
      END.
     END CASE.


END FUNCTION.




FUNCTION fillExtInfo01 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
 DEF VAR oKross  AS TKross  NO-UNDO.
 DEF VAR dSum    AS DECIMAL NO-UNDO. 
 DEF VAR oClient AS TClient NO-UNDO.

 FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
 IF op-entry.acct-db BEGINS "4" AND op-entry.acct-cr BEGINS "4" THEN DO:
            oClient = NEW TClient(op-entry.acct-cr).
            oKross = NEW TKross(BUFFER op-entry:HANDLE).
              oParam:setH('tyo',oParam:get('tyo') + "|" + op-entry.currency).
              oParam:setH('acct-db',op-entry.acct-db).
              oParam:setH('acct-cr',op-entry.acct-cr).
              oParam:setH('amt-rub',op-entry.amt-rub).
              oParam:setH('amt-cur',op-entry.amt-cur).
              oParam:setH('amt-fact',oKross:factKurs).
              oParam:setH('activeKursCb',oKross:activeKursCB).
              oParam:setH('middle',oKross:middleKurs).
              oParam:setH('subtyo',oKross:getSubType()).
              oParam:setH('fprice',oKross:getSubType()).
              oParam:setH('kurs-fact',oKross:factKurs).
              dSum = (oKross:middleKurs - oKross:factKurs) / oKross:middleKurs.
              oParam:setH('cprice',ROUND(dSum,3)).
              oParam:setH('name-short',oClient:name-short).
            DELETE OBJECT oKross.
            DELETE OBJECT oClient.
         END.
       END.
END FUNCTION.

/**
 * Заполняет доп. информацию по операции покупки валюты (безнал.).
 */
FUNCTION fillExtInfo02 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
    DEF VAR oKross AS TKross  NO-UNDO.
    DEF VAR dSum   AS DECIMAL NO-UNDO.
    DEF VAR oClient AS TClient NO-UNDO.
    
     FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
         IF op-entry.acct-db BEGINS "4" AND op-entry.acct-cr BEGINS "4" THEN DO:
            oKross = NEW TKross(BUFFER op-entry:HANDLE).
            oClient = NEW TClient(op-entry.acct-db).
              oParam:setH('tyo',oParam:get('tyo') + "|" + op-entry.currency).
              oParam:setH('acct-db',op-entry.acct-db).
              oParam:setH('acct-cr',op-entry.acct-cr).
              oParam:setH('amt-rub',op-entry.amt-rub).
              oParam:setH('amt-cur',op-entry.amt-cur).
              oParam:setH('amt-calc',oKross:activeKurs).
              oParam:setH('amt-fact',oKross:factKurs).
              oParam:setH('middle',oKross:middleKurs).
              oParam:setH('activeKursCb',oKross:activeKursCB).
              oParam:setH('subtyo',oKross:getSubType()).
              oParam:setH('fprice',oKross:getSubType()).
              oParam:setH('kurs-fact',oKross:factKurs).
              oParam:setH('name-short',oClient:name-short).
              dSum = (oKross:factKurs - oKross:middleKurs) / oKross:middleKurs.
              oParam:setH('cprice',ABS(dSum)).
            DELETE OBJECT oKross.
            DELETE OBJECT oClient.
          END.
     END.
END FUNCTION.

FUNCTION fillExtInfo03-2 RETURN  LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):

    DEF VAR oKross  AS TKross1 NO-UNDO.
    DEF VAR dSum    AS DEC     NO-UNDO.
    DEF VAR oClient AS TClient NO-UNDO.

    DEF VAR acct-db   AS CHAR      NO-UNDO.
    DEF VAR acct-cr   AS CHAR      NO-UNDO.
    DEF VAR dSumDb    AS DEC       NO-UNDO.
    DEF VAR dSumCr    AS DEC       NO-UNDO.
    DEF VAR oSysClass AS TSysClass NO-UNDO.
    DEF VAR val-buy   AS INT       NO-UNDO.
    DEF VAR val-sell  AS INT       NO-UNDO.

    DEF VAR k-buy   AS DEC       NO-UNDO.
    DEF VAR k-sell  AS DEC       NO-UNDO.
    DEF VAR k       AS DEC       NO-UNDO.
    DEF VAR d       AS DEC       NO-UNDO.
 
     oSysClass = NEW TSysClass().
    
     FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:

         IF op-entry.acct-db BEGINS "4" AND op-entry.acct-cr EQ ? THEN DO:
              acct-db = op-entry.acct-db.
              val-buy = INT(SUBSTRING(acct-db,6,3)).
              dSumDb  = op-entry.amt-cur.

              oParam:setH('amt-buy',op-entry.amt-cur).
              k-buy = oSysClass:getCBRKurs(val-buy,currDate).
              oParam:setH('val-buy',val-buy).
              oParam:setH('k-buy',k-buy).

              oClient = NEW TClient(op-entry.acct-db).
                    oParam:setH('name-short',oClient:name-short).
              DELETE OBJECT oClient.

         END.

         IF op-entry.acct-db EQ ? AND op-entry.acct-cr BEGINS "4" THEN DO:
              val-sell = INT(SUBSTRING(op-entry.acct-cr,6,3)).
              oParam:setH('amt-sell',op-entry.amt-cur).
              k-sell = oSysClass:getCBRKurs(val-sell,currDate).
              oParam:setH('k-sell',k-sell).
              oParam:setH('val-sell',val-sell).
              acct-cr = op-entry.acct-cr.
              dSumCr  = op-entry.amt-cur.
         END.        
     END.  


    oParam:setH('tyo',oParam:get('tyo') + "|" + STRING(val-buy) + "|" + STRING(val-sell)).

    k = dSumCr / dSumDb.

    d = ROUND((k-buy - k * k-sell) / (k * k-sell + k-buy),3).
    oParam:setH('fprice',d).
    oParam:setH('cprice',d).


    DELETE OBJECT oSysClass.
END FUNCTION.

/**
 * Рассчитывает стоимость операции по кредиту.
 **/
FUNCTION fillExtInfo04 RETURN  LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):

  DEF VAR dSum      AS DEC        NO-UNDO.  
  DEF VAR oLoan     AS TLoan      NO-UNDO.
  DEF VAR oRes      AS TAArray    NO-UNDO.
  DEF VAR loanOwner AS TClient    NO-UNDO.
  DEF VAR p%        AS DEC INIT 0 NO-UNDO.
  DEF VAR duration  AS INT        NO-UNDO.

  DEF VAR dBegDate  AS DATE       NO-UNDO.
  DEF VAR dEndDate  AS DATE       NO-UNDO.

  DEF BUFFER ttLoan-int FOR loan-int.
  DEF BUFFER bOp FOR op.
  DEF BUFFER bOpEntry FOR op-entry.


  dBegDate = DATE(oParam:get("dBegDate")).
  dEndDate = DATE(oParam:get("dEndDate")).
  /**
   * Не очень корректно, так как, наверное,
   * можно гасить через кассу.
   **/
  FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
              oLoan = TLoan:initByDoc(hOp,FALSE).
                                                                 

              IF oLoan <> ? THEN DO:
                oRes      = oLoan:getCommisionValue(currDate).
                loanOwner = oLoan:getOwner().
                duration  = oLoan:end-date - oLoan:open-date.                  

                 oParam:setH('tyo',oParam:get('tyo') + "|" + oLoan:currency + "|" + oLoan:cust-cat + "|" + getPeriod1(duration)).
                 oParam:setH('acct-db',op-entry.acct-db).
                 oParam:setH('acct-cr',op-entry.acct-cr).
                 oParam:setH('amt-rub',op-entry.amt-rub).
                 oParam:setH('amt-cur',op-entry.amt-cur).
                 oParam:setH('amt-calc',oLoan:currency).
                 oParam:setH('amt-fact',1).
                 oParam:setH('cust-cat',oLoan:cust-cat).
                 oParam:setH('middle',1).
                 oParam:setH('activeKursCb',1).
                 oParam:setH('subtyo',1).

                 oParam:setH('fprice',TRIM(oRes:get('%Кред'),'%')).
                 oParam:setH('cprice',TRIM(oRes:get('%Кред'),'%')). 
                 oParam:setH('name-short',loanOwner:name-short).
                 oParam:setH('cont-code',oLoan:cont-code).
                 oParam:setH('open-date',oLoan:open-date).
                 oParam:setH('loan-pos',oLoan:getParamRoot(0,currDate) + oLoan:getParamRoot(7,currDate)).
                 oParam:setH('percent',op-entry.amt-rub).
                 
/*
                 FOR EACH ttLoan-int WHERE ttLoan-int.contract=oLoan:contract AND ttLoan-int.cont-code EQ ENTRY(1,oLoan:cont-code," ")
                                       AND ttLoan-int.id-d = 5 AND ttLoan-int.id-k = 6 AND dBegDate <= ttLoan-int.mdate AND ttLoan-int.mdate <= dEndDate NO-LOCK:
                   FIND FIRST bOp WHERE bOp.op EQ ttLoan-int.op NO-LOCK.
                   FIND FIRST bOpEntry OF bOp NO-LOCK.

                   p% = p% + bOpEntry.amt-rub.
                 END.

                 FOR EACH ttLoan-int WHERE ttLoan-int.contract=oLoan:contract AND ttLoan-int.cont-code EQ ENTRY(1,oLoan:cont-code," ")
                                       AND ttLoan-int.id-d = 33 AND ttLoan-int.id-k = 32 AND dBegDate <= ttLoan-int.mdate AND ttLoan-int.mdate <= dEndDate NO-LOCK:
                   FIND FIRST bOp WHERE bOp.op EQ ttLoan-int.op NO-LOCK.
                   FIND FIRST bOpEntry OF bOp NO-LOCK.

                   p% = p% + bOpEntry.amt-rub.
                 END.

               oParam:setH('percent',p%).
*/
               DELETE OBJECT oRes NO-ERROR.
             END.
            DELETE OBJECT oLoan     NO-ERROR.
            DELETE OBJECT loanOwner NO-ERROR.
  END.
  
END FUNCTION.

FUNCTION fillExtInfo05 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):

  DEF VAR dSum  AS DECIMAL            NO-UNDO.
  DEF VAR oLoan AS TLoan              NO-UNDO.
  DEF VAR kredAcct AS TAcct           NO-UNDO.

  DEF VAR loanOwner AS TClient        NO-UNDO.
  DEF VAR oRes      AS TAArray        NO-UNDO.
  DEF VAR p%        AS DEC     INIT 0 NO-UNDO.
  DEF VAR duration  AS INT            NO-UNDO.

  DEF VAR dBegDate  AS DATE           NO-UNDO.
  DEF VAR dEndDate  AS DATE           NO-UNDO.

  DEF BUFFER ttLoan-int FOR loan-int.
  DEF BUFFER bOp        FOR op.
  DEF BUFFER bOpEntry        FOR op-entry.
  
       oLoan = TLoan:initByDoc(hOp,FALSE).

      IF oLoan <> ? THEN DO:
               duration  =  oLoan:end-date - oLoan:open-date.
               loanOwner = oLoan:getOwner().
               kredAcct  = NEW TAcct(oLoan:getAcctByDateRole("Кредит",currDate)).
               oRes      = oLoan:getCommisionValue(currDate).

              oParam:setH('tyo',oParam:get('tyo') + "|" + oLoan:currency + "|" + oLoan:cust-cat + "|" + getPeriod1(duration)).
              oParam:setH('name-short',loanOwner:name-short).
              oParam:setH('cont-code',oLoan:doc-ref).
              oParam:setH('open-date',oLoan:open-date).
              oParam:setH('loan-pos',oLoan:getParam(0,currDate - 1)).
              oParam:setH('fprice',TRIM(oRes:get('%Кред'),'%')).
              oParam:setH('cprice',TRIM(oRes:get('%Кред'),'%')).

              dBegDate = DATE(oParam:get("dBegDate")).
              dEndDate = DATE(oParam:get("dEndDate")).

              FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
                 oParam:setH('acct-db',op-entry.acct-db).
                 oParam:setH('acct-cr',op-entry.acct-cr).
                 oParam:setH('amt-rub',op-entry.amt-rub).
                 oParam:setH('amt-cur',op-entry.amt-cur).
                 oParam:setH('cust-cat',oLoan:cust-cat).
                 oParam:setH('subtyo',1).
                 oParam:setH('percent',op-entry.amt-rub).
              END. 
/*
                 FOR EACH ttLoan-int WHERE ttLoan-int.contract=oLoan:contract AND ttLoan-int.cont-code EQ oLoan:cont-code
                                       AND ttLoan-int.id-d = 5 AND ttLoan-int.id-k = 6 AND dBegDate <= ttLoan-int.mdate AND ttLoan-int.mdate <= dEndDate NO-LOCK:
                   FIND FIRST bOp WHERE bOp.op EQ ttLoan-int.op NO-LOCK.
                   FIND FIRST bOpEntry OF bOp NO-LOCK.

                   p% = p% + bOpEntry.amt-rub.
                 END.

                 FOR EACH ttLoan-int WHERE ttLoan-int.contract=oLoan:contract AND ttLoan-int.cont-code EQ oLoan:cont-code
                                       AND ttLoan-int.id-d = 33 AND ttLoan-int.id-k = 32 AND dBegDate <= ttLoan-int.mdate AND ttLoan-int.mdate <= dEndDate NO-LOCK:
                   FIND FIRST bOp WHERE bOp.op EQ ttLoan-int.op NO-LOCK.
                   FIND FIRST bOpEntry OF bOp NO-LOCK.

                   p% = p% + bOpEntry.amt-rub.
                 END.
                 oParam:setH('percent',p%).
*/



              DELETE OBJECT oLoan     NO-ERROR.
              DELETE OBJECT oRes      NO-ERROR.
              DELETE OBJECT loanOwner NO-ERROR.
              DELETE OBJECT kredAcct  NO-ERROR.
  END.

END FUNCTION.

FUNCTION fillExtInfo06 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
    DEF VAR oLoan       AS TLoan     NO-UNDO.
    DEF VAR loanOwner   AS TClient   NO-UNDO.
    DEF VAR oAcct       AS TAcct     NO-UNDO.     
    DEF VAR trMask      AS CHAR      NO-UNDO.     
    DEF VAR oSysClass   AS TSysClass NO-UNDO.
    DEF VAR nach%       AS DEC       NO-UNDO.
    DEF VAR ref%        AS DEC       NO-UNDO.
    DEF VAR duration    AS INT       NO-UNDO.
    DEF VAR cTypePeriod AS CHAR      NO-UNDO.

    DEF VAR dBegDate    AS DATE      NO-UNDO.
    DEF VAR dEndDate    AS DATE      NO-UNDO.

    DEF VAR oldMarket   AS DEC       NO-UNDO.

    dEndDate = DATE(oParam:get("dEndDate")).

    DEF BUFFER loan-cond FOR loan-cond.


    oSysClass = NEW TSysClass().
    oLoan = TLoan:initDeposByDoc(hOp).

    loanOwner = oLoan:getOwner().
 
    oParam:setH('name-short',loanOwner:name-short).




   IF oLoan <> ? THEN DO:
    /**
     * По заявке #2893 в расчет попадают договора:
     *  1. Открытые в рассчитываем период;
     *  2. Договора по взаимозависимым лицам;
     **/
    IF CAN-DO("Срочн*",oLoan:cont-type) AND ( (DATE(oParam:get("dBegDate"))<=oLoan:open-date AND oLoan:open-date<=DATE(oParam:get("dEndDate")) OR LOGICAL(oParam:get("isLnk"))) ) THEN DO:
            duration = oLoan:end-date - oLoan:open-date.

            oParam:setH("open-date",oLoan:open-date).

            FIND LAST loan-cond WHERE loan-cond.contract  EQ oLoan:contract AND
                                      loan-cond.cont-code EQ oLoan:cont-code NO-LOCK.

            cTypePeriod    = loan-cond.int-period.
            IF cTypePeriod = "КМ"    THEN cTypePeriod = "М".
            IF cTypePeriod = "КМ[3]" THEN cTypePeriod = "К".

      oldMarket = DECIMAL(oLoan:getXAttrWDef("PirMarketPrice",?)).


      FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:

            ref% = GET_COMM("%ЦБРеф",?,"","",0,0,IF oLoan:isRateChanged("Деп%",hOp::op-date,FALSE) THEN dEndDate ELSE oLoan:open-date).
            oParam:setH('ref%',ref%).
            oParam:setH('acct-db',op-entry.acct-db).
            oParam:setH('acct-cr',op-entry.acct-cr).
            oParam:setH('amt-rub',op-entry.amt-rub).
            oParam:setH('amt-cur',op-entry.amt-cur).
            oParam:setH("nach%",amt-rub).
            oParam:setH('loan-pos',oLoan:getMainPos2Date(currDate - 1)).
            oParam:setH('fprice',getDpsRateComm(oLoan:HANDLE,hOp::op-date,TRUE)).
            oParam:setH('cprice',getDpsRateComm(oLoan:HANDLE,hOp::op-date,TRUE)).        
            oParam:setH("PirMarketPrice",oldMarket).
            oParam:setH('max%',ref% * oLoan:getMaxK()).

            oParam:setH('isSkip','NO').
            oParam:setH('cont-code',oLoan:cont-code).
            oParam:setH('contract',oLoan:contract).

            oParam:setH('tyo',oParam:get('tyo') + "|" + oLoan:currency + "|" + getPeriod2(cTypePeriod,STRING(oLoan:currency),duration) + "|" + cTypePeriod + "|" + STRING(getSumType(STRING(oLoan:currency),cTypePeriod,oLoan:getMainPos2Date(oLoan:open-date + 1)))).     
      END.

    END. /* CAN-DO */
    ELSE DO:
        oParam:setH('isSkip','YES').
    END.
   END.

   /**
    * Определяем сколько выплачено.
    * Это будет дебетовый оборот по 47411.
    * Причем обязательно рублевый.
    *
    oAcct = oLoan:getAcct("loan-dps-int",currDate).

    trMask = oSysClass:invertMask(oSysClass:getSetting("ОперДень","BefCl","!*")) + ",*".
    */

    /**
     * Получаем дебетовый оборот
     * в рублях кроме переоценки.
     **/
    /*
    oParam:setH("nach%",oAcct:getCrMove(DATE(oParam:get("dBegDate")),DATE(oParam:get("dEndDate")),"Ф",810,trMask)).
    */
                                                                                                                             
   DELETE OBJECT oLoan     NO-ERROR.
   DELETE OBJECT loanOwner NO-ERROR.
   DELETE OBJECT oAcct     NO-ERROR. 
   DELETE OBJECT oSysclass NO-ERROR. 
   
END FUNCTION.

FUNCTION fillExtInfo07 RETURNS LOG(
                                   INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
				   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray
                                  ):

    DEF VAR oLoan     AS TLoan   NO-UNDO.
    DEF VAR oRes      AS TAArray NO-UNDO.
    DEF VAR loanOwner AS TClient NO-UNDO.
    DEF VAR nach%     AS DEC     INIT 0 NO-UNDO.
    DEF VAR duration  AS INT     NO-UNDO.

    DEF VAR dBegDate  AS DATE       NO-UNDO.
    DEF VAR dEndDate  AS DATE       NO-UNDO.

    DEF BUFFER ttLoan-int FOR loan-int.

    dBegDate = DATE(oParam:get("dBegDate")).
    dEndDate = DATE(oParam:get("dEndDate")).
    
    FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK.

    oLoan = TLoan:initDeposByDoc(hOp).

    IF oLoan = ? THEN DO:    
      /*
       * Проводка может быть не привязана к договору.
       */
       oLoan = TLoan:initByAcct('Депоз',op-entry.acct-cr,op-entry.op-date).
    END.

   IF oLoan <> ? THEN DO:

    /**
     * По заявке #2893 если
     * договор открыт вне даты расчетного периода,
     * то не учитываем его в расчете рядов
     **/
    IF (oLoan:open-date <= dBegDate OR dEndDate <= oLoan:open-date) AND NOT LOGICAL(oParam:get("isLnk")) THEN DO:

      oParam:setH("isSkip","YES").

    END.
     
    loanOwner = oLoan:getOwner().
    duration = oLoan:end-date - oLoan:open-date.
    oRes  = oLoan:getCommisionValue(currDate).
     

    oParam:setH('tyo',oParam:get('tyo') + "|" + oLoan:currency + "|" + getPeriod3(duration)).

    oParam:setH('name-short',loanOwner:name-short).
    oParam:setH('loan-pos',oLoan:getMainPos2Date(currDate - 1)).
    oParam:setH('cont-code',oLoan:cont-code).
    oParam:setH('contract',oLoan:contract).
    oParam:setH('open-date',oLoan:open-date).

    oParam:setH('acct-db',op-entry.acct-db).
    oParam:setH('acct-cr',op-entry.acct-cr).
    oParam:setH('amt-rub',op-entry.amt-rub).
    oParam:setH('amt-cur',op-entry.amt-cur).
    oParam:setH('fprice',TRIM(oRes:get('%Деп'),'%')).
    oParam:setH('cprice',TRIM(oRes:get('%Деп'),'%')).
    oParam:setH('ref%',STRING(GET_COMM("%ЦБРеф",
                                         ?,
                                         "",
                                         "",
                                         0,
                                         0,
                                         oLoan:open-date))).

    IF oLoan:isRateChanged("%Деп",hOp::op-date,FALSE) THEN DO:
       oParam:setH('ref%',STRING(GET_COMM("%ЦБРеф",
                                           ?,
                                           "",
                                           "",
                                           0,
                                           0,
                                           oLoan:open-date))
                   ).
    END.

     oParam:setH("PirMarketPrice",oLoan:getXAttrWDef("PirMarketPrice","-1")).

   oParam:setH('nach%',amt-rub).


/*
                 FOR EACH ttLoan-int WHERE ttLoan-int.contract=oLoan:contract AND ttLoan-int.cont-code EQ ENTRY(1,oLoan:cont-code," ")
                                       AND ttLoan-int.id-d = 4 AND ttLoan-int.id-k = 5 AND dBegDate <= ttLoan-int.mdate AND ttLoan-int.mdate <= dEndDate  NO-LOCK:
                   nach% = nach% + ttLoan-int.amt-rub.
                 END.
*/


    DELETE OBJECT oLoan NO-ERROR.
    DELETE OBJECT oRes  NO-ERROR.
   END.
END FUNCTION.

FUNCTION fillExtInfo07-1 RETURNS LOG(
                                   INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
				   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray
                                  ):

    DEF VAR oRes      AS TAArray   NO-UNDO.
    DEF VAR loanOwner AS TClient   NO-UNDO.
    DEF VAR oSysClass AS TSysClass NO-UNDO.
    DEF VAR vAcct     AS TAcct     NO-UNDO.
  
    DEF VAR nach%     AS DEC INIT 0 NO-UNDO.
    DEF VAR duration  AS INT        NO-UNDO.

    DEF VAR dBegDate  AS DATE       NO-UNDO.
    DEF VAR dEndDate  AS DATE       NO-UNDO.
    DEF VAR ref%      AS DEC        NO-UNDO.

    DEF BUFFER ttLoan-int FOR loan-int.

    dBegDate = DATE(oParam:get("dBegDate")).
    dEndDate = DATE(oParam:get("dEndDate")).

    oSysClass = NEW TSysClass().
    


        FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK.

        loanOwner = NEW TClient(op-entry.acct-cr).
        vAcct     = NEW TAcct(op-entry.acct-cr).
     

        oParam:setH('tyo',oParam:get('tyo') + "|").

        oParam:setH('name-short',loanOwner:name-short).
        oParam:setH('loan-pos',oSysClass:convert2Rur((IF vAcct:currency = "" THEN 810 ELSE INT(vAcct:currency)),vAcct:getLastPos2Date(currDate - 1),dEndDate)).
        oParam:setH('cont-code',vAcct:acct).
        oParam:setH('open-date',vAcct:open-date).

        oParam:setH('acct-db',op-entry.acct-db).
        oParam:setH('acct-cr',op-entry.acct-cr).
        oParam:setH('amt-rub',op-entry.amt-rub).
        oParam:setH('amt-cur',op-entry.amt-cur).


        oParam:setH('fprice',vAcct:getXAttr("PirNPerc",hOp::op-date)).
        oParam:setH('cprice',vAcct:getXAttr("PirNPerc",hOp::op-date)).

  
      /***
       * Если ставка менялась, то ставка рефинансирования
       * берется на дату окончания периода.
       ***/
                    ref% = GET_COMM("%ЦБРеф",
                                           ?,
                                           "",
                                           "",
                                           0,
                                           0,
                                           IF vAcct:isTmpAttrChanged("PirNPerc",hOp::op-date) THEN dEndDate ELSE vAcct:open-date).


    oParam:setH('ref%',ref%).
    oParam:setH('max%',ref% * TLoan:getMK(vAcct:currency)).
    oParam:setH('nach%',amt-rub).



    DELETE OBJECT oSysClass NO-ERROR.
    DELETE OBJECT oRes      NO-ERROR.
    DELETE OBJECT vAcct     NO-ERROR.

END FUNCTION.


FUNCTION fillExtInfo08 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
 DEF VAR oLoan     AS TLoan     NO-UNDO.
 DEF VAR oSysClass AS TSysClass NO-UNDO.
 DEF VAR oAcct     AS TAcct     NO-UNDO.
 DEF VAR trMask    AS CHAR      NO-UNDO.

 oLoan = TLoan:initDeposByDoc(hOp).
 oSysClass = NEW TSysClass().

   IF oLoan <> ? THEN DO:    

    IF CAN-DO("Срочн*",oLoan:cont-type) THEN DO:
        fillExtInfo06(currDate,typeOper,isLnk,hOp,oParam).
        oParam:setH('fprice',getDpsRateComm(oLoan:HANDLE,hOp::op-date,FALSE)).
        oParam:setH('cprice',getDpsRateComm(oLoan:HANDLE,hOp::op-date,FALSE)).

     /**
      * Определяем сколько выплачено.
      * Это будет дебетовый оборот по 47411.
      * Причем обязательно рублевый.
      */

     oAcct = oLoan:getAcct("loan-dps-int",currDate).

     trMask = oSysClass:invertMask(oSysClass:getSetting("ОперДень","BefCl","!*")) + ",ptClose*".
    

     /**
      * Получаем дебетовый оборот
      * в рублях кроме переоценки.
      **/
      oParam:setH("nach%",oAcct:getDbMove(DATE(oParam:get("dBegDate")),DATE(oParam:get("dEndDate")),"Ф",810,trMask)).
    

     END.
   END.

 DELETE OBJECT oAcct NO-ERROR.
 DELETE OBJECT oLoan NO-ERROR.
 DELETE OBJECT oSysClass.

END FUNCTION.


 
FUNCTION fillExtInfo10 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
    DEF VAR operId AS CHAR NO-UNDO.
    DEF BUFFER op-entry FOR op-entry.
    FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK NO-ERROR.
    IF AVAILABLE(op-entry) THEN DO:
    operId = STRING(currDate) + "-" + typeOper + "-" + op-entry.acct-db.
    oOper10Count:incrementTo(operId,1).
    oParam:setH('isSkip','YES').
    END.
END FUNCTION.


FUNCTION fillExtInfo09 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
    DEF VAR operId       AS CHAR      NO-UNDO.
    DEF VAR oSysClass    AS TSysClass NO-UNDO.
    DEF BUFFER op-entry FOR op-entry.

    oParam:setH('isSkip','YES').
    oSysClass = NEW TSysClass().
    IF NOT CAN-DO(oSysClass:getSetting("ГНИ","bal-nalog","!*"),hOp::ben-acct) THEN DO:

       FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK NO-ERROR.
       IF AVAILABLE(op-entry) THEN DO:
         operId = STRING(currDate) + "-" + typeOper + "-" + op-entry.acct-db.
         oOper10Count:incrementTo(operId,1).
       END.

    END.
  DELETE OBJECT oSysClass.
END FUNCTION.


FUNCTION fillExtInfo10_1 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
    DEF VAR operId AS CHAR NO-UNDO.
    DEF VAR oSysClass AS TSysClass NO-UNDO.
    DEF BUFFER op-entry FOR op-entry.

    oParam:setH('isSkip','YES').

    oSysClass = NEW TSysClass().
    IF NOT CAN-DO(oSysClass:getSetting("ГНИ","bal-nalog","!*"),hOp::ben-acct) THEN DO:

       FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK NO-ERROR.
       IF AVAILABLE(op-entry) THEN DO:
         operId = STRING(currDate) + "-" + typeOper + "-" + op-entry.acct-db.
         oOper10Count:incrementTo(operId,1).
       END.

    END.
  DELETE OBJECT oSysClass.
END FUNCTION.

FUNCTION fillExtInfo10_2 RETURNS LOG(INPUT currDate AS DATE,INPUT typeOper AS CHAR,INPUT isLnk AS LOG,INPUT hOp AS HANDLE,INPUT oParam AS TAArray):
    DEF VAR operId   AS CHAR NO-UNDO.

    DEF VAR docCount AS DEC  NO-UNDO.
    DEF VAR docSum   AS DEC  NO-UNDO.
    DEF VAR tmpStr   AS CHAR NO-UNDO.

    DEF BUFFER op-entry FOR op-entry.

    oParam:setH('isSkip','YES').

    FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK NO-ERROR.
    IF AVAILABLE(op-entry) THEN DO:
      operId = STRING(currDate) + "-" + typeOper + "-" + op-entry.acct-db.
      tmpStr = oOper10Count:get(operId).

      IF tmpStr = ? OR tmpStr = "0" THEN DO:
         oOper10Count:setH(operId,"1-" + STRING(op-entry.amt-rub)).
      END. ELSE DO:
         ENTRY(1,tmpStr,"-") = STRING(DEC(ENTRY(1,tmpStr,"-")) + 1).
         ENTRY(2,tmpStr,"-") = STRING(DEC(ENTRY(2,tmpStr,"-")) + op-entry.amt-rub).
         oOper10Count:setH(operId,tmpStr).
      END.
    END.
END FUNCTION.




FUNCTION fillExtInfo11 RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):

    DEF VAR oClient AS TClient NO-UNDO.
    DEF VAR dBody   AS DEC     NO-UNDO.
    DEF VAR dCom    AS DEC     NO-UNDO.
    DEF VAR d       AS DEC     NO-UNDO.

    DEF BUFFER bufOp      FOR op.
    DEF BUFFER bufOpEntry FOR op-entry.

    FIND FIRST bufOpEntry WHERE bufOpEntry.op EQ hOp::op
                            AND bufOpEntry.acct-db BEGINS "4"
                            AND bufOpEntry.acct-cr BEGINS "2"
                            NO-LOCK NO-ERROR.

    IF AVAILABLE(bufOpEntry) THEN DO:
          oClient = NEW TClient(bufOpEntry.acct-db).
            oParam:setH('tyo',oParam:get('tyo') + "|" + oClient:cust-cat + "|" + bufOpEntry.currency + "|" + bufOpEntry.symbol).
            oParam:setH("name-short",oClient:name-short).
          DELETE OBJECT oClient.
           oParam:setH('acct',bufOpEntry.acct-db).
           oParam:setH('acct-db',bufOpEntry.acct-db).
           oParam:setH('acct-cr',bufOpEntry.acct-cr).
           oParam:setH('amt-rub',bufOpEntry.amt-rub).
           oParam:setH('amt-cur',bufOpEntry.amt-cur).        
           dBody = bufOpEntry.amt-rub.

    END.

    FOR EACH bufOp WHERE bufOp.op-transaction EQ hOp::op-transaction
                     AND bufOp.op <> hOp::op NO-LOCK,
         FIRST bufOpEntry OF bufOp WHERE acct-cr BEGINS "7" NO-LOCK:
         dCom = bufOpEntry.amt-rub.
    END.

  d = ROUND(100 * dCom / dBody,2).
  oParam:setH("dCom",dCom).
  oParam:setH("fprice",d).
  oParam:setH("cprice",d).
END FUNCTION.

FUNCTION fillExtInfo12 RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
    DEF BUFFER bufOpEntry FOR op-entry.
    DEF BUFFER bufOp      FOR op.
    DEF BUFFER op-entry   FOR op-entry.


   FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK.


   IF AVAILABLE(op-entry) THEN DO:


   FOR FIRST bufOp WHERE bufOp.op-transaction = hOp::op-transaction
                      AND bufOp.op <> hOp::op NO-LOCK,
    FIRST bufOpEntry OF bufOp WHERE bufOpEntry.acct-cr BEGINS '70601' NO-LOCK:

     IF AVAILABLE(bufOpEntry) THEN DO:
           oParam:setH('acct-db',bufOpEntry.acct-db).
           oParam:setH('acct-cr',bufOpEntry.acct-cr).
           oParam:setH('amt-rub',bufOpEntry.amt-rub).
           oParam:setH('amt-cur',bufOpEntry.amt-cur).
           oParam:setH('fprice',bufOpEntry.amt-rub * 100 / ROUND(op-entry.amt-rub,4)).
           oParam:setH('cprice',bufOpEntry.amt-rub * 100 / ROUND(op-entry.amt-rub,4)).
     END.                                                     
 END.

END.

END FUNCTION.

FUNCTION fillExtInfo13 RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
    DEF BUFFER op-entry   FOR op-entry.
    DEF BUFFER bufOpEntry FOR op-entry.
    DEF BUFFER bufOp      FOR op.

   FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK.

   IF AVAILABLE(op-entry) THEN DO:


   FOR FIRST bufOp WHERE bufOp.op-transaction = hOp::op-transaction
                      AND bufOp.op <> hOp::op NO-LOCK,
    FIRST bufOpEntry OF bufOp WHERE bufOpEntry.acct-cr BEGINS '70601' NO-LOCK:

     IF AVAILABLE(bufOpEntry) THEN DO:
           oParam:setH('acct-db',bufOpEntry.acct-db).
           oParam:setH('acct-cr',bufOpEntry.acct-cr).
           oParam:setH('amt-rub',bufOpEntry.amt-rub).
           oParam:setH('amt-cur',bufOpEntry.amt-cur).
           oParam:setH('fprice',bufOpEntry.amt-rub * 100 / ROUND(op-entry.amt-rub,4)).
           oParam:setH('cprice',bufOpEntry.amt-rub * 100 / ROUND(op-entry.amt-rub,4)).
     END.                                                     
 END.

END.

END FUNCTION.


FUNCTION fillExtInfo50 RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk    AS LOG,
                                   INPUT hOp      AS HANDLE,
                                   INPUT oParam   AS TAArray):
    DEF VAR oLoan AS TLoan       NO-UNDO.
    DEF VAR oRes  AS TAArray     NO-UNDO.
    DEF VAR loanOwner AS TClient NO-UNDO.
       

    oLoan = TLoan:initByDoc(hOp).

 IF oLoan <> ? THEN DO:

    loanOwner = oLoan:getOwner().
    oParam:setH('tyo',oParam:get('tyo') + "|" + oLoan:currency + "|" + loanOwner:cust-cat).
    oRes = oLoan:getCommisionValue(hOp::op-date).

 

     FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
        oParam:setH('acct-db',op-entry.acct-db).
        oParam:setH('acct',op-entry.acct-db).
        oParam:setH('dCom',op-entry.amt-rub).
        oParam:setH('acct-db',op-entry.acct-cr).
        oParam:setH('amt-rub',op-entry.amt-rub).
        oParam:setH('amt-cur',op-entry.amt-cur).
        oParam:setH('name-short',loanOwner:name-short).
        oParam:setH('cont-code',oLoan:cont-code).
     END.

        oParam:setH('fprice',TRIM(oRes:get('НеиспК'),'%')).
        oParam:setH('cprice',TRIM(oRes:get('НеиспК'),'%')).
         
    DELETE OBJECT oLoan.
    DELETE OBJECT oRes.
    DELETE OBJECT loanOwner NO-ERROR.
 END.

END FUNCTION.

FUNCTION fillExtInfo51 RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk    AS LOG,
                                   INPUT hOp      AS HANDLE,
                                   INPUT oParam   AS TAArray):

    DEF VAR oLoan     AS TLoan   NO-UNDO.
    DEF VAR oRes      AS TAArray NO-UNDO.
    DEF VAR loanOwner AS TClient NO-UNDO.

    oLoan = TLoan:initByDoc(hOp).
    loanOwner = oLoan:getOwner().

  IF oLoan <> ? THEN DO:

    oParam:setH('tyo',oParam:get('tyo') + "|" + oLoan:currency + "|" + loanOwner:cust-cat).
    oRes = oLoan:getCommisionValue(hOp::op-date).
 

     FOR EACH op-entry WHERE op-entry.op EQ hOp::op NO-LOCK:
        oParam:setH('acct-db',op-entry.acct-db).
        oParam:setH('acct',op-entry.acct-db).
        oParam:setH('dCom',op-entry.amt-rub).
        oParam:setH('acct-cr',op-entry.acct-cr).
        oParam:setH('amt-rub',op-entry.amt-rub).
        oParam:setH('amt-cur',op-entry.amt-cur).
     END.

        oParam:setH('fprice',TRIM(oRes:get('НеиспК'),'%')).
        oParam:setH('cprice',TRIM(oRes:get('НеиспК'),'%')).
        oParam:setH('name-short',loanOwner:name-short).
        oParam:setH('cont-code',oLoan:cont-code).
         
    DELETE OBJECT oLoan.
    DELETE OBJECT oRes.
    DELETE OBJECT loanOwner NO-ERROR.
   END.

END FUNCTION.

FUNCTION fillExtInfoFix RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
       DEF VAR oClient AS TClient NO-UNDO.

        FIND FIRST op-entry WHERE op = hOp::op NO-LOCK NO-ERROR. 
        IF AVAILABLE(op-entry) THEN DO:

        oParam:setH('name-short',hOp::name-ben).

        IF NOT {assigned hOp::name-ben} OR hOp::name-ben EQ ? THEN DO:
           oClient = NEW TClient(op-entry.acct-db).       
            oParam:setH('name-short',oClient:name-short).
           DELETE OBJECT oClient.
        END. 


        oParam:setH('acct',op-entry.acct-db).
	oParam:setH('fprice',amt-rub).
        oParam:setH('cprice',amt-rub).
        END.

END FUNCTION.

FUNCTION fillExtInfo54 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):

       FOR EACH op-entry WHERE op = hOp::op NO-LOCK:
              IF op-entry.acct-db = "" OR op-entry.acct-cr = "" THEN DO:

              END.
       END.
END FUNCTION.

FUNCTION fillExtInfo56-1 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
       DEF VAR dSum1   AS DEC NO-UNDO.
       DEF VAR dSum2   AS DEC NO-UNDO.
       DEF VAR dResult AS DEC NO-UNDO.

       FOR EACH op-entry WHERE op = hOp::op AND NOT (op-entry.acct-db BEGINS '7' AND op-entry.acct-cr BEGINS '7') NO-LOCK:
          IF op-entry.acct-cr EQ ? THEN DO:
             dSum1 = op-entry.amt-cur.
          END. ELSE DO:
             dSum2 = op-entry.amt-cur.
          END.                    
       END.

oParam:setH('fprice',dSum2 / dSum1).
oParam:setH('cprice',dSum2 / dSum1).
END FUNCTION.

FUNCTION fillExtInfo56-2 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):

       DEF VAR dSum1   AS DEC NO-UNDO.
       DEF VAR dSum2   AS DEC NO-UNDO.
       DEF VAR dResult AS DEC NO-UNDO.



       FOR EACH op-entry WHERE op = hOp::op AND NOT (op-entry.acct-db BEGINS '7' AND op-entry.acct-cr BEGINS '7') NO-LOCK:

          IF op-entry.acct-cr EQ ? THEN DO:
             dSum2 = op-entry.amt-cur.
          END. ELSE DO:
             dSum1 = op-entry.amt-cur.
          END.                    

            
       END.
oParam:setH('fprice',dSum2 / dSum1).
oParam:setH('cprice',dSum2 / dSum1).
END FUNCTION.


FUNCTION fillExtInfo57 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):

        DEF VAR oLoan AS TLoan           NO-UNDO.
        DEF VAR oAcct AS TAcct           NO-UNDO.
        DEF VAR loanOwner AS TClient     NO-UNDO.
        DEF VAR oRes  AS TAArray         NO-UNDO.
        DEF VAR cType AS CHAR            NO-UNDO.
        DEF VAR p%    AS DEC  INIT 0     NO-UNDO.

        DEF VAR dBegDate  AS DATE       NO-UNDO.
        DEF VAR dEndDate  AS DATE       NO-UNDO.

        DEF BUFFER op-entry FOR op-entry.
        DEF BUFFER ttLoan-int FOR loan-int.

       dBegDate = DATE(oParam:get("dBegDate")).
       dEndDate = DATE(oParam:get("dEndDate")).

        oLoan = TLoan:initByDoc(hOp).
        loanOwner = oLoan:getOwner().
        FIND FIRST op-entry WHERE op-entry.op EQ hOp::op NO-LOCK NO-ERROR.

            IF oLoan <> ? THEN DO:
	       oRes = oLoan:getCommisionValue(currDate,TRUE).               
               oAcct = NEW TAcct(oLoan:getAcctByDateRole("Кредит",currDate)).
               cType = oLoan:getXAttr('DTType').

               oParam:setH('tyo',oParam:get('tyo') + '|' + (IF cType = ? THEN "Кредит" ELSE cType)).
               oParam:setH('fprice',TRIM(oRes:get('%Кред'),'%')).
               oParam:setH('cprice',TRIM(oRes:get('%Кред'),'%')).               
               
               oParam:setH('acct-db',op-entry.acct-db).
               oParam:setH('acct-db',op-entry.acct-cr).
               oParam:setH('amt-rub',op-entry.amt-rub).
               oParam:setH('amt-cur',op-entry.amt-cur).

               oParam:setH('fprice',TRIM(oRes:get('%Кред'),'%')).
               oParam:setH('cprice',TRIM(oRes:get('%Кред'),'%')).
               oParam:setH('name-short',loanOwner:name-short).
               oParam:setH('cont-code',oLoan:doc-num).
               oParam:setH('open-date',oLoan:open-date).

               oParam:setH('loan-pos',oAcct:getLastPos2Date(currDate)).

                 FOR EACH ttLoan-int WHERE ttLoan-int.contract=oLoan:contract AND ttLoan-int.cont-code EQ ENTRY(1,oLoan:cont-code," ")
                                       AND ttLoan-int.id-d = 5 AND ttLoan-int.id-k = 6  AND dBegDate <= ttLoan-int.mdate AND ttLoan-int.mdate <= dEndDate NO-LOCK:
                   p% = p% + ttLoan-int.amt-rub.
                 END.
                 oParam:setH('percent',p%).

            END.

        DELETE OBJECT oLoan NO-ERROR.
        DELETE OBJECT loanOwner NO-ERROR.
        DELETE OBJECT oAcct NO-ERROR.
END FUNCTION.

FUNCTION fillExtInfo58 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):

   DEF VAR oDoc     AS TDocument NO-UNDO.
   DEF VAR baseCurs AS DECIMAL   NO-UNDO.
   DEF VAR currCurs AS DECIMAL   NO-UNDO.

   oDoc = NEW TDocument(hOp,FALSE).
   baseCurs = DECIMAL(oDoc:getXAttr("PirBaseRate")).     
   currCurs = DECIMAL(oDoc:getXAttr("sprate")).     
   oParam:setH('name-short',oDoc:name-ben).
   oParam:setH('kurs-fact',currCurs).
   oParam:setH('middle',baseCurs).   


       FIND FIRST op-entry WHERE op-entry.op EQ hOp::op
                               AND op-entry.acct-db BEGINS '20202'
                               AND op-entry.acct-cr BEGINS '20202' NO-LOCK NO-ERROR.

       IF AVAILABLE(op-entry) THEN DO:
          oParam:setH('tyo',oParam:get('tyo') + "|" + op-entry.currency).
          baseCurs = DECIMAL(oDoc:getXAttr("PirBaseRate")).     
          currCurs = DECIMAL(oDoc:getXAttr("sprate")).     
          oParam:setH("fprice",currCurs).
          oParam:setH("cprice",baseCurs).
          oParam:setH('amt-rub',op-entry.amt-rub).
          oParam:setH('amt-cur',op-entry.amt-cur).
       END.
   DELETE OBJECT oDoc.

END.

FUNCTION fillExtInfo59 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
   DEF VAR oDoc      AS TDocument NO-UNDO.
   DEF VAR baseCurs  AS DECIMAL   NO-UNDO.
   DEF VAR currCurs  AS DECIMAL   NO-UNDO.
   DEF VAR oSysClass AS TSysClass NO-UNDO.

   oDoc = NEW TDocument(hOp,FALSE).
   oSysClass = NEW TSysClass().
       baseCurs = DECIMAL(oDoc:getXAttr("PirBaseRate")).     
       currCurs = DECIMAL(oDoc:getXAttr("sprate")).     

       oParam:setH('fprice',baseCurs).
       oParam:setH('cprice',currCurs).               
       oParam:setH('name-short',oDoc:name-ben).
       oParam:setH('kurs-fact',currCurs).
       oParam:setH('middle',baseCurs).               


       FIND FIRST op-entry WHERE op-entry.op EQ hOp::op
                               AND op-entry.acct-db BEGINS '20202'
                               AND op-entry.acct-cr BEGINS '20202' NO-LOCK NO-ERROR.
       IF AVAILABLE(op-entry) THEN DO:
          oParam:setH('tyo',oParam:get('tyo') + "|" + op-entry.currency).
          oParam:setH('amt-rub',op-entry.amt-rub).
          oParam:setH('amt-cur',op-entry.amt-cur).
       END.

   DELETE OBJECT oDoc.
   DELETE OBJECT oSysClass.

END.

FUNCTION fillExtInfo60 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
   DEF VAR oDoc        AS TDocument NO-UNDO.
   DEF VAR baseCurs    AS DECIMAL   NO-UNDO.
   DEF VAR currCurs    AS DECIMAL   NO-UNDO.
   DEF VAR oSysClass AS TSysClass NO-UNDO.

   oDoc = NEW TDocument(hOp,FALSE).
   oSysClass = NEW TSysClass().
       baseCurs = DECIMAL(oDoc:getXAttr("PirBaseRate")).     
       currCurs = DECIMAL(oDoc:getXAttr("sprate")).     



       oParam:setH('fprice',baseCurs).
       oParam:setH('cprice',currCurs).
       oParam:setH('middle',baseCurs).               
       oParam:setH('name-short',oDoc:name-ben).
       oParam:setH('kurs-fact',currCurs).
       oParam:setH('kurs-calc',baseCurs).


       FIND FIRST op-entry WHERE op-entry.op EQ hOp::op
                               AND op-entry.acct-db BEGINS '20202'
                               AND op-entry.acct-cr BEGINS '20202' NO-LOCK NO-ERROR.
       IF AVAILABLE(op-entry) THEN DO:
          oParam:setH('amt-rub',op-entry.amt-rub).
          oParam:setH('amt-cur',op-entry.amt-cur).
      END.

   DELETE OBJECT oDoc.
   DELETE OBJECT oSysClass.

END.



FUNCTION fillExtInfo61 RETURN  LOG(INPUT currDate AS DATE,
				   INPUT typeOper AS CHAR,
				   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
   DEF VAR oDoc     AS TDocument NO-UNDO.
   DEF VAR baseCurs AS DECIMAL   NO-UNDO.
   DEF VAR currCurs AS DECIMAL   NO-UNDO.
   DEF VAR PirBaseRate AS DECIMAL   NO-UNDO.

   oDoc = NEW TDocument(hOp,FALSE).
       baseCurs = DECIMAL(oDoc:getXAttr("PirBaseRate")).     
       currCurs = DECIMAL(oDoc:getXAttr("sprate")).     

       oParam:setH('fprice',baseCurs).
       oParam:setH('cprice',currCurs).               
       oParam:setH('name-short',oDoc:name-ben).

       oParam:setH('kurs-fact',currCurs).
       oParam:setH('kurs-calc',baseCurs).

       FIND FIRST op-entry WHERE op-entry.op EQ hOp::op
                               AND op-entry.acct-db BEGINS '20202'
                               AND op-entry.acct-cr BEGINS '20202' NO-LOCK NO-ERROR.
       IF AVAILABLE(op-entry) THEN DO:
          oParam:setH('amt-rub',op-entry.amt-rub).
          oParam:setH('amt-cur',op-entry.amt-cur).
       END.

   DELETE OBJECT oDoc.

END. 


FUNCTION fillExtInfo52 RETURNS LOG(
                                   INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray
                                  ):

    DEF VAR oClient AS TClient NO-UNDO.
    DEF VAR dCom    AS DEC     NO-UNDO.
    DEF VAR dBody   AS DEC     NO-UNDO.
    DEF VAR dOtn    AS DEC     NO-UNDO.

    DEF BUFFER bufOp      FOR op.
    DEF BUFFER bufOpEntry FOR op-entry.

    FIND FIRST bufOpEntry WHERE bufOpEntry.op EQ hOp::op NO-LOCK NO-ERROR.

    oParam:setH('name-short',hOp::name-ben).

    IF AVAILABLE(bufOpEntry) THEN DO:
        oParam:setH('acct',bufOpEntry.acct-db).
        oParam:setH('acct-db',bufOpEntry.acct-db).
        oParam:setH('acct-cr',bufOpEntry.acct-cr).
        dCom = bufOpEntry.amt-rub.
    END.

    FOR EACH bufOp WHERE bufOp.op-transaction EQ hOp::op-transaction
                     AND bufOp.op <> hOp::op NO-LOCK,
         FIRST bufOpEntry OF bufOp NO-LOCK:
         oParam:setH('name-short',bufOp.name-ben).
         oParam:setH('amt-cur',bufOpEntry.amt-cur).        
         oParam:setH('amt-rub',bufOpEntry.amt-rub).
         dBody = bufOpEntry.amt-rub.  
    END.                                           

    dOtn = ROUND(dCom / dBody,2).
    oParam:setH("dCom",dCom).
    oParam:setH("fprice",dOtn).
    oParam:setH("cprice",dOtn).

END FUNCTION.


FUNCTION fillExtInfo53 RETURNS LOG(
                                   INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray
                                  ):

    DEF VAR oClient AS TClient NO-UNDO.
    DEF VAR dCom    AS DEC     NO-UNDO.
    DEF VAR dBody   AS DEC     NO-UNDO.
    DEF VAR dOtn    AS DEC     NO-UNDO.

    DEF BUFFER bufOp      FOR op.
    DEF BUFFER bufOpEntry FOR op-entry.

    FIND FIRST bufOpEntry WHERE bufOpEntry.op EQ hOp::op NO-LOCK NO-ERROR.

    oParam:setH('name-short',hOp::name-ben).

    IF AVAILABLE(bufOpEntry) THEN DO:
        oParam:setH('acct',bufOpEntry.acct-db).
        oParam:setH('acct-db',bufOpEntry.acct-db).
        oParam:setH('acct-cr',bufOpEntry.acct-cr).
        dCom = bufOpEntry.amt-rub.
    END.

    FOR EACH bufOp WHERE bufOp.op-transaction EQ hOp::op-transaction
                     AND bufOp.op <> hOp::op NO-LOCK,
         FIRST bufOpEntry OF bufOp NO-LOCK:
         oParam:setH('name-short',bufOp.name-ben).
         oParam:setH('amt-cur',bufOpEntry.amt-cur).        
         oParam:setH('amt-rub',bufOpEntry.amt-rub).
         dBody = bufOpEntry.amt-rub.  
    END.                                           

    dOtn = ROUND(dCom / dBody,2).
    oParam:setH("dCom",dCom).
    oParam:setH("fprice",dOtn).
    oParam:setH("cprice",dOtn).

END FUNCTION.


FUNCTION fillExtInfo64 RETURNS LOG(
                                   INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray
                                  ):

    DEF VAR oClient AS TClient NO-UNDO.
    DEF VAR dCom    AS DEC     NO-UNDO.
    DEF VAR dBody   AS DEC     NO-UNDO.
    DEF VAR dOtn    AS DEC     NO-UNDO.

    DEF BUFFER bufOp      FOR op.
    DEF BUFFER bufOpEntry FOR op-entry.

    FIND FIRST bufOpEntry WHERE bufOpEntry.op EQ hOp::op NO-LOCK NO-ERROR.

    IF AVAILABLE(bufOpEntry) THEN DO:
        oParam:setH('acct',bufOpEntry.acct-db).
        oParam:setH('acct-db',bufOpEntry.acct-db).
        oParam:setH('acct-cr',bufOpEntry.acct-cr).        
        dBody = bufOpEntry.amt-rub.
    END.

    FOR EACH bufOp WHERE bufOp.op-transaction EQ hOp::op-transaction
                     AND bufOp.op <> hOp::op NO-LOCK,
         FIRST bufOpEntry OF bufOp WHERE acct-cr BEGINS "7" NO-LOCK:
         oParam:setH('name-short',bufOp.name-ben).
         oParam:setH('amt-cur',bufOpEntry.amt-cur).        
         oParam:setH('amt-rub',bufOpEntry.amt-rub).
         dCom = bufOpEntry.amt-rub.  
    END.                                           
    dBody = dBody - dCom.
    dOtn = ROUND(dCom / dBody,2).
    oParam:setH("amt-rub",dBody).

    oParam:setH("dCom",dCom).
    oParam:setH("fprice",dOtn).
    oParam:setH("cprice",dOtn).

END FUNCTION.

FUNCTION fillExtInfo65 RETURNS LOG(
                                   INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray
                                  ):

    DEF VAR oClient AS TClient NO-UNDO.
    DEF VAR dCom    AS DEC     NO-UNDO.
    DEF VAR dBody   AS DEC     NO-UNDO.
    DEF VAR dOtn    AS DEC     NO-UNDO.
    DEF VAR cName   AS CHAR    NO-UNDO.

    DEF BUFFER bufOp      FOR op.
    DEF BUFFER bufOpEntry FOR op-entry.

    FIND FIRST bufOpEntry WHERE bufOpEntry.op EQ hOp::op NO-LOCK NO-ERROR.

    IF AVAILABLE(bufOpEntry) THEN DO:
        oParam:setH('acct',bufOpEntry.acct-db).
         oClient = NEW TClient(bufOpEntry.acct-db).
           cName = oClient:name-short.
         DELETE OBJECT oClient.
        oParam:setH('acct-db',bufOpEntry.acct-db).
        oParam:setH('acct-cr',bufOpEntry.acct-cr).        
        dBody = bufOpEntry.amt-rub.
    END.

    FOR EACH bufOp WHERE bufOp.op-transaction EQ hOp::op-transaction
                     AND bufOp.op <> hOp::op NO-LOCK,
         FIRST bufOpEntry OF bufOp WHERE acct-cr BEGINS "7" NO-LOCK:        
         oParam:setH('name-short',(IF {assigned bufOp.name-ben} THEN bufOp.name-ben ELSE cName)).
         oParam:setH('amt-cur',bufOpEntry.amt-cur).        
         oParam:setH('amt-rub',bufOpEntry.amt-rub).
         dCom = bufOpEntry.amt-rub.  
    END.                                           
    dBody = dBody - dCom.
    dOtn = ROUND(dCom / dBody,2).
    oParam:setH("amt-rub",dBody).

    oParam:setH("dCom",dCom).
    oParam:setH("fprice",dOtn).
    oParam:setH("cprice",dOtn).

END FUNCTION.



FUNCTION fillExtInfo66 RETURNS LOG(INPUT currDate AS DATE,
                                   INPUT typeOper AS CHAR,
                                   INPUT isLnk AS LOG,
                                   INPUT hOp AS HANDLE,
                                   INPUT oParam AS TAArray):
       DEF VAR oClient AS TClient NO-UNDO.

        FIND FIRST op-entry WHERE op = hOp::op NO-LOCK NO-ERROR. 
        IF AVAILABLE(op-entry) THEN DO:

        oClient = NEW TClient(op-entry.acct-db).       
          oParam:setH('name-short',oClient:name-short).
          oParam:setH('tyo',oParam:get('tyo') + "|" + oClient:cust-cat).
        DELETE OBJECT oClient.

        oParam:setH('acct',op-entry.acct-db).
	oParam:setH('fprice',amt-rub).
        oParam:setH('cprice',amt-rub).
        END.

END FUNCTION.
