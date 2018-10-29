CLASS TF227Rep:
 {set-prop.i &aa="currYear"    &cc="INT"}
 {set-prop.i &aa="dEndDate" &cc="DATE"}
 {set-prop.i &aa="iCountIsDepended"    &cc="INT"     &init="1"}
 {set-prop.i &aa="iCountIsNotDepended" &cc="INT"     &init="1"}
 {set-prop.i &aa="uQuery"              &cc="CHAR"    &perms="PROTECTED" &init="?"}
 {set-prop.i &aa="whereCond"           &cc="CHAR"    &init="?"}
 {set-prop.i &aa="hQuery"              &cc="HANDLE"  &perms="PRIVATE"}
 {set-prop.i &aa="currQuery"           &cc="CHAR"    &perms="PRIVATE"}
 {set-prop.i &aa="marketPrice"         &cc="DECIMAL" &perms="PROTECTED" &init="?"}
 {set-prop.i &aa="currClassCode"       &cc="CHAR"}
 {set-prop.i &aa="upNalog"             &cc="DEC"     &init="0"}
 {set-prop.i &aa="condition"   &cc="CHAR"}

  DEF PRIVATE VAR vBegDate AS DATE NO-UNDO.

  DEF PUBLIC PROPERTY dBegDate AS DATE
     GET:
       RETURN vBegDate.
     END GET.
     SET (INPUT iValue AS DATE):
      ASSIGN
       currYear = YEAR(iValue)
       vBegDate = iValue
      .
     END SET.

  CONSTRUCTOR TF227Rep():

    dBegDate = 06/01/2012.
    dEndDate = 06/30/2012.

    currClassCode = "f227_1".

  END CONSTRUCTOR.


  METHOD PROTECTED CHAR buildQuery():
    DEF VAR cDefQuery AS CHAR NO-UNDO.

    cDefQuery = "FOR EACH DataBlock WHERE DataBlock.DataClass-id EQ " + QUOTER(currClassCode) + " 
                              AND DataBlock.Beg-Date EQ " + QUOTER(dBegDate) + " AND DataBlock.End-Date EQ " + QUOTER(dEndDate) + " NO-LOCK, 
                              EACH DataLine WHERE DataLine.data-id EQ DataBlock.data-id " + (IF whereCond <> ? THEN whereCond ELSE "") + " NO-LOCK BY DEC(val[9])".

    currQuery = (IF uQuery <> ? THEN uQuery ELSE cDefQuery).
    RETURN currQuery.
  END METHOD.


  METHOD PUBLIC VOID build():
    DEF VAR oAArray AS TAArray NO-UNDO.

             onBeforeBuild().

             buildQuery().

             calcMarketPrice().

             CREATE QUERY hQuery.

             hQuery:SET-BUFFERS(BUFFER DataBlock:HANDLE,BUFFER DataLine:HANDLE).
             hQuery:QUERY-PREPARE(currQuery).

             hQuery:QUERY-OPEN().
             hQuery:GET-FIRST(NO-LOCK).

             REPEAT WHILE NOT hQuery:QUERY-OFF-END:  

             oAArray = NEW TAArray().
             oAArray:loadSplittedList(DataLine.txt,"~001",FALSE).

              IF LOGICAL(DataLine.Sym3) THEN DO:
                   THIS-OBJECT:buildIsDepended(BUFFER DataLine:HANDLE,oAArray).
                   iCountIsDepended = iCountIsDepended + 1.
              END.
              ELSE DO:
                   THIS-OBJECT:buildIsNotDepended(BUFFER DataLine:HANDLE,oAArray).
                   iCountIsNotDepended = iCountIsNotDepended + 1.
              END.

            DELETE OBJECT oAArray.

            hQuery:GET-NEXT(NO-LOCK).
          END.                               

            hQuery:QUERY-CLOSE().
            DELETE OBJECT hQuery.

            onAfterBuild().
  END METHOD.

 METHOD PROTECTED LOG onBeforeBuild():
   
 END METHOD.

 METHOD PROTECTED LOG onAfterBuild():

     DEF BUFFER pDataBlock FOR DataBlock.
     DEF BUFFER pDataLine  FOR DataLine.

         FOR EACH pDataBlock WHERE pDataBlock.DataClass-id EQ 'f227_2' 
                               AND pDataBlock.Beg-Date EQ dBegDate AND pDataBlock.End-Date EQ dEndDate NO-LOCK,
            FIRST pDataLine WHERE pDataLine.data-id EQ pDataBlock.data-id AND CAN-DO(condition,pDataLine.Sym2):
             pDataLine.Val[5] = THIS-OBJECT:upNalog.
         END.

 END METHOD.

 METHOD PROTECTED VOID buildIsDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):


 END METHOD.

 METHOD PROTECTED VOID buildIsNotDepended(INPUT bufShowCase AS HANDLE,INPUT oAArray AS TAArray):

 END METHOD.

 METHOD PUBLIC DECIMAL calcMarketPrice():
         IF marketPrice = ? THEN 
            DO:
               marketPrice = getMarketPrice().
            END.

         RETURN marketPrice.     
 END METHOD.

  METHOD PROTECTED DECIMAL getMarketPrice():
         DEF BUFFER pDataBlock FOR DataBlock.
         DEF BUFFER pDataLine  FOR DataLine.

         FOR EACH pDataBlock WHERE pDataBlock.DataClass-id EQ 'f227_2' 
                               AND pDataBlock.Beg-Date EQ dBegDate AND pDataBlock.End-Date EQ dEndDate NO-LOCK,
            FIRST pDataLine WHERE pDataLine.data-id EQ pDataBlock.data-id AND CAN-DO(condition,pDataLine.Sym2) NO-LOCK:
             RETURN pDataLine.Val[1].
         END.
  END METHOD.


END CLASS.