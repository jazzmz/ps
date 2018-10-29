USING Progress.Lang.*.

/**
 *
 * Сущность лицевой счет.
 * @author Маслов Д. А. Maslov D. A.
 *
 **/
CLASS TAcct INHERITS TBase IMPLEMENTS IFinObj:
/***********************************************************
 * Класс является представлением сущености бухгалтерский   *
 * счет.                                                   *
 * Автор: Маслов Д. А.                                     *
 * Дата создания: 12.05.2009                               *
 ************************************************************/

 /*** PROTECTED ***/





  DEF PRIVATE BUFFER bAcct FOR acct.             /* Таблица со счетами */
  DEF PRIVATE BUFFER bAcct-pos FOR acct-pos.     /* Таблица остатков по счетам */
  DEF PRIVATE BUFFER bAcct-Cur FOR acct-cur.
  DEF VAR lRAISE_ERROR AS LOGICAL INITIAL false NO-UNDO.

  DEF PRIVATE VAR dbMove AS DECIMAL INITIAL 0 NO-UNDO.                        /* Движение по дебету */
  DEF PRIVATE VAR crMove AS DECIMAL INITIAL 0 NO-UNDO.                        /* Движение по кредиту */

  DEF PRIVATE VAR lisRSPMD AS LOGICAL INITIAL FALSE NO-UNDO.			 /* Разрешено ли красное сальдо по счету */

 /*********************************** 
  * Определяем временные таблицы   *
  * для рассчета остатка с ошибкой *
  ***********************************/

  {tacct.def}							     


  
                  
 /*** PUBLIC ***/ 
{set-prop.i  &aa="rubPos"     &bb="dRubPos"     &cc="DECIMAL"}                              /* Остаток по счету в рублях   */
{set-prop.i  &aa="valPos"     &bb="dValPos"     &cc="DECIMAL"}                                /* Остаток по счету в валюте  */
{set-prop.i  &aa="user-id"    &bb="cuser-id"    &cc="CHARACTER"}                          /* Ответственный за счет                */
{set-prop.i  &aa="val"        &bb="cval"        &cc="INTEGER"}                                            /* Валюта счета                                */
{set-prop.i  &aa="acct"       &bb="acct-id"     &cc="CHARACTER"}                                  /* Номер счета                                */
{set-prop.i  &aa="activity"   &bb="cActivity"   &cc="CHARACTER"}                         /* Счет активный/пассивный */
{set-prop.i  &aa="name-short" &bb="cname-short" &cc="CHARACTER"}             /* Название счета */

{set-prop.i  &aa="clSurrogate" &bb="cClSurrogate" &cc="CHARACTER"}            /* Тип владельца счета */
{set-prop.i  &aa="open-date"   &bb="dOpenDate"    &cc="DATE"}                                /* Дата открытия счета */
{set-prop.i  &aa="details"     &bb="cDetails"     &cc="CHARACTER"}                             /* Название счета */
{set-prop.i  &aa="type"        &bb="cType"        &cc="CHARACTER"}                                    /* Тип владельца счета */
{set-prop.i  &aa="id"          &bb="iId"          &cc="INTEGER"}                                                   /* Тип владельца счета */

{set-prop.i  &aa="contr-acct" &bb="cContrAcct" &cc="CHARACTER"  &init="?"}  	/* Парный счет для указанного */
{set-prop.i  &aa="contract"   &bb="cContract"  &cc="CHARACTER"  &init="?"}  	/* Назначение счета */
{set-prop.i  &aa="bal-acct"   &bb="iBal-acct"  &cc="INTEGER"    &init="?"}	/* Балансовый счет */
{set-prop.i  &aa="tKau-id"    &bb="ctKau-id"   &cc="CHARACTER"  &init="?"}	/* Кау ID из таблицы */

{set-prop.i  &aa="currency"   &cc="CHAR"  &init="?"}

/***/
{set-prop.i  &aa="cust-cat"   &cc="CHAR"}
{set-prop.i  &aa="cust-id"    &cc="INT64"}
{set-prop.i  &aa="close-date" &cc="DATE"}


 DEFINE PUBLIC PROPERTY RAISE_ERROR AS LOGICAL
   GET:
      RETURN lRAISE_ERROR.
   END GET.
                                             
   PROTECTED SET (INPUT cProp AS LOGICAL):
      lRAISE_ERROR=cProp.
   END SET.


DEF PUBLIC PROPERTY isRSPMD AS LOGICAL
   GET:
			/*********************************************************
			 *										     *
			 * isRSPMD - isRedSaldoPermitMiddleDay		     *
			 *										     *
			 *********************************************************
			 * Считается, что красное сальдо допускается	     *
			 * в следующих случаях:					     *
			 *   1.  На счете явно установлено разрешение;	     *
			 *   2.  Счет парный;						     *
			 *   3. Счет без признака знака.				     *
			 *										     *
			 *********************************************************/
		IF getXAttr("СКонСальдо") = "Предупреждение" OR CAN-FIND(acct WHERE acct.acct=contr-acct) OR  activity = "АП"  OR activity = "-" THEN RETURN TRUE.	
		RETURN lisRSPMD.
   END GET.
   PROTECTED SET(INPUT cProp AS LOGICAL):
		lisRSPMD = cProp.
   END SET.     


DEF PUBLIC PROPERTY kau-id AS CHARACTER
GET():
  /************************
   * Сведения о шаблоне
   * кау может хранится, 
   * 1. В реквизите kau-id балансового счета;
   * 2. В реквизите kau-id лицевого счета;
   * 3. В таблице acct-kau-id.
   ************************/
   FIND FIRST acct-kau-id WHERE acct-kau-id.acct=acct NO-LOCK NO-ERROR.

      IF AVAILABLE(acct-kau-id) THEN DO:
	RETURN acct-kau-id.kau-id.
      END.
      ELSE DO:
	IF tKau-id NE ? THEN DO:
	  RETURN tKau-id.
	END.
	ELSE
	  DO:
	   FIND FIRST bal-acct WHERE bal-acct.bal-acct EQ bal-acct NO-LOCK NO-ERROR.
		   IF AVAILABLE(bal-acct) THEN DO:
		       RETURN bal-acct.kau-id.
		   END.   
	  END. /*tKau-id NE ? */
       END. /*available(acct-kau-id)*/
 RETURN ?.
END GET.  
PROTECTED SET(INPUT cProp AS CHARACTER):

END SET.  

