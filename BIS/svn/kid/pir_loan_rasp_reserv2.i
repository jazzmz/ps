/*-----------------------------------------------------------------------------
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2001 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: sword.i
      Comment: ����� ᢮����� ����ਠ�쭮�� �थ� (�ᯮ������ 䨫���).
               ����頥� ��室 �㬠��. ������砥��� � CTRL-G � ���-�� ���.
   Parameters:
         Uses: sword.p sword-p.p
      Used by:
      Created: 18/06/2002 kraw
     Modified: 26/12/2002 kraw (0013029) ����⠭������ �⮡ࠦ���� ����஢����
     Modified: 16/01/2003 kraw (0011853) �⮣���� �㬬� �ய���� � ����
     Modified: 27/02/2003 kraw (0013230) ����⠭������� ��ਠ�� 㧪�� ����
     Modified: 06/01/2003 kraw (0024627) ���㫥��� ���稪� �⮣���� �㬬� (����室���
             : �� ���� ��᪮�쪨� ��������஢)
     Modified: 10/02/2004 kraw (0024321) 3 ����� ��ப� � ���� �थ�
     Modified: 21.03.2007 15:57 ���� �.�.
     						������� ��ࠡ��� ����� &bos - ��� ��砫쭨�� � ����஥筮� ��ࠬ��� PIRboss
-----------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
{globals.i}
{pp-uni.var}
{pp-uni.prg}
{ulib.i}
{tmprecid.def}
{get-bankname.i}


def var senderName as char no-undo.
def var receiverName as char no-undo.
   
{flt-file.i}
def var sDate  as char format "x(29)" NO-UNDO.  /* ���         */
def var sFilt  as char format "x(29)" NO-UNDO.  /* ��� 䨫���  */


def temp-table totals no-undo /* �⮣� ��� */
    field currency like op-entry.currency
    field amt-rub  like op-entry.amt-rub
    field amt-cur  like op-entry.amt-cur
    field i        as   int /* ���-�� �஢���� */.
.

def var acct-db as character NO-UNDO.
def var acct-cr as character NO-UNDO.
def var istr as integer initial 0 NO-UNDO. /* �㬥��� ��ப */
def var client-name as char NO-UNDO.
def var loan-date as date NO-UNDO.
def var loan-code as char NO-UNDO. /* ����� ������� */
def var note as char NO-UNDO. /* �ਬ�砭�� */
def var total as decimal initial 0 NO-UNDO.
def var total_cr as decimal initial 0 NO-UNDO.
def var total_db as decimal initial 0 NO-UNDO.
def var byusers as char NO-UNDO. /* ���㬥��� �� ���稭���� (��筠� ���졠 ������� �.�. �� 02.12.2005 */
byusers = FGetSetting("PIRS1","PIRS1byusers","").
def var PIRbosloan as char NO-UNDO.
def var PIRbosloanFIO as char NO-UNDO.
DEF VAR PIRtarget as char NO-UNDO.
DEF VAR PIRispl as char NO-UNDO.
DEF VAR innParam as char NO-UNDO.

ASSIGN
innParam = {&ipr} .

/** �஢�ઠ �室�饣� ��ࠬ��� */
IF NUM-ENTRIES(innParam) < 2 THEN DO:
  MESSAGE "�������筮� ���-�� ��ࠬ��஢. ������ ���� <���_���㬥��>,<���_�㪮����⥫�_��_PIRBoss>,<�_�����⠬���>,<�ᯮ���⥫�>" 
          VIEW-AS ALERT-BOX.
  RETURN.
END.

PIRbosloan = ENTRY(1,FGetSetting("PIRboss",ENTRY(2, innParam),"")).
PIRbosloanFIO = ENTRY(2,FGetSetting("PIRboss",ENTRY(2, innParam),"")).


/*18/06/09 V.N.Ermilov */
ASSIGN PIRtarget = "" PIRispl = "" .


IF NUM-ENTRIES(innParam) = 4 THEN 
DO:
	PIRtarget = ENTRY(3, innParam).
	PIRispl = ENTRY(4, innParam).
END.







def var date-rasp as date NO-UNDO.
for first tmprecid no-lock,
  first op where recid(op) = tmprecid.id 
:
	date-rasp = op.op-date.
end.

