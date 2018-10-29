/***********************
 * Постановка на учет ценных бумаг.
 ***********************
 * Автор: Маслов Д. А.
 * Заявка: #2494
 * Дата создания: 20.02.13
 ***********************/

 {g-defs.i}
 {a-defs.i}
 {def-wf.i new}
 {defframe.i new}
 {intrface.get instrum}  /* Библиотека для работы с фин. инструментами. */
 {intrface.get acct}     /* Библиотека для работы с фин. инструментами. */
 {intrface.get xclass}
 {intrface.get db2l}

 {pir-aacctcb.i}


 DEF INPUT  PARAM in-op-date  AS DATE        NO-UNDO.
 DEF INPUT  PARAM oprid       AS RECID       NO-UNDO.

 {details.def}


 DEF VAR hOperTable AS HANDLE                NO-UNDO.
 DEF VAR cFileName  AS CHAR INIT "fund.xml"  NO-UNDO.
 DEF VAR hQuery     AS HANDLE                NO-UNDO.
 DEF VAR hTTB       AS HANDLE                NO-UNDO.
 DEF VAR oTable     AS TTable2               NO-UNDO.
 DEF VAR iCount     AS INT  INIT 0           NO-UNDO.
 DEF VAR comExchange AS DEC                  NO-UNDO. 
 DEF VAR ndsExchange AS DEC                  NO-UNDO.


 DEF VAR cur-n           LIKE currency.currency     NO-UNDO.
 DEF VAR vclass          LIKE class.class-code      NO-UNDO.
 DEF VAR vacct-cat       LIKE acct.acct-cat         NO-UNDO.
 DEF VAR tcur-db         LIKE op-templ.currency     NO-UNDO.
 DEF VAR tcur-cr         LIKE op-templ.currency     NO-UNDO.
 DEF VAR noe             LIKE op-entry.op-entry     NO-UNDO.
 DEF VAR dval            LIKE op-entry.value-date   NO-UNDO.



 {getfile.i &set1 = "Сделки"
            &set2 = "Каталог"
            &mode = must-exist
            &filename = cFileName
            &return   = "LEAVE"
  }
 cFileName = fname.

 oTable = NEW TTable2().

 CREATE TEMP-TABLE hOperTable.
 hOperTable:READ-XML("FILE",cFileName,?,?,?,?).
 
 CREATE QUERY hQuery.
 hQuery:SET-BUFFERS(hOperTable:DEFAULT-BUFFER-HANDLE).
 hQuery:QUERY-PREPARE("FOR EACH fund").
 hQuery:QUERY-OPEN().


CR_LOAN:
DO TRANSACTION 
ON ENDKEY UNDO CR_LOAN, LEAVE CR_LOAN 
ON ERROR  UNDO CR_LOAN, LEAVE CR_LOAN:

  hQuery:GET-FIRST(NO-LOCK).

  REPEAT WHILE NOT hQuery:QUERY-OFF-END:

    iCount = iCount + 1.
    RUN createLine (hOperTable).

    hQuery:GET-NEXT(NO-LOCK).
  END.

 hQuery:QUERY-CLOSE().
