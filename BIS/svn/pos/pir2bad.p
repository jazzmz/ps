/*Распоряжение о выносе на просрочку
Автор: Красков А.С.
Заказчик: Василькова Т.В.*/

using Progress.Lang.*.

{globals.i}
{getdate.i}
{lshpr.pro}           /* Инструменты для расчета параметров договора */
{ulib.i}

DEF INPUT PARAMETER TypeOtch AS INT NO-UNDO.

DEF VAR oTpl AS TTpl NO-UNDO.
def buffer transh for loan.

def var oTable AS TTable NO-UNDO.
def var ctrans AS CHAR   NO-UNDO.

def var oFunc   as tfunc   NO-UNDO.
def var grriska as char    NO-UNDO.
def var rate    as dec     NO-UNDO.
def var transhloan as char NO-UNDO.

DEF VAR cur      as Char NO-UNDO.
def var DataZakl as date NO-UNDO.
oFunc = new tfunc().

def buffer bfloan-int for loan-int.

def buffer bLoan-int for loan-int.

def var itogo AS dec initial 0 NO-UNDO.

if TypeOtch = 1 then cur = "".
else 
if TypeOtch = 2 then cur = "840".
else cur = "978".



oTpl = new TTpl("pir2bad.tpl").
oTable = new TTable(6).

    oTable:AddRow().
    oTable:AddCell("НА СЧЕТЕ").
    oTable:AddCell("СУММА ОПЕРАЦИИ").
    oTable:AddCell("ВАЛЮТА").
    oTable:AddCell("ТИП ОПЕРАЦИИ").
    oTable:AddCell("КРЕДИТНЫЙ ДОГОВОР").
    oTable:AddCell("ЗАЕМЩИК").


for each bfloan-int where bfloan-int.contract = "Кредит"
		        and (bfloan-int.id-k = 0 and bfloan-int.id-d = 7) /*срочную задолжность в просрочку */
 		        and bfloan-int.op-date = end-date NO-LOCK BY bfloan-int.amt-rub DESCENDING.
    find first loan where loan.contract = "Кредит" and loan.cont-code = bfloan-int.cont-code and loan.end-date = end-date and can-do(cur,loan.currency) and can-do("l_agr_with*,loan_trans_*",loan.class-code) NO-LOCK NO-ERROR.
    if available loan then do:
    transhloan = loan.cont-code.


    for each loan-int where loan-int.contract = "Кредит"
   		        and loan-int.cont-code = TRIM(transhloan)
		        and ((loan-int.id-k = 0 and loan-int.id-d = 7) /*срочную задолжность в просрочку */
		        or  (loan-int.id-k = 33 and loan-int.id-d = 10) /*начисленные проценты на просроку */
		        or  (loan-int.id-k = 32 and loan-int.id-d = 33) /*доначисление процентов */
		        or  (loan-int.id-k = 30 and loan-int.id-d = 29) /*доначисление процентов на просроку на внебаланс операц 83*/
		        or  (loan-int.id-k = 29 and loan-int.id-d = 48)) /*перенос на просрочку начисл проц. операция 304*/
 		        and loan-int.op-date = end-date NO-LOCK by loan-int.id-k BY loan-int.amt-rub  DESCENDING.

    find first op-entry where op-entry.op = loan-int.op and can-do(cur,op-entry.currency) NO-LOCK NO-ERROR.
    if NOT AVAILABLE (op-entry) then MESSAGE "Не найдена операция выноса на просрочку по траншу " loan.cont-code VIEW-AS ALERT-BOX. 

    find first person where person.person-id = loan.cust-id NO-LOCK NO-ERROR.

    dataZakl = DATE(getMainLoanAttr("Кредит",ENTRY(1,loan.cont-code," "),"%ДатаСогл")).

    oTable:AddRow().
    oTable:AddCell(op-entry.acct-db).

    if TypeOtch = 1 then do:
	oTable:AddCell((STRING(round(op-entry.amt-rub,2),">>>,>>>,>>>,>>9.99"))).
	itogo = itogo + round(op-entry.amt-rub,2).
    end.
    else do:
	oTable:AddCell((STRING(round(op-entry.amt-cur,2),">>>,>>>,>>>,>>9.99"))).
	itogo = itogo + round(op-entry.amt-cur,2).
    end.

    if TypeOtch = 1 then 
    oTable:AddCell("810").
    else
    oTable:AddCell(op-entry.currency).


    if loan-int.id-k = 0 then 
    oTable:AddCell("Перенос на просрочку осн. долга ").

    /*доначисление процентов */
    if loan-int.id-k = 32 then 
    oTable:AddCell("Доначисл. процентов за текущий месяц ").

    /*начисленные проценты на просроку */
    if loan-int.id-k = 33 then 
    oTable:AddCell("Перенос на просрочку начисленных процентов ").

    /*доначисление процентов */
    if loan-int.id-k = 30 then 
    oTable:AddCell("Доначисл. процентов за текущий месяц ").

    /*начисленные проценты на просроку */
    if loan-int.id-k = 29 then 
    oTable:AddCell("Перенос на просрочку начисленных процентов ").


    oTable:AddCell(loan.cont-code + " от " + STRING(dataZakl)).
    oTable:AddCell(Person.name-last + " " + Person.first-names).


    end.
end.
end.

oTpl:addAnchorValue("itogo",itogo).
oTpl:addAnchorValue("TABLE1",oTable).
oTpl:addAnchorValue("Date",end-date).

{setdest.i}
oTpl:Show().
{preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oFunc.