CLASS TPaymentOrder INHERITS TDocument:
            /********************************************
             * Класс поставщик данных для платежного 
             * поручения
             ********************************************/
&GLOBAL-DEFINE in in
&GLOBAL-DEFINE out out
&GLOBAL-DEFINE inner inner

{set-prop.i &aa="type" &bb="cType" &cc="CHARACTER"}
{set-prop.i &aa="cb-type" &bb="ccb-type" &cc="CHARACTER"}
{set-prop.i &aa="sp-date" &bb="cSpdate" &cc="DATE"}

{set-prop.i &aa="name-send" &bb="cName-Send" &cc="CHARACTER"}
{set-prop.i &aa="name-rec" &bb="cName-Rec" &cc="CHARACTER"}

{set-prop.i &aa="inn-send" &bb="cInn-Send" &cc="CHARACTER" &init="\"\""}
{set-prop.i &aa="inn-rec" &bb="cInn-Rec" &cc="CHARACTER" &init="\"\""}

{set-prop.i &aa="kpp-send" &bb="cKpp-Send" &cc="CHARACTER" &init="\"\""}
{set-prop.i &aa="kpp-rec" &bb="cKpp-Rec" &cc="CHARACTER" &init="\"\""}

{set-prop.i &aa="acct-send" &bb="cAcct-Send" &cc="CHARACTER"}
{set-prop.i &aa="acct-rec" &bb="cAcct-Rec" &cc="CHARACTER"}

/* Банк-Отправителя */
{set-prop.i &aa="bank-bic-send"     &bb="cBankBicSend"     &cc="CHARACTER"}
{set-prop.i &aa="bank-acct-send"   &bb="cBankAcctSend"   &cc="CHARACTER"}
{set-prop.i &aa="bank-name-send" &bb="cBankNameSend" &cc="CHARACTER"}

/* Банк-Получателя */
{set-prop.i &aa="bank-bic-rec"     &bb="cBankBicRec"     &cc="CHARACTER"}
{set-prop.i &aa="bank-acct-rec"   &bb="cBankAcctRec"   &cc="CHARACTER"}
{set-prop.i &aa="bank-name-rec" &bb="cBankNameRec" &cc="CHARACTER"}

/* Направление */
{set-prop.i &aa="direct" &bb="cDirect" &cc="CHARACTER" &init="\"out\""}

/****************************************
 *							   *
 * 	     Налоговые реквизиты         *
 *							   *
 ****************************************/

/* В нотации наименования */
{set-prop.i &aa="kbk" &bb="cKbk" &cc="CHARACTER"}
{set-prop.i &aa="okato" &bb="cOkato" &cc="CHARACTER"}
{set-prop.i &aa="datepok" &bb="cDatePok" &cc="CHARACTER"}
{set-prop.i &aa="nppok" &bb="cNpPok" &cc="CHARACTER"}
{set-prop.i &aa="ndpok" &bb="cNdPok" &cc="CHARACTER"}
{set-prop.i &aa="oppok" &bb="cOpPok" &cc="CHARACTER"}
{set-prop.i &aa="tppok" &bb="cTpPok"  &cc="CHARACTER"}
{set-prop.i &aa="statuspok" &bb="cStatusOk" &cc="CHARACTER"}

/* В цифровой нотации */
{set-prop.i &aa="field4"    &bb="dfield4"  &cc="DATE"}	/* Документ от      */
{set-prop.i &aa="field62"   &bb="dfield62" &cc="DATE"}  /* Дата поступления */
{set-prop.i &aa="field71"   &bb="dfield71" &cc="DATE"}  /* Дата списания    */


