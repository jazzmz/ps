{pirsavelog.p}

/**
 * ������� �� ���� "���饭�� ��業�� �� ������ࠬ ��" - pirincdpsf.p
 * ���� ������� ���� - ���� ������㥬�� ��室�� �� ���騬 ���᫥��� ��業⮢ �� �������� ������ࠬ ����� ���
 * �ନ��� �.�.
 * 30/03/2010 
 */
 
 /** �������� ��।������ */
{globals.i}
{sh-defs.i}  /* ��।������ ��६����� ��� ���᫥��� ���⪮� ��楤�ன acct-pos */
{dpsproc.def}

/** ������⥪� �㭪権 */
{ulib.i}

{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** ������ ��६����� */
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpDate AS DATE NO-UNDO.
/** ���� ����஢�� �㭪権 �� ���㫥� u*lib.i */
DEF VAR traceOnOff AS LOGICAL INITIAL false NO-UNDO.
/** ��� ���� */
DEF VAR repDate AS DATE FORMAT "99/99/9999" LABEL "��� ����" NO-UNDO.
/** ����� */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
/** �⮣���� �㬬� %% */
DEF VAR totalSumma%% AS DECIMAL NO-UNDO.
DEF VAR OstSumma AS DECIMAL NO-UNDO.
DEF VAR ProcStavka AS DECIMAL NO-UNDO. 
DEF VAR vYear AS DECIMAL NO-UNDO. 

DEF VAR n_yach AS INTEGER NO-UNDO.

DEF VAR nextDate AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR nextDateKorr AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR FirstDate AS DATE FORMAT "99/99/9999"  NO-UNDO.
DEF VAR IDate AS DATE FORMAT "99/99/9999"  NO-UNDO.

DEF VAR NextPercent AS DECIMAL NO-UNDO.
DEF VAR AllPercent AS DECIMAL NO-UNDO.
DEF VAR FirstPercent AS DECIMAL NO-UNDO.
DEF VAR Percent AS DECIMAL NO-UNDO.
DEF VAR PeriodM AS CHAR NO-UNDO.
DEF VAR PeriodD AS DECIMAL NO-UNDO.

DEF VAR	AllPr4Period AS DECIMAL EXTENT 10 NO-UNDO.

def buffer LAcct for Loan-acct.

FUNCTION NOMER_YACH RETURNS INTEGER (INPUT date1 AS DATE, INPUT date2 AS DATE) FORWARD.

/*PAUSE 0.*/
/** ������ ���� � ������� �� ���짮��⥫� ;) */
repDate = TODAY.

DISPLAY repDate WITH FRAME fSetDate OVERLAY CENTERED SIDE-LABELS.
SET repDate WITH FRAME fSetDate.
HIDE FRAME fSetDate.	

DEFINE TEMP-TABLE tt-report
	FIELD balAcct%% AS CHAR
	FIELD clientName AS CHAR 
	FIELD currency AS CHAR
	FIELD loanInfo AS CHAR 
	
	FIELD loanOpenDate AS DATE
	FIELD loanEndDate AS DATE
	
	FIELD account AS CHAR
	FIELD intAccount AS CHAR
		
	FIELD summa%% AS DECIMAL
	FIELD rate AS DECIMAL
	FIELD summaDeposit AS DECIMAL

	FIELD dpstype AS CHAR	

	FIELD Pr4Period AS DECIMAL EXTENT 10
	FIELD nextDate AS DATE
	
	INDEX main balAcct%% ASCENDING currency ASCENDING nextDate ASCENDING.


/*����᪠�� 横� �� ��࠭� ������ࠬ*/	
FOR EACH tmprecid 
			NO-LOCK,
    FIRST loan WHERE 
    	RECID(loan) = tmprecid.id 
    	NO-LOCK,
    LAST loan-acct WHERE 
    	loan-acct.contract = loan.contract
    	AND loan-acct.cont-code = loan.cont-code
    	AND loan-acct.acct-type = "loan-dps-int"
    	AND loan-acct.since LE repDate
    	NO-LOCK
 :
  	CREATE tt-report.
  	
  	/*��� ��� ����᫥��� ��業⮢*/
  	tt-report.balAcct%% = SUBSTRING(loan-acct.acct,1,5).
  	
  	/*��� ������*/
  	tt-report.clientName = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", traceOnOff).  	  
	
	/*����� �������*/	
  	tt-report.loanInfo = loan.cont-code.
  	
  	/*��� ������*/
  	tt-report.loanOpenDate = DATE(GetLoanInfo_ULL(loan.contract, loan.cont-code, "open_date", traceOnOff)).
	
	/*��� �������*/
	tt-report.loanEndDate = loan.end-date.
	
	/*��� ��� ����᫥��� ��業⮢*/
	tt-report.intAccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-int", repDate, traceOnOff).
	
	
  	/*��� ��⭮�� ������*/
  	tt-report.account = GetLoanAcct_ULL(loan.contract, loan.cont-code, "loan-dps-t,loan-dps-p", repDate, traceOnOff).
	
	/*���⮪ �� ��� ��� ����᫥��� ��業⮢*/
	tt-report.summa%% = ABS(	GetAcctPosValue_UAL(loan-acct.acct,loan.currency, repDate, traceOnOff)  	).
  	
  	/*���� */
  	IF loan.close-date <> ? AND loan.close-date LE repDate THEN
  		tmpDate = loan.close-date - 1.
  	ELSE IF loan.end-date <> ? AND loan.end-date LE repDate THEN
  		tmpDate = loan.end-date - 1.
  	ELSE
  		tmpDate = repDate.
	
	/* ���⮪ �� ��� ��⭮�� ������ */	
	tt-report.summaDeposit = ABS(	GetAcctPosValue_UAL(tt-report.account,	loan.currency,tmpDate, traceOnOff)	).

	/* ��������� �⠢�� �� ������ */		
	tt-report.rate = GetDpsCommission_ULL(loan.cont-code,"commission",repDate, traceOnOff).
		
	/*��� ������*/	
	tt-report.dpstype = loan.cont-type.
	
	/*�����*/
	tt-report.currency = (IF loan.currency = "" THEN "810" ELSE loan.currency).
	
	/*
	tt-report.summa%%d = GetDpsCurrentPersent_ULL(loan.cont-code, repDate, traceOnOff).
  	tt-report.summa%% = tt-report.summa%%1 + tt-report.summa%%d.
  	tt-report.nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, repDate, traceOnOff).
	*/




/**********************************************************************/

       	if can-do("!42306978800000000104,!42307840700000000001,!42307810400000735978,!42307810700000735979,!42307840300000000744,*",loan.cont-code) then do:

/* �᭮���� ���� ࠧ��᪨ ����� ��業⮢ �� �⮫�栬 125�� ���   */
	allPercent = 0.
	firstPercent = tt-report.summa%%.
 
/* ��室�� ᫥������ ��� ������� ������� ���� �믫��� ��業⮢ */
 nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, repDate, traceOnOff).

