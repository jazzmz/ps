{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}
{loan.pro}
{ulib.i}

/* Add by Maslov D.
   Инклюдник подключает функцию определения
   номера договора по записи в таблице
*/
{pir-getdocnum.i}

{exp-path.i &exp-filename = "'analiz/sr_st_' + 

                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

DEF INPUT PARAMETER loanclasses AS CHAR NO-UNDO.
DEF VAR symb AS char no-undo.
DEF VAR isReady2Close AS CHARACTER INITIAL ?  No-Undo.
DEF VAR oTAcct AS TAcct  No-Undo.
DEF VAR oLoan AS TLoan NO-UNDO.
DEF VAR oAArray  AS TAArray NO-UNDO.
DEF var tempamount   as DEC NO-UNDO.
def var temp as dec init 0 no-undo.
def var dComm-rate as dec init 0 no-undo.

 def var PeriodBase as int no-undo.

 DEF VAR dKr         AS DEC INIT 0    NO-UNDO.
 DEF VAR dKr840      AS DEC INIT 0    NO-UNDO.
 DEF VAR dKr978      AS DEC INIT 0    NO-UNDO.

 DEF VAR dKrProc         AS DEC INIT 0    NO-UNDO.
 DEF VAR dKrProc840      AS DEC INIT 0    NO-UNDO.
 DEF VAR dKrProc978      AS DEC INIT 0    NO-UNDO.

 DEF VAR dDep         AS DEC INIT 0    NO-UNDO.
 DEF VAR dDep840      AS DEC INIT 0    NO-UNDO.
 DEF VAR dDep978      AS DEC INIT 0    NO-UNDO.

 DEF VAR dDepProc         AS DEC INIT 0    NO-UNDO.
 DEF VAR dDepProc840      AS DEC INIT 0    NO-UNDO.
 DEF VAR dDepProc978      AS DEC INIT 0    NO-UNDO.

symb = "-".

 do /* end-date = 05/01/13 to 06/11/13 */:
                            
 periodBase = (IF TRUNCATE(YEAR(end-date) / 4,0) = YEAR(end-date) / 4 THEN 366 ELSE 365).


   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база договоров" +  STRING(" ","X(50)").

dKr = 0.
dKr840 = 0.
dKr978 = 0.

dKrProc = 0.
dKrProc840 = 0.
dKrProc978 = 0.

   FOR EACH loan  WHERE ( open-date <= end-date )                             
                    AND ( ( close-date >= end-date ) OR ( close-date = ? ) )  
		    AND (loan.contract = "Кредит")
                    and CAN-DO("!НО*,!Ц*,!НО*,*",loan.cont-code)
                    and CAN-DO("loan_allocat,loan-transh,l_agr_with_diff,loan_c",loan.class-code)
		    NO-LOCK,
       each loan-acct where loan-acct.contract = loan.contract 
                        and loan-acct.cont-code = loan.cont-code
                        and (loan-acct.acct-type = "Кредит" or  loan-acct.acct-type = "КредПр")
                        and loan-acct.since <= end-date
                        and CAN-DO("!5*,*",loan-acct.acct)
                    NO-LOCK,
       LAST loan-cond WHERE loan-cond.contract  = loan.contract 
                       AND loan-cond.cont-code = loan.cont-code 
                       AND loan-cond.since < end-date NO-LOCK.

       RUN acct-pos IN h_base (loan-acct.acct,
                               loan-acct.currency,
                               end-date,
                               end-date,
                                 ?).


          sh-bal = ABS(sh-bal).
          sh-val = ABS(sh-val).


       FIND LAST comm-rate WHERE comm-rate.kau = loan.contract + "," + loan.cont-code
                             AND comm-rate.since <= loan-cond.since 
                             AND comm-rate.commission = (IF loan-acct.acct-type = "кредит" THEN "%Кред" ELSE "%КрПр") 
                             NO-LOCK NO-ERROR.

        if (sh-bal <> 0) OR (sh-val <> 0) and available comm-rate then 
        do:

         if loan.currency = "" then do: 
                                       dKr = dKr + sh-bal.
                                       dKrProc = dKrProc + ((sh-bal * comm-rate.rate-comm) ).
                                    end.

         if loan.currency = "840" then do: 
                                         dKr840 = dKr840 + sh-val.
                                         dKrProc840 = dKrProc840 + ((sh-val * comm-rate.rate-comm) ).

                                       end.
         if loan.currency = "978" then do: 
                                         dKr978 = dKr978 + sh-val.
                                         dComm-rate = comm-rate.rate-comm.
                                         if loan.cont-code = '17/09' then dComm-rate = 23.
                                         dKrProc978 = dKrProc978 + ((sh-val * dComm-rate) ).

                                       end.

        END.


    END.

dKrProc = ROUND((dKrProc / dKr),2).
dkrProc840 = ROUND((dKrProc840 / dKr840),2).
dKrProc978 = ROUND((dKrProc978 / dKr978),2).


put unformatted skip "Ср_ставка_Кр810      " STRING(end-date,"99/99/99") '              ' STRING(ROUND(dKrProc,2),">>9.99") SKIP. 
put unformatted skip "Ср_ставка_Кр840      " STRING(end-date,"99/99/99") '              ' STRING(ROUND(dKrProc840,2),">>9.99") SKIP. 
put unformatted skip "Ср_ставка_Кр978      " STRING(end-date,"99/99/99") '              ' STRING(ROUND(dKrProc978,2),">>9.99") SKIP. 

/*сначала посчитали по кредитам*/

/*теперь считаем по депозитам*/

dDep = 0.
dDep840 = 0.
dDep978 = 0.

dDepProc = 0.
dDepProc840 = 0.
dDepProc978 = 0.



    
   FOR EACH loan  WHERE ( open-date LE end-date )                             
                    AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )  
		    AND (loan.contract = "Депоз")
		    NO-LOCK,
       each loan-acct where loan-acct.contract = loan.contract 
                        and loan-acct.cont-code = loan.cont-code
                        and loan-acct.acct-type = "Депоз" 
                        and loan-acct.since <= end-date
                        and CAN-DO("!523*,*",loan-acct.acct)
                    NO-LOCK,
       LAST loan-cond WHERE loan-cond.contract  = loan.contract 
                       AND loan-cond.cont-code = loan.cont-code 
                       AND loan-cond.since < end-date NO-LOCK,
       LAST comm-rate WHERE comm-rate.kau = loan.contract + "," + loan.cont-code
                       AND comm-rate.since <= loan-cond.since 
                       AND comm-rate.commission = "%Деп" NO-LOCK:


         RUN acct-pos IN h_base (loan-acct.acct,
                                 loan-acct.currency,
                                 end-date,
                                 end-date,
                                 ?).

          sh-bal = ABS(sh-bal).
          sh-val = ABS(sh-val).
         if loan.currency = "" then do: 
                                       dDep = dDep + sh-bal.
                                       dDepProc = dDepProc + ((sh-bal * comm-rate.rate-comm) ).
