{pirsavelog.p}

/*
               Банковская интегрированная система БИСквит
    Copyright: (C) АиПО Смоленского филиала ОАО АКБ АВТОБАНК-НИКОЙЛ
     Filename: lg6001.p
      Comment: Процедура обработки кода 6001 классификатора ОпОтмыв.
               
   Parameters:
         Uses:
      Used BY:
      Created: 20/12/2004 BEP (Бурягин Евгений Петрович)
     Modified:
         Note: 
*/

DEFINE INPUT  PARAMETER iOp LIKE op.op NO-UNDO.
DEFINE OUTPUT PARAMETER oOk AS LOGICAL NO-UNDO INIT false.

{globals.i}

/************ bep: 6001 start impl **************************************/

/* логировать или не логировать - вот в чем вопрос :) */
&GLOBAL-DEFINE logon 0

/* переменные для храниения значений реквизитов документа iOp */
def var DbAccount as char init "" NO-UNDO. 				/* счет по дебету */
def var CrAccount as char init "" NO-UNDO.				/* счет по кредиту */
def var BenAccount as char init ""  NO-UNDO.				/* значение р/с другого банка */
def var ClientName as char init "" NO-UNDO.  /* ФИО клиента из доп.реквизита документа, который передан из фильтра */
def var ClientName2 as char init ""  NO-UNDO. /* ФИО клиента из доп.реквизита документа, который сверяется с документом из фильтра */
def var DateDocument as date NO-UNDO.					/* дата документа */

def var TotalSumma as decimal init 0 NO-UNDO.			/* общая сумма всех документов в группе */
def var TotalCount as int init 0 NO-UNDO.				/* общее кол-во всех документов в группе */
def var MaxSumma as decimal init 600000 NO-UNDO.		/* порог суммы по коду 6001 */

&if {&logon} = 1 &then
/* объявляем поток в файл протокола */
def stream log.
def var LogName as char init "" NO-UNDO.
LogName = "lg6001.log".
output stream log to value(LogName) append.
&endif

put screen col 1 row 23 "Сравнение операции op=" + string(iOp) + "...".

/* 1.сохраним реквизиты текущего документа в переменные */
find first op where op.op = iOp no-lock.
ClientName = GetXAttrValueEx("op", STRING(op), "ФИО", "").
DateDocument = op.op-date.
find first op-entry where op-entry.op = op.op no-lock.
find first acct where acct.acct = op-entry.acct-db no-lock no-error.
if avail acct then
	DbAccount = acct.acct.
find first acct where acct.acct = op-entry.acct-cr no-lock no-error.
if avail acct then
	CrAccount = acct.acct.

/* 2.сравниваем текущий документ в другими в том же операционном дне */
&if {&logon} = 1 &then
put stream log TODAY format "99/99/9999" " " STRING(TIME,"HH:MM:SS") ": Сравнение op=" op.op " doc-num=" op.doc-num " :" ClientName format "x(40)" skip.
&endif

for each op where 	
            op.op-date = DateDocument
            no-lock,
    first op-entry of op where                    
						op-entry.acct-db = DbAccount
						and
						op-entry.acct-cr = CrAccount 
	          no-lock
	:
	ClientName2 = GetXAttrValueEx("op", string(op.op), "ФИО", "").
	
	
	put screen col 1 row 24 "с операцией op=" + string(op.op).

	if (ClientName2 = ClientName) then do:
	
		
			TotalSumma = TotalSumma + amt-rub.
			TotalCount = TotalCount + 1.
	
			&if {&logon} = 1 &then
			put stream log "Найдена операция op=" op.op " doc-num=" op.doc-num 
				" acct-db=" op-entry.acct-db
				" acct-cr=" op-entry.acct-cr
				" ФИО=" 
				" summa=" op-entry.amt-rub format "->>>,>>>,>>9.99" skip.
			&endif
	
	end.

end.	

&if {&logon} = 1 &then
put stream log "Всего: кол-во=" TotalCount " Сумма=" TotalSumma format "->>>,>>>,>>9.99" skip.
&endif

if TotalSumma > MaxSumma and TotalCount > 1 then
	do:
	oOk = true.
	
	&if {&logon} = 1 &then
	put stream log "Помечен=Да" skip "---------------------------------------" skip. 
	&endif

	end.
else 
	do:
	oOk = false.

	&if {&logon} = 1 &then
	put stream log "Помечен=нет" skip "---------------------------------------" skip. 
	&endif

	end.
put screen col 1 row 23 "                          ".	
/************ bep: end impl *********************************************/ 

&if {&logon} = 1 &then
output stream log close.
&endif