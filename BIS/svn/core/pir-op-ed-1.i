 /***********************************
  * 
  * Запрещено исправлять линкованные документы.
  *
  ************************************
  *
  * Автор: Маслов Д. А.
  * Заявка: #726
  * Дата создания: 28.06.11
  *
  ************************************/

 /***********************************
  * 
  * Не очень запрещено исправлять линкованные документы.
  * Если есть доп.рек, то можно и поменять.
  *
  ************************************
  *
  * Автор: Гончаров А.Е.
  * Заявка: #3273
  * Дата создания: 02.07.13
  *
  *
  ************************************/
{globals.i}
{intrface.get xclass}

DEF VAR oUser     AS TUser     NO-UNDO.
DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR roleList  AS CHARACTER NO-UNDO.

oSysClass = new TSysClass().

oUser = new TUser().
  roleList = oUser:getRoleList("05*").
DELETE OBJECT oUser.

if not logical(GetXAttrValueEx("op",string(op.op),"PirLinkCanEdit","no")) then do:
	IF CAN-DO(oSysClass:getCodeValue("PirLnkTrList",roleList,"!*"),op.op-kind) THEN DO:
		MESSAGE COLOR WHITE/RED "НЕЛЬЗЯ ПРАВИТЬ СВЯЗАННЫЕ ДОКУМЕНТЫ!" SKIP
			VIEW-AS ALERT-BOX TITLE "[ОШИБКА #726]".
		RETURN NO-APPLY.
	END.
end.

DELETE OBJECT oSysClass.