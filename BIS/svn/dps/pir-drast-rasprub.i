/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-ordrast-rasprub.i
      Comment:  используется при досрочном расторжении вклада 
		для печати распоряжений (в рублях)
		Запускается из pir-ordrast-trans.p
      Created: Sitov S.A., 20.02.2013
	Basis: #1073 
     Modified:  
*/
/* ========================================================================= */


/* ========================================================================= */
			/** Заготовки для печатной формы распоряжения */
/* ========================================================================= */

{get-bankname.i}
{wordwrap.def}

DEF VAR TablShapka01	AS CHAR NO-UNDO.
DEF VAR TablSep01   	AS CHAR NO-UNDO.
DEF VAR TablDno01   	AS CHAR NO-UNDO.
DEF VAR TablShapka02	AS CHAR NO-UNDO.
DEF VAR TablSep02   	AS CHAR NO-UNDO.
DEF VAR TablDno02   	AS CHAR NO-UNDO.

DEF VAR RaspShapka	AS CHAR NO-UNDO.
DEF VAR RaspPreamb	AS CHAR NO-UNDO.
DEF VAR RaspPodpis	AS CHAR NO-UNDO.

DEF VAR RaspTelo10	AS CHAR NO-UNDO.
DEF VAR RaspTelo21	AS CHAR NO-UNDO.
DEF VAR RaspTelo22	AS CHAR NO-UNDO.
DEF VAR RaspTelo23	AS CHAR NO-UNDO.
DEF VAR RaspTelo24	AS CHAR NO-UNDO.
DEF VAR RaspTelo31	AS CHAR NO-UNDO.
DEF VAR RaspTelo32	AS CHAR NO-UNDO.
DEF VAR RaspTelo33	AS CHAR NO-UNDO.
DEF VAR RaspTelo34	AS CHAR NO-UNDO.


DEF VAR tmpStr AS CHAR EXTENT 20 NO-UNDO.
DEF VAR s AS INT NO-UNDO.


	/*** Временная таблица  ***/
DEF TEMP-TABLE reprasp NO-UNDO
	FIELD stb01  AS DEC
	FIELD stb02  AS DATE
	FIELD stb03  AS DATE
	FIELD stb04  AS INT
	FIELD stb05  AS DEC
	FIELD stb06  AS DEC
	FIELD stb07  AS DEC
	FIELD stb08  AS DEC
	FIELD stb09  AS DEC
.

	/**** убрать */
DEF VAR  SumStb06	AS DEC  NO-UNDO.
DEF VAR  SumStb08	AS DEC  NO-UNDO.
DEF VAR  SumStb09	AS DEC  NO-UNDO.

SumStb06 = SumNachPenProc_All + SumDonachPenProc_All.
SumStb08 = SumNachProc_All .	
SumStb09 = SumVplProc_All  .	



/* ========================================================================= */
/* ========================================================================= */
/* ========================================================================= */

FUNCTION GetSumStr RETURNS CHARACTER (
	INPUT SumDig  AS DEC, 
	INPUT SumCurr AS CHAR
	).

	DEF VAR SumStr AS CHAR NO-UNDO.
	DEF VAR AmtStr AS CHAR EXTENT 2  NO-UNDO.

	RUN x-amtstr.p( SumDig, SumCurr, true,true,output amtstr[1], output amtstr[2]).
	SumStr = AmtStr[1] + ' ' + AmtStr[2] .
	SUBSTR(SumStr,1,1) = Caps(SUBSTR(SumStr,1,1)).
	
	SumStr = TRIM(STRING(SumDig,"->>>,>>>,>>>,>>>,>>9.99")) + " (" + SumStr + ") " .


	RETURN SumStr.

END FUNCTION.



/* ========================================================================= */
/* ========================================================================= */
/* ========================================================================= */


