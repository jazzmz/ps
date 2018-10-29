 
 /*------------------------------------------------------------------------
    File        : TLoan
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dmaslov
    Created     : Sat Jun 02 16:44:31 MSD 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.



CLASS TLoan INHERITS TBase 
            IMPLEMENTS IFinObj:
    
    {set-prop.i &aa="cont-code"  &cc="CHAR"}
    {set-prop.i &aa="doc-ref"    &cc="CHAR"}
    {set-prop.i &aa="contract"   &cc="CHAR"}
    {set-prop.i &aa="open-date"  &cc="DATE"}
    {set-prop.i &aa="end-date"   &cc="DATE"}
    {set-prop.i &aa="close-date" &cc="DATE"}
    {set-prop.i &aa="cust-cat"   &cc="CHAR"}
    {set-prop.i &aa="cust-id"    &cc="INT64"}
    {set-prop.i &aa="currency"   &cc="CHAR" }
    {set-prop.i &aa="cont-type"  &cc="CHAR" }
    {set-prop.i &aa="doc-num"    &cc="CHAR" }
    {set-prop.i &aa="ROWID"      &cc="ROWID"}
    {set-prop.i &aa="HANDLE"     &cc="HANDLE"}
    
    
CONSTRUCTOR TLoan(INPUT cContCode AS CHAR):
    FIND FIRST loan WHERE loan.cont-code = cContCode NO-LOCK NO-ERROR.

    IF AVAILABLE(loan) THEN DO:
        instanceObject(BUFFER loan:HANDLE).
    END.

END CONSTRUCTOR.

CONSTRUCTOR TLoan(INPUT cContract AS CHAR,INPUT cContCode AS CHAR):
    FIND FIRST loan WHERE loan.contract = cContract AND loan.cont-code = cContCode NO-LOCK NO-ERROR.
    IF AVAILABLE(loan) THEN DO:
        instanceObject(BUFFER loan:HANDLE).
    END.
END CONSTRUCTOR.

CONSTRUCTOR TLoan (INPUT hHandle AS HANDLE):
   instanceObject(hHandle).
END CONSTRUCTOR.

CONSTRUCTOR TLoan (INPUT rRecid AS RECID):
        FIND FIRST loan WHERE RECID(loan) = rRecid NO-LOCK NO-ERROR.
        IF AVAILABLE(loan) THEN DO:
           instanceObject(BUFFER loan:HANDLE).
        END.
END CONSTRUCTOR.    

METHOD STATIC TLoan initByAcct(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
  RETURN TLoan:initByAcct('*',cAcct,currDate).
END METHOD.

METHOD STATIC TLoan initByAcct(INPUT cContract AS CHAR,INPUT cAcct AS CHAR,INPUT currDate AS DATE):
      DEF VAR res AS TLoan NO-UNDO.
      
      DEF BUFFER loan-acct FOR loan-acct.
      DEF BUFFER loan      FOR loan.

      res = ?.
      
      FIND LAST loan-acct WHERE loan-acct.contract MATCHES cContract 
                            AND loan-acct.acct = cAcct 
                            AND since <= currDate NO-LOCK NO-ERROR.
      IF AVAILABLE(loan-acct) THEN DO:
         FIND FIRST loan WHERE  loan.contract  = loan-acct.contract
                            AND loan.cont-code = loan-acct.cont-code 
                            NO-LOCK NO-ERROR.
                            
               IF AVAILABLE(loan) THEN DO:
                  RETURN NEW TLoan(BUFFER loan:HANDLE).
               END.
      END. 
       
       RETURN res.
END METHOD.

METHOD STATIC TLoan initByAcct(INPUT cAcct AS CHAR,INPUT currDate AS DATE,INPUT cType AS CHAR):
      DEF VAR res AS TLoan NO-UNDO.
      
      DEF BUFFER loan-acct FOR loan-acct.
      DEF BUFFER loan      FOR loan.

      res = ?.
      
      FIND LAST loan-acct WHERE loan-acct.acct = cAcct 
                            AND since <= currDate 
                            AND acct-type = cType
                            NO-LOCK NO-ERROR.
      IF AVAILABLE(loan-acct) THEN DO:
         FIND FIRST loan WHERE  loan.contract  = loan-acct.contract
                            AND loan.cont-code = loan-acct.cont-code 
                            NO-LOCK NO-ERROR.
                            
               IF AVAILABLE(loan) THEN DO:
                  RETURN NEW TLoan(BUFFER loan:HANDLE).
               END.
      END. 
       
       RETURN res.
END METHOD.

/**
 * Инициализирует договор по RECID документа.
 * @param RECID rRecid Recid указатель на документ.
 * @return TLoan
 **/
