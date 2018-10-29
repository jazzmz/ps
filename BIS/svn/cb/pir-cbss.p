/************************
 * ���ᠭ�� ������権 � ���
 ************************
 * ���� : ��⮢ �.�.
 * ���: #2813
 ************************/


 {g-defs.i}
 {a-defs.i}
 {def-wf.i new}
 {defframe.i new}
 {intrface.get instrum}  /* ������⥪� ��� ࠡ��� � 䨭. �����㬥�⠬�. */
 {intrface.get acct}     /* ������⥪� ��� ࠡ��� � 䨭. �����㬥�⠬�. */
 {intrface.get xclass}
 {intrface.get db2l}


 DEF INPUT  PARAM in-op-date  AS DATE        NO-UNDO.
 DEF INPUT  PARAM oprid       AS RECID       NO-UNDO.



 DEF VAR hOperTable AS HANDLE                NO-UNDO.
 DEF VAR cFileName  AS CHAR                  NO-UNDO.
 DEF VAR hQuery     AS HANDLE                NO-UNDO.
 DEF VAR hTTB       AS HANDLE                NO-UNDO.
 DEF VAR oTable     AS TTable2               NO-UNDO.
 DEF VAR iCount     AS INT  INIT 0           NO-UNDO.
 DEF VAR comExchange AS DEC                  NO-UNDO. 
 DEF VAR ndsExchange AS DEC                  NO-UNDO.
 DEF VAR qty2sell    AS DEC                  NO-UNDO.
 DEF VAR dDiff       AS DEC                  NO-UNDO.
 DEF VAR currFund    AS HANDLE               NO-UNDO.
 DEF VAR cbCount     AS TAArray              NO-UNDO.

 DEF VAR doCorrect   AS LOG INIT FALSE       NO-UNDO.

 DEF VAR currStatus  AS CHAR INIT "�"        NO-UNDO.

 DEF VAR key1  AS CHAR                  NO-UNDO.
 DEF VAR val1  AS CHAR                  NO-UNDO.
 DEF VAR cV    AS CHAR                  NO-UNDO.


 DEF VAR cur-n           LIKE currency.currency     NO-UNDO.
 DEF VAR vclass          LIKE class.class-code      NO-UNDO.
 DEF VAR vacct-cat       LIKE acct.acct-cat         NO-UNDO.
 DEF VAR tcur-db         LIKE op-templ.currency     NO-UNDO.
 DEF VAR tcur-cr         LIKE op-templ.currency     NO-UNDO.
 DEF VAR noe             LIKE op-entry.op-entry     NO-UNDO.
 DEF VAR dval            LIKE op-entry.value-date   NO-UNDO.


 DEF TEMP-TABLE availableAcct
                FIELD iss_id      AS CHAR
                FIELD BodyAcct    AS CHAR
                FIELD ZAcct       AS CHAR
                FIELD uPOAcct     AS CHAR
                FIELD uPPAcct     AS CHAR
                FIELD POAcct      AS CHAR
                FIELD PPAcct      AS CHAR
                FIELD PKDnAcct    AS CHAR
                FIELD PKDuAcct    AS CHAR
                FIELD PremDiskAcct AS CHAR
                FIELD currQty     AS DEC
                FIELD qty         AS DEC
                FIELD pos         AS DEC
                FIELD price       AS DEC
                FIELD ZAcctPos    AS DEC
                FIELD PPAcctPos   AS DEC
                FIELD POAcctPos   AS DEC
                FIELD PKDnAcctPos AS DEC
                FIELD PKDuAcctPos AS DEC
                FIELD PremDiskAcctPos AS DEC
                FIELD ZAcctPrice  AS DEC
                FIELD PPAcctPrice AS DEC
                FIELD POAcctPrice AS DEC
                FIELD PKDnAcctPrice AS DEC
                FIELD PKDuAcctPrice AS DEC
                FIELD PremDiskAcctPrice AS DEC
                INDEX idx_iss_id IS PRIMARY iss_id
             .


 {details.def}

 {pir-aacctcb.i}

 DEF BUFFER newAcct FOR acct.


 PROCEDURE initFunds:
   DEF INPUT PARAM currFund  AS CHAR NO-UNDO.
   DEF INPUT PARAM currCount AS INT  NO-UNDO.
   DEF INPUT PARAM currDate  AS DATE NO-UNDO.

   DEF BUFFER acct  FOR acct.
   DEF BUFFER acct2 FOR acct.

   DEF VAR cMask    AS CHAR NO-UNDO.
   DEF VAR cBodyAcct AS CHAR NO-UNDO.
   DEF VAR cZAcct    AS CHAR NO-UNDO.
   DEF VAR cPOAcct   AS CHAR NO-UNDO.
   DEF VAR cPPAcct   AS CHAR NO-UNDO.
   DEF VAR cPKDnAcct AS CHAR NO-UNDO.
   DEF VAR cPKDuAcct AS CHAR NO-UNDO.
   DEF VAR cPremDiskAcct AS CHAR NO-UNDO.

   DEF VAR cZPos  AS DEC NO-UNDO.
   DEF VAR cPPPos AS DEC NO-UNDO.
   DEF VAR cPOPos AS DEC NO-UNDO.
   DEF VAR cPKDnPos AS DEC NO-UNDO.
   DEF VAR cPKDuPos AS DEC NO-UNDO.
   DEF VAR cPremDiskPos AS DEC NO-UNDO.

   DEF VAR qty       AS DEC        NO-UNDO.
   DEF VAR pos       AS DEC        NO-UNDO.
   DEF VAR qty2fund  AS DEC INIT 0 NO-UNDO.


    FOR EACH signs WHERE signs.file-name  EQ "acct"
                     AND signs.code       EQ "sec-code"
                     AND signs.code-value EQ  currFund NO-LOCK,
         FIRST acct WHERE acct.acct    EQ ENTRY(1,signs.surrogate)
                     AND acct.currency EQ ENTRY(2,signs.surrogate)
                     AND acct.contract EQ "�����"
                     AND (acct.close-date > in-op-date OR acct.close-date = ?) 
                     NO-LOCK BY DEC(SUBSTRING(acct.acct,10,11)):


                   IF qty2fund >= currCount THEN RETURN.

                    cBodyAcct = acct.acct.
		 
                    RUN acct-pos IN h_base (cBodyAcct,
                                            "",
                                            currDate,
                                            currDate,
                                            currStatus
                                            ).
                    pos = ABS(sh-bal).

                    RUN acct-qty IN h_base (cBodyAcct,
                                            acct.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).
                    qty = ABS(sh-qty).

                    IF pos <= 0 OR qty <= 0 THEN NEXT.

                    qty2fund = qty2fund + qty.


                    cMask = getAcct(cBodyAcct,"������").
                    FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.                 
                    cZAcct = acct2.acct.

                    RUN acct-pos IN h_base (cZAcct,
                                            acct2.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).

                     cZPos = ABS(sh-bal).

                    cMask = getAcct(cBodyAcct,"�����").
                    FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.
                    cPPAcct = acct2.acct.

                    RUN acct-pos IN h_base (cPPAcct,
                                            acct2.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).

                    cPPPos = ABS(sh-bal).

                    cMask = getAcct(cBodyAcct,"�����").
                    FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.
                    cPOAcct = acct2.acct.
                                                  
                    RUN acct-pos IN h_base (cPOAcct,
                                            acct2.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).

                     cPOPos = ABS(sh-bal).

                    cMask = getAcct(cBodyAcct,"������").
                    FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.
                    cPKDnAcct = acct2.acct.
                                                  
                    RUN acct-pos IN h_base (cPKDnAcct,
                                            acct2.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).

                    cPKDnPos = ABS(sh-bal).

                    cMask = getAcct(cBodyAcct,"������").
                    FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.
                    cPKDuAcct = acct2.acct.
                                                  
                    RUN acct-pos IN h_base (cPKDuAcct,
                                            acct2.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).

                    cPKDuPos = ABS(sh-bal).


                    cMask = getAcct(cBodyAcct,"�६��").
                    FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.
                    IF NOT AVAIL(acct2) THEN 
                    DO:
                       cMask = getAcct(cBodyAcct,"��᪮��").
                       FIND FIRST acct2 WHERE acct2.acct MATCHES cMask AND (acct2.close-date > currDate OR acct2.close-date = ?) NO-LOCK.
                    END.

                    cPremDiskAcct = acct2.acct.

                    RUN acct-pos IN h_base (cPremDiskAcct,
                                            acct2.currency,
                                            currDate,
                                            currDate,
                  	                    currStatus
                                            ).

                    cPremDiskPos = ABS(sh-bal).



                   CREATE availableAcct.
                       ASSIGN
                          availableAcct.iss_id       = currFund
                          availableAcct.BodyAcct     = cBodyAcct
                          availableAcct.ZAcct        = cZAcct
                          availableAcct.PPAcct       = cPPAcct 
                          availableAcct.POAcct       = cPOAcct 
                          availableAcct.uPPAcct      = getXAttrValue("sec-code",currFund,"��⏊�")
                          availableAcct.uPOAcct      = getXAttrValue("sec-code",currFund,"��⎊�")
                          availableAcct.qty          = qty
                          availableAcct.currQty      = qty
                          availableAcct.pos          = pos
                          availableAcct.price        = pos / qty
                          availableAcct.ZAcctPos     = cZPos
                          availableAcct.PPAcctPos    = cPPPos
                          availableAcct.POAcctPos    = cPOPos
                          availableAcct.ZAcctPrice   = cZPos / qty
                          availableAcct.PPAcctPrice  = cPPPos / qty
                          availableAcct.POAcctPrice  = cPOPos / qty
                          availableAcct.PKDnAcct           = cPKDnAcct
                          availableAcct.PKDnAcctPos        = cPKDnPos
                          availableAcct.PKDnAcctPrice      = cPKDnPos / qty
                          availableAcct.PKDuAcct           = cPKDuAcct     
                          availableAcct.PKDuAcctPos        = cPKDuPos      
                          availableAcct.PKDuAcctPrice      = cPKDuPos / qty
                          availableAcct.PremDiskAcct       = cPremDiskAcct     
                          availableAcct.PremDiskAcctPos    = cPremDiskPos      
                          availableAcct.PremDiskAcctPrice  = cPremDiskPos / qty
                       .
      
    END.
   

 END PROCEDURE.

 PROCEDURE createOpByWop:
  FOR EACH wop NO-LOCK, 
     FIRST op-template OF op-kind WHERE op-template.op-template = wop.op-templ NO-LOCK:

        IF wop.amt-rub <= 0 THEN NEXT.

        CREATE op. 

        {op(sess).cr}
        {g-op.ass}

        ASSIGN
            op.doc-num  = STRING(GetCounterNextValue("��騩",op.op-date))
            op.doc-date = in-op-date
            op.details  = wop.details
        .
     /* ���ਬ��, ��� ���� 
      * ����� ��� ������⥫쭮� ��� ����⥫쭮� ��८業�� ���
      * ��ࠦ���� 䨭. १����.
      */



        CREATE op-entry.
              ASSIGN
               op-entry.op-date      = in-op-date
               op-entry.acct-cat     = wop.acct-cat
               op-entry.op-status    = op.op-status
               op-entry.user-id      = op.user-id
               op-entry.op           = op.op
               op-entry.op-entry     = 1
               op-entry.acct-db      = wop.acct-db
               op-entry.acct-cr      = wop.acct-cr
               op-entry.currency     = wop.currency
               op-entry.value-date   = in-op-date
               op-entry.amt-cur      = 0
               op-entry.amt-rub      = wop.amt-rub
               op-entry.qty          = wop.qty
               op-entry.type         = wop.type
               op-entry.op-cod       = wop.op-cod
        .

