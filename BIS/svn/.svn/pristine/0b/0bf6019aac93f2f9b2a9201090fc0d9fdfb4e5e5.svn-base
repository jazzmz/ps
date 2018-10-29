{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: a_nalreg.p
      Comment: Процедура указывается в шаблоне налоговых отчётов по УМЦ.
               Используется для отчётов:
               1).Расчёт амортизации по амортизиреумому имуществу.
               2).Учёт результатов от реализации амортизируемого имущества.
   Parameters:
         Uses:
      Used by:
      Created: 13/04/2003 fedm
     Modified:
*/

DEF OUTPUT PARAM xResult AS DECIMAL NO-UNDO. /* возвращаемый результат,
                                                "?" в случае ошибки     */
DEF INPUT  PARAM beg     AS DATE    NO-UNDO. /* нач.дата периода        */
DEF INPUT  PARAM dob     AS DATE    NO-UNDO. /* кон.дата периода        */
DEF INPUT  PARAM xStr    AS CHAR    NO-UNDO. /* строка параметров       */

{globals.i}
{norm.i}

/* Переменные, инициализированные извне при обработке шаблона отчёта,
** к которым требуется доступ в процедуре отчёта.
*/
{norm-rps.def}

{tmprecid.def}
{wordwrap.def}
{a-defs.i}
{def-wf.i NEW}

{intrface.get date}
{intrface.get db2l}

/* Хэндл процедуры с парсерными функциями УМЦ   */
DEF VAR mH           AS HANDLE  NO-UNDO.
/* Признак необходимости удаления процедур      */
DEF VAR remove-mH    AS LOGICAL NO-UNDO INIT NO.
/* Суффикс роли                                 */
DEF VAR mRoleSfx     AS CHAR    NO-UNDO INIT "-нал-амор".

/* Номер строки отчёта                          */
DEF VAR mCntLin      AS INT     NO-UNDO.
/* Счётчик месяцев                              */
DEF VAR mCnt         AS INT     NO-UNDO.
/* Счётчик месяцев                              */
DEF VAR mCntYear     AS INT     NO-UNDO.
/* Счётчик для глюкалки                         */
DEF VAR mBarCnt      AS INT     NO-UNDO.
/* Счётчик строк названия ценности              */
DEF VAR mCntNam      AS INT     NO-UNDO.
/* Наименование ценности                        */
DEF VAR mName        AS CHAR    NO-UNDO EXTENT 10.
/* Ширина колонки наименования ценности         */
DEF VAR mNameWidth   AS INT     NO-UNDO.
/* Срок полезного использования                 */
/* Результат сходимости                        */
DEF VAR mShod        AS INT    NO-UNDO.
/* Результат разности амортизации                    */
DEF VAR mRazn        AS decimal    NO-UNDO.
/* Срок полезного использования                 */
DEF VAR mUsefulLife  AS DECIMAL NO-UNDO.
/* Срок эксплуатации (ДР карточки СрокЭкспл)    */
DEF VAR mExplPer     AS DECIMAL NO-UNDO.
/* Срок гашения стоимости (ДР карточки СрокГашСтоим)*/
DEF VAR mGashPer     AS DECIMAL NO-UNDO.
/* Коэффициент ускорения амортизации            */
DEF VAR mAmorAcclr   AS DECIMAL NO-UNDO.
/* Налоговая норма амортизации месячная в %%    */
DEF VAR mAmortNorm   AS DECIMAL NO-UNDO INITIAL ?.
/* Первоначальная стоимость                     */
DEF VAR mInvCost     AS DECIMAL NO-UNDO.
/* стоимость на конец периода                    */
DEF VAR mInvCostEnd     AS DECIMAL NO-UNDO.
/* Изменение первоначальной стоимости           */
DEF VAR mInvCostChng AS DECIMAL NO-UNDO.
/* Остаточная стоимость                         */
DEF VAR mOstCost     AS DECIMAL NO-UNDO.
/* Сумма амортизации на начало периода года   */
DEF VAR mYearAmor    AS DECIMAL NO-UNDO.
/* Сумма амортизации на начало периода отчёта   */
DEF VAR mInitAmor    AS DECIMAL NO-UNDO.
/* Сумма амортизации на конец  периода отчёта   */
DEF VAR mLastAmor    AS DECIMAL NO-UNDO.
/* Суммы амортизации по месяцам + за период     */
DEF VAR mMonSum      AS DECIMAL NO-UNDO EXTENT 13.
/* Суммы амортизации (итоги по группам)         */
DEF VAR mGrSum       AS DECIMAL NO-UNDO EXTENT 13.
/* Суммы амортизации (итоги по отчёту)          */
DEF VAR mRepSum      AS DECIMAL NO-UNDO EXTENT 13.
/* Период консервации */
DEF VAR mConsPers    AS CHAR     NO-UNDO.
DEF VAR mMonPer   AS DATE     NO-UNDO EXTENT 2.
DEF VAR mConsPer     AS DECIMAL NO-UNDO.
/* Дата приходования основного средства в бухгалтерии */
DEF VAR mDateIn      AS DATE    NO-UNDO.
/* Дата реализации (регистрации права)          */
DEF VAR mDateIn2      AS DATE    NO-UNDO.
/* Дата реализации (регистрации права)          */
DEF VAR mDateOut     AS DATE    NO-UNDO.
/* Период эксплуатации (в месяцах)              */
DEF VAR mDateOut2     AS DATE    NO-UNDO.
/* Период эксплуатации (в месяцах 2)              */
DEF VAR mOperPer     AS DECIMAL NO-UNDO.
/* Остаток Периода эксплуатации (в месяцах)              */
DEF VAR mOperPer2     AS DECIMAL NO-UNDO.
/* Остаток Периода эксплуатации (в месяцах)              */
DEF VAR mOstPer     AS DECIMAL NO-UNDO.
/* Остаток Периода эксплуатации (в месяцах)              */
DEF VAR mRasAmor     AS DECIMAL NO-UNDO.
/* Дата истечения срока полезного использования */
DEF VAR mDead-Line   AS DATE    NO-UNDO.
/* Расходы, связанные с реализацией             */
DEF VAR mRealCosts   AS DECIMAL NO-UNDO.
/* Прибыль(убыток) от реализации                */
DEF VAR mSalesIncome AS DECIMAL NO-UNDO.
/* Кол-во месяцев отнесения убытка на расходы   */
DEF VAR mLossMonth   AS DECIMAL NO-UNDO.
/* Сумма расходов, приходящаяся на каждый месяц */
DEF VAR mLossMonSum  AS DECIMAL NO-UNDO.
/* Группа амортизации, по которой фильтруется таблица */
DEF VAR mAmorGr      AS CHARACTER NO-UNDO.
/* Признак необходимости  фильтрации по mAmorGr */
DEF VAR mFilt        AS LOGICAL   NO-UNDO INITIAL NO.
/* Признак необходимости выводить только итоги по группе */
DEF VAR mItog        AS LOGICAL   NO-UNDO INITIAL NO.
DEF VAR mDone        AS LOGICAL   NO-UNDO.
/* Найден ли документ. Для корректной работы нек. функций */
DEF VAR mOpDoc       AS LOGICAL   NO-UNDO.
/* Остаток */
DEF VAR mSum         AS DEC       NO-UNDO.
DEF VAR mQty         AS DEC       NO-UNDO.

