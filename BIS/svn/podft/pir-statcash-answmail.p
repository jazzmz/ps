{pirsavelog.p}

/* ========================================================================= */
/** 
    Copyright: ООО КБ "ПРОМИНВЕСТРАСЧЕТ", Управление автоматизации (C) 2012
     Filename: pir-statcash-answmail.p
      Comment: Процедура отправляюет письмо с информацией об утверждении онлайн заявки,
   Parameters: Входной параметер (iParam) принимает следующие значения (разделенные ";")
       Launch: Процедура запускается из pir-ststcash-podft.p 
         Uses:
      Created: Sitov S.A., 24.12.2012
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

oTpl = new TTpl("pir-statcash-answmail.tpl").
oTableDoc = new TTableCSV(6).


  /*******************  ПЕРЕМЕНЫЕ ***********************/
DEF VAR OpDate		AS CHAR INIT "" NO-UNDO.
DEF VAR KlName		AS CHAR INIT "" NO-UNDO.
DEF VAR KlAcct		AS CHAR INIT "" NO-UNDO.
DEF VAR KlSum		AS DEC  INIT 0  NO-UNDO.
DEF VAR KlDtls		AS CHAR INIT "" NO-UNDO.


DEF VAR MailFile  AS CHAR NO-UNDO.
DEF VAR MailComd  AS CHAR NO-UNDO.
DEF VAR Mail      AS CHAR NO-UNDO.
DEF VAR mSubject  AS CHAR NO-UNDO.


FIND FIRST code WHERE code.class = "PirSightOP"
	AND code.code = "Visa9MailSPdf"
NO-LOCK NO-ERROR.

IF AVAIL code THEN 
DO:
  MailFile = ENTRY(2,code.val,';') .  /* "pir-statcash-answmail.txt" .  */
  MailComd = ENTRY(3,code.val,';') .
  Mail     = ENTRY(4,code.val,';') .  /* "bis@pirbank.ru;u10_1@pirbank.ru" */
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

mSubject = "Subject: Журнал заявок. Утверждена новая онлайн заявка" .

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


  oTableDoc:addRow().
  oTableDoc:addCell(KlName).
  oTableDoc:addCell(KlAcct).
  oTableDoc:addCell(STRING(KlSum,">>>,>>>,>>>,>99.99")).
  oTableDoc:addCell(KlDtls).
  oTableDoc:addCell(ENTRY(1,code.val ,";")).


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
