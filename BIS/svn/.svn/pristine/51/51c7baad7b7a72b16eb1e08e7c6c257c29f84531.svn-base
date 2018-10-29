/*
               Банковская интегрированная система БИСквит
    Copyright: ОАО КБ "ПPОМИНВЕСТРАСЧЕТ"
     Filename: pir-pko.p
      Comment: Отчет проверяющий правильность списания комиссий за перевыпуск пластиковых карт 
   Parameters: 
         Uses: Globals.i SetDest.i Preview.i
      Used by: -
      Created: 15/02/2011 V.N.Ermilov
     Modified:
*/



DEFINE VARIABLE type_com    AS CHARACTER NO-UNDO.
DEFINE VARIABLE all_com     AS DECIMAL NO-UNDO.
DEFINE VARIABLE sum_op      AS DECIMAL NO-UNDO.
DEFINE VARIABLE scs_ost     AS DEC NO-UNDO.
DEFINE VARIABLE sgp_ost     AS DEC NO-UNDO.

DEFINE VARIABLE counter     AS INT NO-UNDO.
DEFINE VARIABLE oldcounter  AS INT NO-UNDO.

DEFINE VAR all_card AS CHARACTER NO-UNDO.

DEFINE VARIABLE loan_holder AS CHAR NO-UNDO.
DEFINE VARIABLE card_holder AS CHAR NO-UNDO.

DEFINE VAR com_acct AS CHARACTER NO-UNDO.
DEFINE VAR scs_acct AS CHARACTER NO-UNDO.
DEFINE VAR sgp_acct AS CHARACTER NO-UNDO.

DEFINE BUFFER mloan FOR loan.    
DEFINE BUFFER mcard FOR loan.
DEFINE BUFFER mlcond FOR loan-cond.

{globals.i}
{bislogin.i}
{intrface.get xclass}
{sh-defs.i}
              
{getdates.i}
{setdest.i}

ASSIGN counter = 1 .


PUT UNFORMATTED TODAY " "  TIME " "  SKIP(1).

PUT UNFORMATTED  
"№ п/п;Статус;№ договора;Условие договора;Вал;Карты;Держатель;Сумма по картам;Сумма по проводкам;Разница;Остаток на SCS;Остаток на SGP;Всего;" SKIP.



/*Бежим по всем карточным договорам*/

FOR EACH mloan  
WHERE ((mloan.contract = 'card-pers') OR (mloan.cont-code = 'card-corp')) 
AND  CAN-DO('ОТКР',mloan.loan-status)
/*AND  mloan.cont-code BEGINS 'B/RUR/'*/
,
LAST mlcond
WHERE mlcond.contract EQ mloan.contract
  AND mlcond.cont-code EQ mloan.cont-code
  AND mlcond.class-code NE "RUR_SAFE-BOX"
      
: 
    
/*Опеределяем условие договора
    FIND LAST mlcond 
    WHERE mlcond.contract  = mloan.contract
    AND mlcond.cont-code = mloan.cont-code
    .  
                              */
/*По условию берем код тарифа*/
    type_com = GetXAttrInit(mlcond.class-code,'КомГод').

/*сбрасываем общую сумму комиссии всех карточек по данному договору */
    ASSIGN 
    oldcounter = counter
    all_card = ""
    all_com = 0 
    sum_op = 0    
    .


/*поиск основного карточного счета*/
FIND LAST loan-acct 
WHERE loan-acct.contract  EQ mloan.contract
  AND loan-acct.cont-code EQ mloan.cont-code
  AND loan-acct.acct-type EQ ("SCS@" + mloan.currency).
IF AVAIL loan-acct THEN scs_acct = loan-acct.acct.   


RUN acct-pos IN h_base (scs_acct, mloan.currency, TODAY, TODAY, ?).

IF   mloan.currency EQ "" 
THEN scs_ost = - sh-bal.
ELSE scs_ost = - sh-val
.

/*поиск счета СГП*/
FIND LAST loan-acct 
WHERE loan-acct.contract  EQ mloan.contract
  AND loan-acct.cont-code EQ mloan.cont-code
  AND loan-acct.acct-type EQ ("SGP@" + mloan.currency).
IF AVAIL loan-acct THEN sgp_acct = loan-acct.acct.   