METHOD STATIC TLoan initByDoc(INPUT rPK AS INT64):
 DEF BUFFER op FOR op.
 
 
 FIND FIRST op WHERE op.op = rPk NO-LOCK NO-ERROR.
 IF AVAILABLE (op) THEN DO:
    RETURN TLoan:initByDoc(BUFFER op:HANDLE).
 END.
 RETURN ?.
END METHOD.

/**
 * Инициализируем договор по HANDLE документа.
 * @param HANDLE hOp
 * @return TLoan
 **/
METHOD STATIC TLoan initByDoc(INPUT hOp AS HANDLE,INPUT findParent AS LOG):
       DEF BUFFER loan-int FOR loan-int.

       DEF VAR dogNum AS CHAR NO-UNDO.

       FIND FIRST loan-int WHERE loan-int.op EQ hOp::op NO-LOCK NO-ERROR.

       IF AVAILABLE(loan-int) THEN DO:
         dogNum = loan-int.cont-code.

         IF findParent AND NUM-ENTRIES(loan-int.cont-code," ") >= 2 THEN DO:
             dogNum = ENTRY(1,loan-int.cont-code," ").
         END.

         RETURN NEW TLoan(loan-int.contract,dogNum).

       END.

       RETURN ?.
END METHOD.
METHOD STATIC TLoan initByDoc(INPUT hOp AS HANDLE):
    /***
     * Не понятно, 
     * может ли многопроводочный документ
     * быть привязанным к договору?.
     * Вообще с этими привязками геммор полный.
     ***/

  RETURN TLoan:initByDoc(hOp,FALSE).     
END METHOD.



METHOD STATIC TLoan initDeposByDoc(INPUT hOp AS HANDLE):
    DEF BUFFER op-entry FOR op-entry.

    FIND FIRST op-entry WHERE op-entry.op EQ hOp::op AND (op-entry.kau-db <> "" OR op-entry.kau-cr <> "") NO-LOCK NO-ERROR.
/*    MESSAGE IF op-entry.kau-db <> "" THEN ENTRY(1,op-entry.kau-db) ELSE ENTRY(1,op-entry.kau-cr) "|" IF op-entry.kau-db <> "" THEN ENTRY(2,op-entry.kau-db) ELSE ENTRY(2,op-entry.kau-cr) VIEW-AS ALERT-BOX.*/
    IF AVAILABLE(op-entry) THEN DO:
        RETURN NEW TLoan(IF op-entry.kau-db <> "" THEN ENTRY(1,op-entry.kau-db) ELSE ENTRY(1,op-entry.kau-cr),IF op-entry.kau-db <> "" THEN ENTRY(2,op-entry.kau-db) ELSE ENTRY(2,op-entry.kau-cr)).
    END. 
    RETURN ?.
END METHOD.
METHOD PRIVATE VOID instanceObject(INPUT cRecord AS HANDLE):
                
    ASSIGN
      contract   = cRecord::contract
      cont-code  = cRecord::cont-code
      doc-ref    = cRecord::doc-ref
      doc-num    = cRecord::doc-num
      open-date  = cRecord::open-date
      end-date   = cRecord::end-date
      close-date = cRecord::close-date
      cust-cat   = cRecord::cust-cat
      cust-id    = cRecord::cust-id
      currency   = cRecord::currency
      ClassType  = "loan"
      classcode  = cRecord::class-code
      cont-type  = cRecord::cont-type
      ROWID      = cRecord:ROWID
      HANDLE     = cRecord:HANDLE
      surrogate  = contract + "," + cont-code
      .    
