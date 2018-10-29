/**********************************
 * ��८業�� 業��� �㬠�.
 * ���: #2494
 * ���: #2808 - � ����� �ࠤ���� ��᫮�� �. ᤥ��� ��� ���� ������ �㭪権, �⮡� ��� �뫮 ���� � ����⭮ :)
 **********************************/
{g-defs.i}
{intrface.get instrum}  /* ������⥪� ��� ࠡ��� � 䨭. �����㬥�⠬�. */
{intrface.get acct}     /* ������⥪� ��� ࠡ��� � 䨭. �����㬥�⠬�. */

DEFINE INPUT  PARAMETER in-op-date  AS DATE        NO-UNDO.
DEFINE INPUT  PARAMETER oprid       AS RECID       NO-UNDO.

{setdest.i}

{pir-aacctcb.i}

/**
 * �����頥� �����ᮢ�� �⮨����� �㬠�� (⮫쪮 �� ����)
 **/
FUNCTION getPrice RETURNS DECIMAL(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
 DEF VAR cMask      AS CHAR NO-UNDO.
 DEF VAR dBody      AS DEC  NO-UNDO.
 DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.
 DEF BUFFER acct FOR acct.

  RUN acct-pos IN h_base (cAcct,
                          "",
                          currDate,
                          currDate,
                          currStatus).

 dBody = ABS(sh-bal).
 RETURN dBody .
END FUNCTION.

FUNCTION getPPAcct CHAR(INPUT cAcct AS CHAR, INPUT cTypeCB AS CHAR):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = IF cTypeCB = "action" THEN getAcct(cAcct,"��") ELSE getAcct(cAcct,"�����") .

  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK.

  RETURN acct.acct.
END FUNCTION.

FUNCTION getPP RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE, INPUT cTypeCB AS CHAR):
  DEF VAR PP    AS DEC  NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.

  RUN acct-pos IN h_base (getPPAcct(cAcct, cTypeCB),
                          "",
                          currDate,
                          currDate,
                          currStatus).
  PP = ABS(sh-bal).
 RETURN PP.
END FUNCTION.

FUNCTION getPOAcct CHAR(INPUT cAcct AS CHAR, INPUT cTypeCB AS CHAR):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = IF cTypeCB = "action" THEN getAcct(cAcct,"��") ELSE getAcct(cAcct,"�����") .

  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK.

  RETURN acct.acct.
END FUNCTION.

FUNCTION getPO RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE, INPUT cTypeCB AS CHAR):
  DEF VAR PO    AS DEC  NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.

  RUN acct-pos IN h_base (getPOAcct(cAcct, cTypeCB),
                          "",
                          currDate,
                          currDate,
                          currStatus).

  PO = ABS(sh-bal).
 RETURN PO.
END FUNCTION.



FUNCTION getZ RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF VAR dComm AS DEC  NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = getAcct(cAcct,"������").

  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK NO-ERROR.
  IF NOT AVAIL(acct) THEN
	MESSAGE "�� ������ ��� ������" VIEW-AS ALERT-BOX.

  RUN acct-pos IN h_base (acct.acct,
                          "",
                          currDate,
                          currDate,
                          currStatus).

  dComm = ABS(sh-bal).                          
 RETURN dComm.
END FUNCTION.


FUNCTION getPKDn RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF VAR dComm AS DEC  INIT 0 NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = getAcct(cAcct,"������").
/*message "������ " cMask view-as alert-box.*/
  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK NO-ERROR.
  IF AVAIL(acct) THEN
  DO:
    RUN acct-pos IN h_base (acct.acct,
                          "",
                          currDate,
                          currDate,
                          currStatus).

    dComm = ABS(sh-bal).                          
  END.
/*message "१ " acct.acct view-as alert-box.*/
 RETURN dComm.
END FUNCTION.


FUNCTION getPKDu RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF VAR dComm AS DEC  INIT 0 NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = getAcct(cAcct,"������").

  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK NO-ERROR.
  IF AVAIL(acct) THEN
  DO:
    RUN acct-pos IN h_base (acct.acct,
                          "",
                          currDate,
                          currDate,
                          currStatus).

    dComm = ABS(sh-bal).                          
  END.
 RETURN dComm.
END FUNCTION.

FUNCTION getPrem RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF VAR dComm AS DEC INIT 0 NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = getAcct(cAcct,"�६��").
/*message "�६ " cMask view-as alert-box.*/
  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK NO-ERROR.
  IF AVAIL(acct) THEN
  DO:
    RUN acct-pos IN h_base (acct.acct,
                          "",
                          currDate,
                          currDate,
                          currStatus).

    dComm = ABS(sh-bal).                          
  END.
 RETURN dComm.
END FUNCTION.

