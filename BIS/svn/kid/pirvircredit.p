/*
Наращенные процентные доходы, ожидаемые к погашению, по кредитам I и II (за вычетом расчетного резерва) категории качества .
#3365
Никитина Ю.А.
22.07.2013
*/
{globals.i}
{intrface.get i254}
{intrface.get comm}
{intrface.get instrum}  /* функции работы с финансовыми инструментами */
{getdate.i}
{sh-defs.i}
{svarloan.def NEW}          /* Shared переменные модуля "Кредиты и депозиты". */
{intrface.get tmess}    /* Инструменты обработки сообщений. */
{intrface.get xclass} /* Загрузка инструментария метасхемы */
{intrface.get pogcr}
{pir_exf_exl.i}

DEFINE NEW SHARED STREAM err.

DEF VAR oTable  AS TTable2    	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR oClient AS TClient    	NO-UNDO.

def var PrRisk  as DEC	 	NO-UNDO.
def var summ-t  as DEC	 	NO-UNDO.
def var summ-tt as DEC	 	NO-UNDO.
def var GrRisk  as int	 	NO-UNDO.
DEF VAR ac_r 	AS char	 	NO-UNDO.
DEF VAR ost_o 	AS dec	init 0 	NO-UNDO.
DEF VAR ost_or 	AS dec	init 0 	NO-UNDO.
DEF VAR proc 	AS dec	 	NO-UNDO.
DEF VAR sfinish as char 	NO-UNDO.
DEF VAR sstart 	as char 	NO-UNDO.
DEF VAR tstart 	as int64 	NO-UNDO.
DEF VAR i 	as dec   init 0	NO-UNDO.
DEF VAR j 	as int   init 0	NO-UNDO.
DEF VAR srok1_o	as dec   init 0	NO-UNDO.
DEF VAR srok2_o	as dec   init 0	NO-UNDO.
DEF VAR srok3_o	as dec   init 0	NO-UNDO.
DEF VAR srok4_o	as dec   init 0	NO-UNDO.
DEF VAR srok5_o	as dec   init 0	NO-UNDO.
DEF VAR srok6_o	as dec   init 0	NO-UNDO.
DEF VAR srok7_o	as dec   init 0	NO-UNDO.
DEF VAR srok8_o	as dec   init 0	NO-UNDO.
DEF VAR srok9_o	as dec   init 0	NO-UNDO.
DEF VAR srok10_o	as dec   init 0	NO-UNDO.
DEF VAR period 	as dec   init 0	NO-UNDO.
DEF VAR periodS	as dec   init 0	NO-UNDO.
DEF VAR NextDate as date 	NO-UNDO.
DEF VAR FirstDate as date 	NO-UNDO.
DEF VAR FirstDate2 as date 	NO-UNDO.
DEF VAR MonthDate as dec 	NO-UNDO.
DEF VAR iDate 	as date 	NO-UNDO.
DEF VAR rate_pr	as dec   init 0	NO-UNDO.
DEF VAR lend-date	as date	NO-UNDO.
DEF VAR ost_o_o	as dec   init 0	NO-UNDO.
DEF VAR ost_or_o	as dec   init 0	NO-UNDO.
DEF VAR ost_proc_o	as dec   init 0	NO-UNDO.
DEF VAR ost_rasrez_o	as dec   init 0	NO-UNDO.
DEF VAR ost_p-r_o	as dec   init 0	NO-UNDO.
DEF VAR ost_n_proc	as dec   init 0	NO-UNDO.
DEF VAR srok1_or	as dec   init 0	NO-UNDO.
DEF VAR srok2_or	as dec   init 0	NO-UNDO.
DEF VAR srok3_or	as dec   init 0	NO-UNDO.
DEF VAR srok4_or	as dec   init 0	NO-UNDO.
DEF VAR srok5_or	as dec   init 0	NO-UNDO.
DEF VAR srok6_or	as dec   init 0	NO-UNDO.
DEF VAR srok7_or	as dec   init 0	NO-UNDO.
DEF VAR srok8_or	as dec   init 0	NO-UNDO.
DEF VAR srok9_or	as dec   init 0	NO-UNDO.
DEF VAR srok10_or	as dec   init 0	NO-UNDO.
DEF VAR ost_o_or	as dec   init 0	NO-UNDO.
DEF VAR ost_proc_or	as dec   init 0	NO-UNDO.
DEF VAR ost_rasrez_or	as dec   init 0	NO-UNDO.
DEF VAR ost_p-r_or	as dec   init 0	NO-UNDO.
DEF VAR ost_n_procr	as dec   init 0	NO-UNDO.
DEF VAR nend-date	as date	NO-UNDO.
DEF VAR POS 	as char 	NO-UNDO.
DEF VAR outfile as char 	NO-UNDO.
DEF VAR vYear 	AS DEC 		NO-UNDO. 
DEF VAR	cXL     as char EXTENT 20 	NO-UNDO.
DEF VAR proc-name AS CHAR 	NO-UNDO.
 
DEF BUFFER loan-acct_o FOR loan-acct.
DEF BUFFER loan-acct_r FOR loan-acct.
DEF BUFFER loan-var_o FOR loan-var.
DEF BUFFER bfrloan FOR loan.
DEF BUFFER bfrterm-obl FOR term-obl.
DEF BUFFER bfr2term-obl FOR term-obl.
           
oTable = new TTable2(24).
oTpl = new TTpl("pirvircredit.tpl").