/* Премия */
DEF VAR mPremia        AS DEC   NO-UNDO.
DEF VAR mPremia10      AS DEC   NO-UNDO.
DEF VAR mPremia30      AS DEC   NO-UNDO.

def var ofunc as tfunc NO-UNDO.
def var tempvar as char NO-UNDO.
ofunc = new tfunc().

/* Рабочая таблица для строк шаблона */
DEF TEMP-TABLE ttPattern NO-UNDO
   FIELD Kind  AS INT    /* Тип строки: 1-шапка; 2-тело; 3-подвал. */
   FIELD LineN AS INT    /* Номер строки                           */
   FIELD Patt  AS CHAR   /* Строка шаблона                         */
INDEX Kind Kind LineN.

/* Расходы, связанные с реализацией */
FUNCTION GetRealCosts RETURNS DECIMAL
FORWARD.

/* Функция для разбора строки шаблона отчёта
  Параметры:
    str_   строка шаблона отчёта
    regim: PATTERN - корректировка шаблонов
           MAIN    - основная строка отчёта
           ADD     - дублированная строка отчёта для вывода длинных наименований
           TOTAL   - итоговая строка отчёта
*/
FUNCTION fill-str_    RETURNS CHAR
        (str_  AS CHAR,
         regim AS CHAR
        )
FORWARD.

mH = SESSION:FIRST-PROCEDURE.
DO WHILE mH <> ?:
   IF mH:FILE-NAME     = "a-obj.p" AND
      mH:PRIVATE-DATA <> "Slave"   THEN LEAVE.
      mH = mH:NEXT-SIBLING.
END.

IF VALID-HANDLE(mH) THEN
   RUN Save IN mH.
ELSE
DO:
  RUN "a-obj.p" PERSISTENT SET mH ("Slave", "", "").
  remove-mH = YES.
END.


/* Предварительная обработка шаблонов */
RUN CorrectPattern.

{ init-bar.i "Ждите завершения формирования отчёта..." }

/* Заголовок отчёта */
PUT STREAM fil UNFORMATTED page_header SKIP.
IF mItog THEN
   RUN CalcItog.
ELSE
DO:
/* Основной цикл */
   FOR
      EACH  tmprecid,

      FIRST loan           WHERE
            RECID(loan)         = tmprecid.id
         NO-LOCK,

      FIRST asset          OF loan
         NO-LOCK,

      EACH  loan-acct      WHERE
            loan-acct.contract  = loan.contract
        AND loan-acct.cont-code = loan.cont-code
        AND loan-acct.acct-type = loan.contract + mRoleSfx
        AND loan-acct.since    <= dob
         NO-LOCK,

      LAST  acct           WHERE
            acct.acct           = loan-acct.acct
        AND acct.currency       = loan-acct.currency
         NO-LOCK

      BREAK BY loan.contract
            BY loan.cont-code:
      IF GetXattrValueEx("asset",
                         GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                         "AmortGr",
                         "0") = mAmorGr OR
         NOT mFilt                      THEN
      DO:
         ASSIGN
            mDone  = NO
            mOpDoc = NO
         .
         FOR EACH op-entry       WHERE
                 (op-entry.acct-db    = loan-acct.acct            AND
                  op-entry.op-date   >= MAX(beg, loan-acct.since) AND
                  op-entry.op-date   <= dob                       AND
                  acct.side           = "А"
                 )
              OR (op-entry.acct-cr    = loan-acct.acct            AND
                  op-entry.op-date   >= MAX(beg, loan-acct.since) AND
                  op-entry.op-date   <= dob                       AND
                  acct.side           = "П"
                 )
            NO-LOCK,
            FIRST op OF op-entry
               NO-LOCK:
            ASSIGN
               mOpDoc                           = YES
               mMonSum[MONTH(op-entry.op-date)] = mMonSum[MONTH(op-entry.op-date)]
                                              + op-entry.amt-rub.
         END.


/* Запускаем поиск еще раз!  */
	mPremia = 0.


         FOR EACH op-entry       WHERE
                 (op-entry.acct-db    = loan-acct.acct            AND
				  op-entry.acct-cr 	  BEGINS '78901'	          AND           
                  op-entry.op-date   >= MIN(beg, loan-acct.since) AND
                  op-entry.op-date   <= dob                       
                 )
 
            NO-LOCK,
            FIRST op OF op-entry WHERE 
               (op.op-kind begins '5002n0')
               
            NO-LOCK:
               			DO: 
               				mPremia = op-entry.amt-rub.
    					   /*MESSAGE "Нашлась премия! "op-entry.acct-db op-entry.acct-cr op-entry.amt-rub VIEW-AS ALERT-BOX.*/            			
               			END.
               			         
            
                                              
         END.


