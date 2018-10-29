{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    COPYRIGHT: (C) 1992-2001 ТОО "Банковские информационные системы"
     FILENAME: FLTCARD.P
      COMMENT:
      COMMENT: Подготавливает данные для процедур cardrpt.p,cardrpt1.p
   PARAMETERS:
         USES:
      USED BY:
      CREATED: 14/08/2003 KOSTIK
     MODIFIED:
  LAST CHANGE:
*/

{globals.i}
{intrface.get xclass}
{tmprecid.def}        /** Используем информацию из броузера */

DEFINE INPUT PARAMETER in-kau-id AS CHARACTER                     NO-UNDO.

DEFINE VAR input-data AS CHARACTER NO-UNDO VIEW-AS RADIO-SET
                         RADIO-BUTTONS
                         "ФИЗИЧЕСКИМ  КЛИЕНТАМ","ФИЗ",
                         "ЮРИДИЧЕСКИМ КЛИЕНТАМ","ЮР",
                         "КЛИЕНТЫ-БАНКИ","БАНКИ",
                         "СЧЕТА","СЧЕТА".
DEFINE VAR div-by-ord AS LOGICAL   NO-UNDO
                         VIEW-AS TOGGLE-BOX
                         LABEL "Разбивать по очередности оплат".

DEFINE VAR v-order-pay AS CHARACTER LABEL "Приоритет"             NO-UNDO.

&IF DEFINED(fltcard_2_dat) <> 0 &THEN
   DEFINE VAR in-date-beg-in  AS DATE                             NO-UNDO.
   DEFINE VAR in-date-end-in  AS DATE                             NO-UNDO.
   DEFINE VAR in-date-beg-out AS DATE                             NO-UNDO.
   DEFINE VAR in-date-end-out AS DATE                             NO-UNDO.
&ELSE
   DEFINE VAR in-date     AS DATE              NO-UNDO.
   DEFINE VAR all-doc     AS LOGICAL INIT YES  VIEW-AS TOGGLE-BOX NO-UNDO.
&ENDIF

DEFINE VAR fullsum     AS DECIMAL INITIAL 0  NO-UNDO.
DEFINE VAR r-sum       AS DECIMAL INITIAL 0  NO-UNDO.
DEFINE VAR in-acct-cat AS CHARACTER          NO-UNDO.
DEFINE VAR level       AS INTEGER INITIAL 3  NO-UNDO.
DEFINE VAR flag-print  AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VAR mSort-by    AS CHARACTER NO-UNDO VIEW-AS RADIO-SET
                         RADIO-BUTTONS
                         "ДАТЕ ДОКУМЕНТА","ДД",
                         "ДАТЕ ПОСТАНОВКИ НА КАРТОТЕКУ","ДП".

DEFINE QUERY flt-qry1 FOR tmprecid,banks,acct.
DEFINE QUERY flt-qry2 FOR tmprecid,person,acct.
DEFINE QUERY flt-qry3 FOR tmprecid,cust-corp,acct.
DEFINE QUERY flt-qry4 FOR tmprecid,acct.

DEFINE NEW SHARED STREAM rpt-stream.

OPEN QUERY flt-qry1 FOR EACH tmprecid NO-LOCK,
                    FIRST banks WHERE RECID(banks) EQ tmprecid.id NO-LOCK,
                    EACH  acct  WHERE acct.cust-cat EQ "Б"
                                  AND acct.cust-id  EQ banks.bank-id NO-LOCK.
OPEN QUERY flt-qry2 FOR EACH tmprecid NO-LOCK,
                    FIRST person WHERE RECID(person) EQ tmprecid.id NO-LOCK,
                    EACH  acct   WHERE acct.cust-cat EQ "Ч"
                                  AND acct.cust-id  EQ person.person-id NO-LOCK.
OPEN QUERY flt-qry3 FOR EACH tmprecid NO-LOCK,
                    FIRST cust-corp WHERE RECID(person) EQ tmprecid.id NO-LOCK,
                    EACH  acct      WHERE acct.cust-cat EQ "Ю"
                                      AND acct.cust-id  EQ cust-corp.cust-id NO-LOCK.


FORM
   input-data LABEL "ПОДГОТОВКА ОТЧЕТА ПО" SKIP(1)
   mSort-by   LABEL "СОРТИРОВАТЬ ПО"       SKIP(1)
   &IF DEFINED(fltcard_2_dat) <> 0 &THEN
      "Документы постановки" SKIP(1)
      in-date-beg-in  FORMAT "99/99/9999" LABEL "С"
      in-date-end-in  FORMAT "99/99/9999" LABEL "ПО" SKIP(2)
      "Документы списания"   SKIP(1)
      in-date-beg-out  FORMAT "99/99/9999" LABEL "С"
      in-date-end-out  FORMAT "99/99/9999" LABEL "ПО"
   &ELSE
      in-date      LABEL "НА ДАТУ"
                   FORMAT "99/99/9999"
      all-doc LABEL "Все документы" HELP "Показывать все документы"
   &ENDIF

   SKIP(1)
   div-by-ord
WITH FRAME enter-data
     CENTERED
     TITLE    "[ ВХОДНЫЕ ДАННЫЕ ]"
     OVERLAY
     SIDE-LABELS.

&IF DEFINED(fltcard_2_dat) <> 0 &THEN
   ASSIGN
      in-date-end-in  = gend-date
      in-date-end-out = gend-date
   .
&ELSE
   in-date = gend-date.
&ENDIF

PAUSE 0.

ON RETURN OF input-data IN FRAME enter-data DO:
   IF VALID-HANDLE(SELF:NEXT-SIBLING) THEN
      APPLY "TAB" TO SELF.
   ELSE
      APPLY "GO"  TO SELF.
END.
ON esc OF FRAME enter-data DO:
   HIDE FRAME enter-data.
END.

&IF DEFINED(fltcard_2_dat) <> 0 &THEN
   ON "F10" OF in-date-beg-in,
               in-date-end-in,
               in-date-beg-out,
               in-date-end-out IN FRAME enter-data OR
      "F1"  OF in-date-beg-in,
               in-date-end-in,
               in-date-beg-out,
               in-date-end-out IN FRAME enter-data
   DO:
&ELSE
   ON "F10" OF in-date IN FRAME enter-data OR
      "F1"  OF in-date IN FRAME enter-data
   DO:
&ENDIF
      RUN calend.p.
      IF RETURN-VALUE NE ? THEN SELF:SCREEN-VALUE = pick-value.
   END.

&IF DEFINED(fltcard_2_dat) <> 0 &THEN
   FIND FIRST op-date NO-LOCK NO-ERROR.
   IF AVAIL(op-date) THEN
   ASSIGN
      in-date-beg-in = op-date.op-date
      in-date-beg-out = op-date.op-date
   .
&ENDIF

UPDATE
   input-data
   mSort-by
&IF DEFINED(fltcard_2_dat) <> 0 &THEN
/*   in-date-beg    VALIDATE(in-date-beg NE ?,"Введите дату расчета!")
   in-date-end    VALIDATE(in-date-end NE ?,"Введите дату расчета!")*/
   in-date-beg-in
   in-date-end-in
   in-date-beg-out
   in-date-end-out
&ELSE
   in-date    VALIDATE(in-date NE ?,"Введите дату расчета!")
   all-doc
&ENDIF
   div-by-ord
WITH FRAME enter-data.
HIDE FRAME enter-data.

CASE input-data:
   WHEN "БАНКИ"  THEN DO:
      RUN bank-cli.p (3).
      OPEN QUERY flt-qry1 FOR EACH  tmprecid NO-LOCK,
                          FIRST banks WHERE RECID(banks) EQ tmprecid.id NO-LOCK,
                          EACH  acct  WHERE acct.cust-cat EQ "Б"
                                        AND acct.cust-id  EQ banks.bank-id
                                        AND acct.acct-cat EQ "o" NO-LOCK.
      GET FIRST flt-qry1.
   END.
   WHEN "ФИЗ" 
   THEN DO:
      RUN browseld.p ("person",
                      "",
                      "",
                      ?,
                      3).
      OPEN QUERY flt-qry2 FOR EACH tmprecid NO-LOCK,
                          FIRST person WHERE RECID(person) EQ tmprecid.id NO-LOCK,
                          EACH  acct   WHERE acct.cust-cat EQ "Ч"
                                         AND acct.cust-id  EQ person.person-id
                                         AND acct.acct-cat EQ "o" NO-LOCK.
      GET FIRST flt-qry2.
   END.
   WHEN "ЮР" THEN DO:
      RUN browseld.p("cust-corp","","",?,3).
      OPEN QUERY flt-qry3 FOR EACH  tmprecid NO-LOCK,
                          FIRST cust-corp WHERE RECID(cust-corp) EQ tmprecid.id NO-LOCK,
                          EACH  acct      WHERE acct.cust-cat EQ "Ю"
                                            AND acct.cust-id  EQ cust-corp.cust-id
                                            AND acct.acct-cat EQ "o" NO-LOCK.
      GET FIRST flt-qry3.
   END.
   WHEN "СЧЕТА" THEN DO:
      RUN browseld.p ("acct",
                      "acct-cat",
                      "o",
                      "acct-cat",
                      level).
      OPEN QUERY flt-qry4 FOR EACH  tmprecid NO-LOCK,
                          FIRST acct      WHERE RECID(acct) EQ tmprecid.id NO-LOCK.
      GET FIRST flt-qry4.
   END.
END CASE.

{setdest2.i &stream="stream rpt-stream" &cols=145}

DO WHILE AVAIL tmprecid:
&IF DEFINED(fltcard_2_dat) <> 0 &THEN
   RUN pir-cardrpt.p (acct.acct,
                   acct.currency,
                   in-kau-id,
                   in-date-beg-in,
                   in-date-end-in,
                   in-date-beg-out,
                   in-date-end-out,
                   div-by-ord,
                   mSort-by,
                  OUTPUT r-sum
                  ).
&ELSE
   RUN pir-cardrpt.p (acct.acct,
                  acct.currency,
                  in-kau-id,
                  in-date,
                  all-doc,
                  div-by-ord,
                  mSort-by,
                  OUTPUT r-sum
                 ).
&ENDIF
   fullsum = fullsum + r-sum.
   IF RETURN-VALUE EQ "PRINT" THEN flag-print = YES.
   CASE input-data:
      WHEN "БАНКИ" THEN
         GET NEXT flt-qry1.
      WHEN "ФИЗ"   THEN
         GET NEXT flt-qry2.
      WHEN "ЮР"    THEN
         GET NEXT flt-qry3.
      WHEN "СЧЕТА" THEN
         GET NEXT flt-qry4.
   END CASE.
END.
      PUT STREAM rpt-stream
         SKIP(3)
         SPACE(40) "Итого:"  SKIP
         SPACE(40) "На сумму: " fullsum  FORMAT ">>>,>>>,>>>,>>9.99" SKIP.
IF flag-print THEN DO:
   {preview2.i &stream="STREAM rpt-stream"}
END.
ELSE DO:
   MESSAGE "Отчет пуст!"
   VIEW-AS ALERT-BOX WARNING BUTTONS OK.
   OUTPUT STREAM rpt-stream CLOSE.
END.
