{pirsavelog.p}

/** 
		��ନ஢���� �ᯮ�殮��� �� �஫������ ���.
		
		���� �.�., 17.04.2007 14:47
		
		�� �����, ����室��� ��� �ନ஢���� �ᯮ�殮��� ������ ���� ������� � ���� ������.
		
		��楤�� ����訢��� ���� �ᯮ�殮���, �⭮�⥫쭮 ���ன ��⮬ ���
		��஥ � ����� �᫮���. 
		
		����᪠���� �� ��㧥� �।����/��������� ������஢.
		
		������ ���� �ப� �७�� ���뢠�� "��஥" ������� ������஢ ��� � ��� �᫮���:
		��� ��� �᫮��� �஬� ��ࢮ�� ������ ���� ࠢ�� (ॠ�쭠� ��� + 1 ����).
		
		�஢���� �� �� �ਢ易� ���� ��� � ஫�� "�।��" �� ���� �ᯮ�殮���.
		�᫨ ��, � � ���� ⥪�� �ᯮ�殮��� ���������� ����室���� ���ଠ�� � ��७��.
		
		��������: ���� �.�. 10.08.2007 10:09 (������� ��� ��� ���᪠ 0000001)
		          �� ��⭮� ��� ��誮��� �.
		          ��ࠫ �� �����ᥩ �ᯮ���⥫�, ����� �࠭���� ������� ���.䨭��ᮢ�� �뭪��.

		��������: <��> <����� [F7]> (������� ��� ��� ���᪠ <㭨�����_���>)
		          <���ᠭ�� ���������>

*/

/** ����������� */
{globals.i}
{get-bankname.i}

/** ��� �ᯮ�짮���� ���ଠ�� �� ��㧥� � �뤥������ ������� */
{tmprecid.def}

/** ��� �㭪樨 */
{ulib.i}

/** ��� �ᯮ�짮���� ��७�� �� ᫮��� */
{wordwrap.def}

/** ��஥ �᫮��� */
DEF BUFFER oldCondition FOR loan-cond .
/** ����� �᫮��� */
DEF BUFFER newCondition FOR loan-cond.
/** �।��᫥���� ������� */
DEF BUFFER bfrLastLoan FOR loan.

/** ��� �ᯮ�殮��� */
DEF VAR orderDate AS DATE LABEL "��� �ᯮ�殮���" FORMAT "99/99/9999" NO-UNDO.
/** ��ଠ ����� ४����⮢ �ᯮ�殮��� */
DEF FRAME frmOrder
	orderDate SKIP
	WITH CENTERED TITLE "��������� �ᯮ�殮���" SIDE-LABELS OVERLAY.

/** �㬬� ��� */
DEF VAR amount AS DECIMAL LABEL "�㬬�" FORMAT ">>>,>>>,>>>,>>9.99" NO-UNDO.
DEF VAR strAmount AS CHAR EXTENT 2 NO-UNDO.

/** ��砫쭨�� */
DEF VAR bosD2 AS CHAR NO-UNDO.
DEF VAR bosKazna AS CHAR NO-UNDO.

/** 0000001: added at 10.08.2007 10:10 */
DEF VAR bosFin AS CHAR NO-UNDO.
/** 0000001: end */

/** �ᯮ���⥫� */
DEF VAR executor AS CHAR NO-UNDO.
DEF VAR execPost AS CHAR EXTENT 3 NO-UNDO.

/** ���� � ���� ��� */
DEF VAR oldAccount AS CHAR NO-UNDO.
DEF VAR newAccount AS CHAR NO-UNDO.

/** ������������ ����� */
DEF VAR bankname AS CHAR NO-UNDO.

/** �᭮���� ⥪�� */
DEF VAR str AS CHAR EXTENT 20 NO-UNDO.
/** ����� ��� �뢮�� ⥪�� �ᯮ�殮��� */
DEF VAR i AS INTEGER NO-UNDO.

/** ������������ ������ */
DEF VAR client AS CHAR NO-UNDO.
/** ����ࠫ쭮� ᮣ��襭�� */
DEF VAR genagree AS CHAR LABEL "����� ��" FORMAT "x(20)" NO-UNDO.
DEF VAR genagreedate AS DATE LABEL "��� ��" FORMAT "99/99/9999" NO-UNDO.

/** �ப �஫����樨 */
DEF VAR lease AS INTEGER NO-UNDO.
DEF VAR strLease AS CHAR EXTENT 2 NO-UNDO.

