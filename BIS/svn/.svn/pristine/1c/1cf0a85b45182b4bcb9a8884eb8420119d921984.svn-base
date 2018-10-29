/*
               Банковская интегрированная система БИСквит
    Copyright: (C) ТОО "Банковские информационные системы"
     Filename: DOCFORM.I
      Comment: Описание и вывод различных форм документов
               пока присутствует расходный и прих. кассовые ордера
   Parameters:
         Uses:
      Used by: cashord.p
      Created: 22.06.2004 10:37 sadm    
     Modified: 22.06.2004 19:36 sadm     
     Modified: 23.06.2004 14:46 sadm     
     Modified: 29.06.2004 19:30 sadm     
     Modified: 13.03.2007 19:35 duvu     <comment>
     Modified: 18.03.2008       muta 0090529 Выводится только наименование валюты 
     Modified: 02/02/2011 kraw (0127446) Если в расходном более 3-х символов
*/

&IF DEFINED(nodef) EQ 0 &THEN
   {sumstrfm.i}
   {wordwrap.def}
   DEFINE VARIABLE mchBuhSum AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE mchStrSum AS CHARACTER EXTENT 10 NO-UNDO.
   DEFINE VARIABLE mchStrIntSum AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE mchStrDecSum AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE mchStrDocDate AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE mchDetails AS CHARACTER
      &IF DEFINED(LAW_318p) <> 0 &THEN
         EXTENT 8
      &ELSE
         EXTENT 10
      &ENDIF
   NO-UNDO.
   DEFINE VARIABLE mchDocCurName AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE i             AS INT64    NO-UNDO.
   DEFINE VARIABLE j             AS INT64    NO-UNDO.
   DEFINE VARIABLE mchCurCode    AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE mchNPNV       AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE mKasOrdTal   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE mKasOrdEqv   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE mCopyDocNum  LIKE {&docnum}     NO-UNDO.
   DEFINE VARIABLE mCopyDocDate LIKE mchStrDocDate NO-UNDO.

   &IF DEFINED(cashord) NE 0 &THEN
      DEFINE VARIABLE mchBuhSymSumIn  AS CHARACTER EXTENT 6 NO-UNDO.
      DEFINE VARIABLE mchBuhSymSumOut AS CHARACTER EXTENT 6 NO-UNDO.
      DEFINE VARIABLE minSymCount     AS INT64            NO-UNDO.
      DEFINE VARIABLE mchBankMFO      AS CHARACTER          NO-UNDO.
      DEFINE VARIABLE mchIdentityCard AS CHARACTER EXTENT 4 NO-UNDO.
      DEFINE VARIABLE mchCoupon       AS CHARACTER          NO-UNDO.
   &ENDIF

   &IF DEFINED(LAW_318p) <> 0 &THEN
      DEFINE VARIABLE mCopyBuhSum    LIKE mchBuhSum     NO-UNDO.
      DEFINE VARIABLE mCopyStrSum    LIKE mchStrSum     NO-UNDO.
      DEFINE VARIABLE mCopyDbAcct    LIKE {&dbacct}     NO-UNDO.
      DEFINE VARIABLE mCopyCrAcct    LIKE {&cracct}     NO-UNDO.
      DEFINE VARIABLE mCopyRecBank   LIKE {&recbank}    NO-UNDO.
      DEFINE VARIABLE mCopyPayBank   LIKE {&paybank}    NO-UNDO.
      DEFINE VARIABLE mCopyDetails   LIKE mchDetails    NO-UNDO.
      DEFINE VARIABLE mCopyWorkerKas LIKE {&worker_kas} NO-UNDO.
      DEFINE VARIABLE mCopyWorkerBuh LIKE {&worker_buh} NO-UNDO.
   &ENDIF
&ENDIF

ASSIGN
   mKasOrdTal  = FGetSetting("КасОрд№Тал", ?,"")
   mKasOrdEqv  = FGetSetting("КасОрдЭквив",?,"").

FOR FIRST currency NO-LOCK WHERE currency.currency = {&doccur}:
   mchDocCurName = currency.name-currenc.
END.

mchStrDocDate = {strdate.i {&docdate}}.
&IF DEFINED(LAW_318p) <> 0 &THEN
   mchStrDocDate = REPLACE(mchStrDocDate, " г.", " года").
&ENDIF

&IF DEFINED(LAW_318p) <> 0 &THEN
   mchBuhSum = TRIM(AmtStrFormat({&docsum}, 
      &IF DEFINED(cashord) NE 0 &THEN
         ( IF {&cashord} = "приходно─расходный"
           THEN "zzzzzzz9=99"
           ELSE
      &ENDIF
              "-zzzzzzzzzzzzzzzzzzzzz9=99"
      &IF DEFINED(cashord) NE 0 &THEN
         )
      &ENDIF
   )).
&ELSE
   mchBuhSum = AmtStrFormat({&docsum}, "-zzzzzzzzzz9=99").
&ENDIF

RUN x-amtstr.p ({&docsum},
                {&doccur},
                YES,
                YES,
                OUTPUT mchStrIntSum, OUTPUT mchStrDecSum).
mchStrSum[1] = mchStrIntSum + " " + mchStrDecSum.

&IF DEFINED(cashord) NE 0 &THEN
   /***** кассовые ордера **************/
   DO minSymCount = 1 TO EXTENT({&symsumin}):
      mchBuhSymSumIn[minSymCount] =
         IF {&symsumin}[minSymCount] = 0 THEN ""
            ELSE AmtStrFormat({&symsumin}[minSymCount],
                    &IF DEFINED(LAW_318p) <> 0 &THEN
                       (IF {&cashord} = "приходно─расходный"
                        THEN "-zzzzzzz9=99"
                        ELSE "-zzzzzzzz9=99")
                    &ELSE
                       "-zzzzzzzzzz9=99"
                    &ENDIF
                 ).
   END.
   DO minSymCount = 1 TO EXTENT({&symsumout}):
      mchBuhSymSumOut[minSymCount] =
         IF {&symsumout}[minSymCount] = 0 THEN ""
            ELSE AmtStrFormat({&symsumout}[minSymCount],
                    &IF DEFINED(LAW_318p) <> 0 &THEN
                       (IF {&cashord} = "приходно─расходный"
                        THEN "-zzzzzzz9=99"
                        ELSE "-zzzzzzzz9=99")
                    &ELSE
                       "-zzzzzzzzzz9=99"
                    &ENDIF
                 ).
   END.
   /* получаем параметр процедуры, регулирующий, какой ДР нац.валюты
      использовать */
   FOR FIRST user-proc WHERE user-proc.procedure EQ "cashord":U NO-LOCK:
      mchNPNV = GetParamByNameAsChar(
                   getXattrValueEx("user-proc",
                                   STRING(user-proc.public-number),
                                   "ExParam":U,
                                   ""
                   ),
                   "НПнацВал":U,
                   ""
      ).
   END.

   IF FGetSetting("КасКодВал", ?,"Да") NE "Нет" THEN DO:
      /* КодНацВал0406007 берется первым, если не указано иначе */
      mchCurCode = IF {&doccur} EQ "" THEN
                      IF mchNPNV EQ "" OR mchNPNV EQ "КодНацВал0406007":U THEN
                         FGetSetting("КодНацВал0406007":U, ?, "")
                      ELSE ""
                   ELSE {&doccur}.
      /* КодНацВал0406007 берется вторым, если не указано иначе или есть
         КодНацВал0406007 */
      mchCurCode = IF mchCurCode EQ "" THEN
                      IF mchNPNV EQ "" OR mchNPNV EQ "КодНацВал":U THEN
                         FGetSetting("КодНацВал":U, ?, "")
                      ELSE ""
                   ELSE mchCurCode.

      mchStrSum[1] = mchStrSum[1] + " (" + mchDocCurName + " (" + mchCurCode + "))".
   END.
   ELSE
      &IF DEFINED(LAW_318p) = 0 &THEN
         mchStrSum[1] = mchStrSum[1] + " (" + mchDocCurName + ")"
      &ENDIF
   .