DEF PROTECTED TEMP-TABLE acctPos NO-UNDO LIKE acct-pos
				 INDEX pk IS PRIMARY since.

 CONSTRUCTOR TAcct():

 END CONSTRUCTOR.

 CONSTRUCTOR TAcct(INPUT cAcct AS CHARACTER):
    /********************************
     *                              *
     * Конструктор по номеру счета  *
     *                              *
     ********************************/
	
     acct=REPLACE(cAcct,"-","").
     getValByAcct().
 END CONSTRUCTOR.

 /**********
  * @var CHARACTER cContract  Тип договора {Кредит,Депоз}
  * @var CHARACTER cCont-Code Номер договора
  * @var CHARACTER cRol       Роль счета
  * @var DATE      dDate      Дата на которую требуется получить счет
  **********
  * Инициализирует счет по договору и роли
  ***********/
 CONSTRUCTOR TAcct(INPUT cContract AS CHARACTER,INPUT cCont-Code AS CHARACTER,INPUT cRole AS CHARACTER,INPUT dDate AS DATE):

    /************
     * Ожидаю, что скоро появится
     * возможность выкидывания исключений.
     ************/
    FIND FIRST loan-acct WHERE     loan-acct.contract  = cContract
			       AND loan-acct.cont-code = cCont-Code
			       AND loan-acct.acct-type = cRole
			       AND loan-acct.since    <= dDate NO-LOCK NO-ERROR.
	IF AVAILABLE(loan-acct) THEN DO:
		getValByAcct(loan-acct.acct).	
        END.
        ELSE DO:

        END.
 END CONSTRUCTOR.


 /**
  * @var HANDLE hAcct указатель на таблицу acct
  *
  **/
 CONSTRUCTOR TAcct(INPUT hAcct AS HANDLE):
   getValByAcct(hAcct).
 END CONSTRUCTOR.



 METHOD PUBLIC LOGICAL add2DB():

    RETURN TRUE.
 END METHOD.
  
 METHOD PUBLIC LOGICAL update2DB():

 END METHOD.
 
 METHOD PRIVATE DECIMAL calcPos():
   /*************************************
    *                                   *
    * Считаем остаток на сегодняшний день. *
    *************************************/
   calcPos(TODAY). 
 END METHOD.

/**********
 * Не знаю как разименовать
 * свойство класса и 
 * значение буффера.
 * приходится делать вот такой
 * костыль.
 * :-(
 **********/
METHOD PRIVATE VOID getValByAcct(INPUT cAcct AS CHARACTER):
  acct = cAcct.
  getValByAcct().
END METHOD.

METHOD PRIVATE VOID getValByAcct(INPUT hAcct AS HANDLE):

      ASSIGN
       cActivity  = hAcct::side
       name-short = hAcct::details
       details    = hAcct::details
       cust-cat   = hAcct::cust-cat
       contr-acct = hAcct::contr-acct
       contract   = hAcct::contract
       bal-acct   = hAcct::bal-acct
       tKau-id	  = hAcct::kau-id
       close-date = hAcct::close-date
       acct       = hAcct::acct
       cust-id    = hAcct::cust-id
       currency   = hAcct::currency
      .

       THIS-OBJECT:val = INTEGER(SUBSTR(hAcct::acct,6,3)) NO-ERROR.


       IF ERROR-STATUS:ERROR THEN
          DO: 
             /* 
               Депозитные счета
               чего с ними делать
               пока не знаю.
             */
          END.
       dOpenDate = DATE(hAcct::open-date).
       cDetails  = hAcct::details.
       cType     = hAcct::cust-cat.
       iId       = hAcct::cust-id.

       ClassType = "acct".
       ClassCode = hAcct::Class-Code.
       Surrogate = hAcct::acct + ",".
       IF THIS-OBJECT:val <> 810 THEN THIS-OBJECT:Surrogate = THIS-OBJECT:acct + "," + STRING(THIS-OBJECT:val).

	/**************************
	 * Если счет внутренний,  *
	 * то cust-id = ?         *
	 * ? + Строка = ?         *
         **************************/
       THIS-OBJECT:clSurrogate = hAcct::cust-cat + "," + (IF STRING(hAcct::cust-id) EQ ? THEN "" ELSE STRING(hAcct::cust-id)).



END METHOD.

METHOD PRIVATE VOID getValByAcct():
  /********************************************************
    * Инициализируем свойства счета                       *
    *******************************************************/
   FIND FIRST bAcct WHERE bAcct.acct=acct NO-LOCK NO-ERROR.
   IF AVAILABLE(bAcct) THEN
     DO:
        getValByAcct(BUFFER bAcct:HANDLE).
     END.     
END METHOD.

METHOD PUBLIC DECIMAL getRurPos(INPUT cBegDate AS DATE,OUTPUT dLastPosDate AS DATE):
    /*****************************************
     *                                                                                     *
     * Возвращает рублевый остаток счета           *
     *                                                                               *
     *****************************************/
    RETURN getBegPosInVal(810,cBegDate,dLastPosDate).
END METHOD.

METHOD PUBLIC DECIMAL getBegPos(INPUT cBegDate AS DATE,OUTPUT dLastPosDate AS DATE):
    /*****************************************
     *                                       *
     * Возвращает остаток в валюте для счета *
     * в той валюте в которой он есть        *
     *                                       *
     *****************************************/   
   RETURN getBegPosInVal(val,cBegDate,dLastPosDate).
END METHOD.

METHOD PRIVATE DECIMAL getBegPosInVal(INPUT acctVal AS INTEGER,INPUT cBegDate AS DATE,OUTPUT dLastPosDate AS DATE):
   /***************************************************** *
    * Функция возвращает начальный остаток                *
    * Полагаю, что аргумент dLastPosDate можно            *
    * перенести в свойства класса, но пока еще не уверен. *
    * Функция находит как валютный так и рублевый остаток.*
    *******************************************************/
       DEF VAR oSysClass      AS TSysClass NO-UNDO.                        /* Подключаем библиотеку с служебными функциями */
       DEF VAR cQuery         AS CHARACTER NO-UNDO.
       DEF VAR dLastCloseDate AS DATE      NO-UNDO.
       DEF VAR hBuffer        AS HANDLE    NO-UNDO.
       DEF VAR dRes           AS DECIMAL   NO-UNDO.
       
      oSysClass = new TSysClass().

       dLastCloseDate = DATE(oSysClass:getLastCloseDate(cBegDate)).


              
       cQuery="WHERE <TableWithPos>.acct=" + QUOTER(acct-id) + " AND <TableWithPos>.since<=" + QUOTER(cBegDate).

       /* 
         Формируем запрос с учетом валюты
       */

       IF acctVal EQ ? OR acctVal = 810 THEN
         DO:
          hBuffer= BUFFER bAcct-pos:HANDLE.
          cQuery=REPLACE(cQuery,"<TableWithPos>","bAcct-Pos"). 
         END.
         ELSE
          DO:
           hBuffer=BUFFER bAcct-Cur:HANDLE.                     
           cQuery=REPLACE(cQuery,"<TableWithPos>","bAcct-Cur").      
          END.
         
          hBuffer:FIND-LAST(cQuery,NO-LOCK) NO-ERROR.
          
          IF hBuffer:AVAILABLE THEN
            DO:               
               /****************************************
		*                                      *
		* В таблице acct-pos хранится          *
		* остаток на дату в которой было       *
		* движение, поэтому возвращаем         *
		* максимальное из последнего закрытого *
		* дня или найденного в таблице         *
		* acct-pos.			       *
	        ****************************************/
              dLastPosDate=MAXIMUM(dLastCloseDate,hBuffer:BUFFER-FIELD("since"):BUFFER-VALUE).
              dRes = ABS(DECIMAL(hBuffer:BUFFER-FIELD("balance"):BUFFER-VALUE)).
            END.
            ELSE
              DO:
                /* Остаток не нашли */
		dLastPosDate = MINIMUM(dLastCloseDate,cBegDate - 1).
                dRes = 0.
              END.

