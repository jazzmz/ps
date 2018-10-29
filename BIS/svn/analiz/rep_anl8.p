{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}
{exp-path.i &exp-filename = "'analiz/anl0_' + string(day(beg-date),'99') + 

                            string(month(beg-date),'99') + string(year(beg-date),'9999') + '_' +
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var cur as char no-undo.

def var vald as dec no-undo.
def var valk as dec no-undo.
def var valdv as dec no-undo.
def var valkv as dec no-undo.
def var restsum as dec no-undo.
def var turndsum as dec no-undo.
def var turncsum as dec no-undo.
def var symb as char no-undo.
def var dt_cur as date no-undo.
def var unk as char no-undo.

symb = "-".

DO dt_cur = beg-date TO end-date :

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается " + STRING(dt_cur,"99/99/9999") + STRING(" ","X(55)").

   FOR EACH acct WHERE open-date LE dt_cur
                         AND ( ( close-date GE dt_cur ) OR ( close-date EQ ? ) )  
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

/* полезли за остатками по счету  */
      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              dt_cur,
                              dt_cur,
                              CHR(251)).

      assign
         vald  = if ( sh-bal > 0 ) then sh-bal else 0 
         valk  = if ( sh-bal < 0 ) then sh-bal else 0 
         valdv = if ( sh-val > 0 ) then sh-val else 0 
         valkv = if ( sh-val < 0 ) then sh-val else 0 
         restsum = sh-val + sh-bal
         turndsum = sh-db + sh-vdb 
         turncsum = sh-cr + sh-vcr
      .
      cur = if acct.currency = "" then "810" else acct.currency.

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      IF cust-cat EQ "Ч" THEN unk = TRIM(GetXAttrValue("person", STRING(cust-id), "УНК")).
      IF cust-cat EQ "Ю" THEN unk = TRIM(GetXAttrValue("cust-corp", STRING(cust-id), "УНК")).
      IF cust-cat EQ "Б" THEN unk = TRIM(GetXAttrValue("banks", STRING(cust-id), "УНК")).
      IF cust-cat EQ "В" THEN unk = "0".
      IF lastmove EQ ? THEN lastmove = DATE("01/01/1990").

      IF (restsum EQ 0) AND (turndsum EQ 0) AND (turncsum EQ 0) THEN  
         put unformatted skip acct.acct FORMAT "x(20)" " "
                           cur FORMAT "x(3)" " "
                           unk FORMAT "x(10)" " "
                           open-date format "99/99/9999" " "
                           close-date format "99/99/9999" " "
                           dt_cur format "99/99/9999" " "
                           sh-vdb  FORMAT "->>>>>>>>>>>9.99" " "
                           sh-db   FORMAT "->>>>>>>>>>>9.99" " "
                           sh-vcr  FORMAT "->>>>>>>>>>>9.99" " "
                           sh-cr   FORMAT "->>>>>>>>>>>9.99" " "
                           valdv FORMAT "->>>>>>>>>>>9.99" " "
                           vald  FORMAT "->>>>>>>>>>>9.99" " "
                           valkv FORMAT "->>>>>>>>>>>9.99" " "
                           valk  FORMAT "->>>>>>>>>>>9.99" " "
                           lastmove format "99/99/9999".
   end.
end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

