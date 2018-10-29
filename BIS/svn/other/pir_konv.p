{globals.i}
{sh-defs.i}
{getdate.i}


 DEFINE BUFFER mCard    FOR Loan.
 DEFINE VAR    mDel   AS LOGICAL  NO-UNDO.
 DEFINE VAR    n   AS INTEGER  NO-UNDO.
 
DEFINE VAR max-cust AS INTEGER   NO-UNDO.
DEFINE VAR num-cust AS INTEGER   NO-UNDO.
DEFINE VAR name-cust   AS CHARACTER NO-UNDO.
DEFINE TEMP-TABLE ttResults
   FIELD ttf_code AS CHAR
   FIELD ttf_owner AS CHAR
   FIELD ttf_acct AS CHAR
   FIELD ttf_bal AS DEC
INDEX idx_acct IS PRIMARY ttf_acct.

max-cust = 0.
num-cust = 0.
FOR EACH  loan  where   (loan.contract  eq "card-pers" or 
                         loan.contract  eq "card-corp") and
                        can-do("*RUR*",loan.cont-code) no-lock,
         first mCard where   mCard.contract  eq "card" and
                        mCard.parent-cont-code eq loan.cont-code and  
                        mCard.loan-work eq yes /*and mCard.loan-status eq "АКТ"*/
 no-lock :                        
       if avail loan then 
       do:
       name-cust = "Поиск договоров (RUR):" + STRING(max-cust). 
       {init-bar.i """ + name-cust + ""}
       max-cust = max-cust + 1.                 
       end.
END.                        

/* конец отбора */

name-cust = "Обработка договоров (RUR):" + STRING(max-cust).
{init-bar.i """ + name-cust + ""}

FOR EACH  loan  where   (loan.contract  eq "card-pers" or 
                         loan.contract  eq "card-corp") and
                        can-do("*RUR*",loan.cont-code)  no-lock,
         first mCard where   mCard.contract  eq "card" and
                        mCard.parent-cont-code eq loan.cont-code and  
                        mCard.loan-work eq yes 	/* and mCard.loan-status eq "АКТ" */
 use-index cont no-lock :                        

 num-cust = num-cust + 1.
     {move-bar.i num-cust max-cust}

 FOR each loan-acct OF loan where  loan-acct.cont-code eq loan.cont-code 
   and can-do("SCS@840,SCS@978",loan-acct.acct-type) use-index cont-code no-lock:

  

       IF AVAIL loan-acct then 
       Do:

                RUN acct-pos IN h_base (loan-acct.acct,
                                 loan-acct.currency,
                                 end-date,
                                 end-date,
                                 gop-status).
       if loan-acct.currency ne "" and ABS(sh-val) > 0.00  then 
          do:
          CREATE ttResults. 
          ASSIGN 
             ttResults.ttf_code = loan-acct.cont-code
             ttResults.ttf_acct = loan-acct.acct
             ttResults.ttf_bal = ABS(sh-val).
          end.                               

       if loan-acct.currency eq "" and ABS(sh-bal) > 0.00  then 
          do:
          CREATE ttResults. 
          ASSIGN 
             ttResults.ttf_code = loan-acct.cont-code
             ttResults.ttf_acct = loan-acct.acct
             ttResults.ttf_bal = ABS(sh-bal).
             END.                                
       END. 

   END.
   
END.

FOR EACH  loan  where   (loan.contract  eq "card-pers" or 
                         loan.contract  eq "card-corp") and
                        can-do("*USD*",loan.cont-code) no-lock,
         first mCard where   mCard.contract  eq "card" and
                        mCard.parent-cont-code eq loan.cont-code and  
                        mCard.loan-work eq yes /*and mCard.loan-status eq "АКТ"	*/
 no-lock :                        
       if avail loan then 
       do:
       name-cust = "Поиск договоров (USD):" + STRING(max-cust). 
       {init-bar.i """ + name-cust + ""}
       max-cust = max-cust + 1.                 
       end.
END.                        

/* конец отбора */

name-cust = "Обработка договоров (USD):" + STRING(max-cust).
{init-bar.i """ + name-cust + ""}

