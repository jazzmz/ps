/*-----------------------------------------------------------------------------
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: OP-IDENT.I
      Comment: Переменные/функции для определения реквизитов документа
         Uses:
      Used BY:
      Created: 03/05/2001 yakv FROM pp-uni.VAR, pp-uni.prg
     Modified: 08/06/2001 yakv - Добавлены комментарии
     Modified: 02/03/2004 NIK  - 1376-У
-------------------------------------------------------------------------------
Необходимо объявлять в вызывающем файле:
    h_base          globals.i
                    bank-id.i
-------------------------------------------------------------------------------
Перед вызовом функций необходимо установить курсоры на следующие таблицы:
    op, op-entry, op-bank, doc-type
-------------------------------------------------------------------------------
Перечень функций/процедур
    get-acct            - Обработка счетов проводки
    BankNameCity        -
    Identify-Acct       - Определение счета плательщика/получателя
    Identify-Client     - Определение клиента-плательщика/получателя
    Get-Xattr-Client    - Определение доп. реквизитов плательщика/получателя
    Identify-Banks      - Определение банка плательщика/получателя
    General-Bank        - Информация о головном банке или филиале (с БИКом)
    Our-Bank            - Информация о "нашем" банке, если он без БИКа
-----------------------------------------------------------------------------

     Modified: 04/02/2004 kraw (0024175) get_set_my -> FGetSetting
     Modified: 12/10/2009 kraw (0116269) вырезаем ИННиз op.name-ben по НП.
     Modified: 07/07/2010 kraw (0123723) Условная компилляция BankNameCity
     Modified: 17/08/2010 kraw (0132213) Код филиала из shFilial, а не из НП "КодФил"
     Modified: 07/12/2011 kraw (0159780) В acct-rec код филиала из op-entry

*/
{intrface.get cust}

&IF DEFINED( FILE_op_ident_i ) = 0 &THEN &GLOBAL-DEFINE FILE_op_ident_i

DEF TEMP-TABLE Info-Store NO-UNDO
    FIELD info-id       AS CHARACTER FORMAT "x(14)"  INITIAL ?
    FIELD inn           AS CHARACTER FORMAT "x(14)"  INITIAL ?
    FIELD flag          AS CHARACTER FORMAT "x(14)"  INITIAL ?
    FIELD code          AS CHARACTER FORMAT "x(14)"  INITIAL ?
    FIELD code-type     AS CHARACTER FORMAT "x(14)"  INITIAL ?
    FIELD acct          AS CHARACTER FORMAT "x(30)"  INITIAL ?
    FIELD corr-acct     AS CHARACTER FORMAT "x(30)"  INITIAL ?
    FIELD acct-type     AS CHARACTER FORMAT "x(10)"  INITIAL ?
    FIELD acct-cat      AS CHARACTER FORMAT "x(1)"   INITIAL ?
    FIELD bank-id       AS INTEGER                   INITIAL ?
    FIELD name          AS CHARACTER FORMAT "x(40)"  INITIAL ?
    FIELD Sh-name       AS CHARACTER FORMAT "x(40)"  INITIAL ?
    FIELD address       AS CHARACTER FORMAT "x(60)"  INITIAL ?
    FIELD corr-acct1    AS CHARACTER FORMAT "x(60)"  INITIAL ?
    FIELD flag-rkc      AS CHARACTER FORMAT "x(60)"  INITIAL ?
    FIELD flag-client   AS CHARACTER FORMAT "x(60)"  INITIAL ?
    FIELD flag-balchinn AS CHARACTER FORMAT "x(60)"  INITIAL ?
    FIELD category      AS CHARACTER FORMAT "x(60)"  INITIAL ?
.

&IF DEFINED(BankNameCity_) EQ 0 &THEN
&GLOBAL-DEFINE BankNameCity_ 2

FUNCTION BankNameCity RETURN CHAR (BUFFER b FOR banks):
  RETURN {banknm.lf b} + (IF {bankct.lf b} <> '' THEN ', ' ELSE '') + {bankct.lf b}.
END FUNCTION.
&ENDIF

/* Обработка Счетов проводки. in-type     = Дебет/Кредит
                              in-acct     = счет
                              in-currency = валюта */
