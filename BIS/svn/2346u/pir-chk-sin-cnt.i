/*************************
 * ญชซ๎คญจช ฏเฎขฅเ๏ฅโ
 * ฅคจญแโขฅญญฎแโ์ จแฏฎซญจโฅซ๏
 * จ ชฎญโเฎซฅเ  คซ๏ ข๋กเ ญญ๋ๅ
 * คฎชใฌฅญโฎข.
 *************************/

DEF BUFFER chkBuf FOR op.
DEF BUFFER chkBufOpEntry FOR op-entry.

DEF VAR curr-user-id        AS CHARACTER NO-UNDO.
DEF VAR curr-user-inspector AS CHARACTER NO-UNDO.

DEF VAR cRootPath AS CHARACTER INITIAL "/home2/bis/quit41d/imp-exp/docum/" NO-UNDO.   /* ก๏ง โฅซ์ญฎ ญ ซจ็จฅ ง ขฅเ่ ๎้ฅฃฎ แซํ่  */

DEF VAR cPath AS CHARACTER NO-UNDO.

/***     ***/
DEF VAR cUserIdRep   AS CHARACTER NO-UNDO.
DEF VAR cUserInspRep AS CHARACTER NO-UNDO.
DEF VAR ipcsc AS INTEGER NO-UNDO.

DEF VAR isExistsUnload AS LOGICAL INITIAL FALSE NO-UNDO.	/* แโ์ ซจ ข ญ กฎเฅ คฎชใฌฅญโ, ชฎโฎเ๋ฉ ใฆฅ ข๋ฃเใฆฅญ?   */
DEF VAR isBadStatus    AS LOGICAL INITIAL FALSE NO-UNDO.	/*  ฎโฎกเ ญญฎฌ ญ กฎเฅ ฅแโ์ ญฅฏฎโขฅเฆคฅญญ๋ฉ คฎชใฌฅญโ? */

DEF VAR dCurrDate AS DATE NO-UNDO.				/*  โ  โฅชใ้ฅฃฎ ฎฏฅเ. คญ๏ */
DEF VAR oSysClassPCS AS TSysClass NO-UNDO.

/*** ฎซใ็ ฅฌ งญ ็ฅญจฅ แ็ฅโ็จช  ญใฌฅเ ๆจจ ***/
{pir-c2346u.i}

oSysClassPCS = new TSysClass().
/**** 
         
       . 
        
 ****/

&IF DEFINED(MULTI-FROM-ENTRY) &THEN
  FOR EACH tmprecid,
    FIRST chkBufOpEntry WHERE RECID(chkBufOpEntry) EQ tmprecid.id NO-LOCK,
     FIRST chkBuf WHERE chkBuf.op EQ chkBufOpEntry.op NO-LOCK BREAK BY chkBuf.user-id BY chkBuf.user-inspector:
&ELSE
FOR EACH tmprecid,
  FIRST chkBuf WHERE RECID(chkBuf) EQ tmprecid.id NO-LOCK BREAK BY chkBuf.user-id BY chkBuf.user-inspector:
&ENDIF

  IF FIRST-OF(chkBuf.user-id) THEN DO:
	 dCurrDate    = chkBuf.op-date.
         curr-user-id = chkBuf.user-id.
	 ACCUMULATE chkBuf.user-id (COUNT).
	END.
  
  IF FIRST-OF(chkBuf.user-inspector) THEN DO:
         curr-user-inspector = chkBuf.user-inspector.
         ACCUMULATE chkBuf.user-inspector (COUNT). 
	END.

IF INT64(getXAttrValue("op",STRING(chkBuf.op),"PirA2346U")) > 1000 THEN DO:
  /**********************
   *  ข๋กเ ญญ๋ๅ คฎชใฌฅญโ ๅ,
   * ญ ฉคฅญ ใฆฅ ข๋ฃเใฆฅญญ๋ฉ 
   * ข  เๅจข.
   ***********************/
  isExistsUnload = TRUE.
  MESSAGE "      !\n  !" VIEW-AS ALERT-BOX.
  RETURN.
  LEAVE.