FOR EACH  loan  where   (loan.contract  eq "card-pers" or 
                         loan.contract  eq "card-corp") and
                        can-do("*USD*",loan.cont-code)  no-lock,
         first mCard where   mCard.contract  eq "card" and
                        mCard.parent-cont-code eq loan.cont-code and  
                        mCard.loan-work eq yes /* and mCard.loan-status eq "АКТ" */
 use-index cont no-lock :                        

 num-cust = num-cust + 1.
     {move-bar.i num-cust max-cust}

   FOR each loan-acct OF loan where  loan-acct.cont-code eq loan.cont-code 
   and can-do("SCS@,SCS@978",loan-acct.acct-type) use-index cont-code no-lock:

  

       IF AVAIL loan-acct then 
       Do:

                RUN acct-pos IN h_base (loan-acct.acct,
                                 loan-acct.currency,
                                 end-date,
                                 end-date,
                                 gop-status).
       if loan-acct.currency ne "" and ABS(sh-val) > 0.00  then 
          do:
          CREATE ttResults. 
          ASSIGN 
             ttResults.ttf_code = loan-acct.cont-code
             ttResults.ttf_acct = loan-acct.acct
             ttResults.ttf_bal = ABS(sh-val).
          end.                                

       if loan-acct.currency eq "" and ABS(sh-bal) > 0.00  then 
          do:
          CREATE ttResults. 
          ASSIGN 
             ttResults.ttf_code = loan-acct.cont-code
             ttResults.ttf_acct = loan-acct.acct
             ttResults.ttf_bal = ABS(sh-bal).
          end.                                
       END.

   END.
   
END.

FOR EACH  loan  where   (loan.contract  eq "card-pers" or 
                         loan.contract  eq "card-corp") and
                        can-do("*EUR*",loan.cont-code) no-lock,
         first mCard where   mCard.contract  eq "card" and
                        mCard.parent-cont-code eq loan.cont-code and  
                        mCard.loan-work eq yes /* and mCard.loan-status eq "АКТ" */
 no-lock :                        
       if avail loan then 
       do:
       name-cust = "Поиск договоров (EUR):" + STRING(max-cust). 
       {init-bar.i """ + name-cust + ""}
       max-cust = max-cust + 1.                 
       end.
END.                        

/* конец отбора */

name-cust = "Обработка договоров (EUR):" + STRING(max-cust).
{init-bar.i """ + name-cust + ""}


FOR EACH  loan  where   (loan.contract  eq "card-pers" or 
                         loan.contract  eq "card-corp") and
                        can-do("*EUR*",loan.cont-code)  no-lock,
         first mCard where   mCard.contract  eq "card" and
                        mCard.parent-cont-code eq loan.cont-code and  
                        mCard.loan-work eq yes /* and mCard.loan-status eq "АКТ" */
 use-index cont no-lock :                        

 num-cust = num-cust + 1.
     {move-bar.i num-cust max-cust}

   FOR each loan-acct OF loan where  loan-acct.cont-code eq loan.cont-code 
   and can-do("SCS@,SCS@840",loan-acct.acct-type) use-index cont-code no-lock:

  

       IF AVAIL loan-acct then 
       Do:

                RUN acct-pos IN h_base (loan-acct.acct,
                                 loan-acct.currency,
                                 end-date,
                                 end-date,
                                 gop-status).
       if loan-acct.currency ne "" and ABS(sh-val) > 0.00  then 
          do:
          CREATE ttResults. 
          ASSIGN 
             ttResults.ttf_code = loan-acct.cont-code
             ttResults.ttf_acct = loan-acct.acct
             ttResults.ttf_bal = ABS(sh-val).
          end.                                

       if loan-acct.currency eq "" and ABS(sh-bal) > 0.00  then 
          do:
          CREATE ttResults. 
          ASSIGN 
             ttResults.ttf_code = loan-acct.cont-code
             ttResults.ttf_acct = loan-acct.acct
             ttResults.ttf_bal = ABS(sh-bal).
          end.                                
       END.

   END.
   
END.

{setdest.i &cols=200}
PUT UNFORMATTED "               ОТЧЕТ ПО ОСТАТКАМ НА ВСПОМОГАТЕЛЬНЫХ СКС".

FOR EACH acct WHERE acct.acct EQ ttResults.ttf_acct:
   ASSIGN ttResults.ttf_owner = acct.details.
END.

FOR EACH ttResults:
DISPLAY 
   ttResults.ttf_code LABEL "Код дог." FORMAT "x(12)"
   ttResults.ttf_owner LABEL "Владелец" FORMAT "x(25)"
   ttResults.ttf_acct LABEL "Счет" FORMAT "x(20)"
   ttResults.ttf_bal LABEL "Остаток".
END.

{preview.i}