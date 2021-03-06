USING Progress.Lang.*.

CLASS TDocument INHERITS TDoc 
                IMPLEMENTS IFinObj:

/**************************************************************
 * ����� ���� �।�⠢������ ��魮�� "���㬥��".
 * �।��⠢��� ����� � ᢮��⢠� ���㬥��, � ⠪�� � ���ᨢ�,
 * �室��� � ���� �஢����.
 *
 * ����: ��᫮� �. �.
 * ��� ᮧ�����: 25.04.2009
 * ��� ����䨪�樨: 30.04.2009
 *
************************************/

  /*** PROTECTED ���� ������ ***/

 
  DEF PROTECTED BUFFER bOp FOR op.                                                                /* ������ ���㬥�⮢ */
  DEF PROTECTED BUFFER bOpEntry FOR op-entry.                                                   /* ������ �஢����      */


  DEF PRIVATE VAR oBankBen AS TBank NO-UNDO.                                                                          /* ���� �����⥫�, ����� ������쭮� ��६�����, �⮡� ����� �뫮 㭨�⮦���. �殮�� ��� ᡮ�騪� ����!!! */

  
 /*** PRIVATE  ���� ������ ***/

  DEFINE PRIVATE TEMP-TABLE DocOpEntry NO-UNDO                                                 /* �६����� ⠡��� ��� �࠭���� ��ꥪ⮢-�஢���� �室��� � ���㬥�� */
         FIELD iNum AS INTEGER
         FIELD iOrderNum AS INTEGER
         FIELD opentry AS CLASS Object
         INDEX iiNum IS PRIMARY iNum
         INDEX iiOrderNum iOrderNum
         .

 /*** PUBLIC �������� ��������� ***/

{set-prop.i &aa="order-pay"             &bb="cOrder-Pay" &cc="INTEGER"}                                                        /* ��।����� ���⥦� */
{set-prop.i &aa="DocRecid"        &bb="iRecId" &cc="INTEGER" perms="PROTECTED"}                         /* RECID ���㬥�� */
{set-prop.i &aa="OpEntryCount" &bb="iOpEntryCount" &cc="INTEGER" perms="PRIVATE"}                   /* ��� ���㬥�� */
{set-prop.i &aa="sum"                      &bb="dDocSum" &cc="DECIMAL" perms="PRIVATE"}                                   /* C㬬� ���㬥�� */
{set-prop.i &aa="sum-in-val"  &bb="dDocSumVal" &cc="DECIMAL" perms="PRIVATE"}                                   /* C㬬� ���㬥�� � ����� ���㬥�� */

{set-prop.i &aa="currency"    &bb="cCurrency"  &cc="CHARACTER" perms="PRIVATE" &init="\"\""}                                   /* ����� ������� */

{set-prop.i &aa="AcctPosInRub"             &bb="dAcctPosInRub" &cc="DECIMAL"}                                   /* ������ �� ���� � ���.����� ��� ��� � ������� ��᫥ �믮������ GetPos() */

{set-prop.i &aa="acct-db"              &bb="cacct-db" &cc="CHARACTER" }                                                           /* ��� �� ������     */
{set-prop.i &aa="acct-cr"              &bb="cacct-cr" &cc="CHARACTER" }                                                                   /* ��� �� �।���    */
{set-prop.i &aa="acct-rcpt"              &bb="cacct-rcpt" &cc="CHARACTER"}                                                           /* ��� �� �।���    */
{set-prop.i &aa="name-ben"              &bb="cname-ben" &cc="CHARACTER"}                                                   /* ��� �����⥫�    */
{set-prop.i &aa="inn"                      &bb="cinn" &cc="CHARACTER"}                                                                           /* ��� �����⥫�    */

{set-prop.i &aa="ins-date"       &bb="dIns-date"      &cc="DATE"}                                                                           /* ��� �����⥫�    */
{set-prop.i &aa="doc-date"       &bb="dDoc-date"      &cc="DATE"}
{set-prop.i &aa="op-date"        &bb="dOp-date"       &cc="DATE"}
{set-prop.i &aa="op-value-date"  &bb="dop-value-date" &cc="DATE"}


{set-prop.i &aa="user-inspector" &bb="cuin"              &cc="CHARACTER"}
{set-prop.i &aa="doc-type"       &bb="cDocType"          &cc="CHARACTER"}  /* ��� ���㬥�� */
{set-prop.i &aa="op-transaction" &bb="iop-transaction"   &cc="INTEGER"}  /* ��� ���㬥�� */
{set-prop.i &aa="op-kind"        &bb="cop-kind"          &cc="CHARACTER"}  /* ��� ���㬥�� */
{set-prop.i &aa="kau-db"         &bb="ckau-db"           &cc="CHARACTER"}  /* ��� ���㬥�� */
{set-prop.i &aa="kau-cr"         &bb="ckau-cr"           &cc="CHARACTER"}  /* ��� ���㬥�� */
{set-prop.i &aa="op"                                     &cc="INT64" perms="PROTECTED"}

