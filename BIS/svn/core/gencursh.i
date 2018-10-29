/*
               Банковская интегрированная система БИСквит
    Copyright: (C) 1992-1996 ТОО "Банковские информационные системы"
     Filename: gencursh.i
      Comment: Шаблон для валютных балансовых ведомостей
   Parameters:
         Uses: gensh.i, inscur.i, ...
      Used by: many
      Created: 18/10/97 Serge
     Modified: 26/02/99 Olenka ЗО - всегда во входящих остатках
     Modified: 05/02/2002 Olenka - исправлено - при группировке по валютам,
                          каждая новая валюта печатается с новой страницы
     Modified: 23.12.03 ler 23356 - устранение ошибки по F1 (выбор валюты) при
                                    формировании Ведомости остатков в валюте
     Modified: 27.07.04 ler 31979 - Автоматизированное тестирование отчетов.
         Note:
               {gencursh.i
                   &sections=yes       - показывать разделы и счета 1-го порядка
                   &names=yes          - показывать наименования счетов

                   &incoming=yes       - показывать входящие остатки
                   &turnover=yes       - показывать обороты
                   &outgoing=yes       - показывать исходящие остатки

                   &curin=yes          - показывать входящие остатки в валюте
                   &curturn=yes        - показывать обороты в валюте
                   &curout=yes         - показывать исходящие остатки в валюте

                   &lastmove=yes       - показывать дату последнего движения
                   &thousands=yes      - показывать суммы в тысячах

                   &format=<format>    - формат сумм    -> &rubformat
                   &curformat=<format> - формат вал. сумм
                   &widthname=<int>    - ширина наименования

                   &isocur=yes         - вывод кодов ISO вместо цифровых
                   &forcur=yes         - перевод в выбираемую валюту

                   &bycurrency=yes     - с разбивкой по валютам
                   &curtotal=yes       - показывать суммы по валютам в конце отчета
               }
*/
/*******************************************************************************/
&IF DEFINED(CONSBAL) = 0 &THEN
   &GLOB consbal yes
&ENDIF

&GLOB NAMEDATE DataBlock.Beg-Date

&IF DEFINED(WIDTHNAME) = 0 &THEN
   &GLOB widthname 40
&ENDIF

{gensh.i {&*}}
{turnin.def}
{intrface.get acct}
{intrface.get separate}

&IF DEFINED(FORCUR) <> 0 &THEN
   def var forcur like currency.currency no-undo.
   pause 0.
   do transaction on error undo, leave on endkey undo, leave with frame forcurframe:
      forcur = "840".
      IF NOT gRemote THEN
         UPDATE forcur
            WITH CENTERED ROW 10 OVERLAY SIDE-LABELS 1 COL
            COLOR messages TITLE "[ ЗАДАЙТЕ ВАЛЮТУ ]"
         EDITING:
            readkey.
            if lastkey = 301 then do:
               RUN currency.p ("Учетный",4).
               if (lastkey = 13 or lastkey = 10) and pick-value <> ? then
                  display pick-value @ forcur.
            end.
            else apply lastkey.
         end.
   end.
   hide frame forcurframe no-pause.
   if keyfunc(lastkey) = "end-error" then return.
&ENDIF

{inscur.i {&*}}

assign cols = 9
   &IF DEFINED(BYCURRENCY) <> 0 &THEN -  4 &ENDIF
   &IF DEFINED(INCOMING)   <> 0 &THEN + 40 &ENDIF
   &IF DEFINED(TURNOVER)   <> 0 &THEN + 40 &ENDIF
   &IF DEFINED(OUTGOING)   <> 0 &THEN + 40 &ENDIF
   &IF DEFINED(CURIN)      <> 0 &THEN + 40 &ENDIF
   &IF DEFINED(CURTURN)    <> 0 &THEN + 40 &ENDIF
   &IF DEFINED(CUROUT)     <> 0 &THEN + 40 &ENDIF
   &IF DEFINED(LASTMOVE)   <> 0 &THEN +  9 &ENDIF
   &IF DEFINED(NAMES)      <> 0 &THEN + {&widthname} + 1  &ENDIF
.

{setdest.i &cols=" + cols"}
assign
   beg-date = in-beg-date
   end-date = in-end-date
.

def var new-cur like currency.currency initial "" no-undo.
def var report-type1 as char format "x(70)" no-undo.
def var report-type2 as char format "x(96)" no-undo.

def buffer xcurrency for currency.

&IF DEFINED(FORCUR) <> 0 &THEN
   if forcur <> "" then
      find first xcurrency where xcurrency.currency = forcur no-lock no-error.
&ENDIF

