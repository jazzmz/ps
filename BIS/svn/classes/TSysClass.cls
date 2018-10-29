CLASS TSysClass IMPLEMENTS ISysClass:

  /*************************************************************
   *                                                                                                                     *
   *  ����� ������⥪� �㭪権.                                                                *
   *                                 !!! �������� !!!                                                   *
   *  ��। ���������� �㭪樨 � �����, ��易⥫쭮 ��������         *
   *  �� ��������� � ����䥩�.                                                                   *
   *                                                                                                                     *
   *************************************************************/

&SCOPED-DEFINE MONTHS_N "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������"
&SCOPED-DEFINE MONTHS_G "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������"

METHOD PUBLIC INTEGER op-entry-sign (INPUT cP AS CHARACTER,INPUT cActivity AS CHARACTER):

   /*****************************************
    * �㭪�� �����頥� ���� ����樨.        *
    * �।���������� ᫥����� ������:          *
    *  1. ���⮪ �� ��� �ᥣ�� �����;            *
    *  2. �᫨ ��� � � �஢���� �� ��               *
    * ����� �� ���⪠ ��� ���⠥�           *
    * �㬬� �஢����;                                           *
    *  3. �᫨ ��� � � �஢���� �� ��               *
    * ����� � ����� ��� �ਡ���塞,        *
    * �㬬� �஢����;                                           *
    *  4. �᫨ ��� � � �஢���� �� ��              * 
    * ����� � ����� �ਡ��塞 �㬬�          *
    * �஢����;                                                       *
    *  5. �᫨ ��� � � �஢���� �� ��              *
    * ����� �� ���⪠ ���⠥�                     *
    * �㬬� �஢����;                                          *
    *****************************************/
    
    CASE cP:
       WHEN "��" THEN
          DO:
             CASE cActivity:
                WHEN "�" THEN RETURN -1.
                WHEN "�" THEN RETURN 1.
             END CASE.
          END.
       WHEN "��" THEN
          DO:
              CASE cActivity:
                  WHEN "�" THEN RETURN 1.
                  WHEN "�" THEN RETURN -1.
              END CASE.
           END.
     END CASE.
END METHOD.

METHOD PUBLIC CHARACTER DATETIME2STR(INPUT dt2Convert AS DATETIME,INPUT cFormat AS CHARACTER):
                /**************************************
                 * ��⮤ ��� �८�ࠧ������                    *
                 * ��६����� DATETIME � ��ப�         *
                 * ��������� ��६����� cFormat ����     *
                 **************************************/
    DEFINE VARIABLE cResult AS CHARACTER INITIAL "" NO-UNDO.
    DEFINE VARIABLE hours AS INTEGER NO-UNDO.
    DEFINE VARIABLE minutes AS INTEGER NO-UNDO.
    DEFINE VARIABLE minleft AS DECIMAL NO-UNDO.
    
    /* ����砥� ����� � �६��� */
    minleft = MTIME(dt2Convert) / 60000.
    minutes = minleft - TRUNCATE(minleft / 60,0) * 60.  
    hours = TRUNCATE(minleft / 60,0).    
    /* ����� � �६��� ����稫�  */   

    cResult = IF DAY(dt2Convert) > 9 THEN REPLACE(cFormat,"%d",STRING(DAY(dt2Convert))) ELSE REPLACE(cFormat,"%d","0" + STRING(DAY(dt2Convert))).

    cResult =IF MONTH(dt2Convert) > 9 THEN  REPLACE(cResult,"%m",STRING(MONTH(dt2Convert))) ELSE REPLACE(cResult,"%m","0" + STRING(MONTH(dt2Convert))).

    cResult = REPLACE(cResult,"%Y",STRING(YEAR(dt2Convert))).
    
    cResult = IF hours > 9 THEN REPLACE(cResult,"%h",STRING(hours)) ELSE REPLACE(cResult,"%h","0" + STRING(hours)).

    cResult = IF minutes > 9 THEN REPLACE(cResult,"%j",STRING(minutes)) ELSE REPLACE(cResult,"%j","0" + STRING(minutes)).
  RETURN cResult.    

END METHOD.

METHOD PUBLIC CHARACTER getMonthString(INPUT iMonthNum AS INTEGER):
            /**************************************
              * �㭪�� �����頥� ������������  *
              * �����                                                       *
             **************************************/
            RETURN getMonthString(iMonthNum,"nominative").
END METHOD.

METHOD PUBLIC CHARACTER getMonthString(INPUT iMonthNum AS INTEGER,INPUT cCase AS CHARACTER):
            /*****************************************
              * �㭪�� �����頥� ������������         *
              * �����                                                              *
              * cCase = "nominative" - �����⥫��       *
              * �����, "genitive" - த�⥫�� �����    *
             ******************************************/
                
            IF iMonthNum LT 1 OR iMonthNum GT 12 THEN RETURN ?.
                ELSE 
                    DO:
                        IF cCase EQ "genitive" THEN RETURN ENTRY(iMonthNum, {&MONTHS_G}).  ELSE RETURN ENTRY(iMonthNum, {&MONTHS_N}).
                     END.

END METHOD.

METHOD PUBLIC DATE str2Date(INPUT cStr AS CHARACTER,INPUT cFormat AS CHARACTER):
            /**************************************
             *                                                                       *
             * �㭪�� �����頥� ���� �� ��ப�.   *
             *                                                                       *
             **************************************/
            RETURN DATE(INTEGER(SUBSTRING(cStr,4,2)),INTEGER(SUBSTRING(cStr,1,2)),INTEGER(SUBSTRING(cStr,7,4))).

