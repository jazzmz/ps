DEF INPUT PARAMETER fileWdata AS CHARACTER NO-UNDO.
DEF INPUT PARAMETER currDate  AS CHARACTER NO-UNDO.

{globals.i}

DEF VAR oTable   AS TTableCSV NO-UNDO.
DEF VAR oTpl     AS TTpl      NO-UNDO.
DEF VAR userPost AS CHARACTER NO-UNDO.


oTpl = new TTpl("pir-lvk0001rep.tpl").

oTable = new TTableCSV(11).
oTable:decFormat = "<<<,<<<,<<<,<<9.99".
oTable:filename = fileWdata.

oTable:addRow().

oTable:addCell("� ��㤭��� ���,������������ ������, ����� �������").
oTable:addCell("���⮪ �� ��㤭��� ����").
oTable:addCell("������ ���� (��/$,��/���)").
oTable:addCell("�㬬� ����� � �����").
oTable:addCell("���").
oTable:addCell("����騩 ���� (��/$;��/���)").
oTable:addCell("�㬬� ����⭮� ������������ (� �㡫��)").
oTable:addCell("�����祭�� ������������").
oTable:addCell("�����襭�� ������������").
oTable:addCell("�����").
oTable:addCell("������").
                                                         
oTable:setAlign(2,1,"CENTER").
oTable:setAlign(1,1,"CENTER").
oTable:setAlign(10,1,"CENTER").
oTable:setAlign(11,1,"CENTER").


 oTable:LOAD().
 oTpl:addAnchorValue("Table1",oTable).

FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
IF AVAIL _user
THEN DO:
   userPost = GetXAttrValueEx("_user", _user._userid, "���������", "").
   PUT UNFORMATTED userPost FORMAT "x(100)" _user._user-name SKIP.
END.


 oTpl:addAnchorValue("userPost",GetXAttrValueEx("_user", _user._userid, "���������", "")).
 oTpl:addAnchorValue("����",currDate).
 oTpl:addAnchorValue("userName",_user._user-name).

 {setdest.i}
   oTpl:show().
 {preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.

OS-DELETE VALUE(fileWdata).	/* ���⨬ �� ᮡ�� */
