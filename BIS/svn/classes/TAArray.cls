/**************************
 * ��������� ���
 ***************************/
CLASS TAArray IMPLEMENTS IIteration, IDumpable:

DEF PROTECTED TEMP-TABLE tbl_aarray NO-UNDO
						   FIELD id      AS INT64
						   FIELD code    AS CHAR
						   FIELD val     AS CHAR
						   INDEX idx_code IS PRIMARY code   
						   INDEX idx_id id
						.


{set-prop.i &aa="length"   &cc="INT64"   &init="0"     &perms="PRIVATE"}
{set-prop.i &aa="curr"     &cc="INT64"   &init="0"     &perms="PRIVATE"}
{set-prop.i &aa="defValue" &cc="CHAR"    &init=?       &perms="PRIVATE" &perm="PRIVATE"}
{set-prop.i &aa="EOA"      &cc="LOGICAL" &init="TRUE"  &perms="PRIVATE" &perm="PROTECTED"}

CONSTRUCTOR TAArray():

END METHOD.

/**
 * @param CHAR cDefValue ���祭�� �����頥���
 * �� ������⢨� ���祭�� � ���ᨢ�.
 **/
CONSTRUCTOR TAArray(INPUT cDefValue AS CHAR):
 defValue = cDefValue.
END CONSTRUCTOR.    

/*******

  ��⮤ �������� ���祭�� � ���

 *******/

METHOD VOID setH(INPUT cKey AS INT,INPUT cValue AS INT):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS INT,INPUT cValue AS CHAR):
   setH(STRING(cKey),cValue).
END METHOD.



METHOD VOID setH(INPUT cKey AS INT64,INPUT cValue AS INT64):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.


METHOD VOID setH(INPUT cKey AS DATE,INPUT cValue AS DECIMAL):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS DATE,INPUT cValue AS CHAR):
   setH(STRING(cKey),cValue).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHAR,INPUT cValue AS DATE):
   setH(STRING(cKey),STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS DECIMAL):
   setH(cKey,STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS INT64):
   setH(cKey,STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS LOG):
   setH(cKey,STRING(cValue)).
END METHOD.

METHOD VOID setH(INPUT cKey AS CHARACTER,INPUT cValue AS CHARACTER):

/***************************
 *			   *
 * ��⠭�������� 㪠��⥫� *
 * �� ����� ������.       *
 *			   *
 ****************************/ 
EOA = FALSE.
FIND FIRST tbl_aarray WHERE code = cKey EXCLUSIVE-LOCK NO-ERROR.

	IF AVAILABLE(tbl_aarray) THEN DO:
	   tbl_aarray.val = cValue.
	END.
	ELSE DO:
		length = length + 1.
		CREATE tbl_aarray.

		ASSIGN
			tbl_aarray.id   = length
			tbl_aarray.code = cKey
			tbl_aarray.val  = cValue
		.
	  END.
END METHOD.

METHOD PUBLIC TAArray push(INPUT cValue AS INT64):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS INT):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS RECID):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS LOG):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.
METHOD PUBLIC TAArray push(INPUT cValue AS DEC):
   RETURN THIS-OBJECT:push(STRING(cValue)).
END METHOD.




METHOD PUBLIC TAArray push(INPUT cValue AS CHAR):
  THIS-OBJECT:setH(STRING(THIS-OBJECT:length),cValue).
  RETURN THIS-OBJECT.
END METHOD.

METHOD PUBLIC CHAR pop():
   DEF VAR cRes AS CHAR INIT ? NO-UNDO.
   FIND LAST tbl_aarray EXCLUSIVE-LOCK NO-ERROR.

   IF AVAILABLE(tbl_aarray) THEN DO:
    cRes = tbl_aarray.val.
    DELETE tbl_aarray.
    length = length - 1.
   END.


   RETURN cRes.
END METHOD.

