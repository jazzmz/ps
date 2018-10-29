/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-ordrast-trans.p
      Comment: Процедура используется при досрочном расторжении вклада
		Используется с входными параметрами. 
		Запускается из транзакции досрочного расторжения или процедуры 
   Parameters: описаны ниже
       Launch: 
         Uses: pir-dps-tblkau.i - строим талицу по аналитике и проходимся по ней 
		pir-drast-rasprub.i - печать распоряжения
      Created: Sitov S.A., 20.02.2013
	Basis: #1073 
     Modified:  
*/
/* ========================================================================= */



{globals.i}		/** Глобальные определения */
{ulib.i}		/** Библиотека ПИР-функций */
{sh-defs.i}

/* ========================================================================= */
				/** Объявления */
/* ========================================================================= */

  /* Входные и выходные параметры процедуры */
DEF INPUT PARAM LoanNumber	AS CHAR  NO-UNDO.	/* номер договора */
DEF INPUT PARAM RaspDate	AS DATE  NO-UNDO.	/* дата расторжения */
DEF INPUT PARAM RatePen		AS DEC   NO-UNDO.	/* штрафная проц ставка */
DEF INPUT PARAM SPODDate	AS DATE  NO-UNDO.	/* дата СПОД */
DEF INPUT PARAM ShowTabl	AS LOGICAL NO-UNDO.	/* показывать расчет */
DEF INPUT PARAM ShowRasp	AS LOGICAL NO-UNDO.	/* печать распоряжений */
DEF OUTPUT PARAM Result AS CHAR NO-UNDO.

{pir-drast-trans.def}


/* ========================================================================= */
				/** Реализация */
/* ========================================================================= */
/*
message 
  " Вход для drast-trans-v.p " 
  " LoanNumber  = " LoanNumber
  " RaspDate    = " RaspDate  
  " RatePen     = " RatePen   
  " SPODDate    = " SPODDate
  " ShowTabl    = " ShowTabl 
  " ShowRasp    = " ShowRasp 
view-as alert-box.
*/

FIND FIRST trloan 
   WHERE trloan.contract = "dps"
   AND   trloan.cont-code = LoanNumber
NO-LOCK NO-ERROR.


/****************************************************************************/
	/* определяем информацию по договору */
/****************************************************************************/

LoanCurrency = trloan.currency .
LoanOpDate  = trloan.open-date .
LoanClient  = GetClientInfo_ULL("Ч," + STRING(trloan.cust-id), "name", false) .

  /* 423 */
LoanAcct    = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-dps-t', trloan.open-date, false).
  /* 47411 */
LoanAcctInt = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-dps-int', trloan.open-date, false).
  /* 70606 - может поменяться. нам нужен только для распоряжения на дату распоряжения */ 
LoanAcctExp = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-expens', RaspDate, false).
  /* 40817 - может поменяться. надо определять его для каждого периода  */
LoanAcctOut = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-dps-out', trloan.open-date, false).
  /* текущий loan-dps-cur */	
LoanAcctCur = "" .
  /* СПОД !!! пока так */
LoanAcctExpSPOD = (IF RaspDate > SPODDate THEN LoanAcctExp ELSE (if substring(LoanAcct,1,3) = '426' then '70706810600002160202' else '70706810700002160102') ) .
LoanAcctExpSPODBefLast = (IF LoanCurrency = "" THEN '70701810600001720101' ELSE '70701810900001720102' ) .
LoanAcctExpProsh = (IF RaspDate > SPODDate AND year(RaspDate) = year(LoanOpDate) THEN LoanAcctExp ELSE '70601810900001720105' ) .


  /* Остаток вклада на дату расторжения */
RUN acct-pos IN h_base (LoanAcct, LoanCurrency, RaspDate - 1 , RaspDate - 1 , CHR(251) ) .
AmtOsn = IF LoanCurrency = "" THEN ABS(sh-bal) ELSE ABS(sh-val) .

	/* Ставка До востребования */
IF RatePen = ? OR RatePen = 0 THEN
   RatePen = GetDpsCommission_ULL(LoanNumber, 'pen-commi', RaspDate, false) .
