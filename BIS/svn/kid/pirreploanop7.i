/*
		Балансовые и внебалансовые операции не подвязанные к кредитным договорам.
		Седьмой раздел отчета по операциям по кредитным договорам.
		Бурягин Е.П., 16.01.2006 16:01
*/

/* 
{uloanlib.i} - определен в pirreploanop.p
DEF VAR loanno AS CHAR - определен в pirreploanop.p
DEF VAR loanopendate AS DATE - определен в pirreploanop.p
DEF VAR traceOn AS LOGICAL - определен в pirreploanop.p
*/

/* Очистим таблицу
*/
FOR EACH replines
:
	DELETE replines.
END.

ASSIGN
subtotal_amt_rub = 0
subtotal_amt_usd = 0.

/* Для всех документов, выбранных в брoузере выполняем... */
FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op WHERE
         NO-LOCK
: 
	/* 
		Все операции, выбранные в фильтре и не привязанные по субаналитике к кредитным договорам.
	*/
	IF NOT op-entry.kau-db BEGINS "Кредит,"
		AND
		NOT op-entry.kau-cr BEGINS "Кредит,"
	THEN
			DO:
					loanno = "".
					
					/* Создаем строку */
					CREATE replines.
					/* Дата открытия договора */
					loanopendate = ?.
					/* Заполним значения */
					ASSIGN
					replines.client_name[1] = ""
					replines.loan_no = ""
					replines.loan_date = loanopendate
					replines.op_no = op.doc-num
					replines.op_acct_db = op-entry.acct-db
					replines.op_acct_cr = op-entry.acct-cr
					replines.op_amt = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur)
					replines.op_cur = (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency)
					replines.op_details[1] = op.details
					replines.op_user = op.user-id
					replines.op_contr_user = op.user-inspector
					replines.op_done_flag = op.op-status.
					/* Суммируем подытоги */
					IF replines.op_cur = "810" THEN subtotal_amt_rub = subtotal_amt_rub + replines.op_amt.
					IF replines.op_cur = "840" THEN subtotal_amt_usd = subtotal_amt_usd + replines.op_amt.

				END.
END.

/* Заполнили временную таблицу, теперь выведем ее на экран */

PUT UNFORMATTED	
	"  7) ОПЕРАЦИИ НЕ ПОДВЯЗАННЫЕ К КРЕДИТНЫМ ДОГОВОРАМ. ВНЕБАЛАНСОВЫЕ ОПЕРАЦИИ" SKIP
	"┌──────┬──────────────────────────────┬───────────┬──────────┬──────┬────────────────────┬────────────────────┬──────────────────┬───┬──────────────────────────────┬───────────┬─────────┬─────────────┐" SKIP.

FOR EACH replines USE-INDEX acct_db
:
	PUT UNFORMATTED	
	"│" str_num FORMAT ">>>>>>"
	"│" client_name[1] FORMAT "x(30)"
	"│" loan_no FORMAT "x(11)"
	"│" loan_date FORMAT "99/99/9999"
	"│" op_no FORMAT "x(6)"
	"│" op_acct_db FORMAT "x(20)"
	"│" op_acct_cr FORMAT "x(20)"
	"│" op_amt FORMAT ">>>,>>>,>>>,>>9.99"
	"│" op_cur FORMAT "xxx"
	"│" op_details[1] FORMAT "x(30)"
	"│" op_user FORMAT "x(11)"
	"│" op_contr_user FORMAT "x(9)"
	"│" op_done_flag FORMAT "x(13)" 
	"│" SKIP.
	IF client_name[2] <> "" OR op_details[2] <> "" THEN
		PUT UNFORMATTED
			"│" SPACE(6)
			"│" client_name[2] FORMAT "x(30)"
			"│" SPACE(11)
			"│" SPACE(10)
			"│" SPACE(6)
			"│" SPACE(20)
			"│" SPACE(20)
			"│" SPACE(18)
			"│" SPACE(3)
			"│" op_details[2] FORMAT "x(30)"
			"│" SPACE(11)
			"│" SPACE(9)
			"│" SPACE(13)
			"│" SKIP.
	IF op_details[3] <> "" THEN
		PUT UNFORMATTED
			"│" SPACE(6)
			"│" SPACE(30)
			"│" SPACE(11)
			"│" SPACE(10)
			"│" SPACE(6)
			"│" SPACE(20)
			"│" SPACE(20)
			"│" SPACE(18)
			"│" SPACE(3)
			"│" op_details[3] FORMAT "x(30)"
			"│" SPACE(11)
			"│" SPACE(9)
			"│" SPACE(13)
			"│" SKIP.
	PUT UNFORMATTED
		"├──────┼──────────────────────────────┼───────────┼──────────┼──────┼────────────────────┼────────────────────┼──────────────────┼───┼──────────────────────────────┼───────────┼─────────┼─────────────┤" SKIP.

	/* Увеличим номер строки */
	str_num = str_num + 1.
END.

PUT UNFORMATTED	
	"└──────┴──────────────────────────────┴───────────┴──────────┴──────┴────────────────────┴────────────────────┴──────────────────┴───┴──────────────────────────────┴───────────┴─────────┴─────────────┘" SKIP.
