/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2002 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: tr-db(l.p
      Comment: �㡠����⪠ �� ������ࠬ. (�।� �ॡ������ �� ���᫥��� %%)
   Parameters: 
      Created: ??? ??/??/???? 
     Modified: Om  17/04/02 �訡��: - ᮧ����� ����樨 �� �������� ����,
                                    - �ଠ�஢���� ����.
     Modified: ���� 30/10/02 ���������� �� ��� ��ᢠ������ ����⠭� ���祭�� lr-st
                              �. svarloan.def ���ᨢ ����� ����������, � ������ �� ���
                              ����� �����쭮 �殮��
     Modified: 24/01/2003 Om ��ࠡ�⪠: �஢�ઠ ����権 �� "�祭��".
     Modified: 31/03/2003 Om ��ࠡ�⪠: �᫨ ��� �� �� ᮢ������ � ��������
                                        ��⮩, � ����訢��� ���⢥ত���� �
                                        ������������ ᪮�४�஢��� ����.
     Modified: 11/08/2003 Om �訡��: �᫨ �������� ��� ���㬥�� �� ᮢ������
                                     � ��⮩ ����樮����� ���, � �ந��������
                                     ����� ����. ��᫥ �����, �����⢫����
                                     �஢�ઠ �� �, �� ��� ������ �������
                                     ����� ���� ࠢ�� ����訢�����.
     Modified: 20/01/2005 ���� - ������ ��।����
                                  ���� �� �⠫ ᫨���� �� ��楤��� �����⨪�
                                  � ����, ��� �� �祭� ᨫ쭮 ����訢�����
                                  �㡫�஢���� ���� 㦠᭮�, �� ��� �� ᤥ����
                                  ����ᨢ�� ���� �� ����

*/
Form "~n@(#) tr-cr(l.p 1.0 ??? ??/??/???? Om 07/04/2002 "
with frame sccs-id stream-io width 250.

{svarloan.def NEW GLOBAL}
{globals.i} /* ������祭�� ��������� ��६�����/�����㬥�⮢ ��ᨨ */
{pick-val.i}          /* ����室��� ��� �롮� ������஢ */
{intrface.get xclass} /* ����㧪� �����㬥�⮢ �� ࠡ�� � ����奬�� */
{intrface.get db2l}   /* �������᪠� ࠡ�� � ��  */
{intrface.get loan}   /* �����㬥��� ��� �।�⮢  */
{intrface.get lv}
{intrface.get rights} /* �஢�ઠ �ࠢ  */
{intrface.get tmess}  /* ��㦡� ᮮ�饭�� */
{loanint.pro}         /* ��楤��� ࠡ��� � �����ﬨ �� ��������. */
{loankau.pro}         /* ��楤��� ��� �㡠����⨪� �� ������. */

&GLOB isk '2,4,5'
/* ᯨ᮪ 蠡����� ���, ��ࠡ��뢠��� �।��� � �������� ������� */
&GLOB shabl_kau '�������,��������,�।�,����'

&GLOB RET_ERR  DO: ~
                  ~{intrface.del~} ~
                  pick-value = 'NO'. ~
                  RETURN mRetErr. ~
               END.

&GLOB RET_OK   DO: ~
                  ~{intrface.del~} ~
                  pick-value = 'YES'. ~
                  RETURN. ~
               END.

DEF INPUT PARAM iRidEntry AS RECID NO-UNDO. /* �����䨪��� �஢���� */
DEF INPUT PARAM iSide     AS LOG   NO-UNDO. /* */

DEF VAR mCh AS LOG INIT YES.

DEF VAR mCurDate   AS DATE  NO-UNDO.
DEF VAR mLoanSince AS DATE NO-UNDO.

DEF VAR mHOp       AS HANDLE NO-UNDO. /*�����⥫� �� ���㬥��*/
DEF VAR mHEntry    AS HANDLE NO-UNDO. /*�����⥫� �� �஢����*/
DEF VAR mHAcct     AS HANDLE NO-UNDO. /*�����⥫� �� ��� �஢����*/
DEF VAR mHCAcct    AS HANDLE NO-UNDO. /*�����⥫� �� ��� ���*/
DEF VAR mHLoanAcct AS HANDLE NO-UNDO. /*�����⥫� �� ��� ��� � �������*/
DEF VAR mRidOp     AS RECID  NO-UNDO. /*recid ���㬥�� */

DEF VAR mAcct     AS CHAR  NO-UNDO. /*��� ��襩 ��஭� �஢���� */
DEF VAR mCurr     AS CHAR  NO-UNDO. /*����� ��� ��譥� ��஭� �஢����*/
DEF VAR mCorrAcct AS CHAR  NO-UNDO. /*��� ��㣮� ��஭�*/
DEF VAR mCorrCurr AS CHAR  NO-UNDO. /*����� ��� ��㣮� ��஭�*/
DEF VAR mCorrKau  AS CHAR  NO-UNDO. /*��� ��� ��㣮� ��஭�*/
DEF VAR mKauEnt   AS CHAR  NO-UNDO. /*��� ��㣮� ��஭� �஢����*/
DEF VAR mKau      AS CHAR  NO-UNDO. /*��� ��襩 ��஭� �஢����*/
DEF VAR mKauCalc  AS CHAR  NO-UNDO. 
DEF VAR mOpCode   AS CHAR  NO-UNDO.
DEF VAR mTStr     AS CHAR  NO-UNDO.
DEF VAR mList     AS CHAR  NO-UNDO.
DEF VAR mAcctSide AS CHAR  NO-UNDO.

DEF VAR mLastContract AS CHAR NO-UNDO. /* �����䨪��� ������� */
DEF VAR mLastContCode AS CHAR NO-UNDO. /*    ��� �ਢ離�        */
DEF VAR mCodeInt      AS CHAR NO-UNDO. /* ������ ��� �ਢ離�  */
DEF VAR mAutoLink     AS LOG  NO-UNDO. /* ���祭�� �� ���ਢ    */
DEF VAR mOperFlag     AS LOG  NO-UNDO. 
DEF VAR mSkipOper     AS LOG  NO-UNDO.
DEF VAR mRetErr       AS CHAR NO-UNDO.

/*kmy*/
DEFINE VARIABLE mAutoLinkCalc AS LOGICAL NO-UNDO.  
mAutoLinkCalc = CAN-DO("yes,true,ok,��", fGetSetting("���ਢ����", ?,"���")).

DEF NEW SHARED STREAM err.

{loankau.us}
{loankau.ds}

/* ����  �஢����, ���㬥��, ���, ����ᯮ������饣� ��� */
RUN FindEntities(iRidEntry,
                 iSide,
                 OUTPUT mHOp,
                 OUTPUT mHEntry,
                 OUTPUT mHAcct,
                 OUTPUT mHCAcct,
                 OUTPUT mRidOp).

IF NOT VALID-HANDLE(mHOp)    OR
   NOT VALID-HANDLE(mHEntry) OR
   NOT VALID-HANDLE(mHAcct)  THEN
{&RET_OK}

ASSIGN
   mAcct     = GetValue(mHAcct,"acct")
   mCurr     = GetValue(mHAcct,"currency")
   mAcctSide = GetValue(mHAcct,"side")

   mKauEnt = GetValue(mHEntry,"kau-cr")  WHEN     iSide
   mKauEnt = GetValue(mHEntry,"kau-db")  WHEN NOT iSide

   mKau = GetValue(mHEntry,"kau-db")  WHEN     iSide
   mKau = GetValue(mHEntry,"kau-cr")  WHEN NOT iSide

   mCorrAcct = GetValue(mHCAcct,"acct")     WHEN VALID-HANDLE(mHCAcct)
   mCorrCurr = GetValue(mHCAcct,"currency") WHEN VALID-HANDLE(mHCAcct)
   mCorrKau  = GetValue(mHCAcct,"kau-id")   WHEN VALID-HANDLE(mHCAcct)

   mAutoLink = CAN-DO("yes,true,ok,��", fGetSetting("���ਢ", ?,"���")).
   .

/* �㡠����⨪� 㦥 ᮧ���� */
IF {assigned mKau} THEN {&RET_OK}

/**
 * �᫨ �믮������ ����ୠ� �ਢ離�,
 * � ��祣� �� ������. �������筠�
 * ��� � ���� 0164291.
 *
 * ����: ��᫮� �. �. Maslov D. A.
 * ��� ᮧ�����: 20.09.12
 * ���: #956
 *
 **/

IF VALID-HANDLE(mHCAcct) AND CAN-DO({&shabl_kau},mCorrKau) AND ({assigned mKauEnt}) AND CAN-DO(FGetSetting("���᪏��‭","" ,""),ENTRY(3,mKauEnt)) THEN {&RET_OK}

/** ����� #956 **/


/* ���짮��⥫� �� ᮧ���� �㡠����⨪� */
IF GetValue(mHEntry,"user-id") = "SERV" AND
   USERID("bisquit")           = "SERV"
THEN  {&RET_OK}

/* ��।������ ���� ����樨. */
mCurDate = IF GetValue(mHEntry,"prev-year") = "YES"

           /* �᫨ ��, � � ������ ᮧ���� �� ᮮ⢥�������� ���� */
           THEN DATE(12,31,YEAR(DATE(GetValue(mHOp,"op-date"))) - 1)

           /* �������� ��� ���㬥�� */
           ELSE DATE(GetValue(mHOp,"contract-date")).

/* �饬 ��᫥���� �ਢ離� ��� */
RUN GetLastLinkAcctTr(mAcct,mCurr,mCurDate,mAcctSide,OUTPUT mHLoanAcct).

IF NOT VALID-HANDLE(mHLoanAcct) THEN {&RET_OK}

/* ����� ��襣� �������稪� */
ASSIGN
   mLastContract = GetValue(mHLoanAcct,"contract")
   mLastContCode = GetValue(mHLoanAcct,"cont-code")
   mKauCalc  = ""
   mOpCode   = ""
   mSkipOper = NO
   .

/*kmy*/
IF mAutoLinkCalc THEN DO:
   mKauCalc = getAutoKau(mCurDate, iSide).
   IF mKauCalc <> ? THEN
      IF mKauCalc <> "" THEN
         IF NUM-ENTRIES(mKauCalc) = 3 THEN DO:
            mOpCode   = TRIM(ENTRY(3,mKauCalc)).
            IF mOpCode = "" THEN  mSkipOper = YES.
         END.
END.

IF mAutoLinkCalc AND mSkipOper THEN {&RET_OK}

/* ������塞 ⠡���� � ��ﬨ ���  � ������ࠬ� */
RUN FillLocalTTRole(mAcct,mCurr,mCurDate,OUTPUT mList).
/* ������塞 ⠡���� � ��ﬨ ஫�� ��⮢  � �����ﬨ */
RUN FillLocalTTOper(mList,iSide,mOpCode).

/* ����樨 ��� - ��祣� �� ������ */
IF NOT CAN-FIND(FIRST ttOperRole) THEN {&RET_OK}

/* �᫨ �� ����஢����, � �஡㥬 ��ࠡ���� ��� �����業�� ���㬥�� */
IF NOT VALID-HANDLE(mHCAcct) THEN
DO:
/* �஢�ਬ ����� �� ᮡ��� ������ �஢����? */
   RUN FindSecondOpEntry(mLastContract,
                         mLastContCode,
                         mCurDate,
                         iSide,
                         mHOp,
                  OUTPUT mOperFlag).
   IF mOperFlag THEN
   DO:
/* ᮡ�⢥��� �⠢�� ���㬥�� �� �����⨪�. */
      RUN CrKauForFulOpEn(mLastContract,
                          mLastContCode,
                          mAcct,
                          mCurr,
                          mCurDate,
                          iSide,
                          mHOp,
                          mHEntry,
                   OUTPUT mOperFlag).
      IF mOperFlag THEN {&RET_OK}
   END.
END.

IF    NOT mAutoLink 
  AND work-module         NE "factor" THEN 
DO:
   RUN Fill-SysMes IN h_tmess("",
                              "",
                              "4",
                              "�������� �ਢ離� �஢����, "  +
                              (IF iSide 
                                  THEN "�������饩 ��� " 
                                  ELSE "�।����饩 ��� " ) +
                              delFilFromAcct(mAcct) + "~n � " + (IF mLastContract = "�।��"
                                                                    THEN "�।�⭮��"
                                                                    ELSE "������⭮��") +
                              " ��������.�㤥� �����⢫���?").

   IF LASTKEY = KEYCODE("Esc") THEN DO:
      mRetErr = "�믮������ ��ࢠ�� �� ���樠⨢� ���짮��⥫�".
      {&RET_ERR}
   END.

   IF work-module = "factor" THEN 
      pick-value = "NO".

   IF pick-value NE "YES" THEN {&RET_OK}
END.

pick-value = "yes".

RUN ChkOpRights.

IF RETURN-VALUE = "EXIT" THEN DO:
   mRetErr = "�������筮 �ࠢ ��� �믮������ ����樨".
   {&RET_ERR}
END.

/* �롨ࠥ� ������� � ������ */
define variable mSkip as logical no-undo.
RUN InputLoan(INPUT-OUTPUT mLastContract,
              INPUT-OUTPUT mLastContCode,
              mCurDate,
              iSide,
              YES,
              OUTPUT mCodeInt,
              output mSkip).

if mSkip then /*�� ᮧ������ ��.���������� �஢����*/
do:
   pick-value = "yes".
   return.
end.

IF mLastContCode = "" THEN DO:
   mRetErr = "�믮������ ��ࢠ�� �� ���樠⨢� ���짮��⥫�".
   {&RET_ERR}
END.

mLoanSince = DATE(GetBufferValue(
        "loan",
        "
        WHERE loan.contract = '" + mLastContract + "'
          AND loan.cont-code = '" + mLastContCode + "'",
        "since")).

pick-value = "yes".

/* �������� �㡠����⨪� */
IF IsBindEarlier(mCurDate,mLoanSince)
THEN DO TRANSACTION
   ON ERROR  UNDO, RETRY
   ON ENDKEY UNDO, RETRY:

   IF RETRY AND LASTKEY = KEYCODE("Esc") THEN
      mRetErr = "�믮������ ��ࢠ�� �� ���樠⨢� ���짮��⥫�".
   IF RETRY THEN {&RET_ERR}

   /* ���४�஢�� �������� ���� � ������ ���ﭨ� ������ �ந�室��� ࠭�� 
      �ନ஢���� �㬬 ����樨, ���� �㬬� ���� ��ନ஢���� �� ���� �� ������,
      � �� �� �������� ���� ( ⥬ ����� ᪮�४�஢����� ) */

   /* ����祭�� �������� ���� ����樨 */
   IF GetSysConf("DisplayOFF") EQ "YES" 
   THEN 
      RUN Fill-SysMes IN h_tmess ("", "", "", "�������� ���: " + STRING(mCurDate,"99/99/9999") + ".").
   ELSE
      RUN UpdContract (mLastContract,    /* �����祭�� �������. */
                       mLastContCode,    /* ����� �������. */
                       mCurDate,         /* �������� ��� ���㬥��. */
                       mCodeInt,         /* ������ */
                       OUTPUT mCurDate). /* ��ୠ� ��� ���㬥��. */

   /* ��ࠡ�⪠ �訡��. */
   IF RETURN-VALUE NE "" THEN 
   DO:
      mRetErr = RETURN-VALUE.
      UNDO, RETRY.
   END.

   /* ���⢥ত���� ����� ���㬥��. */
   IF GetSysConf("DisplayOFF") NE "YES" 
   THEN DO:
   
      RUN ConfirmAction ( mRidOp,                 /* �����䨪��� �������.  */
                          INPUT-OUTPUT mCurDate). /* �������� ��� ���㬥��. */

      /* ��ࠡ�⪠ �訡��. */
      IF RETURN-VALUE NE "" THEN
      DO:
         mRetErr = RETURN-VALUE.
         UNDO, RETRY.
      END.
   END.
   /* ���४�஢�� �������� ���� ����樨. */
   RUN SetLIntDate (mCurDate).

   /* ������ ������� �� ���⢥ত����� �������� ����. */
   IF mCurDate <> mLoanSince THEN 
      RUN LoanCalc (mLastContract,    /* �����祭�� �������. */
                    mLastContCode,    /* ����� �������. */
                    mCurDate).        /* �������� ��� ����㬥��. */

   IF mCurDate <> DATE(GetBufferValue("loan","WHERE loan.contract = '" + mLastContract + "'
                                                AND loan.cont-code = '" + mLastContCode + "'",
                                      "since")) THEN
   DO:
      RUN Fill-SysMes IN h_tmess ("","","","��� �஢���� �� ࠢ�� ��� ������ ���ﭨ� �������. �� ��離� �������� �訡��. �����⠩� �������.").
      mRetErr = "no_mess".
      UNDO, RETRY.   
   END.
   /* � ⮫쪮 ⥯��� �ନ�㥬 ����� �� ����樨 */

   /* ��ନ஢���� ����� ����� ��� ᮧ�����.
   ** ��।������ �㬬� � ������ ����権. */
   RUN GetOper (iRidEntry,      /* �����䨪��� �஢����. */
                mLastContract,  /* �����祭�� �������. */
                mLastContCode,  /* ����� �������. */
                mCurDate,       /* �������� ��� ���-�. */
                mCodeInt,       /* ��� ���� ����樨. */
                YES).

   /* ��ࠡ�⪠ �訡��. */
   IF RETURN-VALUE NE ""
   THEN DO:
      MESSAGE
          COLOR MESSAGES
          RETURN-VALUE
      VIEW-AS ALERT-BOX.
      mRetErr = "no_mess".
      UNDO, RETRY.
   END.

   /* �맮� ��⮤� �஢�ન ����樨 �� ����奬�.
   ** ������ �����।�⢥��� ��। ᮧ������ ����樨,
   ** ��-�� �஢�ન �뫨 ��᫥ ���⢥ত���� �㬬� � �������� ���� */
   RUN RunChkMethod (mLastContract,  /* �����祭�� �������. */
                     mLastContCode,  /* ����� �������. */
                     iRidEntry,  /* �����䨪��� �஢����. */
                     mCodeInt).  /* ��� ����樨 �����⥬���� ���. */

   /* ��ࠡ�⪠ �訡��. */
   IF RETURN-VALUE NE ""
   THEN DO:
      mRetErr = RETURN-VALUE.
      UNDO, RETRY.
   END.

   /* �������� ����樨. */
   RUN CreLInt (mLastContract,  /* �����祭�� �������. */
                mLastContCode). /* ����� �������. */

   /* ��ࠡ�⪠ �訡��. */
   IF RETURN-VALUE NE ""
   THEN DO:
      MESSAGE
          COLOR messages
          RETURN-VALUE.
      mRetErr = "no_mess".
      UNDO, RETRY.
   END.

   /* �������� �㡠����⨪� �� �஢����. */
   RUN CreEntryKau(iRidEntry, /* �����䨪��� �஢����. */
                   mLastContract,  /* �����祭�� �������. */
                   mLastContCode,  /* ����� �������. */
                   mCodeInt,   /* ��� ���� ����樨. */
                   NOT iSide,  /* ��஭� ��� Yes - �।��. */
                   mCurDate).  /* ��ୠ� �������� ��� ���㬥��. */

   /* ��ࠡ�⪠ �訡��. */
   IF RETURN-VALUE NE ""
   THEN DO:
      IF RETURN-VALUE BEGINS "lock"
      THEN RUN wholock(IF RETURN-VALUE EQ "lock_op"
                       THEN mRidOp
                       ELSE iRidEntry, "").
      ELSE MESSAGE
              COLOR messages
              RETURN-VALUE
           VIEW-AS ALERT-BOX.                
      mRetErr = "".
      UNDO, RETRY.
   END.
   mRetErr = "".
END.
ELSE
DO:
   pick-value = "NO".
   mRetErr = "�믮������ ��ࢠ�� �� ���樠⨢� ���짮��⥫�".
END.


{intrface.del}

RETURN  mRetErr.