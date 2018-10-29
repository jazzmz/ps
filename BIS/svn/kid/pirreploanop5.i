/*
		��稥 ����樨 �� �������.
		���� ࠧ��� ���� �� ������ �� �।��� ������ࠬ.
		���� �.�., 16.01.2006 15:23
*/

/* 
{uloanlib.i} - ��।���� � pirreploanop.p
DEF VAR loanno AS CHAR - ��।���� � pirreploanop.p
DEF VAR loanopendate AS DATE - ��।���� � pirreploanop.p
DEF VAR traceOn AS LOGICAL - ��।���� � pirreploanop.p
*/

/* ���⨬ ⠡����
*/
FOR EACH replines
:
	DELETE replines.
END.

ASSIGN
subtotal_amt_rub = 0
subtotal_amt_usd = 0.

/* ��� ��� ���㬥�⮢, ��࠭��� � ��o㧥� �믮��塞... */
FOR EACH tmprecid 
         NO-LOCK,
   FIRST op WHERE 
         RECID(op) EQ tmprecid.id 
         NO-LOCK, 
   FIRST op-entry OF op WHERE
         NO-LOCK
: 
	/* ��稥 ����樨 - ����樨 �� �����ᮢ� ��⠬ �ਢ易��� �� ����⮢�� ��� 
	   �।�⮢�� �����⨪�. 
	   �� ����⮢�� �����⨪� �� ������ ���� ���� ����樨 4.
	   �� �।�⮢�� �����⨪� �� ������ ���� ���� ����樨 5,10,36,358,57
	   ��ଠ� ����� � �⮬ ���� ⠪��: "�।��,<�����_��������>,<�����_��������>".
	*/
	IF op-entry.acct-cat = "b" AND (
		op-entry.kau-db BEGINS "�।��,"
		OR
		op-entry.kau-cr BEGINS "�।��,"
	)
	THEN
		IF	(
					op-entry.kau-db BEGINS "�।��" 
					AND 
					op-entry.kau-cr BEGINS "�।��"
					AND
					CAN-DO("4",ENTRY(3,op-entry.kau-db))
					AND				
					CAN-DO("5",ENTRY(3,op-entry.kau-cr))
				)
				OR
				(
					op-entry.kau-cr BEGINS "�।��" 
					AND
					NOT CAN-DO("5,50,10,36,358,57,371",ENTRY(3,op-entry.kau-cr))
			 	)
			 	OR
			 	(
			 		op-entry.kau-db BEGINS "�।��"
			 		AND
			 		NOT CAN-DO("4",ENTRY(3,op-entry.kau-db))
			 	)			  
		THEN
			DO:
					/* ���࠭�� ����� ������� � ��६����� */
					IF op-entry.kau-db BEGINS "�।��" THEN 
						loanno = ENTRY(2,op-entry.kau-db).
					IF op-entry.kau-cr BEGINS "�।��" THEN
						loanno = ENTRY(2,op-entry.kau-cr).
					
					/* ������� ��ப� */
					CREATE replines.
					/* ��� ������ ������� */
					loanopendate = DATE(GetCredLoanInfo_ULL(loanno,"open_date", traceOn)).
					/* �������� ���祭�� */
					ASSIGN
					replines.client_name[1] = GetCredLoanInfo_ULL(loanno,"client_name", traceOn)
					replines.loan_no = loanno
					replines.loan_date = loanopendate
					replines.op_no = op.doc-num
					replines.op_acct_db = op-entry.acct-db
					replines.op_acct_cr = op-entry.acct-cr
					replines.op_amt = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur)
					replines.op_cur = (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency)
					replines.op_details[1] = op.details
					replines.op_user = op.user-id
					replines.op_contr_user = op.user-inspector
					replines.op_done_flag = op.op-status.
					/* �㬬��㥬 ����⮣� */
					IF replines.op_cur = "810" THEN subtotal_amt_rub = subtotal_amt_rub + replines.op_amt.
					IF replines.op_cur = "840" THEN subtotal_amt_usd = subtotal_amt_usd + replines.op_amt.
					{wordwrap.i &s=replines.client_name &l=30 &n=2}
					{wordwrap.i &s=replines.op_details &l=30 &n=3}

				END.
END.

/* ��������� �६����� ⠡����, ⥯��� �뢥��� �� �� �࠭ */

PUT UNFORMATTED	
	"  5) � � � � � �   � � � � � � � �   � �   � � � � � � �" SKIP
	"�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" SKIP.

FOR EACH replines USE-INDEX cur
:
	PUT UNFORMATTED	
	"�" str_num FORMAT ">>>>>>"
	"�" client_name[1] FORMAT "x(30)"
	"�" loan_no FORMAT "x(11)"
	"�" loan_date FORMAT "99/99/9999"
	"�" op_no FORMAT "x(6)"
	"�" op_acct_db FORMAT "x(20)"
	"�" op_acct_cr FORMAT "x(20)"
	"�" op_amt FORMAT ">>>,>>>,>>>,>>9.99"
	"�" op_cur FORMAT "xxx"
	"�" op_details[1] FORMAT "x(30)"
	"�" op_user FORMAT "x(11)"
	"�" op_contr_user FORMAT "x(9)"
	"�" op_done_flag FORMAT "x(13)" 
	"�" SKIP.
	IF client_name[2] <> "" OR op_details[2] <> "" THEN
		PUT UNFORMATTED
			"�" SPACE(6)
			"�" client_name[2] FORMAT "x(30)"
			"�" SPACE(11)
			"�" SPACE(10)
			"�" SPACE(6)
			"�" SPACE(20)
			"�" SPACE(20)
			"�" SPACE(18)
			"�" SPACE(3)
			"�" op_details[2] FORMAT "x(30)"
			"�" SPACE(11)
			"�" SPACE(9)
			"�" SPACE(13)
			"�" SKIP.
	IF op_details[3] <> "" THEN
		PUT UNFORMATTED
			"�" SPACE(6)
			"�" SPACE(30)
			"�" SPACE(11)
			"�" SPACE(10)
			"�" SPACE(6)
			"�" SPACE(20)
			"�" SPACE(20)
			"�" SPACE(18)
			"�" SPACE(3)
			"�" op_details[3] FORMAT "x(30)"
			"�" SPACE(11)
			"�" SPACE(9)
			"�" SPACE(13)
			"�" SKIP.
	PUT UNFORMATTED
		"�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" SKIP.

	/* �����稬 ����� ��ப� */
	str_num = str_num + 1.
END.

PUT UNFORMATTED	
	"���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������" SKIP.