/* MESSAGE 'First Next Date: ' nextDate VIEW-AS ALERT-BOX. */


/* ���� ������ ��� �� �ॢ��� ���� �����襭�� ������� �㤥� �᪨�뢠�� ����塞� ��業�� �� �ப�� */
DO WHILE nextDate LT tt-report.LoanEndDate :	

/* MESSAGE 'Data viplati: ' nextDate VIEW-AS ALERT-BOX. */

		/*��室�� ���� ���� ��業⮢ ���. ���� �믫�祭� */
		nextDateKorr =   DATE(DATE(	STRING( "1/" + STRING(MONTH(nextDate)) + "/" + STRING(YEAR(nextDate)))	) - 1 ).                    

/* MESSAGE 'Data rascheta: ' nextDateKorr VIEW-AS ALERT-BOX. */

		
		/*�����뢠�� �㬬� ��業⮢ �� ��᫥���� �᫮ �।��饣� �����, ��� �� � �㤥� �믫�祭� 5��� ��� 7��� �᫠*/
		nextPercent = GetDpsCurrentPersent_ULL(loan.cont-code, nextDateKorr, traceOnOff).

/*MESSAGE 'Next Percent: ' nextPercent VIEW-AS ALERT-BOX.*/

		
		/*�����稢��� �㦭�� �祩�� ���ᨢ� Pr4Period �� ���⠭��� �㬬� ��業⮢ � ���⠥� �㬬� ��業⮢ 
		㦥 ��⥭��� �� �।���� ������  */


