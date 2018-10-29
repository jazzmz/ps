{globals.i}
{getdate.i}
{tmprecid.def}
{ulib.i}
{sh-defs.i}

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* Счетчик договоров */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* Общее количество договоров */

def var vFlDosrZakr as CHAR NO-UNDO.

def var prevgend-date as date NO-UNDO.
def var prevgbeg-date as date NO-UNDO.
def var loan-end-date as date NO-UNDO.

def var temp2 as char no-undo.

prevgend-date = gend-date.
prevgbeg-date = gbeg-date.
gbeg-date = end-date.
gend-date = end-date.

def var count as int init 0 NO-UNDO.
def var count2 as int init 0 NO-UNDO.

def var oTable as TTable NO-UNDO.
def var oTable2 as TTable NO-UNDO.
def var oTable3 as TTable NO-UNDO.
def var iserror as logical init no NO-UNDO.
def var iserror2 as logical init no NO-UNDO.
def var iserror3 as logical init no NO-UNDO.
def var temp as char NO-UNDO.
def var deriv as char NO-UNDO.

def var base as integer NO-UNDO.

if TRUNCATE(YEAR(end-date) / 4,0) = YEAR(end-date) / 4 then
	base = 366.
else
	base = 365.

def var vMessAns as LOGICAL NO-UNDO.

def var vMessAns2 as LOGICAL NO-UNDO.

MESSAGE "Учитывать пролонгацию договоров?" 
		VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
		TITLE "" UPDATE vMessAns.

MESSAGE "Проверять исключение deriv на счетах?" 
		VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
		TITLE "" UPDATE vMessAns2.

/* здесь считаем количество записей которые нужно обработать для того чтобы правильно построить прогрессбар*/
for each loan where loan.contract = "Кредит" 
		and (loan.close-date >= end-date or loan.close-date = ?) 
		and loan.open-date <= end-date
		and can-do("l*",loan.class-code) NO-LOCK.

vLnTotalInt = vLnTotalInt + 1.

end.

for each acct where acct.acct begins "9" and (acct.close-date = ? OR acct.close-date >= end-date) NO-LOCK.
vLnTotalInt = vLnTotalInt + 1.
end.

/*посчитали*/

/* создаем таблицы в которые будем сохранять ошибки, в данном случае не использую TTpl, 
т.к. неизвестно нужно ли выводить какую-то таблицу */
oTable = new TTable(7).

	    oTable:AddRow().
	    oTable:AddCell("").
	    oTable:AddCell("Номер договора").
	    oTable:AddCell("Счет лимита").
	    oTable:AddCell("Установленное значение DERIV").
	    oTable:AddCell("Расчетное значение К.риска").
	    oTable:AddCell("Дата окончания договора").
	    oTable:AddCell("Ответственный по договору").

oTable2 = new TTable(7).

	    oTable2:AddRow().
	    oTable2:AddCell("").
	    oTable2:AddCell("Номер договора").
	    oTable2:AddCell("Счет лимита").
	    oTable2:AddCell("Установленное значение DERIV").
	    oTable2:AddCell("   ").
	    oTable2:AddCell("Дата окончания договора").
	    oTable2:AddCell("Ответственный по договору").

oTable3 = new TTable(3).

	    oTable3:AddRow().
	    oTable3:AddCell("").
	    oTable3:AddCell("Номер счета").
	    oTable3:AddCell("Установленное значение DERIV").




/*FOR EACH tmprecid,*/

for each loan where loan.contract = "Кредит" 
		and (loan.close-date >= end-date or loan.close-date = ?) 
		and loan.open-date <= end-date
		and can-do("l*",loan.class-code) NO-LOCK.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


     for each loan-acct where loan-acct.contract = loan.contract 
			  and loan-acct.cont-code = loan.cont-code 
			  and loan-acct.since <= end-date
			  and (loan-acct.acct-type = "КредН" or 
			       loan-acct.acct-type = "КредЛин") 
			  No-LOCK,
	first acct where loan-acct.acct = acct.acct and (acct.close-date >= end-date or acct.close-date = ?) NO-LOCK.

      deriv = "".
      deriv = GetXAttrValue("acct", loan-acct.acct + "," + loan-acct.currency, "deriv").

      loan-end-date = loan.end-date.

      if vMessAns then                                                            /* если с учетом пролонгации то логика следующая:   */
	do:                                                                       /* ищем первую пролонгацию дата которой больше      */ 
	   find first pro-obl where pro-obl.contract = loan.contract              /* даты формирования отчета, и берем срок договора */
			       and pro-obl.cont-code = loan.cont-code             /* до пролонгации */
			       and pro-obl.pr-date >= end-date	
			       NO-LOCK NO-ERROR. 
	    if AVAILABLE(pro-obl) then loan-end-date = pro-obl.end-date.

        end.


       vFlDosrZakr = "Нет".
          vFlDosrZakr = GetXattrValueEx("loan",
                                        loan.contract + "," + loan.cont-code,
                                        "ДосрЗакр",
                                        "").



      if loan-end-date - end-date <= base then temp = "003".
      else
      temp = "002".

      if  vFlDosrZakr = "Да" then temp = "004".

      FIND FIRST code WHERE code.class EQ 'ПарамФИ' 
		        AND code.parent EQ 'ПарамФИ'
			AND code.code begins STRING(acct.bal-acct)
			and code.misc[2] = temp NO-LOCK NO-ERROR.
	
	if available (code) then do: temp = entry(2,code.code,"_") + "," + temp. temp2 = entry(2,code.code,"_"). end.
	else temp = "Не найдено значение ПАРАМФИ для связки: " + STRING(acct.bal-acct)	+ " " + temp.

            RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              CHR(251)).