/* Если не было движения, то пытаемся получить ненулевой остаток
** на счете ОС-нал-учет на начало и/или конец отчетного периода.*/
         IF mOpDoc EQ NO
         THEN DO:
            RUN    GetLoanPos IN h_umc (       loan.contract,
                                               loan.cont-code,
                                               "-нал-учет",
                                               beg,
                                        OUTPUT mSum,
                                        OUTPUT mQty
                                       ).
            IF mSum   EQ 0 THEN
               RUN GetLoanPos IN h_umc (       loan.contract,
                                               loan.cont-code,
                                               "-нал-учет",
                                               dob,
                                        OUTPUT mSum,
                                        OUTPUT mQty
                                       ).
         END.

         IF    mOpDoc
            OR mSum   NE 0 THEN
            mDone = YES.

         IF NOT mDone AND NOT mFilt     OR
            NOT LAST-OF(loan.cont-code) THEN
            NEXT.

         RUN CalcData.

         IF mInvCost > 0 THEN
         DO:
      /* Накопление сумм */
            ACCUMULATE
               mInvCost     (TOTAL)
               mInvCostChng (TOTAL)
	       	   mYearAmor    (TOTAL)
               mInitAmor    (TOTAL)
               mLastAmor    (TOTAL)
               mOstCost     (TOTAL)
               mRealCosts   (TOTAL)
               mSalesIncome (TOTAL)
               mPremia10	(TOTAL)
               mPremia30	(TOTAL).

      /* Считаем строки, обновляем глюкалку */
            ASSIGN
               mCntLin = mCntLin + 1
               mBarCnt = mCntLin MOD 11.

            {move-bar.i mBarCnt 10}

      /* Вывод основных строк отчёта */
            mCntNam = 0.
            FOR EACH ttPattern WHERE
                     ttPattern.Kind = 2:

               mCntNam = mCntNam + 1.
               PUT STREAM fil UNFORMATTED fill-str_ (ttPattern.Patt, "MAIN") SKIP.
            END.

      /* Вывод дополнительных строк для дорисовки длинного названия ценности */
            FOR LAST ttPattern WHERE
                     ttPattern.Kind = 2:

               DO mCntNam = mCntNam + 1 TO EXTENT(mName)
                  WHILE mName[mCntNam] <> "":

                  PUT STREAM fil UNFORMATTED fill-str_ (ttPattern.Patt, "ADD") SKIP.
               END.
            END.
         END.
         mMonSum = 0.
      END.
   END.
   /* Итоги по отчёту */
   /* Разделительная линия */
   FOR LAST ttPattern WHERE
            ttPattern.Kind = 1:

      PUT STREAM fil UNFORMATTED ttPattern.Patt SKIP.
   END.

   /* Копируем итоги в mMonSum и считаем итого амортизации */
   DO mCnt = MONTH(beg) TO MONTH(dob):
      ASSIGN
         mMonSum[mCnt] = mRepSum[mCnt]
         mMonSum[13]   = mMonSum[13] + mMonSum[mCnt].
   END.

   /* Итоги по суммируемым показателям */
   ASSIGN
      mInvCost     = (ACCUM TOTAL mInvCost)
      mInvCostChng = (ACCUM TOTAL mInvCostChng)
      mYearAmor    = (ACCUM TOTAL mYearAmor)
      mInitAmor    = (ACCUM TOTAL mInitAmor)
      mOstCost     = (ACCUM TOTAL mOstCost)
      mLastAmor    = (ACCUM TOTAL mLastAmor)
      mRealCosts   = (ACCUM TOTAL mRealCosts)
      mSalesIncome = (ACCUM TOTAL mSalesIncome)
      mPremia10    = (ACCUM TOTAL mPremia10)
      mPremia30    = (ACCUM TOTAL mPremia30)
      mLossMonSum  = 0.
   /* Выводим итоги */
   FOR EACH ttPattern WHERE
      ttPattern.Kind = 2:

      PUT STREAM fil UNFORMATTED fill-str_ (ttPattern.Patt, "TOTAL") SKIP.
   END.
END.
/* Выводим подвал */
PUT STREAM fil UNFORMATTED page_footer SKIP.

IF remove-mH        AND
   VALID-HANDLE(mH) THEN
   DELETE PROCEDURE (mH).
ELSE IF NOT remove-mH AND
        VALID-HANDLE(mH) THEN
   RUN Restore IN mH.

{del-bar.i}
{intrface.del}

RETURN.

/***  ВНУТРЕННИЕ ФУНКЦИИ И ПРОЦЕДУРЫ ***/

