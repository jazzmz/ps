/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1997 ТОО "Банковские информационные системы"
     Filename: genpos.i
      Comment: оборотно-сальдовая ведомость в рублях и валюте
   Parameters: см. ниже
         Uses: genpos.*, etc.
      Used BY: many
      Created: 08/02/95   smbd
     Modified: 30/04/96   Serge
     Modified: 05/08/96   Serge сумма по валютам
     Modified: 10/03/97   Serge flag-ZO
     Modified: 16.06.97   Andr показ gop-status
     Modified: 31/07/97   Serge показ lastcurr вместо lastmove для
                          валютных счетов
     Modified: 01/08/97   Kostik_B переход к новой кодировке валют.
     Modified: 25/12/98   Serge merge & kazakh.ver
     Modified: 12/11/2001 Николай Белов. Исключены интерактивные запросы
                          пользователя и создание выходного файла и просмотр
                          результата.
     Modified: 19/09/2001 Olenka Добавлены подитоги по счетам 1 порядка
     Modified: 26/02/2003 KAVI добавлена группировка по коду ЦБ, подитоги
                          и исключил общий итог в случае выбора всех счетов
     Modified: 12.03.2003 KAVI убрал группировку group, т.к. с ней нельзя
                          гарантировать корректность результата
                          для программ, использующих этот файл, входные
                          параметры всегда должны иметь указанные значения:
                          groupbybalacct1 =BY SUBSTR(STRING(acct.bal-acct),1,3)
                          groupbyuser     =BY acct.user-id
                          acct.currency   =BY acct.currency

                          установлен порядок группировок
                          [code.code|total]
                             [acct.user-id][acct.currency]
                             [STRING(acct.bal-acct),1,3]
                                 [acct.bal-acct]
     Modified: 23/05/2003 Gunk Добавил Входной параметр "Исключаемые балансовые
                          счета". По умолчанию - НП "

надо исправить ошибочное создание подитогов в случае, когда
  нет разбора по валютам и валюта не одна
*/
FORM "~n@(#) genpos.i 1.5 smbd 08/02/95 Serge 10/03/97 оборотно-сальдовая ведомость в рублях и валюте"
WITH FRAME sccs-id STREAM-IO WIDTH 250.

/*
внутри спрашивает дату/даты, обработку нулей, диапазон оборотов
выбор счетов - через &addwhere и &recids
группировка - по б/с, исполнителям и валюте

{genpos.i
    &title=""               - заголовок формы
    &addwhere=""            - дополнительное условие выборки
    &recids=yes             - ручной выбор счетов
    &persons=yes            - выбор счетов через клиентов
    &groupbyuser="by acct.user-id "  - группировка по исполнителям
    &byturn=yes             - отбор по оборотам

    &names=yes              - показывать наименования счетов
    &lastmove=yes           - показывать дату посл. движения
    &opendate=yes           - показывать дату открытия счета

    &incoming=yes           - показывать входящие остатки
    &turnover=yes           - показывать обороты
    &outgoing=yes           - не показывать исходящие остатки
    &thousands=yes          - показывать суммы в тысячах
    &format=<format>        - формат сумм

    &curin=yes              - показывать входящие валютные остатки
    &curturn=yes            - показывать валютные обороты
    &curout=yes             - показывать исходящие валютные остатки
    &curformat=<format>     - формат валютных сумм
    &gopstatus=yes          - показывать gop-status

    &parDateEnd=20.02.2003 11:39      - дата начала формирования отчета
    &parDateBeg=20.02.2003 11:39      - дата окончания формирования отчета
    &setzerozo=yes          - установить подавление нулей и строк и
                              ZO по умолчанию
    &destalready=yes        - не включать {setdest.i} и {preview.i}
    &no-list=yes            - не выводить номера страниц
    &mask-acct=<маска>      - маска счетов
todo:
    &groupbycur="by acct.currency " - группировка по валютам
    &groupbybalacct1=" BY substr(string(acct.bal-acct),1,3) " - подитоги
                                                     по счетам 1 порядка
}
*/

{globals.i}
{chkacces.i}
{sh-defs.i}
{wordwrap.def}

DEF VAR mAllwaysHeader AS LOGICAL INIT NO NO-UNDO.

