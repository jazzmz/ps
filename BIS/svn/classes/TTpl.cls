using Progress.Lang.*.                        /* ������砥� ��⥬�� ������ �ண��� */

/*
����� 蠡��������.
 �室�� �����: 䠩� � ⥪�⮢묨 ��⪠�� - 类�ﬨ;
 ����७��� �����: ������ ᮮ⢥��⢨� 类�� --> ⥪�⮢��� ���祭�� ��� ��ꥪ��, ��ꥪ� ������
 ॠ�����뢠�� ����䥩� ITplElement
*/

CLASS TTpl:
      /**************************************************
       *                                                                             *
       * ����� 蠡��������                                        *
       *                                                                             *
       **************************************************/
      

/* ������ ᮮ⢥��⢨� 类�� --> ����⠢�塞�� ���祭�� */
 DEFINE PROTECTED TEMP-TABLE anchor-value NO-UNDO
                                 FIELD code AS CHARACTER
                                 FIELD code-value-object AS CLASS OBJECT
                                 .

/* ������ ᮮ⢥��⢨� 类�� ---> ��ࠬ��� ��� ��� ����⠢�塞��� ��ꥪ�  ---> ���祭�� ��ࠬ��� ����⠢�塞��� ��ꥪ� */
 DEFINE PROTECTED TEMP-TABLE anchor-param-value NO-UNDO
                                FIELD code AS CHARACTER
                                FIELD paramName AS CHARACTER
                                FIELD paramValue AS CHARACTER
                                .

 
{set-prop.i &aa="filename"  &bb="cFileName" &cc="CHAR" &perms="PROTECTED"}
{set-prop.i &aa="RunTime"   &bb="iRunTime"  &cc="INTEGER"}     /* �६� ࠡ��� 蠡���� */
{set-prop.i &aa="encoding"  &bb="cEncoding" &cc="CHARACTER" &init="'ibm866'"} /* ����஢�� 䠩�� 蠡���� */

{set-prop.i &aa="isInit"    &bb="lIsInit"   &cc="LOGICAL"   &init="FALSE" perms="PRIVATE"}     /* ���樠����஢�� 蠡��� */

DEF PROTECTED VAR SPC AS INTEGER INITIAL 35 LABEL "��� ࠧ����⥫� 类��".
DEFINE PUBLIC PROPERTY splitter AS CHARACTER
        GET:
                RETURN CHR(SPC).
        END GET.
        SET (INPUT cProp AS CHARACTER):
                SPC = ASC(cProp).
        END SET.


 CONSTRUCTOR TTpl(INPUT cTemplateFile AS CHAR):
   RunTime = TIME.
   fileName = cTemplateFile. 
   setServiceTags().                                /* ��⠭�������� �ࢨ�� ���� */
 END CONSTRUCTOR.
 
 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT cValue AS CHARACTER):
                /******************************************************
                 *                                                                                 *
                 * �������� ���祭�� � ⠡���� ᮮ⢥��⢨�  *
                 * 类�� <--> ����⠢�塞�� ���祭��                         *
                 * ��� ����, ����� ������塞 ��ப��,                 *
                 * �⮡� �� �㣠�� ��த 䨫��䨥�,                 *
                 * �� �� ���� ��ꥪ� ���祬, �� ��ப�                 *
                 * �� ⮦� �����                                                          *
                 *                                                                                 *
                 * ******************************************************/
                DEF VAR oObject AS CLASS Object NO-UNDO.

                oObject = new TCharacter(IF cValue = ? THEN "" ELSE cValue).

                addAnchorValue(cAnchor,oObject).

                oObject = ?.
 END METHOD.

 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT iValue AS INTEGER):

                addAnchorValue(cAnchor,STRING(iValue)).

 END METHOD.

 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT daValue AS DATE):
                addAnchorValue(cAnchor,STRING(daValue,"99.99.9999")).
 END METHOD.

 METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT dValue AS DECIMAL):
        DEF VAR cValue    AS CHAR         NO-UNDO.
        DEF VAR cNewValue AS CHAR INIT "" NO-UNDO.
        DEF VAR oSysClass AS TSysClass    NO-UNDO.
        DEF VAR i         AS INT          NO-UNDO.

        DEF VAR p1 AS CHARACTER INITIAL "" NO-UNDO.
        DEF VAR p2 AS CHARACTER INITIAL "" NO-UNDO.

        cValue = STRING(dValue).

        oSysClass = new TSysClass().

        p1 = ENTRY(1,cValue,".").

         IF NUM-ENTRIES(cValue,".") > 1 THEN 
                DO:
                        p2 = "." + ENTRY(2,cValue,".").                
                 END.

        DO i = 0 TO LENGTH(p1) - 1:
                /* ���� � ���⭮� ���浪� */
                IF oSysClass:getRemainder(i + 1,3,0) = 0 THEN cNewValue = "," + SUBSTR(p1,LENGTH(p1) - i,1) + cNewValue.
                ELSE  cNewValue = SUBSTR(p1,LENGTH(p1) - i,1) + cNewValue. 
        END. /* DO */
        IF SUBSTR(cNewValue,1,1) = "," THEN SUBSTR(cNewValue,1,1) = "".

        cNewValue = cNewValue + p2.

        addAnchorValue(cAnchor,cNewValue).
        DELETE OBJECT oSysClass.

 END METHOD.