{set-prop.i &aa="field101" &bb="cField101" &cc="CHARACTER"}
{set-prop.i &aa="field102" &bb="cField102" &cc="CHARACTER"}
{set-prop.i &aa="field103" &bb="cField103" &cc="CHARACTER"}
{set-prop.i &aa="field104" &bb="cField104" &cc="CHARACTER"}
{set-prop.i &aa="field105" &bb="cField105" &cc="CHARACTER"}
{set-prop.i &aa="field106" &bb="cField106" &cc="CHARACTER"}
{set-prop.i &aa="field107" &bb="cField107" &cc="CHARACTER"}
{set-prop.i &aa="field108" &bb="cField108" &cc="CHARACTER"}
{set-prop.i &aa="field109" &bb="cField109" &cc="CHARACTER"}
{set-prop.i &aa="field110" &bb="cField110" &cc="CHARACTER"}



CONSTRUCTOR TPaymentOrder(INPUT recRecID AS RECID):
        SUPER(recRecID,TODAY).
END CONSTRUCTOR.

CONSTRUCTOR TPaymentOrder(INPUT iOp AS INTEGER):
        SUPER(iOp).
END CONSTRUCTOR.

CONSTRUCTOR TPaymentOrder(INPUT bOpHandle AS HANDLE):
          fillOp(bOpHandle).
END CONSTRUCTOR.



METHOD PROTECTED VOID fillTechPlat(INPUT bOpHandle AS HANDLE):
   DEF VAR oSysClass AS TSysClass NO-UNDO.
   DEF VAR oOpEntry AS TOpEntry   NO-UNDO.

   oSysClass = new TSysClass().
   oOpEntry = getOpEntry4Order(1).

     IF CAN-DO(oSysClass:getSetting("ТехПлат","ТПЭлектронный"),oOpEntry:techPlat) THEN type = "электронно".
     IF CAN-DO(oSysClass:getSetting("ТехПлат","ТПСрочный"),oOpEntry:techPlat)     THEN type = "срочно".
     IF CAN-DO(oSysClass:getSetting("ТехПлат","ТППочта"),oOpEntry:techPlat)       THEN type = "почта".
     IF CAN-DO(oSysClass:getSetting("ТехПлат","ТПТелеграф"),oOpEntry:techPlat)    THEN type = "телеграф".

   DELETE OBJECT oSysClass.
   oOpEntry = ?.
END METHOD.

METHOD PROTECTED VOID fillDirectPlat(INPUT bOpHandle AS HANDLE):
            /*************************************
             * Определяем направление документа *
             **************************************/
        DEF VAR oSysClass AS TSysClass NO-UNDO.
        DEF VAR cCorrAcct AS CHARACTER NO-UNDO.
        DEF VAR oOpEntry AS TOpEntry   NO-UNDO.

            oSysClass = new TSysClass().
                   cCorrAcct = TBank:getNostroCbr().

                    /************************
                     * Если по ДБ корсчет, то документ пришел
                     * Если по кредиту корсчет, то документ ушел.
                     * Если ни там ни там, 
                     * то это внутренний документ.
                     * ВНИМАНИЕ!!! ЭТО ЧАСТНЫЙ СЛУЧАЙ !!!
                     ************************/

                     IF acct-db = cCorrAcct THEN direct = "{&in}". ELSE IF acct-cr = cCorrAcct THEN direct = "{&out}".  ELSE direct = "{&inner}".

             DELETE OBJECT oSysClass.
   oOpEntry = ?.
END METHOD.