&IF DEFINED (nobalacctmask) EQ 0 &THEN
DEFINE INPUT  PARAMETER iBalAcctMask AS CHARACTER  NO-UNDO.

IF NUM-ENTRIES(iBalAcctMask) EQ 2 THEN
   ASSIGN mAllwaysHeader = ENTRY(2, iBalAcctMask) EQ "Да".
          iBalAcctMask   = ENTRY(1, iBalAcctMask)
   .
IF iBalAcctMask EQ "" THEN
   iBalAcctMask = fGetSetting ("Отчеты","ВедБалСчета","!*").
&ENDIF

DEF VAR mAllContract AS LOG NO-UNDO. /*чтобы в цикле вычислений не делать*/

DEF VAR long-acct AS   CHAR FORMAT "x(25)" COLUMN-LABEL "ЛИЦЕВОЙ СЧЕТ" NO-UNDO.
DEF VAR units     AS   DECIMAL INITIAL 1 NO-UNDO.
DEF VAR cols      AS   INT NO-UNDO.
DEF VAR slash     AS   CHAR FORM "x" NO-UNDO.
DEF VAR name      AS   CHAR FORMAT "x(35)" EXTENT 10
                       COLUMN-LABEL "НАИМЕНОВАНИЕ" NO-UNDO.
DEF VAR new-cur   LIKE op-entry.currency INITIAL "" NO-UNDO.
DEF VAR mdtBegDate AS DATE NO-UNDO.
DEF VAR mdtEndDate AS DATE NO-UNDO.

def var min-turn like op-entry.amt-rub form ">>>,>>>,>>>,>>>,>>9.99" initial 0.01 no-undo.
def var max-turn like op-entry.amt-rub form ">>>,>>>,>>>,>>>,>>9.99" initial 999999999999999.99 no-undo.


{ifndef {&curformat}}
   &GLOB curformat ->>>,>>>,>>>,>>9.99
{endif} */

{ifndef {&format}}
   &GLOB FORMAT ->>>,>>>,>>>,>>9.99
{endif} */

DEF VAR prevposbal-db  LIKE acct-pos.balance NO-UNDO.
DEF VAR prevposbal-cr  LIKE acct-pos.balance NO-UNDO.
DEF VAR prevcurbal-db  LIKE acct-pos.balance NO-UNDO.
DEF VAR prevcurbal-cr  LIKE acct-pos.balance NO-UNDO.
DEF VAR acct-posbal-db LIKE acct-pos.balance NO-UNDO.
DEF VAR acct-posbal-cr LIKE acct-pos.balance NO-UNDO.
DEF VAR acct-curbal-db LIKE acct-pos.balance NO-UNDO.
DEF VAR acct-curbal-cr LIKE acct-pos.balance NO-UNDO.

DEF VAR mCharAcctCurr  AS CHAR EXTENT 5 NO-UNDO INITIAL "?".
DEF VAR mIntAcctCurr   AS INT  EXTENT 5 NO-UNDO INITIAL 0.
DEF VAR mInt           AS INT           NO-UNDO.

ASSIGN cols = 29 + 1
   {ifdef {&incoming}} + LENGTH(" {&format}") * 2 {endif} */
   {ifdef {&turnover}} + LENGTH(" {&format}") * 2 {endif} */
   {ifdef {&outgoing}} + LENGTH(" {&format}") * 2 {endif} */
   {ifdef {&curin}}    + LENGTH(" {&curformat}") * 2 {endif} */
   {ifdef {&curturn}}  + LENGTH(" {&curformat}") * 2 {endif} */
   {ifdef {&curout}}   + LENGTH(" {&curformat}") * 2 {endif} */
   {ifdef {&lastmove}} +  9 {endif} */
   {ifdef {&opendate}} +  9 {endif} */
   {ifdef {&names}}    + 36 {endif} */
   .

{ifdef {&thousands}} units = 1000. {endif} */

{ifdef {&groupbycur}}
   RELEASE currency.
   RELEASE sec-code.
{endif} */

