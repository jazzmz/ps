{pirsavelog.p}

/* кол-во счетов для Колосовой 
   27/03/06

*/ 

{globals.i}
{getdate.i}

def var b-date as date initial 01/01/2005 format "99/99/9999".
def var e-date as date initial 12/31/2005 format "99/99/9999".
def var BalAcctLine as char extent 4. /* массив исходных строк */
def var iCount as integer init 1.
def var eCount as integer init 1.
def var AllAcctCount as Integer.
def var sCount as integer.


balAcctLine[1] = "30109,30112".
balAcctLine[2] = "40502,40602,40701,40702,40703,40802,40804,40805,40807,40813,40814,40815,40817,40820".
balAcctLine[3] = "42104,42105,42204,42205,42301,42302,42304,42305,42306,42307,42309,42501,42506,42601,42604,42605".
balAcctLine[4] = "45203,45204,45205,45206,45207,45208,45502,45503,45504,45505,45506,45507,45601,45605,47427,458,459,916".


function AcctCount returns integer (input maska as char).
def var ac as integer init 0.

 for each acct where acct.acct begins maska AND
		    acct.open-date <= e-date AND
		    (acct.close-date = ? or acct.close-date > e-date):
  Ac= Ac + 1.   
 end.
return(Ac).
end function.


{setdest.i}
e-date = end-date.

/* расчет кол-ва лицевых счетов по списку счетов второго порядка */

do iCount = 1 to 4:
 put unformatted  "Расчет кол-ва счетов. Список счетов " string(iCount,"9") "." skip. 
 sCount = 0.
 Do eCount = 1 to num-entries(balAcctLine[iCount]):
   sCount = sCount + AcctCount(entry(eCount,balAcctLine[iCount])).
   put unformatted string(ecount,">9") space string(entry(eCount,balAcctLine[icount]),"x(5)") space 
		   string(AcctCount(entry(eCount,balAcctLine[icount])),">>>>>9") skip.
 End.
 put unformatted  "---------------------------" skip "Всего по списку:" string(sCount,">>>>>9") skip(1). 
end.



{preview.i}