TablShapka01 = 
	CHR(10) + FILL(" ", 20) + "ПЕРЕСЧЕТ ПРОЦЕНТОВ ЗА ПЕРИОД С " + STRING(LoanOpDate + 1,"99/99/9999") + " ПО " + STRING(RaspDate,"99/99/9999") + "г." + CHR(10) + 
	"┌───────────────┬─────────────────────┬──────┬──────┬──────────────┬──────┬──────────────┐" + CHR(10) +
	"│ Остаток       │   Расчетный период  │Кол-во│Ставка│ Сумма начис  │Ставка│ Сумма ранее  │" + CHR(10) +
	"│ на счете      ├──────────┬──────────┤ дней │доср. │ ленных процен│по    │ начисленных  │" + CHR(10) +
	"│               │     С    │    ПО    │      │растор│ тов по ставке│дого- │ процентов    │" + CHR(10) +
	"│               │          │          │      │      │ досрочного   │вору  │              │" + CHR(10) +
	"│               │          │          │      │      │ расторжения  │      │              │" + CHR(10) +
	"├───────────────┼──────────┼──────────┼──────┼──────┼──────────────┼──────┼──────────────┤" + CHR(10) +
	"│      1        │     2    │    3     │   4  │  5   │       6      │   7  │       8      │" + CHR(10) +		
	"├───────────────┼──────────┼──────────┼──────┼──────┼──────────────┼──────┼──────────────┤" 
	.

TablSep01 =
	"├───────────────────────────────────────────────────┼──────────────┼──────┼──────────────┤" . 
	.
TablDno01 =
	"│                   ИТОГО                           │" + STRING(SumStb06,">>>,>>>,>>9.99") +  "│      │" + STRING(SumStb08,">>>,>>>,>>9.99") + "│" + CHR(10) +		
	"└───────────────────────────────────────────────────┴──────────────┴──────┴──────────────┘" + CHR(10)
	.

TablShapka02 = 
	CHR(10) + FILL(" ", 20) + "ПЕРЕСЧЕТ ПРОЦЕНТОВ ЗА ПЕРИОД С " + STRING(LoanOpDate + 1,"99/99/9999") + " ПО " + STRING(RaspDate,"99/99/9999") + "г." + CHR(10) +    
	"┌───────────────┬─────────────────────┬──────┬──────┬──────────────┬──────┬──────────────┬──────────────┐" + CHR(10) +
	"│ Остаток       │   Расчетный период  │Кол-во│Ставка│ Сумма начис  │Ставка│ Сумма ранее  │ Сумма ранее  │" + CHR(10) +
	"│ на счете      ├──────────┬──────────┤ дней │доср. │ ленных процен│по    │ начисленных  │ выплаченных  │" + CHR(10) +
	"│               │     С    │    ПО    │      │растор│ тов по ставке│дого- │ процентов    │ процентов    │" + CHR(10) +
	"│               │          │          │      │      │ досрочного   │вору  │              │              │" + CHR(10) +
	"│               │          │          │      │      │ расторжения  │      │              │              │" + CHR(10) +
	"├───────────────┼──────────┼──────────┼──────┼──────┼──────────────┼──────┼──────────────┼──────────────┤" + CHR(10) +
	"│      1        │     2    │    3     │   4  │  5   │       6      │   7  │       8      │       9      │" + CHR(10) +		
	"├───────────────┼──────────┼──────────┼──────┼──────┼──────────────┼──────┼──────────────┼──────────────┤" 
	.
TablSep02 =
	"├───────────────────────────────────────────────────┼──────────────┼──────┼──────────────┼──────────────┤" . 
	.

TablDno02 =
	"│                   ИТОГО                           │" + STRING(SumStb06,">>>,>>>,>>9.99") +  "│      │" + STRING(SumStb08,">>>,>>>,>>9.99") + "│" + STRING(SumStb09,">>>,>>>,>>9.99") + "│" + CHR(10) +		
	"└───────────────────────────────────────────────────┴──────────────┴──────┴──────────────┴──────────────┘" + CHR(10)
	.



RaspShapka =	FILL(" ",60) + "В Департамент 3" + CHR(10) + CHR(10) +
		FILL(" ",60) + cBankName + CHR(10) + CHR(10) +
		FILL(" ",60) + "Дата:" + STRING(RaspDate,"99/99/9999") + CHR(10) + CHR(10) + CHR(10) +
		FILL(" ",30)  + "Р А С П О Р Я Ж Е Н И Е" + CHR(10) + CHR(10) + CHR(10) 
		.

