{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir-redrep.p,v $ $Revision: 1.6 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ООО КБ "Пpоминвестрасчет"
Назначение    : Отчет по счетам, на которых возникает красное сальдо, с рассылкой отчет по почте.
Причина	      : Усиление борьбы против красного сальдо
Место запуска : Планировщик задач.
Параметры     : Входной параметер (iParam) понимает следующие значения (разделенные ;):
                - Имя временного файла
                - Имя почтового скрипта с параметрами (sendmail)
                - Список адресов для рассылки уведомлений разделенных запятыми
Автор         : $Author: anisimov $ 
Изменения     : $Log: not supported by cvs2svn $
Изменения     : Revision 1.5  2007/09/05 13:48:31  Lavrinenko
Изменения     : Дораотка отчета по счетам с красным сальдо - показывается наличие парного счета
Изменения     :
Изменения     : Revision 1.4  2007/07/05 11:46:44  lavrinenko
Изменения     : 1. Убраны  параметры запускавнешнего скрипта из кода. 2. Поправлен заголовок
Изменения     :
Изменения     : Revision 1.3  2007/06/25 07:44:44  lavrinenko
Изменения     : изменен порядок следования полей, изменено назначение ряда полей
Изменения     :
Изменения     : Revision 1.2  2007/06/22 12:03:17  lavrinenko
Изменения     : отчет по счетам с красным сальдо
Изменения     :
Изменения     : Revision 1.1  2007/06/22 12:02:24  lavrinenko
Изменения     : отчет по счетам с красным сальдо
Изменения     :
----------------------------------------------------- */

{globals.i}
{sh-defs.i}
{intrface.get xclass}

DEFINE INPUT PARAMETER iParam AS CHAR.
DEFINE VARIABLE vSumSaldo AS DECIMAL NO-UNDO.
DEFINE VARIABLE vCount    AS INTEGER NO-UNDO INITIAL 0.

OUTPUT TO VALUE(ENTRY(1,iParam,';')) .
PUT UNFORMAT "To: " ENTRY(3,iParam,';') 									SKIP
						 "Content-Type: text/plain; charset = ibm866" SKIP
						 "Content-Transfer-Encoding: 8bit" 						SKIP
						 "Subject: Красное сальдо по счетам на " STRING(TIME,"HH:MM:SS") " " TODAY "" SKIP(2).
						 
PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP.

FOR EACH acct 
	  WHERE acct.acct-cat EQ 'b' AND acct.close EQ ? NO-LOCK:
	  	
    RUN acct-pos IN h_base (acct.acct, acct.currency, TODAY, TODAY, "ФАА").
		
		vSumSaldo = IF acct.currency EQ "" THEN sh-bal ELSE sh-val.

	  IF ((vSumSaldo > 0) AND (acct.side = "П")) OR  
	  	 ((vSumSaldo < 0) AND (acct.side = "А")) THEN DO:
	  	 	vCount = vCount + 1.	
				PUT UNFORMAT acct.acct ' ' acct.side ' ' STRING(vSumSaldo,"->>>,>>>,>>>,>>>,>>9.99") ' '  
				             GetXAttrValueEx("acct", acct.acct + "," + acct.currency,"СКонСальдо",?) ' ' (IF {assigned acct.contr-acct} THEN "(есть парный счет)" ELSE "") SKIP.
		END.
		  	
END.
PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

OUTPUT CLOSE.			  

IF vCount NE 0 AND OPSYS = "UNIX" THEN DO:
	 OS-COMMAND SILENT VALUE(ENTRY(2,iParam,';') + " < " + ENTRY(1,iParam,';')).
END.

OS-DELETE VALUE(ENTRY(1,iParam,';')).
