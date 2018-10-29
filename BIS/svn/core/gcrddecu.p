/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2001 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: GCRDDECU.P
      Comment: ������ᠫ쭠� ��楤�� ᯨᠭ�� � ����⥪� 2
   Parameters:
         Uses:
      Used by:
      Created: ...
     Modified: NIK ���䨪��� � "ࠧ�������".
     Modified: 30/03/2007 kraw (0057466) �맮� 㭨���ᠫ쭮� �࠭���樨 ������2
     Modified: 21/02/2007 kraw (0074649) ���뢠�� ��� ᯨᠭ��.
     Modified: 05/09/2007 kraw (0081627) ����⮩�� ⮫쪮 ��� ����⥪� 2
     Modified: 06/09/2007 kraw (0077977) �ਭ㤨⥫쭠� ������ ins-date � ���. ⮫쪮 ��� ����⥪� 2
     Modified: 02/10/2007 kraw (0077977) ����2kau
     Modified: 14/01/2007 muta (0087133) 302-�. ���ﭠ �㭪樮���쭮��� ���� ����⮩�� �� �����ᨮ��� ���⥦� 
     Modified: 12/02/2007 kraw (0079168) ��� ���⪠ �� �����ᮢ�� ���.
     Modified: 04/02/2011 kraw (0116612) �ਮ�⠭������� ᯨᠭ��

*/
def input param in-op-date like  op.op-date  no-undo.
def input param oprid      as    recid       no-undo.
def input param in-proc    as    char        no-undo.

{g-defs.i}
{defwrkop.i NEW}
{def-wf.i NEW}
{defframe.i NEW}
{topkind.def}
{intrface.get pbase}
{intrface.get strng}
{protdec.def new}
output stream stream_prot to "crddec_prot.txt".
{ setdest2.i
   &stream   = " stream stream_prot "
   &filename = " crddec_prot.txt "
}
def new global shared var is-pack         as logical        no-undo.
def new        shared var hist-rec-acct   as recid init ?   no-undo.
def new        shared var hist-rec-kau    as recid init ?   no-undo.

def var ret-value    as    char              no-undo.
def var out-rid      as    recid             no-undo.
def var vmfo         like  op-bank.bank-code no-undo.
def var vcorr-acct   like  op-bank.corr-acct no-undo.
def var vacct-corr   like  acct.acct         no-undo.
def var incur        like  op-entry.amt-cur  no-undo.

def var acctcorr           like  acct.acct            no-undo.
def var acctbal            like  acct.acct            no-undo.
def var kau-recid          as    recid                no-undo.
def var reccode            as    recid                no-undo.
def var temp-transaction   like  op.op-transaction    no-undo.
def var level              as    int64   INITIAL 6    no-undo.

def var work-kau        like  acct.kau-id             no-undo.
def var flag-corr       as    logical                 no-undo.
def var flag-kau        as    logical                 no-undo.
def var brows-proc      as    char                    no-undo.
def var brows-proc-stat as    char     initial "yes"  no-undo.
DEF VAR mFlBrAcrUN      AS    LOGICAL                 NO-UNDO.
def var tmp-sign        as    char                    no-undo.

def var summ-val        like  op-entry.amt-rub init ? no-undo.
def var summ-rub        like  op-entry.amt-rub init ? no-undo.
def var chg-is-pack     as    logical                 no-undo.
def var mCurrTmp        as char                       no-undo.

DEFINE VARIABLE mAcct-cr   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE mAcct-Db   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE main-first AS LOGICAL    NO-UNDO.

DEFINE VARIABLE mRes       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mErrMsg    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mOK        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mOpOutB    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mOpentOutB AS CHARACTER NO-UNDO.
DEFINE VARIABLE mOpOutO    AS CHARACTER NO-UNDO.
DEFINE VARIABLE mOpentOutO AS CHARACTER NO-UNDO.

DEFINE VARIABLE mStrTMP AS CHARACTER NO-UNDO.

DEFINE VARIABLE mIsKauCr AS LOGICAL NO-UNDO.
DEFINE VARIABLE vAcct     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vCartAcct AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vCurr     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE vAvPos    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vAvCur    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE vError    AS LOGICAL     NO-UNDO.

DEF BUFFER oAcct        FOR acct.
DEF BUFFER bAcct        FOR acct.
def buffer aop          for op.
def buffer opb          for op.
def buffer kau-op       for op.
def buffer kau-op-bank  for op-bank.
def buffer kau-entry    for op-entry.
def buffer out-entry    for op-entry.
    
DEFINE BUFFER xwop           FOR wop.                  

{g-currv1.i &ofbase="/*"}   

/* ��६���� ��� ����஢���� ��� ४����⮢ �� ���-� ���⠭���� � ���-� ᯨᠭ�� */

{copyxtr.i}
{kautools.lib}
DEF VAR Copy-str    AS CHARACTER INITIAL ? NO-UNDO.
DEF VAR Copy-op-In  AS RECID     INITIAL ? NO-UNDO.
DEF VAR Copy-op-Out AS RECID     INITIAL ? NO-UNDO.
DEFINE VARIABLE mDocType  AS CHARACTER NO-UNDO.
DEFINE VARIABLE mClassDoc AS CHARACTER NO-UNDO.
DEFINE VARIABLE mVidSpis  AS INT64     NO-UNDO.
DEFINE VARIABLE mNDS      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE mStat     AS CHARACTER NO-UNDO.

DEFINE VARIABLE mDate1256 AS DATE NO-UNDO. /*��� ��砫� ����⢨� 1256*/
/*============================================================================*/
is-pack = no.
{chkacces.i}
ASSIGN
   end-date  = in-op-date
   mDate1256 = DATE(FGetSetting("�⠭���","��⠍��1256",?))
NO-ERROR.
IF ERROR-STATUS:ERROR THEN DO:
   MESSAGE "�஢���� ���祭�� ����஥筮�� ��ࠬ��� <��⠍��1256>!"
   VIEW-AS ALERT-BOX ERROR.
   RETURN.
END.

FIND FIRST op-kind WHERE 
     RECID(op-kind) EQ oprid NO-LOCK NO-ERROR.
