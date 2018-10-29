{pirsavelog.p}

/*
		Отчет по счетам, остатки которых удовлетворяют условиям
*/
DEF VAR result_min AS DECIMAL INITIAL 0 label "Сумма MIN:".
DEF VAR count_min  AS INTEGER INITIAL 0 label "Кол-во MIN:".
DEF VAR result_max AS DECIMAL INITIAL 0 label "Сумма MAX:".
DEF VAR count_max  AS INTEGER INITIAL 0 label "Кол-во MAX:".
DEF VAR new_acct AS CHAR LABEL "Счет".
DEF VAR new_date AS DATE LABEL "Дата".
DEF VAR max_summa AS DECIMAL LABEL "Сумма".

PAUSE 0.
DISPLAY
	new_acct FORMAT "x(63)" SKIP
	new_date FORMAT "99/99/9999" SKIP
	max_summa FORMAT ">>>,>>>,>>9" SKIP
	"-------" SKIP
	WITH FRAME frm CENTERED OVERLAY SIDE-LABELS.
	
SET new_acct new_date max_summa WITH FRAME frm.

FOR EACH acct WHERE
		CAN-DO(new_acct, acct.acct)
		AND
		open-DATE LE new_date
		AND
		(acct.close-DATE = ? OR acct.close-DATE GT new_date)
		NO-LOCK,
		LAST acct-pos OF acct WHERE
		acct-pos.since LE new_date
		NO-LOCK
		:
		IF ABS(acct-pos.balance) <= max_summa AND ABS(acct-pos.balance) > 0 THEN 
			DO:
				result_min = result_min + ABS(acct-pos.balance).
				count_min = count_min + 1.
			END.
		IF ABS(acct-pos.balance) = max_summa THEN 
			DO:
				result_max = result_max + ABS(acct-pos.balance).
				count_max = count_max + 1.
			END.
END.

DISPLAY 
  result_min FORMAT "->>>,>>>,>>>,>>>,>>9.99" count_min FORMAT ">>>,>>>,>>>" SKIP
  result_max FORMAT "->>>,>>>,>>>,>>>,>>9.99" count_max FORMAT ">>>,>>>,>>>" SKIP
  WITH FRAME frm.
  
HIDE FRAME frm.