/*           if loan.cont-code = "ПК-001/05" then MESSAGE sh-val sh-bal deriv temp VIEW-AS ALERT-BOX.*/

      if (sh-val + sh-bal) <> 0 then /* если исходящий остак по счету равен 0 на дату отчета, то такой счет нас не интересует */
	do:
	      if deriv <> "" and deriv <> ? then
	      do:
	/*       if (entry(1,deriv) + "," + entry(2,deriv) = temp)  then                */

	         if (entry(1,deriv) <> temp2 and entry(2,deriv) <> temp)  then
		 do:                           
	            count = count + 1.	
		    iserror  = true.
		    oTable:AddRow().
		    oTable:AddCell(count).
		    oTable:AddCell(loan.cont-code).
		    oTable:AddCell(loan-acct.acct).
		    oTable:AddCell(entry(1,deriv) + "," + entry(2,deriv)).
		    oTable:AddCell(temp).
		    oTable:AddCell(loan.end-date).
		    oTable:AddCell(loan.user-id).
		 end.

	      if (dec(ENTRY(7,deriv)) <> 1) and vMessAns2 = yes then          
	         do:
	            message vMessAns2 VIEW-AS ALERT-BOX.
		    count2 = count2 + 1.
		    iserror2 = true.
		    oTable2:AddRow().
		    oTable2:AddCell(count2).
		    oTable2:AddCell(loan.cont-code).
		    oTable2:AddCell(loan-acct.acct).
		    oTable2:AddCell(deriv).
		    oTable2:AddCell("ИСКЛЮЧЕН!").
		    oTable2:AddCell(loan.end-date).
		    oTable2:AddCell(loan.user-id).
		 end.
	      end.
	      else      
	        do:
	            count = count + 1.
		    iserror = true.
		    oTable:AddRow().
		    oTable:AddCell(count).
		    oTable:AddCell(loan.cont-code).
		    oTable:AddCell(loan-acct.acct).
		    oTable:AddCell("НЕ ЗАПОЛНЕН!").
		    oTable:AddCell(temp).
		    oTable:AddCell(loan.end-date).
		    oTable:AddCell(loan.user-id).
		 END.       
       end. /*    */
    end. /*for each loan-acct*/

           vLnCountInt = vLnCountInt + 1.

end.



    count = 0.

for each acct where acct.acct begins "9" and (acct.close-date = ? OR acct.close-date >= end-date) NO-LOCK.

         /* Бегущая строка - индикатор работы процесса */
         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }


      deriv = GetXAttrValue("acct", acct.acct + "," + acct.currency, "deriv").

       if can-do("!91315*,!91316*,!91317*,!90907*,*",acct.acct) 
	    and (deriv <> ? and deriv <> "") 
	    and (dec(ENTRY(NUM-ENTRIES(deriv),deriv)) <> 0) \
	    and vMessAns2 = no then 
	do:
            count = count + 1.
	    iserror3 = true.

   	    oTable3:AddRow().
	    oTable3:AddCell(count).
	    oTable3:AddCell(acct.acct).
	    oTable3:AddCell(deriv).

    
        end.

           vLnCountInt = vLnCountInt + 1.

end.

{setdest.i}
PUT UNFORMATTED "                   Проверочная ведомость доп.реквизита Deriv за " end-date Skip(3).
if iserror then oTable:show().
/*else
PUT UNFORMATTED "Ошибок не найдено! " end-date Skip(3).*/
if iserror2 then do:
PUT UNFORMATTED Skip " Счета на которых значение deriv исключает счет из расчета" Skip(1).
oTable2:show().
end.

if iserror3 then do:
PUT UNFORMATTED Skip " Счета на которых значение deriv не должно быть установленно:" Skip(1).
oTable3:show().
end.

PUT UNFORMATTED "Выполнил: " + GetUserInfo_ULL(USERID, "fio", false) SKIP(0). 
PUT UNFORMATTED "Дата расчета: " + string(end-date) SKIP(0).
PUT UNFORMATTED "Дата выполнения: " + string(TODAY) + "  " + STRING(TIME,"HH:MM:SS") SKIP(0).
{preview.i}

gend-date = prevgend-date.
gbeg-date = prevgbeg-date.

DELETE OBJECT oTable.
DELETE OBJECT oTable2.
DELETE OBJECT oTable3.