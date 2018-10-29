{pirsavelog.p}

DEF INPUT PARAM in-param AS CHAR.

/* !!! pir_selfpr.p
   Выявление проводок между счетами одного клиента
   Борисов А.В. 03.07.2009
*/

{globals.i} /* Подключяем глобалные настройки*/
{tmprecid.def}

{intrface.get loan}
{intrface.get xclass}   /* Функции работы с метасхемой */

DEF VAR iDbCust     AS INTEGER   NO-UNDO.
DEF VAR cDbCat      AS CHARACTER NO-UNDO.
DEF VAR iCrCust     AS INTEGER   NO-UNDO.
DEF VAR cCrCat      AS CHARACTER NO-UNDO.

DEF VAR iAll        AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbUl       AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbFl       AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iSelf       AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbUlSelf   AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbFlSelf   AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDr         AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbUlDr     AS INTEGER   INIT 0 NO-UNDO.
DEF VAR iDbFlDr     AS INTEGER   INIT 0 NO-UNDO.

DEF VAR dSAll       AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSUl        AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSFl        AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSSelf      AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSUlSelf    AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSFlSelf    AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSDr        AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSUlDr      AS DECIMAL   INIT 0 NO-UNDO.
DEF VAR dSFlDr      AS DECIMAL   INIT 0 NO-UNDO.

DEF VAR summ        AS DECIMAL   NO-UNDO.
DEF VAR summ1       AS DECIMAL   NO-UNDO.
DEF VAR acct-db     AS CHARACTER NO-UNDO.
DEF VAR acct-cr     AS CHARACTER NO-UNDO.
DEF VAR dop         AS CHARACTER NO-UNDO.
DEF VAR DR-type     AS CHARACTER NO-UNDO.

RUN g-prompt.p("CHARACTER", "Прим", "x(10)", "--",
               "Примечание", 20, ",", "", ?,?,OUTPUT dop).
   IF (dop = ?)
   THEN RETURN.

{setdest.i &cols = 140 &custom = " IF YES THEN 0 ELSE "} /* Вывод в preview */

{get-fmt.i &obj = '" + 'b' + ""-Acct-Fmt"" + "'}
FORM
   op-entry.op-date  FORMAT "99/99/99"
   op.doc-num                                   COLUMN-LABEL 'N док'
   op.doc-type       FORMAT "xxxxx"             COLUMN-LABEL 'Kod'
   DR-type           FORMAT "xxxxx"             COLUMN-LABEL 'KodDR'
   acct-db           FORMAT "x(24)"             COLUMN-LABEL 'ДЕБЕТ'
   acct-cr           FORMAT "x(24)"             COLUMN-LABEL 'КРЕДИТ'
   op-entry.currency FORMAT "xxx"
   summ              FORMAT "->>>>>>>>>>>>9.99" COLUMN-LABEL 'Сумм.вал'
   summ1             FORMAT "->>>>>>>>>>>>9.99" COLUMN-LABEL 'Сумм руб'
   dop               FORMAT "x(10)"             COLUMN-LABEL 'Прим'
WITH FRAME brw WIDTH 140 DOWN.

/* Шапка отчета ==================================================================== */
PUT UNFORMATTED
"                                   1 Проводки между счетами одного клиента" SKIP(2)
/*
"√    ДАТА     НОМЕР ДОКУМ. ЗО ДЕБЕТ                    КРЕДИТ                   ВАЛ      СУММА В НАЦ. ВАЛ." SKIP
"---- -------- ------------ -- ------------------------ ------------------------ ---- ---------------------" SKIP
*/
.

/* Для всех документов, выбранных в брoузере выполняем... =========================== */
FOR EACH tmprecid
   NO-LOCK,
   FIRST op-entry
      WHERE (RECID(op-entry) EQ tmprecid.id)
      NO-LOCK,
   FIRST op OF op-entry
      NO-LOCK
   WITH FRAME brw:

   IF (op-entry.acct-db EQ ?) OR (op-entry.acct-cr EQ ?) THEN NEXT.
   iAll  = iAll + 1.
   dSAll = dSAll + op-entry.amt-rub.

   FIND FIRST acct WHERE acct.acct = op-entry.acct-db
      NO-ERROR.
   ASSIGN
      iDbCust = acct.cust-id
      cDbCat  = acct.cust-cat
   .

   FIND FIRST acct WHERE acct.acct = op-entry.acct-cr
      NO-ERROR.
   ASSIGN
      iCrCust = acct.cust-id
      cCrCat  = acct.cust-cat
   .

   IF (cDbCat EQ "Ю") THEN
      ASSIGN
         iDbUl = iDbUl + 1
         dSUl  = dSUl + op-entry.amt-rub
      .
   IF (cDbCat EQ "Ч") THEN
      ASSIGN
         iDbFl = iDbFl + 1
         dSFl  = dSFl + op-entry.amt-rub
      .

   IF (iDbCust EQ iCrCust) AND (cDbCat EQ cCrCat) AND (cDbCat NE "В")
   THEN DO:
      iSelf  = iSelf  + 1.
      dSSelf = dSSelf + op-entry.amt-rub.

      IF (cDbCat EQ "Ю") THEN
         ASSIGN
            iDbUlSelf = iDbUlSelf + 1
            dSUlSelf  = dSUlSelf + op-entry.amt-rub
         .
      IF (cDbCat EQ "Ч") THEN
         ASSIGN
            iDbFlSelf = iDbFlSelf + 1
            dSFlSelf  = dSFlSelf + op-entry.amt-rub
         .
