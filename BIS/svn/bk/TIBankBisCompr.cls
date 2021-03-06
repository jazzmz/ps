CLASS TIBankBisCompr IMPLEMENTS ISysComprasion:

/*******************************************************
 *                                                    *                          * « áá áà ¢­¥­¨ï ¤ ­­ëå ¤¢ãå á¨áâ¥¬                 *
 *                                                    *    
 *******************************************************/

DEFINE PRIVATE VARIABLE TDocCollect AS HANDLE NO-UNDO.  /*  ¡«¨æ  ¤«ï åà ­¥­¨ï ¤ ­­ëå ¨§  ­ª-«¨¥­â */
DEFINE PRIVATE VARIABLE ddate-end AS DATETIME NO-UNDO.
                         
/*** PUBLIC PROPERTY ***/


{set-prop.i  &aa="date-beg" &bb="ddate-beg" &cc="DATETIME"}
{set-prop.i  &aa="firstSource" &bb="cfirstSource" &cc="CHARACTER"}
{set-prop.i  &aa="firstProvider" &bb="cfirstProvider" &cc="CHARACTER"}
{set-prop.i  &aa="OperDate" &bb="dOperDate" &cc="DATE"}
{set-prop.i  &aa="DateDiff" &bb="iDateDiff" &cc="INTEGER" &init="1"}

{set-prop.i  &aa="ItogoInBIS" &bb="dItogoInBIS" &cc="DECIMAL"}                                  /* ¨â®£® ¯® ¤®ªã¬¥­â ¬ ¢              */
{set-prop.i  &aa="KolvoInBIS" &bb="iKolvoInBIS" &cc="INTEGER"}                                  /* ª®«-¢® ¤®ªã¬¥­â®¢ ¢                */
{set-prop.i  &aa="ItogoInIBank" &bb="dItogoInIBank" &cc="DECIMAL"}                              /* ¨â®£® ¯® ¤®ªã¬¥­â ¬ ¢ iBank            */
{set-prop.i  &aa="KolvoInIBank" &bb="iKolvoInIBank" &cc="INTEGER"}                              /* ª®«-¢® ¤®ªã¬¥­â®¢ ¢ iBank                   */
{set-prop.i  &aa="TableInBIS" &bb="tTableInBIS" &cc="TTable"}                                   /* â ¡«¨æ  á ¤ ­­ë¬¨ ¯® ¤®ªã¬¥­â ¬ ¢  */
{set-prop.i  &aa="TableInIBank" &bb="tTableInIBank" &cc="TTable"}                               /* â ¡«¨æ  á ¤ ­­ë¬¨ ¯® ¤®ªã¬¥­â ¬ ¢  */

DEFINE PUBLIC PROPERTY date-end AS DATETIME
   GET:
       RETURN ddate-end.
   END GET.
   SET (INPUT cProp AS DATETIME):
       ddate-end=cProp.
/*       DISPLAY cProp.*/
       dOperDate = DATE(cProp).
   END SET.

/*** METHODS ***/
CONSTRUCTOR TIBankBisCompr():               
TableInBIS = new TTable(6).
TableInIBank = new TTable(6).

END METHOD.

METHOD PUBLIC LOGICAL load2First():
   DEFINE VARIABLE oSysClass AS TSysClass NO-UNDO.
  
   oSysClass = new TSysClass().
   
   OS-COMMAND SILENT VALUE(firstProvider + " \"" + oSysClass:DATETIME2STR(date-beg,"%Y-%m-%d %h:%j") + "\" \"" + oSysClass:DATETIME2STR(date-end,"%Y-%m-%d %h:%j") + "\"").    

   CREATE TEMP-TABLE TDocCollect.
/*   firstSource = "svod.xml".*/
   TDocCollect:READ-XML("FILE",firstSource,?,?,?,?). 

END METHOD.

METHOD PUBLIC LOGICAL load2Sec():
    /***********************************************
     *                                             *                                * ®ª  ­¥â ­¥®¡å®¤¨¬®áâ¨.                     *
     *                                             *
     ***********************************************/