METHOD PUBLIC CHAR delete(INPUT cKey AS CHAR):
   DEF VAR cRes AS CHAR INIT ? NO-UNDO.

   FIND LAST tbl_aarray WHERE code = cKey EXCLUSIVE-LOCK NO-ERROR.

   IF AVAILABLE(tbl_aarray) THEN DO:
     cRes = tbl_aarray.val.
     DELETE tbl_aarray.
     length = length - 1.
   END.

  RETURN cRes.
END METHOD.

/*****************************
 * ����砥� ���祭�� 
 *****************************/
METHOD CHAR get(INPUT cKey AS CHARACTER):

	FIND FIRST tbl_aarray WHERE tbl_aarray.code = cKey NO-LOCK NO-ERROR.
	
	IF AVAILABLE(tbl_aarray) THEN DO:
		RETURN tbl_aarray.val.
	END.

	RETURN defValue.
END METHOD.

METHOD DECIMAL getInDec(INPUT cKey AS CHAR):
    RETURN DECIMAL(get(cKey)).
END METHOD.

METHOD CHARACTER get(INPUT cKey AS DATE):
  RETURN get(STRING(cKey)).
END METHOD.

METHOD CHARACTER get(INPUT cKey AS INT):
  RETURN get(STRING(cKey)).
END METHOD.

METHOD CHARACTER get(INPUT cKey AS INT64):
  RETURN get(STRING(cKey)).
END METHOD.


METHOD VOID dump():
 FOR EACH tbl_aarray BY id:
   DISPLAY code FORMAT "x(20)" val FORMAT "x(20)".
 END.
END.

METHOD VOID dump(INPUT cFileName AS CHAR):
   TEMP-TABLE tbl_aarray:WRITE-XML("file",cFileName,YES,?,?,NO,NO).
END.
/*****************
 * ����砥� ���祭�� � 㢥��稢��� ���稪
 *****************/
METHOD CHARACTER get_(OUTPUT cKey AS CHARACTER):

   DEF VAR lRes AS CHAR NO-UNDO.

  /***********
   * �᫨ � ���ᨢ� ��祣� ���,
   * � �����頥� ���� � ����ਬ,
   * �� ��祣� ���.
   ***********/
  IF length <= 0 THEN DO:
       EOA = TRUE.
       lRes = ?.
  END. 
  ELSE DO:

    curr = curr + 1.

    FIND FIRST tbl_aarray WHERE tbl_aarray.id = curr NO-LOCK NO-ERROR.

	IF AVAILABLE(tbl_aarray) THEN DO:
         ASSIGN
	  cKey = tbl_aarray.code
          lRes = tbl_aarray.val
         .
	END.
                                        
    IF curr = length THEN EOA = TRUE.
 END.

 RETURN lRes.
END METHOD.

/**
 * �����頥� ��ࢮ� ���祭��.
 **/
METHOD CHARACTER getFirst():

	FIND FIRST tbl_aarray NO-LOCK NO-ERROR.
	
	IF AVAILABLE(tbl_aarray) THEN DO:
		RETURN tbl_aarray.val.
	END.

	RETURN ?.

END METHOD.

/**
 * �����頥� ��᫥���� ���祭�� ᯨ᪠.
 **/
METHOD CHARACTER  getLast():
	FIND LAST tbl_aarray NO-LOCK NO-ERROR.
	
	IF AVAILABLE(tbl_aarray) THEN DO:
		RETURN tbl_aarray.val.
	END.

	RETURN ?.
END METHOD.

/******************
 * ����뢠�� ���稪
 *******************/
METHOD VOID reset_():
  curr = 0.
  IF length > 0 THEN  EOA = FALSE.
END METHOD.

METHOD PUBLIC LOGICAL EOI():
  RETURN EOA.
END METHOD.


METHOD PUBLIC CHARACTER save2str():
  DEF VAR cRes  AS CHARACTER INITIAL "" NO-UNDO.

  FOR EACH tbl_aarray NO-LOCK:
	cRes = cRes + tbl_aarray.val + ",".
  END.

  cRes = TRIM(cRes,",").
 RETURN cRes.