&IF DEFINED(turnover)       NE 0 OR
   DEFINED(curturn)         NE 0 &THEN
   &IF DEFINED(parDateEnd)     NE 0 AND
      DEFINED(parDateBeg)      NE 0 &THEN
      beg-date = {&parDateBeg}.
      end-date = {&parDateEnd}.
   &ELSE
      {getdates.i}
   &ENDIF
&ELSEIF DEFINED(parDateEnd) NE 0 &THEN
   beg-date = {&parDateEnd}.
   end-date = beg-date.
&ELSE
   {getdate.i}
   beg-date = end-date.
&ENDIF

ASSIGN /* что бы нижевызываемыми справочниками не терлось */ 
   mdtBegDate = beg-date
   mdtEndDate = end-date
.

&GLOB nodef-list-id YES
&IF DEFINED(persons)      NE 0 &THEN
   DEF NEW SHARED VAR list-id AS CHAR INITIAL "*" NO-UNDO.
   {tempcust.i {&*}}
&ELSEIF DEFINED(recids)   NE 0 &THEN
   DEF NEW SHARED VAR list-id AS CHAR INITIAL "*" NO-UNDO.
   {tempacct.i {&*}}
&ELSEIF DEFINED(nobalcur) EQ 0 &THEN
   {getuser.i}
   {getbac.i}
   DEF VAR i AS INT NO-UNDO.
&ELSE
   DEF NEW SHARED VAR list-id AS CHAR INITIAL "*" NO-UNDO.
   DEF VAR i AS INT NO-UNDO.
&ENDIF

ASSIGN /* что бы вышевызываемыми справочниками не терлось */
   beg-date = mdtBegDate
   end-date = mdtEndDate
.

&IF DEFINED(setzerozo) NE 0 &THEN
   DEF VAR zerospace AS LOGICAL INITIAL NO  NO-UNDO.
   DEF VAR zeroskip  AS LOGICAL INITIAL NO  NO-UNDO.
   DEF VAR zo        AS INT                 NO-UNDO.

   zo = IF end-date EQ DATE(12,31,YEAR(end-date)) AND
           beg-date EQ DATE(1,1,YEAR(end-date)) THEN
           1
        ELSE
           3.
&ELSE
   {getzerzo.i {&*}}
&ENDIF

&IF DEFINED(destalready) EQ 0 &THEN
   {setdest.i &cols=" + cols"}
&ENDIF

/*если "все", то in-acct-cat - пустое*/
/*надо брать code, т.к. нужна сортировка по code.val и code.code*/
   mAllContract = NO.
&IF DEFINED(nobalcur) EQ 0 &THEN
   IF in-acct-cat         EQ ? OR
      STRING(in-acct-cat) EQ "" THEN
      mAllContract = YES.
&ENDIF


   FOR EACH code WHERE
            code.class      EQ "acct-cat"
&IF DEFINED(nobalcur) EQ 0 &THEN
                                                   AND
            code.code       BEGINS in-acct-cat
&ENDIF NO-LOCK,
&IF DEFINED(recids)  NE 0 OR
    DEFINED(persons) NE 0 &THEN
       EACH tmprecid,
       FIRST acct WHERE
             RECID(acct)    EQ tmprecid.id          AND
             acct.acct-cat  EQ code.code
&ELSE
       EACH acct  WHERE
             acct.acct-cat  EQ code.code            AND
      &IF DEFINED(nobalcur) EQ 0 &THEN
            CAN-DO(bac, STRING(acct.bal-acct))      AND
            CAN-DO(cur, acct.currency)              AND
      &ENDIF
      &IF DEFINED(parBranchID) &THEN
            acct.branch-id  EQ {&parBranchID}       AND
      &ENDIF
      &IF DEFINED(mask-acct)   &THEN
          CAN-DO({&mask-acct},acct.acct)            AND
      &ENDIF
           (acct.close-date EQ ? OR
            acct.close-date
              {ifdef {&turnover} {&curturn}} GE beg-date
              {else} */ > end-date {endif} */)      AND
            acct.open-date  LE end-date
            {&addwhere}                             AND
            acct.user-id    BEGINS access           AND
            CAN-DO(list-id,acct.user-id)