DEF PRIVATE VAR dDoc-sum AS DECIMAL INITIAL 0 NO-UNDO.
DEF PUBLIC PROPERTY doc-sum AS DECIMAL
   GET:
      IF currency <> "" THEN RETURN sum-in-val. ELSE RETURN sum.
   END GET.
   SET (INPUT cProp AS DECIMAL):
      dDoc-Sum = cProp.
   END SET.

/*** PUBLIC  ������ ��������� ***/

 CONSTRUCTOR PUBLIC TDocument():
  /*
      ���⮩ ��������� �।������� �ᯮ�짮���� ��� ��������� ���㬥��.
  */
 END CONSTRUCTOR.


  CONSTRUCTOR TDocument(INPUT iDocId AS INTEGER):
             /**********************************
              * ���樠�����㥬 ���㬥��        *
              **********************************/

       FIND FIRST bOp WHERE bOp.op=iDocId AND bOp.op-date<>? NO-LOCK NO-ERROR.

         DocRecid=RECID(bOp).
         
         IF AVAILABLE(bOp) THEN
           DO:
             fillOp(BUFFER bOp:HANDLE).            
           END.

 END.


 CONSTRUCTOR TDocument(INPUT iDocId AS INTEGER,INPUT dDate AS DATE):
      FIND FIRST bOp WHERE bOp.op=iDocId NO-LOCK NO-ERROR.


         DocRecid=RECID(bOp).
         
         IF AVAILABLE(bOp) THEN
           DO:
             fillOp(BUFFER bOp:HANDLE).            
           END.

 END CONSTRUCTOR.
 
 
 CONSTRUCTOR TDocument(INPUT iOpRecid AS RECID):
   /***
                ���樠�����㥬 ��ꥪ�-���㬥��, �� ��� RECID � ����.
    ***/
   
           DocRecid=iOpRecid.
           
           FIND FIRST bOp WHERE RECID(bOp)=iOpRecid AND bOp.op-date<>? NO-LOCK NO-ERROR.
           /* ���樠�����㥬 �᭮��� ४������ ���㬥��� */

              IF AVAILABLE(bOp) THEN
                 DO:

                     fillOp(BUFFER bOp:HANDLE). /* ������塞 ४������ ���-� */
                
                 END.
 END CONSTRUCTOR.

  CONSTRUCTOR TDocument(INPUT iOpRecid AS RECID,INPUT iDate AS DATE):

           DocRecid=iOpRecid.
           
           FIND FIRST bOp WHERE RECID(bOp)=iOpRecid NO-LOCK NO-ERROR.
           /* ���樠�����㥬 �᭮��� ४������ ���㬥��� */

              IF AVAILABLE(bOp) THEN
                 DO:

                     fillOp(BUFFER bOp:HANDLE). /* ������塞 ४������ ���-� */
                
                 END.

  END CONSTRUCTOR.

CONSTRUCTOR TDocument(INPUT bOpHandle AS HANDLE,INPUT initOpEntry AS LOG):
                                /*******************************************
                                 *                                         *
                                 * ���樠�����㥬 ��ꥪ� �� ����� �� ��   *
                                 *                                         *
                                 *******************************************/

                 fillOp(bOpHandle,initOpEntry). /* ������塞 ४������ ���-� */
END CONSTRUCTOR.

METHOD PROTECTED VOID fillOp(INPUT bOpHandle AS HANDLE):
  fillOp(bOpHandle,TRUE).
END METHOD.