/* Вычисление итоговых данных по группе ценностей */
PROCEDURE CalcItog:
DEF VAR vA AS LOGICAL NO-UNDO.
/* Основной цикл */
   FOR EACH code WHERE code.class  = "АморГруппы"
                   AND code.parent = "АморГруппы"
      NO-LOCK BREAK BY code.code:
      vA = NO.
      FOR
         EACH  tmprecid,

         FIRST loan           WHERE
               RECID(loan)         = tmprecid.id
            NO-LOCK,

         FIRST asset          OF loan
            NO-LOCK,

         EACH  loan-acct      WHERE
               loan-acct.contract  = loan.contract
           AND loan-acct.cont-code = loan.cont-code
           AND loan-acct.acct-type = loan.contract + mRoleSfx
           AND loan-acct.since    <= dob
            NO-LOCK,

         LAST  acct           WHERE
               acct.acct           = loan-acct.acct
           AND acct.currency       = loan-acct.currency
            NO-LOCK

         BREAK BY loan.contract
               BY loan.cont-code:
         IF GetXattrValueEx("asset",
                            GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                            "AmortGr",
                            "0") = code.code THEN
         DO:
            mOpDoc = NO.
            FOR EACH op-entry       WHERE
                    (op-entry.acct-db    = loan-acct.acct            AND
                     op-entry.op-date   >= MAX(beg, loan-acct.since) AND
                     op-entry.op-date   <= dob                       AND

                     acct.side           = "А"
                    )
                 OR (op-entry.acct-cr    = loan-acct.acct            AND
                     op-entry.op-date   >= MAX(beg, loan-acct.since) AND
                     op-entry.op-date   <= dob                       AND
                     acct.side           = "П"
                    )
               NO-LOCK,
               FIRST op OF op-entry
                  NO-LOCK:
               ASSIGN
                  mOpDoc                           = YES
                  mMonSum[MONTH(op-entry.op-date)] = mMonSum[MONTH(op-entry.op-date)]
                                                 + op-entry.amt-rub.
            END.

            IF LAST-OF(loan.cont-code) THEN
            DO:
               vA = YES.
               RUN CalcData.
               IF mInvCost > 0 /* OR
                  mItog */       THEN
         /* Накопление сумм */
                  ACCUMULATE
                     mInvCost     (SUB-TOTAL BY code.code)
                     mInvCostChng (SUB-TOTAL BY code.code)
		     mYearAmor    (SUB-TOTAL BY code.code)
                     mInitAmor    (SUB-TOTAL BY code.code)
                     mLastAmor    (SUB-TOTAL BY code.code)
                     mOstCost     (SUB-TOTAL BY code.code)
                     mRealCosts   (SUB-TOTAL BY code.code)
                     mSalesIncome (SUB-TOTAL BY code.code)
                     mInvCost     (TOTAL)
                     mInvCostChng (TOTAL)
		     mYearAmor    (TOTAL)
                     mInitAmor    (TOTAL)
                     mLastAmor    (TOTAL)
                     mOstCost     (TOTAL)
                     mRealCosts   (TOTAL)
                     mSalesIncome (TOTAL)
                     mPremia10    (TOTAL)
      				 mPremia30    (TOTAL)
      				 .

               mMonSum = 0.
            END.
         END.
      END.  /* for tmprecid,loan,asset,loan-acct,acct */
      IF LAST-OF(code.code) THEN
      DO:
         ASSIGN
            mInvCost     = ACCUM SUB-TOTAL BY code.code mInvCost
            mInvCostChng = ACCUM SUB-TOTAL BY code.code mInvCostChng
	        mYearAmor    = ACCUM SUB-TOTAL BY code.code mYearAmor
            mInitAmor    = ACCUM SUB-TOTAL BY code.code mInitAmor
            mLastAmor    = ACCUM SUB-TOTAL BY code.code mLastAmor
            mOstCost     = ACCUM SUB-TOTAL BY code.code mOstCost
            mRealCosts   = ACCUM SUB-TOTAL BY code.code mRealCosts
            mSalesIncome = ACCUM SUB-TOTAL BY code.code mSalesIncome
            mPremia10 = ACCUM SUB-TOTAL BY code.code mPremia10
            mPremia30 = ACCUM SUB-TOTAL BY code.code mPremia30.
            
   /* Считаем строки, обновляем глюкалку */
         ASSIGN
            mCntLin = mCntLin + 1
            mBarCnt = mCntLin MOD 11.

         {move-bar.i mBarCnt 10}

   /* Копируем итоги в mMonSum и считаем итого амортизации по группе */
         DO mCnt = MONTH(beg) TO MONTH(dob):
            ASSIGN
               mMonSum[mCnt] = mRepSum[mCnt] - mGrSum[mCnt]
               mMonSum[13]   = mMonSum[13]   + mMonSum[mCnt]
               mGrSum[mCnt]  = mRepSum[mCnt]
               mGrSum[13]    = mRepSum[13] /* GrSum[13] + mGrSum[mCnt] */.
         END.
         IF NOT vA THEN
            mName[1] = "Основные средства " + STRING(code.code,"99") + "-й амортизационной группы".
   /* Вывод основных строк отчёта */
         mCntNam = 0.
         FOR EACH ttPattern WHERE
                  ttPattern.Kind = 2:

            mCntNam = mCntNam + 1.
            PUT STREAM fil UNFORMATTED fill-str_ (ttPattern.Patt, "MAIN") SKIP.
         END.

   /* Вывод дополнительных строк для дорисовки длинного названия ценности */
         FOR LAST ttPattern WHERE
                  ttPattern.Kind = 2:

            DO mCntNam = mCntNam + 1 TO EXTENT(mName)
               WHILE mName[mCntNam] <> "":

               PUT STREAM fil UNFORMATTED fill-str_ (ttPattern.Patt, "ADD") SKIP.
            END.
         END.
         mMonSum = 0.
      END.
   END. /* for code */
/* Итоги по отчёту */
/* Разделительная линия */
   FOR LAST ttPattern WHERE
            ttPattern.Kind = 1:

      PUT STREAM fil UNFORMATTED ttPattern.Patt SKIP.
   END.

/* Копируем итоги в mMonSum и считаем итого амортизации */
   DO mCnt = MONTH(beg) TO MONTH(dob):
      ASSIGN
         mMonSum[mCnt] = mRepSum[mCnt]
         mMonSum[13]   = mMonSum[13] + mMonSum[mCnt].
   END.

/* Итоги по суммируемым показателям */
   ASSIGN
      mInvCost     = (ACCUM TOTAL mInvCost)
      mInvCostChng = (ACCUM TOTAL mInvCostChng)
      mYearAmor    = (ACCUM TOTAL mYearAmor)
      mInitAmor    = (ACCUM TOTAL mInitAmor)
      mOstCost     = (ACCUM TOTAL mOstCost)
      mLastAmor    = (ACCUM TOTAL mLastAmor)
      mRealCosts   = (ACCUM TOTAL mRealCosts)
      mSalesIncome = (ACCUM TOTAL mSalesIncome)
      mPremia10    = (ACCUM TOTAL mPremia10)
      mPremia30    = (ACCUM TOTAL mPremia30)
      mLossMonSum  = 0.
/* Выводим итоги */
   FOR EACH ttPattern WHERE
      ttPattern.Kind = 2:

      PUT STREAM fil UNFORMATTED fill-str_ (ttPattern.Patt, "TOTAL") SKIP.
   END.

END PROCEDURE. /* CalcItog */

/* Вычисление данных по строке отчета (карточке) */
PROCEDURE CalcData:
   IF mItog THEN
      mName = "Основные средства " + STRING(code.code,"99") + "-й амортизационной группы".
   ELSE
      mName = STRING(loan.cont-code, "x(13)")
         + " - " + asset.name.

   {wordwrap.i
      &s = mName
      &l = mNameWidth
      &n = EXTENT(mName)
   }