DELETE OBJECT oSysClass.

RETURN dRes.
END METHOD.
 

METHOD PRIVATE VOID calcPos(INPUT dDate AS DATE):

   /***********************************
    *                                 *
    *  Считаем остаток на указанную   *
    * дату.                           *
    * Учитываем акцептованные док-ты. *
    *                                 *
    ***********************************/
    
   DEF VAR tmpPosSum AS DECIMAL INITIAL 0 NO-UNDO.
   
END METHOD.

METHOD PUBLIC DECIMAL getPos2DateVVK(INPUT dDate AS DATE,INPUT cStatus AS CHARACTER):
						/*************************************************************
						 * Метод возвращает РУБЛЕВЫЙ ОСТАТОК по счету!  *
						 * 1. Если счет рублевый, то будет возвращен обычный
						 * остаток на конец дня.
						 * 2. Если счет валютный:
						 *    2.1.  Будет получен валютный остаток на начало дня;
						 *    2.2. Валютный остаток умножим на курс ЦБ на этот
						 *   день; Если курс не установлен, то в качестве значения
						 * будет установлена 1.
						 *    2.3. Валютный остаток умножим на значение курса;
						 *    Получим рублевый эквивалент с учетом переоценки
						 * (даже если переоценка не проводилась).
						 *   2.4 Из рублевого эквивалента будем вычитать
						 * сумму валютных операций по счету в рублях.
						 *
						 * ПРИМЕЧАНИЕ: Если метод будет применен к рублевому
						 * счету, то метод абсолютно аналогичен getPos2Date().
						 ***********************************************************/

DEF VAR oSysClass AS TSysClass NO-UNDO.

DEF VAR dCursCB AS DECIMAL NO-UNDO.

DEF VAR dSumRur AS DECIMAL NO-UNDO.
DEF VAR dSumVal AS DECIMAL NO-UNDO.
		
oSysClass = new TSysClass().

			dCursCB = oSysClass:getCBRKurs(val,dDate).								/* Получаем курс ЦБ на дату */

			dSumVal = getLastPos2Date(dDate - 1,cStatus,val). 							 /* Остаток на утро в валюте */


			IF val <> 810 THEN
				DO:
					dSumRur = ROUND(dSumVal * (IF dCursCB <> ? THEN dCursCB ELSE 1),2).		/* Остаток в рублях на утро */
				END.
				ELSE
					DO:
						dSumRur = dSumVal.
					END.
	
			       dSumRur = dSumRur + calcOborot (dDate - 1,dDate,cStatus,810).				/* Посчитали оборот по рублям за текущий день */

DELETE OBJECT oSysClass.
RETURN dSumRur.
END METHOD.

/**
 * Функция возвращает ИСХОДЯЩИЙ остаток
 * по счету dDate с учетом документов
 * в статусе cStatus, в валюте iVal. 
 * @var DATE dDate Дата на которую возвращаем остаток по счету
 * @var CHAR cStatus Статус в котором учитываются документы при просчете остатка
 * @var INT iVal Валюта в которой считаем остаток
 * @result DECIMAL
 **/
METHOD PUBLIC DECIMAL getLastPos2Date(INPUT dDate AS DATE,INPUT cStatus AS CHARACTER,INPUT iVal AS INTEGER):
DEF VAR dLastPosDate AS DATE    NO-UNDO.
DEF VAR dSum 	     AS DECIMAL NO-UNDO.
DEF VAR oSysClass AS TSysClass  NO-UNDO.

    oSysClass = new TSysClass().    
     dSum = getBegPosInVal(iVal,dDate,dLastPosDate).                   /* Получили последнюю дату на которую есть агрегированный остаток */
     dSum = dSum + calcOborot(dLastPosDate,dDate,cStatus,iVal).
   DELETE OBJECT oSysClass.
RETURN dSum.
END METHOD.

METHOD PUBLIC DECIMAL getLastPos2Date(INPUT dDate AS DATE,INPUT cStatus AS CHARACTER):
		/**********************************************
		 *					      *
		 * Метод возвращает остаток по счету          *
		 * в валюте счета.			      *
		 *					      *
		 **********************************************/
	RETURN getLastPos2Date(dDate,cStatus,val).
END METHOD.

METHOD PUBLIC DECIMAL getLastPos2Date(INPUT dDate AS DATE):
        /***********************************
         * Функция возвращает остаток     *
         * в валюте счета, на дату dDate. *
         * Учитывает все документы,       *
         * кроме удаленных                *
         **********************************/
        RETURN getLastPos2Date(dDate,"").
END METHOD.


/******************
  Метод возвращает 
  весь приход 
  по ID транзакции (каждая транзакция
  при запуске имеет уникальный номер)
  при этом учитывается приход, который
  не попадает в рассчет основного оборота.
*******************/

METHOD PUBLIC DECIMAL calcOborot(INPUT iOpTr AS INTEGER):

DEF VAR dRes AS DECIMAL INITIAL 0 NO-UNDO.
  
  IF activity = "П" THEN DO:
	  FOR EACH op WHERE op-transaction EQ iOpTr NO-LOCK,
	    EACH op-entry OF op WHERE op-entry.acct-cr EQ acct 
                                      AND op-entry.op-status>="Ф" AND op-entry.op-status < "√" NO-LOCK:
	dRes = dRes + op-entry.amt-rub.
   END.
  END.
  ELSE DO:
	  FOR EACH op WHERE op.op-transaction EQ iOpTr NO-LOCK,
	    EACH op-entry OF op WHERE op-entry.acct-db EQ acct 
	    AND op-entry.op-status>="Ф" AND op-entry.op-status < "√" NO-LOCK:

	    	dRes = dRes + op-entry.amt-rub.
   END.
  END.
 RETURN dRes.
END METHOD.

METHOD PUBLIC DECIMAL  calcOborot (INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHARACTER,INPUT iVal AS INTEGER):
	/****************************************
	 * 			                *
	 *  Метод возвращает оборот             *
	 * по счету за указанный период.        *
	 *                                      *
	 ****************************************/
        RETURN calcOborot(dDateBeg,dDateEnd,cStatus,iVal,"*").