PROCEDURE GET-ACCT:
   DEFINE INPUT PARAMETER db-cr    AS LOGICAL   NO-UNDO.
   DEFINE INPUT PARAMETER rec-open AS RECID     NO-UNDO.
   DEFINE PARAMETER BUFFER buf-acct FOR acct.

   DEFINE VAR tmp-str              AS CHARACTER NO-UNDO.
   DEFINE VAR in-acct              AS CHARACTER NO-UNDO.
   DEFINE VAR in-currency          AS CHARACTER NO-UNDO.

   &IF DEFINED (tt-op-entry) = 0 &THEN
      DEFINE BUFFER buf-open FOR op-entry .
   &ELSE
      DEFINE BUFFER buf-open FOR tt-op-entry  .
   &ENDIF

   IF db-cr THEN tmp-str = "acct-db".
            ELSE tmp-str = "acct-cr".
   FIND buf-open WHERE RECID(buf-open) EQ rec-open
                                  NO-LOCK NO-ERROR.
   FIND signs WHERE signs.file      EQ "op"
                AND signs.code      EQ tmp-str
                AND signs.surrogate EQ STRING(op.op)
                                    NO-LOCK NO-ERROR.
   IF AVAIL signs THEN
   in-acct = TRIM(signs.xattr-val).
   IF AVAIL buf-open THEN
   ASSIGN
      in-acct     = IF in-acct NE ? AND in-acct NE ""    THEN in-acct
                    ELSE IF AVAIL buf-open AND db-cr     THEN buf-open.acct-db
                    ELSE IF AVAIL buf-open AND NOT db-cr THEN buf-open.acct-cr
                    ELSE ?
      in-currency = IF AVAIL buf-open THEN buf-open.currency
                                      ELSE ?
   .
   IF (in-acct EQ ? OR in-acct EQ "") AND db-cr THEN DO:
      FIND FIRST buf-open WHERE buf-open.op = op.op AND
        buf-open.acct-db NE ? NO-LOCK NO-ERROR.
      ASSIGN
         in-acct     = IF AVAIL buf-open THEN buf-open.acct-db
                                         ELSE ?
         in-currency = IF AVAIL buf-open THEN buf-open.currency
                                         ELSE ?
      .
   END.
   ELSE IF (in-acct EQ ? OR in-acct EQ "") AND NOT db-cr THEN DO:
      FIND FIRST buf-open WHERE buf-open.op = op.op AND
        buf-open.acct-cr NE ? NO-LOCK NO-ERROR.
      ASSIGN
         in-acct     = IF AVAIL buf-open THEN buf-open.acct-cr
                                         ELSE ?
         in-currency = IF AVAIL buf-open THEN buf-open.currency
                                         ELSE ?
      .
   END.
   {find-act.i
      &bact     = buf-acct
      &acct     = in-acct
      &curr     = in-currency}
   &IF DEFINED (tt-op-entry) <> 0 &THEN
      IF NOT AVAIL buf-acct THEN DO:
         {find-act.i
            &bact = buf-acct
            &acct = in-acct}
      END.
   &ENDIF
END PROCEDURE.


PROCEDURE Identify-Acct:
DEFINE INPUT  PARAMETER in-type     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER in-acct     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER in-currency AS CHARACTER NO-UNDO.

DEFINE VAR tmp-sett  AS CHARACTER NO-UNDO.
DEFINE VAR tmp-sett1 AS CHARACTER NO-UNDO.
DEFINE VAR tmp-sett2 AS CHARACTER NO-UNDO.
DEFINE VAR tmp-sett3 AS CHARACTER NO-UNDO.

DEFINE VAR idnt-name AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VAR out-cat   AS CHARACTER NO-UNDO.
DEFINE VAR out-type  AS CHARACTER NO-UNDO.
DEFINE VAR out-str   AS CHARACTER NO-UNDO.
DEFINE VAR out-str1  AS CHARACTER NO-UNDO.
DEFINE VAR out-inn   AS CHARACTER INITIAL ? NO-UNDO.

DEFINE VAR bank-corr-acct   AS CHARACTER NO-UNDO.
DEFINE VAR flag-acct   AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR flag-client AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR flag-rkc AS CHARACTER INITIAL ? NO-UNDO.
DEFINE VAR BalAcctINN AS CHARACTER INITIAL ? NO-UNDO.
DEFINE BUFFER idnt-setting FOR setting.
DEFINE BUFFER idnt-acct    FOR acct.
DEF BUFFER inn-banks-code FOR banks-code.

