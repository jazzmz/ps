{pirsavelog.p}
/*
		����� �ਤ��᪮�� ���.
		���� �.�., 30.01.2006 9:48
*/
/* �������� ��।������ ��⥬� */
{globals.i}
/* ������� �����㬥���� ��७�� ��ப */
{wordwrap.def}
{tmprecid.def}        /** �ᯮ��㥬 ���ଠ�� �� ��㧥� */

/* �⢥ত��騩 ����⨥ ��� */
DEF VAR pirbosD6 AS CHAR NO-UNDO.
pirbosD6 = FGetSetting("PIRBoss","PIRBosD6","").
DEF VAR pirbosU6 AS CHAR NO-UNDO.
pirbosU6 = FGetSetting("PIRBoss","PIRBosU6","").

/* ��� ���������� ������ */
DEF VAR xfile-date AS DATE LABEL "��� ����������" INITIAL TODAY NO-UNDO.
/* ��� ���㤭��� ����襣� ��� (����) */
DEF VAR auserFIO AS CHAR NO-UNDO.
/* ��������� ���㤭��� ����襣� ��� (����) */
DEF VAR auserPost AS CHAR NO-UNDO.
/* ��� ���짮��⥫� ��⥬� */
DEF VAR auserID AS CHAR NO-UNDO.
/* ����� */
DEF VAR i AS INTEGER NO-UNDO.
/* ࠡ��� ��蠤�� */
DEF VAR tmp AS CHAR NO-UNDO.
DEF VAR tmp_d AS DATE NO-UNDO.
/* ����� */
DEF VAR months AS CHAR
	INITIAL "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������" NO-UNDO.

/* ��� ��ࢮ� �����, �뤥������ � ��㧥�, ������... */
FOR FIRST tmprecid NO-LOCK,
		FIRST cust-corp WHERE RECID(cust-corp) EQ tmprecid.id NO-LOCK
