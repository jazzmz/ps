/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2005 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: pir-SFPRN.I
      Comment: ����� ��ୠ�� ���⠢������ � �ਭ���� ��⮢-䠪���
		� ���ᨨ PIR ����ࠢ���� sf-in-[hdr,body,end] �� �।��� 㤠����� "��� ������ ���-䠪����"
   Parameters:
         Uses:
      Used by:
      Created: 15.06.2005 18:44 gorm    
*/
{globals.i}             /* �������� ��६���� ��ᨨ. */

DEF VAR mStrNum    AS INT64    NO-UNDO. /*���浪��� �����*/
DEF VAR mCustName  AS CHAR   NO-UNDO. /*����ࠣ���*/
DEF VAR mINN       AS CHAR   NO-UNDO. /*���*/
DEF VAR mKPP       AS CHAR   NO-UNDO. /*���*/
DEF VAR mAddr      AS CHAR   NO-UNDO. /*����*/
DEF VAR mAmtNoNds  AS DEC    NO-UNDO. /*�㬬� ��� ���*/
DEF VAR mAmtSf     AS DEC    NO-UNDO. /*�㬬� �� ������ ���*/
DEF VAR mAmtNds    AS DEC    NO-UNDO. /*�㬬� ���*/
DEF VAR mAmtSfAll  AS DEC    NO-UNDO. /*�⮣���� �㬬� ������ ���*/
DEF VAR mAmtNdsAll AS DEC    NO-UNDO. /*�⮣���� �㬬� ���*/
DEF VAR mConfDate  AS CHAR   NO-UNDO. /*��� ���-䠪����*/
DEF VAR mOpenDate  AS CHAR   NO-UNDO. /*��� ॣ����樨 ���-䠪����*/
DEF VAR mEndDate   AS CHAR   NO-UNDO. /*��� ����砭�� ���-䠪����*/
DEF VAR mUserName  AS CHAR   NO-UNDO. /*��� ���㤭���*/
DEF VAR mContType  AS CHAR   NO-UNDO.
DEF VAR mDocNum    AS CHAR   NO-UNDO.
DEF VAR hQuery     AS HANDLE NO-UNDO.
DEF VAR mSort      AS CHAR   NO-UNDO.
DEF BUFFER sfloan FOR loan.       /*����� ��� ��⮢-䠪���*/
DEFINE STREAM sfprn.              

/*����� ���*/
{getdates.i}

{setdest.i &cols=120 &STREAM="stream sfprn" }

{pir-sfprn.fun}
{tmprecid.def}
{pick-val.i}
{intrface.get tmess}    /* �����㬥��� ��ࠡ�⪨ ᮮ�饭��. */

DEFINE TEMP-TABLE ttUser NO-UNDO
         FIELD fUserId AS CHARACTER                        /* �����䨪��� �����      */
         INDEX fUserId fUserId
   .

/*�����*/
PUT STREAM sfprn UNFORMATTED
   FILL(" ",23) + mTitle SKIP
   FILL(" ",25) + "�� ��ਮ� � " + STRING(beg-date,"99/99/9999") + " �� " 
    + STRING(end-date,"99/99/9999") SKIP
   "                                     ����������    ����������" SKIP(1)
.
/*����� ��������*/
RUN sf-hdr.

ASSIGN
    mStrNum = 0
    mAmtSfAll = 0
    mAmtNdsAll = 0
    mUserName = ""
    .
CREATE QUERY hQuery.
FIND FIRST tmprecid NO-LOCK NO-ERROR.
RUN Fill-sysmes ("","","3","���ᮡ� ���஢�� ���-䠪����:|�� ��� ॣ����樨,�� ��� ���-䠪����,�� ������ ���-䠪����,�� ���ࠧ������� (�ᯮ���⥫�)").
CASE pick-value:
   WHEN "1" THEN mSort = "BY sfloan.open-date".
   WHEN "2" THEN mSort = "BY sfloan.conf-date".
   WHEN "3" THEN mSort = "BY sfloan.doc-num".
   WHEN "4" THEN mSort = IF AVAIL tmprecid THEN "BY sfloan.open-date" ELSE "".
END CASE.

IF AVAIL tmprecid
THEN DO:
   hQuery:SET-BUFFERS(BUFFER tmprecid:HANDLE,BUFFER sfloan:HANDLE).
   hQuery:QUERY-PREPARE("FOR EACH tmprecid NO-LOCK," 
                         +  " FIRST sfloan WHERE RECID(sfloan)    EQ       tmprecid.id "
                                         + " AND sfloan.filial-id EQ '" +  shFilial         + "'" 
                                         + " AND sfloan.contract  EQ '" +  mContract        + "'"
                                         + " AND sfloan.open-date GE "  +  STRING(beg-date) 
                                         + " AND sfloan.open-date LE "  +  STRING(end-date)
                         + " NO-LOCK " + mSort + ".").