&ENDIF
          NO-LOCK

      BREAK
         BY code.val
         BY code.code
         {&groupbyuser}
         {&groupbycur}
         {&groupbybalacct1}
         BY acct.bal-acct
         BY SUBSTR(acct.acct,10)
         BY acct.currency
      ON ENDKEY UNDO, LEAVE:

   {on-esc RETURN}

/*начало описания формы*/
   FORM             long-acct /*space(0)
                    slash no-label space(0)*/
                    acct.currency

{ifdef {&curin}}    prevcurbal-db
                    COLUMN-LABEL "ВХ. ОСТАТОК!В ВАЛЮТЕ (АКТИВ)"
                    FORMAT "{&curformat}" {endif} */
{ifdef {&curin}}    prevcurbal-cr
                    COLUMN-LABEL "ВХ. ОСТАТОК!В ВАЛЮТЕ (ПАССИВ)"
                    FORMAT "{&curformat}" {endif} */

{ifdef {&incoming}} prevposbal-db
                    COLUMN-LABEL "ВХ. ОСТАТОК!В {&in-up-C1} (АКТИВ)"
                    FORMAT "{&format}"    {endif} */
{ifdef {&incoming}} prevposbal-cr
                    COLUMN-LABEL "ВХ. ОСТАТОК!В {&in-up-C1} (ПАССИВ)"
                    FORMAT "{&format}"    {endif} */

{ifdef {&curturn}}  acct-cur.debit
                    COLUMN-LABEL "ОБОРОТЫ!В ВАЛЮТЕ (ДЕБЕТ)"
                    FORMAT "{&curformat}" {endif} */
{ifdef {&curturn}}  acct-cur.credit
                    COLUMN-LABEL "ОБОРОТЫ!В ВАЛЮТЕ (КРЕДИТ)"
                    FORMAT "{&curformat}" {endif} */

{ifdef {&turnover}} acct-pos.debit
                    COLUMN-LABEL "ОБОРОТЫ!В {&in-up-C1} (ДЕБЕТ)"
                    FORMAT "{&format}"    {endif} */
{ifdef {&turnover}} acct-pos.credit
                    COLUMN-LABEL "ОБОРОТЫ!В {&in-up-C1} (КРЕДИТ)"
                    FORMAT "{&format}"    {endif} */

{ifdef {&curout}}   acct-curbal-db
                    COLUMN-LABEL "ИСХ. ОСТАТОК!В ВАЛЮТЕ (АКТИВ)"
                    FORMAT "{&curformat}" {endif} */
{ifdef {&curout}}   acct-curbal-cr
                    COLUMN-LABEL "ИСХ. ОСТАТОК!В ВАЛЮТЕ (ПАССИВ)"
                    FORMAT "{&curformat}" {endif} */

{ifdef {&outgoing}} acct-posbal-db
                    COLUMN-LABEL "ИСХ. ОСТАТОК!В {&in-up-C1} (АКТИВ)"
                    FORMAT "{&format}"    {endif} */
{ifdef {&outgoing}} acct-posbal-cr
                    COLUMN-LABEL "ИСХ. ОСТАТОК!В {&in-up-C1} (ПАССИВ)"
                    FORMAT "{&format}"    {endif} */

{ifdef {&lastmove}} lastmove
                    COLUMN-LABEL "ДПД" {endif}
                    FORMAT "99/99/99" */
{ifdef {&names}}    NAME[1]        {endif} */
{ifdef {&opendate}} acct.open-date
                    FORMAT "99/99/99" {endif} */

      HEADER  CAPS(name-bank) FORMAT "x(70)" SKIP

{ifdef {&title}}    "{&title}"
{else} */
&IF DEFINED(turnover) NE 0 OR
    DEFINED(curturn)  NE 0 &THEN
                 "ОБОРОТНО-САЛЬДОВАЯ ВЕДОМОСТЬ ЗА "
&ELSE
                 "ВЕДОМОСТЬ ОСТАТКОВ ЗА "
&ENDIF
                 + CAPS({term2str Beg-Date End-Date})
                 + (IF flag-zo THEN
                       " (ВКЛЮЧАЯ ЗО)"
                    ELSE IF flag-zo = ? THEN
                       " (ТОЛЬКО ЗО)"
                    ELSE
                       "")