END METHOD.



METHOD PUBLIC DECIMAL  calcOborot (INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHARACTER,INPUT iVal AS INTEGER,INPUT cTransaction AS CHAR):
 DEF VAR dRes AS DEC NO-UNDO.

 dRes = calcOborot(dDateBeg,dDateEnd,cStatus,iVal,cTransaction,OUTPUT DbMove,OUTPUT CrMove).

 RETURN dRes.
END METHOD.

METHOD PUBLIC DECIMAL  calcOborot (INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHARACTER,INPUT iVal AS INTEGER,INPUT cTransaction AS CHAR,OUTPUT dDbMove AS DEC,OUTPUT dCrMove AS DEC):


								/******************************************
								 * 				          *
								 *  Метод возвращает оборот               *
								 * по счету за указанный период  .        *
								 * за исключением транзакций cTransaction *
								 *					  *
								 ******************************************/

DEF VAR dSum             AS DEC INIT 0 NO-UNDO.
DEF VAR dbMoveTmp        AS DEC INIT 0 NO-UNDO.
DEF VAR crMoveTmp        AS DEC INIT 0 NO-UNDO.

DEF VAR dSumOpEntryWSign AS DEC        NO-UNDO.
DEF VAR oSysClass        AS TSysClass  NO-UNDO.

oSysClass = new TSysClass().

     FOR EACH op-entry WHERE op-entry.acct-db=acct  				
						   AND dDateBeg<op-entry.op-date AND op-entry.op-date<=dDateEnd
						   AND op-entry.op-date<>? 
						   AND op-entry.op-status >= cStatus NO-LOCK,
						   FIRST op OF op-entry WHERE CAN-DO(cTransaction,op.op-kind) NO-LOCK:

		        IF iVal=810 THEN DO:
		                 dSumOpEntryWSign = oSysClass:op-entry-sign("Дб",activity) * op-entry.amt-rub.
                                 dbMoveTmp = dbMoveTmp + op-entry.amt-rub.
                        END.
		        ELSE DO:
		                 dSumOpEntryWSign = oSysClass:op-entry-sign("Дб",activity) * op-entry.amt-cur.
                                 dbMoveTmp = dbMoveTmp + op-entry.amt-cur.
                        END.
         dSum = dSum + dSumOpEntryWSign.
      END. /* По проводкам в дебете */


     FOR EACH op-entry WHERE op-entry.acct-cr=acct 
						   AND dDateBeg<op-entry.op-date AND op-entry.op-date<=dDateEnd
						   AND op-entry.op-date<>? 
						   AND op-entry.op-status >= cStatus NO-LOCK,
						   FIRST op OF op-entry WHERE CAN-DO(cTransaction,op.op-kind) NO-LOCK: 
        /* НАЛИЦО ДУБЛИРОВАНИЕ КОДА !!! Надо что-нибудь придумать ! */
        IF iVal=810 THEN DO:
            dSumOpEntryWSign = oSysClass:op-entry-sign("Кр",activity) * op-entry.amt-rub.
            crMoveTmp = crMoveTmp + op-entry.amt-rub.
        END.
        ELSE DO:
            dSumOpEntryWSign=oSysClass:op-entry-sign("Кр",activity) * op-entry.amt-cur.
            crMoveTmp = crMoveTmp + op-entry.amt-cur.
        END.

         dSum = dSum + dSumOpEntryWSign.
	END. /* По проводкам в дебете */


DELETE OBJECT oSysClass.	

dDbMove = dbMoveTmp.
dCrMove = crMoveTmp.
RETURN dSum.

END METHOD.


METHOD PUBLIC DECIMAL getCrMove(INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE):
  calcOborot(dDateBeg,dDateEnd,"К",val,"*",OUTPUT dbMove,OUTPUT crMove).
  RETURN crMove.

END METHOD.

METHOD PUBLIC DECIMAL getCrMove (INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHAR,INPUT iVal AS INT,INPUT cTrans AS CHAR):

                                                             /****************************************
                                                              *                                      *
                                                              * Возвращает оборот по кредиту         *
                                                              *                                      *
                                                              ****************************************/

 calcOborot(dDateBeg,dDateEnd,cStatus,iVal,cTrans,OUTPUT DbMove,OUTPUT CrMove).

 RETURN crMove.

END METHOD.

/**
 *
 * @param DATE dDateBeg - Дата начала определения оборота;
 * @param DATE dDateEnd - Дата окончания определения оборота;
 * @param CHARACTER cStatus - статус в котором смотрится оборот;
 * @return TAArray - возвращает массив amt-rub и amt-cur с оборотом.
 *
 *                  !!! ВНИМАНИЕ !!!
 *                Убей за собой результат! 
 *            Иначе получишь утечку памяти!
 **/

METHOD PUBLIC TAArray getCrMove (INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHARACTER):

   DEF VAR oa AS TAArray NO-UNDO.

   FOR EACH op-entry WHERE op-entry.acct-cr = acct 
		       AND op-entry.op-date >= dDateBeg AND op-entry.op-date <= dDateEnd AND op-entry.op-date <> ? 
		       AND op-entry.op-status >= cStatus
		       NO-LOCK,
		FIRST op OF op-entry NO-LOCK:

		 ACCUMULATE op-entry.amt-rub (TOTAL).
		 ACCUMULATE op-entry.amt-cur (TOTAL).
   END.

   oa = new TAArray().
	   oa:setH("amt-rub",(ACCUM TOTAL op-entry.amt-rub)).
	   oa:setH("amt-cur",(ACCUM TOTAL op-entry.amt-cur)).
  RETURN oa.
END METHOD.


METHOD PUBLIC DECIMAL getDbMove(INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE):
  calcOborot(dDateBeg,dDateEnd,"К",val,"*",OUTPUT dbMove,OUTPUT crMove).
  RETURN dbMove.
END METHOD.

METHOD PUBLIC DECIMAL getDbMove(INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cStatus AS CHAR,INPUT iVal AS INT,INPUT cTrans AS CHAR):

                                                             /****************************************
                                                              *                                      *
                                                              * Возвращает оборот по дебету          *
                                                              *                                      *
                                                              ****************************************/

  calcOborot(dDateBeg,dDateEnd,cStatus,iVal,cTrans,OUTPUT DbMove,OUTPUT CrMove).

  RETURN dbMove.
END METHOD.

METHOD PUBLIC DATE getFirstMoveByDate(INPUT dDateBeg AS DATE,INPUT dDateEnd AS DATE,INPUT cwithCorr AS CHARACTER):
                            /*******************************************
                             * Метод возвращает дату первого движения    *
                             * по  счету.                                                                *
                             *******************************************/
         
