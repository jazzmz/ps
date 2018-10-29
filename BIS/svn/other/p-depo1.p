
                   /*******************************************
                    *                                         *
                    *  ГОСПОДА ПРОГРАММИСТЫ И СОЧУВСТВУЮЩИЕ!  *
                    *                                         *
                    *  РЕДАКТИРОВАТЬ ДАННЫЙ ФАЙЛ БЕСПОЛЕЗНО,  *
                    *  Т.К. ОН СОЗДАЕТСЯ ГЕНЕРАТОРОМ ОТЧЕТОВ  *
                    *             АВТОМАТИЧЕСКИ!              *
                    *                                         *
                    *******************************************/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2009 ТОО "Банковские информационные системы"
     Filename: p-depo1.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 16/09/09 15:03:40
     Modified:
*/
Form "~n@(#) p-depo1.p 1.0 RGen 16/09/09 RGen 16/09/09 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

Define Buffer buf_0_op               For op.

/*--------------- Буфера для полей БД: ---------------*/

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable AcctCr           As Character            No-Undo.
Define Variable AcctDb           As Character            No-Undo.
Define Variable BankName         As Character            No-Undo.
Define Variable Dep              As Character            No-Undo.
Define Variable DepCr            As Character            No-Undo.
Define Variable KolSec           As Decimal              No-Undo.
Define Variable NameSec          As Character            No-Undo.
Define Variable reg-num          As Character            No-Undo.
Define Variable secCode          As Character            No-Undo.
Define Variable Type             As Character            No-Undo.

/*--------------- Определение форм для циклов ---------------*/
/* Форма для цикла "bb" */
Form
  "│" at 1 Type format "x(11)" at 2 "│" at 13 AcctDb format "x(25)" at 14 "│" at 39 AcctCr format "x(25)" at 40 " │" at 65 secCode format "x(12)" at 67 "│" at 79 KolSec format ">>>>>>>9.9999999" at 80 "│" at 96 skip
with frame frm_-2 down no-labels no-underline no-box width 96.

Def Var FH_p-depo1-2 as INT64 init 1 no-undo. /* frm_2: мин. строк до перехода на новую страницу */


/* Начальные действия */
{wordwrap.def}
{get-fmt.i &obj=D-Acct-Fmt}
def var AcctName as character extent 2  No-Undo.

/*-----------------------------------------
   Проверка наличия записи главной таблицы,
   на которую указывает Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "Нет записи <op>".
  Return.
end.

/*------------------------------------------------
   Выставить buffers на записи, найденные
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Т.к. не задано правило для выборки записей из главной таблицы,
   просто выставим его buffer на input RecID                    */
find buf_0_op where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   Вычислить значения специальных полей
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Вычисление значения специального поля AcctCr */
/* */

/* Вычисление значения специального поля AcctDb */
/* */

/* Вычисление значения специального поля BankName */
BankName = dept.name-bank.

/* Вычисление значения специального поля Dep */
/*  */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-db AcctName}
Dep = AcctName[1] + AcctName[2].

/* Вычисление значения специального поля DepCr */
/*  */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-cr AcctName}
DepCr = AcctName[1] + AcctName[2].

/* Вычисление значения специального поля KolSec */
/* */

/* Вычисление значения специального поля NameSec */
/* */

/* Вычисление значения специального поля reg-num */
/**/
find first sec-code
  where sec-code.sec-code = op-entry.currency no-lock no-error.

if avail sec-code
   then assign reg-num = sec-code.reg-num
               NameSec = sec-code.name.
   else assign reg-num = ""
               NameSec = "" .

/* Вычисление значения специального поля secCode */
/* */

/* Вычисление значения специального поля Type */
/* */

/*  */
def var tempfordetails1 as char  No-Undo.
def var tempfordetails2 as char  No-Undo.
tempfordetails1 = substring(buf_0_op.details,1,112).
tempfordetails2 = substring(buf_0_op.details,113,200).
/*  */

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=96 &option=Paged}

put skip(1).
put unformatted "  " BankName Format "x(40)"
                "" skip.
put unformatted " " skip.
put skip(1).
put unformatted " " skip.
put skip(1).
put unformatted "                    Мемориальный ордер N " buf_0_op.doc-num Format "x(7)"
                "" skip.
put unformatted "                    от " buf_0_op.op-date Format "99/99/9999"
                "" skip.
put skip(1).
put unformatted "Основание" skip.
put unformatted "" tempfordetails1 Format "x(115)"
                "" skip.
put unformatted "" tempfordetails2 Format "x(115)"
                "" skip.

put skip(1).
put unformatted "Государственный номер" skip.
put unformatted "ценной бумаги:  " reg-num Format "x(12)"
                "" skip.
put skip(1).
put unformatted "Наименование" skip.
put unformatted "ценной бумаги:  " NameSec Format "x(60)"
                "" skip.
put skip(1).
put unformatted "Депонент                                  : " Dep Format "x(40)"
                "" skip.
put unformatted "Депонент корреспондирующего лицевого счета: " DepCr Format "x(40)"
                "" skip.
put skip(1).
put unformatted "Дата исполнения поручения " buf_0_op.op-value-date Format "99/99/9999"
                "" skip.
put unformatted "┌───────────┬─────────────────────────┬──────────────────────────┬────────────┬────────────────┐" skip.
put unformatted "│    Тип    │      Дебет счета        │       Кредит счета       │   Код цен. │   Число ЦБ в   │" skip.
put unformatted "│ поручения │                         │                          │    бумаги  │     штуках     │" skip.
put unformatted "├───────────┼─────────────────────────┼──────────────────────────┼────────────┼────────────────┤" skip.

/* Начало цикла "bb" */
do:
  for each op-entry of op no-lock:
  /**/
  find first acct where acct.acct = op-entry.acct-db no-lock no-error.
  if acct.side = 'А' then do:
    find first acct where acct.acct = op-entry.acct-cr no-lock no-error.
    if acct.side = 'А'then Type = 'Перемещение'.
                      else Type = 'Приход'.
  end.
  else Type = 'Расход'.
  assign AcctDb = {out-fmt.i op-entry.acct-db Fmt}
         AcctCr = {out-fmt.i op-entry.acct-cr Fmt}
         SecCode = op-entry.currency
         KolSec = op-entry.qty
  .

  Disp
    Type
    AcctDb
    AcctCr
    secCode
    KolSec
  with frame frm_-2.
  if Line-Count + FH_p-depo1-2 >= Page-Size and Page-Size <> 0 then do:
    Page.
  end.
  else
    Down with frame frm_-2.
  end.
end.
/* Конец цикла "bb" */

put unformatted "└───────────┴─────────────────────────┴──────────────────────────┴────────────┴────────────────┘" skip.
put skip(2).
put unformatted "Подписи" skip.

{endout3.i &nofooter=yes}

