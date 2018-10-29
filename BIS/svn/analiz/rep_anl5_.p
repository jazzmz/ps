{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}
{loan.pro}

{exp-path.i &exp-filename = "'analiz/kred_' + 
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var symb as char no-undo.
def var cacct as char no-undo.
def var edate as date no-undo.
def var dt_cur as date no-undo.

symb = "-".

DO dt_cur = beg-date TO end-date :


   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база договоров" + STRING(dt_cur,"99/99/9999") + STRING(" ","X(40)").

   FOR EACH loan WHERE ( open-date LE dt_cur )
/*                    AND ( ( close-date GE dt_cur ) OR ( close-date EQ ? ) )   */
           NO-LOCK :

      put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
      cacct = "".

      find last loan-acct where loan-acct.contract eq loan.contract and
                                loan-acct.cont-code eq loan.cont-code and
                                loan-acct.acct-type eq loan.contract and 
                                loan-acct.since le end-date
                no-lock no-error .

      if avail loan-acct then cacct = loan-acct.acct.
      if cacct EQ "" then if length(loan.cont-code)=20 then cacct = loan.cont-code.
      if cacct EQ "" then next.
      CASE symb :
           WHEN "\\"  THEN symb = "|".
           WHEN "|"   THEN symb = "/".
           WHEN "/"   THEN symb = "-".
           WHEN "-"   THEN symb = "\\".
      END CASE.

      find first pro-obl where pro-obl.contract    eq loan.contract and
                               pro-obl.cont-code   eq loan.cont-code and
                               pro-obl.idnt        eq 3 and
                               pro-obl.pr-date     >  end-date and
                               pro-obl.n-end-date  >  end-date
                               no-lock no-error.
      IF AVAIL pro-obl THEN DO:
         edate = pro-obl.end-date.
      END.
      ELSE
         edate = loan.end-date.

      IF edate NE ? THEN  put unformatted skip cacct FORMAT "x(25)" " "
                           edate FORMAT "99/99/9999" " "
                           dt_cur FORMAT "99/99/9999".
         
      find last loan-acct where loan-acct.contract eq loan.contract and
                                loan-acct.cont-code eq loan.cont-code and
                                loan-acct.acct-type eq "КредПр" and 
                                loan-acct.since le end-date
                no-lock no-error .

      if avail loan-acct then do:
         cacct = loan-acct.acct.
         edate = dt_cur.
         IF  edate NE ? THEN  put unformatted skip cacct FORMAT "x(25)" " "
                              edate FORMAT "99/99/9999" " "
                              dt_cur FORMAT "99/99/9999".
      end.
   end.
end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