f-MakeProt = GetXAttrValueEx("op-kind",
                             op-kind.op-kind,
                             "��ଏ�⮪��",
                             "���").


gen:
repeat transaction on error  undo gen,leave gen
                   on endkey undo gen,leave gen:

   FOR EACH wop:
      DELETE wop. 
   END.

   FIND FIRST op-templ OF op-kind WHERE op-templ.class-code NE "doc-templ-nds" NO-LOCK NO-ERROR.

 /****************
  * ��᫮� Maslov
  * ��।��塞 ᮤ�ঠ��� ����樨 *
 **************/
   DEF BUFFER bufOp-template FOR op-template.
  FIND FIRST bufOp-template WHERE bufOp-template.op-kind=op-kind.op-kind NO-LOCK.

   IF NOT AVAIL op-templ THEN DO:
      MESSAGE COLOR MESSAGES "��� 蠡���� ��� �⮩ �࠭���樨."
      VIEW-AS ALERT-BOX ERROR .
      RETURN.
   END.

   ASSIGN
      brows-proc  = GetXAttrValueEx("op-template",
                                    STRING(op-templ.op-kind) + "," + STRING(op-templ.op-templ),
                                    "��抠�",
                                    ?)
      cur-op-date = in-op-date
      flager      = 1
      flag-corr   = no
      flag-kau    = no
   .

   RUN SetSysConf IN h_base("��抠㏠�", GetEntries(2,brows-proc,";","")).
   brows-proc = ENTRY(1,brows-proc,";").
/*--------------------------------------- ᮧ����� ��������ᮢ��� ���㬥�� --*/
   CREATE work-op.
   {crddec.acc &side       = "cr"
               &side-name  = "�।���"
               &no-dacct   = YES
   }     /* ��।������ ��� �� �।���   */

   {crddec.acc &side          = "db"
               &side-name     = "������"
               &no-cacct      = YES
               &nodef-GetAcct = YES
   }      /* ��।������ ��� �� ������    */

   RUN DeleteOldDataProtocol IN h_base("��抠㏠�").

   assign prot-acct = work-op.acct-cr.
   IF flag-kau EQ no THEN DO:
      MESSAGE COLOR MESSAGES
              "   ��� ��� ����⥪�, ��    " SKIP
              "���஬� �ந������� ᯨᠭ��."
              VIEW-AS ALERT-BOX ERROR.
      UNDO gen,LEAVE gen.
   END.
   ASSIGN
      Copy-op-In  = ?
      Copy-op-Out = ?
      copy-str    = ?
   .

   IF GetXAttrValueEx("op-template",STRING(op-templ.op-kind) + "," + STRING(op-templ.op-templ), "��७�፠�2", "���") EQ "��" THEN DO:

      RUN fnd_acct_op(INPUT  work-op.kau-cr, 
                      OUTPUT vAcct,           /* �����ᮢ� ��� */
                      OUTPUT vCartAcct,       /* ��� ����⥪� */
                      OUTPUT vCurr).

      {find-act.i
         &bact   = oAcct
         &acct   = vCartAcct
         &curr   = vCurr
         } 
      IF AVAIL(oAcct) AND oAcct.kau-id EQ "����-��1" THEN DO:

         {find-act.i
            &bact = bAcct
            &acct = vAcct
            &curr = vCurr
            }
        
         IF AVAIL(bAcct) THEN DO:

            RUN CheckCard2(bAcct.acct,bAcct.currency,in-op-date).
            IF RETURN-VALUE <> ""  THEN DO: 
        
               RUN Fill-SysMes("","","3","� ������ ���� ���㬥��� ��  ����⥪� 2. ���ᠭ�� ����������.|��७��� ���㬥�� �� ����⥪� 2,�⬥����").

               IF pick-value NE "1" THEN
                  UNDO gen,RETRY gen.
               ELSE DO:

                  IF GetBaseOpDate() EQ ? THEN
                     RUN InitBaseLibrary IN h_pbase (?,in-op-date,?).
                 
                  RUN SetSysConf IN h_base("kau_rec", STRING(RECID(kau))).
                  RUN RunTransaction(GetXAttrValueEx("op-template",STRING(op-templ.op-kind) + "," + STRING(op-templ.op-templ), "�࠭��1�2", "crd1_2")).
                  RUN SetSysConf IN h_base("kau_rec", "").
                  NEXT gen.

               END.
            END.
            ELSE DO:

               RUN CalcAvailPos(bAcct.acct, bAcct.currency, in-op-date, in-op-date,"�","�","cli-pos", YES, work-op.order-pay, YES, OUTPUT vAvPos, OUTPUT vAvCur).

               FIND FIRST kau WHERE kau.acct     EQ vCartAcct
                                AND kau.currency EQ vCurr
                                AND kau.kau      EQ work-op.kau-cr
                                    NO-LOCK NO-ERROR.

               IF AVAIL kau AND ((vCurr EQ "" AND kau.balance > - vAvPos) OR (vCurr NE "" AND kau.curr-bal > - vAvCur)) THEN DO:                 

                  RUN Fill-SysMes("","","3","�� ��� �������筮 �।�� ��� ������� ᯨᠭ�� ���㬥��.|��७��� ���㬥�� �� ����⥪� 2,�⬥����").
                    
                  IF pick-value NE "1"  THEN
                     UNDO gen,RETRY gen.
                  ELSE DO:
                 
                     IF GetBaseOpDate() EQ ? THEN
                        RUN InitBaseLibrary IN h_pbase (?,in-op-date,?).
                   
                     RUN SetSysConf IN h_base("kau_rec", STRING(RECID(kau))).
                     RUN RunTransaction(GetXAttrValueEx("op-template",STRING(op-templ.op-kind) + "," + STRING(op-templ.op-templ), "�࠭��1�2", "crd1_2")).
                     RUN SetSysConf IN h_base("kau_rec", "").
                     NEXT gen.                 
                 
                  END.
               END.
            END.
         END.
      END.
   END.

   if SearchPFile(in-proc) then             /* �맮� ��楤��� ।���஢���� */
      run value(in-proc + ".p") (output flager,
                                 in-op-date,
                                 recid(work-op),
                                 recid(op-templ),
                                 yes,
                                 summ-val,
                                 summ-rub,
                                 output out-rid).

   else
      undo gen, leave gen.

   delete work-op.