&IF DEFINED(natsum) NE 0 &THEN
   IF {&doccur} NE "" AND mKasOrdEqv EQ "Да" THEN
      mchStrSum[1] = mchStrSum[1] + "~n" + "Сумма рублей по курсу ЦБ" + AmtStrFormat({&natsum}, "-zzzzzzzzzz9=99").
&ENDIF

   IF {&cashord} = "приходный" THEN DO:
   /****** приходные кассовые ордера */
      {&payer}[1] = "От кого " + {&payer}[1].
      {&receiver}[1] = "Получатель " + {&receiver}[1].
      &IF DEFINED(LAW_318p) <> 0 &THEN
         mchStrSum[1] = "Сумма прописью с указанием наименования валюты " + mchStrSum[1].
         {wordwrap.i &s=mchStrSum   &n=3 &l=72}
         {wordwrap.i &s={&payer}    &n=3 &l=45}
         {wordwrap.i &s={&receiver} &n=3 &l=45}
         IF {&receiver}[3] = ""
            THEN ASSIGN
               {&receiver}[3] = {&receiver}[2]
               {&receiver}[2] = ""
            .
         {&paybank}[1] = "Наименование банка─вносителя " + {&paybank}[1].
         {wordwrap.i &s={&paybank}  &n=2 &l=72}
         {&recbank}[1] = "Наименование банка─получателя " + {&recbank}[1].
         {wordwrap.i &s={&recbank}  &n=2 &l=72}
         mchDetails[1] = "Источник поступления " + {&details}.
         {wordwrap.i &s=mchDetails  &n=8 &l=100}
         IF {&recacct} = ""
            THEN {&recacct} = FILL(" ",16) + FILL("─",31).
         IF {&recinn} = ""
            THEN {&recinn} = FILL(" ",3) + FILL("─",4).
         IF {&reckpp} = ""
            THEN {&reckpp} = FILL(" ",7) + FILL("─",11).
         IF {&recokato} = ""
            THEN {&recokato} = FILL(" ",5) + FILL("─",7).
      &ELSE
         {wordwrap.i &s=mchStrSum   &n=3 &l=73}
         {wordwrap.i &s={&payer}    &n=3 &l=47}
         {wordwrap.i &s={&receiver} &n=2 &l=47}
         {&recbank}[1] = "Банк получателя " + {&recbank}[1].
         {wordwrap.i &s={&recbank}  &n=2 &l=47}
         mchDetails[1] = "Источник взноса " + {&details}.
         {wordwrap.i &s=mchDetails &n=10 &l=73}
      &ENDIF

      &IF DEFINED(LAW_318p) = 0 &THEN
         /* сдвигаем заполненные строчки вниз массива */
         j = EXTENT(mchDetails).
         DO i = EXTENT(mchDetails) TO 1 BY -1 :
            IF mchDetails[i] NE "" AND j NE i THEN DO:
               ASSIGN
                  mchDetails[j] = mchDetails[i]
                  mchDetails[i] = ""
                  j = j - 1
               .
            END.
         END.
      &ENDIF

      &IF DEFINED(nodef) EQ 0 &THEN

         &IF DEFINED(LAW_318p) <> 0 &THEN
            FORM
            "                                                                                 ┌─────────────────┐" SKIP
            "                                                                                 │    Код формы    │" SKIP
            "                                                                                 │документа по ОКУД│" SKIP
            "                                                                                 ├─────────────────┤" SKIP
            "                                                                                 │     0402008     │" SKIP
            "                                                                                 └─────────────────┘" SKIP
            "                              ╔═════════╗                                                           " SKIP
            " Приходный кассовый ордер  N  ║         ║                                                           " SKIP
            "                              ╚═════════╝                                                           " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                       ДЕБЕТ                                        " SKIP
            "                                             ╔══════════════════════════╦══════════════════════════╗" SKIP
            "От кого                                      ║счет N                    ║                          ║" SKIP
            "                                             ║                          ║                          ║" SKIP
            "                                             ║                          ║                          ║" SKIP
            "─────────────────────────────────────────────╚══════════════════════════╣                          ║" SKIP
            "                                                       КРЕДИТ           ║                          ║" SKIP
            &IF DEFINED(cashord3) &THEN
               "─────────────────────────────────────────────╔══════════════════════════╣                          ║" SKIP
            &ELSE
               "─────────────────────────────────────────────╔══════════════════════════╣      Сумма цифрами       ║" SKIP
            &ENDIF
            "Получатель                                   ║счет N                    ║                          ║" SKIP
            "─────────────────────────────────────────────║                          ║                          ║" SKIP
            "                                             ║счет N                    ║                          ║" SKIP
            &IF DEFINED(cashord3) &THEN
               "                                             ║                          ║      Сумма цифрами       ║" SKIP
            &ELSE
               "                                             ║                          ║                          ║" SKIP
            &ENDIF
            "─────────────────────────────────────────────╚══════════════════════════╬══════════════════════════╣" SKIP
            "ИНН              КПП                              ОКАТО                 ║       в том числе        ║" SKIP
            "    ──────────       ─────────────────────────         ─────────────────║       по символам:       ║" SKIP
            "р/счет N                                                                ║                          ║" SKIP
            "         ───────────────────────────────────────────────────────────────║────────────┬─────────────║" SKIP
            "Наименование банка─вносителя                                            ║   символ   │    сумма    ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                  БИК                   ║            │             ║" SKIP
            "─────────────────────────────────────────────────     ──────────────────║────────────┼─────────────║" SKIP
            "Наименование банка─получателя                                           ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                  БИК                   ║            │             ║" SKIP
            "─────────────────────────────────────────────────     ──────────────────║────────────┼─────────────║" SKIP
            "Сумма прописью с указанием наименования валюты                          ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────╚══════════════════════════╝" SKIP
            "Источник поступления                                                                                " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
            "                                                                                                    " SKIP
            "────────────────────────────────────────────────────────────────────────────────────────────────────" SKIP
            &IF DEFINED(cashord3) <> 0 &THEN
               SKIP(1)
               "Приложения на ____ листах"
               SKIP(1)
               "Подпись вносителя" SKIP
               "                  ──────────────────" SKIP 
               SKIP(1)
               " Контролер                     Бухгалтерский работник                 Кассовый работник" SKIP
            &ELSE
               " Подпись вносителя        Бухгалтерский работник                        Кассовый работник           " SKIP
            &ENDIF
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            
            {&docnum}         FORMAT "X(09)" AT COLUMN 32 ROW 8
            mchStrDocDate     FORMAT "X(30)" AT COLUMN  2 ROW 10
            {&payer}[1]       FORMAT "X(45)" AT COLUMN  1 ROW 14
            {&payer}[2]       FORMAT "X(45)" AT COLUMN  1 ROW 15
            {&payer}[3]       FORMAT "X(45)" AT COLUMN  1 ROW 16
            {&receiver}[1]    FORMAT "X(45)" AT COLUMN  1 ROW 20
            {&receiver}[2]    FORMAT "X(45)" AT COLUMN  1 ROW 22
            {&receiver}[3]    FORMAT "X(45)" AT COLUMN  1 ROW 23
            {&recinn}         FORMAT "X(12)" AT COLUMN 5  ROW 25
            {&reckpp}         FORMAT "X(25)" AT COLUMN 22 ROW 25
            {&recokato}       FORMAT "X(16)" AT COLUMN 57 ROW 25
            {&recacct}        FORMAT "X(63)" AT COLUMN 10 ROW 27
            {&paybank}[1]     FORMAT "X(72)" AT COLUMN  1 ROW 29
            {&paybank}[2]     FORMAT "X(49)" AT COLUMN  1 ROW 31
            {&paybankbik}     FORMAT "X(18)" AT COLUMN 55 ROW 31
            {&recbank}[1]     FORMAT "X(72)" AT COLUMN  1 ROW 33
            {&recbank}[2]     FORMAT "X(49)" AT COLUMN  1 ROW 35
            {&recbankbik}     FORMAT "X(18)" AT COLUMN 55 ROW 35
            {&dbacct}         FORMAT "X(25)" AT COLUMN 47 ROW 15
            mchBuhSum         FORMAT "X(15)" AT COLUMN 74 ROW 15
            {&cracct}         FORMAT "X(25)" AT COLUMN 47 ROW 21
            {&acctkomis}      FORMAT "X(25)" AT COLUMN 47 ROW 23
            mchStrSum[1]      FORMAT "X(72)" AT COLUMN 1  ROW 37
            mchStrSum[2]      FORMAT "X(72)" AT COLUMN 1  ROW 39
            mchStrSum[3]      FORMAT "X(72)" AT COLUMN 1  ROW 41
            {&symcodin}[1]    FORMAT "XX"    AT COLUMN 79 ROW 31
            {&symcodin}[2]    FORMAT "XX"    AT COLUMN 79 ROW 33
            {&symcodin}[3]    FORMAT "XX"    AT COLUMN 79 ROW 35
            {&symcodin}[4]    FORMAT "XX"    AT COLUMN 79 ROW 37
            {&symcodin}[5]    FORMAT "XX"    AT COLUMN 79 ROW 39
            {&symcodin}[6]    FORMAT "XX"    AT COLUMN 79 ROW 41
            mchBuhSymSumIn[1] FORMAT "X(13)" AT COLUMN 87 ROW 31
            mchBuhSymSumIn[2] FORMAT "X(13)" AT COLUMN 87 ROW 33
            mchBuhSymSumIn[3] FORMAT "X(13)" AT COLUMN 87 ROW 35
            mchBuhSymSumIn[4] FORMAT "X(13)" AT COLUMN 87 ROW 37
            mchBuhSymSumIn[5] FORMAT "X(13)" AT COLUMN 87 ROW 39
            mchBuhSymSumIn[6] FORMAT "X(13)" AT COLUMN 87 ROW 41
            mchDetails[01]    FORMAT "X(100)" AT COLUMN 1  ROW 43
            mchDetails[02]    FORMAT "X(100)" AT COLUMN 1  ROW 44
            mchDetails[03]    FORMAT "X(100)" AT COLUMN 1  ROW 45
            mchDetails[04]    FORMAT "X(100)" AT COLUMN 1  ROW 46
            mchDetails[05]    FORMAT "X(100)" AT COLUMN 1  ROW 47
            mchDetails[06]    FORMAT "X(100)" AT COLUMN 1  ROW 48
            mchDetails[07]    FORMAT "X(100)" AT COLUMN 1  ROW 49
            mchDetails[08]    FORMAT "X(100)" AT COLUMN 1  ROW 50
            WITH FRAME mfrInOrdForm WIDTH 102 NO-LABELS.
         &ELSE
            FORM
            "                                      ╔════════╗" SKIP
            "       Приходный кассовый ордер No    ║        ║" SKIP
            "                                      ╚════════╝" SKIP
            "                                                         ДЕБЕТ" SKIP
            "                                               ╔═════════════════════════╦══════════════════════╗" SKIP
            "От кого                                        ║Сч.No                    ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "───────────────────────────────────────────────╚═════════════════════════╣                      ║" SKIP
            "                                                         КРЕДИТ          ║                      ║" SKIP
            "───────────────────────────────────────────────╔═════════════════════════╣                      ║" SKIP
            "Банк получателя                                ║Сч.No                    ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "───────────────────────────────────────────────║                         ║                      ║" SKIP
            "Получатель                                     ║                         ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "───────────────────────────────────────────────╚═════════════════════════╣    Сумма цифрами     ║" SKIP
            "                                                                         ╠══════════════════════╝" SKIP
            "Сумма прописью (наименование (код) валюты)  ─────────────────────────────║                       " SKIP
            "                                                                         ║                       " SKIP
            "                                                                         ║                       " SKIP
            "─────────────────────────────────────────────────────────────────────────║ в том числе           " SKIP
            "                                                                         ║ по символам:          " SKIP
            "─────────────────────────────────────────────────────────────────────────╠══════════════════════╗" SKIP
            "                                                                         ║     Сумма     │Символ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "─────────────────────────────────────────────────────────────────────────╚══════════════════════╝" SKIP
            SKIP(1)
            "Подпись вносителя              Бухгалтерский работник             Кассовый работник" SKIP
            SKIP(1)
            "М.П." SKIP
            SKIP(1)
            
            {&docnum}         FORMAT "X(8)"  AT COLUMN 40 ROW 2
            mchStrDocDate     FORMAT "X(30)" AT COLUMN  8 ROW 4
            {&payer}[1]       FORMAT "X(47)" AT COLUMN  1 ROW 6
            {&payer}[2]       FORMAT "X(47)" AT COLUMN  1 ROW 7
            {&payer}[3]       FORMAT "X(47)" AT COLUMN  1 ROW 8
            {&receiver}[1]    FORMAT "X(47)" AT COLUMN  1 ROW 15
            {&receiver}[2]    FORMAT "X(47)" AT COLUMN  1 ROW 16
            {&recbank}[1]     FORMAT "X(47)" AT COLUMN  1 ROW 12
            {&recbank}[2]     FORMAT "X(47)" AT COLUMN  1 ROW 13
            {&dbacct}         FORMAT "X(25)" AT COLUMN 49 ROW 7
            mchBuhSum         FORMAT "X(15)" AT COLUMN 82 ROW 7
            {&cracct}         FORMAT "X(25)" AT COLUMN 49 ROW 13
            mchStrSum[1]      FORMAT "X(73)" AT COLUMN  1 ROW 20
            mchStrSum[2]      FORMAT "X(73)" AT COLUMN  1 ROW 21
            mchStrSum[3]      FORMAT "X(73)" AT COLUMN  1 ROW 23
            mchBuhSymSumIn[1] FORMAT "X(15)" AT COLUMN 75 ROW 27
            mchBuhSymSumIn[2] FORMAT "X(15)" AT COLUMN 75 ROW 29
            mchBuhSymSumIn[3] FORMAT "X(15)" AT COLUMN 75 ROW 31
            mchBuhSymSumIn[4] FORMAT "X(15)" AT COLUMN 75 ROW 33
            mchBuhSymSumIn[5] FORMAT "X(15)" AT COLUMN 75 ROW 35
            mchBuhSymSumIn[6] FORMAT "X(15)" AT COLUMN 75 ROW 37
            {&symcodin}[1]    FORMAT "XX"    AT COLUMN 93 ROW 27
            {&symcodin}[2]    FORMAT "XX"    AT COLUMN 93 ROW 29
            {&symcodin}[3]    FORMAT "XX"    AT COLUMN 93 ROW 31
            {&symcodin}[4]    FORMAT "XX"    AT COLUMN 93 ROW 33
            {&symcodin}[5]    FORMAT "XX"    AT COLUMN 93 ROW 35
            {&symcodin}[6]    FORMAT "XX"    AT COLUMN 93 ROW 37
            mchDetails[01]    FORMAT "X(73)" AT COLUMN  1 ROW 28
            mchDetails[02]    FORMAT "X(73)" AT COLUMN  1 ROW 29
            mchDetails[03]    FORMAT "X(73)" AT COLUMN  1 ROW 30
            mchDetails[04]    FORMAT "X(73)" AT COLUMN  1 ROW 31
            mchDetails[05]    FORMAT "X(73)" AT COLUMN  1 ROW 32
            mchDetails[06]    FORMAT "X(73)" AT COLUMN  1 ROW 33
            mchDetails[07]    FORMAT "X(73)" AT COLUMN  1 ROW 34
            mchDetails[08]    FORMAT "X(73)" AT COLUMN  1 ROW 35
            mchDetails[09]    FORMAT "X(73)" AT COLUMN  1 ROW 36
            mchDetails[10]    FORMAT "X(73)" AT COLUMN  1 ROW 37
            WITH FRAME mfrInOrdForm WIDTH 100 NO-LABELS.
         &ENDIF
      /* конец описания формы прих.ордера */
      &ENDIF /*IF_DEFINED(nodef)*/

      DISPLAY {&docnum} /* вывод приходного ордера */
              {&payer}
              {&receiver}
              {&recbank}
              mchStrDocDate
              {&dbacct}
              mchBuhSum
              {&cracct}
              mchStrSum[1]
              mchStrSum[2]
              mchStrSum[3]
              mchBuhSymSumIn
              {&symcodin}
              mchDetails
              &IF DEFINED(LAW_318p) <> 0 &THEN
                 {&acctkomis}
                 {&recbankbik}
                 {&recinn}
                 {&reckpp}
                 {&recokato}
                 {&recacct}
                 {&paybank}[1]
                 {&paybank}[2]
                 {&paybankbik}
              &ENDIF
         WITH FRAME mfrInOrdForm.      
     
   END. /* приходный */
   ELSE IF {&cashord} = "расходный" THEN DO:

      IF mKasOrdTal EQ "Да" THEN 
         mchCoupon = "" .
      ELSE 
         mchCoupon = ({&docnum}).
   
      {&receiver}[1] = "Выдать " + {&receiver}[1].

      mchBankMFO = FGetSetting("БанкМФО","","").

      &IF DEFINED(LAW_318p) <> 0 &THEN
         IF {&documentdate} = "" THEN
            {&documentdate} = """  ""         20   года".
         {wordwrap.i &s={&receiver} &n=3 &l=45}
         mchDetails[1] = "Направление выдачи " + {&details}.
         {wordwrap.i &s=mchDetails  &n=5 &l=72}
         mchStrSum[1] = "Сумма прописью с указанием наименования валюты " + mchStrSum[1].
         {wordwrap.i &s=mchStrSum   &n=3 &l=72}
         IF NOT {assigned mchStrSum[3]}
            THEN mchStrSum[3] = "────────────────────────────────────────────────────────────────────────".
         {wordwrap.i &s={&recbank}  &n=2 &l=45}
         {wordwrap.i &s={&documentwho} &n=2 &l=65}
         IF {&documentwho}[2] = "" THEN ASSIGN
            {&documentwho}[2] = {&documentwho}[1]
            {&documentwho}[1] = ""
         .
      &ELSE
         mchIdentityCard[1] = "Предъявлен документ, удостоверяющий личность " +
            IF {&identcard} = "" THEN
               "____________________, No_________________ Выдан______________________________ _____ г."
            ELSE
               {&identcard}.
         {wordwrap.i &s=mchIdentityCard &n=3 &l=90}
         {wordwrap.i &s={&receiver} &n=2 &l=47}
         mchDetails[1] = "Назначение платежа " + {&details}.
         {wordwrap.i &s=mchDetails  &n=4 &l=73}
         {wordwrap.i &s={&payer}    &n=2 &l=47}
         {wordwrap.i &s=mchStrSum   &n=3 &l=73}
         {wordwrap.i &s={&recbank}  &n=2 &l=47}
      &ENDIF

      &IF DEFINED(nodef) EQ 0 &THEN
         /* описание расх. кассового ордера */
            FORM
            "                                                                                 ┌─────────────────┐" SKIP
            "                                                                                 │    Код формы    │" SKIP
            "                                                                                 │документа по ОКУД│" SKIP
            "                                                                                 ├─────────────────┤" SKIP
            "                                                                                 │     0402009     │" SKIP
            "                                                                                 └─────────────────┘" SKIP
            "                              ╔═════════╗                               ┌──────────────────────────┐" SKIP
            " Расходный кассовый ордер  N  ║         ║                               │      Отрывной талон      │" SKIP
            "                              ╚═════════╝                               │  к расходному кассовому  │" SKIP
            "                                                                        │       ордеру N _____     │" SKIP
            "                                                                        └──────────────────────────┘" SKIP
            "                                                                                                    " SKIP
            "                                                      ДЕБЕТ             ╔══════════════════════════╗" SKIP
            "                                             ╔══════════════════════════╣    Место для наклейки    ║" SKIP
            "Выдать                                       ║счет N                    ║     отрывного талона     ║" SKIP
            "                                             ║                          ║                          ║" SKIP
            "                                             ║                          ║                          ║" SKIP
            "─────────────────────────────────────────────╚══════════════════════════╬══════════════════════════╣" SKIP
            " (фамилия, имя, отчество)                             КРЕДИТ            ║                          ║" SKIP
            "─────────────────────────────────────────────╔══════════════════════════╣                          ║" SKIP
            "Наименование банка                           ║счет N                    ║                          ║" SKIP
            "                                             ║                          ║      Сумма цифрами       ║" SKIP
            "─────────────────────────────────────────────╚══════════════════════════╬══════════════════════════╣" SKIP
            "                                                  БИК                   ║       в том числе        ║" SKIP
            "──────────────────────────────────────────────────   ───────────────────║       по символам:       ║" SKIP
            "Сумма прописью с указанием наименования валюты                          ║                          ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║   символ   │    сумма    ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "Направление выдачи                                                      ║            │             ║" SKIP
            "                   ─────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────╚══════════════════════════╝" SKIP
            &IF DEFINED(cashord3) <> 0 &THEN
               "                                                                                                    " SKIP
               "                                                                                                    " SKIP
               "Приложения на ____ листах                                                                           " SKIP
               "                                                                                                    " SKIP
               "                                                                                                    " SKIP
            &ENDIF
            "Предъявлен документ, удостоверяющий личность                                 N                      " SKIP
            "                                             ───────────────────────────────   ─────────────────────" SKIP
            "                                                 (наименование документа)                           " SKIP
            "                                                                                                    " SKIP
            "Выдан                                                                    "  "        20  года       " SKIP
            "      ─────────────────────────────────────────────────────────────────                             " SKIP
            "                            (кем выдан)                                                             " SKIP
            "                                                                                                    " SKIP
            "Указанную в расходном кассовом ордере сумму получил ____________________                            " SKIP
            "                                                    (подпись получателя)                            " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "Бухгалтерский работник                   Контролер                Кассовый работник                 " SKIP
            
            {&docnum}          FORMAT "X(09)" AT COLUMN 32 ROW  8
            mchCoupon          FORMAT "X(06)" AT COLUMN 90 ROW 10
            mchStrDocDate      FORMAT "X(30)" AT COLUMN  2 ROW 11
            {&receiver}[1]     FORMAT "X(45)" AT COLUMN  1 ROW 15
            {&receiver}[2]     FORMAT "X(45)" AT COLUMN  1 ROW 16
            {&receiver}[3]     FORMAT "X(45)" AT COLUMN  1 ROW 17
            {&dbacct}          FORMAT "X(25)" AT COLUMN 47 ROW 16
            {&cracct}          FORMAT "X(25)" AT COLUMN 47 ROW 22
            mchBuhSum          FORMAT "X(15)" AT COLUMN 74 ROW 20
            mchBuhSymSumOut[1] FORMAT "X(13)" AT COLUMN 87 ROW 30
            mchBuhSymSumOut[2] FORMAT "X(13)" AT COLUMN 87 ROW 32
            mchBuhSymSumOut[3] FORMAT "X(13)" AT COLUMN 87 ROW 34
            mchBuhSymSumOut[4] FORMAT "X(13)" AT COLUMN 87 ROW 36
            mchBuhSymSumOut[5] FORMAT "X(13)" AT COLUMN 87 ROW 38
            mchBuhSymSumOut[6] FORMAT "X(13)" AT COLUMN 87 ROW 40
            {&symcodout}[1]    FORMAT "XX"    AT COLUMN 79 ROW 30
            {&symcodout}[2]    FORMAT "XX"    AT COLUMN 79 ROW 32
            {&symcodout}[3]    FORMAT "XX"    AT COLUMN 79 ROW 34
            {&symcodout}[4]    FORMAT "XX"    AT COLUMN 79 ROW 36
            {&symcodout}[5]    FORMAT "XX"    AT COLUMN 79 ROW 38
            {&symcodout}[6]    FORMAT "XX"    AT COLUMN 79 ROW 40
            mchDetails[1]      FORMAT "X(72)" AT COLUMN  1 ROW 30
            mchDetails[2]      FORMAT "X(72)" AT COLUMN  1 ROW 32
            mchDetails[3]      FORMAT "X(72)" AT COLUMN  1 ROW 34
            mchDetails[4]      FORMAT "X(72)" AT COLUMN  1 ROW 36
            mchDetails[5]      FORMAT "X(72)" AT COLUMN  1 ROW 38
            mchDetails[6]      FORMAT "X(72)" AT COLUMN  1 ROW 40
            mchStrSum[1]       FORMAT "X(72)" AT COLUMN  1 ROW 26
            mchStrSum[2]       FORMAT "X(72)" AT COLUMN  1 ROW 28
            mchStrSum[3]       FORMAT "X(72)" AT COLUMN  1 ROW 29
            {&recbank}[1]      FORMAT "X(45)" AT COLUMN  1 ROW 22
            {&recbank}[2]      FORMAT "X(45)" AT COLUMN  1 ROW 24
            mchBankMFO         FORMAT "X(10)" AT COLUMN 55 ROW 24
            &IF DEFINED(cashord3) <> 0 &THEN
               {&documentid}      FORMAT "X(31)" AT COLUMN 46 ROW 47
               {&documentnum}     FORMAT "X(21)" AT COLUMN 80 ROW 47
               {&documentwho}[1]  FORMAT "X(65)" AT COLUMN  7 ROW 50
               {&documentwho}[2]  FORMAT "X(65)" AT COLUMN  7 ROW 51
               {&documentdate}    FORMAT "X(26)" AT COLUMN 75 ROW 51
            &ELSE
               {&documentid}      FORMAT "X(31)" AT COLUMN 46 ROW 42
               {&documentnum}     FORMAT "X(21)" AT COLUMN 80 ROW 42
               {&documentwho}[1]  FORMAT "X(65)" AT COLUMN  7 ROW 45
               {&documentwho}[2]  FORMAT "X(65)" AT COLUMN  7 ROW 46
               {&documentdate}    FORMAT "X(26)" AT COLUMN 75 ROW 46
            &ENDIF
            WITH FRAME mfrOutOrdForm6 WIDTH 102 NO-LABELS.
      &ENDIF

      &IF DEFINED(nodef) EQ 0 &THEN
         /* описание расх. кассового ордера */
         &IF DEFINED(LAW_318p) <> 0 &THEN
            FORM
            "                                                                                 ┌─────────────────┐" SKIP
            "                                                                                 │    Код формы    │" SKIP
            "                                                                                 │документа по ОКУД│" SKIP
            "                                                                                 ├─────────────────┤" SKIP
            "                                                                                 │     0402009     │" SKIP
            "                                                                                 └─────────────────┘" SKIP
            "                              ╔═════════╗                               ┌──────────────────────────┐" SKIP
            " Расходный кассовый ордер  N  ║         ║                               │      Отрывной талон      │" SKIP
            "                              ╚═════════╝                               │  к расходному кассовому  │" SKIP
            "                                                                        │       ордеру N _____     │" SKIP
            "                                                                        └──────────────────────────┘" SKIP
            "                                                                                                    " SKIP
            "                                                      ДЕБЕТ             ╔══════════════════════════╗" SKIP
            "                                             ╔══════════════════════════╣    Место для наклейки    ║" SKIP
            "Выдать                                       ║счет N                    ║     отрывного талона     ║" SKIP
            "                                             ║                          ║                          ║" SKIP
            "                                             ║                          ║                          ║" SKIP
            "─────────────────────────────────────────────╚══════════════════════════╬══════════════════════════╣" SKIP
            " (фамилия, имя, отчество)                             КРЕДИТ            ║                          ║" SKIP
            "─────────────────────────────────────────────╔══════════════════════════╣                          ║" SKIP
            "Наименование банка                           ║счет N                    ║                          ║" SKIP
            "                                             ║                          ║      Сумма цифрами       ║" SKIP
            "─────────────────────────────────────────────╚══════════════════════════╬══════════════════════════╣" SKIP
            "                                                  БИК                   ║       в том числе        ║" SKIP
            "──────────────────────────────────────────────────   ───────────────────║       по символам:       ║" SKIP
            "Сумма прописью с указанием наименования валюты                          ║                          ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║   символ   │    сумма    ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "Направление выдачи                                                      ║            │             ║" SKIP
            "                   ─────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────║────────────┼─────────────║" SKIP
            "                                                                        ║            │             ║" SKIP
            "────────────────────────────────────────────────────────────────────────╚══════════════════════════╝" SKIP
            &IF DEFINED(cashord3) <> 0 &THEN
               "                                                                                                    " SKIP
               "                                                                                                    " SKIP
               "Приложения на ____ листах                                                                           " SKIP
               "                                                                                                    " SKIP
               "                                                                                                    " SKIP
            &ENDIF
            "Предъявлен документ, удостоверяющий личность                                 N                      " SKIP
            "                                             ───────────────────────────────   ─────────────────────" SKIP
            "                                                 (наименование документа)                           " SKIP
            "                                                                                                    " SKIP
            "Выдан                                                                    "  "        20  года       " SKIP
            "      ─────────────────────────────────────────────────────────────────                             " SKIP
            "                            (кем выдан)                                                             " SKIP
            "                                                                                                    " SKIP
            "Указанную в расходном кассовом ордере сумму получил ______________________                          " SKIP
            "                                                     (подпись получателя)                           " SKIP
            "                                                                                                    " SKIP
            "                                                                                                    " SKIP
            "Бухгалтерский работник                   Контролер                Кассовый работник                 " SKIP
            
            {&docnum}          FORMAT "X(09)" AT COLUMN 32 ROW  8
            mchCoupon          FORMAT "X(06)" AT COLUMN 90 ROW 10
            mchStrDocDate      FORMAT "X(30)" AT COLUMN  2 ROW 11
            {&receiver}[1]     FORMAT "X(45)" AT COLUMN  1 ROW 15
            {&receiver}[2]     FORMAT "X(45)" AT COLUMN  1 ROW 16
            {&receiver}[3]     FORMAT "X(45)" AT COLUMN  1 ROW 17
            {&dbacct}          FORMAT "X(25)" AT COLUMN 47 ROW 16
            {&cracct}          FORMAT "X(25)" AT COLUMN 47 ROW 22
            mchBuhSum          FORMAT "X(15)" AT COLUMN 74 ROW 20
            mchBuhSymSumOut[1] FORMAT "X(13)" AT COLUMN 87 ROW 30
            mchBuhSymSumOut[2] FORMAT "X(13)" AT COLUMN 87 ROW 32
            mchBuhSymSumOut[3] FORMAT "X(13)" AT COLUMN 87 ROW 34
            {&symcodout}[1]    FORMAT "XX"    AT COLUMN 79 ROW 30
            {&symcodout}[2]    FORMAT "XX"    AT COLUMN 79 ROW 32
            {&symcodout}[3]    FORMAT "XX"    AT COLUMN 79 ROW 34
            mchDetails[1]      FORMAT "X(72)" AT COLUMN  1 ROW 30
            mchDetails[2]      FORMAT "X(72)" AT COLUMN  1 ROW 32
            mchDetails[3]      FORMAT "X(72)" AT COLUMN  1 ROW 34
            mchStrSum[1]       FORMAT "X(72)" AT COLUMN  1 ROW 26
            mchStrSum[2]       FORMAT "X(72)" AT COLUMN  1 ROW 28
            mchStrSum[3]       FORMAT "X(72)" AT COLUMN  1 ROW 29
            {&recbank}[1]      FORMAT "X(45)" AT COLUMN  1 ROW 22
            {&recbank}[2]      FORMAT "X(45)" AT COLUMN  1 ROW 24
            mchBankMFO         FORMAT "X(10)" AT COLUMN 55 ROW 24
            &IF DEFINED(cashord3) <> 0 &THEN
               {&documentid}      FORMAT "X(31)" AT COLUMN 46 ROW 41
               {&documentnum}     FORMAT "X(21)" AT COLUMN 80 ROW 41
               {&documentwho}[1]  FORMAT "X(65)" AT COLUMN  7 ROW 44
               {&documentwho}[2]  FORMAT "X(65)" AT COLUMN  7 ROW 45
               {&documentdate}    FORMAT "X(26)" AT COLUMN 75 ROW 45
            &ELSE
               {&documentid}      FORMAT "X(31)" AT COLUMN 46 ROW 36
               {&documentnum}     FORMAT "X(21)" AT COLUMN 80 ROW 36
               {&documentwho}[1]  FORMAT "X(65)" AT COLUMN  7 ROW 39
               {&documentwho}[2]  FORMAT "X(65)" AT COLUMN  7 ROW 40
               {&documentdate}    FORMAT "X(26)" AT COLUMN 75 ROW 40
            &ENDIF
            WITH FRAME mfrOutOrdForm WIDTH 102 NO-LABELS.
         &ELSE
            FORM
            "                                      ╔════════╗               МЕСТО ДЛЯ"    SKIP
            "       Расходный кассовый ордер No    ║        ║            НАКЛЕЙКИ ТАЛОНА" SKIP
            "                                      ╚════════╝" SKIP
            "                                                         ДЕБЕТ" SKIP
            "                                               ╔═════════════════════════╦══════════════════════╗" SKIP
            "                                               ║Сч.No                    ║ No талона в          ║" SKIP
            "                                               ║                         ║ кассу                ║" SKIP
            "       ────────────────────────────────────────╚═════════════════════════╣                      ║" skip
            "                                                         КРЕДИТ          ║                      ║" SKIP
            "───────────────────────────────────────────────╔═════════════════════════╬══════════════════════╣" SKIP
            "                                               ║Сч.No                    ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "───────────────────────────────────────────────║                         ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "                                               ║                         ║                      ║" SKIP
            "                                ┌──────────────║                         ║                      ║" SKIP
            "Наименование банка              │БИК           ║                         ║    Сумма цифрами     ║" SKIP
            "────────────────────────────────┴──────────────╚═════════════════════════╠══════════════════════╝" SKIP
            "                                                                         ║ в том числе           " SKIP
            "Назначение платежа                                                       ║ по символам:          " SKIP
            "                   ──────────────────────────────────────────────────────╠══════════════════════╗" SKIP
            "                                                                         ║     Сумма     │Символ║" SKIP
            "─────────────────────────────────────────────────────────────────────────║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "─────────────────────────────────────────────────────────────────────────║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "═════════════════════════════════════════════════════════════════════════╣───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "                                                                         ║               │      ║" SKIP
            "                                                                         ║───────────────┼──────║" SKIP
            "Суммы прописью (наименование (код) валюты)                               ║               │      ║" SKIP
            "─────────────────────────────────────────────────────────────────────────╚══════════════════════╝" SKIP
            SKIP(1)
            "Предъявлен документ, удостоверяющий личность" SKIP
            SKIP(1)
            "Выдан " SKIP
            SKIP(3)
            "Указанную в ордере сумму получил " SKIP
            "                                 ──────────────────" SKIP
            "                                 подпись получателя" SKIP
            SKIP(1)
            "Контролирующий работник               Бухгалтерский работник             Кассовый работник" SKIP
            
            {&docnum}          FORMAT "X(8)"  AT COLUMN 40 ROW 2
            mchCoupon          FORMAT "X(06)" AT COLUMN 87 ROW 8
            mchStrDocDate      FORMAT "X(30)" AT COLUMN  8 ROW 4
            {&receiver}[1]     FORMAT "X(47)" AT COLUMN  1 ROW 7
            {&receiver}[2]     FORMAT "X(47)" AT COLUMN  1 ROW 9
            {&dbacct}          FORMAT "X(25)" AT COLUMN 49 ROW 7
            {&payer}[1]        FORMAT "X(47)" AT COLUMN  1 ROW 11
            {&payer}[2]        FORMAT "X(47)" AT COLUMN  1 ROW 12
            {&cracct}          FORMAT "X(25)" AT COLUMN 49 ROW 13
            mchBuhSum          FORMAT "X(15)" AT COLUMN 82 ROW 14
            mchBuhSymSumOut[1] FORMAT "X(15)" AT COLUMN 75 ROW 24
            mchBuhSymSumOut[2] FORMAT "X(15)" AT COLUMN 75 ROW 26
            mchBuhSymSumOut[3] FORMAT "X(15)" AT COLUMN 75 ROW 28
            mchBuhSymSumOut[4] FORMAT "X(15)" AT COLUMN 75 ROW 30
            mchBuhSymSumOut[5] FORMAT "X(15)" AT COLUMN 75 ROW 32
            mchBuhSymSumOut[6] FORMAT "X(15)" AT COLUMN 75 ROW 34
            {&symcodout}[1]    FORMAT "XX"    AT COLUMN 93 ROW 24
            {&symcodout}[2]    FORMAT "XX"    AT COLUMN 93 ROW 26
            {&symcodout}[3]    FORMAT "XX"    AT COLUMN 93 ROW 28
            {&symcodout}[4]    FORMAT "XX"    AT COLUMN 93 ROW 30
            {&symcodout}[5]    FORMAT "XX"    AT COLUMN 93 ROW 32
            {&symcodout}[6]    FORMAT "XX"    AT COLUMN 93 ROW 34
            mchDetails[1]      FORMAT "X(73)" AT COLUMN  1 ROW 20
            mchDetails[2]      FORMAT "X(73)" AT COLUMN  1 ROW 22
            mchDetails[3]      FORMAT "X(73)" AT COLUMN  1 ROW 24
            mchDetails[4]      FORMAT "X(73)" AT COLUMN  1 ROW 26
            mchStrSum[1]       FORMAT "X(73)" AT COLUMN  1 ROW 28
            mchStrSum[2]       FORMAT "X(73)" AT COLUMN  1 ROW 29
            mchStrSum[3]       FORMAT "X(73)" AT COLUMN  1 ROW 30
            {&recbank}[1]      FORMAT "X(47)" AT COLUMN  1 ROW 14
            {&recbank}[2]      FORMAT "X(47)" AT COLUMN  1 ROW 15
            mchIdentityCard[1] FORMAT "X(90)" AT COLUMN  1 ROW 37
            mchIdentityCard[2] FORMAT "X(90)" AT COLUMN  1 ROW 39
            mchIdentityCard[3] FORMAT "X(90)" AT COLUMN  1 ROW 41
            mchBankMFO  FORMAT "X(10)" AT COLUMN 38 ROW 17
            WITH FRAME mfrOutOrdForm WIDTH 100 NO-LABELS.
         &ENDIF
         /* конец описания формы расх.ордера */
      &ENDIF
      /* вывод расх. ордера */

      &IF DEFINED(LAW_318p) NE 0 &THEN
      IF {assigned mchBuhSymSumOut[4]} THEN
      DO:
      
         DISPLAY {&docnum}
                 mchCoupon
                 mchStrDocDate
                 {&dbacct}
                 {&cracct}
                 mchBuhSum
                 mchDetails[1]
                 mchDetails[2]
                 mchDetails[3]
                 mchStrSum[1]
                 mchStrSum[2]
                 mchStrSum[3]
                 {&symcodout}
                 mchBuhSymSumOut
                 &IF DEFINED(LAW_318p) <> 0 &THEN
                    {&receiver}[1]
                    {&receiver}[2]
                    {&receiver}[3]
                    {&documentid}
                    {&documentnum}
                    {&documentwho}
                    {&documentdate}
                 &ELSE
                    {&receiver}
                    {&payer}[1]
                    {&payer}[2]
                    mchDetails[4]
                    mchIdentityCard[1]
                    mchIdentityCard[2]
                    mchIdentityCard[3]
                 &ENDIF
                 {&recbank}
                 mchBankMFO
         WITH FRAME mfrOutOrdForm6.      
      END.
      ELSE
      &ENDIF
      DO:
      
         DISPLAY {&docnum}
                 mchCoupon
                 mchStrDocDate
                 {&dbacct}
                 {&cracct}
                 mchBuhSum
                 mchDetails[1]
                 mchDetails[2]
                 mchDetails[3]
                 mchStrSum[1]
                 mchStrSum[2]
                 mchStrSum[3]
                 {&symcodout}[1]
                 {&symcodout}[2]
                 {&symcodout}[3]
                 mchBuhSymSumOut[1]
                 mchBuhSymSumOut[2]
                 mchBuhSymSumOut[3]
                 &IF DEFINED(LAW_318p) EQ 0 &THEN
                 {&symcodout}[4]
                 {&symcodout}[5]
                 {&symcodout}[6]
                 mchBuhSymSumOut[4]
                 mchBuhSymSumOut[5]
                 mchBuhSymSumOut[6]
                 &ENDIF
                 &IF DEFINED(LAW_318p) <> 0 &THEN
                    {&receiver}[1]
                    {&receiver}[2]
                    {&receiver}[3]
                    {&documentid}
                    {&documentnum}
                    {&documentwho}
                    {&documentdate}
                 &ELSE
                    {&receiver}
                    {&payer}[1]
                    {&payer}[2]
                    mchDetails[4]
                    mchIdentityCard[1]
                    mchIdentityCard[2]
                    mchIdentityCard[3]
                 &ENDIF
                 {&recbank}
                 mchBankMFO
         WITH FRAME mfrOutOrdForm.      
      END.
   END. /*IF {&cashord} = "расходный"*/
   &IF DEFINED(LAW_318p) <> 0 &THEN
      ELSE IF {&cashord} = "приходно─расходный" THEN DO:

         mchStrSum[1] = "Сумма прописью " + mchStrSum[1].
         {wordwrap.i &s=mchStrSum &n=5 &l=28}
    
         {wordwrap.i &s={&payer} &n=2 &l=47}
         IF {&payer}[2] = "" THEN ASSIGN
            {&payer}[2] = {&payer}[1]
            {&payer}[1] = ""
         .
         {wordwrap.i &s={&receiver} &n=2 &l=47}
         IF {&receiver}[2] = "" THEN ASSIGN
            {&receiver}[2] = {&receiver}[1]
            {&receiver}[1] = ""
         .
         {wordwrap.i &s={&paybank} &n=2 &l=37}
         IF {&paybank}[2] = "" THEN ASSIGN
            {&paybank}[2] = {&paybank}[1]
            {&paybank}[1] = ""
         .
         {wordwrap.i &s={&recbank} &n=2 &l=38}
         IF {&recbank}[2] = "" THEN ASSIGN
            {&recbank}[2] = {&recbank}[1]
            {&recbank}[1] = ""
         .

         mchDetails[1] = "Основание ".
         IF {assigned {&details}}
            THEN mchDetails[1] = mchDetails[1] + REPLACE({&details},"~n"," ").
            ELSE mchDetails[1] = mchDetails[1] + "____________________________________________".
         {wordwrap.i &s=mchDetails &n=2 &l=54}

         mchIdentityCard[1] = "Получил по документу, удостоверяющему личность, ".
         IF {&identcard} = "" THEN ASSIGN
            mchIdentityCard[1] = mchIdentityCard[1] + "______"
            mchIdentityCard[2] = ""
            mchIdentityCard[3] = ""
            mchIdentityCard[4] = "______________________________________________________"
         .
         ELSE DO:
            mchIdentityCard[1] = mchIdentityCard[1] + {&identcard}.
            {wordwrap.i &s=mchIdentityCard &n=4 &l=52}
            IF mchIdentityCard[4] = "" THEN DO:
               IF mchIdentityCard[3] = ""
               THEN ASSIGN
                  mchIdentityCard[4] = mchIdentityCard[2]
                  mchIdentityCard[2] = ""
               .
               ELSE ASSIGN
                  mchIdentityCard[4] = mchIdentityCard[3]
                  mchIdentityCard[3] = mchIdentityCard[2]
                  mchIdentityCard[2] = ""
               .
            END.
         END.

         IF NOT {assigned {&inc_part_fio}}
            THEN {&inc_part_fio} = "____________________________".
         IF NOT {assigned {&worker_buh}}
            THEN {&worker_buh} = "________________________".
         IF NOT {assigned {&worker_kont}}
            THEN {&worker_kont} = "_______________________".
         IF NOT {assigned {&worker_kas}}
            THEN {&worker_kas} = "______________________".
    
         &IF DEFINED(nodef) EQ 0 &THEN
            /* описание прих.-расх. кассового ордера */
            FORM
            "                                                                                ┌──────────────────┐         "
            "                                                                                │    Код формы     │         "
            "                                                                                │документа по ОКУД │         "
            "                                                                                ├──────────────────┤         "
            "                                                                                │     0402007      │         "
            "                                                                                └──────────────────┘         "
            "                                                                                                             "
            "                                                                                                             "
            "                                     ╔════════╗       |                                     ╔════════╗       "
            " Приходно-расходный кассовый ордер N ║        ║       | Приходно─расходный кассовый ордер N ║        ║       "
            "                                     ╚════════╝       |                                     ╚════════╝       "
            " '__' _________ 20__ года                             | '__' _________ 20__ года                             "
            "                                                      |                                                      "
            " ПРИХОДНАЯ ЧАСТЬ                                      | РАСХОДНАЯ ЧАСТЬ                                      "
            "                                                      |                                                      "
            "                                                      |                                                      "
            "От кого                                               |Выдать                                                "
            "──────────────────────────────────────────────────────|──────────────────────────────────────────────────────"
            "          (фамилия, имя, отчество)                    |            (фамилия, имя, отчество)                  "
            "                                                      |                                                      "
            "                                                      |                                                      "
            "Банк─отправитель                                      |Банк─отправитель                                      "
            "──────────────────────────────────────────────────────|──────────────────────────────────────────────────────"
            "                                                      |                                                      "
            "Банк─получатель                                       |Банк─получатель                                       "
            "────────────────────────────╔════════════════════════╗|────────────────────────────╔════════════════════════╗"
            "                ДЕБЕТ       ║Сумма цифрами           ║|                ДЕБЕТ       ║Сумма цифрами           ║"
            "╔═══════════════════════════╬════════════════════════╣|╔═══════════════════════════╬════════════════════════╣"
            "║счет N                     ║      в том числе       ║|║счет N                     ║      в том числе       ║"
            "╚═══════════════════════════╣      по символам:      ║|╚═══════════════════════════╣      по символам:      ║"
            "               КРЕДИТ       ║                        ║|               КРЕДИТ       ║                        ║"
            "╔═══════════════════════════╬════════════════════════╣|╔═══════════════════════════╬════════════════════════╣"
            "║счет N                     ║   символ  │  сумма     ║|║счет N                     ║   символ  │  сумма     ║"
            "╚═══════════════════════════╣───────────┼────────────║|╚═══════════════════════════╣───────────┼────────────║"
            "Сумма прописью              ║           │            ║|Сумма прописью              ║           │            ║"
            "                            ║───────────┼────────────║|                            ║───────────┼────────────║"
            "                            ║           │            ║|                            ║           │            ║"
            "                            ║───────────┼────────────║|                            ║───────────┼────────────║"
            "                            ║           │            ║|                            ║           │            ║"
            "────────────────────────────╚════════════════════════╝|────────────────────────────╚════════════════════════╝"
            "Основание ____________________________________________|Основание ____________________________________________"
            "                                                      |                                                      "
            "Вноситель _______________ ____________________________|Бухгалтерский _______________ ________________________"
            "          (личная подпись) (фамилия и инициалы)       |работник      (личная подпись) (фамилия и инициалы)   "
            "                                                      |                                                      "
            "Бухгалтерский _______________ ________________________|Контролер      _______________ _______________________"
            "работник      (личная подпись) (фамилия и инициалы)   |               (личная подпись) (фамилия и инициалы)  "
            "                                                      |                                                      "
            "Получил кассовый                                      |Получил по документу, удостоверяющему личность, ______"
            "работник        _______________ ______________________|                                                      "
            "                (личная подпись) (фамилия и инициалы) |                                                      "
            "                                                      |______________________________________________________"
            "                                                      | (наименование документа, номер, кем и когда выдан)   "
            "                                                      |                                                      "
            "                                                      |Выдал кассовый  _______________ ______________________"
            "                                                      |работник        (личная подпись) (фамилия и инициалы) "
            "                                                      |                                                      "

            {&docnum}          FORMAT "X(08)" AT COLUMN 39 ROW 10
            mCopyDocNum        FORMAT "X(08)" AT COLUMN 94 ROW 10
            mchStrDocDate      FORMAT "X(30)" AT COLUMN  2 ROW 12
            mCopyDocDate       FORMAT "X(30)" AT COLUMN 57 ROW 12
            {&payer}[1]        FORMAT "X(46)" AT COLUMN 9  ROW 16
            {&receiver}[1]     FORMAT "X(47)" AT COLUMN 63 ROW 16
            {&payer}[2]        FORMAT "X(46)" AT COLUMN 9  ROW 17
            {&receiver}[2]     FORMAT "X(47)" AT COLUMN 63 ROW 17
            {&paybank}[1]      FORMAT "X(37)" AT COLUMN 18 ROW 21
            mCopyPayBank[1]    FORMAT "X(37)" AT COLUMN 73 ROW 21
            {&paybank}[2]      FORMAT "X(37)" AT COLUMN 18 ROW 22
            mCopyPayBank[2]    FORMAT "X(37)" AT COLUMN 73 ROW 22
            {&recbank}[1]      FORMAT "X(38)" AT COLUMN 17 ROW 24
            mCopyRecBank[1]    FORMAT "X(38)" AT COLUMN 72 ROW 24
            {&recbank}[2]      FORMAT "X(38)" AT COLUMN 17 ROW 25
            mCopyRecBank[2]    FORMAT "X(38)" AT COLUMN 72 ROW 25
            mchBuhSum          FORMAT "X(11)" AT COLUMN 43 ROW 27
            mCopyBuhSum        FORMAT "X(11)" AT COLUMN 98 ROW 27
            {&dbacct}          FORMAT "X(20)" AT COLUMN 9  ROW 29
            mCopyDbAcct        FORMAT "X(20)" AT COLUMN 64 ROW 29
            {&cracct}          FORMAT "X(20)" AT COLUMN 9  ROW 33
            mCopyCrAcct        FORMAT "X(20)" AT COLUMN 64 ROW 33
            mchStrSum[1]       FORMAT "X(28)" AT COLUMN  1 ROW 35
            mCopyStrSum[1]     FORMAT "X(28)" AT COLUMN 56 ROW 35
            mchBuhSymSumIn[1]  FORMAT "X(12)" AT COLUMN 42 ROW 35
            mchBuhSymSumOut[1] FORMAT "X(12)" AT COLUMN 97 ROW 35
            {&symcodin}[1]     FORMAT "XX"    AT COLUMN 35 ROW 35
            {&symcodout}[1]    FORMAT "XX"    AT COLUMN 90 ROW 35
            mchStrSum[2]       FORMAT "X(28)" AT COLUMN  1 ROW 36
            mCopyStrSum[2]     FORMAT "X(28)" AT COLUMN 56 ROW 36
            mchStrSum[3]       FORMAT "X(28)" AT COLUMN  1 ROW 37
            mCopyStrSum[3]     FORMAT "X(28)" AT COLUMN 56 ROW 37
            mchBuhSymSumIn[2]  FORMAT "X(12)" AT COLUMN 42 ROW 37
            mchBuhSymSumOut[2] FORMAT "X(12)" AT COLUMN 97 ROW 37
            {&symcodin}[2]     FORMAT "XX"    AT COLUMN 35 ROW 37
            {&symcodout}[2]    FORMAT "XX"    AT COLUMN 90 ROW 37
            mchStrSum[4]       FORMAT "X(28)" AT COLUMN  1 ROW 38
            mCopyStrSum[4]     FORMAT "X(28)" AT COLUMN 56 ROW 38
            mchStrSum[5]       FORMAT "X(28)" AT COLUMN  1 ROW 39
            mCopyStrSum[5]     FORMAT "X(28)" AT COLUMN 56 ROW 39
            mchBuhSymSumIn[3]  FORMAT "X(12)" AT COLUMN 42 ROW 39
            mchBuhSymSumOut[3] FORMAT "X(12)" AT COLUMN 97 ROW 39
            {&symcodin}[3]     FORMAT "XX"    AT COLUMN 35 ROW 39
            {&symcodout}[3]    FORMAT "XX"    AT COLUMN 90 ROW 39
            mchDetails[1]      FORMAT "X(54)" AT COLUMN  1 ROW 41
            mCopyDetails[1]    FORMAT "X(54)" AT COLUMN 56 ROW 41
            mchDetails[2]      FORMAT "X(54)" AT COLUMN  1 ROW 42
            mCopyDetails[2]    FORMAT "X(54)" AT COLUMN 56 ROW 42
            {&inc_part_fio}    FORMAT "X(28)" AT COLUMN 27 ROW 43
            mCopyWorkerBuh     FORMAT "X(24)" AT COLUMN 86 ROW 43
            {&worker_buh}      FORMAT "X(24)" AT COLUMN 31 ROW 46
            {&worker_kont}     FORMAT "X(23)" AT COLUMN 87 ROW 46
            mchIdentityCard[1] FORMAT "X(54)" AT COLUMN 56 ROW 49
            mchIdentityCard[2] FORMAT "X(54)" AT COLUMN 56 ROW 50
            mchIdentityCard[3] FORMAT "X(54)" AT COLUMN 56 ROW 51
            {&worker_kas}      FORMAT "X(22)" AT COLUMN 33 ROW 50
            mchIdentityCard[4] FORMAT "X(54)" AT COLUMN 56 ROW 52
            mCopyWorkerKas     FORMAT "X(22)" AT COLUMN 88 ROW 55
            WITH FRAME mfrInOutOrdForm WIDTH 112 NO-LABELS.
            /* конец описания формы прих.-расх.ордера */
         &ENDIF
         /* вывод прих.-расх. ордера */
         ASSIGN
            mCopyDocNum     = {&docnum}
            mCopyDocDate    = mchStrDocDate
            mCopyBuhSum     = mchBuhSum
            mCopyStrSum[1]  = mchStrSum[1]
            mCopyStrSum[2]  = mchStrSum[2]
            mCopyStrSum[3]  = mchStrSum[3]
            mCopyStrSum[4]  = mchStrSum[4]
            mCopyStrSum[5]  = mchStrSum[5]
            mCopyDbAcct     = {&dbacct}
            mCopyCrAcct     = {&cracct}
            mCopyRecBank[1] = {&recbank}[1]
            mCopyRecBank[2] = {&recbank}[2]
            mCopyPayBank[1] = {&paybank}[1]
            mCopyPayBank[2] = {&paybank}[2]
            mCopyDetails[1] = mchDetails[1]
            mCopyDetails[2] = mchDetails[2]
            mCopyWorkerBuh  = {&worker_buh}
            mCopyWorkerKas  = {&worker_kas}
         .
         DISPLAY {&docnum}         mCopyDocNum
                 mchStrDocDate     mCopyDocDate
                 {&payer}[1]       {&receiver}[1]
                 {&payer}[2]       {&receiver}[2]
                 {&paybank}[1]     mCopyPayBank[1]
                 {&paybank}[2]     mCopyPayBank[2]
                 {&recbank}[1]     mCopyRecBank[1]
                 {&recbank}[2]     mCopyRecBank[2]
                 {&dbacct}         mCopyDbAcct
                 {&cracct}         mCopyCrAcct
                 mchBuhSum         mCopyBuhSum
                 mchStrSum[1]      mCopyStrSum[1]
                 mchStrSum[2]      mCopyStrSum[2]
                 mchStrSum[3]      mCopyStrSum[3]
                 mchStrSum[4]      mCopyStrSum[4]
                 mchStrSum[5]      mCopyStrSum[5]
                 mchDetails[1]     mCopyDetails[1]
                 mchDetails[2]     mCopyDetails[2]
                 mchBuhSymSumIn[1] mchBuhSymSumOut[1]
                 mchBuhSymSumIn[2] mchBuhSymSumOut[2]
                 mchBuhSymSumIn[3] mchBuhSymSumOut[3]
                 {&symcodin}[1]    {&symcodout}[1]
                 {&symcodin}[2]    {&symcodout}[2]
                 {&symcodin}[3]    {&symcodout}[3]
                                   mchIdentityCard[1]
                                   mchIdentityCard[2]
                                   mchIdentityCard[3]
                                   mchIdentityCard[4]
                 {&inc_part_fio}   mCopyWorkerBuh
                 {&worker_buh}     {&worker_kont}
                 {&worker_kas}     mCopyWorkerKas
         WITH FRAME mfrInOutOrdForm.      
      END. /*IF {&cashord} = "приходно─расходный" */
   &ENDIF
&ENDIF /* конец описания─вывода кассовых ордеров */
