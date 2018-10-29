{pirsavelog.p}

/*
               KSV Editor
    Copyright: (C) 2000-2006 Serguey Klimoff (bulklodd)
     Filename: snc-piis.p
      Comment: 0062724  éùÑ. ëÆß§†≠®• Æ‚Á•‚† ØÆ ß†£‡„¶•≠≠Î¨ 
                  ·´„¶•°≠Æ-®≠‰Æ‡¨†Ê®Æ≠≠Î¨ ·ÆÆ°È•≠®Ô¨.   
   Parameters:
         Uses:
      Used by:
      Created: 07.06.2006 15:56 MUTA    
     Modified: 07.06.2006 15:56 MUTA     <comment>
*/

DEFINE INPUT PARAMETER iSeanceID AS INTEGER NO-UNDO.

{globals.i}
{tmprecid.def &NGSH=YES}

{exchange.equ}
{intrface.get strng}
{intrface.get exch}
{pp-pack.p}

DEFINE BUFFER filPacket FOR Packet.
DEFINE BUFFER docPacket FOR Packet.
DEFINE BUFFER stmPacket FOR Packet.

DEFINE VARIABLE mHeader   AS CHAR    NO-UNDO.
DEFINE VARIABLE mComment  AS CHAR    NO-UNDO.
DEFINE VARIABLE mMistake  AS CHAR    NO-UNDO.
DEFINE VARIABLE mNumber   AS CHAR    NO-UNDO.
DEFINE VARIABLE mItm      AS INTEGER NO-UNDO.
DEFINE VARIABLE mJtm      AS INTEGER NO-UNDO.
DEFINE VARIABLE mNextStr  AS LOGICAL NO-UNDO.
DEFINE VARIABLE mDispl    AS LOGICAL NO-UNDO.
DEFINE VARIABLE mCorNum   AS INTEGER NO-UNDO.
DEFINE VARIABLE mMistNum  AS INTEGER NO-UNDO.

DEF VAR Clinm AS CHAR EXTENT 2 NO-UNDO.
DEFINE VARIABLE Clinm2   AS CHAR    NO-UNDO.

DEFINE TEMP-TABLE mResults
   FIELD seance   AS INTEGER
   FIELD fname    AS CHARACTER
   FIELD kind     AS CHARACTER
   FIELD CorNum   AS INTEGER
   FIELD MistNum  AS INTEGER.

FORM 
  PackObject.Kind     COLUMN-LABEL "  ë é!ÇàÑ" 
                      FORMAT "x(5)" 
  mNumber             COLUMN-LABEL "é Å ô Ö ç!çéåÖê" 
                      FORMAT "x(9)"
  docPacket.State     COLUMN-LABEL "à Ö!ëíÄí"
                      FORMAT "x(4)"
  op.op-status        COLUMN-LABEL " Ñ é!ëíÄí"
                      FORMAT "x(4)"
  op.doc-num          COLUMN-LABEL "ä ì å Ö ç!çéåÖê"  
                      FORMAT "x(7)"    
  op-entry.amt-rub    COLUMN-LABEL "í                  ! ëìååÄ çÄñ. ÇÄã."
  mComment            COLUMN-LABEL "äéååÖçíÄêàâ"
                      FORMAT "x(60)"
  HEADER SKIP(1)
            mHeader   FORMAT "x(80)"
         SKIP(1)
WITH FRAME frOper1 WIDTH 120.

FORM 
  PAckObject.Kind     COLUMN-LABEL "ÇàÑ" 
                      FORMAT "x(5)" 
  mNumber             COLUMN-LABEL "çéåÖê" 
                      FORMAT "x(9)"
  docPacket.State     COLUMN-LABEL "ëíÄí"
                      FORMAT "x(4)"
  mMistake            COLUMN-LABEL "éòàÅäà" 
                      FORMAT "x(30)"
  HEADER SKIP(1)
         mHeader      FORMAT "x(80)"
         SKIP(1)
  "ëééÅôÖçàü "
WITH FRAME frOper2 WIDTH 120.