RUN SetSysConf IN h_base ("ImpED107Flag",flager).

      /*************************************
       * ��������㥬 ᮤ�ন���           *
       * � ���㬥�� �� ����������.        *
       *************************************
       * ����: ��᫮� �.�. (Maslov D.A.)  *
       * ���: #538
       * ��� ᮧ�����: 30.12.2010
       **************************************/

       DEF VAR rVnOp AS RECID.
       rVnOp = out-rid.                  

      /*************** ����� #538 ***********/

   if flager ne 0 then do:
      brows-proc-stat = "yes".
      /* �� ��室�� ⮫쪮 � �ᮡ�� ��砥 (esc �� ᯨ᪠ ���㬥�⮢) */
      {justasec}
      IF flager EQ -1 AND mFlBrAcrUN
      THEN UNDO gen,RETRY gen.
      ELSE UNDO gen,LEAVE gen.
   end.

/*------------------------------------------ ᮧ����� �����ᮢ��� ���㬥�� --*/
   find op-entry where recid(op-entry) eq out-rid  no-lock no-error.
   find op          of op-entry                    no-lock no-error.
   find op-bank     of op                          no-lock no-error.

   IF AVAIL op THEN ASSIGN
      temp-transaction = op.op-transaction
      cur-op-trans     = op.op-transaction
      copy-op-out      = recid(op)
      mOpentOutO       = STRING(op-entry.op-entry)
      mOpOutO          = STRING(op-entry.op)
   .
   ELSE
      cur-op-trans = ?.

   copy-str = GetXAttrValue("op-template",
                            string(op-templ.op-kind) + "," +
                            string(op-templ.op-templ),
                            "����������").
   mIsKauCr = NO.

   IF {assigned op-entry.kau-cr} THEN DO:
      FIND op WHERE op.op EQ INT64(ENTRY(1,op-entry.kau-cr)) NO-LOCK NO-ERROR.
      FIND kau WHERE kau.acct     EQ op-entry.acct-cr
                 AND kau.currency EQ op-entry.currency
                 AND kau.kau      EQ op-entry.kau-cr
      NO-LOCK NO-ERROR.

      /*************************************
       * ��������㥬 ᮤ�ন���           *
       * � ���㬥�� �� ����������.        *
       *************************************
       * ����: ��᫮� �.�. (Maslov D.A.)  *
       * ���: #538
       * ��� ᮧ�����: 30.12.2010
       **************************************/

	  DEF VAR cDocNum   AS CHAR INITIAL "" NO-UNDO.
	  DEF VAR iOpId     AS INT             NO-UNDO.
	  DEF VAR oClient   AS TClient         NO-UNDO.
          DEF VAR oDocument AS TDocument       NO-UNDO.

	  DEF BUFFER vnOpEntry FOR op-entry.
          DEF BUFFER vnOp      FOR op.




	  cDocNum = IF AVAIL op THEN op.doc-num ELSE "".
	
		/*********************************
		 * ��뫪� �� �����ᮢ� ���㬥�� *
		 * �࠭���� � ���. ४�����     *
		 * op-bal ���������.		 *
		 *********************************/

	      iOpId = INTEGER(getXAttrValue("op",STRING(op.op),"op-bal")).



	       FIND FIRST vnOpEntry WHERE RECID(vnOpEntry)=rVnOp NO-LOCK NO-ERROR.
	       FIND FIRST vnOp WHERE vnOp.op = vnOpEntry.op NO-LOCK NO-ERROR.
        

	       IF AVAILABLE(vnOp) THEN 
                 DO:

	           oDocument = new TDocument(iOpId,?).
                   oClient = new TClient(oDocument:getXAttr("acctbal")).


                     vnOp.details = "#ACTION# �� " + bufOp-template.details + " #DOCTYPE# N " + oDocument:doc-num + " �� " + STRING(oDocument:doc-date,"99.99.9999") + " " + oClient:name-short + " " + oDocument:getXAttr("acctbal").

                     /**
                      * ��᫮� �. �. Maslov D. A.
                      * �� ���: #2070
                      **/
		
                     CASE oDocument:doc-type:
                          WHEN "01" THEN DO:
                            vnOp.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            vnOp.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "02" THEN DO:
                            vnOp.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            vnOp.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "015" THEN DO:
                            vnOp.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            vnOp.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "016" THEN DO:
                            vnOp.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            vnOp.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "17" THEN DO:
                            vnOp.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            vnOp.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          OTHERWISE DO:
                            vnOp.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            vnOp.details = REPLACE(vnOp.details,"#ACTION#","����筮 ᯨᠭ�").
                          END.
                     END.


              	  DELETE OBJECT oClient.
                  DELETE OBJECT oDocument.

		END.	  
	/****  ����� #538 ****/

      IF AVAILABLE kau THEN
         mIsKauCr = YES.
   END.
   if {assigned op-entry.kau-db} THEN DO:
      FIND op WHERE op.op EQ INT64(ENTRY(1,op-entry.kau-db)) NO-LOCK NO-ERROR.
      FIND kau WHERE kau.acct     EQ op-entry.acct-db
                 AND kau.currency EQ op-entry.currency
                 AND kau.kau      EQ op-entry.kau-db
      NO-LOCK NO-ERROR.
   END.
   copy-op-in  = if available(op)
                    then recid(op)
                    else ?.

   IF copy-op-in  NE ?  AND
      copy-op-out NE ?  AND
      copy-str    NE ?  AND
      copy-str    NE "" THEN DO:
      RUN Copy-Xattr-Op(copy-op-in,copy-op-out,copy-str).
      ASSIGN
         Copy-op-Out = ?
         copy-str    = ?
      .
   END.

   IF AVAILABLE op THEN
   DO:

      IF GetXAttrValueEx("op",
                         STRING(op.op),
                         "�ਮ�⑯��",
                         "") EQ "��" THEN
      DO:
         mStrTMP =  GetXAttrValueEx("op",
                                    STRING(op.op),
                                    "op-bal", 
                                    "").

         IF mStrTMP NE "" THEN
         DO:
            FIND FIRST opb WHERE opb.op EQ INT64(mStrTMP) NO-LOCK NO-ERROR.

            IF AVAILABLE opb THEN
            DO:
               mStrTMP = opb.doc-num.
            END.
            ELSE
            DO:
               mStrTMP = "".
            END.
         END.

         IF mStrTMP NE "" THEN
            mStrTMP = "N " + mStrTMP.

         RUN Fill-SysMes("","","-1","�� ���㬥��� " + mStrTMP + " ᯨᠭ�� �ਮ�⠭������").
         UNDO gen,RETRY gen.
      END.
   END.
   
   find next op-template of op-kind WHERE op-templ.class-code NE "doc-templ-nds" no-lock no-error.
   if not available(op-template) then next gen.

   if avail op then do:
      tmp-sign = GetXattrValue("op",string(op.op),"op-bal").

      IF FGetSetting("�⠭���", "��⑯", "") EQ "�� ���㬥��" THEN
         mStat = GetXattrValue("op",string(op.op),"�������"). 

      IF tmp-sign ne "" THEN
         FIND kau-op WHERE kau-op.op EQ INT64(TMP-SIGN) NO-LOCK NO-ERROR.
      ELSE
         find first kau-op where kau-op.op-transaction eq op.op-transaction
                             and kau-op.acct-cat       eq "b"
                             and recid(kau-op)         ne recid(op)
                                 NO-LOCK NO-ERROR.
      IF AVAIL kau-op THEN
         FIND FIRST kau-entry OF kau-op NO-LOCK NO-ERROR.
      FIND aop WHERE RECID(aop) EQ RECID(op) NO-LOCK NO-ERROR.
   end.
   find op of op-entry no-lock no-error.
   if avail kau-op then do:
      if not avail op-bank then
         find op-bank of kau-op no-lock no-error.

      assign
         acctcorr = GetXAttrValueEx("op",string(kau-op.op),"acctcorr",?)
         acctbal  = GetXAttrValueEx("op",string(kau-op.op),"acctbal", ?)
      .
   end.
   ELSE DO:
      assign
         acctcorr = GetXAttrValueEx("op",string(aop.op),"acctcorr",?)
         acctcorr = (if acctcorr eq ?
                        then GetXAttrValueEx("op",string(op.op),"acctcorr",?)
                        else acctcorr)
         acctbal  = GetXAttrValueEx("op",string(aop.op),"acctbal",?)
         acctbal  = (if acctbal eq ?
                        then GetXAttrValueEx("op",string(op.op),"acctbal",?)
                        else acctbal)
      .
   END.
   
   create work-op.
   assign
      work-op.mfo       = (if available(op-bank)
                             then op-bank.bank-code
                             else ?)
      work-op.currency  = (if not available(signs)
                              then ?
                              else op-templ.currency)
      work-op.corr-acct = (if available(op-bank)
                              then op-bank.corr-acct
                              else ?)
      work-op.amt-cur   = op-entry.amt-cur
      work-op.amt-rub   = op-entry.amt-rub
      work-op.acct-cr   = (if available(kau-entry)
                              then kau-entry.acct-cr
                              else (if acctcorr ne ?
                                      then acctcorr
                                      else ?))
      work-op.acct-db   = (if available(kau-entry)
                              then kau-entry.acct-db
                              else (if acctbal ne ?
                                       then acctbal
                                       else ?))
      work-op.ben-acct  = if avail kau-op then kau-op.ben-acct else op.ben-acct
      work-op.name-ben  = if avail kau-op then kau-op.name-ben else op.name-ben
      work-op.details   = IF {assigned op-templ.details} THEN op-templ.details ELSE
                           (if avail kau-op
                              then kau-op.details
                              else (if available(op)
                                       then op.details
                                       else ?))
      work-op.doc-num   = IF AVAIL kau-op THEN kau-op.doc-num ELSE ?
      work-op.op-status = IF {assigned mStat} THEN mStat ELSE op-templ.op-status
      work-op.doc-kind  = if avail kau-op then kau-op.doc-kind else work-op.doc-kind
      work-op.acct-cat  = if avail kau-op then kau-op.acct-cat else ?
      work-op.inn       = if avail kau-op then kau-op.inn else op.inn
      work-op.op-transaction = temp-transaction
      work-op.order-pay = IF AVAIL op THEN op.order-pay
                                      ELSE work-op.order-pay
   .                          
   if op-templ.doc-type ne ?  and
      op-templ.doc-type ne "" then
      work-op.doc-type  = entry(1, op-templ.doc-type) .
   else do:
      if avail kau-op then
         work-op.doc-type  = kau-op.doc-type.
      else
         work-op.doc-type  = ?.
   end.
   
   RUN chktpdoc.p (RECID(kau),
                   RECID(op-template),
                   IF acct.currency EQ "" THEN work-op.amt-rub ELSE work-op.amt-cur,
                   OUTPUT mDocType,
                   OUTPUT mClassDoc,
                   OUTPUT mVidSpis).
   work-op.doc-type  = ENTRY(1,mDocType).

   copy-str = GetXAttrValue("op-template",
                            string(op-templ.op-kind) + "," +
                            string(op-templ.op-templ),
                            "����������").

   IF {assigned copy-str} THEN
      copy-op-in = IF AVAIL kau-op THEN RECID(kau-op)
                                   ELSE copy-op-in.
   chg-is-pack = no.

   if is-pack                and
      (work-op.acct-db eq ?  or
       work-op.acct-cr eq ?) then assign
      is-pack     = no
      chg-is-pack = yes
   .
   
   if SearchPFile(in-proc) then do:            /* �맮� ��楤��� ।���஢���� */
      IF     mDate1256 NE ?
         AND mDate1256 GT (IF AVAIL kau-op THEN kau-op.doc-date ELSE op.op-date) THEN
      RUN SetSysConf IN h_base ("����2��ଠ���","NO").
      ELSE
      RUN SetSysConf IN h_base ("����2��ଠ���","").
      RUN SetSysConf IN h_base ('����2����ᄮ�',mClassDoc).
      RUN SetSysConf IN h_base ("����2���",STRING(IF AVAIL kau-op THEN RECID(kau-op) ELSE RECID(op))).

      IF mVidSpis EQ 1 AND AVAILABLE kau-op 
         AND kau.kau-id BEGINS "����-��" 
         AND mIsKauCr THEN
      DO:

         IF kau-op.doc-date EQ ? THEN
            mStrTMP = ",".
         ELSE
            mStrTMP = STRING(kau-op.doc-date) + ",".

         IF kau-op.ins-date NE ? THEN
            mStrTMP = mStrTMP + STRING(kau-op.ins-date).

         RUN SetSysConf IN h_base ('����2Date',mStrTMP).
         RUN SetSysConf IN h_base ('����2doc-type',kau-op.doc-type).
         RUN SetSysConf IN h_base ('����2kau',kau.kau-id).
      END.
      ELSE
      DO:
         RUN SetSysConf IN h_base ('����2Date',"").
         RUN SetSysConf IN h_base ('crddec1_mDocDate',"").
         RUN SetSysConf IN h_base ('����2kau',"").
      END.

      RUN SetSysConf IN h_base ("����2��ଠ���","").
      RUN SetSysConf IN h_base ("VidSpis",STRING(mVidSpis) + ";" + mDocType).
      
      run value(in-proc + ".p") (output flager,
                                 in-op-date,
                                 recid(work-op),
                                 recid(op-templ),
                                 no,
                                 summ-val,
                                 summ-rub,
                                 output out-rid).
      /*************************************
       * ��������㥬 ᮤ�ন���           *
       * � ���㬥�� �� ����������.        *
       *************************************
       * ����: ��᫮� �.�. (Maslov D.A.)  *
       * ���: #538
       * ��� ᮧ�����: 30.12.2010
       **************************************/

       DEF BUFFER ttOpEntry FOR op-entry.
       DEF BUFFER ttOp FOR op.
       DEF BUFFER ttOpEntry2 FOR op-entry.
       DEF BUFFER ttOp2 FOR op.

       FIND FIRST ttOpEntry WHERE RECID(ttOpEntry) EQ out-rid NO-LOCK NO-ERROR. 

      IF AVAILABLE(ttOpEntry) THEN
         DO:

            FIND FIRST ttOp WHERE ttOp.op EQ ttOpEntry.op NO-LOCK NO-ERROR.
            FIND FIRST ttOpEntry2 WHERE RECID(ttOpEntry2) EQ rVnOP.

            FIND FIRST ttOp2 WHERE ttOp2.op EQ ttOpEntry2.op.

              oClient = new TClient(ttOpEntry.acct-db).
	      oDocument = new TDocument(iOpId,?).


                 ttOp2.details = "#ACTION# �� " + bufOp-template.details + " #DOCTYPE# N " + oDocument:doc-num + " �� " + STRING(oDocument:doc-date,"99.99.9999") + " " + oClient:name-short + " " +  ttOpEntry.acct-db.
                      
                     /**************
                      * ��᫮� �. �. Maslov D. A.
                      * �� ���: #2070
                      * �� ���: #2071 ���ਫ ���祭� ⨯��.
                      **************/
                     CASE oDocument:doc-type:
                          WHEN "01" THEN DO:
                            ttOp2.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            ttOp2.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "02" THEN DO:
                            ttOp2.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            ttOp2.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "015" THEN DO:
                            ttOp2.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            ttOp2.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.
                          WHEN "016" THEN DO:
                            ttOp2.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            ttOp2.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.

                          WHEN "17" THEN DO:
                            ttOp2.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            ttOp2.details = REPLACE(vnOp.details,"#ACTION#","���ᠭ�").
                          END.

                          OTHERWISE DO:
                            ttOp2.details = REPLACE(vnOp.details,"#DOCTYPE#","�/�").
                            ttOp2.details = REPLACE(vnOp.details,"#ACTION#","����筮 ᯨᠭ�").
                          END.
                     END.

              DELETE OBJECT oClient.
              DELETE OBJECT oDocument.
          END.


      /*********** ����� #538 ***************/
 
      RUN SetSysConf IN h_base ("VidSpis","").
      RUN SetSysConf IN h_base ('����2doc-type',"").
      RUN SetSysConf IN h_base ('����2Date',"").
      RUN SetSysConf IN h_base ("����2���","").
      RUN SetSysConf IN h_base ("����2��ଠ���","").
      RUN SetSysConf IN h_base ('����2����ᄮ�',"").
      RUN SetSysConf IN h_base ('����2kau',"").
   end.
   else
      undo gen, leave gen.
   
   if flager ne 0 then do:
      brows-proc-stat = "yes".
      undo gen,leave gen.
   end.
   
   if chg-is-pack then is-pack = not is-pack.
   find op-entry where recid(op-entry) eq out-rid no-lock no-error.
   if avail op-entry then
      assign
        summ-val = summ-val - op-entry.amt-cur
        summ-rub = summ-rub - op-entry.amt-rub.
   find op of op-entry no-lock no-error.
   IF AVAIL op THEN
      ASSIGN
         mOpOutB      = STRING(op.op)
         mOpentOutB   = STRING(op-entry.op-entry)
         cur-op-trans = op.op-transaction
         copy-op-out  = RECID(op)
      .
   ELSE
      cur-op-trans = ?.
   IF copy-op-in  NE ?  AND
      copy-op-out NE ?  AND
      copy-str    NE ?  AND
      copy-str    NE "" THEN DO:
      RUN Copy-Xattr-Op(copy-op-in,copy-op-out,copy-str).
      ASSIGN
         Copy-op-In  = ?
         Copy-op-Out = ?
         copy-str    = ?
      .
      if summ-val = 0 and summ-rub = 0 then leave.
   END.
   delete work-op.
   if flager ne 0 then undo gen,leave gen.

