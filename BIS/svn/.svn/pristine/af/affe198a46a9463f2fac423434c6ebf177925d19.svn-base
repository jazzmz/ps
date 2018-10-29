/******************************
 * Для отображения информации *
 * о пользователе.            *
 ******************************/

CLASS TUser INHERITS TBase:

{set-prop.i &aa="user-id" &bb="cuser-id" &cc="CHARACTER"}


CONSTRUCTOR TUser(INPUT cUserId AS CHARACTER): 
   SUPER().
   FIND FIRST _user WHERE _user._userid = cUserId NO-LOCK NO-ERROR.
   fillObject(BUFFER _user:HANDLE).

END CONSTRUCTOR.

CONSTRUCTOR TUser():

  FIND FIRST _user WHERE _user._userid = USERID("bisquit") NO-LOCK NO-ERROR.
  fillObject(BUFFER _user:HANDLE).

END CONSTRUCTOR.

METHOD PROTECTED VOID fillObject(INPUT bfh AS HANDLE):

  ASSIGN
   ClassType = "_user"
   ClassCode = "_user"
   Surrogate = _user._userid
   user-id = bfh::_userid
  .
END METHOD.

METHOD PUBLIC LOGICAL isInGroup():

END METHOD.

/***********************************
 * Возвращает список ролей в которые
 * входит пользователь.
 ***********************************
 *
 *    *** !!! ВНИМАНИЕ !!! ***     *
 *     УБЕЙ ЗА СОБОЙ ОБЪЕКТ !!!    *
 *
 ***********************************/
METHOD PUBLIC TAArray getRoleAArray(INPUT cMask AS CHARACTER):
   DEF VAR oaa AS TAArray NO-UNDO.
   DEF VAR i   AS INT	  NO-UNDO INITIAL 1.

  oaa = new TAArray().
  FOR EACH user-role WHERE user-role.user-id EQ user-id 
			   AND CAN-DO(cMask,user-role.role-id) NO-LOCK:
    oaa:setH(STRING(i),user-role.role-id).
    i = i + 1.
  END.

  RETURN oaa.
END METHOD.

METHOD PUBLIC TAArray getRoleAArray():
   RETURN getRoleAArray("*").
END METHOD.

METHOD PUBLIC CHAR getRoleList(INPUT cMask AS CHAR):
  DEF VAR oaa  AS TAArray   NO-UNDO.
  DEF VAR cRes AS CHARACTER NO-UNDO.
  oaa = getRoleAArray(cMask).
    cRes = oaa:save2str().
  DELETE OBJECT oaa.
 RETURN cRes. 
END METHOD.

METHOD PUBLIC STATIC CHAR getUserLst(INPUT iMask AS CHAR):
  DEF VAR vUser AS TUser NO-UNDO.
  DEF VAR vRes  AS CHAR  NO-UNDO.

  vUser = NEW TUser().
    vRes = vUser:getUserList(iMask).
  DELETE OBJECT vUser.

 RETURN vRes.
END METHOD.

/***********************************
 * Возвращает список пользователей *
 * которые входят в роль.          *
 ***********************************
 *                                   *
 *    *** !!! ВНИМАНИЕ !!! ***     *
 *     УБЕЙ ЗА СОБОЙ ОБЪЕКТ !!!    *
 *                                   *  
 ***********************************/
METHOD PUBLIC TAArray getUserAArray(INPUT cGroupName AS CHAR):

  DEF VAR oaa AS TAArray 	 NO-UNDO.
  DEF VAR i AS INTEGER INITIAL 0 NO-UNDO.

  oaa = new TAArray().

  FOR EACH user-role WHERE user-role.role-id EQ cGroupName NO-LOCK:
    i = i + 1.
    oaa:setH(STRING(i),user-role.user-id).
  END.

 RETURN oaa.
END METHOD.





/****************************************
 * Метод возвращает пользователей       *
 * группы в виде списка, разделенного   *
 * запятыми.                            *
 ****************************************/

METHOD PUBLIC CHARACTER getUserList(INPUT cGroupName AS CHARACTER):
    DEF VAR oaa   AS TAArray NO-UNDO.
    DEF VAR cList AS CHARACTER NO-UNDO.
    DEF VAR key1  AS CHARACTER NO-UNDO.
    DEF VAR val1  AS CHARACTER NO-UNDO.

   oaa = getUserAArray(cGroupName).

  {foreach oaa key1 val1}
     cList = cList + val1 + ",".
  {endforeach oaa}

  DELETE OBJECT oaa.
  cList = RIGHT-TRIM(cList,",").
  RETURN cList.
END METHOD.

END CLASS.
