{pirsavelog.p}

/**
 * Расчет планируемых расходов по будущим начислениям процентов до депозитным договорам юридических лиц
 * Ермилов В.Н.
 * 30/03/2010 
 */
 
 /** Глобальные определения */
{globals.i}

/** Библиотека функций */
{ulib.i}

{tmprecid.def}        /** Используем информацию из броузера */


/** Рабочая переменная */
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpDate AS DATE NO-UNDO.
/** Флаг трассировки функций из модулей u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** Дата отчета */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "Дата отчета" NO-UNDO.
/** Итератор */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
/** Итоговая сумма %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.

DEF VAR n_yach AS INTEGER NO-UNDO.

DEF VAR tekDate AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR real-end-date AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR nextDate AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR nextDateKorr AS DATE FORMAT "99/99/9999"  NO-UNDO.



DEF VAR NextPercent AS DECIMAL NO-UNDO.

DEF VAR firstPercent AS DECIMAL NO-UNDO.

DEF VAR AllPr4Period AS DECIMAL EXTENT 10 NO-UNDO.


FUNCTION NOMER_YACH RETURNS INTEGER (INPUT date1 AS DATE, INPUT date2 AS DATE) FORWARD.
FUNCTION PIR_LOAN_PERCENT RETURNS DECIMAL (INPUT iContract AS CHAR,INPUT iContCode AS CHAR, INPUT iBegDate AS DATE, INPUT iEndDate AS DATE, INPUT iNeedMon AS LOGICAL) FORWARD.   


/*PAUSE 0.*/
/** Задаем дату с помощью рук пользователя ;) */
repDate = TODAY.

DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR 
	FIELD currency AS CHAR
	FIELD loanInfo AS CHAR 
	
	FIELD loanOpenDate AS DATE
	FIELD loanEndDate AS DATE
	
	FIELD account AS CHAR
	FIELD intAccount AS CHAR
		
	FIELD summa%% AS DECIMAL
	FIELD rate AS DECIMAL
	FIELD summaDeposit AS DECIMAL

	FIELD dpstype AS CHAR	

	FIELD Pr4Period AS DECIMAL EXTENT 10
	FIELD nextDate AS DATE
	
	INDEX main balAcct%% ASCENDING currency ASCENDING nextDate ASCENDING.


/*запускаем цикл по выбраным договорам*/	
FOR EACH tmprecid 
			NO-LOCK,
    FIRST loan WHERE 
    	RECID(loan) = tmprecid.id 
    	NO-LOCK
	,
    LAST loan-acct WHERE 
    	loan-acct.contract = loan.contract
    	AND loan-acct.cont-code = loan.cont-code
    	AND loan-acct.acct-type = "ДепТ"
    	AND loan-acct.since LE repDate
    	NO-LOCK
	,
    LAST loan-cond WHERE
	loan-cond.contract = loan.contract
	AND loan-cond.cont-code = loan.cont-code
 :
  	CREATE tt-report.

  	
  	/*Счет для перечисления процентов*/
  	tt-report.balAcct%% = SUBSTRING(loan-acct.acct,1,5).
  	
  	/*Имя клиента*/
  	tt-report.clientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).  		
	/*Номер договора*/	
  	tt-report.loanInfo = loan.cont-code.
  	
  	/*Дата открытия*/
  	tt-report.loanOpenDate = DATE(GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff)).


/* Будем считать, что если у договора дата закрытия не определена, 
то срок действия договора = 5 лет с даты формирования отчета */
IF loan.end-date = ? 
THEN
      real-end-date = DATE(MONTH(repDate), DAY(repDate), YEAR(repDate) + 5).
ELSE 
      real-end-date = loan.end-date
