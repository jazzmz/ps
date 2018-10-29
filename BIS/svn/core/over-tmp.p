/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2002 ТОО "Банковские информационные системы"
     Filename: OVER-TMP.P
      Comment: Обработка выбранных по фильтру договоров и формирование нового
               списка из течений овердрафтных договоров
   Parameters:
      Used by:
      Created: Илюха, где-то 28.06.2002
     Modified: Илюха 02.07.2002
     Modified: Илюха 11.07.2002
     Modified: Илюха 04.03.2003 - Период создается только для l_agr_with_per
     Modified: Om    14.03.2003 - Течение (период кредитования) создается
                                  с группой риска равной группе риска 
                                  охватывающего договора.
     Modified: JADV  18.09.2007 (32295) - Проверка на дублирование договора.                                  
*/
{globals.i}
{svarloan.def}
{loan-def.i}
{pick-val.i}
{flt-file.i} /* Объявление фильтра по договорам */
{l-table.def new}
{sh-defs.i}
{all_note.def} /* Таблица с recid, выбранных по фильтру записей Shared */
{flt_var.def}
{over-def.def} /* описание таблицы over-error */
{loan.pro}     /* DS - Работа с полями таблицы loan. */
{mf-loan.i}

{intrface.get xclass}
{tloan.pro}
{intrface.get loan}
{intrface.get ovl}
{intrface.get op}
{intrface.get i254}     /*Библиотека функций для вычисления показателей, связанных
                        **с расчетом резерва по ссудам (Инструкция 254-П)*/
{intrface.get bag}
{intrface.get blkob}

DEF INPUT PARAM oprid AS RECID NO-UNDO.

DEF VAR mClasses    AS CHAR    NO-UNDO.
DEF VAR mMess       AS CHAR    NO-UNDO.
DEF VAR mCounter    AS INT64     NO-UNDO.
DEF VAR mLimitSumm  AS DECIMAL NO-UNDO.
DEF VAR mTotalRecs  AS INT64     NO-UNDO. /* Для progress bar */
DEF VAR mFlagError  AS INT64 INIT -1 NO-UNDO.
DEF VAR mCondRid    AS RECID NO-UNDO.
DEF VAR mAcctRid    AS RECID NO-UNDO.
DEF VAR mLoanRid    AS RECID NO-UNDO.
DEF VAR mTranRid    AS RECID NO-UNDO .
DEF VAR lim-pos     LIKE op-entry.amt-rub NO-UNDO.
DEF VAR mAmntOpr    AS DEC   NO-UNDO. /* Сумма операции */
DEF VAR mBlockedSm  AS DEC   NO-UNDO. /* Блокированная сумма по счету */
DEF VAR vubxattr    AS CHAR  NO-UNDO. /* Значение дополнительного реквизита UniformBag */
DEF VAR mResult     AS CHAR  NO-UNDO. /* для получения результата впроцедуре SetLinkPos */
DEF VAR mNewCondSum AS DEC   NO-UNDO. /* Новая сумма течения (при ДР OverUpCond =Да) */
DEF VAR vOffSet     AS CHAR  NO-UNDO.
DEF VAR vMove       AS INT64   NO-UNDO.
DEF VAR vPar19      AS DEC   NO-UNDO. /* Остаток на 19ом параметре */
DEF VAR vStndrtPar1 AS DEC   NO-UNDO. /* Затычка для вызова stndrt_param */
DEF VAR vStndrtPar2 AS DEC   NO-UNDO. /* Затычка для вызова stndrt_param */
DEF VAR mLstDR      AS CHAR  NO-UNDO. /*список наследуемых ДР*/

def var iRes as decimal INIT 0 NO-UNDO.

DEF SHARED TEMP-TABLE over NO-UNDO
 FIELD acct           LIKE acct.acct
 FIELD cur            LIKE acct.currency
 FIELD cont-code-agr  LIKE loan.cont-code
 FIELD agr-class-code LIKE loan.class-code
 FIELD cont-code-per  AS CHAR
 FIELD limit          AS DECIMAL
 FIELD bal            AS DECIMAL
 FIELD overtr         AS LOG INIT NO
 .



