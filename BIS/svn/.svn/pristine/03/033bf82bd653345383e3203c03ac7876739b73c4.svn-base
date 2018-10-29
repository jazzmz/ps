/*Проверочная ведомость 
сравнивает категория качетва по договору с категорией качества по счету внебаланса
Автор:Красков А.С.
Заказчик: Маслов Д.А. */

{globals.i}
{intrface.get i254}
{getdate.i}
/*{tmprecid.def}*/

def var oTable as TTable.
def var vRisk as dec NO-UNDO.
def var vRiskKredN as dec NO-UNDO.
def var vGr-Risk as dec NO-UNDO.
def var vGr-RiskKredN as dec NO-UNDO.
def var lacct as char NO-UNDO.
oTable = new TTable(6).


oTable:addRow().
oTable:addCell("Номер договора").
oTable:addCell("Коэф. рез").
oTable:addCell("Группа риска").
oTable:addCell("Счет по внебалансу").
oTable:addCell("Коэф. рез КредН/КредЛин").
oTable:addCell("Группа риска").

/*FOR EACH tmprecid,*/
for each Loan where  can-do("!*loan-tran-lin,!*loan_trans*,*",loan.class-code) and loan.contract = "Кредит" and (loan.close-date >= end-date or loan.close-date = ?) NO-LOCK.


vRisk = 0.
vGR-Risk = 0.

vRisk  = LnRsrvRate(loan.contract,loan.cont-code,end-date).

RUN LnGetRiskGrOnDate  IN h_i254 (vRisk,end-date,OUTPUT vGr-Risk).  

vRiskKredN = -1.
vGR-RiskKredN = -1.
lacct = "".

find last loan-acct where loan-acct.contract = loan.contract and loan-acct.cont-code = loan.cont-code and Can-Do("КредН,КредЛин",loan-acct.acct-type) and loan-acct.since <= end-date NO-LOCK NO-ERROR.
if available loan-acct then do:
lacct = loan-acct.acct.
find last comm-rate where comm-rate.commission begins "%Рез" 
                      and comm-rate.since <= end-date
                      and comm-rate.acct = loan-acct.acct
                      and comm-rate.currency = loan-acct.currency
                      NO-LOCK NO-ERROR.
   if available (comm-rate) then do:
     vRiskKredN = comm-rate.rate-comm.                      
    RUN LnGetRiskGrOnDate  IN h_i254 (vRiskKredN,end-date,OUTPUT vGr-RiskKredN).  
  end.
end.

if vGr-Risk <> vGr-RiskKredN and vGr-RiskKredN <> -1 then do:
oTable:addRow().
oTable:addCell(loan.cont-code).
oTable:addCell(vRisk).
oTable:addCell(vGr-Risk).
oTable:addCell(lacct).
if lacct <> "" then oTable:addCell(vRiskKredN). else oTable:addCell("").
if lacct <> "" then oTable:addCell(vGr-RiskKredN). else oTable:addCell("").
end.
end.


{setdest.i}
PUT UNFORMATTED "           Коэффициенты резервирования и группы риска по выбранным кредитным договорам на " STRING(end-date,"99/99/9999") SKIP(3).
oTable:show().
{preview.i}

DELETE OBJECT oTable.
{intrface.del}

