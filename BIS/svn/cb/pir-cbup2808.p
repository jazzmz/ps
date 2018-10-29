/***********************************************
 * Событие на обработку строки в XML файле     *
 * для постановки ценных бумаг.                *
 ***********************************************
 * Автор : Маслов Д. А.                        *
 * Дата  : 10.04.12                            *
 * Заявка: #2808                               *
 ***********************************************/

 DEF INPUT PARAM vCurrTable  AS HANDLE NO-UNDO.
 DEF INPUT PARAM vCurrBuffer AS HANDLE NO-UNDO.
 DEF INPUT PARAM vCurrTrans  AS HANDLE NO-UNDO.
 DEF INPUT PARAM currDate    AS DATE   NO-UNDO.

 {globals.i}
 {intrface.get xclass}
 {intrface.get instrum}  /* Библиотека для работы с фин. инструментами. */
 {intrface.get acct}     /* Библиотека для работы с фин. инструментами. */
 {intrface.get db2l}
 {intrface.get sm}       /* Для получения номинала ценной бумаги */

 {pir-aacctcb.i}

 DEF VAR mField       AS HANDLE        NO-UNDO.

 DEF VAR mI           AS INT64         NO-UNDO.

 DEF VAR mBodyBal     AS CHAR          NO-UNDO.
 DEF VAR mBodyAcct    AS CHAR          NO-UNDO.
 DEF VAR mIssueNum    AS CHAR          NO-UNDO.
 DEF VAR mPirEmit2Dig AS CHAR          NO-UNDO.
 DEF VAR mEmitId      AS CHAR          NO-UNDO.

 DEF VAR mNominal     AS DEC           NO-UNDO.
 DEF VAR mNominalRur  AS DEC           NO-UNDO.

 DEF VAR mMask        AS CHAR          NO-UNDO.
 DEF VAR oSysClass    AS TSysClass     NO-UNDO.
 DEF VAR mD           AS DEC           NO-UNDO.  /* Разница между стоимостью покупки и номиналом */
 DEF VAR mPok         AS DEC           NO-UNDO.

 DEF VAR currOrgTorg  AS CHAR          NO-UNDO.
 DEF VAR newOrgTorg   AS CHAR          NO-UNDO.

 oSysClass = NEW TSysClass().

 DEF BUFFER sec-code FOR sec-code.
 DEF BUFFER newAcct  FOR acct.

 /*** Получаем информацию по ценной бумаге ***/

 FIND FIRST sec-code WHERE sec-code.sec-code EQ vCurrBuffer::id NO-LOCK.

 IF NOT AVAILABLE(sec-code) THEN DO:
       MESSAGE "Ошибка! Не найдена ценная бумага!" VIEW-AS ALERT-BOX.
 END.

 mEmitId = getXAttrValue("sec-code",sec-code.sec-code,"issue_cod").

 FIND FIRST cust-role WHERE cust-role-id EQ INT64(mEmitId) NO-LOCK.

 IF NOT AVAILABLE(cust-role) THEN DO:
       MESSAGE "Ошибка! Не найден эмитент!" VIEW-AS ALERT-BOX.
 END.
  
    
 mBodyBal      = getXAttrValue("sec-code",sec-code.sec-code,"pir-bal-acct").
 mIssueNum     = getXAttrValue("sec-code",sec-code.sec-code,"issue_num").
 mPirEmit2Dig  = getXAttrValue("cust-role",STRING(cust-role-id),"pir_emit_2dig").

 /*********************************************************
  *     Получаем номинальную стоимость ценной бумаги!     *
  *********************************************************
  * Алгоритм следующий:                                   *
  *  1. Берем номинальную стоимость из справочника        *
  * БМ => Ценные бумаги => Котировки;                     *
  *   1.1 Если значение есть, то добавляем его            *
  * в SysConf;                                            *
  *  2. Если значение получить не удалось, то проверяем   *
  * наличие значения в SysConfig;                         *
  *  3. Если значения в SysConfig не установлено, то      *
  * запрашиваем у пользователя;                           *
  *   3.1 Введенное значение сохраняем в SysConf          *
  *********************************************************/

  mPok = DECIMAL(getSysConf("price")).

  RUN GetNominal IN h_sm (vCurrBuffer::id,OUTPUT mNominal,OUTPUT mNominalRur).
  mD = mPok - mNominal.

  RUN SetSysConf IN h_base ("mD",STRING(mD)).
  RUN SetSysConf IN h_base ("nominal",STRING(mNominal)).


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



 /**********
  * №1 Открываем тело.
  **********/
  mMask = mBodyBal + "вввк00" + mPirEmit2Dig + mIssueNum + "1" + "сссс".

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirPPrice",getSysConf("price"),?).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

  newAcct.details  = GetSysConf("name") + " по сделке " + GetSysConf("n") + ", " + GetSysConf("count") + " шт. ".
  newAcct.contract = "ЦБУчет".

  mBodyAcct = newAcct.acct.
 
  RUN SetSysConf IN h_base ("СчетТело",newAcct.acct).
  RELEASE newAcct.


 /**
  * №2 Открываем счет затрат
  **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXXвввкXXXXXX4XXXX").

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).
  newAcct.details = "Затраты на приобретение облигаций " + GetSysConf("name") + " по сделке " + GetSysConf("n").

  RUN SetSysConf IN h_base ("СчетЗатраты",newAcct.acct).
  RELEASE newAcct.


 /**
  * №3 Открываем премию
  **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXXвввкXXXXXX6XXXX").

  RUN createAcct(cust-role.cust-cat,
                   cust-role.cust-id,
                   mMask,
                   currDate,
                   BUFFER newAcct
                  ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

  newAcct.details = "Премия по облигациям " + GetSysConf("name") + " по сделке " + GetSysConf("n") + ", " + GetSysConf("count") + " шт.".
 
  RUN SetSysConf IN h_base ("СчетПремия",newAcct.acct).
  RELEASE newAcct.


 /**
  * №4 Открываем дисконт
  **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXXвввкXXXXXX5XXXX").

  RUN createAcct(cust-role.cust-cat,
                   cust-role.cust-id,
                   mMask,
                   currDate,
                   BUFFER newAcct
                  ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

  newAcct.details = "Дисконт по облигациям " + GetSysConf("name") + " по сделке " + GetSysConf("n") + ", " + GetSysConf("count") + " шт.".
 
  RUN SetSysConf IN h_base ("СчетДисконт",newAcct.acct).
  RELEASE newAcct.


  /**
   * №5 Открываем ПКД уплаченный
   **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXXвввкXXXXXX3XXXX").

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

  newAcct.details = "ПКД уплаченный по облигациям " + GetSysConf("name") + " по сделке " + GetSysConf("n").

  RUN SetSysConf IN h_base ("СчетПКДУпл",newAcct.acct).
  RELEASE newAcct.


  /**
   * №6 Открываем ПКД начисленный
   **/
  mMask = oSysClass:buildAcctByMask(mBodyAcct,"XXXXXвввкXXXXXX2XXXX").

  RUN createAcct(cust-role.cust-cat,
                 cust-role.cust-id,
                 mMask,
                 currDate,
                 BUFFER newAcct
                ).

  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
  UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

  IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

  newAcct.details = "ПКД начисленный по облигациям " + GetSysConf("name") + " по сделке " + GetSysConf("n").

  RUN SetSysConf IN h_base ("СчетПКДНач",newAcct.acct).
  RELEASE newAcct.


  /**
   * №7 Открываем отрицательную переоценку
   **/
   mMask = oSysClass:buildAcctByMask(mBodyAcct,"50220вввкХХХХXXXXXXX").

   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  mMask,
                  currDate,
                  BUFFER newAcct
                  ).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

   newAcct.details  = "Отрицательная переоценка облигаций " + GetSysConf("name") + " по сделке " + GetSysConf("n").

   RUN SetSysConf IN h_base ("СчетПП",newAcct.acct). 
   RELEASE newAcct.


  /**
   * №8 Открываем положительную переоценку
   **/
   mMask = oSysClass:buildAcctByMask(mBodyAcct,"50221вввкХХХХXXXXXXX").
   RUN createAcct(cust-role.cust-cat,
                  cust-role.cust-id,
                  mMask,
                  currDate,
                  BUFFER newAcct
                  ).

   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",vCurrBuffer::n,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"sec-code",vCurrBuffer::id,?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"i1_exc","i1_exc_N6",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f155_dec","f155_exc",?).
   UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"f115_exc","f115_exc",?).

   IF newOrgTorg <> ? THEN UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"БиржаОргТорг",newOrgTOrg,?).

   newAcct.details  = "Положительная переоценка облигаций " + GetSysConf("name") + " по сделке " + GetSysConf("n").

   RUN SetSysConf IN h_base ("СчетПО",newAcct.acct). 
   RELEASE newAcct.


  /**
   * №9 Открываем еще что-нибудь
   **/




  DO mI = 1 TO vCurrBuffer:NUM-FIELDS:
     mField = vCurrBuffer:BUFFER-FIELD(mI).
  END.

 DELETE OBJECT oSysClass.
 {intrface.del}