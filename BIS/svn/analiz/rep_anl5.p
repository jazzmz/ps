{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{getdate.i}
{loan.pro}

/* Add by Maslov D.
   Инклюдник подключает функцию определения
   номера договора по записи в таблице
*/
{pir-getdocnum.i}

{exp-path.i &exp-filename = "'analiz/kred_' + 

                            string(day(end-date),'99') + string(month(end-date),'99') + 
                            string(year(end-date),'9999') + '.txt'"
}

def var symb as char no-undo.
def var unk as char no-undo.
def var cacct as char no-undo.
def var edate as date no-undo.
def var odate as date no-undo.
DEF VAR isReady2Close AS CHARACTER INITIAL ?  No-Undo.
DEF VAR oTAcct AS TAcct  No-Undo.
def var temp as DEC INIT 0  No-Undo.

def var showlog as logical init false  No-Undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база договоров" +  STRING(" ","X(50)").

   FOR EACH loan WHERE ( open-date LE end-date )
/*                    AND ( ( close-date GE end-date ) OR ( close-date EQ ? ) )   */
           NO-LOCK :

 /* 
      Add By Maslov D. 
*/
     isReady2Close = getXAttrValue("loan",loan.contract + "," + getDocNum(BUFFER loan:HANDLE),"PirReady2Close").


/* проверяем остаток на счете с ролью Кредит и КредН и КредЛин, если везде 0, то договор погашен, но кредитчики забыли закрыть или проставить доп.рек*/
    IF (isReady2Close NE "Да") and (loan.contract = "Кредит")  THEN 
       DO:
       for each loan-acct where loan-acct.contract eq loan.contract and
                                loan-acct.cont-code begins loan.cont-code and
                                loan-acct.since le end-date and 
			        (loan-acct.acct-type = "Кредит" OR loan-acct.acct-type = "КредН" OR loan-acct.acct-type = "КредЛин" OR loan-acct.acct-type = "КредПр" OR loan-acct.acct-type = "КредПр%")
                no-lock.

/*         if showlog then message loan-acct.cont-code loan-acct.acct VIEW-AS ALERT-BOX.*/
/*          oTAcct = new TAcct(loan-acct.acct).

          temp = temp + oTacct:getlastpos2date(end-date). */

                RUN acct-pos IN h_base (loan-acct.acct,
                              loan-acct.currency,
                              end-date,
                              end-date,
                              ?).

           temp = temp + sh-val + sh-bal.



         /* if loan-acct.cont-code = "17/09" then MESSAGE loan-acct.cont-code temp loan-acct.acct-type VIEW-AS ALERT-BOX.          */

          if temp = 0 then isReady2Close = "ДА". else isReady2Close = "НЕТ".
          
/*  	  DELETE OBJECT oTAcct.       */
       END.
	  temp = 0.
       END.            
                  
/* проверили           */

      put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .
      cacct = "".

    IF isReady2Close NE "Да" THEN 
       DO:
            /* Если кредитный договор не помечен к закрытию, то производим его выгрузку */
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

      IF loan.cust-cat EQ "Ч" THEN unk = TRIM(GetXAttrValue("person", STRING(loan.cust-id), "УНК")).
      IF loan.cust-cat EQ "Ю" THEN unk = TRIM(GetXAttrValue("cust-corp", STRING(loan.cust-id), "УНК")).
      IF loan.cust-cat EQ "Б" THEN unk = TRIM(GetXAttrValue("banks", STRING(loan.cust-id), "УНК")).
      IF loan.cust-cat EQ "В" THEN unk = "0".

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

       odate = loan.open-date.

      put unformatted skip odate FORMAT "99/99/9999" " "
                           loan.close-date FORMAT "99/99/9999" " "
                           loan.cust-cat FORMAT "x(1)" " "
                           unk format "x(9)" " "
                           edate FORMAT "99/99/9999" " "
                           loan.contract FORMAT "x(6)" " "
                           loan.currency FORMAT "x(3)" " "
                           loan.cont-code FORMAT "x(22)" " "
                           loan.cont-type FORMAT "x(20)" " "
                           cacct FORMAT "x(25)" " "
                           end-date FORMAT "99/99/9999".
         

      find last loan-acct where loan-acct.contract eq loan.contract and
                                loan-acct.cont-code eq loan.cont-code and
                                loan-acct.acct-type eq "КредПр" and 
                                loan-acct.since le end-date
                no-lock no-error .
/*      if loan.cont-code = "00001812090000001472" then showlog = true.*/
      if avail loan-acct then do:
         cacct = loan-acct.acct.
         edate = end-date.
         put unformatted skip odate FORMAT "99/99/9999" " "
                              loan.close-date FORMAT "99/99/9999" " "
                              loan.cust-cat FORMAT "x(1)" " "
                              unk format "x(9)" " "
                              edate FORMAT "99/99/9999" " "
                              loan.contract FORMAT "x(6)" " "
                              loan.currency FORMAT "x(3)" " "
                              loan.cont-code FORMAT "x(22)" " "
                              loan.cont-type FORMAT "x(20)" " "
                              cacct FORMAT "x(25)" " "
                              end-date FORMAT "99/99/9999".
      end.
end.
  END. /* Если договор не помечен к закрытию */
put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

