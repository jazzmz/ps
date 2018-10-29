/* ------------------------------------------------------
     File: $RCSfile: pir_valvip.p,v $ $Revision: 1.5 $ $Date: 2009-05-26 10:14:19 $
     Copyright: ��� �� "�p������������"
     ���������: -
     ��稭�: ��� ��, �� �᭮����� ���쬠 �� ������ �.�. � ���� 2009
     �� ������: �ନ��� �믨�� �� ������ ������, ����� 
                 ����㯨�� �� ��⥬ iBank2 � SWIFT. ����� �ᯮ�������� � 
                 䠩� �ଠ� XML:EXCEL
     ��� ࠡ�⠥�: �� ��࠭�� � ��㧥� ���㬥�⮢ ������, ��楤�� 
                   �������� �६����� ⠡����, ᮡ��� ����室��� �����.
                   � �᭮����, ����� ��� ���� �࠭���� � �������⥫��� ४������
                   ᮮ�饭�� (�����: msg-impexp), ���஥ �易��� � ���㬥�⮬
     ��ࠬ����: <��⠫��_�ᯮ��>
     ���� ����᪠: ��㧥� ���㬥�⮢
     ����: $Author: Buryagin $ 
     ���������: $Log: not supported by cvs2svn $
     ���������: Revision 1.4  2009/05/25 14:46:08  Buryagin
     ���������: Added option for div or not div data by client's page
     ���������:
     ���������: Revision 1.2  2009/04/01 10:11:25  Buryagin
     ���������: Fix the Benef and Order information for the transit operations. Added the origin details of operation into last column.
     ���������:
     ���������: Revision 1.1  2009/03/25 08:47:06  Buryagin
     ���������: For PODFT and Currency Department
     ���������:
------------------------------------------------------ */

/** �������� ��⥬�� ��।������ */
{globals.i}

/** ������⥪� ��� ᮧ����� XML:EXCEL 䠩�� */
{uxelib.i}
{ulib.i}
{get-bankname.i}
/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}
/* ��।������ �������� �������᪮�� 䨫���. */
{flt-val.i}

DEFINE INPUT PARAM iParam AS CHAR.
DEFINE VAR saveDir AS CHAR NO-UNDO.
DEFINE VAR clientAcctMask AS CHAR NO-UNDO.
DEFINE VAR corsAcctMask AS CHAR NO-UNDO.
DEFINE VAR transAcctMask AS CHAR NO-UNDO.
DEFINE VAR flag AS logical NO-UNDO init false.

DEFINE TEMP-TABLE ttReport
	FIELD id AS INT
	FIELD direct AS CHAR /** in, out */
	FIELD ourClientID AS CHAR /** ��� ��㯯�஢�� */
	FIELD ourClientName AS CHAR 
	/** ���⥦�� ���㬥�� */
	FIELD docNum AS CHAR
	FIELD docDate AS CHAR
	FIELD docAmount AS CHAR /* �ଠ�: 999999,99 */
	FIELD docCurrency AS CHAR 
	FIELD docAmountRUR AS CHAR 
	FIELD docDetails AS CHAR
	FIELD docOrigDetails AS CHAR /** �����祭�� ���⥦� �� ���㬥�� SWIFT */
	/** ����-���⥫�騪 */
	FIELD bankOutBic AS CHAR
	FIELD bankOutName AS CHAR
	FIELD bankOutStrana AS CHAR
	/** ������-���⥫�騪 */
	FIELD clientOutName AS CHAR
	FIELD clientOutInn AS CHAR
	FIELD clientOutAcct AS CHAR
	FIELD clientOutStrana AS CHAR
	/** ����-�����⥫� */
	FIELD bankInBic AS CHAR
	FIELD bankInName AS CHAR
	FIELD bankInStrana AS CHAR
	/** ������-�����⥫� */
	FIELD clientInName AS CHAR
	FIELD clientInStrana AS CHAR
	FIELD clientInInn AS CHAR
	FIELD clientInAcct AS CHAR
	FIELD codeVO AS CHAR
	
	/** ⥣� 
	    �ଠ�: <litera>=<value>|<litera>=<value>|...|<litera>=<value> 
	*/
	FIELD tag32 AS CHAR /** �㬬� ����樨. �� ॠ�쭮 �㬬� ��६ �� �஢���� */
	FIELD tag50 AS CHAR /** ����� ��� ���⥫�騪� ��� �室��� ���.*/
	FIELD tag52 AS CHAR /** ����-��ࠢ�⥫� */
	FIELD tag59 AS CHAR /** ����� ��� �����⥫� ��� ��室��� ���. */
	FIELD tag70 AS CHAR /** �ਣ����쭮� �����祭�� ���⥦� */
