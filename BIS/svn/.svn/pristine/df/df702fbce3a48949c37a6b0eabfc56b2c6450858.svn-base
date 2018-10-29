
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: schklotl.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(comm-rate)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 06/04/03 12:33:53
     Modified:
*/
Form "~n@(#) schklotl.p 1.0 RGen 06/04/03 RGen 06/04/03 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
{parsin.def}
DEFINE  INPUT  PARAMETER  p-param AS CHARACTER NO-UNDO.         /* Параметры */

/*-------------------- Объявление переменных --------------------*/
DEFINE VARIABLE npp         AS INTEGER INIT 0 NO-UNDO. /* Номер по порядку */
DEFINE VARIABLE mRate-comm  AS DECIMAL    NO-UNDO. /* Базовый тариф */
DEFINE VARIABLE mRate-fixed AS CHARACTER  NO-UNDO. /* Базовая ед. измерения */
DEFINE VARIABLE mAcct       AS CHARACTER INIT "" NO-UNDO.
DEFINE VARIABLE mBal        AS CHARACTER INIT "" NO-UNDO.
DEFINE VARIABLE mClients    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vLog        AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE mNameSchet  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE name1       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE name2       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cust-inn    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
/*--------------- Буфера для полей БД: ---------------*/
Define Buffer     xcomm-rate        For comm-rate. /* Буфер для comm-rate, роль 'commission' */
DEFINE TEMP-TABLE tt-comm-rate NO-UNDO
   FIELD acct        AS CHARACTER FORMAT "x(20)"
   FIELD commission  AS CHARACTER FORMAT "x(10)"
   FIELD name-comm   AS CHARACTER FORMAT "x(27)"
   FIELD min-value   AS DECIMAL FORMAT ">>>,>>>,>>9.99"
   FIELD rate-comm   AS DECIMAL FORMAT ">>>>>>9.99"
   FIELD ind-comm    AS DECIMAL FORMAT ">>>>>>9.99"
   FIELD rate-fixed  AS CHARACTER FORMAT "x(2)"
   FIELD rate-fixed0 AS CHARACTER FORMAT "x(2)"
   FIELD idx         AS INTEGER FORMAT ">>>>>>9"
   INDEX acct acct idx
   .
DEFINE TEMP-TABLE tt-name NO-UNDO
   FIELD acct       AS CHARACTER FORMAT "x(20)"
   FIELD details    AS CHARACTER EXTENT 4 FORMAT "x(29)"
   FIELD idx1       AS INTEGER FORMAT ">>9"
   FIELD idx2       AS INTEGER FORMAT ">>9"
   FIELD SORT       AS CHARACTER FORMAT "x(20)"
   INDEX SORT SORT
   INDEX acct acct
   .
IF p-param NE "*" THEN
ASSIGN 
  mBal = GetParamByNameAsChar(p-param, "БалСч", mBal)
  mClients = GetParamByNameAsChar(p-param, "Клиенты", mClients).
{getdate.i}
{justasec}

DO ON STOP UNDO, LEAVE:
ASSIGN
   npp = 0.