ELSE 
   RatePen = RatePen / 100 .

KursRaspDate = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , RaspDate) . 

/****************************************************************************/
	/*  заполняем таблицу по аналитике до даты расторжения */
/****************************************************************************/

  /* строим таблицу по аналитике и проходимся по ней */
{pir-dps-tblkau.i}


/****************************************************************************/
	/*  получаем новую рабочую таблицу */
/****************************************************************************/

FOR EACH tblkau :

  IF tblkau.Op-ContractDate = LoanOpDate AND tblkau.KauEntry-Kau = 'ОстВклС' 
  THEN  NEXT.

  n = n + 1 .


/****/
if  n = 11 then next.
/*****/

	/* отбираем все, кроме выплат процентов */
  IF NOT ( tblkau.KauEntry-AcctDb = LoanAcctInt AND tblkau.KauEntry-AcctCr BEGINS SUBSTRING(LoanAcctOut,1,5) )  THEN
  DO:

    i = i + 1 .
    FlgNach = yes .

	/* начало и конец периода начисления */ 
    PerBegDate = ( IF i = 1 THEN LoanOpDate + 1 ELSE PerEndDate + 1 ).
    PerEndDate = tblkau.Op-ContractDate .
    PerKolDay  = PerEndDate - PerBegDate + 1 .

	/* сумма остатка на счете на конец периода */ 
    RUN acct-pos IN h_base (LoanAcct, LoanCurrency, (PerEndDate - 1), (PerEndDate - 1), CHR(251) ) .
    PerEndOstAcct = IF LoanCurrency = "" THEN ABS(sh-bal) ELSE ABS(sh-val).

	/* ставка по договору на конец периода начисления */ 
    RateNorm = GetDpsCommission_ULL(LoanNumber, 'commission', PerEndDate, false) .

	/* временная база начисления на конец периода */
    LoanIntSchBase = GetLoanIntSchBase(PerEndDate) . 

	/* дата проводки. на эту дату мы берем курс */
    PerEndKursDate = tblkau.KauEntry-OpDate .
	/* курс валюты на дату проводки  tblkau.KauEntry-OpDate */
    PerEndKurs = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , PerEndKursDate) . 


	/* сумма начисленных процентов на конец периода */ 
    IF (tblkau.KauEntry-Kau = 'ОстВклС') OR (tblkau.KauEntry-Kau = 'НачПр' AND FlgRazb = yes ) THEN
    DO:
  	    /* было изменение остатка, тогда надо рассчитать */
	PerEndSumNach    = ROUND( PerEndOstAcct * PerKolDay * RateNorm / LoanIntSchBase , 2) .
	PerEndSumNachEqv = IF LoanCurrency = "" THEN 0 ELSE ROUND( PerEndSumNach * PerEndKurs, 2) . 
	FlgRazb = yes .
    END.
    ELSE
    DO:
	PerEndSumNach    = IF LoanCurrency = "" THEN tblkau.KauEntry-AmtRub ELSE tblkau.KauEntry-AmtCur .
	PerEndSumNachEqv = IF LoanCurrency = "" THEN 0 ELSE tblkau.KauEntry-AmtCur .
	FlgRazb = no .
    END.


	/* сумма процентов пересчитанных по ставке до востребования за период */
    PerEndSumNachPen    = ROUND( PerEndOstAcct * PerKolDay * RatePen / LoanIntSchBase , 2).
    PerEndSumNachPenEqv = IF LoanCurrency = "" THEN 0 ELSE ROUND( PerEndSumNachPen * PerEndKurs, 2) .


	/* заполняем таблицу */
    CREATE repkau .
    ASSIGN
	repkau.stb00 = n
	repkau.stb01 = PerEndOstAcct	/* остаток вклада на конец периода */
	repkau.stb02 = PerBegDate	/* начало периода начисления */
	repkau.stb03 = PerEndDate	/* конец  периода начисления */
	repkau.stb04 = PerKolDay        /* количество дней в периоде */
	repkau.stb05 = RateNorm * 100	/* % ставка по договору на дату */   
	repkau.stb06 = RatePen * 100	/* % ставка досрочного расторжения */
	repkau.stb07 = PerEndKursDate	/* дата проводки, на эту дату определяем курс */
	repkau.stb08 = PerEndKurs	/* курс */
	repkau.stb09 = PerEndSumNach        /* сумма в вал дог = сумма %-ов по ставке договора */
	repkau.stb10 = PerEndSumNachEqv     /* сумма в эквив   = сумма %-ов по ставке договора */    
	repkau.stb11 = PerEndSumNachPen     /* сумма в вал дог = сумма %-ов пересчитанных по ставке ДВ */      
	repkau.stb12 = PerEndSumNachPenEqv  /* сумма в эквив   = сумма %-ов пересчитанных по ставке ДВ */      
	repkau.stb13 = "novpl"		/* тип = не выплаты процентов */
    .                       

  END.  /* закончили отбирать все, кроме выплат процентов */

  
	/* отбираем выплаченные проценты */ 
  IF ( tblkau.KauEntry-AcctDb = LoanAcctInt AND tblkau.KauEntry-AcctCr BEGINS SUBSTRING(LoanAcctOut,1,5) ) THEN
  DO:

    j = j + 1 .
    FlgVpl  = yes .

    PerVplBegDate = ( IF j = 1 THEN LoanOpDate + 1 ELSE PerVplEndDate + 1 ).

    IF  DAY(tblkau.Op-ContractDate) = 5 OR DAY(tblkau.Op-ContractDate) = 7 THEN
	PerVplEndDate = tblkau.Op-ContractDate - DAY(tblkau.Op-ContractDate) .
    ELSE
	PerVplEndDate = tblkau.Op-ContractDate .

    PerKolDay  = PerVplEndDate - PerVplBegDate + 1 .

	/* ставка по договору на конец периода начисления */ 
    RateNorm = GetDpsCommission_ULL(LoanNumber, 'commission', PerEndDate, false) .
	/* временная база начисления на конец периода */
    LoanIntSchBase = GetLoanIntSchBase(PerEndDate) . 
	/* дата проводки. на эту дату мы берем курс */
    PerEndKursDate = tblkau.KauEntry-OpDate .
	/* курс валюты на дату проводки  tblkau.KauEntry-OpDate */
    PerEndKurs = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , PerEndKursDate) . 

	/* сумма %-ов по ставке договора в валюте договора и в эквиваленте */
    PerEndSumVpl    = IF LoanCurrency = "" THEN tblkau.KauEntry-AmtRub ELSE tblkau.KauEntry-AmtCur .
    PerEndSumVplEqv = IF LoanCurrency = "" THEN 0 ELSE tblkau.KauEntry-AmtRub .


	/* заполняем таблицу */
    CREATE repkau .
    ASSIGN
	repkau.stb00 = n
	repkau.stb01 = 0		/* остаток вклада на конец периода */
	repkau.stb02 = PerVplBegDate	/* начало периода начисления */
	repkau.stb03 = PerVplEndDate	/* конец  периода начисления */
	repkau.stb04 = PerKolDay        /* количество дней в периоде */
	repkau.stb05 = RateNorm * 100	/* % ставка по договору на дату */   
	repkau.stb06 = RatePen * 100	/* % ставка досрочного расторжения */
	repkau.stb07 = PerEndKursDate	/* дата проводки, на эту дату определяем курс */
	repkau.stb08 = PerEndKurs	/* курс */
	repkau.stb09 = PerEndSumVpl      /* сумма в вал дог = сумма %-ов по ставке договора */
	repkau.stb10 = PerEndSumVplEqv   /* сумма в эквив   = сумма %-ов по ставке договора */    
	repkau.stb11 = 0 		 /* сумма в вал дог = сумма %-ов пересчитанных по ставке ДВ */      
	repkau.stb12 = 0 		 /* сумма в эквив   = сумма %-ов пересчитанных по ставке ДВ */      
	repkau.stb13 = "vpl"		/* тип = выплата процентов */
	repkau.stb14 = 	PerEndSumVplEqv - (PerEndSumVpl * KursRaspDate)
    .                       