END METHOD.

 METHOD PUBLIC LOGICAL isTemplate(INPUT cTemplate AS CHARACTER):
                /***************************************
                 * �㭪�� �����頥� ��⨭�, �᫨     *
                 * cTemplate ���� 蠡�����         *
                 ***************************************/
 IF (INDEX(cTemplate,"*") NE 0 OR INDEX(cTemplate,"!") NE 0 OR INDEX(cTemplate,".") NE 0 OR INDEX(cTemplate,",") NE 0) THEN
    RETURN TRUE.
   ELSE
    RETURN FALSE.
 END METHOD.


 METHOD STATIC PUBLIC CHARACTER getSetting2(INPUT cParent AS CHARACTER,INPUT cParam AS CHARACTER,INPUT cDef AS CHARACTER):
             /*************************************************
             *                                               *
             * �����頥� ����஥�� ��ࠬ���               *
             * � ��� ����஥�� ��ࠬ���� ���������       *
             * � ����. ��� ���� ��।������ � pp-cache. *
             * ���� ��楤��� ����㯭� � globals.i.          *
             * � ������ ����� ������� ࠡ���� �          *
             * �����⥭�묨 ��楤�ࠬ�, ���⮬�           *
             * �ᯮ���� ��楤��� �������.                 *
             *************************************************/
	DEF VAR cRes AS CHARACTER NO-UNDO.

	RUN get-setting.p(cParent,cParam,cDef,OUTPUT cRes).
 
       RETURN cRes.

 END METHOD.

 METHOD STATIC PUBLIC CHARACTER getSetting2(INPUT cParent AS CHARACTER):
	DEF VAR cRes AS CHARACTER NO-UNDO.

	RUN get-setting.p(cParent,"",?,OUTPUT cRes).
 
       RETURN cRes.

 END METHOD.

 METHOD PUBLIC CHARACTER getSetting(INPUT cParent AS CHARACTER,INPUT cParam AS CHARACTER,INPUT cDef AS CHARACTER):
    RETURN getSetting2(cParent,cParam,cDef).
 END METHOD.

 METHOD PUBLIC CHARACTER getSetting(INPUT cParentParam AS CHARACTER, INPUT cParam AS CHARACTER):
                                                                /*************************************************
                                                                 *                                                                      *
                                                                 * �����頥� ����஥�� ��ࠬ���         *
		                                                *                                                                       *
                                                                 *************************************************/
       RETURN getSetting(cParentParam,cParam,?).
 END METHOD.

 METHOD PUBLIC CHARACTER getSetting(INPUT cParam AS CHARACTER):
                                                                /*************************************************
                                                                 *                                                                                                                                           *
                                                                 * �����頥� ����஥�� ��ࠬ���                                           *
                                                                 *                                                                                                                                               *
                                                                 *************************************************/
  RETURN getSetting(cParam,"").
END METHOD.

METHOD PUBLIC VOID write2Log(INPUT iLogLevel AS INTEGER,INPUT lResult AS LOGICAL, INPUT cComment AS CHARACTER,INPUT cLogName AS CHARACTER):
                               /*************************************************
                                *
                                * �ந������ ������ � ���.
                                *
                                *************************************************/
     OUTPUT TO VALUE(cLogName) APPEND.

                  PUT UNFORMATTED lResult "|" cComment SKIP.

     OUTPUT CLOSE.
END METHOD.

METHOD PUBLIC VOID write2Log(INPUT iLogLevel AS INTEGER,INPUT lResult AS LOGICAL, INPUT cComment AS CHARACTER):
                        write2Log(iLogLevel,lResult,cComment,"transaction-log.log").
END METHOD.

METHOD PUBLIC CHARACTER REPLACE_ASCII(INPUT cStr AS CHARACTER,INPUT iCode AS INTEGER,INPUT cString AS CHARACTER):
                /*************************************************
                 * �㭪�� ������� � ��ப� cStr ᨬ���         *
                 * � ����� iCode �� �����ப� cString                 *
                * ����:                                                                 *
                * 10 - ᨬ��� ��ॢ��� ��ப�.                         *
                 *13 - ᨬ��� ������ ���⪨.                         *
                 * 251 - ���.                                                         *
                 *************************************************/
DEF VAR i AS INTEGER INITIAL 0 		     NO-UNDO.
DEF VAR tmpChar AS CHARACTER INITIAL ""      NO-UNDO.
DEF VAR resultString AS CHARACTER INITIAL "" NO-UNDO.

DO i=1 TO LENGTH(cStr):
   tmpChar = SUBSTRING(cStr,i,1).

   IF ASC(tmpChar) = iCode THEN  SUBSTRING(cStr,i,1) = cString.   
 END.

  RETURN cStr.
END METHOD.

METHOD PUBLIC CHARACTER REPLACE_CASE(INPUT cStr AS CHARACTER,INPUT cWhat AS CHARACTER,INPUT cTo AS CHARACTER):
                /*****************************************************
                 * �㭪�� �����⢫�� ॣ���஧���ᨬ��  *
                 * ������ cWhat �� cTo � ��ப� cStr.                       *
                 *****************************************************/
RETURN "".
END METHOD.