{strtout3.i &cols=95 &custom="printer.page-lines - "}
/*
function StrCenter returns char (input asStr as char, input anLen as int).
    def var nSpaces as int  no-undo.
    assign nSpaces = ( anLen - length( asStr ) ) / 2.
    return string( fill( " ", nSpaces ) + asStr, "x(" + string( anLen ) + ")" ).
end.

find first flt-attr where flt-attr.attr-initial <> flt-attr.attr-code-value no-lock no-error.
assign
    PackagePrint = true
    sDate = string( caps({term2str date(GetFltVal('op-date1')) date(GetFltVal('op-date2')) yes}), "x(30)" )
    sFilt = StrCenter( if( avail flt-attr ) then ( '������ "' + entry( 3, user-config-info ) + '"' ) else "�� ���㬥���", 75 )
.
*/
PUT UNFORMATTED  "                                                                                                               " PIRtarget skip.
PUT UNFORMATTED  "                                                                                                               " cBankName skip(2).
PUT UNFORMATTED  "                                                                                                               " string(date-rasp,"99/99/9999") skip(3).
PUT UNFORMATTED  "                                         � � � � � � � � � � � �" skip(1).
PUT UNFORMATTED  "    � ᮮ⢥��⢨� � ���������� �� �� " ENTRY(1,innParam) /*N 254-� �� 24.03.2004�.*/ " <<� ���浪� �ନ஢���� �।��묨 �࣠�����ﬨ" skip.
PUT UNFORMATTED  "१�ࢮ� �� ��������  ���� �� ��㤠�, �� ��㤭�� � ��ࠢ������ � ���  �����������>>  ���� ����� ����樨" skip.                                           
PUT UNFORMATTED  "�� �ନ஢���� १�ࢠ �� �������� ���� �� ��㤠�:" skip(1).

PUT UNFORMATTED  "����������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" skip.
PUT UNFORMATTED  "�      �                            �       �������         �                                        �஢����                                        �" skip.
PUT UNFORMATTED  "�N �/� �   ������������ ����騪�    ����������������������������������������������������������������������������������������������������������������Ĵ" skip.
PUT UNFORMATTED  "�      �                            �  ���    �    �����   �N ���.�     ����� ���    �    �।�� ���    �       �㬬�       �    �ਬ�砭��     �" skip.
PUT UNFORMATTED  "����������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" skip. 


/*
FORM
  "�" istr format ">>>>>>" "�"
  client-name format "x(28)" "�"
  loan-date format "99/99/9999" "�"
  loan-code format "x(12)" "�"
  op.doc-num format "x(6)" "�"
  acct-db format "x(20)" "�"
  acct-cr format "x(20)" "�"
  op-entry.amt-rub format "->>>,>>>,>>>,>>9.99" "�"
  note format "x(19)" "�"

	HEADER
  "����������������������������������������������������������������������������������������������������������������������������������������������������Ŀ" skip
  "�      �                            �       �������         �                                        �஢����                                        �" skip
  "�N �/� �   ������������ ����騪�    ����������������������������������������������������������������������������������������������������������������Ĵ" skip
  "�      �                            �  ���    �    �����   �N ���.�     ����� ���    �    �।�� ���    �       �㬬�       �    �ਬ�砭��     �" skip
  "����������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" skip 
WITH FRAME myframe DOWN WIDTH 160.
*/

for each tmprecid no-lock,

&if defined( FILE_sword_p ) ne 0 &then

  first op where recid(op) = tmprecid.id 
  		and
  		can-do(byusers, op.user-id) no-lock,
   each op-entry of op no-lock break by op-entry.currency by op-entry.amt-rub:

&else

  first op-entry where recid(op-entry) = tmprecid.id no-lock,
   first op of op-entry no-lock break by op-entry.currency by op-entry.amt-rub:

&endif
/* �᫨ ��� �㡠������᪨� �ਢ燐� �� �஢����, ����� �� �� �㤥� ������� � ���� */

if (NUM-ENTRIES(op-entry.kau-cr) eq 3  AND ENTRY(1,op-entry.kau-cr) eq "�।��")
		OR 
	 (NUM-ENTRIES(op-entry.kau-db) eq 3 AND ENTRY(1,op-entry.kau-db) eq "�।��")
THEN DO:
      assign
       acct-cr =  if (op-entry.acct-cr <> ?) then op-entry.acct-cr else ""
       acct-db =  if (op-entry.acct-db <> ?) then op-entry.acct-db else ""
       istr = istr + 1
      .

     /* ======================== �ਬ�砭�� � �⮣� =========================== */


if NUM-ENTRIES(op-entry.kau-db) eq 3 AND 
	(ENTRY(3,op-entry.kau-db) EQ "321" OR  ENTRY(3,op-entry.kau-db) eq "33"  OR ENTRY(3,op-entry.kau-db) eq "137" ) then
	do:
       /* ============ ������������ ����騪�, ��� � ����� �������  ====================== */

		total = total + op-entry.amt-rub.
		assign
					client-name = "���"
					loan-date = TODAY
					loan-code = "���".

		find first loan-acct where loan-acct.acct = acct-db no-lock no-error.
		if avail loan-acct then
			do:
				find first loan where 
					loan.contract = loan-acct.contract
					and
					loan.cont-code = loan-acct.cont-code 
					no-lock no-error.
				if avail loan then
					assign
							loan-date = loan.open-date
							loan-code = loan.cont-code.
							if loan.cont-code begins "MM" then loan-code = loan.doc-num.
					find first signs where 
							signs.code = "��⠑���"
							and
							signs.file-name = "loan"
							and
							signs.surrogate = "�।��," + Loan-code
							no-lock no-error.
					if avail signs then
						Loan-Date = DATE(signs.code-value).
					
					client-name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).

					/*if loan.cust-cat = "�" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then	
								client-name = cust-corp.name-corp.
						end.
					if loan.cust-cat = "�" then
						do:
							find first person where person.person-id = loan.cust-id no-lock no-error.
							if avail person then
								client-name = person.name-last + " " + first-names.
						end.
					*/
			end.
	assign
		total_db = total_db + op-entry.amt-rub
		note = "����⠭�������".
  put UNFORMATTED "�" string(istr, ">>>>>>") +
            "�" + STRING(client-name, "x(28)") +
            "�" + STRING(loan-date, "99/99/9999") +
            "�" + STRING(loan-code, "x(12)") +
            "�" + STRING(op.doc-num, "x(6)") +
            "�" + STRING(acct-db, "x(20)") +
            "�" + string(acct-cr, "x(20)")   +
            "�" + string(op-entry.amt-rub, "->>>,>>>,>>>,>>9.99") +
            "�" + string(note, "x(19)") + "�" skip.

  	PUT UNFORMATTED  "����������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" skip.
	end.