/* ******************************************* */
IF kau.balance EQ 0 AND kau.kau-id EQ "����-��2" THEN
DO:

  mOK = YES.

   FIND FIRST acct WHERE acct.acct     EQ op-entry.acct-cr
                     AND acct.currency EQ op-entry.currency
      NO-LOCK NO-ERROR.

   IF AVAILABLE acct THEN
   DO:

      IF NOT CAN-DO(FGetSetting("�犮������","","--���--"), acct.acct) THEN
      mOK = NO.
   END.

   FIND FIRST acct WHERE acct.acct     EQ op-entry.acct-db
                     AND acct.currency EQ op-entry.currency
      NO-LOCK NO-ERROR.

   IF AVAILABLE acct THEN
   DO:

      IF GetXAttrValueEx("acct", 
                         acct.acct + "," + acct.currency, 
                         "���������2", 
                         "**empty**") EQ "**empty**" THEN
         mOK = NO.
   END.

   IF mOK THEN
   DO:

      MESSAGE "� ����⥪� ᯨ�뢠���� ������� �����." SKIP
              "������� ����⮩��?"
         VIEW-AS ALERT-BOX BUTTONS YES-NO
         UPDATE mOK.

      IF mOK THEN
      DO:

        {empty tOpKindParams} /* ������ ⠡���� ��ࠬ��஢ */
        ASSIGN
           mRes = TDAddParam ("iOp_b",       mOpOutB)
                  AND
                  TDAddParam ("iOp-entry_b", mOpentOutB)
                  AND
                  TDAddParam ("iOp_o",       mOpOutO)
                  AND
                  TDAddParam ("iOp-entry_o", mOpentOutO)
        NO-ERROR.

        IF NOT mRes THEN 
        DO:
           MESSAGE "�訡�� ��।�� ��ࠬ��஢ � �࠭����� ����⮩��" SKIP
                   "���㬥�� ����⮩�� �� �㤥� ��ନ஢��"
              VIEW-AS ALERT-BOX ERROR.
           RETURN.
        END.

        RUN ex-trans.p ("������2", in-op-date, TABLE tOpKindParams, OUTPUT mOK, OUTPUT mErrMsg).

        IF NOT mOK THEN
        DO:
           MESSAGE "�訡�� �࠭���樨 ����⮩��" SKIP
                   "���㬥�� ����⮩�� �� ��ନ஢��"
              VIEW-AS ALERT-BOX ERROR.
           RETURN.
        END.
     END.
   END.
