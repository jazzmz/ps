{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}
{intrface.get i254}
{loan.pro}

{exp-path.i &exp-filename = "'analiz/grr_' + 
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

DEFINE TEMP-TABLE gracc NO-UNDO
   FIELD acct     AS CHARACTER
   FIELD grrisk   AS INTEGER
   INDEX acct acct
.


def var symb  as char no-undo.
def var cacct as char no-undo.
def var racct as char no-undo.
def var mGrRisk as dec no-undo.
def var nument as int no-undo.
def var crRole as char no-undo.

symb = "-".

crRole  = "КредПр,КредВГар,КредЛин,КредН".

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база договоров" +  STRING(" ","X(50)").

    FOR EACH loan WHERE ( open-date LE end-date ) no-lock:

         put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
         cacct = "".

         CASE symb :
             WHEN "\\"  THEN symb = "|".
             WHEN "|"   THEN symb = "/".
             WHEN "/"   THEN symb = "-".
             WHEN "-"   THEN symb = "\\".
         END CASE.
         find last loan-acct where loan-acct.contract eq loan.contract and
                                   loan-acct.cont-code eq loan.cont-code and
                                   loan-acct.acct-type eq loan.contract and 
                                   loan-acct.since le end-date
                                   no-lock no-error.

         if avail loan-acct then cacct = loan-acct.acct.
         if cacct EQ "" then if length(loan.cont-code)=20 then cacct = loan.cont-code.
         if cacct EQ "" then next.

        if (TRIM(cacct) NE "") THEN DO:
           mGrRisk = LnGetGrRiska(LnRsrvRate (loan.contract,loan.cont-code,end-date), end-date).
           IF mGrRisk EQ ? THEN mGrRisk = loan.gr-riska.
           FIND FIRST gracc where gracc.acct EQ cacct no-lock no-error.
           IF NOT AVAIL gracc THEN DO:
              create gracc.
              gracc.acct = cacct.
              gracc.grrisk = mGrRisk.
              update.    
           END.
        END.
        DO nument=1 to NUM-ENTRIES(crRole):
           find last  loan-acct where loan-acct.contract eq loan.contract and
                                      loan-acct.cont-code eq loan.cont-code and
                                      loan-acct.acct-type eq ENTRY(nument,crRole) and
                                      loan-acct.since le end-date
                                      no-lock no-error.
           if AVAIL loan-acct THEN DO:
              mGrRisk = LnGetGrRiska(LnRsrvRate (loan.contract,loan.cont-code,end-date), end-date).
              IF mGrRisk EQ ? THEN mGrRisk = loan.gr-riska.
              FIND FIRST gracc where gracc.acct EQ loan-acct.acct no-lock no-error.
              IF NOT AVAIL gracc THEN DO:
                 create gracc.
                 gracc.acct = loan-acct.acct.
                 gracc.grrisk = mGrRisk.
                 update.         
              END.
           END.
        END.
    end. 

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база счетов   " +  STRING(" ","X(50)").

   FOR EACH acct WHERE open-date LE end-date
           NO-LOCK BREAK BY acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      racct = "".

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      racct = GetXAttrValue("acct",acct.acct + "," + acct.currency,"ГрРиска").
 
     if (TRIM(acct.acct) NE "") and (TRIM(racct) NE "") THEN DO:
        FIND FIRST gracc where gracc.acct EQ acct.acct no-lock no-error.
        IF NOT AVAIL gracc THEN DO:
           create gracc.
           gracc.acct = acct.acct.
           gracc.grrisk = INT(racct) NO-ERROR.
           update.       
        END.
     END.
   end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

    FOR EACH gracc no-lock:
        IF gracc.GrRisk NE 0 THEN
           put unformatted skip gracc.acct FORMAT "x(25)" " " gracc.GrRisk FORMAT "9" " " end-date FORMAT "99.99.9999".
    END.
