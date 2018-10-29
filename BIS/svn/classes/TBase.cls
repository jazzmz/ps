CLASS TBase:
   /****************************************************
    *                                                 *
    * ������ �����. �� ��� �।�����祭             *
    * ��� ࠡ��� � ⠡��栬� ����奬�                *
    * � �������⥫�묨 ⠡��栬�.                    *
    *                                                 *
    ****************************************************/
    

   {set-prop.i &aa="ClassType" &bb="cClassType"  &cc="CHARACTER" &perms="PROTECTED"}        /* �������� ⠡���� �� ���ன ����஥� �����        */
   {set-prop.i &aa="Surrogate"  &bb="cSurrogate"   &cc="CHARACTER" &perms="PROTECTED"}	       /* ��।���� ���ண�� ��ꥪ�                                     */
   {set-prop.i &aa="ClassCode" &bb="cClassCode"  &cc="CHARACTER" &perms="PROTECTED"}	       /* ����� ��ꥪ�.                                                                */

   /**********************************************
     *                                           *
     *  �।����������, �� ��।������ �����   *
     * �㤥� �ந��������� � ����� ��᫥�����.  *
     * ����筮 �᫨ �� �뫠 ����������� � ABL    *
     * � �� ᤥ��� ��� ����� ����ࠪ��        *
     * 						 *
  ************************************************/
CONSTRUCTOR TBase():

END CONSTRUCTOR.

METHOD PROTECTED LOGICAL isIndexed(INPUT cXAttrCode AS CHARACTER):
               /****************************************
                *                                     * 
                * ��⮤ �����頥� TRUE,              *
                * �᫨ ४����� �������㥬�          *
                * � FALSE ����.                      *
                *                                     *
                ****************************************/
               FIND FIRST xAttr WHERE xAttr.class-code=ClassCode AND xAttr.XAttr-code = cXAttrCode NO-LOCK NO-ERROR.

                    IF AVAILABLE(xAttr) THEN
          		     DO:
               			/* ���. ४ ��।���� � ����奬� */
          	     		RETURN xAttr.indexed.
          		     END.
	                    ELSE DO:
                                 DISPLAY "�����. ४�����:" ClassCode "." cXattrCode.
                                 RETURN ?.		
                            END.

END METHOD.

/***
 * �����頥� ���祭�� ⥬���஢����� ���. ४�� � ����
 * dDate => Value.
 * @param CHAR cXAttrCode ������������ �������⥫쭮�� ४�����
 * @param DATE dActionDate ��� �� ���ன ����室��� ᬮ���� �������⥫�� ४������
 * @return TAArray
 ***/

METHOD PUBLIC TAArray getTemporalValues(INPUT cXAttrCode AS CHAR,INPUT dActionDate AS DATE):
 DEF VAR oAArray AS TAArray NO-UNDO.

 oAArray = NEW TAArray().
 IF isIndexed(cXAttrCode) THEN DO:
       FOR EACH tmpsigns WHERE tmpsigns.code=cXAttrCode 
                           AND tmpsigns.since <= dActionDate 
                           AND tmpsigns.file-name=ClassType 
                           AND tmpsigns.surrogate=cSurrogate NO-LOCK:
                                   oAArray:setH(since,code-value).
       END.
 END. ELSE DO:
       FOR EACH tmpsigns WHERE tmpsigns.code=cXAttrCode 
                           AND tmpsigns.since <= dActionDate 
                           AND tmpsigns.file-name=ClassType 
                           AND tmpsigns.surrogate=cSurrogate NO-LOCK:
                                   oAArray:setH(since, xattr-value).
       END.                                 
 END.

RETURN oAArray.
  
END METHOD.

  METHOD PROTECTED CHARACTER getValue(INPUT val1 AS CHARACTER,INPUT val2 AS CHARACTER,INPUT cXAttrName AS CHARACTER,INPUT cXAttrType AS CHARACTER):

                /*****************************************
		 * ��।����� ��� �࠭�����	     *
		 * ���祭�� ���. ४� �����	     *
		 * �� ������ � ����奬�.	     * 
		 *				     * 
		 * ������ ����� ��� ������� ���.    *
		 * ४� ���쬠 ����⥫쭮,	     *
		 * �� ���� � ���� �� ᫮������	     *
		 * ���� ���⨭� ����奬� ����     *
		 * �� ���� ��祣� �ਤ㬠��	     *
		 * ����� ���������� �����	     *	
		 * ����� ����������!!!		     *
                 *****************************************/
    IF isIndexed(cXAttrName) THEN RETURN val1. ELSE RETURN val2.
	