RaspPreamb =	"В связи с досрочным расторжением Договора банковского вклада  №" + LoanNumber + " от " + STRING(LoanOpDate,"99/99/9999") + "г. " + 
		"на основании заявления " + LoanClient + " произвести следующие операции:" + CHR(10) 
		.


RaspPodpis =	CHR(10) + CHR(10) + CHR(10) +
		"Начальник казначейства                " + FILL(" ",32) + "Е.М. Маршева" + CHR(10) + CHR(10) +
		"Ведущий специалист Депозитного отдела " + FILL(" ",32) + "С.В. Балан" 
		.


/* ========================================================================= */
	/**  НЕ БЫЛО НАЧИСЛЕНИЙ  10 */
/* ========================================================================= */

RaspTelo10 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +
        "  2) Начисление процентов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctExp + " на счет " + LoanAcctInt +  " (" + LoanClient + ");" + CHR(10) +
	"  3) Выплата процентов за период с " +
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " в размере " +
	GetSumStr(SumDonachPenProc_All,"") + 
	"на счет " + LoanAcctOut + " (" + LoanClient + ");" + CHR(10)
	.


/* ========================================================================= */
	/**  БЫЛИ НАЧИСЛЕНИЯ. НЕ БЫЛО ВЫПЛАТЫ ПРОЦЕНТОВ 21-24 */
/* ========================================================================= */

RaspTelo21 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +
        "  2) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr( ( SumNachProc_All - SumNachPenProc_All - SumDonachPenProc_All ),"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) +
	"  3) Выплата процентов за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " в размере " +
	GetSumStr( (SumNachPenProc_All + SumDonachPenProc_All) ,"") + 
	" на счет " + LoanAcctOut + " (" + LoanClient + ");" + CHR(10)
	.


RaspTelo22 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +

      (IF SumNachProc_BeforeLast > 0 THEN
       ("  2) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 2) + " год в размере " + 
	GetSumStr(SumNachProc_BeforeLast - SumNachPenProc_BeforeLast,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPODBefLast <> "" then LoanAcctExpSPODBefLast else LoanAcctExp) + ";" + CHR(10) +
        "  3) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" )
      ELSE
       ("  2) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" )
      )	
	+ CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN  "  4) " ELSE  "  3) " )
        + "Начисление процентов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctExp + " на счет " + LoanAcctInt + ";" + CHR(10) +

      (IF SumNachProc_BeforeLast > 0 THEN  "  5) " ELSE  "  4) " )
	+ "Выплата процентов за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " в размере " +
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") + 
	"на счет " + LoanAcctOut + " (" + LoanClient + ");" + CHR(10)
	.


RaspTelo23 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +

      (IF SumNachProc_BeforeLast > 0 THEN
       ("  2) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 2) + " год в размере " + 
	GetSumStr(SumNachProc_BeforeLast - SumNachPenProc_BeforeLast,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPODBefLast <> "" then LoanAcctExpSPODBefLast else LoanAcctExp) + ";" + CHR(10) +
        "  3) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" )
      ELSE	
       ("  2) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" )
      )	
	+ CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN  "  4) " ELSE  "  3) " )
	+ "Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumNachProc_Current - SumNachPenProc_Current - SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) +

      (IF SumNachProc_BeforeLast > 0 THEN  "  5) " ELSE "  4) " )
	+ "Выплата процентов за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " в размере " +
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") + 
	" на счет " + LoanAcctOut + " (" + LoanClient + ");" + CHR(10)
	.


RaspTelo24 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +

      (IF SumNachProc_BeforeLast > 0 THEN
       ("  2) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 2) + " год в размере " + 
	GetSumStr(SumNachProc_BeforeLast - SumNachPenProc_BeforeLast,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) +
        "  3) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + /*LoanAcctExp*/ LoanAcctExpProsh + ";" )
      ELSE	
       ("  2) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + /*LoanAcctExp*/ LoanAcctExpProsh + ";" )
      )	
	+ CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN  "  4) " ELSE  "  3) " )
        + "Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumNachProc_Current - SumNachPenProc_Current - SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) +

      (IF SumNachProc_BeforeLast > 0 THEN  "  5) " ELSE  "  4) " )
	+ "Выплата процентов за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." +
	" в размере " +
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") + 
	" на счет " + LoanAcctOut + " (" + LoanClient + ");" + CHR(10)
	.


/* ========================================================================= */
		/**  БЫЛИ ВЫПЛАТЫ ПРОЦЕНТОВ 31-34 */
/* ========================================================================= */

RaspTelo31 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +
        "  2) Списание со счета " + LoanAcctOut + " на счет " + LoanAcctInt + "денежных средств в сумме " +
	GetSumStr(SumVplProc_All - SumNachPenProc_All - SumDonachPenProc_All,"") + 
	"как возмещение разницы между выплаченными ранее процентами за период с " +
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(PerVplEndDateRasp,"99/99/9999") + "г." +	" вкл. в размере " + 
	GetSumStr(SumVplProc_All,"") + 
	"и причитающимися процентами за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") +
	" в соответствии с условиями Договора;" + CHR(10) + 
        "  3) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumNachProc_All - SumNachPenProc_All - SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) 
	.


