{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-replg.p,v $ $Revision: 1.13 $ $Date: 2010-09-01 13:29:40 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Причина       : ТЗ от 10.09.2007, Отдел противодействия легализации доходов, Утина В.А
Назначение    : Ведомость средних оборотов по клиентам, превышающим пороговые соотношения
Место запуска : БМ/Печать/Отчеты по лицевым счетам/Оборотно-сальдовые ведомости/Обор.сальд. ведомость, с превышением соотношения оборотов
Автор         : $Author: borisov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.12  2009/08/10 08:42:29  maslov
Изменения     : Dobavil kol. 'Ustavnoi Rfpital' po pros`be Gamana
Изменения     :
Изменения     : Revision 1.11  2008/02/18 09:50:53  kuntash
Изменения     : dorabotka kapitala
Изменения     :
Изменения     : Revision 1.10  2008/02/02 07:41:10  kuntash
Изменения     : uvelichenie znakov
Изменения     :
Изменения     : Revision 1.9  2007/10/18 07:42:21  anisimov
Изменения     : no message
Изменения     :
Изменения     : Revision 1.8  2007/10/09 11:17:54  kuntash
Изменения     : dorabotka po dnuam
Изменения     :
Изменения     : Revision 1.7  2007/10/05 07:45:41  kuntash
Изменения     : ╨┤╨╛╤А╨░╨▒╨╛╤В╨░╨╜
Изменения     :
Изменения     : Revision 1.7  2007/10/05 11:42:30  kuntash
Изменения     : Изменение условий параметров turn-ratio и interval-ratio в условии при отборе поменял местами
Изменения     : 
Изменения     : Revision 1.6  2007/09/28 07:52:30  lavrinenko
Изменения     : Исправление толкования порогга оборотом 
Изменения     :
Изменения     : Revision 1.5  2007/09/25 13:56:51  Lavrinenko
Изменения     : Доработки по требованию - приложение к записке@
Изменения     :
Изменения     : Revision 1.4  2007/09/20 09:15:19  Lavrinenko
Изменения     : Переделан расчет средних значений, добавлен порог по отношению остатка к дб оборот
Изменения     : у@
Изменения     :
Изменения     : Revision 1.3  2007/09/20 06:09:48  lavrinenko
Изменения     : Доработки по просьбе борцов за легализацию
Изменения     :
Изменения     : Revision 1.2  2007/09/14 07:26:46  lavrinenko
Изменения     : *** empty log message ***
Изменения     :
Изменения     : Revision 1.1  2007/09/14 07:15:03  lavrinenko
Изменения     : ведомость средних оборотов за период
Изменения     :
------------------------------------------------------ */
{globals.i}
{chkacces.i}
{sh-defs.i}
{zo-defs.i}
{sh-temp.i new}
{wordwrap.def}
{avrg.pro}

{ifndef {&format}}
   &GLOB format ->>>,>>>,>>>,>>9.99
{endif} */

DEFINE VAR Capital         AS   DECIMAL FORMAT "{&format}" NO-UNDO.
DEFINE VAR cCapital        AS   CHAR    NO-UNDO.
DEFINE VAR vAvgbal         AS   DECIMAL NO-UNDO.
DEFINE VAR date-inter      AS   INTEGER NO-UNDO.
DEFINE VAR day-counter     AS   INTEGER NO-UNDO.
DEFINE VAR iLen            AS   INTEGER NO-UNDO.
DEFINE VAR iK              AS   INTEGER NO-UNDO.
DEFINE VAR I               AS   DATE    NO-UNDO.
DEFINE VAR lNoAcct         AS   LOGICAL INIT YES NO-UNDO.
DEFINE VAR long-acct       AS   CHAR             FORMAT "x(25)"           COLUMN-LABEL "ЛИЦЕВОЙ СЧЕТ"       NO-UNDO.
DEFINE VAR name            AS   CHAR             FORMAT "x(35)" EXTENT 10 COLUMN-LABEL "НАИМЕНОВАНИЕ"       NO-UNDO.
DEFINE VAR avg-db          LIKE op-entry.amt-rub FORMAT "{&format}"                                         NO-UNDO.
DEFINE VAR avg-cr          LIKE op-entry.amt-rub FORMAT "{&format}"                                         NO-UNDO.
DEFINE VAR min-capital     LIKE op-entry.amt-rub FORMAT "{&format}" LABEL "КАПИТАЛ ДО"       INITIAL  50000 NO-UNDO.
DEFINE VAR max-turn        LIKE op-entry.amt-rub FORMAT "{&format}" LABEL "ОБОРОТ ОТ"        INITIAL 600000 NO-UNDO.
DEFINE VAR turn-ratio      AS   DECIMAL          FORMAT "999.99"    LABEL "СОТНОШ. ОБОРОТОВ" INITIAL     80 NO-UNDO.
DEFINE VAR interval-ratio  AS   DECIMAL          FORMAT "999.99"    LABEL "ОСТАТОК/ОБОРОТ  " INITIAL     80 NO-UNDO.
DEFINE VAR day-ratio       AS   DECIMAL          FORMAT "999.99"    LABEL "ДНЕЙ/ПЕРИОД  "    INITIAL     80 NO-UNDO.

DEFINE TEMP-TABLE tt-Acct  NO-UNDO
   FIELD fAcct       LIKE acct.acct
   FIELD fIn-bal     LIKE acct-pos.balance
   FIELD Fdb         LIKE acct-pos.debit
   FIELD fcr         LIKE acct-pos.credit
   FIELD fbal        LIKE acct-pos.balance
   FIELD fAvgbal     LIKE acct-pos.balance
   FIELD fratio      LIKE turn-ratio
   FIELD fratioRest  LIKE turn-ratio
   FIELD ustavfond   LIKE Capital
   INDEX iAcct       IS UNIQUE PRIMARY  fAcct
   INDEX iturn Fdb Fcr DESCENDING
   INDEX iRatio fratio DESCENDING fratioRest DESCENDING
.

DEFINE BUFFER bacct FOR acct.

{getdates.i}

PAUSE 0.
DO ON ERROR UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE
   WITH FRAME capitalframe:

   UPDATE
      min-capital    HELP "Введите минимальное значение капитала"
      max-turn       HELP "Введите минимальный средний оборот по дебету или кредиту"
      interval-ratio HELP "Введите максимальное соотношение остатка и дебетового оборота"
      turn-ratio     HELP "Введите допустимое соотношение кредитового и дебетового оборота"
      day-ratio      HELP "Введите допустимое соотношение дней к общему периоду"
      WITH CENTERED ROW 10 OVERLAY SIDE-LABELS  1 COL
      COLOR messages TITLE "[ ЗАДАЙТЕ КАПИТАЛ]"
   .
END.

HIDE FRAME capitalframe NO-PAUSE.

IF keyfunc(LASTKEY) EQ "end-error"
THEN RETURN.

IF    min-capital EQ ?
   OR turn-ratio  EQ ?
THEN DO:
   MESSAGE "НЕ ЗАДАНЫ ПАРАМЕТРЫ РАСЧЕТА !" VIEW-AS ALERT-BOX.
   RETURN.
END.

{get-fmt.i &obj=b-Acct-Fmt}
{empty tt-Acct}
 
{justamin}
{setdest.i &cols="230"}

date-inter = end-date - beg-date.

FOR EACH cust-corp
   NO-LOCK,
   FIRST acct
      WHERE acct.cust-cat EQ 'Ю'
        AND acct.cust-id  EQ cust-corp.cust-id
        AND (acct.close-date EQ ?
          OR acct.close-date GE beg-date
         AND acct.open-date  LE end-date)
   NO-LOCK:

   cCapital = GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "УставКап").
   cCapital = REPLACE(cCapital, "-", ".").
   cCapital = REPLACE(cCapital, ",", ".").
   iLen = LENGTH(cCapital).
   iK   = 1.

   DO WHILE (iK LE iLen):
      CASE SUBSTRING(cCapital, iK, 1):
         WHEN "0" OR WHEN "1" OR WHEN "2" OR WHEN "3" OR WHEN "4" OR WHEN "5"
                  OR WHEN "6" OR WHEN "7" OR WHEN "8" OR WHEN "9" OR WHEN "."
         THEN iK = iK + 1.
         WHEN "/" THEN DO:
            cCapital = SUBSTRING(cCapital, 1, iK - 1).
            iLen     = iK - 1.
         END.
         OTHERWISE DO:
            SUBSTRING(cCapital, iK, 1) = "".
            iLen = iLen - 1.
         END.
      END CASE.
   END.

/*
   cCapital = REPLACE(cCapital, "рубле", "").
   cCapital = REPLACE(cCapital, "=", "").
   cCapital = REPLACE(cCapital, ";", "").
   cCapital = REPLACE(cCapital, " ", "").
*/
   Capital  = DECIMAL(cCapital) NO-ERROR.

   IF (ERROR-STATUS:ERROR)
   THEN MESSAGE cust-corp.name-short + " - УставКап = " + 
      GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "УставКап") SKIP Capital
      VIEW-AS ALERT-BOX QUESTION BUTTONS OK.

   IF    cCapital EQ ""
      OR Capital  LE min-capital
   THEN
      FOR EACH bacct
         WHERE bacct.cust-cat   EQ 'Ю'
           AND bacct.cust-id    EQ cust-corp.cust-id
           AND CAN-DO("3*,40*", bacct.acct)
           AND (bacct.close-date EQ ?
             OR bacct.close-date GE beg-date
            AND bacct.open-date  LE end-date)
         NO-LOCK:

         {on-esc RETURN}
         {empty sh}

         vAvgbal = clc-avrg(bacct.acct, bacct.curr, beg-date, end-date, ?, NO).

         IF     ABS(vAvgbal / (sh-db / date-inter)  * 100) LE interval-ratio
            AND ABS(sh-cr / sh-db * 100) GE turn-ratio
            AND (sh-db / date-inter GE max-turn
            AND  sh-cr / date-inter GE max-turn)
         THEN DO:

            day-counter = 0.
            DO I = beg-date TO end-date:
               run acct-pos in h_base (bacct.acct,bacct.curr,i,i,gop-status).
               IF ROUND(ABS(sh-bal / sh-db * 100),2) LE interval-ratio
               THEN day-counter = day-counter + 1.

 /*            message "Ok2" sh-bal sh-db ROUND(ABS(sh-bal / sh-db * 100),2) day-counter. pause.*/
            END.

            IF ABS (day-counter * 100 / date-inter) GE day-ratio
            THEN DO:

               vAvgbal = clc-avrg(bacct.acct, bacct.curr, beg-date, end-date, ?, NO).
               CREATE tt-Acct.
               ASSIGN
                  tt-acct.fAcct      = bacct.acct
                  tt-acct.fIn-bal    = ABS(sh-in-bal) 
                  tt-acct.Fdb        = ABS(sh-db)
                  tt-acct.fcr        = ABS(sh-cr)
                  tt-acct.fbal       = ABS(sh-bal)
                  tt-acct.fRatio     = ROUND(ABS(sh-cr / sh-db * 100),2)
                  tt-acct.fAvgbal    = ABS(vAvgbal)
                  tt-acct.fRatioRest = ROUND(ABS((tt-acct.fAvgbal / (tt-Acct.Fdb / date-inter)) * 100), 2)
                  tt-acct.ustavfond  = Capital
               .
            END.
         END. /* IF ((sh-cr / sh-db) GE turn-ratio  */
      END. /* FOR EACH bacct WHERE bacct.cust-cat   EQ 'Ю' AND  */
END. /* FOR EACH acct WHERE CAN-DO('Ю,Ч',acct.cust-cat) */

FOR EACH tt-Acct
   NO-LOCK,
   FIRST acct
      WHERE acct.acct EQ tt-acct.facct
   NO-LOCK 
   BY tt-acct.fratio DESCENDING
   BY tt-Acct.fratioRest
   ON ENDKEY UNDO, LEAVE:

   FORM  long-acct
      NAME[1]
      tt-acct.ustavfond   COLUMN-LABEL "УСТАВНОЙ!КАПИТАЛ/ФОНД"        FORMAT "{&format}"
      tt-Acct.Fdb         COLUMN-LABEL "ОБОРОТ ПО ДЕБЕТУ"             FORMAT "{&format}"
      tt-Acct.fcr         COLUMN-LABEL "ОБОРОТ ПО КРЕДИТУ"            FORMAT "{&format}"
      avg-db              COLUMN-LABEL "СРЕДНИЙ!ОБОРОТ ПО ДЕБЕТУ"     FORMAT "{&format}"
      avg-cr              COLUMN-LABEL "СРЕДНИЙ!ОБОРОТ ПО КРЕДИТУ"    FORMAT "{&format}"
      tt-Acct.fAvgbal     COLUMN-LABEL "СРЕДНИЙ!ОСТАТОК"              FORMAT "{&format}"
      tt-Acct.fratioRest  COLUMN-LABEL "СООТНОШЕНИЕ СР.ОСТАТОКА!К СР.ОБОРОТУ ПО ДЕБЕТУ" FORMAT "{&format}"
      tt-acct.fratio      COLUMN-LABEL "СООТНОШЕНИЕ!ОБОРОТОВ ПО КР. И ДБ."              FORMAT "{&format}"
      HEADER  CAPS(name-bank) FORMAT "x(70)" SKIP
         "ОБОРОТНО-САЛЬДОВАЯ ВЕДОМОСТЬ ЗА " + CAPS({term2str Beg-Date End-Date})  FORMAT "x(69)"
      SKIP(2)
      WITH NO-BOX WIDTH 400.

   lNoAcct = NO.

   {getcust.i &name="name" &offinn="/*"}
   name[1] = TRIM(name[1] + " " + name[2]).
   {wordwrap.i &s=name &l=35 &n=10}

   DISPLAY
      {out-fmt.i tt-Acct.facct fmt} @ long-acct
      NAME[1]
      tt-acct.ustavfond
      tt-acct.Fdb
      tt-acct.Fcr
      tt-acct.Fdb / date-inter @ avg-db
      tt-acct.Fcr / date-inter @ avg-cr
      tt-Acct.fAvgbal
      tt-Acct.fratioRest
      tt-acct.fratio
   .
END.

IF lNoAcct
THEN DO:
   FORM  long-acct
      HEADER  CAPS(name-bank) FORMAT "x(70)" SKIP
         "ОБОРОТНО-САЛЬДОВАЯ ВЕДОМОСТЬ ЗА " + CAPS({term2str Beg-Date End-Date})  FORMAT "x(69)"
      SKIP(2)
      WITH NO-BOX WIDTH 400.

   DISPLAY ""
   .
   PUT UNFORMATTED SKIP
      "За указанный период счетов, удовлетворяющих параметрам запроса, не выявлено." SKIP.
END.

{preview.i}
{pir-log.i &module="$RCSfile: pir-replg.p,v $"
           &comment="Ведомость средних оборотов по клиентам, превышающим пороговые соотношения"}
