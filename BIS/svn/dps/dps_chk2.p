{pirsavelog.p}

/*                          
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: dps_chk.p
      Comment: Проверочная ведомость по вкладам.
               Сравнивает остатки по аналитическим счетам, у которых есть
               субаналитические счета, привязанным ко вкладам, и
               их субаналитические остатки.
   Parameters:
      Created: Om 16/11/01
     Modified: Om 21/11/01 Доработка: Проверка на существование
                                субаналитических шаблонов.
*/

Form "~n@(#) dps_chk.p 1.0 Om 16/11/01"
with frame sccs-id stream-io width 250.

{globals.i}
{tmprecid.def}   /* Временная таблица со списком выбранных вкладов */
{dps_chk2.us}     /* Определение временной талици для отчета и формы печати. */

{sh-defs.i}      /* Переменные для получения аналитического остатка по счету. */
{ksh-defs.i new} /* Переменные для получения субаналит-го остатка по счету. */

define var vCountInt as int     no-undo. /* счетчик обработанных вкладов */
define var vTotalInt as int     no-undo. /* общее кол-во вкладов */
define var vKauChar  as char    no-undo. /* Субаналитический суррогат */
define var vTmpDec   as decimal no-undo. /* Временное значение остатка */
define var vAllLog   as logical
                     format "различия/все       "
                     init Yes
                                no-undo. /* Перекулючатель отображения записей */

/* Необходимо для встраивание в getdate.i
** селектора выборки */
form
    end-date
    vAllLog
        label "Выводить"
        help "ПРОБЕЛ - изменить тип отображения"
with frame dateframe2.

on ' ' of vAllLog in frame dateframe2
do:
    frame-value = if trim(frame-value) eq "все" then Yes else No.
end.

/* Ввод даты, подсказка по календарю
** выбор отчета */
{getdate.i
    &UpdAfterDate = "vAllLog"
}

/* Выход если нет ни одного отобранного договора */
if not can-find(first tmprecid)
then return.

{init-bar.i "Секундочку..."}

/*  Подсчет общего числа записей */
for each tmprecid:
    vTotalInt = vTotalInt + 1.
end.

/* Формирование отчета */
GET_LOAN:
for each tmprecid,
    first loan where
        recid(loan) eq tmprecid.id
    no-lock,
    each loan-acct of loan where
        loan-acct.since le end-date and
        can-find (first code where
                    code.class eq "ШаблКау" and
                    code.code  eq loan-acct.acct-type
                  no-lock)
    no-lock,
    first acct of loan-acct
    no-lock
break
    by loan.cont-code:

    /* Создаю таблицу отчета */
    create ttDpsChkRep.

    ASSIGN
        ttDpsChkRep.cont-code = loan.cont-code
        ttDpsChkRep.acct-type = loan-acct.acct-type
        ttDpsChkRep.acct      = acct.acct
        ttDpsChkRep.currency  = acct.currency
    .

    /* Формирование аналитического остатка */
    run acct-pos in h_base (acct.acct,
                            acct.currency,
                            end-date,
                            end-date,
                            gop-status).


    /* Получение АНАЛИТИЧЕСКОГО остатка счета в валюте счета */
    ttDpsChkRep.acct-pos = if acct.currency eq ""
                           then sh-bal
                           else sh-val.

    /* Получение СУБАНАЛИТИЧЕСКОГО остатка счета в валюте счета */
    for each code where
        code.class  eq "loan-acct" and
        code.parent eq loan-acct.acct-type
    no-lock:

        /* Формирование субаналитики */
        vKauChar = loan.contract + ',' + loan.cont-code + ',' + code.code.

        /* Получение остатка по суб. счету */
        run kau-pos.p(acct.acct,     /* Счет */
                      acct.currency, /* Валюта счета */
                      end-date,      /* Остаток на  */
                      end-date,      /* дату end-date */
                      gop-status,    /* Статус проводк, с которых рассчитываем */
                      vKauChar).     /* Субаналитический остаток */

        /* Суб. остаток в валюте счета */
        vTmpDec = if acct.currency eq ""
                  then ksh-bal
                  else ksh-val.

/* message "" code.name acct.acct loan.cont-code vTmpDec. pause. */

        if code.name matches ("*процент*")
	and acct.acct EQ loan.cont-code
        then ttDpsChkRep.kau-proc = vTmpDec.
        else ttDpsChkRep.kau-pos  = vTmpDec.
    end.

    /* Формирование разности остатков */
    ttDpsChkRep.RemDiff = ttDpsChkRep.acct-pos -
                          (ttDpsChkRep.kau-pos /* + ttDpsChkRep.kau-proc*/ ).

    /* счетчик обработанных записей */
    if last-of (loan.cont-code)
    then do:
        vCountInt = vCountInt + 1.
        {move-bar.i vCountInt vTotalInt}
    end.
end.

/* Удаление progress bar */
{del-bar.i}

/* Если таблица отчета пуста,
** то сообщаем и выходим */
if not can-find (first ttDpsChkRep)
then do:
    message color darkgray/gray "Отчет пуст!"
    view-as alert-box message buttons Ok.

    return.
end.

/* Печать ведомости */
{setdest.i}

for each ttDpsChkRep where
    vAllLog     and ttDpsChkRep.RemDiff ne 0 or
    not vAllLog and true
with frame DpsChkRepFrm
break
    by ttDpsChkRep.cont-code:

    display
        ttDpsChkRep.cont-code   when first-of (ttDpsChkRep.cont-code)
        ttDpsChkRep.acct-type
        ttDpsChkRep.acct     
        ttDpsChkRep.currency 
        ttDpsChkRep.acct-pos
            format "zzz,zzz,zzz,zz9.99 Д"
            when ttDpsChkRep.acct-pos ge 0
            @ ttDpsChkRep.acct-pos
        - ttDpsChkRep.acct-pos
            format "zzz,zzz,zzz,zz9.99 К"
            when ttDpsChkRep.acct-pos lt 0
            @ ttDpsChkRep.acct-pos
        ttDpsChkRep.kau-pos
            format "zzz,zzz,zzz,zz9.99 Д"
            when ttDpsChkRep.kau-pos ge 0
            @ ttDpsChkRep.kau-pos
        - ttDpsChkRep.kau-pos
            format "zzz,zzz,zzz,zz9.99 К"
            when ttDpsChkRep.kau-pos lt 0
            @ ttDpsChkRep.kau-pos
        ttDpsChkRep.kau-proc
            format "zzz,zzz,zzz,zz9.99 Д"
            when ttDpsChkRep.kau-proc ge 0
            @ ttDpsChkRep.kau-proc
        - ttDpsChkRep.kau-proc
            format "zzz,zzz,zzz,zz9.99 К"
            when ttDpsChkRep.kau-proc lt 0
            @ ttDpsChkRep.kau-proc
        ttDpsChkRep.RemDiff
            format "zzz,zzz,zzz,zz9.99 Д"
            when ttDpsChkRep.RemDiff ge 0
            @ ttDpsChkRep.RemDiff
        - ttDpsChkRep.RemDiff
            format "zzz,zzz,zzz,zz9.99 К"
            when ttDpsChkRep.RemDiff lt 0
            @ ttDpsChkRep.RemDiff
    .
    down.

    if last-of (ttDpsChkRep.cont-code)
    then down 1.

end.

/* Печать испольнителя */
{signatur.i &user=/*}

{preview.i}
