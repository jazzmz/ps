/*
		Ведомость начисленных процентов за период
		Бурягин Е.П.
		28.11.2005 9:14
*/

{globals.i}
{tmprecid.def}  /* Таблица с выбранными записями по вкладам */
{getdates.i}
{setdest.i}
{ulib.i}

def input param iParam as char no-undo. /* Входные параметры */
def var nozero as logical initial false no-undo. /* Подавлять нулевые строки ? */
if NUM-ENTRIES(iParam) > 0 then
do:
	if CAPS(ENTRY(1,iParam)) = "ДА" then	
		nozero = true.
end.

def var period-len as integer no-undo. /* Кол-во дней в периоде */
def var period-beg-date like op-date.op-date no-undo.			/* Первый день периода */
def var ostatok like acct-pos.balance no-undo. 	/* Текущий остаток по счету */
def var summa%% like acct-pos.balance no-undo. 	/* Проценты за период */
def var total_summa%% like acct-pos.balance no-undo. /* Всего процентов за период по одному договору*/
def var all_count as integer initial 0 no-undo. /* Кол-во обоработанных договоров */
def var all_summa_rub%% like acct-pos.balance initial 0 no-undo. /* Всего процентов за период по всем договорам */
def var all_summa_usd%% like acct-pos.balance initial 0 no-undo. /* Всего процентов за период по всем договорам */
def var all_summa_eur%% like acct-pos.balance initial 0 no-undo. /* Всего процентов за период по всем договорам */
def var stavka%% as decimal initial 0.0001 no-undo. /* Процентная ставка по вкладу ДВ */
def var basa as integer initial 365 no-undo. /* 365 дней в году */
def var todispl as char no-undo. /* Строка, в которую будем сохранять 
																		выводимую информацию по договору.
																		Используется для реализации механизма подавления вывода нулевых сумм
																		начисления процентов */
DEF VAR iDate AS DATE NO-UNDO.
def var cr as char no-undo. /* Символ перевода коретки */
cr = CHR(10).

/* Выход если нет ни одного отобранного договора */
if not can-find(first tmprecid)
then return.

def var cur_year as integer NO-UNDO.
cur_year = YEAR(end-date).
if TRUNCATE(cur_year / 4,0) = cur_year / 4 then
	basa = 366.
else
	basa = 365.

put unformatted "ВЕДОМОСТЬ РАСЧИТАННЫХ ПРОЦЕНТОВ ЗА ПЕРИОД с " beg-date " по " end-date skip(2).

/* Работаем по выбранным договорам */
for each tmprecid no-lock,
	first loan where recid(loan) eq tmprecid.id	no-lock