END.

 oTable:addRow()
       :addCell("Итого сделок")
       :addCell(iCount)
 .
 {setdest.i}
  oTable:show().
 {preview.i}

 DELETE OBJECT hQuery.
 DELETE OBJECT hOperTable.          
 DELETE OBJECT oTable.

 PROCEDURE createLine:
   DEF INPUT PARAM currFund AS HANDLE NO-UNDO.

   DEF VAR currDate      AS DATE NO-UNDO.
   DEF VAR cur-op-date   AS DATE NO-UNDO.
   DEF VAR dBodyBal      AS CHAR NO-UNDO.
   DEF VAR issue_num     AS CHAR NO-UNDO.
   DEF VAR pir_emit_2dig AS CHAR NO-UNDO.


   DEF VAR cAcct       AS CHAR NO-UNDO.
   DEF VAR cMask       AS CHAR NO-UNDO.

   DEF VAR cBodyAcct   AS CHAR NO-UNDO.
   DEF VAR cZAcct      AS CHAR NO-UNDO.
   DEF VAR cBrokerAcct AS CHAR NO-UNDO.
   DEF VAR cPPAcct     AS CHAR NO-UNDO.
   DEF VAR cPOAcct     AS CHAR NO-UNDO.
   DEF VAR oError      AS LOG  NO-UNDO.
   DEF VAR currOrgTorg AS CHAR NO-UNDO.
   DEF VAR newOrgTorg  AS CHAR NO-UNDO.


   DEF VAR mEmitID     AS CHAR NO-UNDO.

   DEF VAR oSysClass AS TSysClass NO-UNDO.  

   DEF BUFFER sec-code  FOR sec-code.
   DEF BUFFER newAcct   FOR acct.

   currDate    = in-op-date.
   cur-op-date = in-op-date.

   oSysClass = NEW TSysClass().

   RUN SetSysConf IN h_base ("гр1",currFund::n).
   RUN SetSysConf IN h_base ("гр2",currFund::dt).
   RUN SetSysConf IN h_base ("гр3",currFund::name).
   RUN SetSysConf IN h_base ("гр4",currFund::type).
   RUN SetSysConf IN h_base ("гр5",currFund::count).
   RUN SetSysConf IN h_base ("гр6",currFund::price).
   RUN SetSysConf IN h_base ("гр7",currFund::totalPrice).
   RUN SetSysConf IN h_base ("гр8",currFund::exchange).
   RUN SetSysConf IN h_base ("гр9",currFund::its).
   RUN SetSysConf IN h_base ("гр10",currFund::klir).
   RUN SetSysConf IN h_base ("гр11",currFund::broker1).
   RUN SetSysConf IN h_base ("гр12",currFund::broker2).
   RUN SetSysConf IN h_base ("гр13",currFund::profit).

   /**********************
    * Пытаемся найти ЦБ
    **********************/
    FIND FIRST sec-code WHERE sec-code.sec-code EQ currFund::id NO-LOCK.

    IF NOT AVAILABLE(sec-code) THEN DO:
       MESSAGE "Ошибка! Не найдена ценная бумага!" VIEW-AS ALERT-BOX.
    END.

    /**
     * Если на ценной бумаге нет ДР,
     * то берем начальное значение ДР из класса.
     * Если на ценной бумаге есть ДР и он не "нет",
     * то проставляем его. Если же "нет", то ничего не делаем.
     **/
    currOrgTorg = getXAttrValueEx("sec-code",getSurrogateBuffer("sec-code",BUFFER sec-code:HANDLE),"БиржаОргТорг",?).
    IF currOrgTorg = ? THEN DO:
      newOrgTorg = getXAttrInit(sec-code.class-code,"БиржаОргТорг").
    END. ELSE DO:
        IF currOrgTorg <> "нет" THEN DO:
                newOrgTorg = currOrgTorg.
        END. ELSE DO:
                newOrgTorg = ?.
        END.
    END.

    mEmitId = getXAttrValue("sec-code",sec-code.sec-code,"issue_cod").

    FIND FIRST cust-role WHERE cust-role-id EQ INT64(mEmitId) NO-LOCK.

    IF NOT AVAILABLE(cust-role) THEN DO:
       MESSAGE "Ошибка! Не найден эмитент!" VIEW-AS ALERT-BOX.
    END.
  
    
   dBodyBal      = getXAttrValue("sec-code",sec-code.sec-code,"pir-bal-acct").
   issue_num     = getXAttrValue("sec-code",sec-code.sec-code,"issue_num").
   pir_emit_2dig = getXAttrValue("cust-role",STRING(cust-role-id),"pir_emit_2dig").

   /**************************
    * Часть №1:
    *  Открываем счета.
    ***************************/

   /***************************
    * Открываем тело
    ***************************/

   cMask = dBodyBal + "вввк00" + pir_emit_2dig + issue_num + "1" + "сссс".
   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  cMask,
                  currDate,
                  BUFFER newAcct).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",currFund::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",currFund::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).
   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).
   cBodyAcct = newAcct.acct.

   /**
    * На "теле" поле контракт должно быть ЦБУчет
    **/
   newAcct.contract = "ЦбУчет".
   newAcct.details  = "Акции " + getSysConf("гр3") + " по сделке " + getSysConf("гр1") + ", " + getSysConf("гр5") + " шт.".
   RELEASE newAcct.

   /***************************
    * Открываем затраты
    ***************************/
   cMask = oSysClass:buildAcctByMask(cBodyAcct,dBodyBal + "вввкXXXXXX4XXXX").
   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  cMask,
                  currDate,
                  BUFFER newAcct).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",currFund::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",currFund::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).
   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).
   cZAcct = newAcct.acct.

   newAcct.details  = "Затраты на приобретение акций " + getSysConf("гр3") + " по сделке " + getSysConf("гр1").
   RELEASE newAcct.


   /***************************
    * Открываем отрицательную переоценку
    ***************************/

   cMask = oSysClass:buildAcctByMask(cBodyAcct,"50720вввкХХХХXXXXXXX").
   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  cMask,
                  currDate,
                  BUFFER newAcct
                  ).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",currFund::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",currFund::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).
   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

   cPOAcct = newAcct.acct.
   newAcct.details  = "Отрицательная переоценка акций " + getSysConf("гр3") + " по сделке " + getSysConf("гр1").
   RELEASE newAcct.

   /***************************
    * Открываем положительную переоценку
    ***************************/

   cMask = oSysClass:buildAcctByMask(cBodyAcct,"50721вввкХХХХXXXXXXX").
   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  cMask,
                  currDate,
                  BUFFER newAcct).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",currFund::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",currFund::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).
   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

   cPPAcct = newAcct.acct.
   newAcct.details  = "Положительная переоценка акций " + getSysConf("гр3") + " по сделке " + getSysConf("гр1").

   RELEASE newAcct.

   DELETE OBJECT oSysClass.



   /****************************
    * Часть №2:
    *    Теперь создаем документы
    ****************************/

