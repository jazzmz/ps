DEF VAR iS2ARes  AS INT64   NO-UNDO.
DEF VAR doUnload AS LOGICAL NO-UNDO INIT YES.

&IF DEFINED(arch2)<>0 &THEN

&IF DEFINED(nomess)=0 &THEN
  MESSAGE "Будем выгружать в электронный архив ?" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "Запрос на выгрузку" SET doUnload.
&ENDIF

/**************************************/
/***  Запрос #1079                 ***/
/*** IF NOT doUnload THEN RETURN.  ***/
IF doUnload NE YES THEN RETURN.


oSysClass1 = new TSysClass().


&IF DEFINED(f2a)<>0 &THEN

 RUN soap-file.p (STRING(iCurrOut),
		  oSysClass1:DATETIME2STR(gend-date,"%Y-%m-%d"),
		  STRING(iCurrOut),
		  curr-user-id,
		  curr-user-inspector,
		  {&f2a},
                  OUTPUT iS2ARes
                  ).
&ELSE

 RUN soap-file.p (STRING(iCurrOut),
		  oSysClass1:DATETIME2STR(gend-date,"%Y-%m-%d"),
		  STRING(iCurrOut),
		  curr-user-id,
		  curr-user-inspector,
		  "_spool.tmp",
		  OUTPUT iS2ARes
                  ).

&ENDIF

  IF NOT ERROR-STATUS:ERROR AND iS2Ares > 0 THEN DO:

&IF DEFINED(notmark)=0 &THEN
   &IF DEFINED(notmprecid)=0 &THEN
      FOR EACH tmprecid:
   &ENDIF

  	FIND FIRST op WHERE RECID(op) EQ tmprecid.id NO-LOCK.
         /*** Помечаем документы как отправленные ***/
	IF AVAILABLE(op) THEN DO:
  	 FIND FIRST op-entry OF op NO-LOCK.
	   UpdateSignsEx('opb',STRING(op.op),"PirA2346U",STRING(iCurrOut)).
	   UpdateSignsEx('op-entry',STRING(op.op) + "," + STRING(op-entry.op-entry),"PirDEVLink",STRING(iCurrOut)).
	END.
		

   &IF DEFINED(notmprecid)=0 &THEN
      END. /* FOR EACH */
   &ENDIF
&ENDIF

 END. /* IF NOT */
 ELSE DO:
   MESSAGE "Ошибка выгрузки" ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
 END.

DELETE OBJECT oSysClass1.

&ENDIF