END METHOD.   

METHOD PUBLIC CHARACTER getXAttr(INPUT cXAttrCode AS CHARACTER):

      FIND FIRST signs WHERE signs.file-name=ClassType AND signs.surrogate=Surrogate AND signs.code=cXAttrCode NO-LOCK NO-ERROR.

      IF AVAILABLE(signs) THEN        
          DO:
            IF isIndexed(cXAttrCode) THEN RETURN code-value. ELSE RETURN xattr-value.
          END.
          ELSE RETURN ?.   
END METHOD.

/**
 * ��⮤ �����頥� TRUE �᫨ 
 * ⥬���஢���� ४����� ��� 
 * �� ���� ࠧ � �祭��� �६��� ������ ᢮� ���祭��.
 * @param CHAR cXAttrCode  �������� ⥬���஢������ ४�����
 * @param DATE dActionDate ��� ࠭�� ���ன �㤥� �஢������� ���������
 * @return LOG
 **/
METHOD PUBLIC LOG isTmpAttrChanged(
                                   INPUT cXAttrCode AS CHAR,
                                   INPUT dActionDate AS DATE
                                   ):

  DEF VAR vOldVal AS CHAR INIT ?     NO-UNDO.
  DEF VAR vRes    AS LOG  INIT FALSE NO-UNDO.



  FOR EACH tmpsigns WHERE tmpsigns.file-name = THIS-OBJECT:ClassType
                      AND tmpsigns.surrogate = THIS-OBJECT:surrogate
                      AND tmpsigns.code      = cXAttrCode             
                      AND tmpsigns.since    <= dActionDate NO-LOCK:
    IF vOldVal <> ? AND vOldVal <> (IF isIndexed(cXAttrCode) THEN tmpsigns.code-value ELSE tmpsigns.xattr-value) THEN DO:
         vRes = TRUE.
         LEAVE.
    END.

    vOldVal = IF isIndexed(cXAttrCode) THEN tmpsigns.code-value ELSE tmpsigns.xattr-value.

  END.

 RETURN vRes.

END METHOD.

METHOD PUBLIC CHARACTER getXAttr(INPUT cXAttrCode AS CHARACTER,INPUT dActionDate AS DATE):

                     /*********************************************
                      *                                		 *
                      * �㭪�� �����頥� ���祭��              *
                      * ���. ४����⮢ ��ꥪ�.                 *
                      * ��墠�뢠�� �� �� ⥬����-           *
                      * �����.                                  *
                      * ������ ࠡ��� ᫥�.:                   *
                      * 1. ����ਬ ⥬��஢����,               *
                      * �����䨪��� cXAttrCode;                *
                      * 2. �᫨ ⠪�� �� ��⠭�����,             *
                      * � ���� ��� ����� � ��,                 *
                      * � �����頥� ���祭�� ���筮��          *
                      * ���. ४�����.                          *
                      *********************************************/

 FIND LAST tmpsigns WHERE tmpsigns.code=cXAttrCode 
                      AND tmpsigns.since <= dActionDate 
                      AND tmpsigns.file-name=ClassType 
                      AND tmpsigns.surrogate=cSurrogate NO-LOCK NO-ERROR.

     IF AVAILABLE(tmpsigns) THEN
          IF isIndexed(cXAttrCode) THEN RETURN code-value. ELSE RETURN xattr-value.
     ELSE
          RETURN ?.
     
     