/* Итого за период отчёта */
   DO mCnt = MONTH(beg) TO MONTH(dob):
      ASSIGN
         mMonSum[13]   = mMonSum[13]   + mMonSum[mCnt]
         mRepSum[mCnt] = mRepSum[mCnt] + mMonSum[mCnt].
   END.

/* Итого c начала года  */
/*   DO mCntYear = 1 TO MONTH(dob):
      ASSIGN
         mYearAmor[13]   = mYearAmor[13]   + mYearAmot[mCntYear]
         mRepSum[mCnt] = mRepSum[mCnt] + mMonSum[mCnt]. 
   END.*/

/* Срок эксплуатации (ДР карточки СрокЭкспл)    */
   mExplPer = INT(GetXAttrValueEx("loan",
                                  loan.contract + "," + loan.cont-code,
                                  "СрокЭкспл",
                                  "0"
                                 )
                 ) NO-ERROR.

   IF ERROR-STATUS:ERROR THEN
      mExplPer = 0.

/* Срок гашения стоимости (ДР карточки СрокГашСтоим)    */
   mGashPer = INT(GetXAttrValueEx("loan",
                                  loan.contract + "," + loan.cont-code,
                                  "СрокГашСтоим",
                                  "0"
                                 )
                 ) NO-ERROR.

   IF ERROR-STATUS:ERROR THEN
      mGashPer = 0.
/* Срок полезного использования */

   ASSIGN
      mUsefulLife = GetSrokAmor (RECID(loan),
                                 "СПИН",
                                 dob
                                )
      mUsefulLife =  INT(mUsefulLife)  - INT(mExplPer).
    If mUsefulLife eq ? then mUsefulLife = mGashPer.

/* Дата приходования основного средства в бухгалтерии */
   mDateIn  = GetInDate (loan.contract,
                         loan.cont-code,
                         "Б"
                        ).

 /*  IF mDone THEN
   DO:*/
/* Дата реализации (регистрации права) */
if not avail op then mDateOut = dob. else
   do:
      mDateOut = Str2Date(GetXAttrValueEx("op",
                                          STRING(op.op),
                                          "ДатаОпер",
                                          ?
                                         )
                         ).

      IF mDateOut = ? THEN
         mDateOut = op.op-date.
   end.
	 
/* Период эксплуатации (в месяцах) */

      mOperPer = MonInPer (mDateIn,
                           mDateOut
                          ).
 
 /* Период эксплуатации (в месяцах) 2 в целых месяцах */
      
      mDateIn2 = lastmondate(mDateIn).
      mDateOut2 = firstmondate(mDateOut).
      mOperPer2 = MonInPer (mDateIn2,
                           mDateOut2
                          ) + 1.
      IF (month(mDateIn) EQ month(mDateOut)
      and year(mDateIn) EQ year(mDateOut))
      then mOperPer2 = 0.
      
/* Осталось эксплуатировать (в месяцах) */

        mOstPer = int((mUseFulLife) - (mOperPer2)).
/*        if (mOstPer - truncate(mOstPer,0)) < 0.4
        then mOstPer = int(mOstPer).
	else mOstPer = INT(truncate(mOstPer,0)) + 1.
*/      
/* расчет период консервации */
   mConsPers  = GetXAttrValueEx("loan",
                                loan.contract + "," + loan.cont-code,
                                "ПериодКонс",
                                ?
                                ).
   
    IF mConsPers <> ? THEN
    DO:
    mConsPer = int(MonInPer (DATE(ENTRY(1, mConsPers, "-")),
                         DATE(ENTRY(2, mConsPers, "-"))
                          )).
    mOstPer = mOstPer +  mConsPer.
    END.
                

        if mOstPer < 0  or mOstPer eq ? then mOstPer = 0.
      
          
/* Дата истечения срока полезного использования */
      mDead-Line = GoMonth (mDateIn,
                            INT(mUsefulLife)
                           ).

/* Расходы, связанные с реализацией             */
      mRealCosts = GetRealCosts().
/*   END.*/
/* Коэффициент ускорения амортизации */
   mAmorAcclr = GetSrokAmor (RECID(loan),
                            "КУН",
                             dob
                            ).
   IF mAmorAcclr = ? OR
      mAmorAcclr = 0 THEN
      mAmorAcclr = 1.

/* Налоговая норма амортизации месячная в %%    */
   mAmortNorm = GetAmortNorm (loan.contract,
                              loan.cont-code,
                              dob,
                              "Н"
                             ).

/* Инициализация по новой карточке УМЦ */
   RUN Change        IN mH (loan.contract,
                            loan.cont-code,
                            ?,
                            ?
                           ).

/* Находим стоимость по НУ на начало периода */   
	  

   RUN ПервСтоимНал IN mH (      DATE(01/01/0001),
                            OUTPUT mInvCost
                           ).
/*MESSAGE "minvcost= " mInvCost VIEW-AS ALERT-BOX.*/
	
    /* mInvCost = GetLoan-Pos (loan.contract,loan.Cont-Code,"нал-учет",mDateIn).*/


/* Находим стоимость по НУ на конец периода
 	Было:     
   RUN ПервСтоимНал2 IN mH (       dob,
                            OUTPUT mInvCostEnd
                           ).
	Стало:
*/
     mInvCostEnd = GetLoan-Pos (loan.contract,
                             loan.Cont-Code,
                             "нал-учет",
                             dob).

	ASSIGN
    	mPremia10 = 0
    	mPremia30 = 0
    .                            
	
/* Находим премию            */	
/*

	IF ABS(mPremia - (mInvCost / 10))<1 THEN mPremia10 = mPremia .
	IF ABS(mPremia - (30 * mInvCost / 100))<1 THEN mPremia30 = mPremia .	
*/

        tempvar = ofunc:FindAmortPremia(loan.cont-code,loan.contract,dob).
	mPremia10 = DEC(ENTRY(1,tempvar,";")).
	mPremia30 = dec(ENTRY(2,tempvar,";")).

   
/*MESSAGE loan.contract loan.cont-code loan-acct.acct mPremia mPremia10 mPremia30 "beg=" beg " dob=" dob " mInvCost=" mInvCost " mInvCostEnd=" mInvCostEnd 	VIEW-AS ALERT-BOX.*/ 