&IF DEFINED(thousands) NE 0 &THEN
                 + " ({&in-UA-1000NCN})"
&ENDIF
              FORMAT "x(69)"
{endif} */
&IF DEFINED(no-list) EQ 0 &THEN
                 " - ЛИСТ" SPACE(0) PAGE-NUMBER FORMAT ">>9" SKIP
&ELSE
                 SKIP
&ENDIF

{ifdef {&groupbyuser}}
              "ИСПОЛНИТЕЛЬ:" _user._user-name
              "(" + CAPS(acct.user-id) + ")" FORMAT "x(10)"
{endif} */

{ifdef {&groupbycur}}
      IF acct.acct-cat <> "d" THEN
         ("ВАЛЮТА: " + acct.currency + CAPS(currency.name-currenc))
      ELSE
         ("ЦЕННАЯ БУМАГА: " + CAPS(sec-code.name)) FORMAT "x(70)"
{endif} */

{ifdef {&byturn}}
                 "СЧЕТА С ОБОРОТАМИ ОТ" min-turn "ДО" max-turn
{endif} */

{ifdef {&gopstatus}}
                 "ПО ДОКУМЕНТАМ СО СТАТУСОМ ВЫШЕ: " gop-status
      FORMAT "x(4)"
{endif} */

      SKIP(2)
      WITH NO-BOX WIDTH 400.
/*конец описания формы*/

IF mAllwaysHeader AND FIRST(code.val) THEN
   VIEW. /* чтобы хидер всегда печатался - есть данные или нет 0026780*/

{ifdef {&groupbyuser}}
   IF LAST-OF(acct.user-id)  THEN
      {chkpage 5}
{endif} */

{ifdef {&groupbycur}}
   IF LAST-OF(acct.currency) THEN
      {chkpage 5}
{endif} */

   {chkpage IF LAST-OF(acct.bal-acct) THEN
               3
            ELSE
               1
   }

{ifdef {&groupbyuser}}
   IF FIRST-OF(acct.user-id) THEN
   DO:
      FIND _user WHERE _user._userid EQ acct.user-id NO-LOCK NO-ERROR.
      PAGE.
   END.
{endif} */

{ifdef {&groupbycur}}
   IF FIRST-of(acct.currency) THEN
   DO:
      IF acct.acct-cat NE "d" THEN
         FIND currency WHERE currency.currency EQ acct.currency
            NO-LOCK NO-ERROR.
      ELSE
         FIND sec-code WHERE sec-code.sec-code = acct.currency
            NO-LOCK NO-ERROR.
      PAGE.
   END.
{endif} */

RUN acct-pos IN h_base (acct.acct, acct.currency, beg-date, end-date, ?).
/*
{ifdef {&turnover} {&curturn}}
    RUN acct-pos IN h_base (acct.acct, acct.currency, beg-date, end-date, ?).
{else} /**/
    RUN acct-pos IN h_base (acct.acct, acct.currency, end-date, end-date, ?).
{endif} */

   IF ((NOT zeroskip)               OR
      &IF DEFINED(incoming) EQ 0 AND
          DEFINED(turnover) EQ 0 AND
          DEFINED(outgoing) EQ 0 &THEN
          (sh-in-val    NE 0 OR
           sh-val       NE 0 OR
           sh-vdb       NE 0 OR
           sh-vcr       NE 0)
      &ELSE
          (sh-in-bal    NE 0 OR
           sh-bal       NE 0 OR
           sh-db        NE 0 OR
           sh-cr        NE 0)
      &ENDIF
      )
      {ifdef {&byturn}}                  AND
      (((sh-db + sh-cr) GE min-turn) AND
       ((sh-db + sh-cr) LE max-turn))
      {endif} */                         AND
        NOT (flag-ZO    EQ ? AND
             sh-db      EQ 0 AND
             sh-cr      EQ 0)            THEN
   DO:

      &IF DEFINED(recids)   NE 0 OR
          DEFINED(persons)  NE 0 OR
          DEFINED(nobalcur) NE 0 &THEN
      {get-fmt.i &obj='" + acct.acct-cat + ""-Acct-Fmt"" + "'}
      &ENDIF
      RUN currcode IN h_base (acct.currency, OUTPUT new-cur).
