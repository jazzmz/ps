{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-statcash-mail.p
      Comment: Процедура отправляюет письмо с информацией по заявке,
		при заведении заявки из опер.дня (онлайн заявка)
   Parameters: Входной параметер (iParam) принимает следующие значения (разделенные ";")
       Launch: Процедура запускается из pir-chk-cash.p 
         Uses:
      Created: Sitov S.A., 07.12.2012
	Basis: # 946
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}
{ulib.i}


   /**************  ВХОДНЫЕ ПАРАМЕТРЫ  *******************/ 
DEF INPUT PARAM iCode	AS CHAR.

   /*******************  РИСОВАЛКИ  **********************/ 
DEF VAR oTpl       AS TTpl      NO-UNDO.
DEF VAR oTableDoc  AS TTableCSV NO-UNDO.

oTpl = new TTpl("pir-statcash-mail.tpl").
oTableDoc = new TTableCSV(10).


  /*******************  ПЕРЕМЕНЫЕ ***********************/
DEF VAR OpDate		AS CHAR INIT "" NO-UNDO.
DEF VAR KlName		AS CHAR INIT "" NO-UNDO.
DEF VAR KlAcct		AS CHAR INIT "" NO-UNDO.
DEF VAR KlSum		AS DEC  INIT 0  NO-UNDO.
DEF VAR KlDtls		AS CHAR INIT "" NO-UNDO.
DEF VAR OnlnInitr	AS CHAR INIT "" NO-UNDO.
DEF VAR CodeDescr 	AS CHAR NO-UNDO.
DEF VAR CodeMisc  	AS CHAR NO-UNDO.

DEF VAR MailFile  AS CHAR NO-UNDO.
DEF VAR MailComd  AS CHAR NO-UNDO.
DEF VAR Mail      AS CHAR NO-UNDO.
DEF VAR mSubject  AS CHAR NO-UNDO.



FIND FIRST code WHERE code.class = "PirSightOP"
	AND code.code = "Visa9MailSOnl"
NO-LOCK NO-ERROR.

IF AVAIL code THEN 
DO:
  MailFile = ENTRY(2,code.val,';') . 
  MailComd = ENTRY(3,code.val,';') .
  Mail     = ENTRY(4,code.val,';') . 
END.

/*
MESSAGE 
   " iCode= " iCode
   " MailFile= " MailFile
   " MailComd= " MailComd
   " Mail= " Mail    
VIEW-AS ALERT-BOX.
*/


/* =========================   РЕАЛИЗАЦИЯ   ================================= */

OUTPUT TO VALUE(MailFile) . 

mSubject = "Subject: Журнал заявок. Заведена новая заявка" .

PUT UNFORMAT	 "To: " Mail SKIP
		 "Content-Type: text/plain; charset = ibm866" SKIP
		 "Content-Transfer-Encoding: 8bit" SKIP
		mSubject SKIP(2) .
		/* CODEPAGE-CONVERT(mSubject,"1251",SESSION:CHARSET) SKIP(2). */


	 /* ТЕЛО ПИСЬМА */

PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP(2).


FIND FIRST code 
	WHERE code.class  EQ 'PirStatCash' 
	AND code.code     EQ iCode
NO-LOCK NO-ERROR.


IF AVAIL(code) THEN
DO:

	/* Дата опер.дня */
  OpDate = ENTRY(5,code.code,"_") .
  OpDate = SUBSTRING(OpDate,7,2) + "/" + SUBSTRING(OpDate,5,2) + "/" + SUBSTRING(OpDate,1,4) .

	/* Клиент */
  KlName = GetClientInfo_ULL(ENTRY(3,code.code,"_") + "," + ENTRY(1,code.code,"_"), "name", false) .  
	/* Счет */ 
  KlAcct = ENTRY(1,code.name,";") . 
	/* Сумма */ 
  KlSum  = DECIMAL(ENTRY(2,code.name,";")) . 
	/* Вид расчета */
  KlDtls = ENTRY(3,code.name,";") . 
	/* Кто разрешил завести онлайн завку */
  OnlnInitr = ENTRY(5,code.name,";") . 

  IF NUM-ENTRIES(code.description[1],";") >= 3 THEN 
	  CodeDescr = ENTRY(3,code.description[1],";") .
  ELSE 
	  CodeDescr = "" . 

  CodeMisc  = code.misc[1] + code.misc[2] + code.misc[3] + code.misc[4] 
	    + code.misc[5] + code.misc[6] + code.misc[7] + code.misc[8]	.		



  oTableDoc:addRow().
  oTableDoc:addCell(KlName).
  oTableDoc:addCell(SUBSTRING(KlAcct,6,3)).
  oTableDoc:addCell(KlAcct).
  oTableDoc:addCell(STRING(KlSum,">>>,>>>,>>>,>99.99")).
  oTableDoc:addCell(KlDtls).
  oTableDoc:addCell(ENTRY(1,code.val ,";")).	/* Решение ПОДФТ */
  oTableDoc:addCell(ENTRY(2,code.val ,";")).	/* Причина решения ПОДФТ */
  oTableDoc:addCell(OnlnInitr).			/* Разрешил завести онлайн завку */
  oTableDoc:addCell(CodeDescr).			/* Утвердил член Правления */
  oTableDoc:addCell( (IF NUM-ENTRIES(code.name,";") >= 4 THEN ENTRY(4,code.name,";") ELSE "" ) ).



END.


oTpl:addAnchorValue("OpDate", OpDate).

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