METHOD PROTECTED VOID fillOp(INPUT bOpHandle AS HANDLE,INPUT initOpEntry AS LOG):

          /*********************************
           * �㭪�� ���������� �᭮����   *
           * ���-�.                       *
           **********************************/

           DEF VAR oOpEntry AS TOpEntry NO-UNDO.

            ClassType = "op".

          ASSIGN
                  doc-num        = bOpHandle::doc-num
		  user-inspector = bOpHandle::user-inspector
                  user-id        = bOpHandle::user-id
                  doc-id         = bOpHandle::op
                  details        = bOpHandle::details
                  order-pay      = INTEGER(bOpHandle::order-pay)
                  acct-rcpt      = bOpHandle::ben-acct
                  name-ben       = bOpHandle::name-ben
                  DocDate        = bOpHandle::op-date
		  op-date        = bOpHandle::op-date
		  op-value-date  = bOpHandle::op-value-date
                  inn            = bOpHandle::inn
                  Surrogate      = STRING(bOpHandle::op)
                  op             = bOpHandle::op
                  ClassCode      = bOpHandle::class-code              
		  ins-date       = bOpHandle::ins-date
		  doc-date       = bOpHandle::doc-date
		  doc-type       = bOpHandle::doc-type
		  doc-status     = bOpHandle::op-status
		  op-transaction = bOpHandle::op-transaction
		  op-kind	 = bOpHandle::op-kind
           .

            /*********
             * �� ��� #3353 ����᭮ �� ������� � �� 祣�???
             *********/

	    IF initOpEntry THEN
              DO:
                getAndFillOpEntry().       /* ����砥� �� �஢���� ���-� */ 

                 /*
                 ������塞 ४������ ���㬥��
                 �� ��ࢮ� �஢���� ���㬥��.
                 ������ ���뢠��, �� ����������
                 ��砨, ����� � ���㬥�� ���� �஢����,
                 �� ����� �⮩ �஢���� (op-entry.op-entry) � ���㬥��
                 �⫨祭 �������.
                 ���ਬ��, � ���㬥�� ���� �஢����,
                 � �� ���浪��� ����� op-entry=2.
                 */
                 
                 
                 oOpEntry = getOpEntry4Order(1).
                 cacct-db = oOpEntry:acct-db.
                 cacct-cr = oOpEntry:acct-cr.
                 oOpEntry = ?.
              END.
                  
 END METHOD.
  
 METHOD PUBLIC CLASS TOpEntry getOpEntry4Order(INPUT iOrderNum AS INTEGER):
       /******************************************
        *                                        *
        * ��⮤ �����頥� �஢���� ���-�       *
        * �� ���浪����� ������.                 *
        * ������ᨬ� �� ���祭�� ���� op-entry.  *
        *                                        *
        ******************************************/
 
   FIND FIRST DocOpEntry WHERE DocOpEntry.iOrderNum=iOrderNum NO-LOCK NO-ERROR.
   
   IF AVAILABLE(DocOpEntry) THEN
     DO:
         RETURN CAST(DocOpEntry.opentry,"TOpEntry").
     END. 
     
 END METHOD.
 
 METHOD PUBLIC CLASS TOpEntry getOpEntry(INPUT iNum AS INTEGER):
   /*** 
       ��⮤ �����頥� �஢���� � ����஬ iId.
       ������ ����� �����, �� ��� ����஬
       �஢���� ���������� ���祭�� ���� op-entry
       � ⠡��� op-entry.
       ���, ���ਬ��, �������� ��砩, ����� � ���㬥��
       ���� �஢����, � �� ����� �� ������, ��� ���������,�
       ���ਬ��, ���.
       ������⮬ ���� ��ꥪ� ����� TOpEntry
    ***/
    
     FIND FIRST DocOpEntry WHERE DocOpEntry.iNum=iNum NO-LOCK.
      
     IF AVAILABLE(DocOpEntry) THEN
       DO:
         RETURN CAST(DocOpEntry.opentry,"TOpEntry").
       END.
 END METHOD.
 

/*** PRIVATE ������ ������ ***/

   METHOD PROTECTED VOID getAndFillOpEntry():
        /***
             ��⮤ ��樠������� ����७��� ���ᨢ
             �஢����.
        ***/
        DEF VAR iI           AS INTEGER INITIAL 0 NO-UNDO.
        DEF VAR tmpDocSumRub AS DECIMAL INITIAL 0 NO-UNDO.
        DEF VAR tmpDocSumVal AS DECIMAL INITIAL 0 NO-UNDO.
        DEF VAR tmpOpEntry   AS CLASS TOpEntry    NO-UNDO.

       FOR EACH bOpEntry WHERE bOpEntry.op=doc-id NO-LOCK:                                     

               tmpOpEntry=new TOpEntry(bOpEntry.op,bOpEntry.op-entry).

		ASSIGN
		  kau-db	 = tmpOpEntry:kau-db
		  kau-cr	 = tmpOpEntry:kau-cr
		.

               CREATE DocOpEntry.

                    ASSIGN
                           iNum = bOpEntry.op-entry
                           iOrderNum = iI + 1
                           DocOpEntry.opentry = tmpOpEntry
                     .
                                                    
                  iI=iI + 1.
                  /**
                   * �᫨ ��� �� ����
                   * �� �஢���� ����⭠�,
                   * � � � 楫�� ���㬥�� ��⠥� ������.
                   **/
                  IF bOpEntry.currency NE "" THEN currency = bOpEntry.currency.

                  tmpDocSumRub = tmpDocSumRub + tmpOpEntry:rusSum.             
		  tmpDocSumVal = tmpDocSumVal + tmpOpEntry:inSum.
                  tmpOpEntry = ?.  /* ����塞 ��뫪� �� ��ꥪ� */
   
        END.      
       OpEntryCount = iI.
       sum = tmpDocSumRub.
	   sum-in-val = tmpDocSumVal.
   END METHOD.