END.
ELSE DO:
   RUN bran#ot.p("*",3).
   FIND FIRST tmprecid NO-LOCK NO-ERROR.
   IF AVAIL tmprecid 
   THEN DO:
      FIND FIRST branch WHERE RECID(branch) EQ tmprecid.id NO-LOCK NO-ERROR.
      {empty tmprecid}
      IF AVAIL branch 
      THEN DO:
         FOR EACH _User NO-LOCK:
            IF NOT AVAIL branch 
               OR GetXattrValue("_user",_User._Userid,"�⤥�����") EQ branch.Branch-Id 
            THEN DO:
               CREATE ttUser.
               ttUser.fUserId = _User._Userid.
            END.
         END.
         hQuery:SET-BUFFERS(BUFFER ttUser:HANDLE,BUFFER sfloan:HANDLE).
         hQuery:QUERY-PREPARE("FOR EACH ttUser NO-LOCK," 
                               +  " EACH sfloan WHERE sfloan.user-id   EQ       ttUser.fUserId "
                                              + " AND sfloan.contract  EQ '" +  mContract                + "'"
                                              + " AND sfloan.filial-id EQ '" +  shFilial                 + "'" 
                                              + " AND sfloan.branch-id EQ '" +  STRING(branch.Branch-Id) + "'" 
                                              + " AND sfloan.open-date GE "  +  STRING(beg-date) 
                                              + " AND sfloan.open-date LE "  +  STRING(end-date)
                               + " NO-LOCK " + mSort + ".").
      END.
   END. 
   ELSE DO:
      hQuery:SET-BUFFERS(BUFFER sfloan:HANDLE).
      hQuery:QUERY-PREPARE("FOR EACH sfloan WHERE sfloan.contract  EQ '" +  mContract        + "'"
                                               + " AND sfloan.filial-id EQ '" +  shFilial    + "'" 
                                               + " AND sfloan.open-date GE "  +  STRING(beg-date) 
                                               + " AND sfloan.open-date LE "  +  STRING(end-date)
                               + " NO-LOCK " + mSort + ".").
   END.
END.
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
/*������ �� �������*/
Block-loan:
DO WHILE NOT hQuery:QUERY-OFF-END:

   /* ���-䠪���� ��� ⨯� ��� � ��砫�� ����ᮬ - �� �⮡ࠦ��� */
   IF sfloan.cont-type = "" OR 
      sfloan.loan-status = "������" 
   THEN DO:
      hQuery:GET-NEXT().
      NEXT.
   END.
   
   /*��।��塞 �㬬� � ��� ���-䠪����*/
   RUN SFAmtServs IN h_axd (sfloan.contract,
                            sfloan.cont-code,
                            OUTPUT mAmtSf,
                            OUTPUT mAmtNds,
                            OUTPUT mAmtNoNds).
   
   ASSIGN 
       mAmtSfAll = mAmtSf + mAmtSfAll
       mAmtNdsAll = mAmtNds + mAmtNdsAll
       mStrNum = mStrNum + 1
       mConfDate = IF sfloan.conf-date <> ? 
                      THEN STRING(sfloan.conf-date,"99/99/9999")
                      ELSE ""
       mOpenDate = IF sfloan.open-date <> ? 
                      THEN STRING(sfloan.open-date,"99/99/9999")
                      ELSE ""
       mEndDate = IF sfloan.end-date <> ? 
                     THEN STRING(sfloan.end-date,"99/99/9999")
                     ELSE ""
       mContType = sfloan.cont-type
       mDocNum = sfloan.doc-num.
   
   /*��।��塞 ��� ����ࠣ���*/
   RUN SFAttribs_Seller IN h_axd (sfloan.contract,
                                  sfloan.cont-code,
                                  sfloan.cust-cat,
                                  sfloan.cust-id,
                                  OUTPUT mCustName,
                                  OUTPUT mAddr,
                                  OUTPUT mInn,
                                  OUTPUT mKpp).

   FIND _user WHERE _user._userid = sfloan.user-id 
       NO-LOCK NO-ERROR.
   IF AVAIL _user THEN mUserName = _user._user-name.

   RUN sf-body.
   hQuery:GET-NEXT().

END.
/*�����*/
RUN sf-end.

/*������*/
PUT STREAM sfprn UNFORMATTED SKIP(3).

{signatur.i
   &stream="STREAM sfprn"}

{preview.i &STREAM="STREAM sfprn"}
