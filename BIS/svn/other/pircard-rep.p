/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2008 ЗАО "Банковские информационные системы"
     Filename: card_rep.p
      Comment: Операции по картам
   Parameters:
         Uses:
      Used by:
      Created: 11/02/2008  BMS
     Modified: 11/02/2008  BMS
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

DEF VAR mContract   AS CHAR NO-UNDO.
DEF VAR mContCode   AS CHAR NO-UNDO.
DEF VAR mAmt        AS DEC  NO-UNDO.
DEF VAR mDateFrom   AS DATE NO-UNDO.
DEF VAR mDateTo     AS DATE NO-UNDO.
DEF VAR mCnt        AS INT  NO-UNDO.
DEF VAR mFormatDec  AS CHAR NO-UNDO INIT "->,>>>,>>9.99".
DEF VAR mDet        AS CHAR NO-UNDO. /* Содержание операции в неск. строк     */
DEF VAR mDetEnt     AS INT  NO-UNDO. /* Содержание операции в неск. строк     */

DEF VAR RepTempl  AS CHAR NO-UNDO FORMAT "x(150)" EXTENT 30 INITIAL
[
"┌──────────────┬──────────────────────────────────────────────────────────────┬────────────┬───────────────────────────────────────────────────┐",
"│              │                                                              │Дата выписки│_Датавыписки                                       │",
"│  Ф.И.О.      │_Фамилия                                                      │Report date │                                                   │",
"│Client name   │                                                              ├────────────┼───────────────────────────────────────────────────┤",
"│              │_Familia1                                                     │ Тип карты  │_Типкарты                                          │",
"│              │_Familia2                                                     │ Card type  │                                                   │",
"├──────────────┼──────────────────────────────────────────────────────────────┼────────────┼───────────────────────────────────────────────────┤",
"│   Адрес      │_Адрес                                                        │Номер карты │_Номеркарты                                        │",
"│  Address     │                                                              │Card number │                                                   │",
"└──────────────┴──────────────────────────────────────────────────────────────┴────────────┴───────────────────────────────────────────────────┘",
" ",
"┌──────────────┬────────────┬─────────────────────────────────────────┬──────────────┬─────────────────────────────────┬───────────┬───────────┐",
"│              │            │                                         │              │             Сумма               │           │           │",
"│Дата операции │Дата расчета│          Содержание операции            │     Код      │             Amount              │ Комиссия  │   Итого   │",
"│Operation date│ Value date │           Operation details             │ авторизации  ├─────────────────┬───────────────┤    fee    │   Total   │",
"│              │            │                                         │Operation code│В валюте операции│В валюте счета │           │           │",
"│              │            │                                         │              │    Operation    │   Account     │           │           │",
"├──────────────┼────────────┼─────────────────────────────────────────┼──────────────┼─────────────────┼───────────────┼───────────┼───────────┤",
"│_Датаоперации │_Датарасчета│_Содержаниеоперации                      │_Кодавторизац │     _Ввалютеопер│  _Ввалютесчета│  _Комиссия│     _Итого│",
"│              │            │_Содержаниеоперации                      │              │                 │               │           │           │",
"├──────────────┴────────────┴─────────────────────────────────────────┴──────────────┴─────────────────┼───────────────┴───────────┴───────────┤",
"│НЕСНИЖАЕМЫЙ ОСТАТОК (Insurance deposit):                                                              │                    _неснижаемыйостаток│",
"│ОСТАТОК НА НАЧАЛО ПЕРИОДА (Initial balance):                                                          │                _остатокнаначалопериода│",
"│ОБОРОТ ПО ПРИХОДУ ЗА ПЕРИОД (Credit turnover):                                                        │               _оборотпоприходузапериод│",
"│ОБОРОТ ПО РАСХОДУ ЗА ПЕРИОД (Debit turnover):                                                         │               _оборотпорасходузапериод│",
"│ОСТАТОК НА КОНЕЦ ПЕРИОДА (Total balance):                                                             │                 _остатокнаконецпериода│",
"│БЛОКИРОВАННАЯ СУММА (НЕОПЛАЧЕННЫЕ ОПЕРАЦИИ) (Blocked amount):                                         │                    _Блокированнаясумма│",
"│ДОПУСТИМЫЙ ПЕРЕРАСХОД (КРЕДИТНЫЙ ЛИМИТ) (Acceptable overdarft):                                       │                  _Допустимыйперерасход│",
"│ТЕКУЩИЙ РАСХОДНЫЙ ЛИМИТ (opento-buy):                                                                 │                 _Текущийрасходныйлимит│",
"└──────────────────────────────────────────────────────────────────────────────────────────────────────┴───────────────────────────────────────┘"
].