FIND FIRST op-entry WHERE op-entry.acct-db = acct
                                                      AND op-entry.acct-cr  MATCHES cwithCorr  
                                                      AND op-entry.op-date>=dDateBeg AND op-entry.op-date<=dDateEnd 
                                                      NO-LOCK NO-ERROR.

 IF NOT AVAILABLE(op-entry) THEN 
    DO:
         FIND FIRST op-entry WHERE op-entry.acct-cr = acct 
                                                               AND op-entry.acct-db MATCHES cwithCorr 
                                                               AND op-entry.op-date>=dDateBeg AND op-entry.op-date<=dDateEnd 
                                                    NO-LOCK NO-ERROR.

         IF AVAILABLE(op-entry) THEN RETURN op-entry.op-date.
      END.
      ELSE 
        RETURN op-entry.op-date.

   RETURN ?.      
END METHOD.

/*************************
 *
 * Получаем остатку по
 * счету.
 *
 *************************/
METHOD PUBLIC DECIMAL getPos2DateWError (INPUT dDate AS DATE,INPUT cTransaction AS CHARACTER):

  DEF VAR h       AS OBJECT  NO-UNDO.
  DEF VAR dBegPos AS DECIMAL NO-UNDO.
  DEF VAR dRes    AS DECIMAL NO-UNDO.

  dRes = getPos2DateWError(dDate,cTransaction,dBegPos,h).
  DELETE OBJECT h.

 RETURN dRes.
END METHOD.

/*********************************************
 *                                           *
 *           !!! ВНИМАНИЕ !!!		     *
 *                                           *
 *  ПОСЛЕ ИСПОЛЬЗОВАНИЯ УДАЛИ ОБЪЕКТ hCalc!  *

 ***********************************************
 * Цель метода: 1. Определить остаток по счету *
 * учитывая доверенные транзакции.	       *
 * 2. Выдать ключ=>значение рассчета.	       *
 *                                             *
 ***********************************************/

METHOD PUBLIC DECIMAL getPos2DateWError (INPUT dDate AS DATE,INPUT cTransaction AS CHARACTER,OUTPUT dBegPos AS DECIMAL,OUTPUT hCalc AS CLASS OBJECT):

DEF VAR oSysClass AS TSysClass         NO-UNDO.
DEF VAR oDBObRub  AS TAArray           NO-UNDO.
DEF VAR oCRObRub  AS TAArray           NO-UNDO.
DEF VAR oItogRub  AS TAArray           NO-UNDO.

DEF VAR oDBObCur  AS TAArray           NO-UNDO.
DEF VAR oCRObCur  AS TAArray           NO-UNDO.
DEF VAR oItogCur  AS TAArray           NO-UNDO.


DEF VAR dItogRub AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dItogCur AS DECIMAL INITIAL 0  NO-UNDO.
DEF VAR dSum     AS DECIMAL INITIAL 0  NO-UNDO.

DEF VAR dLastPosDate AS DATE           NO-UNDO.
DEF VAR iDate 	     AS DATE           NO-UNDO.





DEF VAR cStatus1 AS CHARACTER          NO-UNDO.
DEF VAR cStatus2 AS CHARACTER          NO-UNDO.
DEF VAR cPirRsv2TrDwnSt AS CHARACTER   NO-UNDO.

/*** Остатки по рублям ***/
oDBObRub = new TAArray().
oCRObRub = new TAArray().
oItogRub = new TAArray().

/*** Остатки по валюте ***/
oDBObCur = new TAArray().
oCRObCur = new TAArray().
oItogCur = new TAArray().


oSysClass = new TSysClass().

/***************
 * Получили список 
 * доверенных транзакций.
 ***************/
cPirRsv2TrDwnSt = oSysClass:getSetting("PirChkOp","PirRSv2TrDwnSt","!*").

/***************
 * Получили последнюю дату 
 * на которую есть агрегированный 
 * остаток.
 ***************/
dSum = getBegPosInVal(val,dDate,dLastPosDate).        

/********************************** ПРОХОДЫ ПО БД ***********************************/

/**************************************************
 *						  *
 * По все документам в заданный период            *
 * В случае, если счет стоит по ДБ.		  *
 *                                                *
 ***************************************************/

IF activity EQ "П" THEN DO:
			 cStatus1 = "Ф".
			 cStatus2 = "√".
			END.

IF activity EQ "А" THEN DO:
			 cStatus1 = "√".
			 cStatus2 = "Ф".
		        END.

FOR EACH op-entry WHERE op-entry.acct-db=acct  				
			AND dLastPosDate<op-entry.op-date AND op-entry.op-date<=dDate
			AND op-entry.op-date<>? AND op-entry.op-status <> "" NO-LOCK,
			FIRST op OF op-entry WHERE CAN-DO(cTransaction,op.op-kind)
						   AND (op.op-status >= cStatus1 OR (CAN-DO(cPirRsv2TrDwnSt,op.op-kind) AND op.op-status>=cStatus2))
						   AND op.op-date<>? NO-LOCK
                                                   BREAK BY op-entry.op-date:

   ACCUMULATE op-entry.amt-rub (SUB-TOTAL BY op-entry.op-date).
   ACCUMULATE op-entry.amt-cur (SUB-TOTAL BY op-entry.op-date).

   IF LAST-OF(op-entry.op-date) THEN
       DO:
		oDBObRub:setH(op-entry.op-date,(ACCUM SUB-TOTAL BY op-entry.op-date op-entry.amt-rub)).
		oDBObCur:setH(op-entry.op-date,(ACCUM SUB-TOTAL BY op-entry.op-date op-entry.amt-cur)).
      END.	/* Конец найден последний элемент группы */
END. /* Конец по проводкам */


/****************************************************
 *  По все документам в заданный период      *
 * В случае, если счет стоит по КР.		     *
 *                                                                           *
 ***************************************************/

FOR EACH op-entry WHERE op-entry.acct-cr=acct  			
			AND dLastPosDate<op-entry.op-date AND op-entry.op-date<=dDate
			AND op-entry.op-date<>? AND op-entry.op-status <> "" NO-LOCK,
			FIRST op OF op-entry WHERE CAN-DO(cTransaction,op.op-kind)
						   AND (op.op-status >= cStatus2 OR (CAN-DO(cPirRsv2TrDwnSt,op.op-kind) AND op.op-status>=cStatus1))
						   AND op.op-date<>? NO-LOCK
						   BREAK BY op-entry.op-date:

   ACCUMULATE op-entry.amt-rub (SUB-TOTAL BY op-entry.op-date).
   ACCUMULATE op-entry.amt-cur (SUB-TOTAL BY op-entry.op-date).

   IF LAST-OF(op-entry.op-date) THEN
       DO:
	oCRObRub:setH(op-entry.op-date,(ACCUM SUB-TOTAL BY op-entry.op-date op-entry.amt-rub)).
	oCRObCur:setH(op-entry.op-date,(ACCUM SUB-TOTAL BY op-entry.op-date op-entry.amt-cur)).
       END.	/* Конец найден последний элемент группы */
     END. /* Конец по проводкам */
   
