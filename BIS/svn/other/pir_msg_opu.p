{pirsavelog.p}

/** 
		��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007

		��ନ஢���� ���⭮� ��� ᮮ�饭�� �� ����樨 �ਤ��᪮�� ���.
		
		���� �.�., 15.05.2007 15:16
		
		<���_����᪠����> : ����᪠���� �� ���㬥�⮢ ����樮����� ���.
		<��ࠬ���� ����᪠>
		<���_ࠡ�⠥�>
		<�ᮡ������_ॠ����樨>
		
		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

*/

/** �������� ��।������ */
{globals.i}

/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}

/* �㤥� �ᯮ�짮���� ��७�� �� ᫮��� */
{wordwrap.def}

{parsin.def}
/** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get xclass}
/** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get strng}

/******************************************* ��।������ ��६����� � ��. */

/** ���ଠ��, ��ࠦ����� � ᮮ�饭�� */
DEF TEMP-TABLE ttMessage NO-UNDO
	FIELD needControl AS CHAR /* ������ �㦤����� � ����஫� */
	FIELD irregulary AS CHAR /* �����筠� ������ */
	FIELD documentNumber AS CHAR LABEL "����� ���㬥��" /* ����� ���㬥�� */
	FIELD documentDetails AS CHAR /* ����ঠ��� ����樨 */
	FIELD documentCurrency AS CHAR /* ��� ������ ����樨 */
	FIELD documentAmount AS DECIMAL /* �㬬� ����樨 */
	FIELD documentDate AS DATE /* ��� ����樨 */
	FIELD troubles AS CHAR /* ���ᠭ�� �������� ����㤭���� �����䨪�樨 */
	FIELD userName AS CHAR /* ����㤭��, ��⠢��訩 ᮮ�饭�� */
	FIELD userPost AS CHAR /* ��������� ���㤭��� */
	FIELD dateTime AS CHAR /* ��� � �६� ��⠢����� */
  FIELD resolve AS CHAR /* �ਭ�� �襭�� */
	.
/** ���ଠ�� � ����, �஢����� ������ */
DEF TEMP-TABLE ttClient NO-UNDO
	FIELD id AS INTEGER
	FIELD name AS CHAR /* ��� */
	FIELD inn AS CHAR 
	FIELD ogrn AS CHAR
	FIELD addressOfStay AS CHAR
	FIELD addressOfPost AS CHAR
	FIELD account AS CHAR /* ���, � ������� ���ண� �஢������ ᤥ��� */
	.


DEF VAR documentType AS CHAR /* ������, ��������� ����஫� / �����筠� ᤥ��� */
			LABEL "��⥣���"
			VIEW-AS RADIO-SET RADIO-BUTTONS "�������� ����஫�", "control", "�����筠�", "irregulary".

/** ���㠫�� �����, � ������� ���ண� � ��砥 ����室����� 
    ����� ����� ������, ����� ������� � ᮮ�饭�� */
DEF VAR needClient AS CHAR LABEL "�㦭� ������" FORMAT "x(30)"
	VIEW-AS COMBO-BOX LIST-ITEM-PAIRS "","" INNER-LINES 5
.

DEF FRAME frmMessage 
	ttMessage.documentNumber SKIP
	documentType SKIP
	needClient SKIP
	ttMessage.troubles LABEL "���ᠭ�� �������� ����㤭����"
	   VIEW-AS EDITOR SIZE 40 BY 6
	WITH SIDE-LABELS CENTERED OVERLAY TITLE "��������� ᮮ�饭��".

DEF VAR str AS CHAR EXTENT 100. /** ����� ᮮ�饭�� */
DEF VAR i AS INTEGER. /** ����� */

DEF VAR withoutAcctMask AS CHAR INIT "40909*,40913*".

/******************************************* ��������� */

FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK
  :
  	CREATE ttMessage.
  	
  	ttMessage.documentNumber = op.doc-num.

  	ttMessage.documentDetails = op.details.
  	
  	/** ������ ��� ������ � �㬬� */
  	FIND FIRST op-entry OF op NO-LOCK NO-ERROR.
  	IF AVAIL op-entry THEN DO:
  		ttMessage.documentCurrency = (IF op-entry.currency = "" THEN "810" ELSE op-entry.currency).
  		ttMessage.documentAmount = (IF op-entry.currency = "" THEN op-entry.amt-rub ELSE op-entry.amt-cur).
  	END.
  	
  	ttMessage.documentDate = op.doc-date.
  	
  	/** ����⨬ ⠡���� */
  	FOR EACH ttClient: 		DELETE ttClient.  	END.
  	DO i = 1 TO needClient:NUM-ITEMS :     needClient:DELETE(i). 	END.
  	i = 0.
  	/** ������ ��� ���, �஢����� ������ */
  	/** ��ࠡ�⠥� ��� �� ������ � �।��� */
  	FOR EACH acct WHERE 
 				acct.cust-cat = "�"
  			AND 
  			(
  				acct.acct = op-entry.acct-db
  				OR 
  				acct.acct = op-entry.acct-cr
  			)
  			NO-LOCK
  		:
  			FIND FIRST cust-corp WHERE cust-corp.cust-id = acct.cust-id NO-LOCK NO-ERROR.
  			IF AVAIL cust-corp THEN DO:
  				CREATE ttClient.
  				i = i + 1.
  				ttClient.id = i.
  				ttClient.name = cust-corp.name-corp.
  				ttClient.inn = cust-corp.inn.
	  			IF ttClient.inn = "0" OR ttClient.inn = "000000000000" THEN ttClient.inn = "".
	  			ttClient.ogrn = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", "").
  				/** �� ��᢮���� ���� ����㥬�� �� "�������� ���祭��" */
	  			ttClient.addressOfStay = DelDoubleChars(IF addr-of-low[1] = addr-of-low[2] THEN addr-of-low[1] ELSE addr-of-low[1] + " " + addr-of-low[2], ",").
	  			ttClient.addressOfPost = GetXAttrValueEx("cust-corp", STRING(cust-corp.cust-id), "����", "").
	  			IF ttClient.addressOfPost = "" THEN ttClient.addressOfPost = ttClient.addressOfStay.
	  			ttClient.account = (IF CAN-DO(withoutAcctMask, acct.acct) THEN "" ELSE acct.acct).
	  			needClient:ADD-LAST(ttClient.name, STRING(ttClient.id)).
  			END.
  	END.
  	
		FIND FIRST _user WHERE (_user._userid = USERID) NO-LOCK NO-ERROR.
		IF AVAIL _user THEN DO:
			ttMessage.userName = _user._user-name.
			ttMessage.userPost = GetXAttrValueEx("_user", _user._userid, "���������", "").
			ttMessage.dateTime = STRING(TODAY, "99.99.9999") /* + ", " + STRING(TIME, "HH:MM:SS") */.
		END.

  	/** ����ᨬ ⨯ � ��㣨� ����� �� ����樨 � ���짮��⥫� */
  	PAUSE 0.
  	documentType = "".
  	DISPLAY ttMessage.documentNumber documentType ttMessage.troubles WITH FRAME frmMessage.
  	SET documentType needClient ttMessage.troubles WITH FRAME frmMessage.
  	
  	IF documentType:SCREEN-VALUE = "control" THEN 
  		ASSIGN ttMessage.needControl = "X" ttMessage.irregulary = "".
  	ELSE
  		ASSIGN ttMessage.needControl = "" ttMessage.irregulary = "X".
  	
  	ttMessage.troubles = ttMessage.troubles:SCREEN-VALUE.

  	
  	{setdest.i}

		PUT UNFORMATTED SPACE(50) "���������" SKIP
		                SPACE(40) "�� ����樨 �ਤ��᪮�� ���." SKIP
		                .
		
  	PUT UNFORMATTED 
  	"�������������������������������������������������������������������������������������������������������������Ŀ" SKIP
  	"��������� �� ����樨 (ᤥ���)                                                                                �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"��ਭ���������� � 㪠����� ��⥣��� (�㦭�� ������� 'X')                                                  �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ������, ��������� ��易⥫쭮�� ����஫�  �" ttMessage.needControl FORMAT "x(60)"                     "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   �����筠� ᤥ���                             �" ttMessage.irregulary FORMAT "x(60)"                      "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"����㬥��, �� �᭮����� ���ண� �����⢫����  �" ttMessage.documentNumber FORMAT "x(60)"                  "�" SKIP
  	"������� (ᤥ���)                               �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
  	
  	/** ����ঠ��� ����樨 �㦭� ࠧ���� �� ��ப�� */
  	str[1] = ttMessage.documentDetails.
  	{wordwrap.i &s=str &n=100 &l=60}
  	
  	PUT UNFORMATTED
  	"�   ����ঠ��� ����樨 (ᤥ���)                 �" str[1] FORMAT "x(60)"                                    "�" SKIP.
  	DO i = 2 TO 100 :
  		IF str[i] <> "" THEN DO:
  			PUT UNFORMATTED
		  	"�                                                �" str[i] FORMAT "x(60)"                                    "�" SKIP.
		  	str[i] = "".
		  END.
  	END.
  	
  	PUT UNFORMATTED
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ��� ������ ����樨 (ᤥ���)                 �" ttMessage.documentCurrency FORMAT "x(60)"                "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   �㬬� ����樨 (ᤥ���)                      �" TRIM(STRING(ttMessage.documentAmount, ">>>,>>>,>>>,>>9.99")) FORMAT "x(60)" "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ��� ᮢ��襭�� ����樨 (ᤥ���)            �" STRING(ttMessage.documentDate, "99.99.9999") FORMAT "x(60)" "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"��������� � ���, �஢���饬 ������ (ᮢ����饬 ᤥ���)                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
  	
  	FIND FIRST ttClient WHERE ttClient.id = INT(needClient:SCREEN-VALUE) NO-LOCK NO-ERROR.
  	IF AVAIL ttClient THEN DO:
  		str[1] = ttClient.ogrn.
  		{wordwrap.i &s=str &n=3 &l=60}
  		
  		PUT UNFORMATTED
  		"�   ������������                                 �" ttClient.name FORMAT "x(60)" "�" SKIP
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  		"�   ���                                          �" ttClient.inn FORMAT "x(60)" "�" SKIP
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  		"�   �������樮��� �����, ���� ॣ����樨     �" str[1] FORMAT "x(60)" "�" SKIP
  		"�                                                �" str[2] FORMAT "x(60)" "�" SKIP
  		"�                                                �" str[3] FORMAT "x(60)" "�" SKIP
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
  		
  		str[1] = ttClient.addressOfStay. str[2] = "". str[3] = "".
  		PUT UNFORMATTED
  		"�   ���� ��宦����� �ਤ��᪮�� ���           �" str[1] FORMAT "x(60)" "�" SKIP
  		"�                                                �" str[2] FORMAT "x(60)" "�" SKIP
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
  		str[1] = ttClient.addressOfPost. str[2] = "".
  		PUT UNFORMATTED
  		"�   ���⮢� ����                               �" str[1] FORMAT "x(60)" "�" SKIP
  		"�                                                �" str[2] FORMAT "x(60)" "�" SKIP.
  		
  		
  	
	  	PUT UNFORMATTED
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  		"��������� � ���, � �ᯮ�짮������ ���ண� �஢������ ������ ��� ᤥ��� (�஬� ��砥� �����⢫����      �" SKIP
	  	"���ॢ���� ��� ������ ���):                                                                               �" SKIP
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  		"�   � ���                                      �" ttClient.account FORMAT "x(60)" "�" SKIP
	  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  		"����ᠭ�� �������� ����㤭���� �����䨪�樨 ����樨 ��� �������饩 ��易⥫쭮�� ����஫� ��� ��稭�,      �" SKIP
  		"��� ����� ᤥ��� ������������ ��� �����筠�                                                              �" SKIP
  		"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP.
  	END.	
  	
  	str[1] = ttMessage.troubles.
  	{wordwrap.i &s=str &n=10 &l=109}
  	
  	DO i = 1 TO 10:
  		IF str[i] <> "" THEN 
  			PUT UNFORMATTED
  			"�" str[i] FORMAT "x(109)" "�" SKIP.
  	END.
  	
  	PUT UNFORMATTED
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"��������� � ���㤭���, ��⠢��襬 ᮮ�饭��                                                                 �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   �.�.�.                                       �" /* ttMessage.userName FORMAT "x(60)" */ SPACE(60) "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ���������                                    �" /* ttMessage.userPost FORMAT "x(60)" */ SPACE(60) "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   �������                                      �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ���, �६�                                  �" /* ttMessage.dateTime FORMAT "x(60)" */ SPACE(60) "�" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�������� ������������ �������������              �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"��⬥⪠ �⢥��⢥����� ���㤭��� � ����祭�� ����饭��:                                                     �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ���, �६�                                  �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   �������                                      �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"��⬥⪠ �⢥��⢥����� ���㤭��� � �ਭ�⮬ �襭��:                                                        �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   �ਭ�� �襭��                              �" ttMessage.resolve FORMAT "x(60)" "�" SKIP
  	"�                                                �                                                            �" SKIP
  	"�                                                �                                                            �" SKIP
  	"�                                                �                                                            �" SKIP
  	"�                                                �                                                            �" SKIP
  	"�                                                �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�   ���                                         �                                                            �" SKIP
  	"�������������������������������������������������������������������������������������������������������������Ĵ" SKIP
  	"�������� �㪮����⥫� �����                      �                                                            �" SKIP
  	"�                                                �                                                            �" SKIP
  	"���������������������������������������������������������������������������������������������������������������" SKIP.
  	
  	{preview.i}
  	
END.

HIDE FRAME frmMessage.

{intrface.del}