METHOD PROTECTED VOID fillSendAttr(INPUT bOpHandle AS HANDLE):
            
            /***********************************
             * 
             * Заполняем реквизиты блока №2
             *
             ***********************************/

            DEF VAR oClient AS CLASS TClient NO-UNDO.

                    
                                 oClient = new TClient(acct-db).

                                     kpp-send = getXAttrWDef("Kpp-send","").

                                     inn-send  = getXAttr("inn-send").

				  IF inn-send EQ ? THEN DO:

                                     IF direct = "{&in}"  THEN
                                            DO:
                                                    inn-send = bOpHandle::inn.
                                            END.                                           

				    IF inn-send EQ ? THEN inn-send = oClient:clInn.

				  END.

				   /*** Имя отправителя ***/

                                    name-send = getXAttr("name-send").
                
					  IF name-send EQ ? THEN DO:

                                             IF direct = "{&out}" OR direct = "{&inner}" THEN
                                                    DO:
                                                         name-send = oClient:name-short.
                                                     END.
                                                     ELSE
                                                        DO:
                                                             name-send = bOpHandle::name-ben.
                                                        END.
					   END.

                                             acct-send = getXAttr("acct-send").
					    IF acct-send EQ ? THEN DO:
                                             IF direct = "{&out}" OR direct = "{&inner}" THEN
                                                    DO:                                                    
                                                        acct-send = acct-db.
                                                     END.
                                                        ELSE
                                                            DO:
                                                                    acct-send = bOpHandle::ben-acct.
                                                            END.
					     END.

                       DELETE OBJECT oClient.

END METHOD.

METHOD PROTECTED VOID fillSendBankAttr(INPUT bOpHandle AS HANDLE):
                     /*********************************
                     * Заполняем банк-отправителя №3 *
                     *********************************/

            DEF VAR oSysClass AS TSysClass NO-UNDO.
            DEF VAR oBank     AS TBank     NO-UNDO.
	    DEF VAR oBank1    AS TBank     NO-UNDO.

            DEF VAR bankName     AS CHAR      NO-UNDO.
            DEF VAR bankNameFull AS CHAR      NO-UNDO.

          oSysClass = new TSysClass().           

	  /***********************
           * Платеж внешний
           ***********************/
          IF direct = "{&out}" THEN
            DO:

                    RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).

                    ASSIGN
                       bank-bic-send = oSysClass:getSetting("БанкМФО")
                       bank-acct-send = oSysClass:getSetting("КоррСч20")
                       bank-name-send = bankName + " " + oSysClass:getSetting("БанкГород") 
                    .
            END.
            ELSE
                DO:
                    oBank = SUPER:getBankBen().
                            /*******************
                             * Платеж внешний входящий
                             *******************/
                             IF oBank <> ? THEN
                                 DO:	
				      ASSIGN	
                                        bank-bic-send  = oBank:bic
                                        bank-acct-send = oBank:corr-acct
                                        bank-name-send = oBank:bank-name + " " + oBank:town-type + " " + oBank:town
				      .
                                 END.
				 ELSE DO:
					/*********************
					 * Платеж внутренний *
					 **********************/
                                             RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).
					     ASSIGN
			                	bank-bic-send  = oSysClass:getSetting("БанкМФО")
				                bank-acct-send = oSysClass:getSetting("КоррСч20")
			                	bank-name-send = bankName + " " + oSysClass:getSetting("БанкГород")
					     .
				 END.

                      DELETE OBJECT oBank NO-ERROR.
                END.

        DELETE OBJECT oSysClass.
END METHOD.

METHOD PROTECTED VOID fillRecAttr(INPUT bOpHandle AS HANDLE):
            
            /***********************************
             * 
             * Заполняем реквизиты блока №4
             *
             ***********************************/
            

             kpp-rec = getXAttrWDef("Kpp-rec","").

             inn-rec  = getXAttr("inn-rec").
             IF inn-rec = ? THEN inn-rec = bOpHandle::inn.

            name-rec = getXAttr("name-rec").

                        IF name-rec = ? THEN
                            DO:
                                  name-rec = name-ben.
                            END.

            acct-rec = getXAttr("acct-rec").
            IF acct-rec = ? THEN acct-rec = bOpHandle::ben-acct.

END METHOD.