METHOD PUBLIC INTEGER strPos (INPUT cStr AS CHARACTER,INPUT cChar AS CHARACTER,INPUT cType AS CHARACTER):
                /*****************************************************************
                 * �㭪�� �����⢫�� ���� ��ࢮ�� �宦�����                *
                 * ᨬ���� cChar � ��ப� � ��ப� cStr, � ���浪� cType *
                 * ���� cType ����� ���� ࠢ�� ���� first,last                        *
                 * �᫨ �宦����� �� �������, � �����頥� ?              *
                 ****************************************************************/
  DEF VAR i AS INTEGER 		    NO-UNDO.
  DEF VAR iPos AS INTEGER INITIAL ? NO-UNDO.

  DO i = 1 TO LENGTH(cStr):
      IF SUBSTRING(cStr,i,1) = cChar THEN
                        DO:
                        
                                CASE cType:
                                        WHEN "first" THEN RETURN i.
                                        WHEN "last" THEN iPos = i.
                                END. /* ����� CASE */

                        END. /* ����� ������ ᨬ��� */
  END.

 RETURN iPos.
END METHOD.

METHOD PUBLIC INTEGER getRemainder(INPUT iNum AS INTEGER,INPUT iModul AS INTEGER,INPUT iStep AS INTEGER):
         /***************************************************************************
          * �����頥� ���⮪ ������� iNum �� iModul + ᬥ饭�� iStep. *
          *                                                                                                             *
          ****************************************************************************/
                DEF VAR iRemainder AS INTEGER LABEL "���⮪ �� �������" NO-UNDO.
                iRemainder = iNum - TRUNCATE(iNum / iModul,0) * iModul.
            RETURN iRemainder + iStep.
END METHOD.
 
    /********************************************
     * �㭪�� ��।������ �ਭ���������       *
     * ����:                                    *
     *  ����� ���� ��ﬠ� ࠧ�������� �� n      *
     * �易���� ��१���                       *
     * ������ ����� ������� ��१��.            *   
     *  ������ �窠 �ਭ�������� ��אַ�.      *
     * ��।�����:                              *
     * ����� ��१�� ���஬� �ਭ������� �窠 *
     *                                          *
     * �ਬ�砭��: �������� ��砫쭠� �窠 �   *
     * � ����� ������� ������������ �������.    *
     *                                          *
     ********************************************/

METHOD PUBLIC INTEGER getLineSegment(INPUT iPos AS INTEGER,INPUT cSegmentWidthList AS CHARACTER):
     
    DEF VAR i      AS INT INIT 0 NO-UNDO.
    DEF VAR iLeft  AS INT INIT 0 NO-UNDO.
    DEF VAR iRight AS INT INIT 0 NO-UNDO.

      DO i = 1 TO NUM-ENTRIES(cSegmentWidthList):
        iRight = iRight + INTEGER(ENTRY(i,cSegmentWidthList)).
        IF iLeft<iPos AND iPos <= iRight THEN RETURN i.
        iLeft = iRight.      
    END.
    /* ����ਬ ��ਠ�� ����� �窠 �� �ਭ������� �� ������ �� ��१���.
      ����室��� ��� ��ࠡ�⪨:
        1. �窠 ����� ������ ���� ��������;
        2. �� �樮���쭠� ��᫥����⥫쭮���.
    */
    IF iPos < 0 THEN RETURN 0. ELSE 
    IF iPos > iRight THEN RETURN i. ELSE 
    IF iPos = 0 THEN RETURN 0.
END METHOD.

/**
 * @param currValue DEC ������ �窠
 * @param cLinePoint CHAR ���᮪ �१ ������� �祪 �� ��אַ�
 * @return INT ����� ��१�� ���஬� �ਭ������� �窠.
 **/

METHOD PUBLIC INTEGER getLineSegmentByList(INPUT currValue AS DEC,INPUT cLinePoint AS CHAR):
 DEF VAR oAArray AS TAArray NO-UNDO.
 DEF VAR iRes    AS INT     NO-UNDO.
 DEF VAR i       AS INT     NO-UNDO.

 oAArray = NEW TAArray().

    DO i = 1 TO NUM-ENTRIES(cLinePoint):
       oAArray:setH(ENTRY(i,cLinePoint),STRING(i)).
    END.

   iRes = INT(TSysClass:getTableValue(DECIMAL(currValue),oAArray)).

 DELETE OBJECT oAArray.

 RETURN iRes.
END METHOD.


/**
 * �����頥� ���祭�� �� ���ࢠ��.
 * @var DEC iPos �஢��塞�� ���祭��
 * @var TAArray oLinePoints ��� ��१��� � ���祭��.
 * @return DECIMAL
 **/
METHOD STATIC PUBLIC DECIMAL getTableValue(INPUT iPos AS DEC,INPUT oLinePoints AS TAArray):
 DEF VAR dRes AS DECIMAL NO-UNDO.
 DEF VAR key1 AS CHAR    NO-UNDO.
 DEF VAR val1 AS CHAR    NO-UNDO.
 
 {foreach oLinePoints key1 val1}
    IF iPos >= DECIMAL(key1) THEN dRes = DECIMAL(val1).
 {endforeach oLinePoints}
 RETURN dRes.
END METHOD.