FORM 
  
  op.op-status        COLUMN-LABEL "ëíÄí"
                      FORMAT "x(4)"
  op.doc-num          FORMAT "x(6)"
  
  
  clinm[1]            FORMAT "x(45)"
                      COLUMN-LABEL "çÄàåÖçéÇÄçàÖ èéãìóÄíÖãü Ç ÅÄáÖ" 
  clinm2              FORMAT "x(45)"
                      COLUMN-LABEL "çÄàåÖçéÇÄçàÖ èéãìóÄíÖãü Ç îÄâãÖ"
  op-entry.acct-cr    FORMAT "x(20)"
                      COLUMN-LABEL "ëóÖí èéãìóÄíÖãü" 
  op-entry.amt-rub                      
  
  HEADER SKIP(1)
            mHeader   FORMAT "x(80)"
         SKIP(1)
WITH FRAME frOper3 WIDTH 150.

FORM 
  mNumber             LABEL "çÆ¨•‡ ·ÆÆ°È•≠®Ô " 
                      FORMAT "x(9)"
   docPacket.State
 WITH FRAME frOper5 WIDTH 100 SIDE-LABEL 1 COL NO-UNDERLINE.

FORM 
   Seance.SeanceDate LABEL "Ñ†‚† ·•†≠·†  "
   Seance.Number     LABEL "çÆ¨•‡ ·•†≠·† "
WITH FRAME frOper7 WIDTH 150 SIDE-LABEL 1 COL  NO-UNDERLINE.

FORM 
  FileExch.Path       LABEL   "î†©´" 
                      FORMAT "x(80)"
 WITH FRAME frOper6 WIDTH 100 SIDE-LABEL 1 COL NO-UNDERLINE.


FORM 
  mResults.Kind     COLUMN-LABEL "ÇàÑ"
                    FORMAT "x(10)"
  mResults.CorNum   COLUMN-LABEL "éÅêÅ"
                    FORMAT ">>>>>>>9"
  mResults.MistNum  COLUMN-LABEL "éòÅä"
                    FORMAT ">>>>>>>9"
  HEADER SKIP(1)
         mHeader      FORMAT "x(80)"
         SKIP(1)
  WITH FRAME frOper8 WIDTH 100.

FORM 
  mResults.Kind     COLUMN-LABEL "ÇàÑ"
                    FORMAT "x(10)"
  mCorNum   COLUMN-LABEL "éÅêÅ"
                    FORMAT ">>>>>>>9"
  mMistNum  COLUMN-LABEL "éòÅä"
                    FORMAT ">>>>>>>9"
  HEADER SKIP(1)
         mHeader      FORMAT "x(80)"
         SKIP(1)
  WITH FRAME frOper9 WIDTH 100.

/*============================================================================*/

IF iSeanceID > 0 THEN DO:
   FIND FIRST Seance WHERE
              Seance.SeanceID EQ iSeanceID.
   CREATE tmprecid.
          tmprecid.id = recid(Seance).   
END.
ELSE
   run rid-rest.p (output table tmprecid).

{setdest.i &filename='report.txt'}

PUT UNFORMATTED dept.name FORMAT "x(100)" SKIP(1).
                                              
FOR EACH tmprecid,
   FIRST Seance WHERE 
   recid(Seance) EQ tmprecid.id 
         NO-LOCK,
    EACH filPacket WHERE
         filPacket.SeanceID EQ
         Seance.SeanceID
         NO-LOCK,
   FIRST FileExch WHERE
         FileExch.FileExchID EQ filPacket.FileExchID
         NO-LOCK
   BREAK BY Seance.op-kind
         BY Seance.SeanceDate
         BY Seance.Number
         BY FileExch.Name:

   IF FIRST-OF(Seance.op-kind) THEN 
      PUT "ê•ß„´Ï‚†‚ ¢ÎØÆ´≠•≠®Ô ‚‡†≠ß†™Ê®® " Seance.op-kind SKIP.
   
   IF FIRST-OF(Seance.SeanceDate) OR
      FIRST-OF(Seance.Number) THEN 
      DISPLAY 
      Seance.SeanceDate
      Seance.Number 
      WITH FRAME frOper7.

   IF FIRST-OF(FileExch.Name) THEN
      DISPLAY fileExch.Path WITH FRAME frOper6.

