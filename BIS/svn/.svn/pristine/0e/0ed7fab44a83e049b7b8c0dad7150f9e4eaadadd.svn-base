{pirsavelog.p}

/**
 * Создана из отчета "Наращенные проценты по договорам ЧВ" - pirincdpsf.p
 * Цель данного отчета - расчет планируемых расходов по будущим начислениям процентов до депозитным договорам частных лиц
 * Ермилов В.Н.
 * 30/03/2010 
 */
 
 /** Глобальные определения */
{globals.i}
{sh-defs.i}  /* Определение переменных для вычисления остатков процедурой acct-pos */
{dpsproc.def}

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
DEF VAR OstSumma AS DECIMAL NO-UNDO.
DEF VAR ProcStavka AS DECIMAL NO-UNDO. 
DEF VAR vYear AS DECIMAL NO-UNDO. 

DEF VAR n_yach AS INTEGER NO-UNDO.

DEF VAR nextDate AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR nextDateKorr AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR FirstDate AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR IDate AS DATE FORMAT "99/99/9999"  NO-UNDO.

DEF VAR NextPercent AS DECIMAL NO-UNDO.
DEF VAR AllPercent AS DECIMAL NO-UNDO.
DEF VAR FirstPercent AS DECIMAL NO-UNDO.
DEF VAR Percent AS DECIMAL NO-UNDO.
DEF VAR PeriodM AS CHAR NO-UNDO.
DEF VAR PeriodD AS DECIMAL NO-UNDO.

DEF VAR	AllPr4Period AS DECIMAL EXTENT 10 NO-UNDO.

def buffer LAcct for Loan-acct.

FUNCTION NOMER_YACH RETURNS INTEGER (INPUT date1 AS DATE, INPUT date2 AS DATE) FORWARD.

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
    	NO-LOCK,
    LAST loan-acct WHERE 
    	loan-acct.contract = loan.contract
    	AND loan-acct.cont-code = loan.cont-code
    	AND loan-acct.acct-type = "loan-dps-int"
    	AND loan-acct.since LE repDate
    	NO-LOCK
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
	
	/*Дата закрытия*/
	tt-report.loanEndDate = loan.end-date.
	
	/*Счет для перечисления процентов*/
	tt-report.intAccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-int", repDate, traceOnOff).
	
	
  	/*Счет частного вклада*/
  	tt-report.account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t,loan-dps-p", repDate, traceOnOff).
	
	/*Остаток на счете для перечисления процентов*/
	tt-report.summa%% = ABS(	GetAcctPosValue_UAL(loan-acct.acct,loan.currency, repDate, traceOnOff)  	).
  	
  	/*Даты */
  	IF loan.close-date <> ? AND loan.close-date LE repDate THEN
  		tmpDate = loan.close-date - 1.
  	ELSE IF loan.end-date <> ? AND loan.end-date LE repDate THEN
  		tmpDate = loan.end-date - 1.
  	ELSE
  		tmpDate = repDate.
	
	/* Остаток на счете частного вклада */	
	tt-report.summaDeposit = ABS(	GetAcctPosValue_UAL(tt-report.account,	loan.currency,tmpDate, traceOnOff)	).

	/* Действующая ставка по вкладу */		
	tt-report.rate = GetDpsCommission_ULL(loan.cont-code,"commission",repDate, traceOnOff).
		
	/*Тип вклада*/	
	tt-report.dpstype = loan.cont-type.
	
	/*Валюта*/
	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
	
	/*
	tt-report.summa%%d = GetDpsCurrentPersent_ULL(loan.cont-code, repDate, traceOnOff).
  	tt-report.summa%% = tt-report.summa%%1 + tt-report.summa%%d.
  	tt-report.nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, repDate, traceOnOff).
	*/




/**********************************************************************/

       	if can-do("!42306978800000000104,!42307840700000000001,!42307810400000735978,!42307810700000735979,!42307840300000000744,*",loan.cont-code) then do:

/* Основной блок разноски будущих процентов по столбцам 125ой формы   */
	allPercent = 0.
	firstPercent = tt-report.summa%%.
 
/* находим следующую для данного договора дату выплаты процентов */
 nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, repDate, traceOnOff).

/* MESSAGE 'First Next Date: ' nextDate VIEW-AS ALERT-BOX. */


