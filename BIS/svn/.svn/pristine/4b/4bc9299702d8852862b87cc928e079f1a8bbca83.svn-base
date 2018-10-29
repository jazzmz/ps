/*** Находим доп.реквизит счета своим способом, т.к. 
     функция GetXattrValueEx в данном случае не подходит
*/
FUNCTION GetKorrektDR RETURNS CHARACTER
   (INPUT ipDRcode AS CHAR,
    INPUT ipSurr   AS CHAR):

  DEF VAR opDRval  AS CHAR  INIT "" NO-UNDO  . 
  DEF BUFFER pfsigns FOR signs .

  FIND FIRST  pfsigns
    WHERE pfsigns.code = ipDRcode
    AND   pfsigns.surrogate = ipSurr
    AND   pfsigns.file-name = "acct"
  NO-LOCK NO-ERROR .

  IF NOT AVAILABLE(pfsigns) THEN RETURN opDRval .

  IF pfsigns.xattr-value <> ?  AND pfsigns.xattr-value <> "" THEN
     opDRval = pfsigns.xattr-value .  /* это "нормальный" реквизит */

  IF pfsigns.xattr-value = ? AND pfsigns.xattr-value <> "" AND pfsigns.code-value <> ? AND pfsigns.code-value <> "" THEN
     opDRval = pfsigns.code-value .

  RETURN  opDRval .

END FUNCTION.