/*-----------------------------------------------------------------------------*/      
   mHeader = PADC("ëãìÜÖÅçõÖ ëééÅôÖçàü",80).

   FOR EACH docPacket WHERE
            docPacket.ParentID   EQ filPacket.PacketID 
       AND  docPacket.Class-Code EQ "PCONF"
            NO-LOCK,
      first Code where
            Code.Class eq "EXCH-MSG"
        and Code.Code  eq docPacket.mail-format
            no-lock,   
      FIRST Reference WHERE
            Reference.PacketID   EQ docPacket.PacketID
        and Reference.Class-Code EQ Code.Misc[{&RKC-REPLY}]
            NO-LOCK
      BREAK BY docPacket.State
            BY docPacket.mail-format
            BY Reference.RefValue                
       WITH FRAME frOper1 DOWN: 

         mNumber = entry(2,Reference.RefValue,"|"). 

         display mNumber
                 docPacket.State
         WITH frame frOper1.  

         mNextStr = NO.
         FOR EACH PackObject where
                  PackObject.PacketID  eq docPacket.PacketID
              and PackObject.File-Name eq "op-entry"
                  NO-LOCK,
            FIRST op-entry where
                  op-entry.op       eq integer(entry(1,PackObject.Surrogate))
              and op-entry.op-entry eq integer(entry(2,PackObject.Surrogate))
                  NO-LOCK,
            first op WHERE op.op EQ op-entry.op
                  NO-LOCK
                  BREAK BY op.doc-num:
            
            IF mNextStr = YES THEN DOWN WITH FRAME frOper1.
            DISPLAY PackObject.Kind
                    op.doc-num
                    op.op-status
                    op-entry.amt-rub 
               WITH FRAME frOper1.
            mNextStr = YES.

            RUN mResultsTable(BUFFER mResults).
             
         END.              /* FOR EACH PackObject */

         IF PacketReadOpen(docPacket.PacketID) THEN
            REPEAT:
               IF NOT PacketReadLine(docPacket.PacketID, OUTPUT mComment) THEN 
                  LEAVE.
               ELSE DO:
                  DISPLAY  
                     mComment 
                  WITH FRAME frOper1.
                  DOWN WITH FRAME frOper1. 
               END.
            END.
         ELSE 
            DOWN WITH FRAME frOper1.
         PacketReadClose(docPacket.PacketID).             

         RUN FillErrorTable (INPUT        docPacket.ClassError,
                             INPUT        docPacket.PackError,
                             OUTPUT TABLE ttError). 
            
         FOR EACH ttError:
               PUT UNFORMATTED
               FILL(" ",9)
               string(ttError.Code,"x(12)") "      "
               string(ttError.Name,"x(50)") " "
               string(ttError.Type,"x(15)")  SKIP.
         END.
  END.