FOR EACH commission WHERE commission.commission EQ "K01TAR"
   USE-INDEX comm-comm 
   NO-LOCK:
   ASSIGN 
      mRate-comm  = 0
      mRate-fixed = "".
   FOR LAST xcomm-rate
      WHERE xcomm-rate.commission EQ commission.commission
        AND xcomm-rate.currency EQ commission.currency
        AND xcomm-rate.min-value EQ commission.min-value
        AND xcomm-rate.period EQ commission.period
      AND xcomm-rate.acct EQ "0" 
      AND xcomm-rate.since LE end-date
      USE-INDEX rate-comm
      NO-LOCK:
         ASSIGN 
            mRate-comm  = xcomm-rate.rate-comm
            mRate-fixed = IF xcomm-rate.rate-fixed THEN " =" ELSE " %".
   END. /* FOR LAST xcomm-rate*/

   FOR EACH comm-rate 
   WHERE comm-rate.commission EQ commission.commission
        AND comm-rate.currency EQ commission.currency
        AND comm-rate.min-value EQ commission.min-value
        AND comm-rate.period EQ commission.period
        AND comm-rate.acct NE "0"
        AND comm-rate.since LE end-date
   USE-INDEX rate-comm
   NO-LOCK
   BREAK BY comm-rate.acct
      BY comm-rate.commission
      BY comm-rate.min-value:
      IF LAST-OF(comm-rate.min-value) THEN
      DO:
         RUN vcan-do(mBal, 
                     TRIM(comm-rate.acct),
                     INPUT-OUTPUT vLog).

      IF vLog THEN
      DO:

         FIND FIRST acct 
         WHERE acct.acct EQ comm-rate.acct
               AND acct.open-date LE end-date
               AND (acct.close-date EQ ? 
               OR acct.close-date GT end-date)
         USE-INDEX acct-acct
         NO-LOCK NO-ERROR.
            IF AVAILABLE acct THEN
               RUN vcan-do(mClients, 
                           acct.cust-cat,
                           INPUT-OUTPUT vLog).
            ELSE
               ASSIGN 
                  vLog = NO.
      END. /*IF vLog THEN*/
      IF vLog THEN
      DO:
         IF acct.details EQ ? THEN 
         DO:
            RUN GetCustName in h_base (INPUT acct.cust-cat,
                       INPUT acct.cust-id,
                       INPUT acct.acct,
                       OUTPUT name1,
                       OUTPUT name2,
                       INPUT-OUTPUT cust-inn).
             mNameSchet = TRIM(name1) + " " + TRIM(name2).
         END. /*IF acct.details EQ ?*/
         ELSE 
             mNameSchet = acct.details.
         ASSIGN 
            npp = npp + 1.
         CREATE tt-comm-rate.
         ASSIGN
            tt-comm-rate.acct        = TRIM(comm-rate.acct)
            tt-comm-rate.name-comm   = commission.name-comm[1] + commission.name-comm[2]
            tt-comm-rate.commission  = comm-rate.commission
            tt-comm-rate.min-value   = comm-rate.min-value
            tt-comm-rate.rate-comm   = mRate-comm
            tt-comm-rate.ind-comm    = comm-rate.rate-comm
            tt-comm-rate.rate-fixed  = IF comm-rate.rate-fixed THEN " =" ELSE " %"
            tt-comm-rate.rate-fixed0 = mRate-fixed
            tt-comm-rate.idx         = npp
         .
         FIND FIRST tt-name WHERE tt-name.acct = tt-comm-rate.acct NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt-name THEN
         DO:
            CREATE tt-name.
            ASSIGN
               tt-name.idx1       = 1
               tt-name.idx2       = TRUNCATE(LENGTH(TRIM(mNameSchet)) / 29, 0) +
               IF (LENGTH(TRIM(mNameSchet)) MODULO 29) GT 0 THEN 1 ELSE 0
               tt-name.acct       = tt-comm-rate.acct
               tt-name.details[1] = SUBSTRING(TRIM(mNameSchet), 1, 29)
               tt-name.details[2] = SUBSTRING(TRIM(mNameSchet), 30, 29)
               tt-name.details[3] = SUBSTRING(TRIM(mNameSchet), 60, 29)
               tt-name.details[4] = SUBSTRING(TRIM(mNameSchet), 90, 29)
               tt-name.SORT       = SUBSTRING(TRIM(comm-rate.acct), 1, 8) + SUBSTRING(TRIM(comm-rate.acct), 10, 11)
               .
         END.
         ELSE
            ASSIGN
               tt-name.idx1       = tt-name.idx1 + 1.

      END.
      END. /* IF vLog THEN */
   END.  /* FOR EACH comm-rate */
END.   /* FOR EACH commission */
ASSIGN 
   i = 0.
ASSIGN mAcct = "".
FOR EACH tt-name USE-INDEX acct:
   REPEAT i = 1 TO tt-name.idx2 - tt-name.idx1:
      ASSIGN 
         npp = npp + 1.
      CREATE tt-comm-rate.
      ASSIGN 
         tt-comm-rate.MIN-VALUE = -1
         tt-comm-rate.rate-comm = -1
         tt-comm-rate.ind-comm  = -1
         tt-comm-rate.acct      = tt-name.acct
         tt-comm-rate.idx       = npp
         .
   END.
END.
ASSIGN 
   npp = 0.