RaspTelo32 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +
        "  2) Списание со счета " + LoanAcctOut + " на счет " + LoanAcctInt + "денежных средств в сумме " +
	GetSumStr(SumVplProc_All - SumNachPenProc_All - SumDonachPenProc_All,"") + 
	"как возмещение разницы между выплаченными ранее процентами за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(PerVplEndDateRasp,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumVplProc_All ,"") + 
	"и причитающимися процентами за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") + 
	" в соответствии с условиями Договора;" + CHR(10) + 
        "  3) Начисление процентов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctExp + "на счет " + LoanAcctInt + ";" + CHR(10) +
        "  4) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1)+ " год в размере " + 
	GetSumStr(SumNachProc_All - SumNachPenProc_All - SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctInt + "на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" + CHR(10) 
	.


RaspTelo33 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +
        "  2) Cписание со счета " + LoanAcctOut + " на счет " + LoanAcctInt + "денежных средств в сумме " +
	GetSumStr(SumVplProc_All - SumNachPenProc_All - SumDonachPenProc_All,"") + 
	"как возмещение разницы между выплаченными ранее процентами за период c " +
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(PerVplEndDateRasp,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumVplProc_All,"") + 
	"и причитающимися процентами за период c " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") + 
	" в соответствии с условиями Договора;" + CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN
       ("  3) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 2) + " год в размере " + 
	GetSumStr(SumNachProc_BeforeLast - SumNachPenProc_BeforeLast,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPODBefLast <> "" then LoanAcctExpSPODBefLast else LoanAcctExp) + ";" + CHR(10) +
        " 4) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" )
      ELSE
       ("  3) СПОД. Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + (if LoanAcctExpSPOD <> "" then LoanAcctExpSPOD else LoanAcctExp) + ";" )
      )	
	+ CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN  "  5) " ELSE  "  4) " )
        + "Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumNachProc_Current - SumNachPenProc_Current - SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) 
	.


