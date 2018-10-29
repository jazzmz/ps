/* Комментарий добра
По задаче #4173 заменяем 1 из транзакций по клирингу p-шкой,
т.к. изменился формат файла initf 
ООО ПИР Банк 
27.11.2013 Гончаров А.Е. */

define input parameter filename as character no-undo.
define output parameter cOut as character no-undo.
define variable cLim as character init "," no-undo.

define variable istr as character init "" no-undo.
define variable tmpstr as character init "" no-undo.

define variable rep_cur as character no-undo.
define variable tr_id as character no-undo.
define variable sum1 as decimal no-undo.
define variable sum2 as decimal no-undo.

define variable atm as character no-undo.
define variable dir_tr as character no-undo.
define variable tr_commission as character no-undo.

define variable RURATM01266TRAM as decimal init 0 no-undo.
define variable RURATM01266TRFEE as decimal init 0 no-undo.
define variable RURATM01266MPAM as decimal init 0 no-undo.
define variable RURATM01266MPFEE as decimal init 0 no-undo.
define variable USDUSDATM01266TRAM as decimal init 0 no-undo.
define variable USDUSDATM01266STAM as decimal init 0 no-undo.
define variable USDRURATM01266TRAM as decimal init 0 no-undo.
define variable USDRURATM01266STAM as decimal init 0 no-undo.
define variable USDRURATM01266MPTRAM as decimal init 0 no-undo.
define variable USDRURATM01266MPSTAM as decimal init 0 no-undo.
define variable EURATM01266TRAM as decimal init 0 no-undo.
define variable EURATM01266STAM as decimal init 0 no-undo.
define variable RURATM01279TRAM as decimal init 0 no-undo.
define variable RURATM01279TRFEE as decimal init 0 no-undo.
define variable RURATM01279MPAM as decimal init 0 no-undo.
define variable RURATM01279MPFEE as decimal init 0 no-undo.
define variable USDUSDATM01279TRAM as decimal init 0 no-undo.
define variable USDUSDATM01279STAM as decimal init 0 no-undo.
define variable USDRURATM01279TRAM as decimal init 0 no-undo.
define variable USDRURATM01279STAM as decimal init 0 no-undo.
define variable USDRURATM01279MPTRAM as decimal init 0 no-undo.
define variable USDRURATM01279MPSTAM as decimal init 0 no-undo.
define variable EURATM01279TRAM as decimal init 0 no-undo.
define variable EURATM01279STAM as decimal init 0 no-undo.
define variable RURATM01280TRAM as decimal init 0 no-undo.
define variable RURATM01280TRFEE as decimal init 0 no-undo.
define variable RURATM01280MPAM as decimal init 0 no-undo.
define variable RURATM01280MPFEE as decimal init 0 no-undo.
define variable USDUSDATM01280TRAM as decimal init 0 no-undo.
define variable USDUSDATM01280STAM as decimal init 0 no-undo.
define variable USDRURATM01280TRAM as decimal init 0 no-undo.
define variable USDRURATM01280STAM as decimal init 0 no-undo.
define variable USDRURATM01280MPTRAM as decimal init 0 no-undo.
define variable USDRURATM01280MPSTAM as decimal init 0 no-undo.
define variable EURATM01280TRAM as decimal init 0 no-undo.
define variable EURATM01280STAM as decimal init 0 no-undo.

define temp-table tt1 no-undo
	field rep_cur as character
	field tr_id as character
	field sum1 as decimal
	field sum2 as decimal
	field ztr as decimal
	field commission as decimal
	field atm as character.

empty temp-table tt1.

