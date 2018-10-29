/*
Наращенные процентные доходы, ожидаемые к погашению, по ПК кредитам I и II (за вычетом расчетного резерва) категории качества .
#3440
Никитина Ю.А.
22.07.2013
*/
{globals.i}
{intrface.get i254}
{intrface.get instrum}  /* функции работы с финансовыми инструментами */
{intrface.get comm}
{intrface.get loan}
{getdate.i}
{sh-defs.i}
{pir_exf_exl.i}

DEF VAR oTable  AS TTable2    	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR oClient AS TClient    	NO-UNDO.

def var PrRisk  as DEC	 	NO-UNDO.
def var summ-t  as DEC	 	NO-UNDO.
def var GrRisk  as int	 	NO-UNDO.
DEF VAR ac_r 	AS char	 	NO-UNDO.
DEF VAR ost_o 	AS dec	init 0 	NO-UNDO.
DEF VAR vost_o 	AS dec	init 0 	NO-UNDO.
DEF VAR ost_r 	AS dec	 	NO-UNDO.
DEF VAR proc 	AS dec	 	NO-UNDO.
DEF VAR sfinish as char 	NO-UNDO.
DEF VAR sstart 	as char 	NO-UNDO.
DEF VAR tstart 	as int64 	NO-UNDO.
DEF VAR i 		as dec   init 0	NO-UNDO.
DEF VAR j 		as int   init 0	NO-UNDO.
DEF VAR srok1_o		as dec   init 0	NO-UNDO.
DEF VAR srok2_o		as dec   init 0	NO-UNDO.
DEF VAR srok3_o		as dec   init 0	NO-UNDO.
DEF VAR srok4_o		as dec   init 0	NO-UNDO.
DEF VAR srok5_o		as dec   init 0	NO-UNDO.
DEF VAR srok6_o		as dec   init 0	NO-UNDO.
DEF VAR srok7_o		as dec   init 0	NO-UNDO.
DEF VAR srok8_o		as dec   init 0	NO-UNDO.
DEF VAR srok9_o		as dec   init 0	NO-UNDO.
DEF VAR srok10_o	as dec   init 0	NO-UNDO.
DEF VAR ost_o_o		as dec   init 0	NO-UNDO.
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
DEF VAR rate_pr		as dec   init 0	NO-UNDO.
DEF VAR nend-date	as date	NO-UNDO.
DEF VAR period 		as dec   init 0	NO-UNDO.
DEF VAR POS 	as char 	NO-UNDO.
DEF VAR outfile as char 	NO-UNDO.
DEF VAR	cXL     as char EXTENT 20 	NO-UNDO.

DEF BUFFER loan-acct_o FOR loan-acct.
DEF BUFFER loan-acct_r FOR loan-acct.
DEF BUFFER loan-var_o FOR loan-var.

oTable = new TTable2(24).
oTpl = new TTpl("pirvircreditpk.tpl").

DEF temp-table tmp_virtp NO-UNDO
    FIELD name as char 
    FIELD cont-code as char 
    FIELD val as char 
    FIELD acct_o as char 
    FIELD acct_r as char 
    FIELD ost_o as dec 
    FIELD ost_or as dec 
    FIELD ost_n_proc as dec 
    FIELD ost_proc as dec 
    FIELD ost_rasrez as dec 
    FIELD ost_p-r as dec 
    FIELD kk as dec 
    FIELD prrisk as dec 
    FIELD kolday as dec 
    FIELD endd as date 
    FIELD srok1 as dec 
    FIELD srok2 as dec 
    FIELD srok3 as dec 
    FIELD srok4 as dec 
    FIELD srok5 as dec 
    FIELD srok6 as dec 
    FIELD srok7 as dec 
    FIELD srok8 as dec 
    FIELD srok9 as dec 
    FIELD srok10 as dec 
.
/* посчитаем время работы */
sstart = string(Time,"HH:MM:SS").
tstart = Time.
i = 0.