METHOD PUBLIC CHARACTER getUserFIO(INPUT cUserID AS CHARACTER,INPUT cFormat AS CHARACTER):
                                /**************************************************
                                 * ��⮤ �����頥� ��� ���짮��⥫� � ID cUserID *
                                 * � �ଠ� cFormat
                                 ****************************************************/
       DEF VAR cSurname AS CHARACTER INITIAL ""    NO-UNDO.
       DEF VAR cName AS CHARACTER INITIAL "" 	   NO-UNDO.
       DEF VAR cPatronymic AS CHARACTER INITIAL "" NO-UNDO.
                
       FIND FIRST _user WHERE _user._userid EQ cUserID NO-LOCK NO-ERROR.

       IF NOT ERROR-STATUS:ERROR THEN
                        DO:                            
                                        /* � ���짮��⥫� �� �����-���� ��稭��
                                             ����� ���� �� ��������� �����-���� ��
                                             �����. ���⮬� ����室��� ������ �訡��.
                                         */
                                    
                             cSurname = ENTRY(1,_user._user-name," ") NO-ERROR.
                             cName = ENTRY(2,_user._user-name," ") NO-ERROR.
                             cPatronymic = ENTRY(3,_user._user-name," ") NO-ERROR.

                                   cFormat = REPLACE_ASCII(cFormat,ASC("F"),cSurname).
                                   cFormat = REPLACE_ASCII(cFormat,ASC("I"),cName).
                                   cFormat = REPLACE_ASCII(cFormat,ASC("O"),cPatronymic).
				   cFormat = REPLACE_ASCII(cFormat,ASC("i"),SUBSTRING(cName,1,1)).
				   cFormat = REPLACE_ASCII(cFormat,ASC("o"),SUBSTRING(cPatronymic,1,1)).
                           RETURN cFormat.
                        END.
                        ELSE 
                        RETURN "".
END METHOD.

METHOD PUBLIC CHARACTER getUserPost():
                                /**************************************************
                                 * ��⮤ �����頥� ��������� ���짮��⥫�  *
                                 * 
                                 ****************************************************/
                 

          FIND LAST signs WHERE signs.file-name = "_user" AND
                         signs.surrogate = _user._userid  AND
                         signs.code      = "���������" NO-LOCK NO-ERROR.
                         
        RETURN signs.xattr-val. 
        /*ELSE )
                        ELSE 
                        RETURN "".*/
END METHOD.

METHOD PUBLIC CHARACTER getUserFIO():
      /************************************************
      * ��⮤ �����頥� ��� ⥪�饣� ���짮��⥫�    *
      *************************************************/

        RETURN getUserFIO(USERID("bisquit"),"F I O").

END METHOD.

METHOD PUBLIC DECIMAL getCBRKurs(INPUT iCode AS INTEGER,INPUT dDate AS DATE):
                            /********************************
                            * �����頥� ���� ���� ��    *
                            *********************************/

  RETURN getKursByType('����',iCode,dDate).

END METHOD.
METHOD PUBLIC DECIMAL getKursByType(INPUT cType AS CHARACTER,INPUT iCode AS INTEGER,INPUT dDate AS DATE):
                            /**********************************
                             *                                                               *
                             *  �����頥� ���� ⨯� cType          *
                             * ��� ������ iCode �� ���� dDate    *
                             *                                                               *
                             **********************************/

            FIND FIRST instr-rate WHERE instr-rate.instr-cat EQ 'currency' 
                                                                  AND instr-rate.instr-code EQ STRING(iCode)
                                                                  AND instr-rate.rate-type EQ cType 
                                                                  AND since = dDate 
                                                    NO-LOCK NO-ERROR.
            IF AVAILABLE(instr-rate) THEN RETURN instr-rate.rate-instr. ELSE RETURN ?.

END METHOD.

/**
 * �����頥� ����� � ��⮬ ���� �६���.
 * @var CHAR cType ��� ����
 * @var INT iCode ��� ������
 * @var DATETIME dDateTime ��� �६� �� ���஥ 
 * �஢��塞 ����.
 * @return TAArray
 **
 *      !!! �������� !!!
 *  ���� �� ᮡ�� ��ꥪ�!!!
 **/
METHOD PUBLIC TAArray getKursDynamic(INPUT cType AS CHAR,INPUT iCode AS INT,INPUT dDateTime AS DATE):
          DEF VAR oResult  AS TAArray NO-UNDO.
          DEF VAR i        AS INT     NO-UNDO.
          DEF VAR prevTime AS DATETIME NO-UNDO.

          oResult = NEW TAArray().
          prevTime = DATETIME(MONTH(dDateTime),DAY(dDateTime),YEAR(dDateTime),0,0).
          FOR EACH history WHERE history.modify NE "RUN" 
                             AND history.modify NE "PRINT"
                             AND history.modify NE "SAVE" 
                             AND history.field-ref EQ 'currency,' + cType + ',' + STRING(iCode) + ',' + STRING(DATE(dDateTime))
                             AND history.file-name EQ 'instr-rate' NO-LOCK
                             BY history.file-name
                             BY history.modif-date
                             BY history.modif-time:               
              DO i = 1 TO NUM-ENTRIES(history.field-value):
                    IF ENTRY(i,history.field-value) = "rate-instr" THEN DO:
                        oResult:setH(STRING(prevTime),ENTRY(i + 1,history.field-value)).
                        prevTime = DATETIME(STRING(history.modif-date,"99-99-9999") + " " + STRING(history.modif-time,"HH:MM:SS")).
                    END. 
               END.               
          END.
          oResult:setH(STRING(prevTime),getKursByType(cType,iCode,DATE(dDateTime))).
          RETURN oResult.
END METHOD.

/**
 * �����頥� ���� �������騩
 * �� dDateTime.
  * @var CHAR cType ��� ����
  * @var INT  iCode ��� ������
  * @var DATETIME �६� �� ���஥ �஢������
  * ����.
  * @result DECIMAL
 **/