/* MESSAGE 'REAL Percent: ' nextPercent + FirstPercent - allPercent  VIEW-AS ALERT-BOX. */

		
		n_yach = NOMER_YACH(repDate,nextDate).
			
		tt-report.Pr4period[n_yach] = tt-report.Pr4period[n_yach] + nextPercent + FirstPercent - allPercent.  
		
		/*��-�� ���猪 � ���⮬ ��業⮢ ������騬 �⮣��  ���������� ����� �㬬� 㦥 �⭥ᥭ��� ��業⮢ �� ��⥣�ਨ */
		allpercent =  nextpercent.
		firstPercent = 0.

/*MESSAGE 'all Percent: ' allPercent VIEW-AS ALERT-BOX.*/
		
		/*������ ᫥������ ���� ���᫥��� ��業⮢*/
		nextDate = GetDpsNextDatePercentPayOut_ULL(loan.cont-code, DATE(nextDate + 1), traceOnOff).

/* MESSAGE 'Next next Date:) ' nextDate VIEW-AS ALERT-BOX. */
		
	END.
	end.

/*������ ��⥬ ��業�� ����뢠��� � ���� ������� ������, ��� ������� ⨯� �� �� �㤥� 
�����⢥���� ����� */
IF nextDate GE tt-report.LoanEndDate THEN
	DO:

		/*�����뢠�� �㬬� ��業⮢ �� ���� ������ ������*/
		nextPercent = GetDpsCurrentPersent_ULL(loan.cont-code, tt-report.LoanEndDate, traceOnOff).

		/*� �⭮ᨬ �� �� ���� ������ ������ */
		n_yach = NOMER_YACH(repDate,tt-report.LoanEndDate).
		tt-report.Pr4period[n_yach] = tt-report.Pr4period[n_yach] + nextPercent + firstPercent - allPercent.  

	END.
/*��! �� ࠧ��᫨ �� ��業��!!*/