DEF BUFFER loan-per   FOR loan.      /* Локализация буфера. */
DEF BUFFER oloan-cond FOR loan-cond. /* Локализация буфера. */
DEF BUFFER oterm-obl  FOR term-obl.  /* Локализация буфера. */
DEF BUFFER tr_loan    FOR loan.      /* Локализация буфера. */
DEF BUFFER xtermobl    FOR term-obl.  /* Локализация буфера. */

/* Commented by JADV: Форвардное описание */
FUNCTION Check-Dog RETURNS LOGICAL (
                                    iAcct     AS CHARACTER,
                                    iTranRid  AS RECID
                                    ) FORWARD. 


 
/*------------------------ MAIN BLOCK ---------------------------------------*/

FIND LAST all_recids NO-ERROR.

IF NOT AVAIL all_recids THEN
DO:
   {intrface.del tloan}
   {intrface.del loan}
   {intrface.del ovl}
   {intrface.del op}
   RETURN.
END.
ELSE
   mTotalRecs = all_recids.count.

{init-bar.i "Секундочку..."}

IF GetSysConf("multiple_loan_filters") <> "YES" THEN DO:
    {empty over_error}
END.

mClasses = FGetSetting("ОверКлассТранз","ОверКлДляГрТранз","").

FOR EACH all_recids, loan WHERE RECID(loan) = all_recids.rid NO-LOCK:


   /* проверка правильности класса договора */
   IF NOT CAN-DO(mClasses, loan.class-code) OR
      loan.contract <> 'Кредит'             THEN
   DO:
      DELETE all_recids.
      NEXT.
   END.

   
   /* проверка наличия расчетного счета */
   RUN get-acct-for-ovr IN h_ovl (RECID(loan),svPlanDate,BUFFER acct).

   IF NOT AVAILABLE acct THEN
   DO:
      DELETE all_recids.
      NEXT.
   END.

   {chktempl.i}

   /* проверка нарушения режима счета */
   lim-pos = GetLimitPosition(BUFFER acct,INPUT svPlanDate).

      /* Получим блокированную по счету сумму */
   IF FGetSetting("УчитБлокО", ?, "") EQ "Да" THEN
      mBlockedSm = GetBlockPosition(acct.acct, acct.currency, "", svPlanDate).
   
   IF GetXattrValueEx("op-kind", op-kind.op-kind, "TranshOpen", "Да") EQ "Да" THEN DO:
      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              svPlanDate,
                              svPlanDate,
                              'К').
   END.
/*Заявка 3969*/
    iRes = 0.
    for each op-entry where op-entry.acct-cr = acct.acct
                     and op-entry.acct-db = "30102810900000000491"    
                     and op-entry.op-status = "К"
                     and op-entry.op-date = svPlanDate
                     NO-LOCK.

    iRes = iRes + op-entry.amt-rub.

    END.

 sh-bal = sh-bal + iRes.
