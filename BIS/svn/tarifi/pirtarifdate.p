{globals.i}


DEF VAR TERMINAL-SIMULATION AS WIDGET-HANDLE NO-UNDO.

DEF INPUT PARAMETER iTarif as CHAR NO-UNDO.
/*def var iTarif as char init "1." NO-UNDO.*/

def buffer bcode for code.
def var tempID as INT NO-UNDO.
def var oTarif as TTarif NO-UNDO.

def temp-table tcode 
    field val AS date
    INDEX val val.

DEF QUERY qDate FOR tcode SCROLLING.

DEF BROWSE brwDate QUERY qDate 
        DISPLAY        
               tcode.val format "99/99/9999" NO-Label
        WITH 14 DOWN WIDTH 14 NO-LABELS.

DEF FRAME frmDate
       brwDate at row 1 column 1
WITH ROW 5 CENTERED OVERLAY SIZE 16 BY 20.

TERMINAL-SIMULATION = CURRENT-WINDOW.
ASSIGN CURRENT-WINDOW                = TERMINAL-SIMULATION 
       THIS-PROCEDURE:CURRENT-WINDOW = TERMINAL-SIMULATION.

PROCEDURE FillTempTable.
EMPTY TEMP-TABLE tcode.
FOR EACH Code where code.class = "PirTarifDate" and code.name = iTarif NO-LOCK BY code.val.
  Create tcode.
  tcode.val = date(code.val). 
end.
END PROCEDURE.


ON enter  of brwDate in frame frmDate do:
  FIND CURRENT tcode NO-ERROR.
  if AVAILABLE tcode then 
  do:
     if oTarif:IsNewDate(tcode.val) then do:
        oTarif:CopyToNewDate(tcode.val).
     end.

     RUN pirtarifmainedit.p(iTarif,tcode.val).
     APPLY "window-close" TO THIS-PROCEDURE.
  END.
end.

ON INS OF brwDATE in FRAME frmDate DO:

  {getdate.i &return = "."}
   IF KEYFUNCTION(LASTKEY) EQ "END-ERROR" OR KEYFUNCTION(LASTKEY) EQ "ENDKEY" THEN DO:
      RETURN.
   END.
   ELSE DO:
 find first bcode where bcode.class = "PirTarifDate" 
		     and bcode.name = iTarif   
 	 	     and bcode.val = STRING(end-date,"99/99/9999")
		     NO-LOCK NO-ERROR.

  if available bcode then MESSAGE end-date " уже введено в системе!!!" VIEW-AS ALERT-BOX.
  else
   do:
      find last bcode where bcode.class = "PirTarifDate"  NO-ERROR.
      if available bcode then tempID = INT(bcode.code) + 1.
      else tempID = 1.
      CREATE bcode.
      ASSIGN 
            bcode.code = STRING(tempID)     
            bcode.class = "PirTarifDate"
            bcode.parent = "PirTarifDate"
  	    bcode.name = iTarif
	    bcode.val = STRING(end-date,"99/99/9999")
 	    bcode.misc[1] = STRING(dec(end-date)).
      CLOSE QUERY qDate.
      RUN FillTempTable.
      OPEN QUERY qDate FOR EACH tCode NO-LOCK BY tcode.val.
   end. 
  END.
END.



MAIN-BLOCK:
DO         ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
           :
    run filltemptable.
    oTarif = new TTarif(iTarif).
    OPEN QUERY qDate FOR EACH tCode NO-LOCK BY tcode.val.

        ENABLE brwDate WITH FRAME frmDate IN WINDOW TERMINAL-SIMULATION.

        VIEW TERMINAL-SIMULATION.
                                                              	
        IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
                   WAIT-FOR WINDOW-CLOSE OF THIS-PROCEDURE
/*                     WAIT-FOR enter  IN FRAME frmDate     */   
                    FOCUS brwDate.
           END.


END. 

ON esc endkey.

DELETE OBJECT oTarif.