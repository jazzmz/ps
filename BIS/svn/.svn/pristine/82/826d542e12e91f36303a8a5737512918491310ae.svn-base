{pirsavelog.p}

/*
   КБ ПPОМИНВЕСТРАСЧЕТ

   04/03/06        Смета расходов

         Расчет в тысячах. обороты отбираются и группируются по счетам
         привязанным к классификатору "СтатьиСметыРасх". В значениях этого
         класс-ра указывается код формулы класса в котором хранятся плановые
         значения.
         Плановые значения хранятся ввиде формул класса "SmRashod".
         Плановые значения редактируются отдельной процедурой sm-plan.p .
         в принципе можно редактировать формулы на дату начала квартала ручками,
         но блин это геморойно...
              Есть еще маленькая процедурка sm-acct.p: она вытаскивает счета привязанные
         к классификатору. ну типа для контроля.

         [vk]
*/

{globals.i}
{ulib.i}

DEFINE VARIABLE in-year      as integer NO-UNDO.
DEFINE VARIABLE in-month     as integer NO-UNDO.
DEFINE VARIABLE in-kvartal   as logical extent 4 NO-UNDO.
DEFINE VARIABLE cT           as char NO-UNDO.
DEFINE VARIABLE cAcct        as char NO-UNDO.
DEFINE VARIABLE cCur         as char NO-UNDO.
DEFINE VARIABLE i            as integer NO-UNDO.
DEFINE VARIABLE j            as integer NO-UNDO.
DEFINE VARIABLE dmin         as date NO-UNDO. /* дата начала периода */
DEFINE VARIABLE dmax         as date NO-UNDO. /* дата конца периода  */
DEFINE VARIABLE m-name       as char NO-UNDO.
DEFINE VARIABLE m-value      as decimal NO-UNDO.
DEFINE VARIABLE galka        as logical initial true NO-UNDO.
DEFINE VARIABLE sm-header    as char NO-UNDO.
DEFINE VARIABLE sm-line      as char NO-UNDO.
DEFINE VARIABLE smeta        as char initial "SmRashod" NO-UNDO.
       /* класс данных в формулах, которого хранятся плановые значения. Плановое значение заводится
         как формула содержащая собственно значение на дату начала квартала.
         Дата начала действия формулы = дата начала квартала. */

{wordwrap.def}
DEFINE VARIABLE mName        as char    extent 5 NO-UNDO.
DEFINE VARIABLE mCount       as integer init 2 NO-UNDO.
DEFINE VARIABLE mlen         as integer init 0 NO-UNDO.
DEFINE VARIABLE iplan        as decimal format "->>>>>9" NO-UNDO.
DEFINE VARIABLE ireal        as decimal format "->>>>>9" NO-UNDO.
DEFINE VARIABLE sum-plan     as decimal format "->>>>>9" NO-UNDO.
DEFINE VARIABLE sum-real     as decimal format "->>>>>9" NO-UNDO.
DEFINE VARIABLE isum-plan    as decimal format "->>>>>9" NO-UNDO.
DEFINE VARIABLE isum-real    as decimal format "->>>>>9" NO-UNDO.
DEFINE VARIABLE ikod         as integer initial 0 format ">9" NO-UNDO.
DEFINE VARIABLE istr         as char    format "x(2)" NO-UNDO.

DEFINE temp-table ttRezult                 /* таблица результатов */
   field years as integer format "9999"
   field kvartal as integer format "9"
   field kod as char format "x(2)"
   field plan as decimal format "->>>>>9"
   field real as decimal format "->>>>>9".

DEFINE temp-table ttMain                   /* ну типа главная таблица результатов */
   field years as integer format "9999"
   field kvartal as integer format "9"
   field kod as char format "x(3)"
   field name as char format "x(40)".

ASSIGN
   in-year  = year(today)
   in-month = month(today)
   in-kvartal[1] = true
   in-kvartal[2] = (in-month GT 3)
   in-kvartal[3] = (in-month GT 6)
   in-kvartal[4] = (in-month GT 9)
.

FORM
   in-year
      AT 4  FORMAT "9999"      LABEL "Расчетный год"    HELP   "Номер расчетного года"
