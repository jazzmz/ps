CLASS TClient INHERITS TBase:

DEF PROTECTED VAR iId  AS INTEGER   NO-UNDO.
DEF PROTECTED VAR cInn AS CHARACTER NO-UNDO.


{set-prop.i &aa="cust-cat"   &bb="cType"       &cc="CHARACTER"}
{set-prop.i &aa="name-short" &bb="cNameShort"  &cc="CHARACTER"}
{set-prop.i &aa="address"    &bb="cAddress"    &cc="CHARACTER"}

{set-prop.i &aa="date-in"    &cc="DATE"}
{set-prop.i &aa="date-out"   &cc="DATE"}
{set-prop.i &aa="PK"         &cc="INT64"}

DEF PUBLIC PROPERTY clInn AS CHARACTER
	GET:
		   /************************
		    * �������� ��ਠ��, ��
		    * � ������ ��� �� �㫨,
		    * �� ��⠥� ��થ஬,
		    * ������⢨� ���.
		    *************************/
	    IF NOT LOGICAL(INT64(cInn)) THEN RETURN ?.
					ELSE RETURN cInn.
	END.
	SET (INPUT cValue AS CHARACTER):
	  cInn = cValue.
	END.


CONSTRUCTOR TClient(INPUT type AS CHARACTER, INPUT id AS INT):
            /*****************************
             * ��������� �����        *
             * �� ⨯� ������, � ��� ID *
             *****************************/
    cType = type.
    iId = id.
    Surrogate = STRING(id).
    initClass().
END CONSTRUCTOR.

CONSTRUCTOR TClient(INPUT type AS CHARACTER, INPUT id AS INT64):
            /*****************************
             * ��������� �����        *
             * �� ⨯� ������, � ��� ID *
             *****************************/
    cType = type.
    iId = id.
    Surrogate = STRING(id).
    initClass().
END CONSTRUCTOR.

CONSTRUCTOR TClient(INPUT cAcct AS CHARACTER):
           /********************************
            *                                   *
            * ��������� ����� �� ����  *
            *                                   *
            ********************************/
        DEF VAR oAcct AS TAcct     NO-UNDO.
        DEF VAR tmp   AS CHARACTER NO-UNDO.


        oAcct=new TAcct(cAcct).

         tmp = oAcct:clSurrogate.        
         cType=ENTRY(1,tmp,",") NO-ERROR.
         iId = INTEGER(ENTRY(2,tmp,",")) NO-ERROR.                

        DELETE OBJECT oAcct.
initClass().
END CONSTRUCTOR.

CONSTRUCTOR TClient(INPUT iRec AS HANDLE):
   CASE iRec:NAME:
       WHEN "person" THEN DO:
           ASSIGN
             cType = "�"
             iId   = iRec::person-id
           .          
       END.
       WHEN "cust-corp" THEN DO:
           ASSIGN
             cType = "�"
             iId   = iRec::cust-id
            .
       END.
       WHEN "banks"  THEN DO:
           ASSIGN
             cType = "�"
             iId   = iRec::bank-id
           .
       END.
   END CASE.
 initClass().
END CONSTRUCTOR.

CONSTRUCTOR TClient(INPUT iRecid AS RECID):
    cType = ?.
    iId = ?.
    FIND FIRST cust-corp WHERE RECID(cust-corp) = iRecid NO-LOCK NO-ERROR.
    IF available cust-corp THEN 
      DO:
         cType = "�".
         iId  = cust-corp.cust-id.
      END.                                                                              
    FIND FIRST person WHERE RECID(person) = iRecid NO-LOCK NO-ERROR.
    IF AVAILABLE person THEN 
      DO:
         cType = "�".
         iId  = person.person-id.
      END.                       
    FIND FIRST banks WHERE RECID(banks) = iRecid NO-LOCK NO-ERROR.
    IF AVAILABLE banks THEN 
      DO:
         cType = "�".
         iId  = banks.bank-id.
      END.                       
    if cType = ? or iId = ? then message "�訡�� ᮧ����� ��ꥪ� TClient!" VIEW-AS ALERT-BOX.
    
initClass().
END CONSTRUCTOR.



METHOD PRIVATE VOID initCh():
             /****************************
              * ���樠������� 䨧. ��� *
              ****************************/          
           FIND FIRST person WHERE person-id = iId NO-LOCK NO-ERROR.           
           ASSIGN
                  clinn      = person.inn
                  cNameShort = name-last + " " + first-names
                  date-in    = person.date-in
                  date-out   = person.date-out
                  address    = person.address[1] + " " + person.address[2]
                  ClassCode  = person.class-code
                  PK         = person.person-id
                .
