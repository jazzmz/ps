{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}

{exp-path.i &exp-filename = "'f102_' + string(day(end-date),'99') + 
                            string(month(end-date),'99') + 
			    string(year(end-date),'9999') + '.txt'"
}

def var vald as dec no-undo.
def var valk as dec no-undo.
def var rest as dec no-undo.
def var symb as char no-undo.
def var dt_cur as date no-undo.
def var unk as char no-undo.

symb = "-".

dt_cur = end-date.

   put screen col 1 row 24 
       "Обрабатывается " + STRING(dt_cur,"99/99/9999") + STRING(" ","X(55)").

   FOR EACH acct WHERE open-date LE dt_cur
                         AND ( ( close-date GE dt_cur ) OR ( close-date EQ ? ) ) 
                         AND CAN-DO("706*",acct)
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 "(" + symb + ")" .

/* полезли за остатками по счету  */
      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              dt_cur,
                              dt_cur,
                              gop-status).

      rest  = if ( sh-bal > 0) then sh-bal / 1000 else ( sh-bal * -1) / 1000.
/*
      if rest EQ 0 then DO:
         rest = sh-cr.
         rest = if ( sh-db > rest) then sh-db else rest.
      END.
      IF rest < 0 then rest = rest * -1.
*/
      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      IF GetXAttrValue("acct",acct.acct + "," + acct.currency,"f102_cur") EQ "yes" then
         put unformatted skip SUBSTR(acct.acct,14,5) FORMAT "x(5)" " "
/*                           acct.acct " "   */
                           0    FORMAT "->>>>>>>>>>>9.99" " "
                           rest FORMAT "->>>>>>>>>>>9.99" " "
                           rest FORMAT "->>>>>>>>>>>9.99".
      ELSE
         put unformatted skip SUBSTR(acct.acct,14,5) FORMAT "x(5)" " "
                           /* acct.acct " " */
                           rest FORMAT "->>>>>>>>>>>9.99" " "
                           0    FORMAT "->>>>>>>>>>>9.99" " "
                           rest FORMAT "->>>>>>>>>>>9.99".
   end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