END.

/*-------------------------------------------- ��ࠡ��뢠�� 蠡��� �����ᨨ --*/
   find out-entry where recid(out-entry) eq out-rid exclusive-lock no-error.
   IF NOT AVAIL out-entry THEN RETURN.
   find op of out-entry exclusive-lock.
   op.op-transaction = temp-transaction.
   
   find next op-templ of op-kind WHERE op-templ.class-code NE "doc-templ-nds" no-lock no-error.
   if avail op-templ then do:

      IF {assigned op-templ.amt-rub} THEN
         FIND FIRST commission where commission.commission eq op-templ.amt-rub NO-LOCK NO-ERROR.
      IF AVAIL(commission) THEN DO:
         {g-comcal.i}
         find op of out-entry exclusive-lock.
         if avail op then
         op.op-transaction = temp-transaction.
      END.
      ELSE DO:
         RUN CreateCommis (OUTPUT vError).
         IF vError  THEN DO:

             RUN Fill-SysMes("","","-1","�訡�� ᮧ����� ���㬥�� �����ᨨ.").
             UNDO gen, LEAVE gen.

         END.
      END.
   END.
/******************* ��ࠡ�⪠ 蠡���� ��� ****************************/
   mNDS = DEC(GetXattrValue("kau",kau.acct + "," + kau.currency + "," + kau.kau, "���")).  
   IF mNDS > 0.00 THEN DO:
   
      FIND FIRST op-template OF op-kind WHERE
                 op-template.class-code EQ "doc-templ-nds" NO-LOCK NO-ERROR.
      IF AVAIL(op-template) THEN DO:

         CREATE work-op.
         
         {crddec.acc &side       = "cr"
                    &side-name  = "�।���"
                    &no-dacct   = YES
                    &nodef-GetAcct = YES                    
        }     /* ��।������ ��� �� �।���   */   
              
         ASSIGN
            work-op.acct-db  = acctcorr
            work-op.currency = op-entry.currency
            work-op.amt-cur  = 0.00
            work-op.amt-rub  = mNDS
          .   
         RUN g-call1.p (output flager, in-op-date, recid(work-op), recid(op-template),output out-rid).
         IF flager NE 0 THEN UNDO gen, LEAVE gen. ELSE flager = 1.
         FIND FIRST out-entry WHERE RECID(out-entry) EQ out-rid NO-LOCK.
         find FIRST op of out-entry EXCLUSIVE-LOCK NO-ERROR.
         IF AVAIL op THEN
         op.op-transaction = temp-transaction.
      END.      
   END.
   if is-pack = no then do:
      {g-print1.i}
   end.