.

DEFINE TEMP-TABLE t_tmprecid
	FIELD t_id AS INT
.
/** ���⥫�騪 ��� �����⥫� */
DEF BUFFER bfrClient FOR cust-role.
/** ���� ���⥫�騪� ��� ���� �����⥫� */
DEF BUFFER bfrBank FOR cust-role.
/** �㬬� ����樨 */
DEF BUFFER bfrOpEntry FOR op-entry.

DEF VAR i AS INTEGER NO-UNDO INIT 0.
DEF VAR tmpStr AS CHAR NO-UNDO.
DEF VAR tmpStr2 AS CHAR NO-UNDO.

clientAcctMask = GetParamByName_ULL(iParam, "clientAcctMask", ".", ";").
corsAcctMask = GetParamByName_ULL(iParam, "corsAcctMask", ".", ";").
transAcctMask = GetParamByName_ULL(iParam, "transAcctMask", ".", ";").
/** ��ࠡ�⪠ ��࠭��� ���㬥�⮢ */
FOR EACH tmprecid NO-LOCK,
    FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
    FIRST op-entry WHERE op-entry.op = op.op
                     AND (CAN-DO(clientAcctMask, op-entry.acct-db) OR
                          CAN-DO(transAcctMask, op-entry.acct-db) OR 
                          CAN-DO(clientAcctMask, op-entry.acct-cr) OR
                          CAN-DO(transAcctMask, op-entry.acct-cr)
                         )
                     NO-LOCK,
    /** �㬬� ����樨 �饬 � �஢���� � ����ᯮ����樥� ����-��� */
    FIRST bfrOpEntry WHERE bfrOpEntry.op = op.op
                       AND (CAN-DO(corsAcctMask, op-entry.acct-db) OR CAN-DO(corsAcctMask, op-entry.acct-cr))
                       NO-LOCK
  :
  	i = i + 1.
	CREATE t_tmprecid.
	t_tmprecid.t_id = tmprecid.id. 
  	CREATE ttReport.
  	ttReport.id = i.
  	
	FIND FIRST msg-impexp WHERE msg-impexp.object-id = STRING(op.op) NO-LOCK NO-ERROR.
	IF AVAIL msg-impexp THEN DO:	
  		ttReport.tag32 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift32", "").
  		ttReport.tag50 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift50", "").
  		/** �� ���饥 
  		ttReport.tag52 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift70", "").
  		*/
  	
  		ttReport.tag59 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift59", "").
  	
  		/** "=" ��㬮�砭�� ��⮬�, �� 70 ⥣ �� ���������� �㪢��� � ���祭�� �.�. �㤥�
  	    	��宦� �� "=<���祭��>" 
  		*/
  		ttReport.tag70 = 	GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0", 
  						"pirSwift70", "=").
  
  	END.
  	
  	/** ���㬥��: ����� � ��� */
  	ttReport.docNum = op.doc-num.
  	ttReport.docDate = STRING(op.op-date, "99.99.9999").
  	
  	/** �㬬� ����樨 �� SWIFT
  	tmpStr = "". tmpStr = GetParamByName_ULL(ttReport.tag32, "A", "", "|").
  	ttReport.docAmount = SUBSTR(tmpStr, 10).
  	*/
  	
  	/** �㬬� ����樨 �� �஢���� */ 
  	ttReport.docAmount = REPLACE(STRING(bfrOpEntry.amt-cur), ",", ".").
  	ttReport.docCurrency = bfrOpEntry.currency.
  	ttReport.docAmountRUR = REPLACE(STRING(bfrOpEntry.amt-rub), ",", ".").

  	/** �����祭�� ���⥦� �� ���㬥�� � �� SWIFT */
  	ttReport.docDetails = op.details.
  	ttReport.docOrigDetails = ENTRY(2, ttReport.tag70, "=").
	tmpStr = GetXAttrValueEx("op", STRING(op.op), "��������117", "").
  	ttReport.codeVO = "VO" + ENTRY(1, tmpStr).
  	IF NUM-ENTRIES(ttReport.docDetails, "\}") = 2 THEN DO:
  	  	ttReport.codeVO = ENTRY(1, ENTRY(2, ENTRY(1, ttReport.docDetails, "\}"), "\{"), ",").
  	END. 
  	
  	
  	FIND FIRST bfrClient WHERE bfrClient.file-name = "op" 
                      AND bfrClient.surrogate = STRING(op.op)
                      AND CAN-DO("Order-Cust,Benef-Cust", bfrClient.Class-code)
                      NO-LOCK NO-ERROR.
    FIND FIRST bfrBank WHERE bfrBank.file-name = "op"
                    AND bfrBank.surrogate = STRING(op.op)
                    AND CAN-DO("Order-Inst,Benef-Inst", bfrBank.Class-code)
                    NO-LOCK NO-ERROR.  	
  	
  	/** ��।��塞 ���ࠢ����� ���⥦� */
  	IF AVAIL bfrClient AND bfrClient.class-code = "Order-Cust" THEN ttReport.direct = "in".
  	IF AVAIL bfrClient AND bfrClient.class-code = "Benef-Cust" THEN ttReport.direct = "out".

  	/** ���⥫�騪 */
  	IF ttReport.direct = "in" THEN DO:
  		IF AVAIL bfrBank THEN do:
			ttReport.bankOutBic = bfrBank.cust-code.
  			ttReport.bankOutName = bfrBank.cust-name.
                        ttReport.bankOutStrana = bfrBank.country-id.
		end.
  		IF AVAIL bfrClient THEN do:
			ttReport.clientOutName = bfrClient.cust-name.
			ttReport.clientOutStrana = bfrClient.country-id.
		end.
  		ttReport.clientOutInn = "".
  		tmpStr = GetParamByName_ULL(ttReport.tag50, "F", "", "|") + GetParamByName_ULL(ttReport.tag50, "K", "", "|").
  		ttReport.clientOutAcct = ENTRY(2, ENTRY(1, tmpStr, CHR(126)), "/").
  	END.
  	/* �����⥫� */
  	IF ttReport.direct = "out" THEN DO:
  		IF AVAIL bfrBank THEN do:
			ttReport.bankInBic = bfrBank.cust-code.
  			ttReport.bankInName = bfrBank.cust-name.
			ttReport.bankInStrana = bfrBank.country-id.
		end.
  		IF AVAIL bfrClient THEN do:
			ttReport.clientInName = bfrClient.cust-name.
			ttReport.clientInStrana = bfrClient.country-id.
		end.
  		ttReport.clientInInn = "".
  		ttReport.clientInAcct = ENTRY(2, ENTRY(1, ENTRY(2, ttReport.tag59, "="), CHR(126)), "/").
  	END.
  	
  	IF ttReport.direct = "in" THEN DO:
  	
  		/** ���ଠ��, ����� �⭮���� ������ � ��襬� �������,
  		    ���� �᫨ ���⥦ �࠭����. ���ਬ��, ��� ������ - ����.
  		    ������� ��襣� ������ ᮢ����� ���⥦�, ����� �� 
  		    �㤥� ��㯯�஢��� �� ID ��襣� ������ 
  		*/
  		ttReport.ourClientID = GetAcctClientId_ULL(op-entry.acct-cr, false).
  		ttReport.ourClientName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).
  	
		/** �᫨ ��� ���� ���� �࠭���� (���⥦ ��室�� �१
		    �������), � ����� ������-�����⥫�
		    �⠥� �� swift, ����� �����-�����⥫� ��६ �� �࠭��⭮�� ����, 
		    
		    �᫨ ���⥦ �� �࠭����, � �⠥� �� �� ����஥� */
		    
		if (CAN-DO(transAcctMask, op-entry.acct-db) OR 
		    CAN-DO(transAcctMask, op-entry.acct-cr))
		then 
			do:
				/** ����-�����⥫� */
		  		ttReport.bankInBic = GetClientInfo_ULL(ttReport.ourClientID, "bank-code:bic;���-9", false).
				ttReport.bankInName = ttReport.ourClientName.
				ttReport.bankInStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
				
				/** ��� � ������������ �����⥫� */
				tmpStr = ttReport.tag59.
  				
  				ttReport.clientInAcct = ENTRY(2, ENTRY(1, ENTRY(2, ttReport.tag59, "="), CHR(126)), "/").
  			
  				tmpStr2 = "".
  				DO i = 2 TO NUM-ENTRIES(tmpStr, CHR(126)) :
  					if tmpStr2 <> "" then tmpStr2 = tmpStr2 + CHR(13) + CHR(10).
  					tmpStr2 = tmpStr2 + ENTRY(i, tmpStr, CHR(126)).
  				END.
  				ttReport.clientInName = tmpStr2.
  				ttReport.clientInStrana = "".
			end.
		else
			do:
		  		ttReport.bankInBic = FGetSetting("�������", "", "").
  				ttReport.bankInName = cBankName.
  				ttReport.bankInStrana = "RUS".
		  		ttReport.clientInAcct = op-entry.acct-cr.
  				ttReport.clientInName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).
		  		ttReport.clientInInn = GetClientInfo_ULL(ttReport.ourClientID, "inn", false).
  				ttReport.clientInStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
		  	end.
  	END.

  	/* ���⥫�騪 */
	IF ttReport.direct = "out" THEN DO:
		
  		/** ���ଠ��, ����� �⭮���� ������ � ��襬� �������,
  		    ���� �᫨ ���⥦ �࠭����. ���ਬ��, ��� ������ - ����.
  		    ������� ��襣� ������ ᮢ����� ���⥦�, ����� �� 
  		    �㤥� ��㯯�஢��� �� ID ��襣� ������ 
  		*/
  		ttReport.ourClientID = GetAcctClientId_ULL(op-entry.acct-db, false).
  		ttReport.ourClientName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).

		/** �᫨ ��� ���� ���� �࠭���� (���⥦ ��室�� �१
		    �������), � ����� ������-���⥫�騪�
		    �⠥� �� swift, ����� �����-���⥫�騪� ��६ �� �࠭��⭮�� ����, 
		    
		    �᫨ ���⥦ �� �࠭����, � �⠥� �� �� ����஥� */
		    
		if (CAN-DO(transAcctMask, op-entry.acct-db) OR 
		    CAN-DO(transAcctMask, op-entry.acct-cr))
		then 
			do:
				/** ����-���⥫�騪� */
		  		ttReport.bankOutBic = GetClientInfo_ULL(ttReport.ourClientID, "bank-code:bic;���-9", false).
				ttReport.bankOutName = ttReport.ourClientName.
				ttReport.bankOutStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
				
				/** ��� � ������������ ���⥫�騪� */
				tmpStr = GetParamByName_ULL(ttReport.tag50, "F", "", "|") + GetParamByName_ULL(ttReport.tag50, "K", "", "|").
  				
  				ttReport.clientOutAcct = ENTRY(2, ENTRY(1, tmpStr, CHR(126)), "/").
  				/** �� ॠ��� ��� ���⥫�騪� ����� ᫥������ �� �࠭���� (�ଠ� �������� �� �����) 
  				    ��� ��� ����� �뫮 ������� � ����, �� ����� ����⭮ */
  				if num-entries(ENTRY(1, tmpStr, CHR(126)), "/") = 3 then do:
  					ttReport.clientOutAcct = ENTRY(3, ENTRY(1, tmpStr, CHR(126)), "/").
  				end.
  			
  				tmpStr2 = "".
  				DO i = 2 TO NUM-ENTRIES(tmpStr, CHR(126)) :
  					if tmpStr2 <> "" then tmpStr2 = tmpStr2 + CHR(13) + CHR(10).
  					tmpStr2 = tmpStr2 + ENTRY(i, tmpStr, CHR(126)).
  				END.
  				ttReport.clientOutName = tmpStr2.
  				ttReport.clientOutStrana = "".
			end.
		else
			do:
			  	ttReport.bankOutBic = FGetSetting("�������", "", "").
  				ttReport.bankOutName = cBankName.
  				ttReport.bankOutStrana = "RUS".
		  		ttReport.clientOutAcct = op-entry.acct-db.
		  		ttReport.clientOutName = GetClientInfo_ULL(ttReport.ourClientID, "name", false).
		  		ttReport.clientOutInn = GetClientInfo_ULL(ttReport.ourClientID, "inn", false).
				ttReport.clientOutStrana = GetClientInfo_ULL(ttReport.ourClientID, "country", false).
			end.
  		
  	END.
  	
