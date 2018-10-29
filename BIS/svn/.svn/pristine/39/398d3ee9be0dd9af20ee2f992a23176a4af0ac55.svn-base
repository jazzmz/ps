{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{g-defs.i}
{sh-defs.i}
{getdate.i}


/* Временная таблица с клиентами , счетами и оквэд */
DEFINE NEW SHARED TEMP-TABLE cli-acc-ok
        FIELD cli-name AS CHAR 
        FIELD account  AS CHAR 
        FIELD kodokved AS CHAR 
        FIELD rest     AS DECIMAL
        INDEX cli-name cli-name
        INDEX account  account
        INDEX kodokved kodokved
.


def var symb    as char no-undo.
def var okved   as char no-undo.
def var mask    as char no-undo.
def var OutNull as int  INIT 1 no-undo.

symb = "-".

RUN getstr.p("ВВЕДИТЕ МАСКУ СЧЕТА",OUTPUT mask).


MESSAGE "Выводить счета с нулевыми остатками?" VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO SET choice AS LOGICAL.
   IF choice EQ NO THEN OutNull = 0.


put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается справочник юрлиц" + STRING(" ","X(48)").

FOR EACH cust-corp NO-LOCK BREAK BY cust-id:

    okved = ENTRY(1,GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"ОКВЭД","")).

    FOR EACH acct WHERE acct.cust-cat EQ "Ю" 
        AND acct.cust-id EQ cust-corp.cust-id 
        AND CAN-DO(mask, acct.acct)
        NO-LOCK BREAK BY acct.acct:

        put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.

        /* полезли за остатками по счету  */
        RUN acct-pos IN h_base (acct.acct,
                                acct.currency,
                                end-date,
                                end-date,
                                CHR(251)).

        CREATE cli-acc-ok.
        ASSIGN
            cli-acc-ok.cli-name = TRIM(TRIM(cust-stat) + " " + TRIM(name-corp))
            cli-acc-ok.account  = acct.acct
            cli-acc-ok.kodokved = okved
            cli-acc-ok.rest     = if ( sh-bal < 0 ) then ( sh-bal * -1 ) else sh-bal
        .
    END.
END.




/* вывод отчета  */

put screen col 1 row 24 color bright-blink-normal 
       "Формирование отчета по ОКВЭД" + STRING(" ","X(51)").

{setdest.i &cols=130}

FOR EACH cli-acc-ok NO-LOCK BREAK BY kodokved BY cli-name /* BY account*/ :
    put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
    CASE symb :
       WHEN "\\"  THEN symb = "|".
       WHEN "|"   THEN symb = "/".
       WHEN "/"   THEN symb = "-".
       WHEN "-"   THEN symb = "\\".
    END CASE.
    ACCUMULATE cli-acc-ok.rest (TOTAL).
    IF ( OutNull=1 ) OR ( cli-acc-ok.rest NE 0 ) THEN 
    put unformatted cli-acc-ok.cli-name FORMAT "x(50)" " "
                    cli-acc-ok.kodokved FORMAT "x(10)" " "
                    cli-acc-ok.account  FORMAT "x(20)" " "
                    cli-acc-ok.rest     FORMAT "->>>,>>>,>>>,>>9.99" " " SKIP.
END.

put unformatted "-------------------------------------------------- ---------- -------------------- -------------------" SKIP
                "Итого по всем счетам                                                               " 
                    ACCUM TOTAL cli-acc-ok.rest FORMAT "->>>,>>>,>>>,>>9.99" " " SKIP.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").


{preview.i}
