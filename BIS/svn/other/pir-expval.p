/* ��� "��� ����" ��ࠢ����� ��⮬�⨧�樨 2013�.								*/
/* #3474													*/
/* ����砫쭮 ����ᠭ� �.��砥��.										*/
/* �������� �.����஢� ��� ��ࠡ�⪨ ����� ���㬥�⮢							*/
/* �� ������: ��ᯮ����� ����� �� ��� � ⥪�⮢� 䠩�, ������ ��� SWIFT					*/
/* ��� ࠡ�⠥�: �� ��࠭�� � ��㧥� ���㬥�⮢ ������, ��楤��  �������� 䠩� � ����室���� �ଠ�.	*/
/* ���� ����᪠: ��㧥� ���㬥�⮢.										*/

/** �������� ��⥬�� ��।������ */
{globals.i}
{ulib.i} 

/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}
{wordwrap.def}
{gstrings.i}


/*DEF INPUT PARAM iParam AS CHAR.*/
define variable saveDir AS CHAR NO-UNDO.
define variable fileName AS CHAR NO-UNDO.
define variable rSurrogate as char no-undo.
define variable rClass as char no-undo.
define variable rProc as char init "pir-swiftfill" no-undo. 

DEF TEMP-TABLE ttReport NO-UNDO
	FIELD id AS INT
	FIELD ourClientID AS CHAR /** ��� ��㯯�஢�� */
	FIELD doc-num AS INT INIT 0	/**	����� ���㬥��	*/
	FIELD bank AS CHAR INIT ""	/**	Receiver ����	*/
	/** ⥣� 
		�ଠ�: <litera>=<value>~<litera>=<value>~...~<litera>=<value> 
	*/
	/** ⥣� SWIFT */
	FIELD tag13 AS CHAR INIT "" /**	�������� �६���	*/
	FIELD tag20 AS CHAR INIT "" /**	���७� ��ࠢ�⥫� */
	FIELD tag23 AS CHAR INIT "" /**	�=��� ������᪮� ����樨 �=��� ������権 */
	FIELD tag26 AS CHAR INIT "" /**	��� ⨯� ����樨 */
	FIELD tag32 AS CHAR INIT "" /**	��� �����஢���� / ����� / �㬬� �� */
	FIELD tag33 AS CHAR INIT "" /**	����� / �㬬� ���⥦���� ����祭�� */
	FIELD tag36 AS CHAR INIT "" /**	���� �������樨 */
	FIELD tag50Cor AS CHAR INIT "" /**	������ - �����稪 */
	FIELD tag51 AS CHAR INIT "" /**	�࣠����� ��ࠢ�⥫� */
	FIELD tag52 AS CHAR INIT "" /**	�����ᮢ�� �࣠������ - �����稪 */
	FIELD tag53 AS CHAR INIT "" /**	������ ��ࠢ�⥫� */
	FIELD tag54 AS CHAR INIT "" /**	������ �����⥫� */
	FIELD tag55 AS CHAR INIT "" /**	��⨩ ���� �����饭�� */
	FIELD tag56 AS CHAR INIT "" /**	���।��� */
	FIELD tag57 AS CHAR INIT "" /**	���� �����樠� */
	FIELD tag59Cor AS CHAR INIT "" /**	������ - �����樠� */
	FIELD tag59 AS CHAR INIT "" /**	������ - �����樠� */
	FIELD tag70 AS CHAR INIT "" /**	���ଠ�� � ���⥦� */
	FIELD tag70Cor AS CHAR INIT "" /**	���ଠ�� � ���⥦� */
	FIELD tag71 AS CHAR INIT "" /**	��⠫����� ��室�� */
	FIELD tag72 AS CHAR INIT "" /**	���ଠ��, ��ࠢ������ �����⥫� */
	FIELD tag77 AS CHAR INIT "" /**	����ঠ��� ������� */
.