END.
/** ᡮ� ������ �����祭 */

/** ��ନ஢���� XML:EXCEL 䠩�� */
pause 0.

saveDir = GetParamByName_ULL(iParam, "saveDir", "./users/" + LC(USERID), ";").
DEFINE VAR fileName AS CHAR NO-UNDO LABEL "��� 䠩��"  FORMAT "x(65)".
DEFINE VAR divPage AS LOGICAL NO-UNDO LABEL "������� ������� ᢮� ����?" FORMAT "��/���" INIT "��".
DEFINE VAR Strana AS CHAR format 'x(450)' VIEW-AS FILL-IN SIZE 45 by 1 init '*' no-undo.
fileName = GetParamByName_ULL(iParam, "fileName", "valvip.xml", ";").
fileName = saveDir + "/" + fileName.
/*UPDATE filename SKIP divPage WITH FRAME tmpFrame OVERLAY CENTERED.
HIDE FRAME tmpFrame.
*/
form
    "��� 䠩��:" fileName no-label skip
    "������� ������� ᢮� ����? :" divPage no-label skip
    "���᮪ ��࠭(�롮� �� F1)  :" Strana no-label skip
     with frame wow OVERLAY ROW 10 SIDE-LABELS TITLE
          COLOR bright-white "[ ����� �� �ନ஢���� �������� ]".