report-type2 =
   &IF DEFINED(TURNOVER) NE 0 OR DEFINED(CURTURN) NE 0 &THEN
     "ОБОРОТНО-САЛЬДОВАЯ ВЕДОМОСТЬ ЗА " + caps({term2str Beg-Date End-Date})
   &ELSE
     "ВЕДОМОСТЬ ОСТАТКОВ ЗА " + string(end-date)
   &ENDIF
   &IF DEFINED(THOUSANDS) NE 0 &THEN
   + " ({&in-UA-1000NCN})"
   &ENDIF
   &IF DEFINED(FORCUR) NE 0 &THEN
   + " (В ВАЛЮТЕ "~""
   + (if avail xcurrency then caps(xcurrency.name-curr) else "")
   + "~")"
   &ENDIF
   + (if flag-ZO then " С УЧЕТОМ ЗАКЛЮЧ. ОБОРОТОВ" else "")
   .

&IF DEFINED(TURNOVER) NE 0 OR DEFINED(CURTURN) NE 0 &THEN
   {br-put.i "ОБОРОТНО-САЛЬДОВАЯ ВЕДОМОСТЬ"}
&ELSE
   {br-put.i "ВЕДОМОСТЬ ОСТАТКОВ"}
&ENDIF

&GLOB bysect by b-sect.code ~
   &IF DEFINED(ACCT0) <> 0 &THEN ~
       by b-acct0.code ~
   &ENDIF~
   &IF DEFINED(NOACCT1) = 0 &THEN ~
       by b-acct1.code ~
   &ENDIF ~

def var ispace as INT64 no-undo.
&IF DEFINED(BYCURRENCY) NE 0 &THEN
   &GLOB breakby by currency.currency by code.val by bal-acct.acct-cat ~
         &IF DEFINED(SECTIONS) NE 0 &THEN  {&bysect} &ENDIF by inscur.bal-acct
   ispace = 6.
&ELSE
   &GLOB breakby by code.val by bal-acct.acct-cat ~
         &IF DEFINED(SECTIONS) NE 0 &THEN  {&bysect} &ENDIF by inscur.bal-acct by currency.currency
   ispace = 10.
&ENDIF

{ifdef {&format}}
   &GLOB rubformat "{&format}"
{else} */
   &GLOB rubformat "->>>,>>>,>>>,>>9.99"
{endif} */
{ifdef {&curformat}}
   &GLOB curformat "{&curformat}"
{else} */
   &GLOB curformat "->>>,>>>,>>>,>>9.99"
{endif} */

&GLOB und_all ~
   underline inscur.bal-acct ~
     &IF DEFINED(NAMES)    <> 0                          &THEN  name[1]   &ENDIF ~
     &IF DEFINED(CURIN)    <> 0 AND (DEFINED(FORCUR) <> 0 OR DEFINED(BYCURRENCY) <> 0) &THEN  inscur.in-val-db inscur.in-val-cr &ENDIF ~
     &IF DEFINED(CURTURN)  <> 0 AND (DEFINED(FORCUR) <> 0 OR DEFINED(BYCURRENCY) <> 0) &THEN  inscur.vdebit inscur.vcredit &ENDIF ~
     &IF DEFINED(CUROUT)   <> 0 AND (DEFINED(FORCUR) <> 0 OR DEFINED(BYCURRENCY) <> 0) &THEN  inscur.val-db inscur.val-cr &ENDIF ~
     &IF DEFINED(INCOMING) <> 0 &THEN  inscur.in-bal-db inscur.in-bal-cr &ENDIF ~
     &IF DEFINED(TURNOVER) <> 0 &THEN  inscur.debit inscur.credit &ENDIF ~
     &IF DEFINED(OUTGOING) <> 0 &THEN  inscur.bal-db inscur.bal-cr &ENDIF ~
  . ~

&GLOB und ~
    underline ~
     &IF DEFINED(NAMES)    <> 0                          &THEN  name[1]   &ENDIF ~
     &IF DEFINED(INCOMING) <> 0 &THEN  inscur.in-bal-db inscur.in-bal-cr &ENDIF ~
     &IF DEFINED(TURNOVER) <> 0 &THEN  inscur.debit inscur.credit &ENDIF ~
     &IF DEFINED(OUTGOING) <> 0 &THEN  inscur.bal-db inscur.bal-cr &ENDIF ~
  . ~

FORM HEADER "- Лист " AT 70 PAGE-NUMBER FORMAT ">9" AT 77 WITH FRAME PageH PAGE-TOP.
VIEW FRAME PageH.

for each code where
         code.class = "acct-cat"
     and code.code begins in-acct-cat
   NO-LOCK BREAK BY code.val:
/*    IF NOT FIRST(code.val) THEN PAGE. */
    case code.code:
         when "d" then do: {gencursh.ii {&*} &1="bal1sect.i" &noacct1=yes &f=d } end.
         when "f" then do: {gencursh.ii {&*} &1="bal3sect.i" &acct0=yes   &f=f } end.
         otherwise     do: {gencursh.ii {&*} &1="bal2sect.i"              &f=b } end.
    end.
end.
{intrface.del acct}

{signatur.i &department = branch}

flag-zo = no.

IF GetSysConf("ModeExport") NE "ExpАвтоТест" THEN DO:
   {preview.i}                      /* искл при генер для эксп при автотестир */
END.
/******************************************************************************/
