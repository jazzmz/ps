CLASS TF212:


/******************************* �������� ������ **************************************/

{set-prop.i &aa="date-beg" &bb="dDateBeg" &cc="DATE"}
{set-prop.i &aa="date-end" &bb="dDateEnd" &cc="DATE"}

{set-prop.i &aa="obslCount"      &bb="iOb"        &cc="INTEGER"}
{set-prop.i &aa="controlCount" &bb="iControl" &cc="INTEGER"}
{set-prop.i &aa="ControlCountClose"  &bb="iControlCountClose" &cc="INTEGER" &init="0"}

{set-prop.i &aa="withLimitCash"         &bb="iWLimitCash"            &cc="INTEGER"  &init="0"}
{set-prop.i &aa="limitCash"                 &bb="dLimitCash"              &cc="DECIMAL" &init="0"}
{set-prop.i &aa="isControlCount"        &bb="iConInCurrPeriod"     &cc="INTEGER" &init="0"}



/************************* ����� ����������� ������� ****************************/

/***** ���������� ��� �������� ����������� ���������� *****/

DEF PROTECTED VAR SettingGroup AS CHARACTER INITIAL "PIR212Report" LABEL "��㯯� � ����஥�묨 ��ࠬ��ࠬ�" NO-UNDO.
DEF PROTECTED VAR cAcctMask    AS CHARACTER INITIAL "*" NO-UNDO.
DEF PROTECTED VAR iBegOffset   AS INTEGER INITIAL 0     NO-UNDO.
DEF PROTECTED VAR iEndOffset   AS INTEGER INITIAL 0     NO-UNDO.
DEF PROTECTED VAR cExUNKG      AS CHARACTER             NO-UNDO.
DEF PROTECTED VAR iLogLevel    AS INTEGER               NO-UNDO.
DEF PROTECTED VAR clogFileName AS CHARACTER             NO-UNDO.
DEF PROTECTED VAR oel          AS TEventLog		NO-UNDO.

/********* ����� ���������� ��� �������� ���������� ********/

CONSTRUCTOR TF212(INPUT bD AS DATE,INPUT eD AS DATE):

DEF VAR oSysClass AS TSysClass NO-UNDO.

date-beg = bD.
date-end = eD.
oSysClass = new TSysClass().

/************* �������� ����������� ���������  *****************/

cAcctMask = oSysClass:getSetting(SettingGroup,"PIR212AcctMask").
iBegOffset = INTEGER(oSysClass:getSetting(SettingGroup,"BegOffset")).
iEndOffset = INTEGER(oSysClass:getSetting(SettingGroup,"EndOffset")).
cExUNKG = oSysClass:getSetting(SettingGroup,"exUNKG").
iLogLevel = INTEGER(oSysClass:getSetting(SettingGroup,"LogLevel")).
clogFileName = oSysClass:getSetting(SettingGroup,"logFileName").

oel = new TEventLog("file",clogFileName).

/********* ����� ����������� ����������� ���������� ***********/

DELETE OBJECT oSysClass.
END CONSTRUCTOR.

METHOD PROTECTED VOID write2Log (INPUT eventLevel AS INTEGER,INPUT cInfo AS CHARACTER):
                /*******************************************
                 * �㭪�� ����஢����. ����� �� �� ����       *
                 * �� ��� ����筥� �� ࠧ������ ���� �� ���� *
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
                             * �㭪�� ᬮ��� ��������                     *
                             * �� ���� � ����ᯮ����樨                   *
                             * � ���ᮩ. �᫨ ⠪��                         *
                             * �������� �뫮, � �����頥�                 *
                             * TRUE, ���� FALSE.                           *
                              * ����筮 �⮬� ��⮤� �� ����               *
                              * � �⮬ �����, �� �㤠 㭥�� ���� �� ����. *
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
                                 * �㭪�� ���� ���.                                               *
                                 *                                                                                               *
                                 ************************************************/
    DEF VAR oClient          AS TClient 					NO-UNDO.
    DEF VAR dDateLastControl AS DATE LABEL "�६����� ��� ��᫥����� ����஫�" NO-UNDO.
    DEF VAR lisAcctOpen      AS LOGICAL 	      NO-UNDO.
    DEF VAR lisControl       AS LOGICAL INITIAL FALSE NO-UNDO.		/* ������� �� �࣠������ ����஫��㥬�� */

/****************************************************************
 *												*
 * �� ��� #608,									*
 * �뫠 �訡��, ⠪ ��� � ⠡��� cust-corp �࠭����	*
 * ��� � ������� � ������ ���� ���, ⠪ � �������		*
 * � ������ ��⮢ ���.							*
 * ���⮬� ������ �롮�� ᭠砫� �� 				*
 * cust-role										*
 *												*
 ****************************************************************/

