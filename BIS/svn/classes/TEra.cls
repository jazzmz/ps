  /*------------------------------------------------------------------------
    File        : TEra
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : dmaslov
    Created     : Tue Jun 05 09:47:52 MSD 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS TEra:

  {set-prop.i &aa="hWebService" &cc="HANDLE"}
  {set-prop.i &aa="hpt" &cc="HANDLE"}
      
  CONSTRUCTOR TEra(INPUT lType AS LOG):
         connect().
  END CONSTRUCTOR.
     
METHOD PROTECTED VOID connect():
  CREATE SERVER hWebService.
  hWebService:CONNECT("-WSDL " + OS-GETENV("EARCH") + " ") NO-ERROR.

  IF NOT hWebService:CONNECTED() THEN DO:
         MESSAGE "�訡��! ���������� ����������� � ��⥬� �࠭����!" VIEW-AS ALERT-BOX.
         RETURN.
  END.
  
  RUN WfControllerPortType SET hpt ON SERVER hWebService.
  
END METHOD.         
 
/**
 * ��⮤ �������� ���㬥�� � �����஭��� �࠭����
 *
 * @var CHAR num ����� ���㬥��
 * @var CHAR opdate ��� ���� ��� � �ଠ� YYYY-mm-dd
 * @var CHAR expn ����� ३� �� ���஬� ���㬥��� ���㦠����
 * @var CHAR author ���� ���㬥��
 * @var CHAR inspector ����஫��� ���㬥��
 * @var CHAR cFileName ���� � 䠩�� � ����묨
 * @return INT64 Primary Key ���㬥�� � �����஭��� ��娢�
 **/
METHOD PUBLIC INT64 addDoc(INPUT num AS CHAR,INPUT opdate AS CHAR,INPUT expn AS CHAR,INPUT author AS CHAR,INPUT inspector AS CHAR,INPUT cFileName AS CHAR):
       DEF VAR iRes    AS INT      NO-UNDO.
       DEF VAR details AS LONGCHAR NO-UNDO.
       details = getFile(cFileName). 
       RUN addDoc IN hpt ({cpc num},{cpc opdate},{cpc expn},{cpc author},{cpc inspector},{cpc details},OUTPUT iRes).
      RETURN iRes.
END METHOD.

/**
 * �����頥� ᮤ�ন��� 䠩��
 * @var CHAR cFileName ���� � 䠩�� � ����묨
 * @return LONGCHAR ����ন��� 䠩��
 **/
METHOD PUBLIC LONGCHAR getFile(INPUT cFileName AS CHAR):
       DEF VAR details      AS LONGCHAR       NO-UNDO.
       DEF VAR fileInMemory AS MEMPTR         NO-UNDO.

       COPY-LOB FROM FILE cFileName TO fileInMemory.
       details=BASE64-ENCODE(fileInMemory).
    RETURN details.
END METHOD.    

/**
 * �������� 䠩� � �����஭�� ��娢 � �ந�����묨
 * ��ࠬ��ࠬ�.
 * @var TAArray oArray ���ਡ��� ���㬥���
 * @var CHAR cFileName ���� � 䠩�� � ����묨
 * @return INT64 Primary Key ���㬥�� � �����஭��� �࠭����
 **/

METHOD PUBLIC INT64 addCustomDoc(INPUT oArray AS TAArray,INPUT cFileName AS CHAR):
    DEF VAR details AS LONGCHAR NO-UNDO.
    DEF VAR json    AS LONGCHAR NO-UNDO.
    DEF VAR iRes    AS INT      NO-UNDO.
    details = getFile(cFileName).
    json    = oArray:toJSON().

    RUN addCustomDoc IN hpt({cpc json},{cpc details},OUTPUT iRes).
    RETURN iRes.
END METHOD.    

/**
 * �������� 䠩� � �����஭�� ��娢 � �ந�����묨 ��ࠬ��ࠬ�,
 * �।���⥫쭮 ����訢��� ᮣ��ᨥ �� ��࠭����.
 * @var TAArray oArray  ��ࠬ���� ���㬥��
 * @var CHAR cFileName ���� � 䠩�� � ����묨
 * @return INT64 ��ࢨ�� ���� ���㬥�� � �����஭��� �࠭����
 **/

METHOD PUBLIC INT64 askAndSave(INPUT oArray AS TAArray,INPUT cFileName AS CHAR):
  DEF VAR doUnload AS LOG NO-UNDO.
  MESSAGE "�㤥� ���㦠�� � �����஭�� ��娢?" VIEW-AS ALERT-BOX BUTTONS YES-NO TITLE "����� �� ���㧪�" SET doUnload.

  IF doUnload THEN DO:
   RETURN addCustomDoc(oArray,cFileName).
  END. ELSE DO:
   RETURN ?.
  END.

END METHOD.

/** 
 * �८�ࠧ��� ���� � �ଠ� YYYY-mm-dd
 * @var DATE dDate ���
 * @return CHAR
 **/
METHOD STATIC CHAR getDate(INPUT dDate AS DATE):
  DEF VAR oSysClass AS TSysClass NO-UNDO.
  DEF VAR cRes      AS CHAR      NO-UNDO.

  oSysClass = new TSysClass().
    cRes = oSysClass:DATETIME2STR(dDate,"%Y-%m-%d").
  DELETE OBJECT oSysClass.
 RETURN cRes.  
END METHOD.

METHOD PUBLIC LOG disconnect():
 hWebService:DISCONNECT().
 DELETE OBJECT hWebService.
END METHOD.

DESTRUCTOR TEra():
 hWebService:DISCONNECT().
 DELETE OBJECT hWebService.   
END DESTRUCTOR.                      

END CLASS.