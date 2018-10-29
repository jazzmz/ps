{globals.i}
{tmprecid.def}
{ulib.i}   

DEF VAR oTable  AS TTable    	NO-UNDO.
DEF VAR oTpl 	AS TTpl 	NO-UNDO.
DEF VAR client_name AS CHAR INIT ""  NO-UNDO.
DEF VAR loaninf AS CHAR 	NO-UNDO.
DEF VAR tmpStr 	AS CHAR EXTENT 5 NO-UNDO.
DEF VAR summapr	AS CHAR 	NO-UNDO.
Def Var Month_Name As Char Initial
   "январь,февраль,март,апрель,май,июнь,июль,август,сентябрь,октябрь,ноябрь,декабрь" NO-UNDO.
   
oTable = new TTable(2).
oTpl = new TTpl("pirloan3192.tpl").

FOR EACH tmprecid,
    FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK,
    FIRST op-entry OF op NO-LOCK:
	if can-do("61301*",op-entry.acct-db) then do:
		FIND LAST loan-acct WHERE loan-acct.acct = op-entry.acct-db AND loan-acct.contract EQ "Кредит" NO-LOCK NO-ERROR.
		if avail(loan-acct) then do:
			FIND LAST loan WHERE loan.contract  = loan-acct.contract 
	        			AND loan.cont-code = loan-acct.cont-code
					NO-LOCK NO-ERROR.   
			IF AVAIL loan THEN DO:
                                oTable:addRow().
				oTable:addCell("Сумма").
				RUN x-amtstr.p(op-entry.amt-rub, "", true, true, output tmpStr[1], output tmpStr[2]).
                                summapr = tmpStr[1] + ' ' + tmpStr[2].
				oTable:addCell(string(op-entry.amt-rub,">>>,>>>,>>>,>>9.99") + " (" + summapr + ")").
                                oTable:addRow().
				oTable:addCell("На счет").
				oTable:addCell(op-entry.acct-cr).
				client_name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
                                oTable:addRow().
				oTable:addCell("Заемщик").
				oTable:addCell(client_name).
                                oTable:addRow().
				oTable:addCell("Корреспондентский счет №").
				oTable:addCell(op-entry.acct-db).
				loaninf = getMainLoanAttr("Кредит",loan.cont-code,"%cont-code от %ДатаСогл").
                                oTable:addRow().
				oTable:addCell("Кредитный договор").
				oTable:addCell(loaninf).
                                oTable:addRow().
				oTable:addCell("Валюта").
				oTable:addCell(if op-entry.currency eq "" then "810" else op-entry.currency).
                                oTable:addRow().
				oTable:addCell("Вид операции").
				oTable:addCell("Зачисление денежных средств на доходы в счет оплаты 
процентов за " + entry(MONTH(op-entry.op-date), Month_Name) + " " + string(YEAR(op-entry.op-date)) + " года учтенных ранее 
на счете доходов будущих периодов").
			end.
			else do:
				message "не нашел счет " + op-entry.acct-db + " в договоре loan" view-as alert-box.
				return.
			end.
		end.
		else do:
			message "не нашел счет " + op-entry.acct-db + " в договоре loan-acct" view-as alert-box.
			return.
		end.
	end.
	else do:
		message "Выбран не тот документ. Документ по данному распоряжению должен в Дебете иметь 61301*" view-as alert-box.
		return.
	end.

END.

oTpl:addAnchorValue("Date",op-entry.op-date).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
    oTpl:show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.