METHOD PROTECTED VOID fillRecBankAttr(INPUT bOpHandle AS HANDLE):
            
            /***********************************
             * 
             * Заполняем реквизиты блока №5
             *
             ***********************************/          
        DEF VAR oBank AS TBank         NO-UNDO.
        DEF VAR oSysClass AS TSysClass NO-UNDO.
        
        DEF VAR bankName     AS CHAR      NO-UNDO.
        DEF VAR bankNameFull AS CHAR      NO-UNDO.


        oSysClass = new TSysClass().

                IF direct = "{&out}" THEN
                    DO:

                        oBank = SUPER:getBankBen().
            
                             IF oBank <> ? THEN
                                 DO:
				    ASSIGN
                                       bank-bic-rec  = oBank:bic
                                       bank-acct-rec = oBank:corr-acct
                                       bank-name-rec = oBank:bank-name + " " + oBank:town-type + " " + oBank:town
                                    .
                                 END.
                                 ELSE
                                    DO:
				       ASSIGN
                                         bank-bic-rec  = bank-bic-send
                                         bank-acct-rec = bank-acct-send
                                         bank-name-rec = bank-name-send
                                        .
                                    END.
                        DELETE OBJECT oBank NO-ERROR.

                    END. /* END {&out} */
                    ELSE
                        DO:    
                           RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).

			    ASSIGN                   
                              bank-bic-rec = oSysClass:getSetting("БанкМФО")
                              bank-acct-rec = oSysClass:getSetting("КоррСч20")
                              bank-name-rec = bankName + " " + oSysClass:getSetting("БанкГород")
                            .
                        END.
        DELETE OBJECT oSysClass.
END METHOD.

METHOD PROTECTED VOID fillNalogAttr(INPUT bOpHandle AS HANDLE):
            /***********************************
             * 
             * Заполняем реквизиты блока №6
             *
             ***********************************/          
        statuspok = getXAttrWDef("ПокСТ","").
	field101 = statuspok.

	field102 = kpp-send.

	field103 = kpp-rec.

        kbk = getXAttrWDef("КБК","").
	field104 = kbk.

        okato = getXAttrWDef("ОКАТО-НАЛОГ","").
	field105 = okato.

        oppok = getXAttrWDef("ПокОп","").
	field106 = oppok.

        nppok = getXAttrWDef("ПокНП","").
	field107 = nppok.

        datepok = getXAttrWDef("ПокДД","").
	field108 = datepok.

        ndpok = getXAttrWDef("ПокНД","").
	field109 = ndpok.

        tppok = getXAttrWDef("ПокТП","").
	field110 = tppok.


END METHOD.

METHOD OVERRIDE PROTECTED VOID fillOp(INPUT bOpHandle AS HANDLE):

       DEF VAR oSysClass AS TSysClass NO-UNDO.

    /*************************************
     * Определяем основные рек-ты док-та *
     * Блок №1                                                    *
     *************************************/
      SUPER:fillOp(bOpHandle).

        oSysClass = new TSysClass().

            cb-type = oSysClass:getCBDocCode(doc-type).
            doc-date = bOpHandle::doc-date.
            sp-date = DATE(getXAttr("СписСчета")).
	
	   ASSIGN
	    field4  = doc-date
	    field62 = ins-date
	    field71 = sp-date
	   .
	


        DELETE OBJECT oSysClass.
    /*********************************
     *
     * Определяем технологию платежа
     *
     **********************************/
      fillTechPlat(bOpHandle).

    /*************************************
      * Определяем направление документа *
      *************************************/

       fillDirectPlat(bOpHandle).
        

    /*********************************
     * Определяем отправителя средств *
     * Блок №2                                            *
     *********************************/
    fillSendAttr(bOpHandle).

    /*********************************
     * Определяем банк отправителя     *
     * Блок №3                                             *
     *********************************/
   fillSendBankAttr(bOpHandle).

     /**********************************
       * Определяем получателя средств *
       * Блок №4                                            *
       *********************************/
     fillRecAttr(bOpHandle).


     /**********************************
       * Определяем банк получателя      *
       * Блок №5                                            *
       *********************************/
     fillRecBankAttr(bOpHandle). 

     /************************************
       * Определяем налоговые реквизиты  *
       * Блок №6                                                  *
       ************************************/
    fillNalogAttr(bOpHandle).

 END METHOD.

END CLASS.