pause 0.

   
do transaction with frame wow:
	update fileName divPage Strana editing: readkey.
	        if lastkey eq keycode('F1') AND (frame-field EQ 'Strana') then do:
       		       RUN browseld.p ('country',
                                  '',
                                  '',
                                  ?,
                                  1) NO-ERROR.
				if lastkey eq 10 then do:
/*				disp pick-value @ Strana. */
                                Strana = "".
				for each tmprecid NO-LOCK, FIRST country WHERE RECID(country) = tmprecid.id NO-LOCK:
					Strana = Strana + country.country-id + ",".
				end.
                                Strana = substring(Strana,1,LENGTH(Strana) - 1).
				disp Strana @ Strana. 
			end.
	        end.
	        else do: apply lastkey.
		end.
 	end.
    end.

    HIDE FRAME wow NO-PAUSE.
    if lastkey eq 27 then do:
       HIDE FRAME wow.
       return.
end.  


DEF VAR styleXmlCode AS CHAR NO-UNDO.
DEF VAR cnt AS INTEGER NO-UNDO. 

OUTPUT TO VALUE(fileName).

	/** ������ �⨫� */
	styleXmlCode = CreateExcelStyle("Center", "Center", 2, "title1") +
	               CreateExcelStyle("Left", "Center", 1, "cell1") +
	               CreateExcelStyle("Right", "Center", 1, "cell2") +
	               CreateExcelStyle("Right", "Center", 2, "total1").
	/** ������ ����� */
	PUT UNFORMATTED CreateExcelWorkbook(styleXmlCode).
	/** �뢮��� ����� */
	
	FOR EACH ttReport where can-do(Strana,ttReport.bankOutStrana) or can-do(Strana,ttReport.clientOutStrana)
		or can-do(Strana,ttReport.bankInStrana) or can-do(Strana,ttReport.clientInStrana)	
		BREAK BY ttReport.ourClientID:
		flag = true.
		IF (FIRST-OF(ttReport.ourClientID) AND divPage) OR (FIRST(ttReport.ourClientID) AND NOT divPage) THEN DO: 
			
			cnt = 0.
			
			/** ������ ���� */
			IF divPage THEN 
				PUT UNFORMATTED CreateExcelWorksheet(SUBSTRING(LoopReplace_ULL(ttReport.ourClientName, '"', ""), 1, 15)).
			ELSE
				PUT UNFORMATTED CreateExcelWorksheet(SUBSTRING(LoopReplace_ULL("��", '"', ""), 1, 15)).
	
			PUT UNFORMATTED 
			
			/** ������ �ਭ� �⮫�殢 */ 
			SetExcelColumnWidth(1, 50) +
			SetExcelColumnWidth(2, 70) + 
			SetExcelColumnWidth(3, 100) +
			SetExcelColumnWidth(4, 200) +
			SetExcelColumnWidth(5, 70) +
			SetExcelColumnWidth(6, 200) +
			SetExcelColumnWidth(7, 70) +
			SetExcelColumnWidth(8, 100) +
			SetExcelColumnWidth(9, 200) +
			SetExcelColumnWidth(10, 100) +
			SetExcelColumnWidth(11, 200) +
			SetExcelColumnWidth(12, 70) +
			SetExcelColumnWidth(13, 200) +
			SetExcelColumnWidth(14, 70) +
			SetExcelColumnWidth(15, 100) +
			SetExcelColumnWidth(16, 200) +
			SetExcelColumnWidth(17, 70) +
			SetExcelColumnWidth(18, 40) +
			SetExcelColumnWidth(19, 70) +
			SetExcelColumnWidth(20, 400) +								
			SetExcelColumnWidth(21, 400) + 
			SetExcelColumnWidth(22, 100)							
			/** �뢮��� �������� ���� */ 
			CreateExcelRow(
				CreateExcelCell("String", "", "��室�� � ��室�� ����樨 " + (IF divPage THEN ttReport.ourClientName ELSE "") + " �� ��ਮ� � " + GetFltVal("op-date1") + " �� " + GetFltVal("op-date2"))
			) +
						
			/** �뢮��� ��������� ���� */
			CreateExcelRow(
				CreateExcelCell("String", "title1", "����� �/�") +
				CreateExcelCell("String", "title1", "��� ᮢ��襭�� ����樨") +
				CreateExcelCell("String", "title1", "��� �����-���⥫�騪�") +
				CreateExcelCell("String", "title1", "������������ �����-���⥫�騪�") +
				CreateExcelCell("String", "title1", "��� ��࠭� ॣ����樨 �����-���⥫�騪�") +
				CreateExcelCell("String", "title1", "������������ ���⥫�騪�") +
				CreateExcelCell("String", "title1", "��� ��࠭� ॣ����樨 ���⥫�騪�") +
				CreateExcelCell("String", "title1", "��� ���⥫�騪�") +
				CreateExcelCell("String", "title1", "����� ��� ���⥫�騪�") +
				CreateExcelCell("String", "title1", "��� �����-�����⥫�") +
				CreateExcelCell("String", "title1", "������������ �����-�����⥫�") +
				CreateExcelCell("String", "title1", "��� ��࠭� ॣ����樨 �����-�����⥫�") +
				CreateExcelCell("String", "title1", "������������ �����⥫�") +
				CreateExcelCell("String", "title1", "��� ��࠭� ॣ����樨 �����⥫�") +
				CreateExcelCell("String", "title1", "��� �����⥫�") +
				CreateExcelCell("String", "title1", "����� ��� �����⥫�") +
				CreateExcelCell("String", "title1", "�㬬� ����樨") +
				CreateExcelCell("String", "title1", "����� ����樨") + 
				CreateExcelCell("String", "title1", "�㬬� ����樨 (��)") +
				CreateExcelCell("String", "title1", "�����祭�� ���⥦�") +
				CreateExcelCell("String", "title1", "����ঠ��� ����樨 (� ���)") +
				CreateExcelCell("String", "title1", "��� ����⭮�� ����஫�")
			).
			
		END. /* ���� ���� */
				
		PUT UNFORMATTED CreateExcelRow(
			CreateExcelCell("String", "cell1", ttReport.docNum) +
			CreateExcelCell("String", "cell1", ttReport.docDate) +
			CreateExcelCell("String", "cell1", ttReport.bankOutBic) +
			CreateExcelCell("String", "cell1", ttReport.bankOutName) +
			CreateExcelCell("String", "cell1", ttReport.bankOutStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientOutName) +
			CreateExcelCell("String", "cell1", ttReport.clientOutStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientOutInn) +
			CreateExcelCell("String", "cell1", ttReport.clientOutAcct) +
			CreateExcelCell("String", "cell1", ttReport.bankInBic) +
			CreateExcelCell("String", "cell1", ttReport.bankInName) +
			CreateExcelCell("String", "cell1", ttReport.bankInStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientInName) +
			CreateExcelCell("String", "cell1", ttReport.clientInStrana) +
			CreateExcelCell("String", "cell1", ttReport.clientInInn) +
			CreateExcelCell("String", "cell1", ttReport.clientInAcct) +
			CreateExcelCell("Number", "cell2", ttReport.docAmount) +
			CreateExcelCell("Number", "cell1", ttReport.docCurrency) +
			CreateExcelCell("Number", "cell2", ttReport.docAmountRUR) +
			CreateExcelCell("String", "cell1", ttReport.docOrigDetails) +
			CreateExcelCell("String", "cell1", ttReport.docDetails) +
			CreateExcelCell("String", "cell1", ttReport.codeVO)
		). 
		
		/** ���稪 ���㬥�⮢. �㦥� ��� ���� �⮣� */
		cnt = cnt + 1.

	IF (LAST-OF(ttReport.ourClientID) AND divPage) OR 
	   (LAST(ttReport.ourClientID) AND NOT divPage) THEN DO:

		/** �⮣���� ��ப�. �㬬��㥬 ������� "�㬬� ���㬥��" */
		PUT UNFORMATTED CreateExcelRow(
			CreateExcelCellEx(17, "Number", "total1", "=SUM(R[-" + STRING(cnt) + "]C[0]:R[-1]C[0])", "0") +
			CreateExcelCellEx(19, "Number", "total1", "=SUM(R[-" + STRING(cnt) + "]C[0]:R[-1]C[0])", "0")
		). 
	
		PUT UNFORMATTED CloseExcelTag("Worksheet").
	END.

	END.
				
	PUT UNFORMATTED CloseExcelTag("Workbook").

OUTPUT CLOSE.

for each tmprecid no-lock:
	delete tmprecid.
end.

for each t_tmprecid no-lock:
	create tmprecid.
	tmprecid.id = t_tmprecid.t_id.
end.

if flag then do:
	MESSAGE "����� �ᯮ��஢��� � 䠩� " + fileName VIEW-AS ALERT-BOX.
end.
else do:
	MESSAGE "����� �� 䨫���� �� �������. �㦭� �������� ����� 䨫���樨" VIEW-AS ALERT-BOX.
end.
