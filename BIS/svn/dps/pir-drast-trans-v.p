/* ========================================================================= */
/** 
    Copyright: ��� ��� ����, ��ࠢ����� ��⮬�⨧�樨 (C) 2013
     Filename: pir-ordrast-trans.p
      Comment: ��楤�� �ᯮ������ �� ����筮� ���থ��� ������
		�ᯮ������ � �室�묨 ��ࠬ��ࠬ�. 
		����᪠���� �� �࠭���樨 ����筮�� ���থ��� ��� ��楤��� 
   Parameters: ���ᠭ� ����
       Launch: 
         Uses: pir-dps-tblkau.i - ��ந� ⠫��� �� �����⨪� � ��室���� �� ��� 
		pir-drast-rasprub.i - ����� �ᯮ�殮���
      Created: Sitov S.A., 20.02.2013
	Basis: #1073 
     Modified:  
*/
/* ========================================================================= */



{globals.i}		/** �������� ��।������ */
{ulib.i}		/** ������⥪� ���-�㭪権 */
{sh-defs.i}

/* ========================================================================= */
				/** ������� */
/* ========================================================================= */

  /* �室�� � ��室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM LoanNumber	AS CHAR  NO-UNDO.	/* ����� ������� */
DEF INPUT PARAM RaspDate	AS DATE  NO-UNDO.	/* ��� ���থ��� */
DEF INPUT PARAM RatePen		AS DEC   NO-UNDO.	/* ���䭠� ��� �⠢�� */
DEF INPUT PARAM SPODDate	AS DATE  NO-UNDO.	/* ��� ���� */
DEF INPUT PARAM ShowTabl	AS LOGICAL NO-UNDO.	/* �����뢠�� ���� */
DEF INPUT PARAM ShowRasp	AS LOGICAL NO-UNDO.	/* ����� �ᯮ�殮��� */
DEF OUTPUT PARAM Result AS CHAR NO-UNDO.

{pir-drast-trans.def}


/* ========================================================================= */
				/** ��������� */
/* ========================================================================= */
/*
message 
  " �室 ��� drast-trans-v.p " 
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
	/* ��।��塞 ���ଠ�� �� �������� */
/****************************************************************************/

LoanCurrency = trloan.currency .
LoanOpDate  = trloan.open-date .
LoanClient  = GetClientInfo_ULL("�," + STRING(trloan.cust-id), "name", false) .

  /* 423 */
LoanAcct    = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-dps-t', trloan.open-date, false).
  /* 47411 */
LoanAcctInt = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-dps-int', trloan.open-date, false).
  /* 70606 - ����� ����������. ��� �㦥� ⮫쪮 ��� �ᯮ�殮��� �� ���� �ᯮ�殮��� */ 
LoanAcctExp = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-expens', RaspDate, false).
  /* 40817 - ����� ����������. ���� ��।����� ��� ��� ������� ��ਮ��  */
LoanAcctOut = GetLoanAcct_ULL(trloan.contract, trloan.cont-code, 'loan-dps-out', trloan.open-date, false).
  /* ⥪�騩 loan-dps-cur */	
LoanAcctCur = "" .
  /* ���� !!! ���� ⠪ */
LoanAcctExpSPOD = (IF RaspDate > SPODDate THEN LoanAcctExp ELSE (if substring(LoanAcct,1,3) = '426' then '70706810600002160202' else '70706810700002160102') ) .
LoanAcctExpSPODBefLast = (IF LoanCurrency = "" THEN '70701810600001720101' ELSE '70701810900001720102' ) .
LoanAcctExpProsh = (IF RaspDate > SPODDate AND year(RaspDate) = year(LoanOpDate) THEN LoanAcctExp ELSE '70601810900001720105' ) .


  /* ���⮪ ������ �� ���� ���থ��� */
RUN acct-pos IN h_base (LoanAcct, LoanCurrency, RaspDate - 1 , RaspDate - 1 , CHR(251) ) .
AmtOsn = IF LoanCurrency = "" THEN ABS(sh-bal) ELSE ABS(sh-val) .

	/* �⠢�� �� ����ॡ������ */
IF RatePen = ? OR RatePen = 0 THEN
   RatePen = GetDpsCommission_ULL(LoanNumber, 'pen-commi', RaspDate, false) .