FIND FIRST op-kind WHERE RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.

      FOR EACH op-template OF op-kind NO-LOCK:
         
         CREATE wop.
           {asswop.i}

           ASSIGN
             wop.con-date = currDate
             wop.acct-cr  = op-template.acct-cr
             wop.qty      = 1
           .


           CASE op-template.op-template:
               WHEN 1 THEN DO:
                  ASSIGN
                    wop.acct-db = cBodyAcct
                    wop.amt-rub = DEC(currFund::count) * DEC(currFund::price)
                    wop.qty     = DEC(currFund::count)
                  .
               END.

               WHEN 2 THEN DO:
                    ASSIGN
                      wop.acct-db = cZAcct
                      wop.amt-rub = DEC(currFund::broker2) 
                    .
               END.


               WHEN 3 THEN DO:
                    ASSIGN
                      wop.acct-db = cZAcct
                      wop.amt-rub = DEC(currFund::exchange)
                    .
               END.

               WHEN 4 THEN DO:
                    ASSIGN
                      wop.acct-db = cZAcct
                      wop.amt-rub = ROUND(100 * DEC(currFund::its) / 118,2)
                    .
               END.

               WHEN 5 THEN DO:
                    ASSIGN
                      wop.acct-db = op-template.acct-db
                      wop.amt-rub = ROUND(18 * DEC(currFund::its) / 118,2)
                    .
               END.

               WHEN 6 THEN DO:
                    ASSIGN
                      wop.acct-db = cZAcct
                      wop.amt-rub = DEC(currFund::klir)
                    .
               END.
           END CASE.
            RUN ProcessDetails (RECID(wop), INPUT-OUTPUT wop.details).

      END.

 
  FOR EACH wop NO-LOCK, 
     FIRST op-template OF op-kind WHERE op-template.op-template = wop.op-templ NO-LOCK:

    CREATE op. 

    {op(sess).cr}
    {g-op.ass}

       ASSIGN
            op.doc-num  = STRING(GetCounterNextValue("Общий",op.op-date))
            op.doc-date = in-op-date
            op.details  = wop.details
       .
        CREATE op-entry.
              ASSIGN
               op-entry.op-date      = in-op-date
               op-entry.acct-cat     = wop.acct-cat
               op-entry.op-status    = op.op-status
               op-entry.user-id      = op.user-id
               op-entry.op           = op.op
               op-entry.op-entry     = 1
               op-entry.acct-db      = wop.acct-db
               op-entry.acct-cr      = wop.acct-cr
               op-entry.currency     = wop.currency
               op-entry.value-date   = in-op-date
               op-entry.amt-cur      = 0
               op-entry.amt-rub      = wop.amt-rub
               op-entry.qty          = wop.qty
               op-entry.type         = wop.type
               op-entry.op-cod       = wop.op-cod
         .
        {op.upd &undo="undo, return "}
   END.

 RUN DeleteOldDataProtocol IN h_base ("гр1").
 RUN DeleteOldDataProtocol IN h_base ("гр2").
 RUN DeleteOldDataProtocol IN h_base ("гр3").
 RUN DeleteOldDataProtocol IN h_base ("гр4").
 RUN DeleteOldDataProtocol IN h_base ("гр5").
 RUN DeleteOldDataProtocol IN h_base ("гр6").
 RUN DeleteOldDataProtocol IN h_base ("гр7").
 RUN DeleteOldDataProtocol IN h_base ("гр8").
 RUN DeleteOldDataProtocol IN h_base ("гр9").
 RUN DeleteOldDataProtocol IN h_base ("гр10").
 RUN DeleteOldDataProtocol IN h_base ("гр11").
 RUN DeleteOldDataProtocol IN h_base ("гр12").
 RUN DeleteOldDataProtocol IN h_base ("гр13").

 EMPTY TEMP-TABLE wop.
END PROCEDURE. 

{intrface.del}
