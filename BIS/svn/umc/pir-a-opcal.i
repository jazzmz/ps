/*─юЁрсюЄъш яю чр тъх #764*/
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2003 ТОО "Банковские информационные системы"
     Filename: a-opcal.i
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

&IF DEFINED( MANUAL-REMOTE ) &THEN
&SCOPED-DEFINE edtempl edtemplForQbis
FORM
   wop.acct-db
   wop.acct-cr
   wop.currency
   wop.amt-cur
   wop.amt-rub 
   WITH FRAME {&edtempl} SIDE-LABELS 1 COL TITLE "ПРОВЕРКА ПРОВОДОК".
&ELSE
&SCOPED-DEFINE edtempl edtempl
&ENDIF

DEFINE BUFFER xxxwop    FOR wop.
DEFINE BUFFER xLoanAcct FOR loan-acct.

ON "F1" OF wop.acct-db, wop.acct-cr IN FRAME {&edtempl}
DO:
   RUN acct.p (wop.acct-cat, 4).

   IF pick-value NE ? AND
      (LASTKEY EQ 10 OR LASTKEY EQ 13)
   THEN
      SELF:SCREEN-VALUE = ENTRY(1, pick-value).
END.

ON "LEAVE" OF wop.acct-db, wop.acct-cr IN FRAME {&edtempl}
DO:
   DEFINE VARIABLE tt-acct AS CHARACTER NO-UNDO.

   DO WITH FRAME {&edtempl}:
      tt-acct = AddFilToAcct(TRIM(REPLACE(SELF:SCREEN-VALUE, "-", ""), "- "), shFilial).

      RUN AssumeAcct(INPUT-OUTPUT tt-acct).

      IF tt-acct NE ?
      THEN DO:
         tt-acct = ENTRY(1, tt-acct).
         IF AddFilToAcct(REPLACE(SELF:SCREEN-VALUE, "-", ""), shFilial) NE tt-acct
         THEN DO:
            SELF:SCREEN-VALUE = STRING(tt-acct, mFmt).
            RETURN NO-APPLY.
         END.
      END.
      ELSE DO:
         MESSAGE
            "Нет такого счета или у Вас недостаточно прав!"
         VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
   END.
END.

/* Код шаблона КАУ? */
DEFINE VARIABLE vKau-Id  AS CHARACTER NO-UNDO INITIAL ?.
DEFINE VARIABLE mOpTempl AS INT64     NO-UNDO.
DEFINE VARIABLE vLastKau AS CHARACTER NO-UNDO INITIAL ?.

{empty wop}

CLEAR FRAME edtempl ALL NO-PAUSE.

mOpClassList = Ls-Class("op").

&IF DEFINED(q-opt) > 0 &THEN

DEFINE QUERY q-opt FOR op-template.

OPEN   QUERY q-opt FOR EACH op-template OF op-kind NO-LOCK.

GET FIRST q-opt.
mOpTempl = 0.
m-opt:
DO WHILE AVAILABLE op-template
   WITH FRAME edtempl
   ON ERROR  UNDO m-opt, RETRY m-opt /* наверно нужно откатить только это блок а не ген */
   ON ENDKEY UNDO m-opt, RETRY m-opt:

   IF RETRY THEN DO:
      MESSAGE "Вы откатили обработку шаблона № " + STRING(mOpTempl) +
              " для карточки " + loan.contract + "/" + loan.doc-ref + " !" SKIP
              "Откатить всю транзакцию                         (Да),"      SKIP
              IF mOpTempl EQ 1 THEN
              "вернуться к редактированию предыдущей карточки (Нет),"
              ELSE
              "вернуться к редактированию предыдущего шаблона (Нет),"      SKIP
              "или продолжить                              (Отмена) ?"
         VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-cancel SET vQ AS LOG.
      IF vQ EQ YES THEN
         UNDO gen, LEAVE gen.
      ELSE IF vQ EQ NO THEN DO:
         IF mOpTempl EQ 1 THEN DO:
            UNDO m-ln, RETRY m-ln.
         END.
         ELSE DO: 
            GET PREV q-opt.
            IF NOT AVAILABLE op-template then
            GET FIRST q-opt.
            FIND LAST bwop NO-ERROR.
            IF AVAILABLE bwop THEN
               DELETE bwop.
         END.
      END.
      ELSE DO:
         GET NEXT q-opt.
         IF NOT AVAILABLE op-template THEN
         GET FIRST q-opt.
      END.
   END.

   IF NOT CAN-DO(mOpClassList, op-template.cr-class-code)
   THEN DO:
      GET NEXT q-opt.
      NEXT m-opt.
   END.

   mOpTempl = op-template.op-template.