METHOD PUBLIC DECIMAL getKursWithHistory(INPUT cType AS CHAR,INPUT iCode AS INT,INPUT dDateTime AS DATETIME):
  DEF VAR oKurs AS TAArray NO-UNDO.
  DEF VAR dRes  AS DECIMAL NO-UNDO.
  DEF VAR key1  AS CHAR    NO-UNDO.
  DEF VAR val1  AS CHAR    NO-UNDO.
  oKurs = THIS-OBJECT:getKursDynamic(cType,iCode,DATE(dDateTime)).
    {foreach oKurs key1 val1}
        IF dDateTime > DATETIME(key1) THEN DO:
            dRes = DECIMAL(val1).
        END.
    {endforeach oKurs}
  DELETE OBJECT oKurs.
  RETURN dRes.
END METHOD.

METHOD PUBLIC CHARACTER getCBDocCode(INPUT cDocCode AS CHARACTER):
                            /***********************************
                             * ��⮤ �����頥� ��� ���㬥��
                             * �� �����䨪�樨 ��.
                             * � ����⢥ ��ࠬ��� ����㯠��
                             * ��� ���㬥�� � �����䨪�樨 
                             * ��᪢��
                             ************************************/
            FIND FIRST doc-type WHERE doc-type EQ cDocCode NO-LOCK NO-ERROR.
                IF AVAILABLE(doc-type) THEN RETURN digital.
                                                              ELSE  RETURN ?.
END METHOD.

/**
 * ��⮤ �����頥� ���� ��᫥����� ����⮣� ���.
 * @static
 * @return DATE
 **/
METHOD STATIC DATE getLastOpenDate2():
        DEF BUFFER op-date FOR op-date.
        FIND LAST op-date NO-LOCK.
        RETURN op-date.
END METHOD.

METHOD PUBLIC DATE getLastOpenDate():
                        /***************************************************
                         *
                         * ��⮤ �����頥� ���� ��᫥����� 
                         * ����⮣� ���.
                         *
                         ***************************************************/
 RETURN TSysClass:getLastOpenDate2().

END METHOD.

METHOD PUBLIC LOGICAL isOpen(INPUT dDate AS DATE):
                        /***************************************************
                         *
                         * �����頥� TRUE �᫨ ���� dDate �����
                         *
                         ***************************************************/
 IF CAN-FIND(FIRST op-date WHERE op-date EQ dDate) THEN RETURN TRUE.
 RETURN FALSE.
END METHOD.

	/**********************************
     *                                *
	 * @param  DATE cBegDate ������  *
	 * �࠭�� ���᪠ �����⮣� ��    *
	 *                                *
	 * @return DATE	 	              *
	 *                                *
	 * �����頥� ��᫥���� ������    *
     * ����樮��� ����.             *
	 *			                      *
	 **********************************
	 * ����: ��᫮� �. �.            *
	 * ��� ᮧ�����:                 *
	 * ���:                        *
	 *                                *
	 **********************************/

METHOD PUBLIC DATE getLastCloseDate(INPUT cBegDate AS DATE):
 RETURN TSysClass:getLastCloseDate2(cBegDate).
END METHOD.


/***************************************************
 *                                                 *                          *
 * ��⮤ �����頥� ���� ��᫥�����                *
 * �����⮣� ���.                                  *
 *                                                 *
 * ������:                                       *
 * ������� �� 䨪���� ��᫥����                  *
 * ������� ���� � �����-���� ⠡���,             *
 * ���⮬� ������ ���᪠ ᫥���騩:              *
 * 1. ��६ ��� ��� �� ����஥筮�� ��ࠬ���;     *
 * 2. ��室�� ��᫥���� ���⮪ � acct-pos         *
 * �� �������.                                    *
 * 3. �� � �㤥� ��᫥���� ������� ����.         *
 *
 * @var DATE dBegDate ��� � ��砫� ���ண� 
 * �஢��塞 ����稥 �������� ����.
 * @return DATE
 ***************************************************/

METHOD STATIC DATE getLastCloseDate2(INPUT dBegDate AS DATE):


          DEF VAR oBank     AS TBank 	       NO-UNDO.
          DEF VAR cCorrAcct AS CHARACTER      NO-UNDO.
          DEF VAR dRes      AS DATE           NO-UNDO.

          DEF BUFFER acct-pos FOR acct-pos.

          oBank = new TBank(TSysClass:getSetting2("�������")).

          cCorrAcct = oBank:getNostroAcct().
           
          FIND LAST acct-pos WHERE acct=cCorrAcct AND since < dBegDate NO-LOCK NO-ERROR.

          IF AVAILABLE(acct-pos) THEN dRes = acct-pos.since.
          ELSE
           DO:
              dRes = DATE(TSysClass:getSetting2("���_��")).
           END.

 DELETE OBJECT oBank.

 RETURN dRes.

END METHOD.

/**
 * �����頥� ���� ������ ��᫥����� �����⮣� ���.
 * @return DATE
 **/
METHOD STATIC DATE getLastCloseDate2():
  RETURN TSysClass:getLastCloseDate2(TSysClass:getLastOpenDate2()).
END METHOD.

/*****************************
 *
 * @return date
 *
 * �����頥� ��᫥���� ������� ����
 *
 ******************************
 *
 * ����: ��᫮� �. �.
 * ��� ᮧ�����:
 * ���:
 *
 ******************************/

