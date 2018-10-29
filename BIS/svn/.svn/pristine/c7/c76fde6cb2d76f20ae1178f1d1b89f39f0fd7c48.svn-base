/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2012 ТОО "Банковские информационные системы"
     Filename:
      Comment:
   Parameters:
         Uses:
      Used by: ov-grace.p  - который как правило закодирован !
      Created: 12/09/12 ches
     Modified:
*/

/*
 процедуры для работы с овердрафтом
   del_table_loan         - удаление данных из временных таблиц
   create_tloan           - создание временных таблиц
   cr_loan_with_tab       - создание договора по временной таблице
   cr_loan-cond_with_tab  - создание условий договора
   cr_multi_loan-cond_with_tab   - создание условий договора ГРЕЙС с 2мя условиями
   get_period_loan-cond   - получение даты следующего условия по текущему
   cr_comm_rate_with_tab  - создание процентных ставок к договору
   cr_term-obl            - создание обязательств
   cr_main_loan-acct      - создание основного счета
   cr_signs               - создание признаков
   upd_loan_with_tab      - изменение договора
   cr_loan_rasch_acct     - создание расчетного счета
*/

/**
 * @var recid rid Указатель на условие.
 * @return AArray Список действующих комиссий.
 **************************************
 *
 * ********** ВНИМАНИЕ !!! *************
 * *** УБЕЙ ПОСЛЕ СЕБЯ РЕЗУЛЬТАТ !!! ***
 *
 **/
FUNCTION getCommRates RETURNS TAArray(INPUT rid AS RECID):

  DEF VAR oAArray  AS TAArray NO-UNDO.
  DEF VAR res      AS TAArray NO-UNDO.
  DEF VAR end_date AS DATE    NO-UNDO.

  DEF BUFFER xloan      FOR loan.
  DEF BUFFER xcomm-rate FOR comm-rate.


  FIND LAST loan-cond WHERE RECID(loan-cond) = rid NO-LOCK NO-ERROR.
  RUN get_period_loan-cond(RECID(loan-cond),OUTPUT end_date).

     FIND xloan WHERE xloan.contract=loan-cond.contract 
		     AND xloan.cont-code=loan-cond.cont-code NO-LOCK NO-ERROR.

  IF NOT AVAIL(loan-cond) THEN RETURN ?.
    ELSE DO:
      oAArray = new TAArray().

     /**
      * По #1053
      * не должен копироваться
      * коэффициент резервирования.
      * Он будет наследоваться с охвата.
      **/
     
      FOR EACH xcomm-rate WHERE
            xcomm-rate.currency = xloan.currency
            AND xcomm-rate.acct     = "0"
            AND xcomm-rate.kau      = xloan.contract + "," + xloan.cont-code
            AND xcomm-rate.since   >= loan-cond.since
            AND xcomm-rate.since   <= end_date 
            AND xcomm-rate.commission NE "%Рез" NO-LOCK:

	oAArray:setH(xcomm-rate.commission,xcomm-rate.rate-comm).

      END.

      RETURN oAArray.
    END.
END FUNCTION.

/*{{{ del_table_loan: очистка временных таблиц */
PROCEDURE del_table_loan.
  {empty tloan}
  {empty tloan-signs}
  {empty tloan-cond}
  {empty tloan-acct}
  main-cont-code = ?.
END PROCEDURE.
/* }}} */
 