/*конец Заявка 3969*/
      /* Сумма операции */
   mAmntOpr = IF acct.currency EQ "" 
                   THEN sh-bal - lim-pos - mBlockedSm
                   ELSE sh-val - lim-pos - mBlockedSm.

   IF mAmntOpr LE 0 THEN
   DO:
      DELETE all_recids.
      NEXT.
   END.

   set_loan(loan.contract, loan.cont-code).
   
  /*получаем лимит*/
   mLimitSumm = Get_limit(svplandate, OUTPUT mMess).

   /*ругаемся*/
   IF mLimitSumm <= 0 THEN
   DO:
      CREATE over_error.
      ASSIGN
         over_error.acct      = acct.acct
         over_error.cont-code = loan.cont-code
         over_error.DATE      = svPlanDate
         over_error.MES       = "Лимит овердрафта использован полностью"
      .
      DELETE all_recids.
      NEXT.
   END.


   /*проверка на возможность выдачи*/
   RUN chk_get_over IN h_ovl (RECID(acct),
                              svPlanDate,
                              mAmntOpr,
                              NO,
                              OUTPUT mMess,
                              OUTPUT mTranRid,
                              OUTPUT mFlagError)  .
   /* нет возможности выдать кредит */
   IF mFlagError < 0 THEN
   DO :
      CREATE over_error.
      ASSIGN
         over_error.acct      = acct.acct
         over_error.cont-code = loan.cont-code
         over_error.DATE      = svPlanDate
         over_error.MES       = mMess
      .
      DELETE all_recids.
      NEXT.
   END.


   /* Проверка на дублирование договора овердрафта по одному счету */
   IF Check-Dog(INPUT acct.acct, INPUT RECID(loan)) THEN
   DO:
    CREATE over_error.
    ASSIGN
       over_error.acct      = acct.acct
       over_error.cont-code = loan.cont-code
       over_error.DATE      = svPlanDate
       over_error.MES       = "Существует более одного действующего договора об овердрафте по счету. 
                               Обработка остановлена."
    .
    DELETE all_recids.
    NEXT.
   END.


   RELEASE tr_loan.

   IF mTranRid <> ? THEN
      FIND tr_loan WHERE RECID(tr_loan) = mTranRid NO-LOCK NO-ERROR.
    /*создаем период, если нет периода или дата найденного меньше даты опердня,
      и класс договора l_agr_with_per*/
   IF NOT AVAIL tr_loan              OR
     (AVAILABLE tr_loan              AND
      tr_loan.end-date < svPlanDate) THEN
   DO:
      RUN create-per.
      NEXT.
   END.

   /* Если для данного класса допустимо увеличение 
   ** суммы кредита, то увеличиваем */
   IF GetXAttrValueEx ("loan",
                       loan.contract + "," + loan.cont-code,
                       "OverUpCond",
                       GetXAttrInit(loan.class-code,"OverUpCond")) EQ "Да" THEN
   OverUp:
   DO:
      /* Найдем существующее условие по течению */
      FIND LAST oloan-cond WHERE oloan-cond.contract  EQ tr_loan.contract
                             AND oloan-cond.cont-code EQ tr_loan.cont-code
                             AND oloan-cond.since     LE svPlanDate
      NO-LOCK NO-ERROR.
      IF NOT AVAIL oloan-cond THEN
         LEAVE OverUp.

      /* Найдем первый плановый остаток по данному условию */
      FIND FIRST oterm-obl WHERE oterm-obl.contract  EQ oloan-cond.contract
                             AND oterm-obl.cont-code EQ oloan-cond.cont-code
                             AND oterm-obl.idnt      EQ 2
                             AND oterm-obl.end-date  EQ oloan-cond.since
      NO-LOCK NO-ERROR.
      IF NOT AVAIL oterm-obl THEN
         LEAVE OverUp.

      /* Расчитываем новую сумму */
      RUN STNDRT_PARAM IN h_Loan (loan.contract,
                                  loan.cont-code,
                                  19,
                                  svPlanDate,
                                  OUTPUT vPar19,
                                  OUTPUT vStndrtPar1,
                                  OUTPUT vStndrtPar2).

      mNewCondSum = oterm-obl.amt-rub + (IF acct.currency = "" THEN MIN(vPar19,sh-bal - lim-pos)
                                                               ELSE MIN(vPar19,sh-val - lim-pos)).

      /* Проверим, не превышен ли общий лимит по договору, если превышен, то присваиваем максимально
      ** возможную сумму */
      FIND FIRST xtermobl WHERE xtermobl.contract  EQ loan.contract
                            AND xtermobl.cont-code EQ loan.cont-code
                            AND xtermobl.idnt      EQ 2
      NO-LOCK NO-ERROR.
      IF    AVAIL xtermobl 
        AND xtermobl.amt-rub < mNewCondSum THEN
            mNewCondSum = xtermobl.amt-rub.
      /* Обновляем сумму планового остатка по условию транша */
      RUN CrTermObl(tr_loan.contract,
                    tr_loan.cont-code,
                    oterm-obl.end-date,
                    2,
                    tr_loan.currency,
                    mNewCondSum,
                    ?).
      RUN SetSysConf IN h_base ("NoProtocol","YES").
      RUN SetSysconf IN h_base("НЕ ВЫВОДИТЬ ГРАФИКИ НА ЭКРАН","ДА").
      RUN i-ovterm.p(RECID(tr_loan),RECID(oloan-cond),mNewCondSum).
      RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
      RUN DeleteOldDataProtocol IN h_base ("НЕ ВЫВОДИТЬ ГРАФИКИ НА ЭКРАН").
   END.

   CREATE over.
   ASSIGN
      over.acct           = acct.acct       /*счет*/
      over.cur            = acct.currency   /*валюта*/
      over.cont-code-agr  = loan.cont-code  /*номер договора соглашения*/
      over.agr-class-code = loan.class-code /*класс договора*/
      over.limit          = mLimitSumm           /*лимит*/
      over.bal            = mAmntOpr
      over.cont-code-per  = tr_loan.cont-code   /*номер договора  течения*/
      .

   {init-bar.i "Секундочку..."}

   {move-bar.i "all_recids.count" mTotalRecs}