DEF temp-table tmp_virtp NO-UNDO
    FIELD name       as char 
    FIELD cont-code  as char 
    FIELD val        as char 
    FIELD acct_o     as char
    FIELD acct_r     as char
    FIELD ost_o      as dec 
    FIELD ost_or     as dec 
    FIELD ost_n_proc as dec init 0
    FIELD ost_proc   as dec 
    FIELD ost_rasrez as dec 
    FIELD ost_p-r    as dec
    FIELD kk         as dec
    FIELD prrisk     as dec
    FIELD kolday     as dec
    FIELD endd       as date
    FIELD srok1      as dec
    FIELD srok2      as dec
    FIELD srok3      as dec
    FIELD srok4      as dec
    FIELD srok5      as dec
    FIELD srok6      as dec
    FIELD srok7      as dec
    FIELD srok8      as dec
    FIELD srok9      as dec
    FIELD srok10     as dec
.
/* посчитаем время работы */
sstart = string(Time,"HH:MM:SS").
tstart = Time.
i = 0.

/* функция для расчета процентов с учетом високосного года */
/* iFirstDate - начало периода, iNextDate - окончание периода, iost_o - остаток, irate_pr - процентаня ставка*/
function fProc RETURN DEC (iFirstDate as date, iNextDate as date, iost_o as dec, irate_pr as dec).
	def var osumm-t as dec NO-UNDO init 0.
	def var mvYear  as DEC NO-UNDO init 0.
	def var mPeriod as int NO-UNDO init 0.

        if Year(iFirstDate) <> Year(iNextDate) then do:
        	mvYear = Year(iFirstDate) MODULO 4.
        	if mvYear = 0 then do:
        		mPeriod = date(12,31,Year(iFirstDate)) - iFirstDate. 
        		osumm-t = round(iost_o * rate_pr / 100 / 366 * mPeriod,2).
        		mPeriod = iNextDate - date(1,1,Year(iNextDate)) + 1. 
        		osumm-t = osumm-t + round(iost_o * irate_pr / 100 / 365 * mPeriod,2).
        	end.
        	mvYear = Year(iNextDate) MODULO 4.		
        	if mvYear = 0 then do:
        		mPeriod = date(12,31,Year(iFirstDate)) - iFirstDate. 
        		osumm-t = round(iost_o * irate_pr / 100 / 365 * mPeriod,2).
        		mPeriod = iNextDate - date(1,1,Year(iNextDate)). 
        		osumm-t = osumm-t + round(iost_o * irate_pr / 100 / 366 * mPeriod,2).
        	end.
           end.
        /* считаем проценты */
        if osumm-t = 0 then do:
		mperiod = iNextDate - iFirstDate.
        	mvYear = Year(iNextDate) MODULO 4.
                if mvYear = 0 then osumm-t = round(iost_o * irate_pr / 100 / 366 * mperiod,2).
        	else osumm-t = round(iost_o * irate_pr / 100 / 365 * mperiod,2).
        end.
	return osumm-t.
end.

/*06/13,76/12,60/12,63/12,01/13,105/11,56/12,КЛ-71/12*,КЛ-12/13*,70/12,18/13,КЛ-27/13*,81/11*/
for each loan  where loan.contract eq "Кредит"
		and can-do("!MM*,!ПК*,!1/12*,!НО*,*",loan.cont-code) 
