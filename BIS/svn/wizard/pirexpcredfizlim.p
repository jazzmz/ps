{pirsavelog.p}

/** 
		��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2010

		�ந������ �ᯮ�� ������ � �ଠ� afx �� �।�⭮� ����� 䨧��᪮�� ���.
		
		���� �.�., 12.10.2010, 10:20
		
		<���_����᪠����> : �� ��㧥� �।���� ������஢
		<��ࠬ���� ����᪠> : ������ ��� 䠩�� �ᯮ��.
		<���_ࠡ�⠥�> : ����������� ��楤��� ��� �ᯮ�� ������ �������樨. ��᫥ ᡮ� 
						�ᥩ ���ଠ樨 �� �뤥������ � ��㧥� �������� �� ��楤��� ��뢠���� � 
						ᮮ⢥����騬� ��ࠬ��ࠬ�.
		<�ᮡ������_ॠ����樨>
		
		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

*/

/** �������� ��।������ */
{globals.i}

/** ������⥪� ���� ᮡ�⢥���� �㭪権 */
{ulib.i}

/** ������祭�� ���������� �ᯮ�짮���� ���ଠ�� ��㧥� */
{tmprecid.def}

{intrface.get strng}

/** ����ணࠬ�� �ᯮ�� �������権 */
FUNCTION exp_agree RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR,	INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, 
			INPUT arg6 AS CHAR,
			INPUT arg7 AS CHAR,	INPUT arg8 AS CHAR,
			INPUT arg9 AS CHAR,	INPUT arg10 AS CHAR,
			INPUT arg11 AS CHAR,	INPUT arg12 AS CHAR,
			INPUT arg13 AS CHAR,	INPUT arg14 AS CHAR,
			INPUT arg15 AS CHAR,	INPUT arg16 AS CHAR,
			INPUT arg17 AS CHAR,	INPUT arg18 AS CHAR,
			INPUT arg19 AS CHAR
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction =                "<agreement>" + CHR(13) + CHR(10).
			construction = construction + "number=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "currency=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "open_date=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "end_date=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "summa=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "rate=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "firstpayratedate=" + arg7 + CHR(13) + CHR(10).
			construction = construction + "firstpayloandate=" + arg8 + CHR(13) + CHR(10).
			construction = construction + "rate_kind=" + arg9 + CHR(13) + CHR(10).
			construction = construction + "intpay=" + arg10 + CHR(13) + CHR(10).
			construction = construction + "intnextpaym=" + arg11 + CHR(13) + CHR(10).
			construction = construction + "intpaydaym=" + arg12 + CHR(13) + CHR(10).
			construction = construction + "intnextpayk=" + arg13 + CHR(13) + CHR(10).
			construction = construction + "intpaydayk=" + arg14 + CHR(13) + CHR(10).
			construction = construction + "pena_canfast_need=" + arg15 + CHR(13) + CHR(10).
			construction = construction + "countmonth=" + arg16 + CHR(13) + CHR(10).
			construction = construction + "safe_need=" + arg17 + CHR(13) + CHR(10).
			construction = construction + "guaranty_need=" + arg18 + CHR(13) + CHR(10).
			construction = construction + "safe_need=notneed" + CHR(13) + CHR(10).
			construction = construction + "lim_type=" + arg19 + CHR(13) + CHR(10).
			construction = construction + "lim_items=1" + CHR(13) + CHR(10).
			construction = construction + "</agreement>" + CHR(13) + CHR(10).
			
			RETURN construction.
			
END FUNCTION.

FUNCTION exp_client RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, INPUT arg6 AS CHAR  
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<client>" + CHR(13) + CHR(10).
			construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "document=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "addressoflow=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "addressoflife=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "acct=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "sex=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "</client>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.


FUNCTION exp_plan RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR,
			INPUT arg5 AS CHAR, INPUT arg6 AS CHAR
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<plan>" + CHR(13) + CHR(10).
			construction = construction + "id=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "date=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "payment=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "int=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "amt=" + arg5 + CHR(13) + CHR(10).
			construction = construction + "pos=" + arg6 + CHR(13) + CHR(10).
			construction = construction + "</plan>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.

