{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПPОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-chk-cash-answ.p
      Comment: Процедура отправляюет письмо - отчет по документам, на кототрых 
		были установлен доп.рек."Виза9" в значение Утверждена/Не утверждена
		(в рамках контроля наличных расходных операций по кассе)
      Comment: Процедура запускается из планировщика
   Parameters: Входной параметер (iParam) принимает следующие значения (разделенные ";")
                - Имя временного файла
                - Имя почтового скрипта с параметрами (sendmail)
                - Список адресов для рассылки уведомлений разделенных запятыми
         Uses:
      Created: Sitov S.A., 15.05.2012
	Basis: # 946
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */



{globals.i}


   /**************  ВХОДНЫЕ ПАРАМЕТРЫ  *******************/ 
DEF INPUT PARAM iParam AS CHAR.

   /*******************  РИСОВАЛКИ  **********************/ 
DEF VAR oSysClass  AS TSysClass NO-UNDO.
DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableDoc  AS TTableCSV NO-UNDO.

oTpl = new TTpl("pir-chk-cash-answ.tpl").
oTableDoc = new TTableCSV(11).
oSysClass = new TSysClass().

  /*******************  ПЕРЕМЕНЫЕ ***********************/
DEF VAR iDocCount  AS INTEGER INIT 0 NO-UNDO.

DEF VAR cMailFile  AS CHAR INIT "pir-chk-cash-answ.tmp" NO-UNDO.
DEF VAR cMailComd  AS CHAR INIT "/usr/sbin/sendmail -t" NO-UNDO.
DEF VAR cMail      AS CHAR INIT "u10_1@pirbank.ru" NO-UNDO.

/***SSITOV  */
cMailFile = ENTRY(1,iParam,';') .
cMailComd = ENTRY(2,iParam,';') .
cMail     = ENTRY(3,iParam,';') .

DEF VAR mSubject  AS CHAR NO-UNDO.
mSubject = "Subject: ОТЧЕТ: Контроль ПодФТ. Документы с Виза9 = УТРЕЖДЕНА/НЕ УТВЕРЖДЕНА" .

DEF VAR DRVisa9 AS CHAR  NO-UNDO.
DEF VAR KlName  AS CHAR  NO-UNDO.

/*MESSAGE iParam VIEW-AS ALERT-BOX.*/

/* =========================   РЕАЛИЗАЦИЯ   ================================= */


FOR EACH op WHERE op.op-status EQ "вФКА"
NO-LOCK,
FIRST op-entry OF op NO-LOCK:	

   DRVisa9 = GetXAttrValueEx("op",STRING(op.op),"Виза9","") .

   IF DRVisa9 = "Не требуется"  OR DRVisa9 = "Требуется" 
	THEN NEXT.  

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
   oTableDoc:addCell(IF op-entry.currency = "" THEN  op-entry.amt-rub ELSE op-entry.amt-cur ).
   oTableDoc:addCell(KlName).
   oTableDoc:addCell(DRVisa9).
   iDocCount = iDocCount + 1.


END.  /* end_for_each */



IF iDocCount > 0 THEN
DO:
OUTPUT TO VALUE(cMailFile) . 

PUT UNFORMAT	 "To: " cMail SKIP
		 "Content-Type: text/plain; charset = ibm866" SKIP
		 "Content-Transfer-Encoding: 8bit" SKIP
		 mSubject
		 /* CODEPAGE-CONVERT(mSubject,"1251",SESSION:CHARSET)  */
		 SKIP(2).		 

   /*** ТЕЛО ПИСЬМА ***/

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP(2).

oTpl:addAnchorValue("DocCount",iDocCount).
IF oTableDoc:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEDOC",oTableDoc). ELSE oTpl:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").
oTpl:show().

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

   /*** ТЕЛО ПИСЬМА (конец) ***/


IF OPSYS = "UNIX" THEN DO:
	 OS-COMMAND SILENT VALUE(cMailComd + " < " + cMailFile).
END.
OS-DELETE VALUE(cMailFile).

OUTPUT CLOSE.			  

/*
oTableDoc:SAVE-TO("/home2/bis/quit41d/imp-exp/doc/pir-chk-cash-answ-" + oSysClass:DATETIME2STR(TODAY,"%y%m%d") + ".txt").
*/

END.

DELETE OBJECT oTableDoc.
DELETE OBJECT oTpl.
DELETE OBJECT oSysClass.