/* MESSAGE Pr4Period[1] '  ' Pr4Period[2] '  ' Pr4Period[3] '  ' Pr4Period[4] '  ' Pr4Period[5] '  '
   Pr4Period[6] '  ' Pr4Period[7] '  ' Pr4Period[8] '  ' Pr4Period[9] '  ' Pr4Period[10] '  ' VIEW-AS ALERT-BOX. */

       	/* ��᫥ ᮢ�頭�� � ��⮢� �. �⠫� ����⭮, �� ��� ������ �� �ᥣ�� ᮮ⢥����� �᫮��� ������.
       	   ��� �⤥���� ������ � �믫�⮩ ��業⮢ 5 ��� 7, �� ⮫쪮 ��१�ࢨ஢����� �� ����� ����� ��� ��� ��� 5 ��� 7 ���� ���� �� ����⭮.
       	   ���⮬� ����� �����७� �� ��. ����� ������ �� ����.
	   �� ������ � �믫�⮩ ��業⮢ ����� 3 ����� � ��।������ ���� � ����⠫���樥�.
	*/
       	if can-do("42306978800000000104,42307840700000000001,42307810400000735978,42307810700000735979,42307840300000000744",loan.cont-code) then do:
                nextDate = ?.
		Percent = 0.
		nextPercent = 0.
		/* ��ᬮ��ਬ �᫮��� �������*/
       		FIND LAST Loan-Cond WHERE Loan-Cond.contract = Loan.contract
       					AND Loan-Cond.cont-code = Loan.cont-code
       					AND Loan-Cond.since LE repDate
 					NO-LOCK NO-ERROR.

		FirstDate = Loan-Cond.since.
		/* ��ᬮ�ਬ ��� ��������� ��業�� */
		if Loan-Cond.int-period begins "��[" then do:
			/* ��ਮ� � ������ */ 
			PeriodM = SUBSTRING(Loan-Cond.int-period,INDEX(Loan-Cond.int-period,"[") + 1,INDEX(Loan-Cond.int-period,"]") - INDEX(Loan-Cond.int-period,"[") - 1).
			/* ��ࢠ� ��� �믫��� ��業⮢ � ���� ���� */ 
    			do while FirstDate < repDate :
				FirstDate = Date((month(FirstDate) + dec(PeriodM)) MODULO 12,Loan-Cond.int-date,if month(FirstDate) + dec(PeriodM) > 12 then year(FirstDate) + 1 else year(FirstDate)).
				if FirstDate gt loan.end-date then FirstDate = loan.end-date.
        		end.
		end.

		if Loan-Cond.int-period eq "�" then do:
			/* ��ਮ� � ������ */ 
			PeriodM = "3".
			FirstDate = Date(month(repDate),Loan-Cond.int-date,year(repDate)).	
			/* ��ࢠ� ��� �믫��� ��業⮢ � ���� ���� */ 
    			do while month(FirstDate) MODULO 3 <> 1 :
				FirstDate = Date((month(FirstDate) + 1) MODULO 12,Loan-Cond.int-date,if month(FirstDate) + 1 > 12 then year(FirstDate) + 1 else year(FirstDate)).
				if FirstDate gt loan.end-date then FirstDate = loan.end-date.
        		end.
		end.

		/*��ᬮ�ਬ ���⮪ �� ��� ��筮�� ������*/
		FIND FIRST LAcct where CAN-DO("loan-dps-t,loan-dps-p",LAcct.acct-type) 
				and LAcct.cont-code = Loan.cont-code
				and LAcct.since LE repDate
				and LAcct.contract eq "dps"
				NO-LOCK NO-ERROR.
		RUN acct-pos in h_base (LAcct.acct,LAcct.currency,repDate,repDate,gop-status).
		OstSumma = (IF Lacct.currency EQ "" THEN abs(sh-bal) ELSE abs(sh-val)).
		/*���쬥� ��業��� �⠢��*/
       		ProcStavka = tt-report.rate. 

		/* � ���� FirstDate ��室���, ⮣�� ��⠥� ��業�� �� ᫥�. ࠡ. ����*/
       		do while {holiday.i FirstDate} :
			FirstDate = FirstDate + 1.
                end.
		/*������⢮ ����*/
		PeriodD = FirstDate - RepDate + 1.

		/* ����ਬ ��᮪��� ���. ���砩 �᫨ ���⭠� ��� 01.12.15, � �믫�� 22.01.16. 
		   ����� � 01.12.15 �� 31.12.15 ��業�� ��⠥� �� 365, � � 01.01.16 �� 22.01.16 ��⠥� ��業�� �� 366
		*/
		
		if Year(FirstDate) <> Year(RepDate) then do:
			vYear = Year(RepDate) MODULO 4.
			if vYear = 0 then do:
				PeriodD = date(12,31,Year(RepDate)) - RepDate + 1. 
				Percent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
				PeriodD = FirstDate - date(1,1,Year(FirstDate)). 
				Percent = Percent + round(OstSumma * ProcStavka / 365 * PeriodD,2).
			end.
			vYear = Year(FirstDate) MODULO 4.		
			if vYear = 0 then do:
				PeriodD = date(12,31,Year(RepDate)) - RepDate + 1. 
				Percent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
				PeriodD = FirstDate - date(1,1,Year(FirstDate)) + 1. 
				Percent = Percent + round(OstSumma * ProcStavka / 366 * PeriodD,2).
			end.
   		end.
		/* ��⠥� ��業�� */
		if Percent = 0 then do:
			vYear = Year(RepDate) MODULO 4.		
                        if vYear = 0 then Percent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
			else Percent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
		end.
		RUN acct-pos in h_base (Loan-Acct.acct,Loan-Acct.currency,repDate,repDate,gop-status).
		/* �ਡ���塞 㦥 ���᫥��� ��業�� �� 474* */
                Percent = Percent + (if Loan-Acct.currency EQ "" THEN abs(sh-bal) ELSE abs(sh-val)).

		if PeriodD le 1 then tt-report.Pr4period[1] = tt-report.Pr4period[1] + Percent.
		if PeriodD gt 1 and PeriodD le 5 then tt-report.Pr4period[2] = tt-report.Pr4period[2] + Percent.
		if PeriodD gt 5 and PeriodD le 10 then tt-report.Pr4period[3] = tt-report.Pr4period[3] + Percent.
		if PeriodD gt 10 and PeriodD le 20 then tt-report.Pr4period[4] = tt-report.Pr4period[4] + Percent.
		if PeriodD gt 20 and PeriodD le 30 then tt-report.Pr4period[5] = tt-report.Pr4period[5] + Percent.
		if PeriodD gt 30 and PeriodD le 90 then tt-report.Pr4period[6] = tt-report.Pr4period[6] + Percent.
		if PeriodD gt 90 and PeriodD le 180 then tt-report.Pr4period[7] = tt-report.Pr4period[7] + Percent.
		if PeriodD gt 180 and PeriodD le 270 then tt-report.Pr4period[8] = tt-report.Pr4period[8] + Percent.
		if PeriodD gt 270 and PeriodD le 365 then tt-report.Pr4period[9] = tt-report.Pr4period[9] + Percent.
		if PeriodD gt 365 then tt-report.Pr4period[6] = tt-report.Pr4period[10] + Percent.

		do IDate = FirstDate to loan.end-date - 1 :
        		/* ᫥����� ��� �믫��� ��業⮢ */ 
        		NextDate = Date((month(FirstDate) + dec(PeriodM)) MODULO 12,Loan-Cond.int-date,if month(FirstDate) + dec(PeriodM) > 12 then year(FirstDate) + 1 else year(FirstDate)). 
        		/* ᫥���騩 ��ਮ� �믫��� ��業⮢*/ 
			if NextDate gt loan.end-date then NextDate = loan.end-date.
        		/* � ���� NextDate ��室���, ⮣�� ��⠥� ��業�� �� ᫥�. ࠡ. ����*/
               		do while {holiday.i NextDate} :
        			NextDate = NextDate + 1. 
                        end.

        		PeriodD =  NextDate - FirstDate.
			OstSumma = OstSumma + Percent.
			/* ᬮ�ਬ ��᮪��� �� ��� */
                	if Year(FirstDate) <> Year(NextDate) then do:
                		vYear = Year(FirstDate) MODULO 4.
                		if vYear = 0 then do:
                			PeriodD = date(12,31,Year(FirstDate)) - FirstDate. 
                			nextPercent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
                			PeriodD = NextDate - date(1,1,Year(NextDate)) + 1. 
                			nextPercent = nextPercent + round(OstSumma * ProcStavka / 365 * PeriodD,2).
                		end.
                		vYear = Year(NextDate) MODULO 4.		
                		if vYear = 0 then do:
                			PeriodD = date(12,31,Year(FirstDate)) - FirstDate. 
                			nextPercent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
                			PeriodD = NextDate - date(1,1,Year(NextDate)). 
                			nextPercent = nextPercent + round(OstSumma * ProcStavka / 366 * PeriodD,2).
                		end.
           		end.
                	/* ��⠥� ��業�� */
                	if nextPercent = 0 then do:
                		vYear = Year(NextDate) MODULO 4.		
                                if vYear = 0 then nextPercent = round(OstSumma * ProcStavka / 366 * PeriodD,2).
                		else nextPercent = round(OstSumma * ProcStavka / 365 * PeriodD,2).
                	end.