/*		and can-do("кл-02/13*",loan.cont-code)                 */
                and (loan.close-date GE end-date or loan.close-date eq ?) 
		and loan.open-date LT end-date 
		no-lock:
        /* Смотрим дату пересчета договора. И говорим пользователю, если договор не пересчитать на один день вперед, чтобы появились нужные параметры учета процентов */
        if (loan.since < end-date and loan.close-date eq ? and loan.cont-code begins "КЛ") 
		or (loan.since <> end-date and loan.close-date eq ? and can-do("!КЛ*,*",loan.cont-code))  then do:
		message "Пересчитайте договор " loan.cont-code " на дату " (end-date) "." VIEW-AS ALERT-BOX.
                RETURN.
	end.
  	PrRisk = LnRsrvRate(loan.contract, loan.cont-code, end-date). /* коэф. резервирования */
	GrRisk = LnGetGrRiska(PrRisk, end-date).                      /* категория качества */
	/* в ПОСе */
	POS = LnInBagOnDate(loan.contract,loan.cont-code,end-date - 1).
	/* если в Посе, то КК будет другая*/	
	if POS ne ? then GrRisk = PsGetGrRiska(PrRisk,loan.cust-cat,end-date - 1) .

	if GrRisk = 1 or GrRisk = 2 then do:
		ost_o = 0.
		if loan.cont-code begins "КЛ" then do:
			find first tmp_virtp where tmp_virtp.cont-code eq entry(1,loan.cont-code," ") no-lock no-error.
		        if not avail tmp_virtp then do:
                              	create tmp_virtp.
                         	tmp_virtp.cont-code = entry(1,loan.cont-code," ").
                         	tmp_virtp.val = loan.currency.
                        	tmp_virtp.prrisk = PrRisk.
                        	tmp_virtp.kk = GrRisk.
                         	oClient = NEW TClient(loan.cust-cat,loan.cust-id).
                         	tmp_virtp.name = oClient:name-short.
                 	        DELETE OBJECT oClient.
                		/* определяем счет основго долга.  */
                		find last loan-acct_o where loan-acct_o.contract EQ loan.contract
                	                       	AND loan-acct_o.cont-code EQ loan.cont-code
                				AND loan-acct_o.acct-type eq  "Кредит"
                				AND loan-acct_o.since LE end-date 
                				no-lock no-error.
                		if avail loan-acct_o then do:
                			tmp_virtp.acct_o = loan-acct_o.acct.
                		end.
        		end.
			/* если это транш */
			if loan.cont-code matches "* *" then do:
        		/* смотрим остаток на конец месяца */
                		find last loan-var_o OF loan WHERE
                				loan-var_o.amt-id = 0
                				AND loan-var_o.since < end-date
                				NO-LOCK no-error.
				if avail loan-var_o then do:
                                        ost_o = loan-var_o.balance.
					ost_or = loan-var_o.balance. 
        				tmp_virtp.ost_o = tmp_virtp.ost_o + ost_o.
                        		if loan.currency ne "" then do:
                                		/* пересчитаем в рубли по курсу последнего рабочего дня */
                                		nend-date = end-date - 1.
                                       		do while {holiday.i nend-date} :
                                			nend-date = nend-date - 1.
                                                end.
                        			ost_or = CurToCurWork("Учетный",loan.currency,"",nend-date,ost_o). 
                        		end.
                                        tmp_virtp.ost_or = tmp_virtp.ost_or + ost_or.

        				FirstDate = end-date - 1.
        				/* дата окончания или пролонгации договора */
        				lend-date = loan.end-date.
        				find first pro-obl where pro-obl.cont-code eq loan.cont-code and pro-obl.pr-date GT end-date - 1 no-lock no-error.
        				if avail pro-obl then lend-date = pro-obl.end-date.
					summ-t = 0. 
					proc = 0.
					NextDate = ?.
        				/* нашли процентную ставку */ 
        				rate_pr = GET_COMM("%Кред",?,loan.currency,loan.contract + "," + entry(1,loan.cont-code," "),0,0,end-date).
        				do iDate = end-date to lend-date:
						/* смотрим на график платежей на охвате */ 
						find first bfrloan where bfrloan.cont-code eq entry(1,loan.cont-code," ") no-lock no-error.
						if avail bfrloan then do:
                                                        FIND FIRST bfrterm-obl WHERE bfrterm-obl.contract EQ bfrloan.contract 
                        					AND bfrterm-obl.cont-code EQ bfrloan.cont-code
                        					AND bfrterm-obl.idnt EQ 1
                        			                and bfrterm-obl.end-date GT FirstDate 
        							and bfrterm-obl.end-date LE lend-date 

                        					NO-LOCK no-error.
							if avail bfrterm-obl then do:
								NextDate = bfrterm-obl.end-date.
							end.
							else do:
								NextDate = lend-date.
							end.
						end.
						else do: /* если графика нет, то ожидаем выплату процентов в конце каждого месяца. */
        					     /* дата окончания месяца */
                                                     	NextDate = date(if (month(FirstDate + 1) + 1) >12 then (month(FirstDate + 1) + 1) MODULO 12 else (month(FirstDate + 1) + 1), 1, if month(FirstDate + 1) + 1 > 12 then year(FirstDate + 1) + 1 else year(FirstDate + 1)) - 1.
        						if NextDate > lend-date then NextDate = lend-date.
						end.
                		        	period = NextDate - FirstDate.

						/* смотрим а не уменьшился ли ОД по графику платежей */
						FirstDate2 = FirstDate.
                                                FOR EACH bfr2term-obl WHERE bfr2term-obl.contract EQ loan.contract 
                					AND bfr2term-obl.cont-code EQ loan.cont-code
                					AND bfr2term-obl.idnt EQ 3
                			                and bfr2term-obl.end-date GT FirstDate2 
							and bfr2term-obl.end-date LE NextDate 
                                                        NO-LOCK break by bfr2term-obl.end-date:
                                                        summ-t = fProc(FirstDate2,bfr2term-obl.end-date,ost_o,rate_pr). 
 							FirstDate2 = bfr2term-obl.end-date.
                                                        RUN summ-t.p(OUTPUT summ-tt,loan.Contract,loan.Cont-Code,RECID(bfr2term-obl),end-date - 1).
 							ost_o = ost_o - summ-tt.
							if last-of(bfr2term-obl.end-date) then do:
								summ-t = summ-t +  fProc(FirstDate2,NextDate,ost_o,rate_pr).
							end.
						end.

                                		/* Смотрим високосный год. Случай если отчетная дата 01.12.15, а выплата 22.01.16. 
                                		   Тогда с 01.12.15 по 31.12.15 проценты считаем по 365, а с 01.01.16 по 22.01.16 считаем проценты по 366
                                		*/
                                                if summ-t = 0 then do:
							summ-t = fProc(FirstDate,NextDate,ost_o,rate_pr).
						end. 

                                                /* считаем проценты */
                        			/* summ-t = ost_o * rate_pr / 100 / 365 * period.*/
                        			/* сколько всего процентов */
                        			tmp_virtp.ost_proc = tmp_virtp.ost_proc + summ-t.
                        			/* расчетный резерв */
                                                tmp_virtp.ost_rasrez = tmp_virtp.ost_rasrez + round(summ-t * PrRisk / 100,2).
                        			/*проценты за минусом расчетного резерва*/
                        			proc = summ-t - round(summ-t * PrRisk / 100,2).
                        			tmp_virtp.ost_p-r = tmp_virtp.ost_p-r + proc.
                        			/* if loan.currency <> "" then proc = CurToCurWork("Учетный",loan.currency,"",nend-date,proc). */
						/* начисляем проценты за месяц, а ждем оплаты в послредний раб. день*/

						FirstDate = NextDate.
						iDate = NextDate.
        					 
        					if avail bfrterm-obl then do:
							if bfrterm-obl.end-date eq bfrterm-obl.dsc-beg-date then do:
                                                       		do while {holiday.i NextDate} :
                                                			NextDate = NextDate - 1.
                                                                end.
							end.
        						/* если сдвигать надо вперед, тогда берем из графика*/
                					else NextDate = bfrterm-obl.dsc-beg-date.
        					end.
						else do:
                                               		do while {holiday.i NextDate} :
                                        			NextDate = NextDate - 1.
                                                        end.
						end.

                        			PeriodS = NextDate - end-date + 1.
                                		if periodS le 1 then tmp_virtp.srok1 = tmp_virtp.srok1 + proc.
                                		if PeriodS gt 1 and PeriodS le 5 then tmp_virtp.srok2 = tmp_virtp.srok2 + proc.
                                		if PeriodS gt 5 and PeriodS le 10 then tmp_virtp.srok3 = tmp_virtp.srok3 + proc.
                                		if PeriodS gt 10 and PeriodS le 20 then tmp_virtp.srok4 = tmp_virtp.srok4 + proc.
                                		if PeriodS gt 20 and PeriodS le 30 then tmp_virtp.srok5 = tmp_virtp.srok5 + proc.
                                		if PeriodS gt 30 and PeriodS le 90 then tmp_virtp.srok6 = tmp_virtp.srok6 + proc.
                                		if PeriodS gt 90 and PeriodS le 180 then tmp_virtp.srok7 = tmp_virtp.srok7 + proc.
                                		if PeriodS gt 180 and PeriodS le 270 then tmp_virtp.srok8 = tmp_virtp.srok8 + proc.
                                		if PeriodS gt 270 and PeriodS le 365 then tmp_virtp.srok9 = tmp_virtp.srok9 + proc.
                                		if PeriodS gt 365 then tmp_virtp.srok10 = tmp_virtp.srok10 + proc.
						summ-t = 0.

        				end.
				end.
                  	end.
			else do: 	
				/* нашли процентную ставку */ 
				rate_pr = GET_COMM("%Кред",?,loan.currency,loan.contract + "," + loan.cont-code,0,0,end-date).
                                /* Смотрим сколько было начислено процентов */
                		for each loan-int where loan-int.cont-code = loan.cont-code
                		    	        	and loan-int.contract = loan.contract
                  		 		        and loan-int.mdate >= loan.open-date 
                  		 		        and loan-int.mdate < end-date
                					and ((loan-int.id-d = 33) and (loan-int.id-k = 32)) /* ОПЕРАЦИЯ 65. начислено процентов на баланс */
                					NO-LOCK :
                			tmp_virtp.ost_proc = tmp_virtp.ost_proc + loan-int.amt-rub.
                			tmp_virtp.ost_n_proc = tmp_virtp.ost_n_proc + loan-int.amt-rub.
                		end.
                                /* Смотрим сколько было оплачено процентов */
                		for each loan-int where loan-int.cont-code = loan.cont-code
                		    	        	and loan-int.contract = loan.contract
                  		 		        and loan-int.mdate >= loan.open-date 
                  		 		        and loan-int.mdate < end-date 
                					and (((loan-int.id-d = 5) and (loan-int.id-k = 35)) /* ОПЕРАЦИЯ 46. оплата начисленных процентов */	
							       or ((loan-int.id-d = 5) and (loan-int.id-k = 10))) /* ОПЕРАЦИЯ 362. Оплата просроченых процентов 302-П . Пример КЛ-112/11*/
                					NO-LOCK :
                			tmp_virtp.ost_proc = tmp_virtp.ost_proc - loan-int.amt-rub.
                			tmp_virtp.ost_n_proc = tmp_virtp.ost_n_proc - loan-int.amt-rub.
                		end.
                		/* занесем начисленные проценты в график */
				/* смотрим на график платежей на охвате */
       				FirstDate = end-date - 1.
				find first bfrloan where bfrloan.cont-code eq loan.cont-code no-lock no-error.
				if avail bfrloan then do:
                                        FIND FIRST bfrterm-obl WHERE bfrterm-obl.contract EQ bfrloan.contract 
        					AND bfrterm-obl.cont-code EQ bfrloan.cont-code
        					AND bfrterm-obl.idnt EQ 1
        			                and bfrterm-obl.end-date GT FirstDate 
						and bfrterm-obl.end-date LE lend-date 

        					NO-LOCK no-error.
					if avail bfrterm-obl then do:
						NextDate = bfrterm-obl.end-date.
					end.
					else do:
						NextDate = lend-date.
					end.
				end.
				else do: /* если графика нет, то ожидаем выплату процентов в конце каждого месяца. */
				     /* дата окончания месяца */
                                     	NextDate = date(if (month(FirstDate + 1) + 1) >12 then (month(FirstDate + 1) + 1) MODULO 12 else (month(FirstDate + 1) + 1), 1, if month(FirstDate + 1) + 1 > 12 then year(FirstDate + 1) + 1 else year(FirstDate + 1)) - 1.
					if NextDate > lend-date then NextDate = lend-date.
				end.

                                summ-t = tmp_virtp.ost_n_proc.
        			/* расчетный резерв */
                                tmp_virtp.ost_rasrez = tmp_virtp.ost_rasrez + round(summ-t * PrRisk / 100,2).
        			/*проценты за минусом расчетного резерва*/
        			proc = summ-t - round(summ-t * PrRisk / 100,2).
        			tmp_virtp.ost_p-r = tmp_virtp.ost_p-r + proc.
				/* начисляем проценты за месяц, а ждем оплаты в послредний раб. день*/

				if avail bfrterm-obl then do:
					if bfrterm-obl.end-date eq bfrterm-obl.dsc-beg-date then do:
                                       		do while {holiday.i NextDate} :
                                			NextDate = NextDate - 1.
                                                end.
					end.
					/* если сдвигать надо вперед, тогда берем из графика*/
					else NextDate = bfrterm-obl.dsc-beg-date.
				end.
				else do:
                               		do while {holiday.i NextDate} :
                        			NextDate = NextDate - 1.
                                        end.
				end.

        			PeriodS = NextDate - end-date + 1.
                		if periodS le 1 then tmp_virtp.srok1 = tmp_virtp.srok1 + proc.
                		if PeriodS gt 1 and PeriodS le 5 then tmp_virtp.srok2 = tmp_virtp.srok2 + proc.
                		if PeriodS gt 5 and PeriodS le 10 then tmp_virtp.srok3 = tmp_virtp.srok3 + proc.
                		if PeriodS gt 10 and PeriodS le 20 then tmp_virtp.srok4 = tmp_virtp.srok4 + proc.
                		if PeriodS gt 20 and PeriodS le 30 then tmp_virtp.srok5 = tmp_virtp.srok5 + proc.
                		if PeriodS gt 30 and PeriodS le 90 then tmp_virtp.srok6 = tmp_virtp.srok6 + proc.
                		if PeriodS gt 90 and PeriodS le 180 then tmp_virtp.srok7 = tmp_virtp.srok7 + proc.
                		if PeriodS gt 180 and PeriodS le 270 then tmp_virtp.srok8 = tmp_virtp.srok8 + proc.
                		if PeriodS gt 270 and PeriodS le 365 then tmp_virtp.srok9 = tmp_virtp.srok9 + proc.
                		if PeriodS gt 365 then tmp_virtp.srok10 = tmp_virtp.srok10 + proc.
				summ-t = 0.
			end.
		end.
		else do:
                       	create tmp_virtp.
                	tmp_virtp.cont-code = loan.cont-code.
                	tmp_virtp.val = loan.currency.
                	tmp_virtp.prrisk = PrRisk.
                	tmp_virtp.kk = GrRisk.
                	oClient = NEW TClient(loan.cust-cat,loan.cust-id).
                	tmp_virtp.name = oClient:name-short.
        	        DELETE OBJECT oClient.
        		/* определяем счет основго долга.  */
        		find last loan-acct_o where loan-acct_o.contract EQ loan.contract
        	                       	AND loan-acct_o.cont-code EQ loan.cont-code
        				AND loan-acct_o.acct-type eq  "Кредит"
        				AND loan-acct_o.since LE end-date 
        				no-lock no-error.
        		if avail loan-acct_o then do:
        			tmp_virtp.acct_o = loan-acct_o.acct.
        		end.
			/* нашли процентную ставку */ 
			rate_pr = GET_COMM("%Кред",?,loan.currency,loan.contract + "," + loan.cont-code,0,0,end-date).
        		/* смотрим остаток на конец месяца */
        		find last loan-var_o OF loan WHERE
        				loan-var_o.amt-id = 0
        				AND loan-var_o.since LT end-date
        				NO-LOCK no-error.
			if avail loan-var_o then do: 
        			ost_o = loan-var_o.balance.
        			ost_or = loan-var_o.balance.
				tmp_virtp.ost_o = tmp_virtp.ost_o + ost_o.
                		if loan.currency ne "" then do:
                        		/* пересчитаем в рубли по курсу последнего рабочего дня */
                        		nend-date = end-date - 1.
                               		do while {holiday.i nend-date} :
                        			nend-date = nend-date - 1.
                                        end.
                			ost_or = round(CurToCurWork("Учетный",loan.currency,"",nend-date,ost_o),2). 
                		end.
                                tmp_virtp.ost_or = tmp_virtp.ost_or + ost_or.

                                /* Смотрим сколько было начислено процентов */
                		for each loan-int where loan-int.cont-code = loan.cont-code
                		    	        	and loan-int.contract = loan.contract
                  		 		        and loan-int.mdate >= loan.open-date 
                  		 		        and loan-int.mdate < end-date
                					and ((loan-int.id-d = 33) and (loan-int.id-k = 32)) /* ОПЕРАЦИЯ 65. начислено процентов на баланс */
                					NO-LOCK :
                			/*tmp_virtp.ost_proc = tmp_virtp.ost_proc + loan-int.amt-rub. */
                			tmp_virtp.ost_n_proc = tmp_virtp.ost_n_proc + loan-int.amt-rub.
                		end.
                                /* Смотрим сколько было оплачено процентов */
                		for each loan-int where loan-int.cont-code = loan.cont-code
                		    	        	and loan-int.contract = loan.contract
                  		 		        and loan-int.mdate >= loan.open-date 
                  		 		        and loan-int.mdate < end-date 
                					and ((loan-int.id-d = 5) and (loan-int.id-k = 35)) /* ОПЕРАЦИЯ 46. оплата начисленных процентов */	
                					NO-LOCK :
                			/*tmp_virtp.ost_proc = tmp_virtp.ost_proc - loan-int.amt-rub.*/
                			tmp_virtp.ost_n_proc = tmp_virtp.ost_n_proc - loan-int.amt-rub.
                		end.

				/*FirstDate = end-date - 1.
				/* дата окончания или пролонгации договора */

				lend-date = loan.end-date.
				find first pro-obl where pro-obl.cont-code eq loan.cont-code and pro-obl.pr-date GT end-date - 1 no-lock no-error.
				if avail pro-obl then lend-date = pro-obl.end-date. 
				do iDate = end-date to lend-date:
					/* ожидаем выплату процентов в конце каждого месяца. */
					/* дата окончания месяца */
					NextDate = date(if (month(FirstDate + 1) + 1) >12 then (month(FirstDate + 1) + 1) MODULO 12 else (month(FirstDate + 1) + 1), 1, if month(FirstDate + 1) + 1 > 12 then year(FirstDate + 1) + 1 else year(FirstDate + 1)) - 1.
					if NextDate > lend-date then NextDate = lend-date.
        		        	period = NextDate - FirstDate.
					FirstDate = NextDate.

                			/* считаем проценты */
                			summ-t = ost_o * rate_pr / 100 / 365 * period.
                			/* сколько всего процентов */
                			tmp_virtp.ost_proc = tmp_virtp.ost_proc + summ-t.
                			/* расчетный резерв */
                                        tmp_virtp.ost_rasrez = tmp_virtp.ost_rasrez + summ-t * PrRisk / 100.
                			/*проценты за минусом расчетного резерва*/
                			proc = summ-t - summ-t * PrRisk / 100.
                			tmp_virtp.ost_p-r = tmp_virtp.ost_p-r + proc.
                			/* if loan.currency <> "" then proc = CurToCurWork("Учетный",loan.currency,"",nend-date,proc). */
                			PeriodS = NextDate - end-date + 1.
                        		if periodS le 1 then tmp_virtp.srok1 = tmp_virtp.srok1 + proc.
                        		if PeriodS gt 1 and PeriodS le 5 then tmp_virtp.srok2 = tmp_virtp.srok2 + proc.
                        		if PeriodS gt 5 and PeriodS le 10 then tmp_virtp.srok3 = tmp_virtp.srok3 + proc.
                        		if PeriodS gt 10 and PeriodS le 20 then tmp_virtp.srok4 = tmp_virtp.srok4 + proc.
                        		if PeriodS gt 20 and PeriodS le 30 then tmp_virtp.srok5 = tmp_virtp.srok5 + proc.
                        		if PeriodS gt 30 and PeriodS le 90 then tmp_virtp.srok6 = tmp_virtp.srok6 + proc.
                        		if PeriodS gt 90 and PeriodS le 180 then tmp_virtp.srok7 = tmp_virtp.srok7 + proc.
                        		if PeriodS gt 180 and PeriodS le 270 then tmp_virtp.srok8 = tmp_virtp.srok8 + proc.
                        		if PeriodS gt 270 and PeriodS le 365 then tmp_virtp.srok9 = tmp_virtp.srok9 + proc.
                        		if PeriodS gt 365 then tmp_virtp.srok10 = tmp_virtp.srok10 + proc.
				end.
				*/
				/* график платежей по процентам */
				lend-date = loan.end-date.
				find first pro-obl where pro-obl.cont-code eq loan.cont-code and pro-obl.pr-date GT end-date - 1 no-lock no-error.
				if avail pro-obl then lend-date = pro-obl.end-date.
                		FOR EACH term-obl WHERE term-obl.contract EQ loan.contract 
                					AND term-obl.cont-code EQ loan.cont-code
                					AND term-obl.idnt EQ 1
                			                and term-obl.end-date GE end-date
							and term-obl.end-date LE lend-date 
                					NO-LOCK:
                 			/* непогашенный остаток */
                			RUN summ-t1.p (OUTPUT summ-t,RECID(term-obl),RECID(loan)).
					/* {summ-t1.i mPayDate=end-date} */
					/* если договор закрыт при составлении отчета, но был открыт на дату end-date, тогда считаем руками. 
					   не бьем его на периоды , т.к. считаем , что это текущий месяц
					*/
					if loan.close-date ne ? then do:
						period = term-obl.end-date - end-date + 1.
                                       		vYear = Year(term-obl.end-date) MODULO 4.		
                                                if vYear = 0 then summ-t = round(ost_o * rate_pr / 100 / 366 * period,2).
                                      		else summ-t = round(ost_o * rate_pr / 100 / 365 * period,2).
                                                summ-t = tmp_virtp.ost_n_proc + summ-t.
        				end.
                			/* сколько всего процентов */
                			tmp_virtp.ost_proc = tmp_virtp.ost_proc + summ-t.
                       			/* расчетный резерв */
                                        tmp_virtp.ost_rasrez = tmp_virtp.ost_rasrez + round(summ-t * PrRisk / 100,2).
   	        			/*проценты за минусом расчетного резерва*/
                			proc = summ-t - round(summ-t * PrRisk / 100,2).
                			tmp_virtp.ost_p-r = tmp_virtp.ost_p-r + proc.
					/* начисляем проценты за месяц, а ждем оплаты в послредний раб. день*/
					NextDate = term-obl.end-date.
					if term-obl.end-date eq term-obl.dsc-beg-date then do:
                                       		do while {holiday.i NextDate} :
                                			NextDate = NextDate - 1.
                                                end.
					end.
					/* если сдвигать надо вперед, тогда берем из графика*/
					else NextDate = term-obl.dsc-beg-date.
					PeriodS = NextDate - end-date + 1.
                        		if PeriodS le 1 then tmp_virtp.srok1 = tmp_virtp.srok1 + proc.
                        		if PeriodS gt 1 and PeriodS le 5 then tmp_virtp.srok2 = tmp_virtp.srok2 + proc.
                        		if PeriodS gt 5 and PeriodS le 10 then tmp_virtp.srok3 = tmp_virtp.srok3 + proc.
                        		if PeriodS gt 10 and PeriodS le 20 then tmp_virtp.srok4 = tmp_virtp.srok4 + proc.
                        		if PeriodS gt 20 and PeriodS le 30 then tmp_virtp.srok5 = tmp_virtp.srok5 + proc.
                        		if PeriodS gt 30 and PeriodS le 90 then tmp_virtp.srok6 = tmp_virtp.srok6 + proc.
                        		if PeriodS gt 90 and PeriodS le 180 then tmp_virtp.srok7 = tmp_virtp.srok7 + proc.
                        		if PeriodS gt 180 and PeriodS le 270 then tmp_virtp.srok8 = tmp_virtp.srok8 + proc.
                        		if PeriodS gt 270 and PeriodS le 365 then tmp_virtp.srok9 = tmp_virtp.srok9 + proc.
                        		if PeriodS gt 365 then tmp_virtp.srok10 = tmp_virtp.srok10 + proc.
					summ-t = 0.
                  		end.

			end.
		end.
	end.
