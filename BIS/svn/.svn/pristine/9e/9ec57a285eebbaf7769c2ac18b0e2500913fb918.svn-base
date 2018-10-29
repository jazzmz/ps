USING Progress.Lang.*.

CLASS TDocument INHERITS TDoc 
                IMPLEMENTS IFinObj:

/**************************************************************
 * Класс является представлением сущности "Документ".
 * Предоставляет доступ к свойствам документа, а также к массиву,
 * входящих в него проводок.
 *
 * Автор: Маслов Д. А.
 * Дата создания: 25.04.2009
 * Дата модификации: 30.04.2009
 *
************************************/

  /*** PROTECTED ПОЛЯ КЛАССА ***/

 
  DEF PROTECTED BUFFER bOp FOR op.                                                                /* Таблица документов */
  DEF PROTECTED BUFFER bOpEntry FOR op-entry.                                                   /* Таблица проводок      */


  DEF PRIVATE VAR oBankBen AS TBank NO-UNDO.                                                                          /* Банк получателя, делам глобальной переменной, чтобы можно было уничтожить. Тяжело без сборщика мусора!!! */

  
 /*** PRIVATE  ПОЛЯ КЛАССА ***/

  DEFINE PRIVATE TEMP-TABLE DocOpEntry NO-UNDO                                                 /* Временная таблица для хранения объектов-проводок входящих в документ */
         FIELD iNum AS INTEGER
         FIELD iOrderNum AS INTEGER
         FIELD opentry AS CLASS Object
         INDEX iiNum IS PRIMARY iNum
         INDEX iiOrderNum iOrderNum
         .

 /*** PUBLIC СВОЙСТВА ДОКУМЕНТА ***/

{set-prop.i &aa="order-pay"             &bb="cOrder-Pay" &cc="INTEGER"}                                                        /* Очередность платежа */
{set-prop.i &aa="DocRecid"        &bb="iRecId" &cc="INTEGER" perms="PROTECTED"}                         /* RECID документа */
{set-prop.i &aa="OpEntryCount" &bb="iOpEntryCount" &cc="INTEGER" perms="PRIVATE"}                   /* Дата документа */
{set-prop.i &aa="sum"                      &bb="dDocSum" &cc="DECIMAL" perms="PRIVATE"}                                   /* Cумма документа */
{set-prop.i &aa="sum-in-val"  &bb="dDocSumVal" &cc="DECIMAL" perms="PRIVATE"}                                   /* Cумма документа в валюте документа */

{set-prop.i &aa="currency"    &bb="cCurrency"  &cc="CHARACTER" perms="PRIVATE" &init="\"\""}                                   /* Валюта договора */

{set-prop.i &aa="AcctPosInRub"             &bb="dAcctPosInRub" &cc="DECIMAL"}                                   /* позиция по счету в нац.валюте для счета в инвалюте после выполнения GetPos() */

{set-prop.i &aa="acct-db"              &bb="cacct-db" &cc="CHARACTER" }                                                           /* Счет по дебету     */
{set-prop.i &aa="acct-cr"              &bb="cacct-cr" &cc="CHARACTER" }                                                                   /* Счет по кредету    */
{set-prop.i &aa="acct-rcpt"              &bb="cacct-rcpt" &cc="CHARACTER"}                                                           /* Счет по кредету    */
{set-prop.i &aa="name-ben"              &bb="cname-ben" &cc="CHARACTER"}                                                   /* Счет получателя    */
{set-prop.i &aa="inn"                      &bb="cinn" &cc="CHARACTER"}                                                                           /* ИНН получателя    */

{set-prop.i &aa="ins-date"       &bb="dIns-date"      &cc="DATE"}                                                                           /* ИНН получателя    */
{set-prop.i &aa="doc-date"       &bb="dDoc-date"      &cc="DATE"}
{set-prop.i &aa="op-date"        &bb="dOp-date"       &cc="DATE"}
{set-prop.i &aa="op-value-date"  &bb="dop-value-date" &cc="DATE"}


{set-prop.i &aa="user-inspector" &bb="cuin"              &cc="CHARACTER"}
{set-prop.i &aa="doc-type"       &bb="cDocType"          &cc="CHARACTER"}  /* Тип документа */
{set-prop.i &aa="op-transaction" &bb="iop-transaction"   &cc="INTEGER"}  /* Тип документа */
{set-prop.i &aa="op-kind"        &bb="cop-kind"          &cc="CHARACTER"}  /* Тип документа */
{set-prop.i &aa="kau-db"         &bb="ckau-db"           &cc="CHARACTER"}  /* Тип документа */
{set-prop.i &aa="kau-cr"         &bb="ckau-cr"           &cc="CHARACTER"}  /* Тип документа */
{set-prop.i &aa="op"                                     &cc="INT64" perms="PROTECTED"}