METHOD PUBLIC LOGICAL add2DB():

END METHOD.

METHOD PUBLIC LOGICAL update2DB():

END METHOD.

METHOD PUBLIC DECIMAL getPos (INPUT cAcct AS CHARACTER):
        /**********************************************
         *                                            *
         * �����頥� ���⮪ � ��⮬                *
         * ��� �� �᪫�祭��� 㤠������ ���㬥�⮢.  *
         *                                            *
         **********************************************/
        RETURN getPos(cAcct,"").
END METHOD.

METHOD PUBLIC DECIMAL getPos (INPUT cAcct AS CHARACTER,INPUT cStatus AS CHARACTER):      
   /************************************************************
    *                                                           *
    * �㭪�� �����頥� ���⮪ �� ����                      *
    * cAcct. �।����������, �� ��᫥����                     *
    * ���㬥�� �� ������� ���� �� � ID OP                    *
    * ���� �� ���� �த㬠��, ��� ������� ᥡ�                 * 
    * ���� � ��砥 ��७�� ���㬥�⮢ �� ���               *
    * � ����.                                                  *
    * �� ��� ���� �㭪�� �⮡ࠦ��� ���⮪                  *
    * �� ���� cAcct �� ���㬥�� OP (� ��⮬                  *
    * �⮣� �� ���㬥��).                                     *
    ************************************************************                                                  
    *                                                          *
    * ���뢠�� ���㬥��� ⮫쪮 � ����� cStatus.            *
    * �� �⮬ ᠬ ���㬥�� ���뢠���� ������ᨬ� �� �����. *
    *                                                          *
    ************************************************************/

   DEF VAR dSum             AS DECIMAL INITIAL 0 NO-UNDO.                /* ����ন� ���⮪ �� ���� */
   DEF VAR dLastPosDate     AS DATE              NO-UNDO.                        /* ��� ��᫥����� �����⮣� ����樮����� ��� �� ����� ���� ���⮪ */
   DEF VAR cPosDir          AS CHARACTER         NO-UNDO.                        /* ���ࠢ����� � ���஬ ��� ������ � �஢���� */
   DEF VAR oAcct            AS CLASS TAcct       NO-UNDO.                        /* ��ꥪ� ��� */
   DEF VAR oSysClass        AS CLASS TSysClass   NO-UNDO.       /* ��ꥪ�-����� ��⥬��� �⨫��  */
   DEF VAR dSumOpEntryWSign AS DECIMAL INITIAL 1 NO-UNDO.

   DEF VAR prihod AS Decimal INITIAL 0 NO-UNDO.
   DEF VAR rashod AS Decimal INITIAL 0 NO-UNDO.

   DEF VAR prihodRub AS Decimal INITIAL 0 NO-UNDO.
   DEF VAR rashodRub AS Decimal INITIAL 0 NO-UNDO.
   DEF VAR dSumRub   AS Decimal INITIAL 0 NO-UNDO.

    oSysClass = new TSysClass().   
    oAcct=new TAcct(cAcct).            

    dSum = oAcct:getBegPos(DocDate,dLastPosDate).
    dSumRub = oAcct:getRurPos(DocDate,dLastPosDate).
     /*
       ���堫� �� �஢�����, ����� �뫨 ᮢ��襭��
       �� 㪠����� ��⠬, ࠭�� ��।�����.       
     */
     /* ��������! 
        � ������ ������������� �������� ABL �㬠��, ��
        ��� "" > dLastPosDate ������ ��� �⮣� � �����
        ����室��� �᫮��� bOpEntry.op-date<>?
        
        ��������!
          �������, �� �㤥� ࠧ㬭�� ��७��� ������騩
          ��᮪ ���� � ����� TOpEntry.
     */


FOR EACH bOpEntry WHERE (bOpEntry.acct-db=oAcct:acct)
                                                     AND bOpEntry.op-date>dLastPosDate 
                                                     AND bOpEntry.op-date<>? 
                                                     AND bOpEntry.op-date<=docdate
                                                     AND (bOpEntry.op-status>=cStatus OR bOpEntry.op=doc-id):

                IF oAcct:activity = "�" then 
                  do:
                     if bOpEntry.op <=doc-id THEN
                         do: 
                           IF oAcct:val=810 OR oAcct=? THEN rashod = rashod + bOpEntry.amt-rub.
                           ELSE DO:
                                rashod = rashod + bOpEntry.amt-cur.
                                rashodRub = rashodRub + bOpEntry.amt-rub.
                                end.
                         end.         
                     end.
    
                
                IF oAcct:activity = "�" then 
                  do:
                    if cacct-db = oAcct:acct then
                     do:
                       if bOpEntry.op <=doc-id THEN
                         do: 
                             IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                           ELSE DO:
                                   prihod = prihod + bOpEntry.amt-cur.
                                   prihodRub = prihodRub + bOpEntry.amt-rub.
                                end.
                         end.         
                     end. 
                      else
                     do:
                          IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                        ELSE DO:
                                prihod = prihod + bOpEntry.amt-cur.
                                prihodRub = prihodRub + bOpEntry.amt-rub.
                             END.        
                     end.
                  end.
      end.



     