END METHOD.

/**
 * @VAR CHAR cRole роль счета;
 * @VAR DATE dDate дата действия счета.
 * @VAR CHAR Номер счета 
 * Метод возвращает 
 * счет по роли.
 **/
METHOD PUBLIC CHAR getAcctByDateRole(INPUT cRole AS CHAR, INPUT dDate AS DATE):
 FIND LAST loan-acct WHERE loan-acct.contract  = THIS-OBJECT:contract
                        AND loan-acct.cont-code = THIS-OBJECT:cont-code
                        AND loan-acct.since    <= dDate
                        AND loan-acct.acct-type = cRole NO-LOCK NO-ERROR.
  IF AVAIL(loan-acct) THEN DO:
    RETURN loan-acct.acct.
  END.                        
END METHOD.         

/**
 * Возвращает владельца договора
 * @RETURN TClient
 **/
METHOD PUBLIC TClient getOwner():
    DEF VAR oClient AS TClient NO-UNDO.
    oClient = NEW TClient(cust-cat,cust-id).
  RETURN oClient. 
END METHOD.

/**
 * Возвращает коэффициент резервирования по договору.
 * @var DATE dDate Дату на которую смотрим КК;
 * @var CHAR cType Тип к.к. {Баланс,Внебаланс}
 * @return DECIMAL.
 **/
METHOD PUBLIC DECIMAL getKK(INPUT dDate AS DATE,INPUT cType AS CHAR):
    DEF BUFFER comm-rate FOR comm-rate.
    DEF VAR    dRes      AS DECIMAL NO-UNDO.
    
     FIND LAST comm-rate WHERE comm-rate.commission BEGINS "%Рез" 
                           AND comm-rate.kau = THIS-OBJECT:contract + "," + ENTRY(1,THIS-OBJECT:cont-code," ") 
                           AND comm-rate.since <= dDate NO-LOCK NO-ERROR.
     
     IF AVAILABLE(comm-rate) THEN DO:
         dRes = comm-rate.rate-comm.
     END. ELSE DO:
         dRes = ?.
     END.
   RETURN dRes.
END METHOD.    

/**
 * Возвращает % ставки по договору
 * @var DATE currDate Дата действия
 ***/
METHOD PUBLIC TAArray getCommisionValue(INPUT currDate AS DATE):
  RETURN THIS-OBJECT:getCommisionValue(currDate,FALSE).
END METHOD.

/****
 * Метод возвращает изменение комиссии с кодом cName
 * за диапазон dBegDate - dEndDate
 * @param cName CHAR тип комиссии
 * @param dBegDate DATE начало действия комиссии
 * @param dEndDate DATE окончание действия комиссии
 * @return TAArray
 *****/ 

METHOD PUBLIC TAArray getRates( INPUT cName    AS CHAR,
                                INPUT dBegDate AS DATE,
                                INPUT dEndDate AS DATE
                               ):
  DEF VAR oAArray AS TAArray NO-UNDO.

  oAArray = getTemporalValues("PirRates",dEndDate).
  RETURN oAArray.
END METHOD.

/**
 * Метод возвращает условия договора на дату.
 * @param currDate DATE дату на которую получаем условия по договору
 * @param lRoot    LOG берем условия с текущего или родительского
 * @return TAArray
 **/
