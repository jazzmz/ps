/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2000 ТОО "Банковские информационные системы"
     Filename: af-lists.p
      Comment: Ведомость состояния основных средств/НМА c группировкой
   Parameters:
         Uses:
      Used by:
      Created: from ap-list.p 06.03.2000 vteb
      модификация : 26/01/2001 mitr  tt 0000984,   добавлена обработка no-beg-date , фраза ПЕРИОД -> ЗА
*/
define var ii as integer no-undo.
define var a-stack as decimal no-undo extent 8.
define var b-stack as decimal no-undo extent 8.
define var c-stack as decimal no-undo extent 8.
define var d-stack as decimal no-undo extent 8.
define var e-stack as decimal no-undo extent 8.
define var sum1 as decimal no-undo.
define var sum2 as decimal no-undo.
define var sum3 as decimal no-undo.
define var sum4 as decimal no-undo.
define var sum5 as decimal no-undo.
define var no-ex as char no-undo.

define var prev-lst as character no-undo initial ["Top;;;;;;;"].

define var head1 as char extent 5 no-undo initial [
  "┌────────────────┬────────────────────────────────────────┬──────────┬────────────────┬───────────┬───────────────────┬───────────────────┬───────────────────┬───────────────────┐",
  "│                │                                        │  ДАТА    │                │           │                   │                   │                   │                   │",
  "│ИНВЕНТАРН. НОМЕР│              НАИМЕНОВАНИЕ              │ ПОСТУП-  │   ЗАВОДСКОЙ    │   КОЛ.    │    БАЛАНСОВАЯ     │      СУММА        │       СУММА       │    ОСТАТОЧНАЯ     │",
  "│                │                                        │ ЛЕНИЯ    │     НОМЕР      │           │     СТОИМОСТЬ     │     ИЗНОСА        │     ПЕРЕОЦЕНКИ    │     СТОИМОСТЬ     │",
  "└────────────────┴────────────────────────────────────────┴──────────┴────────────────┴───────────┴───────────────────┴───────────────────┴───────────────────┴───────────────────┘"].

/* Наименование группы */
DEF VAR mGroupName  AS CHAR  NO-UNDO.

&SCOPED-DEFINE jer CAN-DO("asset,sub-u,place", in-sort)
&GLOBAL-DEFINE by-acct YES

{ap-sortg.i {&*}}      /* Запись temp-table af  */

form              /* Формат строки таблицы */
     space
     af.inv-num    format "x(16)"
     af.name[1]    format "x(40)"
     af.date-make  format "99/99/9999"
     af.ser-num    format "x(16)" at 71
     af.qty
     af.unit       format "x(4)"
     af.disc       format " ->>,>>>,>>>,>>9.99"
     af.amor       format " ->>,>>>,>>>,>>9.99"
     af.over       format " ->>,>>>,>>>,>>9.99"
     af.rest       format " ->>,>>>,>>>,>>9.99"
with frame listx width 179 down no-box no-label.

{setdest.i &cols=179}

PUT UNFORMATTED
   GetReportName("ВЕДОМОСТЬ СОСТОЯНИЯ") SKIP(3).