RELEASE banks.
RELEASE banks-code.
   tmp-sett  = FGetSetting("НазнСчМБР",?,?).
   tmp-sett1 = FGetSetting("БалСчИННПл",?,?).
   tmp-sett2 = FGetSetting("НазнСчБ-К",?,?).
   tmp-sett3 = FGetSetting("КорСч",?,?).

   IF in-type EQ "ДЕБЕТ"
      THEN RUN GET-ACCT(YES,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
      ELSE IF in-type EQ "КРЕДИТ"
           THEN RUN GET-ACCT(NO,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).

   IF NOT AVAIL idnt-acct THEN RETURN.
   in-acct = idnt-acct.acct.
   IF CAN-DO(tmp-sett1,STRING(idnt-acct.bal-acct)) THEN DO:
      BalAcctINN = "БалСчИННПл".
   END.
   IF CAN-DO(tmp-sett2,idnt-acct.contract) AND tmp-sett2 NE "" AND tmp-sett2 NE ? THEN DO:
      flag-client = "БанкКлиент".
   END.

   out-cat = idnt-acct.cust-cat.
   IF CAN-DO(tmp-sett,idnt-acct.contract) AND tmp-sett NE "" AND tmp-sett NE ? THEN DO:
      /* Межбанк или Филиал */
      IF idnt-acct.cust-cat EQ "Б" THEN DO:
         FIND banks WHERE banks.bank-id EQ idnt-acct.cust-id NO-LOCK NO-ERROR.
         FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                             NO-LOCK NO-ERROR.
         IF AVAIL banks AND CAN-FIND(branch WHERE branch.bank-id EQ banks.bank-id) THEN
            out-type = "Филиал".
         ELSE
            out-type = "МежБанк".
      END.
      ELSE DO:
         out-type = "МежБанк".
      END.
   END.
   IF out-type EQ "Филиал" OR out-type EQ "МежБанк" THEN DO:
      IF idnt-acct.cust-cat EQ "Б" THEN DO:
         FIND banks WHERE banks.bank-id EQ idnt-acct.cust-id NO-LOCK NO-ERROR.
         FIND branch WHERE branch.bank-id EQ banks.bank-id NO-LOCK NO-ERROR.
         FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                             NO-LOCK NO-ERROR.
         IF AVAIL branch AND NOT AVAIL banks-code THEN flag-acct = "МежФилиалБезБИК".
      END.
   END.
   IF idnt-acct.cust-cat EQ "В" THEN DO:
      FIND c-nostro OF idnt-acct NO-LOCK NO-ERROR.
      IF AVAIL c-nostro THEN DO:
         RELEASE banks.
         RELEASE banks-code.
         &IF DEFINED(MORDER) = 0 &THEN
            FIND banks-code WHERE banks-code.bank-code-type EQ c-nostro.code-nmfor
                              AND banks-code.bank-code      EQ c-nostro.nmfor NO-LOCK NO-ERROR.
            IF NOT AVAIL banks-code THEN
            FIND banks-code WHERE banks-code.bank-code-type EQ "МФО-9"
                              AND banks-code.bank-code      EQ c-nostro.nmfor NO-LOCK NO-ERROR.
         &ENDIF
         IF NOT AVAIL banks-code THEN DO:
            out-cat = "В".
            {getcust.i &name=idnt-name &pref="idnt-" &OFFInn = "/*"}
            idnt-name[1] = idnt-name[1] + " " + idnt-name[2].
            out-str = idnt-name[1].
         END.
         ELSE DO:
            FIND banks OF banks-code NO-LOCK NO-ERROR.
            IF AVAIL banks THEN DO:
               FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                                  NO-LOCK NO-ERROR.
               IF NOT banks.flag-rkc THEN
               FIND FIRST banks-corr WHERE banks-corr.bank-corr EQ banks.bank-id
                                       AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc)
                                                                              NO-LOCK NO-ERROR.
               out-inn = GetBankInn ("bank-id", STRING (banks.bank-id)).
               IF NOT {assigned out-inn} THEN
                  out-inn = ?.
               out-str  = {banknm.lf banks}.
               out-str1 = {banknm.lf banks} + (IF {bankct.lf banks} <> '' THEN ', ' ELSE '') + {bankct.lf banks}.
               out-cat = "Б".
            END.
         END.
      END.
      ELSE DO:
         out-cat = "В".
         {getcust.i &name=idnt-name &pref="idnt-" &OFFInn = "/*"}
         idnt-name[1] = idnt-name[1] + " " + idnt-name[2].
         out-str = idnt-name[1].

      END.
   END.
   ELSE IF idnt-acct.cust-cat EQ "Б" THEN DO:
      FIND banks WHERE banks.bank-id EQ idnt-acct.cust-id NO-LOCK NO-ERROR.
      FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                          NO-LOCK NO-ERROR.
      IF AVAIL banks AND NOT banks.flag-rkc THEN
      FIND FIRST banks-corr WHERE banks-corr.bank-corr EQ banks.bank-id
                              AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc)
                                                                     NO-LOCK NO-ERROR.

      IF AVAIL banks THEN DO:
         out-inn = GetBankInn ("bank-id", STRING (banks.bank-id)).
         IF NOT {assigned out-inn} THEN
            out-inn = ?.
         &IF DEFINED(MORDER) = 0 &THEN
            out-str  = {banknm.lf banks}.
            out-str1 = {banknm.lf banks} + (IF {bankct.lf banks} <> '' THEN ', ' ELSE '') + {bankct.lf banks}.
         &ELSE
         IF NOT {assigned idnt-acct.details} THEN DO:
            out-str  = {banknm.lf banks}.
            out-str1 = {banknm.lf banks} + (IF {bankct.lf banks} <> '' THEN ', ' ELSE '') + {bankct.lf banks}.
         END.
         ELSE
            out-str = idnt-acct.details.
         &ENDIF
      END.
   END.
   ELSE IF idnt-acct.cust-cat EQ "Ю" OR idnt-acct.cust-cat EQ "Ч" THEN DO:
      {getcust.i &name=idnt-name &OFFInn=YES &inn=out-inn &pref="idnt-" }
      idnt-name[1] = idnt-name[1] + " " + idnt-name[2].
      &if DEFINED (SAMECUSTNAME) EQ 0 &THEN 
      IF  in-type            = "ДЕБЕТ"
      AND idnt-acct.cust-cat = "Ю"
      THEN DO:
         idnt-name[2] = "".
         RUN GetCustNameFormattedByAcct IN h_cust (BUFFER idnt-acct,
                                                   &IF DEFINED(OFFsigns) &THEN
                                                   NO
                                                   &ELSE
                                                   YES
                                                   &ENDIF
                                                   ,
                                                   OUTPUT idnt-name[1]).
      END.
      &ENDIF
      out-str = idnt-name[1].
   END.
   IF flag-client EQ "БанкКлиент" THEN DO:
      FIND c-nostro OF idnt-acct NO-LOCK NO-ERROR.
      IF AVAIL c-nostro THEN
         bank-corr-acct = c-nostro.corr-acct.
      ELSE
         bank-corr-acct = "".
   END.
   ELSE bank-corr-acct = "".
   IF (AVAIL banks AND banks.flag-rkc) OR
      (bank-corr-acct NE "" AND bank-corr-acct EQ tmp-sett3) THEN
   flag-rkc = "РКЦ".
   CREATE Info-Store.
   ASSIGN
      Info-Store.inn         = out-inn
      Info-Store.info-id     = in-type
      Info-Store.flag        = flag-acct
      Info-Store.flag-client = flag-client
      Info-Store.flag-rkc    = flag-rkc
      Info-Store.acct        = in-acct
      Info-Store.category    = idnt-acct.acct-cat
      Info-Store.acct-cat    = out-cat
      Info-Store.acct-type   = out-type
      Info-Store.bank-id     = IF AVAIL banks THEN banks.bank-id
                                              ELSE ?
      Info-Store.code        = IF AVAIL banks-code THEN banks-code.bank-code
                                                   ELSE ?
      Info-Store.code-type   = IF AVAIL banks-code THEN banks-code.bank-code-type
                                                   ELSE ?
      Info-Store.name        = out-str
      Info-Store.Sh-Name     = out-str1
      Info-Store.flag-balchinn = BalAcctINN
      Info-Store.corr-acct   = IF AVAIL banks-corr AND flag-rkc NE "РКЦ" THEN banks-corr.corr-acct
                                                                         ELSE ""
      Info-Store.corr-acct1  = bank-corr-acct
   .
