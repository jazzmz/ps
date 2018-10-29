/*****************
 * Инклюдник для выгрузки в архив.
 *****************/


&IF DEFINED(arch2)>0 &THEN

DEF VAR oSysClass1 AS TSysClass NO-UNDO.

oSysClass1 = new TSysClass().

/*** ПРОВЕРЯЕМ ПРАВИЛЬНОСТЬ ИСПОЛНИТЕЛЯ И КОНТРОЛЛЕРА ***/
{pir-chk-sin-cnt.i &*}

/*** ПЕРЕНАПРАВЛЯЕМ ВЫВОД В АРХИВ ***/
IF curr-user-inspector EQ ? OR curr-user-inspector EQ "" THEN DO:
 curr-user-inspector = FGetSetting("PirEArch","RepNullInsp",?).
END.
cPath = cRootPath + oSysClass1:DATETIME2STR(gend-date,"%Y") + "/" + oSysClass1:DATETIME2STR(gend-date,"%m") + "/" + oSysClass1:DATETIME2STR(gend-date,"%d") + "/md/" + curr-user-inspector + "/".

/*
FILE-INFO:FILE-NAME = cPath.

IF CAN-DO("*D*,*W*",FILE-INFO:FILE-TYPE) THEN
  DO:
	cPath = cPath + curr-user-id + "(" + STRING(iCurrOut) + "){&postfix}".
  END.
  ELSE
    DO:
	MESSAGE "Доступ к директории выгрузки запрещен\n" + cPath VIEW-AS ALERT-BOX.
	RETURN "ERROR".
    END.
&IF DEFINED(wsd)=0 &THEN
{setdest.i &filename = cPath}
&ENDIF
*/

/** Оставил для совместимости **/
&IF DEFINED(wsd)=0 &THEN
{setdest.i}
&ENDIF






DELETE OBJECT oSysClass1.

&ENDIF