ELSE 
   RatePen = RatePen / 100 .

KursRaspDate = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , RaspDate) . 

/****************************************************************************/
	/*  ������塞 ⠡���� �� �����⨪� �� ���� ���থ��� */
/****************************************************************************/

  /* ��ந� ⠡���� �� �����⨪� � ��室���� �� ��� */
{pir-dps-tblkau.i}


/****************************************************************************/
	/*  ����砥� ����� ࠡ���� ⠡���� */
/****************************************************************************/

FOR EACH tblkau :

  IF tblkau.Op-ContractDate = LoanOpDate AND tblkau.KauEntry-Kau = '��₪��' 
  THEN  NEXT.

  n = n + 1 .


/****/
if  n = 11 then next.
/*****/

	/* �⡨ࠥ� ��, �஬� �믫�� ��業⮢ */
  IF NOT ( tblkau.KauEntry-AcctDb = LoanAcctInt AND tblkau.KauEntry-AcctCr BEGINS SUBSTRING(LoanAcctOut,1,5) )  THEN
  DO:

    i = i + 1 .
    FlgNach = yes .

	/* ��砫� � ����� ��ਮ�� ���᫥��� */ 
    PerBegDate = ( IF i = 1 THEN LoanOpDate + 1 ELSE PerEndDate + 1 ).
    PerEndDate = tblkau.Op-ContractDate .
    PerKolDay  = PerEndDate - PerBegDate + 1 .

	/* �㬬� ���⪠ �� ��� �� ����� ��ਮ�� */ 
    RUN acct-pos IN h_base (LoanAcct, LoanCurrency, (PerEndDate - 1), (PerEndDate - 1), CHR(251) ) .
    PerEndOstAcct = IF LoanCurrency = "" THEN ABS(sh-bal) ELSE ABS(sh-val).

	/* �⠢�� �� �������� �� ����� ��ਮ�� ���᫥��� */ 
    RateNorm = GetDpsCommission_ULL(LoanNumber, 'commission', PerEndDate, false) .

	/* �६����� ���� ���᫥��� �� ����� ��ਮ�� */
    LoanIntSchBase = GetLoanIntSchBase(PerEndDate) . 

	/* ��� �஢����. �� ��� ���� �� ��६ ���� */
    PerEndKursDate = tblkau.KauEntry-OpDate .
	/* ���� ������ �� ���� �஢����  tblkau.KauEntry-OpDate */
    PerEndKurs = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , PerEndKursDate) . 


	/* �㬬� ���᫥���� ��業⮢ �� ����� ��ਮ�� */ 
    IF (tblkau.KauEntry-Kau = '��₪��') OR (tblkau.KauEntry-Kau = '����' AND FlgRazb = yes ) THEN
    DO:
  	    /* �뫮 ��������� ���⪠, ⮣�� ���� ������� */
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


	/* �㬬� ��業⮢ �����⠭��� �� �⠢�� �� ����ॡ������ �� ��ਮ� */
    PerEndSumNachPen    = ROUND( PerEndOstAcct * PerKolDay * RatePen / LoanIntSchBase , 2).
    PerEndSumNachPenEqv = IF LoanCurrency = "" THEN 0 ELSE ROUND( PerEndSumNachPen * PerEndKurs, 2) .


	/* ������塞 ⠡���� */
    CREATE repkau .
    ASSIGN
	repkau.stb00 = n
	repkau.stb01 = PerEndOstAcct	/* ���⮪ ������ �� ����� ��ਮ�� */
	repkau.stb02 = PerBegDate	/* ��砫� ��ਮ�� ���᫥��� */
	repkau.stb03 = PerEndDate	/* �����  ��ਮ�� ���᫥��� */
	repkau.stb04 = PerKolDay        /* ������⢮ ���� � ��ਮ�� */
	repkau.stb05 = RateNorm * 100	/* % �⠢�� �� �������� �� ���� */   
	repkau.stb06 = RatePen * 100	/* % �⠢�� ����筮�� ���থ��� */
	repkau.stb07 = PerEndKursDate	/* ��� �஢����, �� ��� ���� ��।��塞 ���� */
	repkau.stb08 = PerEndKurs	/* ���� */
	repkau.stb09 = PerEndSumNach        /* �㬬� � ��� ��� = �㬬� %-�� �� �⠢�� ������� */
	repkau.stb10 = PerEndSumNachEqv     /* �㬬� � ���   = �㬬� %-�� �� �⠢�� ������� */    
	repkau.stb11 = PerEndSumNachPen     /* �㬬� � ��� ��� = �㬬� %-�� �����⠭��� �� �⠢�� �� */      
	repkau.stb12 = PerEndSumNachPenEqv  /* �㬬� � ���   = �㬬� %-�� �����⠭��� �� �⠢�� �� */      
	repkau.stb13 = "novpl"		/* ⨯ = �� �믫��� ��業⮢ */
    .                       

  END.  /* �����稫� �⡨��� ��, �஬� �믫�� ��業⮢ */

  
	/* �⡨ࠥ� �믫�祭�� ��業�� */ 
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

	/* �⠢�� �� �������� �� ����� ��ਮ�� ���᫥��� */ 
    RateNorm = GetDpsCommission_ULL(LoanNumber, 'commission', PerEndDate, false) .
	/* �६����� ���� ���᫥��� �� ����� ��ਮ�� */
    LoanIntSchBase = GetLoanIntSchBase(PerEndDate) . 
	/* ��� �஢����. �� ��� ���� �� ��६ ���� */
    PerEndKursDate = tblkau.KauEntry-OpDate .
	/* ���� ������ �� ���� �஢����  tblkau.KauEntry-OpDate */
    PerEndKurs = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , PerEndKursDate) . 

	/* �㬬� %-�� �� �⠢�� ������� � ����� ������� � � �������� */
    PerEndSumVpl    = IF LoanCurrency = "" THEN tblkau.KauEntry-AmtRub ELSE tblkau.KauEntry-AmtCur .
    PerEndSumVplEqv = IF LoanCurrency = "" THEN 0 ELSE tblkau.KauEntry-AmtRub .


	/* ������塞 ⠡���� */
    CREATE repkau .
    ASSIGN
	repkau.stb00 = n
	repkau.stb01 = 0		/* ���⮪ ������ �� ����� ��ਮ�� */
	repkau.stb02 = PerVplBegDate	/* ��砫� ��ਮ�� ���᫥��� */
	repkau.stb03 = PerVplEndDate	/* �����  ��ਮ�� ���᫥��� */
	repkau.stb04 = PerKolDay        /* ������⢮ ���� � ��ਮ�� */
	repkau.stb05 = RateNorm * 100	/* % �⠢�� �� �������� �� ���� */   
	repkau.stb06 = RatePen * 100	/* % �⠢�� ����筮�� ���থ��� */
	repkau.stb07 = PerEndKursDate	/* ��� �஢����, �� ��� ���� ��।��塞 ���� */
	repkau.stb08 = PerEndKurs	/* ���� */
	repkau.stb09 = PerEndSumVpl      /* �㬬� � ��� ��� = �㬬� %-�� �� �⠢�� ������� */
	repkau.stb10 = PerEndSumVplEqv   /* �㬬� � ���   = �㬬� %-�� �� �⠢�� ������� */    
	repkau.stb11 = 0 		 /* �㬬� � ��� ��� = �㬬� %-�� �����⠭��� �� �⠢�� �� */      
	repkau.stb12 = 0 		 /* �㬬� � ���   = �㬬� %-�� �����⠭��� �� �⠢�� �� */      
	repkau.stb13 = "vpl"		/* ⨯ = �믫�� ��業⮢ */
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
	/*  ��᫥���� ��ப� �����뢠�� �⤥�쭮 - �����᫥��� */