.              
	
	/*Дата закрытия*/
	tt-report.loanEndDate = real-end-date. 
	
	/*Счет для перечисления процентов*/
	tt-report.intAccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "ДепТ", repDate, traceOnOff).
		
  	/*Счет частного вклада*/
  	tt-report.account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "Депоз", repDate, traceOnOff).

	/*Остаток на счете для перечисления процентов*/
	tt-report.summa%% = ABS(	GetAcctPosValue_UAL(loan-acct.acct,loan.currency, repDate, traceOnOff)  	).
  	
  	/*Даты */
  	IF loan.close-date <> ? AND loan.close-date LE repDate THEN
  		tmpDate = loan.close-date - 1.
  	ELSE IF real-end-date <> ? AND real-end-date LE repDate THEN
  		tmpDate = real-end-date - 1.
  	ELSE
  		tmpDate = repDate.
	
	/* Остаток на счете депозита */	
	tt-report.summaDeposit = ABS(	GetAcctPosValue_UAL(tt-report.account,	loan.currency,tmpDate, traceOnOff)	).

	/* Действующая ставка по вкладу */		
	tt-report.rate = GetLoanCommission_ULL(loan.contract,loan.cont-code,"%Деп",repDate, traceOnOff).
		
	/*Тип депозита	
	tt-report.dpstype = loan.cont-type.*/
	
	/*Валюта*/
	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
	


/**********************************************************************/


/* Основной блок разноски будущих процентов по столбцам 125ой формы   */
	firstpercent = tt-report.summa%% .
	
	/*MESSAGE " repdate " repdate VIEW-AS ALERT-BOX. */

	tekDate = repdate.
 
/* находим следующую для данного договора дату выплаты процентов */
   nextDate = GetLoanNextDatePercentPayOut_ULL(loan.contract, loan.cont-code, repDate - 1 , YES).

/*   MESSAGE 'First Next Date: ' nextDate VIEW-AS ALERT-BOX.  */ 


/* пока данная дата не превысит дату завершения договора будем раскидывать начисляемые проценты по срокам */
DO WHILE nextDate LT tt-report.LoanEndDate :	

/*    MESSAGE 'Data viplati: ' nextDate VIEW-AS ALERT-BOX. */

    /*находим дату расчета процентов кот. будут выплачены */
	IF loan-cond.delay = 0 THEN
	    nextDateKorr = nextDate .
        ELSE	
	    nextDateKorr =   DATE(DATE(	STRING( "1/" + STRING(MONTH(nextDate)) + "/" + STRING(YEAR(nextDate)))	) - 1 )
        .                    

/*    MESSAGE 'Nachislenie: ' tekDate nextDateKorr VIEW-AS ALERT-BOX.  */
		
		/*Расчитываем сумму процентов на последнее число предыдущего месяца, она же и будет выплачена 5ого или 7ого числа*/
		nextPercent = PIR_LOAN_PERCENT(loan.contract,loan.cont-code,tekDate, nextDateKorr, NO).

/*    MESSAGE 'Next Percent: ' nextPercent VIEW-AS ALERT-BOX.  */

		
		/*Увеличиваем нужную ячейку массива Pr4Period на расчитанную сумму процентов и вычитаем сумму процентов 
		уже учтенную на предыдущих итерациях  */

/*    MESSAGE 'First Percent: ' firstPercent VIEW-AS ALERT-BOX. */


		
		n_yach = NOMER_YACH(repDate,nextDate).
			
		tt-report.Pr4period[n_yach] = tt-report.Pr4period[n_yach] + nextPercent + firstPercent .  
		
		/* Учтем  */
		firstPercent = 0.
		
		/*найдем следующую дату начисления процентов*/
		tekDate  = nextDateKorr + 1 .
		nextDate = GetLoanNextDatePercentPayOut_ULL(loan.contract, loan.cont-code, DATE(nextDate + 1), traceOnOff).

/*     MESSAGE 'Next next Date:) ' nextDate VIEW-AS ALERT-BOX. 		*/

END.  /***** WHILE *****/ 
 

/*Теперь учтем проценты расчитываемые в день закрытия депозита, для в типа КС это будет 
единственная итерация */
IF nextDate GE tt-report.LoanEndDate THEN
	DO:

/* MESSAGE 'Zakritie - dati ' tekdate nextDate VIEW-AS ALERT-BOX.  */ 		

		/*Расчитываем сумму процентов на дату возврата вклада*/
		nextPercent =  PIR_LOAN_PERCENT(loan.contract,loan.cont-code,tekDate, nextDate, NO). 

/*  MESSAGE 'Zakritie Summa %% ' nextPercent VIEW-AS ALERT-BOX.  */ 		


		/*и относим ее на дату возврата вклада */
		n_yach = NOMER_YACH(repDate,tt-report.LoanEndDate).
		tt-report.Pr4period[n_yach] = tt-report.Pr4period[n_yach] + nextPercent + firstPercent  .  

	END.

/*Все! мы разнесли все проценты!!*/

/*  MESSAGE Pr4Period[1] '  ' Pr4Period[2] '  ' Pr4Period[3] '  ' Pr4Period[4] '  ' Pr4Period[5] '  '
   Pr4Period[6] '  ' Pr4Period[7] '  ' Pr4Period[8] '  ' Pr4Period[9] '  ' Pr4Period[9] '  ' VIEW-AS ALERT-BOX.  */ 

END. /* Завершение обработки всех договоров */




{setdest.i}

PUT UNFORMATTED "РАСЧЕТ ПРОЦЕНТОВ ПО ДЕПОЗИТАМ" AT 35 SKIP
                "по состоянию на " AT 36 repDate FORMAT "99/99/9999" SKIP(1).

FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "Проценты по балансовому счету " tt-report.balAcct%% SKIP(1).
		END.
	IF FIRST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED "По депозитам в валюте " tt-report.currency ":" SKIP(1).
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				"№ п/п "
				"|Организация                   "
				"|ВАЛ" 
				"|Договор №                "
    			"|Открыт    "
	        	"|Возврат   "
		        "|Счет процентов      "
				"|Сумма %% на 474"
				"|Ставка"
				"|Сумма депозита "
				"| До 1 дня      "
				"| До 5 дней     "
				"|  До 10 дней   "
				"|  До 20 дней   "
				"|  До 30 дней   "
				"|  До 90 дней   "
				"|  До 180 дней  "
				"|  До 270 дней  "
				"|  До 1 года    "
				"|  Свыше 1 года "
				SKIP
				FILL("-",295) SKIP.
		END.
	i = i + 1.
	totalSumma%% = totalSumma%% + Summa% .
	allpr4period[1]= allpr4period[1] + pr4period[1] .
	allpr4period[2]= allpr4period[2] + pr4period[2] .
	allpr4period[3]= allpr4period[3] + pr4period[3] .
	allpr4period[4]= allpr4period[4] + pr4period[4] .
	allpr4period[5]= allpr4period[5] + pr4period[5] .
	allpr4period[6]= allpr4period[6] + pr4period[6] .
	allpr4period[7]= allpr4period[7] + pr4period[7] .
	allpr4period[8]= allpr4period[8] + pr4period[8] .
	allpr4period[9]= allpr4period[9] + pr4period[9] .
	allpr4period[10]= allpr4period[10] + pr4period[10] .
	
	PUT UNFORMATTED
		i FORMAT ">>>>>>"
		"|" tt-report.clientName FORMAT "x(30)"
		"|" tt-report.currency FORMAT "XXX" 
		"|" tt-report.loanInfo FORMAT "x(25)"
   		"|" tt-report.loanOpenDate FORMAT "99/99/9999"
        	"|" tt-report.loanEndDate FORMAT "99/99/9999"
    		"|" tt-report.intAccount FORMAT "x(20)"
		"|" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"|" (tt-report.rate * 100) FORMAT ">>9.99"
		"|" tt-report.summaDeposit FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[1] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[2] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[3] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[4] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[5] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[6] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[7] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[8] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[9] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[10] FORMAT "->>>,>>>,>>9.99"
		
		SKIP.

	
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED	  FILL("-",295) SKIP
			  FILL(" ",111)
			  totalSumma%%  FORMAT "->>>,>>>,>>9.99" " "
			  FILL(" ",23)
			  allpr4period[1] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[2] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[3] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[4] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[5] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[6] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[7] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[8] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[9] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[10] FORMAT "->>>,>>>,>>9.99" " "
			  
			  SKIP(1).
			  totalSumma%% = 0.
			  allpr4period[1] = 0.
			  allpr4period[2] = 0.
			  allpr4period[3] = 0.  
			  allpr4period[4] = 0.
			  allpr4period[5] = 0.
			  allpr4period[6] = 0.
			  allpr4period[7] = 0.
			  allpr4period[8] = 0.
			  allpr4period[9] = 0.
			  allpr4period[10] = 0.

		END.