METHOD PUBLIC DATE getLastCloseDate():
  RETURN getLastCloseDate(getLastOpenDate()).
END METHOD.

METHOD PUBLIC LOGICAL isHoliday(INPUT dDate AS DATE).
                            /**************************************
                             *
                             * ��⮤ �����頥� TRUE �᫨ ���� ��室���
                             * ���� ��⮤ �����頥� ���祭�� FALSE.
                             *
                             * ************************************/
   DEF VAR lResult AS LOGICAL INIT NO NO-UNDO.

   if (WEEKDAY(dDate) MODULO 6) EQ 1 THEN
      lResult = YES. 

   FOR FIRST holiday WHERE holiday.op-date EQ dDate NO-LOCK:
      lResult = NOT lResult.
   END.

   RETURN lResult.
END METHOD.

/******************************************
 ��⮤ �����頥� ���祭�� �����䨪���.
 ******/
METHOD PUBLIC CHARACTER getCodeValue(INPUT cCodeClass AS CHARACTER,INPUT cCodeName AS CHARACTER,INPUT cDefault AS CHARACTER):

      FIND FIRST code WHERE code.class EQ cCodeClass 
			   AND code.parent EQ cCodeClass 
			   AND code.code EQ cCodeName 
			NO-LOCK NO-ERROR.
	IF AVAILABLE(code) THEN DO:
		RETURN code.val.
	END.
	ELSE DO:
		RETURN cDefault.
	END.
END METHOD.


/**
 * ��⮤ �����頥� ���� ��ࢮ�� �������
 * ���� ���.
 * @var DATE dOpDate 
 **/

METHOD STATIC PUBLIC DATE getDateFirstClose(INPUT dOpDate AS DATE):

DEF BUFFER bhistory FOR history.

FIND FIRST bhistory WHERE file-name = "op-date" 
		      AND field-value MATCHES "*�����⨥*" 
                      AND field-ref = STRING(dOpDate) 
                      NO-LOCK NO-ERROR.

            IF AVAILABLE(bhistory) THEN RETURN bhistory.modif-date. ELSE RETURN ?. 

END METHOD.

/**
 * ��⮤ �����頥� ���� 
 * ��᫥����� ������� ����. ���.
 * @var DATE dOpDate
 **/

METHOD STATIC PUBLIC DATE getDateLastClose(INPUT dOpDate AS DATE):

DEF BUFFER bhistory FOR history.

FIND LAST bhistory WHERE file-name = "op-date" 
		     AND field-value MATCHES "*�����⨥*" 
		     AND field-ref = STRING(dOpDate) 
                     NO-LOCK NO-ERROR.

            IF AVAILABLE(bhistory) THEN RETURN bhistory.modif-date. ELSE RETURN ?. 

END METHOD.

/**
 * ������뢠�� ��������
 * ��������� ����.
 *
 * @var DATE dBegDate - ��� ��砫� ����
 * @var DATE dEndDate - ��� ����砭�� ����
 **/
METHOD STATIC TAArray calcKursMove (INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT cVal AS CHAR):

/*************************************
 *                                   *
 * 				     *
 * �����뢠�� ������⥫���        *
 * � ����⥫��� ��८業��        *
 * �� ��ਮ� �� opDate �� currDate.  *
 *                                   *
 *************************************
 * ���� : ��᫮� �. �. Maslov D. A. *
 * ���: #858                      *
 * ���  : 05.03.2012                *
 *************************************/
DEF VAR kn       AS DECIMAL NO-UNDO.
DEF VAR kn-1     AS DECIMAL NO-UNDO.
DEF VAR dn       AS DECIMAL NO-UNDO.
DEF VAR iDate    AS DATE    NO-UNDO.

DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR oAArray   AS TAArray   NO-UNDO.
DEF VAR key1      AS CHARACTER NO-UNDO.
DEF VAR value1    AS CHARACTER NO-UNDO.

IF cVal = "" THEN cVal = "810".

oSysClass = new TSysClass().
oAArray   = new TAArray().

DO iDate=dBegDate TO dEndDate - 1:
 kn   = oSysClass:getCBRKurs(INT(cVal),iDate + 1).
 kn-1 = oSysClass:getCBRKurs(INT(cVal),iDate).
 
 dn   = kn - kn-1.

 /*****************************************
  * �᫨ ���� �� ��⠭�����,              *
  * � ��⠥�, �� ��������� �� �뫮.    *
  *****************************************/ 
 IF dn = ? THEN dn = 0.

 oAArray:setH(STRING(iDate + 1),STRING(dn)).

END. /*DO*/


DELETE OBJECT oSysClass.

RETURN oAArray.
END METHOD.

/**
 * @var DECIMAL dSum �㬬� � ��८業��
 * @var DATE dBegDate ��� ��砫� ��८業��
 * @var DATE dEndDate ��� ����砭�� ��८業��
 * @var CHAR cVal ����� �㬬�.
 * @return �㬬� ��८業��
 *
 *    !!! �������� !!!
 * ���� ��᫥ ᥡ� TAArray!
 *
 **/
