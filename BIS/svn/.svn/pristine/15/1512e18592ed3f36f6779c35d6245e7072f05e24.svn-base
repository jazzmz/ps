{pirsavelog.p}

/*
   Информация о расчете резерва
   Борисов А.В. 05.08.2009
*/

{globals.i}             /* Подключяем глобалные настройки*/
{ulib.i}                /* Библиотека функций для работы со счетами */
{intrface.get rsrv}
{intrface.get i254}
{intrface.get instrum}
{intrface.get loan}
{intrface.get comm}     /* Инструменты для работы с комиссиями */
{intrface.get xclass}   /* Функции работы с метасхемой */
{intrface.get db2l}
{tmprecid.def}        /** Используем информацию из броузера */

/** ОПРЕДЕЛЕНИЯ **/
FUNCTION LnPrincipal2 RETURNS DECIMAL
   (INPUT iContract AS CHAR, INPUT iContCode AS CHAR,
    INPUT iDate     AS DATE, INPUT iCurrency AS CHAR, INPUT CC AS CHAR)
   FORWARD.

FUNCTION Get_QualityGar2 RETURNS CHAR
   (INPUT iFileName AS CHAR, INPUT iSurrogate AS CHAR, INPUT iSince AS DATE)
   FORWARD.

/* ================================================================================== */
DEF VAR cAcctRsrv    AS CHARACTER NO-UNDO. /* Счет резерва */
DEF VAR cAcctPrRsrv  AS CHARACTER NO-UNDO. /* Счет пр.резерва */
DEF VAR nCredVal     AS DECIMAL   NO-UNDO. /* Сумма кредита в валюте */
DEF VAR nCredRur     AS DECIMAL   NO-UNDO. /* Сумма кредита в рублях */
DEF VAR nPrCredVal   AS DECIMAL   NO-UNDO. /* Сумма пр.кредита в валюте */
DEF VAR nPrCredRur   AS DECIMAL   NO-UNDO. /* Сумма пр.кредита в рублях */
DEF VAR nRsrv        AS DECIMAL   NO-UNDO. /* Сумма резерва */
DEF VAR nPrRsrv      AS DECIMAL   NO-UNDO. /* Сумма пр.резерва */
DEF VAR nRsrvClc     AS DECIMAL   NO-UNDO. /* Рассчетный резерв (без обеспечения) */
DEF VAR nPrRsrvClc   AS DECIMAL   NO-UNDO. /* Рассчетный пр.резерв (без обеспечения) */
DEF VAR nRsrvTst     AS DECIMAL   NO-UNDO. /* Пересчет резерва с обеспечением */
DEF VAR nPrRsrvTst   AS DECIMAL   NO-UNDO. /* Пересчет пр.резерва с обеспечением */
DEF VAR nObesp       AS DECIMAL   NO-UNDO. /* Обеспечение */
DEF VAR nPrObesp     AS DECIMAL   NO-UNDO. /* Пр.обеспечение */
DEF VAR nObespClc    AS DECIMAL   NO-UNDO. /* Пересчет обеспечения при ошибке*/

DEF VAR iVR          AS INTEGER FORMAT "9" INITIAL 1 NO-UNDO. /* Вариант отчета */

DEF VAR cClient      AS CHARACTER NO-UNDO. /* Наименование заемщика */
DEF VAR cDogCurr     AS CHARACTER NO-UNDO. /* Валюта договора */
DEF VAR cDogSogl     AS CHARACTER NO-UNDO. /* ДР ДатаСогл */
DEF VAR loaninf      AS CHARACTER NO-UNDO. /* */
DEF VAR loannum      AS CHARACTER NO-UNDO. /* */
DEF VAR iGrRisk      AS INTEGER   NO-UNDO. /* Группа риска */
DEF VAR nPrRisk      AS DECIMAL   NO-UNDO. /* Процент резервирования */
DEF VAR cObCat       AS CHARACTER NO-UNDO. /* Категория обеспечения */
DEF VAR iObCat       AS DECIMAL   NO-UNDO. /* Коэф-т обеспечения */
DEF VAR vSurr        AS CHARACTER NO-UNDO. /* Суррогат обязательства */

/** РЕАЛИЗАЦИЯ **/

/* Для всех выбранных договоров выполняем... */
FOR EACH tmprecid NO-LOCK,
   FIRST loan WHERE RECID(loan) EQ tmprecid.id NO-LOCK