else 

if NUM-ENTRIES(op-entry.kau-cr) eq 3 AND 
	( ENTRY (3,op-entry.kau-cr) EQ "320" OR ENTRY(3,op-entry.kau-cr) EQ "32" OR ENTRY(3,op-entry.kau-cr) eq "136" ) then
	do:
/* ============ ������������ ����騪�, ��� � ����� �������  ====================== */
		total = total + op-entry.amt-rub.
		assign
					client-name = "���"
					loan-date = TODAY
					loan-code = "���".

		find first loan-acct where loan-acct.acct = acct-cr no-lock no-error.
		if avail loan-acct then
			do:
				find first loan where 
					loan.contract = loan-acct.contract
					and
					loan.cont-code = loan-acct.cont-code 
					no-lock no-error.
				if avail loan then
					assign
							loan-date = loan.open-date
							loan-code = loan.cont-code.
							if loan.cont-code begins "MM" then loan-code = loan.doc-num.	  	
					find first signs where 
							signs.code = "��⠑���"
							and
							signs.file-name = "loan"
							and
							signs.surrogate = "�।��," + Loan-code
							no-lock no-error.
					if avail signs then
						Loan-Date = DATE(signs.code-value).
							
					client-name = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_name", false).
					/* Buryagin commented at 21.03.2007 16:19 
					if loan.cust-cat = "�" then
						do:
							find first cust-corp where cust-corp.cust-id = loan.cust-id no-lock no-error.
							if avail cust-corp then	
								client-name = cust-corp.name-corp.
						end.
					if loan.cust-cat = "�" then
						do:
							find first person where person.person-id = loan.cust-id no-lock no-error.
							if avail person then
								client-name = person.name-last + " " + first-names.
						end.
					*/
			end.
	assign
    note = "��������"
    total_cr = total_cr + op-entry.amt-rub.
  put UNFORMATTED "�" string(istr, ">>>>>>") +
            "�" + STRING(client-name, "x(28)") +
            "�" + STRING(loan-date, "99/99/9999") +
            "�" + STRING(loan-code, "x(12)") +
            "�" + STRING(op.doc-num, "x(6)") +
            "�" + STRING(acct-db, "x(20)") +
            "�" + string(acct-cr, "x(20)")   +
            "�" + string(op-entry.amt-rub, "->>>,>>>,>>>,>>9.99") +
            "�" + string(note, "x(19)") + "�" skip.

  PUT UNFORMATTED  "����������������������������������������������������������������������������������������������������������������������������������������������������Ĵ" skip.
  end.




END. /* IF */
end.
PUT UNFORMATTED  "������������������������������������������������������������������������������������������������������������������������������������������������������" skip.
PUT UNFORMATTED  "�                                                                                       �⮣� ᮧ����:       �" + string(total_cr,"->>>,>>>,>>>,>>9.99") + "�" skip.
PUT UNFORMATTED  "�                                                                                       �⮣� ����⠭�����:  �" + string(total_db,"->>>,>>>,>>>,>>9.99") + "�" skip.
PUT UNFORMATTED  "�                                                                                       �ᥣ�:               �" + string(total,"->>>,>>>,>>>,>>9.99") + "�" skip.
PUT UNFORMATTED  "����������������������������������������������������������������������������������������������������������������������������������" skip(2).

PUT UNFORMATTED PIRbosloan SPACE(70 - LENGTH(PIRbosloan)) PIRbosloanFIO skip(5).

/*
{signatur.i &user-only}
*/


IF PIRispl = "" 
THEN DO:

	find first _user where _user._userid EQ userid no-lock no-error.
	if avail _user then
		put unformatted "�ᯮ���⥫�: " _user._user-name format "x(40)" skip.
	else
		put unformatted "�ᯮ���⥫�: " skip.
END.
ELSE 	IF PIRispl <> '0' THEN 	PUT UNFORMATTED "�ᯮ���⥫�:  " PIRispl  SKIP.





PackagePrint = false.

{endout3.i}