/* пока данная дата не превысит дату завершения договора будем раскидывать начисляемые проценты по срокам */
DO WHILE nextDate LT tt-report.LoanEndDate :	

/* MESSAGE 'Data viplati: ' nextDate VIEW-AS ALERT-BOX. */

		/*находим дату расчета процентов кот. будут выплачены */
		nextDateKorr =   DATE(DATE(	STRING( "1/" + STRING(MONTH(nextDate)) + "/" + STRING(YEAR(nextDate)))	) - 1 ).                    

/* MESSAGE 'Data rascheta: ' nextDateKorr VIEW-AS ALERT-BOX. */

		
		/*Расчитываем сумму процентов на последнее число предыдущего месяца, она же и будет выплачена 5ого или 7ого числа*/
		nextPercent = GetDpsCurrentPersent_ULL(loan.cont-code, nextDateKorr, traceOnOff).

/*MESSAGE 'Next Percent: ' nextPercent VIEW-AS ALERT-BOX.*/

		
		/*Увеличиваем нужную ячейку массива Pr4Period на расчитанную сумму процентов и вычитаем сумму процентов 
		уже учтенную на предыдущих итерациях  */


/* MESSAGE 'REAL Percent: ' nextPercent + FirstPercent - allPercent  VIEW-AS ALERT-BOX. */

		
		n_yach = NOMER_YACH(repDate,nextDate).
			
		tt-report.Pr4period[n_yach] = tt-report.Pr4period[n_yach] + nextPercent + FirstPercent - allPercent.  
		
		/*Из-за косяка с расчетом процентов нарастающим итогом  запоминаем общую сумму уже отнесенных процентов на категории */
		allpercent =  nextpercent.
		firstPercent = 0.

/*MESSAGE 'all Percent: ' allPercent VIEW-AS ALERT-BOX.*/
		
		/*найдем следующую дату начисления процентов*/
		nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, DATE(nextDate + 1), traceOnOff).

/* MESSAGE 'Next next Date:) ' nextDate VIEW-AS ALERT-BOX. */
		
	END.
	end.

/*Теперь учтем проценты расчитываемые в день закрытия вклада, для вкладов типа КС это будет 
единственная итерация */
IF nextDate GE tt-report.LoanEndDate THEN
	DO:

		/*Расчитываем сумму процентов на дату возврата вклада*/
		nextPercent = GetDpsCurrentPersent_ULL(loan.cont-code, tt-report.LoanEndDate, traceOnOff).

		/*и относим ее на дату возврата вклада */
		n_yach = NOMER_YACH(repDate,tt-report.LoanEndDate).
		tt-report.Pr4period[n_yach] = tt-report.Pr4period[n_yach] + nextPercent + firstPercent - allPercent.  

	END.
/*Все! мы разнесли все проценты!!*/