END PROCEDURE.

/* Определение плательщика и получателя in-type = REC/SEND */
PROCEDURE Identify-Client:
   DEFINE INPUT  PARAMETER in-type  AS CHARACTER NO-UNDO.
   DEFINE VAR out-inn  AS CHARACTER INITIAL "" NO-UNDO.
   DEFINE VAR out-acct AS CHARACTER INITIAL "" NO-UNDO.
   DEFINE VAR out-name AS CHARACTER INITIAL "" NO-UNDO.
   DEFINE VAR tmp-type AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-val  AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-sett AS CHARACTER NO-UNDO.
   DEFINE VAR flag-xattr AS LOGICAL NO-UNDO.
   DEFINE VAR type-str   AS CHARACTER NO-UNDO.
   DEFINE BUFFER idnt-setting FOR setting.
   DEFINE BUFFER idnt-acct    FOR acct.

   DEFINE VARIABLE vItem  AS INT64 NO-UNDO.

   DEFINE VARIABLE vFil   AS CHARACTER NO-UNDO.

   type-str = IF in-type EQ "SEND" THEN "REC"
                                   ELSE "SEND".
   flag-xattr = NO.
   RUN Get-Xattr-Client(INPUT  type-str ,
                        INPUT  "INN"   ,
                        OUTPUT tmp-val).
   IF tmp-val NE ?  THEN
   ASSIGN
      flag-xattr = YES.

   RUN Get-Xattr-Client(INPUT  type-str ,
                        INPUT  "ACCT"   ,
                        OUTPUT tmp-val).
   IF tmp-val NE ? THEN
   ASSIGN
      flag-xattr = YES.

   RUN Get-Xattr-Client(INPUT  type-str ,
                        INPUT  "NAME"   ,
                        OUTPUT tmp-val).
   IF tmp-val NE ?  THEN
   ASSIGN
      flag-xattr = YES.



   IF op.doc-kind EQ "" OR op.doc-kind EQ ? THEN DO:
      IF flag-xattr THEN tmp-type = in-type.
      ELSE DO:
         FIND FIRST idnt-setting WHERE idnt-setting.Code = "НазнСчМБР" NO-LOCK NO-ERROR.
         tmp-sett = IF AVAIL idnt-setting THEN idnt-setting.val
                                    ELSE "".
         RUN GET-ACCT(YES,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
         IF NOT AVAIL idnt-acct THEN RETURN.
         IF CAN-DO(tmp-sett,idnt-acct.contract) THEN tmp-type = "SEND".
         RUN GET-ACCT(NO,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
         IF NOT AVAIL idnt-acct THEN RETURN.
         IF CAN-DO(tmp-sett,idnt-acct.contract) THEN tmp-type = "REC".
         IF tmp-type EQ "" OR tmp-type EQ ? THEN DO:
            tmp-type = "REC".
         END.
      END.
   END.
   ELSE tmp-type = op.doc-kind.
   IF tmp-type = in-type THEN
   DO:
      ASSIGN
         out-inn  = op.inn
         out-acct = op.ben-acct
         out-name = op.name-ben
      .

      IF FGetSetting("ИсклИНН","","Да") EQ "Да" AND out-name BEGINS "ИНН " THEN
      DO:
         vItem = 4.

         DO WHILE LOOKUP(SUBSTRING(out-name, vItem, 1)," ,0,1,2,3,4,5,6,7,8,9") GT 0 :
            vItem = vItem + 1.
         END.

         out-name = SUBSTRING(out-name, vItem).
      END.

   END.
   flag-xattr = NO.
   RUN Get-Xattr-Client(INPUT  in-type ,
                        INPUT  "INN"   ,
                        OUTPUT tmp-val).
   IF tmp-val NE ?  THEN
   ASSIGN
      flag-xattr = YES.

   RUN Get-Xattr-Client(INPUT  in-type ,
                        INPUT  "ACCT"   ,
                        OUTPUT tmp-val).
   IF tmp-val NE ? THEN
   ASSIGN
      flag-xattr = YES.

   RUN Get-Xattr-Client(INPUT  in-type ,
                        INPUT  "NAME"   ,
                        OUTPUT tmp-val).
   IF tmp-val NE ? THEN
   ASSIGN
      flag-xattr = YES.
   IF flag-xattr THEN DO:
      RUN Get-Xattr-Client(INPUT  in-type ,
                           INPUT  "INN"   ,
                           OUTPUT tmp-val).
      out-inn = tmp-val.
      RUN Get-Xattr-Client(INPUT  in-type ,
                           INPUT  "ACCT"   ,
                           OUTPUT tmp-val).

      IF ShMode AND NUM-ENTRIES(tmp-val, "@") EQ 1 THEN
      DO:
&IF DEFINED(tt-op-entry) EQ 0 &THEN
         vFil = ENTRY(2, op-entry.acct-cr, "@").
&ELSE
         vFil = ENTRY(2, tt-op-entry.acct-cr, "@").
&ENDIF
         tmp-val = addFilToAcct(tmp-val, vFil).
      END.

      out-acct = tmp-val.
      RUN Get-Xattr-Client(INPUT  in-type ,
                           INPUT  "NAME"   ,
                           OUTPUT tmp-val).
      out-name = tmp-val.
   END.
   IF out-inn  = ? THEN out-inn  = "".
   IF out-acct = ? THEN out-acct = "".
   IF out-name = ? THEN out-name = "".
   IF NOT (out-inn = "" AND out-acct = "" AND out-name = "") THEN DO:
      CREATE Info-Store.
      ASSIGN
         Info-Store.info-id    = IF in-type EQ "SEND" THEN "Плательщик"
                                                      ELSE "Получатель"
         Info-Store.inn     = out-inn
         Info-Store.acct    = out-acct
         Info-Store.name    = out-name
         Info-Store.flag    = IF flag-xattr THEN "ДопРекв"
                                            ELSE "ОснРекв"
      .
   END.
END PROCEDURE.

/* Берет дополнительные реквизиты плательщика и получателя
   in-type = REC/SEND
   in-code = acct/inn/name
   Код доп. реквизита = in-code + "-" + in-type */
PROCEDURE Get-Xattr-Client:
DEFINE INPUT  PARAMETER in-type AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER in-code AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER in-val  AS CHARACTER NO-UNDO.
FIND signs WHERE signs.file EQ "op"
             AND signs.code EQ (in-code + "-" + in-type)
             AND signs.surr EQ STRING(op.op)
                               NO-LOCK NO-ERROR.
IF AVAIL signs THEN in-val = signs.xattr-val.
               ELSE in-val = ?.
END PROCEDURE.

/* Процедура для определения банка плательщика или получатель */

PROCEDURE Identify-Banks:
   DEFINE INPUT PARAMETER in-type AS CHARACTER NO-UNDO.
   DEFINE VAR bnk-recid           AS RECID     NO-UNDO.
   DEFINE VAR tmp-type            AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-sett            AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-corr-acct       AS CHARACTER INITIAL ? NO-UNDO.
   DEFINE VAR tmp-bank-code       AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vInn AS CHARACTER   NO-UNDO.

   DEFINE BUFFER idnt-setting FOR setting.
   DEFINE BUFFER idnt-op-bank FOR op-bank.
   DEFINE BUFFER idnt-acct    FOR acct.
   DEFINE BUFFER buf-store    FOR Info-Store.
   tmp-type = IF in-type EQ "REC" THEN "SEND"
                                  ELSE "REC".
   IF in-type EQ "REC" THEN
      FIND buf-store   WHERE buf-store.info-id     EQ "Плательщик"
                         AND buf-store.flag        EQ "ДопРекв" NO-LOCK NO-ERROR.
   ELSE
      FIND buf-store   WHERE buf-store.info-id     EQ "ПОЛУЧАТЕЛЬ"
                         AND buf-store.flag        EQ "ДопРекв" NO-LOCK NO-ERROR.
   RELEASE banks.
   RELEASE banks-corr.
   FIND idnt-op-bank OF op WHERE idnt-op-bank.op-bank-type EQ in-type
                             AND NOT CAN-FIND(Info-Store WHERE Info-Store.Info-id BEGINS "БАНК"
                                                           AND Info-Store.flag    EQ STRING(RECID(idnt-op-bank)) ) NO-LOCK NO-ERROR.
   IF AVAIL idnt-op-bank THEN DO:
      /*банк соответствует вход роли */
      bnk-recid = RECID(idnt-op-bank).
   END.
   ELSE DO:
      /*FIND idnt-op-bank OF op WHERE idnt-op-bank.op-bank-type EQ ""      NO-LOCK NO-ERROR.*/
      FIND idnt-op-bank OF op WHERE idnt-op-bank.op-bank-type EQ ""
                                AND NOT CAN-FIND(Info-Store WHERE Info-Store.Info-id BEGINS "БАНК"
                                                              AND Info-Store.flag    EQ STRING(RECID(idnt-op-bank)) ) NO-LOCK NO-ERROR.

      IF AVAIL idnt-op-bank AND op.doc-kind EQ in-type THEN DO:
         /*банк соответствует вход роли */
         bnk-recid = RECID(idnt-op-bank).
      END.
      ELSE IF AVAIL idnt-op-bank AND (op.doc-kind EQ ? OR op.doc-kind EQ "") AND AVAIL buf-store THEN DO:                
         bnk-recid = RECID(idnt-op-bank).
      END.
      ELSE IF AVAIL idnt-op-bank AND CAN-FIND(idnt-op-bank OF op WHERE idnt-op-bank.op-bank-type EQ tmp-type) THEN DO:
         /*банк соответствует вход роли */
         bnk-recid = RECID(idnt-op-bank).
      END.
      ELSE IF AVAIL idnt-op-bank AND (op.doc-kind EQ ? OR op.doc-kind EQ "") THEN DO:
         FIND FIRST idnt-setting WHERE idnt-setting.Code = "НазнСчМБР" NO-LOCK NO-ERROR.
         tmp-sett = IF AVAIL idnt-setting THEN idnt-setting.val
                                    ELSE "".
         &IF DEFINED(tt-op-entry) = 0 &THEN 
         IF NOT AVAIL(op-entry) THEN RETURN.
         &ENDIF
         RUN GET-ACCT(NO,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
         IF NOT AVAIL idnt-acct THEN RETURN.
         IF CAN-DO(tmp-sett,idnt-acct.contract) AND in-type EQ "REC" THEN DO:
            /*банк соответствует вход роли */
            bnk-recid = RECID(idnt-op-bank).
         END.
         ELSE IF NOT CAN-DO(tmp-sett,idnt-acct.contract) THEN DO:
            RUN GET-ACCT(YES,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
            IF NOT AVAIL idnt-acct THEN RETURN.
            IF CAN-DO(tmp-sett,idnt-acct.contract) AND in-type EQ "SEND" THEN DO:
               /*банк соответствует вход роли */
               bnk-recid = RECID(idnt-op-bank).
            END.
         END.
         IF in-type EQ "REC" AND bnk-recid = ? AND
            NOT CAN-FIND(FIRST Info-Store WHERE Info-Store.Info-Id EQ "БАНКПЛ") THEN DO:
            /*банк соответствует вход роли */
            bnk-recid = RECID(idnt-op-bank).
         END.
      END.
   END.
   IF bnk-recid NE ? THEN DO:
      FIND idnt-op-bank WHERE RECID(idnt-op-bank) EQ bnk-recid NO-LOCK NO-ERROR.
      IF AVAIL idnt-op-bank THEN DO:
         tmp-bank-code = (IF LENGTH(idnt-op-bank.bank-code) LE 9 THEN FILL("0",9 - LENGTH(idnt-op-bank.bank-code))
                                                                 ELSE "") +
                         idnt-op-bank.bank-code.

         IF idnt-op-bank.bank-code-type NE "" AND idnt-op-bank.bank-code-type NE ? THEN DO:
            IF idnt-op-bank.bank-code-type EQ "МФО-9" THEN
            FIND banks-code WHERE banks-code.bank-code-type EQ idnt-op-bank.bank-code-type
                              AND banks-code.bank-code      EQ tmp-bank-code
                                                                          NO-LOCK NO-ERROR.
            ELSE
            FIND banks-code WHERE banks-code.bank-code-type EQ idnt-op-bank.bank-code-type
                              AND banks-code.bank-code      EQ idnt-op-bank.bank-code
                                                                          NO-LOCK NO-ERROR.
         END.
         ELSE DO:
            FIND banks-code WHERE banks-code.bank-code-type EQ "МФО-9"
                              AND banks-code.bank-code      EQ tmp-bank-code
                                                                          NO-LOCK NO-ERROR.

            IF NOT AVAIL banks-code THEN
            FIND banks-code WHERE banks-code.bank-code-type EQ "BIC"
                              AND banks-code.bank-code      EQ idnt-op-bank.bank-code
                                                                          NO-LOCK NO-ERROR.

         END.
         IF AVAIL banks-code THEN DO:
            IF AVAIL banks-code AND banks-code.bank-code-type NE "МФО-9" THEN
            tmp-corr-acct = idnt-op-bank.corr-acct.
            FIND banks OF banks-code NO-LOCK NO-ERROR.
            IF AVAIL banks THEN
            FIND FIRST banks-corr WHERE banks-corr.bank-corr EQ banks.bank-id
                                    AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc)
                                                                      NO-LOCK NO-ERROR.

            IF AVAIL banks AND banks-code.bank-code-type NE "МФО-9" THEN
            FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                               NO-LOCK NO-ERROR.

         END.
      END.
      IF NOT AVAIL banks AND (idnt-op-bank.bank-code EQ ? OR idnt-op-bank.bank-code EQ "") THEN DO:
         &IF DEFINED(tt-op-entry) = 0 &THEN 
         IF AVAIL(op-entry) THEN 
         &ENDIF
         IF (in-type EQ "SEND" AND idnt-op-bank.corr-acct EQ &IF DEFINED(tt-op-entry) = 0 &THEN op-entry.acct-db &ELSE tt-op-entry.acct-db &ENDIF )
         OR (in-type EQ "REC"  AND idnt-op-bank.corr-acct EQ &IF DEFINED(tt-op-entry) = 0 &THEN op-entry.acct-cr &ELSE tt-op-entry.acct-cr &ENDIF ) THEN DO:
            IF in-type EQ "SEND" THEN /*GET-ACCT*/
            RUN GET-ACCT(YES,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
            ELSE /*GET-ACCT*/
            RUN GET-ACCT(NO,&IF DEFINED(tt-op-entry) = 0 &THEN RECID(op-entry) &ELSE RECID(tt-op-entry) &ENDIF,BUFFER idnt-acct).
            IF AVAIL idnt-acct THEN DO:
               IF idnt-acct.cust-cat EQ "Б" THEN DO:
                  FIND banks WHERE banks.bank-id EQ idnt-acct.cust-id NO-LOCK NO-ERROR.
                  IF AVAIL banks THEN DO:
                     FIND FIRST banks-corr WHERE banks-corr.bank-corr EQ banks.bank-id
                                             AND CAN-FIND (banks OF banks-corr WHERE banks.flag-rkc)
                                                                                  NO-LOCK NO-ERROR.
                     FIND banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9"
                                                                        NO-LOCK NO-ERROR.
                  END.
               END.
            END.
         END.
      END.
      IF AVAIL banks THEN DO:
         vInn = GetBankInn ("bank-id", STRING (banks.bank-id)).
      END.
      CREATE Info-Store.
      ASSIGN
         Info-Store.info-id = "БАНК" + IF in-type EQ "SEND" THEN "ПЛ"
                                                            ELSE "ПОЛ"
         Info-Store.bank-id = IF AVAIL banks THEN banks.bank-id
                                             ELSE ?
         Info-Store.inn     = IF {assigned vInn} THEN vInn
                                                 ELSE ?
         Info-Store.code    = IF AVAIL banks-code THEN banks-code.bank-code
                                                  ELSE idnt-op-bank.bank-code
         Info-Store.name    = IF idnt-op-bank.bank-name EQ "" OR idnt-op-bank.bank-name EQ ? THEN
                                 IF AVAIL banks THEN BankNameCity(BUFFER Banks)
                                                ELSE " "
                              ELSE idnt-op-bank.bank-name
		/* по заявке #1388 */
         Info-Store.acct    =  /* IF AVAIL banks-corr THEN banks-corr.corr-acct
                                  ELSE */   idnt-op-bank.corr-acct
         Info-Store.corr-acct = IF TRIM(tmp-corr-acct) EQ "" THEN ?
                                                             ELSE TRIM(tmp-corr-acct)
         Info-Store.flag      = STRING(RECID(idnt-op-bank))
         Info-Store.code-type =   if AVAIL banks-code THEN banks-code.bank-code-type
         else idnt-op-bank.bank-code-type
      .
   END.
END PROCEDURE.

/* Процедура , которая достает информацию о головном банке или филиале (с БИКом) */

PROCEDURE General-Bank:
   DEFINE VAR tmp-bank-name  AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-bank-name1 AS CHARACTER NO-UNDO.
   DEFINE VAR find-filial    AS LOGICAL   NO-UNDO.

   DEFINE VAR param-bank-inn       AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-mfo       AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-name      AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-town      AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-acct      AS CHARACTER NO-UNDO.
   DEFINE BUFFER idnt-setting FOR setting.
{get-bankname.i}

   find-filial = CAN-FIND(Info-Store WHERE Info-Store.Info-Id EQ "БАНКФИЛ").
   IF NOT find-filial THEN DO:
      param-bank-inn  = FGetSetting("ИНН",?,?).
      param-bank-mfo  = FGetSetting("БанкМФО",?,?).
/*      param-bank-name = FGetSetting("БанкС",?,?).*/
      param-bank-name = cBankNameS.
      param-bank-town = FGetSetting("БанкГород",?,?).
      param-bank-acct = FGetSetting("КорСч",?,?).
   END.
   ELSE
      ASSIGN
         param-bank-inn  = ""
         param-bank-mfo  = ""
         param-bank-name = ""
         param-bank-town = ""
         param-bank-acct = ""
      .

   {getbank.i banks bank-mfo-9 "'МФО-9'"}
   tmp-bank-name1 = IF AVAIL banks THEN {banknm.lf banks} ELSE "".
   tmp-bank-name  = IF AVAIL banks THEN BankNameCity(BUFFER Banks) ELSE "".
   CREATE Info-Store.
   ASSIGN
      Info-Store.info-id = "БАНКГО"
      Info-Store.bank-id = IF AVAIL banks THEN banks.bank-id
                                          ELSE ?
      Info-Store.inn     = bank-inn
      Info-Store.code    = bank-mfo-9
      Info-Store.name    = IF param-bank-name EQ "" THEN tmp-bank-name
                                                    ELSE (param-bank-name +
                                                          ", " + param-bank-town)
      Info-Store.Sh-name = IF param-bank-name EQ "" THEN tmp-bank-name1
                                                    ELSE param-bank-name
      Info-Store.acct    = bank-acct
   .
/*   CREATE Info-Store.
   ASSIGN
      Info-Store.info-id = "БАНКГО"
      Info-Store.bank-id = IF AVAIL banks THEN banks.bank-id
                                          ELSE ?
      Info-Store.inn     = param-bank-inn
      Info-Store.code    = param-bank-mfo
      Info-Store.name    = param-bank-name + ", " + param-bank-town
      Info-Store.Sh-name = param-bank-name
      Info-Store.acct    = bank-acct
   .*/
END PROCEDURE.

/* Процедура, которая достает информацию о нашем банке, если он без БИКа */
PROCEDURE Our-Bank:
   DEFINE VAR param-bank-inn       AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-mfo       AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-name      AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-town      AS CHARACTER NO-UNDO.
   DEFINE VAR param-bank-acct      AS CHARACTER NO-UNDO.

   DEFINE VAR tmp-bank-name  AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-bank-name1 AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-cod-fil    AS CHARACTER NO-UNDO.

   DEFINE BUFFER idnt-setting FOR setting.
   RELEASE banks.

   tmp-cod-fil = shFilial.

   IF tmp-cod-fil EQ "" THEN RETURN.
   FIND branch WHERE branch.branch-id EQ tmp-cod-fil NO-LOCK NO-ERROR.
   IF AVAIL branch THEN DO:
      IF branch.bank-id NE ? THEN
      FIND banks WHERE banks.bank-id EQ branch.bank-id NO-LOCK NO-ERROR.
      IF AVAIL banks AND CAN-FIND(FIRST banks-code OF banks WHERE banks-code.bank-code-type EQ "МФО-9") THEN RETURN.
      IF AVAIL banks THEN DO:
         tmp-bank-name  = IF AVAIL banks THEN BankNameCity(BUFFER Banks) ELSE "".
         tmp-bank-name1 = IF AVAIL banks THEN {banknm.lf banks} ELSE "".
      END.
      ELSE DO:
         tmp-bank-name  =  branch.name + " " + branch.address.
         tmp-bank-name1 =  branch.name.
      END.
   END.

   param-bank-inn  = FGetSetting("ИНН",?,?).
   param-bank-acct = FGetSetting("КорСч",?,?).

   CREATE Info-Store.
   ASSIGN
      Info-Store.info-id = "БАНКФИЛ"
      Info-Store.code    = tmp-cod-fil
      Info-Store.inn     = param-bank-inn
      Info-Store.name    = tmp-bank-name
      Info-Store.acct    = param-bank-acct
      Info-Store.Sh-name = tmp-bank-name1
   .
END PROCEDURE.

&ENDIF