/* Печать таблицы */
FOR EACH af
   BREAK BY af.sort-value
   WITH FRAME listx:

   /* Накопление итогов */
   ACCUMULATE
      af.disc (TOTAL BY af.sort-value)
      af.qty  (TOTAL BY af.sort-value)
      af.amor (TOTAL BY af.sort-value)
      af.over (TOTAL BY af.sort-value)
      af.rest (TOTAL BY af.sort-value).

   IF FIRST-OF(af.sort-value) THEN
   DO:
      IF {&jer} THEN
      DO:
         /* Печать промежуточных итогов для иерарх. групп */
         IF NOT FIRST(af.sort-value) THEN
         DO ii = 8 TO 1 BY -1:
            /* Сравнение снизу тек. и предыд. иер. индекса.
            ** Если уровень иер.индекса изменился, то напечатать итог.
            */
            IF ENTRY(ii, prev-lst, ";") <> ENTRY(ii, af.sort-value, ";") AND
               ENTRY(ii, prev-lst, ";") <> "" THEN
            DO:
               PUT UNFORMATTED " " FILL("─", 178) SKIP.

               CASE in-sort:
                  WHEN "asset" THEN
                  FOR FIRST code WHERE
                            code.class = "asset"
                        AND code.code  = ENTRY(ii, prev-lst, ";")
                     NO-LOCK:
                     {a-strngs.i
                        &file = code
                        &a    = disc
                        &b    = qty
                        &c    = amor
                        &d    = over
                        &e    = rest
                     }
                  END.

                  WHEN "sub-u" THEN
                  FOR FIRST branch WHERE
                            branch.branch-id = ENTRY(ii, prev-lst, ";")
                     NO-LOCK:
                     {a-strngs.i
                        &file = branch
                        &a    = disc
                        &b    = qty
                        &c    = amor
                        &d    = over
                        &e    = rest
                     }
                  END.

                  WHEN "place" THEN
                  FOR FIRST code WHERE
                            code.class = "Место"
                        AND code.code  = ENTRY(ii, prev-lst, ";")
                     NO-LOCK:
                     {a-strngs.i
                        &file = code
                        &a    = disc
                        &b    = qty
                        &c    = amor
                        &d    = over
                        &e    = rest
                     }
                  END.
               END CASE.
            END.
         END.

         /* Печать заголовков разделов */
         DO ii = 1 TO 8:
            /* Сравнение сверху тек. и предыд. иер. индекса.
            ** Если уровень иер. индекса изменился, то напечатать заголовок.
            */
            IF ENTRY(ii, prev-lst, ";") <> ENTRY(ii, af.sort-value, ";") THEN
            DO:
               mGroupName = GetGroup-Name(ENTRY(ii, af.sort-value, ";")).

               IF mGroupName <> "" THEN
                  PUT UNFORMATTED SPACE(2 * ii) mGroupName SKIP.
            END.
         END.

         /* Обнулить стеки результатов для изменившихся уровней иерарх.индекса */
         DO ii = 1 TO 8:
            IF ENTRY(ii, prev-lst, ";") <> ENTRY(ii, af.sort-value, ";") THEN
            DO:
               DO WHILE ii <= 8:
                  ASSIGN
                     a-stack[ii] = 0
                     b-stack[ii] = 0
                     c-stack[ii] = 0
                     d-stack[ii] = 0
                     e-stack[ii] = 0
                     ii          = ii + 1.
               END.

               LEAVE.
            END.
         END.
      END.
      ELSE /* Печать заголовка раздела для групп без иерархии */
         PUT UNFORMATTED SKIP(1) " "
            GetGroupName()
         SKIP.

      /* Печать заголовка таблицы */
      REPEAT ii = 1 TO 5:
         PUT UNFORMATTED head1[ii] SKIP.
      END.
   END.

   DISPLAY                                   /* Печать строки таблицы        */
      af.inv-num
      af.name[1]
      af.date-make
      af.ser-num
      af.qty
      af.unit
      af.disc
      af.amor
      af.over
      af.rest
   WITH FRAME listx.

   DOWN WITH FRAME listx.
   
      DO mExt = 2 TO EXTENT(af.name):
      IF af.name[mExt] NE "" THEN DO:
         DISPLAY
            af.name[mExt] @ af.name[1]
         WITH FRAME listx.
         DOWN WITH FRAME listx.
      END.
   END.

   IF LAST-OF(af.sort-value) THEN
   DO:
      /* Итоги нижнего уровня группир. */
      ASSIGN
         sum1 = ACCUM TOTAL BY af.sort-value af.disc
         sum2 = ACCUM TOTAL BY af.sort-value af.qty
         sum3 = ACCUM TOTAL BY af.sort-value af.amor
         sum4 = ACCUM TOTAL BY af.sort-value af.over
         sum5 = ACCUM TOTAL BY af.sort-value af.rest.

      IF NOT ({&jer}) THEN
      DO: /* Печать итогов по группам без иерархии */
         PUT UNFORMATTED " " FILL("─", 178) SKIP.

         DISPLAY
            GetSubTitle() @ af.name[1]
            sum1          @ af.disc
            sum2          @ af.qty
            sum3          @ af.amor
            sum4          @ af.over
            sum5          @ af.rest
         WITH FRAME listx.

         DOWN WITH FRAME listx.
      END.
      ELSE
      DO:
         /* Накопление итогов в стеках результатов */
         DO ii = 1 TO 8:                   
            IF ENTRY(ii, af.sort-value, ";") <> "" THEN
               ASSIGN
                  a-stack[ii] = a-stack[ii] + sum1
                  b-stack[ii] = b-stack[ii] + sum2
                  c-stack[ii] = c-stack[ii] + sum3
                  d-stack[ii] = d-stack[ii] + sum4
                  e-stack[ii] = e-stack[ii] + sum5.
            ELSE
               LEAVE.
         END.

         prev-lst = af.sort-value.                  /* Переход к новой иерарх. группе         */
         if last(af.sort-value) then do:            /* Печать оконч. итогов для иерарх. групп */
           repeat ii = 8 to 1 by -1:           /* Проверка снизу уровней иер. индекса    */
             if entry(ii, prev-lst, ';') ne "" then do:     /* Если уровень не пуст, то  */
               if in-sort eq "asset" then do:
                 put unformatted " " fill("─", 178) skip.     /* напечатать итог           */
                 find first code where code.class eq "asset" and code.code eq entry(ii, prev-lst, ';') no-lock no-error.
                 {a-strngs.i &file=code &a=disc &b=qty &c=amor &d=over &e=rest}
               end.
               else if in-sort eq "sub-u" and entry(ii, prev-lst, ';') ne "Top" then do:
                 put unformatted " " fill("─", 178) skip.     /* напечатать итог           */
                 find first branch where branch.branch-id eq entry(ii, prev-lst, ';') no-lock no-error.
                 {a-strngs.i &file=branch &a=disc &b=qty &c=amor &d=over &e=rest}
               end.
               else if in-sort eq "place" then do:
                 put unformatted " " fill("─", 178) skip.     /* напечатать итог           */
                 find first code where code.class eq "Место" and code.code eq entry(ii, prev-lst, ';') no-lock no-error.
                 {a-strngs.i &file=code &a=disc &b=qty &c=amor &d=over &e=rest}
               end.
             end.
           end.
         end.
      END.

      if last(af.sort-value) then do:             /* Печать оконч. итогов по ведомости */
        put unformatted skip " " fill("─", 178).
          sum1 = accum total af.disc.
          sum2 = accum total af.qty.
          sum3 = accum total af.amor.
          sum4 = accum total af.over.
          sum5 = accum total af.rest.
        display
          "Итого по ведомости" @ af.name[1]
          sum1 @ af.disc
          sum2 @ af.qty
          sum3 @ af.amor
          sum4 @ af.over
          sum5 @ af.rest
        with frame listx .
        down with frame listx .
      end.
   END.
END. /* FOR EACH */

/* {signatur.i}*/
{signatur.i &user-only=yes}
{preview.i}