/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2008 ЗАО "Банковские информационные системы"
     Filename: card_rep.p
      Comment: Выписка по карте. Уже 54 НП !!!
   Parameters:
         Uses:
      Used by:
      Created: 11/02/2008  BMS
     Modified: 11/02/2008  BMS
     Modified: 21/05/2008  JADV (0091047)
*/

DEF INPUT PARAM iCont-code AS CHAR NO-UNDO.
DEF INPUT PARAM iDate-from AS DATE NO-UNDO.
DEF INPUT PARAM iDateTo    AS DATE NO-UNDO.

{globals.i}

{sh-defs.i}
{intrface.get tmess}
{intrface.get strng}
{intrface.get card}
{intrface.get cust}
{intrface.get xclass}
{intrface.get instrum}
{intrface.get loan}
{intrface.get date}

DEF VAR mDateFrom   AS DATE NO-UNDO.
DEF VAR mDateTo     AS DATE NO-UNDO.
DEF VAR mCnt        AS INT  NO-UNDO.
DEF VAR mFormatDec  AS CHAR NO-UNDO INIT "->>>,>>>,>>9.99".
DEF VAR mDet        AS CHAR NO-UNDO. /* Содержание операции в неск. строк     */
DEF VAR mDetEnt     AS INT  NO-UNDO. /* Содержание операции в неск. строк     */
DEF VAR mAcctP      AS CHAR NO-UNDO. /* НП Счет положительных курсовых разниц */
DEF VAR mAcctN      AS CHAR NO-UNDO. /* НП Счет отрицательных курсовых разниц */
DEF VAR mTextNP     AS LOG  NO-UNDO. /* Берем текст строки из НП              */
DEF VAR mNameOrg    AS CHAR NO-UNDO.


DEF VAR RepTempl  AS CHAR NO-UNDO FORMAT "x(150)" EXTENT 40 INITIAL
[
"┌──────────────┬──────────────────────────────────────────────────────────────┬────────────┬───────────────────────────────────────────────────────────┐",
"│              │                                                              │Дата выписки│_Датавыписки                                               │",
"│    Ф.И.О.    │_Фамилия                                                      │Report date │                                                           │",
"│ Client name  │                                                              ├────────────┼───────────────────────────────────────────────────────────┤",
"│              │_Familia1                                                     │ Тип карты  │_Типкарты                                                  │",
"│              │_Familia2                                                     │ Card type  │                                                           │",
"├──────────────┼──────────────────────────────────────────────────────────────┼────────────┼───────────────────────────────────────────────────────────┤",
"│    Адрес     │_Адрес                                                        │Номер карты │_Номеркарты                                                │",
"│   Address    │                                                              │Card number │                                                           │",
"└──────────────┴──────────────────────────────────────────────────────────────┴────────────┴───────────────────────────────────────────────────────────┘",
" ",
"┌──────────────┬────────────┬─────────────────────────────────────────┬──────────────┬─────────────────────────────────┬───────────────┬───────────────┐",
"│              │            │                                         │              │             Сумма               │               │               │",
"│Дата операции │Дата расчета│          Содержание операции            │     Код      │             Amount              │   Комиссия    │     Итого     │",
"│Operation date│ Value date │           Operation details             │ авторизации  ├─────────────────┬───────────────┤      fee      │     Total     │",
"│              │            │                                         │Operation code│В валюте операции│В валюте счета │               │               │",
"│              │            │                                         │              │    Operation    │    Account    │               │               │",
"├──────────────┼────────────┼─────────────────────────────────────────┼──────────────┼─────────────────┼───────────────┼───────────────┼───────────────┤",
"│_Датаоперации │_Датарасчета│_Содержаниеоперации                      │_Кодавторизац │_Ввалютеопер     │_Ввалютесчета  │_Комиссия      │_Итого         │",
"│              │            │_Содержаниеоперации                      │              │                 │               │               │               │",
"├──────────────┴────────────┴─────────────────────────────────────────┴──────────────┴─────────────────┼───────────────┴───────────────┴───────────────┤",
"│НЕСНИЖАЕМЫЙ ОСТАТОК (Insurance deposit):                                                              │_неснижаемыйостаток                            │",
"│СЧЁТ ГАРАНТИЙНОГО ПОКРЫТИЯ                                                                            │_счетгарнтпокр                                 │",
"│ОСТАТОК НА НАЧАЛО ПЕРИОДА (Initial balance):                                                          │_остатокнаначалопериода                        │",
"│ОБОРОТ ПО ПРИХОДУ ЗА ПЕРИОД (Credit turnover):                                                        │_оборотпоприходузапериод                       │",
"│ОБОРОТ ПО РАСХОДУ ЗА ПЕРИОД (Debit turnover):                                                         │_оборотпорасходузапериод                       │",
"│ОСТАТОК НА КОНЕЦ ПЕРИОДА (Total balance):                                                             │_остатокнаконецпериода                         │",
"│БЛОКИРОВАННАЯ СУММА (НЕОПЛАЧЕННЫЕ ОПЕРАЦИИ) (Blocked amount):                                         │_Блокированнаясумма                            │",
"│ДОПУСТИМЫЙ ПЕРЕРАСХОД (КРЕДИТНЫЙ ЛИМИТ) (Acceptable overdarft):                                       │_Допустимыйперерасход                          │",
"│ТЕКУЩИЙ РАСХОДНЫЙ ЛИМИТ (opento-buy):                                                                 │_Текущийрасходныйлимит                         │",
"│ДОСТУПНЫЙ ЛИМИТ (available quota):                                                                    │_Доступныйлимит                                │",
"│СУММА ОВЕРДРАФТА (Debts)                                                                              │_Суммаовердрафта                               │",
"│СУММА НЕИСПОЛЬЗОВАННОГО ОВЕРДРАФТА                                                                    │_СуммНеиспОвер                                 │",
"│СУММА ЛИМИТА ОВЕРДРАФТА                                                                               │_Суммалимитаовердрафта                         │",
"├───────────────────────────────────────────────┬───────┬────────────────────┬────────────┬────────────┼───────────────┬───────────────────────────────┤",
"│ГРЕЙС:                                         │МИН.ПЛ.│_Суммаминплатежа    │ДАТА МИН.ПЛ.│_Датаминпл  │ДАТА ОКОН.ГРЕЙС│_Датаконгрейс-периода          │",
"├───────────────────────────────────────────────┴───────┴────────────────────┴────────────┴────────────┼───────────────┴───────────────────────────────┤",
"│СУММА НЕРАЗРЕШЕННОГО ОВЕРДРАФТА                                                                       │_Сумманеразрешенногоовердрафта                 │",
"│СУММА ПРОСРОЧЕННОЙ ЗАДОЛЖЕННОСТИ                                                                      │_Суммапросроченнойзадолженности                │",
"└──────────────────────────────────────────────────────────────────────────────────────────────────────┴───────────────────────────────────────────────┘"
].

DEF VAR RepTempl2  AS CHAR NO-UNDO FORMAT "x(150)" EXTENT 5 INITIAL
[
"┌──────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐",
"│ Организация  │_Организация                                                                                                                           │",
"└──────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘"
].

DEF STREAM fil.

DEF TEMP-TABLE tt-cardrep NO-UNDO
   FIELD name        AS CHAR /* ФИО                                           */
   FIELD data        AS DATE /* дата выписки                                  */
   FIELD type-card   AS CHAR /* тип карты                                     */
   FIELD address     AS CHAR /* Адрес                                         */
   FIELD card_num    AS CHAR /* Номер карты                                   */
   FIELD ins_depos   AS DEC  /* неснижаемый остаток                           */
   FIELD bal_sgp     AS DEC  /* счет гарантийного покрытия                    */
   FIELD init_bal    AS DEC  /* остаток на начало периода                     */
   FIELD credit_turn AS DEC  /* оборот по приходу за период                   */
   FIELD debit_turn  AS DEC  /* оборот по расходу за период                   */
   FIELD total_bal   AS DEC  /* остаток на конец периода                      */
   FIELD block_amm   AS DEC  /* Блокированная сумма (неопл-нные операции + 2%)*/
   FIELD avail_amt   AS DEC  /* Доступный лимит                               */
   FIELD ovefdraft   AS DEC  /* Допустимый перерасход (кредитный лимит)       */
   FIELD open_to_buy AS DEC  /* Текущий расходный лимит                       */
   FIELD debts       AS DEC  /* Сумма овердрафта                              */
   FIELD notover     AS DEC  /* Сумма неиспользованного овердрафта            */
   FIELD LimOver     AS DEC  /* Сумма лимита овердрафта                       */
   FIELD amt_min_pay AS DEC  /* Сумма минимального платежа */
   FIELD dat_min_pay AS DATE /* Дата минимального платежа */
   FIELD dat_grs_end AS DATE /* Дата окончания грейс-периода */
   FIELD amt_uns_ovd AS DEC  /* Сумма неразрешенного овердрафта */
   FIELD amt_pst_due AS DEC  /* Сумма просроченной задолженности */
   FIELD flg_grs_pnt AS LOG  /* Печатать ли строку о грейс периоде */

   INDEX card_num card_num
.

DEF TEMP-TABLE tt-opcard NO-UNDO
   FIELD card_num    AS CHAR /* номер карты                                   */
   FIELD date_op     AS DATE /* дата операции                                 */
   FIELD date_val    AS DATE /* дата расчета                                  */
   FIELD details     AS CHAR /* Содеожание операции                           */
   FIELD code_op     AS CHAR /* код авторизации                               */
   FIELD amm_op      AS DEC  /* сумма операции в валюте операции              */
   FIELD amm_acct    AS DEC  /* сумма операции в валюте счета                 */
   FIELD comm        AS DEC  /* комиссия                                      */
   FIELD total       AS DEC  /* комиссия                                      */
   FIELD scs         AS CHAR /* Счет SCS                                      */
   FIELD acct-cor    AS CHAR /* Корреспондирующий счет в проводке             */
   FIELD curr        AS CHAR /* Валюта операции                               */
   FIELD AddOper     AS LOG  /* Тип операции. Да - дополнительная             */

   INDEX card_num card_num
.

DEF BUFFER Pcard  FOR loan. /* Буфер карты по которой печатается отчет */

/* Есть ли связанный договор овердрафта */
FUNCTION IsOverdraft RETURNS LOG (iPaContract AS CHAR,
                                  iPaContCode AS CHAR,
                                  iSince      AS DATE
                                 ):

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
   DEF VAR          vCurr       AS CHAR   NO-UNDO.

   DEF BUFFER  loan      FOR loan.      /* Договор */
   DEF BUFFER bloan      FOR loan.      /* Договор */
   DEF BUFFER  loan-acct FOR loan-acct.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract  EQ iPaContract
                    AND loan.cont-code EQ iPaContCode
   NO-LOCK:
      RUN GetRoleAcct IN h_card (       loan.contract + "," + loan.cont-code,
                                        iSince,
                                        "SCS",
                                        loan.currency,
                                 OUTPUT vAcct,
                                 OUTPUT vCurr
      ).

      IF vAcct NE ""
      THEN DO:
         FOR EACH loan-acct WHERE loan-acct.acct      EQ vAcct
                              AND loan-acct.currency  EQ vCurr
                              AND loan-acct.acct-type EQ "КредРасч"
                              AND loan-acct.since     LE iSince
         NO-LOCK,
         FIRST    bloan     OF loan-acct
         NO-LOCK:
            IF GetXattrValue ("loan",
                              bloan.contract + "," + bloan.cont-code,
                              "КартОвер"
                             ) EQ "Разреш" THEN
               RETURN YES.
         END.
      END.
   END.

   RETURN NO.
