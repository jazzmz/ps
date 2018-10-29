{pirsavelog.p}
/**             ��� �� "�P��������������", ��ࠢ����� ��⮬�⨧�樨 (�) 2007
                ��ନ஢���� ᯨ᪠ �����⮢(��) ��� �ᯮ�� .
                ���ᨬ�� �.�., 23.10.2007
   �� ���졥 ������ �.�. � ������ ������� ���� "����饭�� �� �������", "�����", "����".
   rusinov 06.05.08 15:48
	�� #3912 �� ⥯��� ����� p-誠.
*/

/** �������� ��।������ */
{globals.i}
/** �ᯮ��㥬 ���ଠ�� �� ��㧥� */
{tmprecid.def}
/** �㭪樨 ��� ࠡ��� � ����奬�� */
{intrface.get xclass}
/** �㭪樨 ��� ࠡ��� � ��ப��� */
{intrface.get strng}

{sh-defs.i}
{pir_exf_vrt.i}

/******************************************* ��।������ ��६����� � ��. */
DEF VAR FirstStr AS LOGICAL          NO-UNDO.
DEF VAR cXL      AS CHAR             NO-UNDO.
DEF VAR symb     AS CHAR INITIAL "-" NO-UNDO.
DEF VAR cNShort  AS CHAR             NO-UNDO. /* �������� ������ */
DEF VAR cId      AS CHAR             NO-UNDO.
DEF VAR cDate    AS CHAR             NO-UNDO.
DEF VAR cUser    AS CHAR             NO-UNDO. /* ����㤭��, �����訩 ���� */
DEF VAR cDolgn   AS CHAR             NO-UNDO. /* ��� ���������             */
DEF VAR cKlb     AS CHAR             NO-UNDO. /* ������-����               */
DEF VAR cAdr     AS CHAR             NO-UNDO. /* ���� ����              */

define temp-table tacct no-undo
	field	acct like acct.acct
	field	currency like acct.currency
	field	open-date like acct.open-date
	field	close-date like acct.close-date
	field	user-id like acct.user-id
	field	rdpo as date.


{pir_xf_def.i}  /* GetLastHistoryDate */

{pir_exf_exl.i}

{exp-path.i &exp-filename = "'ul.xls'"}

/******** ����㤭��, �����訩 ���� *********************/
FIND FIRST _user
   WHERE (_user._userid EQ USERID)
   NO-LOCK NO-ERROR.
cUser  = _user._user-name.
cDolgn = GetXAttrValue("_user", _user._userid, "���������").

/******************************************* ��������� */
put unformatted XLHead("ul", "CCDDCCCCCCCCDCCCCCCCCCCCCCCCCCCCDDDCDDCCCC", ",150").

cXL = XLCell("������������")
    + XLCell("���")
    + XLCell("��� ��������")
    + XLCell("����")
    + XLCell("������-����")
    + XLCell("C���饭�� �� �������")
    + XLCell("����饭��� ������������")
    + XLCell("������᪮� ������������")
    + XLCell("�࣠�.�ࠢ.�ଠ")
    + XLCell("����")
    + XLCell("�����")
    + XLCell("����")
    + XLCell("��� ॣ����樨")
    + XLCell("���� ॣ����樨")
    + XLCell("�ਤ��᪨� ����")
    + XLCell("�ਤ��᪨� ���� (����)")
    + XLCell("�����᪨� ����")
    + XLCell("�����᪨� ���� (����)")
    + XLCell("����䮭")
    + XLCell("����")
    + XLCell("���")
    + XLCell("���")
    + XLCell("������� (���)")
    + XLCell("�ᯮ����.�࣠�")
    + XLCell("��饥 ᮡ࠭��")
    + XLCell("����� ��४�஢")
    + XLCell("���⠢ ���")
    + XLCell("����⠫")
    + XLCell("������⢨� �࣠�� �ࠢ�����")
    + XLCell("����������(��)")
    + XLCell("pirOtherBanks")
    + XLCell("�業�� �᪠")
    + XLCell("��� ��ࢮ�� ���")
    + XLCell("��� ��砫�")
    + XLCell("��� ��᫥����� ���������")
    + XLCell("��業���")
    + XLCell("��� ������ ���")
    + XLCell("��� ������� ���")
    + XLCell("����⭨�, ����訩 ���")
    + XLCell("���������")
    + XLCell("����⭨�, ��⠢��訩 ����")
    + XLCell("���������")
    .

put unformatted XLRow(0) cXL XLRowEnd().

for each tmprecid no-lock,
	first cust-corp
	where (RECID(cust-corp) = tmprecid.id)
	no-lock:
		FirstStr = YES.
		/* #3912 */