FUNCTION exp_guaranty RETURNS CHAR (
			INPUT arg1 AS CHAR, INPUT arg2 AS CHAR,
			INPUT arg3 AS CHAR, INPUT arg4 AS CHAR
			).
			
			DEFINE VAR construction AS CHAR.
			
			construction = "<guaranty>" + CHR(13) + CHR(10).
			construction = construction + "kind=" + arg1 + CHR(13) + CHR(10).
			construction = construction + "name=" + arg2 + CHR(13) + CHR(10).
			construction = construction + "no=" + arg3 + CHR(13) + CHR(10).
			construction = construction + "open_date=" + arg4 + CHR(13) + CHR(10).
			construction = construction + "checked=checked" + CHR(13) + CHR(10).
			construction = construction + "</guaranty>" + CHR(13) + CHR(10).
			
			RETURN construction.
																					
END FUNCTION.


/** ��������� */
/* �室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM iParam AS CHAR.

/* ���� ��ࠬ��� */
DEF VAR out_file_name AS CHAR NO-UNDO. 
DEF VAR account AS CHAR NO-UNDO.
DEF VAR summa AS DECIMAL NO-UNDO. 
DEF VAR rate AS DECIMAL NO-UNDO.
DEF VAR rate_type AS CHAR NO-UNDO.
DEF VAR firstpayloandate AS DATE NO-UNDO.
DEF VAR firstpayratedate AS DATE NO-UNDO.

DEF TEMP-TABLE ttPlan 
	FIELD id AS INT
	FIELD pdate AS DATE
	FIELD amt-all AS DEC
	FIELD amt-int AS DEC
	FIELD amt AS DEC
	FIELD pos AS DEC
	INDEX idx id pdate.

DEF VAR i AS INT NO-UNDO.

DEF VAR total-amt AS DEC EXTENT 3 NO-UNDO.

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/buryagin/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED StrToWin_ULL("<data>" + CHR(13) + CHR(10)).