/*{{{ create_tloan: создание и инициализация временной таблицы */
PROCEDURE create_tloan.
   DEF INPUT  PARAM in-class AS CHAR        NO-UNDO. /*код класса*/
   DEF INPUT  PARAM rid      AS RECID       NO-UNDO. /*ук-тель на договор*/
   DEF OUTPUT PARAM fl       AS INT64 INIT -1 NO-UNDO. /*флаг возврата*/

   DEF VAR str-par     AS CHAR INIT 'contract,cont-type,loan-status'  NO-UNDO.
   DEF VAR str-dop-par AS CHAR NO-UNDO.
   DEF VAR i           AS INT64  NO-UNDO.
   DEF VAR codval      AS CHAR NO-UNDO.
   DEF VAR acct-type   AS CHAR NO-UNDO.
   DEF VAR stav        AS CHAR INIT '%Кред,%Деп' NO-UNDO.

   DEF BUFFER xloan      FOR loan.
   DEF BUFFER xloan-acct FOR loan-acct.
   DEF BUFFER xsigns     FOR signs.
   DEF BUFFER xloan-cond FOR loan-cond.
   DEF BUFFER xacct      FOR acct.
   
   DEFINE BUFFER term-obl FOR term-obl.
   DEFINE BUFFER comm-rate FOR comm-rate.
   DEFINE BUFFER loan-acct FOR loan-acct.
   
   RUN XAttrAll IN h_xclass (in-class,OUTPUT TABLE xattrid  ).
   RUN get_mand_xattr (in-class,OUTPUT str-dop-par).
   acct-type = GetXattrInit(in-class,"main-loan-acct").
   /*если изменение договора*/
   IF rid <> 0 THEN DO :

     CREATE tloan.
     CREATE tloan-cond.
     CREATE tloan-acct.

     FIND xloan WHERE RECID(xloan) = rid NO-LOCK NO-ERROR.
     IF NOT AVAIL xloan THEN RETURN.

     RUN RE_CLIENT(xloan.cust-cat,xloan.cust-id,INPUT-OUTPUT tloan.client-name).

     BUFFER-COPY xloan TO tloan.

     FIND LAST xloan-acct OF xloan WHERE
               xloan-acct.acct-type = acct-type
           AND xloan-acct.since    <= xloan.since NO-LOCK NO-ERROR.

     IF AVAIL xloan-acct THEN
       tloan.acct = xloan-acct.acct.

     FOR EACH xsigns WHERE
              xsigns.FILE-NAME = 'loan'
          AND xsigns.surrogate = xloan.contract + ',' + xloan.cont-code
     NO-LOCK:
       CREATE tloan-signs.
       ASSIGN
          tloan-signs.contract   = xloan.contract
          tloan-signs.cont-code  = xloan.cont-code
          tloan-signs.CODE       = xsigns.CODE
          tloan-signs.code-val   = IF xsigns.code-value <> "" THEN
                                      xsigns.code-value
                                   ELSE
                                      xsigns.xattr-value
          .
     END.
     FIND LAST xloan-cond WHERE
               xloan-cond.contract  = xloan.contract
           AND xloan-cond.cont-code = xloan.cont-code
           AND xloan-cond.since    LE xloan.since NO-LOCK NO-ERROR.
     IF AVAIL xloan-cond THEN DO:
        BUFFER-COPY xloan-cond TO tloan-cond.
        FIND LAST term-obl  WHERE
                  term-obl.contract  = xloan.contract
              AND term-obl.cont-code = xloan.cont-code
              AND term-obl.end-date LE xloan-cond.since
              AND term-obl.idnt      = 2 NO-LOCK NO-ERROR.
        IF NOT AVAIL term-obl
        THEN
          FIND FIRST term-obl  WHERE
                     term-obl.contract  = xloan.contract
                 AND term-obl.cont-code = xloan.cont-code
                 AND term-obl.idnt      = 2 NO-LOCK NO-ERROR.
       IF AVAIL term-obl THEN
          ASSIGN
             tloan-cond.amt-cur = term-obl.amt.
       FIND LAST  comm-rate WHERE
                  comm-rate.commi    EQ lrate[lr-st]
              AND comm-rate.kau      EQ xloan.contract + "," + xloan.cont-code
              AND comm-rate.currency EQ xloan.currency
              AND comm-rate.acct     EQ "0"
              AND comm-rate.since    LE xloan-cond.since  NO-LOCK NO-ERROR.

       IF AVAIL comm-rate THEN
         ASSIGN
           tloan-cond.rcommi = comm-rate.rate-comm.
     END.
      FIND FIRST loan-acct WHERE
                 loan-acct.contract  = xloan.contract
             AND loan-acct.cont-code = xloan.cont-code
             AND loan-acct.acct-type = "КредРасч"
             AND loan-acct.currency  = xloan.currency
             AND loan-acct.since    >= xloan.open-date NO-LOCK NO-ERROR.
      IF AVAIL loan-acct THEN
        FIND FIRST xacct WHERE
                   xacct.acct     = loan-acct.acct
               AND xacct.currency = loan-acct.currency
               AND xacct.cust-cat = xloan.cust-cat
               AND xacct.cust-id  = xloan.cust-id NO-LOCK NO-ERROR.
      IF AVAIL xacct THEN
        BUFFER-COPY loan-acct TO tloan-acct.
      ELSE DO:
        CREATE tloan-acct.
        ASSIGN
           tloan-acct.contract  = tloan.contract
           tloan-acct.cont-code = tloan.cont-code
           tloan-acct.acct-type = "КредРасч"
           tloan-acct.since     = tloan.open-date
           tloan-acct.currency  = tloan.currency
           .
      END.
    END.
    /*если создание договора*/
    ELSE DO :
      CREATE tloan.
      ASSIGN
        tloan.branch-id = GetUserBranchId(USERID("bisquit"))
        tloan.class-code = in-class
        tloan.cont-code  = '?'
        tloan.user-id    =  USERID('bisquit')
        tloan.cust-cat   = 'Ю'
        tloan.filial-id  = dept.branch
        tloan.doc-ref    = tloan.cont-code
        .
      DO i = 1 TO NUM-ENTRIES(str-par) :

        codval = GetXattrInit(in-class,ENTRY(i,str-par)).

         CASE ENTRY(i,str-par) :
             WHEN 'loan-status' THEN ASSIGN tloan.loan-status = codval.
             WHEN 'cont-type'   THEN ASSIGN tloan.cont-type   = codval.
             WHEN 'contract'    THEN ASSIGN tloan.contract    = codval.
         END CASE .

      END.

      DO i = 1 TO NUM-ENTRIES(str-dop-par) :
         
         codval = GetXattrInit(in-class,ENTRY(i,str-dop-par)).
         IF codval <> ? THEN
         DO:
            CREATE tloan-signs.
            ASSIGN
               tloan-signs.contract   =  tloan.contract
               tloan-signs.cont-code  =  tloan.cont-code
               tloan-signs.CODE       =  ENTRY(i,str-dop-par)
               tloan-signs.code-val   =  codval
            .
         END.
      END.

      CREATE tloan-acct.
      ASSIGN
        tloan-acct.contract  = tloan.contract
        tloan-acct.cont-code = tloan.cont-code
        tloan-acct.acct-type = "КредРасч"
        tloan-acct.since     = tloan.open-date
        .
    END.
    IF rid = 0 OR NOT AVAIL xloan-cond THEN DO :
        CREATE tloan-cond.
        ASSIGN
          tloan-cond.contract      = tloan.contract
          tloan-cond.cont-code     = tloan.cont-code
          tloan-cond.since         = tloan.open-date
          .

        IF rid <> 0  THEN
          ASSIGN
            tloan-cond.int-period = ?
            tloan-cond.int-date   = ?
            .

         tloan-cond.disch-type = INT64(GetXattrInit('loan-cond','disch-type')).
         IF tloan-cond.disch-type = ? THEN tloan-cond.disch-type = 1.
         tloan-cond.delay  = IF  INT64(GetXattrInit(in-class, "delay")) <> ?
                             THEN INT64(GetXattrInit(in-class, "delay"))
                             ELSE tloan-cond.delay .
         tloan-cond.delay1  = IF  INT64(GetXattrInit(in-class, "delay1"))
<>
?
                    THEN INT64(GetXattrInit(in-class, "delay1"))
                    ELSE tloan-cond.delay1 .

    END.
    fl = 0 .    
END PROCEDURE .

/*}}}*/