DEF STREAM fil.

DEF TEMP-TABLE tt-cardrep NO-UNDO
   FIELD name        AS CHAR /* ФИО                                           */
   FIELD data        AS DATE /* дата выписки                                  */
   FIELD type-card   AS CHAR /* тип карты                                     */
   FIELD address     AS CHAR /* Адрес                                         */
   FIELD card_num    AS CHAR /* Номер карты                                   */
   FIELD ins_depos   AS DEC  /* неснижаемый остаток                           */
   FIELD init_bal    AS DEC  /* остаток на начало периода                     */
   FIELD credit_turn AS DEC  /* оборот по приходу за период                   */
   FIELD debit_turn  AS DEC  /* оборот по расходу за период                   */
   FIELD total_bal   AS DEC  /* остаток на конец периода                      */
   FIELD block_amm   AS DEC  /* Блокированная сумма (неопл-нные операции + 2%)*/
   FIELD ovefdraft   AS DEC  /* Допустимый перерасход (кредитный лимит)       */
   FIELD open_to_buy AS DEC  /* Текущий расходный лимит                       */

   INDEX card_num card_num
.

DEF TEMP-TABLE tt-opcard NO-UNDO
   FIELD card_num    AS CHAR /* номер карты                                   */
   FIELD date_op     AS DATE /* дата операции                                 */
   FIELD date_val    AS DATE /* дата расчета                                  */
   FIELD details     AS CHAR /* Содеожание операции                           */
   FIELD code_op     AS CHAR /* код авторизации                               */
   FIELD amm_op      AS DEC  /* сумма операции в валюте операции              */
   FIELD val_op      AS CHAR /* валюта операции                               */
   FIELD amm_acct    AS DEC  /* сумма операции в валюте счета                 */
   FIELD comm        AS DEC  /* комиссия                                      */
   FIELD total       AS DEC  /* комиссия                                      */

   INDEX card_num card_num
.

DEF BUFFER card  FOR loan. /* Буфер карты */
DEF BUFFER cardO FOR loan. /* Буфер основной карты */

MAIN:
DO ON ERROR UNDO MAIN, LEAVE MAIN:

   FIND FIRST card WHERE card.contract  EQ "card"
                     AND card.cont-code EQ iCont-code
   NO-LOCK NO-ERROR.

   IF NOT AVAIL card THEN
      UNDO MAIN, LEAVE MAIN.

   ASSIGN
      mDateFrom = iDate-from
      mDateTo   = iDateTo
   .

   /* Заполнение временных таблиц для выписки. */
   RUN BuildCardRep.

   /* Печать выписки по одной карте. */
   {setdest.i
      &stream   = "stream fil"
      &append   = "append"
   }

   RUN PrintCardRep.
END.

{intrface.del}



/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

