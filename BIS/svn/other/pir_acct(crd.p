{pirsavelog.p}

/* ------------------------------------------------------
File          : $RCSfile: pir_acct(crd.p,v $ $Revision: 1.4 $ $Date: 2007-10-18 07:42:21 $
Copyright     : ��� �� "�p������������"
���������    : acct(crd.p
��稭�       : ���ᠭ�� � ����⥪� �������� ⮫쪮 ��� ���譨� ��室
�����祭��    : ��楤�� ��ᬮ�� � �롮� �������� ��⮢.
���� ����᪠ : �࠭����� ᯨᠭ�� � ����⥪� �2 070203
����         : Kuntash, Anisimov 
���������     : $Log: not supported by cvs2svn $
���������     : Revision 1.3  2007/09/21 09:49:07  lavrinenko
���������     : ���������� ᫥���騩 䨫��� - �⡨����� ⮫쪮 � ������� ��� �� ����� �뫮 ���᫥��� � ३� (�����㦥���� � ⥪�騩 ����) ��� �� �����⢨� ३� - ᮬ������ ���᫥��� �� �।��饣� �� ���. @
���������     :
���������     : Revision 1.2  2007/09/14 12:14:41  lavrinenko
���������     : 1. �������� �⠭����� ���������. 2. ����������� ���४⭮� ��।������ ����㯫���� � ����� ����
���������     :
���������     : 05/02/2007 ���襢 �.�. �ࠫ �����஢�� ���
���������     : 03/05/2006 Anisimov      ���뢠���� �����஢�� ��⮢ � ��᭨����� ���⪨
------------------------------------------------------ */
/*
                ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright:  (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename:  acct(crd.p
      Comment:  ��ᬮ�� � �롮� ��������ᮢ�� ��⮢, ࠡ����� � 㪠�����
                蠡����� ���. �室�騩 ��ࠬ��� - ��� 蠡���� ���. �ᯮ�� -
                ����� � ��楤�� ᯨᠭ�� � ����⥪� 2. ������砥��� �१
                �������⥫�� ४����� 蠡���� �஢���� � ����� "��抠�".
                ��� �롨����� �� ᫥���饬� �������:
                  �롨����� �� ��������ᮢ� ���, ࠡ���騥 �� 㪠�������
                蠡���� ���, �� ����� �⢥砥� ����� ���㤭�� ���
                ���稭���� ��� ���㤭���. �� �� ������뢠���� �� 㬮�砭��
                ��࠭�祭�� - ���⮪ �� ��� ������ ���� �⫨祭 �� ��� ��
                ��� ���� � �� ᮮ⢥�����饬 ��� �⮣� ������ �� ������
                �� ���� ������ ���� ���⮪.
         Uses:  -
      Used by:  gcrddec.p
      Created:  15/09/1999 eagle
     modified: 08/05/2002 kostik  0006764 ��ଠ� �����ᮢ��� ���⪠, ����� ��������ᮢ��
                                          ��⮢ � ��⮬ �ࠢ ���짮��⥫�
     modified: 03/05/2006 Anisimov  ���뢠���� �����஢�� ��⮢ � ��᭨����� ���⪨

*/
{globals.i}
{sh-defs.i}
{chkacces.i}
{intrface.get "acct"}
def input parameter in-code-value like code.code no-undo.

DEF VAR mOnlyUser    AS LOG  NO-UNDO.
DEF VAR mCurrentUser AS CHAR NO-UNDO.
DEF VAR mSum         AS DECIMAL INITIAL 0 no-undo.

mCurrentUser = userid('bisquit') + "," + getslaves().

&GLOB user-rights1 (   (    mOnlyUser                                 ~
                        AND LOOKUP(bfAcct.user-id,mCurrentUser) GT 0) ~
                    OR (    NOT mOnlyUser)                            ~
                    )

IF NUM-ENTRIES(in-code-value,"#") GT 1 THEN
   ASSIGN
      mOnlyUser = TRUE
      in-code-value = ENTRY(1,in-code-value,"#")
   .

def var vacct-cat   like acct.acct-cat no-undo.
def var long-acct   as char format "x(24)" no-undo.
def var comment_str as char label "                                   "  no-undo.
def var users       as char no-undo.
def var lstcont     as char initial "�����" no-undo.
def buffer bacct for acct.
def buffer bop-entry for op-entry.
def var dt-op   LIKE op-date.op-date INITIAL ? NO-UNDO.
def var summ-rr like op-entry.amt-rub no-undo.
def var vdebug as log init no no-undo.
def var ff-card as char no-undo.
DEF VAR name AS CHARACTER EXTENT 2 NO-UNDO.
DEF VAR Store-Position AS RECID NO-UNDO.
DEF TEMP-TABLE ttacct NO-UNDO
   FIELD acct        LIKE acct.acct
   FIELD acct-view   LIKE acct.acct  /* ����� ��� � ᮮ⢥�����饬 �ଠ� */
   FIELD bacct       LIKE acct.acct
   FIELD bacct-view  LIKE acct.acct  /* ����� ��� � ᮮ⢥�����饬 �ଠ� */
   FIELD curr        LIKE acct.curr
   FIELD name        AS   CHARACTER LABEL "������"
                             FORMAT "x(40)"
   FIELD rec-oa      AS   RECID /* ��� ��뫪� �� ��������ᮢ� ��� */
   FIELD obal        LIKE acct-pos.balance
   FIELD fobal       AS   LOG
   FIELD rec-ba      AS   RECID /* ��� ��뫪� �� �����ᮢ� ��� */
   FIELD bbal        LIKE acct-pos.balance
   FIELD fbbal       AS   LOG
   FIELD bbal-rub    LIKE acct-pos.balance /* ��� �஢�ப �� �ॢ�襭�� ����� */
   FIELD bbal-val    LIKE acct-pos.balance
INDEX acct   IS PRIMARY acct curr bacct
INDEX wacct             fobal fbbal acct curr bacct
.

find code where code.class eq "�������"
            and code.code  eq in-code-value
                           no-lock no-error.
if not avail code then return.
{kautools.lib}
ff-card = FGetSetting("�⠭���", "findcard2", "���").

/* PIR BEGIN ��।������ ���� ����㧪� ����㯫���� �� ��� */                                                                   
l-pack:                                                                               
    FOR EACH  Packet     WHERE Packet.PackDate         EQ gend-date   NO-LOCK,        
        FIRST PackObject WHERE PackObject.PacketID     EQ Packet.PacketID    AND      
                                  PackObject.kind      EQ 'ED211'            AND      
                                  PackObject.File-Name EQ 'op-entry' NO-LOCK,         
        FIRST bop-entry  WHERE bop-entry.op       EQ INT(ENTRY(1,PackObject.Surrogate)) AND 
                               bop-entry.op-entry EQ INT(ENTRY(2,PackObject.Surrogate))   
                               NO-LOCK:                                               
       dt-op = bop-entry.op-date.                                                     
       LEAVE l-pack.                                                                  
    END.                                                                              
                                                                                      
    IF dt-op EQ ? THEN DO:                                                            
       MESSAGE "�� �����㦥�� ����㧪� �����⥫쭮� �믨᪨ �� ��� !"                
         VIEW-AS ALERT-BOX TITLE "�������� !".  
       
       FIND LAST op-date WHERE op-date.op-date LT gend-date NO-LOCK NO-ERROR.
       dt-op = op-date.op-date.                                                         
    END.                                                                              
/* PIR END */                                                                         


&GLOB PROC-ACCT                                                                       ~
  RUN fdbacct( buffer acct, ff-card, in-code-value ).                                 ~
  FOR EACH buf-ttKau WHERE buf-ttKau.fTbName EQ "ACCTB" NO-LOCK,                      ~
    FIRST bacct WHERE RECID(bacct) EQ buf-ttKau.fRecId 	NO-LOCK,                      ~
    /* PIR BEGIN */                                                                   ~
    FIRST bop-entry WHERE bop-entry.acct-cr EQ bacct.acct                             ~
                      AND bop-entry.op-date EQ dt-op  NO-LOCK  /* PIR END */          ~
    BREAK BY bacct.acct :                                                             ~
      CREATE ttacct.                                                                  ~
      ASSIGN                                                                          ~
        ttacct.acct-view   = STRING(acct.acct,GetAcctFmt(code.misc[8]))               ~
        ttacct.rec-oa      = recid(acct)                                              ~
        ttacct.acct        = acct.acct                                                ~
        ttacct.curr        = acct.curr                                                ~
      .                                                                               ~
      RUN acct-pos IN h_base (ttacct.acct,                                            ~
                              ttacct.curr,                                            ~
                              gend-date,                                              ~
                              gend-date,                                              ~
                              "�").                                                   ~
      ASSIGN                                                                          ~
        ttacct.obal  = IF ttacct.curr > "" THEN sh-val                                ~
                                            ELSE sh-bal                               ~
        ttacct.fobal = ttacct.obal NE 0                                               ~
      .                                                                               ~
      ASSIGN                                                                          ~
          ttacct.rec-ba = recid(bacct)                                                ~
      .                                                                               ~
      RUN acct-pos IN h_base (bacct.acct,                                             ~
                              bacct.curr,                                             ~
                              gend-date,                                              ~
                              gend-date,                                              ~
                              "�").                                                   ~
/* PIR BEGIN */                                                                       ~
      mSum = 0.                                                                       ~
      FOR EACH loan-acct WHERE loan-acct.acct = bacct.acct NO-LOCK,                   ~
          LAST term-obl WHERE term-obl.cont-code = loan-acct.cont-code AND            ~
                                  ( (term-obl.idnt = 2) OR (term-obl.idnt = 22) ) AND ~
                                  term-obl.contract EQ loan-acct.acct-type NO-LOCK:   ~
               mSum = mSum +  term-obl.amt-rub.                                       ~
      END. /* PIR END */                                                              ~
      ASSIGN                                                                          ~
          ttacct.bacct-view = STRING(bacct.acct,GetAcctFmt(code.misc[8]))             ~
          ttacct.bacct      = bacct.acct                                              ~
          ttacct.rec-ba     = RECID(bacct)                                            ~
          ttacct.name       = IF acct.cust-cat EQ "�" THEN (name[1] + " " + name[2])  ~
                                                  ELSE (name[1] +  " " + name[2])     ~
          ttacct.bbal       = IF bacct.curr  GT "" THEN sh-val ELSE sh-bal            ~
          ttacct.fobal      = IF ttacct.obal GT 0  THEN yes    ELSE no                ~
/* PIR */ ttacct.fbbal      = IF (ttacct.bbal - mSum) LT 0  THEN yes    ELSE no       ~
          ttacct.bbal-rub   = sh-bal                                                  ~
          ttacct.bbal-val   = sh-val                                                  ~
      .                                                                               ~
  END.


RUN SelectAcctOfKauId(code.code).
/* ���������� �६����� ⠡���� */
FOR EACH ttKau WHERE ttKau.fTbName EQ "ACCT" NO-LOCK,
    FIRST acct WHERE RECID(acct) EQ ttKau.fRecId NO-LOCK:
   {getcust.i &name=name &Offinn="/*"}
   {&PROC-ACCT}
END.


FORM
   ttacct.acct-view FORMAT "x(25)"
               HELP "��������ᮢ� ���"
               SPACE(5)
   ttacct.obal COLUMN-LABEL "������� ��!������������� �����"
               HELP "���⮪ �� ��������ᮢ�� ���"
   ttacct.bbal COLUMN-LABEL "������� ��!���������� �����"
               HELP "���⮪ �� �����ᮢ�� ���"
WITH FRAME BROWSE1
     TITLE COLOR BRIGHT-WHITE "[ ������� ����� �� ��������� �� " + STRING(gend-date) + " ]"
     WIDTH 79.

FORM
   ttacct.acct-view  FORMAT "x(25)"
                HELP "��������ᮢ� ���"
   ttacct.bacct-view FORMAT "x(25)"
                COLUMN-LABEL  "!���� �� �������"
                HELP "�����ᮢ� ���"
   ttacct.obal  COLUMN-LABEL "������� ��!������������� �����"
                HELP "���⮪ �� ��������ᮢ�� ���"
WITH FRAME BROWSE2
     TITLE COLOR BRIGHT-WHITE "[ ������� ����� �� ��������� �� " + STRING(gend-date) + " ]"
     WIDTH 79.

FORM
   ttacct.acct-view  FORMAT "x(25)"
                HELP "��������ᮢ� ���"
   ttacct.name  FORMAT "x(47)"
                COLUMN-LABEL "!������������ �����"
                HELP "������������ (��������) ��楢��� ���"
WITH FRAME BROWSE3
     TITLE COLOR BRIGHT-WHITE "[ ������� ����� ]"
     WIDTH 79.


&glob oqry0 open query qry0 for each ttacct where ttacct.fobal and ttacct.fbbal no-lock.
&glob oqry1 open query qry0 for each ttacct where ttacct.fobal no-lock.
&glob oqry2 open query qry0 for each ttacct no-lock.

release ttacct.

{navigate.cqr
   &file     = ttacct
   &files    = "ttacct"
   &qry      = "qry0"
   &maxoq    = 3
   &avfile   = "ttacct "
   &defquery = "def query qry0 for ttacct scrolling."
   &maxfrm   = 3
   &bf1      = "ttacct.acct-view ttacct.obal ttacct.bbal "
   &bf2      = "ttacct.acct-view ttacct.bacct-view ttacct.obal "
   &bf3      = "ttacct.acct-view ttacct.name "
   &workfile = "/*"
   &nodel    = "/*"
   &look     = "acct(crd.nav "
   &return   = "acct(crd.ret "
   &oh3      = "�F3"
   &oth3     = "acct(crd.f3 "
   &oh6      = "�F6"
   &oth6     = "acct(crd.f6 "
   &oh2      = "�F2-��⠫�����"
   &oth2     = "acct(crd.f2 "
   &oh7      = "�F7"
   &oth7     = "findsp.cqr "
     &find1  = "searchsp.cqr  &file-name = ttacct   ~
                              &sfld      = acct     ~
                              &metod     = matches  ~
               "             
     &find2  = "searchsp.cqr  &file-name = ttacct   ~
                              &sfld      = bacct    ~
                              &metod     = matches  ~
               "             
     &find3  = "searchsp.cqr  &file-name = ttacct   ~
                              &sfld      = name     ~
                              &metod     = matches  ~
                              &metmatch  = YES      ~
               "             

}

/*
   &n-str=num-line

   &oh2="�F3 �ଠ"
   &oth2="op-frm.chg "
*/
{intrface.del "acct"}
RETURN.
