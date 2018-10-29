/* ========================================================================= */
/** 
    Copyright: ООО ПИР Банк, Управление автоматизации (C) 2013
     Filename: pir-dr2asv.p
      Comment: Процедура выводит отчет с информацией о проставлении
		реквизитов на счетах для реестра вкладчиков
		и по желанию пользователя их проставляет
   Parameters: Входные параметры 
		- список счетов второго порядка 
                - маска user-id ответсвенных сотрудников
                - правило заполнения реквизита
                - список получателей письма о смене реквизита (для запуска из планировщика)
       Launch: Процедура запускается из pir-dr2asv-st.p 
      Created: Sitov S.A., 06.05.2013
	Basis: # 2967
     Modified: <Кто> <Когда [F7]> (Локальный код для поиска <уникальный_код>) 
               <Описание изменения>                                           
*/
/* ========================================================================= */


{globals.i}
{intrface.get xclass}  
{pir-dr2asv.i}


/* =========================   ОБЪЯВЛЕНИЯ   ================================= */

DEF INPUT  PARAM  iAcctMask	AS  CHAR  NO-UNDO.
DEF INPUT  PARAM  iUserMask	AS  CHAR  NO-UNDO.
DEF INPUT  PARAM  iRuleFill	AS  CHAR  NO-UNDO.
DEF INPUT  PARAM  iMailList	AS  CHAR  NO-UNDO.
DEF INPUT  PARAM  iFlChange	AS  LOGICAL  NO-UNDO.
DEF OUTPUT PARAM  oCount	AS  INT64 INIT 0 NO-UNDO  . 

DEF VAR  vDRDogDate	AS CHAR NO-UNDO .
DEF VAR  vDRDogPlast	AS CHAR NO-UNDO .
DEF VAR  vNewDRDogDate	AS CHAR NO-UNDO .
DEF VAR  vNewDRDogPlast	AS CHAR NO-UNDO .

DEF VAR  vCountAcct	AS INT64 INIT 0 NO-UNDO .  

DEF BUFFER bfacct FOR acct . 




/* =========================   РЕАЛИЗАЦИЯ   ================================= */
oCount = 0 .

{setdest.i}

FOR EACH bfacct 
  WHERE  bfacct.acct-cat = 'b'
  AND    CAN-DO(iAcctMask , STRING(bfacct.bal-acct) )  
  AND    CAN-DO(iUserMask , bfacct.user-id  )  
  AND    bfacct.cust-cat = 'Ч'
  AND    bfacct.close-date = ? 
NO-LOCK:

   vNewDRDogDate  = "" .
   vNewDRDogPlast = "" .

   vDRDogDate   = GetXattrValueEx("acct", bfacct.acct + "," + bfacct.currency , "DogDate" , "" ) . 
   /*vDRDogDate   = GetKorrektDR("DogDate" , bfacct.acct + "," + bfacct.currency ) .*/
   vDRDogPlast  = GetKorrektDR("DogPlast", bfacct.acct + "," + bfacct.currency ) .

      /*** Запускаем проставление реквизитов */
   IF vDRDogDate = ""  OR  vDRDogPlast = ""  THEN
   DO:

     vCountAcct = vCountAcct + 1 .
     RUN UpdateDRforASV( INPUT bfacct.acct, INPUT iRuleFill, INPUT iFlChange, OUTPUT vNewDRDogDate, OUTPUT vNewDRDogPlast ) .

     IF  iFlChange = no  THEN
     DO:
       IF  vCountAcct = 1  THEN
       DO:
         PUT UNFORM "          ОТЧЕТ О ПРОСТАНОВКЕ ДОПОЛНИТЕЛЬНЫХ РЕКВИЗИТОВ НА СЧЕТАХ ДЛЯ РЕЕСТРА ВКЛАДЧИКОВ" SKIP .
         PUT UNFORM "                (проставленный процедурой реквизит указан в соответсвующем столбце)" SKIP(1) .
         PUT UNFORM 
           "Счет" 		FORMAT "X(21)"  "|"
           "Ответств-й сотрудник"	FORMAT "X(22)"  "|" 
           "ДР Дата договора"	FORMAT "X(16)"  "|"
           "ДР Номер договора"	FORMAT "X(25)"  "|"
         SKIP .
         PUT UNFORM FILL("-", 88) SKIP .
       END.
  
       PUT UNFORM 
         bfacct.acct	FORMAT "X(20)"  " | "
         bfacct.user-id	FORMAT "X(20)"  " | " 
         vNewDRDogDate	FORMAT "X(14)"  " | "
         vNewDRDogPlast	FORMAT "X(23)"  " | "
       SKIP .
     END.
   END.

END. /* end_FOR EACH bfacct */


IF  iFlChange = no  THEN
DO:
  PUT UNFORM  SKIP (2) .
  PUT UNFORM "ВСЕГО СЧЕТОВ: " vCountAcct  SKIP (2) .
  PUT UNFORMAT STRING(TIME,"HH:MM:SS") ' : ' PROGRAM-NAME(1) ': Finish' SKIP.
  {preview.i}
END.

oCount = vCountAcct .