end.                       /* repeat transaction on error  undo gen,leave gen */

RUN SetSysConf in h_base ("���-���:OP-BAL" ,  "").
RUN SetSysConf in h_base ("���-���:DOC-KIND" ,"").
RUN SetSysConf in h_base ("���-���:DOC-NUM"  ,"").
RUN SetSysConf in h_base ("���-���:ORDER-PAY", "").
RUN SetSysConf in h_base ("���-���:ACCT-DB"  , "").
RUN SetSysConf in h_base ("���-���:ACCT-CR", "").
RUN SetSysConf in h_base ("���-���:BEN-ACCT", "").
RUN SetSysConf in h_base ("���-���:NAME-BEN", "").
RUN SetSysConf in h_base ("���-���:INN"     , "").
RUN SetSysConf in h_base ("���-���:DETAILS", "").
RUN SetSysConf in h_base ("���-���:AMT-RUB", "").
RUN SetSysConf in h_base ("���-���:AMT-CUR", "").
RUN SetSysConf in h_base ("���-���:DOP-DATE" , "").
RUN SetSysConf in h_base ("���-���:����-���-���", ""). 

/* �ନ஢��� ��⮪�� */
if f-MakeProt eq "��"
then do:
   run print_protocol.
   {signatur.i
         &user-only = YES
         &stream    = " stream stream_prot "
   }
   { preview2.i
         &stream   = " stream stream_prot "
         &filename = "crddec_prot.txt"
   }
end.
output stream stream_prot close.


/*============================================================================*/
&glob op-stat op-templ.op-status

{intrface.del}          /* ���㧪� �����㬥����. */ 