:
	
	/* Начальное присвоение значений переменных */
	total_summa%% = 0.
	period-beg-date = beg-date - 1.
	period-len = 0.
	summa%% = 0.
	
	/* Вывод шапки договора */
	todispl = "Договор: " + loan.cont-code + cr.
	
	find first loan-acct where
		loan-acct.cont-code = loan.cont-code
		and
		(
			loan-acct.acct-type = "loan-dps-p"
			or 
			loan-acct.acct-type = "loan-dps-t"
		)
		
		no-lock no-error.

	if avail loan-acct then do:
	
	todispl = todispl + "Cчет:    " + loan-acct.acct + cr.
	
	/* Найдем реквизиты клиента */
	if loan.cust-cat = "Ч" then
		do:
			find first person where 
				person.person-id = loan.cust-id
				no-lock no-error.
			if avail person then
				todispl = todispl + "Клиент:  " + person.name-last + " " + person.first-names + cr + cr.
			else
				todispl = todispl + "Клиент:   не определен" + cr + cr.
		end.
	
	todispl = todispl +  "   С    |   ПО   | Срок | Остаток на счете | Ставка |    Нач. %%      " + cr.
	todispl = todispl +  "-----------------------------------------------------------------------" + cr.
	
	/* Определим валюту из договора */
	if(loan.currency = "") then
	do:

	/* Найдем остаток */
	find last acct-pos where
		acct-pos.since le period-beg-date
		and
		acct-pos.acct = loan-acct.acct
		no-lock no-error.
	if avail acct-pos then
		ostatok = acct-pos.balance.
	else
		ostatok = 0.

	stavka%% = GetDpsCommission_ULL(loan.cont-code, "commission", period-beg-date, false).

	/* найдем все изменения остатков счета */
	for each acct-pos where	
		acct-pos.since ge beg-date
		and
		acct-pos.since lt end-date
		and
		acct-pos.acct = loan-acct.acct
	no-lock:
	
				/* Найден новый остаток. */
				period-len = acct-pos.since - period-beg-date.
				summa%% = ostatok / basa * stavka%% * period-len.
				total_summa%% = total_summa%% + summa%%.
			
				/*MESSAGE "1" VIEW-AS ALERT-BOX.*/
				/* Вывод таблицы начисления */
				todispl = todispl + STRING(period-beg-date + 1,"99/99/99") + "|" 
						+ STRING(acct-pos.since,"99/99/99") + "|"
						+ STRING(period-len,"ZZZZZZ") + "|"
						+ STRING(abs(ostatok),"ZZZ,ZZZ,ZZZ,ZZ9.99") + "|" 
						+ STRING(stavka%% * 100 , ">>9.99") + "% |"
						+ STRING(abs(summa%%),"ZZZ,ZZZ,ZZZ,ZZ9.99") + cr.

				ostatok = acct-pos.balance.
				period-beg-date = acct-pos.since.
	end.
	DO iDate = period-beg-date + 1 TO end-date :
		IF ostatok <> GetAcctPosValue_UAL(loan-acct.acct,loan-acct.currency,iDate,false) THEN DO:
			period-len = iDate - period-beg-date.
			summa%% = ostatok / basa * stavka%% * period-len.
			total_summa%% = total_summa%% + summa%%.
			/* Вывод таблицы начисления */
			todispl = todispl + STRING(period-beg-date + 1,"99/99/99") + "|" 
						+ STRING(iDate,"99/99/99") + "|"
						+ STRING(period-len,"ZZZZZZ") + "|"
						+ STRING(abs(ostatok),"ZZZ,ZZZ,ZZZ,ZZ9.99") + "|" 
						+ STRING(stavka%% * 100 , ">>9.99") + "% |"
						+ STRING(abs(summa%%),"ZZZ,ZZZ,ZZZ,ZZ9.99") + cr.
			ostatok = GetAcctPosValue_UAL(loan-acct.acct,loan-acct.currency,iDate,false).
			period-beg-date = iDate.
		END.
	END.
				
		/*all_summa_rub%% = all_summa_rub%% + total_summa%%.*/
	end. 
	else	/* !810 */
	do:

	/* Найдем остаток */
	find last acct-cur where
		acct-cur.since le period-beg-date
		and
		acct-cur.acct = loan-acct.acct
		no-lock no-error.
	if avail acct-cur then
		ostatok = acct-cur.balance.
	else
		ostatok = 0.

	stavka%% = GetDpsCommission_ULL(loan.cont-code, "commission", period-beg-date, false).

	/* найдем все изменения остатков счета */
	for each acct-cur where	
		acct-cur.since ge beg-date
		and
		acct-cur.since lt end-date
		and
		acct-cur.acct = loan-acct.acct
	no-lock:

				/* Найден новый остаток. */
				period-len = acct-cur.since - period-beg-date.
				summa%% = ostatok / basa * stavka%% * period-len.
				total_summa%% = total_summa%% + summa%%.
			
				/* Вывод таблицы начисления */
				/* put unformatted period-beg-date + 1 "|" acct-cur.since "|"  period-len format "ZZZZZZ" "|" abs(ostatok) format "ZZZ,ZZZ,ZZZ,ZZ9.99" "|" abs(summa%%) format "ZZZ,ZZZ,ZZZ,ZZ9.99" skip. */
				todispl = todispl + STRING(period-beg-date + 1,"99/99/99") + "|" 
						+ STRING(acct-cur.since,"99/99/99") + "|"
						+ STRING(period-len,"ZZZZZZ") + "|"
						+ STRING(abs(ostatok),"ZZZ,ZZZ,ZZZ,ZZ9.99") + "|" 
						+ STRING(stavka%% * 100 , ">>9.99") + "% |"
						+ STRING(abs(summa%%),"ZZZ,ZZZ,ZZZ,ZZ9.99") + cr.

				ostatok = acct-cur.balance.
				period-beg-date = acct-cur.since.
		end.
	DO iDate = period-beg-date + 1 TO end-date :
		IF ostatok <> GetAcctPosValue_UAL(loan-acct.acct,loan-acct.currency,iDate,false) THEN DO:
			period-len = iDate - period-beg-date.
			summa%% = ostatok / basa * stavka%% * period-len.
			total_summa%% = total_summa%% + summa%%.
			/* Вывод таблицы начисления */
			todispl = todispl + STRING(period-beg-date + 1,"99/99/99") + "|" 
						+ STRING(iDate,"99/99/99") + "|"
						+ STRING(period-len,"ZZZZZZ") + "|"
						+ STRING(abs(ostatok),"ZZZ,ZZZ,ZZZ,ZZ9.99") + "|" 
						+ STRING(stavka%% * 100 , ">>9.99") + "% |"
						+ STRING(abs(summa%%),"ZZZ,ZZZ,ZZZ,ZZ9.99") + cr.
			ostatok = GetAcctPosValue_UAL(loan-acct.acct,loan-acct.currency,iDate,false).
			period-beg-date = iDate.
		END.
	END.
		
		/*IF loan.currency = "840" THEN
			all_summa_usd%% = all_summa_usd%% + total_summa%%.
		IF loan.currency = "978" THEN
			all_summa_eur%% = all_summa_eur%% + total_summa%%.
		*/
	end. /* !810 */
	
	period-len = end-date - period-beg-date.
	summa%% = ostatok / basa * stavka%% * period-len.
	total_summa%% = total_summa%% + summa%%.
	/* Вывод таблицы начисления */
	/* put unformatted period-beg-date + 1 "|" end-date "|" period-len format "ZZZZZZ" "|" abs(ostatok) format "ZZZ,ZZZ,ZZZ,ZZ9.99" "|" abs(summa%%) format "ZZZ,ZZZ,ZZZ,ZZ9.99" skip.*/
	todispl = todispl + STRING(period-beg-date + 1,"99/99/99") + "|" 
						+ STRING(end-date,"99/99/99") + "|"
						+ STRING(period-len,"ZZZZZZ") + "|"
						+ STRING(abs(ostatok),"ZZZ,ZZZ,ZZZ,ZZ9.99") + "|" 
						+ STRING(stavka%% * 100 , ">>9.99") + "% |"
						+ STRING(abs(summa%%),"ZZZ,ZZZ,ZZZ,ZZ9.99") + cr
						+ "-----------------------------------------------------------------------" + cr
						+ "                                                     " + STRING(abs(total_summa%%),"ZZZ,ZZZ,ZZZ,ZZ9.99") + cr + cr + cr.
	IF loan.currency = "" THEN
		all_summa_rub%% = all_summa_rub%% + total_summa%%.
	IF loan.currency = "840" THEN
		all_summa_usd%% = all_summa_usd%% + total_summa%%.
	IF loan.currency = "978" THEN
		all_summa_eur%% = all_summa_eur%% + total_summa%%.
		
	if (total_summa%% <> 0) OR NOT nozero then
	do:
		put unformatted todispl skip.
		all_count = all_count + 1.
	end.
	end. /* if avail loan-acct */
end.

put unformatted "Всего договоров: " all_count format "ZZZZZZ" skip	
	              "Сумма процентов " skip
	              " по рублевым договорам      : " abs(all_summa_rub%%) format "ZZZ,ZZZ,ZZZ,ZZ9.99" skip
	              " по договорам в долларах США: " abs(all_summa_usd%%) format "ZZZ,ZZZ,ZZZ,ZZ9.99" skip
	              " по договорам в ЕВРО        : " abs(all_summa_eur%%) format "ZZZ,ZZZ,ZZZ,ZZ9.99" skip.
	              

{preview.i}