&ELSE
FOR EACH op-template
      OF op-kind
NO-LOCK
WITH FRAME edtempl
ON ERROR  UNDO gen, LEAVE gen
ON ENDKEY UNDO gen, RETRY gen
:
   IF NOT CAN-DO(mOpClassList, op-template.cr-class-code) THEN
      NEXT.
&ENDIF

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
      res4nal  = 0
   .

   IF RETRY AND
      op-template.op-template EQ 1 AND
      CAN-FIND(FIRST xxxwop)
   THEN FIND LAST wop.
   ELSE CREATE wop.

   ASSIGN
      wop.currency = GetCurr(op-template.currency)
      wop.op-kind  = op-kind.op-kind
      wop.op-templ = op-template.op-template
      .

   IF wop.currency EQ ?
   THEN DO:
      MESSAGE
         "Не определена валюта в шаблоне проводки N"
         STRING(op-template.op-template) "!"
      VIEW-AS ALERT-BOX ERROR.
      UNDO gen, LEAVE gen.
   END.

   mPropShabl = GetXAttrValueEx(
                                 "op-template"
                               , op-template.op-kind + "," + STRING(op-template.op-template)
                               , "ПропШаблСчет"
                               , "Нет"
                               ) EQ "Да".
   IF mPropShabl
   THEN DO:
      RUN parssen.p
         (
            INPUT RECID(wop)
         ,  INPUT in-op-date
         , OUTPUT fler
         ) .
      IF fler THEN
         UNDO gen, LEAVE gen.
   END.

   {g-acctv1.i
      &OFbase   = YES
      &OFsrch   = YES
      &BYrole   = YES
      &vacct    = tacct
      }

   {asswop.i}

   IF op-template.op-template EQ 1 THEN
   DO:
   &IF DEFINED(acctdb) &THEN
      wop.acct-db = {&acctdb}.
   &ENDIF
   &IF DEFINED(acctcr) &THEN
      wop.acct-db = {&acctcr}.
   &ENDIF
   END.

   &IF DEFINED(prepf) &THEN
      wop.prepf = (IF NUM-ENTRIES({&prepf}) GE op-template.op-template
                   THEN ENTRY(op-template.op-template, {&prepf})
                   ELSE wop.prepf).
   &ENDIF

   &IF DEFINED(qty) &THEN
      /* По-умолчанию для шаблона №1 учитываем количество,
      ** если категория счета <> "n" - налоговый учет, 
      ** для остальных шаблонов не учитываем.
      */
      IF GetXAttrValueEx(
                          "op-template"
                        ,  op-template.op-kind + "," + STRING(op-template.op-template)
                        , "QtyNeed"
                        , (IF op-template.op-template EQ  1  AND
                              op-template.acct-cat    NE "n"
                           THEN "Да"
                           ELSE "Нет")
                        ) EQ "Да"
      THEN
         wop.qty = DECIMAL({&qty}).
   &ENDIF

   {debuger.i "wop.prepf"}

   CLEAR NO-PAUSE.

   &IF DEFINED(indoc) &THEN
     IF tmp-acct NE ? AND
        op-template.op-template EQ 1
     THEN DO:
        IF wop.acct-cr         EQ ?   AND
           op-template.acct-cr NE "-" AND
           v-cat               NE "Внешние"
        THEN
           wop.acct-cr = tmp-acct.

        IF wop.acct-db         EQ ?   AND
           op-template.acct-db NE "-" AND
           v-cat               EQ "Внешние"
        THEN
           wop.acct-db = tmp-acct.
     END.
   &ENDIF
   
   mFmt = GetAcctFmtEx(wop.acct-cat, "", YES).

   wop.acct-db:FORMAT IN FRAME {&edtempl} = mFmt.
   wop.acct-cr:FORMAT IN FRAME {&edtempl} = mFmt.

   DISPLAY
      wop.acct-db
      wop.acct-cr
      wop.amt-cur
      wop.amt-rub
   WITH FRAME {&edtempl}.
   SET
      wop.acct-db  WHEN (op-template.acct-db NE "-"  AND
                         (wop.acct-db EQ ?
                          &IF DEFINED(indoc) &THEN
                             OR wop.acct-db EQ tmp-acct
                          &ENDIF
                         )
                        ) OR RETRY
      wop.acct-cr  WHEN (op-template.acct-cr NE "-"  AND
                         (wop.acct-cr EQ ?
                          &IF DEFINED(indoc) &THEN
                             OR wop.acct-cr EQ tmp-acct
                          &ENDIF
                         )
                        ) OR RETRY
      wop.amt-cur  WHEN wop.prepf  EQ ""   
    WITH FRAME {&edtempl}.

   IF wop.prepf EQ "" THEN
   DO:
      {find-act.i
           &acct = "wop.acct-db"
           &curr = "wop.currency"
      }

      IF AVAILABLE acct THEN
         FIND FIRST bal-acct OF acct NO-LOCK NO-ERROR.


      IF     (AVAILABLE acct AND AVAILABLE bal-acct)
         AND
             ((acct.kau-id NE ? AND acct.kau-id     NE "УМЦ-Учет")
               OR
              (acct.kau-id EQ ? AND bal-acct.kau-id NE "УМЦ-Учет") )
      THEN
         wop.prepf = (IF wop.amt-cur <> ?
                      THEN STRING(wop.amt-cur)
                      ELSE "0"
                     ).

      ELSE IF AVAILABLE acct
      THEN DO:
/*         IF wop.amt-cur NE mCostNew * (IF CAN-DO("ОС,НМА", acct.contract)
                                       THEN 1
                                       ELSE wop.qty)
         THEN DO:
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
         END.            */

         wop.prepf = STRING(wop.amt-cur).

         DISPLAY
            wop.amt-cur
         WITH FRAME edtempl.
      END.

      ELSE IF NOT AVAILABLE acct THEN
         MESSAGE "Счет не найден !" VIEW-AS ALERT-BOX.
   END.

   DOWN.

   &IF DEFINED(indoc) &THEN
      IF wop.acct-cr               NE ?   AND
         (op-template.acct-cr      EQ ?   OR
         TRIM(op-template.acct-cr) EQ "") AND
         v-cat                     NE "Внешние"
      THEN
         tmp-acct = wop.acct-cr.
   
      IF wop.acct-db               NE ? AND
         (op-template.acct-db      EQ ? OR
         TRIM(op-template.acct-db) EQ "") AND
         v-cat                     EQ "Внешние"
      THEN
         tmp-acct = wop.acct-db.
   &ENDIF

   IF NOT mPropShabl
   THEN DO:
      RUN parssen.p
         (
            INPUT RECID(wop)
         ,  INPUT in-op-date
         , OUTPUT fler
         ) .
      IF fler THEN
         UNDO gen, LEAVE gen.
   END.

   /*
   ** Если транзакция работает с двумя карточками одной подсистемы,
   ** то при построении аналитики на основе проводки сложно определить,
   ** к какой из карточек относятся счета Дт и Кт.
   ** Поэтому здесь пытаемся определить коды аналитического учёта.
   */
   wop.kau-db = GetPPKau(op-template.acct-db).

   RUN Get-Kau-Id IN h_kau
      (
         INPUT wop.acct-cr
      ,  INPUT wop.currency
      , OUTPUT vKau-Id
      ) .
   IF vKau-Id EQ ? THEN
      wop.kau-cr = ?.
   ELSE DO:
      IF NOT {assigned wop.kau-cr} THEN
         wop.kau-cr = GetPPKau(op-template.acct-cr).

      IF NOT CAN-DO("as-out,a-in", op-kind.proc) AND
         vKau-Id NE "УМЦ-амор"                   AND
         NOT {assigned wop.kau-cr}
      THEN DO:
         /* Когда неизвестно, с кого списывать,
         ** ищем последний kau с ненулевым остатком
         */
         IF NUM-ENTRIES(vKau-Id,"-") GE 2 AND
            NOT CAN-FIND( LAST kau
                         WHERE kau.kau-id EQ vKau-Id
                           AND kau.kau    EQ wop.kau-cr)
         THEN DO:
            IF     op-kind.proc           EQ "a-io(gr)"
               AND module                 EQ "СКЛАД"
               AND op-temp.acct-cat       EQ "b"
               AND op-template.class-code EQ "doc-templ-umc"
               AND wop.kau-cr             NE GetLastKauEx(
                                                           ENTRY(1, wop.kau-cr)
                                                         , ENTRY(2, wop.kau-cr + ",")
                                                         , vKau-Id
                                                         , in-op-date
                                                         )
            THEN DO:
               RUN Fill-SysMes IN h_tmess ("", "УМЦ1001", "", "%s=" + wop.kau-cr).
               UNDO gen, LEAVE gen.
            END.

            ASSIGN
               vKau-Id    = REPLACE(vKau-Id, "УМЦ", "")
               vKau-Id    = ENTRY(2, vKau-Id, "-")
               wop.kau-cr = GetLastKauEx(
                                          ENTRY(1, wop.kau-cr)
                                        , ENTRY(2, wop.kau-cr + ",")
                                        , vKau-Id
                                        , in-op-date
                                        )
               .
         END.
         ELSE IF vKau-Id EQ "УМЦ-учет"
         THEN DO:
            vKau-Id = "-учет".
            FOR FIRST xLoanAcct           OF loan
                WHERE xLoanAcct.acct-type EQ work-module + vKau-Id
                  AND xLoanAcct.since     LE in-op-date
            NO-LOCK
            :
               wop.kau-cr = GetLastKauEx(
                                          ENTRY(1, wop.kau-cr)
                                        , ENTRY(2, wop.kau-cr + ",")
                                        , vKau-Id
                                        , in-op-date
                                        ) .
            END.
         END.
      END.
      IF NOT {assigned wop.kau-cr}
      THEN DO:
         vLastKau = GetLastKauEx(
                                  ENTRY(1, wop.kau-cr)
                                , ENTRY(2, wop.kau-cr + ",")
                                , vKau-Id
                                , in-op-date
                                ) .
         IF op-template.class-code EQ "doc-templ-umc" AND
            NOT CAN-DO("СчФактПрин,АхдДог", vKau-Id)  AND
            wop.kau-cr             NE vLastKau     /* AND {assigned vLastKau} */
         THEN DO:
            RUN Fill-SysMes IN h_tmess ("", "УМЦ1001", "", "%s=" + wop.kau-cr).
            UNDO gen, LEAVE gen.
         END.
      END.
   END.

   FOR FIRST tt-op
       WHERE tt-op.op-template EQ op-template.op-template
         AND tt-op.rid         NE ?
   :
      FIND FIRST op
           WHERE RECID(op) EQ tt-op.rid
         NO-LOCK NO-ERROR.
   END.

   IF AVAILABLE op THEN
      RUN parssign.p
         (
           INPUT in-op-date    /* Дата ОД.                             */
         , INPUT "op-template" /* Наименование таблицы с формулой.     */
                               /* Идентификатор формулы.               */
         , INPUT op-template.op-kind + "," + STRING(op-template.op-template)
         , INPUT op-template.class-code
         , INPUT "op"          /* Наименование таблицы объекта.        */
         , INPUT STRING(op.op) /* Указатель на объект для создания ДР. */
         , INPUT op.class-code
         , INPUT RECID(wop)    /* Указатель на WOP для парсера.        */
         ) .

   &IF DEFINED(q-opt) > 0 &THEN
   GET NEXT q-opt.
   &ENDIF

END.

{a-op.cr {&*}}

/*   Filename: a-opcal.i  --  E n d */
