{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}

DEF VAR vStr      AS CHAR NO-UNDO.

{getdate.i}

RUN getstr.p("ВВЕДИТЕ СЧЕТА",OUTPUT vStr).

def var vald as dec no-undo.
def var valk as dec no-undo.
def var valdv as dec no-undo.
def var valkv as dec no-undo.
def var restsum as dec no-undo.
def var symb as char no-undo.

DEF VAR vName AS CHAR EXTENT 2 NO-UNDO. /* для формирования имени клиента */

{setdest.i &cols=80}

symb = "-".

   put screen col 1 row 24 
       "Обрабатывается " + STRING(end-date,"99/99/9999") + STRING(" ","X(55)").

   FOR EACH bal-acct WHERE CAN-DO(vStr,STRING(bal-acct.bal-acct,"99999")) NO-LOCK,
       EACH acct OF bal-acct WHERE open-date LE end-date
                           AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )  
           NO-LOCK USE-INDEX acct-cust :

   put screen col 77 row 24 "(" + symb + ")" .

   
   {getcust.i &name=vName  &OFFinn="/*"} 

   vName[1] = TRIM(vName[1]) + " " +  TRIM(vName[2]).
/* полезли за остатками по счету  */
      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

      restsum = if ( sh-val < 0 ) then sh-val else sh-bal.
      restsum = if ( restsum < 0 ) then ( restsum * -1 ) else restsum.

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

         put unformatted skip acct.acct FORMAT "x(20)" " "
                           vName[1] FORMAT "x(40)" " "
                           restsum FORMAT "->>>>>>>>>>>9.99".
end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

{signatur.i &user-only=yes}
{preview.i}