/*{{{ cr_loan_with_tab: coздание договора */
PROCEDURE cr_loan_with_tab.
   DEF OUTPUT PARAM rid AS RECID INIT 0  NO-UNDO. /*ук-тель на договор*/
   DEF OUTPUT PARAM fl  AS INT64   INIT -1 NO-UNDO. /*флаг успешности операции*/
   
   DEFINE BUFFER loan FOR loan.
   DEFINE BUFFER comm-rate FOR comm-rate.
   
   FIND FIRST tloan  NO-ERROR.
   IF NOT AVAIL tloan THEN RETURN.
   
   cr_loan:
   DO TRANSACTION ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE :


      /*mitr: 20-3-2006 - вычисление поля doc-ref */
      DEFINE VARIABLE vDoc-ref LIKE loan.doc-ref NO-UNDO . 
      tloan.doc-ref = delFilFromLoan(tloan.cont-code) . 

      CREATE  loan .
      ASSIGN
         loan.contract = tloan.contract
         loan.cont-code = tloan.cont-code 
       
         loan.filial-id = tloan.filial-id
         loan.doc-ref   = tloan.doc-ref
         
       NO-ERROR.
       
       IF ERROR-STATUS:ERROR THEN DO :          
          MESSAGE 'Договор с таким номером уже существует' VIEW-AS ALERT-BOX ERROR.
          fl = -2 .
          UNDO cr_loan, RETURN .
       END.
       BUFFER-COPY tloan 
         EXCEPT contract cont-code acct client-name filial-id doc-ref 
         TO loan.
         
       ASSIGN
          loan.since = loan.open-date
          rid        = RECID(loan)
          .
      
       IF INDEX (loan.cont-code," ") = 0 THEN
       DO:
          CREATE comm-rate.
          ASSIGN
             comm-rate.commission = "%Рез"
             comm-rate.acct       = "0"
             comm-rate.currency   = loan.currency
             comm-rate.kau        = loan.contract + "," + loan.cont-code
             comm-rate.MIN-VALUE  = 0.0
             comm-rate.period     = 0
             comm-rate.since      = loan.open-date
             comm-rate.rate-fixed = NO
             comm-rate.rate-comm  = tloan.risk
             .
       END.
       
       /*4-2-2006 mitr*/
       RELEASE loan.
       RELEASE comm-rate.
   END.
   fl = 0 .
   
END PROCEDURE .
/*}}}*/

/*{{{ cr_loan-cond_with_tab: создание условий договора по временной таблице*/
PROCEDURE cr_loan-cond_with_tab.
     DEF OUTPUT PARAM rid AS RECID       NO-UNDO . /*ук-тель на договор*/
     DEF OUTPUT PARAM fl  AS INT64 INIT -1 NO-UNDO . /*флаг успешности операции*/

     DEFINE BUFFER loan-cond  FOR loan-cond.
     DEFINE BUFFER bloan-cond FOR loan-cond.
     
     DEF VAR in-commi   AS CHAR NO-UNDO .
     DEF VAR acct-type  AS CHAR NO-UNDO .
     DEF VAR end_date   AS DATE NO-UNDO .
     DEF VAR mClassCode AS CHAR NO-UNDO.
     DEF VAR vCondSur   AS CHAR NO-UNDO.
     DEF VAR vbCondSur  AS CHAR NO-UNDO.

     DEF VAR oAArray    AS TAArray   NO-UNDO.
     DEF VAR key1       AS CHARACTER NO-UNDO.
     DEF VAR value1     AS CHARACTER NO-UNDO.

     FIND FIRST tloan NO-ERROR.
     IF NOT AVAIL tloan THEN RETURN .

     IF tloan.contract = 'Кредит'
     THEN lr-st = 1.
     ELSE lr-st = ({&lrate-dim} / 2) + 1.

     in-commi = lrate[lr-st] .

     FIND FIRST tloan-cond WHERE
                tloan-cond.contract  = tloan.contract
            AND tloan-cond.cont-code = tloan.cont-code NO-ERROR.
     IF NOT AVAIL tloan-cond THEN RETURN .

     FIND FIRST xattrid NO-ERROR.
     IF NOT AVAIL xattrid THEN
              RUN XAttrAll IN h_xclass (tloan.class-code, OUTPUT TABLE xattrid) .

     acct-type = GetXattrInit(tloan.class-code,'main-loan-acct').
     mClassCode = GetXattrEx(tloan.class-code,"loan-cond","domain-code").
     IF NOT {assigned mClassCode} THEN RETURN .

     /****************************************
      * Находим охватывающий договор,        *
      * и копируем с него недостающие рекв.  *
      ****************************************/

     /**************************
      *
      * Находим последнее условие по договору
      *
      **************************/
     FIND LAST bloan-cond WHERE bloan-cond.contract  EQ tloan.contract
                                AND bloan-cond.cont-code EQ ENTRY(1,tloan.cont-code," ")
     NO-LOCK NO-ERROR.


     cr_cond:
     DO TRANSACTION ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE :

       CREATE loan-cond .
       ASSIGN
           loan-cond.class-code   = mClassCode
           loan-cond.contract     = tloan-cond.contract
           loan-cond.cont-code    = tloan.cont-code
           loan-cond.since        = tloan.open-date 
           loan-cond.delay        = bloan-cond.delay
           loan-cond.delay1       = bloan-cond.delay1      
           loan-cond.int-date     = bloan-cond.int-date
           loan-cond.cred-date    = bloan-cond.cred-date
           loan-cond.int-period   = bloan-cond.int-period
	   loan-cond.cred-period  = bloan-cond.cred-period
	   loan-cond.disch-type   = 1
       .
       IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE 'Ошибка при создании  условий - условие на дату ' + STRING(tloan-cond.since) + ' уже существует' VIEW-AS ALERT-BOX ERROR.
          UNDO cr_cond, RETURN.
       END.
       /* Копируем из временной таблицы в реальную */
