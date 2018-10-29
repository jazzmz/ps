
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
     Filename: p-depo.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 16/09/09 15:00:33
     Modified:
*/
Form "~n@(#) p-depo.p 1.0 RGen 16/09/09 RGen 16/09/09 [ AutoReport By R-Gen ]"
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
Define Variable Dep1             As Character            No-Undo.
Define Variable Dep2             As Character            No-Undo.
Define Variable DepCr            As Character            No-Undo.
Define Variable DepCr1           As Character            No-Undo.
Define Variable DepCr2           As Character            No-Undo.
Define Variable KolSec           As Decimal              No-Undo.
Define Variable reg-num          As Character            No-Undo.
Define Variable secCode          As Character            No-Undo.
Define Variable SumNom           As Character            No-Undo.
Define Variable Type             As Character            No-Undo.

/*--------------- Определение форм для циклов ---------------*/
/* Форма для цикла "bb" */
Form
  "│" at 1 Type format "x(11)" at 2 "│" at 13 AcctDb format "x(25)" at 14 "│" at 39 AcctCr format "x(25)" at 40 " │" at 65 secCode format "x(12)" at 67 "│" at 79 KolSec format ">>>>>>>9.9999999" at 80 "│" at 96 SumNom format "x(17)" at 97 " │" at 114 skip
with frame frm_-2 down no-labels no-underline no-box width 123.

Def Var FH_p-depo-2 as INT64 init 1 no-undo. /* frm_2: мин. строк до перехода на новую страницу */


/* Начальные действия */
{wordwrap.def}
{get-fmt.i &obj=D-Acct-Fmt}
def var AcctName as character extent 2 NO-UNDO.

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
Dep = substring(AcctName[1] + AcctName[2], 1, 80).

/* Вычисление значения специального поля Dep1 */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-db AcctName}
Dep = substring(AcctName[1] + AcctName[2], 81, 161).

/* Вычисление значения специального поля Dep2 */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-db AcctName}
Dep = substring(AcctName[1] + AcctName[2], 162, 242).

/* Вычисление значения специального поля DepCr */
/*  */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-cr AcctName}
DepCr = substring(AcctName[1] + AcctName[2], 1, 80).

/* Вычисление значения специального поля DepCr1 */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-cr AcctName}
DepCr = substring(AcctName[1] + AcctName[2], 81, 161).

/* Вычисление значения специального поля DepCr2 */
find first op-entry of op no-lock.
{getcust2.i op-entry.acct-cr AcctName}
DepCr = substring(AcctName[1] + AcctName[2], 162, 242).

/* Вычисление значения специального поля KolSec */
/* */

/* Вычисление значения специального поля reg-num */
/**/
find first sec-code
  where sec-code.sec-code = op-entry.currency no-lock no-error.

if avail sec-code
   then reg-num = sec-code.reg-num.
   else reg-num = "".

/* Вычисление значения специального поля secCode */
/* */

/* Вычисление значения специального поля SumNom */
/* */

/* Вычисление значения специального поля Type */
/* */

/*  */
def var tempfordetails1 as char NO-UNDO.
def var tempfordetails2 as char NO-UNDO.
tempfordetails1 = substring(buf_0_op.details,1,112).
tempfordetails2 = substring(buf_0_op.details,113,200).
/*  */
/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=123 &option=Paged}

put skip(1).
put unformatted "  " BankName Format "x(40)"
                "" skip.
put unformatted " " skip.
put skip(1).
put unformatted " " skip.
put unformatted "                    Платежное поручение на бухгалтерские операции" skip.
put unformatted "                    по счетам Депо N " buf_0_op.doc-num Format "x(6)"
                "" skip.
put unformatted "                    от " buf_0_op.op-date Format "99/99/9999"
                "" skip.
put skip(1).
put unformatted "Основание" skip.
put unformatted ""  tempfordetails1 Format "x(115)"
                "" skip.
put unformatted ""  tempfordetails2 Format "x(115)"
                "" skip.
put skip(1).
put unformatted "Государственный номер" skip.
put unformatted "ценной бумаги  " reg-num Format "x(12)"
                "" skip.
put skip(1).
put unformatted "Депонент                                   " Dep Format "x(80)"
                "" skip.
put unformatted "                                           " Dep1 Format "x(80)"
                "" skip.
put unformatted "                                           " Dep2 Format "x(80)"
                "" skip.
put unformatted "Депонент корреспондирующего лицевого счета " DepCr Format "x(80)"
                "" skip.
put unformatted "                                           " DepCr1 Format "x(80)"
                "" skip.
put unformatted "                                           " DepCr2 Format "x(80)"
                "" skip.
put skip(1).
put unformatted "Дата исполнения поручения " buf_0_op.op-value-date Format "99/99/9999"
                "" skip.
put unformatted "┌───────────┬─────────────────────────┬──────────────────────────┬────────────┬────────────────┬──────────────────┐" skip.
put unformatted "│    Тип    │      Дебет счета        │       Кредит счета       │   Код цен. │   Число ЦБ в   │     Сумма по     │" skip.
put unformatted "│ поручения │                         │                          │    бумаги  │     штуках     │     номиналу     │" skip.
put unformatted "├───────────┼─────────────────────────┼──────────────────────────┼────────────┼────────────────┼──────────────────┤" skip.

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
  find last instr-rate
    where instr-rate.instr-code = op-entry.currency
      and instr-rate.rate-type = 'Номинал'
      and instr-rate.since <= op-entry.value-date
      and instr-rate.instr-cat = "sec-code" no-lock no-error.
  sumNom = string(if avail instr-rate then op-entry.qty * instr-rate.rate-instr
                                else 0,">>>>>>,>>>,>>9.99") .

  Disp
    Type
    AcctDb
    AcctCr
    secCode
    SumNom
    KolSec
  with frame frm_-2.
  if Line-Count + FH_p-depo-2 >= Page-Size and Page-Size <> 0 then do:
    Page.
  end.
  else
    Down with frame frm_-2.
  end.
end.
/* Конец цикла "bb" */

put unformatted "└───────────┴─────────────────────────┴──────────────────────────┴────────────┴────────────────┴──────────────────┘" skip.
put skip(2).
put unformatted "Подписи" skip.
put unformatted " " skip.

{endout3.i &nofooter=yes}