END.

/*сносим все остальные записи*/
{empty all_recids}

/*формируем новый список*/
mCounter = 1.
FOR EACH over:
   FIND FIRST loan WHERE
              loan.contract = "Кредит"
          AND loan.cont-code = over.cont-code-per NO-LOCK NO-ERROR.
   IF AVAILABLE loan THEN
   DO:
      /* Проставляем дополнительный реквизит UniformBag в соответствии с соответствующим ДР */
      IF GetXAttrValueEx("op-kind",op-kind.op-kind,"ЗаполнятьПОС","Нет") EQ "Да" THEN 
      DO:
         vubxattr = LnInBagOnDate(loan.contract,
                                  over.cont-code-agr, 
                                  DATE(GetXAttrValueEx("loan",
                                                       loan.contract + "," + loan.cont-code,
                                                       "ДатаСогл",
                                                       STRING(loan.open-date)
                                                      )
                                      )
                                 ).
         IF vubxattr NE ? THEN
            RUN SetLinkPos(loan.contract,
                           loan.cont-code,
                           vubxattr,
                           DATE(GetXAttrValueEx("loan",
                                                loan.contract + "," + loan.cont-code,
                                                "ДатаСогл",
                                                STRING(loan.open-date)
                                               )
                               ),
                           ?,
                           NO,
                           OUTPUT mResult
                           ). 
      END.

      /* Формируем новый список */
      CREATE all_recids.
      ASSIGN
         all_recids.rid   = RECID(loan)
         all_recids.COUNT = mCounter
         mCounter         = mCounter + 1
         all_recids.overtr   = over.overtr
         .
   END.
END.

{del-bar.i}

{intrface.del tloan}
{intrface.del loan}
{intrface.del ovl}
{intrface.del op}


/*----------------------------------- Internal Procedures -------------------*/
PROCEDURE Create-Per: /* Процедура создания периода кредитования */

DEF VAR vDate     AS DATE  NO-UNDO.
DEF VAR vFicsDate AS CHAR  NO-UNDO.
DEF VAR vDay      AS INT64 NO-UNDO.
DEF VAR vTrList   AS CHAR  NO-UNDO.
DEF VAR vMList    AS CHAR  NO-UNDO.
DEF VAR vMainAcct AS CHAR  NO-UNDO.
DEF VAR vAcctType AS CHAR  NO-UNDO.

DEF BUFFER xloan      FOR loan .
DEF BUFFER xloan-cond FOR loan-cond.
DEF BUFFER xloan-acct FOR loan-acct.  

