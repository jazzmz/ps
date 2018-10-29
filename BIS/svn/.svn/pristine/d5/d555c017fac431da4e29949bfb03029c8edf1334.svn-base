	   /**************************************
	    *                                    *
	    * Указанный здесь код выполняется    *
	    * при смене статуса.                 *
            * Событие: onStatusChange            *
	    * Реагирует на следующие             *
	    * документы:                         *
            *  1. Повысить статус документа;     *
	    *  2. Понизить статус документа;     *
	    *  3. Откатить документ;             *
	    *  4. Аннулировать документ.         *
	    *                                    *
	    *  !!! ПОДКЛЮЧАЕТСЯ В pir-chkop !!!	 *
	    *                                    *
	    *         !!! ВНИМАНИЕ !!!           *
	    * В этом событие статус документа    *
            * меняется быстрее!                  *
	    *                                    *
	    **************************************
	    * Автор: Маслов Д. А. (Maslov D. A.) *
	    * Заявка: #638                       *
	    * Дата создания: 17.02.11            *
	    **************************************/

 {pir-nerez-check.i}
 {pir-inststat.i}

IF op.op-status>fop-entry.op-status THEN
  DO:
	/*********************************
	 *                               *
	 * Документ переводится в более  *
	 * высокий статус.               *
	 *				 *
         **********************************/

    IF LOGICAL(FGetSetting("PirChkOp","PirBankNerStatus","no")) THEN 
      DO:

	/****************************************
	 * Проверка на банк-нерезидент включена *
         *****************************************/

        IF NOT isBankNerezCheck(iRecOp) THEN DO:

          {pir-emtop.i}
          RETURN.
        END.

      END. /* END FGetSetting */


     IF LOGICAL(FGetSetting("PirChkOp","PirNalogStatus","no")) THEN
	DO:

	  /******************************************
	   * Проверка на правильность заполнения    *
	   * налоговых реквизитов.                  *
	   ******************************************/
	  oPoValid:runNalogCheck().

		  IF  oPOValid:isErrorState THEN 
			DO:
				/*************************
				 * В ДОКУМЕНТЕ ОШИБКА !!!*
		                 *************************/
   		                 MESSAGE COLOR WHITE/RED "НЕПРАВИЛЬНЫЕ НАЛОГОВЫЕ РЕКВИЗИТЫ! " SKIP
			         "ДОКУМЕНТ №" + oPoValid:doc-num + " . На сумму: " + STRING(oPoValid:sum) SKIP
			         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
				 REPLACE(oPOValid:getListErrorDetails(),",",CHR(10)) SKIP
				 VIEW-AS ALERT-BOX TITLE "[ОШИБКА #654]".

                             {pir-emtop.i}
  		             RETURN.
			END.


	  /******************************************
	   * Проверка на правильность заполнения    *
	   * налоговых документов - ПРЕДУПРЕЖДЕНИЕ  *
	   ******************************************/
	  oPoValid:runNalogCheck2().

		  IF  oPOValid:isErrorState THEN 
			DO:
				/*************************
				 * В ДОКУМЕНТЕ ОШИБКА !!!*
		                 *************************/
   		                 MESSAGE "НЕПРАВИЛЬНЫЕ НАЛОГОВЫЕ РЕКВИЗИТЫ! " SKIP
			         "ДОКУМЕНТ №" + oPoValid:doc-num + " . На сумму: " + STRING(oPoValid:sum) SKIP
			         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
				 REPLACE(oPOValid:getListErrorDetails(),",",CHR(10)) SKIP
				 VIEW-AS ALERT-BOX TITLE "[ПРЕДУПРЕЖДЕНИЕ #3004]".
                              /*{pir-emtop.i}*/
  		             RETURN.
			END.

	END.

/****************************************************
 *                                                  *
 * 1. Проверка документа на принадлежность вкладу;  *
 * 2. Разрешено ли осуществлять проводку в эту дату.*
 * Автор: Маслов Д. А.                              *
 * Заявка: #397                                     * 
 ****************************************************
 *
 * Перенес на из pir-chkop.p 19.05.11
 *                                                  *
*****************************************************/