END METHOD.
METHOD PRIVATE VOID initYu():
             /***************************
              * ���樠������� ��. ��� *
              ***************************/
            FIND FIRST cust-corp WHERE cust-id = iId NO-LOCK NO-ERROR.

		/********************************************************
		 * ��� ��. ��� ����� ����� �㡫�஢�����.
		 * ���⮬� ��१��� �㡫�஢����.
		 ********************************************************/
          IF AVAILABLE(cust-corp) THEN DO:

            ASSIGN
                 clinn      = cust-corp.inn
                 cNameShort = cust-corp.name-short
                 date-in    = cust-corp.date-in		 
                 date-out   = cust-corp.date-out
                 ClassCode  = cust-corp.class-code
                 PK         = cust-corp.cust-id
                 .        
           /************************************************
            * ��⥫� ��� ����,                            *
            * �� ����稫��� ��� �ᥣ��.                    *
            * ������ addr-of-low[1] �� �������� �          *
            * ⮣�� REPLACE �뤠�� ᮮ�饭�� �� �訡��.... *
            * � ��㣮� ��஭� � �� �������, ��� �ࠢ��� *
            * ��������� ����� � ���⮬� ��� IF � ���     *
            * ⠪�� �������.                             *
            *************************************************/
            address = cust-corp.addr-of-low[1] + REPLACE(addr-of-low[2],addr-of-low[1],"") NO-ERROR.

          END.
END METHOD.

METHOD PRIVATE VOID initBank():
      FIND FIRST banks WHERE bank-id = iId NO-LOCK.      

      ASSIGN
        clinn = banks.inn
        cNameShort = banks.short-name
        date-in    = banks.date-in		 
        date-out   = banks.date-out
        ClassCode  = banks.class-code
        PK         = banks.bank-id
       .        

END METHOD.

/*************************************
 * ���樠������� ᠬ�� ᥡ�.   *
 *************************************/
METHOD PRIVATE VOID initSelf():
    DEF VAR oSysClass AS TSysClass NO-UNDO.
	
    oSysClass = new TSysClass().
	  clinn = oSysClass:getSetting("���").
    DELETE OBJECT oSysClass.
END METHOD.

METHOD PRIVATE VOID initClass():
    Surrogate = STRING(iId).
    CASE cType:
       WHEN "�" THEN
                DO:
                   ClassType = "person".
                   initCh().  
                END.
       WHEN "�" THEN
                DO:
                  ClassType = "cust-corp".
                  initYu().
                END.
       WHEN "�" THEN 
                DO:
                  ClassType = "banks".
                  initBank().
                END.

	/******** ���������� �� ���� **********/
	WHEN "�" THEN
		DO:
			ClassType="banks".
			initSelf().
		END.
     END CASE.  
END METHOD.
METHOD PRIVATE VOID getCustIdent(INPUT cCustCodeType AS CHARACTER):
/*   FIND FIRST cust-ident WHERE cust-ident=cCustCodeType.*/
END METHOD.

/**
 * �����頥� 㪠��⥫� �� cust-role �� �����.
 * @var DATE dBegDate ��� � ���ன ����� cust-role
 * @var DATE dEndDate ��� � ���ன ����� cust-role
 * @var CHAR cClassCode ��᪠ � �ଠ� CAN-DO ⨯�� cust-role
 * @result LOGICAL
 **/
METHOD PUBLIC HANDLE getCustRole(
                                 INPUT dBegDate AS DATE,
                                 INPUT dEndDate AS DATE,
                                 INPUT cClassCode AS CHAR
                                 ):
  FIND FIRST cust-role WHERE file-name=ClassType
                         AND CAN-DO(cClassCode,cust-role.class-code)
                         AND cust-role.surrogate   EQ THIS-OBJECT:Surrogate
                         AND cust-role.open-date   LE dBegDate
                         AND (cust-role.close-date GE dEndDate OR cust-role.close-date EQ ?)
                         NO-LOCK NO-ERROR.
    IF AVAILABLE(cust-role) THEN DO:
       RETURN BUFFER cust-role:HANDLE.
    END. ELSE DO:
       RETURN ?.
    END.
END METHOD.

/**
 * �஢���� ���� �� ������ �������易��� � ������.
 * @var DATE dDateBeg ���� �� ������ �஢��塞 ஫�.
 * @result LOGICAL
 **/
METHOD PUBLIC LOG isDepended(INPUT dBegDate AS DATE):
    DEF VAR hCustRole AS HANDLE NO-UNDO.
    hCustRole = getCustRole(dBegDate,dBegDate,"����������易���").
    RETURN (IF hCustRole <> ? THEN TRUE ELSE FALSE).
END METHOD.    
/**
 * ��� �� ����.
 * @var DATE dDate ��� �� ������ ����砥� ���.
 * @return CHAR
	 **/
METHOD PUBLIC CHAR getInnByDate(INPUT dDate AS DATE):
	/**********************************************
	 *											  *
	 * �����頥� ��� � ��⮬ ⥬���஢������  *
     *											  *
	 **********************************************/

     DEF VAR tmpInn AS CHAR NO-UNDO.

     tmpInn = getXAttr("inn",dDate).
     
     RETURN (IF tmpInn EQ "" OR tmpInn EQ ? THEN clinn ELSE tmpInn).
END METHOD.


/**
 * �஢���� ����室��� �� ��������� ������ ������
 * @result LOGICAL
 **/
METHOD PUBLIC LOG isClientUpdAnketa():
    DEF VAR oRes AS LOGICAL INIT no NO-UNDO.  /* no - �� �뢮���� ᮮ��饭�� */
    IF cust-cat = "�" OR cust-cat = "�"  THEN 
       RUN pir-updatedanket.p( (IF cust-cat = "�" THEN "person" ELSE "cust-corp" ) , iId ,OUTPUT oRes).
    RETURN oRes.
END METHOD.    


END CLASS.