/* Заполнение временных таблиц для выписки */
PROCEDURE BuildCardRep:
   DEF VAR         vClName AS CHAR NO-UNDO EXTENT 3.
   DEF VAR         vInn    AS CHAR NO-UNDO.
   DEF VAR         vKpp    AS CHAR NO-UNDO.
   DEF VAR         vType   AS CHAR NO-UNDO.
   DEF VAR         vCode   AS CHAR NO-UNDO.
   DEF VAR         vAcct   AS CHAR NO-UNDO.
   DEF VAR         vAddres AS CHAR NO-UNDO.


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
      tt-cardrep.card_num  = SUBSTR(card.doc-num, 1 , 4) + " xxxx xxxx "
                           + SUBSTR(card.doc-num, 13, 2) + "xx"
      tt-cardrep.data      = mDateTo
   .

   /* Определение и сохранение в tt-card неснижаемого остатка */
  
     RUN CardMinOstPir (   card.parent-contract,
                           card.parent-cont-code,
                           mDateTo,
                    OUTPUT mAmt
   ).
   ASSIGN
      tt-cardrep.ins_depos = mAmt
      mAmt                 = 0
   .

   /* Определение и сохранение в tt-card остатка на начало периода */
   RUN CardInitBal (       card.parent-contract,
                           card.parent-cont-code,
                           mDateFrom,
                    OUTPUT mAmt
   ).
   ASSIGN
      tt-cardrep.init_bal = mAmt * (- 1)
      mAmt                = 0
   .

   /* Определение и сохранение в tt-card оборота по приходу */
   RUN CardCreditTurnPir ( card.parent-contract,
                           card.parent-cont-code,
                           mDateFrom,
                           mDateTo,
                    OUTPUT mAmt
   ).   
   ASSIGN
      tt-cardrep.credit_turn = mAmt
      mAmt                   = 0
   .

   /* Определение и сохранение в tt-card оборота по расходу */
   RUN CardDebitTurnPir (  card.parent-contract,
                           card.parent-cont-code,
                           mDateFrom,
                           mDateTo,
                    OUTPUT mAmt
   ).   
   ASSIGN
      tt-cardrep.debit_turn = mAmt
      mAmt                  = 0
   .

   /* Определение и сохранение в tt-card исходящего остатка */
   RUN CardTotalBal (      card.parent-contract,
                           card.parent-cont-code,
                           mDateTo,
                    OUTPUT mAmt
   ).
   ASSIGN
      tt-cardrep.total_bal = mAmt * (- 1)
      mAmt                 = 0
   .

   /* Определение и сохранение в tt-card допустимого перерасхода */
   RUN CardOverdraft (       card.parent-contract,
                             card.parent-cont-code,
                             mDateTo,
                      OUTPUT mAmt
   ).
   ASSIGN
      tt-cardrep.ovefdraft = mAmt
      mAmt                 = 0
   .

   /* Построение списка операций по карте */
   RUN BuildOpCard (card.contract,
                    card.cont-code,
                    card.parent-cont-code
   ).
   IF CAN-FIND (FIRST tt-opcard) THEN
      tt-opcard.card_num = card.doc-num.

   /* Определение и сохранение в tt-card блокированной суммы */
   RUN CardBlockAmm (       card.doc-num,
                     OUTPUT mAmt
   ).
   ASSIGN
      tt-cardrep.block_amm = mAmt
      mAmt                 = 0
   .

   /* Опредление и сохранение tt-card платежного лимита */
   RUN CardCurrentLimit.

   RETURN.
END PROCEDURE.


/* Заполнение временной таблицы для операций по карте */
PROCEDURE BuildOpCard:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCodeL  AS CHAR   NO-UNDO.

   DEF VAR          vList       AS CHAR   NO-UNDO.
   DEF VAR          vAmtA       AS DEC    NO-UNDO.
   DEF VAR          vAmtC       AS DEC    NO-UNDO.
   DEF VAR          vAmtComm    AS DEC    NO-UNDO.
   DEF VAR vAcct AS CHAR NO-UNDO.
   /* Опредление списка статусов оперций */
   vList = FGetSettingEx ("КартВыписка",
                          "ВыпискаСтат",
                          "",
                          NO
                         ).

   FOR EACH pc-trans        WHERE
           (pc-trans.sur-card  EQ iContract + "," + iContCode
        AND pc-trans.proc-date GE mDateFrom
        AND pc-trans.proc-date LE mDateTo
        AND CAN-DO (vList, pc-trans.pctr-status)
           )
        OR
           (pc-trans.sur-card  EQ iContract + "," + iContCode
        AND pc-trans.proc-date EQ ?
        AND CAN-DO (vList, pc-trans.pctr-status)
           )
   NO-LOCK:
      RUN CardSummA    IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtA
      ).
 /*     RUN CardSummA   IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtC
      ). */
      RUN CardSummComm IN h_card (       pc-trans.pctr-id,
                                  OUTPUT vAmtComm
      ).
      FIND FIRST pc-trans-amt WHERE pc-trans-amt.pctr-id  EQ pc-trans.pctr-id
                              AND pc-trans-amt.amt-code EQ "СУМТ" no-lock no-error.

      CREATE tt-opcard.
      ASSIGN
         tt-opcard.date_op  = pc-trans.cont-date
         tt-opcard.date_val = IF pc-trans.proc-date NE ?
                              THEN pc-trans.proc-date
                              ELSE ?
         tt-opcard.details  = GetEntries(1, pc-trans.pctr-code, CHR(1) , "")
                            + " , "
                            + pc-trans.eq-country + " "
                            + pc-trans.eq-city    + " "
                            + pc-trans.eq-location
         tt-opcard.code_op  = pc-trans.auth-code
         tt-opcard.amm_op   = pc-trans-amt.amt-cur
         tt-opcard.val_op   = GetISOCode(pc-trans-amt.currency)
         tt-opcard.amm_acct = vAmtA
         tt-opcard.comm     = vAmtComm
         tt-opcard.total    = tt-opcard.amm_op + tt-opcard.comm
         vAmtA              = 0
         vAmtC              = 0
         vAmtComm           = 0
      .
   END.