METHOD PUBLIC VOID addAnchorValue(INPUT cAnchor AS CHARACTER,INPUT cValue AS CLASS Object):
                /********************************************************
                 *                                                                                   *
                 * �������� ���祭�� � ⠡���� ᮮ⢥��⢨�   *
                 * 类� <--> ����⠢�塞�� ���祭��,                  *
                 * ��ꥪ� ⠡���.                                                          *
                 *                                                                                  *
                 *******************************************************/
        IF TYPE-OF(cValue,"ITplElement") THEN
              DO:
                        CREATE anchor-value.
                                 ASSIGN
                                        code = cAnchor
                                        code-value-object = cValue
                                  .
                END.
                ELSE
                        DO:
                                        /* ����� ������ ������ �訡�� ��।���� ����� �� �����ন������ */
                        END.
END METHOD.

METHOD PROTECTED VOID saveParamValue(INPUT cAnchor AS CHARACTER,INPUT cParamValue AS CHARACTER):
                                /*******************************************************************
                                 * ����� � ��࠭�� �������� ��ࠬ��� ��� ���祭��            *
                                 * ��� 类�� cAnchor                                                                    *
                                ********************************************************************/
        DEF VAR cParam AS CHARACTER         NO-UNDO.
        DEF VAR cValue AS CHARACTER INIT "" NO-UNDO.

        cParam = ENTRY(1,cParamValue,"=").
        IF NUM-ENTRIES(cParamValue,"=")  = 2 THEN cValue = ENTRY(2,cParamValue,"=").
        cValue = LEFT-TRIM(cValue,'"').
        cValue = RIGHT-TRIM(cValue,'"').

        CREATE anchor-param-value.
        ASSIGN
                code = cAnchor
                paramName  = cParam
                paramValue = cValue
        .
END METHOD.

