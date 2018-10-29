/* Во входой параметр ipName через разделитель "|" вторым элементом
** могут передаваться дополнительные параметры. Разделитель между параметрами - CHR(1) */
FUNCTION Form_Rsrv RETURN CHARACTER ( INPUT ipName    AS CHAR,
                                      INPUT iContract AS CHARACTER,
                                      INPUT iContCode AS CHARACTER,
                                      INPUT iDate     AS DATE
                                    ).
   DEF VAR vRsrvSum AS DECIMAL INIT 0.00 NO-UNDO.
   DEF VAR vExtPrm     AS CHARACTER NO-UNDO.  /* Дополнительные параметры */
   DEF VAR vFname      AS CHARACTER NO-UNDO .
   DEF VAR vSpisParam3 AS CHARACTER NO-UNDO INIT "". /* необязательный третий   параметр  у ФормРезСроч и ФормРезПр    */
   DEF VAR vSpisParam4 AS CHARACTER NO-UNDO INIT "". /* необязательный четвертый параметр  у ФормРезСроч и ФормРезПр    */

   IF iContract <> "Кредит" THEN
      RETURN ?.

   /* Поиск договора */
   RUN RE_B_LOAN (iContract, iContCode, BUFFER loan).

   IF NOT AVAIL loan THEN
      RETURN ?.

   IF iDate = ? THEN iDate = GetBaseOpDate().

   IF loan.since NE iDate THEN
   DO:
      RUN Fill-SysMes ("", "17l", "",
                       "%s=" + iContCode + "%s=" + STRING(iDate)).
      RETURN ?.
   END.

   IF NUM-ENTRIES(ipName,"|") GT 1
   THEN
      ASSIGN
         vExtPrm = ENTRY(2,ipName,"|")
         vFName  = ENTRY(1,ipName,"|")
         .
   ELSE
      vFName = ipName.
   IF NUM-ENTRIES(ipName,"|") GT 2 AND
     ( TRIM(vFName) EQ 'ФормРезСроч' OR
       TRIM(vFName) EQ 'ФормРезПр' )
   THEN
      ASSIGN
         vSpisParam3 = ENTRY(3,ipName,"|")
         vSpisParam4 = ENTRY(4,ipName,"|")
         NO-ERROR
      .
   IF ERROR-STATUS :ERROR  THEN
      ASSIGN
         vSpisParam3 = ""
         vSpisParam4 = ""
         .


   /* Взведем флаг ,нужно ли обрабатывать параметр CОГЛ */
   RUN setVerifyRelType IN h_i254 (FALSE) .
   IF INDEX(vExtPrm,"СОГЛ") GT 0
   THEN
      RUN setVerifyRelType IN h_i254  (TRUE) .

   /* Передаем vSpisParam в обработку парсеров  */
   RUN setSpisBaseParam IN h_i254 (vSpisParam3,vSpisParam4) .

   IF TRIM(vFName) = 'ФормРез' THEN
      vRsrvSum = LnFormRsrv(loan.contract,loan.cont-code,iDate,"").
   IF TRIM(vFName) = 'ФормРезСроч' THEN
      vRsrvSum = LnFormRsrvGoodDebt(loan.contract,loan.cont-code,iDate,"").
   IF TRIM(vFName) = 'ФормРезПр' THEN
      vRsrvSum = LnFormRsrvBadDebt(loan.contract,loan.cont-code,iDate,"").
   IF TRIM(vFName) = 'ФормРезКом' THEN
      vRsrvSum = LnFormRsrvCom(loan.contract,loan.cont-code,iDate,"",ENTRY(2,vExtPrm,CHR(1))).

   IF TRIM(vFName) = 'ФормРезПроцСроч' THEN
      vRsrvSum = LnFormRsrvProcGood(loan.contract,loan.cont-code,iDate,"").
   IF TRIM(vFName) = 'ФормРезПроцПр' THEN
      vRsrvSum = LnFormRsrvProcBad(loan.contract,loan.cont-code,iDate,"").
   IF TRIM(vFName) = 'ФормРезДискСроч' THEN
      vRsrvSum = LnFormRsrvVDiskGood(loan.contract,loan.cont-code,iDate,"").
   IF TRIM(vFName) = 'ФормРезДискПр' THEN
      vRsrvSum = LnFormRsrvDiskBad(loan.contract,loan.cont-code,iDate,"").

   IF TRIM(vFName) = 'ФормРезВб'     THEN
      vRsrvSum = LnFormRsrvVb(loan.contract,loan.cont-code,iDate,"","КредН",FALSE,FALSE).
   RUN setVerifyRelType IN h_i254 (FALSE) .
   RUN setSpisBaseParam IN h_i254 ("","") .
   RETURN STRING(vRsrvSum).

END FUNCTION.