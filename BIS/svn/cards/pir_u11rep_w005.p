/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir_u11rep_w005.p
      Comment: Отчет по файлу эквайринга из ПЦ (OK_TAN_txt)
		Находим нашу карту в нужном устройстве. 
		Если клиент по договору - нерезидент, то выводим в отчет
   Parameters: черех ; логины исполнителя и контролера для подписей в отчете
       Launch: ПК - Печать - Выходные формы - ПИРБАНК: Отчет по эквайрингу. Наша карта нерезидента
      Created: Sitov S.A., 01.04.2013
	Basis: #2742
     Modified: #3026, #3027 - Sitov S.A.
               
*/
/* ========================================================================= */


{globals.i}
{ulib.i}
{get-bankname.i}


DEF INPUT PARAMETER iBranch  AS CHAR NO-UNDO .

DEF VAR  iFileName	AS CHAR NO-UNDO.
DEF VAR  iFileNum	AS INT  NO-UNDO.
DEF VAR  iFileDate	AS DATE NO-UNDO.

DEFINE STREAM sImp.
DEFINE BUFFER card 	FOR loan .
DEFINE BUFFER equip	FOR loan .
DEFINE BUFFER acqloan 	FOR loan .

DEF VAR  CardExpect    	AS CHAR NO-UNDO.
DEF VAR  ListCard	AS CHAR NO-UNDO.
DEF VAR  EquipExpect	AS CHAR NO-UNDO.
DEF VAR  EquipName	AS CHAR NO-UNDO.
DEF VAR  ListEquip	AS CHAR NO-UNDO.	/* из классификатора */
DEF VAR  ClientType	AS CHAR NO-UNDO.
DEF VAR  ClientName	AS CHAR NO-UNDO.

DEFINE TEMP-TABLE ttRfile NO-UNDO
   FIELD npp		AS INT
   FIELD mStrNum	AS INT
   FIELD CardNum	AS CHAR 
   FIELD ClientName	AS CHAR 
   FIELD AcctCurrency	AS CHAR 
   FIELD TransAmount	AS DEC  
   FIELD EquipNum 	AS CHAR 
   FIELD EquipName      AS CHAR 
INDEX npp CardNum .

DEF VAR  TmpString	AS CHAR NO-UNDO.
DEF VAR  mStrNum	AS INT  NO-UNDO.
DEF VAR  mErrorStr	AS CHAR NO-UNDO.
DEF VAR  i		AS INT INIT 0 NO-UNDO.

DEF VAR  RepBeg		AS CHAR NO-UNDO.
DEF VAR  RepEnd		AS CHAR NO-UNDO.
DEF VAR  TablSep	AS CHAR NO-UNDO.
DEF VAR  TablHead	AS CHAR NO-UNDO.
DEF VAR  TablEnd	AS CHAR NO-UNDO.


DEF VAR oTpl     	AS TTpl   NO-UNDO.
DEF VAR oTableDoc	AS TTable NO-UNDO.
oTpl = new TTpl("pir_u11rep_w005.tpl").
oTableDoc = new TTable(6).

DEF VAR oTpl1     	AS TTpl   NO-UNDO.
DEF VAR oTableDoc1	AS TTable NO-UNDO.
oTpl1 = new TTpl("pir_u11rep_w005-1.tpl").
oTableDoc1 = new TTable(6).

DEF VAR oTpl2     	AS TTpl   NO-UNDO.
DEF VAR oTableDoc2	AS TTable NO-UNDO.
oTpl2 = new TTpl("pir_u11rep_w005-2.tpl").
oTableDoc2 = new TTable(6).


DEF VAR  Flg1   	AS LOG INIT no NO-UNDO.
DEF VAR  Flg2	  	AS LOG INIT no NO-UNDO.
DEF VAR  ListCardFlg2 	AS CHAR NO-UNDO.
DEF VAR  Mail    	AS CHAR NO-UNDO.
DEF VAR  MailFile    	AS CHAR NO-UNDO.
DEF VAR  ChkSum    	AS DEC  NO-UNDO.




	/* запрашиваем номер файла по разному для ПОДФТ и У11 (#3025) */
iFileNum = 44 .	/* на нем тестирую */

IF iBranch = "podft"  THEN
DO:
  MESSAGE  COLOR WHITE/RED  "Введите дату файла OKTRAN: "  UPDATE iFileDate .

  	/* файл импорта */
  iFileNum = iFileDate - DATE("01/01/" + STRING(YEAR(iFileDate))) + 1 .
  iFileName = FGetSetting("PIRCard","PathImpPODFT","")
	    + FGetSetting("PIRCard","MaskAcqRez","") 
	    + "." + STRING(iFileNum,"999") .
