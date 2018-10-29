/*****************************************
 *                                       *
 * ����.                                *
 * �஢���� ����稥 ����襭��           *
 * ०��� ���⪮� �� ��㯯� ��⮢      *
 *                                       *
 *****************************************
 *                                       *
 * ����: ��᫮� �. �. Maslov D. A.      *
 * ��� ᮧ�����: 01.03.12               *
 * ���: #838                          *
 *                                       *
 *****************************************
 *                                       *
 * ����䨪��� �� ��� #2656           *
 * ����: ��᪮� �.                     *
 *                                       *
 *  04.04.2013                           *
 *                                       *
 *****************************************/ 
{globals.i}
{tmprecid.def}

/*DEF INPUT PARAM cParam AS CHARACTER NO-UNDO.*/

DEF VAR oArray            AS TAArray   NO-UNDO.
DEF VAR oAMinMode             AS TAArray   NO-UNDO.
DEF VAR oAMinCalc         AS TAArray   NO-UNDO.

DEF VAR oAcct		  AS TAcct     NO-UNDO.

DEF VAR oTable		  AS TTable    NO-UNDO.
DEF VAR oSysClass         AS TSysClass NO-UNDO.

DEF VAR key1	          AS CHARACTER NO-UNDO.
DEF VAR value1	          AS CHARACTER NO-UNDO.

DEF VAR mQuery            AS HANDLE    NO-UNDO.
DEF VAR mCnt1             AS INT64     NO-UNDO.
DEF VAR mBuffer           AS HANDLE    NO-UNDO.
DEF VAR fltName 	  AS CHARACTER NO-UNDO.

DEF VAR iDate		  AS DATE            NO-UNDO.
DEF VAR iMiddle		  AS DECIMAL INIT 0  NO-UNDO.
DEF VAR iColsCount        AS INT64   INIT 0  NO-UNDO.
DEF VAR i                 AS INT     INIT 1  NO-UNDO.
DEF VAR dAgr              AS DECIMAL INIT 0  NO-UNDO.
DEF VAR dSum              AS DECIMAL INIT 0  NO-UNDO.
DEF VAR dLimit            AS DECIMAL FORMAT "->>>,>>>,>>>,>>>,>>9.99" LABEL "������ �᫮" INIT 0  NO-UNDO.

DEF VAR startDate         AS DATE            NO-UNDO.


oSysClass = new TSysClass().

/*/**************
 * ���� �� �祢����, ��
 * ����ன�� 䨫��� ������
 * ���� � ᫥���饬 ����:
 * ��� ������������,acct.p,���������������,b
 ***************/
fltName = ENTRY(1,cParam,"|").*/

/*dLimit  = DECIMAL(ENTRY(2,cParam,"|")). */

PAUSE 0.

UPDATE SKIP(1) dLimit SKIP(1)
  WITH FRAME fMain OVERLAY ROW 10 CENTERED SIDE-LABELS TITLE "[ ����� ]".

HIDE FRAME fMain.



{getdates.i}

DEF VAR oTpl AS TTpl.
oTpl = new TTpl("pir-chk838.tpl").



oArray     = new TAArray().
oAMinMode      = new TAArray().
oAMinCalc  = new TAArray().

/*
/*********
 * ��� �1.
 * ��室�� ��� �������騥
 * ��ࠡ�⪥.
 *********/
SUBSCRIBE "AfterNavigate" ANYWHERE RUN-PROCEDURE "AfterNavigate".

RUN browseld.p ("acct",
		"UserConf",
                fltName,
		"",
		4).

UNSUBSCRIBE "AfterNavigate".

PROCEDURE AfterNavigate:
   DEF INPUT PARAM iNavigate AS HANDLE  NO-UNDO.
   DEF OUTPUT PARAM oCont    AS LOGICAL NO-UNDO.


  RUN Open-Query IN iNavigate.

  mQuery = DYNAMIC-FUNCTION("GetHandleQuery" IN iNavigate).

IF    NOT VALID-HANDLE(mQuery)
      OR mQuery:TYPE NE "QUERY"
      OR NOT mQuery:IS-OPEN THEN
	MESSAGE "������ ������ �����!!!" VIEW-AS ALERT-BOX.

  RUN GetFirstRecord IN iNavigate (mQuery).

    DO mCnt1 = 1 TO mQuery:NUM-BUFFERS:
      mBuffer = mQuery:GET-BUFFER-HANDLE(mCnt1).
      IF mBuffer:TABLE EQ "acct" THEN LEAVE.
    END.

  DO WHILE NOT mQuery:QUERY-OFF-END:

     IF mBuffer:AVAIL THEN DO:   
       oArray:setH(mBuffer::acct,mBuffer::details).	  
     END.

    RUN GetNextRecord IN iNavigate (mQuery).
  END.

