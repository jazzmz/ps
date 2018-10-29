/* ========================================================================= */
/** 
    Copyright: ��� ��� ����, ��ࠢ����� ��⮬�⨧�樨 (C) 2013
     Filename: pir-proxy-check.p
      Comment: �஢�ઠ ���㬥�⮢ ����/���ᥭ�� ������� �������� �।�� 
		� ��� 䨧��� ��殬, � ���ண� ��� ����७���� 
   Parameters: 
       Launch: ����᪠���� � ��ࠬ��ࠬ� �� ����୮� �㭪樨, �� pir-chkop
      Created: Sitov S.A., 2013-09-19
	Basis: #3679
     Modified: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>) 
               <���ᠭ�� ���������>                                           
*/
/* ========================================================================= */

{globals.i}


DEF INPUT  PARAM iAcct		AS CHAR NO-UNDO.
DEF INPUT  PARAM iClient	AS CHAR NO-UNDO.
DEF INPUT  PARAM iOpDate	AS DATE NO-UNDO.
DEF OUTPUT PARAM oDover		AS CHAR INIT "" NO-UNDO. 

DEF VAR cListRole      AS CHAR          NO-UNDO.
DEF VAR cCardList      AS CHAR          NO-UNDO.

DEFINE BUFFER acct	FOR acct.
DEFINE BUFFER person	FOR person.
DEFINE BUFFER cust-role  FOR cust-role .
DEFINE BUFFER cust-role2 FOR cust-role .
DEFINE BUFFER signs2 FOR signs .

DEFINE BUFFER proxy	FOR loan.
DEFINE BUFFER card	FOR loan.
DEFINE BUFFER loan-acct	FOR loan-acct.



FIND FIRST acct WHERE acct.acct = iAcct NO-LOCK NO-ERROR.

	/* �饬 ����७�����, �᫨ �������� ������.  */
IF acct.cust-cat = "�" AND  iClient <> "" AND  iClient <> ?  THEN 
DO:

    cListRole = FGetSetting("PirChkOp", "Pir3679List", "") .

    FOR EACH cust-role 
	  WHERE cust-role.file-name = "person"
	  AND   cust-role.cust-cat EQ '�'
	  AND   cust-role.cust-id <>  STRING(acct.cust-id)
	  AND   cust-role.surrogate = STRING(acct.cust-id)
	  AND   (cust-role.open-date <= iOpDate) AND (cust-role.close-date >= iOpDate)
	  AND   CAN-DO( cListRole, TRIM(cust-role.class-code) )
    NO-LOCK,
    FIRST person
	  WHERE person.name-last = SUBSTRING(iClient,1,INDEX(iClient," ") - 1)
	  AND   person.first-names = SUBSTRING(iClient,INDEX(iClient," ") + 1,LENGTH(iClient) - INDEX(iClient," ") + 1) 
	  AND   STRING(person.person-id) = cust-role.cust-id
    NO-LOCK,
    FIRST signs 
	  WHERE signs.file-name = "cust-role"
	  AND   signs.surrogate = STRING(cust-role.cust-role-id) 
	  AND   signs.code = "acct-list"
	  AND   CAN-DO( REPLACE(signs.xattr-value,CHR(32),"") , acct.acct) 
    NO-LOCK:

	     IF AVAILABLE(cust-role) AND AVAILABLE(person) AND AVAILABLE(signs) THEN
	     DO:

		oDover = GetXattrValueEx("cust-role",STRING(cust-role.cust-role-id),"PIRosnovanie","") .

		  /* �᫨ ⠪ ����� ����७���� �� ��।�����, � 
		     �����-� ��㣮� ��ਠ�� ��।������ ����� ����୭��� */.
		IF oDover = "" THEN 
		DO:
			/* �.� � ��� ����७���� ������� ���-� ���, � ��ਠ�� ��।������ ����� ����७���� ⮦� ����� */
		   FOR FIRST cust-role2 
			WHERE cust-role2.file-name = "person"
			AND   cust-role2.cust-cat EQ '�'
			AND   cust-role2.cust-id = cust-role.cust-id
			AND   cust-role2.surrogate = STRING(acct.cust-id)
			AND   cust-role2.open-date = cust-role.open-date  AND cust-role2.close-date = cust-role.close-date
			AND   cust-role2.class-code = cust-role.class-code
		   NO-LOCK,
		   EACH signs2 
			WHERE signs2.file-name = "cust-role"
			AND   signs2.surrogate = STRING(cust-role2.cust-role-id) 
			AND   signs2.code = "PIRosnovanie"
			AND   (signs2.xattr-value <> ? and signs2.xattr-value <> "")
		   NO-LOCK:
			oDover = signs2.xattr-value.
		   END.
		END.

		  /* �᫨ � ᥩ�� ����� ����७���� �� ��।�����, � ��襬 ⠪ */
		IF oDover = "" THEN
			oDover = "�� ���. �/� �� " + STRING(cust-role.open-date) . 

	     END.

    END. /* FOR EACH cust-role  */



	/* #3918 - �⤥�쭮 ��� �11 */
    IF SUBSTRING(acct.acct,14,3) = "050"  AND  oDover = ""  THEN 
    DO:
	FOR EACH proxy
	   WHERE proxy.class-code = "proxy-pircard"
	   AND   proxy.contract = "proxy"
	   AND   proxy.cust-id  = acct.cust-id
	   AND   (proxy.open-date <= iOpDate) AND (proxy.end-date >= iOpDate) AND (proxy.close-date >= iOpDate OR proxy.close-date = ?) 
	NO-LOCK,
	EACH  signs
	   WHERE signs.file-name = "loan"
	   AND   signs.surrogate = STRING("proxy," + proxy.cont-code)
	   AND   signs.code = "agent-id"
	NO-LOCK,
	FIRST person
	   WHERE person.name-last = SUBSTRING(iClient,1,INDEX(iClient," ") - 1)
	   AND   person.first-names = SUBSTRING(iClient,INDEX(iClient," ") + 1,LENGTH(iClient) - INDEX(iClient," ") + 1)
	   AND   STRING(person.person-id) = signs.code-value
	NO-LOCK:
	     IF AVAILABLE(proxy) AND AVAILABLE(person) AND AVAILABLE(signs) THEN
	     DO:
		cCardList = GetXattrValueEx("loan", STRING("proxy," + proxy.cont-code), "loan-allowed","") .

		IF cCardList = "" THEN  
		  NEXT.
	
		FOR LAST loan-acct 
		   WHERE loan-acct.acct = acct.acct
		   AND   loan-acct.contract  = 'card-pers'
		   AND   loan-acct.acct-type = STRING("SCS@" + acct.currency)
		   AND   loan-acct.since <= iOpDate
		NO-LOCK,
		FIRST  card 
		   WHERE card.contract = "card"
		   AND card.parent-contract = loan-acct.contract
		   AND card.parent-cont-code = loan-acct.cont-code
		   AND card.loan-status = "���"
		   AND (card.close-date >= iOpDate  OR  card.close-date = ?)
		   AND CAN-DO(cCardList,card.doc-num)
		NO-LOCK:
	
		  IF AVAIL(loan-acct) AND AVAIL(card) THEN
			oDover = "�� ����७���� �� �� " + card.doc-num .
		END.
	     END.
	END.
    END.  /* end IF SUBSTRING(acct.acct,14,3) */



    IF oDover = "" THEN
	DO:
	  MESSAGE COLOR WHITE/RED "��� ������������ ��� ������� �������" VIEW-AS ALERT-BOX.
	END.


END. /* IF acct.cust-cat = "�" THEN */