END.
ELSE
DO:
  MESSAGE  COLOR WHITE/RED  "Введите номер файла OKTRAN: "  UPDATE iFileNum .
  iFileDate = DATE("01/01/" + STRING(YEAR(TODAY))) + iFileNum - 1 .

	/* файл импорта */
  iFileName = FGetSetting("PIRCard","PathImp","")
  	    + FGetSetting("PIRCard","MaskAcqRez","") 
	    + "." + STRING(iFileNum,"999") .
END.

MESSAGE "Обрабатываем файл: " iFileName  VIEW-AS ALERT-BOX.



FOR EACH code
  WHERE code.class EQ 'КартыБанка' AND code.parent EQ 'КартыБанка' AND code.code BEGINS '198'
NO-LOCK:
  ListCard = ListCard + code.val + "," .
END.
ListCard = SUBSTRING(ListCard, 1, LENGTH(ListCard) - 1) .


ChkSum = DEC(GetCode("PirU11Rep", "2742ChkSum")) .

ListEquip = GetCode("PirU11Rep", "ListEquipNekom") .
MESSAGE "Список устройств для контроля: " ListEquip VIEW-AS ALERT-BOX.



  /* --- ------------------------------------------------------ --- */
  /* --- Импорт файла. Строим временную таблицу TEMP-TABLE      --- */
  /* --- ------------------------------------------------------ --- */

INPUT STREAM sImp FROM VALUE(iFileName) CONVERT SOURCE "1251"  .


MAIN:
DO TRANSACTION ON ERROR UNDO MAIN, RETRY MAIN:

   /* --- Обработка ошибок --- */
   IF RETRY THEN DO:
      ASSIGN mErrorStr = RETURN-VALUE                WHEN mErrorStr = "".
      ASSIGN mErrorStr = ERROR-STATUS:GET-MESSAGE(1) WHEN mErrorStr = "".
      ASSIGN mErrorStr = "Не определена"             WHEN mErrorStr = "".
      MESSAGE "ОШИБКА: " mErrorStr VIEW-AS ALERT-BOX .
      LEAVE MAIN.
   END.

   ClientType = "" .

   /* --- Импорт файла в TEMP-TABLE --- */
   imp:
   REPEAT:

      IMPORT STREAM sImp UNFORMATTED TmpString.
      mStrNum = mStrNum + 1.

      IF mStrNum = 1    /* первую строку пропускаем */
      THEN NEXT imp.


	/*** Задача 1 - Определить, наша ли карта ***/

      CardExpect   = TRIM(SUBSTRING(TmpString,221,24)) . /* карта-претендент */

      IF NOT CAN-DO( ListCard, SUBSTRING(CardExpect,1,6) )
      THEN NEXT imp.

      FIND FIRST card 
	WHERE card.contract = "card"
	AND card.loan-work = YES AND CAN-DO("АКТ,ЗВЛ,ИЗГ",card.loan-status) AND card.close-date = ?
	AND card.doc-num MATCHES CardExpect
      NO-LOCK NO-ERROR .

      IF NOT AVAIL(card)
      THEN NEXT imp.


	/*** Задача 2 - Определить, в нужном ли устройстве карта ***/

      EquipExpect = TRIM(SUBSTRING(TmpString,127,24)) . /* устройство-претендент */

      IF NOT CAN-DO( ListEquip, EquipExpect )
      THEN NEXT imp.

      FOR FIRST equip
	WHERE equip.contract EQ "card-equip"
	AND CAN-DO("card-equip",equip.class-code)
	AND equip.doc-num EQ EquipExpect
      NO-LOCK,
      LAST acqloan
	WHERE acqloan.contract EQ "card-acq"
	AND CAN-DO("card-loan-acqcust",acqloan.class-code)
	AND acqloan.cont-code EQ equip.parent-cont-code
      NO-LOCK:
	EquipName = GetClientInfo_ULL(acqloan.cust-cat + "," + string(acqloan.cust-id), "name", false) .
      END.


	/*** Задача 3 - Определить, является ли клиент по договору ПК резидентом ***/

      FIND FIRST loan 
	WHERE loan.cont-code = card.parent-cont-code
      NO-LOCK NO-ERROR .
      IF AVAIL(loan) THEN
      DO:
	ClientName = GetClientInfo_ULL(loan.cust-cat + "," + string(loan.cust-id), "name", false) .
	IF loan.cust-cat = 'Ч' THEN
	DO:
	  FIND FIRST person WHERE person.person-id = loan.cust-id NO-LOCK NO-ERROR .
	  ClientType = person.country-id .
	END.
	IF loan.cust-cat = 'Ю' THEN
	DO:
	  FIND FIRST cust-corp WHERE cust-corp.cust-id = loan.cust-id NO-LOCK NO-ERROR .
	  ClientType = cust-corp.country-id .
	END.
      END.