/* MESSAGE Pr4Period[1] '  ' Pr4Period[2] '  ' Pr4Period[3] '  ' Pr4Period[4] '  ' Pr4Period[5] '  '
   Pr4Period[6] '  ' Pr4Period[7] '  ' Pr4Period[8] '  ' Pr4Period[9] '  ' Pr4Period[10] '  ' VIEW-AS ALERT-BOX. */

       	/* После совещания с Ситовым С. стало понятно, что Тип вклада не всегда соответствует Условию вклада.
       	   Как отделить вклады с выплатой процентов 5 или 7, но только зарезервированных по конец месяца без учета этих 5 или 7 дней пока не понятно.
       	   Поэтому делаю конктрено по ТЗ. Какие вклады не идут.
	   Это вклады с выплатой процентов каждый 3 месяц в определенный день с капитализацией.
	*/
       	if can-do("42306978800000000104,42307840700000000001,42307810400000735978,42307810700000735979,42307840300000000744",loan.cont-code) then do:
                nextDate = ?.
		Percent = 0.
		nextPercent = 0.
		/* посмомтрим условия договора*/
       		FIND LAST Loan-Cond WHERE Loan-Cond.contract = Loan.contract
       					AND Loan-Cond.cont-code = Loan.cont-code
       					AND Loan-Cond.since LE repDate
 					NO-LOCK NO-ERROR.

		FirstDate = Loan-Cond.since.
		/* посмотрим как начисляются проценты */
		if Loan-Cond.int-period begins "КМ[" then do:
			/* период в месяцах */ 
			PeriodM = SUBSTRING(Loan-Cond.int-period,INDEX(Loan-Cond.int-period,"[") + 1,INDEX(Loan-Cond.int-period,"]") - INDEX(Loan-Cond.int-period,"[") - 1).
			/* первая дата выплаты процентов с даты отчета */ 
    			do while FirstDate < repDate :
				FirstDate = Date((month(FirstDate) + dec(PeriodM)) MODULO 12,Loan-Cond.int-date,if month(FirstDate) + dec(PeriodM) > 12 then year(FirstDate) + 1 else year(FirstDate)).
				if FirstDate gt loan.end-date then FirstDate = loan.end-date.
        		end.
		end.

		if Loan-Cond.int-period eq "К" then do:
			/* период в месяцах */ 
			PeriodM = "3".
			FirstDate = Date(month(repDate),Loan-Cond.int-date,year(repDate)).	
			/* первая дата выплаты процентов с даты отчета */ 
    			do while month(FirstDate) MODULO 3 <> 1 :
				FirstDate = Date((month(FirstDate) + 1) MODULO 12,Loan-Cond.int-date,if month(FirstDate) + 1 > 12 then year(FirstDate) + 1 else year(FirstDate)).
				if FirstDate gt loan.end-date then FirstDate = loan.end-date.
        		end.
		end.

		/*посмотрим остаток на счете срочного вклада*/
		FIND FIRST LAcct where CAN-DO("loan-dps-t,loan-dps-p",LAcct.acct-type) 
				and LAcct.cont-code = Loan.cont-code
				and LAcct.since LE repDate
				and LAcct.contract eq "dps"
				NO-LOCK NO-ERROR.
		RUN acct-pos in h_base (LAcct.acct,LAcct.currency,repDate,repDate,gop-status).
		OstSumma = (IF Lacct.currency EQ "" THEN abs(sh-bal) ELSE abs(sh-val)).
		/*возьмем процентную ставку*/
       		ProcStavka = tt-report.rate. 

		/* а вдруг FirstDate выходной, тогда считаем проценты на след. раб. день*/
       		do while {holiday.i FirstDate} :
			FirstDate = FirstDate + 1.
                end.
		/*количество дней*/
		PeriodD = FirstDate - RepDate + 1.

		/* Смотрим високосный год. Случай если отчетная дата 01.12.15, а выплата 22.01.16. 
		   Тогда с 01.12.15 по 31.12.15 проценты считаем по 365, а с 01.01.16 по 22.01.16 считаем проценты по 366
		*/
		
		if Year(FirstDate) <> Year(RepDate) then do:
			vYear = Year(RepDate) MODULO 4.
			if vYear = 0 then do:
				PeriodD = date(12,31,Year(RepDate)) - RepDate + 1. 
				Percent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
				PeriodD = FirstDate - date(1,1,Year(FirstDate)). 
				Percent = Percent + round(OstSumma * ProcStavka / 365 * PeriodD,2).
			end.
			vYear = Year(FirstDate) MODULO 4.		
			if vYear = 0 then do:
				PeriodD = date(12,31,Year(RepDate)) - RepDate + 1. 
				Percent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
				PeriodD = FirstDate - date(1,1,Year(FirstDate)) + 1. 
				Percent = Percent + round(OstSumma * ProcStavka / 366 * PeriodD,2).
			end.
   		end.
		/* считаем проценты */
		if Percent = 0 then do:
			vYear = Year(RepDate) MODULO 4.		
                        if vYear = 0 then Percent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
			else Percent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
		end.
		RUN acct-pos in h_base (Loan-Acct.acct,Loan-Acct.currency,repDate,repDate,gop-status).
		/* прибавляем уже начисленные проценты на 474* */
                Percent = Percent + (if Loan-Acct.currency EQ "" THEN abs(sh-bal) ELSE abs(sh-val)).

		if PeriodD le 1 then tt-report.Pr4period[1] = tt-report.Pr4period[1] + Percent.
		if PeriodD gt 1 and PeriodD le 5 then tt-report.Pr4period[2] = tt-report.Pr4period[2] + Percent.
		if PeriodD gt 5 and PeriodD le 10 then tt-report.Pr4period[3] = tt-report.Pr4period[3] + Percent.
		if PeriodD gt 10 and PeriodD le 20 then tt-report.Pr4period[4] = tt-report.Pr4period[4] + Percent.
		if PeriodD gt 20 and PeriodD le 30 then tt-report.Pr4period[5] = tt-report.Pr4period[5] + Percent.
		if PeriodD gt 30 and PeriodD le 90 then tt-report.Pr4period[6] = tt-report.Pr4period[6] + Percent.
		if PeriodD gt 90 and PeriodD le 180 then tt-report.Pr4period[7] = tt-report.Pr4period[7] + Percent.
		if PeriodD gt 180 and PeriodD le 270 then tt-report.Pr4period[8] = tt-report.Pr4period[8] + Percent.
		if PeriodD gt 270 and PeriodD le 365 then tt-report.Pr4period[9] = tt-report.Pr4period[9] + Percent.
		if PeriodD gt 365 then tt-report.Pr4period[6] = tt-report.Pr4period[10] + Percent.

		do IDate = FirstDate to loan.end-date - 1 :
        		/* следующая дата выплаты процентов */ 
        		NextDate = Date((month(FirstDate) + dec(PeriodM)) MODULO 12,Loan-Cond.int-date,if month(FirstDate) + dec(PeriodM) > 12 then year(FirstDate) + 1 else year(FirstDate)). 
        		/* следующий период выплаты процентов*/ 
			if NextDate gt loan.end-date then NextDate = loan.end-date.
        		/* а вдруг NextDate выходной, тогда считаем проценты на след. раб. день*/
               		do while {holiday.i NextDate} :
        			NextDate = NextDate + 1. 
                        end.

        		PeriodD =  NextDate - FirstDate.
			OstSumma = OstSumma + Percent.
			/* смотрим высокосный ли год */
                	if Year(FirstDate) <> Year(NextDate) then do:
                		vYear = Year(FirstDate) MODULO 4.
                		if vYear = 0 then do:
                			PeriodD = date(12,31,Year(FirstDate)) - FirstDate. 
                			nextPercent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
                			PeriodD = NextDate - date(1,1,Year(NextDate)) + 1. 
                			nextPercent = nextPercent + round(OstSumma * ProcStavka / 365 * PeriodD,2).
                		end.
                		vYear = Year(NextDate) MODULO 4.		
                		if vYear = 0 then do:
                			PeriodD = date(12,31,Year(FirstDate)) - FirstDate. 
                			nextPercent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
                			PeriodD = NextDate - date(1,1,Year(NextDate)). 
                			nextPercent = nextPercent + round(OstSumma * ProcStavka / 366 * PeriodD,2).
                		end.
           		end.
                	/* считаем проценты */
                	if nextPercent = 0 then do:
                		vYear = Year(NextDate) MODULO 4.		
                                if vYear = 0 then nextPercent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
                		else nextPercent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
                	end.