METHOD STATIC TAArray doRevision (INPUT dSum AS DECIMAL,INPUT dBegDate AS DATE,INPUT dEndDate AS DATE,INPUT cVal AS CHAR):

     DEF VAR iDate AS DATE    NO-UNDO.

     DEF VAR revision AS DECIMAL     NO-UNDO.
     DEF VAR kn    AS DECIMAL        NO-UNDO.
     DEF VAR kn-1  AS DECIMAL        NO-UNDO.
     DEF VAR dResP AS DECIMAL INIT 0 NO-UNDO.
     DEF VAR dResM AS DECIMAL INIT 0 NO-UNDO.

     DEF VAR oAArray AS TAArray     NO-UNDO.
     DEF VAR oSysClass AS TSysClass NO-UNDO.

 oSysClass = new TSysClass().

 oAArray = new TAArray().

 DO iDate = dBegDate TO dEndDate:

    kn   = oSysClass:getCBRKurs(INT(cVal),iDate + 1).
    kn-1 = oSysClass:getCBRKurs(INT(cVal),iDate).


    /* ����稫� ��८業�� �� ���� */
    revision = ROUND(dSum * kn,2) - ROUND(dSum * kn-1,2).


   /* �竨 � ��८業�� */

   /**
    * �᫨ ���� �� ��⠭�����, �
    * ��⠥�, �� ��������� ���� �� �뫮.
    **/
   IF revision = ? THEN revision = 0.
   IF revision > 0 THEN dResP = dResP + revision. ELSE dResM = dResM + revision.
 END.     
  oAArray:setH("p+",dResP).
  oAArray:setH("p-",ABS(dResM)).

  DELETE OBJECT oSysClass.

  RETURN oAArray.    
END METHOD.

/***************************************
 * ��ॢ���� ������ � �㡫�.           *
 * @var INT  val      �����           *
 * @var DEC  summ     �㬬� � ��ॢ��� *
 * @var DATE currDAte ��� ��ॢ���    *
 * @return DECIMAL		               *
 ***************************************/
METHOD PUBLIC DECIMAL convert2rur (INPUT val AS INTEGER,INPUT summ AS DECIMAL,INPUT currDate AS DATE):
   DEF VAR val_t AS CHAR NO-UNDO.
   val_t = STRING(val).
   RETURN THIS-OBJECT:convert2rur(val_t,summ,currDate).
END METHOD.

METHOD PUBLIC DECIMAL convert2rur (INPUT val AS CHAR,INPUT summ AS DECIMAL,INPUT currDate AS DATE):

   IF val <> getSetting("�����悠�") AND val <> "0" THEN DO:
      RETURN ROUND(summ * getCBRKurs(INT(val),currDate),2).
   END. ELSE DO:
      RETURN summ.
   END.

END METHOD.

/**
 * ����砥� ������� ������
 * �⫨��� �� ��悠����.
 * @var CHAR cVal - �����
 * @return CHAR
 **/
METHOD STATIC CHARACTER markValuta (INPUT cVal AS CHARACTER):
   DEF VAR oSysClass AS TSysClass NO-UNDO.
   DEF VAR cRes      AS CHARACTER NO-UNDO.

    oSysClass = new TSysClass().
       cRes = IF cVal <> oSysClass:getSetting("�����悠�") AND cVal <> "" THEN "*" ELSE "".
     DELETE OBJECT oSysClass.

   RETURN cRes.
END METHOD.

/**
 * �����頥� ��᫥���� ���� �����.
 * @var DATE ��室��� ���
 * @return DATE
 **/
METHOD STATIC DATE getMonthEndDate(INPUT dDate AS DATE):
  DEF VAR month     AS INT EXTENT 12 INIT [31,28,31,30,31,30,31,31,30,31,30,31] NO-UNDO.
  DEF VAR currMonth AS INT NO-UNDO.
  DEF VAR lastDay   AS INT NO-UNDO.

  currMonth = MONTH(dDate).  

  currMonth = MONTH(dDate).  

  /**
   * �᫨ ����� 䥢ࠫ�
   **/
  lastDay = month[currMonth].

  IF currMonth = 2 AND YEAR(dDate) MODULO 4 = 0 THEN DO:
     lastDay = 29.    
  END.

 RETURN DATE(MONTH(dDate),lastDay,YEAR(dDate)).
END METHOD.

/**
 * �����頥� ���ᨢ � ��⮩ ����砭��
 * ������� �� ����楢 ��������� dBegDate - dEndDate.
 * @var DATE dBegDate ��砫� ��ਮ�
 * @var DATE dEndDate ����砭�� ��ਮ��
 * @return TAArray
 *        !!! �������� !!!
 * ���� ��᫥ ��ꥪ�!
 **/

METHOD STATIC TAArray getMonthEndDateArray(INPUT dBegDate AS DATE,INPUT dEndDate AS DATE):
   DEF VAR iBegMonth     AS INT     NO-UNDO.
   DEF VAR iEndMonth     AS INT     NO-UNDO.
   DEF VAR iDate         AS DATE    NO-UNDO.
   DEF VAR oAArray       AS TAArray NO-UNDO.
   DEF VAR dEndMonthDate AS DATE    NO-UNDO.

   oAArray   = new TAArray().

   DO iDate = dBegDate TO dEndDate:
     dEndMonthDate = TSysClass:getMonthEndDate(iDate).

     IF dEndMonthDate <= dEndDate THEN DO:
        oAArray:setH(
                     STRING(TSysClass:getMonthEndDate(iDate)),
                     STRING(dEndMonthDate)
                    ).
     END.

   END.
 RETURN oAArray.
END METHOD.

/**
 * �����頥� ���-�� ���� � ����. �� ����室��� ���
 * ���� ��業⮢.
 * @var DATE iYear ��� ��� ���ண� ����塞 ����.
 * @return INT
 **/