/****************************************************************************/

n = n + 1 .

	/* ��砫� � ����� ��ਮ�� ���᫥��� */ 
PerBegDate = ( IF n = 1 THEN LoanOpDate + 1 ELSE PerEndDate + 1 ).
PerEndDate = RaspDate .
PerKolDay  = PerEndDate - PerBegDate + 1 .

	/* �㬬� ���⪠ �� ��� �� ����� ��ਮ�� */ 
RUN acct-pos IN h_base (LoanAcct, LoanCurrency, (PerEndDate - 1), (PerEndDate - 1), CHR(251) ) .
PerEndOstAcct = IF LoanCurrency = "" THEN ABS(sh-bal) ELSE ABS(sh-val).

	/* �६����� ���� ���᫥��� */
LoanIntSchBase = GetLoanIntSchBase(PerEndDate) . 

	/* �㬬� �����᫥���� ��業⮢ �� �⠢�� �� ����ॡ������ */
IF LoanCurrency = "" THEN
DO:
  PerEndSumDonachPen    = ROUND( PerEndOstAcct * PerKolDay * RatePen / LoanIntSchBase , 2).
  PerEndSumDonachPenEqv = 0 .
END.
ELSE
DO:
	/* ���� ������ �� ���� �஢����  - ��� ���থ��� ������ */
  PerEndKursDate = RaspDate .
  PerEndKurs = oSysClass:getCBRKurs( ( if LoanCurrency = "" then INT("810") else INT(LoanCurrency) ) , PerEndKursDate) . 
  PerEndSumDonachPen    = ROUND( PerEndOstAcct * PerKolDay * RatePen / LoanIntSchBase , 2).
  PerEndSumDonachPenEqv = ROUND( PerEndSumDonachPen * PerEndKurs, 2) . 