{pir-isdeper.i}
     IF LOGICAL(FGetSetting("PirChkOp","PirDepPerStatus","YES")) THEN DO:
         IF  CAN-DO("{&maskDepozAcctList397}",fop-entry.acct-cr)
         THEN DO:
            /* Пополняем вкладной счет */
            IF NOT isDepozInPermit(fop-entry.acct-cr,fop-entry.op-date)
            THEN DO:
               MESSAGE COLOR WHITE/RED
                  "Установлен запрет на пополнение вклада!" SKIP
                  "Запрет начинается с " + STRING(getPermitDate(fop-entry.acct-cr)) + "!" SKIP
                  " Обратитесь в казаначейство!!!" SKIP
                  VIEW-AS ALERT-BOX
                  TITLE "Ошибка #397".
               {pir-emtop.i}
               RETURN.
            END.
         END.
      END.



/*по заявке #1292, проверяем не забыли ли опменять референс у документа загруженного транзакцией Pireval */
     IF LOGICAL(FGetSetting("PirChkOp","PirPirevalChk","YES")) THEN DO:
         if can-do("*@REF*",op.details) and can-do("pireval*",op.op-kind) then
	    DO:
               MESSAGE COLOR WHITE/RED
                  "Не исправлен Референс документа загруженного транзакцией pireval" SKIP
                  VIEW-AS ALERT-BOX
                  TITLE "Ошибка #1292".
              {pir-emtop.i}
	       RETURN.
	    end.
     END.


	  /******************************************
	   * Проверка на правильность заполнения    *
           * кассовых символов.                     *
	   ******************************************/


	  oPoValid:runSymbolsCheck().

		  IF  oPOValid:isErrorState THEN 
			DO:
				/*************************
				 * В ДОКУМЕНТЕ ОШИБКА !!!*
		                 *************************/
   		                 MESSAGE COLOR WHITE/RED "НЕПРАВИЛЬНЫЕ КАССОВЫЕ СИМВОЛА! " SKIP
			         "ДОКУМЕНТ №" + oPoValid:doc-num + " . На сумму: " + STRING(oPoValid:sum) SKIP
			         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
				 REPLACE(oPOValid:getListErrorDetails(),",",CHR(10)) SKIP
				 VIEW-AS ALERT-BOX TITLE "[ОШИБКА #991]".

                             {pir-emtop.i}
  		             RETURN.
			END.

          /*********************************************
           *
           * Проверка на возможность изменения остатка
           * по счетам.
           *
           *********************************************
           * Автор         : Маслов Д. А. Maslov D. A.
           * Дата создания : 30.10.12
           * Заявка        : #1606
           *********************************************/

	  oPoValid:runBusinessProcessCheck().

     IF LOGICAL(FGetSetting("PirChkOp","isBusinessCheck","YES")) THEN DO:

		  IF  oPOValid:isErrorState THEN 
			DO:
				/*************************
				 * В ДОКУМЕНТЕ ОШИБКА !!!*
		                 *************************/
   		                 MESSAGE COLOR WHITE/RED "ЗАПРЕТ НА ИЗМЕНЕНИЕ ОСТАТКА! " SKIP
			         "ДОКУМЕНТ №" + oPoValid:doc-num + " . На сумму: " + STRING(oPoValid:sum) SKIP
			         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
				 REPLACE(oPOValid:getListErrorDetails(),",",CHR(10)) SKIP
				 VIEW-AS ALERT-BOX TITLE "[ОШИБКА #1606]".

                             {pir-emtop.i}
  		             RETURN.
			END.

     END.

     IF LOGICAL(FGetSetting("PirChkOp","Pir2165","YES")) THEN DO:
       def var ParTemp AS CHAR NO-UNDO.
       def var ParTemp1 AS CHAR NO-UNDO.
       Partemp = FGetSetting("PirChkOp","Pir2165List","").
       if NUM-ENTRIES(Partemp,";") > 0 then 
	do:
	   vI = 1.
	   do vI = 1 to NUM-ENTRIES(Partemp,";"):	
             ParTemp1 = ENTRY(vI,ParTemp,";").
	      if NUM-ENTRIES(ParTemp1,"|") = 4 then do:
	        if can-do (entry(1,Partemp1,"|"),op.op-kind) and 
	           NOT CAN-DO(entry(2,Partemp1,"|"),fop-entry.acct-db) and 
                    NOT CAN-DO(entry(3,Partemp1,"|"),fop-entry.acct-cr)
		     then do: /*если документ сделаный транзакцией из списка, то проверяем*/

                                                  
	            find first b-op-entry where b-op-entry.op-transaction = fop-entry.op-transaction and
						    (CAN-DO(entry(2,Partemp1,"|"),b-op-entry.acct-db) or
						    CAN-DO(entry(3,Partemp1,"|"),b-op-entry.acct-cr)) and
						    b-op-entry.op-status < entry(4,Partemp1,"|") 
						    NO-LOCK NO-ERROR.
		   if available (b-op-entry) then do:
   		                 MESSAGE COLOR WHITE/RED "Не проведен связанный документ! " SKIP
			         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
			         "ДОКУМЕНТ На сумму: " + STRING(b-op-entry.amt-rub) SKIP
			         "ДЕБЕТ: " + STRING(b-op-entry.acct-db) SKIP
			         "КРЕДИТ: " + STRING(b-op-entry.acct-cr) SKIP
				 VIEW-AS ALERT-BOX TITLE "[ОШИБКА #2165]".
		     RETURN.
		     end.      
	        
	      end. 
	     end. /*if NUM-ENTRIES(ParTemp1,"|") = 4 then do:*/
	   end. /*do vI = 1 to NUM-ENTRIES(Partemp,";"):	*/
        end.  /*if NUM-ENTRIES(Partemp,";") > 0*/
 
     END.



    IF LOGICAL(FGetSetting("PirChkOp","Pir2621","YES")) 
       AND  NOT( CAN-DO( FGetSetting("PirChkOp","Pir2621opkind","*") , oPOValid:op-kind) )
    THEN 
      DO:
	/**************************************************
	 * #2621 Проверка документов с кодом 17,  01*, 09 *
         **************************************************/
         oPoValid:runChkCodeDocum().
         IF  oPOValid:isErrorState  THEN 
         DO:
		/*************************
		 * В ДОКУМЕНТЕ ОШИБКА !!!*
                 *************************/
                 MESSAGE COLOR WHITE/RED "НЕКОРРЕКТНЫЙ КОД ДОКУМЕНТА! " SKIP
	         "ДОКУМЕНТ №" + oPoValid:doc-num + " . На сумму: " + STRING(oPoValid:sum) SKIP
	         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
		 oPOValid:getListErrorDetails("ПроверкаКодаДокумента") SKIP
		 VIEW-AS ALERT-BOX TITLE "[ОШИБКА #2621]".
                 {pir-emtop.i}
		RETURN.
         END.
      END. /* END FGetSetting  Pir2621 */


    /********************
     * По заявке #2939
     * Проверка разрешенной запрещенной корреспонденции
     ********************/
     IF op.op-status >= FGetSetting("PirChkOp","korrStatus","ФБК") THEN DO:
         oPOValid:runPermitKorr().
     END.


   /*******************************************
    * По заявке #3065:
    *    1. Если в документе счет ДБ клиентский;
    *    2. И есть движение документов Д2;
    * выдаем предупреждение.
    *******************************************
    * Автор : Маслов Д. А. Maslov D. A.
    * Дата  : 24.06.13
    * Заявка: #3065
    *******************************************/

    IF oPOValid:runHasD2Move() AND CAN-DO(FGetSetting("PirChkOp","whoD2Notify","*"),USERID("bisquit")) THEN DO:

      RUN Fill-SysMes IN h_tmess ("","",3,"Внимание! #3065\nПо счету  " + oPOValid:acct-db + " есть не акцептованные документы Д2!\n|Все равно проводим,Отменить").
      IF pick-value = "2" THEN DO:
         {pir-emtop.i}
         RETURN.
      END.
          
    END.

