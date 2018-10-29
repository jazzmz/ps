{capsif.i}
{get-bankname.i}
name-bank = cBankname.
   def var h-str     as char no-undo.
   def var doubl-chr as char no-undo.
/*   MESSAGE "222" VIEW-AS ALERT-BOX. */
   /******
    * Маслов Д. А. Maslov D. A.
    * Необходимо отображать название счета
    *  Инициатор Кувикова Ж. Ю.
    * Дата создания 14.07.2011
    ******/
   DEF VAR acct-name AS CHARACTER NO-UNDO.
   DEF VAR oAcct AS TAcct NO-UNDO.
   oAcct = new TAcct(REPLACE(long-acct,"-","")).
	   acct-name = oAcct:details.
   DELETE OBJECT oAcct.
   


   if doubl-v1
   then doubl-chr = trim(ts.name-vip) + " - ДУБЛИКАТ".
   else doubl-chr = string(" ","x(3)") + trim(ts.name-vip).

   if (prev-db <> "")
   then h-str = fill(" ",12) + prev-db.
   else h-str = fill(" ",29) + prev-cr.

   form

    "│" space(0) stmt.doc-num   form "x(6)"      space(0)
    "│" space(0) stmt.doc-type  form "x(3)"      space(0)
    "│" space(0) stmt.bank-code form "x(9)"      space(0)
    "│" space(0) sacctcur form "x(20)"           space(0)
    "│" space(0) sh-db format "->>>>,>>>,>>9.99" space(0)
    "│" space(0) sh-cr format "->>>>,>>>,>>9.99" space(0)
    "│" space(0) detarr[1] form "x({&detwidth})" space(0) "│"
   header
   skip(4)
    "╒═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════╕" skip
    "│                                                                                              Регистр    N 3 к УП  │" skip
    "│"      name-bank  form "x(95)"                                                                                    "│" at 117 skip
    "│"                                                                                                                 "│" at 117 skip
    "│                                         Регистр аналитического учета                                              │" skip
    "│                                                   за" dob form "99.99.99"                                        "│" at 117 skip
    "│"                                                                                                                 "│" at 117 skip
    "│       Балансовый счет : " long-acct format "x(25)" acct-name FORMAT "x(30)"                                                              "│" at 117 skip
    "│"                                                                                                                 "│" at 117 skip
    "│ Сальдо на начало дня :" h-str form "x(62)"                                                                       "│" at 117 skip
    "├──────┬───┬─────────┬────────────────────┬─────────────────────────────────┬───────────────────────────────────────┤" skip
    "│ Номер│Код│   Код   │  Корреспондирующий │       Обороты в нац. валюте     │          Содержание операции          │" skip
    "│докум.│док│  банка  │        счет        │      Дебет            Кредит    │                                       │" skip
    "├──────┼───┼─────────┼────────────────────┼────────────────┬────────────────┼───────────────────────────────────────┤" skip
   with no-label no-underline.