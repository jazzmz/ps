{pirsavelog.p}

{lshpr.pro}           /* Инструменты для расчета параметров договора */
{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdates.i}

{exp-path.i &exp-filename = "'analiz/anl_' + string(day(beg-date),'99') + 
                            string(month(beg-date),'99') + string(year(beg-date),'9999') + '_' +
                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var cur as char no-undo.

def var vald as dec no-undo.
def var valk as dec no-undo.
def var valdv as dec no-undo.
def var valkv as dec no-undo.
def var restsum as dec no-undo.
def var turndsum as dec no-undo.
def var turncsum as dec no-undo.
def var symb as char no-undo.
def var dt_cur as date no-undo.
def var unk as char no-undo.
def var tacct as char FORMAT "x(20)" no-undo.

def var temp as dec no-undo.
def var SummOP21cr as dec no-undo.
def var SummOP21db as dec no-undo.
def var summOp46cr as dec no-undo.
def var summOp46db as dec no-undo.
def var temp1 as dec no-undo.
def var Summtemp as dec no-undo.
def var Summtemp1 as dec no-undo.

def var dt1 as dec no-undo.
def var dt2 as dec no-undo.


def buffer transh for loan.

symb = "-".

DO dt_cur = beg-date TO end-date :

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается " + STRING(dt_cur,"99/99/9999") + STRING(" ","X(55)").

   FOR EACH acct WHERE acct.open-date LE dt_cur
                         AND ( ( acct.close-date GE dt_cur ) OR ( acct.close-date EQ ? ) )  
           NO-LOCK BREAK BY acct.acct :

   put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

/* полезли за остатками по счету  */
      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              dt_cur,
                              dt_cur,
                              CHR(251)).

      assign
         vald  = if ( sh-bal > 0 ) then sh-bal else 0 
         valk  = if ( sh-bal < 0 ) then sh-bal else 0 
         valdv = if ( sh-val > 0 ) then sh-val else 0 
         valkv = if ( sh-val < 0 ) then sh-val else 0 
         restsum = sh-val + sh-bal
         turndsum = sh-db + sh-vdb 
         turncsum = sh-cr + sh-vcr
      .
      cur = if acct.currency = "" then "810" else acct.currency.

      CASE symb :
          WHEN "\\"  THEN symb = "|".
          WHEN "|"   THEN symb = "/".
          WHEN "/"   THEN symb = "-".
          WHEN "-"   THEN symb = "\\".
      END CASE.

      IF acct.cust-cat EQ "Ч" THEN unk = TRIM(GetXAttrValue("person", STRING(acct.cust-id), "УНК")).
      IF acct.cust-cat EQ "Ю" THEN unk = TRIM(GetXAttrValue("cust-corp", STRING(acct.cust-id), "УНК")).
      IF acct.cust-cat EQ "Б" THEN unk = TRIM(GetXAttrValue("banks", STRING(acct.cust-id), "УНК")).
      IF acct.cust-cat EQ "В" THEN unk = "0".
      IF lastmove EQ ? THEN lastmove = DATE("01/01/1990").
/*      IF (restsum <> 0) OR (turndsum <> 0) OR (turncsum <> 0) THEN  */
         put unformatted skip acct.acct FORMAT "x(20)" " "
                           cur FORMAT "x(3)" " "
                           unk FORMAT "x(10)" " "
                           acct.open-date format "99/99/9999" " "
                           acct.close-date format "99/99/9999" " "
                           dt_cur format "99/99/9999" " "
                           sh-vdb  FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет во валюте */
                           sh-db   FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет в рубликах */
                           sh-vcr  FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в валюте */
                           sh-cr   FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в рубликах*/
                           valdv FORMAT "->>>>>>>>>>>9.99" " "
                           vald  FORMAT "->>>>>>>>>>>9.99" " "
                           valkv FORMAT "->>>>>>>>>>>9.99" " "
                           valk  FORMAT "->>>>>>>>>>>9.99" " "
                           lastmove format "99/99/9999".
   end.
     cur = "810".


                           sh-vdb = 0.
                           sh-db = 0.
                           sh-vcr = 0.
                           sh-cr = 0.
                           valdv = 0.
                           vald = 0.
                           valkv = 0.
                           valk = 0.