end.

sfinish = string(Time,"HH:MM:SS").
i = 0.
j = 1.
for each tmp_virtp where tmp_virtp.ost_o <> 0 no-lock break by tmp_virtp.kk by tmp_virtp.val by tmp_virtp.cont-code :
	ACCUMULATE tmp_virtp.srok1 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok2 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok3 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok4 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok5 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok6 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok7 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok8 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok9 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.srok10 (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.ost_o (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.ost_or (TOTAL by tmp_virtp.kk BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.ost_proc (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.ost_rasrez (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.ost_p-r (TOTAL BY tmp_virtp.val).
	ACCUMULATE tmp_virtp.ost_n_proc (TOTAL BY tmp_virtp.val).
	i = i + 1.
       	PAUSE 0. 
       	Display "Сохраняю в файл." format "x(30)" skip "Ничего не нажимайте. Ждите." format "x(30)" skip 
		"Обрабатываю клиента :" + string(i) format "x(30)" skip 
		tmp_virtp.name format "x(30)"  
        	tmp_virtp.cont-code format "x(30)" skip 
		tmp_virtp.val format "x(30)"  
		with frame Inf3 overlay Centered . pause 0. 


	if LENGTH(cXL[j]) > 30000 then j = j + 1.
	cXL[j] = cXL[j] + XLRowInFormat(45,"s80") + XLCell(string(i)) + XLCell(tmp_virtp.cont-code) 
			+ XLCell(if tmp_virtp.val eq "" then "810" else tmp_virtp.val) 
                        + XLCell(tmp_virtp.name) 
                        + XLCellInFormat(tmp_virtp.acct_o,"s68")
			+ XLCellInFormat(string(tmp_virtp.kk,">>9.99"),"s68")
			+ XLCellInFormat(string(tmp_virtp.prrisk,">>9.99") + "%","s68")
			+ XLNumECellInFormat(tmp_virtp.ost_o,"s69") 
			+ XLNumECellInFormat(tmp_virtp.ost_proc,"s69")
			+ XLNumECellInFormat(tmp_virtp.ost_n_proc,"s69")
			+ XLNumECellInFormat(tmp_virtp.ost_rasrez,"s69")
			+ XLNumECellInFormat(tmp_virtp.ost_p-r,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok1,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok2,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok3,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok4,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok5,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok6,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok7,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok8,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok9,"s69")
			+ XLNumECellInFormat(tmp_virtp.srok10,"s69")
			+ XLRowEnd().
       	if last-of(tmp_virtp.val) then do:
		srok1_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok1.
		srok2_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok2.
		srok3_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok3.
		srok4_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok4.
		srok5_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok5.
		srok6_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok6.
		srok7_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok7.
		srok8_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok8.
		srok9_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok9.
		srok10_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.srok10.
		ost_o_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.ost_o.
		ost_or_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.ost_or.
		ost_proc_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.ost_proc.
		ost_rasrez_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.ost_rasrez.
		ost_p-r_o = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.ost_p-r.
		ost_n_proc = ACCUM TOTAL BY tmp_virtp.val tmp_virtp.ost_n_proc.
		if tmp_virtp.val eq "" then do:
        		srok1_or = srok1_or + srok1_o.
        		srok2_or = srok2_or + srok2_o.
        		srok3_or = srok3_or + srok3_o.
        		srok4_or = srok4_or + srok4_o.
        		srok5_or = srok5_or + srok5_o.
        		srok6_or = srok6_or + srok6_o.
        		srok7_or = srok7_or + srok7_o.
        		srok8_or = srok8_or + srok8_o.
        		srok9_or = srok9_or + srok9_o.
        		srok10_or = srok10_or + srok10_o.
        		ost_o_or = ost_o_or + ost_o_o.
        		ost_proc_or = ost_proc_or + ost_proc_o.
        		ost_rasrez_or = ost_rasrez_or + ost_rasrez_o.
        		ost_p-r_or = ost_p-r_or + ost_p-r_o.
        		ost_n_procr = ost_n_procr + ost_n_proc.
		end.
		if LENGTH(cXL[j]) > 30000 then j = j + 1.
               	cXL[j] = cXL[j] + XLRowInFormat(45,"s80") + XLEmptyCell() + XLCell("ИТОГО по " + (if tmp_virtp.val eq "" then "810" else tmp_virtp.val) + " по " + string(tmp_virtp.kk) + " категории качества") 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLNumECellInFormat(ost_o_o,"s69") 
        			+ XLNumECellInFormat(ost_proc_o,"s69")
        			+ XLNumECellInFormat(ost_n_proc,"s69")
        			+ XLNumECellInFormat(ost_rasrez_o,"s69")
        			+ XLNumECellInFormat(ost_p-r_o,"s69")
        			+ XLNumECellInFormat(srok1_o,"s69")
        			+ XLNumECellInFormat(srok2_o,"s69")
        			+ XLNumECellInFormat(srok3_o,"s69")
        			+ XLNumECellInFormat(srok4_o,"s69")
        			+ XLNumECellInFormat(srok5_o,"s69")
        			+ XLNumECellInFormat(srok6_o,"s69")
        			+ XLNumECellInFormat(srok7_o,"s69")
        			+ XLNumECellInFormat(srok8_o,"s69")
        			+ XLNumECellInFormat(srok9_o,"s69")
        			+ XLNumECellInFormat(srok10_o,"s69")
        			+ XLRowEnd().

		if tmp_virtp.val ne "" then do:
        		/* пересчитаем в рубли по курсу последнего рабочего дня */
        		nend-date = end-date - 1.
               		do while {holiday.i nend-date} :
        			nend-date = nend-date - 1.
                        end.
        		srok1_or = srok1_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok1_o).
        		srok2_or = srok2_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok2_o).
        		srok3_or = srok3_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok3_o).
        		srok4_or = srok4_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok4_o).
        		srok5_or = srok5_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok5_o).
        		srok6_or = srok6_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok6_o).
        		srok7_or = srok7_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok7_o).
        		srok8_or = srok8_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok8_o).
        		srok9_or = srok9_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok9_o).
        		srok10_or = srok10_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok10_o).
        		ost_o_or = ost_o_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_o_o).
        		ost_proc_or = ost_proc_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_proc_o).
        		ost_rasrez_or = ost_rasrez_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_rasrez_o).
        		ost_p-r_or = ost_p-r_or + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_p-r_o).
        		ost_n_procr = ost_n_procr + CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_n_proc).
        		if LENGTH(cXL[j]) > 30000 then j = j + 1.
                       	cXL[j] = cXL[j] + XLRowInFormat(45,"s80") + XLEmptyCell() + XLCell("ИТОГО (в рублях) по " + (if tmp_virtp.val eq "" then "810" else tmp_virtp.val) + " по " + string(tmp_virtp.kk) + " категории качества") 
                			+ XLEmptyCell() 
                			+ XLEmptyCell() 
                			+ XLEmptyCell() 
                			+ XLEmptyCell() 
                			+ XLEmptyCell() 
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_o_o),"s69") 
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_proc_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_n_proc),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_rasrez_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,ost_p-r_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok1_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok2_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok3_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok4_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok5_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok6_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok7_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok8_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok9_o),"s69")
                			+ XLNumECellInFormat(CurToCurWork("Учетный",tmp_virtp.val,"",nend-date,srok10_o),"s69")
                			+ XLRowEnd().
		end.
     	end.
       	if last-of(tmp_virtp.kk) then do:
		ost_o_o = ACCUM TOTAL BY tmp_virtp.kk tmp_virtp.ost_or.
		if LENGTH(cXL[j]) > 30000 then j = j + 1.
               	cXL[j] = cXL[j] + XLRowInFormat(45,"s80") + XLEmptyCell() + XLCell("ВСЕГО в рублях по " + string(tmp_virtp.kk) + " категории качества") 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
        			+ XLNumECellInFormat(ost_o_o,"s69") 
				+ XLNumECellInFormat(ost_proc_or,"s69")
        			+ XLNumECellInFormat(ost_n_procr,"s69")
        			+ XLNumECellInFormat(ost_rasrez_or,"s69")
        			+ XLNumECellInFormat(ost_p-r_or,"s69")
        			+ XLNumECellInFormat(srok1_or,"s69")
        			+ XLNumECellInFormat(srok2_or,"s69")
        			+ XLNumECellInFormat(srok3_or,"s69")
        			+ XLNumECellInFormat(srok4_or,"s69")
        			+ XLNumECellInFormat(srok5_or,"s69")
        			+ XLNumECellInFormat(srok6_or,"s69")
        			+ XLNumECellInFormat(srok7_or,"s69")
        			+ XLNumECellInFormat(srok8_or,"s69")
        			+ XLNumECellInFormat(srok9_or,"s69")
        			+ XLNumECellInFormat(srok10_or,"s69")
         			+ XLRowEnd().
		srok1_or = 0.
		srok2_or = 0.
		srok3_or = 0.
		srok4_or = 0.
		srok5_or = 0.
		srok6_or = 0.
		srok7_or = 0.
		srok8_or = 0.
		srok9_or = 0.
		srok10_or = 0.
		ost_o_or = 0.
		ost_proc_or = 0.
		ost_rasrez_or = 0.
		ost_p-r_or = 0.
		ost_n_procr = 0.

 	end.
end.
Hide Frame Inf3 No-Pause.

oTpl:addAnchorValue("Date",end-date).
oTpl:addAnchorValue("Timer"," старт " + sstart + " финиш " + sfinish).
do j = 1 to 20:
	if cXL[j] ne "" then oTpl:addAnchorValue("TABLE" + string(j),cXL[j]).
end.

outfile = ("/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/125_credit.xls").

OUTPUT TO VALUE(outfile) /*CONVERT TARGET "UTF-8"*/.
    oTpl:show().

MESSAGE "Расчет сохранен в " SKIP outfile VIEW-AS ALERT-BOX.

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