ASSIGN 	mPremia = 0.

/* Изменение первоначальной стоимости           */
   mInvCostChng = mInvCostEnd - mInvCost .


/* Сумма амортизации на начало периода отчёта   */
   RUN НачАморНал    IN mH (       beg - 1,
                            OUTPUT mInitAmor
                           ).
/* Повторная инициализация для разблокировки пересчета НачАморНал */
   RUN Change        IN mH (loan.contract,
                            loan.cont-code,
                            ?,
                            ?
                           ).

/* Сумма амортизации на конец  периода отчёта   */
   RUN НачАморНал    IN mH (       dob,
                            OUTPUT mLastAmor
                           ).


/* Повторная инициализация для разблокировки пересчета НачАморНал */
   RUN Change        IN mH (loan.contract,
                            loan.cont-code,
                            ?,
                            ?
                           ).
/* Сумма амортизации на начало текущего года*/
   RUN НачАморНал    IN mH (DATE(1, 1, YEAR(dob)) ,
	                    OUTPUT mYearAmor
			    ).

  mYearAmor =  mLastAmor - mYearAmor.
  
/* Остаточная стоимость на конец периода отчета */
   mOstCost = mInvCost + mInvCostChng - mLastAmor.
   
  
   if mOstCost = 0 then mOstPer = 0. /*убираем срок службы если остаточная стоимость 0 */
    if mUseFulLife ne mOstPer then do:
       mRasAmor = (mInvCost + mInvCostChng - mLastAmor) / (mOstPer).
       end.
     else do: /*убираем расчет средств за этот месяц */
     mRasAmor = 0.
     end.
     
     mRazn=abs(mMonSum[13] - mRasAmor).
       	
   If mRazn = .0 then mShod= 1. else 
    do:
    mShod=0.
    end.    

/* Прибыль(убыток) от реализации                */
   mSalesIncome = mMonSum[13]
               - (mInvCost + mInvCostChng)
               + mLastAmor - mRealCosts.

/* Кол-во месяцев отнесения убытка на расходы   */
   IF mOpDoc
   THEN DO:
      mLossMonth = (IF mSalesIncome < 0 THEN
                       MonInPer(mDateOut, mDead-Line)
                    ELSE
                       .0
                   ).
      IF mLossMonth <> TRUNC(mLossMonth, 0) THEN
         mLossMonth =  TRUNC(mLossMonth, 0) + 1.
   
   /* Сумма расходов, приходящаяся на каждый месяц */
      mLossMonSum = (IF mLossMonth > 0
                     THEN ROUND(mSalesIncome / mLossMonth, 0)
                     ELSE 0
                    ).
   END.
END PROCEDURE.

/* Загрузка строк шаблона во временную таблицу ttPattern */
PROCEDURE SetPattern:
   DEF INPUT PARAMETER iPatt AS CHAR NO-UNDO. /* Строка шаблона */
   DEF INPUT PARAMETER iKind AS INT  NO-UNDO. /* Тип строки     */

   DEF VAR vCnt    AS INT NO-UNDO.

   DO vCnt = 1 TO NUM-ENTRIES(iPatt, "~n"):
      CREATE
         ttPattern.

      ASSIGN
         ttPattern.Kind  = iKind
         ttPattern.LineN = vCnt
         ttPattern.Patt  = ENTRY(vCnt, iPatt, "~n").
   END.

   RETURN.

END PROCEDURE.

/*  Предварительная обработка шаблонов */
PROCEDURE CorrectPattern:

   /* Счётчик элементов в строке параметров        */
   DEF VAR vCnt         AS INT     NO-UNDO.
   /* Вспомогательная символьная переменная        */
   DEF VAR vTmpChar     AS CHAR    NO-UNDO.
   /* Элемент списка                               */
   DEF VAR vItem        AS CHAR    NO-UNDO.

   /* Установки для внешней процедуры печати */
   ASSIGN
      xresult   = 0
      printres  = NO.

   /* Сразу корректируем период отчёта.
      Корректировать не будем - может, нужно посмотреть не с начала года!
   ASSIGN
     dob = LastMonDate(dob - 1)
     beg = DATE(1, 1, YEAR(dob)).
   */
   IF YEAR(beg) <> YEAR(dob) THEN
   DO:
      PUT STREAM fil UNFORMATTED
         "** ОШИБКА: ДАННЫЙ ОТЧЁТ НЕ МОЖЕТ БЫТЬ СФОРМИРОВАН ЗА ПЕРИОД," SKIP
         "           ДАТЫ НАЧАЛА И КОНЦА КОТОРОГО ОТНОСЯТСЯ К РАЗНЫМ ГОДАМ!".

      RETURN ERROR.
   END.

   /* Разбор строки параметров */
   ASSIGN
      vTmpChar = REPLACE(xStr, "_", " ")
      xStr     = "".

   DO vCnt = 1 TO NUM-ENTRIES(vTmpChar, "|"):
      vItem = ENTRY(vCnt, vTmpChar, "|").
      IF      vItem BEGINS "ГРУППА:" THEN
      DO:
         mAmorGr = SUBSTR(vItem, LENGTH("ГРУППА:") + 1).
         mFilt   = YES.
      END.
      ELSE IF vItem BEGINS "ИТОГО:"  THEN
         mItog   = YES.
      ELSE IF vItem BEGINS "РОЛЬ:"   THEN
         mRoleSfx = SUBSTR(vItem, LENGTH("РОЛЬ:") + 1).
      ELSE IF vItem BEGINS "ШАБЛОН:" THEN
         xStr = xStr + "~n"
              + SUBSTR(vItem, LENGTH("ШАБЛОН:") + 1).
   END.

   xStr = TRIM(xStr, "~n").

   /* Загружаем шаблоны во врем.таблицу ttPattern */
   RUN SetPattern (page_header, 1).
   RUN SetPattern (xStr,        2).
   RUN SetPattern (page_footer, 3).

   /* Обнуляем строки заголовка и подвала */
   ASSIGN
      page_header = ""
      page_footer = "".

   /* Дополнение шаблонов строк отчёта колонками по месяцам */
   FOR EACH ttPattern:

      ttPattern.Patt = fill-str_ (ttPattern.Patt, "PATTERN").

      CASE ttPattern.Kind:
         WHEN 1 THEN
            page_header = page_header + "~n" + ttPattern.Patt.

         WHEN 3 THEN
            page_footer = page_footer + "~n" + ttPattern.Patt.
      END CASE.

      PrinterWidth = MAX(PrinterWidth, LENGTH(ttPattern.Patt)).
   END.

   /* Установка правильных заголовка и подвала */
   ASSIGN
      page_header = TRIM(page_header, "~n")
      page_footer = TRIM(page_footer, "~n").

   RETURN.

