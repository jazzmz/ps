/*по заявке #868
Отчет о наличии элементов расчетной базы по контрагенту 
Закачик: Титова С.В
Автор: Красков А.С.
12.04.2012 */

using Progress.Lang.*.

{globals.i}

{tmprecid.def}
{sh-defs.i}

{getdate.i}



def var oTable AS TTable NO-UNDO.
def var custtype AS CHAR INIT " " NO-UNDO.
def var custid AS INTEGER INIT 0 NO-UNDO.
def var acctmaskA as CHAR INIT "30110*,30114*,30118*,30119*,30213*,30221*,30233*,30402*,30404*,30406*,30409*,30602*,320*,321*,322*,323*,324*,32501*,32502*,47427*,459*,47423*,45*,501*,502*,503*,506*,507*,512*,513*,514*,515*,516*,517*,518*" NO-UNDO.
def var acctmaskP as CHAR INIT "91315*,91316*,91317*" NO-UNDO.
def var acctmask2 as CHAR INIT "60202*,60203*,60204*,60308*,60312*,60314*,60323*,60401*" NO-UNDO.
def var finded as logical NO-UNDO.
def var clientname as CHAR NO-UNDO.
def var count as int NO-UNDO.


PROCEDURE ADDtoTable.

	              sh-bal = 0.
	              sh-val = 0.
                      RUN acct-pos IN h_base (acct.acct,
                              acct.currency,
                              end-date,
                              end-date,
                              ?).


                  if sh-bal <> 0 or sh-val <> 0 then 
	             do:
	                count = count + 1.
                        finded = true.
		        oTable:addRow().
		        oTable:addCell(count).
 		        oTable:addCell(acct.acct).
		        oTable:addCell(acct.details).
		        oTable:addCell(STRING(sh-bal)).
		        oTable:addCell(sh-val).
		     end.

END PROCEDURE.



{setdest.i}





for each tmprecid.


     find first cust-corp where RECID(cust-corp) = tmprecid.id NO-LOCK NO-ERROR.
         if AVAILABLE (cust-corp) then 
            do:
               custtype = "Ю".
               custid = cust-corp.cust-id.
               clientname = cust-corp.name-short.
            end.
         else
            do:
               find first person where RECID(person) = tmprecid.id NO-LOCK NO-ERROR.
                   if AVAILABLE (person) then 
             	      do:
 	                 custtype = "Ч".
 	                 custid = person.person-id.
                         clientname = person.name-last + " " + person.first-names.
 	              end.
		   else
                      do:
	                 find first banks where RECID(banks) = tmprecid.id NO-LOCK NO-ERROR.
	                     if AVAILABLE (banks) then 
	               	        do:
              	           
	   	                   custtype = "Б".
 	                 	   custid = banks.bank-id.
                         	   clientname = banks.short-name.
 	              		end.
                     end.

            end.


               PUT UNFORMATTED "              Элементы расчетной базы резерва по Контрагенту " + clientname + "."      SKIP(0).
               PUT UNFORMATTED "                                     "string(end-date)      SKIP(3).

    finded = false.
    count = 0.
    oTable = new tTable(5).

    oTable:addRow().
    oTable:addCell(" ").
    oTable:addCell("Номер счета").
    oTable:addCell("Наименование счета").
    oTable:addCell("Остаток в рублях").
    oTable:addCell("Остаток в валюте").

oTable:colsWidthList="2,20,30,17,17".
    
    /* ищем счета в которых явно прописан cust-id */
    for each acct where CAN-DO(acctmaskA,acct.acct) 
                    and acct.side = "А"
                    and acct.cust-cat = custtype
	            and acct.cust-id = custid 
                    and acct.open-date <= end-date 
	            and (acct.close-date >= end-date or acct.close-date = ?) NO-LOCK.

	   RUN ADDtoTable.

    end.

    for each acct where CAN-DO(acctmaskP,acct.acct)
                    and acct.side = "П" 
                    and acct.cust-cat = custtype
	            and acct.cust-id = custid 
                    and acct.open-date <= end-date 
	            and (acct.close-date >= end-date or acct.close-date = ?) NO-LOCK.

	   RUN ADDtoTable.

    end.


   if custtype = "Ю" or custtype = "Б" then do:
      for each acct where can-do(acctmask2,acct.acct) 
                    and acct.open-date <= end-date 
	            and (acct.close-date >= end-date or acct.close-date = ?) NO-LOCK,
          first signs where signs.code = "PirInnCorp" and signs.file-name = "acct" and signs.surrogate = (acct.acct + "," + acct.currency) and signs.xattr-value = cust-corp.inn NO-LOCK.

	   RUN ADDtoTable.	

      end.
   end.
   if custtype = "Ч" then do:
      for each acct where can-do(acctmask2,acct.acct)
		     and can-do("*" + ENTRY(1,person.name-last," ") + "*",acct.details)
                     and acct.open-date <= end-date 
 	             and (acct.close-date >= end-date or acct.close-date = ?) NO-LOCK.
	   RUN ADDtoTable.	
      end.
   end.

  if finded then oTable:show().

  PUT UNFORMATTED SKIP(1).


   DELETE OBJECT oTable.

end.


{preview.i}