input from value(filename).
repeat:
	import unformatted istr.
	tmpstr = substring(istr,147,3).
	if rep_cur eq "" then do:
		if tmpstr eq "USD" or tmpstr eq "EUR" or tmpstr eq "RUR" or tmpstr eq "RUB" then do:
			if tmpstr eq "RUB" then tmpstr = "RUR". /*В процессинге работают дебилы */
			rep_cur = tmpstr. /*rep_cur*/
		end.
	end.

	if tr_id eq "" then do:
		if substring(istr,103,3) eq "901" then do: /*если в 103-й позиции 901, берём данные о суммах из этой строки */
			tmpstr = substring(istr,103,15).
			if tmpstr begins ("901") then do: 
				tr_id = tmpstr.
				if tr_id eq "901 2501 00  000" then tr_id = "901       00  00".    /*tr_id*/
			end.
			sum1 = dec(trim(substring(istr,121,10))).
			sum2 = dec(trim(substring(istr,139,10))). 
		end.
	end.

	if atm eq "" then do:
		if substring(istr,39,6) eq "CA ID:" then do:
			atm = trim(substring(istr,46,9)). /*Номер банкомата*/
		end.
	end.

	if (tr_commission eq "") and (substring (istr,102,5) eq "LEVEL") then do:
		tmpstr = substring(istr,149,2). /* cr,dr */
		if (tmpstr eq "CR") or (tmpstr eq "DR") then do:
			dir_tr = tmpstr.
			tr_commission = substring(istr,139,10).
		end.
	end.

	if rep_cur ne "" and tr_id ne "" and atm ne "" and dir_tr ne "" then do:
               	create tt1.
		assign
			tt1.rep_cur  = rep_cur
			tt1.tr_id = tr_id
			tt1.sum1 = sum1
			tt1.sum2 = sum2
			tt1.commission = dec(tr_commission)
			tt1.ztr = (if dir_tr eq "CR" then 1 else -1)
			tt1.atm = atm.
		tr_id = "".
		sum1 = 0.
		sum2 = 0.
		atm = "".
		tr_commission = "".
		dir_tr = "".
	end.
	if substring (istr,30,9) eq "AFFILIATE" then do:
		rep_cur = "".
		tr_id = "".
		sum1 = 0.
		sum2 = 0.
		tr_commission = "".
		atm = "".
		dir_tr = "".
	end.
end.
input close.

for each tt1:

	/* Обычные операции */
	if tt1.rep_cur eq "RUR" and tt1.tr_id eq "901      00  00" then do:
		if tt1.atm eq "ATM01266" then RURATM01266TRAM = (RURATM01266TRAM + tt1.sum1) * tt1.ztr.
		if tt1.atm eq "ATM01279" then RURATM01279TRAM = (RURATM01279TRAM + tt1.sum1) * tt1.ztr.
		if tt1.atm eq "ATM01280" then RURATM01280TRAM = (RURATM01280TRAM + tt1.sum1) * tt1.ztr.
	end.
	/* Мобильные платежи в рублях */
	if tt1.rep_cur eq "RUR" and tt1.tr_id eq "901      02  00" then do:
		if tt1.atm eq "ATM01266" then RURATM01266MPAM = (RURATM01266MPAM + tt1.sum1)/* * tt1.ztr*/.
		if tt1.atm eq "ATM01279" then RURATM01279MPAM = (RURATM01279MPAM + tt1.sum1)/* * tt1.ztr*/.
		if tt1.atm eq "ATM01280" then RURATM01280MPAM = (RURATM01280MPAM + tt1.sum1)/* * tt1.ztr*/.
	end.

	/* Комиссии по обычным операциям */
	if tt1.rep_cur eq "RUR" and tt1.tr_id ne "901      02  00"  then do:
		if tt1.atm eq "ATM01266" then RURATM01266TRFEE = (RURATM01266TRFEE + tt1.commission) * tt1.ztr.
		if tt1.atm eq "ATM01279" then RURATM01279TRFEE = (RURATM01279TRFEE + tt1.commission) * tt1.ztr.
		if tt1.atm eq "ATM01280" then RURATM01280TRFEE = (RURATM01280TRFEE + tt1.commission) * tt1.ztr.
	end.

	/* Комиссии по мобильным платежам */
	if tt1.rep_cur eq "RUR" and tt1.tr_id eq "901      02  00" then do:
		if tt1.atm eq "ATM01266" then RURATM01266MPFEE = (RURATM01266MPFEE + (tt1.commission))/* * tt1.ztr*/.
		if tt1.atm eq "ATM01279" then RURATM01279MPFEE = (RURATM01279MPFEE + (tt1.commission))/* * tt1.ztr*/.
		if tt1.atm eq "ATM01280" then RURATM01280MPFEE = (RURATM01280MPFEE + (tt1.commission))/* * tt1.ztr*/.

	end.

        /* Если расчеты в банкомате производились в ин. валютах */
	if tt1.rep_cur ne "RUR" and tt1.tr_id eq "901      00  00" then do:
		if tt1.rep_cur eq "USD" then do:
			if tt1.atm eq "ATM01266" then USDRURATM01266TRAM = (USDRURATM01266TRAM + tt1.sum1) * tt1.ztr.
			if tt1.atm eq "ATM01266" then USDRURATM01266STAM = (USDRURATM01266STAM + tt1.sum2) * tt1.ztr.
        		if tt1.atm eq "ATM01279" then USDRURATM01279TRAM = (USDRURATM01279TRAM + tt1.sum1) * tt1.ztr.
			if tt1.atm eq "ATM01279" then USDRURATM01279STAM = (USDRURATM01279STAM + tt1.sum2) * tt1.ztr.
			if tt1.atm eq "ATM01280" then USDRURATM01280TRAM = (USDRURATM01280TRAM + tt1.sum1) * tt1.ztr.
			if tt1.atm eq "ATM01280" then USDRURATM01280STAM = (USDRURATM01280STAM + tt1.sum2) * tt1.ztr.
		end.
		else do:
			if tt1.atm eq "ATM01266" then EURATM01266TRAM = (EURATM01266TRAM + tt1.sum1) * tt1.ztr.
			if tt1.atm eq "ATM01266" then EURATM01266STAM = (EURATM01266STAM + tt1.sum2) * tt1.ztr.
        		if tt1.atm eq "ATM01279" then EURATM01279TRAM = (EURATM01279TRAM + tt1.sum1) * tt1.ztr.
			if tt1.atm eq "ATM01279" then EURATM01279STAM = (EURATM01279STAM + tt1.sum2) * tt1.ztr.
			if tt1.atm eq "ATM01280" then EURATM01280TRAM = (EURATM01280TRAM + tt1.sum1) * tt1.ztr.
			if tt1.atm eq "ATM01280" then EURATM01280STAM = (EURATM01280STAM + tt1.sum2) * tt1.ztr.
		end.
	end.

	/* Долларовые мобильные платежи */
	if tt1.rep_cur eq "USD" and tt1.tr_id eq "901      02  00" then do:	
		if tt1.atm eq "ATM01266" then USDRURATM01266MPTRAM = (USDRURATM01266MPTRAM + tt1.sum1) /* * tt1.ztr */.
		if tt1.atm eq "ATM01266" then USDRURATM01266MPSTAM = (USDRURATM01266MPSTAM + tt1.sum2) /* * tt1.ztr  */.
		if tt1.atm eq "ATM01279" then USDRURATM01279MPTRAM = (USDRURATM01279MPTRAM + tt1.sum1) /* * tt1.ztr  */.
		if tt1.atm eq "ATM01279" then USDRURATM01279MPSTAM = (USDRURATM01279MPSTAM + tt1.sum2) /* * tt1.ztr  */.
		if tt1.atm eq "ATM01280" then USDRURATM01280MPTRAM = (USDRURATM01280MPTRAM + tt1.sum1) /* * tt1.ztr */.
		if tt1.atm eq "ATM01280" then USDRURATM01280MPSTAM = (USDRURATM01280MPSTAM + tt1.sum2) /* * tt1.ztr  */.
	end.