METHOD PUBLIC TAArray getCommisionValue(INPUT currDate AS DATE,INPUT lRoot AS LOG):

    DEF BUFFER comm-rate FOR comm-rate.
    DEF BUFFER loan-cond FOR loan-cond.
   
    DEF VAR oAArray   AS TAArray NO-UNDO.
    DEF VAR currContCode AS CHAR NO-UNDO.
    
    currContCode = (IF lRoot THEN ENTRY(1,THIS-OBJECT:cont-code," ") ELSE THIS-OBJECT:cont-code).

    oAArray = NEW TAArray().

    FIND LAST loan-cond WHERE loan-cond.contract  = THIS-OBJECT:contract 
                          AND loan-cond.cont-code = currContCode
                          AND loan-cond.since    <= currDate
                          NO-LOCK NO-ERROR.
                          
    IF AVAILABLE(loan-cond) THEN DO:
        FOR EACH comm-rate WHERE comm-rate.kau   = THIS-OBJECT:contract + "," + currContCode
                             AND comm-rate.since <= loan-cond.since
                             NO-LOCK BY comm-rate.since:
                             oAArray:setH(comm-rate.commission,STRING(comm-rate.rate-comm) + (IF comm-rate.rate-fixed THEN "=" ELSE "%")).   
         END.
     END.
     RETURN oAArray. 


END METHOD.

/**
 * Изменялась ли процентная ставка с кодом iRateName
 * в период до currDate
 * @param CHAR iRateName название ставки
 * @param DATE currDate ТВГ
 * @return LOG
 **/
METHOD PUBLIC LOG isRateChanged(INPUT iRateName AS CHAR,
                                INPUT iCurrDate  AS DATE,
                                INPUT lRoot     AS LOG):

    DEF VAR currContCode AS CHAR            NO-UNDO.
    DEF VAR vOldValue    AS DEC  INIT ?     NO-UNDO.
    DEF VAR vRes         AS LOG  INIT FALSE NO-UNDO.

    DEF BUFFER loan-cond FOR loan-cond.
    DEF BUFFER comm-rate FOR comm-rate.

    currContCode = (IF lRoot THEN ENTRY(1,THIS-OBJECT:cont-code," ") ELSE THIS-OBJECT:cont-code).


    FOR EACH loan-cond WHERE loan-cond.contract   = THIS-OBJECT:contract 
                          AND loan-cond.cont-code = currContCode
                          AND loan-cond.since    <= iCurrDate
                          NO-LOCK,
      FIRST comm-rate WHERE comm-rate.kau             = THIS-OBJECT:contract + "," + currContCode
                             AND comm-rate.since      = loan-cond.since
                             AND comm-rate.commission = iRateName  NO-LOCK:


                             IF vOldValue <> ? AND vOldValue <> comm-rate.rate-comm THEN DO:
                                vRes = TRUE.
                                LEAVE.
                             END.
                             vOldValue = comm-rate.rate-comm.

    END.

 RETURN vRes.

END METHOD.

METHOD PUBLIC DECIMAL getParam(INPUT dParam AS INT,INPUT dDate AS DATE):
   DEF VAR dResult AS DEC NO-UNDO.
   RUN getparam.p (THIS-OBJECT:cont-code,dParam,dDate,OUTPUT dResult).
   RETURN dResult.
END METHOD.

/**
 * @dParam INT Номер параметра
 * @dDate  DATE Дату на которую требуется параметр
 * Возвращает параметр с охватывающего договора
 * @return DEC.
 **/
METHOD PUBLIC DEC getParamRoot(INPUT dParam AS INT,INPUT dDate AS DATE):
   DEF BUFFER loan FOR loan.

   DEF VAR dRes AS DEC INIT 0 NO-UNDO.
   DEF VAR dP   AS DEC INIT 0 NO-UNDO.


   FOR EACH loan WHERE ENTRY(1,loan.cont-code," ") = ENTRY(1,THIS-OBJECT:cont-code," ") 
                  AND loan.open-date <= dDate AND (loan.close-date > dDate  OR loan.close-date = ?) NO-LOCK:

         RUN getparam.p(loan.cont-code,dParam,dDate,OUTPUT dP).
         dRes = dRes + dP.

   END.

 RETURN dRes.
END METHOD.