FOR EACH bOpEntry WHERE (bOpEntry.acct-cr=oAcct:acct)
                                                     AND bOpEntry.op-date>dLastPosDate 
                                                     AND bOpEntry.op-date<>? 
                                                     AND bOpEntry.op-date<=docdate
                                                            AND (bOpEntry.op-status>=cStatus OR bOpEntry.op=doc-id):

                IF oAcct:activity = "�" then 
                  DO:
          
                    if cacct-cr = oAcct:acct then 
                     do:
                       if bOpEntry.op <= doc-id THEN
                         do: 
                              IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                           ELSE DO:
                                   prihod = prihod + bOpEntry.amt-cur.
                                   prihodRub = prihodRub + bOpEntry.amt-rub.
                                END.
                         end.         
                     end.
                     else
                     do:
                        IF oAcct:val=810 OR oAcct=? THEN prihod = prihod + bOpEntry.amt-rub.
                        ELSE DO:
                                prihod = prihod + bOpEntry.amt-cur.        
                                prihodRub = prihodRub + bOpEntry.amt-rub.
                             END.
                     end.
                end.
        
                IF oAcct:activity = "�" then 
                  do:
                     if bOpEntry.op <=doc-id THEN
                       do: 
                          IF oAcct:val=810 OR oAcct=? THEN rashod = rashod + bOpEntry.amt-rub.
                          ELSE DO:
                                  rashod = rashod + bOpEntry.amt-cur.
                                  rashodRub = rashodRub + bOpEntry.amt-rub.
                               END.
                       end.         
                  end.
                
      end.

      IF (oAcct:activity = "�" and cacct-db = oAcct:acct) OR (oAcct:activity = "�" AND cacct-cr = oAcct:acct) then 
          do: 
             dSum = dSum + prihod.  
             dAcctPosInRub = dSumRub + prihodRub.        
          end.
      else
          do: 
             dSum = dSum - rashod + prihod.
                dAcctPosInRub = dSumRub - rashodRub + prihodRub.        
          end.
      delete object oSysClass.
      delete object oAcct.        
      RETURN dSum.   
END METHOD.

/**
 * ��⮤ �����頥� ��ꥪ� ����� �����⥫�.
 * @return TBank
 **/
METHOD PUBLIC TBank getBankBen():
                                /******************************************************
                                 *                                                      *
                                 * ��⮤ �����頥� ��ꥪ� ����� �����⥫�           *
                                 *                                                      *
                                 ******************************************************/
     FIND FIRST op-bank WHERE op-bank.op = doc-id NO-LOCK NO-ERROR.
     IF AVAILABLE(op-bank) THEN
       DO:
         oBankBen = new TBank(op-bank.bank-code,THIS-OBJECT:DocDate).
         oBankBen:corr-acct = op-bank.corr-acct.
       END.
          ELSE
            DO:
                RETURN ?.
            END.
     RETURN oBankBen.

END METHOD.

/******************************************************
 *                                                    *
 * ��⮤ �஢���� ����������� �஢������ ���㬥��,  *
 * �� 㪠������� ����.                               *
 * �᫨ �஢��� �����, � � �訡�� ������塞        *
 * ���ଠ�� �� �訡��.			      *
 *                                                    *
 ******************************************************/
METHOD PUBLIC LOGICAL isCanTake(INPUT oAcct AS TAcctBal):

	DEF VAR oSysClass AS TSysClass NO-UNDO.
	DEF VAR hCalc     AS OBJECT    NO-UNDO.

	DEF VAR dBegPos   AS DECIMAL   NO-UNDO.
	DEF VAR dDiff     AS DECIMAL   NO-UNDO.

	DEF VAR dDate AS DATE    NO-UNDO.

	DEF VAR lRes AS LOGICAL INITIAL TRUE.

	DEF VAR cPirRsv2TrDwnSt AS CHARACTER NO-UNDO.
	DEF VAR key        AS CHARACTER 	     NO-UNDO.
	DEF VAR val        AS CHARACTER 	     NO-UNDO.
	DEF VAR classError AS CHARACTER INITIAL "�訡�����⪠" NO-UNDO.

