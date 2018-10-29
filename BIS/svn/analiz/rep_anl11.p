{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}

{exp-path.i &exp-filename = "'analiz/prz_' + string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var risk as char no-undo.
def var symb as char no-undo.

symb = "-".

   put screen col 1 row 24 
       "Обрабатывается " + STRING(end-date,"99/99/9999") + STRING(" ","X(55)").

   FOR EACH acct WHERE open-date LE end-date
                         AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) ) 
                         AND ( CAN-DO ("9*", STRING(acct.bal-acct)) )
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 "(" + symb + ")" .

   risk = GetTempXAttrValueEx("acct", acct.acct + "," + acct.currency, "deriv", end-date,"").
   IF ( risk NE "" ) THEN risk = ENTRY(2,risk,",").

      CASE risk :
          WHEN "001"   THEN risk = "100".
          WHEN "002"   THEN risk = "50".
          WHEN "003"   THEN risk = "20".
          WHEN "004"   THEN risk = "0".
      END CASE.

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      IF (risk NE "" ) AND (risk <> "0") THEN  
         put unformatted skip acct.acct FORMAT "x(20)" " "
                           risk FORMAT "x(3)" " " end-date FORMAT "99/99/9999".
   end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

