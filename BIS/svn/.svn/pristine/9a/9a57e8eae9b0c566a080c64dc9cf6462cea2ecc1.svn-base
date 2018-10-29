CLASS TF212:


/******************************* СВОЙСТВА КЛАССА **************************************/

{set-prop.i &aa="date-beg" &bb="dDateBeg" &cc="DATE"}
{set-prop.i &aa="date-end" &bb="dDateEnd" &cc="DATE"}

{set-prop.i &aa="obslCount"      &bb="iOb"        &cc="INTEGER"}
{set-prop.i &aa="controlCount" &bb="iControl" &cc="INTEGER"}
{set-prop.i &aa="ControlCountClose"  &bb="iControlCountClose" &cc="INTEGER" &init="0"}

{set-prop.i &aa="withLimitCash"         &bb="iWLimitCash"            &cc="INTEGER"  &init="0"}
{set-prop.i &aa="limitCash"                 &bb="dLimitCash"              &cc="DECIMAL" &init="0"}
{set-prop.i &aa="isControlCount"        &bb="iConInCurrPeriod"     &cc="INTEGER" &init="0"}



/************************* КОНЕЦ ОПРЕДЕЛЕНИЯ СВОЙСТВ ****************************/

/***** ПЕРЕМЕННЫЕ ДЛЯ ХРАНЕНИЯ НАСТРОЕЧНЫХ ПАРАМЕТРОВ *****/

DEF PROTECTED VAR SettingGroup AS CHARACTER INITIAL "PIR212Report" LABEL "Группа с настроечными параметрами" NO-UNDO.
DEF PROTECTED VAR cAcctMask    AS CHARACTER INITIAL "*" NO-UNDO.
DEF PROTECTED VAR iBegOffset   AS INTEGER INITIAL 0     NO-UNDO.
DEF PROTECTED VAR iEndOffset   AS INTEGER INITIAL 0     NO-UNDO.
DEF PROTECTED VAR cExUNKG      AS CHARACTER             NO-UNDO.
DEF PROTECTED VAR iLogLevel    AS INTEGER               NO-UNDO.
DEF PROTECTED VAR clogFileName AS CHARACTER             NO-UNDO.
DEF PROTECTED VAR oel          AS TEventLog		NO-UNDO.

/********* КОНЕЦ ПЕРЕМЕННЫХ ДЛЯ ХРАНЕНИЯ ПАРАМЕТРОВ ********/

CONSTRUCTOR TF212(INPUT bD AS DATE,INPUT eD AS DATE):

DEF VAR oSysClass AS TSysClass NO-UNDO.

date-beg = bD.
date-end = eD.
oSysClass = new TSysClass().

/************* ПОЛУЧАЕМ НАСТРОЕЧНЫЕ ПАРАМЕТРЫ  *****************/

cAcctMask = oSysClass:getSetting(SettingGroup,"PIR212AcctMask").
iBegOffset = INTEGER(oSysClass:getSetting(SettingGroup,"BegOffset")).
iEndOffset = INTEGER(oSysClass:getSetting(SettingGroup,"EndOffset")).
cExUNKG = oSysClass:getSetting(SettingGroup,"exUNKG").
iLogLevel = INTEGER(oSysClass:getSetting(SettingGroup,"LogLevel")).
clogFileName = oSysClass:getSetting(SettingGroup,"logFileName").

oel = new TEventLog("file",clogFileName).

/********* КОНЕЦ ОПРЕДЕЛЕНИЯ НАСТРОЕЧНЫХ ПАРАМЕТРОВ ***********/

DELETE OBJECT oSysClass.
END CONSTRUCTOR.

METHOD PROTECTED VOID write2Log (INPUT eventLevel AS INTEGER,INPUT cInfo AS CHARACTER):
                /*******************************************
                 * Функция логирования. Здесь ей не место       *
                 * Но где логичнее ее разместить пока не знаю *
                 *******************************************/
     IF iLogLevel GE eventLevel THEN
     DO:
     OUTPUT TO VALUE(cLogFileName) APPEND.
       PUT UNFORMATTED cInfo.
       PUT UNFORMATTED SKIP.
     OUTPUT CLOSE.
     END.
END METHOD.

METHOD PROTECTED LOGICAL findMoveInAcct(INPUT cAcct AS CHARACTER):
                            /************************************************
                             * Функция смотрит движение                     *
                             * по счету в корреспонденции                   *
                             * с кассой. Если такое                         *
                             * движение было, то возвращает                 *
                             * TRUE, иначе FALSE.                           *
                              * Конечно этому методу не место               *
                              * в этом классе, но куда унести пока не знаю. *
                             ************************************************/ 
                             
FIND FIRST op-entry WHERE op-entry.acct-db MATCHES '20202*' AND op-entry.acct-cr=cAcct AND op-date>(date-beg - iEndOffset) AND op-date<date-end + iBegOffset NO-LOCK NO-ERROR.

 IF NOT AVAILABLE(op-entry) THEN 
    DO:
     FIND FIRST op-entry WHERE op-entry.acct-db=cAcct AND op-entry.acct-cr MATCHES '20202*' AND op-entry.op-date>(date-beg - iEndOffset) AND op-date<date-end + iBegOffset NO-LOCK NO-ERROR.
     IF AVAILABLE(op-entry) THEN RETURN TRUE.
      END.
      ELSE RETURN TRUE.
   RETURN FALSE.      
END METHOD.