&IF DEFINED (NoBalAcctMask) EQ 0 &THEN
    IF NOT CAN-DO (iBalAcctMask, STRING (acct.bal-acct,"99999")) THEN
    DO:
&ENDIF
      DISPLAY {out-fmt.i acct.acct fmt} @ long-acct
                                new-cur @ acct.currency.
      {genpos1.i
         &in    ="{&incoming} "
         &turn  ="{&turnover} "
         &out   ="{&outgoing} "
         &bv    = b
         &v     ="-"
         &pos   = pos
         &units = units
         &group ="{&groupbyuser} {&groupbycur} {&groupbybalacct1} BY code.code"
      }
      {genpos1.i
         &in    ="{&curin} "
         &turn  ="{&curturn} "
         &out   ="{&curout} "
         &bv    = v
         &v     ="-v"
         &pos   = cur
         &units = 1
         &group ="{&groupbyuser} {&groupbycur} {&groupbybalacct1} BY code.code"
      }
&IF DEFINED (NoBalAcctMask) EQ 0 &THEN
    END.
    ELSE
    DO:
       {genpos1.i
         &bv=b &v="-"
       }
       {genpos1.i
         &bv=v &v="-v"
       }
    END.
&ENDIF

      {ifdef {&lastmove}}
      IF acct.currency NE ""  AND
         acct.acct-cat NE "d" THEN
         lastmove = lastcurr.
&IF DEFINED (NoBalAcctMask) EQ 0 &THEN
    IF NOT CAN-DO (iBalAcctMask, STRING (acct.bal-acct,"99999")) THEN
&ENDIF
      DISPLAY lastmove.
      {endif} */
&IF DEFINED (NoBalAcctMask) EQ 0 &THEN
    IF NOT CAN-DO (iBalAcctMask, STRING (acct.bal-acct,"99999")) THEN
    DO:
&ENDIF
      {getcust.i &name="name" &offinn="/*"}
      {ifdef {&names}}
      name[1] = TRIM(name[1] + " " + name[2]).
      {wordwrap.i &s=name &l=35 &n=10}
      DISPLAY name[1].
      DO i = 2 TO 10:
         IF name[i] <> "" THEN
         DO:
            DOWN.
            DISPLAY name[i] @ name[1].
         END.
         ELSE
            LEAVE.
      END.
      {endif} */
&IF DEFINED (NoBalAcctMask) EQ 0 &THEN
    END.
&ENDIF
      {ifdef {&opendate}}
&IF DEFINED (NoBalAcctMask) EQ 0 &THEN
    IF NOT CAN-DO (iBalAcctMask, STRING (acct.bal-acct,"99999")) THEN
&ENDIF
      DISPLAY acct.open-date.
      {endif} */


/*&IF DEFINED(groupbycur) EQ 0 &THEN
в связи с тем, что для категорий всегда надо знать об
  изменении валюты в подгруппах, делаем проверку всегда

проверим валюту записи и обновим значение
  нужно для обнаружения изменения валюты в группе
  для блокирования вывода некорректного подитога в валюте
  в случаях, когда нет сортировки по валюте
  два значения - в одном валюта, с которой надо сравнивать
     (м.б. любой символ или строка)
  в другом - трехзначный (0,1,2) флаг*/
      DO mInt=1 TO 5:
         CASE mIntAcctCurr[mInt]:
            WHEN 0 THEN
               ASSIGN
                  mCharAcctCurr[mInt] = acct.currency
                  mIntAcctCurr[mInt]  = 1
               .
            WHEN 1 THEN
               IF mCharAcctCurr[mInt] NE acct.currency THEN
                  ASSIGN
                     mCharAcctCurr[mInt] = " - "
                     mIntAcctCurr[mInt]  = 2
                  .
         END CASE.
      END.
/*обнаружение изменения валюты происходит только среди выводимых строк
&ENDIF*/

   END. /* нули */
/*окончился вывод значимой строки данных*/


   IF LAST-OF(acct.bal-acct) THEN
   DO:
/*начинается вывод разных подитогов*/