RUN acct-pos IN h_base (sgp_acct, mloan.currency, TODAY, TODAY, ?).

IF   mloan.currency EQ "" 
THEN sgp_ost = - sh-bal.
ELSE sgp_ost = - sh-val
.



/*поиск счета комиссий*/
FIND LAST loan-acct 
WHERE loan-acct.contract  EQ mloan.contract
  AND loan-acct.cont-code EQ mloan.cont-code
  AND loan-acct.acct-type EQ ("comiss@" + mloan.currency).
IF AVAIL loan-acct THEN com_acct = loan-acct.acct.    


IF mloan.cust-cat EQ 'Ч' THEN 
DO:
    FIND FIRST person 
    WHERE person.person-id EQ mloan.cust-id.
    IF AVAIL person THEN loan_holder = person.name-last + " " + person.first-names.
END.
ELSE 
DO:
    FIND FIRST cust-corp
    WHERE cust-corp.cust-id EQ mloan.cust-id.
    IF AVAIL cust-corp THEN loan_holder = cust-corp.name-short.
END.   


/*Выбираем все карты данного карт. договора*/
    FOR EACH mcard 
    WHERE mcard.contract EQ 'card'
      AND mcard.parent-contract EQ mloan.contract
      AND mcard.parent-cont-code EQ mloan.cont-code
      AND CAN-DO('АКТ',mcard.loan-status)
      AND mcard.open-date LE end-date
      AND mcard.end-date GE end-date
    :   


    FIND FIRST person 
    WHERE person.person-id EQ mcard.cust-id.
    IF AVAIL person THEN card_holder = person.name-last + " " + person.first-names.
       

       
        
/*находим сумму годовой комиссии*/
        FIND LAST comm-rate
        WHERE comm-rate.commission EQ (type_com + "@" + mcard.sec-code).

        IF AVAIL comm-rate 
        THEN  all_com = all_com  + comm-rate.rate-comm.

/*выводим строку о карте в отчет*/
    /*   
        PUT UNFORMATTED  "| "  counter FORMAT ">>>9"
                        " | " mcard.loan-status FORMAT "X(4)"
                        " | " mcard.doc-num  FORMAT "X(26)"
                        " | " mloan.currency FORMAT "X(3)"
                        " | " card_holder FORMAT "X(30)"
                        " | " mcard.loan-work FORMAT "ДА /НЕТ"
                        " | " comm-rate.rate-comm FORMAT "->>>,>>9.99"
                        " | "
        SKIP.
     */
      
      all_card = all_card  + mcard.doc-num +  "(" + STRING(mcard.end-date)  +   "), " .                     
                           
/*щелкаем счетчиком*/         
/*         ASSIGN counter = oldcounter + 1.    */
   END.
   

/*запускаем поиск проводок по взиманию комиссии. корреспонденция 40817-61304*/
    FOR EACH op-entry 
    WHERE op-entry.acct-db EQ scs_acct 
      AND op-entry.acct-cr EQ com_acct
      AND op-entry.op-date GE beg-date
      AND op-entry.op-date LE end-date NO-LOCK  
    :
  
        IF  mloan.currency EQ "" 
        THEN sum_op = sum_op + op-entry.amt-rub.
        ELSE sum_op = sum_op + op-entry.amt-cur.
        
    END.    

IF (sum_op - all_com) < 0 THEN
DO: 

PUT UNFORMATTED     counter FORMAT ">>>9"
                ";" mloan.loan-status  FORMAT "X(4)" 
                ";" mloan.cont-code FORMAT "X(16)"
                ";" mlcond.class-code    FORMAT "X(12)"
                ";" mloan.currency FORMAT "X(3)"
                ";" all_card
                ";" loan_holder FORMAT "X(30)"
                ";" all_com FORMAT "->>>,>>9.99"
                ";" sum_op FORMAT "->>>,>>9.99" 
                ";" (sum_op - all_com) FORMAT "->>>,>>9.99" 
                ";" scs_ost FORMAT "->>>,>>>,>>9.99"
                ";" sgp_ost FORMAT "->>>,>>>,>>9.99"
                ";" (scs_ost + sgp_ost) FORMAT "->>>,>>>,>>9.99"                
                ";"
                SKIP.

assign counter = counter + 1.

END.

END.   

{preview.i}