/*   galka
      AT 15 VIEW-AS TOGGLE-BOX LABEL "Расчет в тысячах" HELP   "Расчет в тысячах/рублях" */
      SKIP "Печать информации: " SKIP
   in-kvartal[1]
      AT 15 VIEW-AS TOGGLE-BOX LABEL "   I квартал"     HELP   "I квартал"
   in-kvartal[2]
      AT 15 VIEW-AS TOGGLE-BOX LABEL "  II квартал"     HELP  "II квартал"
   in-kvartal[3]
      AT 15 VIEW-AS TOGGLE-BOX LABEL " III квартал"     HELP "III квартал"
   in-kvartal[4]
      AT 15 VIEW-AS TOGGLE-BOX LABEL "  IV квартал"     HELP  "IV квартал"
   WITH FRAME frParam 2 COL OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ ПАРАМЕТРЫ РАСЧЕТА]".
/*
ON ENTER OF in-year
DO:
   if in-year < year(today)
   then do:
      in-kvartal[1] = true.
      in-kvartal[2] = true.
      in-kvartal[3] = true.
      in-kvartal[4] = true.
   end.

END.
*/
PAUSE 0.
UPDATE
   in-year
/*   galka */
   in-kvartal[1]
   in-kvartal[2]
   in-kvartal[3]
   in-kvartal[4]
   WITH FRAME frParam.

HIDE FRAME frParam NO-PAUSE.

IF NOT (   KEYFUNC(LASTKEY) EQ "GO"
        OR KEYFUNC(LASTKEY) EQ "RETURN")
THEN LEAVE.

{setdest.i}

/* расчет */

DO i = 1 to 4:
   if in-kvartal[i]
   then do:

      dmin = date((i - 1) * 3 + 1, 1, in-year).
      dmax = (if (i ne 4) then date(i * 3 + 1, 1, in-year )
                          else date(1, 1, in-year + 1)) - 1.

      /* Собираем значения в tt */
      for each code
         where code.class  = "СтатьиСметыРасх"
           and code.parent = "СтатьиСметыРасх"
         by code.code:

         m-name = code.name.
         m-value = 0.

         for each sign
            where sign.code        = code.class
              and sign.xattr-value = code.code
              and sign.file-name   = "acct"
            by substring(sign.surrogate, 1, 20):

            cAcct = substring(sign.surrogate, 1, 20).
            cCur  = substring(sign.surrogate, 6, 3).

            for each op-entry
               where op-entry.op-date >= dmin
                 and op-entry.op-date <= dmax
                 and op-entry.acct-db =  cAcct:

               m-value = m-value + op-entry.amt-rub.
            end.

            IF (code.code EQ "17")
            THEN DO:
               IF (i EQ 1)
               THEN DO:
                  m-value = m-value + GetAcctPosValue_UAL(cAcct, cCur, dmin - 1, NO).
               END.

               for each op-entry
                  where op-entry.op-date >= dmin
                    and op-entry.op-date <= dmax
                    and op-entry.acct-cr =  cAcct:

                  m-value = m-value - op-entry.amt-rub.
               end.
            END.

         end.
/*       put unformatted code.code space
             string (m-name,"x(40)") space
             string(m-value,"->>>>>>>>9.99") skip. */

         find first ttmain
            where /* ttmain.years  = in-year and 
                  ttmain.kvartal = i */
                  ttmain.kod  = code.code
              and ttmain.name = code.name
            no-error.

         if not avail ttmain
         then do:

            create ttmain.
            assign
/*             ttmain.years   = in-year
               ttmain.kvartal = i
*/
               ttmain.kod     = code.code
               ttmain.name    = code.name
            .
/*           update ttMain.     */
         end. /* if not avail ttmain */

         create ttRezult.
         ttRezult.years   = in-year.
         ttRezult.kvartal = i.
         ttRezult.kod     = code.code.

         find first formula
            where formula.DataClass-id = smeta
              and formula.var-id       = code.val
              and formula.since        = dmin
            no-error.

         IF AVAIL formula
         THEN do:
            ttRezult.plan = integer(substring(formula.formula, 1, length(formula.formula) - 1)) no-error.
            if error-status:error
            then message "ФОРМУЛА ДОЛЖНА СОДЕРЖАТЬ ТОЛЬКО ЦИФРОВОЕ ЗНАЧЕНИЕ ПОКАЗАТЕЛЯ!!!"
                         view-as alert-box.
         end.
         else do:
