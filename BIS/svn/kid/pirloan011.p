{pirsavelog.p}

/**
 * ��ᯮ�殮��� �� �뤠�� �।��.
 * ���� �.�., 22.02.2006 12:43
 */

/** �������� ��६���� � ��।������ */
{globals.i}

{get-bankname.i}

/** ��� ������⥪� �㭪権 */
{ulib.i}
/** ��७�� ��ப */
{wordwrap.def}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/** �����᪨� �ਧ��� ⮣�, �� ������� ����� �祭��/����� */
DEF VAR hasTransh AS LOGICAL NO-UNDO.
/** ��砫쭨�� ��直� */
DEF VAR bosD2 AS CHAR NO-UNDO.
DEF VAR bosLoan AS CHAR NO-UNDO.
DEF VAR bosKazna AS CHAR NO-UNDO.
/** ���� �ᯮ�殮��� */
/** ��� �ᯮ�殮���: �� ���� ���㬥�� */
DEF VAR rDate AS DATE NO-UNDO.
/** ������ ��� ���� ���, �� ����� �뤠���� �।�⢠ */
DEF VAR acctCr AS CHAR NO-UNDO.
/** �㬬� �뤠������� �।�� */
DEF VAR summa AS DECIMAL NO-UNDO.
DEF VAR summaStr AS CHAR EXTENT 3 NO-UNDO.
/** ����� ����樨, �筥� �� ��஢�� ���. ��� �㡫�� ��� "" */
DEF VAR currency AS CHAR NO-UNDO.
/** ����� ����樨, �⮡ࠦ����� � �ଥ. ��� �㡫�� ��� "810" */
DEF VAR currencyPrint AS CHAR NO-UNDO.
/** ��㤭� ��� */
DEF VAR loanAcct AS CHAR NO-UNDO.
/** ����騪 */
DEF VAR clientName AS CHAR EXTENT 3 NO-UNDO.
/** �।��� ������� */
DEF VAR loanNo AS CHAR NO-UNDO.
DEF VAR currLoanNo AS CHAR NO-UNDO.

DEF VAR loanDate AS CHAR NO-UNDO.
/** �ப ����⢨� ������� */
DEF VAR loanPeriod AS CHAR NO-UNDO.
DEF VAR begLoanPeriod AS DATE NO-UNDO.
DEF VAR endLoanPeriod AS DATE NO-UNDO.

DEF VAR DataZakl  AS DATE NO-UNDO.
DEF VAR DataEnd   AS DATE NO-UNDO.

DEF VAR DogPeriod AS CHARACTER NO-UNDO.

/** �ਧ��� �࠭� */
DEF VAR isTransh AS LOGICAL NO-UNDO.
/** �ப ����⢨� �।�⭮� �����/�࠭� */
DEF VAR transhPeriod AS CHAR NO-UNDO.
DEF VAR begTranshPeriod AS DATE NO-UNDO.
DEF VAR endTranshPeriod AS DATE NO-UNDO.
/** ��� ����� TRUE-�뤠�/FALSE-������������ */
DEF VAR limitType AS LOGICAL NO-UNDO.
/** ����� ������������/�뤠� */
DEF VAR limit AS DECIMAL NO-UNDO.
/** ��� ��� ����� */
DEF VAR limitAcct AS CHAR NO-UNDO.
/** ���ᯮ�짮����� ����� */
DEF VAR availLimit AS DECIMAL NO-UNDO.
/** ��業⭠� �⠢�� */
DEF VAR rate AS DECIMAL NO-UNDO.
/** �ப 㯫��� ��業⮢ */
DEF VAR percentTerm AS CHAR NO-UNDO.
/** ��⥣��� ����⢠: ��㯯� � ��業� �᪠ */
DEF VAR risk AS CHAR NO-UNDO.
/** ���ᯥ祭�� */
DEF VAR backing AS CHAR NO-UNDO.
DEF VAR backingTotalSumma AS DECIMAL NO-UNDO.
DEF VAR backLoans AS CHAR EXTENT 10 NO-UNDO.
DEF VAR backSumma AS DECIMAL EXTENT 10 NO-UNDO.
/** ������ ��蠤�� */
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpStrArr AS CHAR EXTENT 4 NO-UNDO.
/** ����� */
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR j AS INTEGER NO-UNDO.
/** �ᯮ���⥫� */
DEF VAR ExecFIO AS CHAR NO-UNDO.