END FUNCTION.

/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */


MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:

   FIND FIRST Pcard WHERE Pcard.contract  EQ "card"
                      AND Pcard.cont-code EQ iCont-code
   NO-LOCK NO-ERROR.

   IF NOT AVAIL Pcard THEN
      UNDO MAIN, LEAVE MAIN.

   ASSIGN
      mDateFrom   = iDate-from
      mDateTo     = iDateTo
   .

   /* Заполнение временных таблиц для выписки. */
   RUN BuildCardRep (Pcard.contract,
                     Pcard.cont-code
   ).

   /* Печать выписки по одной карте. */
   {setdest.i
      &stream   = "stream fil"
      &append   = "append"
   }

   RUN PrintCardRep (Pcard.contract,
                     Pcard.cont-code
   ).
END.

{intrface.del}



/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

/* Заполнение временных таблиц для выписки */
PROCEDURE BuildCardRep:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.

   DEF BUFFER card  FOR loan.
   DEF BUFFER card2 FOR loan.

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   DEF VAR         vClName AS CHAR NO-UNDO EXTENT 3.
   DEF VAR         vInn    AS CHAR NO-UNDO.
   DEF VAR         vKpp    AS CHAR NO-UNDO.
   DEF VAR         vType   AS CHAR NO-UNDO.
   DEF VAR         vCode   AS CHAR NO-UNDO.
   DEF VAR         vAcct   AS CHAR NO-UNDO.
   DEF VAR         vAddres AS CHAR NO-UNDO.
   DEF VAR         vAmt1   AS DEC  NO-UNDO.
   DEF VAR         vAmt2   AS DEC  NO-UNDO.
   DEF VAR         vAcctRl AS CHAR NO-UNDO.
   DEF VAR         vCurrRl AS CHAR NO-UNDO.
   DEF VAR vCardContract   AS CHAR NO-UNDO. /* Назначение карточного договора   */
   DEF VAR vCardContCode   AS CHAR NO-UNDO. /* Номер карточного договора        */
   DEF VAR vAmtMinPay      AS DEC  NO-UNDO. /* Сумма минимального платежа       */
   DEF VAR vDateMinPay     AS DATE NO-UNDO. /* Дата минимального платежа        */
   DEF VAR vDateGraceEnd   AS DATE NO-UNDO. /* Дата окончания грейс-периода     */
   DEF VAR vFlgGracePrint  AS LOG  NO-UNDO. /* Признак вывода на печать грейс   */
   DEF VAR vAmtUnSolvOvdft AS DEC  NO-UNDO. /* Сумма неразрешенного овердрафта  */
   DEF VAR vAmtPastDueLoan AS DEC  NO-UNDO. /* Сумма просроченной задолженности */
   DEF VAR vAcctTypeTmp    AS CHAR NO-UNDO. /* Роли ссудного счета из НП        */
   DEF VAR vAcctTmp        AS CHAR NO-UNDO. /* Заглушка */
   DEF VAR vCurrTmp        AS CHAR NO-UNDO. /* Заглушка */

   RUN GetCustName IN h_base (             card.cust-cat,
                                           card.cust-id,
                                           "",
                              OUTPUT       vClName[1],
                              OUTPUT       vClName[2],
                              INPUT-OUTPUT vClName[3]
   ).

   FIND FIRST loan WHERE loan.contract  EQ card.parent-contract
                     AND loan.cont-code EQ card.parent-cont-code
   NO-LOCK.


   CREATE tt-cardrep.
   ASSIGN
      tt-cardrep.name      = vClName[1] + " " + vClName[2]
                           + CHR(1) + card.user-o[2] + CHR(1) + card.user-o[3]
      tt-cardrep.address   = GetCliName (             card.cust-cat,
                                                      STRING (card.cust-id),
                                         OUTPUT       vAddres,
                                         OUTPUT       vINN,
                                         OUTPUT       vKPP,
                                         INPUT-OUTPUT vType,
                                         OUTPUT       vCode,
                                         OUTPUT       vAcct
                                        )
      tt-cardrep.address   = ""
      tt-cardrep.address   = vAddres
      tt-cardrep.type-card = GetCodeName("КартыБанка", card.sec-code) + " "
                           + GetISOCode(loan.currency)
      tt-cardrep.data      = IF FGetSettingEx ("КартВыписка",
                                               "ВыпискаДата",
                                               "",
                                               NO
                                              ) EQ "Системная"
                             THEN TODAY
                             ELSE gend-date
      tt-cardrep.card_num  = SUBSTR(card.doc-num, 1 , 4) + " xxxx xxxx "
                           + SUBSTR(card.doc-num, 13, 2) + "xx"
   .

   /* Определение и сохранение в tt-card неснижаемого остатка */
   RUN CardMinOst (       card.contract,
                          card.cont-code,
                          mDateTo,
                   OUTPUT vAmt1
   ).
   ASSIGN
      tt-cardrep.ins_depos = vAmt1
      vAmt1                = 0
      vAddres              = FGetSettingEx ("КартВыписка",
                                            "РольСГП",
                                            "",
                                            NO
                                           )
   .

   /* Cчет гарантийного покрытия */

   RUN GetRoleAcct IN h_card (       loan.contract + "," + loan.cont-code,
                                     mDateTo,
                                     vAddres,
                                     loan.currency,
                              OUTPUT vAcctRl,
                              OUTPUT vCurrRl
   ).
   IF vAcctRl NE ""
   THEN DO:
      RUN acct-pos IN h_base (vAcctRl,
                              vCurrRl,
                              mDateTo,
                              mDateTo,
                              gop-status
                             ).

      IF vCurrRl EQ "" THEN
         tt-cardrep.bal_sgp = sh-bal * (- 1).
      ELSE
         tt-cardrep.bal_sgp = sh-val * (- 1).
   END.

   /* Если карта с ФЛ основная, либо карта корпоративная и она всего одна для своего карточного договора */
   IF    (loan.contract EQ "card-pers"
      AND Pcard.loan-work
         )
      OR (loan.contract EQ "card-corp"
      AND NOT CAN-FIND (FIRST card2 WHERE card2.parent-contract  EQ "card-corp"
                                      AND card2.parent-contract  EQ loan.contract
                                      AND card2.parent-cont-code EQ loan.cont-code
                                      AND RECID(card2)           NE RECID(Pcard)
                       )
         ) THEN
   DO:
      /* Задолженность. */
      RUN GetCredit (       card.parent-contract,
                            card.parent-cont-code,
                     OUTPUT vAmt1
                    ).
      ASSIGN
         tt-cardrep.debts = vAmt1
         vAmt1               = 0
      .

      /* Неиспользованный лимит. */
      RUN GetLim (       card.parent-contract,
                         card.parent-cont-code,
                  OUTPUT vAmt1
                 ).
      ASSIGN
         tt-cardrep.notover = vAmt1
         vAmt1              = 0
         tt-cardrep.LimOver = tt-cardrep.debts + tt-cardrep.notover
      .
   END.

   /* Определение и сохранение в tt-card остатка на начало периода */
   /*
      Если карта дополнительная и настроечный параметр КартВыписка/ОстатокДопКарт = НЕТ
      сумма остатка считается = 0.

      Если карта корпоративная и настроечный параметр КартВыписка/ОстатокКорпКарт = НЕТ
      сумма остатка считается = 0.
   */
   IF    (
            NOT Pcard.loan-work
      AND   FGetSettingEx ("КартВыписка",
                           "ОстатокДопКарт",
                           "",
                           NO
                          ) EQ "НЕТ"
         )
      OR
         (
            loan.contract  EQ "card-corp"
      AND   FGetSettingEx ("КартВыписка",
                           "ОстатокКорпКарт",
                           "",
                           NO
                          ) EQ "НЕТ"
         ) THEN
      tt-cardrep.init_bal = 0.

   ELSE DO:
      RUN CardInitBal (       card.parent-contract,
                              card.parent-cont-code,
                              mDateFrom,
                       OUTPUT vAmt1
      ).
      ASSIGN
         tt-cardrep.init_bal = vAmt1
         vAmt1               = 0
      .
   END.

   /* Определение и сохранение в tt-card допустимого перерасхода */
   RUN CardOverdraft (       card.parent-contract,
                             card.parent-cont-code,
                             mDateTo,
                      OUTPUT vAmt1
   ).
   ASSIGN
      tt-cardrep.ovefdraft = vAmt1
      vAmt1                = 0
      vAmt2                = 0
   .

   /* Построение списка операций по карте */
   RUN BuildOpCard (card.contract,
                    card.cont-code,
                    loan.contract,
                    loan.cont-code
   ).



/**************************************/
   /* Определение и сохранение в tt-card исходящего остатка */
   /*
      Если карта дополнительная и настроечный параметр КартВыписка/ОстатокДопКарт = НЕТ
      сумма остатка считается = 0.

      Если карта корпоративная и настроечный параметр КартВыписка/ОстатокКорпКарт = НЕТ
      сумма остатка считается = 0.
   */
   IF    (
            NOT Pcard.loan-work
      AND   FGetSettingEx ("КартВыписка",
                           "ОстатокДопКарт",
                           "",
                           NO
                          ) EQ "НЕТ"
         )
      OR
         (
            loan.contract  EQ "card-corp"
      AND   FGetSettingEx ("КартВыписка",
                           "ОстатокКорпКарт",
                           "",
                           NO
                          ) EQ "НЕТ"
         ) THEN
      tt-cardrep.total_bal = 0.
/*      
   ELSE
      ASSIGN
         tt-cardrep.total_bal = tt-cardrep.init_bal + vAmt1 - vAmt2
         vAmt1                = 0
      .
*/

ELSE DO:
   RUN CardInitBal (       card.parent-contract,
                          card.parent-cont-code,
			  	      			                                 mDateto + 1,
							                     OUTPUT vAmt1
									        ).
										   ASSIGN
										         tt-cardrep.total_bal = vAmt1
											       vAmt1               = 0
											          .
												  END.

/*
message tt-cardrep.init_bal skip
vAmt1 skip
vAmt2 skip
tt-cardrep.total_bal
view-as alert-box.
*/
/**************************************/



   RUN GetBlockedAmt(       card.doc-num,
                            card.contract + "," + card.cont-code,
                            loan.contract,
                            loan.cont-code,
                     OUTPUT tt-cardrep.block_amm).

   RUN GetAvailAmt(       card.doc-num,
                          card.contract + "," + card.cont-code,
                          loan.contract,
                          loan.cont-code,
                   OUTPUT tt-cardrep.avail_amt).

   /* Опредление и сохранение tt-card платежного лимита */
   RUN CardCurrentLimit (card.contract,
                         card.cont-code,
                         loan.contract,
                         loan.cont-code
   ).

   /* Обороты по карте */
   RUN CardTurnovers (       Pcard.contract,
                             Pcard.cont-code,
                      OUTPUT vAmt1,
                      OUTPUT vAmt2
   ).

   ASSIGN
      tt-cardrep.credit_turn = vAmt1
      tt-cardrep.debit_turn  = ABS(vAmt2)
      vAmt1                  = 0
      vAmt2                  = 0
   .