/**************************************
����稫� ���� ��᫥����� ����⮣� ���
***************************************/

oSysClass = new TSysClass().

dDate=oSysClass:getLastOpenDate().


	cPirRsv2TrDwnSt = oSysClass:getSetting("PirChkOp","PirRSv2TrDwnSt","!*").


			  /**************************************************
			   * �᫨ �࠭����� ����७���, � � ���           *
			   * 㦥 ���뢠���� ��室 � ����� ������ �����  *
			   * ���⮬� �᪫�砥� ��� �� ����୮�� �����.  *
			   * ���ਬ��, �࠭����� ����ன �����.
			   *   �� �஢�ઠ �������� ᤥ���� ��室 � ��室
			   * �����६����, � ⮫쪮 ��⮬ ��� ���⢥न��.
			   **************************************************/

				  IF NOT CAN-DO(cPirRsv2TrDwnSt,op-kind) THEN DO:
		                  	dDiff = oAcct:calcOborot(op-transaction).
				  END.
			 ELSE dDiff = 0.

	          	oAcct:getPos2DateWError(dDate,"*",dBegPos,hCalc).

		        {foreach hCalc key val}

		           dBegPos = dBegPos + DECIMAL(val).


		
			   /***** 
			    *
			    * ��童�塞 ��砩, �����
			    * ��᪮�쪮 ���㬥�⮢ ᮧ����
			    * ����� �࠭���樥�.
			    * ����� ��室 ����� �� ���� � �����
			    * ������ �����.
			    *
			    ******/

				IF DATE(key) EQ DocDate THEN DO:
				     IF (dBegPos + dDiff) < 0 THEN DO:
					     addError("535","�� ���� " + oAcct:acct + ". \n �� ����: " + key + " �� c㬬�:" + STRING(dBegPos),classError).
					lRes = FALSE.
			        END.
				
			     dBegPos = MAXIMUM(dBegPos,0).

                        END.
			ELSE DO:
			    IF dBegPos < 0 THEN DO:
					     addError("535","�� ���� " + oAcct:acct + ". \n �� ����: " + key + " �� c㬬�:" + STRING(dBegPos),classError).
					lRes = FALSE.
			    END.
			END.

		  	{endforeach hCalc}

 		   DELETE OBJECT hCalc.
 
 DELETE OBJECT oSysClass.
 RETURN TRUE.

END METHOD.

/*********************************
 * @param direct ���ࠢ����� �஢������ ���-� = {up,down,?}.
 * @return logical
 * ��⮤ �஢���� �ਢ���� ��
 * ���㬥�� � ��᭮�� ᠫ줮 ��
 * ������ ���� ����.
 *********************************/
METHOD PUBLIC LOGICAL isCanTake(INPUT direct AS CHARACTER):
	 /**********************************************
          * �㭪�� �ந������ �஢��� ��     	       *
	  * ����稥 ��᭮�� ᠫ줮                    *
	  * �� ��⠬ ���㬥��.                       *
	  **********************************************/




/**** �������� ���. ��������� ������������ �������� ***/

DEF VAR oSysClass AS TSysClass NO-UNDO.
DEF VAR oDocument AS TDocument NO-UNDO.
DEF VAR oAcct-Db  AS TAcctBal  NO-UNDO.
DEF VAR oAcct-Cr  AS TAcctBal  NO-UNDO.


DEF VAR i     AS INTEGER NO-UNDO.

DEF VAR OpEntryCurrency AS CHARACTER NO-UNDO.
DEF VAR OpEntryAcctDb   AS CHARACTER NO-UNDO.
DEF VAR OpEntryAcctCr   AS CHARACTER NO-UNDO.


DEF VAR lResult AS LOGICAL INITIAL TRUE NO-UNDO.