/***********************************
 * ����: ��᫮� �. �.(Maslov D. A.)
 * ��� (Event): #607
 * �����䨪��� �������.
 ***********************************/

DEF VAR cDocID AS CHARACTER NO-UNDO.

/*** ����� #607 ***/
/***********************************
 * ����: ��᪮� �.�.
 * ��� (Event): #718
 * �����䨪��� �������.
 ***********************************/

DEF VAR oAcct AS TAcct NO-UNDO.

/*** ����� #718 ***/

/** �᭮����� */
DEF VAR evidence AS CHAR
	LABEL "����� �᭮�����"
	VIEW-AS 
	EDITOR SIZE 48 BY 7 NO-UNDO.

/** ���⠥� ��砫쭨��� */
bosLoan = FGetSetting("PIRboss","PIRbosloan","").
bosKazna = FGetSetting("PIRboss","PIRbosKazna","").
bosD2 = FGetSetting("PIRboss","PIRbosD2","").
FIND FIRST _user WHERE _user._userid = userid NO-LOCK NO-ERROR.
IF AVAIL _user THEN
	ExecFIO = _user._user-name.
ELSE
	ExecFIO = "-".

/** ������ ���㬥��, ��࠭�� � ��㧥� */
FOR FIRST tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
    FIRST op-entry OF op NO-LOCK
:
		/** ����� ���� ��� �஢�ப */
		/** 1. �஢���� ������ ���� �ਢ易�� � �������� */
		IF NOT op-entry.kau-db BEGINS "�।��," THEN DO:
			MESSAGE "������ �� �ਢ易�� � ��������!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		/** 2. �஢���� ������ ���� �ਢ易�� � ����� 4 */
		IF ENTRY(3, op-entry.kau-db) <> "4" THEN DO:
			MESSAGE "�� �� ������ �뤠� �।��!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		
		/** ���࠭�� ���祭�� */
		rDate = op.op-date.
		acctCr = op-entry.acct-cr.
		currency = op-entry.currency.
		currencyPrint = (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency).
		summa = (IF currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur).
		/* �㬬� �ய���� */
		RUN x-amtstr.p(summa,currency,TRUE,TRUE,OUTPUT summaStr[1], OUTPUT summaStr[2]).
		/** ������� 楫� � �஡�� ������� � ���� ��६����� */
		summaStr[1] = summaStr[1] + ' ' + summaStr[2].
		/** ��ࢠ� �㪢� ������ ���� ��������� */
		SUBSTRING(summaStr[1],1,1) = CAPS(SUBSTRING(summaStr[1],1,1)).
		{wordwrap.i &s=summaStr &l=40 &n=3}
		
		loanAcct = op-entry.acct-db.

		/** ��।����, ���� �� ������� �祭��� */
		tmpStr = GetMainLoan_ULL(ENTRY(1, op-entry.kau-db), ENTRY(2, op-entry.kau-db), false).
	
		/******************************************
		 * ����: ��᫮� �. �. (Maslov D. A.)
		 * ��� (Event): #607
		 ******************************************/
			cDocID = getMainLoanAttr("�।��",ENTRY(2,tmpStr),"%cont-code �� %��⠑���").
		/*** ����� #607 ***/


		loanNo = ENTRY(1, op-entry.kau-db) + "," + ENTRY(2, op-entry.kau-db).

		/** �᫨ �� �࠭�, � ���᫨� ��ਮ� �।�⮢���� ��� ����*/
		IF tmpStr <> loanNo THEN 
			DO:
				isTransh = TRUE.
			END.

		/** ����� ࠡ�⠥� � �墠�뢠�騬 ������஬ */
		currLoanNo = loanNo.
		loanNo = tmpStr.

		
		clientName[1] = GetLoanInfo_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "client_short_name", false).
		{wordwrap.i &s=clientName &l=40 &n=3}
		

		loanDate = GetLoanInfo_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "open_date", false).

				/************************************
				 * ��ࠢ���� ��� ��砫� ����⢨�
				 * �������. ������ ��� ������
				 * � ���� beg-date �������.
				 * ����: ��᫮� �. �. Maslov D. A.
				 * ���: #670
				 ************************************/
					/******************              
					 * �ᥣ� � �������
					 * ��� ��ਮ��:
					 * ���� �������� - ᬮ����� �� �墠�뢠�饬 �
					 * ���� �����祭�� �� ���� ����砭��.
					 * ���� �������� ���� ��� ������ � ��������.
					 *
					 * ���� - ᬮ����� � ���� ������ �� ���� ���������,
					 * ������� �� �࠭襩.
					 ********************/
					 /*******************
					  * !!! �������� !!!
					  * 1. ����� currLoanNo - �� ����� �������,
					  * � ���஬� �ਢ易�� �஢���� (� ⮬ �᫥ � �࠭�).
					  * 2. ����� loanNo - �� ����� �墠�뢠�饣� ������.
					  * ���: #693.
					  * ��᫮� �. �. Maslov D. A.
					  **********************/
					  


					dataZakl = DATE(getMainLoanAttr("�।��",ENTRY(2,currLoanNo),"%��⠑���")).
					dataEnd  = DATE(getMainLoanAttr("�।��",ENTRY(2,currLoanNo),"%��⠎�")).

					begLoanPeriod = DATE(getLoanAttr("�।��",ENTRY(2,currLoanNo),"%��⠍��")).
					endLoanPeriod = DATE(GetLoanInfo_ULL("�।��", ENTRY(2,currLoanNo), "end_date", false)).
	 	
				dogPeriod = "c " + STRING(begLoanPeriod,"99/99/9999")
					+ " �� " + STRING(endLoanPeriod,"99/99/9999") + "(" + STRING(endLoanPeriod - begLoanPeriod) + " ����)".

                                /*** �ப ����⢨� �।�⭮�� ������� ***/
				loanPeriod = "c " + STRING(dataZakl)
						  + " �� " + STRING(dataEnd, "99/99/9999") + " (" + STRING(dataEnd - dataZakl) + " ����)".

					 /*** ����� #670 ***/
			
		/** �᫨ �� �࠭�, � �㦭� �뢥�� ���ଠ�� � ����� */
		IF isTransh THEN DO:
		limit = GetLoanLimit_ULL(ENTRY(1,loanNo), ENTRY(2, loanNo), op.op-date, false).
		limitAcct = GetLoanAcct_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "�।���", rDate, false).
		IF limitAcct <> "" THEN 
			limitType = TRUE.
		ELSE	
			DO:
				limitAcct = GetLoanAcct_ULL(ENTRY(1,loanNo), ENTRY(2,loanNo), "�।�", rDate, false).
				IF limitAcct <> "" THEN
					limitType = FALSE.
				ELSE
					DO:
						MESSAGE "��� ����� �� ������!" VIEW-AS ALERT-BOX.
					END.
			END.

		/* ��� # 718 */
		