/*          message "Незаведены плановые значения для " code.name view-as alert-box. */
            ttRezult.plan = 0.
         end.

         ttRezult.real = round((m-value / 1000),0).
/*       update ttRezult.   */
      end. /* for each code */
   end. /* if in-kvartal[i] */
END. /* do i = 1 to 4: */

/* выводим заголовок сметы */

mName[1] = ttmain.name.
{wordwrap.i
   &s = mName
   &l = 40
   &n = 5
}

mlen = 45 + 16.
DO i = 1 to 4:
   if in-kvartal[i]
   then mlen = mlen + 16.
end.

put unformatted space(round((mlen - 26 ) / 2, 0)) "СМЕТА РАСХОДОВ НА " string(in-year,"9999") " ГОД" skip.
put unformatted space(round((mlen - 26 + 10 ) / 2, 0)) "В ТЫСЯЧАХ РУБЛЕЙ." skip(2).

sm-header = "                                            ".
DO i = 1 to 4:
   if in-kvartal[i]
   then sm-header = sm-header + "    " + string(i,"9") + " КВАРТАЛ   ".  /* + " " +
                    string(in-year,"9999") +  "г" .                                              */
end.
put unformatted sm-header  "    И Т О Г О   " skip.
sm-header = "  NN" + "            НАИМЕНОВАНИЕ                  ".
DO i = 1 to 4:
   if in-kvartal[i]
   then sm-header = sm-header + " " + "  ПЛАН    ФАКТ ".
end.
put unformatted sm-header "   ПЛАН    ФАКТ" skip.

sm-header = " ---" + " ----------------------------------------".
DO i = 1 to 4:
   if in-kvartal[i]
   then sm-header = sm-header + " " + "------- -------".
end.
put unformatted sm-header  " ------- -------"skip.

/* выводим смету */

FOR EACH ttmain
   by ttmain.kvartal
   by ttmain.kod:

   /*  put  " " ttmain.kod space. */
   ikod = ikod + 1.
   istr = string(ikod,"99").
   put  " " ttmain.kod  space. /* вместо кода выводим порядковый номер а не код.
                                  чтобы в классификатор можно было вставить запись */
   mName[1] = ttmain.name.

   {wordwrap.i
      &s = mName
      &l = 40
      &n = 5
   }

   put unformatted string(mname[1], "x(40)") space.
   iplan = 0.
   ireal = 0.

   FOR EACH ttrezult
      WHERE ttrezult.kod EQ ttmain.kod
      by ttrezult.kvartal:

      put ttrezult.plan space
          ttrezult.real space.
      iplan = iplan + ttrezult.plan.
      ireal = ireal + ttrezult.real.
   END.

   put iplan space
       ireal skip.
   isum-plan = isum-plan + iplan.
   isum-real = isum-real + ireal.

   DO WHILE (mName[mCount] NE ""):
      PUT UNFORMATTED "     " string(mName[mCount], "x(40)") skip.
      mCount = mCount + 1.
   END.

   mCount = 2.
end.

/* выводим итоги по столбцам */
sm-header = " ---" + " ----------------------------------------".
DO i = 1 to 4: 
   if in-kvartal[i]
   then sm-header = sm-header + " " + "------- -------".
end.
put unformatted sm-header  " ------- -------"skip.

Put Unformatted "                                   И Т О Г О:" .

DO i = 1 to 4:
   sum-plan = 0.
   sum-real = 0.

   if in-kvartal[i]
   then do:

      for each ttrezult
      where ttrezult.kvartal = i
      by ttrezult.kvartal:

         sum-plan = sum-plan + ttrezult.plan.
         sum-real = sum-real + ttrezult.real.
      end.
      put space sum-plan space sum-real.
   end.
end.
put space isum-plan space isum-real skip(3).

{signatur.i  &user-only = yes}
{preview.i}
