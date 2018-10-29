{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}
{exp-path.i &exp-filename = "'analiz/deal_date.txt"'

}

def var symb as char no-undo.
def var dealdt_ as char no-undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатываются счета" + STRING(" ","X(60)").

   FOR EACH acct WHERE open-date LE end-date
                         AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )  
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      dealdt_ = TRIM(GetXAttrValue("acct", acct.acct + "," + acct.currency,"DealEndDate")). 
      IF ( dealdt_ NE "" ) THEN put unformatted skip acct.acct FORMAT "x(20)" " "
                                   DATE(dealdt_) format "99/99/9999" " "
                                   end-date format "99/99/9999".
   end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