/* 3701 СМЭВ 
Гончаров А.Е. 25.09.2013
*/
if logical (FGetSetting("PirChkOp","Pir3701","YES"))  then do:
	find first op-entry where op-entry.op eq op.op no-lock no-error.
	if (op.op-status GT "ФБМ") and 
	can-do (FGetSetting("PirChkOp","Pir3701_acct_rs",""), op.ben-acct) and
	can-do (FGetSetting("PirChkOp","Pir3701_acct_db",""), op-entry.acct-db) and
	can-do (FGetSetting ("PirChkOp","Pir3701_pokst",""), GetXattrValueEx ("op", string (op.op), "ПокСт","")) and
	not can-do (FGetSetting("PirChkOp","Pir3701_details",""),string(op.details)) and
	length (GetXattrValueEx("op", string(op.op), "Kpp-rec","")) ge 9 /*and  Убираем проверку длины ОКАТО по №4340
	length (GetXattrValueEx("op", string(op.op), "ОКАТО-НАЛОГ","")) le 10 */ then do:
		message color white/red "Невозможно сменить статус документа №" op.doc-num "\nНа сумму " if op-entry.amt-cur ne 0 then op-entry.amt-cur else op-entry.amt-rub "! Проверьте его реквизиты."
				view-as alert-box
				title "Ошибка #3701 (СМЭВ)".
				return.
			end.