FOR FIRST tmprecid 
         NO-LOCK,
   FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id 
         NO-LOCK,
   FIRST loan-cond WHERE loan-cond.contract = loan.contract AND loan-cond.cont-code = loan.cont-code NO-LOCK 
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, '�।����', loan.open-date, false).
	summa = ABS(GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false)).
	rate = GetLoanCommissionEx_ULL(loan.contract, loan.cont-code, "%�।", loan.open-date, false, rate_type).
	
	PUT UNFORMATTED
	 
	 StrToWin_ULL(
			exp_agree(
				loan.cont-code,
				(if loan.currency = "" then "810" else loan.currency), 
				STRING(loan.open-date,"99/99/9999"), 
				STRING(loan.end-date,"99/99/9999"),
				STRING(summa),
				STRING(rate),
				STRING(LastMonDate(loan.open-date), "99/99/9999"),
				STRING(LastMonDate(GoMonth(loan.open-date, 1)), "99/99/9999"),
				"fix",
				loan-cond.int-period,
				(IF loan-cond.int-date = 31 THEN "tail" ELSE "every"),
				STRING(loan-cond.int-date),
				(IF loan-cond.int-date = 31 THEN "tail" ELSE "every"),
				STRING(loan-cond.int-date),
				"notneed",
				STRING(ROUND(MonInPer(loan.open-date, loan.end-date),0)),
				"notneed",
				(IF CAN-FIND(FIRST term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
						AND term-obl.class-code = "term-obl-gar") THEN "need" ELSE "notneed"),
				(IF GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "�����", "����������") = "����������"
					THEN "v" ELSE "z")
			)
		).
				
					
	/* ���ଠ�� �� ������� */
	IF loan.cust-cat = "�" THEN
		DO:
			FIND FIRST person WHERE
				person.person-id = loan.cust-id
				NO-LOCK NO-ERROR.
			IF AVAIL person THEN
				DO:
					PUT UNFORMATTED StrToWin_ULL(exp_client(
							person.name-last + " " + person.first-names,
							person.document-id + ": " +	person.document + ". �뤠�: " + person.issue + " " +
							GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid",""),
							DelDoubleChars(person.address[1] + " " + person.address[2], ","), 
							"",
							account,
							(IF person.gender THEN "M" ELSE "F")
						)
					).
				END.
		END.
	ELSE
		DO:
			MESSAGE "��� �� �ਭ������� ��⭮�� ����!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
		
	/** ���ଠ�� �� ���ᯥ祭�� */
	FOR EACH term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-gar" NO-LOCK:
				PUT UNFORMATTED StrToWin_ULL(exp_guaranty(
						GetXAttrValueEx("term-obl", term-obl.contract + "," + term-obl.cont-code + "," 
								+ STRING(term-obl.idnt) + "," + STRING(term-obl.end-date) 
								+ "," + STRING(term-obl.nn), "��������", ""),
						LC(GetCodeName("�����", GetXAttrValueEx("term-obl", term-obl.contract + "," + term-obl.cont-code + "," 
								+ STRING(term-obl.idnt) + "," + STRING(term-obl.end-date) 
								+ "," + STRING(term-obl.nn), "�����", ""))),
						GetXAttrValueEx("term-obl", term-obl.contract + "," + term-obl.cont-code + "," 
								+ STRING(term-obl.idnt) + "," + STRING(term-obl.end-date) 
								+ "," + STRING(term-obl.nn), "��������", ""),
						STRING(term-obl.end-date, "99/99/9999")
					)
				).
	END.
	
	/** ��䨪 ����襭�� */
	/** �।���⥫쭮 �㦭� ᮡ��� ����� �� �६����� ⠡���� */
	
	/** �⠯ 1. �뤠� �।�� */
	i = 1.
	FIND FIRST term-obl WHERE term-obl.contract = loan.contract 
			AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-sum" 
			AND term-obl.end-date <= loan.open-date
			NO-LOCK NO-ERROR.
	IF AVAIL term-obl THEN DO:
				CREATE ttPlan.
				ASSIGN 
					ttPlan.id = i
					ttPlan.pdate = term-obl.end-date
					ttPlan.amt-all = term-obl.amt-rub * (-1).
				i = i + 1.
	END.

	/** �⠯ 2. ���⥦� �� ��業⠬ */
	FOR EACH term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-per" NO-LOCK:
			
			CREATE ttPlan.
			ASSIGN 
				ttPlan.id = i
				ttPlan.pdate = term-obl.end-date
				ttPlan.amt-int = term-obl.amt-rub.
			
			i = i + 1.
	END.
	
	/** �⠯ 3. ���⥦� �� ��㤥 */
	FOR EACH term-obl WHERE term-obl.contract = loan.contract AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-debt" NO-LOCK:
			
			FIND FIRST ttPlan WHERE ttPlan.pdate = term-obl.end-date NO-LOCK NO-ERROR.
			IF NOT AVAIL ttPlan THEN DO:
				CREATE ttPlan.
				ASSIGN 
					ttPlan.id = i
					ttPlan.pdate = term-obl.end-date.
				i = i + 1.
			END.
			ttPlan.amt = term-obl.amt-rub.
	END.
	
	/** �⠯ 4. ������� ���⮪, �롮ઠ "訢��� �� �뢮��" */
	FOR EACH ttPlan :
		FIND LAST term-obl WHERE term-obl.contract = loan.contract 
			AND term-obl.cont-code = loan.cont-code
			AND term-obl.class-code = "term-obl-sum" 
			AND term-obl.end-date <= ttPlan.pdate
			NO-LOCK NO-ERROR.
		IF AVAIL term-obl THEN DO:
			ttPlan.pos = term-obl.amt-rub.
		END.
	END.
	
	/** �⠯ 5. ���� �㬬� ���⥦� ������ 
	            ��ࠡ�⪠ ��� ����ᥩ � �����, �஬� ��ࢮ� ��ப� - �뤠� �।�� 
	*/
	FOR EACH ttPlan WHERE ttPlan.id > 1:
		ttPlan.amt-all = ttPlan.amt + ttPlan.amt-int.
	END.
	
	/** �⠯ 6. �⮣� */
	total-amt[1] = 0.
	total-amt[2] = 0.
	total-amt[3] = 0.
	FOR EACH ttPlan :
		total-amt[1] = total-amt[1] + ttPlan.amt-all.
		total-amt[2] = total-amt[2] + ttPlan.amt-int.
		total-amt[3] = total-amt[3] + ttPlan.amt.
	END.
	CREATE ttPlan.
	ASSIGN 
		ttPlan.id = i
		ttPlan.pdate = 12/31/9999
		ttPlan.amt-all = total-amt[1]
		ttPlan.amt-int = total-amt[2]
		ttPlan.amt = total-amt[3].
	
	/** �⠯ 7. ��ᯮ�� */
	FOR EACH ttPlan NO-LOCK:
		PUT UNFORMATTED StrToWin_ULL(exp_plan(
					STRING(ttPlan.id),
					(IF ttPlan.pdate = 12/31/9999 THEN "�����:" ELSE STRING(ttPlan.pdate)),
					STRING(ttPlan.amt-all),
					STRING(ttPlan.amt-int),
					STRING(ttPlan.amt),
					STRING(ttPlan.pos)
				)
			).
	END.
	
END.

PUT UNFORMATTED StrToWin_ULL("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "����� �ᯥ譮 �ᯮ��஢���!" VIEW-AS ALERT-BOX.