RaspTelo34 = 
	"  1) Возврат вклада в сумме " + 
	GetSumStr(AmtOsn,"") + 
	"со счета " + LoanAcct + " на счет " + LoanAcctOut +  " (" + LoanClient + ");" + CHR(10) +
        "  2) Списание со счета " + LoanAcctOut + " на счет " + LoanAcctInt + "денежных средств в сумме " +
	GetSumStr(SumVplProc_All - SumNachPenProc_All - SumDonachPenProc_All,"") + 
	"как возмещение разницы между выплаченными ранее процентами за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(PerVplEndDateRasp,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumVplProc_All ,"") + 
	"и причитающимися процентами за период с " + 
	STRING(LoanOpDate + 1,"99/99/9999") + " по " + STRING(RaspDate,"99/99/9999") + "г." + " вкл. в размере " + 
	GetSumStr(SumNachPenProc_All + SumDonachPenProc_All,"") + 
	" в соответствии с условиями Договора;" + CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN
       ("  3) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 2) + " год в размере " + 
	GetSumStr(SumNachProc_BeforeLast - SumNachPenProc_BeforeLast,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10) +
        "  4) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" )
      ELSE
       ("  3) Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate) - 1) + " год в размере " + 
	GetSumStr(SumNachProc_Last - SumNachPenProc_Last,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" )
      )	
	+ CHR(10) + 

      (IF SumNachProc_BeforeLast > 0 THEN  "  5) " ELSE  "  4) " )
        + "Возврат излишне признанных расходов за " + STRING(YEAR(RaspDate)) + " год в размере " + 
	GetSumStr(SumNachProc_Current - SumNachPenProc_Current - SumDonachPenProc_All,"") + 
	"со счета " + LoanAcctInt + " на счет " + LoanAcctExp + ";" + CHR(10)
	.



/* ========================================================================= */
/* ========================================================================= */
/* ========================================================================= */

MESSAGE "Случай расторжения по тех.заданию = " iParam VIEW-AS ALERT-BOX.

CASE iParam :
    WHEN 10 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo10 .
    END.
    WHEN 21 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo21 .
    END.
    WHEN 22 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo22 .
    END.
    WHEN 23 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo23 .
    END.
    WHEN 24 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo24 .
    END.
    WHEN 31 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo31 .
    END.
    WHEN 32 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo32 .
    END.
    WHEN 33 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo33 .
    END.
    WHEN 34 THEN DO:
	tmpStr[1] =  RaspPreamb + RaspTelo34 .
    END.
END CASE.


/* ========================================================================= */
/* ========================================================================= */
/* ========================================================================= */



/* ========================================================================= */
			/** создаем таблицу для распоряжения */
/* ========================================================================= */

FOR EACH repkau :

  IF repkau.stb14 <> "vpl" THEN
  DO:
    CREATE reprasp .
    ASSIGN
	reprasp.stb01 = repkau.stb01
	reprasp.stb02 = repkau.stb02
	reprasp.stb03 = repkau.stb03
	reprasp.stb04 = repkau.stb04
	reprasp.stb05 = repkau.stb11
	reprasp.stb06 = repkau.stb12
	reprasp.stb07 = repkau.stb05
	reprasp.stb08 = repkau.stb07
	reprasp.stb09 = 0
    .	
  END.
  ELSE
  DO:
    ASSIGN
	reprasp.stb09 = repkau.stb09
    .
  END.

END.



/* ========================================================================= */
			/** Печатная форма распоряжения */
/* ========================================================================= */

{setdest.i}

PUT UNFORM RaspShapka SKIP.
	
{wordwrap.i &s=tmpStr &n=20 &l=100}
DO s = 1 TO 20 :
  IF tmpStr[s] <> "" THEN
    	PUT UNFORM tmpStr[s] SKIP.
END.


CASE iParam :
    WHEN 10 OR WHEN 21 OR WHEN 22 OR WHEN 23 OR WHEN 24 THEN DO:
	PUT UNFORM TablShapka01 	SKIP.	
    END.
    WHEN 31 OR WHEN 32 OR WHEN 33 OR WHEN 34 THEN DO:
	PUT UNFORM TablShapka02 	SKIP.	
    END.
END CASE.



FOR EACH reprasp :

      PUT UNFORM  "│"
	STRING(reprasp.stb01,">>>>,>>>,>>9.99")   "│"  
	STRING(reprasp.stb02,"99/99/9999")        "│"
	STRING(reprasp.stb03,"99/99/9999")        "│"
	STRING(reprasp.stb04,">>>>>9")            "│"
	STRING(reprasp.stb05,">>9.99")            "│"
	STRING(reprasp.stb06,">>>,>>>,>>9.99")    "│"
	STRING(reprasp.stb07,">>9.99")            "│"
	STRING(reprasp.stb08,">>>,>>>,>>9.99")    "│"
	(IF iParam = 31 OR iParam = 32 OR iParam = 33 OR iParam = 34
	THEN (STRING(reprasp.stb09,">>>,>>>,>>9.99")  +  "│")
	ELSE "") 
      SKIP.

END.


CASE iParam :
    WHEN 10 OR WHEN 21 OR WHEN 22 OR WHEN 23 OR WHEN 24 THEN DO:
	PUT UNFORM TablSep01	SKIP.	
	PUT UNFORM TablDno01	SKIP.	
    END.
    WHEN 31 OR WHEN 32 OR WHEN 33 OR WHEN 34 THEN DO:
	PUT UNFORM TablSep02	SKIP.	
	PUT UNFORM TablDno02	SKIP.	
    END.
END CASE.

PUT UNFORM RaspPodpis SKIP.

{preview.i}
