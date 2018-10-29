{pirsavelog.p}

/*
 КБ ПPОМИНВЕСТРАСЧЕТ

 27/03/06  - Отчет по счетам c нулевыми остатками на дату.

 [vk]

*/

{globals.i}                  
{getdate.i}
{sh-defs.i}
{wordwrap.def}

def input parameter bal-line as char format "x(300)".
def var params as char format "x(70)".
def var lm as c.
def var acount as integer.
def var bal as char extent 20.
def var i as integer.
def var symb as char init "-".

params = bal-line.

FORM
   skip(1)
   params
     no-label
      HELP   "Введите через запятую список балансовых счетов 2-го порядка"

WITH FRAME frParam OVERLAY CENTERED ROW 10 TITLE "[ ВВЕДИТЕ СПИСОК СЧЕТОВ 2-ГО ПОРЯДКА ]".

PAUSE 0.
UPDATE
   params
WITH FRAME frParam.
HIDE FRAME frParam NO-PAUSE.
IF NOT (   KEYFUNC(LASTKEY) EQ "GO" 
        OR KEYFUNC(LASTKEY) EQ "RETURN") 
THEN LEAVE.


{setdest.i &cols=100}

put unformatted "                            Отчет по счетам" skip
                "                      с  нулевым остатком на " end-date skip(2).

put unformatted "                      Остаток   " skip.
put unformatted "        СЧЕТ        на " end-date space "    ДПД              КЛИЕНТ  " skip.
put unformatted "-------------------- --------- ---------- -------------------------------" skip.
put unformatted " " skip.


for each acct where acct.open-date < beg-date and acct.close-date = ? 
      and lookup(string(acct.bal-acct),params) > 0 
      by acct.bal-acct by substring (acct.acct,17,4):
       run acct-pos in h_base (acct.acct, acct.currency, end-date, end-date, "√").

put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
  CASE symb :
      WHEN "\\"  THEN symb = "|".
      WHEN "|"   THEN symb = "/".
      WHEN "/"   THEN symb = "-".
      WHEN "-"   THEN symb = "\\".
  END CASE.

/* рубли */
      if acct.currency = "" then do:
         if abs(sh-bal) = 0 then do:
              acount = acount + 1.
              if lastmove = ? then lm = "          ".
              if lastmove <> ? then lm = string(lastmove,"99/99/9999"). 
               if acct.cust-cat = "Ч" then do:
                 find first person where person.person-id = acct.cust-id no-error.
                 if avail(person) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-bal),">>>>>9.99") space
                                    lm space
                                    person.first-names space person.name-last skip.
                 end.
               end.
               if acct.cust-cat = "Ю" then do:
                 find first cust-corp where cust-corp.cust-id = acct.cust-id no-error.
                 if avail(cust-corp) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-bal),">>>>>9.99") space 
                                    lm space
                                    string(cust-corp.name-corp,"x(40)") skip.
                 end.
               end.

         end.
      end.

/* валюта */
      if acct.currency <> "" then do:
         if abs(sh-val) = 0 then do:
              acount = acount + 1.
              if lastcurr = ? then lm = "          ".
              if lastcurr <> ? then lm = string(lastcurr,"99/99/9999"). 
               if acct.cust-cat = "Ч" then do:
                 find first person where person.person-id = acct.cust-id no-error.
                 if avail(person) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-val),">>>>>9.99") space
                                    lm space
                                    person.first-names space person.name-last skip.
                 end.
               end.
               if acct.cust-cat = "Ю" then do:
                 find first cust-corp where cust-corp.cust-id = acct.cust-id no-error.
                 if avail(cust-corp) then do:     
                    put unformatted string(acct.acct,"x(20)") space string(abs(sh-val),">>>>>9.99") space 
                                    lm space
                                    string(cust-corp.name-corp,"x(60)") skip.
                 end.
               end.

         end.
      end.
end.

i = 2.

bal[1] = params.
{wordwrap.i
	&s =bal 
	&l =40
        &n =20}

put unformatted "-------------------- --------- ---------- -------------------------------" skip.
put unformatted	"Лицевых счетов c нулевым остатком на " end-date skip.
put unformatted	"открытых на счетах 2-го порядка:" bal[1] skip. 
    DO WHILE (bal[i] NE ""):
        PUT UNFORMATTED "                                " string(bal[i],"x(40)") skip.
       i = i + 1.
    END.
put unformatted "ВСЕГО : " string(acount) skip.

{preview.i}