END METHOD.

METHOD PROTECTED VOID inFirstButNotInSec():
   /**********************************************
    * ¥â®¤ ¯à®¢¥àª¨ ¤®ªã¬¥­â®¢, ª®â®àë¥ ¥áâì    *
    * ¢  ­ª-«¨¥­â, ­® ­¥â ¢ ¨áª¢¨â¥           *
    **********************************************/

   DEFINE VARIABLE hQuery       AS HANDLE NO-UNDO.  /* ¥à¥¬¥­­ ï ¤«ï ä®à¬¨à®¢ ­¨ï § ¯à®á®¢ */
   DEFINE VARIABLE hBuffer      AS HANDLE NO-UNDO. /* ¥à¥¬¥­­ ï ¯®«ãç¥­¨ï ¡ãää¥à  § ¯à®á  */
   DEFINE VARIABLE oDocCollect  AS TDocCollect NO-UNDO.
   DEFINE VARIABLE oDocCollect1 AS TDocCollect NO-UNDO.
    
   /**** 
    ã¬¬  ¨ ª®«-¢® ¢á¥å ¤®ª-®¢ -. 
    ¥§  ­­ã«¨à®¢ ­­ëå ¨ ®â¢¥à£­ãâëå.
    ****/
    
   DEFINE VARIABLE tmpiBankSum   AS DECIMAL INITIAL 0 NO-UNDO. 
   DEFINE VARIABLE tmpiBankCount AS INTEGER INITIAL 0 NO-UNDO.
   
   /**** ã¬¬  ¨ ª®«-¢® ¢­ãâà¥­­¨å ¤®ª-®¢ - ****/ 
   DEFINE VARIABLE tmpiBankInner    AS INTEGER INITIAL 0 NO-UNDO.
   DEFINE VARIABLE tmpiBankInnerSum AS DECIMAL INITIAL 0 NO-UNDO.
   
   /*** ***/
   DEFINE VARIABLE cGrAcct AS CHARACTER INITIAL "" NO-UNDO.
   
   /*** ã¬¬  ¨ ª®«-¢® ¤®ª-¢, ª®â®àëå ­¥â ¢ ¨áª¢¨â */
   DEFINE VARIABLE diBankOnlySum AS DECIMAL INITIAL 0 NO-UNDO.
   DEFINE VARIABLE iiBankOnlyCount AS INTEGER INITIAL 0 NO-UNDO.
   
   /*** ***/
   DEFINE VARIABLE tmpDocDate AS CHARACTER INITIAL "" NO-UNDO.
   DEFINE VARIABLE i AS INTEGER NO-UNDO.
   

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(TDocCollect:DEFAULT-BUFFER-HANDLE).
  hQuery:QUERY-PREPARE("FOR EACH TDocCollect WHERE TIsDel=false").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST(NO-LOCK).

  hBuffer=hQuery:GET-BUFFER-HANDLE.

   REPEAT WHILE NOT hQuery:QUERY-OFF-END:
     oDocCollect = new TDocCollect().
     oDocCollect:date-beg=OperDate.
     oDocCollect:date-end=OperDate.
     oDocCollect:user-id="BNK-CL".
     oDocCollect:acct-db=hBuffer:BUFFER-FIELD("TPay"):BUFFER-VALUE.
     oDocCollect:acct-rcpt=hBuffer:BUFFER-FIELD("TRcpt"):BUFFER-VALUE.
     oDocCollect:doc-num=hBuffer:BUFFER-FIELD("TNum"):BUFFER-VALUE.
     oDocCollect:sum-min=hBuffer:BUFFER-FIELD("TSum"):BUFFER-VALUE.
     oDocCollect:sum-max=oDocCollect:sum-min.
         
     oDocCollect:applyFilter().

     IF NOT oDocCollect:isFind() THEN
        DO:
         /*        */

         IF hBuffer:BUFFER-FIELD("TPay"):BUFFER-VALUE NE cGrAcct THEN
            DO:
                TableInIBank:addrow().
                TableInIBank:addCell(" ").                
                TableInIBank:addCell(" ").                
                TableInIBank:addCell(" ").                
                TableInIBank:addCell(" ").                
                TableInIBank:addCell(" ").                
                TableInIBank:addCell(" ").                
               
              cGrAcct=hBuffer:BUFFER-FIELD("TPay"):BUFFER-VALUE.
            END.
             /* 
             ®ªã¬¥­â  ­¥â ¢ â¥ªãé¥¬ ®¯¥à. ¤­¥, á¬®âà¨¬ ¥áâì «¨ ®­
             ¢ ¡«¨¦ ©è¨å ¤­ïå.
             */
            
              oDocCollect1=new TDocCollect().
              oDocCollect1:date-beg=OperDate - DateDiff.
              oDocCollect1:date-end=OperDate + DateDiff.
              oDocCollect1:user-id="BNK-CL".
              oDocCollect1:acct-db=hBuffer:BUFFER-FIELD("TPay"):BUFFER-VALUE.
              oDocCollect1:acct-rcpt=hBuffer:BUFFER-FIELD("TRcpt"):BUFFER-VALUE.
              oDocCollect1:doc-num=hBuffer:BUFFER-FIELD("TNum"):BUFFER-VALUE.
              oDocCollect1:sum-min=hBuffer:BUFFER-FIELD("TSum"):BUFFER-VALUE.
              oDocCollect1:sum-max=oDocCollect:sum-min.
              oDocCollect1:applyFilter().
                DO i = 1 TO oDocCollect1:DocCount:
                  tmpDocDate = tmpDocDate + STRING(oDocCollect1:getDocument(i):DocDate) + ",".       
                END.
              DELETE OBJECT oDocCollect1.

                  tTableInIBank:addrow().
                tTableInIBank:addCell(hBuffer:BUFFER-FIELD("TNum"):BUFFER-VALUE).                
                tTableInIBank:addCell(hBuffer:BUFFER-FIELD("TPay"):BUFFER-VALUE).        
                tTableInIBank:addCell(hBuffer:BUFFER-FIELD("TRcpt"):BUFFER-VALUE).        
                tTableInIBank:addCell(hBuffer:BUFFER-FIELD("TSum"):BUFFER-VALUE).        
                tTableInIBank:addCell("").        
                tTableInIBank:addCell(tmpDocDate).        

     /*** ç¨â ¥¬ áã¬¬ã ¤®ª-®¢, ª®â®àë¥ ¥áâì ¢ , ­® ­¥â ¢  ****/
    diBankOnlySum=diBankOnlySum + hBuffer:BUFFER-FIELD("TSum"):BUFFER-VALUE.
    iiBankOnlyCount=iiBankOnlyCount + 1.
   tmpDocDate = "".
  END /*      */. 

  IF hBuffer:BUFFER-FIELD("TIsInner"):BUFFER-VALUE THEN
     DO:
      /* -    - */
      tmpiBankInner = tmpiBankInner + 1.
      tmpiBankInnerSum = tmpiBankInnerSum + hBuffer:BUFFER-FIELD("TSum"):BUFFER-VALUE.
     END.

     /*  - - - */
     tmpiBankSum=tmpiBankSum + hBuffer:BUFFER-FIELD("TSum"):BUFFER-VALUE.
     tmpiBankCount=tmpiBankCount + 1.
    hQuery:GET-NEXT(NO-LOCK).
  DELETE OBJECT oDocCollect.
  END /*      - */.     

  dItogoInIBank = diBankOnlySum.
  iKolvoInIBank = iiBankOnlyCount.

 hQuery:QUERY-CLOSE().
 DELETE OBJECT hQuery.
    
