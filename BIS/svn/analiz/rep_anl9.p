{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}
{loan.pro}

{ulib.i}


{exp-path.i &exp-filename = "'analiz/rez_' + 
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var symb  as char no-undo.
def var cacct as char no-undo.
def var racct as char no-undo.
def var maind as char no-undo.
def var dtype as char no-undo.

define var in-type  as char init  "КредРез" no-undo.
define var in1-type  as char init "КредПр" no-undo.
define var in2-type  as char init "КредРез1" no-undo.
define var in4-type  as char init "КредРезВб" no-undo.

define var POSAccts  as char init "45515810400080000001,45715810200080000001" no-undo.
define var POSAcctsPr  as char init "45818810300080000002,45818810200080000005,45818810600080000003,45818810900080000004" no-undo.
define var POSAcctsKredN  as char init "47425810200080000001" no-undo.
def buffer bloan-acct for loan-acct.
def temp-table tAcct NO-UNDO
	field tcAcct as char
	field trAcct as char
	INDEX tcAcct IS PRIMARY tcAcct
	INDEX trAcct trAcct.

def buffer mainloan for loan.
def buffer loan-acct3 for loan-acct.
def var temploan as char no-undo.
DEFINE VAR max-cust AS INTEGER   NO-UNDO.
DEFINE VAR num-cust AS INTEGER   NO-UNDO.
DEFINE VAR name-cust   AS CHARACTER NO-UNDO.

max-cust = 0.
num-cust = 0.

symb = "-".


    for each loan where loan.contract eq "Кредит" no-lock:
       name-cust = "Обработка договоров:" + STRING(max-cust).
       {init-bar.i """ + name-cust + ""}
       max-cust = max-cust + 1.    
    end.



       FOR EACH acct WHERE open-date LE end-date
                         AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )  
                         AND NOT CAN-DO("45*", acct.acct)
       NO-LOCK BREAK BY acct :
       name-cust = "Обработка счетов:" + STRING(max-cust).
       {init-bar.i """ + name-cust + ""}
       max-cust = max-cust + 1.    
    end.
                                              

name-cust = "Обработка :" + STRING(max-cust).   
{init-bar.i """ + name-cust + ""}  

/*   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база договоров" +  STRING(" ","X(50)"). */


/*    for each loan where loan.contract eq "Кредит" and  loan.cont-type ne "Течение" no-lock: */
    for each loan where loan.contract eq "Кредит" no-lock:

     num-cust = num-cust + 1. 
     {move-bar.i num-cust max-cust}       

         put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
         cacct = "".
         racct = "".

         CASE symb :
             WHEN "\\"  THEN symb = "|".
             WHEN "|"   THEN symb = "/".
             WHEN "/"   THEN symb = "-".
             WHEN "-"   THEN symb = "\\".
         END CASE.
         find last loan-acct where loan-acct.contract eq loan.contract and
                                   loan-acct.cont-code eq loan.cont-code and
                                   loan-acct.acct-type eq loan.contract and 
                                   loan-acct.since le loan.since
                                   no-lock no-error.

         if avail loan-acct then cacct = loan-acct.acct.
         if cacct EQ "" then if length(loan.cont-code)=20 then cacct = loan.cont-code.
         if cacct EQ "" then next.


         /* Поиск счета резерва */

        racct = GetLoanAcct_ULL("Кредит", loan.cont-code, in-type, end-date, FALSE).
        if racct EQ "" then do:
           maind = GetMainLoan_ULL("Кредит", loan.cont-code, FALSE).
           dtype = ENTRY(1,maind).
           maind = ENTRY(2,maind).
           racct = GetLoanAcct_ULL(dtype, maind, in-type, end-date, FALSE).
        end.

 /* вставка из-за ПОС */

        if CAN-DO(POSAccts,racct) then 
        do:
	   find first mainloan where mainloan.contract = loan.contract and mainloan.cont-code = Entry(1,loan.cont-code," ") NO-LOCK NO-ERROR.
            IF NOT AVAIL(mainloan) then message "НЕПРЕДВИДЕННАЯ ОШИБКА!!!" VIEW-AS ALERT-BOX.
            racct = STRING(RECID(mainloan),"9999999999999999999").                   /*Кредит*/
            racct = "2" + racct.

	end.
/* конец вставка из-за ПОС */
           Find first tAcct where tAcct.tracct = racct or tAcct.tcacct = cacct NO-LOCK NO-ERROR.
           IF AVAILABLE tAcct then racct = "". 
   	   else
	     do:
	     CREATE tAcct.
	     Assign
		tAcct.tracct = racct
	        tAcct.tcacct = cacct.
	     end.


        if (TRIM(cacct) NE "") and (TRIM(racct) NE "") THEN
            put unformatted skip cacct FORMAT "x(25)" " " racct FORMAT "x(25)" " ".

        /* Поиск счета просрочки и резерва к нему */
        cacct = GetLoanAcct_ULL("Кредит", loan.cont-code, in1-type, end-date, FALSE).
        racct = GetLoanAcct_ULL("Кредит", loan.cont-code, in2-type, end-date, FALSE).
        if racct EQ "" then do:
           maind = GetMainLoan_ULL("Кредит", loan.cont-code, FALSE).
           dtype = ENTRY(1,maind).
           maind = ENTRY(2,maind).
           racct = GetLoanAcct_ULL(dtype, maind, in2-type, end-date, FALSE).
        end.

/* вставка из-за ПОС */

        if CAN-DO(POSAcctsPr,racct) then 
        do:
/*           racct = Entry(1,loan.cont-code," ") + " Просрочка". */
	   find first mainloan where mainloan.contract = loan.contract and mainloan.cont-code = Entry(1,loan.cont-code," ") NO-LOCK NO-ERROR.
            IF NOT AVAIL(mainloan) then message "НЕПРЕДВИДЕННАЯ ОШИБКА!!!" VIEW-AS ALERT-BOX.
            racct = STRING(RECID(mainloan),"9999999999999999999").                   /*Просрочка*/
            racct = "3" + racct.

	end.
	   if racct = '45818810100010504600' then racct = "".
           Find first tAcct where tAcct.tracct = racct and tAcct.tcacct = cacct NO-LOCK NO-ERROR.
           IF AVAILABLE tAcct then racct = "". 
   	   else
	     do:
	     CREATE tAcct.
	     Assign
		tAcct.tracct = racct
	        tAcct.tcacct = cacct.
	     end.


/* конец вставка из-за ПОС */


   if (TRIM(cacct) NE "") and (TRIM(racct) NE "") THEN
            put unformatted skip cacct FORMAT "x(25)" " " racct FORMAT "x(25)" " ".









/* добавляем кусок для счетов по внебалансу, ранее искалось через доп.связи - теперь ищем через договор. старый кусок закоментирован
   далее, для возможности быстрого отката к старой технологии выгрузки! */







             /* Поиск счета просрочки и резерва к нему */
        find last loan-acct3 where loan-acct3.contract = loan.contract 
			       and loan-acct3.cont-code = loan.cont-code 
			       and can-do("КредЛин,КредН",loan-acct3.acct-type) 
                               and loan-acct3.since <= end-date NO-LOCK NO-ERROR.
        if available loan-acct3 then cacct = loan-acct3.acct. else cacct = "".

        racct = GetLoanAcct_ULL("Кредит", loan.cont-code, in4-type, end-date, FALSE).

        if racct EQ "" then do:
           maind = GetMainLoan_ULL("Кредит", loan.cont-code, FALSE).
           dtype = ENTRY(1,maind).
           maind = ENTRY(2,maind).
           racct = GetLoanAcct_ULL(dtype, maind, in4-type, end-date, FALSE).
        end.




     /* вставка из-за ПОС */
        if CAN-DO(POSAcctsKredN,racct) and cacct <> "" then do:
  	         find last loan-acct where loan-acct.acct = cacct and loan-acct.contract = "Кредит" NO-LOCK NO-ERROR.
  	         find first mainloan where mainloan.contract = loan-acct.contract and mainloan.cont-code = Entry(1,loan-acct.cont-code," ") NO-LOCK NO-ERROR.
                 IF NOT AVAIL(mainloan) then message "НЕПРЕДВИДЕННАЯ ОШИБКА!!!" loan-acct.cont-code VIEW-AS ALERT-BOX.
                 racct = STRING(RECID(mainloan),"9999999999999999999").                   /*КредН*/
                 racct = "1" + racct.
            end.
        else 
	do:
        if CAN-DO("91317........05.....",cacct) then 
         do:
	    find last loan-acct where loan-acct.acct = cacct and loan-acct.contract = "Кредит" NO-LOCK NO-ERROR.
	    if available loan-acct then 
             do:
             temploan = loan-acct.cont-code.
             find last bloan-acct where bloan-acct.acct-type = "КредРезВб" 
                                    and bloan-acct.cont-code = Entry(1,temploan," ") 
	                            and bloan-acct.contract = "Кредит" 
                                    and bloan-acct.since <= end-date 
                                    and bloan-acct.currency = "" NO-LOCK NO-ERROR.

           if available (bloan-acct)  then do:
             if CAN-DO(POSAcctsKredN,bloan-acct.acct) then do:
 	         find first mainloan where mainloan.contract = loan-acct.contract and mainloan.cont-code = Entry(1,loan-acct.cont-code," ") NO-LOCK NO-ERROR.
                 IF NOT AVAIL(mainloan) then message "НЕПРЕДВИДЕННАЯ ОШИБКА!!!" VIEW-AS ALERT-BOX.
                 racct = STRING(RECID(mainloan),"9999999999999999999").                   /*КредН*/
                 racct = "1" + racct.
               end.
            end.
	end.
	end.



	end.	
     /* конец вставка из-за ПОС */

	        Find first tAcct where tAcct.tracct = racct and tAcct.tcacct = cacct NO-LOCK NO-ERROR.
                IF AVAILABLE tAcct then racct = "". 
  	        else
 	        do:
	        CREATE tAcct.
  	        Assign
	  	   tAcct.tracct = racct
  	           tAcct.tcacct = cacct.
 	        end.

    if (TRIM(cacct) NE "") and (TRIM(racct) NE "") THEN
            put unformatted skip cacct FORMAT "x(25)" " " racct FORMAT "x(25)" " ".

/*   end.           */








   /*конец нового фрагмента*/






   end. 

 /* старый фрагмент */
   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база счетов   " +  STRING(" ","X(50)").

   FOR EACH acct WHERE open-date LE end-date
                         AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )  
                         AND NOT CAN-DO("45*,47*,91302*,91309*,91305*", acct.acct)
           NO-LOCK BREAK BY acct :

     num-cust = num-cust + 1.
     {move-bar.i num-cust max-cust}
     
   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .




      racct = "".

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

     find tAcct where tacct.tcacct = acct.acct NO-LOCK NO-ERROR.
     if available tAcct then next.

      racct = entry(1,GetLinks (acct.Class-Code, acct.acct + "," + acct.currency, ?, "acct-reserve", ",", ?),",").
      
      IF can-do("91302*,91309*,91305*",racct) then 
      racct = entry(3,GetLinks (acct.Class-Code, acct.acct + "," + acct.currency, ?, "acct-reserve", ",", ?),",").
      
  
	        Find first tAcct where tAcct.tracct = racct and tAcct.tcacct = acct.acct NO-LOCK NO-ERROR.
                IF AVAILABLE tAcct then racct = "". 
  	        else
 	        do:
	        CREATE tAcct.
  	        Assign
	  	   tAcct.tracct = racct
  	           tAcct.tcacct = acct.acct.
 	        end.

    if (TRIM(acct.acct) NE "") and (TRIM(racct) NE "") THEN
            put unformatted skip acct.acct FORMAT "x(25)" " " racct FORMAT "x(25)" " ".

   end.


/*конец старого фрагмента */
put screen col 1 row 24 color normal 
       STRING(" ","X(80)").


{intrface.del}