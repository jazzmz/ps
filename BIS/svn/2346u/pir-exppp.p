{globals.i}

{intrface.get xclass}   /* �㭪樨 ࠡ��� � ����奬�� */
{intrface.get count}

{tmprecid.def}

/*****************************************************
 * ����஫��� ��࠭���� ���⥦���                   *
 * ���㬥�⮢ � 䠩�� �ଠ� SVG.                   *
 *  ������ ࠡ���:                                 *
 *   1. �롨ࠥ� ���㬥��� �������騥                *
 * ��࠭���� � ��娢;                               *
 *   2. �� �ᥩ tmprecid;                            *
 *   3. ������� ��ꥪ� ⨯� TPaymentOrder;           *
 *   4. ��ନ�㥬 ���㬥��� �� 蠡���� pp.svg;       *
 *   5. �뢮��� �⮣��� १���� � 䠩�            *
 *   �� ��� cPath � ������ ID ���㬥��.            *
 *****************************************************
 * ��� ᮧ�����: .......                            *
 * ����: ��᫮� �. �.                               *
 * ���: #381                                      *
 *****************************************************/

/**********
 * ������ *
 **********/
DEF VAR oSysClass     AS TSysClass     NO-UNDO.
DEF VAR oPaymentOrder AS TPaymentOrder NO-UNDO.
DEF VAR oCharacter    AS TCharacter    NO-UNDO.
DEF VAR oTpl1         AS TTpl          NO-UNDO.
DEF VAR oDTInput      AS TDTInput      NO-UNDO.
DEF VAR oSysClass1    AS TSysClass     NO-UNDO.


/**************************
 * ����७��� ��६����  *
 * ����஫���            *
 **************************/
DEF VAR i AS INTEGER                 NO-UNDO.
DEF VAR amtstr AS CHARACTER EXTENT 2 NO-UNDO.
DEF VAR Rub AS CHARACTER INITIAL ""  NO-UNDO.
DEF VAR archDate AS DATE             NO-UNDO.

DEF VAR oEra     AS TEra    NO-UNDO.
DEF VAR oConfig  AS TAArray NO-UNDO.
DEF VAR currDate AS DATE    NO-UNDO.

DEF VAR iRes AS INT64 NO-UNDO.


oConfig = NEW TAArray().
oEra    = NEW TEra(TRUE).

currDate = gend-date.

/************************
 * ��६���� ����ன�� *
 ************************/
DEF VAR cEncoding AS CHARACTER INITIAL "utf-8" NO-UNDO.

DEF BUFFER bop FOR op.


oSysClass = NEW TSysClass().

/******************************
 * �����⠢������ ��⠫��     *
 * ��� ��࠭����.            *
 ******************************/

IF gend-date <> ? THEN archDate = gend-date.
		  ELSE
		     DO:
			oDTInput = new TDTInput(3).
			  oDTInput:X = 250.
			  oDTInput:Y = 50.
			  oDTInput:head = "��� ��娢�".
			  oDTInput:show().
			  archDate = oDTInput:beg-date.
			DELETE OBJECT oDTInput.
		     END.

/**********
 * �஢��塞 ���४⭮��� �ᯮ���⥫�� *
 **********/

{pir-chk-sin-cnt.i &cr="2"}

oConfig:setH("taxon","fin po bk rez").
oConfig:setH("opdate",oSysClass:DATETIME2STR(currDate,"%Y-%m-%d")).
oConfig:setH("expn",iCurrOut).
oConfig:setH("author",curr-user-id).
oConfig:setH("inspector",curr-user-inspector).
oConfig:setH("fext","svg").




/********************************
 *
 * � �裡 � ���室�� �� ������
 * ��⥬� �࠭���� ��� 
 * 䠩�� ᪫��뢠�� "��� ����".
 *
 *********************************
 * ����: ��᫮� �. �.
 * ��� ᮧ�����: 09.11.11
 *********************************/
/*cPath = cRootPath + oSysClass:DATETIME2STR(archDate,"%Y-%m-%d") + "/md/" + curr-user-inspector.*/
cPath = "./_spool1.tmp".

/****** ����� ������� *********/

/********** ������ ��� ��������� ������ ****************/
{tpl.create}

DEF VAR oTable AS TTable            NO-UNDO.

DEF VAR iCount AS INTEGER INITIAL 0 NO-UNDO.
DEF VAR dSum   AS DECIMAL INITIAL 0 NO-UNDO.

/***********  ����� ������ ��� ������ ******************/

/*** ��������� ������������� �������� ***/

