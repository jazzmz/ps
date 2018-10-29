{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-chk-cash-mail.p
      Comment: Процедура отправляюет письмо с информацией по документу,
		который попал под контроль pir-chk-cash.p
   Parameters: Входной параметер (iParam) принимает следующие значения (разделенные ";")
                - Имя временного файла
                - Имя почтового скрипта с параметрами (sendmail)
                - Список адресов для рассылки уведомлений разделенных запятыми
                - op.op - номер операции
                - op.op-transaction - номер транзакции
       Launch: Процедура запускается из pir-chk-cash.p 
         Uses:
      Created: Sitov S.A., 26.04.2012
	Basis: # 946
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}


   /**************  ВХОДНЫЕ ПАРАМЕТРЫ  *******************/ 
DEF INPUT PARAM iParam AS CHAR.

   /*******************  РИСОВАЛКИ  **********************/ 
DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableDoc  AS TTableCSV NO-UNDO.

oTpl = new TTpl("pir-chk-cash-mail.tpl").
oTableDoc = new TTableCSV(11).

  /*******************  ПЕРЕМЕНЫЕ ***********************/
DEF VAR KlName    AS CHAR NO-UNDO.
DEF VAR MailFile  AS CHAR NO-UNDO.
DEF VAR MailComd  AS CHAR NO-UNDO.
DEF VAR Mail      AS CHAR NO-UNDO.
DEF VAR Op        AS CHAR NO-UNDO.
DEF VAR OpTranz   AS CHAR NO-UNDO.
DEF VAR mSubject  AS CHAR NO-UNDO.

/*
iParam = "pir-chk-cash-mail.txt;/usr/sbin/sendmail -t -oi;ssitov@pirbank.ru;9927641;25850811" .
*/

MailFile = ENTRY(1,iParam,';') .
MailComd = ENTRY(2,iParam,';') .
Mail     = ENTRY(3,iParam,';') .
Op       = ENTRY(4,iParam,';') .
OpTranz  = ENTRY(5,iParam,';') .

mSubject = "Subject: НЕСАНКЦИОНИРОВАННАЯ ПОПЫТКА ПРОВЕДЕНИЯ РАСХОДНОГО КАССОВОГО ДОКУМЕНТА. " + STRING(TIME,"HH:MM:SS") + " " + STRING(TODAY,"99/99/9999").

/*
MESSAGE iParam VIEW-AS ALERT-BOX.
*/

/* =========================   РЕАЛИЗАЦИЯ   ================================= */

OUTPUT TO VALUE(MailFile) . 

PUT UNFORMAT	 "To: " Mail SKIP
		 "Content-Type: text/plain; charset = ibm866" SKIP
		 "Content-Transfer-Encoding: 8bit" SKIP
		mSubject SKIP(2) .
		/* CODEPAGE-CONVERT(mSubject,"1251",SESSION:CHARSET) SKIP(2). */

	 /* ТЕЛО ПИСЬМА */

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP(2).


FIND FIRST op 
	WHERE op.op EQ INT(Op)
	AND op.op-transaction EQ INT(OpTranz)
NO-LOCK NO-ERROR.

FIND FIRST op-entry OF op NO-LOCK NO-ERROR.

   FIND FIRST acct WHERE acct.acct EQ op-entry.acct-db NO-LOCK NO-ERROR.
   IF AVAIL(acct) THEN
      DO:
	IF acct.cust-cat = "Ч" THEN
	  DO:
		FIND FIRST person WHERE person.person-id EQ acct.cust-id NO-LOCK NO-ERROR.
		KlName = person.name-last + " " + person.first-name .
	  END.
	IF acct.cust-cat = "Ю" THEN
	  DO:
		FIND FIRST cust-corp WHERE cust-corp.cust-id EQ acct.cust-id NO-LOCK NO-ERROR.
		KlName = cust-corp.name-short  .
	  END.
      END.
   ELSE  
	KlName = "" .

   oTableDoc:addRow().
   oTableDoc:addCell(op.doc-date).
   oTableDoc:addCell(op.doc-num).
   oTableDoc:addCell(op-entry.acct-db).
   oTableDoc:addCell(op-entry.acct-cr).
   oTableDoc:addCell(op-entry.symbol).
   oTableDoc:addCell(IF op-entry.currency = "" THEN "810" ELSE op-entry.currency ).
   oTableDoc:addCell(IF op-entry.currency = "" THEN  STRING(op-entry.amt-rub,">>>,>>>,>>>,>99.99") ELSE STRING(op-entry.amt-cur,">>>,>>>,>>>,>99.99") ).
   oTableDoc:addCell(KlName).
   oTableDoc:addCell(op.details).


IF oTableDoc:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEDOC",oTableDoc). ELSE oTpl:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").
oTpl:show().

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

   /*** ТЕЛО ПИСЬМА (конец) ***/


OUTPUT CLOSE.			  

IF OPSYS = "UNIX" THEN DO:
	 OS-COMMAND SILENT VALUE(MailComd + " < " + MailFile).
END.
OS-DELETE VALUE(MailFile).


DELETE OBJECT oTableDoc.
DELETE OBJECT oTpl.