end.

cOut = 	string (RURATM01266TRAM) + cLim +
	string (RURATM01266TRFEE) + cLim +
	string (RURATM01266MPAM) + cLim +
	string (RURATM01266MPFEE) + cLim +
	string (USDUSDATM01266TRAM) + cLim +
	string (USDUSDATM01266STAM) + cLim +
	string (USDRURATM01266TRAM) + cLim +
	string (USDRURATM01266STAM) + cLim +
	string (USDRURATM01266MPTRAM) + cLim +
	string (USDRURATM01266MPSTAM) + cLim +
	string (EURATM01266TRAM) + cLim + 
	string (EURATM01266STAM) + cLim + 
	string (RURATM01279TRAM) + cLim +
	string (RURATM01279TRFEE) + cLim +
	string (RURATM01279MPAM) + cLim +
	string (RURATM01279MPFEE) + cLim +
	string (USDUSDATM01279TRAM) + cLim +
	string (USDUSDATM01279STAM) + cLim +
	string (USDRURATM01279TRAM) + cLim +
	string (USDRURATM01279STAM) + cLim +
	string (USDRURATM01279MPTRAM) + cLim +
	string (USDRURATM01279MPSTAM) + cLim +
	string (EURATM01279TRAM) + cLim + 
	string (EURATM01279STAM) + cLim + 
	string (RURATM01280TRAM) + cLim +
	string (RURATM01280TRFEE) + cLim +
	string (RURATM01280MPAM) + cLim +
	string (RURATM01280MPFEE) + cLim +
	string (USDUSDATM01280TRAM) + cLim + 
	string (USDUSDATM01280STAM) + cLim +
	string (USDRURATM01280TRAM) + cLim +
	string (USDRURATM01280STAM) + cLim +
	string (USDRURATM01280MPTRAM) + cLim +
	string (USDRURATM01280MPSTAM) + cLim +
	string (EURATM01280TRAM) + cLim +
	string (EURATM01280STAM).
