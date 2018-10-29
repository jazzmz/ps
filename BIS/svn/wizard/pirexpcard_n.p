{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2011
     Filename: pirexpcard.p
      Comment: ��ᯮ�� ������ � �ଠ� afx ��� ������� ��������� 
		�� ����⨪��� ������ࠬ
   Parameters: ������ ��� 䠩�� �ᯮ��
         Uses:
      Created: ��⮢ �.�., 16.02.2012
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */




{globals.i}		/** �������� ��।������ */
{tmprecid.def}		/** ������祭�� ���������� �ᯮ�짮���� ���ଠ�� ��㧥� */
{intrface.get strng}
{ulib.i}		/** ������⥪� ���-�㭪権 */
{pir_expmaster.fun}     /** ������⥪� �㭪権 ��� ����� */




/* ========================================================================= */
				/** ������� */
/* ========================================================================= */

  /* �室�� ��ࠬ���� ��楤��� */
DEF INPUT PARAM iParam AS CHAR.

  /* ���� ��ࠬ��� */
DEF VAR out_file_name AS CHAR. 

DEF VAR account AS CHAR NO-UNDO.
DEF VAR account_usd AS CHAR NO-UNDO.
DEF VAR account_eur AS CHAR NO-UNDO.
DEF VAR account_minpos AS CHAR NO-UNDO.
DEF VAR accountosn AS CHAR NO-UNDO.
DEF VAR dateaccountosn AS CHAR INIT "" NO-UNDO.
DEF VAR cardtype AS CHAR NO-UNDO.
DEF VAR paylim AS DEC INIT 0 NO-UNDO.

DEF VAR usershortname AS CHAR NO-UNDO.

DEF BUFFER card FOR loan.
DEF BUFFER qacct FOR acct.



/* ========================================================================= */
				/** ��������� */
/* ========================================================================= */


IF NUM-ENTRIES(iParam) > 0 THEN
	out_file_name = ENTRY(1,iParam).
ELSE
	out_file_name = "/home2/bis/quit41d/work/ssitov/tmp/new_data.afx".


  /** ������ �뢮� � 䠩� */		
OUTPUT TO VALUE(out_file_name).


FOR FIRST tmprecid 
NO-LOCK,
FIRST loan WHERE 
RECID(loan) EQ tmprecid.id 
NO-LOCK,
FIRST card WHERE card.contract = "card"
             AND card.parent-contract = loan.contract
             AND card.parent-cont-code = loan.cont-code
             AND card.loan-work = YES
             AND CAN-DO("���,���,���",card.loan-status)
             AND card.close-date = ?
NO-LOCK: 


	/** ���뢠�騩 �� */	
	RUN Master_OutStr("<data>").

	account = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@', loan.open-date, false).
	account_usd = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@840', loan.open-date, false).
	account_eur = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SCS@978', loan.open-date, false).
	account_minpos = GetLoanAcct_ULL(loan.contract, loan.cont-code, 'SGP@' + loan.currency, loan.open-date, false).
	
	  /* ��।��塞 �᭮���� ������ ��� */
	CASE loan.currency :
	  WHEN "" THEN accountosn = account .
	  WHEN "840" THEN accountosn = account_usd .
	  WHEN "978" THEN accountosn = account_eur .
	END CASE.

	FIND FIRST qacct WHERE qacct.acct = accountosn NO-LOCK NO-ERROR.
	IF avail(qacct) THEN
		dateaccountosn = STRING(qacct.open-date,"99/99/9999").



		/** ������� �� */

	RUN Master_OutStr("<plagreement>").

	RUN Master_OutStr("number="		+ REPLACE(loan.cont-code, "�", "C")).
	RUN Master_OutStr("date="		+ STRING(loan.open-date, "99/99/9999")).
	RUN Master_OutStr("currency="		+ (if loan.currency = "" then "810" else loan.currency)).
	RUN Master_OutStr("card=" 		+ card.doc-num ).
	RUN Master_OutStr("cardtype=" 		+ GetCodeName("����끠���", card.sec-code ) ).
	RUN Master_OutStr("accountmain="	+ account ).
	RUN Master_OutStr("accountcurusdmain="	+ account_usd ).
	RUN Master_OutStr("accountcureurmain="	+ account_eur ).
	RUN Master_OutStr("accountminpos="	+ account_minpos ).
	RUN Master_OutStr("dateaccountosn="	+ dateaccountosn ).

        paylim = Master_GetDogCardPayLim( loan.cont-code ) .

	RUN Master_OutStr("paylim="		+ STRING(paylim) ).
 
	RUN Master_OutStr("</plagreement>").



		/** ������ */					

	IF loan.cust-cat = "�" THEN
	  DO:
		FIND FIRST person WHERE
				person.person-id = loan.cust-id
		NO-LOCK NO-ERROR.

		IF AVAIL person THEN
		  DO:

			RUN Master_OutStr("<client>").

			RUN Master_OutStr("fio="	+ person.name-last + " " + person.first-names).  
			RUN Master_OutStr("document="	+ person.document-id + ": " + person.document 
						+ ". �뤠�: " + person.issue + " " 
						+ GetXAttrValueEx("person",STRING(person.person-id),"Document4Date_vid","")
						).
			RUN Master_OutStr("addressoflow="	+ Master_Kladr(person.country-id + "," 
								+ GetXAttrValue("person", STRING(person.person-id), "���������"),person.address[1] + person.address[2])
								).
			RUN Master_OutStr("addressoflife="	+ Master_GetClntAddr(person.person-id,"�","�������") ).
			RUN Master_OutStr("sex="	+ (IF person.gender THEN "M" ELSE "F")).  
			RUN Master_OutStr("phone="	+ person.phone[1] ).
			RUN Master_OutStr("birthday="	+ STRING(person.birthday, "99/99/9999") ).

			RUN Master_OutStr("</client>").
		  END.
	  END.
	ELSE
	  DO:
		MESSAGE "��� �� �ਭ������� ������� ��⭮�� ����!" VIEW-AS ALERT-BOX.
		RETURN.
	  END.



		/** ������������ */					

	RUN Master_OutStr("<user>").

	FIND FIRST _user WHERE _user._userid = LC(userid("bisquit")) NO-LOCK NO-ERROR.
	RUN Master_OutStr("username=" + _user._user-name).

	usershortname = GetEntries(1,_user._user-name," ","") + " " +
			SUBSTRING(GetEntries(2,_user._user-name," ",""),1,1) + "." +
			SUBSTRING(GetEntries(3,_user._user-name," ",""),1,1) + "." .
	RUN Master_OutStr("usershortname=" + usershortname ).

	RUN Master_OutStr("userpost=" + GetXAttrValueEx("_user", _user._userid, "���������", "") ).
	RUN Master_OutStr("</user>").



		/** ��������� �������� */					

	RUN Master_OutStr("<expproc>").
	RUN Master_OutStr("procname=" + "pirexpcard_n.p" ).
	RUN Master_OutStr("</expproc>").


	/** �������騩 �� */					
	RUN Master_OutStr("</data>").

END.


OUTPUT CLOSE.

MESSAGE "����� �ᯥ譮 �ᯮ��஢���!" VIEW-AS ALERT-BOX.