define variable i AS INTEGER NO-UNDO INIT 0.
define variable j AS INTEGER NO-UNDO INIT 0.
define variable tmpStr AS CHAR NO-UNDO.
define variable tmpStr2 AS CHAR NO-UNDO.
define variable Ref AS CHAR NO-UNDO.
define variable SKIP1 AS CHAR NO-UNDO INIT "".
DEF FRAME fSet 
	 "��࠭��, ��宦� ���� ᫨誮� �������" SKIP tmpStr SKIP1 
	 WITH CENTERED NO-LABELS TITLE "������ �����".

/** ��ࠡ�⪠ ��࠭��� ���㬥�⮢ */
FOR EACH tmprecid NO-LOCK,
	FIRST op WHERE RECID(op) = tmprecid.id NO-LOCK,
	FIRST op-entry WHERE op-entry.op = op.op NO-LOCK:

	i = i + 1.
	/** ������� ��ꥪ�� ���� � ᮡ�ࠥ� ����� */
	CREATE ttReport.
		ttReport.id = i.

	 /**********************************************************
		 *
		 * ����� � ������� ���� �����.
		 * � ���� ������ ����� ��������� ��������
		 * ������.
		 *
		 **********************************************************/
		ttReport.bank = STRING(op-entry.acct-cr).
		IF ttReport.bank = "30114840800000000009" or ttReport.bank = "30114978400000000009" or ttReport.bank = "30114826400000000009"
			THEN ttReport.bank = "OWHBDEFFXXX".
		IF ttReport.bank = "30110840800000000016" or ttReport.bank = "30110978000000000021" 
			THEN ttReport.bank = "SABRRUMMXXX".
		IF ttReport.bank = "30110840000000000023" or ttReport.bank = "30110978600000000023" 
			THEN ttReport.bank = "IMBKRUMMXXX".
		IF ttReport.bank = "30114840800000000012" or ttReport.bank = "30114978400000000012" 
			THEN ttReport.bank = "RZBAATWWXXX".
	
		ttReport.doc-num = INT(op.doc-num).

		tmpStr = STRING(op.details).
		j = INDEX(tmpStr,"REF"). 
		IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 3, LENGTH(tmpStr) - j - 2).
		j = INDEX(tmpStr," "). 
		IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
		j = INDEX(tmpStr," "). 
		IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, 1, j - 1).
		ttReport.tag20 = tmpStr.
	
/*����: �᫨ ��� ���४��, 㪠�뢠��� �� �, �� ���㬥�� ���� �� ��, ���塞 ����� � ���ண�� ���४��
� ����᪠�� i-�� ���������� ���४�� � ���-���㠫쭮� ०��� */

	if GetXAttrValueEx("msg-impexp", "op," + STRING(op.op) + ",i-clb103,0","pirSwift32", "?") = "?" then do:
		message "��筮� ���㬥��\n���室�� � ���������� ��������� ४����⮢." view-as alert-box.
		rClass = "op".
		rSurrogate = string(op.op).
		{pir-swiftfill.i}
	end.
	else do: 
		rClass = "msg-impexp".
		rSurrogate = "op," + string(op.op) + ",i-clb103,0".
	end.

	ttReport.tag32 = GetXAttrValueEx(rClass, rSurrogate,"pirSwift32", "?").
	ttReport.tag33 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift33", "?").
	ttReport.tag50Cor = GetXAttrValueEx(rClass, rSurrogate, "pirSwift50Cor", "?").
	IF ttReport.tag50Cor = "" OR ttReport.tag50Cor = "?" then do:
		message "����室��� �஢���� ����� �� ���� 50 (��ॢ�����⥫�)" view-as alert-box.
		return.
	end.

	ttReport.tag52 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift52", "?").
	ttReport.tag56 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift56", "?").
	ttReport.tag57 = GetXAttrValueEx(rClass, rSurrogate, "pirSwift57", "?").
	ttReport.tag59Cor = TranslitIt(CAPS(GetXAttrValueEx(rClass, rSurrogate,"pirSwift59Cor", "?"))).
	IF ttReport.tag59Cor = "" OR ttReport.tag59Cor = "?" THEN DO:
		message "����室��� �஢���� ����� �� ���� 59 (�����樠�)" view-as alert-box.
		return.
	end.

	ttReport.tag70Cor = GetXAttrValueEx(rClass, rSurrogate,"pirSwift70Cor", "?").
	IF ttReport.tag70Cor = "" OR ttReport.tag70Cor = "?" THEN DO:
			message "����室��� �஢���� ����� �� ���� 70 (�����祭�� ���⥦�)" view-as alert-box.
			return.
	end.

	ttReport.tag71 = GetXAttrValueEx(rClass, rSurrogate,"pirSwift71", "?").


