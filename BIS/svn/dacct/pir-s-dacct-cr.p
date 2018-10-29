/* 
Процедура массово открывает парные счета 
Если процедура не может открыть, то просто пропускает его без ошибок. НО в итоговом отчете об этом написано
Запускается с параметром, в котором указан список счетов 2го порядка
Sitov S.A. 10.04.2013
#1716
*/



DEFINE INPUT PARAM UserListAcct AS CHAR NO-UNDO.
UserListAcct = if UserListAcct = "" then "*" else UserListAcct .


DEF VAR  ListAcct   AS CHAR INIT "" NO-UNDO .
DEF VAR  i AS INT64 INIT 0 NO-UNDO.

DEF NEW SHARED VAR  vFindAcct As CHAR NO-UNDO.

DEF BUFFER bacct FOR acct .
DEF BUFFER qacct FOR acct.


   /* Выходной файл */
DEF VAR  outLogFile	AS CHAR NO-UNDO.
outLogFile = "/home2/bis/quit41d/imp-exp/users/" + LC(USERID("bisquit")) + "/dacct-cr" + STRING(TIME) + ".log" .
DEFINE STREAM sLog.



FOR EACH code
 WHERE code.class  = "Dual-bal-acct"
 AND   code.parent = "Dual-bal-acct"
NO-LOCK:
  ListAcct = ListAcct + code.code + ","  + code.val + ","  .
end.
ListAcct = TRIM(ListAcct,",") . 


{setdest.i	&stream = "STREAM sLog"
		&filename = outLogFile
}

FOR EACH acct
 WHERE acct.acct-cat = 'b'
 AND  LOOKUP(STRING(acct.bal-acct),ListAcct) > 0 
 AND  LOOKUP(STRING(acct.bal-acct),UserListAcct) > 0 
 AND  (acct.contr-acct = ? OR acct.contr-acct = "" )
 AND  acct.close-date  = ? 
/* AND  acct.acct = "30232810200001500007" */
NO-LOCK:

  i = i + 1 .

  FIND FIRST qacct
    WHERE  qacct.acct = acct.contr-acct
    AND    ( (qacct.contr-acct <> acct.acct) OR (qacct.close-date <> acct.close-date) OR (qacct.contr-acct = ?) )
  NO-LOCK NO-ERROR.

  IF AVAIL(qacct) THEN
  DO:
	MESSAGE "ВНИМАНИЕ!!! НАЙДЕН СУЩЕСТВУЮЩИЙ ПАРНЫЙ СЧЕТ " qacct.acct " ДЛЯ СЧЕТА" acct.acct VIEW-AS ALERT-BOX.
	RETURN .
  END.

  IF  i = 1  THEN
  DO:
	PUT STREAM sLog UNFORM "| " "СЧЕТ" FORMAT("X(20)") " | " "ОТКРЫТ ПАРНЫЙ СЧЕТ" FORMAT("X(20)") " | " "ОШИБКА! НАЙДЕН СЧЕТ" FORMAT("X(20)") " |" SKIP .
	PUT STREAM sLog UNFORM FILL("-",68) SKIP.
  END.

	/* процедура открытия парного счета */

  RUN pir-m-dacct-cr.p (STRING(acct.acct + "," + acct.currency)).

  FIND FIRST bacct
     WHERE bacct.acct-cat = 'b'
     AND   bacct.contr-acct = acct.acct 
  NO-LOCK NO-ERROR .

  IF AVAIL bacct THEN
	PUT STREAM sLog UNFORM "| " acct.acct FORMAT("X(20)") " | " bacct.acct FORMAT("X(20)") " | " FILL(" ",20) " |" SKIP .
  ELSE
	PUT STREAM sLog UNFORM "| " acct.acct FORMAT("X(20)") " | " FILL(" ",20) " | " vFindAcct FORMAT("X(20)") " |" SKIP .

/*
	PUT STREAM sLog UNFORM "| " acct.acct " | " acct.contr-acct " |" SKIP .
*/
END.


PUT STREAM sLog UNFORM FILL("-", 68) SKIP(2) .
PUT STREAM sLog UNFORM "ВСЕГО СЧЕТОВ: " i  SKIP(2) .
PUT STREAM sLog UNFORM "Выполнил: " USERID("bisquit") "   "  STRING(TODAY,"99/99/9999") "  " STRING(TIME,"hh:mm:ss")  SKIP(3) .
/* PUT STREAM sLog UNFORM "Парные=" ListAcct  SKIP .*/


{preview.i 	&stream = "STREAM sLog"
		&filename = outLogFile
}