/*       {op.upd &undo="undo, return "}*/
   END.

 END PROCEDURE.


 {getfile.i &set1     = "������"
            &set2     = "��⠫��"
            &mode     = must-exist
            &filename = cFileName
            &return   = "LEAVE"
  }

 cFileName = fname.


{setdest.i}

 cbCount = NEW	TAArray("0").

 CREATE TEMP-TABLE hOperTable.
 hOperTable:READ-XML("FILE",cFileName,?,?,?,?).


 oTable = NEW TTable2().

 /**
  *  ����� �1. ��⠥� ���-�� 
  * �㬠� ��������� � ᯨᠭ��.
  **/
 CREATE QUERY hQuery.
 hQuery:SET-BUFFERS(hOperTable:DEFAULT-BUFFER-HANDLE).
 hQuery:QUERY-PREPARE("FOR EACH fund").
 hQuery:QUERY-OPEN().

 hQuery:GET-FIRST(NO-LOCK).  

  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    cbCount:incrementTo(hOperTable::id,ABS(DEC(hOperTable::count))).
    hQuery:GET-NEXT(NO-LOCK).
  END.

 hQuery:QUERY-CLOSE().
 DELETE OBJECT hQuery.

  /**
   * ����� �2. �⡨ࠥ� ��� ����� ���� ���⢮����
   * � ᤥ���.
   **/
  {foreach cbCount key1 val1}
    PUT UNFORMATTED key1 "===" val1 SKIP.
    RUN initFunds (key1,val1,in-op-date).
  {endforeach cbCount}

 /**
  * ����� �3. �ந������ �����।�⢥��� ᯨᠭ��.
  **/


 CREATE QUERY hQuery.
 hQuery:SET-BUFFERS(hOperTable:DEFAULT-BUFFER-HANDLE).
 hQuery:QUERY-PREPARE("FOR EACH fund").
 hQuery:QUERY-OPEN().

 hQuery:GET-FIRST(NO-LOCK).
  

  REPEAT WHILE NOT hQuery:QUERY-OFF-END:

    iCount = iCount + 1.

    currFund = hOperTable.

    currFund::count = STRING(ABS(DEC(currFund::count))).



   RUN SetSysConf IN h_base ("��1",currFund::n).
   RUN SetSysConf IN h_base ("��2",currFund::dt).
   RUN SetSysConf IN h_base ("��3",currFund::name).
   RUN SetSysConf IN h_base ("��4",currFund::type).
   RUN SetSysConf IN h_base ("��5",currFund::count).
   RUN SetSysConf IN h_base ("��6",currFund::price).
   RUN SetSysConf IN h_base ("��7",currFund::totalPrice).
   RUN SetSysConf IN h_base ("��8",currFund::exchange).
   RUN SetSysConf IN h_base ("��9",currFund::its).
   RUN SetSysConf IN h_base ("��10",currFund::klir).
   RUN SetSysConf IN h_base ("��11",currFund::broker1).
   RUN SetSysConf IN h_base ("��12",currFund::broker2).
   RUN SetSysConf IN h_base ("��13",currFund::profit).

                                         

    /** ���뢠�� ��� ����� **/
    RUN createAcct ("�",?,"61210���������������",in-op-date,BUFFER newAcct).
    cV = newAcct.acct.
    newAcct.details = "���⨥ ��権 " + getSysConf("��3") + " �� ᤥ��� " + getSysConf("��1") + ", " + getSysConf("��5") + " ��.".
    UpdateSigns("acctbcb",getSurrogateBuffer("acct",BUFFER newAcct:HANDLE),"PirNum",currFund::n,?).
    RELEASE newAcct.

      FIND FIRST op-kind WHERE RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.

      FOR EACH op-template OF op-kind NO-LOCK:
     
        
         CREATE wop.
           {asswop.i}

            ASSIGN
              wop.con-date = in-op-date
              wop.acct-cr  = op-template.acct-cr
              wop.qty      = 1
              wop.op-statu = op-template.op-status
              cur-op-date  = in-op-date.
           .


           CASE op-template.op-template:

               WHEN 10 THEN DO:
                  ASSIGN
                    wop.acct-db = op-template.acct-db
                    wop.acct-cr = cV
                    wop.amt-rub = DEC(currFund::count) * DEC(currFund::price)

                  .
               END.
             END.
       RUN ProcessDetails (RECID(wop), INPUT-OUTPUT wop.details).
 END.
     RUN createOpByWop.

     EMPTY TEMP-TABLE wop.

    FOR EACH availableAcct WHERE iss_id = currFund::id:

      IF currFund::count <= 0 THEN NEXT.

      qty2sell = MIN(availableAcct.currQty,DEC(currFund::count)).


      IF qty2sell <= 0 THEN NEXT.

      doCorrect = (qty2sell >= availableAcct.currQty).

      dDiff = currFund::price - availableAcct.price.


      /**********************
       * �������� ���-��
       **********************/

   /****************************
    * ����� �2:
    *    ������ ᮧ���� ���㬥���
    * �� ��㯯� 1
    ****************************/

    