DEF PRIVATE VAR dDoc-sum AS DECIMAL INITIAL 0 NO-UNDO.
DEF PUBLIC PROPERTY doc-sum AS DECIMAL
   GET:
      IF currency <> "" THEN RETURN sum-in-val. ELSE RETURN sum.
   END GET.
   SET (INPUT cProp AS DECIMAL):
      dDoc-Sum = cProp.
   END SET.

/*** PUBLIC  МЕТОДЫ ДОКУМЕНТА ***/

 CONSTRUCTOR PUBLIC TDocument():
  /*
      Пустой конструктор предполагаю использовать для изменения документа.
  */
 END CONSTRUCTOR.


  CONSTRUCTOR TDocument(INPUT iDocId AS INTEGER):
             /**********************************
              * Инициализируем документ        *
              **********************************/

       FIND FIRST bOp WHERE bOp.op=iDocId AND bOp.op-date<>? NO-LOCK NO-ERROR.

         DocRecid=RECID(bOp).
         
         IF AVAILABLE(bOp) THEN
           DO:
             fillOp(BUFFER bOp:HANDLE).            
           END.

 END.


 CONSTRUCTOR TDocument(INPUT iDocId AS INTEGER,INPUT dDate AS DATE):
      FIND FIRST bOp WHERE bOp.op=iDocId NO-LOCK NO-ERROR.


         DocRecid=RECID(bOp).
         
         IF AVAILABLE(bOp) THEN
           DO:
             fillOp(BUFFER bOp:HANDLE).            
           END.

 END CONSTRUCTOR.
 
 
 CONSTRUCTOR TDocument(INPUT iOpRecid AS RECID):
   /***
                Инициализируем объект-документ, по его RECID в базе.
    ***/
   
           DocRecid=iOpRecid.
           
           FIND FIRST bOp WHERE RECID(bOp)=iOpRecid AND bOp.op-date<>? NO-LOCK NO-ERROR.
           /* Инициализируем основные реквизиты документы */

              IF AVAILABLE(bOp) THEN
                 DO:

                     fillOp(BUFFER bOp:HANDLE). /* Заполняем реквизиты док-та */
                
                 END.
 END CONSTRUCTOR.

  CONSTRUCTOR TDocument(INPUT iOpRecid AS RECID,INPUT iDate AS DATE):

           DocRecid=iOpRecid.
           
           FIND FIRST bOp WHERE RECID(bOp)=iOpRecid NO-LOCK NO-ERROR.
           /* Инициализируем основные реквизиты документы */

              IF AVAILABLE(bOp) THEN
                 DO:

                     fillOp(BUFFER bOp:HANDLE). /* Заполняем реквизиты док-та */
                
                 END.

  END CONSTRUCTOR.

CONSTRUCTOR TDocument(INPUT bOpHandle AS HANDLE,INPUT initOpEntry AS LOG):
                                /*******************************************
                                 *                                         *
                                 * Инициализируем объект по записи из БД   *
                                 *                                         *
                                 *******************************************/

                 fillOp(bOpHandle,initOpEntry). /* Заполняем реквизиты док-та */
END CONSTRUCTOR.

METHOD PROTECTED VOID fillOp(INPUT bOpHandle AS HANDLE):
  fillOp(bOpHandle,TRUE).
END METHOD.

