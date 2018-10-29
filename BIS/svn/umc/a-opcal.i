/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: A-OPCAL.I
      Comment: Основной инклуд для транзакций УМЦ
   Parameters:
         Uses:
      Used by:
      Created:
     Modified: 24.10.2003 fedm
     Modified: 23.01.2006 gorm (54244) Убрана ошибка, возникавшая, когда счет стоит 
                                       на субаналитике, но не на УМЦ
*/

{g-assacc.def &currency="wop.currency"}

ON "F1" OF wop.acct-db, wop.acct-cr IN FRAME edtempl
DO:
   RUN acct.p (wop.acct-cat, 4).

   IF pick-value <> ? AND
      (LASTKEY = 10 OR LASTKEY = 13) THEN
      SELF:SCREEN-VALUE = ENTRY(1, pick-value).
END.

ON "LEAVE" OF wop.acct-db,wop.acct-cr IN FRAME edtempl
DO:
   DEF VAR tt-acct AS CHAR NO-UNDO.

   DO WITH FRAME edtempl:
      tt-acct = AddFilToAcct(SELF:SCREEN-VALUE,shFilial).

      RUN AssumeAcct(INPUT-OUTPUT tt-acct).

      IF tt-acct <> ? THEN
      DO:
         tt-acct = ENTRY(1, tt-acct).
         IF AddFilToAcct(SELF:SCREEN-VALUE,shFilial) <> tt-acct THEN
         DO:
            SELF:SCREEN-VALUE = tt-acct.
            RETURN NO-APPLY.
         END.
      END.
      ELSE
      DO:
         MESSAGE
            "Нет такого счета или у Вас недостаточно прав!"
         VIEW-AS ALERT-BOX ERROR.

         RETURN NO-APPLY.
      END.

   END.
END.

/* Код шаблона КАУ? */
DEF VAR vKau-Id      AS CHAR    NO-UNDO INITIAL ?.

{empty wop}

CLEAR FRAME edtempl ALL NO-PAUSE.

mOpClassList = Ls-Class("op").