END METHOD.


METHOD PROTECTED VOID inSecButNotInFirst():
  /*************************************************
   * ¥â®¤ ¯à®¢¥àª¨ ¤®ª-®¢, ª®â®àë¥ ¥áâì ¢ ¨áª¢¨â,*
   * ­® ­¥â ¢  ­ª-«¨¥­â                          *
   **************************************************/

           DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.    /* ¥à¥¬¥­­ ï ¤«ï ä®à¬¨à®¢ ­¨ï § ¯à®á®¢ */
           DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.   /* ¥à¥¬¥­­ ï ¯®«ãç¥­¨ï ¡ãää¥à  § ¯à®á  */

           DEFINE VARIABLE oDocCollect AS TDocCollect NO-UNDO.  /*  ®««¥ªæ¨ï ¤®ªã¬¥­â®  ¢  */

           DEFINE VARIABLE oDocument AS TDocument NO-UNDO.      
           DEFINE VARIABLE oOpEntry AS TOpEntry NO-UNDO.

           DEFINE VARIABLE i AS INTEGER NO-UNDO.
           DEFINE VARIABLE cGrAcct AS CHARACTER INITIAL "" NO-UNDO.
           
  /*** â â¨áâ¨ç¥áª¨¥ ¯¥à¥¬¥­­ë¥ ***/
     DEFINE VARIABLE dSumInBisOnly AS DECIMAL INITIAL 0 NO-UNDO.
     DEFINE VARIABLE iInBisOnly AS INTEGER INITIAL 0 NO-UNDO.

 cGrAcct="".
 oDocCollect = new TDocCollect().
 oDocCollect:date-beg=OperDate.
 oDocCollect:date-end=OperDate.
 oDocCollect:sortOrder="acct-db".
 oDocCollect:user-id="BNK-CL".
 oDocCollect:applyFilter().

 hBuffer=TDocCollect:DEFAULT-BUFFER-HANDLE.

 DO i = 1 TO oDocCollect:docCount:

    /*  -  */

    oDocument = oDocCollect:getDocument(i).

    hBuffer:FIND-FIRST("WHERE TPay=" + QUOTER(oDocument:acct-db) + " AND TRcpt=" + QUOTER(oDocument:acct-rcpt) + " AND TNum=" + QUOTER(oDocument:doc-num) + " AND TSum=" + QUOTER(oDocument:sum),NO-LOCK) NO-ERROR.
   
      IF NOT hBuffer:AVAILABLE THEN
         DO:
             /* -   IBank */

             IF cGrAcct NE oDocument:acct-db THEN
               DO:

                TableInBIS:addrow().
                TableInBIS:addCell(" ").                
                TableInBIS:addCell(" ").        
                TableInBIS:addCell(" ").        
                TableInBIS:addCell(" ").        
                TableInBIS:addCell(" ").        
                TableInBIS:addCell(" ").        


                 cGrAcct=oDocument:acct-db.
               END.
           
                tTableInBIS:addrow().
                tTableInBIS:addCell(oDocument:doc-num).                
                tTableInBIS:addCell(oDocument:acct-db).        
                tTableInBIS:addCell(oDocument:acct-rcpt).        
                tTableInBIS:addCell(STRING(oDocument:sum)).        
                tTableInBIS:addCell("").        
                tTableInBIS:addCell("").                               

                dSumInBisOnly = dSumInBisOnly + oDocument:sum.
             iInBisOnly = iInBisOnly + 1.
         END. /*   -  IBank */        
       oDocument = ?.

      END. /*   -  */
      
     dItogoInBIS = dSumInBisOnly.
     iKolvoInBIS = iInBisOnly.

     DELETE OBJECT oDocCollect.
     DELETE OBJECT hBuffer NO-ERROR.
END METHOD.
METHOD PROTECTED VOID inBoth():
       /*****************************************
        * ®ª  ­¥ ¨­â¥à¥á¥­                     *
        *****************************************/
END METHOD.

METHOD PUBLIC LOGICAL exec():
       /******************************************
        * ®à¬¨àã¥¬ ®âç¥â.                       *
        ******************************************/
   load2First().
   load2Sec().
   inFirstButNotInSec().
   inSecButNotInFirst().  
END METHOD.

DESTRUCTOR TIBankBisCompr():
  DELETE OBJECT TableInBIS.
  DELETE OBJECT TableInIBank.
END DESTRUCTOR.
          
END CLASS.