:
   /* Если транш - пропустить */
   IF NUM-ENTRIES(loan.cont-code, " ") GT 1 THEN NEXT.

   /* ============ Ввод даты проведения расчета ===================================== */
   FORM
      "1 - Вновь выданная ссуда"
      "2 - Последнее изменение кредитного риска"
      "3 - На промежуточную дату"
      iVR LABEL "ВАРИАНТ" VALIDATE ( iVR < 4, "Несуществующий вариант !!!")
      WITH FRAME fVR 
      OVERLAY SIDE-LABELS 1 COL CENTERED ROW 5 
      TITLE COLOR BRIGHT-WHITE "[ Введите вариант расчета для договора " + loan.cont-code + " : ]"
      WIDTH 60.

   DO 
      ON ENDKEY UNDO , RETURN
      ON ERROR  UNDO , RETRY
   :
      UPDATE iVR WITH FRAME fVR.
   END.

   end-date = 01/01/1000.
   CASE iVR:
      WHEN 1 THEN DO:
         FOR EACH comm-rate
            WHERE (comm-rate.commission EQ "%Рез")
              AND (comm-rate.acct       EQ "0")
              AND (comm-rate.kau        EQ loan.contract + "," + loan.cont-code)
         NO-LOCK BY comm-rate.since:
            end-date = comm-rate.since.
            nPrRisk  = comm-rate.rate-comm.

            FIND FIRST loan-int
               WHERE (loan-int.contract EQ loan.contract)
                 AND (ENTRY(1, loan-int.cont-code, " ") EQ loan.cont-code)
                 AND (loan-int.id-d EQ 0)
               NO-ERROR.
            IF AVAIL(loan-int) THEN DO:
               end-date = loan-int.op-date.
            END.
            LEAVE.
         END.
         MESSAGE "Первая ссуда по договору " + loan.cont-code + " выдана " + STRING(end-date) + "," skip
            "Сумма = " + STRING(loan-int.amt-rub) + ",  % риска = " + STRING(nPrRisk) 
            VIEW-AS ALERT-BOX.
      END.
      WHEN 2 THEN DO:
         FOR EACH comm-rate
            WHERE comm-rate.commission = "%Рез"
              AND comm-rate.acct       = "0"
              AND comm-rate.kau        = loan.contract + "," + loan.cont-code
         NO-LOCK BY comm-rate.since DESCENDING:
            end-date = comm-rate.since.
            nPrRisk  = comm-rate.rate-comm.
            LEAVE.
         END.
         MESSAGE "Последнее изменение качества договора " + loan.cont-code skip
            "произошло " + STRING(end-date) + ",  % риска = " + STRING(nPrRisk) 
            VIEW-AS ALERT-BOX.
      END.
      WHEN 3 THEN DO:
         {getdate.i &DateLabel  = "Дата расчета резерва"}
         nPrRisk  = LnRsrvRate(loan.contract, loan.cont-code, end-date).
         MESSAGE "По договору " + loan.cont-code + " на дату " + STRING(end-date) skip
            "установлен % риска = " + STRING(nPrRisk) 
            VIEW-AS ALERT-BOX.
      END.
   END CASE.

   HIDE FRAME fVR.

   IF end-date EQ 01/01/1000
   THEN DO:
      MESSAGE.
      NEXT.
   END.

   iGrRisk = LnGetGrRiska(nPrRisk, end-date).

   /* ============ Печать шапки отчета ============================================== */
   {setdest.i &cols=170} /* Вывод в preview */

   PUT UNFORMATTED SKIP(5)
   "                                         ИНФОРМАЦИЯ О РАСЧЕТЕ РЕЗЕРВА" SKIP(1)
   .

   IF (iVR EQ 1)
   THEN
      PUT UNFORMATTED
      "┌───────────────────────────────────┬" +                      "─────────────────┬───┬─────────────────┬──────────┬───────────────┬──────────────────┬───────────────┐" SKIP
      "│                                   │" +                      "  СУММА ССУДНОЙ  │ВАЛ│  СУММА ССУДНОЙ  │ КАТЕГОРИЯ│     РАЗМЕР    │ СУММА ОБЕСПЕЧЕНИЯ│ РАЗМЕР РЕЗЕРВА│" SKIP
      "│       НАИМЕНОВАНИЕ ЗАЕМЩИКА       │" +                      "  ЗАДОЛЖЕННОСТИ  │   │  ЗАДОЛЖЕННОСТИ  │ КАЧЕСТВА │   РАСЧЕТНОГО  │     В РУБ. И     │    С УЧЕТОМ   │" SKIP
      "│                                   │" +                      "В ВАЛЮТЕ ДОГОВОРА│   │      В РУБ.     │И % РЕЗ-ВА│    РЕЗЕРВА    │КАТЕГОРИЯ КАЧЕСТВА│   ОБЕСПЕЧЕНИЯ │" SKIP
      "├───────────────────────────────────┼" +                      "─────────────────┼───┼─────────────────┼──┬───────┼───────────────┼───────────────┬──┼───────────────┤" SKIP
      .
   ELSE
      PUT UNFORMATTED
      "┌───────────────────────────────────┬─────────────────────────┬─────────────────┬───┬─────────────────┬──────────┬───────────────┬──────────────────┬───────────────┐" SKIP
      "│                                   │                         │ОСТАТОК ПО СЧЕТУ │ВАЛ│ ОСТАТОК ПО СЧЕТУ│ КАТЕГОРИЯ│     РАЗМЕР    │ СУММА ОБЕСПЕЧЕНИЯ│ РАЗМЕР РЕЗЕРВА│" SKIP
      "│       НАИМЕНОВАНИЕ ЗАЕМЩИКА       │    № ДОГОВОРА И ДАТА    │В ВАЛЮТЕ ДОГОВОРА│   │      В РУБ.     │ КАЧЕСТВА │   РАСЧЕТНОГО  │     В РУБ. И     │    С УЧЕТОМ   │" SKIP
      "│                                   │                         │                 │   │                 │И % РЕЗ-ВА│    РЕЗЕРВА    │КАТЕГОРИЯ КАЧЕСТВА│   ОБЕСПЕЧЕНИЯ │" SKIP
      "├───────────────────────────────────┼─────────────────────────┼─────────────────┼───┼─────────────────┼──┬───────┼───────────────┼───────────────┬──┼───────────────┤" SKIP
      .

   /* ============ Название клиента ======================================== */
   cClient = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).
   loaninf = loan.cont-code + " от ".
   loannum = loan.cont-code.

   cDogSogl = GetXAttrValue("loan", "Кредит," + loan.cont-code, "ДатаСогл").
   IF (cDogSogl NE "")
   THEN loaninf = loaninf + cDogSogl.
   ELSE loaninf = loaninf + STRING(loan.open-DATE,"99/99/9999").

   /* ============ Сумма основного и пр.кредитов ======================================== */
   nCredVal    = LnPrincipal2(loan.contract, loan.cont-code, end-date, loan.currency, "Main").
   nPrCredVal  = LnPrincipal2(loan.contract, loan.cont-code, end-date, loan.currency, "Pr").
   nCredRur    = ROUND(CurToCur("УЧЕТНЫЙ", loan.currency, "", end-date, nCredVal), 2).
   nPrCredRur  = ROUND(CurToCur("УЧЕТНЫЙ", loan.currency, "", end-date, nPrCredVal), 2).
   cDogCurr    = IF (loan.currency EQ "") THEN "810" ELSE loan.currency.

   /* ============ Обеспечение ======================================== */
   RUN LnCollateralValueEx(loan.contract, loan.cont-code, end-date, ?, loan.currency, OUTPUT nObesp, OUTPUT nPrObesp).
   nObesp   = ROUND(nObesp,   2).
   nPrObesp = ROUND(nPrObesp, 2).

   /* ============ Категория обеспечения ============================================ */
   cObCat = "".
   iObCat = 0.

   IF ((nObesp + nPrObesp) NE 0)
   THEN DO:
      FOR EACH term-obl
         WHERE term-obl.cont-code EQ loannum
           AND term-obl.idnt      EQ 5
         NO-LOCK:

         vSurr  = term-obl.contract + "," + 
                  term-obl.cont-code + "," + 
                  STRING(term-obl.idnt) + "," +
                  STRING(term-obl.end-date) + "," + 
                  STRING(term-obl.nn).
         cObCat = Get_QualityGar2 ("comm-rate", vSurr, end-date).

         IF (cObCat NE "") AND (cObCat NE "?")
         THEN DO:
            /* индекс качества обеспечения по классификатору "КачествоОбесп"*/
            iObCat  = DECIMAL(GetCode("КачествоОбесп", cObCat)).
            IF (iObCat EQ ?) THEN iObCat = 0.

            LEAVE.
         END.
      END.

      IF cObCat EQ "" THEN 
         MESSAGE "Не найдено обеспечение для договора " + loannum
            VIEW-AS ALERT-BOX.
   END.

   /* ============ Резерв =========================================================== */
   cAcctRsrv   = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредРез", end-date, false).
   nRsrv       = ABS(GetAcctPosValue_UAL(cAcctRsrv, "810", end-date, NO)).
   nRsrvClc    = ROUND(nCredRur * nPrRisk / 100, 2).

   nRsrvTst = IF (nCredVal GT nObesp)
              THEN (ROUND(CurToCur("УЧЕТНЫЙ", loan.currency, "", end-date,
                                   (nCredVal - nObesp) * nPrRisk / 100), 2))
              ELSE 0.

   /* ============ Пр.резерв ======================================================== */
   IF (nPrCredVal NE 0)
   THEN DO:
      cAcctPrRsrv = GetLoanAcct_ULL(loan.contract, loan.cont-code, "КредРез1", end-date, false).
      nPrRsrv     = ABS(GetAcctPosValue_UAL(cAcctPrRsrv, "810", end-date, NO)).
      nPrRsrvClc  = ABS(ROUND(nPrCredRur * nPrRisk / 100, 2)).
      nPrRsrvTst  = IF (nPrCredVal GT nPrObesp)
                    THEN (ROUND(CurToCur("УЧЕТНЫЙ", loan.currency, "", end-date,
                                         (nPrCredVal - nPrObesp) * nPrRisk / 100), 2))
                    ELSE 0.
   END.
   ELSE DO:
      cAcctPrRsrv = "".
      nPrRsrv     = 0.
      nPrRsrvClc  = 0.
      nPrRsrvTst  = 0.
      nPrObesp    = 0.
   END.

   nObesp   = ROUND(CurToCur("УЧЕТНЫЙ", loan.currency, "", end-date, nObesp),   2).
   nPrObesp = ROUND(CurToCur("УЧЕТНЫЙ", loan.currency, "", end-date, nPrObesp), 2).

   /* ============ Проверка расчета резерва ========================================= */
   IF (ABS(nRsrvTst - nRsrv) GE 0.05)
   THEN DO:
      nObespClc = ROUND(nCredRur - (nRsrv * 100 / nPrRisk), 2).
      MESSAGE "Неправильный расчет для договора " + loannum
         skip "Obesp = " STRING(nObesp)
         skip "d.b.  = " STRING(nObespClc)
         VIEW-AS ALERT-BOX.
      nObesp    = nObespClc.
   END.

   /* ============ Проверка расчета пр.резерва ====================================== */
   IF (ABS(nPrRsrvTst - nPrRsrv) GE 0.05)
   THEN DO:
      nObespClc = ROUND(nPrCredRur - (nPrRsrv * 100 / nPrRisk), 2).
      MESSAGE "Неправильный расчет для договора " + loannum
         skip "Obesp = " STRING(nObesp)
         skip "d.b.  = " STRING(nObespClc)
         VIEW-AS ALERT-BOX.
      nPrObesp  = nObespClc.
   END.

   IF iObCat NE 0
   THEN
      ASSIGN
         nObesp   = nObesp   / (iObCat / 100)
         nPrObesp = nPrObesp / (iObCat / 100)
      NO-ERROR.

   /* ============ Печать отчета ======================================== */
   ASSIGN
      nCredVal = nCredVal + nPrCredVal
      nCredRur = nCredRur + nPrCredRur
      nRsrvClc = nRsrvClc + nPrRsrvClc
      nRsrv    = nRsrv    + nPrRsrv
      nObesp   = nObesp   + nPrObesp
   NO-ERROR.

   /* Выводим строку таблицы */
   PUT UNFORMATTED 
      "│" cClient FORMAT "x(35)".
   IF (iVR GT 1)
      THEN PUT UNFORMATTED "│" loaninf FORMAT "x(25)".
   PUT UNFORMATTED 
      "│" nCredVal      FORMAT "->,>>>,>>>,>>9.99"
      "│" cDogCurr      FORMAT "xxx"
      "│" nCredRur      FORMAT "->,>>>,>>>,>>9.99"
      "│" iGrRisk       FORMAT ">>"
      "│" nPrRisk       FORMAT ">>9.99" "%"
      "│" nRsrvClc      FORMAT   "->>>,>>>,>>9.99".
   IF nObesp EQ 0
      THEN PUT UNFORMATTED "│" SPACE(15) .
      ELSE PUT UNFORMATTED "│" nObesp  FORMAT "->>>,>>>,>>9.99" .
   PUT UNFORMATTED 
      "│" cObCat        FORMAT "x(2)"
      "│" nRsrv         FORMAT "->>>,>>>,>>9.99"
      "│" SKIP
      "└───────────────────────────────────". 
   IF (iVR GT 1)
      THEN PUT UNFORMATTED "┴─────────────────────────".
   PUT UNFORMATTED 
      "┴─────────────────┴───┴─────────────────┴──┴───────┴───────────────┴───────────────┴──┴───────────────┘" SKIP(4).

   /* Подписи в подвале */
   PUT UNFORMATTED
      "Исполнитель " /* SPACE(20) ENTRY(1, inParam) */ SKIP(4)
      "Начальник У4" /* SPACE(20) ENTRY(2, inParam) */ SKIP(2)
      (IF (iVR NE 1) THEN STRING(end-date, "99.99.9999") ELSE "") SKIP(1)
      .

   /* Отображаем содержимое preview */
   {preview.i}