/** ��ଠ ��ᬮ��/।���஢���� */
DEF FRAME frmClient
	/** ttClient.id SKIP */
	loan.cont-code LABEL "������ ���" SKIP
	genagree genagreedate SKIP
	WITH CENTERED TITLE "��������� ᤥ���" SIDE-LABELS OVERLAY.


PAUSE 0.

/** ����訢��� � ���짮��⥫� ४������ �ᯮ�殮��� */
orderDate = TODAY.
UPDATE orderDate WITH FRAME frmOrder.
HIDE FRAME frmOrder.

/** ���쬥� ��砫쭨��� */
bosD2 = FGetSetting("PIRboss","PIRbosD2", "<�� ������>,<�� ������>").
bosKazna = FGetSetting("PIRboss", "PIRbosKazna", "<�� ������>,<�� ������>").

/** 0000001: added at 10.08.2007 10:16 */
bosFin = FGetSetting("PIRboss", "PIRbosfinmark", "<�� ������>,<�� ������>").
/** 0000001: end */

/** ���쬥� ������������ ����� */
bankname = cBankName.

/** ���᫨� �ᯮ���⥫� */
find first _user where _user._userid = userid no-lock no-error.
if avail _user then 
	do:
	executor = _user._user-name.
	executor = GetXAttrValueEx("_user", _user._userid, "���������", "") + "," + executor. 
	end.
else
	executor = "-,-".