/**************************************  КОНЕЦ ПРОХОДОВ ПО БД *****************************/
IF val = 810 THEN DO:

 dItogRub  = dSum. 
 dBegPos   = dItogRub.
END.
ELSE DO:
  dItogCur  = dSum.
  dBegPos   = dItogCur.
END.


DO iDate = dLastPosDate TO dDate:

 oItogRub:setH(STRING(iDate),0).
 oItogRub:setH(STRING(iDate),DECIMAL(oItogRub:get(iDate)) + oSysClass:op-entry-sign("ДБ",activity) * DECIMAL((IF oDBObRub:get(iDate) <> ? THEN oDBObRub:get(iDate) ELSE "0"))).
 oItogRub:setH(STRING(iDate),DECIMAL(oItogRub:get(iDate)) + oSysClass:op-entry-sign("КР",activity) * DECIMAL((IF oCRObRub:get(iDate) <> ? THEN oCRObRub:get(iDate) ELSE "0"))).

 oItogCur:setH(STRING(iDate),0).
 oItogCur:setH(STRING(iDate),DECIMAL(oItogCur:get(iDate)) + oSysClass:op-entry-sign("ДБ",activity) * DECIMAL((IF oDBObCur:get(iDate) <> ? THEN oDBObCur:get(iDate) ELSE "0"))).
 oItogCur:setH(STRING(iDate),DECIMAL(oItogCur:get(iDate)) + oSysClass:op-entry-sign("КР",activity) * DECIMAL((IF oCRObCur:get(iDate) <> ? THEN oCRObCur:get(iDate) ELSE "0"))).

 dItogRub = dItogRub + DECIMAL(oItogRub:get(iDate)).
 dItogCur = dItogCur + DECIMAL(oItogCur:get(iDate)).

END. /* Конец по итоговой таблице */

DELETE OBJECT oDBObRub.
DELETE OBJECT oCRObRub.

DELETE OBJECT oDBObCur.
DELETE OBJECT oCRObCur.

DELETE OBJECT oSysClass.  

 IF val = 810 THEN DO:
   hCalc   = oItogRub.
   DELETE OBJECT oItogCur.
   RETURN dItogRub. 
 END.
 ELSE DO:
   hCalc   = oItogCur.
   DELETE OBJECT oItogRub.
   RETURN dItogCur.
 END.
END METHOD.

/********************
 * Метод возвращает
 * дату последнего движения
 * на сумму , чем iLine
 ********************/
METHOD PUBLIC DATE getLastMoveByDate(INPUT begDate AS DATE,INPUT endDate AS DATE,INPUT iLine AS DECIMAL,INPUT cTransMask AS CHARACTER):

DEF VAR res AS DATE INITIAL 01/01/1900 NO-UNDO.


FOR EACH op-entry WHERE op-entry.acct-db EQ acct 
			 AND (op-entry.op-date >= begDate AND op-entry.op-date <= endDate AND op-entry.op-date <> ?)
			 AND amt-rub >= iLine NO-LOCK,
FIRST op OF op-entry WHERE CAN-DO(cTransMask,op.op-kind) NO-LOCK BY op.op-date:
	res = op-entry.op-date.
END.


FOR EACH op-entry WHERE op-entry.acct-cr EQ acct 
			 AND (op-entry.op-date >= begDate AND op-entry.op-date <= endDate AND op-entry.op-date <> ?)
			 AND amt-rub >= iLine NO-LOCK,
FIRST op OF op-entry WHERE CAN-DO(cTransMask,op.op-kind) NO-LOCK BY op.op-date:
	res = MAXIMUM(res,op-entry.op-date).
END.

  IF res EQ 01/01/1900 THEN res = ?.

  RETURN res.
END METHOD.

/**
 * Возвращает TRUE если по счету 
 * есть движение, иначе FALSE.
 * @var DATE dBegDate Дата с которой начинается проверка движения
 * @var DATE dEndDate Дата по которую проверяем движение
 * @var CHAR cTransMask Маска кодов транзакций в формате CAN-DO.
 * @result LOGICAL  
 **/
METHOD PUBLIC LOGICAL hasMove(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT cTransMask AS CHARACTER):

  FOR EACH op-entry WHERE op-entry.acct-db EQ acct OR op-entry.acct-cr EQ acct 
	                  AND (op-entry.op-date >= dBegDate AND op-entry.op-date <= dEndDate AND op-entry.op-date <> ?) NO-LOCK,
          FIRST op OF op-entry WHERE CAN-DO(cTransMask,op.op-kind) NO-LOCK:
		RETURN TRUE.
        END.
  RETURN FALSE.
END METHOD.

/**
 *  Возвращает периоды знакопостоянства
 * остатка по счету.
 * @var DATE dBegDate Дата начала периода
 * @var DATE dEndDate Дата окончания периода
 * @return TAArray 
 *
 **/
METHOD PUBLIC TAArray getStablePoints(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE):
  RETURN getStables("points",dBegDate,dEndDate).
END METHOD.