FUNCTION getDisk RETURNS DEC(INPUT cAcct AS CHAR,INPUT currDate AS DATE):
  DEF VAR cMask AS CHAR NO-UNDO.
  DEF VAR dComm AS DEC INIT 0 NO-UNDO.
  DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.
  DEF BUFFER acct FOR acct.

  cMask = getAcct(cAcct,"��᪮��").
  FIND FIRST acct WHERE acct.currency = "" AND acct MATCHES cMask NO-LOCK NO-ERROR.
  IF AVAIL(acct) THEN
  DO:
    RUN acct-pos IN h_base (acct.acct,
                          "",
                          currDate,
                          currDate,
                          currStatus).

    dComm = ABS(sh-bal).                          
  END.
 RETURN dComm.
END FUNCTION.




DEF VAR mTypeCB AS CHAR NO-UNDO.  /* ��।��塞 ⨯ ��: action -������ / bond -������� */

DEF VAR mTss   AS DEC NO-UNDO.
DEF VAR mQty   AS DEC NO-UNDO.
DEF VAR bPrice AS DEC NO-UNDO.
DEF VAR dDiff  AS DEC NO-UNDO.

DEF VAR price  AS DEC NO-UNDO.
DEF VAR Z      AS DEC NO-UNDO.
DEF VAR PO     AS DEC NO-UNDO.
DEF VAR PP     AS DEC NO-UNDO.

DEF VAR sumPart1  AS DEC NO-UNDO.
DEF VAR sumPart2  AS DEC NO-UNDO.

DEF VAR acctKO  AS CHAR NO-UNDO.
DEF VAR acctKP  AS CHAR NO-UNDO.

DEF VAR mEmitId    AS CHAR NO-UNDO.
DEF VAR name-short AS CHAR NO-UNDO.
DEF VAR currStatus AS CHAR INIT "�" NO-UNDO.

DEF BUFFER xop2 FOR op.
DEFINE BUFFER op-template  FOR op-template.

DEF VAR oTable AS TTable2 NO-UNDO.

oTable = NEW TTable2().


FIND FIRST op-kind WHERE RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.

FOR EACH op-template OF op-kind NO-LOCK:

MAIN:
DO TRANSACTION ON ERROR  UNDO MAIN, LEAVE MAIN ON ENDKEY UNDO MAIN, LEAVE MAIN:

FOR EACH instr-rate WHERE instr-rate.instr-cat EQ "sec-code"
                      AND instr-rate.rate-type EQ "���"
                      AND instr-rate.since     EQ in-op-date 
/*                      AND instr-rate.instr-code = "B102"*/
NO-LOCK:

FOR EACH signs WHERE signs.file-name  EQ "acct"
                 AND signs.code       EQ "sec-code"
                 AND signs.code-value EQ  instr-rate.instr-code NO-LOCK,
   FIRST acct WHERE acct.acct EQ ENTRY(1,signs.surrogate)
              AND acct.currency EQ ENTRY(2,signs.surrogate)
              AND acct.contract EQ "�����"
              AND (acct.close-date > in-op-date OR acct.close-date = ?) NO-LOCK BY open-date:


              RUN acct-qty IN h_base (acct.acct,
                                      acct.currency,
                                      in-op-date,
                                      in-op-date,
                  	              currStatus
                                      ).

              IF sh-qty = 0 THEN NEXT.

             mEmitId = getXAttrValue("sec-code",instr-rate.instr-code,"issue_cod").

             FIND FIRST cust-role WHERE cust-role-id EQ INT64(mEmitId) NO-LOCK.

             IF  cust-role.cust-cat = "�" THEN
                name-short = getTempXAttrValueEx("cust-corp",STRING(cust-role.cust-id),"name-short",in-op-date,"???").
             IF  cust-role.cust-cat = "�" THEN
                name-short = getTempXAttrValueEx("banks",STRING(cust-role.cust-id),"short-name",in-op-date,"???").

              mTypeCB = IF instr-rate.instr-code BEGINS "s" THEN "action" ELSE "bond" .

              mTss        = instr-rate.rate-instr. 
              mQty        = ABS(sh-qty).
              price       = getPrice(acct.acct,in-op-date).
              Z           = getZ(acct.acct,in-op-date).
              PP          = getPP(acct.acct, in-op-date, mTypeCB).
              PO          = getPO(acct.acct, in-op-date, mTypeCB).
              bPrice      = price + Z + PP - PO.
              bPrice      = (IF mTypeCB = "action" THEN bPrice  ELSE (bPrice + getPKDn(acct.acct,in-op-date) + getPKDu(acct.acct,in-op-date) + getPrem(acct.acct,in-op-date) + getDisk(acct.acct,in-op-date))  ).
              dDiff       = mTss * mQty - bPrice.
              acctKO      = getXAttrValue("sec-code",instr-rate.instr-code,"��⎊�").
              acctKP      = getXAttrValue("sec-code",instr-rate.instr-code,"��⏊�").
              cur-op-date = in-op-date.

              /** ���砫� ��⠥��� ᯨ��� ��⨢��������� ��८業�� **/

              sumPart1 = MIN((IF dDiff > 0 THEN PO ELSE PP),ABS(dDiff)).
              sumPart2 = ABS(dDiff) - sumPart1.