/*�������⥫�� ��楤���*/
PROCEDURE CONST-ACCT:
   DEFINE INPUT PARAM dbcr   AS CHAR NO-UNDO.
   DEFINE VAR tmp-kau-id         AS CHARACTER NO-UNDO.
   DEFINE VAR tmp-stat           AS CHARACTER NO-UNDO.

   IF NOT AVAIL acct THEN RETURN.
   IF dbcr EQ "cr" THEN DO:
      assign
         work-op.acct-cr  = acct.acct
         work-op.currency  = acct.currency WHEN acct.currency ne ""
      .
      FIND bal-acct OF acct NO-LOCK NO-ERROR.
      IF {assigned acct.kau-id    } or
         {assigned bal-acct.kau-id}
         THEN flag-kau  = yes.
         ELSE flag-corr = yes.
   END.
   IF dbcr EQ "db" THEN DO:
      assign
         work-op.acct-db  = acct.acct
         work-op.currency  = acct.currency WHEN acct.currency ne ""
      .
      FIND bal-acct OF acct NO-LOCK NO-ERROR.
      IF {assigned acct.kau-id    } or
         {assigned bal-acct.kau-id}
         THEN flag-kau  = yes.
         ELSE flag-corr = yes.
   END.

   tmp-kau-id = IF   acct.kau-id NE ? AND acct.kau-id NE ? THEN acct.kau-id
                ELSE IF bal-acct.kau-id NE ? AND bal-acct.kau-id NE ? THEN bal-acct.kau-id
                ELSE ?.
   IF tmp-kau-id NE ? THEN DO:
      FIND code WHERE code.class EQ "�������"
                  AND code.code  EQ tmp-kau-id
                                    NO-LOCK NO-ERROR.
      IF NOT AVAIL code THEN RETURN.
      IF NUM-ENTRIES(code.misc[4]) GE 2 THEN
         tmp-stat = ENTRY(2,code.misc[4]).
      IF AVAIL op-template AND op-template.op-status GT tmp-stat THEN
         tmp-stat = {&op-stat}.
      ASSIGN
        work-op.op-status = tmp-stat
      .
   END.
END PROCEDURE.



PROCEDURE FILL-ACCT:
    DEFINE INPUT PARAM dbcr   AS CHAR NO-UNDO.
    DEFINE INPUT PARAM in-rec AS RECID NO-UNDO.

    DEFINE VAR tmp-kau-id     AS CHARACTER NO-UNDO.
    DEFINE VAR tmp-stat       AS CHARACTER NO-UNDO.
    DEF BUFFER oba FOR acct.
    DEF BUFFER ba FOR acct.
    DEF VAR out-summ AS DEC NO-UNDO.
    DEF VAR osumm AS DEC NO-UNDO.

    DEFINE VARIABLE vBAmt-rub AS DECIMAL NO-UNDO.
    DEFINE VARIABLE vBAmt-cur AS DECIMAL NO-UNDO.

    FIND acct WHERE RECID(acct) EQ in-rec NO-LOCK NO-ERROR.
    FIND bal-acct OF acct NO-LOCK NO-ERROR.
    IF NOT AVAIL acct THEN RETURN.
    tmp-kau-id = IF   acct.kau-id NE ? AND acct.kau-id NE "" THEN acct.kau-id
                 ELSE IF bal-acct.kau-id NE ? AND bal-acct.kau-id NE "" THEN bal-acct.kau-id
                 ELSE ?.
    IF tmp-kau-id EQ ? THEN RETURN.
    FIND code WHERE code.class EQ "�������"
                AND code.code  EQ tmp-kau-id
                                  NO-LOCK NO-ERROR.
    IF NOT AVAIL code THEN RETURN.
    IF NUM-ENTRIES(code.misc[4]) GE 2 THEN
       tmp-stat = ENTRY(2,code.misc[4]).
    IF AVAIL op-template AND op-template.op-status GT tmp-stat THEN
       tmp-stat = {&op-stat}.

    IF dbcr EQ "cr" THEN DO:
       ASSIGN
        work-op.acct-cr   = IF AVAIL acct THEN acct.acct
                                          ELSE ?
        work-op.currency  = acct.currency WHEN acct.currency ne ""
        work-op.op-status = tmp-stat
        work-op.amt-cur   = 0
        work-op.amt-rub   = 0
        flag-kau          = yes.
/*
      if num-entries(pick-value) = 5 and entry(3, pick-value) = "�㬬�" then do:
        assign
          summ-rub  = abs(dec(entry(4, pick-value)))
          summ-val  = if acct.currency <> "" then abs(dec(entry(5, pick-value))) else 0.
      end.
*/
    END.
    IF dbcr EQ "db" THEN DO:
       ASSIGN
        work-op.acct-db   = IF AVAIL acct THEN acct.acct
                                          ELSE ?
        work-op.currency  = acct.currency WHEN acct.currency ne ""
        work-op.op-status = tmp-stat
        work-op.amt-cur   = 0
        work-op.amt-rub   = 0
        flag-kau          = yes.