METHOD STATIC INT getPercentBase(INPUT iDate AS DATE):
    RETURN TSysClass:getPercentBase(YEAR(iDate)).
END METHOD.

/**
 * �����頥� ���-�� ���� � ����. �� ����室��� ���
 * ���� ��業⮢.
 * @var INT iYear ��� ��� ���ண� ����塞 ����.
 * @return INT
 **/
METHOD STATIC INT getPercentBase(INPUT iYear AS INT):
    RETURN (IF iYear MODULO 4 EQ 0 THEN 366 ELSE 365). 
END METHOD.
/**
 * ��㦥��� ��⮤ ��� ���ਨ,
 * �८�ࠧ�� ���� ���ਨ � DATETIME.
 * @var DATE dDate ��� �� ���ਨ
 * @var INT dTime �६� �� history
 * @result DATETIME
 **/
METHOD STATIC DATETIME history2DT(INPUT dDate AS DATE,INPUT dTime AS INT):
    RETURN DATETIME(STRING(dDate,"99-99-9999") + " " + STRING(dTime,"HH:MM:SS")).
END METHOD.

/**
 * ��⮤ ����뢠�� ������ ����������
 * ��� �������� �㬬� � ���. �����.
 * @param DECIMAL dSum �㬬� � ��� �����
 * @param CHAR    cVal ��� ������
 * @param DATE    dDate ��� ����樨
 * @result DECIMAL
 **/
METHOD PUBLIC DECIMAL getValEq(
                               INPUT dSum AS DECIMAL,
                               INPUT cVal AS CHAR,
                               INPUT dDate AS DATE
                              ):

   DEF VAR kurs      AS DECIMAL           NO-UNDO.
   DEF VAR dSumVal   AS DECIMAL           NO-UNDO.
   DEF VAR iVal      AS INT               NO-UNDO.
   DEF VAR dStep     AS DECIMAL INIT 0.01 NO-UNDO.

   /**
    * �᫨ ��।��� ��悠���,
    * � �����頥� 0.
    **/

   IF cVal = "" OR cVal = "810" THEN RETURN 0.

   iVal = INT(cVal).
   kurs = THIS-OBJECT:getCBRKurs(INT(iVal),dDate).

   dSumVal = ROUND(dSum / kurs,2).

   REPEAT WHILE ROUND(dSumVal * kurs,2) > dSum:
      dSumVal = dSumVal - dStep. 
   END.

  RETURN dSumVal.
END METHOD.

/**
 * ��⮤ ��⠥��� �������� ᭠砫� r-��, �᫨ �� �� 㤠���� ����,
 * � p-��, �᫨ �� ��襫 �� ���� �� �����, � �����頥� ?.
 * @param cFileName CHAR ��� ��楤��� ������ ���������� ��������.
 * @return CHAR ��楤�� ����� �㤥� ����饭� � ॠ�쭮��
 **/
METHOD PUBLIC CHAR whatShouldIRun(INPUT cFileName AS CHAR):
  RETURN TSysClass:whatShouldIRun2(cFileName).
END METHOD.

/**
 * ��⮤ ��⠥��� �������� ᭠砫� r-��, �᫨ �� �� 㤠���� ����,
 * � p-��, �᫨ �� ��襫 �� ���� �� �����, � �����頥� ?.
 * @param cFileName CHAR ��� ��楤��� ������ ���������� ��������.
 * @return CHAR ��楤�� ����� �㤥� ����饭� � ॠ�쭮��
 **/
METHOD PUBLIC STATIC CHAR whatShouldIRun2(INPUT cFileName AS CHAR):

 DEF VAR currFileName AS CHAR NO-UNDO.

 currFileName = ENTRY(1,cFileName,".").

  IF Search(currFileName + ".r") NE ? THEN DO:
     RETURN currFileName + ".r".
  END.

  IF Search(currFileName + ".p") NE ? THEN DO:
     RETURN currFileName + ".p".
  END.

RETURN ?.

END METHOD.

/**
 * ��⮤ ��������� ����.
 * @param  CHAR cMask ��室��� ��᪠
 * @return CHAR
 **/
METHOD PUBLIC CHAR invertMask (INPUT cMask AS CHAR):
 DEF VAR i AS INT NO-UNDO.

 DO i = 1 TO NUM-ENTRIES(cMask):
   ENTRY(i,cMask) = "!" + ENTRY(i,cMask).
 END.

 RETURN cMask.
END METHOD.

METHOD PUBLIC STATIC CHAR invertMask2(INPUT iMask AS CHAR):
  DEF VAR oSysClass AS TSysClass NO-UNDO.
  DEF VAR vRes      AS CHAR      NO-UNDO.

  oSysClass = NEW TSysClass().
     vRes = oSysClass:invertMask(iMask).
  DELETE OBJECT oSysClass.

 RETURN vRes.
END METHOD.

METHOD PUBLIC CHAR buildAcctByMask(INPUT cAcct AS CHAR,INPUT cMask AS CHAR):
  DEF VAR i        AS INT  NO-UNDO.
  DEF VAR currChar AS CHAR NO-UNDO.

  DO i = 1 TO LENGTH(cMask):
     currChar = SUBSTRING(cMask,i,1).
     IF currChar = "�" OR currChar = "�" OR currChar = "x" OR currChar = "�" THEN DO:
              SUBSTRING(cMask,i,1) = SUBSTRING(cAcct,i,1).
     END.
  END.
 RETURN cMask.
END METHOD.

END CLASS