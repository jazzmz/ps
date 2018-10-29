{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (C) 2012
     Filename: pirzarplataodin.p
      Comment: ��ᯮ�� ������ � �ଠ� afx ��� ������� ��������� 
		�� ��௫�⭮�� �������� ��� �����稭��� ������
		������� �� �᭮�� pirzarplata.p
   Parameters: ������ ��� 䠩�� �ᯮ��
      Launch:  Ctrl+G �� ������� �� ������ (⠪�� �������� ��室���� � 
		�易���� � ��௫�⭮�� �������� � �࣠����樥�)
         Uses:
      Created: Sitov S.A., 24.04.2012
	Basis: #937 (��)
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

DEFINE VARIABLE cT        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iT        AS INTEGER   NO-UNDO.
DEFINE VARIABLE KlNum 	  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cKlNum 	  AS CHARACTER NO-UNDO.
DEF VAR usershortname AS CHAR NO-UNDO.


DEF BUFFER card FOR loan.	/* ��� ����窨 */
DEF BUFFER zrploan FOR loan.	/* ��� ��௫�⭮�� ������� */
DEF BUFFER loanp FOR loan.




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


		/** ��௫��� ������� */

	FIND LAST loanp WHERE loanp.contract EQ 'card-pers' 
			AND loanp.cust-cat EQ '�'
			AND loanp.cont-code EQ loan.cont-code
	NO-LOCK No-ERROR.

	FIND FIRST links WHERE links.link-id EQ 36 
		AND links.target-id EQ loanp.contract + ',' + loanp.cont-code 
	NO-LOCK No-ERROR.
	
	FIND LAST zrploan WHERE zrploan.contract EQ 'card-gr' 
		AND zrploan.class-code EQ 'card-loan-gr'
		AND zrploan.contract EQ ENTRY(1,links.source-id) 
		AND zrploan.cont-code EQ ENTRY(2,links.source-id) 
	NO-LOCK NO-ERROR.
	
	RUN Master_OutStr("<agreement>").
	RUN Master_OutStr("date="   + STRING(zrploan.open-date, "99.99.9999")).
	RUN Master_OutStr("number=" + zrploan.cont-code).
	RUN Master_OutStr("proc="   + "").
	RUN Master_OutStr("</agreement>").
	

	FIND FIRST cust-corp WHERE (cust-corp.cust-id EQ zrploan.cust-id) NO-LOCK NO-ERROR.
	IF NOT (AVAIL cust-corp) THEN
	  DO:
		MESSAGE "�࣠������ �� �������!" VIEW-AS ALERT-BOX.
		RETURN.
	  END.
        
	RUN Master_OutStr("<client>").
	RUN Master_OutStr("name="      + cust-corp.name-short).
	RUN Master_OutStr("short="     + cust-corp.name-short).

	RUN Master_OutStr("addressul=" + Master_Kladr(cust-corp.country-id + ","
	                        + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���������"),
	                          cust-corp.addr-of-low[1] + cust-corp.addr-of-low[2])).

	RUN Master_OutStr("fioruk="    + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "�����")).
	RUN Master_OutStr("post="      + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "�����")).
        RUN Master_OutStr("fiobuh="    + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "������")).
	RUN Master_OutStr("inn="       + cust-corp.inn).
	RUN Master_OutStr("kpp="       + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "���")).
	RUN Master_OutStr("ogrn="      + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "����")).
	RUN Master_OutStr("phone="     + GetXAttrValue("cust-corp", STRING(cust-corp.cust-id), "tel")).
	RUN Master_OutStr("fax="       + cust-corp.fax).
	RUN Master_OutStr("</client>").
	

		/** ����७������ �� ��௫�⭮�� �������� */

	FOR LAST cust-role WHERE (cust-role.file-name  EQ "loan")
		AND (cust-role.surrogate  EQ zrploan.contract  + ',' + zrploan.cont-code)
		AND (cust-role.class-code EQ "�����⥫�")
	NO-LOCK,
	FIRST person WHERE (person.person-id     EQ INTEGER(cust-role.cust-id))
	NO-LOCK:

		cKlNum = STRING(cust-corp.cust-id).
		KlNum   = STRING(person.person-id).
		RUN Master_OutStr("<attorney>").
        
		RUN Master_OutStr("fio="         + person.name-last + " " + person.first-names).
		cT = person.issue.
		iT = R-INDEX(cT, ",").
		IF  iT <> 0  THEN  SUBSTRING(cT, iT, 1) = ", �/� " .
		RUN Master_OutStr("pass="        + GetCodeName("�������", person.document-id) + " N "
                                  + person.document + ", �뤠� "
                                  + STRING(DATE(GetXAttrValue("person", cKlNum, "Document4Date_vid")), "99.99.9999")
                                  + " " + cT).

		RUN Master_OutStr("addressreg=" + Master_Kladr(person.country-id + "," 
						+ GetXAttrValue("person", STRING(person.person-id), "���������"),person.address[1] + person.address[2])
						).
		RUN Master_OutStr("addressfact=" + Master_GetClntAddr(person.person-id,"�","�������") ).

		RUN Master_OutStr("tel="         + ENTRY(1, person.phone[1])).
		RUN Master_OutStr("sex="         + (IF person.gender THEN "��᪮�" ELSE "���᪨�")).
        
		RUN Master_OutStr("</attorney>").
	END.

	

		/** ����������� ����� */
	
	FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR.

	IF NOT (AVAIL person) THEN
	  DO:
		MESSAGE "������ �� ������!" VIEW-AS ALERT-BOX.
		RETURN.
	  END.

	RUN Master_OutStr("<card>").

	RUN Master_OutStr("familia="     + person.name-last).
	RUN Master_OutStr("name="        + ENTRY(1, person.first-names, " ")).
	RUN Master_OutStr("otchestvo="   + ENTRY(2, person.first-names, " ")).
	RUN Master_OutStr("namelat="     + ENTRY(1, card.user-o[2], " ")).
	RUN Master_OutStr("familialat="  + ENTRY(2, card.user-o[2], " ")).
	RUN Master_OutStr("birthday="    + STRING(person.birthday, "99.99.9999")).
	RUN Master_OutStr("birthplace="  + GetXAttrValue("person", STRING(person.person-id), "birthplace")).

	RUN Master_OutStr("passdoc="     + GetCodeName("�������", person.document-id)).
	RUN Master_OutStr("passnum="     + person.document).

	cT = person.issue.
	iT = R-INDEX(cT, ",").
        RUN Master_OutStr("passvydan="   + REPLACE(SUBSTRING(cT, 1, iT - 1), CHR(10) ,"" ) ).
        RUN Master_OutStr("passkp="      + (IF  iT <> 0  THEN  REPLACE(SUBSTRING(cT, iT + 1), CHR(10) ,"" ) ELSE "" ) ).
	RUN Master_OutStr("passdate="    + STRING(DATE(GetXAttrValue("person", STRING(person.person-id), "Document4Date_vid")), "99.99.9999")).

	RUN Master_OutStr("addressreg=" + Master_Kladr(person.country-id + "," 
						+ GetXAttrValue("person", STRING(person.person-id), "���������"),person.address[1] + person.address[2])
						).
	RUN Master_OutStr("addressfact=" + Master_GetClntAddr(person.person-id,"�","�������") ).
	RUN Master_OutStr("sex="         + (IF person.gender THEN "��᪮�" ELSE "���᪨�")).
	RUN Master_OutStr("tel="         + ENTRY(1, person.phone[1])).

	cT = person.phone[2].
	RUN Master_OutStr("mob="         + (IF (NUM-ENTRIES(cT) LT 2) THEN "" ELSE ENTRY(2, cT))).
	
	cT = GetXAttrValue("person", STRING(person.person-id), "country-id2").

	FIND FIRST country WHERE (country.country-id EQ cT) NO-LOCK NO-ERROR.
	
	RUN Master_OutStr("resident="    + (IF (AVAIL country) THEN country.country-name ELSE "")).
	RUN Master_OutStr("migrcard="    + "").
	RUN Master_OutStr("cardtype="    + card.sec-code).
	RUN Master_OutStr("cardcurr="    + card.currency).
        RUN Master_OutStr("cardnum="     + card.doc-num).
	RUN Master_OutStr("codeword="    + card.user-o[1]).

	FIND FIRST loan-acct WHERE loan-acct.cont-code EQ loan.cont-code
		        AND loan-acct.contract  EQ 'card-pers'
		        AND loan-acct.currency  EQ loan.currency
			AND loan-acct.acct-type EQ STRING("SCS@" + loan.currency)
	NO-LOCK NO-ERROR.

	RUN Master_OutStr("acct810="     + loan-acct.acct).
	RUN Master_OutStr("acctdate="    + STRING(loan-acct.since, "99.99.9999")).
	
	RUN Master_OutStr("</card>").



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
	RUN Master_OutStr("procname=" + "pirzarplataodin.p" ).
	RUN Master_OutStr("</expproc>").


	/** �������騩 �� */					
	RUN Master_OutStr("</data>").

END.


OUTPUT CLOSE.

MESSAGE "����� �ᯥ譮 �ᯮ��஢���!" VIEW-AS ALERT-BOX.
