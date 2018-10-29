{pirsavelog.p}

{globals.i}
{intrface.get instrum}
{sh-defs.i}
{loan.pro}
{norm.i}

/* Add by Maslov D.
   Инклюдник подключает функцию определения
   номера договора по записи в таблице
*/
{pir-getdocnum.i}

DEF OUTPUT PARAMETER IRes AS DECIMAL NO-UNDO.
DEF INPUT PARAMETER iBegDate as DATE NO-UNDO.
DEF INPUT PARAMETER iEndDate as DATE NO-UNDO.
DEF INPUT PARAMETER iDogType as CHARACTER NO-UNDO.
DEF var loanclasses AS CHAR INIT "loan_allocat,loan_c,loan-transh,l_agr_with*" NO-UNDO.
DEF VAR symb AS char no-undo.
DEF VAR isReady2Close AS CHARACTER INITIAL ?  No-Undo.
DEF VAR oTAcct AS TAcct  No-Undo.
DEF VAR temp AS DEC INIT 0  No-Undo.
def var countVal as INT INIT 0 NO-UNDO.
def var countRUB as INT INIT 0 NO-UNDO.




def var showlog as logical init false  No-Undo.

symb = "-".

   put screen col 1 row 24 color bright-blink-normal 
       "Обрабатывается база кредитных договоров" +  STRING(" ","X(50)").

   FOR EACH loan  WHERE ( open-date LE iEndDate )
                    AND ( ( close-date GE iEndDate ) OR ( close-date EQ ? ) )  
		    AND (loan.contract = "Кредит")
		    and CAN-DO(loanclasses,loan.class-code) 
           NO-LOCK :

 /* 
      Add By Maslov D. 
*/
     isReady2Close = getXAttrValue("loan",loan.contract + "," + getDocNum(BUFFER loan:HANDLE),"PirReady2Close").

/* проверяем остаток на счете с ролью Кредит и КредН и КредЛин, если везде 0, то договор погашен, но кредитчики забыли закрыть или проставить доп.рек*/
    IF (isReady2Close NE "Да") and (loan.contract = "Кредит")  THEN 
       DO:
       for each loan-acct where loan-acct.contract eq loan.contract and
                                ((loan-acct.cont-code begins loan.cont-code /*+ " "*/) /*or (loan-acct.cont-code = loan.cont-code)*/) and
                                loan-acct.since le iEndDate and 
			        (loan-acct.acct-type = "Кредит" OR loan-acct.acct-type = "КредН" OR loan-acct.acct-type = "КредЛин" OR loan-acct.acct-type = "КредПр" OR loan-acct.acct-type = "КредПр%")
                no-lock.


 
                RUN acct-pos IN h_base (loan-acct.acct,
                              loan-acct.currency,
                              iEndDate,
                              iEndDate,
                              ?).

           temp = temp + sh-val + sh-bal.

/*                    if loan.cont-code = "113/11" then message isReady2Close  temp loan-acct.acct loan.cont-code VIEW-AS ALERT-BOX.*/

          if temp = 0 then isReady2Close = "ДА". else isReady2Close = "НЕТ".
/*т.к. векселя у нас ведутся на loan_allocat, исключим их по счету 514*/
          if can-do("514*,30233*",loan-acct.acct) then isReady2Close = "Да".


       END.
	  temp = 0.
       END.            
                  
/*            if loan.cont-code = "113/11" then message "1 " isReady2Close   loan.cont-code VIEW-AS ALERT-BOX.*/


      put screen col 77 row 24 color bright-blink-normal "(" + symb + ")" .

      CASE symb :                           
           WHEN "\\"  THEN symb = "|".
           WHEN "|"   THEN symb = "/".
           WHEN "/"   THEN symb = "-".
           WHEN "-"   THEN symb = "\\".
      END CASE.

/*          if loan.cont-code = "113/11" then message isReady2Close   loan.cont-code VIEW-AS ALERT-BOX.    */

   if (isReady2Close NE "Да") then do:
/*       put unformatted Skip loan.cont-code " " loan.currency.    */

      if loan.currency = "" then countRub = countRub + 1. 
      if loan.currency <> "" then countVal = countVal + 1. 

   end.



  END. /* Если договор не помечен к закрытию */

/*PUT UNFORMATTED     ';Название            Дата                  Кол-во руб.       Кол-во вал. '  SKIP.*/
/*PUT UNFORMATTED 'Кол_КредДог         ' TODAY '               ' count_rub_all_card ~ '           '  count_val_all_card SKIP.*/

/*put unformatted skip "Кол_КредДог         " STRING(iEndDate,"99/99/99") '               ' STRING(countRub) '           ' STRING(countval).*/

CASE IDogType:
	WHEN "rub" THEN iRes = countRub.
	WHEN "val" THEN iRes = countval.
   END.
  
put screen col 1 row 24 color normal 
       STRING(" ","X(80)").

RETURN "".