END METHOD.

/**
 * �ந������ ��᫥�������
 * ᢮��� �� ���ᨢ� oa � 
 * ⥪�騩 ���ᨢ.
 * @param TAArray oa ���ᨢ �� ���ண� ���� 
 * ��᫥�������� ᢮��⢠.
 * @return TAArray
 **/
METHOD PUBLIC TAArray ext(INPUT oa AS TAArray):
 DEF VAR key1 AS CHARACTER NO-UNDO.
 DEF VAR val1 AS CHARACTER NO-UNDO.

 {foreach oa key1 val1}
    THIS-OBJECT:setH(key1,val1).
 {endforeach oa}

 RETURN THIS-OBJECT.
END METHOD.

 /**
  * ��ਫ���� �������� ᯨ᪠ � ��ப�. � ����⢥
  * ࠧ����⥫� �ᯮ������ ~n.
  * @return TAArray
  **/
METHOD PUBLIC LONGCHAR toDataLine():
  RETURN toDataLine(TRUE).
END METHOD.
/**
 * ��⮤ �ਠ����樨 � DataLine.
 *
 * �������� ��� ��ਠ�� ����᪠:
 * 1. ���࠭����� ⮫쪮 ���祭��;
 * 2. ��ன ��ਠ�� ��࠭����� ���� ���� --> ���祭��.
 * @param LOG onlyValues ���࠭��� ⮫쪮 ���祭��
 * ��� � ���� ���� ���祭��.
 *
 **/
METHOD PUBLIC LONGCHAR toDataLine(INPUT onlyValues AS LOG):
   RETURN THIS-OBJECT:toDataLine("~n",onlyValues).
END METHOD.

/**
 * ��ਫ���� ᯨ᮪.
 * @param cSplitter  CHAR ࠧ����⥫�
 * @param onlyValues LOG  �᫨ TRUE, � ���� ���㦠���� ⠪�� � ���� ᯨ᪠
 * @return LONGCHAR
 */
METHOD PUBLIC LONGCHAR toDataLine(INPUT cSplitter AS CHAR,INPUT onlyValues AS LOG):
    DEF VAR key1 AS CHAR         NO-UNDO.
    DEF VAR val1 AS CHAR         NO-UNDO.
    DEF VAR cRes AS CHAR INIT "" NO-UNDO.
    
    cRes = "".
    {foreach THIS-OBJECT key1 val1}
         IF val1 <> ? THEN DO:         
          cRes = cRes + (IF onlyValues THEN cSplitter + val1 ELSE cSplitter + key1 + cSplitter + val1).
         END.
    {endforeach THIS-OBJECT}
    cRes = SUBSTRING(cRes,2).
    RETURN cRes.
END METHOD.

/**
 * ����㧨�� ᯨ᮪ �� ��ப�.
 * @param cDataLine  LONGCHAR ��ப� � ᯨ᪮�
 * @param onlyValues LOG      �᫨ ��⨭�, � �� ᯨ᪠ ����㦠���� ⮫쪮 ���祭��. ���� ��⠥���, �� � ��ப� ���� � ᮮ⢥�����饥 ��� ���祭�� ᯨ᪠
 * @return TAArray
 **/
METHOD PUBLIC TAArray loadDataLine(INPUT cDataLine AS LONGCHAR,INPUT onlyValues AS LOG):
 RETURN THIS-OBJECT:loadSplittedList(cDataLine,"~n",onlyValues).
END METHOD.

/**
 * �������� ��ꥪ�-ᯨ᮪ ���祭�ﬨ.
 * @param cDataLine  LONGCHAR ᯨ᮪ ���祭��
 * @param cSplitter  CHAR     ࠧ����⥫� ᯨ᪠
 * @param onlyValues LOG      �᫨ LOG � ����� �������� ᯨ᪠ ������� ���砬�, � ��� ���祭�ﬨ �� �⨬ ���砬.
 * @return TAArray
 **/