end.

/* 4084  Запрос выписки по счёту при переводе документа в крыж.
Гончаров А.Е. 12.11.2013
*/

if logical (FGetSetting("PirChkOp","Pir4084","YES"))  then do:
	if op.class-code EQ "opbbk" then do:	/* Документы по КБ */
		if op.op-status eq "√" then do:		/* В крыже*/
			InstaStatement (op.op-date, fop-entry.acct-db).
		end.
	end.
end.

/* #4172 Запрет акцептования операции без проверки У10-2 при наличии кода ВО.
   Бакланов А.В. 22.11.2013
*/
        
if logical (FGetSetting("PirChkOp","Pir4172","YES")) then do:
        find first op-entry where op-entry.op eq op.op no-lock no-error.
        if (op.op-status GT "ФБМ") and 
        can-do (FGetSetting("PirChkOp","Pir4172_acct_cr",""), op-entry.acct-cr) and
	not can-do (FGetSetting ("PirChkOp","Pir4172_acpt",""), GetXattrValueEx ("op", string (op.op), "PIRcheckVO","")) and
        can-do (FGetSetting("PirChkOp","Pir4172_code",""),string(op.details)) then do:

                message color white/red "Невозможно сменить статус! Нет акцепта от У10-2!"
                                view-as alert-box
                                title "Ошибка #4172".
                                return.
                        end.
END.

/* 4123  Невозможность переведения документов для печати при 0 остатке на счете в более высокий статус.
Бакланов А.В. 02.12.2013
*/

if logical (FGetSetting("PirChkOp","Pir4123","YES"))  then do:
	if op.class-code EQ "opbprint" then do:		/* Документы для печати при нулевом остатке на счете */
		if op.op-status > "В" then do:		
                message color white/red "Невозможно сменить статус! Документ только для печати. Возможно только аннулирование."
                                view-as alert-box
                                title "Ошибка #4123".
                                return.
                        end.
		end.
end.


    IF LOGICAL(FGetSetting("PirChkOp","PirTechPlat","YES")) 
    THEN 
      DO:
	/**************************************************
	  Проверка Технологии платежа
         **************************************************/
         oPoValid:CheckPaytKind().
         IF  oPOValid:isErrorState  THEN 
         DO:
		/*************************
		 * В ДОКУМЕНТЕ ОШИБКА !!!*
                 *************************/
                 MESSAGE COLOR WHITE/RED "НЕКОРРЕКТНАЯ ТЕХНОЛОГИЯ ПЛАТЕЖА! " SKIP
	         "ДОКУМЕНТ №" + oPoValid:doc-num + " . На сумму: " + STRING(oPoValid:sum) SKIP
	         "*** ОБНАРУЖЕНЫ ОШИБКИ ***" SKIP
		 oPOValid:getListErrorDetails("Технология платежа") SKIP
		 VIEW-AS ALERT-BOX TITLE "[ОШИБКА #3269]".
                 {pir-emtop.i}
		RETURN.
         END.
      END. /* END FGetSetting  PirTechPlat */


    IF LOGICAL(FGetSetting("PirChkOp","PirOrderPay","YES")) 
    THEN 
      DO:
	/**************************************************
	  Проверка очередности платежа
         **************************************************/
       IF NOT CAN-DO(FGetSetting("PirChkOp","PirOrderPayList","*"),op.order-pay) AND CAN-DO("30102*",fop-entry.acct-cr)
            THEN 
            DO:
               message color white/red "Документ с запрещенной очередностью. Номер документа: " + op.doc-num 
                             view-as alert-box
                             title "Ошибка #4272".
                             return.

            END.
      END. /* END FGetSetting  PirOrderPay */

  END. /* END IF op.op-status > fop-entry.op-status */


IF op.op-status<fop-entry.op-status THEN
   DO:
	/*********************************
	 *                               *
	 * Документ переводится в более  *
	 * низкий статус.                *
	 *                               *
         *********************************/	
   END.


     /**
      * Общая проверка наличия ошибки
      **/
     IF oPOValid:isErrorState THEN DO:
               oPOValid:showErrors().
               {pir-emtop.i}
               RETURN.
     END.