END METHOD.

 METHOD PUBLIC CHARACTER getXAttrWDef(INPUT cXAttrCode AS CHARACTER,INPUT cDefault AS CHARACTER):
                     /**********************************
                      * �����頥� ���祭�� ���. ४�  *
                      * � ��砥 �᫨ �� �� ��⠭����� *
                      * �����頥� ���祭�� cDefault   *
                      ***********************************/
      DEF VAR tmpXAttrRes AS CHARACTER.

      tmpXAttrRes = getXAttr(cXAttrCode).
      
       IF tmpXAttrRes EQ ? THEN RETURN cDefault.
                           ELSE RETURN tmpXAttrRes.
END METHOD.

 METHOD PUBLIC CHARACTER getXAttrWDef(INPUT cXAttrCode AS CHARACTER,INPUT dActionDate AS DATE,INPUT cDefault AS CHARACTER):
                    /***********************************************
                     * �����頥� ���祭�� ���. ४�����  *
                     * (���筮�� ��� ⥬���஢������)          *
                     * � ��砥 �᫨ �� �� ��⠭�����             *
                     * �����頥� ���祭�� cDefault               *
                     ***********************************************/
      DEF VAR cResult AS CHARACTER NO-UNDO.
      
      cResult = getXAttr(cXAttrCode,dActionDate).
      IF cResult EQ ? THEN RETURN cDefault.
                      ELSE RETURN cResult.
 END METHOD.                     



 METHOD PUBLIC VOID setXAttr(INPUT cXAttrCode AS CHARACTER,INPUT cXAttrValue AS CHARACTER):

     FIND FIRST xAttr WHERE xAttr.class-code=ClassType AND xAttr.xattr-code=cXAttrCode NO-LOCK NO-ERROR.

          /***********************************************************
           *  ��� ��� ��� ���� �� ��⠭���� ���. ४�����,  *
           * � ᭠砫� �஢��� ��� ����稥 � ����奬�.      *
           ************************************************************/

      IF AVAILABLE(xAttr) THEN
          DO:
             	   /* ���. ४ ��।���� � ����奬� */
                   FIND FIRST signs WHERE signs.file-name=ClassType AND signs.surrogate=Surrogate AND signs.code=cXAttrCode NO-LOCK NO-ERROR.
                             
                            IF AVAILABLE(signs) THEN
                               DO:
                                   /* ���. ४����� 㦥 ��⠭����� � � ⠡��� signs ���� ������ */
                         	     IF xAttr.indexed  THEN signs.code-value=cXAttrValue.  ELSE signs.xattr-value=cXAttrValue.
                               END.
                               ELSE
                                 DO:                                        
                                       CREATE signs.
                                              ASSIGN
                                                     signs.file-name=ClassType
                                                     signs.surrogate=cSurrogate
                                                     signs.code=cXAttrCode
                                              .
                                       	 IF xAttr.indexed  THEN signs.code-value=cXAttrValue. ELSE signs.xattr-value=cXAttrValue.
                                 END.
          END. /* ����� �᫨ ���. ४. ��⠭����� �� ����奬� */
END METHOD.

METHOD PUBLIC VOID rmXAttr(INPUT cXAttrCode AS CHARACTER):
                    /**********************************
                     * ������ ����� ���祭��  *
                     * ���. ४�����.                    *
                     **********************************/

FIND FIRST signs WHERE signs.file-name=cClassType AND signs.surrogate=cSurrogate AND signs.code=cXAttrCode NO-ERROR.

 IF AVAILABLE(signs) THEN
   DO:
/*      DELETE signs.*/
   END.


END METHOD.

METHOD PUBLIC LOGICAL isValidXAttr(INPUT cXAttrCode AS CHARACTER):
		/*******************************************************
		 *										                                *
		 * �஢�ઠ �����⨬��� �ᯮ�짮����� ���.   *
           * ४�����                                                             *
		 *										                                *
		 ********************************************************/
	FIND FIRST xAttr WHERE xAttr.Class-Code=ClassType AND xAttr.xattr-code=cXAttrCode NO-LOCK NO-ERROR.
     IF AVAILABLE(xAttr) THEN RETURN TRUE. ELSE RETURN FALSE.
END METHOD.

METHOD PUBLIC VOID getHistory():
              /************************************
               * �����頥� ��� ����� ��ꥪ�   *
               ************************************/
END METHOD.
END CLASS.