METHOD PUBLIC TAArray loadSplittedList(INPUT cDataLine AS LONGCHAR,INPUT cSplitter AS CHAR,INPUT onlyValues AS LOG):
    DEF VAR i AS INT NO-UNDO.

    IF NOT onlyValues THEN DO:
      DO i = 0 TO NUM-ENTRIES(cDataLine,cSplitter) / 2 - 1:
         THIS-OBJECT:setH(STRING(ENTRY(2 * i + 1,cDataLine,cSplitter)),STRING(ENTRY(2 * (i + 1),cDataLine,cSplitter))).
      END.
    END.

    IF onlyValues THEN DO:
            THIS-OBJECT:loadList(cDataLine,cSplitter).
    END.

  RETURN THIS-OBJECT.
END METHOD.


/**
 * ����㦠�� ᯨ᮪ ��� ������ ���� => ���祭�� �࠭���� �� ����� ��ப�. 
 * @param cDataLine LONGCHAR ᮤ�ন��� 䠩��.
 * @param cSplitter CHAR     ࠧ����⥫� ���祭�� ᯨ᪠
 * @return TAArray
 **/
METHOD PUBLIC TAArray loadListInLines(INPUT cDataLine AS LONGCHAR,INPUT cSplitter AS CHAR):
  DEF VAR i       AS INT64    NO-UNDO.
  DEF VAR currRow AS LONGCHAR NO-UNDO.

  DO i = 1 TO NUM-ENTRIES(cDataLine,"~n"):
      currRow = ENTRY(i,cDataLine,"~n").

      THIS-OBJECT:setH(ENTRY(1,currRow,cSplitter),ENTRY(2,currRow,cSplitter)).
  END.
 RETURN THIS-OBJECT.
END METHOD.


/**
 * ������ ������� �८�ࠧ����� � JSON
 * @result JSON
 **/
METHOD PUBLIC LONGCHAR toJSON():
    DEF VAR key1 AS CHAR         NO-UNDO.
    DEF VAR val1 AS CHAR         NO-UNDO.
    DEF VAR cRes AS CHAR INIT "" NO-UNDO.
    
    cRes = "\{".
    {foreach THIS-OBJECT key1 val1}
        cRes = cRes + "\"" + key1 + "\":\"" + (IF val1 = ? THEN "" ELSE val1) + "\",".
    {endforeach THIS-OBJECT}
    cRes = TRIM(cRes,",").
    cRes = cRes + "\}".
    RETURN cRes.
END METHOD.  

METHOD PUBLIC LONGCHAR toJSON2():
   DEF VAR vRes AS LONGCHAR NO-UNDO.

   TEMP-TABLE tbl_aarray:DEFAULT-BUFFER-HANDLE:WRITE-JSON("LONGCHAR",vRes,TRUE).

 RETURN vRes.
END METHOD.

/*** 
 * ����㦠��
 */
METHOD PUBLIC VOID loadJSON(INPUT iJSONStr AS CHAR):
    DEF VAR lJSONStr AS LONGCHAR NO-UNDO.

    THIS-OBJECT:length = 0.

    lJSONStr = iJSONStr.

    TEMP-TABLE tbl_aarray:READ-JSON("LONGCHAR",lJSONStr,"EMPTY").

    FOR EACH tbl_aarray NO-LOCK:
       THIS-OBJECT:length = THIS-OBJECT:length + 1.
    END.


END METHOD.

METHOD PUBLIC STATIC TAArray loadJSON2(INPUT iJSONStr AS CHAR):
     DEF VAR oAArray AS TAArray NO-UNDO.

     oAArray = NEW TAArray().
     oAArray:loadJSON(iJSONStr).

 RETURN oAArray.
END METHOD.

/**
 * ��ਫ���� ᯨ᮪. � ����⢥ ࠧ����⥫� �ᯮ������ "," (������). ���㦠���� ⮫쪮 ���祭�� ᯨ᪠.
 * @return CHAR
 **/