/*
   /* Определение и сохранение в tt-card исходящего остатка */
   /*
      Если карта дополнительная и настроечный параметр КартВыписка/ОстатокДопКарт = НЕТ
      сумма остатка считается = 0.

      Если карта корпоративная и настроечный параметр КартВыписка/ОстатокКорпКарт = НЕТ
      сумма остатка считается = 0.
   */
   IF    (
            NOT Pcard.loan-work
      AND   FGetSettingEx ("КартВыписка",
                           "ОстатокДопКарт",
                           "",
                           NO
                          ) EQ "НЕТ"
         )
      OR
         (
            loan.contract  EQ "card-corp"
      AND   FGetSettingEx ("КартВыписка",
                           "ОстатокКорпКарт",
                           "",
                           NO
                          ) EQ "НЕТ"
         ) THEN
      tt-cardrep.total_bal = 0.
/*      
   ELSE
      ASSIGN
         tt-cardrep.total_bal = tt-cardrep.init_bal + vAmt1 - vAmt2
         vAmt1                = 0
      .
*/

ELSE DO:
   RUN CardInitBal (       card.parent-contract,
                          card.parent-cont-code,
			  	      			                                 mDateto,
							                     OUTPUT vAmt1
									        ).
										   ASSIGN
										         tt-cardrep.total_bal = vAmt1
											       vAmt1               = 0
											          .
												  END.

/*
message tt-cardrep.init_bal skip
vAmt1 skip
vAmt2 skip
tt-cardrep.total_bal
view-as alert-box.
*/
*/





   /* Информация о Грейс-периоде */
      /* Дата минимального платежа = последний рабочий день месяца */
   vDateMinPay = LastWorkDay(LastMonDate(mDateTo)).
      /* Находим карточный договор по кредитному договору */
   RUN GetCardLoanCredit (loan.contract,
                          loan.cont-code,
                          ?,
                          mDateTo,
                          "Разреш",
                          OUTPUT vCardContract,
                          OUTPUT vCardContCode).
   IF TRIM(vCardContCode) NE "" THEN
   DO:
         /* Определение суммы минимального платежа */
      RUN GetCredLoanMin (vCardContract,
                          vCardContCode,
                          mDateTo,
                          OUTPUT vAmtMinPay).
         /* Дата окончания грейс-периода */
      RUN GetCredLoanGraceDate (vCardContract,
                                vCardContCode,
                                mDateTo,
                                OUTPUT vDateGraceEnd).
         /* Сумма просроченной задолженности */
      vAcctTypeTmp = FGetSettingEx("КартВыписка", "РольПросрочка", "", YES).
      RUN GetCredLoanBalance (vCardContract,
                              vCardContCode,
                              mDateTo,
                              vAcctTypeTmp,     /* Роль из НП РольПросрочка */
                              OUTPUT vAmtPastDueLoan,
                              OUTPUT vAcctTmp,
                              OUTPUT vCurrTmp).
   END.

      /* Строка Грейс печатается только если  у карты есть кредитный договор и
      ** он является овердрафтным дог.с грейс-периодами.
      ** Для доп.карт еще дополнительно проверяется НП "ПоказГрейсДопК" = "Да" */
   IF Pcard.loan-work THEN
      vFlgGracePrint = IF FGetSettingEx("КартВыписка", "ПоказГрейсОснК", "НЕТ", NO) = "ДА" THEN YES ELSE NO.
   ELSE                     /* Для доп.карты проверяем НП "ПоказГрейсДопК" */
      vFlgGracePrint = IF FGetSettingEx("КартВыписка", "ПоказГрейсДопК", "НЕТ", NO) = "ДА" THEN YES ELSE NO.

   ASSIGN
      vCardContract = ""
      vCardContCode = ""
   .
         /* Находим договор неразрешенного овердрафта */
   RUN GetCardLoanCredit (loan.contract,
                          loan.cont-code,
                          ?,
                          mDateTo,
                          "Технич",
                          OUTPUT vCardContract,
                          OUTPUT vCardContCode).
   IF TRIM(vCardContCode) NE "" THEN
   DO:
         /* Сумма неразрешенного овердрафта */
      vAcctTypeTmp = FGetSettingEx("КартВыписка", "РольСсудСчет", "", YES).
      RUN GetCredLoanBalance (vCardContract,
                              vCardContCode,
                              mDateTo,
                              vAcctTypeTmp,     /* Роль из НП РольСсудСчет */
                              OUTPUT vAmtUnSolvOvdft,
                              OUTPUT vAcctTmp,
                              OUTPUT vCurrTmp).
   END.
   ASSIGN
      vAmtUnSolvOvdft        = ABS(vAmtUnSolvOvdft)
      tt-cardrep.amt_min_pay = vAmtMinPay      /* Сумма минимального платежа       */
      tt-cardrep.dat_min_pay = vDateMinPay     /* Дата минимального платежа        */
      tt-cardrep.dat_grs_end = vDateGraceEnd   /* Дата окончания грейс-периода     */
      tt-cardrep.flg_grs_pnt = vFlgGracePrint  /* Признак вывода на печать грейс   */
      tt-cardrep.amt_uns_ovd = vAmtUnSolvOvdft /* Сумма неразрешенного овердрафта  */
      tt-cardrep.amt_pst_due = vAmtPastDueLoan /* Сумма просроченной задолженности */
   .
   /* End Of Информация о Грейс-периоде */

   RETURN.
END PROCEDURE.


/* Заполнение временной таблицы для операций по карте */
PROCEDURE BuildOpCard:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO. /* Карта                   */
   DEF INPUT  PARAM iLContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iLContCode  AS CHAR   NO-UNDO. /* Договор карты           */

   DEF VAR          vAcctC      AS CHAR   NO-UNDO. /* НП ИсклКорпПроводки     */
   DEF VAR          vCurrOE     AS CHAR   NO-UNDO. /* Валюта провоки          */


   DEF BUFFER loan   FOR loan.
   DEF BUFFER card   FOR loan.
   DEF BUFFER card2  FOR loan.
   DEF BUFFER cardD  FOR loan. /* Дополнительная карта */
   DEF BUFFER signs1 FOR signs.
   DEF BUFFER signs2 FOR signs.

   FIND FIRST card  WHERE card.contract  EQ iContract
                      AND card.cont-code EQ iContCode
   NO-LOCK.

   FIND FIRST loan  WHERE loan.contract  EQ iLContract
                      AND loan.cont-code EQ iLContCode
   NO-LOCK.

   ASSIGN
      vCurrOE = IF FGetSettingEx ("КартВыписка",
                                  "ПроводкиВВалДог",
                                  "",
                                  NO
                                 ) EQ "Да"
                THEN loan.currency
                ELSE ""
   .

   FOR EACH loan-acct OF loan
                      WHERE loan-acct.acct-type EQ "SCS@" + vCurrOE
   NO-LOCK:

      ASSIGN
         vAcctC = FGetSettingEx ("КартВыписка",
                                 "ИсклКорпПроводки",
                                 "",
                                 NO
                                )
      .

      FOR EACH op-entry            WHERE
              (op-entry.acct-db       EQ loan-acct.acct
           AND op-entry.op-date       GE mDateFrom
           AND op-entry.op-date       LE mDateTo
           AND op-entry.op-status     GT "Ф"
              )
           OR
              (op-entry.acct-cr       EQ loan-acct.acct
           AND op-entry.op-date       GE mDateFrom
           AND op-entry.op-date       LE mDateTo
           AND op-entry.op-status     GT "Ф"
              )
      NO-LOCK,
      FIRST op                      OF op-entry
      NO-LOCK:

         /* Пытаемся найти op-int для проводки (по допреквизитам Документ и Проводка) */
         RELEASE op-int.
         RELEASE signs1.
         RELEASE signs2.
         RELEASE cardD.
         FOR FIRST signs1 WHERE signs1.file-name  EQ "op-int"
                            AND signs1.code       EQ "Документ"
                            AND signs1.code-value EQ STRING(op.op)
         NO-LOCK,
         FIRST     signs2 WHERE signs2.file-name  EQ "op-int"
                            AND signs2.code       EQ "Проводка"
                            AND signs2.surr       EQ signs1.surr
                            AND signs2.code-value EQ STRING(op-entry.op-entry)
         NO-LOCK:
            FIND FIRST op-int WHERE
                       op-int.op-int-id EQ INT(signs1.surr)
                   AND op-int.op-int-id EQ INT(signs2.surr)
            NO-LOCK NO-ERROR.

            IF AVAIL op-int THEN
               FIND FIRST cardD WHERE
                          cardD.parent-contract  EQ loan.contract
                      AND cardD.parent-cont-code EQ loan.cont-code
                      AND NOT cardD.loan-work
                      AND cardD.contract         EQ ENTRY(1, op-int.surrogate)
                      AND cardD.cont-code        EQ ENTRY(2, op-int.surrogate)
               NO-LOCK NO-ERROR.
         END.

         /*
            КАРТА ПЕРСОНАЛЬНАЯ ДОПОЛНИТЕЛЬНАЯ
            Если op-int не найден, или карта на op-int'е не совпадает с обрабатываемой - пропускаем проводку
         */
         IF      loan.contract  EQ "card-pers"
            AND  NOT Pcard.loan-work
            AND (NOT AVAIL op-int
            OR   op-int.surrogate NE card.contract + "," + card.cont-code
                ) THEN
            NEXT.

         /*
         КАРТА КОРПОРАТИВНАЯ
         Если ИсклКорпПроводки = Да и при этом op-int не найден - пропускаем проводку
         Если op-int найден и его карта не совпадает с обрабатываемой - пропускаем проводку
         */

         IF      loan.contract  EQ "card-corp"
            AND (
                 (vAcctC EQ "Да"
            AND   NOT AVAIL op-int
                 )
              OR (AVAIL op-int
            AND   op-int.surrogate NE card.contract + "," + card.cont-code
                 )
                ) THEN
            NEXT.

         /* Если на документе есть допреквизит ТранзПЦ - пропускаем проводку */
         IF GetXattrValue ("op",
                           STRING(op.op),
                           "ТранзПЦ"
                          ) NE "" THEN
            NEXT.

         IF     op-entry.currency NE ""
            AND op-entry.amt-cur  EQ 0 THEN
            NEXT.

         CREATE tt-opcard.

         /*
            tt-opcard.details:
            Если
            - выписка печатается по основной карте,
            - при этом op-int найден, и соответствует дополнительной карте:
            добавляем к op.details еще текст "по д.карте 4237xxxxxxxx73xx"
            где 4237xxxxxxxx73xx номер соответствующей дополнительной карты.
            Показываются первые 4 цифры номера карты и две предпоследние.
         */
         ASSIGN
            tt-opcard.card_num = card.doc-num

            tt-opcard.date_op  = IF AVAIL op-int
                                 THEN op-int.create-date
                                 ELSE ?

            tt-opcard.date_val = IF AVAIL op-int
                                 THEN op-int.cont-date
                                 ELSE op-entry.op-date

            tt-opcard.details  = op.details
                               + (IF     Pcard.loan-work
                                     AND AVAIL op-int
                                     AND AVAIL cardD
                                     AND op-int.surrogate EQ cardD.contract + ","
                                                           + cardD.cont-code
                                  THEN " по д. карте "
                                     + SUBSTR(cardD.doc-num, 1 , 4)
                                     + " xxxx xxxx "
                                     + SUBSTR(cardD.doc-num,
                                              LENGTH(cardD.doc-num) - 3, 2)
                                     + "xx"
                                  ELSE ""
                                 )

            tt-opcard.scs      = loan-acct.acct
            tt-opcard.acct-cor = IF loan-acct.acct EQ op-entry.acct-db
                                 THEN op-entry.acct-cr
                                 ELSE op-entry.acct-db

            tt-opcard.amm_op   = IF AVAIL op-int
                                 THEN op-int.par-dec[1]
                                 ELSE
                                 IF op-entry.currency EQ ""
                                 THEN op-entry.amt-rub
                                 ELSE op-entry.amt-cur

            tt-opcard.amm_op   = IF loan-acct.acct EQ op-entry.acct-db
                                 THEN tt-opcard.amm_op * (- 1)
                                 ELSE tt-opcard.amm_op
            tt-opcard.curr     = op-entry.currency
         .

         IF op-entry.currency EQ ENTRY (2, loan-acct.acct-type, "@") THEN
            tt-opcard.amm_acct = IF op-entry.currency EQ ""
                                 THEN op-entry.amt-rub
                                 ELSE op-entry.amt-cur.
         ELSE DO:
            IF ENTRY (2, loan-acct.acct-type, "@") EQ "" THEN
               tt-opcard.amm_acct = op-entry.amt-rub.
            ELSE
               tt-opcard.amm_acct = CurToCurWork ( "Учетный",
                                                   op-entry.currency,
                                                   ENTRY (2, loan-acct.acct-type, "@"),
                                                   op.op-date,
                                                  (IF op-entry.currency EQ ""
                                                   THEN op-entry.amt-rub
                                                   ELSE op-entry.amt-cur
                                                  )
                                                 ).
         END.
         ASSIGN
            tt-opcard.amm_acct = IF loan-acct.acct EQ op-entry.acct-db
                                 THEN tt-opcard.amm_acct * (- 1)
                                 ELSE tt-opcard.amm_acct

            tt-opcard.comm     = 0
            tt-opcard.total    = tt-opcard.amm_acct + tt-opcard.comm
         .
      END.
   END.