FIND FIRST op-kind WHERE RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.

      FOR EACH op-template OF op-kind NO-LOCK:
     
        
         CREATE wop.
           {asswop.i}

           ASSIGN
             wop.con-date = in-op-date
             wop.acct-cr  = op-template.acct-cr
             wop.qty      = 1
             wop.op-statu = op-template.op-status
             cur-op-date  = in-op-date.
           .


           CASE op-template.op-template:

               WHEN 21 THEN DO:  /* ⥫�, ����� �2 */
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = availableAcct.bodyAcct
                      wop.amt-rub = (IF doCorrect THEN availableAcct.pos ELSE ROUND(qty2sell * availableAcct.price,2))
                      wop.qty     = qty2sell
                    .

                  availableAcct.pos      = availableAcct.pos - wop.amt-rub.

               END.

/**********/

               WHEN 22 THEN DO:  /* ��� ���*/
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = availableAcct.PKDnAcct
                      wop.amt-rub = (IF doCorrect THEN availableAcct.PKDnAcctPos ELSE ROUND(qty2sell * availableAcct.PKDnAcctPrice,2))
                    .

                  availableAcct.ZAcctPos = availableAcct.PKDnAcctPos - wop.amt-rub.
               END.

               WHEN 23 THEN DO:  /* ��� 㯫 */
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = availableAcct.PKDuAcct
                      wop.amt-rub = (IF doCorrect THEN availableAcct.PKDuAcctPos ELSE ROUND(qty2sell * availableAcct.PKDuAcctPrice,2))
                    .

                  availableAcct.ZAcctPos = availableAcct.PKDuAcctPos - wop.amt-rub.
               END.

               WHEN 24 THEN DO:  /* ������, ����� �3 */
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = availableAcct.ZAcct
                      wop.amt-rub = (IF doCorrect THEN availableAcct.ZAcctPos ELSE ROUND(qty2sell * availableAcct.ZAcctPrice,2))
                    .

                  availableAcct.ZAcctPos = availableAcct.ZAcctPos - wop.amt-rub.
               END.

               WHEN 25 THEN DO:  /* ��᪮��/�६�� */
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = availableAcct.PremDiskAcct
                      wop.amt-rub = (IF doCorrect THEN availableAcct.PremDiskAcctPos ELSE ROUND(qty2sell * availableAcct.PremDiskAcctPrice,2))
                    .

                  availableAcct.PremDiskAcctPos = availableAcct.PremDiskAcctPos - wop.amt-rub.
               END.