/*
message
  " PerEndSumVplEqv = " PerEndSumVplEqv 
  " PerEndSumVpl = " PerEndSumVpl
  " KursRaspDate = " KursRaspDate
view-as alert-box.
*/
  END.

END.



/****************************************************************************/
	/*  последнюю строку рассчитываем отдельно - доначисление */
/****************************************************************************/

n = n + 1 .

	/* начало и конец периода начисления */ 
PerBegDate = ( IF n = 1 THEN LoanOpDate + 1 ELSE PerEndDate + 1 ).
PerEndDate = RaspDate .
PerKolDay  = PerEndDate - PerBegDate + 1 .

	/* сумма остатка на счете на конец периода */ 
RUN acct-pos IN h_base (LoanAcct, LoanCurrency, (PerEndDate - 1), (PerEndDate - 1), CHR(251) ) .
PerEndOstAcct = IF LoanCurrency = "" THEN ABS(sh-bal) ELSE ABS(sh-val).

	/* временная база начисления */
LoanIntSchBase = GetLoanIntSchBase(PerEndDate) . 

	/* сумма доначисленных процентов по ставке до востребования */
IF LoanCurrency = "" THEN
DO:
  PerEndSumDonachPen    = ROUND( PerEndOstAcct * PerKolDay * RatePen / LoanIntSchBase , 2).
  PerEndSumDonachPenEqv = 0 .