/*                        nextPercent = round(OstSumma * ProcStavka / 365 * PeriodD,2).*/
                        FirstDate = NextDate.
			IDate = FirstDate.
        		Percent = nextPercent.
        		if nextDate - repDate le 1 then tt-report.Pr4period[1] = tt-report.Pr4period[1] + nextPercent.
        		if nextDate - repDate gt 1 and nextDate - repDate le 5 then tt-report.Pr4period[2] = tt-report.Pr4period[2] + nextPercent.
        		if nextDate - repDate gt 5 and nextDate - repDate le 10 then tt-report.Pr4period[3] = tt-report.Pr4period[3] + nextPercent.
        		if nextDate - repDate gt 10 and nextDate - repDate le 20 then tt-report.Pr4period[4] = tt-report.Pr4period[4] + nextPercent.
        		if nextDate - repDate gt 20 and nextDate - repDate le 30 then tt-report.Pr4period[5] = tt-report.Pr4period[5] + nextPercent.
        		if nextDate - repDate gt 30 and nextDate - repDate le 90 then tt-report.Pr4period[6] = tt-report.Pr4period[6] + nextPercent.
        		if nextDate - repDate gt 90 and nextDate - repDate le 180 then tt-report.Pr4period[7] = tt-report.Pr4period[7] + nextPercent.
        		if nextDate - repDate gt 180 and nextDate - repDate le 270 then tt-report.Pr4period[8] = tt-report.Pr4period[8] + nextPercent.
        		if nextDate - repDate gt 270 and nextDate - repDate le 365 then tt-report.Pr4period[9] = tt-report.Pr4period[9] + nextPercent.
        		if nextDate - repDate gt 365 then tt-report.Pr4period[10] = tt-report.Pr4period[10] + nextPercent.
			nextPercent = 0.
		end.
                nextDate = ?.
		Percent = 0.
		nextPercent = 0.
	end.