/* заполнение по проводкам */
   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract    EQ "card-pers"
                    AND loan.cont-code   EQ iContCodeL
   NO-LOCK:
      RUN GetRoleAcct (       loan.contract + "," + loan.cont-code,
                              mDateTo,
                              "SCS",
                              loan.currency,
                       OUTPUT vAcct
      ).
    END.

   FOR EACH op-entry      WHERE
            op-entry.op-date GE mDateFrom
        AND op-entry.op-date LE mDateTo
        AND ( op-entry.acct-db eq vAcct or
        op-entry.acct-cr eq vAcct ) no-lock,
      FIRST op where op.op EQ op-entry.op 
   NO-LOCK:
   
/* message GetXattrValueEx("op", string(op.op), "CardStatus","") op-entry.amt-rub . pause. */
 if GetXattrValueEx("op", string(op.op), "CardStatus","") NE "НО"  and
    not can-do("Курс,Курс1,Нуль,Сальдо",op.op-kind) 
 then 
 DO:
      CREATE tt-opcard.
      ASSIGN
         tt-opcard.date_op  = op-entry.op-date
         tt-opcard.date_val = op-entry.op-date
         tt-opcard.details  = op.details
         tt-opcard.code_op  = ""
         tt-opcard.amm_op   = IF loan.currency eq "" then op-entry.amt-rub else op-entry.amt-cur
         tt-opcard.val_op   = GetISOCode(loan.currency)
         tt-opcard.amm_acct = IF loan.currency eq "" then op-entry.amt-rub else op-entry.amt-cur
         tt-opcard.comm     = 0
         tt-opcard.total    = IF loan.currency eq "" then op-entry.amt-rub else op-entry.amt-cur
      .
   END.
   END.

    
   RETURN.
END PROCEDURE.


/* Определение неснижаемого остатка. PIR*/
PROCEDURE CardMinOstPir:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.
/*
   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince,
                                 OUTPUT oAmt
   ).
*/

   DEF VAR vAcct AS CHAR NO-UNDO.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract    EQ iContract
                    AND loan.cont-code   EQ iContCode
   NO-LOCK:
      RUN GetRoleAcct (       loan.contract + "," + loan.cont-code,
                              iSince,
                              "SGP",
                              loan.currency,
                       OUTPUT vAcct
      ).
      IF vAcct NE ""
      THEN DO:
         RUN acct-pos IN h_base (vAcct,
                                 loan.currency,
                                 iSince,
                                 iSince,
                                 gop-status).
         oAmt = IF loan.currency EQ ""
                THEN ABS(sh-bal)
                ELSE ABS(sh-val).
      END.
   END.

   RETURN.
END PROCEDURE.

/* Определение остатка на начало периода */
PROCEDURE CardInitBal:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.
/*
   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince,
                                 OUTPUT oAmt
   ).
*/

   DEF VAR vAcct AS CHAR NO-UNDO.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract    EQ iContract
                    AND loan.cont-code   EQ iContCode
   NO-LOCK:
      RUN GetRoleAcct (       loan.contract + "," + loan.cont-code,
                              iSince,
                              "SCS",
                              loan.currency,
                       OUTPUT vAcct
      ).
      IF vAcct NE ""
      THEN DO:
         RUN acct-pos IN h_base (vAcct,
                                 loan.currency,
                                 iSince,
                                 iSince,
                                 gop-status).
         oAmt = IF loan.currency EQ ""
                THEN sh-in-bal
                ELSE sh-in-val.
      END.
   END.

   RETURN.
END PROCEDURE.


