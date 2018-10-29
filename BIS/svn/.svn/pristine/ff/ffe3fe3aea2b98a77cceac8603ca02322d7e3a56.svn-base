{pirsavelog.p}

/** 
		Отчет крупных клиентов.
 		Крупным клиентом в рамках данного отчета являются клиенты,
 		обороты по счетам которых:
 		1) через кассу
 		2) через корс.счет
 		максимальны, относительно других клиентов.
 		На самом деле процедура собирает результаты по всем клиентам,
 		сортирует их по убыванию оборотов и выводит на экран только 
 		заданное число первых клиентов по списку, например, первых 10 клиентов.
 		
 		Бурягин Е.П., 27.10.2006 10:18
 */
  
 {globals.i}
 
 /** Таблица, в которой будем хранить результаты */
 DEF TEMP-TABLE tt-result NO-UNDO
 		FIELD clientName AS CHAR
 		FIELD type AS INT /* 1 = кассовые, 2 = через корс.счет */
 		FIELD oborotDB AS DECIMAL
 		FIELD oborotCR AS DECIMAL
 		FIELD oborotFULL AS DECIMAL
 		INDEX fullDESC type oborotFULL DESCENDING
 .

/** Переменные */
DEF VAR tmpDEC AS DECIMAL EXTENT 10.
DEF VAR i AS INTEGER.
DEF VAR j AS INTEGER.

DEF VAR acctList AS CHAR INIT "20202,30102".

/** Запрашиваем период */ 
{getdates.i} 
 
 
/** Клиенты юридические лица */
FOR EACH cust-corp NO-LOCK
		:

			{pirbigclient.i &cust-cat="Ю" &cust-id="cust-corp.cust-id" &clientName="cust-corp.name-corp"}
			
END.

/** Клиенты физики лица */
FOR EACH person WHERE NO-LOCK
		:

			{pirbigclient.i &cust-cat = "Ч" &cust-id="person.person-id" &clientName="person.name-last + ' ' + person.first-names"}
			
END.


{setdest.i}

DO i = 1 TO NUM-ENTRIES(acctList) :
	
	j = 1.

	PUT UNFORMATTED 
	"Клиент                                 |Через   |Оборот ДБ          |Оборот КР          |Всего оборотов     " SKIP
	"---------------------------------------------------------------------------------------------------------" SKIP.

	FOR EACH tt-result USE-INDEX fullDESC WHERE tt-result.type = i AND oborotFULL > 0 WHILE j < 10:
		PUT UNFORMATTED tt-result.clientName FORMAT "x(40)"
									ENTRY(tt-result.type, acctList) FORMAT "x(7)"
									tt-result.oborotDB FORMAT "->>>,>>>,>>>,>>9.99"
									tt-result.oborotCR FORMAT "->>>,>>>,>>>,>>9.99"
									tt-result.oborotFULL FORMAT "->>>,>>>,>>>,>>9.99" 
									SKIP.
		j = j + 1.
	END.
	
END.
{preview.i}



		
