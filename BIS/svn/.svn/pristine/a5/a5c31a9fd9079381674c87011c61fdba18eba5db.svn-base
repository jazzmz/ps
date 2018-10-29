{pirsavelog.p}
/*
		Отчет об операциях по кредитным договорам за операционный день.
		Бурягин Е.П. 16.01.2006 9:26
		
		1. Отчет состоит из 7-и разделов. Каждый раздел реализован в собственном *.i файле. 
		2. Для каждого раздела свое условие отбора документов.
		3. В отчете используется сквозная нумерация строк. 
		4. В 1,2,3 и 4 разделе суммы проводок суммируются и 
		   группируются по валюте в подитоги. 
		5. Все операции, кроме тех, что принадлежат 7-му разделу, 
		   должны быть привязаны к договорам (т.е. иметь субаналитику).
		6. Все строки каждого раздела сортируются:
			 а)1,2,3 и 4 разделы - по номеру договора
			 б)5,6 и 7 - по валюте и номеру договора
		
*/
/* Глобальные объявления */
{globals.i}

/* Библиотека функций для работы с кредитными договорами */
{uloanlib.i}

/* Стандартный вывод в файл */
{setdest.i}

/* Перенос строк */
{wordwrap.def}
{tmprecid.def}        /** Используем информацию из броузера */

/** ОПРЕДЕЛЕНИЯ **/

/* Номер строки */
DEF VAR str_num AS INTEGER INITIAL 1 NO-UNDO.
/* Подытоговые значения */
DEF VAR subtotal_amt_rub AS DECIMAL NO-UNDO.
DEF VAR subtotal_amt_usd AS DECIMAL NO-UNDO.
DEF VAR subtotal_amt_eur AS DECIMAL NO-UNDO.
/* Дата отчета */
DEF VAR report_date AS DATE NO-UNDO.
/* Вывод ошибок библиотеки uloanlib на экран */
DEF VAR traceOn AS LOGICAL INITIAL false NO-UNDO.
/* Номер договора */
DEF VAR loanno AS CHAR NO-UNDO.
/* Дата открытия договора */
DEF VAR loanopendate AS DATE NO-UNDO.

/* Таблица, куда нужно сохранять информацию из найденных проводк и др. мест,
   чтобы с помощью индексов, определенных в ней, можно было выполнить требуемую сортировку.
*/
DEF TEMP-TABLE replines NO-UNDO
	FIELD client_name AS CHAR EXTENT 2
	FIELD loan_no AS CHAR
	FIELD loan_date AS DATE
	FIELD op_no AS CHAR
	FIELD op_acct_db AS CHAR
	FIELD op_acct_cr AS CHAR
	FIELD op_amt AS DECIMAL
	FIELD op_cur AS CHAR
	FIELD op_details AS CHAR EXTENT 3
	FIELD op_user AS CHAR
	FIELD op_contr_user AS CHAR
	FIELD op_done_flag AS CHAR
	INDEX loan loan_no ASCENDING loan_date ASCENDING
	INDEX cur op_cur ASCENDING loan_no ASCENDING loan_date
	INDEX acct_db op_cur ASCENDING op_acct_db ASCENDING.

/** РЕАЛИЗАЦИЯ **/

/* Из первой операции найдем дату отчета */
report_date = TODAY.
FOR FIRST tmprecid NO-LOCK,
		FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK
		:
		report_date = op.op-DATE.
END.

/* Шапка отчета */
PUT UNFORMATTED  "                            Отчет об операциях по кредитным договорам за " report_date skip(1)
	 	"┌──────┬──────────────────────────────┬──────────────────────┬───────────────────────────────────────────────────────────────────────┬──────────────────────────────┬───────────┬─────────┬─────────────┐" SKIP
		"│  №   │ Наименование                 │     КРЕД.ДОГОВОР     │                   ОПЕРАЦИЯ                                            │       Назначение             │Исполнитель│Контролер│  Отметка    │" SKIP
    "│ П/П  │  заемщика                    ├───────────┬──────────┼──────┬────────────────────┬────────────────────┬──────────────────┬───┤        Платежа               │           │         │     о       │" SKIP
		"│      │                              │     №     │    от    │  №   │     Дебет счета    │   Кредит счета     │      Сумма       │Вал│                              │           │         │подтверждении│" SKIP
	 	"└──────┴──────────────────────────────┴───────────┴──────────┴──────┴────────────────────┴────────────────────┴──────────────────┴───┴──────────────────────────────┴───────────┴─────────┴─────────────┘" SKIP.


/* Разделы */
{pirreploanop1.i}
{pirreploanop2.i}
{pirreploanop3.i}
{pirreploanop4.i}
{pirreploanop5.i}
{pirreploanop6.i}
{pirreploanop7.i}

/* Вывод на экран содержимого файла */
{preview.i}