for each loan where loan.contract = "Кредит" and loan.class-code begins "l_agr" and (loan.close-date = ? OR loan.close-date >= dt_cur) NO-LOCK:
                           sh-vdb = 0.
                           sh-db = 0.
                           sh-vcr = 0.
                           sh-cr = 0.
                           valdv = 0.
                           vald = 0.
                           valkv = 0.
                           valk = 0.

    IF loan.cust-cat EQ "Ч" THEN unk = TRIM(GetXAttrValue("person", STRING(loan.cust-id), "УНК")).

   RUN STNDRT_PARAM(loan.contract, loan.cont-code,  88, dt_cur, OUTPUT temp , OUTPUT dT1, OUTPUT dT2).
     tacct = STRING(RECID(loan),"9999999999999999999").
     tacct = "1" + tacct.

      vald  = if ( temp > 0 ) then temp else 0. 
      valk  = if ( temp < 0 ) then temp else 0. 

      find last loan-int where loan-int.contract = 'Кредит' 
			   and loan-int.cont-code = loan.cont-code 
			   and (loan-int.id-k = 88 or loan-int.id-d = 88) 
			   and loan-int.op-date = dt_cur NO-LOCK NO-ERROR.
      if available loan-int then 
         do:
            if loan-int.id-k = 88 then sh-cr = loan-int.amt-rub.
            if loan-int.id-d = 88 then sh-db = loan-int.amt-rub.
	    lastmove = loan-int.op-date.
         end.

         put unformatted skip tacct FORMAT "x(20)" " "
                           cur FORMAT "x(3)" " "
                           unk FORMAT "x(10)" " "
                           loan.open-date format "99/99/9999" " "
                           loan.close-date format "99/99/9999" " "
                           dt_cur format "99/99/9999" " "
                           sh-vdb  FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет во валюте */
                           sh-db   FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет в рубликах */
                           sh-vcr  FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в валюте */
                           sh-cr   FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в рубликах*/
                           valdv FORMAT "->>>>>>>>>>>9.99" " "
                           vald  FORMAT "->>>>>>>>>>>9.99" " "
                           valkv FORMAT "->>>>>>>>>>>9.99" " "
                           valk  FORMAT "->>>>>>>>>>>9.99" " "
                           lastmove format "99/99/9999".


                           sh-vdb = 0.
                           sh-db = 0.
                           sh-vcr = 0.
                           sh-cr = 0.
                           valdv = 0.
                           vald = 0.
                           valkv = 0.
                           valk = 0.



      summTemp = 0.
      summTemp1 = 0.
      SummOp21cr = 0.
      SummOp21db = 0.
      SummOp46cr = 0.
      SummOp46db = 0.
      for each transh where transh.cont-code <> loan.cont-code 
			and transh.cont-code begins loan.cont-code 
			and transh.contract = loan.contract 
			and (transh.close-date = ? or transh.close-date >= dt_cur) NO-LOCK.
      temp = 0.
      RUN STNDRT_PARAM(transh.contract, transh.cont-code,  21, dt_cur, OUTPUT temp , OUTPUT dT1, OUTPUT dT2).

      summTemp = SummTemp + temp.
 
      find last loan-int where loan-int.contract = 'Кредит' 
			   and loan-int.cont-code = transh.cont-code 
			   and (loan-int.id-k = 21 or loan-int.id-d = 21) 
			   and loan-int.op-date = dt_cur NO-LOCK NO-ERROR.
      if available loan-int then 
         do:
            if loan-int.id-k = 21 then SummOp21cr =  SummOp21cr + loan-int.amt-rub.
            if loan-int.id-d = 21 then SummOp21db =  SummOp21db + loan-int.amt-rub.
	    lastmove = loan-int.op-date.
         end.



      temp1 = 0.

      RUN STNDRT_PARAM(transh.contract, transh.cont-code,  46, dt_cur, OUTPUT temp1, OUTPUT dT1, OUTPUT dT2).
/*      if transh.cont-code begins "ПК-004/08" then Message transh.cont-code temp1 RECID(loan) VIEW-AS ALERT-BOX.*/
      summTemp1 = SummTemp1 + temp1.
      find last loan-int where loan-int.contract = 'Кредит' 
			   and loan-int.cont-code = transh.cont-code 
			   and (loan-int.id-k = 46 or loan-int.id-d = 46) 
			   and loan-int.op-date = dt_cur NO-LOCK NO-ERROR.
      if available loan-int then 
         do:
            if loan-int.id-k = 46 then SummOp46cr =  SummOp46cr + loan-int.amt-rub.
            if loan-int.id-d = 46 then SummOp46db =  SummOp46db + loan-int.amt-rub.
	    lastmove = loan-int.op-date.
         end.

      end.
/*Выводим для 21 параметра */

      vald  = if ( Summtemp > 0 ) then Summtemp else 0. 
      valk  = if ( Summtemp < 0 ) then Summtemp else 0. 
      tacct = STRING(RECID(loan),"9999999999999999999").
            tacct = "2" + tacct.

           put unformatted skip tacct FORMAT "x(20)" " "
                           cur FORMAT "x(3)" " "
                           unk FORMAT "x(10)" " "
                           loan.open-date format "99/99/9999" " "
                           loan.close-date format "99/99/9999" " "
                           dt_cur format "99/99/9999" " "
                           sh-vdb  FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет во валюте */
                           SummOp21db   FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет в рубликах */
                           sh-vcr  FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в валюте */
                           SummOp21cr   FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в рубликах*/
                           valdv FORMAT "->>>>>>>>>>>9.99" " "
                           vald  FORMAT "->>>>>>>>>>>9.99" " "
                           valkv FORMAT "->>>>>>>>>>>9.99" " "
                           valk  FORMAT "->>>>>>>>>>>9.99" " "
                           lastmove format "99/99/9999".
/*Выводим для 46 параметра */

      vald  = if ( Summtemp1 > 0 ) then Summtemp1 else 0. 
      valk  = if ( Summtemp1 < 0 ) then Summtemp1 else 0. 

      tacct = STRING(RECID(loan),"9999999999999999999").
      tacct = "3" + tacct.
         put unformatted skip tacct FORMAT "x(20)" " "
                           cur FORMAT "x(3)" " "
                           unk FORMAT "x(10)" " "
                           loan.open-date format "99/99/9999" " "
                           loan.close-date format "99/99/9999" " "
                           dt_cur format "99/99/9999" " "
                           sh-vdb  FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет во валюте */
                           SummOp46db   FORMAT "->>>>>>>>>>>9.99" " "             /*Дебет в рубликах */
                           sh-vcr  FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в валюте */
                           SummOp46cr   FORMAT "->>>>>>>>>>>9.99" " "             /*Кредит в рубликах*/
                           valdv FORMAT "->>>>>>>>>>>9.99" " "
                           vald  FORMAT "->>>>>>>>>>>9.99" " "
                           valkv FORMAT "->>>>>>>>>>>9.99" " "
                           valk  FORMAT "->>>>>>>>>>>9.99" " "
                           lastmove format "99/99/9999".

end.

end.

put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