oTable:AddRow().
oTable:AddCell("№ п/п").
oTable:AddCell("Кредит. договор №; Транш №").
oTable:AddCell("Вал.").
oTable:AddCell("Наименование заемщика").
oTable:AddCell("Ссудный счет").
oTable:AddCell("Категория качества").
oTable:AddCell("Процент резервирования").
oTable:AddCell("Сумма задолженности по основному доглу в вал. кредита").
oTable:AddCell("Сумма задолженности %% в вал. кредита").
oTable:AddCell("в том числе Сумма начисленных процентов в вал. кредита").
oTable:AddCell("Резерв расчетный по %% в вал. кредита").
oTable:AddCell("Сумма задолженности %% за минусом резерва в вал. кредита").
oTable:AddCell("Дата погашения траншей").
oTable:AddCell("Кол-во дней от отчетной даты до даты погашения траншей").
oTable:AddCell("До востреб и на 1 день").
oTable:AddCell("до 5 дней").
oTable:AddCell("до 10 дней").
oTable:AddCell("до 20 дней").
oTable:AddCell("до 30 дней").
oTable:AddCell("до 90 дней").
oTable:AddCell("до 180 дней").
oTable:AddCell("до 270 дней").
oTable:AddCell("до 1 года").
oTable:AddCell("свыше 1 года").
oTable:AddRow().
oTable:AddCell("1").
oTable:AddCell("2").
oTable:AddCell("3").
oTable:AddCell("4").
oTable:AddCell("5").
oTable:AddCell("6").
oTable:AddCell("7").
oTable:AddCell("8").
oTable:AddCell("9").
oTable:AddCell("10").
oTable:AddCell("11").
oTable:AddCell("12").
oTable:AddCell("13").
oTable:AddCell("14").
oTable:AddCell("15").
oTable:AddCell("16").
oTable:AddCell("17").
oTable:AddCell("18").
oTable:AddCell("19").
oTable:AddCell("20").
oTable:AddCell("21").
oTable:AddCell("22").
oTable:AddCell("23").
oTable:AddCell("24").
/*06/13,76/12,60/12,63/12,01/13,105/11,56/12,КЛ-71/12*,КЛ-12/13*,70/12,18/13,КЛ-27/13*,81/11*/
for each loan  where loan.contract eq "Кредит"
		and can-do("ПК* *",loan.cont-code)
                and (loan.close-date GE end-date or loan.close-date eq ?)
		and loan.open-date LT end-date 
		no-lock:
        /* Смотрим дату пересчета договора. И говорим пользователю, если договор не пересчитать на один день вперед, чтобы появились нужные параметры учета процентов */
        if loan.since < end-date and loan.close-date eq ? then do:
		message "Пересчитайте договор " loan.cont-code " на дату " (end-date) "." VIEW-AS ALERT-BOX.
                RETURN.
	end.

  	PrRisk = LnRsrvRate(loan.contract, loan.cont-code, end-date - 1). /* коэф. резервирования */
	GrRisk = LnGetGrRiska(PrRisk, end-date - 1).                      /* категория качества */
	/* в ПОСе */
	POS = LnInBagOnDate(loan.contract,loan.cont-code,end-date - 1).
	/* если в Посе, то КК будет другая*/	
	if POS ne ? then GrRisk = PsGetGrRiska(PrRisk,loan.cust-cat,end-date - 1) .

	if GrRisk = 1 or GrRisk = 2 then do:
		ost_o = 0.
		ost_r = 0.
               	create tmp_virtp.
        	tmp_virtp.cont-code = loan.cont-code.
        	tmp_virtp.val = loan.currency.
        	tmp_virtp.prrisk = PrRisk.
        	tmp_virtp.kk = GrRisk.
        	oClient = NEW TClient(loan.cust-cat,loan.cust-id).
        	tmp_virtp.name = oClient:name-short.
		tmp_virtp.kolday = loan.end-date - end-date + 1.
		tmp_virtp.endd = loan.end-date.
	        DELETE OBJECT oClient.
   		tmp_virtp.acct_o = "".
		ost_o = 0.
		tmp_virtp.ost_o = 0.
		tmp_virtp.ost_or = 0.
		rate_pr = 0.
		/* Возвращает сумму выданного кредита в валюте кредита из pp-i254.p*/
		/* ost_o = LnGetExtraditionSum(loan.contract, loan.cont-code, end-date). */
		/* нашли процентную ставку */ 
		rate_pr = GET_COMM("%Кред",?,loan.currency,loan.contract + "," + loan.cont-code,0,0,end-date - 1).
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
					and ((loan-int.id-d = 5) and (loan-int.id-k = 35)) /* ОПЕРАЦИЯ 46. оплата начисленных процентов */	
					NO-LOCK :
			tmp_virtp.ost_proc = tmp_virtp.ost_proc - loan-int.amt-rub.
			tmp_virtp.ost_n_proc = tmp_virtp.ost_n_proc - loan-int.amt-rub.
		end.
		/* посчитаем проценты вручную, т.к. графики платежей ооооочень кривые.*/
		if tmp_virtp.kolday >= 0 then do:
        		/* определяем счет основго долга.  */
        		find last loan-acct_o where loan-acct_o.contract EQ loan.contract
        	                       	AND loan-acct_o.cont-code EQ loan.cont-code
        				AND loan-acct_o.acct-type eq  "Кредит"
        				AND loan-acct_o.since LE end-date 
        				no-lock no-error.
        		if avail loan-acct_o then do:
        			tmp_virtp.acct_o = loan-acct_o.acct.
        		end.
        		/* найдем остаток по договору*/
        		find last loan-var OF loan WHERE
        				loan-var.amt-id = 0
        				AND loan-var.since < end-date
        				NO-LOCK no-error.
			if avail loan-var then ost_o = loan-var.balance.
        		/* посчитаем рублевый эквивалент остатка */
        		tmp_virtp.ost_o = ost_o.
                        tmp_virtp.ost_or = ost_o.
        		if loan.currency ne "" then do:
                		/* пересчитаем в рубли по курсу последнего рабочего дня */
                		nend-date = end-date - 1.
                       		do while {holiday.i nend-date} :
                			nend-date = nend-date - 1.
                                end.
        			tmp_virtp.ost_or = CurToCurWork("Учетный",loan.currency,"",nend-date,ost_o). 
        		end.
	        	period = loan.end-date - end-date + 1.
			/* считаем проценты */
			summ-t = round(ost_o * rate_pr / 100 / 365 * period,2).
			/* сколько всего процентов */
			tmp_virtp.ost_proc = tmp_virtp.ost_proc + summ-t.
			/* расчетный резерв */
                        tmp_virtp.ost_rasrez = round(tmp_virtp.ost_rasrez + tmp_virtp.ost_proc * PrRisk / 100,2).
			/*проценты за минусом расчетного резерва*/
			proc = round(tmp_virtp.ost_proc - tmp_virtp.ost_proc * PrRisk / 100,2).
			tmp_virtp.ost_p-r = tmp_virtp.ost_p-r + proc.
			/*if loan.currency <> "" then proc = CurToCurWork("Учетный",loan.currency,"",nend-date,proc). */

        		if period le 1 then tmp_virtp.srok1 = tmp_virtp.srok1 + proc.
        		if period gt 1 and period le 5 then tmp_virtp.srok2 = tmp_virtp.srok2 + proc.
        		if period gt 5 and period le 10 then tmp_virtp.srok3 = tmp_virtp.srok3 + proc.
        		if period gt 10 and period le 20 then tmp_virtp.srok4 = tmp_virtp.srok4 + proc.
        		if period gt 20 and period le 30 then tmp_virtp.srok5 = tmp_virtp.srok5 + proc.
        		if period gt 30 and period le 90 then tmp_virtp.srok6 = tmp_virtp.srok6 + proc.
        		if period gt 90 and period le 180 then tmp_virtp.srok7 = tmp_virtp.srok7 + proc.
        		if period gt 180 and period le 270 then tmp_virtp.srok8 = tmp_virtp.srok8 + proc.
        		if period gt 270 and period le 365 then tmp_virtp.srok9 = tmp_virtp.srok9 + proc.
        		if period gt 365 then tmp_virtp.srok10 = tmp_virtp.srok10 + proc.
		end.
		/* если договор на просрочке, то посмотрим сколько процентов было вынесено на просрочку и запишем их на ДВ */
		else do:
        		/* определяем счет основго долга.  */
        		find last loan-acct_o where loan-acct_o.contract EQ loan.contract
        	                       	AND loan-acct_o.cont-code EQ loan.cont-code
        				AND loan-acct_o.acct-type eq  "КредПр"
        				AND loan-acct_o.since LE end-date 
        				no-lock no-error.
        		if avail loan-acct_o then do:
        			tmp_virtp.acct_o = loan-acct_o.acct.
        		end.
                        FIND LAST loan-var OF loan WHERE
					loan-var.amt-id = 7
					AND loan-var.since < end-date
					NO-LOCK NO-ERROR. 
			if avail loan-var then do:
			        /* просроченных процентов */
                                ost_o = loan-var.balance.
                                tmp_virtp.ost_o = ost_o. 
                                tmp_virtp.ost_or = ost_o.
                		if loan.currency ne "" then do:
                        		/* пересчитаем в рубли по курсу последнего рабочего дня */
                        		nend-date = end-date - 1.
                               		do while {holiday.i nend-date} :
                        			nend-date = nend-date - 1.
                                        end.
                			tmp_virtp.ost_or = CurToCurWork("Учетный",loan.currency,"",nend-date,ost_o). 
                		end.

				/* Нашли процентную ставку по ссуде */
				/* rate_pr = GET_COMM("%КрПр",?,loan.currency,loan.contract + "," + loan.cont-code,0,0,end-date). */
			end.
                        FIND LAST loan-var OF loan WHERE
					loan-var.amt-id = 10
					AND loan-var.since < end-date
					NO-LOCK NO-ERROR. 
			if avail loan-var then do:
			        /* просроченных процентов */
                                tmp_virtp.ost_proc = loan-var.balance. 
				/* Нашли процентную ставку по ссуде */
				/* rate_pr = GET_COMM("%КрПр",?,loan.currency,loan.contract + "," + loan.cont-code,0,0,end-date). */
			end.
			else tmp_virtp.ost_proc = 0.
       			/* расчетный резерв */
                        tmp_virtp.ost_rasrez = round(tmp_virtp.ost_proc * PrRisk / 100,2).
       			/*проценты за минусом расчетного резерва*/
       			proc = tmp_virtp.ost_proc - tmp_virtp.ost_rasrez.
       			tmp_virtp.ost_p-r = proc.
 			tmp_virtp.srok1 = proc.
			tmp_virtp.kolday = 0.
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
        		+ XLCell(string(tmp_virtp.endd,"99.99.9999"))
        		+ XLNumCell(tmp_virtp.kolday)
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
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
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
                			+ XLEmptyCell() 
                			+ XLEmptyCell() 
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
        			+ XLEmptyCell() 
        			+ XLEmptyCell() 
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
/*oTpl:addAnchorValue("TABLE1",oTable).*/
do j = 1 to 20:
	if cXL[j] ne "" then oTpl:addAnchorValue("TABLE" + string(j),cXL[j]).
end.

/*{setdest.i}*/
outfile = ("/home2/bis/quit41d/imp-exp/users/" + LC(UserID("bisquit")) + "/125_pk.xls").
/*outfile = ("./125_pk.xls").*/
OUTPUT TO VALUE(outfile) /*CONVERT TARGET "UTF-8"*/.
    oTpl:show().
/*{preview.i}*/

MESSAGE "Расчет сохранен в " SKIP outfile VIEW-AS ALERT-BOX.

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
