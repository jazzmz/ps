
{pirfexist.i}

&IF DEFINED(USER_SIGN_DOWN_XY) EQ 0 &THEN
   &SCOP USER_SIGN_DOWN_XY VALUE("/X:600 /Y:4300")
&ENDIF
&IF DEFINED(USER_SIGN_XY) EQ 0 &THEN
   &SCOP USER_SIGN_XY VALUE("/X:600 /Y:3200")
&ENDIF
&IF DEFINED(KONTR_SIGN_DOWN_XY) EQ 0 &THEN
   &SCOP KONTR_SIGN_DOWN_XY VALUE("/X:3100 /Y:4300")
&ENDIF
&IF DEFINED(KONTR_SIGN_XY) EQ 0 &THEN
   &SCOP KONTR_SIGN_XY VALUE("/X:3100 /Y:3200")
&ENDIF

&IF DEFINED(SIGN_DEFINED) EQ 0 &THEN

&GLOBAL-DEFINE SIGN_DEFINED 1

DEF VAR OFile AS CHAR NO-UNDO.
DEF VAR PFile AS CHAR NO-UNDO.
DEF VAR FPath AS CHAR NO-UNDO.
DEF VAR sign  AS MEMPTR NO-UNDO.
DEF VAR comm  AS CHAR NO-UNDO.

&ENDIF

comm = "/home/bis/bin/setxy". 
FPath = "/home2/bis/quit41d/image/sign".

   &IF defined(STAMPBO) NE 0 &THEN
   	   PFile = "tmp.stamp2".
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then OFile = "STAMPBO.stamp".
	else OFile = "STAMPBO_new.stamp".

       IF FExist(FPath,OFile) THEN DO:
          OFile = FPath + "/" + OFile.
          OS-COMMAND SILENT "cp " VALUE(OFile) "./tmp.stamp".
          OS-COMMAND SILENT VALUE(comm) " tmp.stamp" VALUE(PFile) {&STAMPBO_XY}.
          OS-COMMAND SILENT "rm tmp.stamp".
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE  NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
        
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
          OS-COMMAND SILENT "rm " VALUE(PFile).
       END.
   &ENDIF

   &IF defined(LEFTSTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "PRIN_L.stamp".
	else PFile = "PRIN_L_new.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
        
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(MCISTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "MCI.stamp".
	else PFile = "MCI_new.stamp".
       IF FExist(FPath,PFile) THEN DO: 
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
      
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(RIGHTSTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "PRIN_R.stamp".
	else PFile = "PRIN_R_new.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
      
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(BKSTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "BK.stamp".
	else PFile = "BK_new.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
      
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(BKINTSTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "BK_int.stamp".
	else PFile = "BK_int.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
      
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF


   
   &IF defined(RECSTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "RECONLY.stamp".
	else PFile = "RECONLY_new.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
      
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(INKSTAMP) NE 0 &THEN
	if gend-date < DATE(FGetSetting("DateChangeName", "", "01/01/2013")) then PFile = "inkas.stamp".
	else PFile = "inkas_new.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
      
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(POSTAMP) NE 0 &THEN
	PFile = "po.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF

   &IF defined(POSTAMP_NI) NE 0 &THEN
	PFile = "po_ni.stamp".
       IF FExist(FPath,PFile) THEN DO:
          PFile = FPath + "/" + PFile.
          FILE-INFO:FILE-NAME = PFile.
          IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
             SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
             INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
             IMPORT sign.
             INPUT CLOSE.
             EXPORT STREAM macro-file sign.
             SET-SIZE(sign) = 0.
          END.
       END.
   &ENDIF



&IF defined(NOSIGN) EQ 0 &THEN
   PFile = "tmp.sign2".
   &IF defined(ONLYUSER) NE 0 &THEN
      IF TRIM(theUser) NE "" THEN DO:
         OFile = theUserID + ".sign".
         IF FExist(FPath,OFile) THEN DO:
            OFile = FPath + "/" + OFile.
            OS-COMMAND SILENT "cp " VALUE(OFile) "./tmp.sign".
            &IF defined(LEFTSTAMP) NE 0 &THEN
               OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) "/X:800 /Y:4200".
            &ELSE
               OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) "/X:800 /Y:2000".
            &ENDIF
            OS-COMMAND SILENT "rm tmp.sign".
            FILE-INFO:FILE-NAME = PFile.
            IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
               SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
        
               INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
               IMPORT sign.
               INPUT CLOSE.
               EXPORT STREAM macro-file sign.
               SET-SIZE(sign) = 0.
            END.
            OS-COMMAND SILENT "rm " VALUE(PFile).
         END.
      END.
   &ELSEIF defined(ONLYUSERPP) NE 0 &THEN
      IF TRIM(theUser) NE "" THEN DO:
         OFile = theUserID + ".sign".
         IF FExist(FPath,OFile) THEN DO:
            OFile = FPath + "/" + OFile.
            OS-COMMAND SILENT "cp " VALUE(OFile) "./tmp.sign".
            OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) "/X:3200 /Y:4200".
            OS-COMMAND SILENT "rm tmp.sign".
            FILE-INFO:FILE-NAME = PFile.
            IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
               SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
        
               INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
               IMPORT sign.
               INPUT CLOSE.
               EXPORT STREAM macro-file sign.
               SET-SIZE(sign) = 0.
            END.
            OS-COMMAND SILENT "rm " VALUE(PFile).
         END.
      END.
   &ELSE 
      IF TRIM(theKontr) NE "" THEN DO:
         OFile = theKontrID + ".sign".
         IF FExist(FPath,OFile) THEN DO:
            OFile = FPath + "/" + OFile.
            OS-COMMAND SILENT "cp " VALUE(OFile) "./tmp.sign".
            &IF defined(RIGHTSTAMP) NE 0 &THEN
               OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) {&KONTR_SIGN_DOWN_XY}.
            &ELSE
               OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) {&KONTR_SIGN_XY}.
            &ENDIF
            OS-COMMAND SILENT "rm tmp.sign".
            FILE-INFO:FILE-NAME = PFile.
            IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
               SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
        
               INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
               IMPORT sign.
               INPUT CLOSE.
               EXPORT STREAM macro-file sign.
               SET-SIZE(sign) = 0.
            END.
            OS-COMMAND SILENT "rm " VALUE(PFile).
         END.
      END.
      IF TRIM(theUser) NE "" THEN DO:
         OFile = theUserID + ".sign".
         IF FExist(FPath,OFile) THEN DO:
            OFile = FPath + "/" + OFile.
            OS-COMMAND SILENT "cp " VALUE(OFile) "./tmp.sign".
            &IF defined(LEFTSTAMP) NE 0 &THEN
               OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) {&USER_SIGN_DOWN_XY}.
            &ELSE
               OS-COMMAND SILENT VALUE(comm) " tmp.sign" VALUE(PFile) {&USER_SIGN_XY}.
            &ENDIF
            OS-COMMAND SILENT "rm tmp.sign".
            FILE-INFO:FILE-NAME = PFile.
            IF FILE-INFO:FILE-SIZE NE 0 THEN DO:
            	
               SET-SIZE(sign) = FILE-INFO:FILE-SIZE.  
           
               INPUT FROM VALUE(PFile) BINARY NO-CONVERT.
               IMPORT sign.
               INPUT CLOSE. 
               EXPORT STREAM macro-file sign.
               SET-SIZE(sign) = 0.
            END.
            OS-COMMAND SILENT "rm " VALUE(PFile).
         END.
      END.
   &ENDIF
&ENDIF