METHOD PROTECTED CHARACTER parseAnchor(INPUT cAnchor AS CHARACTER):
                        /****************************************************************************************************************************************
                         *                                                                                                                                                                                                                *
                         * ��⮤ ����� 类�� �� ����稥 ��ࠬ��஢.                                                                                                                                 *
                         * ������ ᫥���騩:                                                                                                                                                                   *
                         * �� �ᥬ �㪢�� 类��                                                                                                                                                                   *        
                         *   ��६ �㪢�                                                                                                                                                                                   *
                         *   �᫨ ������ �஡��, � ��� �஡�� �� ����� ���祭�� ��ࠬ���                                                                                           *
                         *       ����ਬ ������� �� 㦥 ��� 类��,                                                                                                                                           *
                         *               �᫨ ��� �� �� �������, � ���� �� ���� ��ࠬ��� (���⮩) ���������� ��� 类��                                           *
                         *               �᫨ ��� 类�� 㦥 ������� ��뢠�� ��࠭���� � ������� ��ࠡ��� ��ࠬ��� � ��� ���祭��                   *
                         *  �᫨ �� �㪢� �� �஡��                                                                                                                                                                   *
                         *   ��ନ��� ��ப� tmpStr                                                                                                                                                           *
                         *   �᫨ ��������� �㪢� ", � ��� ��ࢮ�� �宦����� ��⠭�������� isValue � ���祭�� ������                                           *
                         *  (� ���� ��砫��� ���祭�� ��ࠬ���, ��� ��ண� �宦����� ���祭�� ��ࠬ��� �����稫���.                                   *
                         *                                                                                                                                                                                                                *
                         *                                                                                                                                                                                                               *
                         ****************************************************************************************************************************************/
        DEF VAR i         AS INT             NO-UNDO.
        DEF VAR strLength AS INT             NO-UNDO.
        DEF VAR isValue   AS LOG  INIT false NO-UNDO.
        DEF VAR cCurrChar AS CHAR            NO-UNDO.
        DEF VAR tmpStr    AS CHAR INIT ""    NO-UNDO.
        DEF VAR cName AS CHARACTER INIT ?    NO-UNDO.

        DEF VAR oSysClass AS TSysClass NO-UNDO.

        cAnchor = TRIM(cAnchor).  /* ������塞�� �� ��譨� �஡���� */

        oSysClass = new TSysClass().
                cAnchor = oSysClass:REPLACE_ASCII(cAnchor,13," ").        /* ������ ��ॢ�� ��ப� �஡���� */
                cAnchor = oSysClass:REPLACE_ASCII(cAnchor,10,"").  /* ����塞 ������ ���⪨ */
        DELETE OBJECT oSysClass.

        cAnchor = cAnchor + " ".          /* ������塞 ���楢�� �஡��. ��� ���� �� �㤥� �������� ��᫥���� ��ࠬ���        */

        

        strLength = LENGTH(cAnchor).

         DO i = 1 TO strLength:
                   cCurrChar = SUBSTRING(cAnchor,i,1).
                   IF cCurrChar = " " AND NOT isValue THEN 
                        DO:
                           IF cName = ? THEN cName = tmpStr.
                                                 ELSE  saveParamValue(cName,tmpStr).
                                tmpStr = "".
                        END.
                        ELSE
                           DO:
                                tmpStr = tmpStr + cCurrChar.
                                IF cCurrChar = '"' THEN isValue = NOT isValue.
                          END.        /* ����� �᫨ �㪢� " */
         END.                        /* ����� �� �ᥩ ��ப� */
   RETURN cName.        
END METHOD.

METHOD PROTECTED VOID showAnchorValue(INPUT cAnchor AS CHARACTER):

                                /****************************************************************
                                 *                                                                                                *
                                 * ��⮤ �ந������ �ᮢ���� 类३.                               *
                                 * ������:                                                                               *
                                 *    1. �����⠢������ 类�� �� 蠡����;                               *
                                 *    2. �஢��塞 ���� �� �� ����⠭����� �� ��;    *
                                 *    3. ������� ��ꥪ� ��� �ᮢ���� � ��।��� ���    *
                                 * ᢮��⢠ �� 蠡����;                                                       *
                                 *    4. ���㥬 �� ��࠭�.                                                       *
                                 *                                                                                               *
                                 ****************************************************************/

        DEF VAR cName AS CHAR NO-UNDO.        /* �������� 类�� */

        
        cName = parseAnchor(cAnchor).        /* ����砥� ⮫쪮 �������� 类��, �� ��ࠬ���� �࠭���� � ��� ⠡��� */

                /*******************************************************
                 *                                                                                 *
                 * �஢��塞 ���室�� �� 类�� ��� 蠡���         *
                 * ���祭�� ����஥筮�� ��ࠬ���.                         *
                 * ���祭��� �� �� ��⠥� 蠡��� ����                 *
                 * ��|���祭����                                                 *
                 * ����᪠���� ��᪮�쪮 ��������:                         *
                 * ��|���祭��1|���祭��2                                         *
                 * �᫨ ���室��, � ��⠥��� ����� ���祭��   *
                 * �� ��, �᫨ ��室�� � ����⠢�塞 ����   *
                 * 类��. �᫨ ���, � ��祣� �� ������                 *
                 *                                                                                 *
                 ******************************************************/

                /*************************************************************
                 * P.S. ����� ��ᬮ���� �� ����� ����� �ப�  *
                 * � �������� ������ ���� ������ ����뢠�騥     *
                 * �।� (���ਬ��, ����, ������������ � �.�.)       *
                 *  ���⮬� ���ᨭ� �� �뭥ᥬ � �⤥��� ��⮤,  *
                 * �⮡� ��⥬ ����� �뫮 �������� ��ࠡ���          *
                 * ��ꥪ⮢.                                                                          *
                 *************************************************************/

        /******************************
         *    ���� ����� NEW-PAGE     *
         ******************************/
        IF cName = "NEW-PAGE" THEN DO:
          PAGE.
          RETURN.
        END.
        /******************************
         *    ����� ���� �����        *
         ******************************/

        IF CAN-DO("��|*",cName) THEN
                DO:
                        /* ��諨 ��⥬�� ��ꥪ� */
                        /* ��뢠�� ��⮤ ���ᨭ�� ��⥬��� ��ꥪ⮢ */
                        setSysClassTags(cName).
                END.

        
        FIND FIRST anchor-value WHERE anchor-value.code = cName NO-ERROR.

        IF AVAILABLE(anchor-value) THEN DO:
                FOR EACH anchor-param-value WHERE anchor-param-value.code = cName:
                    CAST(anchor-value.code-value-object,ITplElement):setPropertyByStr(paramName,paramValue).
                END.
                CAST(anchor-value.code-value-object,ITplElement):setIsInTpl(true).
                CAST(anchor-value.code-value-object,ITplElement):show().
        END. ELSE PUT UNFORMATTED CHR(SPC) + cAnchor + CHR(SPC).

