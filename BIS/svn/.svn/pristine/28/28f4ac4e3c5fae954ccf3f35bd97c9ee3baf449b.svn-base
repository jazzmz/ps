/*
		Погашение процентов за кредиты.
		Третий раздел отчета по операциям по кредитным договорам.
		Бурягин Е.П., 16.01.2006 15:08
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
	/* Операция по погашению процентов по кредиту - это операция под номером 10 и 36
	   Она должна быть прописана в поле kau-cr (субаналитика по кредиту) проводки.
	   Формат записи в этом поле такой: "Кредит,<НОМЕР_ДОГОВОРА>,<НОМЕР_ОПЕРАЦИИ>".
	*/
	IF op-entry.kau-cr <> "" THEN
		IF NUM-ENTRIES(op-entry.kau-cr) = 3 THEN
			IF ENTRY(1,op-entry.kau-cr) = "Кредит" AND CAN-DO("10,36,371",ENTRY(3, op-entry.kau-cr)) THEN
				DO:

					/* Сохраним номер договора в переменную */
					loanno = ENTRY(2,op-entry.kau-cr).
					
					/* Создаем строку */
					CREATE replines.
					/* Дата открытия договора */
					loanopendate = DATE(GetCredLoanInfo_ULL(loanno,"open_date", traceOn)).
					/* Заполним значения */
					ASSIGN
					replines.client_name[1] = GetCredLoanInfo_ULL(loanno,"client_name", traceOn)
					replines.loan_no = loanno
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
					IF replines.op_cur = "978" THEN subtotal_amt_eur = subtotal_amt_eur + replines.op_amt.
					{wordwrap.i &s=replines.client_name &l=30 &n=2}
					{wordwrap.i &s=replines.op_details &l=30 &n=3}

				END.
END.

/* Заполнили временную таблицу, теперь выведем ее на экран */

PUT UNFORMATTED	
	"  3) П О Г А Ш Е Н И Е   П Р О Ц Е Н Т О В   З А   К Р Е Д И Т" SKIP
	"┌──────┬──────────────────────────────┬───────────┬──────────┬──────┬────────────────────┬────────────────────┬──────────────────┬───┬──────────────────────────────┬───────────┬─────────┬─────────────┐" SKIP.

FOR EACH replines 
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
	"│      │                              │           │          │      │                    │    ИТОГО(проценты):│" subtotal_amt_rub FORMAT ">>>,>>>,>>>,>>9.99" 
																																																																   "│810│                              │           │         │             │" SKIP 
	"│      │                              │           │          │      │                    │                    │" subtotal_amt_usd FORMAT ">>>,>>>,>>>,>>9.99" 
																																																																   "│840│                              │           │         │             │" SKIP 
	"│      │                              │           │          │      │                    │                    │" subtotal_amt_eur FORMAT ">>>,>>>,>>>,>>9.99" 
																																																																   "│978│                              │           │         │             │" SKIP 

	"└──────┴──────────────────────────────┴───────────┴──────────┴──────┴────────────────────┴────────────────────┴──────────────────┴───┴──────────────────────────────┴───────────┴─────────┴─────────────┘" SKIP.