/*       BUFFER-COPY tloan-cond EXCEPT contract cont-code since TO loan-cond .*/
       /* Досоздаем доп.реквизиты. */ 

       IF AVAIL bloan-cond THEN
       DO:
          ASSIGN
             vbcondSur = GetSurrogateBuffer("loan-cond",(BUFFER bloan-cond:HANDLE))
             vCondSur  = GetSurrogateBuffer("loan-cond",(BUFFER loan-cond:HANDLE))
          .
          
          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "КолЛьгтПер",
                                    GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "КолЛьгтПер"),?).

          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "КолЛьгтПерПрц",
                       GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "КолЛьгтПерПрц"),?).

          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "cred-mode",
                      GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "cred-mode"),?).
          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "int-mode",
                      GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "int-mode"),?).
          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "cred-curr-next",
                      GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "cred-curr-next"),?).
          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "int-curr-next",
                      GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "int-curr-next"),?).
          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "cred-work-calend",
                      GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "cred-work-calend"),?).
          UpdateSigns(loan-cond.class-code,
                      vCondSur,
                      "int-work-calend",
                      GetXAttrValue("loan-cond",
                                    vbcondSur,
                                    "int-work-calend"),?).
       END.
       /* определение периода действия условий */
       RUN get_period_loan-cond(RECID(loan-cond),OUTPUT end_date) .
       /* создание процентной ставки */

       /************************
        * Здесь производим     *
        * наследование ставок. *
        ************************/

       oAArray = getCommRates(RECID(bloan-cond)).

       {foreach oAArray key1 value1}             
	       RUN cr_comm_rate_with_tab(RECID(loan-cond),key1,value1,acct-type,end_date,OUTPUT fl) .
       {endforeach OAArray}   
        DELETE OBJECT oAArray.
       
/*       RUN cr_comm_rate_with_tab(RECID(loan-cond),in-commi,tloan-cond.rcommi,acct-type,end_date,OUTPUT fl) .*/

       IF fl < 0 THEN UNDO cr_cond, RETURN.

       RUN cr_term-obl(RECID(loan-cond),tloan-cond.amt-cur,acct-type,end_date, OUTPUT fl) .
       IF fl < 0 THEN UNDO cr_cond, RETURN .
/**
 *
 * #1053
 * Будем рассчитывать графики
 * в другом месте.
 *
 **
  Маслов Д. А.
  Комментим графики.
       IF tloan-cond.rcommi <> 0 AND tloan-cond.rcommi <> ? THEN DO:
          IF loan-cond.int-period NE "П"  AND tloan.end-date  <> ?
          THEN RUN set-date.p(RECID(loan-cond),RECID(loan),0).
          ELSE RUN set-date.p(RECID(loan-cond),RECID(loan),1).
       END.
*/
     END. /*cr_cond*/
     
     /*4-2-2006 mitr*/
    rid = RECID(loan-cond) .
    
    RELEASE loan-cond.
    
    fl = 0.
     
END PROCEDURE .
/*}}}*/

/*{{{ get_period_loan-cond: получение даты следующего условия договора*/
PROCEDURE get_period_loan-cond.
    DEF INPUT  PARAM rid   AS RECID NO-UNDO. /*ук-тель на условие договора*/
    DEF OUTPUT PARAM date1 AS DATE  NO-UNDO. /*дата следующего условия*/

    DEF BUFFER xloan      FOR loan .
    DEF BUFFER xloan-cond FOR loan-cond .
    define buffer loan-cond for loan-cond.

    FIND loan-cond WHERE RECID(loan-cond) = rid NO-LOCK NO-ERROR .
    IF AVAIL loan-cond THEN
       FIND  xloan WHERE
             xloan.contract  = loan-cond.contract
         AND xloan.cont-code = loan-cond.cont-code  NO-LOCK NO-ERROR .
    IF NOT AVAIL xloan THEN RETURN .

    date1 = IF xloan.end-date <> ? THEN xloan.end-date ELSE 01/01/3000  .

    FIND FIRST xloan-cond WHERE
               xloan-cond.contract  = loan-cond.contract
           AND xloan-cond.cont-code = loan-cond.cont-code
           AND xloan-cond.since    GT loan-cond.since NO-LOCK NO-ERROR.
    IF AVAIL xloan-cond THEN date1 = xloan-cond.since .
END PROCEDURE .
/*}}}*/

/*{{{ cr_comm_rate_with_tab: создание процентных ставок к договору по временной таблице*/
PROCEDURE cr_comm_rate_with_tab  .
    DEF INPUT  PARAM rid       AS RECID NO-UNDO .                 /*ук-тель на условие*/
    DEF INPUT  PARAM in-commi  AS CHAR  NO-UNDO.                  /*код комиссии */
    DEF INPUT  PARAM in-rate   LIKE comm-rate.rate-comm NO-UNDO . /*ставка по комиссии */
    DEF INPUT  PARAM acct-type AS CHAR  NO-UNDO .                 /*роль счета*/
    DEF INPUT  PARAM end_date  AS DATE  NO-UNDO .                 /*дата окончания */
    DEF OUTPUT PARAM fl-o      AS INT64   NO-UNDO .                 /*флаг возврата*/

    DEFINE BUFFER comm-rate FOR comm-rate.
    DEFINE BUFFER loan-cond FOR loan-cond.
    
    DEF VAR dat-t1 AS DATE NO-UNDO .

    DEF BUFFER xloan-cond FOR loan-cond .
    DEF BUFFER xloan      FOR loan .
    DEF BUFFER xcomm-rate FOR comm-rate .

    FIND loan-cond WHERE RECID(loan-cond) = rid NO-LOCK NO-ERROR .
    IF AVAIL loan-cond THEN
       FIND  xloan WHERE
             xloan.contract  = loan-cond.contract
         AND xloan.cont-code = loan-cond.cont-code  NO-LOCK NO-ERROR .
    IF NOT AVAIL xloan THEN RETURN .

    IF NOT AVAIL loan-cond THEN
    DO :
       fl-o = 0 .
       RETURN .
    END.
    cr_commi:
    DO TRANSACTION ON ERROR UNDO, RETURN ON ENDKEY UNDO, RETURN :

      FIND LAST xcomm-rate WHERE
                xcomm-rate.commi    = in-commi
            AND xcomm-rate.currency = xloan.currency
            AND xcomm-rate.acct     = "0"
            AND xcomm-rate.kau      = xloan.contract + "," + xloan.cont-code
            AND xcomm-rate.since   >= loan-cond.since
            AND xcomm-rate.since   <= end_date
         NO-LOCK NO-ERROR.
      IF NOT AVAIL xcomm-rate THEN
      DO :
         CREATE comm-rate.
         ASSIGN
            comm-rate.commi      =  in-commi
            comm-rate.currency   =  xloan.currency
            comm-rate.acct       =  "0"
            comm-rate.rate-comm  =  in-rate
            comm-rate.kau        =  xloan.contract + "," + xloan.cont-code
            comm-rate.since      =  loan-cond.since NO-ERROR.
         IF ERROR-STATUS:ERROR THEN UNDO cr_commi, RETURN .
      END.
         
      /*4-2-2006 mitr*/   
      RELEASE comm-rate.
    END.
    fl-o = 0 .