END.

	/* ������塞 ⠡���� */
CREATE repkau .
ASSIGN
	repkau.stb00 = n
	repkau.stb01 = PerEndOstAcct	/* ���⮪ ������ �� ����� ��ਮ�� */
	repkau.stb02 = PerBegDate	/* ��砫� ��ਮ�� ���᫥��� */
	repkau.stb03 = PerEndDate	/* �����  ��ਮ�� ���᫥��� */
	repkau.stb04 = PerKolDay        /* ������⢮ ���� � ��ਮ�� */
	repkau.stb05 = RateNorm * 100	/* % �⠢�� �� �������� �� ���� */   
	repkau.stb06 = RatePen * 100	/* % �⠢�� ����筮�� ���থ��� */
	repkau.stb07 = PerEndKursDate	/* ��� �஢����, �� ��� ���� ��।��塞 ���� */
	repkau.stb08 = PerEndKurs	/* ���� */
	repkau.stb09 = 0		     /* �㬬� � ��� ��� = �㬬� %-�� �� �⠢�� ������� */
	repkau.stb10 = 0		     /* �㬬� � ���   = �㬬� %-�� �� �⠢�� ������� */    
	repkau.stb11 = PerEndSumDonachPen    /* �㬬� � ��� ��� = �㬬� %-�� �����⠭��� �� �⠢�� �� */      
	repkau.stb12 = PerEndSumDonachPenEqv /* �㬬� � ���   = �㬬� %-�� �����⠭��� �� �⠢�� �� */      
	repkau.stb13 = "donach"		/* ⨯ = �����᫥��� ��業⮢ */
.                       

	/*  �����稫� �����뢠�� ��᫥���� ��ப�  */
/****************************************************************************/




/****************************************************************************/
	/*  ��।��塞 �⮣��� �㬬�   */
/****************************************************************************/