/**
 * Возвращает название роли с которой вяжется счет
 * на которой находится ссудная задолженность или вклад.
 * return CHAR
 **/
METHOD PUBLIC CHAR getMainRole():
  /* todo Переделать на использование метасхемы */
  IF contract = "dps" THEN DO:
    RETURN "loan-dps-t".
  END.
  IF contract = "Депоз" THEN DO:
    RETURN "Депоз".
  END.
END METHOD.
/**
 * Возвращает задолженность по договору на дату в валюте договора
 * @param currDate DATE дата на которую требуется узнать задолженность
 **/
METHOD PUBLIC DEC getMainPos2Date(INPUT currDate AS DATE):
  DEF VAR cAcct    AS CHAR  NO-UNDO.
  DEF VAR dPos     AS DEC   NO-UNDO.
  DEF VAR oAcct    AS TAcct NO-UNDO.

  cAcct = getAcctByDateRole(getMainRole(),currDate).
  oAcct = NEW TAcct(cAcct).
     dPos = oAcct:getLastPos2Date(currDate).
  DELETE OBJECT oAcct.

  RETURN dPos.       
END METHOD.

/**
 * Метод возвращает объект счет с указанной ролью на указанную дату.
 * @param cRole CHAR роль на которую требуется найти указанный счет
 * @param currDate DATE дата на которую ищем счет
 * @return TAcct
 **/
METHOD PUBLIC TAcct getAcct(INPUT cRole AS CHAR,INPUT currDate AS DATE):
   DEF VAR oAcct AS TAcct NO-UNDO.
   DEF VAR cAcct AS CHAR  NO-UNDO.

   cAcct = getAcctByDateRole(cRole,currDate).
   oAcct = NEW TAcct(cAcct).
   RETURN oAcct.
END METHOD.


/**
  * Возвращает коэффициент предельной ставки..
  * @return DECIMAL
  **/
METHOD PUBLIC DECIMAL getMaxK():
  RETURN TLoan:getMK(THIS-OBJECT:currency).
END METHOD.

METHOD STATIC PUBLIC DECIMAL getMK(INPUT iVal AS CHAR):

   IF iVal <> "" AND iVal <> "810" THEN DO:
         RETURN 0.8.
   END.
  RETURN 1.8.

END METHOD.

/**
 * Метод возвращает среднюю ставку
 * по действующим кредитам за указанный период.
 * Овердрафты не учитыаются.
 **********************************************
        ВНИМАНИЕ! УБЕЙ ЗА СОБОЙ ОБЪЕКТ!
 **********************************************
 * @param DATE dBegDate Начальная дата периода
 * @param DATE dEndDate Конечная дата периода
 * @return DEC
 **/

METHOD STATIC DEC getMdlPercent(INPUT iType AS CHAR,INPUT iBegDate AS DATE,INPUT iEndDate AS DATE):
  DEF VAR dRes     AS DEC    NO-UNDO.
  DEF VAR vCount   AS INT64  NO-UNDO.
  DEF VAR vOverLst AS CHAR   NO-UNDO.

  vOverLst = TSysClass:getSetting2("ОверКлассТранз","КлОхватТранш","*").
  vOverLst = REPLACE(vOverLst,"|",",").
  vOverLst = TSysClass:invertMask2(vOverLst) + ",*".
  

  DEF BUFFER loan      FOR loan.
  DEF BUFFER loan-cond FOR loan-cond.
  DEF BUFFER comm-rate FOR comm-rate.

  
  FOR EACH loan WHERE loan.contract     = "Кредит"
                  AND loan.open-date   <= iBegDate 
                  AND (loan.close-date >= iEndDate OR loan.close-date = ?)
                  AND CAN-DO("!НО*,!ДС*,!Ц,*",loan.cont-code)
                  AND CAN-DO(vOverLst,loan.class-code) NO-LOCK,
   LAST loan-cond WHERE loan-cond.contract  = loan.contract 
                    AND loan-cond.cont-code = loan.cont-code 
                    AND loan-cond.since     < iEndDate NO-LOCK,
     LAST comm-rate WHERE comm-rate.kau         = loan.contract + "," + loan.cont-code
                       AND comm-rate.since     <= loan-cond.since 
                       AND comm-rate.commission = iType NO-LOCK:

                       dRes   = dRes + comm-rate.rate-comm.   
                       vCount = vCount + 1.

  END.

  RETURN ROUND(dRes / vCount,2).