END PROCEDURE .
/*}}}*/

/*{{{  CrTermObl: создание планового платежа для транша */
PROCEDURE CrTermObl .
    DEF INPUT PARAM iContract AS CHAR    NO-UNDO.
    DEF INPUT PARAM iContCode AS CHAR    NO-UNDO.
    DEF INPUT PARAM iSince    AS DATE    NO-UNDO.
    DEF INPUT PARAM iNum      AS INT64     NO-UNDO.
    DEF INPUT PARAM iCurrency AS CHAR    NO-UNDO.
    DEF INPUT PARAM iSumm     AS DECIMAL NO-UNDO .
    DEF INPUT PARAM iFSince    AS DATE    NO-UNDO.
    
    DEFINE BUFFER term-obl FOR term-obl.
    
   cr_ter :
   DO TRANSACTION ON ERROR UNDO, RETURN ON ENDKEY UNDO, RETURN :
        FIND FIRST term-obl WHERE
               term-obl.contract      = iContract
               AND term-obl.cont-code = iContCode
               AND term-obl.idnt      = iNum
               AND term-obl.end-date  = iSince
               AND term-obl.acct      = "0"
           NO-ERROR.
        IF NOT AVAIL term-obl THEN
        DO:
           CREATE term-obl.
           ASSIGN
              term-obl.contract   =  iContract
              term-obl.cont-code  =  iContCode
              term-obl.end-date   =  iSince
              term-obl.nn         =  1
              term-obl.idnt       =  iNum
              term-obl.acct       =  "0"
              term-obl.dsc-beg-date = iSince
              .
        END.
        IF term-obl.amt <> iSumm THEN
          ASSIGN
             term-obl.amt =  iSumm .
       IF iNum = 3
       THEN
          ASSIGN
            term-obl.currency = iCurrency
            term-obl.fop-date = iFSince .
  END.
  /*mitr: 4-2-2006*/
  RELEASE term-obl. /*если будет ошибка, то уйдет на верх, т.к. в 
  данной процедуре нет выходного параметра для передачи факта возникновения 
  ошибок в вызывающую процедуру*/
END PROCEDURE .
/*}}}*/

/*{{{ cr_term-obl: создание обязательств*/
PROCEDURE cr_term-obl .
    DEF INPUT  PARAM rid        AS RECID              NO-UNDO . /*ук-тель на условие*/
    DEF INPUT  PARAM in-amt-cur LIKE op-entry.amt-cur NO-UNDO . /*валюта*/
    DEF INPUT  PARAM acct-type  AS CHAR               NO-UNDO . /*роль счета*/
    DEF INPUT  PARAM end_date   AS DATE               NO-UNDO . /*дата следующего условия*/
    DEF OUTPUT PARAM fl-o       AS INT64 INIT -1        NO-UNDO . /*флаг возврата*/

    DEF BUFFER xloan-cond FOR loan-cond .
    DEF BUFFER loan       FOR loan .

    DEFINE BUFFER loan-cond FOR loan-cond.
    
    FIND loan-cond WHERE RECID(loan-cond) = rid NO-LOCK NO-ERROR .
    IF AVAIL loan-cond THEN
      FIND FIRST loan WHERE
                 loan.contract  = loan-cond.contract
             AND loan.cont-code = loan-cond.cont-code NO-LOCK NO-ERROR .
    IF NOT AVAIL loan THEN RETURN.


    IF NOT AVAIL loan-cond THEN DO:
       fl-o = 0 .
       RETURN .
    END.
    cr_term :
      DO TRANSACTION ON ERROR UNDO, RETURN ON ENDKEY UNDO, RETURN :
        RUN CrTermObl(loan.contract,loan.cont-code,loan-cond.since,2,loan.currency,in-amt-cur,loan-cond.since) .
        IF loan.end-date <> ? AND loan-cond.cred-period = 'П' THEN DO :
           RUN CrTermObl(loan.contract,loan.cont-code,loan.end-date,3,loan.currency,in-amt-cur,loan-cond.since) .
           RUN CrTermObl(loan.contract,loan.cont-code,loan.end-date,2,loan.currency,0.0,loan-cond.since) .
        END.
      END.
      fl-o =0 .
END PROCEDURE .
/*}}}*/