METHOD PROTECTED VOID fillOp(INPUT bOpHandle AS HANDLE,INPUT initOpEntry AS LOG):

          /*********************************
           * Функция заполнения основных   *
           * док-та.                       *
           **********************************/

           DEF VAR oOpEntry AS TOpEntry NO-UNDO.

            ClassType = "op".

          ASSIGN
                  doc-num        = bOpHandle::doc-num
		  user-inspector = bOpHandle::user-inspector
                  user-id        = bOpHandle::user-id
                  doc-id         = bOpHandle::op
                  details        = bOpHandle::details
                  order-pay      = INTEGER(bOpHandle::order-pay)
                  acct-rcpt      = bOpHandle::ben-acct
                  name-ben       = bOpHandle::name-ben
                  DocDate        = bOpHandle::op-date
		  op-date        = bOpHandle::op-date
		  op-value-date  = bOpHandle::op-value-date
                  inn            = bOpHandle::inn
                  Surrogate      = STRING(bOpHandle::op)
                  op             = bOpHandle::op
                  ClassCode      = bOpHandle::class-code              
		  ins-date       = bOpHandle::ins-date
		  doc-date       = bOpHandle::doc-date
		  doc-type       = bOpHandle::doc-type
		  doc-status     = bOpHandle::op-status
		  op-transaction = bOpHandle::op-transaction
		  op-kind	 = bOpHandle::op-kind
           .

            /*********
             * По заявке #3353 интересно не поломаю я ли чего???
             *********/

	    IF initOpEntry THEN
              DO:
                getAndFillOpEntry().       /* Получаем все проводки док-та */ 

                 /*
                 Заполняем реквизиты документа
                 по первой проводке документа.
                 Следует учитывать, что попадаются
                 случаи, когда в документе одна проводка,
                 но номер этой проводки (op-entry.op-entry) в документе
                 отличен единицы.
                 Например, в документе одна проводка,
                 а ее порядковый номер op-entry=2.
                 */
                 
                 
                 oOpEntry = getOpEntry4Order(1).
                 cacct-db = oOpEntry:acct-db.
                 cacct-cr = oOpEntry:acct-cr.
                 oOpEntry = ?.
              END.
                  
 END METHOD.
  
 METHOD PUBLIC CLASS TOpEntry getOpEntry4Order(INPUT iOrderNum AS INTEGER):
       /******************************************
        *                                        *
        * Метод возвращает проводку док-та       *
        * по порядковому номеру.                 *
        * Независимо от значение поля op-entry.  *
        *                                        *
        ******************************************/
 
   FIND FIRST DocOpEntry WHERE DocOpEntry.iOrderNum=iOrderNum NO-LOCK NO-ERROR.
   
   IF AVAILABLE(DocOpEntry) THEN
     DO:
         RETURN CAST(DocOpEntry.opentry,"TOpEntry").
     END. 
     
 END METHOD.
 
 METHOD PUBLIC CLASS TOpEntry getOpEntry(INPUT iNum AS INTEGER):
   /*** 
       Метод возвращает проводку с номером iId.
       Следует иметь ввиду, что под номером
       проводки понимается значение поля op-entry
       в таблице op-entry.
       Так, например, возможен случай, когда в документе
       одна проводка, а ее номер не единица, как ожидается,а
       например, два.
       Результатом является объект класса TOpEntry
    ***/
    
     FIND FIRST DocOpEntry WHERE DocOpEntry.iNum=iNum NO-LOCK.
      
     IF AVAILABLE(DocOpEntry) THEN
       DO:
         RETURN CAST(DocOpEntry.opentry,"TOpEntry").
       END.
 END METHOD.
 

/*** PRIVATE МЕТОДЫ КЛАССА ***/

   METHOD PROTECTED VOID getAndFillOpEntry():
        /***
             Метод инциализирует внутренний массив
             проводок.
        ***/
        DEF VAR iI           AS INTEGER INITIAL 0 NO-UNDO.
        DEF VAR tmpDocSumRub AS DECIMAL INITIAL 0 NO-UNDO.
        DEF VAR tmpDocSumVal AS DECIMAL INITIAL 0 NO-UNDO.
        DEF VAR tmpOpEntry   AS CLASS TOpEntry    NO-UNDO.

       FOR EACH bOpEntry WHERE bOpEntry.op=doc-id NO-LOCK:                                     

               tmpOpEntry=new TOpEntry(bOpEntry.op,bOpEntry.op-entry).

		ASSIGN
		  kau-db	 = tmpOpEntry:kau-db
		  kau-cr	 = tmpOpEntry:kau-cr
		.

               CREATE DocOpEntry.

                    ASSIGN
                           iNum = bOpEntry.op-entry
                           iOrderNum = iI + 1
                           DocOpEntry.opentry = tmpOpEntry
                     .
                                                    
                  iI=iI + 1.
                  /**
                   * Если хотя бы одна
                   * из проводок валютная,
                   * то и в целом документ считаем валютным.
                   **/
                  IF bOpEntry.currency NE "" THEN currency = bOpEntry.currency.

                  tmpDocSumRub = tmpDocSumRub + tmpOpEntry:rusSum.             
		  tmpDocSumVal = tmpDocSumVal + tmpOpEntry:inSum.
                  tmpOpEntry = ?.  /* Обнуляем ссылку на объект */
   
        END.      
       OpEntryCount = iI.
       sum = tmpDocSumRub.
	   sum-in-val = tmpDocSumVal.
   END METHOD.

