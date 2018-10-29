{pirsavelog.p}
/*
		��楤�� ��ᯮ�� ������ ��� ����� �����⮢�� ������⭮�� �������
		���� �.�., 21.03.2007 13:47
*/
FUNCTION cnv RETURNS CHARACTER (INPUT arg1 AS CHARACTER).

/* �室: arg1:��ப�
** ��室: ��ப� � ����஢�� windows-1251
*/
	RETURN CODEPAGE-CONVERT(arg1,"1251",SESSION:CHARSET).

END FUNCTION.

FUNCTION expagr RETURNS CHARACTER (
																	INPUT arg1 AS CHAR, /* ����� ������� */
																	INPUT arg2 AS CHAR, /* ��� ������ */
																	INPUT arg3 AS CHAR, /* ��� ����砭�� */
																	INPUT arg4 AS CHAR, /* �㬬� */
																	INPUT arg5 AS CHAR, /* ����� */
																	INPUT arg6 AS CHAR  /* ��業⭠� �⠢�� */ 
																  ).

	DEFINE VARIABLE construction AS CHARACTER.

	construction =                "<agreement>" + CHR(13) + CHR(10).
	construction = construction + "no=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "opendate=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "enddate=" + arg3 + CHR(13) + CHR(10).
   construction = construction + "duration=" + STRING(DATE(arg3) - DATE(arg2) + 1) + CHR(13) + CHR(10).
	construction = construction + "summa=" + arg4 + CHR(13) + CHR(10).
	construction = construction + "currency=" + arg5 + CHR(13) + CHR(10).
	construction = construction + "rate=" + arg6 + CHR(13) + CHR(10).
   construction = construction + "</agreement>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.