/*  #3150 Убрали этот критерий отбора  */
/*
      IF ClientType = "RUS" 
      THEN NEXT imp.
*/

	/*** Если мы до сюда дошли, значит, 
	  карта - наша   AND   устройство - нужное нам  
	  Тогда мы заносим информацию об операции в отчет
	****/

      CREATE ttRfile.
      ASSIGN
         ttRfile.npp  = i + 1
         ttRfile.mStrNum  =  mStrNum
         ttRfile.CardNum  =  card.doc-num
         ttRfile.ClientName   = ClientName 
         ttRfile.AcctCurrency = TRIM(SUBSTR(TmpString, 266, 3))  
         ttRfile.TransAmount  = DEC(TRIM(SUBSTR(TmpString, 269, 15))) / 100 
         ttRfile.EquipNum  = EquipExpect
         ttRfile.EquipName = EquipName
      NO-ERROR.


      IF ERROR-STATUS:ERROR THEN DO:
	MESSAGE "Некорректный формат файла. Обработка прервана." VIEW-AS ALERT-BOX .
        UNDO MAIN, LEAVE MAIN.
      END.

   END.

END.

INPUT STREAM sImp CLOSE.



  /* --- ---------------------------------------------------------------------------- --- */
  /* --- Строим отчет по данным импортированным в TEMP-TABLE  --- */
  /* --- ---------------------------------------------------------------------------- --- */

oTpl:addAnchorValue("FileName", FGetSetting("PIRCard","MaskAcqRez","") + "." + STRING(iFileNum,"999")).
oTpl:addAnchorValue("FileDate", STRING(iFileDate,"99/99/9999") ).

FOR EACH ttRfile 
  BREAK BY ttRfile.CardNum  BY ttRfile.EquipNum 
:

   ACCUMULATE ttRfile.TransAmount (TOTAL BY ttRfile.CardNum  BY ttRfile.EquipNum ) .

   IF LAST-OF(ttRfile.EquipNum ) THEN
   DO:
     oTableDoc:addRow().
     oTableDoc:addCell(ttRfile.CardNum).
     oTableDoc:addCell(ttRfile.ClientName).
     oTableDoc:addCell(STRING(ACCUM TOTAL BY ttRfile.EquipNum ttRfile.TransAmount ,">>>,>>>,>>>,>>9.99")).
     oTableDoc:addCell(ttRfile.AcctCurrency).
     oTableDoc:addCell(ttRfile.EquipNum ).
     oTableDoc:addCell(ttRfile.EquipName).
   END.

	/* определяем операции, каждая из которых свыше заданной суммы */
   IF ttRfile.TransAmount >= ChkSum THEN
   DO:
     Flg1 = yes .

     oTableDoc1:addRow().
     oTableDoc1:addCell(ttRfile.CardNum    ).
     oTableDoc1:addCell(ttRfile.ClientName ).
     oTableDoc1:addCell(ttRfile.TransAmount).
     oTableDoc1:addCell(ttRfile.AcctCurrency).
     oTableDoc1:addCell(ttRfile.EquipNum   ).
     oTableDoc1:addCell(ttRfile.EquipName  ).
   END.

END.

IF oTableDoc:HEIGHT <> 0 THEN  oTpl:addAnchorValue("TABLEDOC",oTableDoc). ELSE oTpl:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").

{setdest.i}
oTpl:show().
{preview.i}                              

DELETE OBJECT oTableDoc.
{tpl.delete}



  /* --- ---------------------------------------------------------------------------- --- */
  /* --- Отправляем письма, если это необходмо  --- */
  /* --- ---------------------------------------------------------------------------- --- */

Mail   = GetCode("PirU11Rep", "2742Mail") .

   /* #3027 */
IF Flg1 THEN 
DO:

   MailFile = "pir_u11rep_w005-1.txt". 

   OUTPUT TO VALUE(MailFile) . 

   PUT UNFORMAT	 "To: " Mail SKIP
		 "Content-Type: text/plain; charset = ibm866" SKIP
		 "Content-Transfer-Encoding: 8bit" SKIP
		 "Subject: Внимание. Обнаружена операция свыше " TRIM(STRING(DEC(ChkSum),">>>,>>>,>>>,>>9.99")) " руб. по нашим картам нерезидентов в устройствах ТСП некоммерческих организаций"  SKIP(2) 
   .
	 
   PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP(2).

   oTpl1:addAnchorValue("FileName", FGetSetting("PIRCard","MaskAcqRez","") + "." + STRING(iFileNum,"999")).
   oTpl1:addAnchorValue("FileDate", STRING(iFileDate,"99/99/9999") ).
   oTpl1:addAnchorValue("ChkSum", TRIM(STRING(DEC(ChkSum),">>>,>>>,>>>,>>9.99")) ).

   IF oTableDoc1:HEIGHT <> 0 THEN  oTpl1:addAnchorValue("TABLEDOC",oTableDoc1). ELSE oTpl1:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").
   oTpl1:show().

   PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

   OUTPUT CLOSE.			  

   IF OPSYS = "UNIX" THEN  OS-COMMAND SILENT VALUE("/usr/sbin/sendmail -t -oi < " + MailFile).
   OS-DELETE VALUE(MailFile).