END PROCEDURE.
*/


for each tmprecid, first acct where RECID(acct) = tmprecid.id NO-LOCK:
      oArray:setH(acct.acct,acct.details).	  
END.


/*******
 * ��� �2.
 * ��ࠡ��뢠�� ���.
 *******/

 /***
  * ��ନ��� 蠯��
  ***/
  iColsCount = oArray:length + 3.
  oTable = new TTable(iColsCount).
  oTable:decFormat=">>>,>>>,>>>,>>9.99".

  oTable:addRow().
  oTable:addCell("���").
  {foreach oArray key1 value1}
    oTable:addCell(SUBSTRING(key1,1,9) + "*" + SUBSTRING(key1,17,4)).

     oAcct = new TAcct(key1).
       oAMinMode:setH(key1,oAcct:getLastPos2Date(beg-date)).
       oAMinCalc:setH(key1,oAcct:getLastPos2Date(beg-date)).
     DELETE OBJECT oAcct.

  {endforeach oArray}
    oTable:addCell("�⮣�").
    oTable:addCell("����襭��").
 /**
  * �� ��� #1662
  * ���� �⮡ࠧ��� ���⮪
  * �� ��� �� ��⠬. ���⮪ �� ���,
  * ���� �� �� ���� ��� ���⮪ �� ���� �।��饣� ���.
  **/

 startDate = beg-date - 1.

 DO iDate = startDate TO end-date:
   oTable:addRow().
       IF iDate = startDate THEN DO:
         oTable:addCell("�室�騩 :" + STRING(iDate + 1)).
       END. ELSE DO:
         IF iDate = startDate + 1 THEN DO:
              oTable:addCell("��室�騩:" + STRING(iDate)).
         END. ELSE DO:
              oTable:addCell(iDate).
         END.
       END.
   {foreach oArray key1 value1}
       oAcct = new TAcct(key1).
        dSum = oAcct:getLastPos2Date(iDate,CHR(251)).

        /**
         * �᪫�砥� �� ���� �������쭮�� ���⪠,
         * �室�騩 ���⮪ �� ��砫� ��ਮ��.
         **/
        IF iDate > startDate THEN DO:
          IF DECIMAL(oAMinMode:get(key1)) > dSum THEN oAMinMode:setH(key1,STRING(dSum)).
        END.

          /**
           * �� ��� #1864
           * � ���� �� ⠪� ���� �⮡� � 
           * �室�騩 ���⮪ �� ��砫� ��ਮ��
           * ��⠫��.
           **************************************
           * ��� �� ��� #1951 ���⮪ �� �����
           * ��ਮ�� �� ������ ���뢠����. ����饬
           * ���� �������஢��� ������� ᭠砫�.
           ***************************************/
          IF iDate < end-date THEN DO:
           IF DECIMAL(oAMinCalc:get(key1)) > dSum THEN oAMinCalc:setH(key1,STRING(dSum)).
          END.

        dAgr = dAgr + dSum.
        oTable:addCell(dSum).
       DELETE OBJECT oAcct.
   {endforeach oArray}
        oTable:addCell(dAgr).
        oTable:addCell( (IF dAgr > dLimit THEN "" ELSE CHR(251)) ).
     dAgr = 0.
 END.

/**
 * �뢮��� �⮣ ��� �室�饣�
 **/
oTable:addRow().
oTable:addCell("�������쭮� ०��:").
{foreach oAMinMode key1 value1}
  oTable:addCell(DECIMAL(value1)).
{endforeach oAMinMode}
oTable:addCell("").
oTable:addCell("").

/**
 * �뢮��� �⮣ � �室�騬
 **/
oTable:addRow().
oTable:addCell("�������쭮� ����:").
{foreach oAMinCalc key1 value1}
  oTable:addCell(DECIMAL(value1)).
{endforeach oAMinCalc}
oTable:addCell("").
oTable:addCell("").
oTable:setAlign(1,1,"center").

oTpl:addAnchorValue("ORG",oArray:getFirst()).
oTpl:addAnchorValue("beg-date",beg-date).
oTpl:addAnchorValue("end-date",end-date).
oTpl:addAnchorValue("TABLE",oTable).
{tpl.show}

DELETE OBJECT oTable.
DELETE OBJECT oArray.
DELETE OBJECT oAMinMode.
DELETE OBJECT oAMinCalc.
DELETE OBJECT oSysClass.