/*----------------------------------------------------------------------------*/   
   mHeader = PADC("àçîéêåÄñàéççõÖ ëééÅôÖçàü",80).
   FOR EACH docPacket WHERE
            docPacket.ParentID   EQ filPacket.PacketID 
       AND  docPacket.Class-Code EQ "PRQST"
            NO-LOCK,
      first Code where
            Code.Class eq "EXCH-MSG"
        and Code.Code  eq docPacket.mail-format
            no-lock,   
      FIRST Reference WHERE
            Reference.PacketID   EQ docPacket.PacketID
        and Reference.Class-Code EQ Code.Misc[{&RKC-REPLY}]
            NO-LOCK   
            BREAK BY docPacket.State
                  BY Reference.RefValue  
            WITH FRAME frOper2 DOWN:
            
      mNumber = ENTRY(2,Reference.RefValue,"|").
      DISPLAY mNumber
              docPacket.State 
      WITH FRAME frOper2.
 
      FOR EACH PackObject where
               PackObject.PacketID  eq docPacket.PacketID
           and PackObject.File-Name eq "op-entry"
              NO-LOCK:

         DISPLAY PackObject.Kind        
         WITH FRAME frOper2.

          RUN mResultsTable(BUFFER mResults).

      END.
      
      RUN FillErrorTable (INPUT        docPacket.ClassError,
                          INPUT        docPacket.PackError,
                          OUTPUT TABLE ttError).    
      FIND FIRST ttError NO-ERROR.
      IF NOT AVAIL(ttError) THEN
         DOWN WITH  FRAME frOper2.
    
      FOR EACH ttError:
          mJtm  = 0.
          mItm  = 1.    
          DO WHILE (AVAIL(ttError) AND mItm LE NUM-ENTRIES(ttError.NAME)): 
             mJtm = mJtm + 1.
             IF AVAIL(ttError) THEN mMistake = GetPartStr(ENTRY(mItm,ttError.NAME),30,mJtm). 
                               ELSE mMistake = "".         
             IF NOT {assigned mMistake} THEN DO:
                mItm = mItm + 1.
                mJtm = 0.
             END.
             ELSE DO:
                DISPLAY mMistake
                WITH FRAME frOper2.
                DOWN WITH  FRAME frOper2.
             END.  
          END.  
      END.           /*FOR EACH ttError */
   END.

/*----------------------------------------------------------------------------*/
   mHeader = PADC("éíÇÖíçõÖ ÑéäìåÖçíõ",80).
   FOR EACH docPacket WHERE
            docPacket.ParentID   EQ filPacket.PacketID 
       AND  docPacket.Class-Code EQ "PRKCXML"
       AND  docPacket.Kind EQ "ExchRKCDoc"
            NO-LOCK,
      first Code where
            Code.Class eq "EXCH-MSG"
        and Code.Code  eq docPacket.mail-format
            no-lock,   
      FIRST Reference WHERE
            Reference.PacketID   EQ docPacket.PacketID
        and Reference.Class-Code EQ Code.Misc[{&RKC-REPLY}]
            NO-LOCK
            BREAK BY docPacket.State
                  BY Reference.RefValue  
            WITH FRAME frOper3 DOWN:

      mNumber = ENTRY(2,Reference.RefValue,"|").
 /*     DISPLAY                
         docPacket.State
         mNumber
      WITH frame frOper3.  
*/
      FOR EACH PackObject WHERE
               PackObject.PacketID  EQ docPacket.PacketID
           AND PackObject.File-Name EQ "op-entry"
               NO-LOCK,
         FIRST op-entry WHERE
               op-entry.op       EQ INTEGER(ENTRY(1,PackObject.Surrogate))
           AND op-entry.op-entry EQ INTEGER(ENTRY(2,PackObject.Surrogate))
               NO-LOCK,
         FIRST op WHERE op.op EQ op-entry.op
               NO-LOCK,
/*         FIRST op-bank  WHERE
               op-bank.op EQ op.op 
               NO-LOCK,*/
        FIRST acct WHERE
               acct.acct EQ op-entry.acct-cr NO-LOCK
               BREAK BY op.doc-num:

 /*        IF op.ben-acct <>"" THEN 
              DISPLAY op.ben-acct WITH FRAME frOper3.
         ELSE DISPLAY op-entry.acct-db @ op.ben-acct WITH FRAME frOper3.
*/
/*
         DISPLAY op.doc-num
                 op.op-status
                 op-entry.amt-rub 
                 op-entry.acct-cr                 
                 op-bank.bank-code
         WITH frame frOper3. 
*/
         RUN mResultsTable(BUFFER mResults).
        
        {getcust.i &name="clinm" &OFFinn = "/*" &OFFsigns = "/*"}         
               ASSIGN
                  clinm[1] = clinm[1] + " " + clinm[2]
                  clinm[2] = ""
               .
         Clinm2     = GetXAttrValueEx("op",
                                  string(op.op),
                                  "name-rec",
                                  op-entry.acct-cr).  
      END.

      RUN FillErrorTable (INPUT        docPacket.ClassError,
                          INPUT        docPacket.PackError,
                          OUTPUT TABLE ttError).      
       
      FIND FIRST ttError NO-ERROR.
      IF NOT AVAIL(ttError) THEN
         DOWN WITH  FRAME frOper3.