/* -------------------------------------------------------------------------- */

   /* Если карта дополнительная */
   IF NOT card.loan-work THEN
      RUN FTrans (iContract, iContCode, NO).

   /*
      Если карта основная персональная - выборка строится по всем картам договора,
      соответствующего выбранной карте (Даты, статусы - аналогично выборке по одной карте).
   */
   ELSE
   IF    (loan.contract EQ "card-pers"
      AND card.loan-work
         )
      OR (loan.contract EQ "card-corp") THEN
   FOR EACH card2 WHERE (card2.parent-contract  EQ loan.contract
                    AND  card2.parent-cont-code EQ loan.cont-code
                    AND  card2.cont-code        NE Pcard.cont-code
                        )
                    OR  (card2.parent-contract  EQ loan.contract
                    AND  card2.parent-cont-code EQ loan.cont-code
                    AND  Pcard.loan-work
                        )
   NO-LOCK:
      RUN FTrans (card2.contract, card2.cont-code, YES).
   END.

   IF loan.contract EQ "card-corp" THEN
      RUN AddOper (iContract, iContCode).

   RETURN.
END PROCEDURE.

/* Поиск и заполнения операций в ТТ. */
PROCEDURE FTrans:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iLog        AS LOG    NO-UNDO. /* Добавлять текст в поле details */

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
   DEF VAR          vCurr       AS CHAR   NO-UNDO. /* Заглушка                */
   DEF VAR          vList       AS CHAR   NO-UNDO.
   DEF VAR          vAmtA       AS DEC    NO-UNDO.
   DEF VAR          vAmtC       AS DEC    NO-UNDO.
   DEF VAR          vAmtComm    AS DEC    NO-UNDO.
   DEF VAR          vCur        AS CHAR   NO-UNDO.

   DEF BUFFER card      FOR loan.
   DEF BUFFER op        FOR op.
   DEF BUFFER op-entry1 FOR op-entry.
   DEF BUFFER op-entry2 FOR op-entry.
   DEF BUFFER signs     FOR signs.

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   /* Опредление списка статусов оперций */
   vList = FGetSettingEx ("КартВыписка",
                          "ВыпискаСтат",
                          "",
                          NO
                         ).

   FOR EACH pc-trans        WHERE
           (pc-trans.sur-card  EQ card.contract + "," + card.cont-code
        AND pc-trans.proc-date GE mDateFrom
        AND pc-trans.proc-date LE mDateTo
        AND CAN-DO (vList, pc-trans.pctr-status)
           )
        OR
           (pc-trans.sur-card  EQ card.contract + "," + card.cont-code
        AND pc-trans.proc-date EQ ?
        AND CAN-DO (vList, pc-trans.pctr-status)
           )
   NO-LOCK:
      RUN CardSummA    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtA,
                                  OUTPUT vCur
      ).
      RUN CardSummComm IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtComm,
                                  OUTPUT vCur
      ).
      RUN CardSummC    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtC,
                                  OUTPUT vCur
      ).

      CREATE tt-opcard.
      ASSIGN
         tt-opcard.date_op  = pc-trans.cont-date
         tt-opcard.date_val = pc-trans.proc-date
         tt-opcard.details  = GetEntries(1, pc-trans.pctr-code, CHR(1) , "")
                            + " , "
                            + pc-trans.eq-country + " "
                            + pc-trans.eq-city    + " "
                            + pc-trans.eq-location
                            + (IF  iLog
                               AND Pcard.loan-work
                               AND NOT card.loan-work
                               THEN " по д. карте "
                                  + SUBSTR(card.doc-num, 1 , 4)
                                  + " xxxx xxxx "
                                  + SUBSTR(card.doc-num,
                                           LENGTH(card.doc-num) - 3, 2)
                                  + "xx"
                               ELSE ""
                              )
         tt-opcard.code_op  = pc-trans.auth-code
         tt-opcard.amm_op   = IF pc-trans.dir
                              THEN vAmtC * (- 1)
                              ELSE vAmtC
         tt-opcard.amm_acct = IF pc-trans.dir
                              THEN vAmtA * (- 1)
                              ELSE vAmtA
         tt-opcard.comm     = vAmtComm * (- 1)
         tt-opcard.total    = tt-opcard.amm_acct + tt-opcard.comm
         tt-opcard.card_num = card.doc-num
         tt-opcard.curr     = vCur
         vAmtA              = 0
         vAmtC              = 0
         vAmtComm           = 0
      .

/* Из КД:
   Ищем документ, у которой есть допреквизит ТранзПЦ,
   содержащий код pc-trans.pctr-id.

   Если документ не найден - поля оставляем пустыми.
   Если документ есть: берем с этого документа проводку, с нее выбираем счета.
   СКС мы запомнили на предыдущем шаге,
   осталось определить корреспондирующий счет.
   ...
*/

      RELEASE signs.
      FIND FIRST signs WHERE signs.file-name  EQ     "op"
                         AND signs.code       EQ     "ТранзПЦ"
                         AND signs.code-value BEGINS STRING(pc-trans.pctr-id)
      NO-LOCK NO-ERROR.



      IF AVAIL signs THEN
      FOR FIRST op WHERE op.op EQ INT(signs.surrogate)
      NO-LOCK,
      FIRST op-entry1 OF op
      NO-LOCK:
         RUN GetRoleAcct IN h_card (       card.parent-contract + "," + card.parent-cont-code,
                                           mDateTo,
                                           "SCS",
                                           loan.currency,
                                    OUTPUT vAcct,
                                    OUTPUT vCurr
         ).
         tt-opcard.scs = vAcct.
/*
   ...
   Если проводка на документе не одна:
   - если один из счетов - счет курсовых разниц, эту проводку не рассматриваем.
   - остальных проводок может быть одна или 2.
     если проводка одна - корреспондирующий счет берем с нее.
     если проводок 2 - это полупроводки, соответственно,
     на каждой будет по одному счету.
*/
         IF NOT CAN-FIND (FIRST op-entry2 OF op
                                          WHERE ROWID(op-entry2) NE ROWID(op-entry1)
                         ) THEN
            tt-opcard.acct-cor = IF vAcct EQ op-entry1.acct-db
                                 THEN op-entry1.acct-cr
                                 ELSE op-entry1.acct-db
            .
         ELSE
         FOR EACH op-entry2 OF op
         NO-LOCK
         BREAK BY op-entry2.op:
            IF    CAN-DO(mAcctN, op-entry2.acct-cr)
               OR CAN-DO(mAcctN, op-entry2.acct-db)
               OR CAN-DO(mAcctP, op-entry2.acct-cr)
               OR CAN-DO(mAcctP, op-entry2.acct-db) THEN
               NEXT.

            IF LAST (op-entry2.op) THEN
               tt-opcard.acct-cor = IF vAcct EQ op-entry2.acct-db
                                    THEN op-entry2.acct-cr
                                    ELSE op-entry2.acct-db
               .
            ELSE
               tt-opcard.acct-cor = IF     op-entry2.acct-cr NE ?
                                       AND op-entry2.acct-cr NE vAcct
                                       AND op-entry2.acct-db EQ ?
                                    THEN op-entry2.acct-cr
                                    ELSE
                                    IF     op-entry2.acct-db NE ?
                                       AND op-entry2.acct-db NE vAcct
                                       AND op-entry2.acct-cr EQ ?
                                    THEN op-entry2.acct-db
                                    ELSE ""
               .


            IF tt-opcard.acct-cor NE "" THEN
               LEAVE.
         END.
      END.
   END.


   RETURN.
END PROCEDURE.


/* Расчет вспомогательного списка операций для корпоративных карт */
PROCEDURE AddOper:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.

   DEF VAR          vList       AS CHAR   NO-UNDO.
   DEF VAR          vAmtA       AS DEC    NO-UNDO.
   DEF VAR          vAmtComm    AS DEC    NO-UNDO.
   DEF VAR          vCur        AS CHAR   NO-UNDO.

   DEF BUFFER card      FOR loan.
   DEF BUFFER ocard     FOR loan. /* Другая карта того же корп. договора      */
   DEF BUFFER loan      FOR loan.

   /* Опредление списка статусов оперций */
   vList = FGetSettingEx ("КартВыписка",
                          "ВыпискаСтат",
                          "",
                          NO
                         ).

   FIND FIRST card  WHERE card.contract          EQ iContract
                      AND card.cont-code         EQ iContCode
   NO-LOCK.

   FOR FIRST loan   WHERE loan.contract          EQ card.parent-contract
                      AND loan.cont-code         EQ card.parent-cont-code
   NO-LOCK,
   EACH      ocard  WHERE ocard.parent-contract  EQ iContract
                      AND ocard.parent-cont-code EQ iContCode
                      AND RECID(ocard)           NE RECID(card)
   NO-LOCK,
   EACH pc-trans    WHERE pc-trans.sur-card      EQ ocard.contract + "," + ocard.cont-code
                      AND pc-trans.proc-date     EQ ?
                      AND CAN-DO (vList, pc-trans.pctr-status)
   NO-LOCK:
      RUN CardSummA    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtA,
                                  OUTPUT vCur
      ).
      RUN CardSummComm IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtComm,
                                  OUTPUT vCur
      ).

      CREATE tt-opcard.
      ASSIGN
         tt-opcard.date_op  = pc-trans.cont-date
         tt-opcard.date_val = pc-trans.proc-date
         tt-opcard.details  = GetEntries(1, pc-trans.pctr-code, CHR(1) , "")
                            + " , "
                            + pc-trans.eq-country + " "
                            + pc-trans.eq-city    + " "
                            + pc-trans.eq-location
         tt-opcard.code_op  = pc-trans.auth-code
         tt-opcard.amm_acct = IF pc-trans.dir
                              THEN vAmtA * (- 1)
                              ELSE vAmtA
         tt-opcard.comm     = vAmtComm * (- 1)
         tt-opcard.total    = tt-opcard.amm_acct + tt-opcard.comm
         tt-opcard.card_num = card.doc-num
         tt-opcard.curr     = vCur
         tt-opcard.AddOper  = YES
         vAmtA              = 0
         vAmtComm           = 0
      .
   END.


   RETURN.
