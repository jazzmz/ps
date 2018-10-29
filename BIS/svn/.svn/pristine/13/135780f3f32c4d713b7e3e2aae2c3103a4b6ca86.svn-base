{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{g-defs.i}
{sh-defs.i}
{getdate.i}
{intrface.get acct}

DEFINE INPUT PARAMETER iParmStr AS CHARACTER NO-UNDO.

/* Временная таблица с клиентами , счетами и оквэд */
DEFINE NEW SHARED TEMP-TABLE cli-acc-ok
        FIELD cli-name   AS CHAR 
        FIELD account    AS CHAR 
        FIELD countr     AS CHAR 
        FIELD countr-name  AS CHAR 
        FIELD rest       AS DECIMAL
        INDEX cli-name cli-name
        INDEX account  account
        INDEX countr countr
.

DEFINE VARIABLE vCountryID AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vCustCat AS CHARACTER   NO-UNDO.
DEF VAR Clinm AS CHAR EXTENT 2 NO-UNDO.

def var symb    as char no-undo.
def var countr   as char no-undo.
def var oCountr   as char no-undo.
def var oRest    as dec no-undo.
def var mask    as char no-undo.
def var OutNull as int  INIT 1 no-undo.

symb = "-".
/*
RUN getstr.p("ВВЕДИТЕ МАСКУ СЧЕТА",OUTPUT mask).
*/

MESSAGE "Выводить счета с нулевыми остатками?" VIEW-AS ALERT-BOX QUESTION
           BUTTONS YES-NO SET choice AS LOGICAL.
   IF choice EQ NO THEN OutNull = 0.


put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается справочник клиентов" + STRING(" ","X(48)").
/*
FOR EACH cust-corp WHERE cust-corp.country-id ne "RUS" NO-LOCK BREAK BY cust-id:
*/
    FOR EACH acct WHERE acct.acct-cat EQ "b" 
                    and acct.cust-cat ne "В"
                    and CAN-DO(iParmStr,string(acct.bal-acct))
     NO-LOCK:
     
        put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
        CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
        END CASE.
    RUN GetCountryIdCli(acct.acct,acct.currency, OUTPUT vCountryID,OUTPUT vCustCat).
    
    IF vCountryID ne "RUS" THEN
    DO:
    	 IF acct.details NE ? THEN  Clinm[1] = acct.details.
    	 ELSE 
    	 DO:
    	 {getcust.i &name="clinm" &OFFinn = "/*" &OFFsigns = "/*"}
    	 ASSIGN
       clinm[1] = clinm[1] + " " + clinm[2]
       clinm[2] = ""
       .
       END.
       
      FIND FIRST country WHERE country.country-id EQ vCountryID NO-LOCK NO-ERROR.


        /* полезли за остатками по счету  */
        RUN acct-pos IN h_base (acct.acct,
                                acct.currency,
                                end-date,
                                end-date,
                                CHR(251)).

        CREATE cli-acc-ok.
        ASSIGN
            cli-acc-ok.cli-name = clinm[1]
            cli-acc-ok.account  = acct.acct
            cli-acc-ok.countr  = vCountryID
            cli-acc-ok.countr-name  = country.country-name
            cli-acc-ok.rest     = if ( sh-bal < 0 ) then ( sh-bal * -1 ) else sh-bal
        .
      END.  
    END.
/* END.*/




/* вывод отчета  */

put screen col 1 row 24 color bright-blink-normal 
       "Формирование отчета по ОКВЭД" + STRING(" ","X(51)").

{setdest.i &cols=130}
oCountr = "".
oRest = 0.

FOR EACH cli-acc-ok NO-LOCK BREAK BY countr /*BY cli-name BY account*/ :
    put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
    CASE symb :
       WHEN "\\"  THEN symb = "|".
       WHEN "|"   THEN symb = "/".
       WHEN "/"   THEN symb = "-".
       WHEN "-"   THEN symb = "\\".
    END CASE.
 IF oCountr ne cli-acc-ok.countr and oCountr ne ""  and oRest ne 0 then
 do:
 put unformatted "-------------------------------------------------- --- ---------------------------------------- -------------------- -------------------" SKIP
                 "Итого по стране                                    " +  oCountr + "                                                               " oRest FORMAT "->>>,>>>,>>>,>>9.99"  " " SKIP(1).                   
 oRest = 0.                 
 end.
                     
    ACCUMULATE cli-acc-ok.rest (TOTAL BY countr).
    ACCUMULATE cli-acc-ok.rest (TOTAL).

    IF ( OutNull=1 ) OR ( cli-acc-ok.rest NE 0 ) THEN 
    put unformatted cli-acc-ok.cli-name FORMAT "x(50)" " "
                    cli-acc-ok.countr FORMAT "x(3)" " "
                    cli-acc-ok.countr-name FORMAT "x(40)" " "
                    cli-acc-ok.account  FORMAT "x(20)" " "
                    cli-acc-ok.rest     FORMAT "->>>,>>>,>>>,>>9.99" " " SKIP.

	 oCountr =   cli-acc-ok.countr. 
	 oRest   =  oRest + cli-acc-ok.rest.
END.
 IF oCountr ne ""  and oRest ne 0 then
 do:
 put unformatted "-------------------------------------------------- --- ---------------------------------------- -------------------- -------------------" SKIP
                 "Итого по стране                                    " +  oCountr + "                                                               " oRest FORMAT "->>>,>>>,>>>,>>9.99"  " " SKIP(1).  
 oRest = 0.                 
 end.
 
put unformatted "-------------------------------------------------- --- ---------------------------------------- -------------------- -------------------" SKIP
                "Итого по всем счетам                                                                                                 " 
                    ACCUM TOTAL cli-acc-ok.rest FORMAT "->>>,>>>,>>>,>>9.99" " " SKIP.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").


{preview.i}
