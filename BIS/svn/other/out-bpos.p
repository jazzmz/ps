{pirsavelog.p}

/*

КБ ПPОМИНВЕСТРАСЧЕТ

22/02/06  Выгрузка данных по балансовым счетам для F1100 ФСФР
	  выгружает только по счетам которые есть в блоке данных          
26/02/06  Выгрузка форматная для Excel: # - разделитель полей;
					, - разделитель целой и дробной части.
02/03/06  Исправлена форматная выгрузка для екселя..
[vk]

*/

def var i as int no-undo.
def var rname as char initial  "КАПИТАЛ И ФОНДЫ,
				ДЕНЕЖНЫЕ СРЕДСТВА И ДРАГ.МЕТАЛЛЫ,
				МЕЖБАНКОВСКИЕ ОПЕРАЦИИ,
				ОПЕРАЦИИ С КЛИЕНТАМИ,
				ОПЕРАЦИИ С ЦЕННЫМИ БУМАГАМИ,
				СРЕДСТВА И ИМУЩЕСТВО,
				РЕЗУЛЬТАТЫ ДЕЯТЕЛЬНОСТИ".

def var r  as char. 
def var rs as char. 

{setdest.i}


r = ",". /* разделитель целой и дробной части числа при выгрузке */
rs = "#". /* разделитель столбцов для екселя  */

FUNCTION CommaString RETURNS char (INPUT a AS dec).
	Return  (string(truncate(a,0),"->>>>>>>>>>>>>>9") + 
		r + string((a - truncate(a,0)) * 100, "99")) + rs.
END FUNCTION.


{branches.i}

{br-put.i "ДАННЫЕ ДЛЯ ФОРМЫ F1100 ФСФР" }
MESSAGE "ВЫВОДИТЬ НАИМЕНОВАНИЯ РАЗДЕЛОВ БАЛАНСОВЫХ СЧЕТОВ?" 
         VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE mWop AS LOG.


put unformatted "ДАННЫЕ ДЛЯ ФОРМЫ F1100 ФСФР" rs skip(1).

do i=1 to 7.
  if mWop then do:
     put unformatted " " skip.
     put unformatted string(i,"9") ". " trim(ENTRY(i,rname)) rs skip.
     put unformatted    " Б/С " rs
			"             АКТИВ Р" rs
			"            АКТИВ РЭ" rs
			"               АКТИВ" rs
			"            ПАССИВ Р" rs
			"           ПАССИВ РЭ" rs
			"              ПАССИВ" rs skip.
     put unformatted    "-----" rs 
			" -------------------" rs 
			" -------------------" rs 
			" -------------------" rs 
			" -------------------" rs 
			" -------------------" rs 
			" -------------------" rs skip.
  end.

  put unformatted " " skip.

  for each DataLine of DataBlock where DataLine.Sym1 begins string(i) no-lock 
    break by DataLine.Sym1:
        put unformatted string(DataLine.Sym1,"99999") rs space 
			CommaString (DataLine.Val[9] - DataLine.Val[8]) space
			CommaString (DataLine.Val[8]) space
			CommaString (DataLine.Val[9]) space
			CommaString (DataLine.Val[12] - DataLine.Val[11]) space
			CommaString (DataLine.Val[11]) space
			CommaString (DataLine.Val[12]) space
			skip. 
  end.
end.


{signatur.i &department = branch &user-only = yes}

{preview.i}