FUNCTION expacct RETURNS CHARACTER (INPUT arg1 AS CHAR,
																		INPUT arg2 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER.

	construction =                "<acct>" + CHR(13) + CHR(10).
	construction = construction + "no=" + arg1 + CHR(13) + CHR(10).
	if can-do("�����",arg2) then 
		construction = construction + "type=�����" + CHR(13) + CHR(10).
	if can-do("�����*",arg2) then 
		construction = construction + "type=⥪�騩 ������" + CHR(13) + CHR(10).
	if can-do("�����",arg2) then 
		construction = construction + "type=��������" + CHR(13) + CHR(10).
	construction = construction + "</acct>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.


FUNCTION expcorp RETURNS CHARACTER (INPUT arg1 AS CHAR,
																		INPUT arg2 AS CHAR,
																		INPUT arg3 AS CHAR,
																		INPUT arg4 AS CHAR, 
																		INPUT arg5 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER.

	construction =                "<client>" + CHR(13) + CHR(10).
	construction = construction + "name=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "address=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "ogrn=" + arg3 + CHR(13) + CHR(10).
	construction = construction + "inn=" + arg4 + CHR(13) + CHR(10).
	construction = construction + "resident=" + arg5 + CHR(13) + CHR(10).
	construction = construction + "</client>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.


FUNCTION expbos RETURNS CHARACTER (INPUT arg1 AS CHAR,
																		INPUT arg2 AS CHAR,
																		INPUT arg3 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER.

	construction =                "<bos>" + CHR(13) + CHR(10).
	construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "post=" + arg2 + CHR(13) + CHR(10).
	construction = construction + "order=" + arg3 + CHR(13) + CHR(10).
	construction = construction + "</bos>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.

FUNCTION expaccounter RETURNS CHARACTER (INPUT arg1 AS CHAR).

	DEFINE VARIABLE construction AS CHARACTER.

	construction =                "<accounter>" + CHR(13) + CHR(10).
	construction = construction + "fio=" + arg1 + CHR(13) + CHR(10).
	construction = construction + "</accounter>" + CHR(13) + CHR(10).
	
	RETURN construction.

END FUNCTION.

/********************************************************************** VARS */

/* �������� ��।������ */
{globals.i}
{ulib.i}
{pir_anketa.fun}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/* �室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM iParam AS CHAR.

/* ���� ��ࠬ��� */
DEF VAR out_file_name AS CHAR. 
DEF VAR account AS CHAR.
DEF VAR summa AS DECIMAL. 
DEF VAR rate AS DECIMAL.

DEF VAR cTfakt AS CHAR NO-UNDO.
DEF VAR cTf-id AS CHAR NO-UNDO.

IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/buryagin/tmp/new_data.afx".
		
OUTPUT TO VALUE(out_file_name).

PUT UNFORMATTED cnv("<data>" + CHR(13) + CHR(10)).

/* ��� ��ࢮ�� ���, ��࠭���� � ��o㧥� �믮��塞... */
FOR FIRST tmprecid 
         NO-LOCK,
   FIRST loan WHERE 
         RECID(loan) EQ tmprecid.id 
         NO-LOCK 
: 

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, '�����', loan.open-date, false).
	/** ������ �㬬� ������� */
	/** �᫨ ��� ���⮪ �� ����, �...
		summa = ABS(GetAcctPosValueEx_UAL(account, loan.currency, loan.open-date, "�", false)).
	*/
	/** �᫨ �� �᫮���, � ��ᯮ��㥬�� �㭪樥� GetLoanLimit_ULL(). �� ᬮ��� �� �� ��������,
	    ��� ��� ��������� ������஢ ��୥� ������ �㬬� ������� �� ���� 
	*/
	
	summa = GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false).
		
	rate = GetLoanCommission_ULL(loan.contract, loan.cont-code, '%���', loan.open-date, false).
	
	PUT UNFORMATTED cnv(expagr(loan.cont-code, 
				STRING(loan.open-date,"99/99/9999"), 
				STRING(loan.end-date,"99/99/9999"),
				STRING(summa),
				SUBSTRING(account, 6, 3),
				STRING(rate * 100))).
				
	PUT UNFORMATTED cnv(expacct(account, "�����")).
	
	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, '�������', loan.open-date, false).
	/** ������ �����祭�� ��� */
	FIND FIRST acct WHERE acct.acct = account NO-LOCK NO-ERROR.
	IF AVAIL acct THEN DO:
		PUT UNFORMATTED cnv(expacct(account, acct.contract)).
	END.
					
	/* ���ଠ�� �� ������� */
	IF loan.cust-cat = "�" THEN
		DO:
			FIND FIRST cust-corp WHERE 
					cust-corp.cust-id = loan.cust-id NO-LOCK.
			IF AVAILABLE cust-corp THEN DO:

			/* #4184 �� ����� ����� - ��ࠢ��� �뢮� � ����� ������஢ - �㦥� ��.���� �� ������ ������ */
				FIND LAST cust-ident WHERE
			                cust-ident.cust-code-type = "�����"
			                AND (cust-ident.close-date EQ ? OR cust-ident.close-date >= gend-date) 
			                AND cust-ident.class-code EQ 'p-cust-adr'
			                AND cust-ident.cust-cat EQ '�'
			                AND cust-ident.cust-id EQ cust-corp.cust-id
			            NO-LOCK NO-ERROR.
			       IF (AVAIL cust-ident) THEN DO:
		                cTfakt = GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
                		       + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "country-id") + ","
			               + GetXAttrValue("cust-ident", cust-ident.cust-code-type + ',' 
			               + cust-ident.cust-code + ',' + STRING(cust-ident.cust-type-num), "���������").
				cTf-id = cust-ident.issue.
				END. 
            		       ELSE DO:
	                       cTfakt = "".
			       cTf-id = "".
				END.			

			/* #4184 ��.���� �� ��ᯮ�� - ���� 2� ��ࠬ��� ����ᠭ ���� */
				/*cust-corp.addr-of-low[1]  + " " + cust-corp.addr-of-low[2],*/

			PUT UNFORMATTED cnv(expcorp(GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "FullName"),
						    Kladr(cTfakt,cTf-id),
						    GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", ""),
						    cust-corp.inn,
						    (IF cust-corp.country-id = "RUS" THEN "yes" ELSE "no")
						)).

			/** ���ଠ�� � �㪮����⥫� */
			PUT UNFORMATTED cnv(expbos(GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����", ""),
																 GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "�����", ""),
																 "")).

			END.

		END.
	ELSE
		DO:
			MESSAGE "��� �� �ਭ������� ������� �ਤ��᪮�� ����!" VIEW-AS ALERT-BOX.
			RETURN.
		END.
	
	
END.



PUT UNFORMATTED cnv("</data>" + CHR(13) + CHR(10)).

OUTPUT CLOSE.

MESSAGE "����� �ᯥ譮 ��ᯮ��஢���!" VIEW-AS ALERT-BOX.