END.
ELSE
DO:
	/* курс валюты на дату проводки  - дата расторжения вклада */
  PerEndKursDate = RaspDate .
  PerEndKurs = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , PerEndKursDate) . 
  PerEndSumDonachPen    = ROUND( PerEndOstAcct * PerKolDay * RatePen / LoanIntSchBase , 2).
  PerEndSumDonachPenEqv = ROUND( PerEndSumDonachPen * PerEndKurs, 2) . 
END.

	/* заполняем таблицу */
CREATE repkau .
ASSIGN
	repkau.stb00 = n
	repkau.stb01 = PerEndOstAcct	/* остаток вклада на конец периода */
	repkau.stb02 = PerBegDate	/* начало периода начисления */
	repkau.stb03 = PerEndDate	/* конец  периода начисления */
	repkau.stb04 = PerKolDay        /* количество дней в периоде */
	repkau.stb05 = RateNorm * 100	/* % ставка по договору на дату */   
	repkau.stb06 = RatePen * 100	/* % ставка досрочного расторжения */
	repkau.stb07 = PerEndKursDate	/* дата проводки, на эту дату определяем курс */
	repkau.stb08 = PerEndKurs	/* курс */
	repkau.stb09 = 0		     /* сумма в вал дог = сумма %-ов по ставке договора */
	repkau.stb10 = 0		     /* сумма в эквив   = сумма %-ов по ставке договора */    
	repkau.stb11 = PerEndSumDonachPen    /* сумма в вал дог = сумма %-ов пересчитанных по ставке ДВ */      
	repkau.stb12 = PerEndSumDonachPenEqv /* сумма в эквив   = сумма %-ов пересчитанных по ставке ДВ */      
	repkau.stb13 = "donach"		/* тип = доначисление процентов */
.                       

	/*  закончили рассчитывать последнюю строку  */
/****************************************************************************/




/****************************************************************************/
	/*  определяем итоговые суммы   */
/****************************************************************************/