/* Печать выписки по одной карте */
PROCEDURE PrintCardRep:
   FOR EACH tt-cardrep:
      PUT STREAM fil UNFORMATTED FGetSettingEx ("КартВыписка",
                                                "ВыпискаВерхКол",
                                                "",
                                                NO
                                               ) SKIP(2).

      PUT STREAM fil UNFORMATTED FILL(" ", 50) + "Выписка (Report)" SKIP.
      PUT STREAM fil UNFORMATTED FILL(" ", 30) + "за период с (from) "
         + STRING(mDateFrom) + " по (to) " + STRING(mDateTo) SKIP(1).

      DO mCnt = 1 TO 17:
         RUN PutLine(RepTempl[mCnt], NO).
      END.

      /* Если нет операций печатаем сразу закрывающую линию */
      IF NOT CAN-FIND (FIRST tt-opcard) THEN
         RUN PutLine(RepTempl[21], NO).

      ELSE DO:
         RUN PutLine(RepTempl[18], NO).
         FOR EACH tt-opcard BREAK BY tt-opcard.card_num BY tt-opcard.date_op:

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

      DO mCnt = 22 TO 30:
         RUN PutLine(RepTempl[mCnt], NO).
      END.

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
   END.

   RETURN.
END PROCEDURE.


/* Определение оборота по приходу Pir */
PROCEDURE CardCreditTurnPir:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iDateFrom   AS DATE   NO-UNDO.
   DEF INPUT  PARAM iDateTo     AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   DEF VAR vAcct AS CHAR NO-UNDO.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract    EQ iContract
                    AND loan.cont-code   EQ iContCode
   NO-LOCK:
      RUN GetRoleAcct (       loan.contract + "," + loan.cont-code,
                              iDateTo,
                              "SCS",
                              loan.currency,
                       OUTPUT vAcct
      ).
      IF vAcct NE ""
      THEN DO:
         RUN acct-pos IN h_base (vAcct,
                                 loan.currency,
                                 iDateFrom,
                                 iDateTo,
                                 gop-status).
         oAmt = IF loan.currency EQ ""
                THEN sh-cr
                ELSE sh-vcr.
      END.
   END.

   RETURN.
END PROCEDURE.

/* Определение оборота по расходу Pir */
PROCEDURE CardDebitTurnPir:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iDateFrom   AS DATE   NO-UNDO.
   DEF INPUT  PARAM iDateTo     AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.

   DEF VAR vAcct AS CHAR NO-UNDO.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract    EQ iContract
                    AND loan.cont-code   EQ iContCode
   NO-LOCK:
      RUN GetRoleAcct (       loan.contract + "," + loan.cont-code,
                              iDateTo,
                              "SCS",
                              loan.currency,
                       OUTPUT vAcct
      ).
      IF vAcct NE ""
      THEN DO:
         RUN acct-pos IN h_base (vAcct,
                                 loan.currency,
                                 iDateFrom,
                                 iDateTo,
                                 gop-status).
         oAmt = IF loan.currency EQ ""
                THEN sh-db
                ELSE sh-vdb.
      END.
   END.

   RETURN.
END PROCEDURE.


/* Определение исходящего остатка */
PROCEDURE CardTotalBal:
   DEF INPUT  PARAM iContract   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iContCode   AS CHAR   NO-UNDO.
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO.

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO.
/*
   RUN CardBalanceTot IN h_card (       iContract,
                                        iContCode,
                                        iSince,
                                 OUTPUT oAmt
   ).
*/

   DEF VAR vAcct AS CHAR NO-UNDO.

   /* Определение договора карты */
   FOR FIRST loan WHERE loan.contract    EQ iContract
                    AND loan.cont-code   EQ iContCode
   NO-LOCK:
      RUN GetRoleAcct (       loan.contract + "," + loan.cont-code,
                              iSince,
                              "SCS",
                              loan.currency,
                       OUTPUT vAcct
      ).
   
      IF vAcct NE ""
      THEN DO:
         RUN acct-pos IN h_base (vAcct,
                                 loan.currency,
                                 iSince,
                                 iSince,
                                 gop-status).
         oAmt = IF loan.currency EQ ""
                THEN sh-bal
                ELSE sh-val.
      END.
   END.

   RETURN.
END PROCEDURE.