END PROCEDURE.

/* Функция проверяет, является ли строка числом */
FUNCTION IsDecimal RETURNS LOGICAL (iStr  AS CHAR):

   DEF VAR vDecVar AS DECIMAL NO-UNDO.

   vDecVar = DECIMAL(iStr) NO-ERROR.

   RETURN (ERROR-STATUS:ERROR = NO).

END FUNCTION.

/* Функция для разбора строки шаблона отчёта
  Параметры:
    str_   строка шаблона отчёта
    regim: PATTERN - корректировка шаблонов
           MAIN    - основная строка отчёта
           ADD     - дублированная строка отчёта для вывода длинных наименований
           TOTAL   - итоговая строка отчёта
*/
FUNCTION fill-str_ RETURNS CHAR (str_  AS CHAR,
                                 regim AS CHAR):
   /* Названия месяцев */
   DEF VAR vMonthNam    AS CHAR    NO-UNDO EXTENT 12 INIT
   [ "  январь" , "  февраль", "  март"    ,
     "  апрель" , "  май"    , "  июнь"    ,
     "  июль"   , "  август" , "  сентябрь",
     "  октябрь", "  ноябрь" , "  декабрь"
   ].

   /* Строка для результата функции */
   DEF VAR vRetStr        AS CHAR    NO-UNDO.

   /* Характеристики параметра { } из шаблона */
   DEF VAR vFrom   AS INT     NO-UNDO. /* Позиция { в строке */
   DEF VAR vTo     AS INT     NO-UNDO. /* Позиция } в строке */
   DEF VAR vLength AS INT     NO-UNDO. /* Ширина параметра   */
   DEF VAR vCode   AS CHAR    NO-UNDO. /* Код параметра      */
   DEF VAR vValue  AS CHAR    NO-UNDO. /* Значение параметра */

   /* Вспомогательные переменные */
   DEF VAR i            AS INT     NO-UNDO.
   DEF VAR j            AS INT     NO-UNDO.
   DEF VAR d            AS CHAR    NO-UNDO.
   DEF VAR vTmpStr      AS CHAR    NO-UNDO.
   DEF VAR vTmpSum      AS DECIMAL NO-UNDO.

   vRetStr = "".
   DO i = 1 TO LENGTH(str_):
      vValue = SUBSTR(str_, i, 1).

      IF vValue = "~{" THEN
      DO:
         ASSIGN
            d            = ""
            vFrom   = i
            vTo     = INDEX (str_, "~}", i)
            vLength = vTo - vFrom + 1
            vCode   = TRIM(SUBSTR(str_, vFrom + 1, vLength - 2)).

         IF vCode = "" THEN
            vValue = FILL(" ", vLength).

         ELSE IF regim = "PATTERN" THEN
         DO:
            IF vCode = "Наименование" THEN

               mNameWidth = vLength.

            ASSIGN
               vValue = ""
               vTmpStr     = SUBSTR(str_, vFrom, vLength).

            IF vCode MATCHES "*(#)" THEN
            DO:
               vCode = REPLACE(vCode, "_", " ").
               DO j = MONTH(beg) TO MONTH(dob):
                  IF vCode BEGINS "Месяц(#)" THEN
                     ASSIGN
                        d = " " + vMonthNam[j]
                        d = d + FILL(" ", vLength - LENGTH(d)).
                  ELSE IF vCode MATCHES ".(#)" THEN
                     d = FILL(SUBSTR(vCode, 1, 1), vLength).
                  ELSE
                     ASSIGN
                        d = STRING(j)
                        d = d + FILL(" ", 3 - LENGTH(d))
                        d = REPLACE(vTmpStr, "(#)", d).

                  vValue = vValue + d.

                  IF j < MONTH(dob) THEN
                    vValue = vValue + SUBSTR(str_, vTo + 1, 1).
               END.
            END.
            ELSE
               vValue = vTmpStr.
         END.

         ELSE
         DO:
            IF vCode = "Наименование" THEN
               d = (IF regim = "TOTAL"
                    THEN " ИТОГО ПО ОТЧЁТУ:"
                    ELSE mName[mCntNam]
                   ).
            ELSE IF CAN-DO("MAIN,TOTAL", regim) THEN
            DO:
               vTmpSum = 0.
               /* КартСум  - приход на счёт за период
               ** КартСумN - приход на счёт за месяц (N: 1..12)
               */
               IF vCode BEGINS "КартСум" THEN
               DO:
                  j = INT(SUBSTR(vCode, 8)) NO-ERROR.
                  IF ERROR-STATUS:ERROR OR
                     j <= 0             OR
                     j > 12  THEN
                     j = 13.

                  vTmpSum = mMonSum[j].
               END.
               ELSE
               CASE vCode:
	       
                  WHEN "НачСт"      THEN
                     vTmpSum = mInvCost.

                  WHEN "ИзмНачСт"   THEN
                     vTmpSum = mInvCostChng.

                  WHEN "НачСтИзм"   THEN
                     vTmpSum = mInvCost + mInvCostChng.
         		 
         		  WHEN "Премия10"      THEN
                     vTmpSum = mPremia10.
			      WHEN "Премия30"      THEN
                     vTmpSum = mPremia30.

                     

                  WHEN "НачАмор"    THEN
                     vTmpSum = /* mInitAmor */ mOstCost.
		     
		  WHEN "ГодАмор"    THEN
		     vTmpSum = mYearAmor.

                  WHEN "ИтгАмор"    THEN
                     vTmpSum = mInitAmor + mMonSum[13].
                  /* Если база не кривая, то по операциям амортизации
                  ** должно быть: КонАмор=ИтгАмор=НачАмор+КартСум
                  */
                  WHEN "КонАмор"    THEN
                     vTmpSum = mLastAmor.
		  WHEN "РасАмор"    THEN
                     vTmpSum = mRasAmor.
		     
                  WHEN "ОстСт"      THEN
                     vTmpSum = mInvCost + mInvCostChng - mLastAmor.

                  WHEN "РасхРеал"   THEN
                     vTmpSum = mRealCosts.

                  WHEN "ПрибРеал"   THEN
                     vTmpSum = mSalesIncome.

                  WHEN "МесРасх"      THEN
                     vTmpSum = mLossMonSum.

               END CASE.

               d = (IF vTmpSum = 0 or vTmpSum = ?
                    THEN ""
                    ELSE STRING(vTmpSum, DefaultFormat)
                   ).
            END.

            IF regim = "MAIN" THEN
            CASE vCode:
               WHEN "№№№"          THEN
                  d = STRING(mCntLin).

               WHEN "Приобрет"     THEN
                  d = GetXAttrValueEx("loan",
                                      loan.contract + "," + loan.cont-code,
                                      "ДогПокупДата",
                                      ""
                                     ).

               WHEN "ДатаПрих"     THEN
                  d = STRING(mDateIn,  "99/99/9999").
             
	       WHEN  "Сход" THEN
	    	DO:
		  IF mRazn = ? THEN
                     d = "".
		   ELSE IF truncate(mRazn,2) = .0 THEN
		     d = "Ok".  
                  ELSE
                     d = string(mRazn,">>>>>9.99").
	       END.
     
               WHEN "ДатаОпер"     THEN
                  d = STRING(mDateOut, "99/99/9999").

               WHEN "ПерЭксп"      THEN
                  d = STRING(mOperPer, ">>>>>9.99").
	       
	       WHEN "ПерОст"      THEN
	       DO:
                  IF mOstPer = ? THEN
                     d = "".
                  ELSE
                     d = STRING(mOstPer).
               END.
	       WHEN "ДатаСПИ"      THEN
                  d = STRING(mDead-Line, "99/99/9999").

               WHEN "МесУбРасх"    THEN
                  d = STRING(mLossMonth, "zzzzzzz9").

               WHEN "АмГр"         THEN
                  d = GetXAttrValueEx("asset",
                                      GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                                      "AmortGr",
                                      ""
                                     ).
               WHEN "ОКОФ"         THEN
                  d = GetXAttrValueEx("asset",
                                      GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                                      "OKOF",
                                      ""
                                     ).
               WHEN "СПИ"          THEN
               DO:
                  IF mUsefulLife = ? THEN
                     d = "".
                  ELSE
                     d = STRING(mUsefulLife).
               END.
               WHEN "НрмАмр"       THEN
                  d = STRING(mAmortNorm, "zzzzzz9.999") + "%".

               OTHERWISE IF vCode MATCHES "ДР.(*)" THEN
               DO:
                  ASSIGN
                     d     = ENTRY(1, vCode, "(")
                     vCode = ENTRY(1, ENTRY(2, vCode, "("), ")").

                  CASE d:
                     /* ДР карточки УМЦ */
                     WHEN "ДРК" THEN
                        d = GetXAttrValueEx("loan",
                                            loan.contract +
                                            "," + loan.cont-code,
                                            vCode,
                                            ""
                                           ).
                     /* ДР ценности    */
                     WHEN "ДРЦ" THEN
                        d = GetXAttrValueEx("asset",
                                            GetSurrogateBuffer("asset",(BUFFER asset:HANDLE)),
                                            vCode,
                                            ""
                                           ).
                     /* ДР последней за период операции по карточке УМЦ */
                     WHEN "ДРО" THEN
                     DO:
                        IF mOpDoc THEN
                           d = GetXAttrValueEx("op",
                                               STRING(op.op),
                                               vCode,
                                               ""
                                              ).
                        ELSE
                           d = "".

                     END.
                     OTHERWISE
                        d = "".
                  END CASE.
               END.
            END CASE.

            d = TRIM(d).

            IF d = "" THEN
               vValue = FILL(" ", vLength).

            ELSE IF d = ? THEN
               vValue = FILL("?", vLength). /* ???????, если ошибка */

            ELSE
            DO:
               IF IsDecimal (REPLACE(d, "%", "")) THEN
                  vValue = FILL(" ", vLength - LENGTH(d)) + d.
               ELSE
                  vValue = d + FILL(" ", vLength - LENGTH(d)).
            END.
         END.

         i = vTo.
      END.

      vRetStr = vRetStr + vValue.
   END.

   RETURN vRetStr.