FOR EACH repkau :

	/* ��।��塞 �⮣��� �㬬� �믫�祭��� ��業⮢ 
	�� ���� ��ਮ�, ⥪�騩 ���, ���� ���, �������� ��� � ࠭�� */
  IF repkau.stb13 = "vpl" THEN
  DO:

	PerVplEndDateRasp = repkau.stb03 .

	   /* �믫�祭�� ��業�� �� �⠢�� ������� */
	SumVplProc_iter = repkau.stb09 . 
	SumVplProc_All  = SumVplProc_All + SumVplProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumVplProc_Current = SumVplProc_Current + SumVplProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumVplProc_Last = SumVplProc_Last + SumVplProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumVplProc_BeforeLast = SumVplProc_BeforeLast + SumVplProc_iter .


	   /* �믫�祭�� ��業��, �����⠭�� �� �⠢� �� ����ॡ������ */
	SumVplPenProc_iter =  repkau.stb11 . 
	SumVplPenProc_All = SumVplPenProc_All + SumVplPenProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumVplPenProc_Current = SumVplPenProc_Current + SumVplPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumVplPenProc_Last = SumVplPenProc_Last + SumVplPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumVplPenProc_BeforeLast = SumVplPenProc_BeforeLast + SumVplPenProc_iter .

	  /* ��� ��室�-��室� */
	SumDohodRashod_Iter = repkau.stb14 . 
	SumDohodRashod_All = SumDohodRashod_Iter + repkau.stb14 .

  END.


	/* ��।��塞 �⮣��� �㬬� ���᫥����, �����⠭��� ���᫥���� ��業⮢ 
	�� ���� ��ਮ�, ⥪�騩 ���, ���� ���, �������� ��� � ࠭�� */
  IF repkau.stb13 = "novpl" THEN
  DO:

	   /* ��業�� ���᫥��� �� �⠢�� ������� */
	SumNachProc_iter =  repkau.stb09 .
	SumNachProc_All  = SumNachProc_All + SumNachProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumNachProc_Current = SumNachProc_Current + SumNachProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumNachProc_Last = SumNachProc_Last + SumNachProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumNachProc_BeforeLast = SumNachProc_BeforeLast + SumNachProc_iter .


	   /* ��業�� �����⠭�� �� �⠢� �� ����ॡ������ */
	SumNachPenProc_iter = repkau.stb11 .
	SumNachPenProc_All  = SumNachPenProc_All + SumNachPenProc_iter.

	IF YEAR(repkau.stb03) = YEAR(RaspDate) THEN
	  SumNachPenProc_Current = SumNachPenProc_Current + SumNachPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 1  THEN
	  SumNachPenProc_Last = SumNachPenProc_Last + SumNachPenProc_iter .

	IF YEAR(repkau.stb03) = YEAR(RaspDate) - 2  THEN
	  SumNachPenProc_BeforeLast = SumNachPenProc_BeforeLast + SumNachPenProc_iter .

  END.


	/* ��।��塞 �⮣��� �㬬� �����᫥���� ��業⮢ �� �⠢�� �� ����ॡ������ */
  IF repkau.stb13 = "donach" THEN
  DO:

	PerDonachBegDate = repkau.stb02 .

	   /* ��業�� �����⠭�� �� �⠢�� �� ����ॡ������ */
	SumDonachPenProc_iter = repkau.stb11 .
	SumDonachPenProc_All  = SumDonachPenProc_All + SumDonachPenProc_iter .

  END.


END.
	/*  �����稫� ��।����� �⮣��� �㬬�   */
/****************************************************************************/


/****************************************************************************/
	/*  ��।��塞 ��室��� Result  */
/****************************************************************************/

Result = 
    /* �믫�祭�� ��業�� */
  STRING(SumVplProc_All)	+ "," +
  STRING(SumVplProc_Current)	+ "," +
  STRING(SumVplProc_Last)	+ "," +
  STRING(SumVplProc_BeforeLast)	+ "," +
    /* ��業�� ���᫥��� �� �⠢�� ������� */
  STRING(SumNachProc_All)	 + "," +
  STRING(SumNachProc_Current)    + "," +
  STRING(SumNachProc_Last)       + "," +
  STRING(SumNachProc_BeforeLast) + "," +
    /* ���᫥��� ��業�� �����⠭�� �� �⠢� �� ����ॡ������ */
  STRING(SumNachPenProc_All)        + "," +
  STRING(SumNachPenProc_Current)    + "," +
  STRING(SumNachPenProc_Last)       + "," +
  STRING(SumNachPenProc_BeforeLast) + "," +
    /* �����᫥��� ��業�� �����⠭�� �� �⠢�� �� ����ॡ������ */
  STRING(SumDonachPenProc_All) + "," +
    /* �����᫥��� ��業�� �� �⠢�� ������� */
  STRING(SumDonachProc_All) + "," +
    /* �믫�祭�� ��業��, �����⠭�� �� �⠢� �� ����ॡ������ */
  STRING(SumVplPenProc_All)	+ "," +
  STRING(SumVplPenProc_Current)	+ "," +
  STRING(SumVplPenProc_Last)	+ "," +
  STRING(SumVplPenProc_BeforeLast)
  .
	/*  �����稫� ��।����� Result   */
/****************************************************************************/