METHOD PUBLIC LOGICAL add2DB():

END METHOD.

METHOD PUBLIC LOGICAL update2DB():

END METHOD.

METHOD PUBLIC DECIMAL getPos (INPUT cAcct AS CHARACTER):
        /**********************************************
         *                                            *
         * Возвращает остаток с учетом                *
         * всех за исключением удаленных документов.  *
         *                                            *
         **********************************************/
        RETURN getPos(cAcct,"").
END METHOD.

METHOD PUBLIC DECIMAL getPos (INPUT cAcct AS CHARACTER,INPUT cStatus AS CHARACTER):      
   /************************************************************
    *                                                           *
    * Функция возвращает остаток по счету                      *
    * cAcct. Предполагается, что последний                     *
    * документ по данному счету был с ID OP                    *
    * Пока не могу продумать, как поведет себя                 * 
    * фукция в случае переноса документов из дня               *
    * в день.                                                  *
    * По сути дела функция отображает остаток                  *
    * по счету cAcct на документ OP (с учетом                  *
    * этого же документа).                                     *
    ************************************************************                                                  
    *                                                          *
    * Учитывает документы только в статусе cStatus.            *
    * При этом сам документ учитывается независимо от статуса. *
    *                                                          *
    ************************************************************/

   DEF VAR dSum             AS DECIMAL INITIAL 0 NO-UNDO.                /* Содержит остаток по счету */
   DEF VAR dLastPosDate     AS DATE              NO-UNDO.                        /* Дата последнего закрытого операционного дня на который есть остаток */
   DEF VAR cPosDir          AS CHARACTER         NO-UNDO.                        /* Направление в котором счет участвует в проводке */
   DEF VAR oAcct            AS CLASS TAcct       NO-UNDO.                        /* Объект счет */
   DEF VAR oSysClass        AS CLASS TSysClass   NO-UNDO.       /* Объект-набор системных утилит  */
   DEF VAR dSumOpEntryWSign AS DECIMAL INITIAL 1 NO-UNDO.

   DEF VAR prihod AS Decimal INITIAL 0 NO-UNDO.
   DEF VAR rashod AS Decimal INITIAL 0 NO-UNDO.

   DEF VAR prihodRub AS Decimal INITIAL 0 NO-UNDO.
   DEF VAR rashodRub AS Decimal INITIAL 0 NO-UNDO.
   DEF VAR dSumRub   AS Decimal INITIAL 0 NO-UNDO.

    oSysClass = new TSysClass().   
    oAcct=new TAcct(cAcct).            

    dSum = oAcct:getBegPos(DocDate,dLastPosDate).
    dSumRub = oAcct:getRurPos(DocDate,dLastPosDate).
     /*
       Поехали по проводкам, которые были совершенны
       по указанным счетам, раньше переданной.       
     */
     /* ВНИМАНИЕ! 
        В СЛУЧАЕ ИСПОЛЬЗОВАНИЕ ИНДЕКСОВ ABL думает, что
        дата "" > dLastPosDate имеено для этого в запросе
        необходимо условие bOpEntry.op-date<>?
        
        ВНИМАНИЕ!
          Полагаю, что будет разумных перенести нижлещащий
          кусок кода в класс TOpEntry.
     */


FOR EACH bOpEntry WHERE (bOpEntry.acct-db=oAcct:acct)
                                                     AND bOpEntry.op-date>dLastPosDate 
                                                     AND bOpEntry.op-date<>? 
                                                     AND bOpEntry.op-date<=docdate
                                                     AND (bOpEntry.op-status>=cStatus OR bOpEntry.op=doc-id):

                IF oAcct:activity = "П" then 
                  do:
                     if bOpEntry.op <=doc-id THEN
                         do: 
                           IF oAcct:val=810 OR oAcct=? THEN rashod = rashod + bOpEntry.amt-rub.
                           ELSE DO:
                                rashod = rashod + bOpEntry.amt-cur.
                                rashodRub = rashodRub + bOpEntry.amt-rub.
                                end.
                         end.         
                     end.
    
                
                IF oAcct:activity = "А" then 
                  do:
                    if cacct-db = oAcct:acct then
                     do:
                       if bOpEntry.op <=doc-id THEN
                         do: 
                             IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                           ELSE DO:
                                   prihod = prihod + bOpEntry.amt-cur.
                                   prihodRub = prihodRub + bOpEntry.amt-rub.
                                end.
                         end.         
                     end. 
                      else
                     do:
                          IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                        ELSE DO:
                                prihod = prihod + bOpEntry.amt-cur.
                                prihodRub = prihodRub + bOpEntry.amt-rub.
                             END.        
                     end.
                  end.
      end.



     