END FUNCTION.

/* Расходы, связанные с реализацией */
FUNCTION GetRealCosts RETURN DECIMAL:

   DEF BUFFER loan-acct FOR loan-acct.
   DEF BUFFER acct      FOR acct.
   DEF BUFFER op-entry  FOR op-entry.

   FOR
      EACH  loan-acct      WHERE
            loan-acct.contract  = loan.contract
        AND loan-acct.cont-code = loan.cont-code
        AND loan-acct.acct-type = loan.contract + "-нал-ликв"
        AND loan-acct.since    <= dob
         NO-LOCK,

      LAST  acct           WHERE
            acct.acct           = loan-acct.acct
        AND acct.currency       = loan-acct.currency
         NO-LOCK,

      EACH  op-entry       WHERE
           (op-entry.acct-db    = loan-acct.acct            AND
            op-entry.op-date   >= MAX(beg, loan-acct.since) AND
            op-entry.op-date   <= dob                       AND
            acct.side           = "А"
           )
        OR (op-entry.acct-cr    = loan-acct.acct            AND
            op-entry.op-date   >= MAX(beg, loan-acct.since) AND
            op-entry.op-date   <= dob                       AND
            acct.side           = "П"
           )
         NO-LOCK:

      ACCUMULATE op-entry.amt-rub (TOTAL).
   END.

   RETURN (ACCUM TOTAL op-entry.amt-rub).

END FUNCTION.

DELETE OBJECT ofunc.