/****************************************************************************/
	/*  �� ����室����� �뢮��� ����   */
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

     /* �믫�祭�� ��業�� */
  PUT UNFORM "�믫�祭�� ��業��:" SKIP(1)
    SumVplProc_All	" | "
    SumVplProc_Current	" | "
    SumVplProc_Last	" | "
    SumVplProc_BeforeLast	" | "
  SKIP(1).
  
     /* ��業�� ���᫥��� �� �⠢�� ������� */
  PUT UNFORM "��業�� ���᫥��� �� �⠢�� �������:" SKIP(1)
    SumNachProc_All	   " | "
    SumNachProc_Current    " | "
    SumNachProc_Last       " | "
    SumNachProc_BeforeLast " | "
  SKIP(1).
  
     /* ��業�� �����⠭�� �� �⠢� �� ����ॡ������ */
  PUT UNFORM "��業�� �����⠭�� �� �⠢� �� ����ॡ������:" SKIP(1)
    SumNachPenProc_All        " | "
    SumNachPenProc_Current    " | "
    SumNachPenProc_Last       " | "
    SumNachPenProc_BeforeLast " | "
  SKIP(1) .
  
     /* ��業�� �����⠭�� �� �⠢�� �� ����ॡ������ */
  PUT UNFORM "��業�� �����᫥��� �� �⠢�� �� ����ॡ������:" SKIP(1)
    SumDonachPenProc_All
  SKIP(1) .

    /* �����᫥��� ��業�� �� �⠢�� ������� */
  PUT UNFORM "��業�� �����᫥��� �� �⠢�� ������� :" SKIP(1)
    SumDonachProc_All 
  SKIP(1) .

    /* �믫�祭�� ��業��, �����⠭�� �� �⠢� �� ����ॡ������ */
  PUT UNFORM "�믫�祭�� ��業��, �����⠭�� �� �⠢� �� ����ॡ������:" SKIP(1)
    SumVplPenProc_All	         " | "
    SumVplPenProc_Current	 " | "
    SumVplPenProc_Last	         " | "
    SumVplPenProc_BeforeLast     " | "
  SKIP(1) .

  PUT UNFORM "��� ��室�-��室�"
    SumDohodRashod_All
  SKIP(1) .

  {preview.i}

END.

/****************************************************************************/





/****************************************************************************/
	/*  �� ����室����� ���⠥� �ᯮ�殮���   */
/****************************************************************************/

IF ShowRasp = yes  THEN
DO:

    /* ��� ��楤��� ���� ��।��� ��ࠬ��� ⨯� �ᯮ�殮��� */

  IF FlgNach = no AND FlgVpl = no THEN
    iParam = 10 . /* �.1 */


  IF FlgNach = yes AND FlgVpl = no THEN
    IF YEAR(LoanOpDate) = YEAR(RaspDate) THEN
	    iParam = 21 . /* �.2.1 */
    ELSE
    DO:
       IF MONTH(RaspDate) = 1 THEN
	    iParam = 22 . /* �.2.2 */

       IF DATE('01/02/' + STRING(YEAR(RaspDate)) ) <= RaspDate   AND  RaspDate <= SPODDate  THEN
	    iParam = 23 . /* �.2.3 */

       IF RaspDate > SPODDate THEN
	    iParam = 24 . /* �.2.4 */
    END.


  IF FlgNach = yes AND FlgVpl = yes THEN
    IF YEAR(LoanOpDate) = YEAR(RaspDate) THEN
	    iParam = 31 . /* �.3.1 */
    ELSE
    DO:
       IF MONTH(RaspDate) = 1 THEN
	    iParam = 32 . /* �.3.2 */

       IF DATE('01/02/' + STRING(YEAR(RaspDate)) ) <= RaspDate   AND  RaspDate <= SPODDate  THEN
	    iParam = 33 . /* �.3.3 */

       IF RaspDate > SPODDate THEN
	    iParam = 34 . /* �.3.4 */
    END.

    /* ���⠥� �ᯮ�殮��� */
/*
  IF LoanCurrency = "" THEN
	{pir-drast-rasprub.i} 
  ELSE 
*/

	{pir-drast-raspval.i} .


END.

/****************************************************************************/



DELETE OBJECT oSysClass.