/**********/


               WHEN 31 THEN DO:
                     ASSIGN
                        wop.acct-db = cV
                        wop.acct-cr = availableAcct.PPAcct
                        wop.amt-rub = IF availableAcct.PPAcctPos > 0 THEN (IF doCorrect THEN availableAcct.PPAcctPos ELSE ROUND(qty2sell * availableAcct.PPAcctPrice,2)) ELSE 0
                      .

                  availableAcct.PPAcctPos = PPAcctPos - wop.amt-rub.

               END.

               WHEN 32 THEN DO:
                     ASSIGN
                        wop.acct-db = availableAcct.uPPAcct
                        wop.acct-cr = op-template.acct-cr
                        wop.amt-rub = IF availableAcct.PPAcctPos > 0 THEN (IF doCorrect THEN availableAcct.PPAcctPos ELSE ROUND(qty2sell * availableAcct.PPAcctPrice,2)) ELSE 0
                      .

               END.

               WHEN 33 THEN DO:
                     ASSIGN
                        wop.acct-db = availableAcct.POAcct
                        wop.acct-cr = cV
                        wop.amt-rub = IF availableAcct.POAcctPos > 0 THEN (IF doCorrect THEN availableAcct.POAcctPos ELSE ROUND(qty2sell * availableAcct.POAcctPrice,2)) ELSE 0
                      .

                  availableAcct.POAcctPos = availableAcct.POAcctPos - wop.amt-rub.

               END.

               WHEN 34 THEN DO:
                     ASSIGN
                        wop.acct-db = op-template.acct-db
                        wop.acct-cr = availableAcct.uPOAcct
                        wop.amt-rub = IF availableAcct.POAcctPos > 0 THEN (IF doCorrect THEN availableAcct.POAcctPos ELSE ROUND(qty2sell * availableAcct.POAcctPrice,2)) ELSE 0
                      .

               END.

           END CASE.


            RUN ProcessDetails (RECID(wop), INPUT-OUTPUT wop.details).

      END.

     RUN createOpByWop.

     EMPTY TEMP-TABLE wop.
     /***************************
      * ����� ᮧ����� ���㬥�⮢
      ***************************/

      currFund::count        = STRING(DEC(currFund::count) - qty2sell).
      availableAcct.currQty  = availableAcct.currQty  - qty2sell.
    END.   

     /***
      * ����� �3. ������ ᮧ���� ���㬥���
      * �� ��㯯� 2
      ***/
      FIND FIRST op-kind WHERE RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.

      FOR EACH op-template OF op-kind NO-LOCK:
     
        
         CREATE wop.
           {asswop.i}

           ASSIGN
             wop.con-date = in-op-date
             wop.acct-cr  = op-template.acct-cr
             wop.qty      = 1
             wop.op-statu = op-template.op-status
             cur-op-date  = in-op-date.
           .


         CASE op-template.op-template:

               WHEN 41 THEN DO:
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = op-template.acct-cr
                      wop.amt-rub = DEC(currFund::broker2)
                    .
               END.

               WHEN 42 THEN DO:
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = op-template.acct-cr
                      wop.amt-rub = DEC(currFund::exchange)
                    .
               END.

               WHEN 43 THEN DO:
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = op-template.acct-cr
                      wop.amt-rub = 100 * DEC(currFund::its) / 118
                    .

               END.

               WHEN 44 THEN DO:
                    ASSIGN
                      wop.acct-db = op-template.acct-db
                      wop.acct-cr = op-template.acct-cr
                      wop.amt-rub = 18 * DEC(currFund::its) / 118
                    .
               END.

               WHEN 45 THEN DO:
                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = op-template.acct-cr
                      wop.amt-rub = currFund::klir
                    .
               END.
       END.
       RUN ProcessDetails (RECID(wop), INPUT-OUTPUT wop.details).
    END.

    RUN createOpByWop.

     EMPTY TEMP-TABLE wop.

     FIND FIRST op-kind WHERE RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.
      FOR EACH op-template OF op-kind NO-LOCK:
         CREATE wop.
           {asswop.i}

           ASSIGN
             wop.con-date = in-op-date
             wop.acct-cr  = op-template.acct-cr
             wop.qty      = 1
             wop.op-statu = op-template.op-status
             cur-op-date  = in-op-date.
           .

          CASE op-template.op-template:
            WHEN 13 THEN DO:

                    RUN acct-pos IN h_base (cV,
                                            "",
                                            in-op-date,
                                            in-op-date,
                                            currStatus
                                            ).

                    ASSIGN
                      wop.acct-db = cV
                      wop.acct-cr = op-template.acct-cr
                      wop.amt-rub = IF dDiff > 0 THEN ABS(sh-bal) ELSE 0
                    .
           END.

            WHEN 14 THEN DO:
                   RUN acct-pos IN h_base (cV,
                                            "",
                                            in-op-date,
                                            in-op-date,
                                            currStatus
                                            ).

                    ASSIGN
                      wop.acct-db = op-template.acct-db
                      wop.acct-cr = cV
                      wop.amt-rub = IF dDiff < 0 THEN ABS(sh-bal) ELSE 0
                    .
            END.

           END.

       RUN ProcessDetails (RECID(wop), INPUT-OUTPUT wop.details).

      END.

    RUN createOpByWop.

    EMPTY TEMP-TABLE wop.

    hQuery:GET-NEXT(NO-LOCK).
    RUN DeleteOldDataProtocol IN h_base ("��1").
    RUN DeleteOldDataProtocol IN h_base ("��2").
    RUN DeleteOldDataProtocol IN h_base ("��3").
    RUN DeleteOldDataProtocol IN h_base ("��4").
    RUN DeleteOldDataProtocol IN h_base ("��5").
    RUN DeleteOldDataProtocol IN h_base ("��6").
    RUN DeleteOldDataProtocol IN h_base ("��7").
    RUN DeleteOldDataProtocol IN h_base ("��8").
    RUN DeleteOldDataProtocol IN h_base ("��9").
    RUN DeleteOldDataProtocol IN h_base ("��10").
    RUN DeleteOldDataProtocol IN h_base ("��11").
    RUN DeleteOldDataProtocol IN h_base ("��12").
    RUN DeleteOldDataProtocol IN h_base ("��13").
  END.

 hQuery:QUERY-CLOSE().

 DELETE OBJECT cbCount.
 DELETE OBJECT hQuery.

 oTable:show().

 DELETE OBJECT oTable.
{preview.i}
{intrface.del}