FOR EACH bOpEntry WHERE (bOpEntry.acct-cr=oAcct:acct)
                                                     AND bOpEntry.op-date>dLastPosDate 
                                                     AND bOpEntry.op-date<>? 
                                                     AND bOpEntry.op-date<=docdate
                                                            AND (bOpEntry.op-status>=cStatus OR bOpEntry.op=doc-id):

                IF oAcct:activity = "П" then 
                  DO:
          
                    if cacct-cr = oAcct:acct then 
                     do:
                       if bOpEntry.op <= doc-id THEN
                         do: 
                              IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                           ELSE DO:
                                   prihod = prihod + bOpEntry.amt-cur.
                                   prihodRub = prihodRub + bOpEntry.amt-rub.
                                END.
                         end.         
                     end.
                     else
                     do:
                        IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                        ELSE DO:
                                prihod = prihod + bOpEntry.amt-cur.        
                                prihodRub = prihodRub + bOpEntry.amt-rub.
                             END.
                     end.
                end.
        
                IF oAcct:activity = "А" then 
                  do:
                     if bOpEntry.op <=doc-id THEN
                       do: 
                          IF oAcct:val=810 OR oAcct=? THEN rashod = rashod + bOpEntry.amt-rub.
                          ELSE DO:
                                  rashod = rashod + bOpEntry.amt-cur.
                                  rashodRub = rashodRub + bOpEntry.amt-rub.
                               END.
                       end.         
                  end.
                
      end.

      IF (oAcct:activity = "А" and cacct-db = oAcct:acct) OR (oAcct:activity = "П" AND cacct-cr = oAcct:acct) then 
          do: 
             dSum = dSum + prihod.  
             dAcctPosInRub = dSumRub + prihodRub.        
          end.
      else
          do: 
             dSum = dSum - rashod + prihod.
                dAcctPosInRub = dSumRub - rashodRub + prihodRub.        
          end.
      delete object oSysClass.
      delete object oAcct.        
      RETURN dSum.   
END METHOD.

/**
 * Метод возвращает объект банка получателя.
 * @return TBank
 **/
METHOD PUBLIC TBank getBankBen():
                                /******************************************************
                                 *                                                      *
                                 * Метод возвращает объект банка получателя           *
                                 *                                                      *
                                 ******************************************************/
     FIND FIRST op-bank WHERE op-bank.op = doc-id NO-LOCK NO-ERROR.
     IF AVAILABLE(op-bank) THEN
       DO:
         oBankBen = new TBank(op-bank.bank-code,THIS-OBJECT:DocDate).
         oBankBen:corr-acct = op-bank.corr-acct.
       END.
          ELSE
            DO:
                RETURN ?.
            END.
     RETURN oBankBen.

END METHOD.

/******************************************************
 *                                                    *
 * Метод проверяет возможность проведения документа,  *
 * по указанному счету.                               *
 * Если провести нельзя, то в ошибки добавляем        *
 * информацию по ошибке.			      *
 *                                                    *
 ******************************************************/
METHOD PUBLIC LOGICAL isCanTake(INPUT oAcct AS TAcctBal):

	DEF VAR oSysClass AS TSysClass NO-UNDO.
	DEF VAR hCalc     AS OBJECT    NO-UNDO.

	DEF VAR dBegPos   AS DECIMAL   NO-UNDO.
	DEF VAR dDiff     AS DECIMAL   NO-UNDO.

	DEF VAR dDate AS DATE    NO-UNDO.

	DEF VAR lRes AS LOGICAL INITIAL TRUE.

	DEF VAR cPirRsv2TrDwnSt AS CHARACTER NO-UNDO.
	DEF VAR key        AS CHARACTER 	     NO-UNDO.
	DEF VAR val        AS CHARACTER 	     NO-UNDO.
	DEF VAR classError AS CHARACTER INITIAL "ОшибкаОстатка" NO-UNDO.