/*** Процедура проставляет реквизиты, если это требуется
*/
PROCEDURE UpdateDRforASV:
  DEF INPUT  PARAMETER  ipAcct		AS CHAR  NO-UNDO.
  DEF INPUT  PARAMETER  ipRuleFill	AS CHAR  NO-UNDO .
  DEF INPUT  PARAMETER  ipFlChange	AS LOGICAL INIT no NO-UNDO .
  DEF OUTPUT PARAMETER  opNewDRDogDate	AS CHAR  INIT "" NO-UNDO  . 
  DEF OUTPUT PARAMETER  opNewDRDogPlast	AS CHAR  INIT "" NO-UNDO  . 
  
  DEF BUFFER pfacct FOR acct .
  DEF BUFFER pfloan-acct FOR loan-acct .
  DEF BUFFER pfloan FOR loan .
  DEF BUFFER tfloan FOR loan .

  DEF VAR  vpDRDogDate	 	AS  CHAR INIT ""  NO-UNDO .
  DEF VAR  vpDRDogPlast	 	AS  CHAR INIT ""  NO-UNDO .
  DEF VAR  vpDRDogOtkrLS 	AS  CHAR INIT ""  NO-UNDO .
  DEF VAR  vpDRDogOtkrLSDate 	AS  CHAR INIT ""  NO-UNDO .
  DEF VAR  vpDRDogOtkrLSNum  	AS  CHAR INIT ""  NO-UNDO .

  DEF VAR  vpLoanParent  	AS  CHAR  NO-UNDO .


  FIND FIRST pfacct WHERE pfacct.acct = ipAcct  NO-LOCK NO-ERROR .
  vpDRDogDate  = GetXattrValueEx("acct", pfacct.acct + "," + pfacct.currency , "DogDate" , "" ) . 
  /* vpDRDogDate  = GetKorrektDR("DogDate" , pfacct.acct + "," + pfacct.currency ) .  */
  vpDRDogPlast = GetKorrektDR("DogPlast", pfacct.acct + "," + pfacct.currency ) .    

  vpDRDogOtkrLS = GetXattrValueEx("acct", pfacct.acct + "," + pfacct.currency , "ДогОткрЛС" , "" ) .
  IF NUM-ENTRIES (vpDRDogOtkrLS, ",") = 2 THEN
  DO:
    vpDRDogOtkrLSDate = ENTRY(1, vpDRDogOtkrLS , "," ) . 
    vpDRDogOtkrLSNum  = ENTRY(2, vpDRDogOtkrLS , "," ) . 
  END.


  CASE ipRuleFill :

        /*** Проставляем реквизиты по данным из реквизита ДогОткрЛС */
    WHEN  "1"  THEN DO: 

      IF  vpDRDogDate = ""   AND  vpDRDogOtkrLSDate <> "" THEN
        opNewDRDogDate =  vpDRDogOtkrLSDate .

      IF  vpDRDogPlast = ""  AND  vpDRDogOtkrLSNum  <> "" THEN
        opNewDRDogPlast	 = vpDRDogOtkrLSNum .

    END.

       /*** Проставляем реквизиты для кредитных счетов */
    WHEN  "2"  THEN DO: 

      FIND FIRST pfloan-acct WHERE pfloan-acct.acct = ipAcct  AND  pfloan-acct.contract BEGINS "кред"  NO-LOCK NO-ERROR.
      IF  NOT AVAILABLE pfloan-acct  THEN  RETURN.

      FIND FIRST pfloan WHERE pfloan.cont-code = pfloan-acct.cont-code  NO-LOCK NO-ERROR.
      IF  NOT AVAILABLE pfloan  THEN  RETURN.


      IF NOT( CAN-DO("loan_trans_ov,loan-tran-lin,loan_trans_diff",TRIM(pfloan.cont-code)) ) THEN
      DO:
           /*** Если договор ПК, то заполняем особым образом */
         IF  pfloan.cont-code BEGINS "ПК"  THEN
         DO:
            opNewDRDogDate  = STRING(pfloan.open-date) .
            opNewDRDogPlast = pfloan.cont-code .
         END.
         ELSE
         DO:
            IF vpDRDogOtkrLSNum = ""  THEN
              opNewDRDogPlast = STRING(pfloan.cont-code) .

            IF vpDRDogOtkrLSDate = ""  THEN
              opNewDRDogDate = GetXattrValueEx("loan",string(pfloan.contract + "," + pfloan.cont-code),"ДатаСогл","") . 
            IF opNewDRDogDate = ""  THEN
              opNewDRDogDate = STRING(pfloan.open-date) .
         END.
      END.

         /*** По траншам дата и номер должны как-то особо считаться */
      IF CAN-DO("loan_trans_ov,loan-tran-lin,loan_trans_diff",TRIM(pfloan.class-code)) THEN
      DO:

            /*** Охватывающий договор */
         IF  NUM-ENTRIES(pfloan.cont-code," ") = 2  THEN
            vpLoanParent = ENTRY(1,pfloan.cont-code," ") .

           /*** Если договор ПК, то заполняем особым образом */
         IF  pfloan.cont-code BEGINS "ПК"  THEN
         DO:
            opNewDRDogDate  = STRING(pfloan.open-date) .
            opNewDRDogPlast = vpLoanParent .
         END.
         ELSE 
         DO:
            FIND FIRST tfloan WHERE tfloan.cont-code = vpLoanParent NO-LOCK NO-ERROR.

            IF vpDRDogOtkrLSNum = ""  THEN
              opNewDRDogPlast = tfloan.cont-code .

            IF vpDRDogOtkrLSDate = ""  THEN
              opNewDRDogDate = GetXattrValueEx("loan",string(tfloan.contract + "," + tfloan.cont-code),"ДатаСогл","") . 
            IF opNewDRDogDate = ""  THEN
              opNewDRDogDate = STRING(tfloan.open-date) .
            IF opNewDRDogDate = ""  THEN
              opNewDRDogDate = STRING(pfloan.open-date) .
         END.
      END.

    END.

       /*** Проставляем реквизиты для вексельных счетов, для которых заведен договор в КИД */
    WHEN  "3"  THEN DO: 

      FIND FIRST pfloan-acct WHERE pfloan-acct.acct = ipAcct  AND  pfloan-acct.contract BEGINS "кред"  NO-LOCK NO-ERROR.
      IF  NOT AVAILABLE pfloan-acct  THEN  RETURN.

      FIND FIRST pfloan WHERE pfloan.cont-code = pfloan-acct.cont-code  NO-LOCK NO-ERROR.
      IF  NOT AVAILABLE pfloan  THEN  RETURN.

      IF  vpDRDogDate = ""  THEN
        opNewDRDogDate = GetXattrValueEx("loan",string(pfloan.contract + "," + pfloan.cont-code),"ДатаСогл","") . 

      IF  vpDRDogPlast = "" THEN
        opNewDRDogPlast	 = pfloan.cont-code .

    END.

        /*** Для счетов 47422 проставляем реквизиты по данным из договора пластиковой карты, к которому они привязаны */
    WHEN  "4"  THEN DO: 

      FIND LAST pfloan-acct WHERE pfloan-acct.acct = ipAcct  AND  pfloan-acct.acct-type BEGINS "ObBnk@"  NO-LOCK NO-ERROR.
      IF  NOT AVAILABLE pfloan-acct  THEN  RETURN.

      IF  vpDRDogDate = ""  THEN
        opNewDRDogDate =  STRING(pfloan-acct.since) .

      IF  vpDRDogPlast = "" THEN
        opNewDRDogPlast	 = pfloan-acct.cont-code .

    END.

    OTHERWISE DO: 
      opNewDRDogDate  = "" . 
      opNewDRDogPlast = "" .
    END.

  END CASE.


    /*** Реквизиты ставятся только при FlChange = yes */
  IF  ipFlChange = yes  THEN
  DO:

    IF  vpDRDogDate = ""  AND  opNewDRDogDate <> ""  THEN
      UpdateSigns("acct", STRING(pfacct.acct + "," + pfacct.currency) , "DogDate"  , opNewDRDogDate , ?).
    IF  vpDRDogPlast = "" AND  opNewDRDogPlast <> ""  THEN
      UpdateSigns("acct", STRING(pfacct.acct + "," + pfacct.currency) , "DogPlast" , opNewDRDogPlast, ?).

  END.


/* для проверки
MESSAGE "END_UpdateDR " 
  " ipAcct =" ipAcct		skip
  " ipRuleFill =" ipRuleFill	skip      
  " vpDRDogDate =" vpDRDogDate    skip
  " vpDRDogPlast =" vpDRDogPlast	skip                                        
  " vpDRDogOtkrLS =" vpDRDogOtkrLS      skip
  " vpDRDogOtkrLSDate =" vpDRDogOtkrLSDate  skip
  " vpDRDogOtkrLSNum =" vpDRDogOtkrLSNum    skip
  " opNewDRDogDate =" opNewDRDogDate    skip
  " opNewDRDogPlast =" opNewDRDogPlast	skip                                        
VIEW-AS ALERT-BOX.
*/

RETURN  .

END PROCEDURE.
