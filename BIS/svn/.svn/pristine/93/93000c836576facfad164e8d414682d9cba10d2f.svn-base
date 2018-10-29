{globals.i}
{getdate.i}

DEF VAR oTpl AS TTpl NO-UNDO.
def var oTable AS TTable NO-UNDO.

Def Var Month_Name As Char Initial
  "январь,февраль,март,апрель,май,июнь,июль,август,сентябрь,октябрь,ноябрь,декабрь" No-UnDo.

DEFINE VARIABLE mW AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE mW2 AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE mS AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.99" NO-UNDO. 
DEFINE VARIABLE mCur AS CHARACTER FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE PokPr AS CHARACTER FORMAT "x(20)" INITIAL "Покупка" NO-UNDO .
DEFINE VARIABLE Sr1 AS decimal NO-UNDO .
DEFINE VARIABLE Sr2 AS decimal NO-UNDO .
DEFINE VARIABLE Sr3 AS decimal NO-UNDO .
DEFINE VARIABLE KursCB1 AS decimal NO-UNDO .
DEFINE VARIABLE KursCB2 AS decimal NO-UNDO .
DEFINE VARIABLE KursSr1 AS decimal NO-UNDO .
DEFINE VARIABLE KursSr2 AS decimal NO-UNDO .
DEFINE VARIABLE Kom1 AS decimal NO-UNDO .
DEFINE VARIABLE Kom2 AS decimal NO-UNDO .
DEFINE VARIABLE oSysClass AS TSysClass NO-UNDO.
DEFINE VARIABLE oAcct as TAcctBal NO-UNDO.