/*                        nextPercent = round(OstSumma * ProcStavka / 365 * PeriodD,2).*/
                        FirstDate = NextDate.
			IDate = FirstDate.
        		Percent = nextPercent.
        		if nextDate - repDate le 1 then tt-report.Pr4period[1] = tt-report.Pr4period[1] + nextPercent.
        		if nextDate - repDate gt 1 and nextDate - repDate le 5 then tt-report.Pr4period[2] = tt-report.Pr4period[2] + nextPercent.
        		if nextDate - repDate gt 5 and nextDate - repDate le 10 then tt-report.Pr4period[3] = tt-report.Pr4period[3] + nextPercent.
        		if nextDate - repDate gt 10 and nextDate - repDate le 20 then tt-report.Pr4period[4] = tt-report.Pr4period[4] + nextPercent.
        		if nextDate - repDate gt 20 and nextDate - repDate le 30 then tt-report.Pr4period[5] = tt-report.Pr4period[5] + nextPercent.
        		if nextDate - repDate gt 30 and nextDate - repDate le 90 then tt-report.Pr4period[6] = tt-report.Pr4period[6] + nextPercent.
        		if nextDate - repDate gt 90 and nextDate - repDate le 180 then tt-report.Pr4period[7] = tt-report.Pr4period[7] + nextPercent.
        		if nextDate - repDate gt 180 and nextDate - repDate le 270 then tt-report.Pr4period[8] = tt-report.Pr4period[8] + nextPercent.
        		if nextDate - repDate gt 270 and nextDate - repDate le 365 then tt-report.Pr4period[9] = tt-report.Pr4period[9] + nextPercent.
        		if nextDate - repDate gt 365 then tt-report.Pr4period[10] = tt-report.Pr4period[10] + nextPercent.
			nextPercent = 0.
		end.
                nextDate = ?.
		Percent = 0.
		nextPercent = 0.
	end.