oSysClass = new TSysClass().



 /***********************************
 * ��ᬠ�ਢ��� �� ��� ���㬥��
 ************************************/

  DO i = 1 TO OpEntryCount:

   /****************************************
     * ������騩 ��᮪ ����
     * ����室�� �� �஢�ન
     * ����஢����, ⠪ ��� � �⮬
     * ��砥 ���� �� ��⮢ �㤥� ?
    ***************************************/

  OpEntryCurrency = getOpEntry4Order(i):currency.
  OpEntryAcctDb   = getOpEntry4Order(i):acct-db.
  OpEntryAcctCr   = getOpEntry4Order(i):acct-cr.

   IF OpEntryAcctDb <> ? THEN DO:
	    oAcct-Db = new TAcctBal(OpEntryAcctDb).

	/****************************************
	 * �᫨ �� �஢���� ��室�,           *
	 * � ࠧ�襭� ��室 �஢�����         *
	 * ��ᬮ��� �� ��᭮� ᠫ줮,          *
	 * � �஢��� �ய�᪠��.              *
	 *					*
	 *        !!! �������� !!!              *
         * ������ �����, �� �᫨ ���-�       *
	 * �⪠�뢠����, � �஢��� �믮�����  *
	 * ����室���!				*
	 ****************************************/

	IF NOT (isUpPos(getOpEntry4Order(i),oAcct-db) AND LOGICAL(oSysClass:getSetting("PirChkOp","PirRedSaldoV2Up","FALSE")) AND direct="up") THEN DO:

               /*****************
	        * �᫨ �� ����
	        * ��� ࠧ�襭�� �� ��᭮�
	        * ᠫ줮
	        *****************/
	      IF NOT oAcct-Db:isRSPMD THEN DO:

	         /****************
	          * �᫨ ��� �ਢ易�
	          * � ��������, � ����祭
                  * �� ࠧ���� �� �� �������⠬,
                  * � �஢��� �ய�᪠��.
	          ****************/

		  IF NOT (oAcct-Db:isLnkOverLoan() AND LOGICAL(oSysClass:getSetting("PirChkOp","isOvrRSPermit","NO"))) THEN DO:
			lResult = isCanTake(oAcct-Db).
		  END. /* IF isLnkOver */
              END.  /* IF NOT oAcct-Db:isRSPMD THEN */
           END. /* IF NOT isUpPos ... */

       DELETE OBJECT oAcct-Db.
      END.   /* IF opEntryAcctDb <> ?  */

   IF OpEntryAcctCr <> ? THEN
	DO:
	    oAcct-Cr = new TAcctBal(OpEntryAcctCr).

    	   IF NOT (isUpPos(getOpEntry4Order(i),oAcct-cr) AND LOGICAL(oSysClass:getSetting("PirChkOp","PirRedSaldoV2Up","FALSE")) AND direct="up") THEN DO:

	     IF  NOT oAcct-Cr:isRSPMD THEN
	      DO:
	         /****************
	          * �᫨ ��� �ਢ易�
	          * � ��������, � ����祭
                  * �� ࠧ���� �� �� �������⠬,
                  * � �஢��� �ய�᪠��.
	          ****************/
		  IF NOT (oAcct-Cr:isLnkOverLoan() AND LOGICAL(oSysClass:getSetting("PirChkOp","isOvrRSPermit","NO"))) THEN DO:
			lResult = isCanTake(oAcct-Cr).
		  END. /* IF isLnkOver */
	       END.     /* IF oAcct-Cr:isRSPMD */
	     END.  /* IF NOT isUpPos ... */

	   DELETE OBJECT oAcct-Cr.
	END. /* IF opEntryAcctCr */
END.          /* ����� �� �஢����� */
/************ ����� ��� ����� ������������ ******************/
 RETURN lResult.
END METHOD.



  /********************************
   *
   * @result character
   * �����頥� ����� ������� � ���஬�
   * �ਢ易� ���.
   *
   ********************************/

METHOD PUBLIC CHARACTER getLnkLoanNum():
	 /*****************
          * �।��������, �� �஢����,
	  * �ਢ易�� ⮫쪮 � ������ ��������.
	  *****************/
   DEF VAR docnum AS CHARACTER NO-UNDO.

	 IF {assigned kau-db} THEN DO:
	    docnum = ENTRY(2,kau-db).			
	 END.

	 IF {assigned kau-cr} THEN DO:
	    docnum = ENTRY(2,kau-cr).			
	 END.

  RETURN docnum.

END METHOD.


/*******************************
 *
 * @param opEntry TOpEntry �஢����
 * @param oAcct TAcct 20� ����� ����� ���
 * @result LOGICAL  �����頥� TRUE, �᫨ ���-�
 * 㢥��稢��� ���⮪ �� ���� oAcct, ���� FALSE.
 * ��� ��� ��� ⨯� �����頥� ?.
 *
 ********************************/

METHOD PROTECTED LOGICAL isUpPos(INPUT opentry AS TOpEntry,INPUT oAcct AS TAcct):
     CASE oAcct:activity:
           WHEN "�" THEN DO:
		IF opentry:acct-db EQ oAcct:acct THEN RETURN TRUE.
		ELSE RETURN FALSE.
	   END.   
	   WHEN "�" THEN DO:
		IF opentry:acct-cr EQ oAcct:acct THEN RETURN TRUE.
		ELSE RETURN FALSE.
	   END.	   
     END CASE.
   RETURN ?.
END METHOD.

/**
 *
 * ���㬥�� �ਭ������� ����������ᨬ��� ���� � ��砥
 * �᫨ ��� �� �� ��� ��� �� �� ��� �����⥫� 
 * �������� �।�� (��� �� name-ben) ����� ����������ᨬ묨 
 * �� ���� ᮢ��襭�� ����樨.
 * 
 **/