/**********************************************************************************************/
/**********************************************************************************************/
      FOR EACH ttError:
         
       
         DISPLAY 
                 op.doc-num
                 op.op-status
                 clinm[1]
                 Clinm2
                 op-entry.amt-rub 
                 op-entry.acct-cr                 
        WITH frame frOper3.
         
         PUT UNFORMATTED
            FILL(" ",9)
            string(ttError.Code,"x(12)") "      "
            string(ttError.Name,"x(50)") " "
            string(ttError.Type,"x(15)")  SKIP.
      END.
   END.            /* FOR EACH DocPacket */

/*----------------------------------------------------------------------------*/
   mHeader = PADC("ÇõèàëäÄ",80).
   FOR EACH docPacket WHERE
            docPacket.ParentID   EQ filPacket.PacketID 
       AND  docPacket.Class-Code EQ "PSTMT"
       AND  docPacket.Kind EQ "ExchRKCStm"
            NO-LOCK,
      first Code where
            Code.Class eq "EXCH-MSG"
        and Code.Code  eq docPacket.mail-format
            no-lock,   
      FIRST Reference WHERE
            Reference.PacketID   EQ docPacket.PacketID
        and Reference.Class-Code EQ Code.Misc[{&RKC-REPLY}]
            NO-LOCK
            BREAK BY docPacket.State
            BY Reference.RefValue  
       WITH FRAME frOper3 DOWN:

      IF PacketReadOpen(docPacket.PacketID) THEN
         REPEAT:
            IF NOT PacketReadLine(docPacket.PacketID, OUTPUT mComment) THEN 
               LEAVE.
            ELSE DISPLAY  
                 mComment  FORMAT "x(50)" NO-LABEL.                    
         END.
      PacketReadClose(docPacket.PacketID).        

      mNumber = ENTRY(2,Reference.RefValue,"|").
      DISPLAY mNumber
              docPacket.State
              WITH FRAME frOper5.

      FOR EACH stmPacket WHERE
               stmPacket.ParentID EQ docPacket.PacketID
                NO-LOCK
               BREAK BY stmPacket.State:

         FOR EACH PackObject WHERE
                  PackObject.PacketID  EQ stmPacket.PacketID
              AND PackObject.File-Name EQ "op-entry"
                  NO-LOCK,
            FIRST op-entry WHERE
                  op-entry.op       EQ INTEGER(ENTRY(1,PackObject.Surrogate))
              AND op-entry.op-entry EQ INTEGER(ENTRY(2,PackObject.Surrogate))
                  NO-LOCK,
            FIRST op WHERE
                  op.op EQ op-entry.op
                  NO-LOCK,
            FIRST op-bank  WHERE
                  op-bank.op EQ op.op NO-LOCK
            BREAK BY op.doc-num:

            DISPLAY /* stmPacket.State @ docPacket.State */
                    op.doc-num
                    op.op-status
                    op-entry.amt-rub 
  /*                  op-bank.bank-code */
            WITH frame frOper3. 
                             
