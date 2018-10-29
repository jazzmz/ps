{pirsavelog.p}
/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-2001 ТОО "Банковские информационные системы"
     Filename: p19v05_k.p
      Comment: ВАЛЮТНАЯ СВОДНАЯ СПРАВКА о кассовых оборотах (сорк хранения 5 лет) для класса i56_1
               по каждому касоовому работнику
   Parameters:
         Uses:
      Used by:
      Created: 01.11.2001 Olenka
     Modified:

*/

{globals.i}
{norm.i}
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */
{get-bankname.i}
def input param in-data-id like DataBlock.Data-Id no-undo.

DEFINE VARIABLE vNatCurCod AS CHARACTER NO-UNDO.

vNatCurCod = fGetSetting("КодНацВал", ?, "").

&Glob cnt DataLine.Val[6]
&Glob sum DataLine.Val[2]
&Glob val DataLine.Val[1]

find DataBlock where DataBlock.Data-Id eq in-Data-Id no-lock no-error.
find first DataClass where DataClass.DataClass-id = entry(1,DataBlock.DataClass-id,'@') no-lock.
find first branch where branch.branch-id = DataBlock.Branch-id no-lock no-error.

def var xresult as dec no-undo.
def var i as int no-undo.
def var str as char no-undo.
def var db-cr as char no-undo.
def var mdeTotalByDb as decimal no-undo.
def var mdeTotalByCr as decimal no-undo.
def var miCountByDb  as integer no-undo.
def var miCountByCr  as integer no-undo.
def var mchBankName  as char extent 3 format "x(40)" no-undo.
def var mchCashBoss  as char no-undo.

find first branch where branch.branch-id eq sh-branch-id no-lock no-error.
if avail branch then do:
/*   mchBankName = branch.name.*/
   mchBankName[1] = cBankNameS.
   mchCashBoss = GetXattrValue ("branch", DataBlock.branch-id, "ЗавКас").
end.
else do:
/*  {get_set.i "БанкС"}
  mchBankName[1] = setting.val.*/
  mchBankName[1] = cBankNameS.	
end.
{wordwrap.i &s=mchBankName &n=3 &l=40}

for each tmprecid:
    delete tmprecid.
end.

/* ввести имя пользователя (или нескольких) */
run br-user.p (4).

&GLOB width 76
{setdest.i &cols = {&width}}

for each tmprecid:
   find first _user where recid(_user) = tmprecid.id no-lock no-error.
   if avail _user and can-find(first DataLine of DataBlock where
                                     entry(1,DataLine.Sym1,"_") = _user._userid and
                                     DataLine.Sym2 = "b" ) then do:

put
mchBankName[1] skip
mchBankName[2] skip
mchBankName[3] skip
"────────────────────────────────────────────" skip
"   (наименование кредитной организации)" skip
skip(1)
"                            СПРАВКА ЗАВЕДУЮЩЕГО КАССОЙ О КАССОВЫХ ОБОРОТАХ" skip
"                                        ЗА " {term2str DataBlock.beg-date DataBlock.end-date} format "x(20)" skip
"┌───────────────────────────────────┬────────┬───────────────────┬────────┬───────────────────┐" skip
"│                                   │Коли-   │                   │Коли-   │                   │" skip
"│    Наименование (код) валюты      │чество  │Сумма прихода валю-│чество  │Сумма расхода валю-│" skip
"│                                   │докумен-│ты по номиналу     │докумен-│ты по номиналу     │" skip
"│                                   │тов     │                   │тов     │                   │" skip
"├───────────────────────────────────┼────────┼───────────────────┼────────┼───────────────────┤" skip
.                         
      
      for each DataLine of DataBlock
          where entry(1,DataLine.Sym1,"_") = _user._userid
            and DataLine.Sym2 = "b"
            and {&sum} <> 0
          no-lock
          break by DataLine.Sym3 by DataLine.Sym4:
      
         accum {&cnt} (total by DataLine.Sym4)
               {&sum} (total by DataLine.Sym4)
               {&val} (total by DataLine.Sym4)
         .
         if first-of(DataLine.Sym3) then do:
            assign
               miCountByDb  = 0
               miCountByCr  = 0
               mdeTotalByDb = 0
               mdeTotalByCr = 0
            .
         end.
         if last-of(DataLine.Sym4) then do:
            find first currency no-lock where currency.currency = DataLine.Sym3 no-error.
            if DataLine.Sym4 = "db" then do:
               miCountByDb = accum total by DataLine.Sym4 {&cnt}.
               mdeTotalByDb =
                  if DataLine.Sym3 = "" then
                     accum total by DataLine.Sym4 {&sum}
                  else
                     accum total by DataLine.Sym4 {&val}
               .
            end.
            else do:
               miCountByCr = accum total by DataLine.Sym4 {&cnt}.
               miCountByDb = 0.
               mdeTotalByCr =
                  if DataLine.Sym3 = "" then
                     accum total by DataLine.Sym4 {&sum}
                  else
                     accum total by DataLine.Sym4 {&val}
               .
            end.
         end.
         if last-of(DataLine.Sym3) then do:
            put unformatted
               "│" currency.name-currenc + " (" + 
                   (IF DataLine.Sym3 = "" THEN vNatCurCod ELSE DataLine.Sym3) + ")" format "x(35)"
               "│" miCountByDb format ">>>>>>>9"
               "│" mdeTotalByDb format "->>>,>>>,>>>,>>9.99"
               "│" miCountByCr format ">>>>>>>9"
               "│" mdeTotalByCr format "->>>,>>>,>>>,>>9.99"
               "│" skip
            .
         end.
      end.
      put unformatted "└───────────────────────────────────┴────────┴───────────────────┴────────┴───────────────────┘" skip.
      
      put unformatted skip(1)
          " Заведующий кассой" skip
          " (кассовый работник) ────────────────" "─────────────────────" at 40 skip
                                                 "(расшифровка подписи)" at 40 skip(1)
            .
      
      page.
   end.
end.
{empty tmprecid}
{preview.i }

