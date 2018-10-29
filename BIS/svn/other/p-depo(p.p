{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1998 ТОО "Банковские информационные системы"
     Filename: p-depo.p
      Comment: Поручение допо на прием/снятие ЦБ
      Comment:
   Parameters: Input: RID -  RecID(op)
         Uses: Globals.I ChkAcces.I SetDest.I PreView.I
      Used by:
      Created: 22/11/99 19:36:48 Lera
     Modified:
*/
Form "~n@(#) p-depo(p.p 1.0 Lera 22/11/99 Lera 22/11/99 "
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
Define Variable reg-num          As Character            No-Undo.
Define Variable sum-nom          As Decimal              No-Undo.

Def Var FH_p-depo-1 as integer init 5 no-undo. /* frm_1: мин. строк до перехода на новую страницу */


/* Начальные действия */
{wordwrap.def}
{get-fmt.i &obj=D-Acct-Fmt}
{rekv-dop.i}


define variable signs-code-val as character no-undo.
def var AcctName as char extent 2 no-undo.
def buffer acct-buf1 for acct.
def buffer acct-buf2 for acct.
def var summ-all as dec no-undo.
def var summ-kol as dec no-undo.


/*-----------------------------------------
   Проверка наличия записи главной таблицы, на которую указывает Input Param RID
-------------------------------------------*/
Find op Where RecID(op) = RID no-lock no-error.
If Not Avail(op) then do:
  message "Нет записи <op>".
  Return.
end.

/*------------------------------------------------*/
/* Вычисление значения специального поля BankName */
BankName = dept.name-bank.

/* Вычисление значения специального поля Dep */
find first op-entry of op no-lock.
if not avail op-entry then do:
      message "У поручения: " + op.doc-num + " нет проводок." view-as alert-box.
      return.
end.

find first acct-buf1 where acct-buf1.acct = op-entry.acct-db no-lock no-error.
if not avail acct-buf1 then do:
   message "Счет по дебету: " + op-entry.acct-db + " отсутствует в справочнике лицевых счетов." view-as alert-box.
   return.
end.
find first acct-buf2 where acct-buf2.acct = op-entry.acct-cr no-lock no-error.
if not avail acct-buf2 then do:
   message "Счет по кредиту: " + op-entry.acct-cr + " отсутствует в справочнике лицевых счетов." view-as alert-box.
   return.
end.
if not ((acct-buf2.side = "П" and acct-buf1.side = "А") or (acct-buf1.side = "П" and acct-buf2.side = "А")) then do:
   message "Данное поручение печатается только при корреспонденции активного и пассивного лицевого счета." view-as alert-box.
   return.
end.
signs-code-val = GetXAttrValue("acct",(if acct-buf2.side = "П" then acct-buf2.acct else acct-buf1.acct) + "," + (if acct-buf2.side = "П" then acct-buf2.currency else acct-buf1.currency),"Депо").
if signs-code-val ne "" then do:
   find first loan where loan.contract = "ДепоП" and
                         loan.cont-code = signs-code-val and
                         loan.class-code = "depoacct" no-lock no-error.

   if avail loan then do:
       case loan.cust-cat:
           when "Ю" then do:
               find first cust-corp of loan no-lock no-error.
               Dep = if avail cust-corp then cust-corp.cust-stat + " " + cust-corp.name-corp else "".
           end.
           when "Ч" then do:
               find first person where person.person-id = loan.cust-id no-lock no-error.
               Dep = if avail person then person.name-last + " " + person.first-names else "".
           end.
           when "Б" then do:
               find first banks where banks.bank-id = loan.cust-id no-lock no-error.
               Dep = if avail banks then banks.name else "".
           end.
        end case.
   end.
end.


/*-------------------- Формирование отчета --------------------*/
{strtout3.i &cols=106 &option=Paged}
find first _user where _user._userid = op-entry.user-id no-lock.

put unformatted "            " at 60 skip.
put unformatted "┌────────────────────────────────────────────────────────────────────────┐" at 45 skip.
put unformatted caps(BankName) format "x(40)" at 1.
put unformatted "│ Дата приема '___' ________200_г.      № Регистрации поручения ________ │" at 45 skip.
put unformatted "│ Время приема ___час______мин.         Подпись ________________________ │" at 45 skip.
put unformatted "├────────────────────────────────────────────────────────────────────────┤" at 45 skip.
put unformatted "                                                                          " at 45 skip.
put unformatted "                                                                          " at 45 skip(1).
put unformatted "──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" at 1 skip(1).
put unformatted "                                        ПОРУЧЕНИЕ ДЕПО № _____________ " skip
                "                                       НА ПРИЕМ ЦЕННЫХ БУМАГ НА СЧЕТ ДЕПО" skip(1)
                "г. Москва                                                                                    "
                {term2str op-entry.op-date op-entry.op-date yes} skip(1).

put unformatted space(int((110 - length(Dep)) / 2))  caps(Dep) skip.
put unformatted "─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────" skip
                "               полное наименование организации - владельца счета Депо, Ф.И.О. - для физ.лица" skip(2).
put unformatted "┌────────────────────────────────────────────────────────────────────────────────────────────┬───────────────────────┐" skip
                "│ НОМЕР СЧЕТА ДЕПО ВЛАДЕЛЬЦА СЧЕТА                                                           │  "
      string(signs-code-val,"x(19)") "  │"  skip
                "└────────────────────────────────────────────────────────────────────────────────────────────┴───────────────────────┘" skip(1).
put unformatted "                                                             " skip
                "Тип ценной бумаги (отметить тип ценных бумаг, по которым дается Поручение) " skip(1).
put unformatted "┌─┐" "Облигации государственного сберегательного займа Министерства финансов РФ (ОГСЗ)" skip
                "└─┘" skip
                "▄▄" " Вексель(я)  " entry(1,dop-rekviz("sec-code",(if acct-buf1.side = "П" then acct-buf1.currency else acct-buf2.currency),"issue_cod","name"),"[") skip
                "▀▀" "            ────────────────────────────────────────────────────────────────────────────" skip
                "┌─┐" "Акции" skip
                "└─┘" skip
                "┌─┐" "Облигации внутреннего валютного государственного займа (ОВВГЗ)" skip
                "└─┘" skip(2).

put unformatted "┌─────────────────┬─────────────────┬─────────────┬─────────────────┬────────────────────────────────────────────────┐" skip
                "│ СЕРИЯ ИЛИ       │   НОМИНАЛ       │ ИНВЕНТАРНЫЙ │    КОЛИЧЕСТВО   │ ОБЩАЯ СТОИМОСТЬ (ПО НОМИНАЛУ), РУБ.            │" skip
                "│ ВЫПУСК          │     РУБ.        │ КОД ЦБ      │ ЦЕННЫХ БУМАГ ШТ.│                                                │" skip
                "├─────────────────┼─────────────────┼─────────────┼─────────────────┼────────────────────────────────────────────────┤" skip.
summ-all = 0.
summ-kol = 0.
for each op-entry of op no-lock:
     /* Вычисление значения специального поля reg-num */
     find first sec-code where sec-code.sec-code = op-entry.currency no-lock no-error.
     find last instr-rate where instr-rate.instr-cat = "sec-code" and
                                instr-rate.rate-type = "Номинал" and
                                instr-rate.since <= op-entry.op-date and
                                instr-rate.instr-code = op-entry.currency no-lock no-error.  /* нашли номинал для данной бумаги */
     put unformatted "│" (if avail sec-code then sec-code.reg-num else " ") format "x(17)"
                     "│" (if avail instr-rate then instr-rate.rate-instr else 0) format ">>>>>>>>>>>>>9.99"
                     "│ " (if avail sec-code then sec-code.sec-code else " ") format "x(12)"
                     "│" op-entry.amt-rub format ">>>>>>>>>>>>>9.99"
                     "│" ((if avail instr-rate then instr-rate.rate-instr else 0) * op-entry.amt-rub) format ">>>>>>,>>>,>>>,>>>,>>9.99"
                     "│" at 118 skip.
     summ-kol = summ-kol + op-entry.amt-rub.
     summ-all = summ-all + ((if avail instr-rate then instr-rate.rate-instr else 0) * op-entry.amt-rub).
end.

put unformatted "├─────────────────┼─────────────────┼─────────────┼─────────────────┼────────────────────────────────────────────────┤" skip
                "│ ИТОГО           │                 │             │" summ-kol format ">>>>>>>>>>>>>9.99"
                "│" summ-all format ">>>>>>,>>>,>>>,>>>,>>9.99" "│" at 118 skip.

put unformatted "└─────────────────┴─────────────────┴─────────────┴─────────────────┴────────────────────────────────────────────────┘" skip.
put unformatted "ОСНОВАНИЕ: " op.details skip(1)
                "                                                                     ┌──────────────────────────────────────────┐" skip
                "                                                                     │      ОТМЕТКА ОБ ИСПОЛНЕНИИ ПОРУЧЕНИЯ     │" skip
                "                                                                     │                                          │" skip
                "                                                                     │ ──────────────────────────────────────── │" skip
                "                                                                     │   (ф.и.о. уполномоченного сотрудника)    │" skip
                "                                                                     │                                          │" skip
                "                                                                     │ ПОДПИСЬ УПОЛНОМОЧЕННОГО СОТРУДНИКА       │" skip
                "                                                                     │ ДЕПОЗИТАРИЯ:                             │" skip
                "                                                                     │                                          │" skip
                "                                                                     │ ──────────────────────────────────────── │" skip
		"                                                                     │ Дата исполнения '__'______________200_г. │" skip
		"                                                                     └──────────────────────────────────────────┘" skip
                "           " skip.

/* put unformatted "Государственный номер ценной бумаги: " reg-num Format "x(12)" skip(1).

put unformatted "Число ЦБ: " op-entry.amt-rub skip(1).

put unformatted "Основание совершаемой операции: " buf_0_op.details Format "x(100)" skip(1).

put unformatted "Дата исполнения операции: " buf_0_op.op-date Format "99/99/9999" skip(2).

put unformatted "Уполномоченное лицо " skip.
  */
{endout3.i &nofooter=yes}
