{pirsavelog.p}


                   /*******************************************
                    *                                         *
                    *  ГОСПОДА ПРОГРАММИСТы И СОЧУВСТВУЮЩИЕ!  *
                    *                                         *
                    *  РЕДАКТИРОВАТЬ ДАННыЙ ФАЙЛ БЕСПОЛЕЗНО,  *
                    *  Т.К. ОН СОЗДАЕТСЯ ГЕНЕРАТОРОМ ОТЧЕТОВ  *
                    *             АВТОМАТИЧЕСКИ!              *
                    *                                         *
                    *******************************************/

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2005 ТОО "Банковские информационные системы"
     Filename: memirvn.p
      Comment: Отчет, созданный генератором отчетов
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 28/07/05 12:03:29
     Modified:
*/
Form "~n@(#) memirvn.p 1.0 RGen 28/07/05 RGen 28/07/05 [ AutoReport By R-Gen ]"
     with frame sccs-id stream-io width 250.

{globals.i}
{chkacces.i}
/*-------------------- Входные параметры --------------------*/
Define Input Param RID as RecID no-undo.

/*-------------------- Объявление переменных --------------------*/

/*--------------- Буфера для полей БД: ---------------*/
Define Buffer buf_0_op               For op. /* Буфер для op, роль 'Тот самый Op, под который лепится проводка' */

/*--------------- Переменные для специальных полей: ---------------*/
Define Variable banner           As Character            No-Undo.
Define Variable Curr-code        As Character            No-Undo.
Define Variable Curs-Val         As Decimal              No-Undo.
Define Variable Detail           As Character Extent   5 No-Undo.
Define Variable Doc-Num          As Character            No-Undo.
Define Variable DocDate          As Character            No-Undo.
Define Variable PlAcct           As Character            No-Undo.
Define Variable PlName           As Character Extent   3 No-Undo.
Define Variable PoAcct           As Character            No-Undo.
Define Variable PoName           As Character Extent   3 No-Undo.
Define Variable Rub              As Character            No-Undo.
Define Variable theDate          As Character            No-Undo.
Define Variable UserName         As Character            No-Undo.
Define Variable Val              As Character            No-Undo.

/*--------------- Определение форм для циклов ---------------*/

/* Начальные действия */
{wordwrap.def}
{pick-val.i}

&scop offinn
&scop offsigns

{get-fmt.i &obj=N-Acct-Fmt}

Def Var InCity  as logic          no-undo.
Def Var NameCli as char  extent 2 no-undo.

Def Buffer Bank1 for Banks.
Def Buffer bop for op.

def var bank-cor-acct as char form "x(20)" no-undo.

{get_set.i "КорСч"}
bank-cor-acct = setting.val.

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
/* Правило для главной таблицы op */
function BankNameCity return char (buffer b for banks):
  return {banknm.lf b} + (if {bankct.lf b} <> "" then ', ' else '') +
         {bankct.lf b}.
end function.
         
{bank-id.i}

find op where RecID(op) = RID no-lock.
find first op-bank of op no-lock no-error.
find op-entry of op no-lock no-error.

if Ambig(op-entry) then do:
  Bell.
  {message &text="|К документу относится более одной проводки!"
           &alert-box="error"}.
  Return.
end.

/* Find PlName */
find first acct where acct.acct = op-entry.acct-db no-lock.
{getcust.i &name=NameCli}
PlAcct = op-entry.acct-db.

if not acct.acct begins "9999"  then do:
   PlName[1] = NameCli[1] + " " + NameCli[2].
   {wordwrap.i &s=PlName &n=3 &l=30}
end.   

/* Find PoName */
find first acct where acct.acct = op-entry.acct-cr no-lock.
{getcust.i &name=NameCli}
PoAcct = op-entry.acct-cr.

if not acct.acct begins "9999" then do:
   PoName[1] = NameCli[1] + " " + NameCli[2].
   {wordwrap.i &s=poName &n=3 &l=30}
end.

/* Выставим buf_0_op на op роли 'Тот самый Op, под который лепится проводка' */
Find buf_0_op Where RecID(buf_0_op) = RecID(op) no-lock.

/*------------------------------------------------
   Вычислить значения специальных полей
   в соответствии с заданными в отчете правилами
------------------------------------------------*/
/* Вычисление значения специального поля banner */
{get_set.i "Банк"}

banner = setting.val.

/* Вычисление значения специального поля Curr-code */
if op-entry.currency eq "" then Curr-Code = "810".
                           else Curr-Code = op-entry.currency.

/* Вычисление значения специального поля Curs-Val */
find last instr-rate 
    where instr-rate.instr-code eq op-entry.currency
      and instr-rate.since le op.op-date no-lock no-error.
if avail instr-rate then Curs-val = instr-rate.rate-instr.
                    else Curs-val = 1.

