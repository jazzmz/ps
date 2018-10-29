/*{pirsavelog.p}*/ /*отключил по заявке 1082 */

/* ---------------------------------------------------------------------
File       : $RCSfile: pir-chkoe.p,v $ $Revision: 1.3 $ $Date: 2007-10-18 07:42:21 $
Copyright  : ООО КБ "Пpоминвестрасчет"
Function   : Процедура метода chkupd класса op-entry.
           : Выполняет проверку изменяемой проводки на возникновение красного сальдо.	
Created    : 29.05.2007 lavrinenko
Modified   : $Log: not supported by cvs2svn $
Modified   : Revision 1.2  2007/06/13 13:29:29  lavrinenko
Modified   :  Доработка по замечаниям во время экуатации
Modified   :
Modified   : Revision 1.1  2007/06/07 09:33:21  lavrinenko
Modified   : ╨┐╤А╨╛╤Ж╨╡╨┤╤Г╤А╨░ ╨┐╤А╨╛╨▓╨╡╤А╨║╨╕ ╨╜╨░ ╨║╤А╨░╤Б╨╜╨╛╨╡ ╤Б╨░╨╗╤М╨┤╨╛
Modified   :
---------------------------------------------------------------------- */
{globals.i}
{intrface.get xclass}
DEF INPUT PARAMETER iRecOp AS RECID.
DEF INPUT PARAMETER iParam AS CHAR.

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
		                              ?,string(recid(op)) + ",op-entry").
	 IF RETURN-VALUE EQ 'no-method' THEN DO: /*
	 		MESSAGE COLOR MESSAGE "НЕ НАЙДЕН МЕТОД ОБРАБОТКИ"
  		VIEW-AS ALERT-BOX ERROR
  		TITLE "ОШИБКА".
  		RETURN. */ pick-value = "yes".
   END. /* IF RETURN-VALUE */
END. ELSE pick-value = "yes".  /* IF op.acct-cat EQ 'b'*/

{intrface.del}	
RETURN.