/*            if op.doc-kind eq  "rec" then        
               DISPLAY
                    GetXAttrValueEx("op",
                                  string(op.op),
                                  "acct-send",
                                  op-entry.acct-db) @ op.ben-acct
                    (if {assigned op.ben-acct} 
                     then op.ben-acct
                     else op-entry.acct-cr)         @ op-entry.acct-cr
               WITH frame frOper3. 
            else
               DISPLAY
                    (if {assigned op.ben-acct} 
                     then op.ben-acct
                     else op-entry.acct-db)         @ op.ben-acct
                    GetXAttrValueEx("op",
                                  string(op.op),
                                  "acct-rec",
                                  op-entry.acct-cr) @ op-entry.acct-cr
               WITH frame frOper3. 
*/
            DOWN WITH  FRAME frOper3.

            RUN mResultsTable(BUFFER mResults).

         END.            /* FOR EACH PackObject   */

         RUN FillErrorTable (INPUT        stmPacket.ClassError,
                             INPUT        stmPacket.PackError,
                             OUTPUT TABLE ttError).   
         FIND FIRST ttError NO-ERROR.
         IF NOT AVAIL(ttError) THEN
         DOWN WITH  FRAME frOper3.

         FOR EACH ttError:
            PUT UNFORMATTED
               FILL(" ",9)
               STRING(ttError.Code,"x(12)") "      "
               STRING(ttError.Name,"x(50)") " "
               STRING(ttError.Type,"x(15)")  SKIP.
         END.
                        
      END.               /*  FOR EACH stmPacket       */
   END.                  /* FOR EACH docPacket (STMP) */ 

   IF LAST-OF(FileExch.Name) THEN DO:
      mHeader =  "àíéÉé èé îÄâãì " + FileExch.NAME. 
      FOR EACH mResults WHERE
         mResults.fName EQ fileExch.NAME
         WITH FRAME frOper8 DOWN
         BREAK BY mResults.kind:
         DISPLAY
            mResults.kind  
            mResults.CorNum  
            mResults.MistNum 
         WITH FRAME frOper8.
         DOWN WITH FRAME frOper8.
      END.
   END.

   mDispl = NO.
   IF LAST-OF(Seance.Number) THEN DO: 
      mHeader =  "àíéÉé èé  ëÖÄçëì " + STRING(Seance.Number).
      FOR EACH mResults WHERE
         mResults.seance EQ Seance.SeanceID
         WITH FRAME frOper9 DOWN
         BREAK BY mResults.kind:

         IF mResults.fname <> FileExch.NAME THEN mDispl = YES.

         IF FIRST-OF(mResults.kind) THEN DO:
         mCorNum  = 0.
         mMistNum = 0.
         END.
         mCorNum  = mCorNum  + mResults.CorNum.
         mMistNum = mMistNum + mResults.MistNum.         
         IF (LAST-OF(mResults.kind)  AND mDispl = YES) THEN
         DISPLAY
            mResults.kind  
            mCorNum 
            mMistNum
         WITH FRAME frOper9.
         DOWN WITH FRAME frOper9.
      END.
   END.
END.                     /* FOR EACH tmprecid  */

{signatur.i}
{preview.i &filename='report.txt'}

/*---------------------------------------------------------------------------------------------*/

PROCEDURE mResultsTable.                 /*á†ØÆ´≠•≠®• ‚†°´®ÊÎ §´Ô ¢Î¢Æ§† ®‚Æ£Æ¢ */
DEFINE PARAMETER BUFFER mResults FOR mResults.

IF NOT CAN-FIND (mResults WHERE
                 mResults.kind   EQ PackObject.Kind
             AND mResults.seance EQ Seance.SeanceID
             AND mResults.fname  EQ FileExch.NAME) THEN DO:
   CREATE mResults.
   ASSIGN
      mResults.kind   = PackObject.Kind
      mResults.seance = Seance.SeanceID
      mResults.fname  = FileExch.NAME.
      IF docPacket.State EQ "éÅêÅ" THEN  mResults.CorNum  = 1.
      IF docPacket.State EQ "éòÅä" THEN  mResults.MistNum = 1.
END.
ELSE DO:
   FIND FIRST mResults WHERE
              mResults.kind   EQ PackObject.Kind
          AND mResults.seance EQ Seance.SeanceID
          AND mResults.fname  EQ FileExch.NAME.
   IF docPacket.State EQ "éÅêÅ" THEN mResults.CorNum  = mResults.CorNum  + 1.
   IF docPacket.State EQ "éòÅä" THEN mResults.MistNum = mResults.MistNum + 1.
END.

END PROCEDURE.