END.

DELETE OBJECT oTableDoc1.
DELETE OBJECT oTpl1.


   /* #3026 */
FOR EACH ttRfile 
  BREAK BY ttRfile.CardNum  BY ttRfile.EquipNum 
:
   IF ttRfile.TransAmount < ChkSum THEN
     ACCUMULATE ttRfile.TransAmount (TOTAL BY ttRfile.CardNum ) .

   IF LAST-OF(ttRfile.CardNum )  AND (ACCUM TOTAL BY ttRfile.CardNum ttRfile.TransAmount) >= ChkSum THEN
   DO:  
     Flg2 = yes .
     ListCardFlg2 = ttRfile.CardNum + "," + ListCardFlg2  .
   END.
END.

IF Flg2 THEN 
DO:

   MailFile = "pir_u11rep_w005-2.txt". 

   FOR EACH ttRfile 
      WHERE CAN-DO(ListCardFlg2,ttRfile.CardNum) AND ttRfile.TransAmount < ChkSum
      BREAK BY ttRfile.CardNum  BY ttRfile.EquipNum 
   :
       oTableDoc2:addRow().
       oTableDoc2:addCell(IF FIRST-OF(ttRfile.CardNum ) THEN ttRfile.CardNum ELSE ""   ).
       oTableDoc2:addCell(IF FIRST-OF(ttRfile.CardNum ) THEN ttRfile.ClientName ELSE "" ).
       oTableDoc2:addCell(ttRfile.TransAmount).
       oTableDoc2:addCell(ttRfile.AcctCurrency).
       oTableDoc2:addCell(ttRfile.EquipNum   ).
       oTableDoc2:addCell(ttRfile.EquipName  ).

       ACCUMULATE ttRfile.TransAmount (TOTAL BY ttRfile.CardNum ) .

       IF LAST-OF(ttRfile.CardNum ) THEN
       DO:
       oTableDoc2:addRow().
       oTableDoc2:addCell("ИТОГО ПО КАРТЕ:").
       oTableDoc2:addCell("").
       oTableDoc2:addCell(STRING(ACCUM TOTAL BY ttRfile.CardNum ttRfile.TransAmount ,">>>,>>>,>>>,>>9.99")).
       oTableDoc2:addCell("").
       oTableDoc2:addCell("").
       oTableDoc2:addCell("").
       END.

   END.

   OUTPUT TO VALUE(MailFile) . 

   PUT UNFORMAT	 "To: " Mail SKIP
		 "Content-Type: text/plain; charset = ibm866" SKIP
		 "Content-Transfer-Encoding: 8bit" SKIP
		 "Subject: Внимание. По нашим картам нерезидентов в устройствах ТСП некоммерческих организаций обнаружены операции суммарно более " TRIM(STRING(DEC(ChkSum),">>>,>>>,>>>,>>9.99")) " руб." SKIP(2) 
   .
	 
   PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Start'  SKIP(2).

   oTpl2:addAnchorValue("FileName", FGetSetting("PIRCard","MaskAcqRez","") + "." + STRING(iFileNum,"999")).
   oTpl2:addAnchorValue("FileDate", STRING(iFileDate,"99/99/9999") ).
   oTpl2:addAnchorValue("ChkSum", TRIM(STRING(DEC(ChkSum),">>>,>>>,>>>,>>9.99")) ).

   IF oTableDoc2:HEIGHT <> 0 THEN  oTpl2:addAnchorValue("TABLEDOC",oTableDoc2). ELSE oTpl2:addAnchorValue("TABLEDOC","*** НЕТ ДАННЫХ ***").
   oTpl2:show().

   PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.

   OUTPUT CLOSE.			  

   IF OPSYS = "UNIX" THEN  OS-COMMAND SILENT VALUE("/usr/sbin/sendmail -t -oi < " + MailFile).
   OS-DELETE VALUE(MailFile).

END.


DELETE OBJECT oTableDoc2.
DELETE OBJECT oTpl2.