END PROCEDURE.


/* Определение неснижаемого остатка. */
PROCEDURE CardMinOst:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oValComm    AS DEC    NO-UNDO.

   /* Заглушки */
   DEF VAR vCurrency   AS CHAR    NO-UNDO.
   DEF VAR vValComm    AS DEC     NO-UNDO.
   DEF VAR vValMinRate AS DEC     NO-UNDO.
   DEF VAR vPlusRate   AS DEC     NO-UNDO.
   DEF VAR vPeriodAdd  AS CHAR    NO-UNDO.
   DEF VAR vFixed      AS LOG     NO-UNDO.
   DEF VAR vPeriodDate AS CHAR    NO-UNDO. /* Срок оплаты тарифа */
   DEF VAR vScheme     AS CHAR    NO-UNDO. /* Схема начисления  */
   DEF VAR vCode       AS CHAR    NO-UNDO.

   DEF BUFFER loan FOR loan.
   DEF BUFFER card FOR loan.

   vCode = FGetSettingEx ("КартВыписка",
                          "НОстКомиссия",
                          "",
                          NO
                         ).

   IF SUBSTRING(vCode, LENGTH(vCode)) EQ "*" THEN
   DO:
      FIND FIRST card WHERE card.contract  EQ iContract
                        AND card.cont-code EQ iContCode
         NO-LOCK NO-ERROR.
      IF AVAIL card THEN
      DO:
         FIND FIRST loan WHERE loan.contract  EQ card.parent-contract
                           AND loan.cont-code EQ card.parent-cont-code
            NO-LOCK NO-ERROR.
         IF AVAIL loan THEN
            vCode = SUBSTRING(vCode, 1, LENGTH(vCode) - 1) + loan.currency.
      END.
   END.

   RUN getCommCard IN h_card (iContract,
                              iContCode,
                              vCode,
                              iSince,
                              OUTPUT vCurrency,
                              OUTPUT oValComm, /* Неснижаемый остаток */
                              OUTPUT vValMinRate,
                              OUTPUT vPlusRate,
                              OUTPUT vPeriodAdd,
                              OUTPUT vFixed,
                              OUTPUT vPeriodDate,
                              OUTPUT vScheme).

   RETURN.
END PROCEDURE.


/* Определение остатка на начало периода */
PROCEDURE CardInitBal:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince - 1,
                                 OUTPUT oAmt
   ).

   RETURN.
END PROCEDURE.