:
	PAUSE 0.
	DISPLAY xfile-date SKIP
		cust-corp.name-corp FORMAT "x(30)"
		WITH FRAME myFrame CENTERED OVERLAY SIDE-LABELS.
	SET xfile-date WITH FRAME myFrame.
	HIDE FRAME myFrame.
	/* ������� �⠭���⭮�� �뢮�� � 䠩� */
	{setdest.i}
	PUT UNFORMATTED SPACE(25) "����� ������ - �ਤ��᪮�� ���" SKIP
								SPACE(23) "(�� ��饣��� �।�⭮� �࣠����樥�)." SKIP (2).
	PUT UNFORMATTED "������������ ������ (������) " SKIP 
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"FullName","") SKIP(1).
	PUT UNFORMATTED "                     (᮪�饭���)" SKIP 
		cust-corp.cust-stat ' ' cust-corp.name-corp SKIP(1).
	PUT UNFORMATTED "                     (�� �����࠭��� �몥)" SKIP
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"engl-name","") SKIP(1).
	PUT UNFORMATTED '�������樮��� ����� ' SKIP 
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"����","") SKIP(1).
	
	tmp_d = DATE(GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"��⠎���","")).
	PUT UNFORMATTED '��� ���.ॣ����樨 "' STRING(DAY(tmp_d)) '" ' 
		 ENTRY(MONTH(tmp_d),months) ' ' STRING(YEAR(tmp_d)) '�.' SKIP(1).
	
	PUT UNFORMATTED '���� ���.ॣ����樨 ' 
		GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"RegPlace","") SKIP(1). 
	
	PUT UNFORMATTED '����������騩 �࣠� '
		/* GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"�࣑����।","")*/ SKIP(1).
	
	PUT UNFORMATTED '���� ���� ��宦����� ' SKIP
	 cust-corp.addr-of-low[1] SKIP(1).
	PUT UNFORMATTED '���⮢� ���� ' SKIP
	 GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"����","") SKIP(1).
	PUT UNFORMATTED '����� ���⠪��� ⥫�䮭�� � 䠪ᮢ ' SKIP
	 cust-corp.fax SKIP(1).
	PUT UNFORMATTED '��� ���������⥫�騪� (��� ��� १����� � ��� ��� ��� ��� ��१����� (�᫨' SKIP
	 '�������) ' cust-corp.inn SKIP(1).
	PUT UNFORMATTED '�������� � ��業��� �� �ࠢ� �����⢫���� ���⥫쭮�� (� ��砥 �� ������)' SKIP
	 GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"��業���","") SKIP(1).
	PUT UNFORMATTED '�࣠�� �ਤ��᪮�� ��� (������� � ���ᮭ���� ��⠢ �࣠��� �ࠢ�����' SKIP
		'�ਤ��᪮�� ���) ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"������","") SKIP(1).
	PUT UNFORMATTED '����稭� ��ॣ����஢������ � ����祭���� ��⠢���� ����⠫� ��� ����稭�' SKIP
		'��⠢���� 䮭��, �����⢠) ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"��⠢���","") SKIP(1).
	PUT UNFORMATTED '��������  �  ������⢨�  ���  ������⢨�  ��  ᢮��� ���⮭�宦����� �ਤ��᪮��' SKIP
	                '���, ��� ����ﭭ� �������饣� �࣠�� �ࠢ�����, ����� �࣠�� ��� ���, �����' SKIP
	                '����� �ࠢ� ����⢮���� �� ����� �ਤ��᪮�� ��� ��� ����७����' SKIP(1)
	                '                      ������������ / �����������' SKIP
	                '                         (���㦭�� ���ભ���)' SKIP(1).
 	PUT UNFORMATTED '�᭮��� ���� ���⥫쭮�� (�����)' SKIP
 	GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"�����","") SKIP(1).
	
	/* ��� */
	i = 1.
	FOR EACH acct WHERE
		acct.cust-cat = "�"
		AND
		acct.cust-id = cust-corp.cust-id
		NO-LOCK
		BY open-date
	:
		IF i = 1 THEN
			DO:
				PUT UNFORMATTED "��� ������ ���.��.".
				auserID = acct.user-id.
			END.
		ELSE
			PUT UNFORMATTED "��� ������ ��㣨� ��.".
		i = i + 1.
		PUT UNFORMATTED '"' STRING(DAY(acct.open-date)) '" ' 
			ENTRY(MONTH(acct.open-date),months) ' ' STRING(YEAR(acct.open-date)) '�. ' acct.acct SKIP.
	END.
	
	/* ��� ���������� */
	PUT UNFORMATTED ' ' SKIP '��� ���������� ������ ' STRING(xfile-date,"99/99/9999") SKIP(1).
	
	/* ����㤭��� */
	FIND FIRST _user WHERE _user._userid EQ auserID NO-LOCK NO-ERROR.
	IF AVAIL _user THEN
		auserFIO = _user._user-name.
	auserPost = GetXAttrValueEx("_user",auserID,"���������","").
	PUT UNFORMATTED 
	'�������, ���, ����⢮, ��������� ���㤭���,' SKIP
	'����襣� ��� ' auserFIO ', ' auserPost SKIP(1).
	PUT UNFORMATTED 
	'�������, ���, ����⢮, ��������� ���㤭���,' SKIP
	'�⢥न�襣� ����⨥ ��� ' 
		ENTRY(2,PIRBosD6) ', ' ENTRY(1,PIRBosD6) SKIP(1).
	PUT UNFORMATTED '�������, ���, ����⢮, ��������� ���,' SKIP
	 '��������襣� ������ � ���஭��� ���� '
		auserFIO ', ' auserPost SKIP(1).
	PUT UNFORMATTED '�������, ���, ����⢮, ���������, � ⠪�� ������� ���, 㯮�����祭����' SKIP
	 '���㤭��� ����� '
		ENTRY(2,PIRBosU6) ', ' ENTRY(1,PIRBosU6) SKIP(1).
	PUT UNFORMATTED '�஢��� �᪠ ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"��᪎��","") SKIP(1).
	PUT UNFORMATTED '�業�� �᪠ ' GetXAttrValueEx("cust-corp",STRING(cust-corp.cust-id),"�業����᪠","") SKIP.
	{preview.i}
END.