/* Получаем список классов охватывающих договоров и классов траншей */
vMList = FGetSetting("ОверКлассТранз","КлОхватТранш","").
IF NUM-ENTRIES(vMList,"|") GT 1 THEN
   ASSIGN
      vTrList = ENTRY(2,vMList,"|")
      vMList  = ENTRY(1,vMList,"|").
/* Проверка соответствия настройки списков */
IF NUM-ENTRIES(vTrList) NE NUM-ENTRIES(vMList) THEN RETURN.
/* Проверка класса договора на вхождение в список охватывающих классов */
IF NOT CAN-DO(vMList, loan.class-code) THEN RETURN.

/* Проверка на окончание договора */
IF loan.end-date LT svPlanDate THEN
   RETURN.

DO_LOAN:
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE :

   /* чистим временные таблицы */
   RUN del_table_loan .
   FIND FIRST tloan NO-ERROR.

   RUN create_tloan (ENTRY(LOOKUP(loan.class-code,vMList),vTrList),0,OUTPUT mFlagError).
   FIND FIRST tloan NO-ERROR.

   main-cont-code  = get_loan() .
   IF main-cont-code = ?  OR
      main-cont-code = '' THEN
      main-cont-code = '?'.

   FIND FIRST tloan-cond  WHERE
              tloan-cond.contract  = tloan.contract
          AND tloan-cond.cont-code = tloan.cont-code NO-ERROR.

   IF tloan.contract = 'Депоз' THEN
      tip-dog = 'ТипДогП'.
   ELSE
      tip-dog = 'ТипДогА'.

   ASSIGN
      tloan.cont-code  = get_last_trans(tloan.contract,main-cont-code)
      tloan.close-date = ?
      tloan.open-date  = svPlanDate
      .

   ASSIGN
      tloan.doc-ref = delFilFromLoan(tloan.cont-code)
      .

   /*поиск счёта течения*/
   vMainAcct = ?.
   FIND FIRST xloan WHERE
              xloan.contract  = tloan.contract
          AND xloan.cont-code = main-cont-code NO-LOCK NO-ERROR.

   IF AVAIL xloan THEN
   DO:

      vAcctType = GetXattrInit(xloan.class-code, 'main-loan-acct').

      IF vAcctType = ?  OR
         vAcctType = '' THEN
         vAcctType = tloan.contract.

      FIND LAST xloan-acct OF xloan WHERE
                xloan-acct.acct-type = vAcctType
            AND xloan-acct.since    <= tloan.open-date NO-LOCK NO-ERROR.

      IF AVAIL xloan-acct THEN vMainAcct = xloan-acct.acct.

   END.

   ASSIGN
      client             = get_client_for_main(tloan.contract,main-cont-code)
      tloan.acct         = vMainAcct

      /* Группа риска охватывающего догвора. */
      tloan.gr-riska     = INT64(FGetLoanField (GetLoanRecid (tloan.contract,
                                                            main-cont-code),
                                              "gr-riska"))
      tloan.risk         = dec(FGetLoanField (GetLoanRecid (tloan.contract,
                                                            main-cont-code),
                                              "risk"))
      tloan.currency     = get_main_currency()
      tloan.cust-cat     = ENTRY(1,client)
      tloan.cust-id      = INT64(ENTRY(2,client))
      tloan.client-name  = ENTRY(3,client)
   .

      /*Определение даты окончания транша*/ 
      vFicsDate = GetXattrValueEx("loan",
                                  loan.contract + "," + loan.cont-code, 
                                  "ФиксДатаОконч", 
                                  ?) NO-ERROR.
      IF vFicsDate = ? THEN vFicsDate = GetXAttrInit(loan.Class-Code,"ФиксДатаОконч").

      /* определяем дату окончания из условий охватывающего договора */
      IF vFicsDate = "Да" THEN DO:
          FIND LAST xloan-cond WHERE xloan-cond.contract  = loan.contract 
                                 AND xloan-cond.cont-code = loan.cont-code
                                 AND xloan-cond.since    LE gend-date
             NO-LOCK NO-ERROR.

          IF AVAIL xloan-cond THEN 
              ASSIGN vDay = xloan-cond.cred-date
                     vOffSet = GetXattrValueEx("loan-cond",
                                               xloan-cond.contract + "," 
                                               + xloan-cond.cont-code + "," 
                                               + STRING(xloan-cond.since), 
                                               "cred-offset", 
                                               "")
                     vMove = IF vOffSet = "->" THEN 1 ELSE (IF vOffSet = "<-" THEN -1 ELSE 0)
                     .

          IF vDay = 31 OR (vDay > 28 AND MONTH(svPlanDate) = 2)  
              THEN vDate = LastMonDate(svPlanDate).
          ELSE IF vDay > 0 THEN DO:

              IF DAY(svPlanDate) >= vDay THEN DO:
                 IF MONTH(svPlanDate) = 12 THEN 
                     vDate = DATE(1, vDay, YEAR(svPlanDate) + 1) NO-ERROR.
                 ELSE DO:
                     IF vDay > 28 AND MONTH(svPlanDate) + 1 = 2 THEN
                          vDate = LastMonDate(DATE(MONTH(svPlanDate) + 1, 1, YEAR(svPlanDate))) NO-ERROR.
                     ELSE vDate = DATE(MONTH(svPlanDate) + 1, vDay, YEAR(svPlanDate)) NO-ERROR.
                 END.
              END.
              ELSE 
                 vDate = DATE(MONTH(svPlanDate), vDay, YEAR(svPlanDate)) NO-ERROR.                      
          END.           
          ELSE 
              vDate  = tloan.open-date + Get_Perid(OUTPUT mMess). /* если что-то не сложилось, то дату окончания определяем по периоду */

          /* проверка на нерабочий день и сдвиг, если надо */  
          IF vMove <> 0 THEN
             vDate = GetFstWrkDay(loan.class-code, loan.user-id, vDate, 9, vMove).

      END.
      ELSE 
      DO:
         vDate  = tloan.open-date + Get_Perid(OUTPUT mMess).
         /* С НП получаем направление смещения даты окончания в случае попадания на нераб.день */
         vOffSet = FGetSetting("СмещОкончТранОв", ?, "").
         vMove = IF vOffSet = "->" THEN 1 ELSE (IF vOffSet = "<-" THEN -1 ELSE 0).
         /* проверка на нерабочий день и сдвиг, если надо */
         vDate = GetFstWrkDay(loan.class-code, loan.user-id, vDate, 9, vMove).
      END.

   ASSIGN
      tloan.end-date     = MIN(loan.end-date, vDate)
      tloan-cond.amt-cur = mAmntOpr
      .

   FIND FIRST tloan-cond WHERE
              tloan-cond.contract  = tloan.contract
          AND tloan-cond.cont-code = '?' NO-LOCK NO-ERROR.
   IF AVAIL tloan-cond THEN
      tloan-cond.cont-code = tloan.cont-code.

   FOR EACH tloan-signs WHERE
            tloan-signs.contract  = tloan.contract
        AND tloan-signs.cont-code = '?' :

       tloan-signs.cont-code = tloan.cont-code.

   END.

   ASSIGN
      tloan.since      = tloan.open-date
      tloan-cond.since = tloan.open-date
      .
   /*Копируем ДР с охватывающего договора*/
   mLstDR = GetXAttrInit(loan.class-code, "СписНаслДР").
   RUN CopySignsEx(loan.class-code,
                   tloan.Contract + "," + main-cont-code,
                   tloan.class-code,
                   tloan.Contract + "," + tloan.Cont-code,
                   mLstDR,
                   "!*").
   /* копируем временные таблицы в базовые */
   RUN cr_loan_with_tab (OUTPUT mLoanRid, OUTPUT mFlagError).

   IF mFlagError < 0 THEN
      UNDO do_loan, RETRY do_loan.

   RUN cr_main_loan-acct (OUTPUT mAcctRid, OUTPUT mFlagError).

   IF mFlagError < 0 THEN
      UNDO do_loan, RETRY do_loan.

   RUN cr_loan-cond_with_tab (OUTPUT mCondRid, OUTPUT mFlagError).

   IF mFlagError < 0 THEN
      UNDO do_loan, RETRY do_loan.

  /**
   * По заявке #3195 строим графики
   *
   **/
      RUN SetSysConf IN h_base ("NoProtocol","YES").
      RUN SetSysconf IN h_base("НЕ ВЫВОДИТЬ ГРАФИКИ НА ЭКРАН","ДА").
      RUN i-ovterm.p(mLoanRid,mCondRid,mAmntOpr).
      RUN DeleteOldDataProtocol IN h_base ("NoProtocol").
      RUN DeleteOldDataProtocol IN h_base ("НЕ ВЫВОДИТЬ ГРАФИКИ НА ЭКРАН").

   CREATE over_error.
   ASSIGN
       over_error.acct      = acct.acct
       over_error.cont-code = loan.cont-code
       over_error.DATE      = svPlanDate
       over_error.MES       = "Создан новый период кредитования "
                              + tloan.cont-code
   .