END METHOD.

/*************************************
 * �ந������ ��������� 蠡����.   *
 * ����室�� ��� �ᯮ�짮�����      *
 * ��������� 蠡�����.              *
 ************************************/
METHOD PROTECTED VOID doCompileTemplate():


END METHOD.

METHOD PROTECTED VOID parseFile():
                                /***************************************************************
                                 * ����� ᯮᮡ, �� ����                                                      *
                                 * �� ������ ᯮᮡ ᮧ����� ������⮢ ��� ����              *
                                 * ��������� ⮫쪮 ⠪.                                                      *
                                 * ������:                                                                              *
                                 * 1. ��ᬠ�ਢ��� 䠩� - 蠡���;                                      *
                                 * 2. ��諨 类��, ��뢠�� ��楤��� ��ࠡ�⪨              *
                                 * 类��;                                                                                      *
                                 * 3. ��諨 ⥪�� 蠡����, ���� �뢮��� ��� � 䠩� *
                                 * ��ࠬ��� cTypeTransform - ⨯ �८�ࠧ������               *
                                 ****************************************************************/

DEF VAR lFlag  AS LOG  INITIAL false NO-UNDO.
DEF VAR anchor AS CHAR INITIAL ""    NO-UNDO.

doCompileTemplate().
  
   INPUT FROM VALUE(SEARCH(THIS-OBJECT:filename)) CONVERT SOURCE encoding.

   REPEAT:
   READKEY.

      CASE LASTKEY:
        WHEN -2 THEN LEAVE.      
        WHEN 13 THEN DO:
                                                /* ��諨 ��ॢ�� ��ப� */
                                                /*
                                                        ����ਬ ��� ��室����� ��ॢ�� ��ப�, �᫨ � 类�, 
                                                        � ��祣� �� ������. 
                                                        �᫨ ��� 类��, � ���� �� ������� ��ଫ����, � �뢮��� ��ॢ�� ��ப� 
                                                */
                                                IF lFlag THEN anchor = anchor + CHR(LASTKEY). ELSE PUT UNFORMATTED SKIP.
                                 END.

        WHEN SPC THEN
                    DO:
                        /* �����  �뤥�塞  类��. */
                       IF lFlag  THEN 
                                  DO:
                                                /* ��諨 ����뢠�騩 ��� 类��, ����� ����� �믮����� �८�ࠧ������ */
                                           showAnchorValue(anchor).
                                    lFlag = FALSE.
                                    anchor = "".
                                  END.
                                 ELSE
                                     DO:
                                        lFlag = TRUE.
                                     END.
                      
                    END.
        OTHERWISE
                DO:
                   IF lFlag THEN anchor = anchor + CHR(LASTKEY).
                   ELSE PUT UNFORMATTED CHR(LASTKEY).         
                END.
      END CASE.
END.

END METHOD.

 METHOD PUBLIC VOID show():
                                        /*********************************************************************
                                         * �믮���� �८�ࠧ������ txt -> ������ 类३ -> ��࠭   *
                                         *********************************************************************/
   RunTime = TIME - iRunTime.
   IF SEARCH(THIS-OBJECT:filename) <> ? THEN DO:
       parseFile().
   END. ELSE DO:
       parseBlank().
   END.
   
 END METHOD.
/**
 * ��⮤ �뢮��� ᮤ�ন��� ��� ���
 * 类�� ���� ��� �� ��㣮�.
 **/