END.

{preview.i}


FUNCTION NOMER_YACH RETURNS INTEGER (INPUT date1 AS DATE, INPUT date2 AS DATE):
   DEFINE VAR vTmpStr AS INTEGER NO-UNDO.
   DEFINE VAR bdates AS INTEGER NO-UNDO.
   
   ASSIGN    bdates = date2 - date1 + 1 .    

/* MESSAGE 'kolvo dnei ' bdates VIEW-AS ALERT-BOX. */

      
      IF bdates <= 1 THEN 
      DO:
         vTmpStr = 1.
         RETURN vTmpStr.
      END.
      
      IF bdates > 1 AND bdates <= 5 THEN 
      DO:
         vTmpStr = 2.
         RETURN vTmpStr.
      END.
      
      IF bdates > 5 AND bdates <=10 THEN 
      DO:
         vTmpStr = 3.
         RETURN vTmpStr.
      END.
      
      IF bdates > 10 AND bdates <= 20 THEN 
      DO:
         vTmpStr = 4.
         RETURN vTmpStr.
      END.
      
      IF bdates > 20 AND bdates <= 30 THEN 
      DO:
         vTmpStr = 5.
         RETURN vTmpStr.
      END.
      
      IF bdates > 30 AND bdates <= 90 THEN 
      DO:
         vTmpStr = 6.
         RETURN vTmpStr.
      END.
      
      IF bdates > 90 AND bdates <= 180 THEN
      DO:
         vTmpStr = 7.
         RETURN vTmpStr.
      END.
      
      IF bdates > 180 AND bdates <= 270 THEN 
      DO:
         vTmpStr = 8.
         RETURN vTmpStr.
      END.

      IF bdates > 270 AND bdates <= 365 THEN 
      DO:
         vTmpStr = 9.
         RETURN vTmpStr.
      END.
    
      IF bdates > 365  THEN 
      DO:
         vTmpStr = 10.
         RETURN vTmpStr.
      END.
      
  
END. /*function*/