/**************************************
Получили дату последнего открытого дня
***************************************/

oSysClass = new TSysClass().

dDate=oSysClass:getLastOpenDate().


	cPirRsv2TrDwnSt = oSysClass:getSetting("PirChkOp","PirRSv2TrDwnSt","!*").


			  /**************************************************
			   * Если транзакция доверенная, то в ней           *
			   * уже учитывается приход в более низком статусе  *
			   * поэтому исключаем его из повторного рассчета.  *
			   * Например, транзакция быстрой почты.
			   *   Эта проверка позволяет сделать приход и расход
			   * одновременно, и только потом его подтвердить.
			   **************************************************/

				  IF NOT CAN-DO(cPirRsv2TrDwnSt,op-kind) THEN DO:
		                  	dDiff = oAcct:calcOborot(op-transaction).
				  END.
			 ELSE dDiff = 0.

	          	oAcct:getPos2DateWError(dDate,"*",dBegPos,hCalc).

		        {foreach hCalc key val}

		           dBegPos = dBegPos + DECIMAL(val).


		
			   /***** 
			    *
			    * Вычленяем случай, когда
			    * несколько документов созданы
			    * одной транзакцией.
			    * Тогда приход может не быть в более
			    * низком статусе.
			    *
			    ******/

				IF DATE(key) EQ DocDate THEN DO:
				     IF (dBegPos + dDiff) < 0 THEN DO:
					     addError("535","По счету " + oAcct:acct + ". \n На дату: " + key + " На cумму:" + STRING(dBegPos),classError).
					lRes = FALSE.
			        END.
				
			     dBegPos = MAXIMUM(dBegPos,0).

                        END.
			ELSE DO:
			    IF dBegPos < 0 THEN DO:
					     addError("535","По счету " + oAcct:acct + ". \n На дату: " + key + " На cумму:" + STRING(dBegPos),classError).
					lRes = FALSE.
			    END.
			END.

		  	{endforeach hCalc}

 		   DELETE OBJECT hCalc.
 
 DELETE OBJECT oSysClass.
 RETURN TRUE.

END METHOD.

/*********************************
 * @param direct Направление проведения док-та = {up,down,?}.
 * @return logical
 * Метод проверяет приводит ли
 * документ к красному сальдо по
 * какому либо счету.
 *********************************/
METHOD PUBLIC LOGICAL isCanTake(INPUT direct AS CHARACTER):
	 /**********************************************
          * Функция производит проверку на     	       *
	  * наличие красного сальдо                    *
	  * по счетам документа.                       *
	  **********************************************/




/**** НАЗВАНИЕ ДОП. РЕКВИЗИТА ОТКЛЮЧАЮЩЕГО ПРОВЕРКУ ***/

DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR oDocument AS TDocument NO-UNDO.
DEF VAR oAcct-Db  AS TAcctBal  NO-UNDO.
DEF VAR oAcct-Cr  AS TAcctBal  NO-UNDO.


DEF VAR i     AS INTEGER NO-UNDO.

DEF VAR OpEntryCurrency AS CHARACTER NO-UNDO.
DEF VAR OpEntryAcctDb   AS CHARACTER NO-UNDO.
DEF VAR OpEntryAcctCr   AS CHARACTER NO-UNDO.


DEF VAR lResult AS LOGICAL INITIAL TRUE NO-UNDO.