/*{{{ cr_main_loan-acct: создание основного счета с ролью Кредит*/
PROCEDURE cr_main_loan-acct.
   DEF OUTPUT PARAM rid  AS RECID       NO-UNDO. /* Ук-тель на loan-acct */
   DEF OUTPUT PARAM vfl  AS INT64 INIT -1 NO-UNDO. /* Флаг возврата */
                               
   DEF VAR acct-type     AS CHAR  NO-UNDO.
   DEF VAR en-kau        AS LOG   NO-UNDO.
   DEF VAR answer        AS LOG   NO-UNDO.
   DEF VAR mes_1         AS CHAR  NO-UNDO.
   DEF VAR mes_2         AS CHAR  NO-UNDO.
   DEF VAR ip-recid      AS RECID NO-UNDO.
   DEF VAR dop-acct-type AS CHAR  NO-UNDO.
   DEF VAR vLockStr      AS CHAR  NO-UNDO.
   DEF VAR i             AS INT64   NO-UNDO.
   
   DEFINE BUFFER loan-acct  FOR loan-acct.
   DEFINE BUFFER gloan-acct FOR loan-acct.
   DEFINE BUFFER gloan      FOR loan.
   DEFINE BUFFER acct       FOR acct.
   
   FIND FIRST tloan NO-ERROR.
   IF NOT AVAIL tloan THEN 
      RETURN.

   FIND FIRST gloan WHERE gloan.contract  EQ tloan.contract
                      AND gloan.cont-code EQ ENTRY(1,tloan.cont-code," ")
   NO-LOCK NO-ERROR.
   
   IF tloan.acct = ? OR tloan.acct = '' THEN 
   DO:
      vfl = 0.
      RETURN.
   END.
   
   ASSIGN
      acct-type     = GetXattrInit(tloan.class-code,"main-loan-acct")
      dop-acct-type = GetXattrInit(gloan.class-code,"acct-type-list")
   .
   
   IF acct-type = ? OR acct-type = '' THEN 
   DO:
      vfl = 0.
      RETURN.
   END.

   cr_acct:
   DO TRANSACTION ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE:
      CREATE loan-acct.
      ASSIGN
          loan-acct.contract    = tloan.contract
          loan-acct.cont-code   = tloan.cont-code
          loan-acct.acct        = tloan.acct
          loan-acct.currency    = tloan.currency
          loan-acct.acct-type   = acct-type
          loan-acct.since       = tloan.open-date
          rid                   = RECID(loan-acct)
      NO-ERROR.

      IF ERROR-STATUS:ERROR THEN 
      DO:
         vfl = 0.
         UNDO cr_acct, LEAVE cr_acct.
      END.

      /*ищем счет*/
      FIND FIRST acct WHERE
                 acct.acct     EQ tloan.acct
             AND acct.currency EQ tloan.currency
      NO-LOCK NO-ERROR.

      /*если счета нет в справочнике, то выходим*/
      IF NOT AVAILABLE acct THEN DO:
         MESSAGE "Счет " + tloan.acct + " не найден!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         vfl = 0 .
         UNDO cr_acct, LEAVE cr_acct.
      END.

      ASSIGN
         en-kau   = (FGetSetting("КауСч",?,"") = "Да")
         mes_1    = 'Счет ' + acct.acct +  ' редактирует другой пользователь.'
         mes_2    = 'Подождите пожалуйста (Да) или отмените операцию (Нет)'
         ip-recid = RECID(acct)
      .

      /*если у счета уже есть аналитика, то выходим*/
      IF acct.kau-id <> ? AND acct.kau-id <> "" THEN 
      DO:
         RELEASE loan-acct.
         vfl = 0.
         LEAVE cr_acct.
      END.

      RELEASE acct.
      /*счет ставим на аналитику по договорам*/
      FIND FIRST acct WHERE
                 acct.acct     EQ tloan.acct
             AND acct.currency EQ tloan.currency
      EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
      IF LOCKED acct THEN DO:
         vLockStr = mes_1 + "~n" + mes_2.
         IF WhoLocks2(ip-recid,
                     "acct",
                     INPUT-OUTPUT vLockStr) THEN
            MESSAGE vLockStr
               VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
         IF answer = NO
         THEN DO:
            vfl = - 2.
            UNDO cr_acct, LEAVE cr_acct.
         END.
      END.

      PUT SCREEN COL 1 ROW SCREEN-LINES + MESSAGE-LINES + 1
                                COLOR BRIGHT-BLINK-NORMAL "Ждите...".
      DO WHILE LOCKED acct :
         FIND FIRST acct WHERE
                    acct.acct     EQ tloan.acct
                AND acct.currency EQ tloan.currency EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
      END.

      IF AVAIL acct THEN 
      DO:
          IF en-kau THEN 
             acct.kau-id = "АналДог".
      END.     
   END.
   
   RELEASE loan-acct. /* т.к. мы в персистентной процедуры, 
                      ** надо освободить буффер "по умолчанию" */   
   
   /* Теперь привяжем доп.указанные счета к 
   ** траншам (уже без постановки на аналитику и т.д.) */
   IF {assigned dop-acct-type} THEN
   dops:
   DO TRANSACTION i = 1 TO NUM-ENTRIES(dop-acct-type)
      ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE:

      FIND LAST gloan-acct  WHERE gloan-acct.contract  EQ gloan.contract
                              AND gloan-acct.cont-code EQ gloan.cont-code
                              AND gloan-acct.acct-type EQ ENTRY(i,dop-acct-type)
                              AND gloan-acct.since     LE tloan.open-date
      NO-LOCK NO-ERROR.
      
      IF NOT AVAIL gloan-acct THEN
         NEXT dops.
      
      IF CAN-FIND (FIRST loan-acct WHERE loan-acct.contract  EQ tloan.contract
                                     AND loan-acct.cont-code EQ tloan.cont-code 
                                     AND loan-acct.acct-type EQ ENTRY(i,dop-acct-type)) THEN
         NEXT dops.

      CREATE loan-acct.
      ASSIGN
          loan-acct.contract    = tloan.contract
          loan-acct.cont-code   = tloan.cont-code
          loan-acct.acct        = gloan-acct.acct
          loan-acct.currency    = gloan-acct.currency
          loan-acct.acct-type   = gloan-acct.acct-type
          loan-acct.since       = tloan.open-date
          rid                   = RECID(loan-acct)
      NO-ERROR.
      
      IF ERROR-STATUS:ERROR THEN 
      DO:
         vfl = 0.
         UNDO dops, RETURN.
      END.

      /*ищем счет*/
      FIND FIRST acct WHERE
                 acct.acct     EQ gloan-acct.acct
             AND acct.currency EQ gloan-acct.currency
      NO-LOCK NO-ERROR.

      /*если счета нет в справочнике, то выходим*/
      IF NOT AVAILABLE acct THEN 
      DO:
         MESSAGE "Счет " + gloan-acct.acct + " не найден!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
         vfl = 0.
         UNDO dops, RETURN.
      END.
   END.

   vfl = 0.