FOR EACH repkau :

	/* определяем итоговые суммы выплаченных процентов 
	за весь период, текущий год, прошлый год, позапрошлый год и ранее */
  IF repkau.stb13 = "vpl" THEN
  DO:

	PerVplEndDateRasp = repkau.stb03 .

	   /* выплаченные проценты по ставке договора */
	SumVplProc_iter = repkau.stb09 . 
	SumVplProc_All  = SumVplProc_All + SumVplProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumVplProc_Current = SumVplProc_Current + SumVplProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumVplProc_Last = SumVplProc_Last + SumVplProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumVplProc_BeforeLast = SumVplProc_BeforeLast + SumVplProc_iter .


	   /* выплаченные проценты, пересчитанные по ставе до востребования */
	SumVplPenProc_iter =  repkau.stb11 . 
	SumVplPenProc_All = SumVplPenProc_All + SumVplPenProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumVplPenProc_Current = SumVplPenProc_Current + SumVplPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumVplPenProc_Last = SumVplPenProc_Last + SumVplPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumVplPenProc_BeforeLast = SumVplPenProc_BeforeLast + SumVplPenProc_iter .

	  /* учет дохода-расхода */
	SumDohodRashod_Iter = repkau.stb14 . 
	SumDohodRashod_All = SumDohodRashod_Iter + repkau.stb14 .

  END.


	/* определяем итоговые суммы начисленных, пересчитанных начисленных процентов 
	за весь период, текущий год, прошлый год, позапрошлый год и ранее */
  IF repkau.stb13 = "novpl" THEN
  DO:

	   /* проценты начисленные по ставке договора */
	SumNachProc_iter =  repkau.stb09 .
	SumNachProc_All  = SumNachProc_All + SumNachProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumNachProc_Current = SumNachProc_Current + SumNachProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumNachProc_Last = SumNachProc_Last + SumNachProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumNachProc_BeforeLast = SumNachProc_BeforeLast + SumNachProc_iter .


	   /* проценты пересчитанные по ставе до востребования */
	SumNachPenProc_iter = repkau.stb11 .
	SumNachPenProc_All  = SumNachPenProc_All + SumNachPenProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumNachPenProc_Current = SumNachPenProc_Current + SumNachPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumNachPenProc_Last = SumNachPenProc_Last + SumNachPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumNachPenProc_BeforeLast = SumNachPenProc_BeforeLast + SumNachPenProc_iter .

  END.


	/* определяем итоговые суммы доначисленных процентов по ставке до востребования */
  IF repkau.stb13 = "donach" THEN
  DO:

	PerDonachBegDate = repkau.stb02 .

	   /* проценты пересчитанные по ставке до востребования */
	SumDonachPenProc_iter = repkau.stb11 .
	SumDonachPenProc_All  = SumDonachPenProc_All + SumDonachPenProc_iter .

  END.


END.
	/*  закончили определять итоговые суммы   */
/****************************************************************************/


/****************************************************************************/
	/*  определяем выходную Result  */
/****************************************************************************/

Result = 
    /* выплаченные проценты */
  STRING(SumVplProc_All)	+ "," +
  STRING(SumVplProc_Current)	+ "," +
  STRING(SumVplProc_Last)	+ "," +
  STRING(SumVplProc_BeforeLast)	+ "," +
    /* проценты начисленные по ставке договора */
  STRING(SumNachProc_All)	 + "," +
  STRING(SumNachProc_Current)    + "," +
  STRING(SumNachProc_Last)       + "," +
  STRING(SumNachProc_BeforeLast) + "," +
    /* начисленные проценты пересчитанные по ставе до востребования */
  STRING(SumNachPenProc_All)        + "," +
  STRING(SumNachPenProc_Current)    + "," +
  STRING(SumNachPenProc_Last)       + "," +
  STRING(SumNachPenProc_BeforeLast) + "," +
    /* доначисленные проценты пересчитанные по ставке до востребования */
  STRING(SumDonachPenProc_All) + "," +
    /* доначисленные проценты по ставке договора */
  STRING(SumDonachProc_All) + "," +
    /* выплаченные проценты, пересчитанные по ставе до востребования */
  STRING(SumVplPenProc_All)	+ "," +
  STRING(SumVplPenProc_Current)	+ "," +
  STRING(SumVplPenProc_Last)	+ "," +
  STRING(SumVplPenProc_BeforeLast)
  .
	/*  закончили определять Result   */
/****************************************************************************/





/****************************************************************************/
	/*  при необходимости выводим расчет   */
/****************************************************************************/