END. /* Завершение обработки всех договоров */




{setdest.i}

PUT UNFORMATTED "Наращенные проценты по депозитным вкладам, ожидаемые к выплате" AT 35 SKIP.
PUT UNFORMATTED "по состояюнию на " AT 50 repDate FORMAT "99/99/9999" SKIP(1).


FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
/*	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "Проценты по балансовому счету " tt-report.balAcct%% SKIP(1).
		END.
*/
	IF FIRST-OF(tt-report.currency) THEN
		DO:
/*			PUT UNFORMATTED "По депозитам в валюте " tt-report.currency ":" SKIP(1).*/
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				"№ п/п "
				"|Вкладчик                      "
				"|ВАЛ" 
				"|Договор №                "
            			"|Открыт    "
        	       		"|Возврат   "
        		        "|Счет процентов      "
				"|Сумма %% на 474"
				"|Ставка"
				"|Сумма вклада   "
				"|Тип вклада"
				"|         Суммы, ожидаемые к выплате в соответствии со сроком от отчетной даты до даты погашения                                                            "
				SKIP.
			PUT UNFORMATTED 
				"      "
				"|                              "
				"|   " 
				"|                         "
             			"|          "
         	       		"|          "
         		        "|                    "
				"|               "
				"|      "
				"|               "
				"|          "
				"|---------------------------------------------------------------------------------------------------------------------------------------------------------------"
				SKIP.
			PUT UNFORMATTED 
				"      "
				"|                              "
				"|   " 
				"|                         "
            			"|          "
        	       		"|          "
        		        "|                    "
				"|               "
				"|      "
				"|               "
				"|          "
				"|  До 1 дня     "
				"|  До 5 дней    "
				"|  До 10 дней   "
				"|  До 20 дней   "
				"|  До 30 дней   "
				"|  До 90 дней   "
				"|  До 180 дней  "
				"|  До 270 дней  "
				"|  До 1 года    "
				"|  Свыше 1 года "
				SKIP.
				put unformatted FILL("-",320) SKIP.
		END.
	i = i + 1.

	totalSumma%% = 	totalSumma%% + Summa%% .
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
   		"|" tt-report.dpstype FORMAT "x(10)"
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
			PUT UNFORMATTED	  FILL("-",320) SKIP
			  "ИТОГО"	
			  FILL(" ",106)
			  totalSumma%%  FORMAT "->>>,>>>,>>9.99" " "
			  FILL(" ",34) 
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
			  
			  totalSumma%%  = 0.
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

PUT UNFORMATTED	"Ответственный исполнитель У 5" SKIP.
PUT UNFORMATTED	"(ответственный за все графы)" SKIP(2).
PUT UNFORMATTED	"Контролер Нач. У 5" SKIP(3).

PUT UNFORMATTED	"Примечание к заполнению Приложения :" SKIP.
PUT UNFORMATTED	"гр 1,2, 4 -10 заполняются в соответствии с наименованием в графах" SKIP.  
PUT UNFORMATTED	"гр 4 указывается код валюты выдачи кредита 810 (рубли), 840 (долл), 978 (евро)" SKIP.
PUT UNFORMATTED	"гр 11 указывается периодичность выплаты %  (срочный*)" SKIP.
PUT UNFORMATTED	"гр 12-21 указываются ожидаемые к выплате проценты  в соответствующем временном периоде" SKIP. 
PUT UNFORMATTED	"* Итоговые значения заполняются по гр  12 - 21 в разрезе счета 2-го порядка" SKIP.
PUT UNFORMATTED	" (по счету 47411 и счету 47426) и валюты привлечения депозита" SKIP.

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




