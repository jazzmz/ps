
/* ------------------------------------------------------
     File: $RCSfile: pir_mm002.p,v $ $Revision: 1.2 $ $Date: 2007-12-13 14:57:16 $
     Copyright: ��� �� "�p������������"
     ���������: 
     ��稭�: ����७�� ����� ������� �뭮�
     �� ������: ��ନ��� �ᯮ�殮��� ��� �஫����஢����� ᤥ��� ���.
     ��� ࠡ�⠥�? �� ����⭮!!!! ;)
     ��ࠬ����: 
     ���� ����᪠: ��㧥� ᤥ��� ��, ��� ��娢 ᤥ���.
     ����: $Author: buryagin $ 
     ���������: $Log: not supported by cvs2svn $
------------------------------------------------------ */

/** �������� ��।������ */
{globals.i}

{get-bankname.i}


/** �ᯮ��㥬 �뤥����� ����� ��㧥� */
{tmprecid.def}

/** �㭪樨 ��� ࠡ��� � ���樨஢���묨 ��ࠬ��ࠬ� */
{parsin.def}

/** ��।������ �६����� ⠡��� � �㭪権 */
{pir_mm_def.i}

/** �㭪樨 ��� ࠡ��� � ������ࠬ� �� ��ࡠ��� */
{ulib.i}

/** =============================== ��।������ ================================== */

DEF INPUT PARAM iParam AS CHAR.

DEF BUFFER bfrCurrentLoan FOR loan. /** �뤥������ � ��㧥� ᤥ��� */
DEF BUFFER bfrCurrentLoanLine FOR loan. /** ����筠� �㬬� ⥪�饩 ᤥ���. */
DEF BUFFER bfrFirstLoan FOR loan. /** ��ࢠ� ᤥ��� */
DEF BUFFER bfrFirstLoanLine FOR loan. /** ����筠� �㬬� ��ࢮ� ᤥ��� */
DEF BUFFER bfrRolloveredLoan FOR loan. /** �஫����஢����� ᤥ��� */
DEF BUFFER bfrBankCorrespond FOR banks. /** ���� ����ᯮ����� */
DEF BUFFER bfrGeneralLoan FOR loan. /** ����ࠫ쭮� ᮣ��襭�� */
DEF buffer bfrLoanAmount FOR term-obl. /** �㬬� ᤥ��� */
def buffer bfrPersentAmount FOR term-obl. /** �㬬� ��業⮢ */
def buffer bfrPay FOR term-obl. /** ��室�騥 � �室�騥 ���⥦� (�ᯮ������ ����।�� */

DEF VAR fileName AS CHAR NO-UNDO. /** ��� ᮧ��������� 䠩�� */
DEF VAR cr AS CHAR NO-UNDO. /** Win-���� ���室� �� ����� ��ப� */
DEF VAR bankName AS CHAR NO-UNDO. /** ������������ ��襣� ����� */
DEF VAR agreeUser AS CHAR NO-UNDO. /** ����� ���㤭���, �⢥ত��饣� �ᯮ�殮���. ��।������ �� ���� ���짮����
�� ��ࠬ��� ��楤���. ��ଠ�: <���_���짮��⥫�,���������,���> */
DEF VAR kaznaUsers AS CHAR NO-UNDO. /** ���� ���짮��⥫�� (�१ ��� � ����⮩ ";") ��� �⬥⮪ �����祩�⢠.
��ଠ�: <���_���짮��⥫�,���������,���>;<���_���짮��⥫�,���������,���>;... */
DEF VAR kaznaSignsHtmlCode AS CHAR NO-UNDO. /** HTML-���, ᮤ�ঠ騩 ⠡���� �����ᥩ ���㤭���� �����祩�⢠ */
DEF VAR outPayHtmlCode AS CHAR NO-UNDO. /** HTML-���, ᮤ�ঠ騩 ⠡���� ��室��� ���⥦�� */
DEF VAR inPayHtmlCode AS CHAR NO-UNDO. /** HTML-���, ᮤ�ঠ騩 ⠡���� �室��� ���⥦�� */
DEF VAR reportUser AS CHAR NO-UNDO. /** ��� ���짮��⥫� ��� �⬥⪨ �����⠬��� ��� � ���⭮�� */