END. /* �����襭�� ��ࠡ�⪨ ��� ������஢ */




{setdest.i}

PUT UNFORMATTED "���饭�� ��業�� �� �������� �������, �������� � �믫��" AT 35 SKIP.
PUT UNFORMATTED "�� ����� �� " AT 50 repDate FORMAT "99/99/9999" SKIP(1).


FOR EACH tt-report BREAK BY balAcct%% BY tt-report.currency :
/*	IF FIRST-OF(balAcct%%) THEN 
		DO:
			PUT UNFORMATTED "��業�� �� �����ᮢ��� ���� " tt-report.balAcct%% SKIP(1).
		END.
*/
	IF FIRST-OF(tt-report.currency) THEN
		DO:
/*			PUT UNFORMATTED "�� ������⠬ � ����� " tt-report.currency ":" SKIP(1).*/
			i = 0.
			totalSumma%% = 0.
			PUT UNFORMATTED 
				"� �/� "
				"|�����稪                      "
				"|���" 
				"|������� �                "
            			"|�����    "
        	       		"|������   "
        		        "|��� ��業⮢      "
				"|�㬬� %% �� 474"
				"|�⠢��"
				"|�㬬� ������   "
				"|��� ������"
				"|         �㬬�, �������� � �믫�� � ᮮ⢥��⢨� � �ப�� �� ���⭮� ���� �� ���� ����襭��                                                            "
				SKIP.
			PUT UNFORMATTED 
				"      "
				"|                              "
				"|   " 
				"|                         "
             			"|          "
         	       		"|          "
         		        "|                    "
				"|               "
				"|      "
				"|               "
				"|          "
				"|---------------------------------------------------------------------------------------------------------------------------------------------------------------"
				SKIP.
			PUT UNFORMATTED 
				"      "
				"|                              "
				"|   " 
				"|                         "
            			"|          "
        	       		"|          "
        		        "|                    "
				"|               "
				"|      "
				"|               "
				"|          "
				"|  �� 1 ���     "
				"|  �� 5 ����    "
				"|  �� 10 ����   "
				"|  �� 20 ����   "
				"|  �� 30 ����   "
				"|  �� 90 ����   "
				"|  �� 180 ����  "
				"|  �� 270 ����  "
				"|  �� 1 ����    "
				"|  ���� 1 ���� "
				SKIP.
				put unformatted FILL("-",320) SKIP.
		END.
	i = i + 1.

	totalSumma%% = 	totalSumma%% + Summa%% .
	allpr4period[1]= allpr4period[1] + pr4period[1] .
	allpr4period[2]= allpr4period[2] + pr4period[2] .
	allpr4period[3]= allpr4period[3] + pr4period[3] .
	allpr4period[4]= allpr4period[4] + pr4period[4] .
	allpr4period[5]= allpr4period[5] + pr4period[5] .
	allpr4period[6]= allpr4period[6] + pr4period[6] .
	allpr4period[7]= allpr4period[7] + pr4period[7] .
	allpr4period[8]= allpr4period[8] + pr4period[8] .
	allpr4period[9]= allpr4period[9] + pr4period[9] .
	allpr4period[10]= allpr4period[10] + pr4period[10] .
	

	PUT UNFORMATTED
		i FORMAT ">>>>>>"
		"|" tt-report.clientName FORMAT "x(30)"
		"|" tt-report.currency FORMAT "XXX" 
		"|" tt-report.loanInfo FORMAT "x(25)"
   		"|" tt-report.loanOpenDate FORMAT "99/99/9999"
       	"|" tt-report.loanEndDate FORMAT "99/99/9999"
   		"|" tt-report.intAccount FORMAT "x(20)"
		"|" tt-report.summa%% FORMAT "->>>,>>>,>>9.99"
		"|" (tt-report.rate * 100) FORMAT ">>9.99"
		"|" tt-report.summaDeposit FORMAT "->>>,>>>,>>9.99"
   		"|" tt-report.dpstype FORMAT "x(10)"
		"|" tt-report.pr4period[1] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[2] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[3] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[4] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[5] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[6] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[7] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[8] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[9] FORMAT "->>>,>>>,>>9.99"
		"|" tt-report.pr4period[10] FORMAT "->>>,>>>,>>9.99"
	
		
		SKIP.
	
	IF LAST-OF(tt-report.currency) THEN
		DO:
			PUT UNFORMATTED	  FILL("-",320) SKIP
			  "�����"	
			  FILL(" ",106)
			  totalSumma%%  FORMAT "->>>,>>>,>>9.99" " "
			  FILL(" ",34) 
			  allpr4period[1] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[2] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[3] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[4] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[5] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[6] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[7] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[8] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[9] FORMAT "->>>,>>>,>>9.99" " "
			  allpr4period[10] FORMAT "->>>,>>>,>>9.99" " "
			  
			  SKIP(1).
			  
			  totalSumma%%  = 0.
			  allpr4period[1] = 0.
			  allpr4period[2] = 0.
			  allpr4period[3] = 0.  
			  allpr4period[4] = 0.
			  allpr4period[5] = 0.
			  allpr4period[6] = 0.
			  allpr4period[7] = 0.
			  allpr4period[8] = 0.
			  allpr4period[9] = 0.
			  allpr4period[10] = 0.
	

		END.