FUNCTION PIR_LOAN_PERCENT RETURNS DECIMAL (INPUT iContract AS CHAR,INPUT iContCode AS CHAR, INPUT iBegDate AS DATE, INPUT iEndDate AS DATE, INPUT iNeedMon AS LOGICAL):   

   DEF VAR begDate AS DATE NO-UNDO.
   DEF VAR endDate AS DATE NO-UNDO.
   DEF VAR balance AS DECIMAL NO-UNDO.
   DEF VAR newBalance AS DECIMAL NO-UNDO.
   DEF VAR rate AS DECIMAL NO-UNDO.
   DEF VAR newRate AS DECIMAL NO-UNDO.
   DEF VAR summa AS DECIMAL NO-UNDO.
   DEF VAR totalSumma AS DECIMAL NO-UNDO.
   DEF VAR period AS INTEGER NO-UNDO.
   DEF VAR iDate AS DATE NO-UNDO.
   DEF VAR periodBegin AS DATE NO-UNDO.
   DEF VAR periodEnd AS DATE NO-UNDO.
   DEF VAR periodBase AS INTEGER NO-UNDO.

   DEF VAR loan-end-date AS DATE NO-UNDO.

   DEF VAR mainLoan AS CHARACTER NO-UNDO.
   
   ASSIGN TotalSumma = 0 .
   
   /** База расчета процентов 365/366 */
   
   FIND FIRST loan WHERE loan.contract = iContract
                     and loan.cont-code = iContCode
                     NO-LOCK NO-ERROR.
                     
   IF NOT AVAIL loan THEN DO:
      MESSAGE "PirLoanPercent: договор '" + iContract + "." + iContCode + "' не найден!" VIEW-AS ALERT-BOX .
      /* RETURN. */
   END.


   IF  loan.end-date = ? 
   THEN loan-end-date = 01/01/2099.
   ELSE loan-end-date = loan.end-date.      
  

   mainLoan = GetMainLoan_ULL(loan.contract, loan.cont-code, false).
   
   begDate = iBegDate. endDate = iEndDate.
   
   periodBegin = MAX(begDate, loan.open-date + 1).
   /** В случаях когда дата окончания транша попадает на выходной день,
       дата окончания периода расчета процентов должна быть следующим рабочим днем.
       Здесь, вместо выражения 
   periodEnd = MIN(endDate, loan-end-date).
       выполним простое приcвоение
   */

    periodEnd = endDate. 

   
   /** Значения "до" периода */
   balance = GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, MIN(loan.since , PeriodBegin - 1), false) .
   rate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%Деп", periodBegin, false) .
   

   
   /** Побежали по дням */
   DO iDate = periodBegin TO periodEnd :
	
	 IF  iDate < loan.since THEN 
         newBalance =  GetLoanParamValue_ULL(loan.contract, loan.cont-code, 0, iDate, false).
	 ELSE
	 newBalance =  Balance
	 .


/*     MESSAGE "idate newbalanct= " idate " " newbalance VIEW-AS ALERT-BOX.*/
     
     newRate = GetLoanCommission_ULL(ENTRY(1, mainLoan), ENTRY(2, mainLoan), "%Деп", iDate + 1, false).
     
     /**    ЕСЛИ:
     	1) изменился остаток
     	2) изменилась процентная ставка
     	3) последний день месяца
 		4) последний день расчетного периода,
 			ТО:
 		"создаем" подпериод, расчитываем значения, аккумулируем общую сумму,
 		новые значения становятся текущими!
 	*/
 	 
     IF  (balance <> newBalance) OR (rate <> newRate) OR (DAY(iDate + 1) = 1 AND iDate < periodEnd) 
        OR iDate = periodEnd THEN
       DO:
       	
	     periodEnd = iDate.
	     periodBase = (IF TRUNCATE(YEAR(iDate) / 4,0) = YEAR(iDate) / 4 THEN 366 ELSE 365).
	     period = periodEnd - periodBegin + 1.
	     summa = round(balance * rate / periodBase * period, 2).
		 totalSumma = totalSumma + summa.
		 
	     IF iNeedMon THEN 
	     DO:
		MESSAGE "PirLoanPercent: "   VIEW-AS ALERT-BOX .
		MESSAGE "loan = "  loan.contract  "."  loan.cont-code   	VIEW-AS ALERT-BOX .
	        MESSAGE ", balance = "  STRING(balance)  	 VIEW-AS ALERT-BOX .
	        MESSAGE ", rate = "  STRING(rate)  	VIEW-AS ALERT-BOX .
	        MESSAGE ", periodBase = "  STRING(periodBase)  	VIEW-AS ALERT-BOX .
	        MESSAGE ", period = "  STRING(period)  "("  STRING(periodBegin)  " - "  STRING(periodEnd)  ")"  	VIEW-AS ALERT-BOX . 
	        MESSAGE ", summa = balance + rate / periodBase * period = "  STRING(summa)  	VIEW-AS ALERT-BOX .
	        MESSAGE ", totalSumma = "  STRING(totalSumma)   	VIEW-AS ALERT-BOX .
	    END.                             

		 periodBegin = periodEnd + 1.
		 periodEnd = MIN(endDate, loan-end-date).
		 balance = newBalance.
		 rate = newRate.         	    
	
       END.
   END. 
   
   RETURN totalSumma.
   
 
END FUNCTION. /* PIR_LOAN_PERCENT */