METHOD PUBLIC LOGICAL calc():
                                /************************************************
                                 *                                                                                               *
                                 * Функция расчета формы.                                               *
                                 *                                                                                               *
                                 ************************************************/
    DEF VAR oClient          AS TClient 					NO-UNDO.
    DEF VAR dDateLastControl AS DATE LABEL "Временная дата последнего контроля" NO-UNDO.
    DEF VAR lisAcctOpen      AS LOGICAL 	      NO-UNDO.
    DEF VAR lisControl       AS LOGICAL INITIAL FALSE NO-UNDO.		/* Является ли организация контролируемой */

/****************************************************************
 *												*
 * По заявке #608,									*
 * Была ошибка, так как в таблице cust-corp хранятся	*
 * как и клиенты у которых есть счета, так и клиенты		*
 * у которых счетов нет.							*
 * Поэтому делаем выборку сначало по 				*
 * cust-role										*
 *												*
 ****************************************************************/

FOR each cust-role WHERE cust-role.cust-cat EQ "Ю" AND cust-role.Class-Code eq 'ImaginClient' NO-LOCK,
  FIRST cust-corp WHERE cust-corp.cust-id EQ INT64(cust-role.cust-id) NO-LOCK:
    /* 
      По всем клиентам 
    */
    
    lisAcctOpen = FALSE.
    lisControl  = FALSE.

 /*******************************************************
  * По заявке #608,							   *
  * (close-date=? OR close-date>=date-beg)		   *
  * То есть счет был открыт хотя бы один день.     *
  *******************************************************/

  FOR EACH acct WHERE acct.cust-cat="Ю" 
		      AND acct.cust-id=cust-corp.cust-id 
		      AND (acct.close-date=? OR acct.close-date>=date-beg) 
		      AND CAN-DO(cacctMask,acct.acct) 
		  NO-LOCK:
          /*
            Смотрим все счета данного клиента.
            Счета должны удовлетворять маске из
            настроечного параметра.
          */ 
           lisAcctOpen = TRUE.           
           IF findMoveInAcct(acct.acct) THEN 
             DO:
               /**********************************************
                 * Посмотрели было ли движение
                 * по клиентскому счету за год 
                 * до отчетной даты.
                 * Если оно было, хотя бы
                 * по одному счету, считаем,
                 * что организация контроллируемая
                 * и дальше не смотрим.
               ***********************************************/
               controlCount = controlCount + 1.
               lisControl = TRUE.	        

		/*****************************************************
		 * По заявке #608.                                                *
		 * Теперь надо учитывать количество                *
		 * организаций, которые контроллируемые,      *
		 * но счета закрыли в отчетном периоде.	       *
		 *****************************************************/
		IF acct.close-date>=date-beg OR acct.close-date<=date-end THEN ControlCountClose = ControlCountClose + 1.
                oel:send(1,cust-corp.name-corp + "|" + "Найдено движение по счету" + acct.acct).
               LEAVE.
             END.  /* Было движение */

  END. /* По всем счетам */
        
  /* Если в результате поиска счета */
  obslCount = obslCount + INTEGER(lisAcctOpen).

oClient = new TClient("Ю",cust-corp.cust-id). 

dDateLastControl = DATE(oClient:getXAttrWDef("PIRCon212LastDate","01/01/1900")).

IF dDateLastControl GE date-beg AND dDateLastControl LE date-end THEN 
 DO:
  isControlCount = isControlCount + 1.
  oel:send(10,cust-corp.name-corp + "|" + STRING(dDateLastControl)).
 END.

     /*************************************************************
	* По заявке #608							        *
        * Должны учитываться организации в том числе       *
	* и с нулевым лимитом.						        *
	* Учитываем только контролируемые организации!!! *
	***********************************************************/

     /**********************************
       * По заявке: #829               *
       * Должны учитываться только     *
       * организации контролируемые    *
       * нами.                         *
       *********************************
       *			       *
       *  !!!                          *
       *  ЛИМИТЫ СКЛАДЫВАЮТСЯ ДЛЯ      *
       *  КОНТРОЛЛИРУЕМЫХ ОРГАНИЗАЦИЙ  *
       *  !!!                          *
       *                               *
       *********************************/


     IF lisControl THEN
       DO:
           oel:send(12,"Организация контролируемая:" + cust-corp.name-corp + "|" + STRING(limitCash)).
	   IF DECIMAL(oClient:getXAttrWDef("PIRLimitCash","0"))>=0 THEN DO:
          	iWLimitCash = iWLimitCash + 1.
	        limitCash = limitCash + DECIMAL(oClient:getXAttrWDef("PIRLimitCash","0")).
                oel:send(7,"ЛИМИТ:" + cust-corp.name-corp + "|" + STRING(limitCash)).
	   END. DO:
	        oel:send(6,"ЛИМИТ В ДРУГОМ БАНКЕ:" + cust-corp.name-corp + "|" + oClient:getXAttr("PirLimitCash")).
	   END.
       END.
        ELSE
            DO:
                oel:send(9,"ОРГАНИЗАЦИЯ НЕ КОНТРОЛЛИРУЕМАЯ:" + cust-corp.name-corp + "|" + STRING(limitCash)).
            END.
       
   DELETE OBJECT oClient.   
END. /* ПО всем клиентам */
END METHOD.

DESTRUCTOR PUBLIC TF212():
	DELETE OBJECT oel.
END.
END CLASS.