METHOD PROTECTED TAArray getStables(INPUT cType AS CHAR,INPUT dBegDate AS DATE,INPUT dEndDate AS DATE):

   DEF BUFFER acct-pos    FOR  acct-pos.
   DEF BUFFER acct-cur    FOR  acct-cur.
   
   DEF BUFFER nextAcctPos FOR acctPos.
   DEF BUFFER acctPos     FOR acctPos.


   DEF VAR dMonthEndDate  AS DATE    NO-UNDO.
   DEF VAR dPeriodBegDate AS DATE    NO-UNDO.
   DEF VAR dPeriodEndDate AS DATE    NO-UNDO.


   DEF VAR dCurrPos       AS DECIMAL NO-UNDO.
   DEF VAR dNextPos       AS DECIMAL NO-UNDO.
   DEF VAR iDate          AS DATE    NO-UNDO.
   DEF VAR dLastDate      AS DATE    NO-UNDO.
   DEF VAR cStatus        AS CHAR    INIT "Ф" NO-UNDO.
   DEF VAR dLastCloseDate AS DATE    NO-UNDO.

   DEF VAR oAArray             AS TAArray NO-UNDO.
   DEF VAR oAArrayMonth        AS TAArray NO-UNDO.

   DEF VAR key1 AS CHAR NO-UNDO.
   DEF VAR val1 AS CHAR NO-UNDO.


   oAArray      = new TAArray().
   oAArrayMonth = new TAArray().

   dLastCloseDate = TSysClass:getLastCloseDate2().

  IF val <> 810 THEN DO:
   FOR EACH acct-cur WHERE acct-cur.since >= dBegDate
                       AND acct-cur.since <= dEndDate
                       AND acct-cur.acct   = THIS-OBJECT:acct
                       NO-LOCK:
          CREATE acctPos.
          BUFFER-COPY acct-cur TO acctPos.
   END.

  END. ELSE DO:
   FOR EACH acct-pos WHERE acct-pos.since >= dBegDate
                       AND acct-pos.since <= dEndDate
                       AND acct-pos.acct   = THIS-OBJECT:acct
                       NO-LOCK:
          CREATE acctPos.
          BUFFER-COPY acct-pos TO acctPos.
   END.
  END.

  /****
   * Проверяем наличие первой точки,
   * если ее нет, то добавляем.
   *
   ****/
   FIND FIRST acctPos WHERE acctPos.since EQ dBegDate NO-LOCK NO-ERROR.
   IF NOT AVAILABLE(acctPos) THEN DO:
     CREATE acctPos.
     ASSIGN 
         acctPos.since   = dBegDate
         acctPos.balance = getLastPos2Date(dBegDate,cStatus)
     .
   END.


  /***
   * Проверяем наличие последней точки,
   * если ее нет, то добавляем ее.
   ***/
  FIND LAST acctPos WHERE acctPos.since EQ dEndDate NO-LOCK NO-ERROR.
  
  IF NOT AVAILABLE(acctPos) THEN DO:
     CREATE acctPos.
     ASSIGN 
         acctPos.since   = dEndDate
         acctPos.balance = getLastPos2Date(dEndDate,cStatus)
     .
  END.

  /*****
   *
   * Досоздаем расчетные точки. Если наш интервал
   * больше области закрытых опер. дней.
   *
   *****/
   IF  dLastCloseDate < dEndDate THEN DO:
        DO iDate = MAX(dBegDate,dLastCloseDate) TO dEndDate:
           dCurrPos = THIS-OBJECT:getLastPos2Date(iDate,cStatus).
           dNextPos = THIS-OBJECT:getLastPos2Date(iDate + 1,cStatus).

           IF dCurrPos <> dNextPos THEN DO:
                CREATE acctPos.
                ASSIGN
                   since   = iDate + 1
                   balance = dNextPos
                .
           END.           
         END.
    END.

 /*********
  * Добавляем разбивку по месяцам.
  *********/

  oAArrayMonth = TSysClass:getMonthEndDateArray(dBegDate,dEndDate).

  {foreach oAArrayMonth key1 val1}

    FIND FIRST acctPos WHERE acctPos.since = DATE(key1) NO-LOCK NO-ERROR.
          IF NOT AVAILABLE(acctPos) THEN DO:
                CREATE acctPos.
                ASSIGN
                  acctPos.since   = DATE(key1)
                  acctPos.balance = getLastPos2Date(DATE(key1),cStatus)
                .
          END.
      
  {endforeach oAArrayMonth}




   /***
    * Непосредственно производим
    * вычисление интервалов знакопостоянства.
    ***/

   CASE cType:
    WHEN "intervals" THEN DO:

     FOR EACH acctPos NO-LOCK:
       FIND FIRST nextAcctPos WHERE nextAcctPos.since > acctPos.since NO-LOCK NO-ERROR.

         IF AVAILABLE(nextAcctPos) THEN DO:  
          oAArray:setH(STRING(acctPos.since + 1) + "-" + STRING(nextAcctPos.since),ABS(acctPos.balance)).
         END.
     END.

    END.
    WHEN "points" THEN DO:
     FOR EACH acctPos NO-LOCK:
       FIND FIRST nextAcctPos WHERE nextAcctPos.since > acctPos.since NO-LOCK NO-ERROR.
         IF AVAILABLE(nextAcctPos) THEN DO:  
          oAArray:setH(STRING(acctPos.since + 1),ABS(acctPos.balance)). 
          oAArray:setH(STRING(nextAcctPos.since),ABS(acctPos.balance)).
         END.
     END.
   
    END.
   END CASE.
    

  RETURN oAArray.
       

END METHOD.

METHOD PUBLIC TAArray getStableIntervals(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE):
  RETURN getStables("intervals",dBegDate,dEndDate).
END METHOD.


METHOD PUBLIC TAArray getStableIntervals(INPUT dEndDate AS DATE):
    RETURN getStableIntervals(open-date,dEndDate).
END METHOD.        

/**
 * Возвращает массив
 * с наименованием счета для книги лицевых счетов.
 * @return TAArray 
 *
 **/
METHOD PROTECTED TAArray getBookAcctName():
    
    DEF VAR oAArray AS TAArray NO-UNDO.
    DEF VAR col5    AS CHAR    NO-UNDO.
    DEF VAR oClient AS TClient NO-UNDO.
   
   col5 = getXAttr("ЦельСч").
    
    oAArray = NEW TAArray().
    
    /************
     * Проверяем:
     * Если счет принадлежит маске
     * !3*,!4*,*, 
     * то наименование СЧЕТА, должно
     * стоять в графе примечание, а наименование
     * клиента должно быть пустым.
     * По диалогу с Кирносовой О. А. и Жуковой И.
     * в начале апреля 2011.
     ************/
 IF CAN-DO("!3*,!4*,*",acct) OR CAN-DO("Внутр*",col5) THEN DO:
            oAArray:setH("name","").
            oAArray:setH("details",details).
          RETURN oAArray.
  END.

  IF cust-cat EQ 'Ю' OR  cust-cat EQ 'Ч' THEN DO:     
     oClient = NEW TClient(acct).
        oAArray:setH("name",oClient:name-short).
        oAArray:setH("details","").
     DELETE OBJECT oClient.
     RETURN oAArray.     
   END.

   IF cust-cat EQ "Б" THEN DO:
          oAArray:setH("name",details).
          oAArray:setH("details","").
        RETURN oAArray.          
   END.
   
    oAArray:setH("name","").
    oAArray:setH("details",details).
    
    RETURN oAArray.    
END METHOD.

/**
 * @return TAArray возвращает массив с данными
 * по датам сообщения в налоговые органы
 **/

METHOD PROTECTED TAArray getBookGniAndPeriod():

   DEF VAR oAArray AS TAArray NO-UNDO.
   DEF VAR col5    AS CHAR    NO-UNDO.
   
   col5 = getXAttr("ЦельСч").
   
   oAArray = NEW TAArray().

IF col5 EQ "Внутренний" OR col5 EQ "Депозитный" OR col5 EQ "Ссудный" THEN DO:
   
     oAArray:setH("gniopen","Не требуется").
     oAArray:setH("gniclose","Не требуется").
     oAArray:setH("period","Не требуется").
   RETURN oAArray.
END.
    