/*		Prdpo = findrdpo(acct.acct,beg-date).*/
		/* #3912 */
		empty temp-table tacct.
		for each acct where (acct.cust-cat EQ "�") and (acct.cust-id  EQ cust-corp.cust-id) no-lock:
			create tacct.
			assign
				tacct.acct = acct.acct
				tacct.currency = acct.currency
				tacct.open-date = acct.open-date
				tacct.close-date = acct.close-date
				tacct.user-id = acct.user-id
				tacct.rdpo = findrdpo(acct.acct,beg-date).
		end.
                for each tacct by tacct.rdpo:
			if VrTest(tacct.acct, tacct.currency, tacct.open-date, tacct.close-date) then do:
				put screen col  1 row 24 "��ࠡ��뢠���� " + TRIM(tacct.acct) + STRING(" ","X(45)").
				put screen col 77 row 24 "(" + symb + ")" .
				CASE symb :
					WHEN "\\"  THEN symb = "|".
					WHEN "|"   THEN symb = "/".
					WHEN "/"   THEN symb = "-".
					WHEN "-"   THEN symb = "\\".
				END CASE.

			cNShort = cust-corp.name-short.
			cId     = STRING(cust-corp.cust-id).

			/** ������ ������-���� */
			FIND FIRST mail-user WHERE (LOOKUP(tacct.acct, mail-user.acct) > 0) NO-LOCK NO-ERROR.
			cKlb = (IF (AVAIL mail-user) THEN SUBSTRING(mail-user.file-exp ,28 ,5) ELSE "").



			put unformatted XLRow(0).

			IF FirstStr THEN DO:
				cDate = GetXAttrValue("cust-corp", cId, "FirstAccDate").
				cXL = XLCell(GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)) + " " + cust-corp.name-corp)
				+ XLCell(TRIM(tacct.acct))
				+ XLDateCell(lastmove)
				+ XLDateCell(tacct.rdpo)/*���� �⮫���!*/
				+ XLCell(cKlb)
				+ XLCell(GetXAttrValue("cust-corp", cId, "mess"))
				+ XLCell(cNShort)
				+ XLCell(GetXAttrValue("cust-corp", cId, "engl-name"))
				+ XLCell(GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)))
				+ XLCell(GetXAttrValue("cust-corp", cId, "����"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "�����"))
				+ XLCell(cust-corp.okpo)
				+ XLDateCell(DATE(GetXAttrValue("cust-corp", cId, "RegDate")))
				+ XLCell(GetXAttrValue("cust-corp", cId, "RegPlace"))
				.

				FIND FIRST cust-ident
					WHERE cust-ident.cust-cat       EQ "�"
					AND cust-ident.cust-id        EQ cust-corp.cust-id
					AND cust-ident.cust-code-type EQ "�����"
					AND cust-ident.class-code     EQ "p-cust-adr"
					AND cust-ident.close-date     EQ ?
					NO-ERROR.

				cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".
				cXL = cXL
				+ XLCell(cAdr)
				+ XLCell(DelDoubleChars((IF (cust-corp.addr-of-low[1] NE cust-corp.addr-of-low[2])
					THEN cust-corp.addr-of-low[1] + " " + addr-of-low[2]
					ELSE cust-corp.addr-of-low[1]),",")).

				FIND FIRST cust-ident
					WHERE cust-ident.cust-cat       EQ '�'
					AND cust-ident.cust-id        EQ cust-corp.cust-id
					AND cust-ident.cust-code-type EQ '�������'
					AND cust-ident.class-code     EQ "p-cust-adr"
					AND cust-ident.close-date     EQ ?
					NO-ERROR.

				cAdr = IF AVAIL(cust-ident) THEN cust-ident.issue ELSE "".
				cXL = cXL
				+ XLCell(cAdr)
				+ XLCell(GetXAttrValue("cust-corp", cId, "����"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "tel"))
				+ XLCell(cust-corp.fax)
				+ XLCell(cust-corp.inn)
				+ XLCell(GetXAttrValue("cust-corp", cId, "���"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "������"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "�ᯮ���࣠�"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "��鑮�࠭��"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "���⠢��"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "���⠢���"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "��⠢���"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "�����࣓�ࠢ"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "��᪎��"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "pirOtherBanks"))
				+ XLCell(GetXAttrValue("cust-corp", cId, "�業����᪠"))
				+ XLDateCell(DATE(cDate))
				+ XLDateCell(IF cDate = "" THEN cust-corp.date-in ELSE DATE(cDate))
				+ XLDateCell(GetLastHistoryDate("cust-corp", cId)).

				/** ������ ����� ��業���  */
				FIND FIRST cust-ident
					WHERE cust-ident.cust-cat   EQ "�"
					AND cust-ident.cust-id    EQ cust-corp.cust-id
					AND cust-ident.class-code EQ "cust-lic"
					NO-LOCK NO-ERROR.

				IF AVAIL cust-ident THEN
					cXL = cXL
					+ XLCell(GetCodeName("�����愥��", cust-ident.cust-code-type) + " " +
					cust-ident.cust-code + " " + STRING(cust-ident.open-date,"99.99.9999") + " " +
					cust-ident.issue + " " + STRING(cust-ident.close-date,"99.99.9999")).
				ELSE
					cXL = cXL
					+ XLEmptyCell().
				FirstStr = NO.
			END.
			ELSE
				cXL = XLCell(GetCodeName("����।�",GetCodeVal("����।�", cust-corp.cust-stat)) + " " + cust-corp.name-corp)
				+ XLCell(TRIM(tacct.acct))
				+ XLDateCell(lastmove)
				+ XLDateCell(tacct.rdpo)/*���� �⮫���!*/
				+ XLCell(cKlb)
				+ XLCell(GetXAttrValue("cust-corp", cId, "mess"))
				+ XLEmptyCells(30).
			cXL = cXL
			+ XLDateCell(tacct.open-date)
			+ XLDateCell(tacct.close-date).

			FIND FIRST _user
				WHERE (_user._userid EQ tacct.user-id)
				NO-LOCK NO-ERROR.
			IF AVAIL _user THEN 
				cXL = cXL
				+ XLCell(_user._user-name)
				+ XLCell(GetXAttrValue("_user", _user._userid, "���������"))
			.
			ELSE
				cXL = cXL
				+ XLEmptyCell()
				+ XLEmptyCell()
			.

			cXL = cXL
			+ XLCell(cUser)
			+ XLCell(cDolgn)
			.
			put unformatted cXL XLRowEnd() .
		END.
	END.
END.

put unformatted XLEnd().
put screen col 1 row 24 color normal STRING(" ","X(80)").

{intrface.del}