END PROCEDURE.
/*}}}*/

/*{{{ cr_signs: создание признаков*/
PROCEDURE cr_signs.
   DEF OUTPUT PARAM fl-o AS INT64 INIT -1 NO-UNDO . /*флаг возврата*/

   DEF VAR out-code AS CHAR NO-UNDO .

   DEF BUFFER xsigns FOR signs.

   FIND FIRST tloan NO-ERROR.
   IF NOT AVAIL tloan THEN RETURN .

   FOR EACH tloan-signs  WHERE
            tloan-signs.contract  = tloan.contract
        AND tloan-signs.cont-code = tloan.cont-code NO-LOCK
   TRANSACTION ON ERROR  UNDO, NEXT
               ON ENDKEY UNDO, RETURN :
       FIND FIRST xattrid NO-ERROR.
       IF NOT AVAIL xattrid THEN
          RUN XAttrAll IN h_xclass (tloan.class-code, OUTPUT TABLE xattrid).

       out-code = GetXAttrValueEx('loan',tloan.contract + ',' + tloan.cont-code,tloan-signs.CODE,"") .

       IF out-code = ? OR out-code <> tloan-signs.code-val THEN DO :
            FIND FIRST xattrid WHERE
                       xattrid.xattr-code = tloan-signs.CODE NO-LOCK NO-ERROR.
            IF AVAIL xattrid THEN
               FIND xattr WHERE
                    xattr.class-code = xattrid.class-code
                AND xattr.xattr-code = xattrid.xattr-code NO-ERROR.
            IF AVAIL xattr THEN DO :
              IF NOT UpdateSigns('loan',tloan.contract + ',' + tloan.cont-code,tloan-signs.CODE,tloan-signs.code-val,xattr.indexed) THEN
                   MESSAGE 'Ошибка при модификации реквизита ' + tloan-signs.CODE + ' договора ' + tloan.cont-code
                        VIEW-AS ALERT-BOX ERROR .
            END.
       END.
   END.
  fl-o = 0 .
END PROCEDURE .
/*}}}*/

/*{{{ upd_loan_with_tab: изменение договора по данным временной таблицы */
PROCEDURE upd_loan_with_tab .
   DEF INPUT  PARAM rid  AS RECID       NO-UNDO . /*ук-тель на договор*/
   DEF OUTPUT PARAM fl-o AS INT64 INIT -1 NO-UNDO . /*флаг возврата*/

   DEFINE BUFFER loan FOR loan.
   
   upd_loan :
       DO TRANSACTION ON ERROR UNDO, RETURN ON ENDKEY UNDO, RETURN :
            FIND loan WHERE  RECID(loan) = rid  EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
            IF NOT AVAIL loan THEN RETURN .
            FIND  tloan WHERE
                  tloan.contract  = loan.contract
              AND tloan.cont-code = loan.cont-code NO-ERROR.
            IF NOT AVAIL tloan THEN RETURN .
            ASSIGN loan.end-date    = tloan.end-date
                   loan.close-date  = tloan.close-date
                   /*loan.gr-riska    = tloan.gr-riska*/
                   loan.cont-type   = tloan.cont-type
                   loan.loan-status = tloan.loan-status
                   loan.user-id     = tloan.user-id
                   .
          /*mitr: 4-2-2006*/
          RELEASE loan. 
                 
       END.
  fl-o = 0 .
END PROCEDURE .
/* }}} */

/*{{{ cr_loan_rasch_acct: создание расчетного счета, если счет уже существует(создан транзакцией), то изменяем  */
PROCEDURE cr_loan_rasch_acct.

  DEF OUTPUT PARAM rid AS RECID       NO-UNDO . /*ук-тель на loan-acct*/
  DEF OUTPUT PARAM fl  AS INT64 INIT -1 NO-UNDO . /*флаг возврата*/

  DEFINE BUFFER loan-acct FOR loan-acct.
  
  FIND FIRST tloan NO-ERROR.
  IF NOT AVAIL tloan THEN RETURN .

  FIND FIRST tloan-acct NO-ERROR.
  IF NOT AVAIL tloan-acct THEN RETURN .

  FIND LAST  loan-acct WHERE
             loan-acct.contract  = tloan.contract
         AND loan-acct.cont-code = tloan.cont-code
         AND loan-acct.acct-type = tloan-acct.acct-type
         /*может и не нужно*/
         AND loan-acct.since    <= tloan-acct.since NO-LOCK NO-ERROR.
  /*если счет существует, то изменяем*/
  IF AVAILABLE loan-acct THEN DO TRANSACTION:
    FIND CURRENT loan-acct EXCLUSIVE NO-WAIT NO-ERROR.
    IF LOCKED loan-acct THEN DO:
      /*потом придумаю чего-нибудь получше*/
      MESSAGE "Со счетом работает другой пользователь!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      fl = 0.
      RETURN.
    END.
    ELSE DO:
      cr_acct:
      DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
        ASSIGN
          loan-acct.acct        = tloan-acct.acct
          loan-acct.currency    = tloan-acct.currency
          loan-acct.acct-type   = tloan-acct.acct-type
          loan-acct.since       = tloan-acct.since
          rid                   = RECID(loan-acct)
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          fl = 0 .
          UNDO cr_acct, RETURN .
        END.
      END.
    END.
  END.
  ELSE DO:
     cr_acct:
     DO ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE :
          CREATE loan-acct.
          ASSIGN
            loan-acct.contract    = tloan.contract
            loan-acct.cont-code   = tloan.cont-code
            loan-acct.acct        = tloan-acct.acct
            loan-acct.currency    = tloan-acct.currency
            loan-acct.acct-type   = tloan-acct.acct-type
            loan-acct.since       = tloan-acct.since
            rid                   = RECID(loan-acct)
          NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
             fl = 0 .
             UNDO cr_acct, RETURN .
          END.
     END.
  END.
  /*mitr: 4-2-2006*/
  RELEASE loan-acct.
  fl = 0 .