/*подитоги по счетам второго порядка - выводятся всегда*/
      {genposp.i
         &acm   ="BY acct.bal-acct "
         &grp   ="yes"
         &fcol  ="STRING(acct.bal-acct, '99999')"
         &tot   ="TOTAL BY acct.bal-acct "
         &prcur ="yes"
         &ich   = 1
         {&*}
      }
/*конец подитогов по счетам второго порядка*/

&IF DEFINED(groupbybalacct1) GT 0 &THEN
      IF LAST-OF(SUBSTR(STRING(acct.bal-acct),1,3)) THEN
      DO:

/*вывод подитогов по счетам 1-го порядка*/
         {genposp.i
            &acm   ="BY SUBSTR(STRING(acct.bal-acct),1,3) "
            &grp   ="yes"
            &fcol  ="SUBSTR(STRING(acct.bal-acct),1,3)"
            &tot   ="TOTAL {&groupbybalacct1} "
            &prcur ="yes"
            &ich   = 2
            {&*}
         }
/*конец вывода подитогов по счетам 1-го порядка*/
&ENDIF

/*вывод подитогов по валютам*/
&IF DEFINED(groupbycur) GT 0 &THEN
         IF LAST-OF(acct.currency) THEN
         DO:
            {genposp.i
               &acm   ="BY acct.currency "
               &down1 ="yes"
               &grp   ="yes"
               &fcol  ="'ВСЕГО ПО ВАЛЮТЕ'"
               &tot   ="TOTAL BY acct.currency "
               &prcur ="yes"
               {&*}
            }
/*конец вывода подитогов по валютам*/
&ENDIF

/*вывод подитогов по исполнителям*/
&IF DEFINED(groupbyuser) GT 0 &THEN
            IF LAST-OF(acct.user-id) THEN
            DO:
               {genposp.i
                  &acm   ="BY acct.user-id "
                  &grp   ="yes"
                  &fcol  ="acct.user-id FORMAT 'x(8)'"
                  &tot   ="TOTAL BY acct.user-id "
                  &prcur ="yes"
                  &ich   = 3
                  {&*}
               }
/*конец вывода подитогов по исполнителям*/
&ENDIF

               IF LAST-OF(code.code) THEN
               DO:
/*подитоги по категориям - выводятся, когда выбраны все категории*/
                  {genposp.i
                     &cha   ="mAllContract"
                     &acm   ="BY code.code "
                     &grp   ="yes"
                     &fcol  ="STRING(code.name)"
                     &tot   ="TOTAL BY code.code "
                     &prcur ="yes"
                     &ich   = 4
                     {&*}
                  }
/*конец вывода подитогов по категориям*/
&IF DEFINED(groupbyuser) EQ 0 AND
    DEFINED(groupbycur)  EQ 0 &THEN
/*вывод окончательного итога отчета
  если нет сортировки по исполнителям или валюте
  общий итог только в рублях
  если выбраны все категории, то выводятся подитоги по категориям,
  вывод общего итога блокируется*/
                  {genposp.i
                     &cha   ="NOT mAllContract"
                     &lof   ="LAST(acct.bal-acct) "
                     &down1 ="yes"
                     &grp   ="{&groupbyuser} {&groupbycur} "
                     &fcol  ="'ОБЩИЙ ИТОГ '"
                     &ifinv = n
                     &tot   ="TOTAL BY code.code "
                     &ich   = 5
                     {&*}
                  }
&ENDIF
               END.          /*LAST-OF(code.code)*/
&IF DEFINED(groupbyuser) GT 0 &THEN
            END.    /*LAST-OF(acct.user-id)*/
&ENDIF
&IF DEFINED(groupbycur) GT 0 &THEN
         END.       /*LAST-OF(acct.currency)*/
&ENDIF
&IF DEFINED(groupbybalacct1) GT 0 &THEN
      END.             /*LAST-OF(SUBSTR(STRING(acct.bal-acct),1,3))*/
&ENDIF
   END.                /*LAST-OF(acct.bal-acct)*/
/*конец вывода подитогов*/
END.
/*конец вывода данных*/

{signatur.i &user-only = YES}
ASSIGN
   access  = ""
   flag-zo = NO.

&IF DEFINED(destalready) EQ 0 &THEN
{preview.i}
&ENDIF