/*                                     put unformatted loan.cont-code " " loan.currency " "sh-bal " " comm-rate.rate-comm skip.*/
                                       temp = temp + sh-val.
                                       tempAmount = tempAmount + ((sh-val * dComm-rate) ). 

                                    end.

         if loan.currency = "840" then do: 
                                         dDep840 = dDep840 + sh-val.
                                         dDepProc840 = dDepProc840 + ((sh-val * comm-rate.rate-comm) ).

                                       end.
         if loan.currency = "978" then do: 
                                         dDep978 = dDep978 + sh-val.
                                         dDepProc978 = dDepProc978 + ((sh-val * comm-rate.rate-comm) ).

                                       end.



   END.         

/*пробежали по депозитам юрлиц, теперь побежим по депозитам физлиц :(*/
   FOR EACH loan  WHERE ( open-date LE end-date )                             
                    AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )  
                    AND (loan.contract = "dps")
                    NO-LOCK,
       last loan-acct where loan-acct.contract = loan.contract 
                        and loan-acct.cont-code = loan.cont-code
                        and loan-acct.acct-type = "loan-dps-t" 
                        and loan-acct.since <= end-date
                    NO-LOCK:


         dComm-rate = 0.
         dComm-rate = getDpsRateComm(BUFFER loan:HANDLE,end-date,TRUE).

         sh-bal = 0.
         sh-val = 0.

           RUN acct-pos IN h_base (loan-acct.acct,
                                 loan-acct.currency,
                                 end-date,
                                 end-date,
                                 ?).


          sh-bal = ABS(sh-bal).
          sh-val = ABS(sh-val).


         if loan.currency = "" then do: 
                                       dDep = dDep + sh-bal.
                                       dDepProc = dDepProc + ((sh-bal * dComm-rate) ).
/*                                       temp = temp + sh-bal.
                                       tempAmount = tempAmount + ((sh-bal * dComm-rate) ).    */

/*     put unformatted loan.cont-code " " loan-acct.acct "    " loan.currency "    " sh-bal "    " dComm-rate skip.*/

                                    end.

         if loan.currency = "840" then do: 

                                         dDep840 = dDep840 + sh-val.
                                         dDepProc840 = dDepProc840 + ((sh-val * dComm-rate) ).

                                       end.

         if loan.currency = "978" then do: 
                                         dDep978 = dDep978 + sh-val.
                                         dDepProc978 = dDepProc978 + ((sh-val * dComm-rate) ).

                                       end.



 



   END.
  
dDepProc = ROUND((dDepProc / dDep),2).
dDepProc840 = ROUND((dDepProc840 / dDep840),2).
dDepProc978 = ROUND((dDepProc978 / dDep978),2).


put unformatted skip "Ср_ставка_Деп810     " STRING(end-date,"99/99/99") '              ' STRING(ROUND(dDepProc,2),">>9.99") SKIP. 
put unformatted skip "Ср_ставка_Деп840     " STRING(end-date,"99/99/99") '              ' STRING(ROUND(dDepProc840,2),">>9.99") SKIP. 
put unformatted skip "Ср_ставка_Деп978     " STRING(end-date,"99/99/99") '              ' STRING(ROUND(dDepProc978,2),">>9.99") SKIP. 

    

end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").



