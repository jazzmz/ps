{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}
{exp-path.i &exp-filename = "'analiz/closeanl_' + string(day(beg-date),'99') + 

                            string(month(beg-date),'99') + string(year(beg-date),'9999') + '_' +
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var cur as char no-undo.
def var symb as char no-undo.
def var unk as char no-undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатываются закрытые счета" + STRING(" ","X(50)").

   FOR EACH acct WHERE open-date LE end-date
                         AND ( ( ( close-date GE beg-date ) AND ( close-date LE end-date ) )  OR ( close-date EQ ? ) )  
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

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

         put unformatted skip acct.acct FORMAT "x(20)" " "
                           cur FORMAT "x(3)"  " "
                           unk FORMAT "x(12)" " "
                           open-date format "99/99/9999" " "
                           close-date format "99/99/9999" " "
                           lastmove format "99/99/9999".
   end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

