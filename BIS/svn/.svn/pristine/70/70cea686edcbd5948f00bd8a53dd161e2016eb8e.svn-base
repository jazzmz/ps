{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-delop.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Процедура метода delete класса op.
              : Выполняет проверку изменяемой проводки на возникновение красного сальдо.
Причина		    : усиление борьбы против красного сальдо
Параметры     : iRecOp - ссылка на удаляемую запись OP
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
{intrface.get acct}

DEFINE INPUT PARAMETER iRecOp AS RECID.

pick-value = "no". 

FIND FIRST op WHERE RECID(op) = iRecOp NO-LOCK NO-ERROR.
IF NOT AVAIL op THEN DO:
  BELL.
  MESSAGE COLOR MESSAGE "НЕ НАЙДЕНА ЗАПИСЬ <op>"
  VIEW-AS ALERT-BOX ERROR
  TITLE "ОШИБКА".
  RETURN.
END.

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
