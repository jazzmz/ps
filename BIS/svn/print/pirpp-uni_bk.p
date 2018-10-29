/* 27.02.2013 Гончаров А.Е.
ООО ПИР Банк
По заявке #2542 наделяем платёжки по КБ пародией на интеллект,
которая состоит в том, что если платёж идёт на банк (кредитуемые
счета 706*, 474*, 45*, 60*, 0000*), то печатаем штамп по КБ без
слова "ИСПОЛНЕНО". */

def input parameter RecOp as recid no-undo.
def var input-proc as char no-undo.

find first op where recid(op) eq RecOp no-lock no-error.
/* if not can-do ("01КЛ", doc-type) then do:              */
		        for each op-entry where op-entry.op = op.op NO-LOCK:
				if can-do ("706*", op-entry.acct-cr) or 
				can-do ("474*", op-entry.acct-cr) or 
				can-do ("45*", op-entry.acct-cr) or 
				can-do ("60*", op-entry.acct-cr) or 
				can-do ("0000*", op-entry.acct-cr) then 
			input-proc = "pirpp-uni_bk_int".
			else input-proc = "pirpp-uni_bk_other".
		end.
		If SEARCH(input-proc + ".r") <> ? then run VALUE (input-proc + ".r")(recop).
		else run VALUE(input-proc + ".p")(recop). 
/* message "Документ: " op.doc-num "Процедура: " input-proc view-as alert-box. */

/* end. */