/* Печать выписки по одной карте */
PROCEDURE PrintCardRep:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.

   DEF VAR vCodeMisc2       AS CHAR NO-UNDO. /* Процессинго из классификатора КартыБанка */
   DEF VAR vProcessing      AS CHAR NO-UNDO. /* НП ВыпискаПЦТамож                 */
   DEF VAR vShowCorpOb      AS CHAR NO-UNDO. /* НП ПоказКорпОбороты           */
   DEF VAR vShowNOstOsnCard AS CHAR NO-UNDO. /* НП ПоказНОстОснКарт           */
   DEF VAR vShowNOstDopCard AS CHAR NO-UNDO. /* НП ПоказНОстДопКарт           */
   DEF VAR vShowSGPOOsnCard AS CHAR NO-UNDO. /* НП ПоказСГПОснКарт            */
   DEF VAR vShowSGPODopCard AS CHAR NO-UNDO. /* НП ПоказСГПДопКарт            */
   DEF VAR vShowDebt        AS CHAR NO-UNDO. /* НП ПоказЗадолж                */
   DEF VAR vShowCredLine    AS CHAR NO-UNDO. /* НП ПоказКредЛиния             */
   DEF VAR vShowBlockAmt    AS CHAR NO-UNDO. /* НП ПоказБлок                  */
   DEF VAR vShowAvailAmt    AS CHAR NO-UNDO. /* НП ПоказДостЛим               */
   DEF VAR vShowBanOverd    AS CHAR NO-UNDO. /* НП ПоказНеразрОвер            */
   DEF VAR vShowDelay       AS CHAR NO-UNDO. /* НП ПоказПросрочка             */
   DEF VAR vShowUnusedOver  AS CHAR NO-UNDO. /* НП ПоказНеиспЛим              */

   DEF VAR vCnt             AS INT  NO-UNDO.
   DEF VAR vNameOrg         AS CHAR NO-UNDO.

   DEF BUFFER card FOR loan.

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   ASSIGN
      /* Надо как-то отличать таможенные карты */
      vProcessing      = FGetSettingEx ("КартВыписка",
                                         "ВыпискаПЦТамож",
                                         "",
                                         NO
                                       )
      vShowCorpOb      = FGetSettingEx ("КартВыписка",
                                        "ПоказКорпОбороты",
                                        "",
                                        NO
                                       )
      vShowNOstOsnCard = FGetSettingEx ("КартВыписка",
                                        "ПоказНОстОснКарт",
                                        "",
                                        NO
                                       )
      vShowNOstDopCard = FGetSettingEx ("КартВыписка",
                                        "ПоказНОстДопКарт",
                                        "",
                                        NO
                                       )
      vShowSGPOOsnCard = FGetSettingEx ("КартВыписка",
                                        "ПоказСГПОснКарт",
                                        "",
                                        NO
                                       )
      vShowSGPODopCard = FGetSettingEx ("КартВыписка",
                                        "ПоказСГПДопКарт",
                                        "",
                                        NO
                                       )
      vShowDebt        = FGetSettingEx ("КартВыписка",
                                        "ПоказЗадолж",
                                        "",
                                        NO
                                       )
      vShowCredLine    = FGetSettingEx ("КартВыписка",
                                        "ПоказКредЛиния",
                                        "",
                                        NO
                                       )
      vShowBlockAmt    = FGetSettingEx ("КартВыписка",
                                        "ПоказБлок",
                                        "",
                                        NO
                                       )

      vShowAvailAmt    = FGetSettingEx ("КартВыписка",
                                        "ПоказДостЛим",
                                        "",
                                        NO
                                       )
      vShowBanOverd    = FGetSettingEx ("КартВыписка",
                                        "ПоказНеразрОвер",
                                        "",
                                        NO
                                       )

      vShowDelay       = FGetSettingEx ("КартВыписка",
                                        "ПоказПросрочка",
                                        "",
                                        NO
                                       )
      vShowUnusedOver  = FGetSettingEx ("КартВыписка",
                                        "ПоказНеиспЛим",
                                        "",
                                        NO
                                       )

      vCodeMisc2       = GetCodeMisc   ("КартыБанка", card.sec-code, 2)
   .

   FOR EACH tt-cardrep:
      PUT STREAM fil UNFORMATTED FGetSettingEx ("КартВыписка",
                                                "ВыпискаВерхКол",
                                                "",
                                                NO
                                               ) SKIP.

      PUT STREAM fil UNFORMATTED FGetSettingEx ("КартВыписка",
                                                "ВыпискаВерхКол2",
                                                "",
                                                NO
                                               ) SKIP.

      PUT STREAM fil UNFORMATTED FGetSettingEx ("КартВыписка",
                                                "ВыпискаВерхКол3",
                                                "",
                                                NO
                                               ) SKIP(2).

      PUT STREAM fil UNFORMATTED FILL(" ", 50) + "Выписка (Report)" SKIP.
      PUT STREAM fil UNFORMATTED FILL(" ", 30) + "за период с (from) "
         + STRING(mDateFrom) + " по (to) " + STRING(mDateTo) SKIP(1).


      IF FGetSettingEx ("КартВыписка",
                        "ПоказНаимОрг",
                        "",
                        NO
                       ) EQ "Да" THEN
      DO:
         RUN GetNameOrg (       card.parent-contract,
                                card.parent-cont-code,
                         OUTPUT mNameOrg).
         DO mCnt = 1 TO 3:
            IF mCnt EQ 2 THEN
            DO:
               IF NUM-ENTRIES(mNameOrg, CHR(1)) GT 1 THEN
               DO:
                  vNameOrg = mNameOrg.
                  DO vCnt = 1 TO NUM-ENTRIES(vNameOrg, CHR(1)):
                     mNameOrg = ENTRY(vCnt, vNameOrg, CHR(1)).
                     RUN PutLine(RepTempl2[mCnt], NO).
                  END.
               END.
               ELSE DO:
                  mNameOrg = REPLACE(mNameOrg, CHR(1), "").
                  RUN PutLine(RepTempl2[mCnt], NO).
               END.
            END.
            ELSE
               RUN PutLine(RepTempl2[mCnt], NO).
         END.
      END.

      DO mCnt = 1 TO 17:
         RUN PutLine(RepTempl[mCnt], NO).
      END.

      /* Если нет операций печатаем сразу закрывающую линию */
      IF NOT CAN-FIND (FIRST tt-opcard) THEN
         RUN PutLine(RepTempl[21], NO).

      ELSE DO:
         RUN PutLine(RepTempl[18], NO).

         /*
            Сортировка в цикле по таблице tt-opcard:
            1. по наличию/отсутствию даты расчета (НЕ ПО ЗНАЧЕНИЮ,
               а по <> ? - чтобы последними показывались авторизации)
            2. по дате операции
            3. по дате расчета

            Если карта основная персональная показываем ВСЕ операции
         */
         FOR EACH  tt-opcard WHERE
                 ( tt-opcard.card_num EQ card.doc-num
             AND  (NOT card.loan-work
              OR   loan.contract      EQ "card-corp"
                  )
             AND   tt-opcard.AddOper  EQ NO
                 )
             OR  (card.loan-work
             AND  loan.contract EQ "card-pers"
                 )
         BREAK BY tt-opcard.date_val NE ? DESC
               BY tt-opcard.date_val
               BY tt-opcard.date_op
               BY tt-opcard.card_num
         :

            /* Печать в неск. строк */
            ASSIGN
               mDet    = ""
               mDetEnt = 0
               mDet    = SplitStr(tt-opcard.details, 41, "│")
               mDetEnt = NUM-ENTRIES(mDet, "│") + 1
            .

            IF LINE-COUNTER(fil) + mDetEnt /*+ 1*/ LT PAGE-SIZE(fil)
            THEN DO:
               RUN PutLine (RepTempl[19], YES).
               DO WHILE mDet NE '':
                  RUN PutLine (RepTempl[20], NO).
               END.
            END.

            ELSE
            IF LINE-COUNTER(fil) + mDetEnt /*+ 1*/ GE PAGE-SIZE(fil)
            THEN DO:
               PAGE STREAM fil.
               RUN PutLine (RepTempl[21], YES).
               RUN PutLine (RepTempl[19], YES).
               DO WHILE mDet NE '':
                  RUN PutLine (RepTempl[20], NO).
               END.
            END.

            IF LAST (tt-opcard.card_num)
            THEN RUN PutLine(RepTempl[21], NO).
            ELSE RUN PutLine(RepTempl[18], NO).
         END.
      END.

      DO mCnt = 22 TO 40:
         /*
            Строка печатается только при следующих условиях:
            - либо НП КартВыписка/ПоказНОстОснКарт = ДА и карта главная
            - либо НП КартВыписка/ПоказНОстДопКарт = ДА и карта дополнительная

            Строка печатается только при следующих условиях:
            - либо НП КартВыписка/ПоказСГПОснКарт = ДА и карта главная
            - либо НП КартВыписка/ПоказСГПДопКарт = ДА и карта дополнительная
         */
         IF
            (
                  RepTempl[mCnt] BEGINS "│НЕСНИЖАЕМЫЙ ОСТАТОК"
               AND  NOT  ( (vShowNOstOsnCard EQ "Да"
                           AND Pcard.loan-work
                           )
                           OR
                           (vShowNOstDopCard EQ "Да"
                           AND NOT Pcard.loan-work
                           )
                         )
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "│СЧЁТ ГАРАНТИЙНОГО ПОКРЫТИЯ"
               AND  NOT  ( (vShowSGPOOsnCard EQ "Да"
                           AND Pcard.loan-work
                           )
                           OR
                           (vShowSGPODopCard EQ "Да"
                           AND NOT Pcard.loan-work
                          )
                        )
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "│СУММА ОВЕРДРАФТА"
               AND  NOT (vShowDebt EQ "Да")
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "│СУММА НЕИСПОЛЬЗОВАННОГО ОВЕРДРАФТА"
               AND  NOT  (    IsOverdraft (Pcard.parent-contract,
                                           Pcard.parent-cont-code,
                                           mDateTo
                                          )
                          AND vShowUnusedOver EQ "Да"
                         )
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "│СУММА ЛИМИТА ОВЕРДРАФТА"
               AND  NOT  (    IsOverdraft (Pcard.parent-contract,
                                           Pcard.parent-cont-code,
                                           mDateTo
                                          )
                          AND vShowCredLine EQ "Да"
                         )
            )
            OR
            (
                  RepTempl[mCnt] BEGINS "│БЛОКИРОВАННАЯ СУММА (НЕОПЛАЧЕННЫЕ ОПЕРАЦИИ)"
               AND  NOT  (    vShowBlockAmt EQ "Да"
                         )
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "│ДОСТУПНЫЙ ЛИМИТ"
               AND  NOT  (    vShowAvailAmt EQ "Да"
                         )
            )

            OR
            (
                  (RepTempl[mCnt] BEGINS "├───────────────────────────────────────────────┬"
                OR RepTempl[mCnt] BEGINS "├───────────────────────────────────────────────┴"
                OR RepTempl[mCnt] BEGINS "│ГРЕЙС:"
                  )
               AND  NOT  (    tt-cardrep.flg_grs_pnt)
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "│СУММА НЕРАЗРЕШЕННОГО ОВЕРДРАФТА"
               AND  NOT  (    tt-cardrep.amt_uns_ovd NE 0
                          AND vShowBanOverd          EQ "Да"
                         )
            )

            OR
            (
                  RepTempl[mCnt] BEGINS "│СУММА ПРОСРОЧЕННОЙ ЗАДОЛЖЕННОСТИ"
               AND  NOT  (    tt-cardrep.amt_pst_due NE 0
                          AND vShowDelay             EQ "Да"
                         )
            )

         THEN NEXT.

         /* Проверяем на принадлежность к корп. картам. Пихать эту проверку выше будет большим нагромождением.

         ** Если карта корпоративная (не таможенная и не физлица) и НП
         ** КартВыписка/ПоказКорпОбороты = Да, необходимо печатать только итоговые строки
         ** ОБОРОТЫ ПО ПРИХОДУ ЗА ПЕРИОД
         ** ОБОРОТЫ ПО РАСХОДУ ЗА ПЕРИОД
         ** Остальные итоговые строки не печатаются.
         ** Если карта таможенная или физлица или НП КартВыписка/ПоказКорпОбороты = Нет - печать итоговых строк управляется, как и ранее, соответствующими настроечными параметрами.
         ** Для того, чтобы определить, является ли карта таможенной - создан дополнительный настроечный параметр КартВыписка/ВыпискаПЦТамож, содержащий код процессинга таможенных карт.
         */
         IF    (    loan.contract      EQ "card-corp"
                AND NOT CAN-DO(vProcessing, vCodeMisc2)
                AND
                (   RepTempl[mCnt] BEGINS "│ОБОРОТ ПО ПРИХОДУ ЗА ПЕРИОД"
                 OR RepTempl[mCnt] BEGINS "│ОБОРОТ ПО РАСХОДУ ЗА ПЕРИОД"
                 OR mCnt EQ 40
                )
                AND vShowCorpOb EQ "Да"
               )
            OR (    loan.contract      EQ "card-corp"
                AND NOT CAN-DO(vProcessing, vCodeMisc2)     /*** SSitov: скорректировал по заявке №1188  */
               )
            OR (loan.contract      EQ "card-pers")
         THEN
            RUN PutLine(RepTempl[mCnt], NO).
      END.

      IF     FGetSettingEx ("КартВыписка",
                            "ПоказОкончание",
                            "",
                            NO
                           ) EQ "Да"
         AND mDateTo + INT(FGetSettingEx ("КартВыписка",
                           "ОкончаниеСрок",
                           "",
                           NO
                          )) GE Pcard.end-date THEN
         PUT STREAM fil UNFORMATTED FGetSettingEx ("КартВыписка",
                                                   "ОкончаниеТекст",
                                                   "",
                                                   NO
                                                  ) SKIP.


      PUT STREAM fil UNFORMATTED "Телефон для справок: " + FGetSettingEx ("КартВыписка",
                                                                          "ВыпискаТел",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED "E-mail: "              + FGetSettingEx ("КартВыписка",
                                                                          "ВыпискаПочта",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED "Web: "                 + FGetSettingEx ("КартВыписка",
                                                                          "ВыпискаСайт",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED                           FGetSettingEx ("КартВыписка",
                                                                          "ВыпискаНижнКол",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED                           FGetSettingEx ("КартВыписка",
                                                                          "ВыпискаНижнКол2",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.

      PUT STREAM fil UNFORMATTED                           FGetSettingEx ("КартВыписка",
                                                                          "ВыпискаНижнКол3",
                                                                          "",
                                                                          NO
                                                                         ) SKIP.
   END.

   RETURN.
END PROCEDURE.  /* PrintCardRep */


/* Определение исходящего остатка */
PROCEDURE CardTotalBal:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince,
                                 OUTPUT oAmt
   ).

   RETURN.
END PROCEDURE.


/* Определение задолженности по овердрафту */
PROCEDURE CardOverdraft:
   DEF INPUT  PARAM iPaContract AS CHAR   NO-UNDO. /* parent-contract         */
   DEF INPUT  PARAM iPaContCode AS CHAR   NO-UNDO. /* parent-cont-code        */
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO. /* Дата                    */

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO. /* sh-bal | sh-val         */

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
   DEF VAR          vCurr       AS CHAR   NO-UNDO.
   DEF VAR          vAmt1       AS DEC    NO-UNDO.
   DEF VAR          vAmt2       AS DEC    NO-UNDO.
   DEF VAR          vAmt3       AS DEC    NO-UNDO.

   DEF BUFFER  loan      FOR loan.      /* Договор */
   DEF BUFFER bloan      FOR loan.      /* Договор */
   DEF BUFFER  loan-acct FOR loan-acct.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract  EQ iPaContract
                    AND loan.cont-code EQ iPaContCode
   NO-LOCK:
      RUN GetRoleAcct IN h_card (       loan.contract + "," + loan.cont-code,
                                        iSince,
                                        "SCS",
                                        loan.currency,
                                 OUTPUT vAcct,
                                 OUTPUT vCurr
      ).

      IF vAcct NE ""
      THEN DO:
         FOR EACH loan-acct WHERE loan-acct.acct      EQ vAcct
                              AND loan-acct.currency  EQ vCurr
                              AND loan-acct.acct-type EQ "КредРасч"
                              AND loan-acct.since     LE iSince
         NO-LOCK,
         FIRST    bloan     OF loan-acct
		WHERE bloan.close-date GE iSince  OR bloan.close-date EQ ?
		AND NUM-ENTRIES(bloan.cont-code," ") = 1 
         NO-LOCK:
            IF GetXattrValue ("loan",
                              bloan.contract + "," + bloan.cont-code,
                              "КартОвер"
                             ) EQ "Разреш"
            THEN DO:
               FIND LAST term-obl WHERE term-obl.contract  EQ bloan.contract
                                    AND term-obl.cont-code EQ bloan.cont-code
                                    AND term-obl.end-date  LE iSince
                                    AND term-obl.idnt      EQ 2
               NO-LOCK NO-ERROR.
               IF AVAIL term-obl THEN
                  oAmt = oAmt + term-obl.amt-rub.
            END.
         END.
      END.
   END.

   RETURN.
END PROCEDURE.


/* Опредление платежного лимита */
PROCEDURE CardCurrentLimit:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO. /* Карта                   */
   DEF INPUT  PARAM iLContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iLContCode  AS CHAR   NO-UNDO. /* Договор карты           */

   DEF VAR vAmt1 AS DEC NO-UNDO.
   DEF VAR vAmt2 AS DEC NO-UNDO.
   DEF VAR vAmt3 AS DEC NO-UNDO.

   DEF BUFFER card  FOR loan.
   DEF BUFFER loan  FOR loan.
   DEF BUFFER cardO FOR loan. /* Буфер основной карты */

   FIND FIRST card WHERE card.contract  EQ iContract
                     AND card.cont-code EQ iContCode
   NO-LOCK.

   FIND FIRST loan WHERE loan.contract  EQ card.parent-contract
                     AND loan.cont-code EQ card.parent-cont-code
   NO-LOCK.
/*   
message
tt-cardrep.total_bal skip
tt-cardrep.ovefdraft skip
ABS(tt-cardrep.block_amm)
view-as alert-box.
*/


   /* Карта основная? */
   IF card.loan-work THEN
      tt-cardrep.open_to_buy = tt-cardrep.total_bal
                             + tt-cardrep.ovefdraft
                             - ABS(tt-cardrep.block_amm).
   ELSE DO:
      /* Определение основной карты */
      FOR FIRST loan WHERE loan.contract          EQ card.parent-contract
                       AND loan.cont-code         EQ card.parent-cont-code
      NO-LOCK,

      FIRST cardO    WHERE cardO.parent-contract  EQ loan.contract
                       AND cardO.parent-cont-code EQ loan.cont-code
                       AND cardO.loan-work        EQ YES
      NO-LOCK:
         /* Построение списка операций по карте */
         RUN BuildOpCard (cardO.contract,
                          cardO.cont-code,
                          loan.contract,
                          loan.cont-code

         ).

         /* Определение блокированной суммы */
         FOR EACH tt-opcard WHERE tt-opcard.date_val EQ ?
         :
            vAmt1 = vAmt1 + tt-opcard.total.
         END.

         /* Определение задолженности по овердрафту */
         RUN CardOverdraft (       cardO.parent-contract,
                                   cardO.parent-cont-code,
                                   mDateTo,
                            OUTPUT vAmt2
         ).

         /* Определение остатка на конец периода */
         RUN CardTotalBal (       cardO.parent-contract,
                                  cardO.parent-cont-code,
                                  mDateTo,
                           OUTPUT vAmt3
         ).

         tt-cardrep.open_to_buy = vAmt3 + vAmt2 - ABS(vAmt1).
      END.
   END.

   RETURN.
END PROCEDURE.


/* Печать строки */
PROCEDURE PutLine PRIVATE:
   DEF INPUT PARAMETER iRepTempl        AS CHAR    NO-UNDO.
   DEF INPUT PARAMETER iFirst           AS LOG     NO-UNDO.

   DEF VAR             vCnt             AS INT     NO-UNDO.
   DEF VAR             vLen             AS INT     NO-UNDO.
   DEF VAR             vItm             AS CHAR    NO-UNDO.
   DEF VAR             vVal             AS CHAR    NO-UNDO.
   DEF VAR             vStr             AS CHAR    NO-UNDO.

   vStr = iRepTempl.

   DO vCnt = 2 TO NUM-ENTRIES(iRepTempl, "│"):

      ASSIGN
         vItm = ENTRY  (vCnt, iRepTempl, "│")
         vLen = LENGTH (vItm)
      .

      CASE TRIM(vItm):
         WHEN ""                          THEN
            NEXT.

         WHEN "_Фамилия"                  THEN
            vVal = STRING(ENTRY(1, tt-cardrep.name, CHR(1))).

         WHEN "_Familia1"                 THEN
            vVal = STRING(ENTRY(2, tt-cardrep.name, CHR(1))).

         WHEN "_Familia2"                 THEN
            vVal = STRING(ENTRY(3, tt-cardrep.name, CHR(1))).

         WHEN "_Адрес"                    THEN
            vVal = STRING(tt-cardrep.address).

         WHEN "_Датавыписки"              THEN
            vVal = STRING(tt-cardrep.data).

         WHEN "_Типкарты"                 THEN
            vVal = STRING(tt-cardrep.type-card).

         WHEN "_Номеркарты"               THEN
            vVal = STRING(tt-cardrep.card_num).

         WHEN "_Датаоперации"             THEN
            vVal = STRING(tt-opcard.date_op).

         WHEN "_Датарасчета"              THEN
         DO:
            IF tt-opcard.date_val EQ ?
            THEN vVal = "А".
            ELSE vVal = STRING(tt-opcard.date_val).
         END.

         WHEN "_Содержаниеоперации"       THEN
         DO:
            vVal = ENTRY(1, mDet, "│").
            ENTRY(1, mDet, "│") = "".

            IF mDet NE ""                THEN
               mDet = SUBSTRING(mDet, 2).
         END.

         WHEN "_Кодавторизац"             THEN
            vVal = STRING(tt-opcard.code_op).

         WHEN "_Ввалютеопер"              THEN
            vVal = STRING(tt-opcard.amm_op, mFormatDec) + " "
                 + GetISOCode(tt-opcard.curr).

         WHEN "_Ввалютесчета"             THEN
            vVal = STRING(tt-opcard.amm_acct, mFormatDec) + " "
                 + GetISOCode(loan.currency).

         WHEN "_Комиссия"                 THEN
            vVal = STRING(tt-opcard.comm, mFormatDec).

         WHEN "_Итого"                    THEN
            vVal = STRING(tt-opcard.total, mFormatDec).

         WHEN "_неснижаемыйостаток"       THEN
            vVal = STRING(tt-cardrep.ins_depos, mFormatDec).

         WHEN "_счетгарнтпокр"       THEN
            vVal = STRING(tt-cardrep.bal_sgp, mFormatDec).

         WHEN "_остатокнаначалопериода"   THEN
            vVal = STRING(tt-cardrep.init_bal, mFormatDec).

         WHEN "_оборотпоприходузапериод"  THEN
            vVal = STRING(tt-cardrep.credit_turn, mFormatDec).

         WHEN "_оборотпорасходузапериод"  THEN
            vVal = STRING(tt-cardrep.debit_turn, mFormatDec).

         WHEN "_остатокнаконецпериода"    THEN
            vVal = STRING(tt-cardrep.total_bal, mFormatDec).

         WHEN "_Блокированнаясумма" THEN
            vVal = STRING(tt-cardrep.block_amm, mFormatDec).

         WHEN "_Допустимыйперерасход"     THEN
            vVal = STRING(tt-cardrep.ovefdraft, mFormatDec).

         WHEN "_Текущийрасходныйлимит"    THEN
            vVal = STRING(tt-cardrep.open_to_buy, mFormatDec).

         WHEN "_Доступныйлимит"           THEN
            vVal = STRING(tt-cardrep.avail_amt, mFormatDec).

         WHEN "_Суммаовердрафта"          THEN
            vVal = STRING(tt-cardrep.debts, mFormatDec).

         WHEN "_СуммНеиспОвер"            THEN
            vVal = STRING(tt-cardrep.notover, mFormatDec).

         WHEN "_Суммалимитаовердрафта"    THEN
            vVal = STRING(tt-cardrep.LimOver, mFormatDec).

         WHEN "_Суммаминплатежа"          THEN
            vVal = STRING(tt-cardrep.amt_min_pay, mFormatDec).

         WHEN "_Датаминпл"                THEN
            vVal = " " + STRING(tt-cardrep.dat_min_pay).

         WHEN "_Датаконгрейс-периода"     THEN
            vVal = IF tt-cardrep.dat_grs_end EQ ?
                   THEN "ГРЕЙС ОКОНЧЕН"
                   ELSE STRING(tt-cardrep.dat_grs_end)
            .

         WHEN "_Сумманеразрешенногоовердрафта"  THEN
            vVal = STRING(tt-cardrep.amt_uns_ovd, mFormatDec).

         WHEN "_Суммапросроченнойзадолженности" THEN
            vVal = STRING(tt-cardrep.amt_pst_due, mFormatDec).

         WHEN "_Организация" THEN
            vVal = mNameOrg.

         OTHERWISE
            NEXT.
      END CASE.

      IF vVal EQ ?                        THEN
         vVal = "".

      vVal = TRIM(vVal).

      IF      vItm BEGINS " "
          AND SUBSTR(vItm, vLen) = " "
      THEN
         vVal = PADC(vVal, vLen).
      ELSE IF vItm BEGINS " "             THEN
         vVal = PADL(vVal, vLen).
      ELSE
         vVal = PADR(vVal, vLen).

      ENTRY(vCnt, vStr, "│") = vVal.
   END.

   IF    vStr BEGINS "│НЕСНИЖАЕМЫЙ ОСТАТОК"
      OR vStr BEGINS "│СЧЁТ ГАРАНТИЙНОГО ПОКРЫТИЯ"
      OR vStr BEGINS "│СУММА ОВЕРДРАФТА (Debts)"
      OR vStr BEGINS "│СУММА НЕИСПОЛЬЗОВАННОГО ОВЕРДРАФТА"
      OR vStr BEGINS "│СУММА ЛИМИТА ОВЕРДРАФТА"
      OR vStr BEGINS "│СУММА НЕРАЗРЕШЕННОГО ОВЕРДРАФТА"
      OR vStr BEGINS "│СУММА ПРОСРОЧЕННОЙ ЗАДОЛЖЕННОСТИ"
   THEN
      ASSIGN
         vItm              = FGetSettingEx ("КартВыписка"
                                            ,
                                            IF vStr BEGINS "│НЕСНИЖАЕМЫЙ ОСТАТОК"
                                            THEN "НОстТекст"

                                            ELSE
                                            IF vStr BEGINS "│СЧЁТ ГАРАНТИЙНОГО ПОКРЫТИЯ"
                                            THEN "СГПТекст"

                                            ELSE
                                            IF vStr BEGINS "│СУММА ОВЕРДРАФТА (Debts)"
                                            THEN "ЗадолжТекст"

                                            ELSE
                                            IF vStr BEGINS "│СУММА НЕИСПОЛЬЗОВАННОГО ОВЕРДРАФТА"
                                            THEN "НеиспЛимТекст"

                                            ELSE
                                            IF vStr BEGINS "│СУММА ЛИМИТА ОВЕРДРАФТА"
                                            THEN "КредЛинияТекст"

                                            ELSE
                                            IF vStr BEGINS "│СУММА НЕРАЗРЕШЕННОГО ОВЕРДРАФТА"
                                            THEN "НеразрОверТекст"

                                            ELSE
                                            IF vStr BEGINS "│СУММА ПРОСРОЧЕННОЙ ЗАДОЛЖЕННОСТИ"
                                            THEN "ПросрочкаТекст"

                                            ELSE ""
                                            ,
                                            ""
                                            ,
                                            NO
                                           )
         vItm              = IF LENGTH(vItm) LT 102
                             THEN vItm + FILL(" ", 102 - LENGTH(vItm))
                             ELSE SUBSTR(vItm, 1, 102)
         ENTRY(2,vStr,"│") = vItm
      .

   PUT STREAM fil UNFORMATTED vStr SKIP.

   RETURN.
END PROCEDURE.   /* PutLine */


/* Обороты по карте */
PROCEDURE CardTurnovers:
   DEF INPUT  PARAM iContract       AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode       AS CHAR   NO-UNDO. /* Карта               */

   DEF OUTPUT PARAM oCreditTurnover AS DEC    NO-UNDO. /* приходные обороты   */
   DEF OUTPUT PARAM oDebitTurnover  AS DEC    NO-UNDO. /* расходные обороты   */

   DEF VAR vList1 AS CHAR NO-UNDO.
   DEF VAR vList2 AS CHAR NO-UNDO.

   DEF BUFFER card FOR loan.

   ASSIGN
      vList1 = FGetSettingEx ("КартВыписка",
                              "ВыпискаБалКр",
                              "",
                              NO
                             )
      vList2 = FGetSettingEx ("КартВыписка",
                              "ОборотДобАвт",
                              "",
                              NO
                             )
   .
   /*
      Если лополнительная или корпоративная, то по карте.
      Если карта основная персональная считаем ВСЕ обороты.
   */

   FOR FIRST card WHERE card.contract      EQ iContract
                    AND card.cont-code     EQ iContCode
   NO-LOCK,
   EACH tt-opcard WHERE (tt-opcard.card_num EQ card.doc-num
                    AND  (NOT card.loan-work
                     OR   loan.contract     EQ "card-corp"
                         )
                    AND  tt-opcard.AddOper   EQ NO
                        )
                     OR
                        (card.loan-work
                     AND loan.contract      EQ "card-pers"
                        )
   :
      /*
         Для расчета приходных оборотов просматриваются все операции.
         - обязательно учитываются операции, у которых определена Дата расчета
         - если настроечный параметр КартВыписка/ОборотДобАвт = ДА,
           также учитываются операции, у которых НЕ определена
           дата расчета (такие операции считаются операциями авторизации).
         FUNC15823
      */
      IF     date_val EQ ?
         AND vList2   NE "ДА" THEN
         NEXT.
	 

if tt-opcard.details matches "*комис*" then
message
1 tt-opcard.amm_acct skip
2 tt-opcard.details skip
3 tt-opcard.scs skip
4 tt-opcard.acct-cor skip
5 vList1 skip
6 date_val skip
7 tt-opcard.comm
view-as alert-box.

	 
      IF tt-opcard.amm_acct LE 0 THEN
/*         oDebitTurnover  = oDebitTurnover + tt-opcard.amm_acct.	 */
         oDebitTurnover = oDebitTurnover
                         + (IF    tt-opcard.acct-cor EQ ""
                               OR NOT CAN-DO(vList1, tt-opcard.acct-cor)
                            THEN tt-opcard.amm_acct
                            ELSE 0
                           ).



      ELSE
      /* Если корреспондирующий счет подходит под маску из параметра исключаемых счетов - пропускаем */
         oCreditTurnover = oCreditTurnover
                         + (IF    tt-opcard.acct-cor EQ ""
                               OR NOT CAN-DO(vList1, tt-opcard.acct-cor)
                            THEN tt-opcard.amm_acct
                            ELSE 0
                           ).

      IF tt-opcard.comm LE 0 THEN
         oDebitTurnover  = oDebitTurnover + tt-opcard.comm.
      ELSE
         oCreditTurnover = oCreditTurnover + tt-opcard.comm.
   END.


   RETURN.
END PROCEDURE.

/* Блокированная сумма */
PROCEDURE GetBlockedAmt:
   DEF INPUT  PARAM iCardNum         AS CHAR   NO-UNDO. /* Карта               */
   DEF INPUT  PARAM iSurr            AS CHAR   NO-UNDO. /* Суррогат Карты               */
   DEF INPUT  PARAM iParentContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iParentContCode  AS CHAR   NO-UNDO.
   DEF OUTPUT PARAM oAmt             AS DEC    NO-UNDO.

   DEFINE VARIABLE vBlokSumm  AS CHARACTER      NO-UNDO.
   DEFINE VARIABLE vSurrAcct  AS CHARACTER      NO-UNDO.
   DEFINE VARIABLE vProcesing AS CHARACTER      NO-UNDO. /* Процесинг */

   DEF BUFFER loan FOR loan. /* Локализация буфера. */

   /* Определение блокированной суммы */
   vBlokSumm = fGetSetting ("КартВыписка", "БлокСумма"  , "" ).
   IF vBlokSumm EQ "Авториз"
   THEN DO:
      FOR EACH tt-opcard WHERE (tt-opcard.date_val EQ ?
                            AND iParentContract    EQ "card-corp"
                            AND tt-opcard.card_num EQ iCardNum
                               )
                            OR (tt-opcard.date_val EQ ?
                            AND iParentContract    EQ "card-pers"
                               )
                            OR (tt-opcard.AddOper)
      :
         oAmt = oAmt + tt-opcard.total.
      END.
   END.
   ELSE IF vBlokSumm EQ "Холды"
   THEN DO:
      FIND FIRST loan WHERE loan.contract  EQ iParentContract
                        AND loan.cont-code EQ iParentContCode
         NO-LOCK NO-ERROR.
      IF AVAIL loan
      THEN DO:
         ASSIGN
            vSurrAcct  = ENTRY(1,GetLinks ("card",iSurr,?,"КартаПроц",CHR(1),mDateTo),CHR(1))
            vProcesing = GetCodeMisc("КартыБанка",loan.trade-sys,2)
         .
         FIND LAST op-int WHERE op-int.file-name   EQ "acct"
                            AND op-int.surrogate   EQ vSurrAcct
                            AND op-int.class-code  EQ "СчетОстХлд"
                            AND op-int.create-date LE mDateTo
                            AND op-int.destination EQ vProcesing
            NO-LOCK NO-ERROR.
         IF AVAIL op-int THEN oAmt = op-int.par-dec[2].
      END.
   END.

END PROCEDURE.

/* Доступный лимит */
PROCEDURE GetAvailAmt:
   DEF INPUT  PARAM iCardNum         AS CHAR   NO-UNDO. /* Карта               */
   DEF INPUT  PARAM iSurr            AS CHAR   NO-UNDO. /* Суррогат Карты      */
   DEF INPUT  PARAM iParentContract  AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iParentContCode  AS CHAR   NO-UNDO.
   DEF OUTPUT PARAM oAmt             AS DEC    NO-UNDO.

   DEFINE VARIABLE vSurrAcct  AS CHARACTER     NO-UNDO.
   DEFINE VARIABLE vProcesing AS CHARACTER     NO-UNDO. /* Процесинг */

   DEF BUFFER loan FOR loan. /* Локализация буфера. */

   FIND FIRST loan WHERE loan.contract  EQ iParentContract
                     AND loan.cont-code EQ iParentContCode
      NO-LOCK NO-ERROR.
   IF AVAIL loan
   THEN DO:
      ASSIGN
         vSurrAcct =  ENTRY(1,GetLinks ("card",iSurr,?,"КартаПроц",CHR(1),mDateTo),CHR(1))
         vProcesing = GetCodeMisc("КартыБанка",loan.trade-sys,2)
      .
      FIND LAST op-int WHERE op-int.file-name   EQ "acct"
                         AND op-int.surrogate   EQ vSurrAcct
                         AND op-int.class-code  EQ "СчетОстХлд"
                         AND op-int.create-date LE mDateTo
                         AND op-int.destination EQ vProcesing
         NO-LOCK NO-ERROR.
      IF AVAIL op-int THEN oAmt = op-int.par-dec[3].
   END.

END PROCEDURE.


/* Получение наименования организации */
PROCEDURE GetNameOrg:
DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oNameOrg    AS CHAR   NO-UNDO.

   DEF VAR       vClName     AS CHAR   NO-UNDO EXTENT 3.
   DEF VAR       vLinkId     AS INT    NO-UNDO. /* GetXLink */

   DEF BUFFER loan  FOR loan.
   DEF BUFFER loan2 FOR loan.
   DEF BUFFER gr    FOR loan. /* З/П договор */
   DEF BUFFER xlink FOR xlink.

   FOR FIRST loan WHERE loan.contract  EQ iContract
                    AND loan.cont-code EQ iContCode
   NO-LOCK:
      IF iContract EQ "card-corp" THEN
      DO:
         RUN GetCustName IN h_base (             loan.cust-cat,
                                                 loan.cust-id,
                                                 "",
                                    OUTPUT       vClName[1],
                                    OUTPUT       vClName[2],
                                    INPUT-OUTPUT vClName[3]).
         oNameOrg = vClName[1] + " " + vClName[2].
      END.

      ELSE DO:
         RUN GetXLink IN h_xclass (       "card-loan-gr",
                                          "ДогПолучателя",
                                   OUTPUT vLinkId,
                                   BUFFER xlink
         ).

         FOR FIRST       loan2 WHERE loan2.contract  EQ iContract
                                 AND loan2.cont-code EQ iContCode
         NO-LOCK:
            /*
               Ищем первый действующий зп договор.
               Если действующего нет - то просто первый
            */
            forgr:
            FOR EACH     links  WHERE  links.link-id   EQ vLinkId
                                  AND  links.target-id EQ loan2.contract + "," +
                                                          loan2.cont-code
                                  AND (links.end-date  GE mDateTo
                                   OR  links.end-date  EQ ?)
            NO-LOCK:
               RELEASE gr.
               FIND FIRST gr    WHERE  gr.contract     EQ ENTRY(1, links.source-id)
                                  AND  gr.cont-code    EQ ENTRY(2, links.source-id)
                                  AND (gr.end-date     LE mDateTo
                                   OR  gr.end-date     EQ ?
                                      )
               NO-LOCK NO-ERROR.
               IF AVAIL gr THEN
               DO:
                  RUN GetCustName IN h_base (             gr.cust-cat,
                                                          gr.cust-id,
                                                          "",
                                             OUTPUT       vClName[1],
                                             OUTPUT       vClName[2],
                                             INPUT-OUTPUT vClName[3]).
                  oNameOrg = IF oNameOrg EQ ""
                             THEN vClName[1] + " " + vClName[2]
                             ELSE oNameOrg + CHR(1) + vClName[1] + " " + vClName[2].
               END.
            END.
         END.
      END.
   END.

   RETURN.
END PROCEDURE.


/* Расчет текущей задолженности */
PROCEDURE GetCredit:
DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   DEF VAR vAcctType AS CHAR NO-UNDO.
   DEF VAR vContract AS CHAR NO-UNDO.
   DEF VAR vContCode AS CHAR NO-UNDO.
   DEF VAR vAcct     AS CHAR NO-UNDO.
   DEF VAR vCurr     AS CHAR NO-UNDO.

   DEF BUFFER acct FOR acct.

   vAcctType = FGetSettingEx ("КартВыписка",
                              "РольСсудСчет",
                              "",
                              NO
                             ).

   RUN GetCardLoanCredit IN h_card (        iContract,
                                            iContCode,
                                            ?,
                                            mDateTo,
                                            "Разреш",
                                    OUTPUT vContract,
                                    OUTPUT vContCode
                                   ).

   RUN GetCredLoanBalance IN h_card (       vContract,
                                            vContCode,
                                            mDateTo,
                                            vAcctType,
                                     OUTPUT oAmt,
                                     OUTPUT vAcct,
                                     OUTPUT vCurr
                                    ).

   IF vAcct NE "" THEN
   DO:
      FOR FIRST acct WHERE acct.acct     EQ vAcct
                       AND acct.currency EQ vCurr
      NO-LOCK:
         IF acct.side EQ "П" THEN
            oAmt = oAmt * (- 1).
      END.
   END.

   RETURN.
END PROCEDURE.


/* Расчет неиспользованного лимита */
PROCEDURE GetLim:
DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   DEF VAR vAcctType AS CHAR NO-UNDO.
   DEF VAR vContract AS CHAR NO-UNDO.
   DEF VAR vContCode AS CHAR NO-UNDO.
   DEF VAR vAcct     AS CHAR NO-UNDO.
   DEF VAR vCurr     AS CHAR NO-UNDO.
   DEF VAR vAmt      AS DEC  NO-UNDO.
   DEF VAR vCode     AS CHAR NO-UNDO.

   DEF BUFFER acct FOR acct.

   ASSIGN
      vAcctType = FGetSettingEx ("КартВыписка",
                                 "РольНеиспЛим",
                                 "",
                                 NO
                                )

      vCode     = FGetSettingEx ("КартВыписка",
                                 "РольПросрочка",
                                 "",
                                 NO
                                )
      vCode     = IF ENTRY(1, vCode) EQ "КредПр"
                  THEN ENTRY(1, vCode)
                  ELSE ""
   .

   RUN GetCardLoanCredit IN h_card (        iContract,
                                            iContCode,
                                            ?,
                                            mDateTo,
                                            "Разреш",
                                    OUTPUT vContract,
                                    OUTPUT vContCode
                                   ).

   RUN GetCredLoanBalance IN h_card (       vContract,
                                            vContCode,
                                            mDateTo,
                                            vAcctType,
                                     OUTPUT oAmt,
                                     OUTPUT vAcct,
                                     OUTPUT vCurr
                                    ).

   RUN GetCredLoanBalance IN h_card (       vContract,
                                            vContCode,
                                            mDateTo,
                                            vCode,
                                     OUTPUT vAmt,
                                     OUTPUT vAcct,
                                     OUTPUT vCurr
                                    ).

   IF vAcct NE "" THEN
   DO:
      FOR FIRST acct WHERE acct.acct     EQ vAcct
                       AND acct.currency EQ vCurr
      NO-LOCK:
         IF acct.side EQ "П" THEN
            oAmt = oAmt * (- 1) - ABS(vAmt).
      END.
   END.

   RETURN.
END PROCEDURE.