/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=135 &option=Paged}
PUT skip(1).
PUT UNFORMATTED "         Счета клиентов, с индивидуальными тарифами," skip.
PUT UNFORMATTED "           отличными от базовых на " STRING(end-date, "99.99.9999") skip.
PUT UNFORMATTED " " skip.
PUT UNFORMATTED "┌───────┬────────────────────┬─────────────────────────────┬──────────────────────────────────────────────────────────────────┬────────────┐" skip.
PUT UNFORMATTED "│   N   │        Номер       │                             │                        Базовый тариф                             │Индивидуаль │" skip.
PUT UNFORMATTED "│  п.п. │   лицевого счета   │    Наименование счета       ├──────────┬────────────────────────────┬───────────────┬──────────┤   ная      │" skip.
PUT UNFORMATTED "│  (по  │                    │                             │   Код    │         Наименование       │   Минимум     │  Ставка  │  ставка    │" skip.
PUT UNFORMATTED "│счетам)│                    │                             │          │                            │               │          │            │" skip.
PUT UNFORMATTED "├───────┼────────────────────┼─────────────────────────────┼──────────┼────────────────────────────┼───────────────┼──────────┼────────────┤" skip.
FOR EACH tt-name USE-INDEX SORT:
   ASSIGN 
      i = 0.
   FOR EACH tt-comm-rate 
   WHERE tt-comm-rate.acct = tt-name.acct
   USE-INDEX acct:
   ASSIGN 
      i = i + 1.
   IF tt-comm-rate.acct NE mAcct 
      THEN 
        ASSIGN 
           npp = npp + 1.
        IF tt-comm-rate.acct NE mAcct 
           AND npp NE 1
           THEN
PUT UNFORMATTED "├───────┼────────────────────┼─────────────────────────────┼──────────┼────────────────────────────┼───────────────┼──────────┼────────────┤" skip.
      
PUT UNFORMATTED "│"IF tt-comm-rate.acct NE mAcct THEN string(npp,">>>>>>9") ELSE '       ' "│" 
                    IF tt-comm-rate.acct NE mAcct THEN tt-comm-rate.acct ELSE "" FORMAT "x(20)"
                "│" IF i LE 4 THEN tt-name.details[i] ELSE "" FORMAT "x(29)"
                "│" tt-comm-rate.commission FORMAT "x(10)"
                "│ " tt-comm-rate.name-comm FORMAT "x(27)"
                "│" IF tt-comm-rate.min-value LT 0 THEN "               "  ELSE STRING(tt-comm-rate.MIN-VALUE, ">>>>>,>>>,>9.99") 
                "│" IF tt-comm-rate.rate-comm LT 0 THEN "          " ELSE STRING(tt-comm-rate.rate-comm, ">>>>9.99") 
                   + tt-comm-rate.rate-fixed0
                "│" IF tt-comm-rate.ind-comm LT 0 THEN "            " ELSE STRING(tt-comm-rate.ind-comm,  ">>>>>>9.99") 
                   + tt-comm-rate.rate-fixed
                "│" skip.
   

ASSIGN 
        mAcct = tt-comm-rate.acct.

END. /*FOR EACH tt-comm-rate*/
END. /*FOR EACH tt-name*/
PUT UNFORMATTED "└───────┴────────────────────┴─────────────────────────────┴──────────┴────────────────────────────┴───────────────┴──────────┴────────────┘"   skip.
PUT UNFORMATTED "" SKIP.
PUT UNFORMATTED "" SKIP.
PUT UNFORMATTED "" SKIP.
{signatur.i}
{endout3.i &nofooter=yes}

END. /*DO ON STOP UNDO, LEAVE:*/
HIDE MESSAGE NO-PAUSE.

PROCEDURE vcan-do.
   DEFINE INPUT PARAMETER vList AS CHARACTER.
   DEFINE INPUT PARAMETER vString AS CHARACTER.
   DEFINE INPUT-OUTPUT PARAMETER vLog AS LOGICAL.
   DEFINE VARIABLE i AS INTEGER  INIT 1  NO-UNDO.
   vLog = NO.
IF NUM-ENTRIES(vList) GT 0 THEN
REPEAT WHILE vLog = NO AND  i LE NUM-ENTRIES(vList):
   IF ENTRY(i, vList) EQ SUBSTRING(TRIM(vString), 1 , LENGTH(ENTRY(i, vList)))
      THEN 
      ASSIGN 
         vLog = YES.
   i = i + 1.
END.
ELSE
   ASSIGN 
      vLog = YES.
RETURN.
END PROCEDURE.