/* Определение задолженности по овердрафту */
PROCEDURE CardOverdraft:
   DEF INPUT  PARAM iPaContract AS CHAR   NO-UNDO. /* parent-contract         */
   DEF INPUT  PARAM iPaContCode AS CHAR   NO-UNDO. /* parent-cont-code        */
   DEF INPUT  PARAM iSince      AS DATE   NO-UNDO. /* Дата                    */

   DEF OUTPUT PARAM oAmt        AS DEC    NO-UNDO. /* sh-bal | sh-val         */

   DEF VAR          vAcct       AS CHAR   NO-UNDO.
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
                                 OUTPUT vAcct
      ).

      IF vAcct NE ""
      THEN DO:
         FOR EACH loan-acct WHERE loan-acct.acct      EQ vAcct
                              AND loan-acct.currency  EQ loan.currency
                              AND loan-acct.acct-type EQ "КредРасч"
                              AND loan-acct.since     LE iSince
         NO-LOCK,
         FIRST    bloan     OF loan-acct
         NO-LOCK:
            IF GetXattrValue ("loan",
                              bloan.contract + "," + bloan.cont-code,
                              "КартОвер"
                             ) EQ "Разреш"
            THEN DO:
               FIND FIRST term-obl WHERE term-obl.contract  EQ bloan.contract
                                     AND term-obl.cont-code EQ bloan.cont-code
                                     AND term-obl.fop-date  LE iSince
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


/* Определение блокированной суммы */
PROCEDURE CardBlockAmm:
   DEF INPUT  PARAM iDocNum AS CHAR   NO-UNDO.

   DEF OUTPUT PARAM oAmt    AS DEC    NO-UNDO.

   FOR EACH tt-opcard WHERE tt-opcard.card_num EQ iDocNum
                        AND tt-opcard.date_val EQ ?
   :
      oAmt = oAmt + tt-opcard.total.
   END.

   RETURN.
END PROCEDURE.


/* Опредление платежного лимита */
PROCEDURE CardCurrentLimit:
   DEF VAR vAmt1 AS DEC NO-UNDO.
   DEF VAR vAmt2 AS DEC NO-UNDO.
   DEF VAR vAmt3 AS DEC NO-UNDO.

   /* Карта основная? */
   IF card.loan-work THEN
      tt-cardrep.open_to_buy = tt-cardrep.total_bal
                             + tt-cardrep.ovefdraft
                             - tt-cardrep.block_amm.
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
                          cardO.cont-code
         ).

         /* Определение блокированной суммы */
         RUN CardBlockAmm (       cardO.doc-num,
                           OUTPUT vAmt1
         ).

         /* Определение задолженности по овердрафту */
         RUN CardOverdraft (       cardO.parent-contract,
                                   cardO.parent-cont-code,
                                   mDateTo,
                            OUTPUT vAmt2
         ).

         /* Определение остатка на начало периода */
         RUN CardInitBal (       cardO.contract,
                                 cardO.cont-code,
                                 mDateTo,
                          OUTPUT vAmt3
         ).

         tt-cardrep.open_to_buy = vAmt3 + vAmt2 - vAmt1.
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
                 + tt-opcard.val_op.

         WHEN "_Ввалютесчета"             THEN
            vVal = STRING(tt-opcard.amm_acct, mFormatDec) + " "
                 + GetISOCode(loan.currency).

         WHEN "_Комиссия"                 THEN
            vVal = STRING(tt-opcard.comm, mFormatDec).

         WHEN "_Итого"                    THEN
            vVal = STRING(tt-opcard.total, mFormatDec).

         WHEN "_неснижаемыйостаток"       THEN
            vVal = STRING(tt-cardrep.ins_depos, mFormatDec).

         WHEN "_остатокнаначалопериода"   THEN
            vVal = STRING(tt-cardrep.init_bal, mFormatDec).

         WHEN "_оборотпоприходузапериод"  THEN
            vVal = STRING(tt-cardrep.credit_turn, mFormatDec).

         WHEN "_оборотпорасходузапериод"  THEN
            vVal = STRING(tt-cardrep.debit_turn, mFormatDec).

         WHEN "_остатокнаконецпериода"    THEN
            vVal = STRING(tt-cardrep.total_bal, mFormatDec).

         WHEN "_Блокированнаясумма"       THEN
            vVal = STRING(tt-cardrep.block_amm, mFormatDec).

         WHEN "_Допустимыйперерасход"     THEN
            vVal = STRING(tt-cardrep.ovefdraft, mFormatDec).

         WHEN "_Текущийрасходныйлимит"    THEN
            vVal = STRING(tt-cardrep.open_to_buy, mFormatDec).

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

   PUT STREAM fil UNFORMATTED vStr SKIP.

   RETURN.
END PROCEDURE.