END.

PUT UNFORMATTED	"�⢥��⢥��� �ᯮ���⥫� � 5" SKIP.
PUT UNFORMATTED	"(�⢥��⢥��� �� �� ����)" SKIP(2).
PUT UNFORMATTED	"����஫�� ���. � 5" SKIP(3).

PUT UNFORMATTED	"�ਬ�砭�� � ���������� �ਫ������ :" SKIP.
PUT UNFORMATTED	"�� 1,2, 4 -10 ����������� � ᮮ⢥��⢨� � ������������� � ����" SKIP.  
PUT UNFORMATTED	"�� 4 㪠�뢠���� ��� ������ �뤠� �।�� 810 (�㡫�), 840 (����), 978 (���)" SKIP.
PUT UNFORMATTED	"�� 11 㪠�뢠���� ��ਮ��筮��� �믫��� %  (����*)" SKIP.
PUT UNFORMATTED	"�� 12-21 㪠�뢠���� �������� � �믫�� ��業��  � ᮮ⢥�����饬 �६����� ��ਮ��" SKIP. 
PUT UNFORMATTED	"* �⮣��� ���祭�� ����������� �� ��  12 - 21 � ࠧ१� ��� 2-�� ���浪�" SKIP.
PUT UNFORMATTED	" (�� ���� 47411 � ���� 47426) � ������ �ਢ��祭�� �������" SKIP.

{preview.i}


FUNCTION NOMER_YACH RETURNS INTEGER (INPUT date1 AS DATE, INPUT date2 AS DATE):
   DEFINE VAR vTmpStr AS INTEGER NO-UNDO.
   DEFINE VAR bdates AS INTEGER NO-UNDO.
   
   ASSIGN    bdates = date2 - date1 + 1 .    

/* MESSAGE 'kolvo dnei ' bdates VIEW-AS ALERT-BOX. */

      
      IF bdates <= 1 THEN 
      DO:
         vTmpStr = 1.
         RETURN vTmpStr.
      END.
      
      IF bdates > 1 AND bdates <= 5 THEN 
      DO:
         vTmpStr = 2.
         RETURN vTmpStr.
      END.
      
      IF bdates > 5 AND bdates <=10 THEN 
      DO:
         vTmpStr = 3.
         RETURN vTmpStr.
      END.
      
      IF bdates > 10 AND bdates <= 20 THEN 
      DO:
         vTmpStr = 4.
         RETURN vTmpStr.
      END.
      
      IF bdates > 20 AND bdates <= 30 THEN 
      DO:
         vTmpStr = 5.
         RETURN vTmpStr.
      END.
      
      IF bdates > 30 AND bdates <= 90 THEN 
      DO:
         vTmpStr = 6.
         RETURN vTmpStr.
      END.
      
      IF bdates > 90 AND bdates <= 180 THEN
      DO:
         vTmpStr = 7.
         RETURN vTmpStr.
      END.
      
      IF bdates > 180 AND bdates <= 270 THEN 
      DO:
         vTmpStr = 8.
         RETURN vTmpStr.
      END.

      IF bdates > 270 AND bdates <= 365 THEN 
      DO:
         vTmpStr = 9.
         RETURN vTmpStr.
      END.
    
      IF bdates > 365  THEN 
      DO:
         vTmpStr = 10.
         RETURN vTmpStr.
      END.
      
  
END. /*function*/