oSysClass = new TSysClass().



 /***********************************
 * Просматриваем все счета документа
 ************************************/

  DO i = 1 TO OpEntryCount:

   /****************************************
     * Следующий кусок кода
     * необходим при проверки
     * полупроводок, так как в этом
     * случае один из счетов будет ?
    ***************************************/

  OpEntryCurrency = getOpEntry4Order(i):currency.
  OpEntryAcctDb   = getOpEntry4Order(i):acct-db.
  OpEntryAcctCr   = getOpEntry4Order(i):acct-cr.

   IF OpEntryAcctDb <> ? THEN DO:
	    oAcct-Db = new TAcctBal(OpEntryAcctDb).

	/****************************************
	 * Если это проводка прихода,           *
	 * и разрешено приход проводить         *
	 * несмотря на красное сальдо,          *
	 * то проверку пропускаем.              *
	 *					*
	 *        !!! ВНИМАНИЕ !!!              *
         * Следует учесть, что если док-т       *
	 * откатывается, то проверку выполнять  *
	 * необходимо!				*
	 ****************************************/

	IF NOT (isUpPos(getOpEntry4Order(i),oAcct-db) AND LOGICAL(oSysClass:getSetting("PirChkOp","PirRedSaldoV2Up","FALSE")) AND direct="up") THEN DO:

               /*****************
	        * Если по счету
	        * нет разрешения на красное
	        * сальдо
	        *****************/
	      IF NOT oAcct-Db:isRSPMD THEN DO:

	         /****************
	          * Если счет привязан
	          * к овердрафту, и включен
                  * НП разрешить КС по овердтрафтам,
                  * то проверку пропускаем.
	          ****************/

		  IF NOT (oAcct-Db:isLnkOverLoan() AND LOGICAL(oSysClass:getSetting("PirChkOp","isOvrRSPermit","NO"))) THEN DO:
			lResult = isCanTake(oAcct-Db).
		  END. /* IF isLnkOver */
              END.  /* IF NOT oAcct-Db:isRSPMD THEN */
           END. /* IF NOT isUpPos ... */

       DELETE OBJECT oAcct-Db.
      END.   /* IF opEntryAcctDb <> ?  */

   IF OpEntryAcctCr <> ? THEN
	DO:
	    oAcct-Cr = new TAcctBal(OpEntryAcctCr).

    	   IF NOT (isUpPos(getOpEntry4Order(i),oAcct-cr) AND LOGICAL(oSysClass:getSetting("PirChkOp","PirRedSaldoV2Up","FALSE")) AND direct="up") THEN DO:

	     IF  NOT oAcct-Cr:isRSPMD THEN
	      DO:
	         /****************
	          * Если счет привязан
	          * к овердрафту, и включен
                  * НП разрешить КС по овердтрафтам,
                  * то проверку пропускаем.
	          ****************/
		  IF NOT (oAcct-Cr:isLnkOverLoan() AND LOGICAL(oSysClass:getSetting("PirChkOp","isOvrRSPermit","NO"))) THEN DO:
			lResult = isCanTake(oAcct-Cr).
		  END. /* IF isLnkOver */
	       END.     /* IF oAcct-Cr:isRSPMD */
	     END.  /* IF NOT isUpPos ... */

	   DELETE OBJECT oAcct-Cr.
	END. /* IF opEntryAcctCr */
END.          /* Конец по проводкам */
/************ КОНЕЦ ДЛЯ УЧЕТА ПОЛУПРОВОДОК ******************/
 RETURN lResult.
END METHOD.



  /********************************
   *
   * @result character
   * Возвращает номер договора к которому
   * привязан счет.
   *
   ********************************/

METHOD PUBLIC CHARACTER getLnkLoanNum():
	 /*****************
          * Предполагаем, что проводка,
	  * привязана только к одному договору.
	  *****************/
   DEF VAR docnum AS CHARACTER NO-UNDO.

	 IF {assigned kau-db} THEN DO:
	    docnum = ENTRY(2,kau-db).			
	 END.

	 IF {assigned kau-cr} THEN DO:
	    docnum = ENTRY(2,kau-cr).			
	 END.

  RETURN docnum.

END METHOD.


/*******************************
 *
 * @param opEntry TOpEntry проводка
 * @param oAcct TAcct 20ти значный номер счета
 * @result LOGICAL  Возвращает TRUE, если док-т
 * увеличивает остаток по счету oAcct, иначе FALSE.
 * Для счета без типа возвращает ?.
 *
 ********************************/

METHOD PROTECTED LOGICAL isUpPos(INPUT opentry AS TOpEntry,INPUT oAcct AS TAcct):
     CASE oAcct:activity:
           WHEN "А" THEN DO:
		IF opentry:acct-db EQ oAcct:acct THEN RETURN TRUE.
		ELSE RETURN FALSE.
	   END.   
	   WHEN "П" THEN DO:
		IF opentry:acct-cr EQ oAcct:acct THEN RETURN TRUE.
		ELSE RETURN FALSE.
	   END.	   
     END CASE.
   RETURN ?.
END METHOD.

/**
 *
 * Документ принадлежит взаимозависимому лицу в случае
 * если счет по ДБ или счет по КР или получатель 
 * денежных средств (лицо из name-ben) являются взаимозависимыми 
 * на дату совершения операции.
 * 
 **/