END METHOD.

/**
 * Метод расчитывает общую среднюю процентную ставку
 * и в разрезах валют.
 * @param CHAR iType Тип комиссии
 * @param DATE iBegDate Дата начала расчета
 * @param DATE iEndDate Дата окончания расчета
 * @return TAArray
 **/
    
METHOD STATIC TAArray getMdlPercent2(
                                 INPUT iType    AS CHAR,
                                 INPUT iBegDate AS DATE,
                                 INPUT iEndDate AS DATE
                                ):

     RETURN getMdlPercent2(iType,"loan_allocat,loan-transh","!НО*,!Ц*,!НО*,!ПК*,*",iBegDate,iEndDate).    

END METHOD.
                   
METHOD STATIC TAArray getMdlPercent2(
                                 INPUT iType    AS CHAR,
                                 INPUT iClass-Code AS CHAR,
                                 INPUT iMaskCont-Code AS CHAR,
                                 INPUT iBegDate AS DATE,
                                 INPUT iEndDate AS DATE
                                ):

 DEF BUFFER loan FOR loan.

 DEF VAR vLoan   AS TLoan   NO-UNDO.
 DEF VAR vAcct   AS TAcct   NO-UNDO.
 DEF VAR vAArray AS TAArray NO-UNDO.

 DEF VAR vP      AS DEC     NO-UNDO.
 DEF VAR vSum1   AS DEC     NO-UNDO.

 DEF VAR key1    AS CHAR    NO-UNDO.
 DEF VAR val1    AS CHAR    NO-UNDO.

 DEF VAR vRes    AS TAArray NO-UNDO.

 DEF VAR vDiff   AS INT     NO-UNDO.

 vRes = NEW TAArray("0").

 FOR EACH loan WHERE loan.open-date <= iEndDate 
                 AND (loan.close-date > iEndDate OR loan.close-date = ?) 
                 AND CAN-DO(iClass-Code,loan.class-code)
                 AND CAN-DO(iMaskCont-Code,loan.cont-code) NO-LOCK:

   vLoan   = NEW TLoan(BUFFER loan:HANDLE).
   vAcct   = vLoan:getAcct("Кредит",iEndDate).

   vAArray = vLoan:getCommisionValue(iEndDate).
      vP = IF DEC(TRIM(vAArray:get("%Кред"),"%")) / 100 <> ? THEN DEC(TRIM(vAArray:get("%Кред"),"%")) / 100 ELSE 0.
   DELETE OBJECT vAArray.
   

   vAArray = vAcct:getStableIntervals(iBegDate,iEndDate).

   IF vAcct:acct <> ? THEN DO:  
     {foreach vAArray key1 val1}
        vDiff = DATE(ENTRY(2,key1,"-")) - DATE(ENTRY(1,key1,"-")).
        vRes:incrementTo("sumAll%",DEC(val1) * vP * vDiff).
        vRes:incrementTo("sumAll",DEC(val1) * vDiff).

        vRes:incrementTo("sum%" + vLoan:currency,DEC(val1) * vP * vDiff).
        vRes:incrementTo("sum"  + vLoan:currency,DEC(val1) * vDiff).
     {endforeach vAArray}
   END.

   DELETE OBJECT vAArray.    
   DELETE OBJECT vLoan.
   DELETE OBJECT vAcct.
 END.
 
 RETURN vRes.

END METHOD.



METHOD PUBLIC LOGICAL add2DB():
END METHOD.
METHOD PUBLIC LOGICAL update2DB():
END METHOD.    
END CLASS.