{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}
{exp-path.i &exp-filename = "'analiz/op_' + string(day(beg-date),'99') + 
                            string(month(beg-date),'99') + string(year(beg-date),'9999') + '_' +
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var symb as char no-undo.
def var dt_cur as date no-undo.
def var dbacc as char no-undo.
def var cracc as char no-undo.
def var sumr as dec no-undo.
def var sumv as dec no-undo.

symb = "-".

DO dt_cur = beg-date TO end-date :

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается " + STRING(dt_cur,"99/99/9999") + STRING(" ","X(55)").

   FOR EACH op WHERE op-date EQ dt_cur
           NO-LOCK :

      put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      FOR EACH op-entry WHERE op.op EQ op-entry.op
              NO-LOCK BREAK BY op-entry:
         CASE symb :
             WHEN "\\"  THEN symb = "|".
             WHEN "|"   THEN symb = "/".
             WHEN "/"   THEN symb = "-".
             WHEN "-"   THEN symb = "\\".
         END CASE.

         IF (op-entry.acct-db EQ ?) OR (op-entry.acct-cr EQ ?)
         THEN DO:
            IF (op-entry.acct-db EQ ?) THEN cracc = op-entry.acct-cr.
            IF (op-entry.acct-cr EQ ?) THEN dbacc = op-entry.acct-db.
            IF (op-entry.currency NE "") THEN ASSIGN sumr = op-entry.amt-rub sumv = op-entry.amt-cur.
            IF (dbacc EQ "") OR (cracc EQ "") THEN NEXT.
         end.
         ELSE ASSIGN dbacc = op-entry.acct-db cracc = op-entry.acct-cr sumr = op-entry.amt-rub sumv = op-entry.amt-cur.
         .
         put unformatted skip op.op-date FORMAT "99/99/9999" " "
                           op.doc-num FORMAT "x(6)" " "
                           op.doc-kind FORMAT "x(1)" " "
                           op.op-status FORMAT "x(4)" " "
                           op-entry.type FORMAT "x(3)" " "
                           dbacc FORMAT "x(25)" " "
                           cracc FORMAT "x(25)" " "
                           op-entry.currency format "x(3)" " "
                           sumv format "->>>>>>>>>>>9.99" " "
                           sumr format "->>>>>>>>>>>9.99" " "
                           op-entry.symbol format "x(2)" " "
                           op.user-id format "x(8)" " "
                           op.order-pay format "x(2)" " "
                           op-entry.op-cod format "x(8)" " ".

      ASSIGN dbacc = "" cracc = "".
      end.
   end.
end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

