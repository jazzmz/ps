{globals.i}
{getdate.i}
{lshpr.pro}           /* Инструменты для расчета параметров договора */
def var oTable as TTable.
def buffer transh for loan.
def var bFirst as Logical.
def var Pr7 AS DEC.
def var Pr48 as DEC.
def var Pr10 AS DEC.
def var Temp AS DEC.

def var sPr7 AS DEC.
def var sPr48 as DEC.
def var sPr10 AS DEC.


{setdest.i}
    PUT UNFORMATTED "                                   Отчет по просроченным траншам в разрезе валют" SKIP(3).


for each loan where (loan.cont-code begins "ПК" or loan.cont-code begins "ДС")  and loan.contract = "Кредит" and loan.close-date = ? NO-LOCK.
    find first person where person.person-id = loan.cust-id NO-LOCK.
    bFirst = false.
        oTable = new TTable(5). 
           oTable:AddRow().
           oTable:AddCell("Номер транша").
           oTable:AddCell("Сумма транша").
           oTable:AddCell("Дата выноса транша на просрочку").
           oTable:AddCell("Просроченные % на счете 45915").
           oTable:AddCell("Просроченные % на счете 91604").
           sPr7 = 0.
	   sPr48 = 0.
           sPr10 = 0.
	
    for each transh where transh.cont-code begins loan.cont-code and transh.cont-code <> loan.cont-code and transh.contract = loan.contract and loan.close-date = ? NO-LOCK.

        RUN STNDRT_PARAM(transh.contract, transh.cont-code,  7, end-date, OUTPUT Pr7 , OUTPUT Temp, OUTPUT Temp).
        if Pr7 <> 0 then do:
           bfirst = true.
	   RUN STNDRT_PARAM(transh.contract, transh.cont-code,  48, end-date, OUTPUT Pr48 , OUTPUT Temp, OUTPUT Temp).
           RUN STNDRT_PARAM(transh.contract, transh.cont-code,  10, end-date, OUTPUT Pr10 , OUTPUT Temp, OUTPUT Temp).
           oTable:AddRow().
           oTable:AddCell(transh.cont-code).
           oTable:AddCell(Pr7).
           oTable:AddCell(transh.end-date).
           oTable:AddCell(Pr10).
           oTable:AddCell(Pr48).

           sPr7 = sPr7 + Pr7. 
	   sPr48 = sPr48 + Pr48. 
           sPr10 = sPr10 + Pr10.

	end.
    end.
    if bfirst then do:
    PUT UNFORMATTED person.name-last + " " person.first-names + "   " + loan.cont-code SKIP(0).

           oTable:AddRow().
           oTable:AddCell(" ").
           oTable:AddCell(sPr7).
           oTable:AddCell(" ").
           oTable:AddCell(sPr10).
           oTable:AddCell(sPr48).

    oTable:show().
     PUT UNFORMATTED SKIP(2).
    end.
    DELETE OBJECT oTable.



end.

{preview.i}