/* Вычисление значения специального поля Detail */
find first signs where signs.file-name = "op" and
                       signs.surrogate = string(op.op) and
                       signs.code = "ОснЗач" no-error.
if avail signs then do:                       
   find first code where code.class = signs.code and
                         code.code = signs.code-value no-error.
   if avail code then do:
      Detail[1] = code.name.
      {wordwrap.i &s=Detail &n=5 &l=50}
   end.
end.                         
else do:
  Detail[1] = if op.details <> ? then op.details else "".
  {wordwrap.i &s=Detail &n=5 &l=50}
end.

/* Вычисление значения специального поля Doc-Num */
find first bop where bop.op-transaction eq op.op-transaction 
                 and bop.op ne op.op no-lock no-error.
if avail bop then do:
   Doc-Num  = bop.doc-num.
   DocDate  = {strdate.i bop.doc-date}.
end. 
else do:
   Doc-Num  = op.doc-num.    
   DocDate  = {strdate.i op.doc-date}. 
end.

/* Вычисление значения специального поля DocDate */
/* */

/* Вычисление значения специального поля PlAcct */
PlAcct = {out-fmt.i PlAcct Fmt}.

/* Вычисление значения специального поля PlName */
/* */

/* Вычисление значения специального поля PoAcct */
PoAcct = {out-fmt.i PoAcct Fmt}.

/* Вычисление значения специального поля PoName */
/* */

/* Вычисление значения специального поля Rub */
if trunc(op-entry.amt-rub,0) = op-entry.amt-rub then 
   Rub = string(string(op-entry.amt-rub * 100, "-zzzzzzzzzz999"),"x(12)=").
else 
   Rub = string(string(op-entry.amt-rub * 100, "-zzzzzzzzzz999"),                      "x(12)-x(2)").

/* Вычисление значения специального поля theDate */
if op.doc-date <> ? then
  if op.doc-date = op.ins-date then
     theDate = {strdate.i op.doc-date}.
  else
     theDate = {strdate.i op.ins-date}.
else
  theDate = {strdate.i op.op-date}.

/* Вычисление значения специального поля UserName */
find first _user where _user._userid eq op.user-id no-error.
if avail _user then username = _user._user-name.

/* Вычисление значения специального поля Val */
if trunc(op-entry.amt-cur,0) = op-entry.amt-cur then 
   Val = string(string(op-entry.amt-cur * 100, "-zzzzzzzzzz999"),"x(12)=").
else 
   Val = string(string(op-entry.amt-cur * 100, "-zzzzzzzzzz999"),                      "x(12)-x(2)").

/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=80 &option=Paged}

put unformatted "" banner Format "x(60)"
                "" skip.
put skip(1).
put unformatted "                             МЕМОРИАЛЬНыЙ ОРДЕР N " buf_0_op.doc-num Format "x(6)"
                "" skip.
put unformatted "                               " theDate Format "x(20)"
                "" skip.
put skip(1).
put unformatted " Содержание операции:  " detail[1] Format "x(50)"
                "" skip.
put unformatted "                       " detail[2] Format "x(50)"
                "" skip.
put unformatted "                       " Detail[3] Format "x(50)"
                "" skip.
put unformatted "                       " Detail[4] Format "x(50)"
                "" skip.
put unformatted "                       " detail[5] Format "x(50)"
                "" skip.
put unformatted " " skip.
put unformatted " ДЕБЕТ " PlAcct Format "x(25)"
                "   КРЕДИТ " PoAcct Format "x(25)"
                "" skip.
put unformatted "  " PlName[1] Format "x(30)"
                "     " PoName[1] Format "x(30)"
                "" skip.
put unformatted "  " PlName[2] Format "x(30)"
                "     " PoName[2] Format "x(30)"
                "" skip.
put unformatted "  " PlName[3] Format "x(30)"
                "     " PoName[3] Format "x(30)"
                "" skip.
put unformatted " ┌──────────────────────────────────┬─────────────────┬─────────────────┐" skip.
put unformatted " │Номер и дата платежного документа │  Сумма в рублях │ Сумма в инвалюте│" skip.
put unformatted " ├──────────────────────────────────┼─────────────────┼─────────────────┤" skip.
put unformatted " │ " Doc-Num Format "x(6)"
                " от " DocDate Format "x(20)"
                "   │ " Rub Format "x(16)"
                "│ " Val Format "x(16)"
                "│" skip.
put unformatted " └──────────────────────────────────┴─────────────────┴─────────────────┘" skip.
put unformatted " " skip.
put unformatted "  Валюта " Curr-code Format "x(4)"
                " Курс на " buf_0_op.op-date Format "99/99/9999"
                " = " Curs-Val Format ">>>>9.9999"
                "" skip.
put skip(2).
put unformatted " " skip.
put skip(1).
put unformatted " Контролер                  Исполнитель              " UserName Format "x(20)"
                "" skip.
put unformatted "           ────────────────            ──────────────" skip.

{endout3.i &nofooter=yes}