METHOD PROTECTED VOID parseBlank():
    PUT UNFORMATTED "*** �������� �� ������ ������ ***" SKIP.
    PUT UNFORMATTED "*** WARNING OBJECT DIDN'T FIND TEMPLATE ***" SKIP.
    PUT UNFORMATTED SKIP.
    PUT UNFORMATTED SKIP.
    
    FOR EACH anchor-value NO-LOCK:
        PUT UNFORMATTED "*** " anchor-value.code " ***" SKIP.
        showAnchorValue(anchor-value.code).
        PUT UNFORMATTED "****" SKIP.
    END.
END METHOD.
METHOD PROTECTED VOID setServiceTags():
                                        /*************************************************************
                                         *                                                                                           *
                                         * ��⮤ ���⠢��� �㦥��� ����                                   *
                                         * ��㦥��� ��� - �� ��� ��稭��騩�� �                           *
                                         * �������樨 Get-<��-����>, ���祭�� ���ண�           *
                                         * ��।������ � ᠬ�� 蠡��������                           *
                                         * ��ࢨ�� ��� ����� �ਭ����� ���祭�� ��           *
                                         * �᫨ ᮢ������ � ��� �� �����.                                   *
                                         *                                                                                           *
                                         *************************************************************/
DEF VAR oSysClass AS TSysClass NO-UNDO.
oSysClass = new TSysClass().

addAnchorValue("GET-RUNTIME",RunTime).                               /* � �����ᥪ㭤�� */
addAnchorValue("GET-DATE",TODAY).                                    /* ������ ��� */
addAnchorValue("GET-TIME",STRING(TIME,"HH:MM:SS")).                  /* �६� � �ଠ� hh:mm:ss */
addAnchorValue("GET-USERFIO",oSysClass:getUserFIO()).                /* ��� ⥪�饣� ���짮��⥫� */
addAnchorValue("GET-USERPOST",oSysClass:getUserPost()).              /* ��������� ���짮��⥫� */
addAnchorValue("GET-USERFIOSHORT",oSysClass:getUserFIO(USERID("bisquit"),"F i. o.")).
DELETE OBJECT oSysClass.

END METHOD.


METHOD PROTECTED VOID setSysClassTags(INPUT cClass AS CHARACTER):
                                        /***********************************************************************************
                                         * ����� ���� �� ����� ⥪�⮢� 类६,                                             *
                                         * � 㪠��⥫�� �� ��⥬�� ��ꥪ�.                                                                     *
                                         * ���⮬� ���� ����⠢��� ᮮ⢥�����騥 ���祭��.                              *
                                         * ���� ����� �������� ������ � ������������ �����������!!!   *
                                         ***********************************************************************************/

   DEF VAR oSysClass   AS TSysClass NO-UNDO.
   DEF VAR currSetting AS CHAR      NO-UNDO.
   DEF VAR bankName     AS CHAR      NO-UNDO.
   DEF VAR bankNameFull AS CHAR      NO-UNDO.

   currSetting = ENTRY(2,cClass,"|").

   oSysClass = new TSysClass().

    /***
     * � �裡 � ����室������� ���ᯥ祭��
     * ⥬���஢������ ������������ �����.
     ***/
    IF    currSetting = "����" 
       OR currSetting = "�������" THEN DO:
             RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).
             addAnchorValue(cClass,bankName).
       END.

    IF     currSetting = "����������" 
        OR currSetting = "�������������" THEN DO:
             RUN VALUE(oSysClass:whatShouldIRun("getbankname.p")) (OUTPUT bankName,OUTPUT bankNameFull).
             addAnchorValue(cClass,bankNameFull).
       END.

       


         CASE NUM-ENTRIES(cClass,"|"):
               WHEN 2 THEN DO:
                  addAnchorValue(cClass,oSysClass:getSetting(ENTRY(2,cClass,"|"))).
               END.
               WHEN 3 THEN DO:
                  addAnchorValue(cClass,oSysClass:getSetting(ENTRY(2,cClass,"|"),ENTRY(3,cClass,"|"))).
               END.
         END CASE.

 DELETE OBJECT oSysClass.

END METHOD.

DESTRUCTOR TTpl():
                                /****************************************************************
                                 *                                                              *
                                 * � ⥡� ��த�� � ⥡� � ���.                                *
                                 *                                                              *
                                 *****************************************************************/
FOR EACH anchor-value:
  DELETE OBJECT anchor-value.code-value-object NO-ERROR.
END.

EMPTY TEMP-TABLE anchor-value.
EMPTY TEMP-TABLE anchor-param-value.
END DESTRUCTOR.

END CLASS.