DEF VAR i AS INTEGER NO-UNDO.
DEF VAR tmpStr AS CHAR NO-UNDO.

/** ====================================== ��直� �㭪樨 ====================== */


/** =============================== ��������� =================================== */

cr = CHR(13) + CHR(10).


bankName = cBankName.
iParam = REPLACE(iParam,"CURRENTUSER",USERID("bisquit")).

agreeUser = SetUserDetails(GetParamByNameAsChar(iParam, "����⢥ত��", "")).
kaznaUsers = SetUserDetails(GetParamByNameAsChar(iParam, "���돮���ᥩ", "")).
DO i = 1 TO NUM-ENTRIES(kaznaUsers, "|") :
	kaznaSignsHtmlCode = kaznaSignsHtmlCode + 
				"<tr height=40 valign=middle><td>" + ENTRY(2, ENTRY(i, kaznaUsers, "|")) + "</td><td>_____________(" + ENTRY(3, ENTRY(i, kaznaUsers, "|")) + ")</td></tr>" + cr.
END.
reportUser = SetUserDetails(GetParamByNameAsChar(iParam, "���������", "")).



/** ��� ������ ��࠭��� ᤥ��� */
FOR EACH tmprecid NO-LOCK,
    FIRST bfrCurrentLoan WHERE RECID(bfrCurrentLoan) = tmprecid.id NO-LOCK,
    FIRST bfrGeneralLoan WHERE bfrGeneralLoan.contract = bfrCurrentLoan.parent-contract AND
                               bfrGeneralLoan.cont-code = bfrCurrentLoan.parent-cont-code NO-LOCK
  :
			
			/** -------------------------------------- ���� ������ ------------------------------------- */
			
			/** ����塞 ��� 䠩�� */
			fileName = "/home/bis/quit41d/imp-exp/users/" + LC(USERID) + "/fb_" + REPLACE(REPLACE(REPLACE(bfrCurrentLoan.doc-num,"/","-"),	"-", "_"), "�", "P") + ".html.doc".
  	  
  	  
  	  /**  - - - - - - ��������� �����-����ᯮ�����  - - - - - - - */
  	  /** ������ ���� ����ᯮ����� */
  	  FIND FIRST bfrBankCorrespond WHERE bfrBankCorrespond.bank-id = bfrCurrentLoan.cust-id NO-LOCK NO-ERROR.  	  
  	  /** ����� �ᯮ��㥬 �६����� ⠡���� */
  	  BUFFER-COPY bfrBankCorrespond TO ttBankCorrespond.
			/** ������ ��� �����-����ᯮ����� */
			FIND FIRST cust-ident WHERE cust-ident.cust-cat = "�" AND cust-ident.cust-id = ttBankCorrespond.bank-id
				AND cust-ident.cust-code-type = "���" NO-LOCK NO-ERROR.
			IF AVAIL cust-ident THEN ttBankCorrespond.inn = cust-ident.cust-code.
			/** ������ ��� �����-����ᯮ����� */
			FIND FIRST banks-code WHERE banks-code.bank-id = ttBankCorrespond.bank-id AND 
			                            banks-code.bank-code-type = "���-9" NO-LOCK NO-ERROR.
			IF AVAIL banks-code THEN ttBankCorrespond.bic = banks-code.bank-code.
			/** ������ ����.��� */
			FIND FIRST banks-corr WHERE banks-corr.bank-corr = ttBankCorrespond.bank-id NO-LOCK NO-ERROR.
			IF AVAIL banks-corr THEN ttBankCorrespond.corr-acct = banks-corr.corr-acct.
			/** ������ SWIFT �����-����ᯮ����� */
			FIND FIRST banks-code WHERE banks-code.bank-id = ttBankCorrespond.bank-id AND 
			                            banks-code.bank-code-type = "BIC" NO-LOCK NO-ERROR.
			IF AVAIL banks-code THEN ttBankCorrespond.swift = banks-code.bank-code.
			/** ������ ������᪮� ������������ */
			ttBankCorrespond.engl-name = GEtXAttrValueEx("banks", STRING(ttBankCorrespond.bank-id), "engl-name", "").
			
			
			/** ������ ��㤭� ��� ���. �஡���� � ⮬, �� �孨�᪨ ��� �ਢ易� �� � ᮣ��襭��, � � ���筮�
			�㬬�. ���筠� �㬬� ⠪ �� �࠭���� � ⠡��� loan � ����� ����� ���� ����� cont-code, ࠢ��� ������ ᤥ���.
			�� ���� ���� cont-code ���筮� �㬬� �⤥���� �஡���� � ���� ����஬ �� (1,2,...). ��� ��ࢮ� ᤥ��� �饬
			����� 1 - �� ��頥� ������. ���� ����� � ���쭥�襬 ���� �㤥� ����� � ����� ���ଠ�� � ⮬, ����� �� ᠬ��
			���� �㬥��� � ������ ��. */
			BUFFER-COPY bfrCurrentLoan TO ttCurrentLoan.
			ttCurrentLoan.loan-acct = GetLoanAcct_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code + "..", "�।��", ttCurrentLoan.open-date, false).
			/** ��� �� ���� ��室�� �� ��業⠬ �ਢ易� � ᠬ�� ᤥ��� */
			ttCurrentLoan.pers-acct = GetLoanAcct_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code, "�।���", ttCurrentLoan.open-date, false).
			/** �� � ��㯯� � ��業� �᪠ */
			/*
			ttCurrentLoan.risk = GetLoanInfo_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code, ,"gr_riska,risk", false).
			ttCurrentLoan.gr-riska = ENTRY(1, ttCurrentLoan.risk).
			ttCurrentLoan.risk = ENTRY(2, ttCurrentLoan.risk).
			*/


			/** ������ ������ ������� */
			FIND FIRST currency WHERE currency.currency = ttCurrentLoan.currency NO-LOCK NO-ERROR.

			
			/** ������ �㬬� ��業⮢ �� ��ਮ� ᤥ��� */
			FIND FIRST bfrPersentAmount WHERE bfrPersentAmount.contract = ttCurrentLoan.contract AND
																		    bfrPersentAmount.cont-code = ttCurrentLoan.cont-code AND
																		    bfrPersentAmount.end-date = ttCurrentLoan.end-date AND
																		    bfrPersentAmount.class-code = "mml-int-call" NO-LOCK NO-ERROR.
			
			/** ��।���� �஫���஢����� c�����. ��� �࠭���� � �.�. �࠭� ᤥ��� PrevLoanID. �᫨, ��砩��, �⮣� �.�. �� �࠭� ᤥ��� ���, � ����� "�����" ᠬ �� ᥡ�... */
			/** �⠪, ������ ᯥࢠ �࠭� ᤥ��� */
			FIND FIRST bfrCurrentLoanLine WHERE bfrCurrentLoanLine.contract = ttCurrentLoan.contract AND
			                                    ENTRY(1, bfrCurrentLoanLine.cont-code," ") = ttCurrentLoan.cont-code AND
			                                    NUM-ENTRIES(bfrCurrentLoanLine.cont-code, " ") = 2 NO-LOCK NO-ERROR.
			/** ���祭�� �.�. �࠭� ᤥ��� */                                    
			tmpStr = GetXAttrValueEx("loan", bfrCurrentLoanLine.contract + "," + bfrCurrentLoanLine.cont-code, "PrevLoanID", ttCurrentLoan.contract + "," + ttCurrentLoan.cont-code).
			
			/** �� ���������� ����� �㦭� ����� ⮫쪮 ����� ���� cont-code, � � ��� ⮦� ��뫠���� �� �࠭� ᤥ��� */
			FIND FIRST bfrRolloveredLoan WHERE bfrRolloveredLoan.contract = ENTRY(1, tmpStr) AND
			                                   bfrRolloveredLoan.cont-code = ENTRY(1, ENTRY(2, tmpStr), " ") NO-LOCK NO-ERROR.

			/** ������ ����� ᤥ���. �� �� ����! ��� ��� ⠬ ᫮���� ��⥬� �痢� �१ ����� �㬬� (�࠭�).
			�.�. ᭠砫� �㦭� ���� ���筠� �㬬� ⥪�饩 ᤥ���, ��⮬ ���� � ����� ���筮� �㬬�� �� ���筠� �㬬� �易�� � �.�. ���� �� ��।����, �� ����� 楯� �����稢�����... ��⮬ �� ��᫥���� ���筮� �㬬� ���� ᤥ���, 
			���ன ��� �ਭ�������. */
			
			REPEAT WHILE tmpStr <> "" :
				FIND FIRST bfrFirstLoan WHERE bfrFirstLoan.contract = ENTRY(1, tmpStr) AND
			                             	  bfrFirstLoan.cont-code = ENTRY(1, ENTRY(2, tmpStr), " ") NO-LOCK NO-ERROR.
			                              
				FIND FIRST bfrFirstLoanLine WHERE bfrCurrentLoanLine.contract = bfrFirstLoan.contract AND
			                                    ENTRY(1, bfrFirstLoanLine.cont-code," ") = bfrFirstLoan.cont-code AND
			                                    NUM-ENTRIES(bfrFirstLoanLine.cont-code, " ") = 2 NO-LOCK NO-ERROR.
				/** ���祭�� �.�. �࠭� ᤥ��� */                                    
				tmpStr = GetXAttrValueEx("loan", bfrFirstLoanLine.contract + "," + bfrFirstLoanLine.cont-code, "PrevLoanID", "").
			END.

			/** ������ �㬬� ᤥ��� */
			FIND FIRST bfrLoanAmount WHERE bfrLoanAmount.contract = bfrFirstLoan.contract AND 
			                               bfrLoanAmount.cont-code = bfrFirstLoan.cont-code AND
			                               bfrLoanAmount.end-date = bfrFirstLoan.open-date AND
			                               bfrLoanAmount.class-code = "mml-pr-obl" NO-LOCK NO-ERROR.
			                                   
			/** ��।���� �� �஫����樨 �� ᤥ���. �� ᠬ�� ����, �.�. ࠧࠡ��뢠���� �� � ᯥ誥 � ��� ���㬥��樨 � �������
			� �孮�����, �஫������ ����! �� �㬬� ��ࢮ� ᤥ���!  */
			FOR EACH bfrPay WHERE bfrPay.contract = bfrFirstLoan.contract AND
			                         bfrPay.cont-code = bfrFirstLoan.cont-code AND
			                         CAN-DO("mml-*-obl", bfrPay.class-code) AND
			                         bfrPay.end-date = bfrFirstLoan.open-date NO-LOCK
			  :
			  	outPayHtmlCode = outPayHtmlCode + 
			  		"<tr valign=top><td>" + bfrRolloveredLoan.doc-num + "</td>" + 
			  		"<td align=right>" + TRIM(STRING(bfrPay.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td>" +
			  		"<td align=right>" + TRIM(STRING(GetLoanCommissionEx_ULL(bfrRolloveredLoan.contract, bfrRolloveredLoan.cont-code, "%�।", bfrRolloveredLoan.open-date, false, tmpStr), ">>9.99")) + "</td>" +
			  		"<td align=right>" + TRIM(STRING(bfrPay.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td></tr>" + cr. 
      END.
      			  		
			/** ��।���� �� �室�騥 ���⥦� �� ᤥ��� */
			FOR EACH bfrPay WHERE bfrPay.contract = ttCurrentLoan.contract AND
			                         bfrPay.cont-code = ttCurrentLoan.cont-code AND
			                         CAN-DO("mml-*-call", bfrPay.class-code) NO-LOCK
			  :
			  	inPayHtmlCode = inPayHtmlCode + 
			  		"<tr valign=top><td>" + STRING(bfrPay.end-date, "99.99.9999") + "</td>" + 
			  		"<td>" + currency.i-currency + "</td>" + 
			  		"<td align=right>" + TRIM(STRING(bfrPay.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td>". 
			  		
			  	/** � ����ᨬ��� �� ����� ᫥���騥 ���� ������ ����������� ��-ࠧ���� */
			  	CASE ENTRY(2, bfrPay.class-code, "-") :
			  		WHEN "pr" THEN 
			  			DO:
			  				inPayHtmlCode = inPayHtmlCode +
			  				"<td>" + ttCurrentLoan.loan-acct + "</td>" + 
			  				"<td>" + bfrPay.acct + "</td>".
			  			END.
			  		WHEN "int" THEN 
			  			DO:
			  				inPayHtmlCode = inPayHtmlCode +
			  				"<td>" + ttCurrentLoan.pers-acct + "</td>" + 
			  				"<td>" + bfrPay.acct + "</td>".
			  			END.
			  		OTHERWISE 
			  			DO:
			  				inPayHtmlCode = inPayHtmlCode +
			  				"<td>" + "�� ��।����" + "</td>" + 
			  				"<td>" + "�� ��।����" + "</td>".
			  			END.
			  			
					END CASE.
					
			  	inPayHtmlCode = inPayHtmlCode + "</tr>" + cr.
			END.
			
  	  /** ------------------------------------- �뢮� ������ -------------------------------------- */
  	  OUTPUT TO VALUE(fileName) CONVERT TARGET "1251" SOURCE SESSION:CHARSET. 
  	  PUT UNFORMATTED "<html>" + cr.
  	  PUT UNFORMATTED '<head><title></title><meta http-equiv="Content-Type" content="text/html; application/msword; charset=windows-1251"></head>' + cr.

  	  PUT UNFORMATTED "<body>" + cr.

  	  /** ���� ������� ���㬥�� */
  	  PUT UNFORMATTED "<table border=0 widht=100% height=100% bgcolor=#000000 cellpadding=0 cellspacing=1>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td>" + bankName + "</td><td>�⢥ত��<br>" 
  	  										+ ENTRY(2, agreeUser) + "<br>_____________" + ENTRY(3, agreeUser) 
  	  										+ "</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>������������<br>�� ������ �� ������������� �������� �����<br><br>N " 
  	  										+ ttCurrentLoan.doc-num + "</b></td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>�������� �������<b><br>" + cr +
  	  									  "<table border=0 width=100%>" + cr +
  	  									  	"<tr><td valign=top>" + cr +
  	  									  		"<table border=0><tr><td>��� ᤥ���</td><td>" + STRING(ttCurrentLoan.open-date, "99.99.9999") + "</td></tr>" + cr +
  	  									  		"<tr><td>������</td><td><b>�஫������</b></td></tr>" + cr +
  	  									  		"<tr><td>����ࠣ���</td><td>" + 
  	  									  			(IF ttCurrentLoan.currency = "" THEN ttBankCorrespond.name + "<br>��� " + ttBankCorrespond.inn
  	  									  			                                ELSE ttBankCorrespond.engl-name + ",<br>" + ttBankCorrespond.swift) + 
  	  									  		  "</td></tr>" + cr +
  	  									  		"<tr><td>����ࠫ쭮� ᮣ��襭��</td><td>� " + bfrGeneralLoan.doc-ref + " �� " + STRING(bfrGeneralLoan.open-date, "99.99.9999") + "</td></tr>" + cr +
  	  									  		"</table>" + cr +
  	  									  	"</td><td valign=top>" + cr +
  	  									  		"<table border=0><tr><td>�����</td><td>" + currency.i-currency + "</td></tr>" + cr +
  	  									  		"<tr><td>�㬬�</td><td>" + TRIM(STRING(bfrLoanAmount.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td></tr>" + cr +
  	  									  		"<tr><td>�⠢��</td><td>" + TRIM(STRING(GetLoanCommissionEx_ULL(ttCurrentLoan.contract, ttCurrentLoan.cont-code, "%�।", ttCurrentLoan.open-date, false, tmpStr), ">>9.99")) + "</td></tr>" + cr +
  	  									  		"<tr><td>��� ��砫�</td><td>" + STRING(ttCurrentLoan.open-date, "99.99.9999") + "</td></tr>"
  	  									  		"<tr><td>��� ����砭��</td><td>" + STRING(ttCurrentLoan.end-date, "99.99.9999") + "</td></tr>"
  	  									  		"<tr><td>������⢮ ����</td><td>" + STRING(INT(ttCurrentLoan.end-date - ttCurrentLoan.open-date)) + "</td></tr>"
  	  									  		"<tr><td>�㬬� ��業⮢</td><td>" + TRIM(STRING(bfrPersentAmount.amt-rub, ">>>,>>>,>>>,>>9.99")) + "</td></tr>"
  	  									  		"</table>" + cr +
  	  									  	"</td></tr>" + cr +
  	  										"</table>" + cr +
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>�����������</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>����� ᤥ���<hr size=1></td><td align=right>�㬬� ᤥ���<hr size=1></td><td align=right>�⠢��<hr size=1></td><td align=right>�㬬� �஫����樨<hr size=1></td></tr>" + cr +
  	  											outPayHtmlCode + 
  	  										"</table>" + cr + 
  	  										"<br>" + cr +
  	  										"<table border=0 width=100%><tr><td>��ࢠ� ᤥ���</td><td>N " + bfrFirstLoan.doc-num + " �� " + STRING(bfrFirstLoan.open-date, "99.99.9999") + " (�ᥣ� ���-�� ����: " + STRING(INT(ttCurrentLoan.end-date - bfrFirstLoan.open-date)) + ")</td></tr></table>" + cr +
  	  										"<br><b>������� �����������</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>���<hr size=1></td><td>�����<hr size=1></td><td align=right>�㬬�<hr size=1></td><td>���������<hr size=1></td><td>�࠭�����<hr size=1></td></tr>" + cr +
  	  											inPayHtmlCode + 
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>�������������� ����������</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>��⥣��� ����⢠</td><td>" + STRING(ttCurrentLoan.gr-riska) + " (" + STRING(ttCurrentLoan.risk) + "%)</td></tr>" + cr +
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center><b>������� ������������</b>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td>��� � �६�</td><td>" + STRING(TODAY, "99.99.9999") + " " + STRING(TIME, "HH:MM:SS") + "</td></tr>" + cr +
  	  											kaznaSignsHtmlCode + 
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	  									"<tr><td><table border=0 width=100% bgcolor=#FFFFFF><tr><td align=center>" + cr +
  	  										"<table border=0 width=100%>" + cr +
  	  											"<tr><td width=60%><b>������� ������������ ����� � ����������</b></td><td>_____________(" + ENTRY(3, reportUser) + 
  	  											")</td></tr>" + cr +
  	  										"</table>" + cr + 
  	  									"</td></tr></table></td></tr>" + cr +
  	                  "</table>" + cr.
  	  PUT UNFORMATTED "</body>" + cr.
  	  PUT UNFORMATTED "</html>" + cr.
  	  
  	  OUTPUT CLOSE.  	  
  	  
  	  MESSAGE "���� ��ନ஢�� � ��࠭�� � " + fileName VIEW-AS ALERT-BOX.
  	  
END.
