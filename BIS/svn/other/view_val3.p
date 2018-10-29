{pirsavelog.p}

/*
КБ ПPОМИНВЕСТРАСЧЕТ
Вывод экранных данных классa данных.
  
[vk]

*/

def var sumval3 as dec.
def var sumval1 as dec.


{branches.i}

{br-put.i "ДАННЫЕ 8956" }
{setdest.i}
sumval1 = 0. sumval3 = 0.
MESSAGE "You are currently running PROGRESS Version" PROVERSION.

put unformatted "Сформированный резерв по счетам попавшим в расчет 8956" skip(2).
  for each DataLine of DataBlock where DataLine.Sym1 = "Лс8956" no-lock 
    break by DataLine.Sym3:
        put unformatted string(DataLine.Sym1,"x(10)") space 
                        string(DataLine.Sym2,"x(20)") space
                        string(DataLine.Sym3,"x(3)") space
                        string(DataLine.Sym2,"x(5)") space
			String (DataLine.Val[3],"->>>,>>>,>>>,>>9.99") space
			String (DataLine.Val[1],"->>>,>>>,>>>,>>9.99") skip. 
	Sumval1 = sumval1 + DataLine.Val[1].
	Sumval3 = sumval3 + DataLine.Val[3].
  end.
put unformatted " " skip.
put unformatted space(42) string(sumval3,"->>>,>>>,>>>,>>9.99") space 
		string(sumval1,"->>>,>>>,>>>,>>9.99") skip.



{preview.i}