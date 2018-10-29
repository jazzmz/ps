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

oTable:addCell("№ ссудного счета,наименование клиента, номер договора").
oTable:addCell("Остаток по ссудному счету").
oTable:addCell("Базовый курс (руб/$,руб/евро)").
oTable:addCell("Сумма долга в валюте").
oTable:addCell("ВАЛ").
oTable:addCell("Текущий курс (руб/$;руб/евро)").
oTable:addCell("Сумма рассчетной задолженности (в рублях)").
oTable:addCell("Увеличение задолженности").
oTable:addCell("Уменьшение задолженности").
oTable:addCell("ДЕБЕТ").
oTable:addCell("КРЕДИТ").
                                                         
oTable:setAlign(2,1,"CENTER").
oTable:setAlign(1,1,"CENTER").
oTable:setAlign(10,1,"CENTER").
oTable:setAlign(11,1,"CENTER").


 oTable:LOAD().
 oTpl:addAnchorValue("Table1",oTable).

FIND FIRST _user WHERE _user._userid EQ userid NO-LOCK NO-ERROR.
IF AVAIL _user
THEN DO:
   userPost = GetXAttrValueEx("_user", _user._userid, "Должность", "").
   PUT UNFORMATTED userPost FORMAT "x(100)" _user._user-name SKIP.
END.


 oTpl:addAnchorValue("userPost",GetXAttrValueEx("_user", _user._userid, "Должность", "")).
 oTpl:addAnchorValue("ДАТА",currDate).
 oTpl:addAnchorValue("userName",_user._user-name).

 {setdest.i}
   oTpl:show().
 {preview.i}

DELETE OBJECT oTable.
DELETE OBJECT oTpl.

OS-DELETE VALUE(fileWdata).	/* Чистим за собой */