END.

  /************************
   *
   *  ข๋กเ ญญ๋ๅ คฎชใฌฅญโ ๅ,
   * ฅแโ์ ญฅฏฎคโขฅเฆคฅญญ๋ฉ คฎชใฌฅญโ.
   *
   *************************/

IF NOT CAN-DO(FGetSetting("PirEArch","PirPermitStatus","!*"),chkBuf.op-status) THEN DO:
  isBadStatus = TRUE.
  MESSAGE "      !\n  !" VIEW-AS ALERT-BOX.
  RETURN.
  LEAVE.
END.

END.

/*****
 * เฎขฅเช  ญ  ฏฎฏ๋โชใ
 * ข๋ฃเใงชจ จง ง ชเ๋โฎฃฎ
 * คญ๏.
 *****/
IF oSysClassPCS:getLastCloseDate() >= dCurrDate 
   AND NOT CAN-DO(FGetSetting("PirEArch","WCUnCloseDate","!*"),USERID("bisquit")) THEN DO:
  MESSAGE "       !" VIEW-AS ALERT-BOX.
  RETURN.
END.

&IF DEFINED(notCheckAuthorInspector)=0 &THEN
IF (ACCUM COUNT chkBuf.user-id) > 1 OR (ACCUM COUNT chkBuf.user-inspector) > 1 THEN DO:
	MESSAGE COLOR WHITE/RED "      " VIEW-AS ALERT-BOX.
        RETURN "Error".
END.
&ENDIF

/***      ***/

&IF DEFINED(ur) &THEN

/*** ฎซใ็ ฅฌ ฏฎคแโ ญฎขชใ คซ๏ จแฏฎซญจโฅซ๏ ***/
  cUserIdRep = GetCodeName("PirEarch","{&ur}").

  cUserIdRep = REPLACE(cUserIdRep,"USERID",USERID("bisquit")).

  IF NUM-ENTRIES(cUserIdRep) > 1 THEN DO:

	/***      ***/

	IF ENTRY(1,cUserIdRep) EQ "USER-ID" THEN DO:

 	  DO ipcsc = 2 TO (NUM-ENTRIES(cUserIdRep) - 1):
		IF curr-user-id = ENTRY(ipcsc,cUserIdRep) THEN DO:
			curr-user-id = ENTRY(ipcsc + 1,cUserIdRep).
		END.
	  END. /* END DO */

        END.    /* IF ENTRY */

  END.        /* END NUM-ENTRIES */

&ENDIF
&IF DEFINED(cr) &THEN
/*** ฎซใ็ ฅฌ ฏฎคแโ ญฎขชใ คซ๏ ชฎญโเฎซซฅเ  ***/

  cUserIdRep = GetCodeName("PirEarch","{&cr}").

  cUserIdRep = REPLACE(cUserIdRep,"USERID",USERID("bisquit")).

  IF NUM-ENTRIES(cUserIdRep) > 1 THEN DO:

	/***      ***/

	IF ENTRY(1,cUserIdRep) EQ "CNT-ID" THEN DO:

 	  DO ipcsc = 2 TO (NUM-ENTRIES(cUserIdRep) - 1):
		IF curr-user-inspector = ENTRY(ipcsc,cUserIdRep) THEN DO:
			curr-user-inspector = ENTRY(ipcsc + 1,cUserIdRep).
		END.
	  END. /* END DO */

        END.    /* IF ENTRY */

  END.        /* END NUM-ENTRIES */

/*** ฎซใ็ ฅฌ ฏฎคแโ ญฎขชใ คซ๏ ชฎญโเฎซซฅเ  ***/



&ENDIF

RELEASE chkBuf.
DELETE OBJECT oSysClassPCS.