IF ShowTabl = yes  THEN
DO:

  {setdest.i}

  FOR EACH repkau :
    PUT UNFORM
       repkau.stb00  " | "
       repkau.stb01  " | "
       repkau.stb02  " | "
       repkau.stb03  " | "
       repkau.stb04  " | "
       repkau.stb05  " | "
       repkau.stb06  " | "
       repkau.stb07  " | "
       repkau.stb08  " | "
       repkau.stb09  " | "
       repkau.stb10  " | "
       repkau.stb11  " | "
       repkau.stb12  " | "
       repkau.stb13  " | "
    SKIP.       
  END.

  PUT UNFORM SKIP(1).

     /* выплаченные проценты */
  PUT UNFORM "Выплаченные проценты:" SKIP(1)
    SumVplProc_All	" | "
    SumVplProc_Current	" | "
    SumVplProc_Last	" | "
    SumVplProc_BeforeLast	" | "
  SKIP(1).
  
     /* проценты начисленные по ставке договора */
  PUT UNFORM "Проценты начисленные по ставке договора:" SKIP(1)
    SumNachProc_All	   " | "
    SumNachProc_Current    " | "
    SumNachProc_Last       " | "
    SumNachProc_BeforeLast " | "
  SKIP(1).
  
     /* проценты пересчитанные по ставе до востребования */
  PUT UNFORM "Проценты пересчитанные по ставе до востребования:" SKIP(1)
    SumNachPenProc_All        " | "
    SumNachPenProc_Current    " | "
    SumNachPenProc_Last       " | "
    SumNachPenProc_BeforeLast " | "
  SKIP(1) .
  
     /* проценты пересчитанные по ставке до востребования */
  PUT UNFORM "Проценты доначисленные по ставке до востребования:" SKIP(1)
    SumDonachPenProc_All
  SKIP(1) .

    /* доначисленные проценты по ставке договора */
  PUT UNFORM "Проценты доначисленные по ставке договора :" SKIP(1)
    SumDonachProc_All 
  SKIP(1) .

    /* выплаченные проценты, пересчитанные по ставе до востребования */
  PUT UNFORM "Выплаченные проценты, пересчитанные по ставе до востребования:" SKIP(1)
    SumVplPenProc_All	         " | "
    SumVplPenProc_Current	 " | "
    SumVplPenProc_Last	         " | "
    SumVplPenProc_BeforeLast     " | "
  SKIP(1) .

  PUT UNFORM "Учет дохода-расхода"
    SumDohodRashod_All
  SKIP(1) .

  {preview.i}

END.

/****************************************************************************/





/****************************************************************************/
	/*  при необходимости печатаем распоряжения   */
/****************************************************************************/

IF ShowRasp = yes  THEN
DO:

    /* для процедуры печати передаем параметр типа распоряжения */

  IF FlgNach = no AND FlgVpl = no THEN
    iParam = 10 . /* п.1 */


  IF FlgNach = yes AND FlgVpl = no THEN
    IF YEAR(LoanOpDate) = YEAR(RaspDate) THEN
	    iParam = 21 . /* п.2.1 */
    ELSE
    DO:
       IF MONTH(RaspDate) = 1 THEN
	    iParam = 22 . /* п.2.2 */

       IF DATE('01/02/' + STRING(YEAR(RaspDate)) ) <= RaspDate   AND  RaspDate <= SPODDate  THEN
	    iParam = 23 . /* п.2.3 */

       IF RaspDate > SPODDate THEN
	    iParam = 24 . /* п.2.4 */
    END.


  IF FlgNach = yes AND FlgVpl = yes THEN
    IF YEAR(LoanOpDate) = YEAR(RaspDate) THEN
	    iParam = 31 . /* п.3.1 */
    ELSE
    DO:
       IF MONTH(RaspDate) = 1 THEN
	    iParam = 32 . /* п.3.2 */

       IF DATE('01/02/' + STRING(YEAR(RaspDate)) ) <= RaspDate   AND  RaspDate <= SPODDate  THEN
	    iParam = 33 . /* п.3.3 */

       IF RaspDate > SPODDate THEN
	    iParam = 34 . /* п.3.4 */
    END.

    /* печатаем распоряжения */
/*
  IF LoanCurrency = "" THEN
	{pir-drast-rasprub.i} 
  ELSE 
*/

	{pir-drast-raspval.i} .


END.

/****************************************************************************/



DELETE OBJECT oSysClass.