/*                availLimit = ABS(GetAcctPosValue_UAL(limitAcct, currency, rDate - 1, false)).*/

                oAcct = new TAcct(limitAcct).
		availLimit = ABS(oAcct:getLastPos2Date(rDate)) + summa.
		DELETE OBJECT oAcct.

		/* ��� # 718 */

		END. /* isTransh */
		
		/** ��業⭠� �⠢�� */
		rate = GetLoanCommission_ULL(ENTRY(1,loanNo),ENTRY(2,loanNo),"%�।",rDate, false).
		/** �ப 㯫��� ��業⮢. ������ ���㠫�� �� ���� ���㬥�� �᫮��� ������� */
		FIND LAST loan-cond WHERE
			loan-cond.contract = ENTRY(1,loanNo)
			AND
			loan-cond.cont-code = ENTRY(2,loanNo)
			AND
			loan-cond.since LE rDate
			NO-LOCK NO-ERROR.
		IF AVAIL loan-cond THEN
			DO:

				IF loan-cond.int-date = 31 THEN 
					percentTerm = "�������筮 �� ������� ��᫥����� ࠡ�祣� ��� �����".
				ELSE
					percentTerm = "�������筮 " + STRING(loan-cond.int-date) + " �᫠".

				if loan-cond.int-period = "��" then
					percentTerm = "� ���� �ப�".
			END.
			
		risk = GetLoanInfo_ULL(ENTRY(1,loanNo),ENTRY(2,loanNo),"gr_riska,risk", false).
		
		/** ���ᯥ祭�� */
		i = 0.
        /************
            Modifed By Maslov D.
            Event: #456
            Ia dobavil uslovit "AND (term-obl.sop-date GE rDate OR term-obl.sop-date EQ ?)"
        ************/
		FOR EACH term-obl WHERE
			term-obl.contract = ENTRY(1,loanNo)
			AND
			term-obl.cont-code = ENTRY(2,loanNo)
			AND
			term-obl.idnt = 5 
            AND (term-obl.sop-date GE rDate OR term-obl.sop-date EQ ?)
			NO-LOCK:
			i = i + 1.
			tmpStr = ENTRY(1,loanNo) + "," + ENTRY(2,loanNo) + "," + STRING(term-obl.idnt) + "," + 
				STRING(term-obl.end-date) + "," + STRING(term-obl.nn).
			
			/** 
			 * ��ଠ� ���祭�� � ����� ���ᨢ� backLoans: 
			 * <�������� ���� ���ᯥ祭��>,<����� ���. ���ᯥ祭��> 
			 */
			backLoans[i] = GetXAttrValueEx("term-obl",tmpStr,"��������","").
			
			FIND FIRST code WHERE code.class = "��������" AND code.code = backLoans[i] NO-LOCK NO-ERROR.
			IF AVAIL code THEN DO:
				backLoans[i] = code.name + ",".
			END.
			
            /* Modify By Maslov D. A.
                ���: #320

			backLoans[i] = backLoans[i] + "�" + GetXAttrValueEx("term-obl",tmpStr,"��������","") + " �� " 
				+ GetXAttrValueEx("term-obl",tmpStr,"��⠏���","").
            */

			backLoans[i] = backLoans[i] + "�" + GetXAttrValueEx("term-obl",tmpStr,"��������","") + " �� " 
				+ STRING(term-obl.fop-date).
			
			backSumma[i] = term-obl.amt.
			backingTotalSumma = backingTotalSumma + term-obl.amt.
		END.
		
		/** ����訢��� � ���짮��⥫� �᭮����� �뤠� �।�� */
		
		pause 0.
		/*DISPLAY evidence.*/
		SET evidence WITH FRAME frmTmp CENTERED.

		/********************************************
		 *								 *
		 * ����: ��᫮� �. �. (Maslov D. A.)     *
		 * ���: #635					 *
		 *							         *
		 ********************************************/

			evidence = evidence + " " + cDocID.

		/******* ����� #635 *******/
		
		/** ��稭��� �ନ஢��� ����� ���㬥�� */
		
		{setdest.i}
		
		PUT UNFORMATTED 
		SPACE(50) "�⢥ত��" SKIP
		SPACE(50) ENTRY(1,bosD2) SKIP
		SPACE(50) ENTRY(2,bosD2) SKIP(2)
		SPACE(50) "� �����⠬��� 3" SKIP
		SPACE(50) cBankName SKIP(2)
		SPACE(50) '���: ' op.op-date FORMAT "99/99/9999" SKIP(2)
		SPACE(20) '� � � � � � � � � � � �' SKIP(1)
		SPACE(4) '�ந����� �뤠�� �।��:' SKIP
		'�������������������������������������������������������������������������������' SKIP
		'�� ����              �' acctCr FORMAT "x(20)" SKIP
		'�������������������������������������������������������������������������������' SKIP
		'�����                �' summa FORMAT "->>>,>>>,>>>,>>9.99" SKIP
		'                     �' summaStr[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF summaStr[i] <> "" THEN 
				PUT UNFORMATTED '                     �' summaStr[i] FORMAT "x(40)" SKIP.
		END.
		PUT UNFORMATTED
		'�������������������������������������������������������������������������������' SKIP
		'������               �' currencyPrint FORMAT "xxx" SKIP
		'�������������������������������������������������������������������������������' SKIP.

		/********************
		 * ����: ��᫮� �. �. Maslov D. A.
		 * ���: #370
		 * ��ࠢ���� �訡��
		 * ��।������ �ப� �.�.
		 ********************/
		/** �᫨ �� �࠭�, � �ப �।�⮢���� �࠭�, ���� �ப ������� */

		PUT UNFORMATTED				'����                 �' dogPeriod	SKIP.

		
		PUT UNFORMATTED
		'�������������������������������������������������������������������������������' SKIP
		'������� ���� �       �' loanAcct FORMAT "x(20)" SKIP
		'�������������������������������������������������������������������������������' SKIP
		'�������              �' clientName[1] FORMAT "x(40)" SKIP.
		DO i = 2 TO 3 :
			IF clientName[i] <> "" THEN
				PUT UNFORMATTED     '                     �' clientName[i] FORMAT "x(40)" SKIP.
		END. 		

		/*******************
		 *
		 * ����: ��᫮� �. �. (Maslov D.A.)
		 * ��� (Event):  #607
		 *
		 *******************/

		PUT UNFORMATTED
		'�������������������������������������������������������������������������������' SKIP
		'��������� �������    �' cDocID SKIP
		'�������������������������������������������������������������������������������' SKIP.
		
		/** �᫨ ������� - �࠭�, � �뢥��� �ப �墠�뢠�饣� ������� */
		IF isTransh THEN
			DO:
				PUT UNFORMATTED '���� �������� ���.   �' loanPeriod	SKIP
 												'�������������������������������������������������������������������������������' SKIP.
			END.
		IF isTransh THEN 
			PUT UNFORMATTED
			'����� ' IF limitType THEN '������         ' ELSE '�������������  ' '�' limit FORMAT "->>>,>>>,>>>,>>9.99" SKIP
			'�������������������������������������������������������������������������������' SKIP
			'���� ����� ������ �  �' limitAcct FORMAT "x(20)" SKIP
			'�������������������������������������������������������������������������������' SKIP
			'���������������� ���.�' availLimit FORMAT "->>>,>>>,>>>,>>9.99" SKIP.
		
		/** ��業�� */
		PUT UNFORMATTED
		'�������������������������������������������������������������������������������' SKIP
		'���������� ������    �' STRING(rate * 100,">>9.99") '% �������' SKIP
		'�������������������������������������������������������������������������������' SKIP
		'���� ������ ����������' percentTerm SKIP
		'�������������������������������������������������������������������������������' SKIP
		'��������� ��������   �' ENTRY(1,risk) '(' ENTRY(2,risk) '%)' SKIP
		'�������������������������������������������������������������������������������' SKIP
		'�����������          �'  SKIP
		'                ������' backingTotalSumma FORMAT "->>>,>>>,>>>,>>9.99" SKIP
		'          � ⮬ �᫥�' SKIP.
		DO i = 1 TO 10 :
			IF backLoans[i] <> "" THEN DO:
				
				/** 
				 * �������� ���� ���ᯥ祭�� ������ ��������� ��ࠦ�����,
				 * ᫥����⥫쭮 �㦭� �믮����� ��७�� �� ��ப��
				 */				
				tmpStrArr[1] = ENTRY(1, backLoans[i]).
				{wordwrap.i &s=tmpStrArr &l=21 &n=3}
				PUT UNFORMATTED	tmpStrArr[1] FORMAT "x(21)" '�' SKIP.
				DO j = 2 TO 3 :	IF tmpStrArr[j] <> "" THEN
						PUT UNFORMATTED tmpStrArr[j] FORMAT "x(21)" '�' SKIP.
				END.
				
				/** ����⢥���, ᠬ ����� ������� � �㬬� ���ᯥ祭�� */
				PUT UNFORMATTED
					ENTRY(2, backLoans[i]) FORMAT "x(21)" '�' backSumma[i] FORMAT "->>>,>>>,>>>,>>9.99" SKIP.
			END.
		END.

		tmpStrArr[1] = evidence.
		{wordwrap.i &s=tmpStrArr &l=40 &n=4}
		PUT UNFORMATTED
		'�������������������������������������������������������������������������������' SKIP
		'���������            �' tmpStrArr[1] FORMAT "x(40)" SKIP.
		
		DO i = 2 TO 4 : IF tmpStrArr[i] <> "" THEN
			PUT UNFORMATTED '                     �' tmpStrArr[i] FORMAT "x(40)" SKIP.
		END.
		
		PUT UNFORMATTED
		'�������������������������������������������������������������������������������' SKIP(1)
		SPACE(4) ENTRY(1,bosKazna) SPACE(50 - LENGTH(ENTRY(1,bosKazna))) ENTRY(2,bosKazna) SKIP(1)
		SPACE(4) ENTRY(1,bosLoan) SPACE(50 - LENGTH(ENTRY(1,bosLoan))) ENTRY(2,bosLoan) SKIP(2)
		SPACE(4) '�ᯮ���⥫�: ' ExecFIO SKIP.
		{preview.i}
END.

/** ����� � �࠭� ��� ����� ⥪�� �᭮����� */
hide frame frmTmp.