oSysClass = new TSysClass().

    form
    "Счет откуда    :" mW no-label skip
    "Счет куда      :" mW2 no-label skip
    "Сумма          :" mS no-label skip
    "Валюта         :" mCur no-label skip
    "Покупка/Продажа:" PokPr no-label HELP "Нужно нажать F1"
     with frame wow CENTERED OVERLAY ROW 10 SIDE-LABELS TITLE
          COLOR bright-white "[ ДАННЫЕ КЛИЕНТА. ПОКУПКА/ПРОДАЖА СО СТОРОНЫ КЛИЕНТА ]".

    pause 0.

   
    do transaction with frame wow:
	update mW mW2 mS mCur PokPr editing: readkey.
	        if lastkey eq keycode('F1') AND (frame-field EQ 'mW') then do:
       		       RUN browseld.p ('acct',
                                  '',
                                  '',
                                  ?,
                                  4) NO-ERROR.
       			if lastkey eq 10 then do:
				disp pick-value @ mW. 
			end.
	        end.
	        else do:
		        if lastkey eq keycode('F1') AND (frame-field EQ 'mW2') then do:
			       RUN browseld.p ('acct',
                                  '',
                                  '',
                                  ?,
                                  4) NO-ERROR.
       				if lastkey eq 10 then do:
					disp pick-value @ mW2. 
				end.
		        end.
			else apply lastkey.
		end.
		if lastkey eq keycode('F1') AND frame-field EQ 'PokPr' then do:
			if PokPr = "Покупка" then do:
				PokPr = "Продажа". 
				disp PokPr.
			end.
			else do: 
				PokPr = "Покупка".
				disp PokPr.
			end.
	        end.
        	else do:
			disp PokPr.
		end.
 	end.
    end.

    HIDE FRAME wow NO-PAUSE.
    if lastkey eq 27 then do:
       HIDE FRAME wow.
       return.
    end.  
    oTpl = new TTpl("pir-operkurs.tpl").

    oTable = new TTable(10).
    oTable:addRow().
    oTable:addCell("Сумма").
    oTable:addCell("Вал").
    oTable:addCell("Наименование клиента").
    oTable:addCell("Ком").
    oTable:addCell("Курс").
    oTable:addCell("Сумма").
    oTable:addCell("Вал").
    oTable:addCell("Наименование клиента").
    oTable:addCell("Ком").
    oTable:addCell("Курс").
   
    oTable:AddRow().
    if PokPr eq "Покупка" then do:
            oTable:addCell("").
	    oTable:addCell("").
	    oTable:addCell("").
	    oTable:addCell("").
	    oTable:addCell("").
    end.
 
    oTable:addCell(mS).
    oTable:addCell(string(mCur)).

    find first acct where acct.acct eq mW2 no-lock no-error.
    if avail(acct) then do:
	oAcct= new TAcctBal(acct.acct).
        oTable:AddCell(oAcct:name-short).

	find first  instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
				AND instr-rate.instr-code EQ acct.currency
				and (if PokPr eq "Продажа" then instr-rate.rate-type eq "СрзВзшКр" else instr-rate.rate-type eq "СрзВзшДБ")
				and instr-rate.since eq end-date
				no-lock no-error.
	if avail(instr-rate) then do:
		KursSr1 = instr-rate.rate-instr.
		find first comm-rate where comm-rate.since <= end-date
					and comm-rate.acct eq acct.acct
					and comm-rate.currency eq acct.currency
					and (if PokPr eq "Продажа" then comm-rate.commission eq "КонверКр" else comm-rate.commission eq "КонверДб")
					no-lock no-error.
		if avail(comm-rate) then do:
                	Kom1 = comm-rate.rate-comm.
		end.
		else do:
			Kom1 = 0.5.
		end.
	        oTable:AddCell(string(Kom1,">>9.99")).
		Sr1 = KursSr1 + (KursSr1 * Kom1) / 100.
		find first instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
				AND instr-rate.instr-code EQ acct.currency
				and instr-rate.rate-type eq "Учетный"
				and instr-rate.since eq end-date
				no-lock no-error.
		if avail(instr-rate) then do:
			KursCB1 = instr-rate.rate-instr.
               		if Sr1 < instr-rate.rate-instr then do:
				Sr1 = instr-rate.rate-instr.
			end.
		end.
		else do:
			message "не нашел instr-rate Учетный". pause.
		end.
	end.
	else do:
		message "не нашел instr-rate". pause.
	end.
    end.
    else do:
	message "счет " mW2 " введен не верно". pause.
    end.

    find first acct where acct.acct eq mW no-lock no-error.
    if avail(acct) then do:
	find first  instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
				AND instr-rate.instr-code EQ acct.currency
				and (if PokPr eq "Продажа" then instr-rate.rate-type eq "СрзВзшКр" else instr-rate.rate-type eq "СрзВзшДБ")
				and instr-rate.since eq end-date
				no-lock no-error.
	if avail(instr-rate) then do:
		KursSr2 = instr-rate.rate-instr.
		find first comm-rate where comm-rate.since <= end-date
					and comm-rate.acct eq acct.acct
					and comm-rate.currency eq acct.currency
					and (if PokPr eq "Продажа" then comm-rate.commission eq "КонверКр" else comm-rate.commission eq "КонверДб")
					no-lock no-error.
		if avail(comm-rate) then do:
        		Kom2 = comm-rate.rate-comm.
		end.
		else do:
			Kom2 = 0.5.
		end.
		Sr2 = KursSr2 - (KursSr2 * Kom2) / 100.
		find first instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
				AND instr-rate.instr-code EQ acct.currency
				and instr-rate.rate-type eq "Учетный"
				and instr-rate.since eq end-date
				no-lock no-error.
		if avail(instr-rate) then do:
			KursCB2 = instr-rate.rate-instr.
			if Sr2 > instr-rate.rate-instr then do:
				Sr2 = instr-rate.rate-instr.
			end.
		end.
		else do:
			message "не нашел instr-rate Учетный". pause.
		end.
	end.
	else do:
		message "не нашел instr-rate". pause.
	end.
    end.
    else do:
	message "счет " mW " введен не верно". pause.
    end.

    if PokPr = "Покупка" then Sr3 = Sr1 / Sr2.
    else Sr3 = Sr2 / Sr1.
    oTable:AddCell(string(Sr3,">>9.9999")).

    if PokPr eq "Продажа" then do:
	    oTable:addCell("").
	    oTable:addCell("").
	    oTable:addCell("").
	    oTable:addCell("").
	    oTable:addCell("").
    end.

oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("Date",end-date).
oTpl:addAnchorValue("КУРС1",oSysClass:getCBRKurs(840,end-date)).
oTpl:addAnchorValue("КУРС2",oSysClass:getCBRKurs(978,end-date)).
oTpl:addAnchorValue("КУРС3",oSysClass:getCBRKurs(826,end-date)).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oSysClass.