END.

/* ========================================================== */
FUNCTION LnPrincipal2 RETURNS DECIMAL (INPUT iContract AS CHAR,
                                       INPUT iContCode AS CHAR,
                                       INPUT iDate     AS DATE,
                                       INPUT iCurrency AS CHAR,
                                       INPUT CC        AS CHAR).
   DEFINE BUFFER b-loan FOR loan.

   DEF VAR mLoanCurr  AS CHAR NO-UNDO.
   DEF VAR vParamSumm AS DEC  NO-UNDO.
   DEF VAR vDb        AS DEC  NO-UNDO.
   DEF VAR vCr        AS DEC  NO-UNDO.
   DEF VAR vRes       AS DEC  NO-UNDO.
   DEF VAR mResult    AS DEC  NO-UNDO.

   RUN RE_B_LOAN IN h_Loan (iContract,iContCode,BUFFER b-loan).

   IF b-loan.cont-type <> "Течение"
   THEN DO:
      IF CC = "Main"
      THEN DO:
         RUN RE_PARAM IN h_Loan ( 0, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).
      END.
      ELSE DO:
         RUN RE_PARAM IN h_Loan ( 7, iDate, iContract, iContCode, OUTPUT vRes, OUTPUT vDb, OUTPUT vCr).
         RUN RE_PARAM IN h_Loan (13, iDate, iContract, iContCode, OUTPUT vParamSumm, OUTPUT vDb, OUTPUT vCr).
         vRes = vRes + vParamSumm.
      END.

      IF b-loan.Currency <> iCurrency
         THEN vRes = CurToCurWork("Учетный", b-loan.currency, iCurrency, iDate, vRes).
   END.

   ELSE DO:
      vRes = 0.
      FOR EACH b-loan WHERE
               b-loan.contract = iContract
           AND b-loan.cont-code BEGINS iContCode
           AND NUM-ENTRIES(b-loan.cont-code, " ") = 2
           AND ENTRY(1, b-loan.cont-code, " ")    = iContCode
           AND b-loan.open-date <= iDate
         NO-LOCK:

         IF b-loan.close-date <> ? AND
            b-loan.close-date <= iDate
         THEN
            NEXT.

         vRes = vRes +  LnPrincipal2(b-loan.contract, b-loan.cont-code, iDate, iCurrency, CC).
      END. /*FOR EACH*/
   END.

   mResult = CurrRound(vRes,iCurrency).
   RETURN mResult.