END PROCEDURE .
/* }}} */

/*{{{ cr_loan-cond_with_tab: создание нескольких условий договора по временной таблице*/
PROCEDURE cr_multi_loan-cond_with_tab.
     DEF INPUT  PARAM iSurr AS CHARACTER   NO-UNDO.  /* суррогат охватывающего договора */
     DEF OUTPUT PARAM rid   AS RECID       NO-UNDO . /*ук-тель на договор*/
     DEF OUTPUT PARAM fl    AS INT64 INIT -1 NO-UNDO . /*флаг успешности операции*/

     DEFINE BUFFER loan-cond FOR loan-cond.
     DEFINE BUFFER bcomm-rate FOR comm-rate.
     DEFINE BUFFER bloan-cond FOR loan-cond.
     
     DEF VAR in-commi   AS CHAR NO-UNDO .
     DEF VAR acct-type  AS CHAR NO-UNDO .
     DEF VAR end_date   AS DATE NO-UNDO .
     DEF VAR mClassCode AS CHAR NO-UNDO.
     DEF VAR vCondSur   AS CHAR NO-UNDO.
     DEF VAR vbCondSur  AS CHAR NO-UNDO.

     FIND FIRST tloan NO-ERROR.
     IF NOT AVAIL tloan THEN RETURN .

     IF tloan.contract = 'Кредит'
     THEN lr-st = 1.
     ELSE lr-st = ({&lrate-dim} / 2) + 1.

     in-commi = lrate[lr-st] .

     FIND FIRST xattrid NO-ERROR.
     IF NOT AVAIL xattrid THEN
              RUN XAttrAll IN h_xclass (tloan.class-code, OUTPUT TABLE xattrid) .

     ASSIGN
        acct-type = GetXattrInit(tloan.class-code,'main-loan-acct')
        end_date = IF tloan.end-date <> ? THEN tloan.end-date ELSE DATE("01/01/3000").
     
     cr_cond:
     DO TRANSACTION ON ERROR UNDO , LEAVE ON ENDKEY UNDO, LEAVE :

        FOR EACH tloan-cond:
           FIND FIRST bloan-cond WHERE bloan-cond.contract  EQ tloan.contract
                                   AND bloan-cond.cont-code EQ ENTRY(1,tloan.cont-code," ")
           NO-LOCK NO-ERROR.
           /* Дозаполняем поля условий */
           ASSIGN
              tloan-cond.delay      = bloan-cond.delay
              tloan-cond.delay1     = bloan-cond.delay1      
              tloan-cond.int-date   = bloan-cond.int-date
              tloan-cond.cred-date  = bloan-cond.cred-date
           NO-ERROR.
           CREATE loan-cond .
           BUFFER-COPY tloan-cond TO loan-cond .
           /* Досоздаем доп.реквизиты */
           IF AVAIL bloan-cond THEN
           DO:
              ASSIGN
                 vbcondSur = GetSurrogateBuffer("loan-cond",(BUFFER bloan-cond:HANDLE))
                 vCondSur  = GetSurrogateBuffer("loan-cond",(BUFFER loan-cond:HANDLE))
              .
          
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "КолЛьгтПер",
                          "0",?).
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "КолЛьгтПерПрц",
                          "0",?).

              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "cred-mode",
                          GetXAttrValue("loan-cond",
                                        vbcondSur,
                                        "cred-mode"),?).
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "int-mode",
                          GetXAttrValue("loan-cond",
                                        vbcondSur,
                                        "int-mode"),?).
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "cred-curr-next",
                          GetXAttrValue("loan-cond",
                                        vbcondSur,
                                        "cred-curr-next"),?).
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "int-curr-next",
                          GetXAttrValue("loan-cond",
                                        vbcondSur,
                                        "int-curr-next"),?).
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "cred-work-calend",
                          GetXAttrValue("loan-cond",
                                        vbcondSur,
                                        "cred-work-calend"),?).
              UpdateSigns(loan-cond.class-code,
                          vCondSur,
                          "int-work-calend",
                          GetXAttrValue("loan-cond",
                                        vbcondSur,
                                        "int-work-calend"),?).
           END.
              
           /* создание процентной ставки (%кред) */
           RUN cr_comm_rate_with_tab(RECID(loan-cond),
                                     in-commi,
                                     tloan-cond.rcommi,
                                     acct-type,
                                     end_date,
                                     OUTPUT fl) .
           IF fl < 0 THEN UNDO cr_cond, RETURN.

           /*  копирование всех остальных ставок */
           FOR EACH  bcomm-rate WHERE
                     bcomm-rate.kau      EQ iSurr                 
                 AND bcomm-rate.acct     EQ "0" 
                 AND bcomm-rate.since    LE loan-cond.since NO-LOCK
               BY bcomm-rate.since DESCENDING :
              IF bcomm-rate.commi NE "%Грейс" AND 
                 bcomm-rate.commi NE in-commi 
                  THEN DO:
                  RUN cr_comm_rate_with_tab(RECID(loan-cond),
                                            bcomm-rate.commission,
                                            bcomm-rate.rate-comm,
                                            "",
                                            end_date,
                                            OUTPUT fl) .

              END.
               .
           END.
    
           RUN cr_term-obl(RECID(loan-cond),tloan-cond.amt-cur,acct-type,end_date, OUTPUT fl) .
           IF fl < 0 THEN UNDO cr_cond, RETURN .   

        END.
       
     END. /*cr_cond*/
     
     /*4-2-2006 mitr*/
    rid = RECID(loan-cond) .
    
    RELEASE loan-cond.
    
    fl = 0.
     
END PROCEDURE .
/*}}}*/
