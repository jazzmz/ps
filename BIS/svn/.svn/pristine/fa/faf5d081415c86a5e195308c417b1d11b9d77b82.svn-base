{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-deloe.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Процедура метода delete класса op-entry.
              : Выполняет проверку изменяемой проводки на возникновение красного сальдо.
Причина		    : усиление борьбы против красного сальдо
Параметры     : iRecOp - ссылка на удаляемую запись op-entry
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.2  2007/06/21 12:59:49  lavrinenko
Изменения     : Доработана обработка удаления докумен
Изменения     :
Изменения     : Revision 1.1  2007/06/20 11:49:24  lavrinenko
Изменения     : Добавлена обработка удаления документа
Изменения     :
----------------------------------------------------- */
{globals.i}
{intrface.get xclass}
DEF INPUT PARAMETER iRecOp AS RECID.

pick-value = "no". 
 
FIND FIRST op-entry WHERE RECID(op-entry) = iRecOp NO-LOCK NO-ERROR.
IF NOT AVAIL op-entry THEN DO:
  BELL.
  MESSAGE COLOR MESSAGE "НЕ НАЙДЕНА ЗАПИСЬ <op-entry>"
  VIEW-AS ALERT-BOX ERROR
  TITLE "ОШИБКА".
  RETURN.
END.

FIND FIRST op OF op-entry NO-LOCK NO-ERROR.

IF op.acct-cat EQ 'b' THEN DO:
	 RUN RunClassMethod IN h_xclass (op.class-code,"chkupd","","",
		                              ?,string(recid(op)) + ",delete").
	 IF RETURN-VALUE EQ 'no-method' THEN DO: 
	 		MESSAGE COLOR MESSAGE "НЕ НАЙДЕН МЕТОД ОБРАБОТКИ ДЛЯ КЛАССА " op.class-code
  		VIEW-AS ALERT-BOX ERROR
  		TITLE "ОШИБКА".
  		RETURN. 
   END. /* IF RETURN-VALUE */
END. ELSE pick-value = "yes".  /* IF op.acct-cat EQ 'b'*/

{intrface.del}	
RETURN.