METHOD PUBLIC CHAR toList():
 RETURN STRING(THIS-OBJECT:toDataLine(",",TRUE)).
END METHOD.

/**
 * ��ਫ���� ᯨ᮪. � ����⢥ ࠧ����⥫� �ᯮ������ "," (������).
 * @param onlyValue LOG �᫨ ��⨭�, � ���㦠���� ⮫쪮 ���祭��, ���� ���㦠���� ���� � ���祭��.
 * @return CHAR
 **/

METHOD PUBLIC CHAR toList(INPUT onlyValues AS LOG):
   RETURN STRING(THIS-OBJECT:toDataLine(",",onlyValues)).
END METHOD.

/**
 * ����㦠�� �ਫ�������� �������� ᯨ᪠. � ����⢥ ���祩 ������� 楫� �᫠ �� 0 �� ����� ᯨ᪠
 * @param cList LONGCHAR ��ப� � ᯨ᪮�
 * @param cSplitter CHAR ࠧ����⥫�
 * @return TAArray
 */
METHOD PUBLIC TAArray loadList(INPUT cList AS LONGCHAR,INPUT cSpliter AS CHAR):
   DEF VAR i AS INT NO-UNDO.
   DO i = 1 TO NUM-ENTRIES(cList,cSpliter):
       THIS-OBJECT:push(STRING(ENTRY(i,cList,cSpliter))).
   END.
 RETURN THIS-OBJECT.   
END METHOD.

/**
 * ����㦠�� ᯨ᮪ ࠧ������� �����묨. � ����⢥ ���祩 ������� 楫� �᫠ �� 0 �� ����� ᯨ᪠
 * @param cList LONGCHAR ��ப� � ᯨ᪮�
 * @return TAArray
 **/
METHOD PUBLIC TAArray loadList(INPUT cList AS LONGCHAR):
  THIS-OBJECT:loadList(cList,",").
  RETURN THIS-OBJECT.
END METHOD.
/**
 * �����稢��� ���祭�� ���ᨢ� hash �� dSum
 * @param CHAR hash ������� ����� 㢥��稢���
 * @param DECIMAL dSum �㬬� �� ������ 㢥��稢���
 * @result TArray
 **/
METHOD PUBLIC TAArray incrementTo(INPUT hash AS CHAR,INPUT dSum AS DECIMAL):
    DEF VAR dRes AS DECIMAL NO-UNDO.
    DEF VAR val1 AS CHAR    NO-UNDO.
    val1 = IF THIS-OBJECT:get(hash) <> ? THEN THIS-OBJECT:get(hash) ELSE "0".
    dRes = DECIMAL(val1). 
    THIS-OBJECT:setH(hash,dRes + dSum).
    RETURN THIS-OBJECT.
END METHOD.

/**
 * �뤠�������� ����७��� �।�⠢�����
 * � 䠩�.
 * @param CHAR cFileName ��� XML 䠩��.
 **/
METHOD PUBLIC VOID SAVE-XML(INPUT cFileName AS CHAR):
    TEMP-TABLE tbl_aarray:WRITE-XML("file",cFileName,YES,?,?,NO,NO).
END METHOD.

/**
 * ������ ᮤ�ন��� ᯨ᪠.
 **/
METHOD PUBLIC VOID empty():
 EMPTY TEMP-TABLE tbl_aarray.
 length = 0.
 THIS-OBJECT:reset_().
END METHOD.

/**
 * ��⮤ �஢���� ����稥 � ᯨ᪥ ���祭�� � ����� cCode
 * @param cCode CHAR ���� ��� �஢�ન
 * @return LOG
 **/

METHOD PUBLIC LOG hasCode(INPUT cCode AS CHAR):
  RETURN THIS-OBJECT:get(cCode) <> ?.
END METHOD.

END CLASS.
/***
 {foreach oar key value}
    {&out} key value.
  {endforeach oar}
*/