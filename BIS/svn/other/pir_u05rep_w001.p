{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2011
     Filename: pir_u05rep_w001.p
      Comment: Отчет о закрытых счетах
		- юр.лиц - 405*,406*,407*,40802*,40807*,40814*,40815*
		- физ.лиц - 40817*,40820*,42301*,42601*,40813*,40814* с цифрой "2" в четырнадцатом разряде счета
		- банков - 30109*,30110*,30114*
		Отчет составлен в порядке возрастания балансовых счетов (405*,406* и т.д.)
		и окончаний счетов (последних четырех цифр) без учета кода валюты и ключа
   Parameters: 
       Launch: БМ - Клиенты - Физические лица - Отмечаем любого клиента, Ctrl+G
         Uses:
      Created: Ситов С.А., 05.07.2012
	Basis: #1083 (по письму Капитановой)
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}
{getdates.i}


DEF VAR i AS INT INIT 0 NO-UNDO.
DEF VAR k AS INT INIT 0 NO-UNDO.

DEFINE temp-table reptt NO-UNDO
	FIELD npp		AS INT
	FIELD accttmp		AS CHAR 
	FIELD acct		AS CHAR 
	FIELD acctname		AS CHAR 
	FIELD close-date	AS DATE
	INDEX acct acct 
.


{setdest.i}


FOR EACH acct WHERE 
	acct.close-date >= beg-date /*01/01/90*/ AND acct.close-date <= end-date
	AND CAN-DO ('405*,406*,407*,40802*,40807*,40814*,40815*,40817........2*,40820........2*,42301........2*,42601........2*,40813........2*,40814........2*,30109*,30110*,30114*',acct.acct) 
	AND acct.acct-cat EQ 'b' 
NO-LOCK:

	i = i + 1.

	CREATE reptt.
	ASSIGN
		reptt.npp = i
		reptt.accttmp = STRING(acct.bal-acct) + SUBSTRING(acct.acct,17,4) 
		reptt.acct = acct.acct
		reptt.acctname = acct.Details
		reptt.close-date = acct.close-date	
	.

END.


	/*** ШАПКА ОТЧЕТА ***/
PUT UNFORM FILL(" ",15) " Отчет о счетах, закрытых до " STRING(end-date,"99/99/9999")  " г."  SKIP(1).

PUT UNFORM
		"№п/п"		FORMAT "X(4)"   " | " 
		" Номер счета "	FORMAT "X(20)"  " | "
		" Наменование клиента" FORMAT "X(60)"  " | "
		"Дата закр"	FORMAT "X(10)"  " | "
SKIP(1).


FOR EACH reptt BY reptt.accttmp :

	k = k + 1 .

	PUT UNFORM
		STRING(k)	 FORMAT "X(4)"   " | " 
		reptt.acct    	 FORMAT "X(20)"  " | "
		reptt.acctname	 FORMAT "X(60)"  " | "
		reptt.close-date FORMAT "99/99/9999" " | "
	SKIP.

END.

PUT UNFORM " " SKIP.
PUT UNFORM "ИТОГО: " i SKIP.

{preview.i}