FOR EACH op-templ OF op-kind WHERE
   CAN-DO(mOpClassList, op-templ.cr-class-code)
   NO-LOCK
   WITH FRAME edtempl
   ON ERROR  UNDO gen, LEAVE gen
   ON ENDKEY UNDO gen, RETRY gen:

   /*-----------------------------------------------------------*/

   ASSIGN
      tacct-db = ?
      tacct-cr = ?
      tcur-db  = ""
      tcur-cr  = ""
      res1     = 0
      res2     = 0
      res3     = 0
      res4     = 0
      res1nal  = 0
      res2nal  = 0
      res3nal  = 0
      res4nal  = 0.

   CREATE wop.

   ASSIGN
      wop.currency = GetCurr(op-templ.currency)
      wop.op-kind  = op-kind.op-kind
      wop.op-templ = op-templ.op-templ.

   IF wop.currency = ? THEN
   DO:
      MESSAGE
         "Не определена валюта в шаблоне проводки N"
         STRING(op-templ.op-templ) "!"
      VIEW-AS ALERT-BOX ERROR.

      UNDO gen, LEAVE gen.
   END.

   {g-acctv1.i
      &OFbase   = YES
      &OFsrch   = YES
      &BYrole   = YES
      &vacct    = tacct
   }

   {asswop.i}

   IF op-templ.op-templ = 1 THEN
   DO:
   &IF DEFINED(acctdb) &THEN
      wop.acct-db = {&acctdb}.
   &ENDIF
   &IF DEFINED(acctcr) &THEN
      wop.acct-db = {&acctcr}.
   &ENDIF
   END.

   &IF DEFINED(prepf) &THEN
      wop.prepf = (IF NUM-ENTRIES({&prepf}) >= op-templ.op-templ
                   THEN ENTRY(op-templ.op-templ, {&prepf})
                   ELSE wop.prepf
                  ).
   &ENDIF

   &IF DEFINED(qty) &THEN
      /* По-умолчанию для шаблона №1 учитываем количество,
      ** для остальных шаблонов не учитываем.
      */
      IF GetXAttrValueEx("op-template",
                         op-templ.op-kind + "," + STRING(op-templ.op-templ),
                         "QtyNeed",
                         (IF op-templ.op-templ = 1 THEN "Да" ELSE "Нет")
                        ) = "Да"  THEN
         wop.qty = DECIMAL({&qty}).
   &ENDIF

   {debuger.i "wop.prepf"}

   CLEAR NO-PAUSE.

   &IF DEFINED(indoc) &THEN
     IF tmp-acct <> ? AND
        op-templ.op-templ = 1 THEN
     DO:
        IF wop.acct-cr = ?         AND
           op-templ.acct-cr <> "-" AND
           v-cat      <> "Внешние" THEN
           wop.acct-cr = tmp-acct.

        IF wop.acct-db = ?         AND
           op-templ.acct-db <> "-" AND
           v-cat       = "Внешние" THEN
           wop.acct-db = tmp-acct.
     END.
   &ENDIF

   DISPLAY
      wop.acct-db
      wop.acct-cr
      wop.amt-cur
      wop.symbol.

   SET
      wop.acct-db  WHEN op-templ.acct-db <> "-"  AND
                        (wop.acct-db = ?
                         &IF DEFINED(indoc) &THEN
                            OR wop.acct-db = tmp-acct
                         &ENDIF
                        )
      wop.acct-cr  WHEN op-templ.acct-cr <> "-"  AND
                        (wop.acct-cr = ?
                         &IF DEFINED(indoc) &THEN
                            OR wop.acct-cr = tmp-acct
                         &ENDIF
                        )
      wop.amt-cur  WHEN wop.prepf   = ""
      wop.symbol   WHEN wop.symbol  = "?".

   IF wop.prepf = "" THEN
   DO:
      FIND FIRST acct WHERE
                 acct.acct     = wop.acct-db
             AND acct.currency = wop.currency
      NO-LOCK NO-ERROR.

      FIND FIRST bal-acct OF acct NO-LOCK.

      IF AVAILABLE acct AND
         ((acct.kau-id <> ? AND acct.kau-id     <> "УМЦ-Учет") OR
          (acct.kau-id =  ? AND bal-acct.kau-id <> "УМЦ-Учет")
         )
      THEN
         wop.prepf = (IF wop.amt-cur <> ?
                      THEN STRING(wop.amt-cur)
                      ELSE "0"
                     ).
      ELSE
      DO:
         IF wop.amt-cur <> mCostNew * (IF CAN-DO("ОС,НМА", acct.contract)
                                          THEN 1
                                       ELSE wop.qty
                                      ) THEN
         DO:
            MESSAGE
               "Проводка по Дб счета учета ценности. "   SKIP
               "Сумма в шаблоне проводки не определена!" SKIP
               "Проставить сумму = ЦенаМЦ * Кол ?"       SKIP
               "В противном случае документ не будет сформирован"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
            UPDATE v-Ok AS LOGICAL.

            IF v-Ok THEN
            DO:
               wop.amt-cur = mCostNew.
               IF NOT CAN-DO("ОС,НМА", acct.contract) THEN
                  wop.amt-cur = wop.amt-cur * wop.qty.
            END.
            ELSE
               wop.amt-cur = ?.
         END.

         wop.prepf = STRING(wop.amt-cur).

         DISPLAY
            wop.amt-cur
         WITH FRAME edtempl.
      END.
   END.

   DOWN.

   &IF DEFINED(indoc) &THEN
      IF       wop.acct-cr            <> ?
         AND  (op-templ.acct-cr        = ?
            OR TRIM (op-templ.acct-cr) = "")
         AND   v-cat                  <> "Внешние"
         THEN tmp-acct = wop.acct-cr.

      IF       wop.acct-db            <> ?
         AND  (op-templ.acct-db        =  ?
            OR TRIM (op-templ.acct-db) =  "")
         AND   v-cat                   =  "Внешние"
         THEN tmp-acct = wop.acct-db.
   &ENDIF

   RUN parssen.p (       RECID(wop),
                         in-op-date,
                  OUTPUT fler
                 ).

   IF fler THEN
      UNDO gen, LEAVE gen.

   /*
   ** Если транзакция работает с двумя карточками одной подсистемы,
   ** то при построении аналитики на основе проводки сложно определить,
   ** к какой из карточек относятся счета Дт и Кт.
   ** Поэтому здесь пытаемся определить коды аналитического учёта.
   */
   wop.kau-db = GetPPKau(op-template.acct-db).

   RUN Get-Kau-Id IN h_kau(       wop.acct-cr,
                                  wop.currency,
                           OUTPUT vKau-Id

                          ).
   IF vKau-Id = ? THEN
      wop.kau-cr = ?.
   ELSE
   DO:
      wop.kau-cr = GetPPKau(op-template.acct-cr).
/*
      IF CAN-DO("af-ex", op-kind.proc) THEN
*/
      DO:
         /* Когда неизвестно, с кого списывать,
         ** ищем последний kau с ненулевым остатком
         */
         IF NUM-ENTRIES(vKau-Id,"-") >= 2              
            AND NOT CAN-FIND(LAST kau WHERE
                              kau.kau-id = vKau-Id
                          AND kau.kau    = wop.kau-cr
                        ) THEN
            ASSIGN
               vKau-Id    = REPLACE(vKau-Id, "УМЦ", "")
               vKau-Id    = ENTRY(2,vKau-Id,"-")
               wop.kau-cr = GetLast-Kau (ENTRY(1, wop.kau-cr),
                                         ENTRY(2, wop.kau-cr),
                                         vKau-Id,
                                         in-op-date
                                        ).

      END.
   END.

   FOR FIRST tt-op WHERE
             tt-op.op-template = op-templ.op-templ
         AND tt-op.rid        <> ?:

      FIND FIRST op WHERE
           RECID(op) = tt-op.rid
      NO-LOCK NO-ERROR.
   END.

   IF AVAILABLE op THEN
      RUN parssign.p (in-op-date,    /* Дата ОД.                              */
                      "op-template", /* Наименование таблицы с формулой.      */
                                     /* Идентификатор формулы.                */
                      op-templ.op-kind + "," + STRING(op-templ.op-templ),
                      op-templ.class-code,
                      "op",          /* Наименование таблицы объекта.         */
                      STRING(op.op), /* Указатель на объект для создания ДР.  */
                      op.class-code,
                      RECID(wop)     /* Указатель на WOP для парсера.         */
                     ).
END.

{a-op.cr {&*}}
