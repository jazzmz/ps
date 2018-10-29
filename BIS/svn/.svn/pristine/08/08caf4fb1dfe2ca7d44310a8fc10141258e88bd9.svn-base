{pirsavelog.p}

/*

КБ ПPОМИНВЕСТРАСЧЕТ

22/02/06  Выгрузка данных по срочным операциям и счетам доверительного управления для F1100 ФСФР
          
[vk]

*/

def var i as int no-undo.
def var r  as char. 
def var rs as char. 
r = ",". /* разделитель целой и дробной части числа при выгрузке */
rs = "#". /* разделитель столбцов для екселя  */

{setdest.i}


FUNCTION CommaString RETURNS char (INPUT a AS dec).
	Return  (string(truncate(a,0),"->>>>>>>>>>>>>>9") + 
		r + string((a - truncate(a,0)) * 100, "99")) + rs.
END FUNCTION.

{branches.i}

{br-put.i "ДАННЫЕ ДЛЯ ФОРМЫ F1100 ФСФР" }

MESSAGE "ВЫВОДИТЬ НАИМЕНОВАНИЯ СТОЛБЦОВ?" 
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mWop AS LOG.



put unformatted "ДАННЫЕ ДЛЯ ФОРМЫ F1100 ФСФР#" skip(1).
put unformatted " " skip.
put unformatted "АКТИВНЫЕ#" skip.

if mWop then do:
	put unformatted " " skip.
	put unformatted " Б/С #               АКТИВ#" skip.
	put unformatted "-----# -------------------#" skip.
end.

  for each DataLine of DataBlock no-lock 
    by DataLine.Sym1:
    find first bal-acct where bal-acct.bal-acct = integer(DataLine.Sym1).
      if avail bal-acct and bal-acct.side = "А" then do:

        put unformatted string(DataLine.Sym1,"99999") rs space 
			CommaString(DataLine.Val[9]) space
			skip. 
      end.
  end.

put unformatted " " skip.
put unformatted "ПАССИВНЫЕ#" skip.
if mWop then do:
	put unformatted " " skip.
	put unformatted " Б/С #              ПАССИВ#" skip.
	put unformatted "-----# -------------------#" skip.
end.

  for each DataLine of DataBlock no-lock 
    by DataLine.Sym1:
    find first bal-acct where bal-acct.bal-acct = integer(DataLine.Sym1).
      if avail bal-acct and bal-acct.side = "П" then do:

        put unformatted string(DataLine.Sym1,"99999") rs space 
			CommaString(DataLine.Val[12]) space
			skip. 
        end.
  end.
	

{signatur.i &department = branch &user-only = yes}

{preview.i}