/** ��� ������� �뤥������ � ��㧥� ����� ������... */
FOR EACH tmprecid NO-LOCK,
    /** ������ ������� */
    FIRST loan WHERE RECID(loan) = tmprecid.id NO-LOCK,
    /** ������ ��஥ �᫮��� */
    LAST oldCondition WHERE oldCondition.contract = loan.contract AND oldCondition.cont-code = loan.cont-code
    		AND oldCondition.since <= orderDate NO-LOCK,
    /** ������ ����� �᫮��� */
    FIRST newCondition WHERE newCondition.contract = loan.contract AND newCondition.cont-code = loan.cont-code
    		AND newCondition.since > orderDate NO-LOCK
  :

  	/** ���쬥� �㬬� ������� */
  	amount = GetLoanLimit_ULL(loan.contract, loan.cont-code, loan.open-date, false).
  	/** �㬬� �ய���� */
		Run x-amtstr.p(amount, loan.currency, true, true, output strAmount[1], output strAmount[2]).
  	strAmount[1] = strAmount[1] + ' ' + strAmount[2].
		Substr(strAmount[1],1,1) = Caps(Substr(strAmount[1],1,1)).

		/** ���᫨� �ப �஫����樨 � ���� */
		lease = loan.end-date - newCondition.since + 1.
		/**
		if oldCondition.since = loan.open-date then 
			lease = lease - 1.
		*/
		Run x-amtstr.p(lease, "", false, false, output strLease[1], output strLease[2]).
		Substr(strAmount[1],1,1) = Caps(Substr(strAmount[1],1,1)).
		
		/** ���쬥� ������ */
		client = GetLoanInfo_ULL(loan.contract, loan.cont-code, "client_short_name", false).
		
		/** ���� ��� */
		oldAccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", orderDate - 1, false).
		/** ���� ��� */
		newAccount = GetLoanAcct_ULL(loan.contract, loan.cont-code, "�।��", orderDate, false).
		
  	/** ���쬥� ४������ ����ࠫ쭮�� ᮣ��襭�� */
  	genagree = GetXAttrValueEx("loan", loan.contract + "," + loan.cont-code, "pirgenagree", ",").
  	/** �᫨ ��� �� ⥪�饬 �������, �饬 �� �।��饬 */
  	if genagree = "," then do:
  		FIND LAST bfrLastLoan WHERE 
  						bfrLastLoan.contract = loan.contract AND bfrLastLoan.cont-code <> loan.cont-code 
  						NO-LOCK NO-ERROR.
  		IF AVAIL bfrLastLoan THEN DO:
  			genagree = GetXAttrValueEx("loan", bfrLastLoan.contract + "," + bfrLastLoan.cont-code, "pirgenagree", ",").
  		END.
  	end.
  	genagreedate = DATE(ENTRY(1, genagree)).
  	genagree = ENTRY(2, genagree).
  	
  	DISPLAY loan.cont-code genagree genagreedate WITH FRAME frmClient.
  	UPDATE genagree genagreedate WITH FRAME frmClient.

  	/** ���࠭�� ४������ ����ࠫ쭮�� ᮣ��襭�� */
  	FIND FIRST signs WHERE 
  			signs.file-name = "loan"  	
  			AND
  			signs.code = "pirgenagree"
  			AND
  			signs.surrogate = loan.contract + "," + loan.cont-code 
  			NO-ERROR.
  	IF AVAIL signs THEN
  		signs.xattr-value = STRING(genagreedate,"99/99/9999") + "," + genagree.
  	ELSE 
  		DO:
  			CREATE 	signs.
  			ASSIGN 	signs.file-name = "loan"
  							signs.code = "pirgenagree"
  							signs.surrogate = loan.contract + "," + loan.cont-code
  							signs.xattr-value = STRING(genagreedate,"99/99/9999") + "," + genagree.
  		END.


  	/** ��ନ�㥬 �᭮���� ⥪�� c #tab - ⠡��樥�, #cr - ��७�ᠬ� */
  	str[1] = "#tab���� �㬬� � ࠧ��� " + STRING(amount) + " (" + strAmount[1] + "),"
  	       + " �।��⠢������ � ���� ��� " + client + " �� ᤥ��� �� " 
  	       + STRING((IF oldCondition.since = loan.open-date THEN oldCondition.since ELSE oldCondition.since - 1), "99/99/9999")
  	       + "�. � ࠬ��� ����ࠫ쭮�� �����襭�� �" + genagree + " �� ���� �᫮���� ���㤭���⢠ � ������ "
  	       + "�஢������ ����権 �� ��ᨩ᪮� ����⭮� � �������� �뭪�� �� " + STRING(genagreedate, "99/99/9999")
  	       + "�. �஫����஢��� �� �ப " + STRING(lease) + " (" + trim(strLease[1]) + ") ����(�,��) �� " 
  	       + STRING(loan.end-date, "99/99/9999") + "�. �� �᭮����� ᤥ��� �" + loan.cont-code + " �� "
  	       + STRING(newCondition.since - 1, "99/99/9999") + "�.".
  	if newAccount <> oldAccount then 
  		str[1] = str[1] + " � ��७��� � ��� " + oldAccount + " �� ��� " + newAccount + ".".
  	       .
  	{wordwrap.i &s=str &l=80 &n=20}    
  	
  	{setdest.i}
  	/** ��ନ�㥬 �ᯮ�殮��� */
  	PUT UNFORMATTED bankname SKIP
  			SPACE(50) "�⢥ত��" SKIP
  			SPACE(50) ENTRY(1,bosD2) SKIP(1)
  			SPACE(50) "___________________" SKIP
  			SPACE(54) ENTRY(2,bosD2) SKIP(1)
  			SPACE(50) "� �����⠬��� 3" SKIP(2)
  			SPACE(25) "� � � � � � � � � � � �" SKIP
  			SPACE(32) orderDate FORMAT "99/99/9999" SKIP(1).
  			
  	
		/** �뢮��� �᭮���� ⥪�� */
		DO i = 1 TO 20:
							IF str[i] <> "" THEN DO:
								str[i] = REPLACE(str[i], "#tab",CHR(9)).
								str[i] = REPLACE(str[i], "#cr", CHR(10)).
								PUT UNFORMATTED str[i] SKIP.
							END.
		END.
		
		/** �뢮��� ������ */
		
		execPost[1] = ENTRY(1,executor).
		{wordwrap.i &s=execPost &l=30 &n=3}
		
		PUT UNFORMATTED
						" " SKIP(2) SPACE(4) ENTRY(1,bosKazna) FORMAT "x(50)" "___________________" SKIP
						SPACE(4 + 50 + 3) ENTRY(2,bosKazna) SKIP(3).
/** 0000001: commented at 10.08.2007 10:18 
						PUT UNFORMATTED	SPACE(4) execPost[1] FORMAT "x(50)" "___________________" SKIP
														SPACE(4) execPost[2] FORMAT "x(50)" SPACE(3) ENTRY(2,executor) SKIP
														SPACE(4) execPost[3] FORMAT "x(50)" SKIP.
*/

/** 0000001: added at 10.08.2007 10:18 */
		PUT UNFORMATTED
						" " SKIP(2) SPACE(4) ENTRY(1,bosFin) FORMAT "x(50)" "___________________" SKIP
						SPACE(4 + 50 + 3) ENTRY(2,bosFin) SKIP(3).
/** 0000001: end */
	  			
  	{preview.i}
  	
END.

HIDE FRAME frmClient.