METHOD PUBLIC LOG isBelongToDepended():

    DEF VAR oClient     AS TClient            NO-UNDO.
    DEF VAR lRes        AS LOG     INIT FALSE NO-UNDO.



  FOR EACH bOpEntry WHERE bOpEntry.op EQ INT64(THIS-OBJECT:surrogate) NO-LOCK:
              oClient = NEW TClient(bOpEntry.acct-db).
                lRes  = lRes OR oClient:isDepended(THIS-OBJECT:DocDate).
              DELETE OBJECT oClient.
                   
              oClient = NEW TClient(bOpEntry.acct-cr).
                lRes  = lRes OR oClient:isDepended(THIS-OBJECT:DocDate).
              DELETE OBJECT oClient.

    IF lRes THEN LEAVE.

  END.
  
 RETURN lRes.

END METHOD.

/**
 * Является ли документ
 * валютным?
 **/
METHOD PUBLIC LOG isValute():
 RETURN IF currency <> "" THEN TRUE ELSE FALSE.
END METHOD.

/***
 *
 * Является ли документ конверсионным.
 *
 ***/
METHOD PUBLIC LOG isExchange():
   DEF VAR i AS INT NO-UNDO.

   DO i = 1 TO THIS-OBJECT:OpEntryCount:
       IF THIS-OBJECT:getOpEntry4Order(i):isHalf() OR NOT THIS-OBJECT:getOpEntry4Order(i):hasEqualVal() THEN RETURN TRUE.
   END.

 RETURN FALSE.

END METHOD.

/**
 * Метод возвращает клиента
 * которому принадлежит документ.
 * @return TClient
 **/
METHOD PUBLIC TClient getClient():
         
END METHOD.

/**
 * Метод возвращает суррогаты
 * связанных с документов
 * документов.
 * @return TAArray
 **/

METHOD PUBLIC TAArray getLnkDocs():

DEF VAR oAArray AS TAArray NO-UNDO.

DEF BUFFER op    FOR op.
DEF BUFFER links FOR links.
DEF BUFFER xlink FOR xlink.

oAArray = NEW TAArray().

/**
 * Связанные по 1ому типу.
 **/

FOR EACH op WHERE op.op-transaction EQ THIS-OBJECT:op-transaction
			AND op.op NE THIS-OBJECT:op
			AND op.op-status GT "А" NO-LOCK:
   oAArray:push(op.op).
END. /* FOR EACH */

/**
 * Связанные по 2ому типу
 **/
FOR EACH links WHERE links.source-id EQ STRING(THIS-OBJECT:op)
                  OR links.target-id EQ STRING(THIS-OBJECT:op) NO-LOCK,
  FIRST xlink WHERE links.link-id EQ xlink.link-id AND xlink.link-code EQ "PirLnkCom" NO-LOCK:
   oAArray:push((IF links.source-id EQ STRING(THIS-OBJECT:op) THEN links.target-id ELSE links.source-id)).
END.

 RETURN oAArray.
END METHOD.


/***
 * СТОРНО-документ ?
 ***/
METHOD PUBLIC LOG isSTORNO():
 RETURN IF details MATCHES "*СТОРНО*" THEN TRUE ELSE FALSE.
END METHOD.


/***
 * Есть ли в документе клиентский счет
 ***/
METHOD PUBLIC LOG isDocumClientAcct():
   DEF VAR i       AS INT     NO-UNDO.
   DEF VAR dbAcct   AS TAcct   NO-UNDO.
   DEF VAR crAcct   AS TAcct   NO-UNDO.

   DO i = 1 TO THIS-OBJECT:OpEntryCount:
       dbAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-db).
       crAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-cr).

       IF  dbAcct:isClient()  OR  crAcct:isClient()  
         THEN DO:
            DELETE OBJECT dbAcct.
            DELETE OBJECT crAcct.
            RETURN TRUE.
         END.
   END.

 DELETE OBJECT dbAcct.
 DELETE OBJECT crAcct.
 RETURN FALSE.

END METHOD.




DESTRUCTOR PUBLIC TDocument():
    /************************************
     * Я тебя порадил, я тебя и убью!   *
     ************************************/
     
     FOR EACH DocOpEntry NO-LOCK:
      DELETE OBJECT DocOpEntry.opentry.     
     END.
     EMPTY TEMP-TABLE DocOpEntry.
    DELETE OBJECT oBankBen NO-ERROR.
END DESTRUCTOR.
END CLASS.