METHOD PUBLIC LOG isBelongToDepended():

    DEF VAR oClient     AS TClient            NO-UNDO.
    DEF VAR lRes        AS LOG     INIT FALSE NO-UNDO.



  FOR EACH bOpEntry WHERE bOpEntry.op EQ INT64(THIS-OBJECT:surrogate) NO-LOCK:
              oClient = NEW TClient(bOpEntry.acct-db).
                lRes  = lRes OR oClient:isDepended(THIS-OBJECT:DocDate).
              DELETE OBJECT oClient.
                   
              oClient = NEW TClient(bOpEntry.acct-cr).
                lRes  = lRes OR oClient:isDepended(THIS-OBJECT:DocDate).
              DELETE OBJECT oClient.

    IF lRes THEN LEAVE.

  END.
  
 RETURN lRes.

END METHOD.

/**
 * ������� �� ���㬥��
 * ������?
 **/
METHOD PUBLIC LOG isValute():
 RETURN IF currency <> "" THEN TRUE ELSE FALSE.
END METHOD.

/***
 *
 * ������� �� ���㬥�� ������ᨮ���.
 *
 ***/
METHOD PUBLIC LOG isExchange():
   DEF VAR i AS INT NO-UNDO.

   DO i = 1 TO THIS-OBJECT:OpEntryCount:
       IF THIS-OBJECT:getOpEntry4Order(i):isHalf() OR NOT THIS-OBJECT:getOpEntry4Order(i):hasEqualVal() THEN RETURN TRUE.
   END.

 RETURN FALSE.

END METHOD.

/**
 * ��⮤ �����頥� ������
 * ���஬� �ਭ������� ���㬥��.
 * @return TClient
 **/
METHOD PUBLIC TClient getClient():
         
END METHOD.

/**
 * ��⮤ �����頥� ���ண���
 * �易���� � ���㬥�⮢
 * ���㬥�⮢.
 * @return TAArray
 **/

METHOD PUBLIC TAArray getLnkDocs():

DEF VAR oAArray AS TAArray NO-UNDO.

DEF BUFFER op    FOR op.
DEF BUFFER links FOR links.
DEF BUFFER xlink FOR xlink.

oAArray = NEW TAArray().

/**
 * ��易��� �� 1��� ⨯�.
 **/

FOR EACH op WHERE op.op-transaction EQ THIS-OBJECT:op-transaction
			AND op.op NE THIS-OBJECT:op
			AND op.op-status GT "�" NO-LOCK:
   oAArray:push(op.op).
END. /* FOR EACH */

/**
 * ��易��� �� 2��� ⨯�
 **/
FOR EACH links WHERE links.source-id EQ STRING(THIS-OBJECT:op)
                  OR links.target-id EQ STRING(THIS-OBJECT:op) NO-LOCK,
  FIRST xlink WHERE links.link-id EQ xlink.link-id AND xlink.link-code EQ "PirLnkCom" NO-LOCK:
   oAArray:push((IF links.source-id EQ STRING(THIS-OBJECT:op) THEN links.target-id ELSE links.source-id)).
END.

 RETURN oAArray.
END METHOD.


/***
 * ������-���㬥�� ?
 ***/
METHOD PUBLIC LOG isSTORNO():
 RETURN IF details MATCHES "*������*" THEN TRUE ELSE FALSE.
END METHOD.


/***
 * ���� �� � ���㬥�� ������᪨� ���
 ***/
METHOD PUBLIC LOG isDocumClientAcct():
   DEF VAR i       AS INT     NO-UNDO.
   DEF VAR dbAcct   AS TAcct   NO-UNDO.
   DEF VAR crAcct   AS TAcct   NO-UNDO.

   DO i = 1 TO THIS-OBJECT:OpEntryCount:
       dbAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-db).
       crAcct = NEW TAcct(THIS-OBJECT:getOpEntry4Order(i):acct-cr).

       IF  dbAcct:isClient()  OR  crAcct:isClient()  
         THEN DO:
            DELETE OBJECT dbAcct.
            DELETE OBJECT crAcct.
            RETURN TRUE.
         END.
   END.

 DELETE OBJECT dbAcct.
 DELETE OBJECT crAcct.
 RETURN FALSE.

END METHOD.




DESTRUCTOR PUBLIC TDocument():
    /************************************
     * � ⥡� ��ࠤ��, � ⥡� � ���!   *
     ************************************/
     
     FOR EACH DocOpEntry NO-LOCK:
      DELETE OBJECT DocOpEntry.opentry.     
     END.
     EMPTY TEMP-TABLE DocOpEntry.
    DELETE OBJECT oBankBen NO-ERROR.
END DESTRUCTOR.
END CLASS.