/*
message 
  " ⥫� " acct.acct SKIP
  " getPPAcct                "      getPPAcct(acct.acct, mTypeCB)  SKIP
  " getPOAcct                "      getPOAcct(acct.acct, mTypeCB)  SKIP
  " getAcct(cAcct,������) "      getAcct(acct.acct,"������")   SKIP
  " getAcct(cAcct,������)  "      getAcct(acct.acct,"������")    SKIP
  " getAcct(cAcct,������)  "      getAcct(acct.acct,"������")    SKIP
  " getAcct(cAcct,�६��)  "      getAcct(acct.acct,"�६��")    SKIP
  " getAcct(cAcct,��᪮��) "      getAcct(acct.acct,"��᪮��")   skip
  " mTss = " mTss  " mQty = " mQty " price = " price SKIP
  " bPrice = " bPrice " Z = " Z  " PP = " PP " PO = " PO  SKIP
  " dDiff = " dDiff SKIP
  " sumPart1 = " sumPart1 SKIP
  " sumPart2 = " sumPart2 SKIP
view-as alert-box.
*/

              IF sumPart1 > 0 THEN DO:
                      /** ����뢠�� ��⨢��������� ��८業�� **/
              CREATE op. 
              {op(sess).cr}
              {g-op.ass}
              ASSIGN
               op.doc-num  = STRING(GetCounterNextValue("��騩",op.op-date))
               op.doc-date = in-op-date
               op.details  = "��८業�� " + (IF mTypeCB = "action" THEN "��権 " ELSE "������権 ") + name-short + " �� �᭮����� �ᯮ�殮��� �/� �� " + STRING(in-op-date) + "."
              .
             CREATE op-entry.
              ASSIGN
               op-entry.op-date      = in-op-date
               op-entry.acct-cat     = op-template.acct-cat
               op-entry.op-status    = op.op-status
               op-entry.user-id      = op.user-id
               op-entry.op           = op.op
               op-entry.op-entry     = 1
               op-entry.acct-db      = IF dDiff > 0 THEN getPOAcct(acct.acct, mTypeCB) ELSE acctKP
               op-entry.acct-cr      = IF dDiff > 0 THEN acctKO ELSE getPPAcct(acct.acct, mTypeCB)
               op-entry.currency     = op-template.currency
               op-entry.value-date   = in-op-date
               op-entry.amt-cur      = 0
               op-entry.amt-rub      = sumPart1
               op-entry.type         = op-template.type
               op-entry.op-cod       = op-template.op-cod
               .

               {op.upd &undo="undo, return "}


              END.

              IF sumPart2 > 0 THEN DO:
                      /** ������� ᮮ⢥�������� ��८業�� **/
              CREATE op. 
              {op(sess).cr}
              {g-op.ass}
              ASSIGN
               op.doc-num  = STRING(GetCounterNextValue("��騩",op.op-date))
               op.doc-date = in-op-date
               op.details  = "��८業�� " + (IF mTypeCB = "action" THEN "��権 " ELSE "������権 ") + name-short + " �� �᭮����� �ᯮ�殮��� �/� �� " + STRING(in-op-date) + "."
              .
             CREATE op-entry.
              ASSIGN
               op-entry.op-date      = in-op-date
               op-entry.acct-cat     = op-template.acct-cat
               op-entry.op-status    = op.op-status
               op-entry.user-id      = op.user-id
               op-entry.op           = op.op
               op-entry.op-entry     = 1
               op-entry.acct-db      = IF dDiff > 0 THEN getPPAcct(acct.acct, mTypeCB) ELSE acctKO
               op-entry.acct-cr      = IF dDiff > 0 THEN acctKP ELSE getPOAcct(acct.acct, mTypeCB)
               op-entry.currency     = op-template.currency
               op-entry.value-date   = in-op-date
               op-entry.amt-cur      = 0
               op-entry.amt-rub      = sumPart2
               op-entry.type         = op-template.type
               op-entry.op-cod       = op-template.op-cod
               .
 
               {op.upd &undo="undo, return "}

              END.
/*
              oTable:addRow()
                    :addCell(instr-rate.instr-code)
                    :addCell(acct.open-date)
                    :addCell(mTss)
                    :addCell(mQty)
                    :addCell(mTss * mQty)
                    :addCell(bPrice)                    
                    :addCell(dDiff)
              .
*/

   END.            
  END.
 END.
END.
oTable:colsHeaderList = "�㬠��,�ਮ��⥭�,�⮨����� �� ����,���-��,������ �ࠢ������� �⮨�����,�����ᮢ�� �⮨�����,��८業��".
oTable:colsWidthList  = "8,12,10,15,15,15,15,15,15".
oTable:show().
/* {preview.i} */
DELETE OBJECT oTable. 
{intrface.del}

MESSAGE "�࠭����� �����襭�" VIEW-AS ALERT-BOX.