/*
      if num-entries(pick-value) = 5 and entry(3, pick-value) = "�㬬�" then do:
        assign
          summ-rub = abs(dec(entry(4, pick-value)))
          summ-val = if acct.currency <> "" then abs(dec(entry(5, pick-value))) else 0.
      end.
*/
    END.
    if num-entries(pick-value) = 5 and entry(3, pick-value) = "�㬬�" then do:
       find oba where recid(oba) = INT64(ENTRY(2, pick-value)) no-lock no-error.
       run fdbacct(buffer oba,FGetSetting("�⠭���", "findcard2","���"),"����-��2").
       vBAmt-rub = 0.
       vBAmt-cur = 0.

       for each ttkau no-lock,
           first ba where recid(ba) = ttkau.frecid no-lock:
           accumulate ba.acct (count).
          RUN acct-pos IN h_base (ba.acct,ba.curr,in-op-date,in-op-date,"�").

          IF vBAmt-rub LT ABSOLUTE(sh-bal) THEN
          ASSIGN
             vBAmt-rub = ABSOLUTE(sh-bal)
             vBAmt-cur = IF acct.currency NE "" THEN ABSOLUTE(sh-bal) ELSE 0
          .
       end.
       if (accum count ba.acct) > 1 then do:
          assign summ-rub = 0 summ-val = 0 osumm = 0.
          RUN acct-pos IN h_base (oba.acct,oba.curr,in-op-date,in-op-date,"�").
          summ-rub = abs(sh-bal).
          summ-val = if oba.currency <> "" then abs(sh-val) else 0.

          IF     acct.currency EQ "" 
             AND summ-rub GT vBAmt-rub 
             AND vBAmt-rub NE 0 THEN
            summ-rub = vBAmt-rub.
          /*
          for each ttkau no-lock,
              first ba where recid(ba) = ttkau.frecid no-lock:
              run calc-crd2(oba.acct,ba.acct,ba.currency,output out-summ).
              RUN acct-pos IN h_base (ba.acct,ba.curr,in-op-date,in-op-date,"�").
              summ-rub = summ-rub + abs(sh-bal).
              osumm = osumm + out-summ.
              IF ba.curr  GT "" THEN summ-val = summ-val + abs(sh-val).
          end.
          */
       end.
       else do:
          assign
             summ-rub = abs(dec(entry(4, pick-value)))
             summ-val = if acct.currency <> "" then abs(dec(entry(5, pick-value))) else 0.

          IF     acct.currency EQ "" 
             AND summ-rub GT vBAmt-rub 
             AND vBAmt-rub NE 0 THEN
            summ-rub = vBAmt-rub.
       end.
    end.
    assign
      brows-proc-stat = "no,ACCT," + STRING(RECID(ACCT))
      hist-rec-acct   = recid(acct)
    .
END PROCEDURE.


PROCEDURE FILL-KAU:
    DEFINE INPUT PARAM dbcr   AS CHAR NO-UNDO.
    DEFINE INPUT PARAM in-rec AS RECID NO-UNDO.
    DEF VAR tmp-stat AS CHARACTER NO-UNDO.
    FIND kau WHERE RECID(kau) EQ in-rec NO-LOCK NO-ERROR.
    IF NOT AVAIL kau THEN RETURN.
       FIND code WHERE code.class EQ "�������"
                   AND code.code  EQ kau.kau-id
                                     NO-LOCK NO-ERROR.
    IF NOT AVAIL code THEN RETURN.
    IF NUM-ENTRIES(code.misc[4]) GE 2 THEN
       tmp-stat = ENTRY(2,code.misc[4]).
    IF AVAIL op-template AND op-template.op-status GT tmp-stat THEN
       tmp-stat = {&op-stat}.
    IF dbcr EQ "cr" THEN DO:
       ASSIGN
        work-op.acct-cr   = IF AVAIL kau THEN kau.acct
                                         ELSE ?
        work-op.amt-cur   = 0
        work-op.amt-rub   = 0
        work-op.currency  = IF AVAIL kau THEN kau.currency
                                         ELSE ""
        work-op.kau-cr    = kau.kau
        work-op.op-status = tmp-stat
        flag-kau          = yes.
    END.
    IF dbcr EQ "db" THEN DO:
       ASSIGN
        work-op.acct-db   = IF AVAIL kau THEN kau.acct
                                         ELSE ?
        work-op.amt-cur   = 0
        work-op.amt-rub   = 0
        work-op.currency  = IF AVAIL kau THEN kau.currency
                                         ELSE ""
        work-op.kau-db    = kau.kau
        work-op.op-status = tmp-stat
        flag-kau          = yes.
    END.
    brows-proc-stat = "yes".
    hist-rec-kau = recid(kau).
END PROCEDURE.

PROCEDURE CreateCommis:
   DEFINE OUTPUT PARAM oError AS LOGICAL NO-UNDO INIT YES.
   DEFINE VARIABLE dval         AS DATE     NO-UNDO.
   DEFINE VARIABLE vFlagErrlog  AS LOGICAL  NO-UNDO.

CR_COM: 
   DO TRANSACTION:

   /* �������� ���㬥�� */
    cur-op-date = in-op-date.
    CREATE op.
    {op(sess).cr}
    {g-op.ass}
    CREATE op-entry.
    {g-en.ass}

    ASSIGN
       op-entry.value-date = in-op-date
       op-entry.currency   = IF op-templ.currency <> ? THEN GetCurr(op-templ.currency)
                                                       ELSE op-entry.currency.

    CREATE wop.
    ASSIGN
       wop.currency = op-entry.currency
       dval         = op-entry.value-date
       wop.op-templ = op-templ.op-templ
       wop.op-kind  = op-kind.op-kind
       tcur         = op-entry.currency
    .

    {asswop.i}

    {g-acctv1.i &OFbase    = YES
                &vacct     = op-entry.acct
                &nodisplay = YES
                &OFsrch    = YES
                &nodef-GetAcct = YES                         
    }
    ASSIGN
       wop.acct-db = op-entry.acct-db
       wop.acct-cr = op-entry.acct-cr
    .
    IF (op-templ.prep-amt-rub <> ? AND op-templ.prep-amt-rub <> "") OR
       (op-templ.prep-amt-natcur <> ? AND op-templ.prep-amt-natcur <> "") THEN DO:
       RUN parssen.p (RECID(wop), in-op-date, OUTPUT vFlagErrlog).
       IF vFlagErrlog THEN UNDO CR_COM, LEAVE CR_COM.

       IF wop.amt-rub = 0 THEN DO:
          oError = NO.
          UNDO CR_COM, LEAVE CR_COM.  
       END.

       ASSIGN
          op-entry.amt-rub = wop.amt-rub
          op-entry.amt-cur = IF wop.currency NE "" AND wop.currency NE ? THEN
                             wop.amt-cur
                             ELSE
                             0
       .

       ASSIGN
          op.op-status       = "�"
          op-entry.op-status = "�"
       .
       RUN "edit(op).p" (in-op-date,
                         RECID(op),
                         RECID(op-entry),
                         RECID(op-kind),
                         op-template.op-template,
                         NO
                        ).
       IF RETURN-VALUE EQ "ERROR,UNDO" THEN UNDO CR_COM, LEAVE CR_COM.
       ASSIGN
          op.op-status       = op-template.op-status
          op-entry.op-status = op-template.op-status
       .
    END.
    oError = NO.
 END.

END PROCEDURE.
/******************************************************************************/

