   /******
    * Степанов С.В. stmtprs Стандартная (ПИРБАНК)- Регистр аналит.учета СВОДНАЯ ПЕРЕОЦЕН
    * сделана из stmtprr3.h - вариант вызова [ ]По дням и счет выписки рублевый
    * убрал код документа, код банка и номер счета корреспондента
    *  Инициатор Кувикова Ж. Ю.
    * Дата создания 27.07.2011
    ******/

{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var h-str     as char no-undo.
   def var doubl-chr as char no-undo.

   DEF VAR acct-name AS CHARACTER NO-UNDO.
   DEF VAR oAcct AS TAcct NO-UNDO.
   oAcct = new TAcct(REPLACE(long-acct,"-","")).
	   acct-name = oAcct:details.
   DELETE OBJECT oAcct.
   

   if doubl-v1
   then doubl-chr = trim(ts.name-vip) + " - ДУБЛИКАТ".
   else doubl-chr = string(" ","x(3)") + "ВЫПИСКА ПО ЛИЦЕВОМУ СЧЕТУ".

   if (prev-db <> "")
   then h-str = fill(" ",17) + prev-db.
   else h-str = fill(" ",34) + prev-cr.

   form
    "│" space(0) stmt.op-date   form "99.99.99"  space(0)
    "│" space(0) stmt.doc-num   form "x(6)"      space(0)
/*    "│" space(0) stmt.doc-type  form "x(3)"      space(0)
    "│" space(0) stmt.bank-code form "x(9)"      space(0)
    "│" space(0) sacctcur form "x(20)"           space(0)
*/    "│" space(0) sh-db format "->>>>,>>>,>>9.99" space(0)
    "│" space(0) sh-cr format "->>>>,>>>,>>9.99" space(0)
    "│" space(0) detarr[1] form "x({&detwidth})" space(0) "│"
   header
   skip(4)
    "╒════════════════════════════════════════════════════════════════════════════════╕" skip
    "│                                                            Регистр N 36  к УП  │" skip
    "│"      name-bank  form "x(69)"                                                 "│" at 82 skip
    "│"                                                                              "│" at 82 skip
    "│                        Регистр аналитического учета                            │" skip
    "│                             за" {term2str beg dob} format "x(25)"             "│" at 82 skip
    "│"                                                                              "│" at 82 skip
    "│ Балансовый счет : " long-acct format "x(25)" acct-name FORMAT "x(30)"         "│" at 82 skip
    "│"                                                                              "│" at 82 skip
    "│ Сальдо на начало периода :" SUBSTR(h-str, 19) form "x(39)"                    "│" at 82 skip
    "├────────┬──────┬─────────────────────────────────┬──────────────────────────────┤" skip
    "│  Дата  │ Номер│       Обороты в нац. валюте     │     Содержание операции      │" skip
    "│опер.дня│докум.│      Дебет            Кредит    │                              │" skip
    "├────────┼──────┼────────────────┬────────────────┼──────────────────────────────┤" skip
   with no-label no-underline.