/*
      PUT UNFORMATTED
         op-entry.op-status FORMAT "x(4)" SPACE
         op-entry.op-date   FORMAT "99/99/99" SPACE
         op.doc-num         FORMAT "x(12)" SPACE(4)
         {out-fmt.i op-entry.acct-db fmt} FORMAT "x(24)" SPACE
         {out-fmt.i op-entry.acct-cr fmt} FORMAT "x(24)" SPACE
         op-entry.currency  FORMAT "x(4)" SPACE
         op-entry.amt-rub   FORMAT "->,>>>,>>>,>>>,>>9.99" SPACE
      SKIP.
*/
      ASSIGN
         acct-db = IF op-entry.acct-db NE ? 
                   THEN {out-fmt.i op-entry.acct-db fmt}
                   ELSE ""
         acct-cr = IF op-entry.acct-cr NE ? 
                   THEN {out-fmt.i op-entry.acct-cr fmt}
                   ELSE ""
         DR-type = GetXAttrValueEx("op", STRING(op.op), "ШифрПл", "")
      .
      IF op-entry.acct-cat EQ "d" THEN 
         ASSIGN 
            summ  = op-entry.amt-rub
            summ1 = op-entry.amt-rub
         .
      ELSE DO:
         ASSIGN 
            summ  = op-entry.amt-cur
            summ1 = op-entry.amt-rub
         .
         IF op-entry.currency EQ "" THEN
            ASSIGN 
               summ  = op-entry.amt-rub
               summ1 = op-entry.amt-rub
            .
      END.

	UpdateSigns ( "op", string(op.op) , "f251_exc", in-param, YES ).

      DISPLAY
         op-entry.op-date
         op.doc-num
         op.doc-type
         DR-type
         acct-db
         acct-cr
         op-entry.currency
         summ
         summ1
         dop
	 GetXAttrValueEx("op", STRING(op.op), "f251_exc", "NO")
      .
      DOWN.
   END.

END.

PUT UNFORMATTED
   SKIP "Всего проводок 'самому себе' : " iSelf FORMAT ">>>>>9"
   SKIP "======================================================="
   SKIP "Всего проводок : " iAll  FORMAT ">>>>>9" " , из них 'самому себе' : " iSelf     FORMAT ">>>>>9" " (разность : " (iAll - iSelf)      FORMAT ">>>>>9" " )"
   SKIP "  Со счетов ЮЛ : " iDbUl FORMAT ">>>>>9" " , из них 'самому себе' : " iDbUlSelf FORMAT ">>>>>9" " (разность : " (iDbUl - iDbUlSelf) FORMAT ">>>>>9" " )"
   SKIP "  Со счетов ФЛ : " iDbFl FORMAT ">>>>>9" " , из них 'самому себе' : " iDbFlSelf FORMAT ">>>>>9" " (разность : " (iDbFl - iDbFlSelf) FORMAT ">>>>>9" " )"
   SKIP "======================================================="
   SKIP .

PUT UNFORMATTED
   SKIP "┌─────────────────────┬────────┬───────────────────────┐"
   SKIP "│                     │ Кол-во │         Сумма         │"
   SKIP "├─────────────────────┼────────┼───────────────────────┤"
   SKIP "│     Со счетов ЮЛ    │        │                       │"
   SKIP "│ Всего               │ " iDbUl     FORMAT ">>>>>9" " │ " dSUl     FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
   SKIP "│ 'Самому себе'       │ " iDbUlSelf FORMAT ">>>>>9" " │ " dSUlSelf FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
/* SKIP "│   Другие исключения │ " iDbUlDr   FORMAT ">>>>>9" " │ " dSUlDr   FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
*/ SKIP "│ Остаток             │ " (iDbUl - iDbUlSelf - iDbUlDr) FORMAT ">>>>>9" " │ "
                                   (dSUl  - dSUlSelf  - dSUlDr)  FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
   SKIP "├─────────────────────┼────────┼───────────────────────┤"
   SKIP "│     Со счетов ФЛ    │        │                       │"
   SKIP "│ Всего               │ " iDbFl     FORMAT ">>>>>9" " │ " dSFl     FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
   SKIP "│ 'Самому себе'       │ " iDbFlSelf FORMAT ">>>>>9" " │ " dSFlSelf FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
/* SKIP "│   Другие исключения │ " iDbFlDr   FORMAT ">>>>>9" " │ " dSFlDr   FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
*/ SKIP "│ Остаток             │ " (iDbFl - iDbFlSelf - iDbFlDr) FORMAT ">>>>>9" " │ "
                                   (dSFl  - dSFlSelf  - dSFlDr)  FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
   SKIP "╞═════════════════════╪════════╪═══════════════════════╡"
   SKIP "│     ИТОГО           │        │                       │"
   SKIP "│ Всего               │ " iAll  FORMAT ">>>>>9" " │ " dSAll  FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
   SKIP "│ 'Самому себе'       │ " iSelf FORMAT ">>>>>9" " │ " dSSelf FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
/* SKIP "│   Другие исключения │ " iDr   FORMAT ">>>>>9" " │ " dSDr   FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
*/ SKIP "│ Остаток             │ " (iAll  - iSelf  - iDr)  FORMAT ">>>>>9" " │ "
                                   (dSAll - dSSelf - dSDr) FORMAT "->,>>>,>>>,>>>,>>9.99" " │"
   SKIP "└─────────────────────┴────────┴───────────────────────┘"
   SKIP .

/* Отображаем содержимое preview */
{preview.i}