/** ᡮ� ������ �����祭 */
end.

/** ��ନ஢���� 䠩��� */
pause 0.

/* saveDir = "/home/PIRBANK/agoncharov/3785".*/
saveDir = "./users/" + LC(USERID).

SKIP1 = "".
SKIP1 = CHR(13) + CHR(10).

/** �뢮��� ����� */
FOR EACH ttReport BREAK BY ttReport.ourClientID:
	fileName = "sw" + SUBSTRING(ttReport.tag32, INDEX(ttReport.tag32,"=") + 1, 6).
	fileName = fileName + "-" + STRING(ttReport.doc-num) + ".103".
	fileName = saveDir + "/" + fileName.

	OUTPUT TO VALUE(fileName).
		
	/** ���㦠�� ��������� */
	PUT UNFORMATTED "~{1:F01BPIRRUMMAXXX0000000000~}~{2:I103" ttReport.bank.
	PUT UNFORMATTED "XN~}~{4:" SKIP1.

	/** ���㦠�� TAG20 */
	tmpStr = CAPS(ttReport.tag20).
	Ref = "".
	Ref = SUBSTRING(tmpStr, 1, 2).
	Ref = SUBSTRING(tmpStr, 3, 2) + Ref.
	Ref = SUBSTRING(tmpStr, 5, 2) + Ref.
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":20:" tmpStr SKIP1.
	/** IF tmpStr <> "?" THEN PUT UNFORMATTED ":20:" Ref SKIP1. */

	/** ���㦠�� TAG23 CRED (�⠭���⭮) */
	tmpStr = CAPS(ttReport.tag23).
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":23B:CRED" SKIP1.

	/** ���㦠�� TAG32 */
	tmpStr = CAPS(ttReport.tag32).
	j = INDEX(tmpStr,"=").
	tmpStr = substring(tmpstr, j + 1, 6) + SUBSTRING(tmpStr, j + 7, LENGTH(tmpStr) - j - 6).


	SUBSTRING(tmpStr, INDEX(tmpStr,"."), 1, "CHARACTER") = ",".
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":32A:" tmpStr SKIP1.

	/** ���㦠�� TAG33, �᫨ 71� BEN */
	tmpStr = CAPS(ttReport.tag33).
	j = INDEX(tmpStr,"=").
	tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	tmpStr2 = CAPS(ttReport.tag71).
	tmpStr2 = SUBSTRING(tmpStr2, INDEX(tmpStr2,"=") + 1, 3).
	IF tmpStr <> "?" AND tmpStr2 = "BEN" THEN PUT UNFORMATTED ":33B:" tmpStr SKIP1.

	/** ���㦠�� TAG50 */
	tmpStr = CAPS(ttReport.tag50Cor).
	REPEAT WHILE INDEX(tmpStr, "?") > 0:
			SUBSTRING(tmpStr, INDEX(tmpStr,"?"), 1, "CHARACTER") = "".
	END.
	REPEAT WHILE INDEX(tmpStr, CHR(10)) <> 0:
			j = INDEX(tmpStr, CHR(10)).
			PUT UNFORMATTED SUBSTRING(tmpStr, 1, j - 1) SKIP1.
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	END.
	IF LENGTH(tmpStr) > 0 THEN PUT UNFORMATTED tmpStr SKIP1.

	/** ���㦠�� TAG56 */
	tmpStr = CAPS(ttReport.tag56).
	IF tmpStr <> "?" AND tmpStr <> "" THEN DO:
			j = INDEX(tmpStr,"=").
			IF tmpStr <> "?" THEN PUT UNFORMATTED ":56A:" SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1) SKIP1.
			/** ���㦠�� TAG57 */
			tmpStr = CAPS(ttReport.tag57).
			j = INDEX(tmpStr,"=").
			tmpStr2 = SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1).
			j = INDEX(tmpStr,"~~").
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			j = INDEX(tmpStr,"~~").
			IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			j = INDEX(tmpStr,"~~").
			IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			j = INDEX(tmpStr,"~~").
			IF j > 0 THEN tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
			/* IF tmpStr <> "?" THEN PUT UNFORMATTED ":57A:/" SUBSTRING(tmpStr, 1, INDEX(tmpStr,"~~") - 1) SKIP1. */
			IF tmpStr <> "?" THEN DO:
					IF tmpStr <> "-" THEN DO:
							PUT UNFORMATTED ":57A:/" tmpStr SKIP1.
							IF tmpStr2 <> "?" THEN PUT UNFORMATTED tmpStr2 SKIP1.
					END.
					ELSE IF tmpStr2 <> "?" THEN PUT UNFORMATTED ":57A:" tmpStr2 SKIP1.
			END.
	END.
	ELSE DO:
			/** ���㦠�� TAG57 */
			tmpStr = CAPS(ttReport.tag57).
			j = INDEX(tmpStr,"=").
			IF tmpStr <> "?" THEN PUT UNFORMATTED ":57A:" SUBSTRING(tmpStr, j + 1, INDEX(tmpStr,"~~") - j - 1) SKIP1.
	END.


	/** ���㦠�� TAG59 */
	tmpStr = CAPS(ttReport.tag59Cor).
	REPEAT WHILE INDEX(tmpStr, "?") > 0:
			SUBSTRING(tmpStr, INDEX(tmpStr,"?"), 1, "CHARACTER") = "".
	END.
	REPEAT WHILE INDEX(tmpStr, CHR(10)) <> 0:
			j = INDEX(tmpStr, CHR(10)).
			PUT UNFORMATTED SUBSTRING(tmpStr, 1, j - 1) SKIP1.
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	END.
	IF LENGTH(tmpStr) > 0 THEN PUT UNFORMATTED tmpStr SKIP1.

	/** ���㦠�� TAG70 */
	tmpStr = CAPS(ttReport.tag70Cor).
	REPEAT WHILE INDEX(tmpStr, "?") > 0:
			SUBSTRING(tmpStr, INDEX(tmpStr,"?"), 1, "CHARACTER") = "".
	END.
	REPEAT WHILE INDEX(tmpStr, CHR(10)) <> 0:
			j = INDEX(tmpStr, CHR(10)).
			PUT UNFORMATTED SUBSTRING(tmpStr, 1, j - 1) SKIP1.
			tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	END.
	IF LENGTH(tmpStr) > 0 THEN PUT UNFORMATTED tmpStr SKIP1.
	
	/** ���㦠�� TAG71A */
	tmpStr = CAPS(ttReport.tag71).
	j = INDEX(tmpStr,"=").
	tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	IF tmpStr <> "?" THEN PUT UNFORMATTED ":71A:" SUBSTRING(tmpStr, 1, INDEX(tmpStr,"~~") - 1) SKIP1.

	/** ���㦠�� TAG71F */
	j = INDEX(tmpStr,"=").
	tmpStr = SUBSTRING(tmpStr, j + 1, LENGTH(tmpStr) - j).
	tmpStr2 = CAPS(ttReport.tag71).
	tmpStr2 = SUBSTRING(tmpStr2, INDEX(tmpStr2,"=") + 1, 3).
	IF tmpStr <> "?" AND tmpStr2 = "BEN" THEN PUT UNFORMATTED ":71F:" tmpStr SKIP1.
	PUT UNFORMATTED "-~}" SKIP1.

	OUTPUT CLOSE.

	MESSAGE "����� �ᯮ��஢��� � 䠩� " + fileName VIEW-AS ALERT-BOX.

END.
				