FOR each cust-role WHERE cust-role.cust-cat EQ "�" AND cust-role.Class-Code eq 'ImaginClient' NO-LOCK,
  FIRST cust-corp WHERE cust-corp.cust-id EQ INT64(cust-role.cust-id) NO-LOCK:
    /* 
      �� �ᥬ �����⠬ 
    */
    
    lisAcctOpen = FALSE.
    lisControl  = FALSE.

 /*******************************************************
  * �� ��� #608,							   *
  * (close-date=? OR close-date>=date-beg)		   *
  * �� ���� ��� �� ����� ��� �� ���� ����.     *
  *******************************************************/

  FOR EACH acct WHERE acct.cust-cat="�" 
		      AND acct.cust-id=cust-corp.cust-id 
		      AND (acct.close-date=? OR acct.close-date>=date-beg) 
		      AND CAN-DO(cacctMask,acct.acct) 
		  NO-LOCK:
          /*
            ����ਬ �� ��� ������� ������.
            ��� ������ 㤮���⢮���� ��᪥ ��
            ����஥筮�� ��ࠬ���.
          */ 
           lisAcctOpen = TRUE.           
           IF findMoveInAcct(acct.acct) THEN 
             DO:
               /**********************************************
                 * ��ᬮ�५� �뫮 �� ��������
                 * �� ������᪮�� ���� �� ��� 
                 * �� ���⭮� ����.
                 * �᫨ ��� �뫮, ��� ��
                 * �� ������ ����, ��⠥�,
                 * �� �࣠������ ����஫���㥬��
                 * � ����� �� ᬮ�ਬ.
               ***********************************************/
               controlCount = controlCount + 1.
               lisControl = TRUE.	        

		/*****************************************************
		 * �� ��� #608.                                                *
		 * ������ ���� ���뢠�� ������⢮                *
		 * �࣠����権, ����� ����஫���㥬�,      *
		 * �� ��� ����뫨 � ���⭮� ��ਮ��.	       *
		 *****************************************************/
		IF acct.close-date>=date-beg OR acct.close-date<=date-end THEN ControlCountClose = ControlCountClose + 1.
                oel:send(1,cust-corp.name-corp + "|" + "������� �������� �� ����" + acct.acct).
               LEAVE.
             END.  /* �뫮 �������� */

  END. /* �� �ᥬ ��⠬ */
        
  /* �᫨ � १���� ���᪠ ��� */
  obslCount = obslCount + INTEGER(lisAcctOpen).

oClient = new TClient("�",cust-corp.cust-id). 

dDateLastControl = DATE(oClient:getXAttrWDef("PIRCon212LastDate","01/01/1900")).

IF dDateLastControl GE date-beg AND dDateLastControl LE date-end THEN 
 DO:
  isControlCount = isControlCount + 1.
  oel:send(10,cust-corp.name-corp + "|" + STRING(dDateLastControl)).
 END.

     /*************************************************************
	* �� ��� #608							        *
        * ������ ���뢠���� �࣠����樨 � ⮬ �᫥       *
	* � � �㫥�� ����⮬.						        *
	* ���뢠�� ⮫쪮 ����஫��㥬� �࣠����樨!!! *
	***********************************************************/

     /**********************************
       * �� ���: #829               *
       * ������ ���뢠���� ⮫쪮     *
       * �࣠����樨 ����஫��㥬�    *
       * ����.                         *
       *********************************
       *			       *
       *  !!!                          *
       *  ������ ������������ ���      *
       *  ��������������� �����������  *
       *  !!!                          *
       *                               *
       *********************************/


     IF lisControl THEN
       DO:
           oel:send(12,"�࣠������ ����஫��㥬��:" + cust-corp.name-corp + "|" + STRING(limitCash)).
	   IF DECIMAL(oClient:getXAttrWDef("PIRLimitCash","0"))>=0 THEN DO:
          	iWLimitCash = iWLimitCash + 1.
	        limitCash = limitCash + DECIMAL(oClient:getXAttrWDef("PIRLimitCash","0")).
                oel:send(7,"�����:" + cust-corp.name-corp + "|" + STRING(limitCash)).
	   END. DO:
	        oel:send(6,"����� � ������ �����:" + cust-corp.name-corp + "|" + oClient:getXAttr("PirLimitCash")).
	   END.
       END.
        ELSE
            DO:
                oel:send(9,"����������� �� ���������������:" + cust-corp.name-corp + "|" + STRING(limitCash)).
            END.
       
   DELETE OBJECT oClient.   
END. /* �� �ᥬ �����⠬ */
END METHOD.

DESTRUCTOR PUBLIC TF212():
	DELETE OBJECT oel.
END.
END CLASS.