END.

CREATE over.
ASSIGN
   over.acct           = acct.acct
   over.cur            = acct.currency
   over.cont-code-agr  = loan.cont-code
   over.agr-class-code = loan.class-code
   over.limit          = mLimitSumm
   over.bal            = mAmntOpr
   over.cont-code-per  = tloan.cont-code
   over.overtr         = YES
   .
END. /*PROCEDURE create-per:*/


/*----------------------------------- Internal Functions -------------------*/
/*
 Проверка на дублирование активных договоров у счета 
 Производится проверка всех прочих договоров из фильтра на совпадение
 привязанного счета. Если такой счет находится, то возвращается ИСТИНА.
 Иначе - ЛОЖЬ.
*/
FUNCTION Check-Dog RETURNS LOGICAL (
   INPUT iAcct       AS CHARACTER,  /* № привязанного счета тек.дог. для сравнения */    
   INPUT iTranRid    AS RECID       /* Id договора для сравнения */
   ):
   
   DEFINE BUFFER vloan FOR loan.
   DEFINE BUFFER yloan FOR loan.
   DEFINE BUFFER vloan-acct FOR loan-acct.
   
   DEFINE VARIABLE vValue AS LOGICAL NO-UNDO.
   vValue = NO.

   FIND FIRST vloan WHERE RECID(vloan) EQ iTranRid
      NO-LOCK NO-ERROR.

   /* Т.к. закрытые договора не всчет, то идем по всем привязкам этого счета к
   ** другим договорам, если нашли, находим договор и проверяем на закрытость.
   ** Как только нашли первый НЕ закрытый договор с таким счетом, 
   ** то вываливаемся, и возвращаем YES */
   FOR EACH vloan-acct WHERE vloan-acct.acct      EQ iAcct
                         AND vloan-acct.contract  EQ "Кредит"
                         AND vloan-acct.acct-type EQ "КредРасч"
                         AND vloan-acct.cont-code NE vloan.cont-code
   NO-LOCK,
      FIRST yloan WHERE yloan.contract   EQ vloan-acct.contract
                    AND yloan.cont-code  EQ vloan-acct.cont-code
                    AND yloan.close-date EQ ? 
   NO-LOCK:
      /* Исключаем течения самого договора */
      IF yloan.cont-code BEGINS vloan.cont-code + " " THEN
         NEXT.
      IF GetXAttrInit(yloan.Class-Code,"DTKind") EQ "Овердр" THEN
      DO:
         vValue = YES.
         LEAVE.
      END.
   END.
   
   RETURN vValue. /* Выход из функции. */
END FUNCTION. /*Check-Dog*/