END FUNCTION. /* LnPrincipal2  */

/*---------------------------------------------------------------------------
  Function   : Get_QualityGar2 (без проверки term-obl)
  Name       : Значение категории качества обеспечения
  Purpose    : Получение значения категории качеста обеспечения, действующую
               на передаваемую дату
  Parameters : iFileName  - таблица
               iSurrogate - суррогат договора обеспечения
  Notes:
  ---------------------------------------------------------------------------*/
FUNCTION Get_QualityGar2 RETURNS CHAR (INPUT iFileName  AS CHAR,
                                       INPUT iSurrogate AS CHAR,
                                       INPUT iSince     AS DATE).

   DEF VAR vReturn AS CHAR NO-UNDO INIT "?".
   DEF VAR vCRSurr AS CHAR NO-UNDO.

   /* Ищем comm-rate */
   FOR EACH comm-rate WHERE comm-rate.commission EQ "КачОбеспеч"
                        AND comm-rate.acct       EQ "0"
                        AND comm-rate.kau        EQ iSurrogate
                        AND comm-rate.min-value  EQ 0
                        AND comm-rate.period     EQ 0
                        AND comm-rate.since      LE iSince
      NO-LOCK BY comm-rate.since DESCENDING:

      LEAVE.
   END.

   /* Если он есть, то определяем значение Категории качества
   ** по соответствующему ДР */
   IF AVAIL comm-rate THEN
   DO:
      vCRSurr = GetSurrogateBuffer("comm-rate",(BUFFER comm-rate:HANDLE)).
      vReturn = GetXAttrValueEx("comm-rate",vCRSurr,"КачОбеспеч","?").
   END.

   RETURN vReturn.

END FUNCTION.