oAArray:setH("period",getXAttr("ПорВыдВыпис")).
oAArray:setH("gniopen",getXAttr("ДатаСообщЛС")).
oAArray:setH("gniclose",getXAttr("ДатаСообщЗак")).

RETURN oAArray.
END METHOD.

/**
 * Возвращает массив с информацией
 * для книги открытых счетов.
 * @return TAArray
 *
 *      !!! ВНИМАНИЕ !!!
 *
 *  Убей после себя объект !
 *
 **/
METHOD PUBLIC TAArray getBookInfo():
 DEF VAR oa  AS TAArray NO-UNDO.
 DEF VAR oa1 AS TAArray NO-UNDO.

 oa  = THIS-OBJECT:getBookAcctName().

 oa1 = getBookGniAndPeriod().
 oa:ext(oa1).
 DELETE OBJECT oa1.

 RETURN oa.
END METHOD.

/**
 * Метод расчитывает проценты на остаток, 
 * за заданный период. Расчет производится
 * с учетом количества дней в году. Расчет производится
 * в валюте счета.
 * @param DATE dBegDate  дата начала расчета
 * @param DATE dEndDate  дата окончания расчет
 * @param DEC  dP        процентная ставка
 * @param LOG  doConvert при doConvert = YES проценты будут переводиться в рубли, иначе 
 * расчет будет вестись в валюте счета.
 * @return DEC
 **/
METHOD PUBLIC DEC calcPercent(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT dP AS DEC,INPUT doConvert AS LOG):

  DEF VAR key1     AS CHAR NO-UNDO.
  DEF VAR val1     AS CHAR NO-UNDO.
  DEF VAR iBegDate AS DATE NO-UNDO.
  DEF VAR iEndDate AS DATE NO-UNDO.
  DEF VAR period   AS INT  NO-UNDO.
  DEF VAR dPos     AS DEC  NO-UNDO.
  DEF VAR nach%    AS DEC  NO-UNDO.


  DEF VAR acctFrost AS TAArray    NO-UNDO.
  DEF VAR oSysClass AS TSysClass  NO-UNDO.

  DEF VAR dRes      AS DEC INIT 0 NO-UNDO.

  oSysClass = NEW TSysClass().

  acctFrost = THIS-OBJECT:getStableIntervals(dBegDate,dEndDate).

  {foreach acctFrost key1 val1}
     iBegDate = DATE(ENTRY(1,key1,"-")).
     iEndDate = DATE(ENTRY(2,key1,"-")).
     period   = iEndDate - iBegDate + 1.
     dPos     = IF doConvert THEN oSysClass:convert2Rur(INT(THIS-OBJECT:currency),DEC(val1),iEndDate) ELSE DEC(val1).

     nach%    = ROUND(period * dPos * dP / TSysClass:getPercentBase(iBegDate),2).

     dRes     = dRes + nach%.

  {endforeach acctFrost}

  DELETE OBJECT acctFrost.
  DELETE OBJECT oSysClass.

   RETURN dRes.
 END METHOD.

METHOD PUBLIC DEC calcPercent(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT dP AS DEC):

 RETURN THIS-OBJECT:calcPercent(dBegDate,dEndDate,dP,FALSE).

END METHOD.


/***
 * Проверяет является ли счет клиентским 
 * Считаем счет клиентским, если 
 * 1) в плане счетов стоит ДР "клиентский" 
 * 2) и счет попавдает из НП Pir2621List (по #2995)
 ***/
METHOD PUBLIC LOG isClient():
   DEF VAR  vNPListAcctClient  AS  CHAR INIT "" NO-UNDO.
   DEF VAR oSysClass AS TSysClass NO-UNDO.

   DEF BUFFER sbal-acct FOR bal-acct .
   DEF BUFFER ssigns FOR signs .



   oSysClass = new TSysClass().

      vNPListAcctClient =  oSysClass:getSetting("PirChkOp","Pir2621List","").

   DELETE OBJECT oSysClass.  

      FIND FIRST sbal-acct WHERE sbal-acct.bal-acct = bal-acct AND CAN-DO(vNPListAcctClient,acct) NO-LOCK NO-ERROR.

      FIND FIRST ssigns
           WHERE ssigns.file-name = "bal-acct"
           AND   ssigns.surrogate = STRING(sbal-acct.bal-acct)
           AND   ssigns.code = "ПрКл"
           AND   ( ssigns.code-value = "Клиентский" OR ssigns.xattr-value = "Клиентский" )
        NO-LOCK NO-ERROR.



   IF  AVAIL(ssigns)  THEN  RETURN TRUE.
   RETURN FALSE.
END METHOD.


/**************************************
 * Спец. метод возвращает TRUE, если
 * по счету в открытом дне есть документ
 * со статусом больше iMinStatus, но меньше
 * iMaxStatus.
 * @param DATE iСurrDate  дата до которой ищется движение
 * @param CHAR iMinStatu  минимальный статус (включительно)
 * @param CHAR iMaxStatus максимальный статус
 * @param CHAR iExcDocLst маска суррогатов документов, которые будут исключены
 * из поиска
 * @return LOG
 **************************************/

METHOD PUBLIC LOG hasD2Move (INPUT iCurrDate AS DATE,INPUT iMinStatus AS CHAR,INPUT iMaxStatus AS CHAR,INPUT iExcDocLst AS CHAR):

  DEF VAR vLastCloseDate AS DATE      NO-UNDO.
  DEF VAR oSysClass      AS TSysClass NO-UNDO.
  DEF VAR vUsrLst        AS CHAR      NO-UNDO.
  DEF VAR vRes           AS LOG       NO-UNDO.

  DEF BUFFER op FOR op.
  DEF BUFFER op-entry FOR op-entry.

 

   oSysClass = NEW TSysClass().
     vLastCloseDate = oSysClass:getLastCloseDate().

     vUsrLst = TUser:getUserLst("05-u5").


     FOR EACH op WHERE vLastCloseDate < op.op-date     AND op.op-date   <= iCurrDate                             
                            AND iMinStatus     <= op.op-status  AND op.op-status < iMaxStatus 
                            AND CAN-DO(vUsrLst,op.user-id)      AND LOOKUP(STRING(op.op),iExcDocLst) = 0 NO-LOCK,
       FIRST op-entry OF op WHERE op-entry.acct-db = THIS-OBJECT:acct NO-LOCK:

         vRes = TRUE.
         LEAVE.

      END.

/*
) THEN DO:
MESSAGE iExcDocLst VIEW-AS ALERT-BOX.
	vRes = TRUE.
     END. ELSE DO:
        vRes = FALSE.
     END.

*/

  DELETE OBJECT oSysClass.

 RETURN vRes.  

END METHOD.



DESTRUCTOR PUBLIC TAcct():
     /***********************************
      * Я тебя порадил, я тебя и убью!!!*
      ************************************/
END DESTRUCTOR.

END CLASS.