DEF VAR vLnCountInt AS INTEGER NO-UNDO. /* ���稪 ������஢ */
DEF VAR vLnTotalInt AS INTEGER NO-UNDO. /* ��饥 ������⢮ ������஢ */

  {init-bar.i "��ࠡ�⪠ ���㬥�⮢"}

   FOR EACH tmprecid NO-LOCK:
		ACCUMULATE tmprecid.id (COUNT).
   END.

vLnTotalInt = (ACCUM COUNT tmprecid.id).

/*** ����� ������������� �������� ***/

                                            
FOR EACH tmprecid,
  FIRST bop WHERE RECID(bop) EQ tmprecid.id NO-LOCK:
 
    

    oTpl1 = new TTpl("pp.svg").

    oTpl1:encoding = cEncoding.
    oTpl1:splitter = "|".

    oPaymentOrder = new TPaymentOrder(BUFFER bOp:HANDLE).
    
    IF CAN-DO("40807*,40820*,42601*",oPaymentOrder:acct-db) OR CAN-DO("40807*,40820*,42601*",oPaymentOrder:acct-cr) THEN DO:
        oConfig:setH("taxon","fin po bk nerez").
    END. ELSE DO:
        oConfig:setH("taxon","fin po bk rez").
    END.

    /***
     * ����� ��⠭�������� ����� ���㬥��.
     * � ����� ���㬥��.
     ***/    
    oConfig:setH("num",oPaymentOrder:doc-num).
    

    iCount = iCount + 1.
    dSum = dSum + oPaymentOrder:sum.

    oTpl1:addAnchorValue("num",oPaymentOrder:doc-num).
    oTpl1:addAnchorValue("op-ins",oPaymentOrder:DocDate).
    oTpl1:addAnchorValue("op-date",oPaymentOrder:ins-date).
    oTpl1:addAnchorValue("op-type",oPaymentOrder:type).

    oTpl1:addAnchorValue("order-pay",oPaymentOrder:order-pay).
    oTpl1:addAnchorValue("type-op",oPaymentOrder:cb-type).
    oTpl1:addAnchorValue("doc-date",oPaymentOrder:doc-date).
    oTpl1:addAnchorValue("statuspok",oPaymentOrder:statuspok).
    
    /* ������塞 ���⥫�騪� */
 RUN x-amtstr.p(oPaymentOrder:sum,'',TRUE,TRUE, OUTPUT amtstr[1], OUTPUT amtstr[2]).
 IF TRUNC(oPaymentOrder:sum, 0) = oPaymentOrder:sum THEN
    ASSIGN
      Rub       = STRING(STRING(oPaymentOrder:sum * 100, "-zzzzzzzzzz999"), "x(12)=")
      AmtStr[2] = ''
    .
  ELSE
    ASSIGN
      Rub       = STRING(STRING(oPaymentOrder:sum * 100, "-zzzzzzzzzz999"), "x(12)-x(2)")
      AmtStr[1] = AmtStr[1] + ' ' + AmtStr[2]
    .
  SUBSTR(AmtStr[1], 1, 1) = CAPS(SUBSTR(AmtStr[1], 1, 1)).
  oTpl1:addAnchorValue("sum",Rub).

 oCharacter = new TCharacter(amtstr[1]).
    oCharacter:width = 65.
    oCharacter:align="left".
     DO i = 1 TO 2:
      oTpl1:addAnchorValue("sum-" + STRING(i),oCharacter:getValue(i)).
     END.
     DELETE OBJECT oCharacter.     

    oCharacter = new TCharacter(oPaymentOrder:name-send).
    oCharacter:width = 45.
    oCharacter:align="left".
     DO i = 1 TO 3:
      oTpl1:addAnchorValue("name-short-send" + STRING(i),oCharacter:getValue(i)).
     END.
     DELETE OBJECT oCharacter.     
     
    oTpl1:addAnchorValue("acct-send",oPaymentOrder:acct-send).
    oTpl1:addAnchorValue("inn-send",oPaymentOrder:inn-send).
    oTpl1:addAnchorValue("kpp-send",oPaymentOrder:kpp-send).
    
    /* ������塞 ���� ���⥫�騪� */
    oCharacter = new TCharacter(oPaymentOrder:bank-name-send).
    oCharacter:width = 45.
    oCharacter:align = "left".
    DO i=1 TO 3 :
      oTpl1:addAnchorValue("name-bank-send" + STRING(i),oCharacter:getValue(i)).
    END.
      DELETE OBJECT oCharacter.
      
    oTpl1:addAnchorValue("bic-send",oPaymentOrder:bank-bic-send).
    oTpl1:addAnchorValue("acct-bank-send",oPaymentOrder:bank-acct-send).
   
    /* ������塞 �����⥫� */
    oCharacter = new TCharacter(oPaymentOrder:name-rec).
    oCharacter:width = 45.
    oCharacter:align = "left".
     DO i=1 TO 3 :     
       oTpl1:addAnchorValue("name-short-rec" + STRING(i),oCharacter:getValue(i))
       .
     END.
     DELETE OBJECT oCharacter.
     
    oTpl1:addAnchorValue("acct-rec",oPaymentOrder:acct-rec).
    oTpl1:addAnchorValue("inn-rec",oPaymentOrder:inn-rec).
    oTpl1:addAnchorValue("kpp-rec",oPaymentOrder:kpp-rec).

    /* ������塞 ���� �����⥫� */
    oCharacter = new TCharacter(oPaymentOrder:bank-name-rec).
    oCharacter:width = 45.
    oCharacter:align = "left".
     DO i=1 TO 3 :
        oTpl1:addAnchorValue("name-bank-rec" + STRING(i),oCharacter:getValue(i))
   .
    END.
     DELETE OBJECT oCharacter.

    oTpl1:addAnchorValue("bic-rec",oPaymentOrder:bank-bic-rec).
    oTpl1:addAnchorValue("acct-bank-rec",oPaymentOrder:bank-acct-rec).
    
    oCharacter = new TCharacter(oPaymentOrder:details).
    oCharacter:width = 90.
    oCharacter:align = "left".
     DO i=1 TO 3 :
      oTpl1:addAnchorValue("details" + STRING(i),oCharacter:getValue(i)).
     END.
     DELETE OBJECT oCharacter.
     
     /* �������� ४������ */
     oTpl1:addAnchorValue("kbk",oPaymentOrder:kbk).
     oTpl1:addAnchorValue("okato",oPaymentOrder:okato).
     oTpl1:addAnchorValue("datepok",oPaymentOrder:datepok).
     oTpl1:addAnchorValue("nppok",oPaymentOrder:nppok).
     oTpl1:addAnchorValue("ndpok",oPaymentOrder:ndpok).
     oTpl1:addAnchorValue("oppok",oPaymentOrder:oppok).
     oTpl1:addAnchorValue("tppok",oPaymentOrder:tppok).

 
    /******************************************
     * �஢��塞 ����������� ����� � ��⠫�� .
     ******************************************
     * ��᫥ ���室� �� ����� ��⥬� �࠭����
     * ��襬 "��� ����" ���⮬� ������ �஢�ન
     * �� ����������� ����� �� �㦭�.
     *******************************************/

	    OUTPUT TO VALUE(cPath) CONVERT TARGET "utf-8".
	      oTpl1:show().
	    OUTPUT CLOSE.    

        
	   /*{send2arch.i &nomess=1 &arch2=1 &notmprecid=1 &f2a="\"./_spool1.tmp\""}*/
	   
	  /*****
	   * �᫨ ���㬥��,
	   * ��ࠢ��� � ��娢,
	   * � ����砥� ��� 
	   * ��� ��ࠢ����.
	   *****/
	   iRes = oEra:addCustomDoc(oConfig,"_spool1.tmp"). 

	  IF  iRes > 0 THEN DO:
	      UpdateSignsEx('opb',STRING(oPaymentOrder:surrogate),"PirA2346U",STRING(iCurrOut)).
              UpdateSignsEx('op-entry',STRING(oPaymentOrder:surrogate) + "," + STRING(oPaymentOrder:getOpEntry4Order(1):numInDoc),"PirDEVLink",STRING(iRes)).
	  END.   

  
      DELETE OBJECT oPaymentOrder.
  	  DELETE OBJECT oTpl1.

         {move-bar.i
            vLnCountInt
            vLnTotalInt
          }

           vLnCountInt = vLnCountInt + 1.

END. /* FOR EACH tmprecid */

/*****************************
 * ����� �ନ஢���� ���� *
 ******************************/

/**********************
 *   ��ନ�㥬 ����  *
 **********************/


oTable = new TTable(2).

 oTable:addRow().
  oTable:addCell(iCount).
  oTable:addCell(dSum).
oTpl:addAnchorValue("TABLE1",oTable).

{setdest.i}
 {tpl.show}

DELETE OBJECT oTable.
{tpl.delete}


DELETE OBJECT oSysClass.
DELETE OBJECT oConfig.
DELETE OBJECT oEra.
{intrface.del}
RETURN.
