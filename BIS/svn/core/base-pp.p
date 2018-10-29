/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) MCMXCII-MCMXCIX ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: BASE-PP.P
      Comment: �����⥭⭠� ��楤��, ᮤ�ঠ�� �᭮��� ��⥬�� �㭪樨
   Parameters: ���饭�� �१ handle h_base
         Uses:
      Used by: ���樠������ � bislogin.i
      Created: 09/11/99 serge
     Modified: 09/06/2001 shin - ������� ���㫥��� ��� ��㯯���� ����
     Modified: 27/04/2002 NIK  - ��������� �㭪樨 FGetSetting*
     Modified: 09/03/2003 AVAL - ��������� �㭪�� SetValue
     Modified: 11.02.2003 17:14 DEMA     (0012943) �㭪樨 ࠡ��� � ��஫ﬨ
                                         ��७�ᥭ� � pp-right.p
     Modified: 22.04.2004 08:59 KSV      (��.�������樨) ��ࠢ����
                                         FChkClsDate.
     Modified: 11.08.2004 14:40 KSV      (0034252) ��䠪�ਭ� ��楤���
                                         SetValue.
     Modified: 07.10.2004 10:15 Om  �訡��.
                  SetValue ����୮ ��ࠡ��뢠�� ���祭�� ��� �����᪮�� ⨯�.
     Modified: 14.07.2005 16:09 KSV      (0047805) ��������� ��楤��
                                         ResetReturnValue, �믮������ ���
                                         ��ਡ�� RETURN-VALUE.
     Modified: 27.07.2005 14:29 Om  ��ࠡ�⪠.
                        ��������� ��楤�� �뢮�� �������� �த��.
     Modified: 17.08.2005 18:23 KSV      (0050131) ������祭 ��⥬�� ���
     Modified: 07.08.2005       TSL    �����䨫���쭮��� � FChkClsDate � FGetLastClsDate
     Modified: 28.05.2006 13:14 KSV      (0042082) ��ࠡ�⠭� WhoLocks ���
                                         �஢�ન ����஢�� �१ ��⥪� ���
                                         ORACLE
     Modified: 15.09.2006 15:39 Vasov    (0064604) ��������� �㭪�� GetBankInn
     Modified: 24.10.2007 18:06 MUTA     0082119 ��������� ������⢥����� ��� 業��� �㬠� � ������� ���㫥
     Modified: 25.07.2008 12:29 KSV      (0095920) ��ࠢ���� RemHeaderMark   
     Modified: 19.11.2008 13:02 KSV      (0100636) �������� �窠 ����祭��
                                         sysconf, �.�. ��� QBIS �� �ॡ��
                                         ����㦥��� pp-tmess
     Modified: 11.03.2009 20:15 ariz     ��������� GetTempXAttrValueEx � �裡
                                         � ��७�ᮬ �࠭���� ���祭�� ⥬���஢�����
                                         ४����⮢ � ⠡���� tmpsigns.
     Modified: 25.03.2010 16:26 ksv      (0110628) + ��⮤� �ࠢ����� ᥬ��஬
                                         CloseOnGo                                        
     Modified: 11.06.2010 15:42 ksv      (0129286) ��ࠢ��� WhoLocks
     Modified: 24.12.2010 11:31 krok     (0133053) ������� GetCBDocType.
                                         �ᯮ���� GetDocTypeDigitalEx �� pp-op.p
     Modified: 23.01.2011 13:03 ksv      (0140791) ��⨬����� WhoLocks
  ��楤���/�㭪樨:
     CheckHandle

     Acct-Pos - ����祭�� ���⪮� � ����⮢ �� ��
     Cli-Pos  - ����祭�� ���⪮� � ����⮢ �� �� �����⮢
     Acct-Qty - ����祭�� ������⢠ 業��� �㬠� �� ����

     CurrCode

     term2str - �����頥� ���筮� ������������ ��ਮ��
     per2str  - �����頥� ���筮� ������������ ⨯� ��ਮ��

     SetModule - ��⠭�������� ⥪�騩 �����
     GetModule

     GetCust
     GetUserBranchId - ���� ���� ���ࠧ������� �� ���짮��⥫�

     CheckOpKNF      - �஢�ઠ ���㬥�� �� ������樨 93-�
     CheckKNF        - �஢�ઠ ४����⮢ �� ������樨 93-�

     GetXAttrValue   - ������ ���祭�� ���४�����
     GetXAttrValueEx - ������ ���祭�� ���४�����
     
     GetTempXAttrValueEx - ������� ���祭�� ���������������� ���४����� 
                           �� ������������ ���� � ��⮬ ���祭�� �� 㬮�砭��
     GetTempXAttrValueEx - ������� ���祭�� ���������������� ���४�����
                           �� ���������� ����. �᫨ �� ������, � �����頥� ���⮥ ���祭��
     
     GetXAttrSurr    - �����頥� ᯨ᮪ ��ண�⮢ �� ���祭��

     FGetSetting     - ������ ���祭�� ����ன��
     FGetSettingEx   - ������ ���祭�� ����ன�� � ��⮬ message mode.

     SetValue        - �ਢ������ ���祭�� � �ଠ��;
                       �� �訡�� - �ନ஢���� ᮮ�饭�� � ���⠢����� �ਧ���� �訡��
     SearchPfile     - �஢�ઠ ������ r-���� ��� p-���� �� Propath
     Holiday         - �஢�ઠ ���� �� ���� ��ࠡ�稬

     GetBank         - ���� ����� �� �����䨪���� � ��� ���祭��
     GetBankInn      - ����祭�� ��� �����
     GetTrueCodeType - �����頥� ��� த�⥫�᪮�� �����䨪��� ��� bank-code-type
     WhoLocks        - �����頥� ��, �᫨ 㤠���� ��।����� �� ��ন� ������
                       ��室�� ��ࠬ��஬ ���� ���ଠ樮���� ��ப�
     GetAttrValueOnDate   - ��।������ ���祭�� ४����� ��ꥪ� �� �������
                            ������ �६��� �� ��ୠ�� ���������
     GetAttrValueOnDateEx - ����ୠ⨢�� ��ਠ�� �맮�� GetAttrValueOnDate
  �����㬥��� ��� �஢�ப �� ������-������� ���� � ���������� ᮢ��襭�� ����権 :

     CheckOpRight      - �஢�ઠ �ࠢ �� ᮢ��襭�� ��।������� ����樨 � ���㬥�⮬
                         � ���भ�
     CheckOpEx         - �஢�ઠ ��।������� �ࠢ �� ���㬥��
     CheckOpDateEx     - �஢�ઠ ��।������� �ࠢ �� ���थ��

     ��ॢ����� �� �ᯮ�짮����� CheckOpEx,CheckOpDateEx:
        CheckDate         - �஢�ઠ �� ��� � ����।������� ��⥣�ਨ � ᮮ�饭��� (chkdate.i chkdate1.i)
        CheckDateNoMsg    - �஢�ઠ �� ��� � ����।������� ��⥣�ਨ ��� ᮮ�饭��
        CheckCatDateNoMsg - �஢�ઠ �� ��� � ��।������� ��⥣�ਨ
        CheckOpDate       - �஢�ઠ �� ���㬥��� (chkdate2.i)


     FChkClsDate     - ����஫� �������� ��� (�����頥� YES, NO)
     FGetLastClsDate - �����頥� ���� ��᫥����� �����⮣� ���, �� ��।����� ����
*/
{globals.i}

h_base = THIS-PROCEDURE.

{sh-defs.i}
{zo-defs.i}

{intrface.get cache}
{getsett.fun}
{gstag.i}               /* ����� � ��ப�� � ⥣���� �ଠ�. */
{intrface.get xclass}
{intrface.get rights}
{intrface.get separate} /* �����㬥��� ��� �஢�ન ���������� ᮢ��襭�� ����樨 */
{intrface.get tmess}    /* �����㬥��� ��ࠡ�⪨ ᮮ�饭��. */
{intrface.get osyst}    /* �����㬥��� ��� ࠡ��� � Oracle (��⥬��) */
{intrface.get isrv}     /* �����㬥��� ��� ࠡ��� � ����७��� ���稪��(⮫쪮 ��� oracle) */
{intrface.get db2l}
{intrface.get hist}

/* Commented by KSV: ��� QBIS �ॡ�� ����㦥����� pp-tmess.p */
{sysconf.i} /*������⥪� ��楤�� ��� ࠡ��� � ����७��� ⠡��楩 SysConf*/

def var codenatcurr  like  currency.currency no-undo.
def var balschinn    as    char              no-undo.
def var bank-inn     as    char              no-undo.

ASSIGN
   codenatcurr = FGetSetting("�����悠�",?,"")
   balschinn   = FGetSetting("����爍�",?,?)
   bank-inn    = FGetSetting("���",?,?)
.

{userfunc.i} /* �㭪樨 ��� ࠡ��� � ���. ४����⠬� ����� _User */
{getcust.pro}
{getbank.pro}
{filial.pro}            /* �����㬥��� ��� ࠡ��� � �����䨫���쭮� ��. */
{mf-loan.i}             /* �㭪樨 addFilToLoan � delFilFromLoan �८�ࠧ������
                        ** ����� loan.doc-ref � loan.cont-code � �������. */
{xattrtmp.def}          /* ������ ᮤ�ন� ���祭� ⥬��ࠫ��� ��. */

&GLOBAL-DEFINE def-stream-log YES /* �६���� */
DEFINE STREAM lock-log.

/* ����㦠�� ⥪�騩 ����� */
def var work-module as char init "0" no-undo.
Procedure SetModule.
    def input param in-module as char no-undo.
    work-module = in-module.
end.

Procedure GetModule.
    def output param in-module as char no-undo.
    in-module = work-module.
end.

procedure SetUser.
   {otdel2.i}

   assign
     corp-ok       = GetTablePermission("cust-corp", "r")
     priv-ok       = GetTablePermission("person", "r")
     int-ok        = Yes
     bank-ok       = GetTablePermission("banks", "r")
     access        = ""
     usr-printer   = getThisUserXAttrValue('�ਭ��')
     acct-look     = getThisUserXAttrValue('�~/�')
     ClassAcctPosView = getThisUserXAttrValue('ClassAcctPosView')
     rightview     = getThisUserXAttrValue('�������')
     otdel-lst     = getThisUserXAttrValue('�⤥������')
     userids       = getSlaves()
     balschinn     = FGetSetting("����爍�",?,?)
     bank-inn      = FGetSetting("���",?,?)     
   .

   IF NOT CAN-DO(userids,userid('bisquit')) THEN DO:
       {additem.i userids USERID('bisquit')}
   END.

   run SetUserRights in h_rights.
                        /* �᫨ ���� �� ����饭� � ०��� READ-ONLY. */
   IF DBRESTRICTIONS ("bisquit") NE "READ-ONLY" THEN
   DO:
                       /* ��⠭���� ०��� ����� ���஢, �� ����稨 � ���짮��⥫�
                       ** ����ઢ���� PrivateBuffers. */
      {longrpt.i &after}
   END.   
end procedure.

procedure CheckHandle:
  /* does nothing */
end procedure.

/* �஢�ઠ ������ r-���� ��� p-���� */
function SearchPfile returns log
         (input filename as char ):
  IF filename = "" OR filename = ? THEN
     RETURN NO.
  IF SEARCH(filename + ".r") <> ? or
     SEARCH(filename + ".p") <> ? then
     return yes.
  else
    return no.
end.

/* �㭪�� �஢����, ���� �� ���� ��ࠡ�稬 */

FUNCTION Holiday RETURNS LOGICAL (INPUT iDate AS DATE).
   DEFINE VARIABLE vFlag AS LOGICAL INIT NO NO-UNDO.
   DEFINE BUFFER   bHoliday FOR holiday.

   if (WEEKDAY(iDate) MODULO 6) EQ 1 THEN
      vFlag = YES. /* ��室��� */
   FOR FIRST bHoliday WHERE bHoliday.op-date EQ iDate NO-LOCK :
      vFlag = NOT vFlag.
   END.
   RETURN vFlag.
END FUNCTION.

function term2str returns char (input in-beg-date as date, in-end-date as date):
   DEFINE VARIABLE iBegDate AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iEndDate AS CHARACTER NO-UNDO.

   IF    (     YEAR (in-beg-date) GE  SESSION:YEAR-OFFSET
          AND  YEAR (in-beg-date) LT (SESSION:YEAR-OFFSET + 100))
     AND (     YEAR (in-end-date) GE  SESSION:YEAR-OFFSET
          AND  YEAR (in-end-date) LT (SESSION:YEAR-OFFSET + 100))
   THEN
      ASSIGN
         iBegDate = STRING (in-beg-date,"99/99/99")
         iEndDate = STRING (in-end-date,"99/99/99")
      .
   ELSE
      ASSIGN
         iBegDate = STRING (in-beg-date,"99/99/9999")
         iEndDate = STRING (in-end-date,"99/99/9999")
      .

   return
      if in-beg-date eq in-end-date
         then string(day(in-beg-date),"99") + " " + entry(month(in-beg-date), "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������") + " " + string(year(in-beg-date)) + " �."
      else if day(in-beg-date) = 1 and day(in-end-date + 1) = 1 and year(in-end-date) = year(in-beg-date)
           then if month(in-end-date) = month(in-beg-date) then entry(month(in-beg-date), "ﭢ���,䥢ࠫ�,����,��५�,���,���,���,������,ᥭ����,������,�����,�������") + " " + string(year(in-beg-date)) + " �."
           else if month(in-end-date) - month(in-beg-date) = 2 and month(in-beg-date) modulo 3 = 1 then string(INT64((month(in-beg-date) / 3) + 1)) + " ����⠫ " + string(year(in-beg-date)) + " �."
           else if in-end-date = date(12,31,year(in-end-date)) and in-beg-date = date(1,1,year(in-end-date)) then string(year(in-beg-date)) + " ���"
           else if month(in-beg-date) = 1 and (month(in-end-date) - month(in-beg-date)) modulo 3 = 2 then "1-" + string(INT64((month(in-end-date) / 3))) + " ����⠫� " + string(year(in-beg-date)) + " �."
           else if month(in-end-date) - month(in-beg-date) = 5 and month(in-beg-date) modulo 6 = 1 then string(INT64(month(in-end-date) / 6)) + '-� ���㣮��� ' + string(year(in-beg-date)) + " �."
              else iBegDate + "-" + iEndDate
      else (if in-beg-date = ? then "  /  /  " else iBegDate) + "-" +
           (if in-end-date = ? then "  /  /  " else iEndDate)
   .
end.

FUNCTION term2strEng RETURNS CHAR (INPUT in-beg-date AS DATE, in-end-date AS DATE):
   DEFINE VARIABLE iBegDate AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iEndDate AS CHARACTER NO-UNDO.

   IF    (     YEAR (in-beg-date) GE  SESSION:YEAR-OFFSET
          AND  YEAR (in-beg-date) LT (SESSION:YEAR-OFFSET + 100))
     AND (     YEAR (in-end-date) GE  SESSION:YEAR-OFFSET
          AND  YEAR (in-end-date) LT (SESSION:YEAR-OFFSET + 100))
   THEN
      ASSIGN
         iBegDate = STRING (in-beg-date,"99/99/99")
         iEndDate = STRING (in-end-date,"99/99/99")
      .
   ELSE
      ASSIGN
         iBegDate = STRING (in-beg-date,"99/99/9999")
         iEndDate = STRING (in-end-date,"99/99/9999")
      .

   RETURN
      IF in-beg-date EQ in-end-date
         THEN STRING(DAY(in-beg-date),"99") + " " + ENTRY(MONTH(in-beg-date), "january,february,march,april,may,june,july,august,september,october,november,december") + " " + STRING(YEAR(in-beg-date))
      ELSE IF DAY(in-beg-date) = 1 AND DAY(in-end-date + 1) = 1 AND YEAR(in-end-date) = YEAR(in-beg-date)
           THEN IF MONTH(in-end-date) = MONTH(in-beg-date) THEN ENTRY(MONTH(in-beg-date), "january,february,march,april,may,june,july,august,september,october,november,december") + " " + STRING(YEAR(in-beg-date))
           ELSE IF MONTH(in-end-date) - MONTH(in-beg-date) = 2 AND MONTH(in-beg-date) MODULO 3 = 1 THEN STRING(INT64((MONTH(in-beg-date) / 3) + 1)) + " quarter " + STRING(YEAR(in-beg-date))
           ELSE IF in-end-date = date(12,31,YEAR(in-end-date)) AND in-beg-date = date(1,1,YEAR(in-end-date)) THEN STRING(YEAR(in-beg-date))
           ELSE IF MONTH(in-beg-date) = 1 AND (MONTH(in-end-date) - MONTH(in-beg-date)) MODULO 3 = 2 THEN "1-" + STRING(INT64((MONTH(in-end-date) / 3))) + " quarters " + STRING(YEAR(in-beg-date))
           ELSE IF MONTH(in-end-date) - MONTH(in-beg-date) = 5 AND MONTH(in-beg-date) MODULO 6 = 1 THEN STRING(INT64(MONTH(in-end-date) / 6)) + 'half-year ' + STRING(YEAR(in-beg-date))
              ELSE iBegDate + "-" + iEndDate
      ELSE (IF in-beg-date = ? THEN "  /  /  " ELSE iBegDate) + "-" +
           (IF in-end-date = ? THEN "  /  /  " ELSE iEndDate)
   .
END.

function per2str returns char (input in-beg-date as date, in-end-date as date):
    DEFINE VARIABLE vstr AS CHARACTER   NO-UNDO.
    vstr = {sv-tstr in-beg-date in-end-date} .
   RETURN vstr.
end.

procedure CurrCode:
/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1997 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: CurrCode.P
      Comment: �����頥� ��� ������, ���������� input ��ࠬ��஬ in-code,
      Comment: � output ��ࠬ��� out-code, � ����ୠ⨢��� �����䨪�樨,
      Comment: �������� � ����஥��� ��ࠬ���� ��ࠬ��஬ "���날�".
      Comment: �᫨ ��ࠬ��� "���날�" �� �����, �����頥� in-code.
   Parameters: input : in-code = currency.currency
   Parameters: output: out-code - ��� ������ � ����ୠ⨢��� �����䨪�樨
         Uses: globals.i
      Used by:
      Created: 17/07/1997 Dima
     Modified:
*/

   def input param in-code   like currency.currency no-undo.
   def output param out-code like currency.currency no-undo.

   DEF VAR AltCurr AS CHAR   NO-UNDO.

   AltCurr = FGetSetting("���날�",?,"").
   if in-code = "" then
      out-code = codenatcurr.
   else if AltCurr = "" then
      out-code = in-code.
   else do:
      find first code where code.class = AltCurr and
                            code.code  = in-code no-lock no-error.
      if avail code then
         out-code = code.val.
      else
         message "��� ������ � ����� " + in-code + " � �����䨪��� " + AltCurr + "!"
                  view-as alert-box Error.
   end.
end procedure.


/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-1996 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: acct-pos
      Comment: 㭨���ᠫ쭠� ��楤�� ���� ���⪠ � ����⮢ �� ����
   Parameters: many
         Uses: acct-pos.i
     Modified: 24/08/1998 Olenka - �� ��।�����
*/

/* ��⠭���������� � bqglset */
def new global shared var GCheck-Op as logical no-undo.

{acct-pos.i &Type = "acct-pos" &defproc=yes}
{acct-pos.i &Type = "cli-pos"  &defproc=yes}
{acct-pos.i &Type = "acct-qty" &defproc=yes}

/* �஢�ઠ �� ��� � ����।������� ��⥣�ਨ � ᮮ�饭��� */
PROCEDURE CheckDate.
   DEFINE INPUT  PARAMETER iOpDate  AS DATE      NO-UNDO.
   DEFINE INPUT  PARAMETER iStatus  AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vMsg    AS CHARACTER NO-UNDO.

   RUN CheckOpDateEx(iOpDate,
                     NO,
                     iStatus NE "�����",
                     "",
                     OUTPUT vMsg).

   IF vMsg NE "" THEN DO:
      MESSAGE vMsg.
      RETURN.
   END.
   ELSE RETURN "ok".
END PROCEDURE.

/* �஢�ઠ �� ��� � ����।������� ��⥣�ਨ ��� ᮮ�饭�� */
PROCEDURE CheckDateNoMsg.
   DEFINE INPUT  PARAMETER iOpDate  AS DATE      NO-UNDO.
   DEFINE INPUT  PARAMETER iStatus  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oMsg     AS CHARACTER NO-UNDO.

   RUN CheckOpDateEx(iOpDate,
                     NO,
                     iStatus NE "�����",
                     "",
                     OUTPUT oMsg).

END PROCEDURE.

/* �஢�ઠ �� ��� � ��।������� ��⥣�ਨ */
PROCEDURE CheckCatDateNoMsg.
   DEFINE INPUT  PARAMETER iOpDate  AS DATE      NO-UNDO.
   DEFINE INPUT  PARAMETER iAcctCat AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iStatus  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oMsg     AS CHARACTER NO-UNDO.

   RUN CheckOpDateEx(iOpDate,
                     NO,
                     iStatus NE "�����",
                     iAcctCat,
                     OUTPUT oMsg).

END PROCEDURE.

/* �஢�ઠ �� ���㬥��� */
PROCEDURE CheckOpDate.
   DEFINE INPUT  PARAMETER iOp     AS INT64   NO-UNDO.
   DEFINE INPUT  PARAMETER iStatus AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER oMsg    AS CHARACTER NO-UNDO.
   DEFINE INPUT  PARAMETER iStatOp AS CHARACTER NO-UNDO.

   DEFINE VARIABLE vOpRec AS RECID      NO-UNDO.
   DEFINE VARIABLE vRight AS CHARACTER  NO-UNDO.

   FIND FIRST op WHERE
              op.op EQ iOp NO-LOCK NO-ERROR.
   IF NOT AVAIL op THEN DO:
       oMsg = "���㬥�� 㤠���.".
       RETURN.
   END.

   vRight = getThisUserXAttrValue('����ᐥ�').
   RUN CheckOpEx(RECID(op),
                 NO,
                 YES,
                 vRight,
                 NO,
                 iStatOp EQ "��������",
                 OUTPUT oMsg).

   IF oMsg > "" THEN
      RETURN.

   FIND FIRST op WHERE
              op.op EQ iOp NO-LOCK NO-ERROR.
   IF NOT AVAIL op THEN DO:
       oMsg = "���㬥�� 㤠���.".
       RETURN.
   END.
   RUN CheckOpDateEx(op.op-date,
                     NO,
                     iStatus NE "�����",
                     op.acct-cat,
                     OUTPUT oMsg).

END PROCEDURE.

/*  ������ᠫ쭠� �஢�ઠ ������ � �ࠢ �� ᮢ��襭�� ����⢨� � ���㬥�⮬ � ���भ�  */
/*  �������� ���� ����権 ��� ���㬥�⠬�:                                             */
/*  VIEW   - ��ᬮ�� ���㬥��                                                          */
/*  Ins    - �������� ���㬥��                                                          */
/*  Upd    - ������஢���� ���㬥��                                                    */
/*  Del    - �������� ���㬥��                                                          */
/*  Signs  - ������஢���� ���४����⮢ ���㬥��                                      */
/*  Copy   - ����஢���� ���㬥��                                                       */
/*  ChgSts - ��������� ����� ���㬥��                                                 */
/*  ChgDt  - ��������� ���� ���㬥��                                                    */
/*  Undo   - �⪠� ���㬥��                                                             */
/*  Ann    - ������� ���㬥��                                                         */

PROCEDURE CheckOpRight.
   DEFINE INPUT PARAMETER iOpRec   AS RECID     NO-UNDO. /* ����� ����� ���㬥��*/
   DEFINE INPUT PARAMETER iDate    AS DATE      NO-UNDO. /* ��� ���भ�*/
   DEFINE INPUT PARAMETER iCodOper AS CHARACTER NO-UNDO. /* ��� ����樨 ��� ���㬥�⮬*/

   DEFINE VARIABLE vMess  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vRight AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vDate  AS DATE      NO-UNDO.
   DEFINE VARIABLE vFlag  AS LOGICAL   NO-UNDO.

   FIND FIRST op WHERE RECID(op) EQ iOpRec NO-LOCK NO-ERROR.

                  /* �஢�ઠ �ࠢ 㤠����� ��ꥪ⮢ ���稭����� */
   IF iCodOper EQ "Del" 
   THEN DO:
      IF     USERID("bisquit") NE op.user-id
         AND NOT GetSlavePermissionBasic (USERID("bisquit"),op.user-id,"d") 
      THEN DO:
         vMess = "�� �� ����� �ࠢ� 㤠���� ��ꥪ�� ���짮��⥫� '" + op.user-id + "'.".
         RETURN ERROR vMess.
      END.
   END.
                  /* �஢�ઠ �ࠢ ।���஢���� ��ꥪ⮢ ���稭����� */
   ELSE IF iCodOper NE "View"
   THEN DO:
      IF     USERID("bisquit") NE op.user-id
         AND NOT GetSlavePermissionBasic (USERID("bisquit"),op.user-id,"w") 
      THEN DO:
         vMess = "�� �� ����� �ࠢ� ।���஢��� ��ꥪ�� ���짮��⥫� '" + op.user-id + "'.".
         RETURN ERROR vMess.
      END.
   END.

   CASE iCodOper:
      WHEN "View" THEN DO:
/*         RUN CheckOpEx(iOpRec,YES,NO,?,NO,NO,OUTPUT vMess).*/
RUN PirCheckOpEx(iOpRec,YES,NO,?,NO,NO,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
      END.
      WHEN "Ins" THEN DO:
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(iDate,NO,YES,"",OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
      END.
      WHEN "Copy" OR
      WHEN "ChgSts" THEN DO:
         vRight = IF iCodOper EQ "Copy"
                  THEN ?
                  ELSE getThisUserXAttrValue('����ሧ�')
         .
/*         RUN CheckOpEx(iOpRec,NO,NO,vRight,NO,NO,OUTPUT vMess).*/
RUN PirCheckOpEx(iOpRec,NO,NO,vRight,NO,NO,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(IF iDate EQ ?
                           THEN op.op-date
                           ELSE iDate,
                           NO,
                           IF iCodOper EQ "Copy"
                           THEN YES
                           ELSE NO,
                           op.acct-cat,
                           OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
      END.
      WHEN "Upd" OR
      WHEN "Del" THEN DO:
         vRight = getThisUserXAttrValue('����ᐥ�').
/*         RUN CheckOpEx(iOpRec,NO,YES,vRight,NO,YES,OUTPUT vMess).*/
RUN PirCheckOpEx(iOpRec,NO,YES,vRight,NO,YES,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(IF iDate EQ ?
                           THEN op.op-date
                           ELSE iDate,
                           NO,
                           YES,
                           op.acct-cat,
                           OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
      END.
      WHEN "Signs" THEN DO:
         vRight = getThisUserXAttrValue('����ᐥ�').
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         vDate = IF iDate EQ ?
                 THEN op.op-date
                 ELSE iDate.
         vFlag =     getThisUserXattrValue("����������") = "�����"
                 AND (   vDate        LE Get_Date_Cat("b",?)
                      OR op.op-status GE FGetSetting("��������",?,CHR(251) + CHR(251))
                     ).                

/*         RUN CheckOpEx(iOpRec,*/
  RUN PirCheckOpEx(iOpRec,
                       NO,
                       YES,
                       IF vFlag
                       THEN ?
                       ELSE vRight,
                       NO,
                       IF  vFlag
                       THEN NO
/*                       ELSE YES,OUTPUT vMess).*/
				   ELSE YES,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" 
            AND getThisUserXattrValue("����������") NE "�����" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(IF iDate EQ ?
                           THEN op.op-date
                           ELSE iDate,
                           NO,
                           YES,
                           op.acct-cat,
                           OUTPUT vMess).
         IF     vMess > ""
            AND getThisUserXattrValue("����������") NE "�����" THEN
            RETURN ERROR vMess.
      END.
      WHEN "UpdDetails" THEN DO:
         vRight = getThisUserXAttrValue('����ᐥ�').
/*         RUN CheckOpEx(iOpRec,NO,YES,vRight,NO,NO,OUTPUT vMess).*/
           RUN PirCheckOpEx(iOpRec,NO,YES,vRight,NO,NO,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(IF iDate EQ ?
                           THEN op.op-date
                           ELSE iDate,
                           NO,
                           YES,
                           op.acct-cat,
                           OUTPUT vMess).
         IF     vMess > ""
            AND getThisUserXattrValue("��������") EQ "�� �����" THEN
            RETURN ERROR vMess.
      END.
      WHEN "Undo" OR
      WHEN "Ann" THEN DO:
         vRight = IF iCodOper EQ "Undo"
                  THEN getThisUserXAttrValue('�����⪠�')
                  ELSE getThisUserXAttrValue('����ိ��')
         .
/*         RUN CheckOpEx(iOpRec,NO,YES,vRight,NO,NO,OUTPUT vMess).*/
         RUN PirCheckOpEx(iOpRec,NO,YES,vRight,NO,NO,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(IF iDate EQ ?
                           THEN op.op-date
                           ELSE iDate,
                           NO,
                           IF iCodOper EQ "Undo"
                           THEN NO
                           ELSE YES,
                           op.acct-cat,
                           OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
      END.
      WHEN "ChgDt" THEN DO:
         vRight = getThisUserXAttrValue('����ᐥ�').
/*         RUN CheckOpEx(iOpRec,NO,YES,vRight,YES,YES,OUTPUT vMess).*/
         RUN PirCheckOpEx(iOpRec,NO,YES,vRight,YES,YES,iCodOper,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         FIND FIRST op WHERE
              RECID(op) EQ iOpRec NO-LOCK NO-ERROR.
         RUN CheckSessions (iOpRec,OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
         RUN CheckOpDateEx(IF iDate EQ ?
                           THEN op.op-date
                           ELSE iDate,
                           YES,
                           YES,
                           op.acct-cat,
                           OUTPUT vMess).
         IF vMess > "" THEN
            RETURN ERROR vMess.
      END.
      OTHERWISE
         RETURN ERROR "�������⨬�� ������ ��� ���㬥�⮬!".
   END CASE.
END PROCEDURE.


/* ������ᠫ쭠� �஢�ઠ ������ � �ࠢ �� ���㬥�� */
PROCEDURE CheckOpEx.
   DEFINE INPUT PARAMETER iOpRec     AS RECID     NO-UNDO. /* ����� ����� ���㬥��*/
   DEFINE INPUT PARAMETER iAcctRight AS LOGICAL   NO-UNDO. /* �᫨ ��� ����㯠 � ���㬥��� �஢����� ��
                                                              �� ����稥 ����㯠 � ��⠬ �஢����*/
   DEFINE INPUT PARAMETER iFlSal     AS LOGICAL   NO-UNDO. /* �஢����� �� �ਭ���������� ��� ��௫��*/
   DEFINE INPUT PARAMETER iStat      AS CHARACTER NO-UNDO. /* ������ ��� �஢�ન �⪠�/���/���/��� ���� */
   DEFINE INPUT PARAMETER iFlDate    AS LOGICAL   NO-UNDO. /* �஢����� �� ����������� ��७�� */
   DEFINE INPUT PARAMETER iChkMaxSts AS LOGICAL   NO-UNDO. /* �஢�ઠ �� ���ᨬ���� �����, � ��� ����� �������� ���-�*/

   DEFINE OUTPUT PARAMETER oMsg       AS CHARACTER NO-UNDO. /*����饭�� �� �訡��*/

   DEFINE BUFFER acct     FOR acct.
   DEFINE BUFFER op-entry FOR op-entry.

   DEFINE VARIABLE vPrIzmDoc    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vIzmDate     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vLockStr     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vDostDocAcct AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vUserids     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vRightView   AS CHARACTER NO-UNDO.

   FIND FIRST op WHERE
        RECID(op) EQ iOpRec SHARE-LOCK NO-WAIT NO-ERROR.
   IF NOT AVAILABLE op THEN DO:
      IF    LOCKED(op) THEN DO:
         IF WhoLocks2(INPUT        iOpRec, 
                     "op",
                     INPUT-OUTPUT vLockStr) 
         THEN oMsg = vLockStr.
         ELSE oMsg = "���㬥�� ।�������� ��㣨� ���짮��⥫��.".
      END.
      ELSE
         oMsg = "���㬥��  㤠��� ��㣨� ���짮��⥫��.".
      RETURN.
   END.
   FIND CURRENT op NO-LOCK.

   ASSIGN
      vRightView     = getThisUserXAttrValue('�������')
      vUserids       = getSlaves()
   .

   IF NOT CAN-DO(vUserids,userid('bisquit')) THEN
      {additem.i vUserids USERID('bisquit')}

   vDostDocAcct = getThisUserXAttrValue('���℮������') EQ '��'.

   IF NOT CAN-DO(vRightView,op.op-status) THEN 
   bl:
   DO:
      /* �᫨ ��⠭����� �� ���℮������ � ���祭�� �� */
      /* �஢��塞 ���稭����� � ��� �஢���� */
      IF vDostDocAcct THEN DO:
         IF NOT CAN-DO(vUserids,op.user-id) THEN DO:
            IF iAcctRight THEN DO:
               FOR EACH op-entry OF op NO-LOCK:
                  {find-act.i
                     &acct = op-entry.acct-db
                     &curr = op-entry.currency
                  }
                  IF     AVAIL acct 
                     AND AcctView(BUFFER acct) 
                  THEN LEAVE bl.

                  {find-act.i
                     &acct = op-entry.acct-cr
                     &curr = op-entry.currency
                  }
                  IF     AVAIL acct 
                     AND AcctView(BUFFER acct) 
                  THEN LEAVE bl.
               END.
            END.
         END.
         ELSE
            LEAVE bl.
      END.
      oMsg = "�� �� ����� �ࠢ� ࠡ���� � �⨬ ���㬥�⮬".
      RETURN.
   END.

   IF iFlDate THEN DO:
      vIzmDate = FGetSetting("����℮�",?,"").
      IF vIzmDate > "" AND CAN-DO(vIzmDate,op.op-status) THEN DO:
   		IF NOT CAN-DO(FGetSetting("PirMoveDocs","",?),op.op-kind)      
		THEN DO:
         oMsg = '���㬥�� � ����ᮬ "' + op.op-status + '" ����� ��७���� � ��㣮� ����!'.
         RETURN.
	    END. ELSE DO:
           iChkMaxSts = false.
         END.
      END.
   END.

   IF iChkMaxSts THEN DO:
       vPrIzmDoc = FGetSetting("��������",?,"").
       IF     vPrIzmDoc GT ""
          AND GetCode("�����",vPrIzmDoc) NE ?
          AND op.op-status GE vPrIzmDoc THEN DO:

          oMsg = "� ���㬥�⮬, ����騬 ����� " + op.op-status +
                 " 㦥 ��祣� ����� ������!~n������� � ������������.".
          RETURN.
       END.
   END.
   IF     iStat NE ?
      AND NOT CAN-DO(iStat,op.op-status) THEN DO:
      oMsg = "� ��� ��� �ࠢ ࠡ���� � ���㬥�⠬� ⠪��� �����.".
      RETURN.
   END.
   RELEASE op.
END PROCEDURE.

/* PIR  **********************************************/
/* ������ᠫ쭠� �஢�ઠ ������ � �ࠢ �� ���㬥�� */
/** �⫨砥��� CheckOpEx ����稥 �� ������ �室���� ��ࠬ��� iCodOper */
PROCEDURE PirCheckOpEx.
   DEFINE INPUT PARAMETER iOpRec     AS RECID     NO-UNDO. /* ����� ����� ���㬥��*/
   DEFINE INPUT PARAMETER iAcctRight AS LOGICAL   NO-UNDO. /* �᫨ ��� ����㯠 � ���㬥��� �஢����� ��
                                                              �� ����稥 ����㯠 � ��⠬ �஢����*/
   DEFINE INPUT PARAMETER iFlSal     AS LOGICAL   NO-UNDO. /* �஢����� �� �ਭ���������� ��� ��௫��*/
   DEFINE INPUT PARAMETER iStat      AS CHARACTER NO-UNDO. /* ������ ��� �஢�ન �⪠�/���/���/��� ���� */
   DEFINE INPUT PARAMETER iFlDate    AS LOGICAL   NO-UNDO. /* �஢����� �� ����������� ��७�� */
   DEFINE INPUT PARAMETER iChkMaxSts AS LOGICAL   NO-UNDO. /* �஢�ઠ �� ���ᨬ���� �����, � ��� ����� �������� ���-�*/
   DEFINE INPUT PARAMETER iCodOper   AS CHARACTER NO-UNDO. /* ��� ����樨 */

   DEFINE OUTPUT PARAMETER oMsg      AS CHARACTER NO-UNDO. /*����饭�� �� �訡��*/

   DEFINE BUFFER acct     FOR acct.
   DEFINE BUFFER op-entry FOR op-entry.

   DEFINE VARIABLE vPrIzmDoc    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vIzmDate     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vLockStr     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vDostDocAcct AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE vUserids     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE vRightView   AS CHARACTER NO-UNDO.

   {pir-base-pp-2.def}

   FIND FIRST op WHERE
        RECID(op) EQ iOpRec SHARE-LOCK NO-WAIT NO-ERROR.
   IF NOT AVAILABLE op THEN DO:
      IF    LOCKED(op) THEN DO:
         IF WhoLocks(INPUT        iOpRec,
                     INPUT-OUTPUT vLockStr) 
         THEN oMsg = vLockStr.
         ELSE oMsg = "���㬥�� ।�������� ��㣨� ���짮��⥫��.".
      END.
      ELSE
         oMsg = "���㬥��  㤠��� ��㣨� ���짮��⥫��.".
      RETURN.
   END.
   FIND CURRENT op NO-LOCK.

   ASSIGN
      vRightView     = getThisUserXAttrValue('�������')
      vUserids       = getSlaves()
   .

   IF NOT CAN-DO(vUserids,userid('bisquit')) THEN
      {additem.i vUserids USERID('bisquit')}

   vDostDocAcct = getThisUserXAttrValue('���℮������') EQ '��'.

   IF NOT CAN-DO(vRightView,op.op-status) THEN 
   bl:
   DO:
      /* �᫨ ��⠭����� �� ���℮������ � ���祭�� �� */
      /* �஢��塞 ���稭����� � ��� �஢���� */
      IF vDostDocAcct
      THEN DO:
         IF NOT CAN-DO(vUserids,op.user-id)
         THEN DO:
            IF iAcctRight
            THEN DO:
               FOR EACH op-entry OF op NO-LOCK:
                  {find-act.i
                     &acct = op-entry.acct-db
                     &curr = op-entry.currency
                  }
                  IF     AVAIL acct 
                     AND AcctView(BUFFER acct) 
                  THEN LEAVE bl.

                  {find-act.i
                     &acct = op-entry.acct-cr
                     &curr = op-entry.currency
                  }
                  IF     AVAIL acct 
                     AND AcctView(BUFFER acct) 
                  THEN LEAVE bl.
               END.
            END.
         END.
         ELSE
            LEAVE bl.
      END.
      oMsg = "�� �� ����� �ࠢ� ࠡ���� � �⨬ ���㬥�⮬".
      RETURN.
   END.

   IF iFlDate
   THEN DO:
      vIzmDate = FGetSetting("����℮�",?,"").

      IF vIzmDate > "" AND CAN-DO(vIzmDate,op.op-status)
      THEN DO: 
         IF NOT CAN-DO(FGetSetting("PirMoveDocs","",?),op.op-kind)
         THEN DO:
            oMsg = '���㬥�� � ����ᮬ "' + op.op-status + '" ����� ��७���� � ��㣮� ����!'.
            RETURN.
         END.
         ELSE DO:
            iChkMaxSts = false.
         END.
      END.
   END.

   IF iChkMaxSts
   THEN DO:
       vPrIzmDoc = FGetSetting("��������",?,"").
       IF     vPrIzmDoc GT ""
          AND GetCode("�����",vPrIzmDoc) NE ?
          AND op.op-status GE vPrIzmDoc
       THEN DO:
          oMsg = "� ���㬥�⮬, ����騬 ����� " + op.op-status +
                 " 㦥 ��祣� ����� ������!~n������� � ������������.".
          RETURN.
       END.
   END.
   IF     iStat NE ?
      AND NOT CAN-DO(iStat,op.op-status)
   THEN DO:
      oMsg = "� ��� ��� �ࠢ ࠡ���� � ���㬥�⠬� ⠪��� �����.".
      RETURN.
   END.
   
   /** �ࠢ� �⪠� */
   {pir-base-pp-2.i}
   /** �ࠢ� ।���஢���� ���㬥�⮢, ᮧ������ �� �᭮����� �࠭���樨 �� */
   {pir-base-pp-3.i}
   /** ।���஢���� ���㬥�⮢, �ப���஫�஢����� ������ ����஫��  */
   {pir-base-pp-4.i}
   /** ।���஢���� ���㬥�⮢, ᮧ������ ������쭮 ��⮬�⨧�஢���� �㭪樮����� ��   */
   {pir-base-pp-5.i}

   /* ।���஢��� ���㬥��� ��� ���� ����⨪�� - ����饭� */
   {pir-base-pp-6.i}

   /* ।���஢��� ���㬥��� � ��⪮� ���㧪� � ��娢 */
   {pir-base-pp-7.i}

   /* ।���஢��� ���������� ���㬥��� */
   /*{pir-base-pp-8.i}*/



   RELEASE op.
END PROCEDURE.

/* ������ᠫ쭠� �஢�ઠ ������, �ࠢ �� ���थ�� */
PROCEDURE CheckOpDateEx.
   DEFINE INPUT  PARAMETER iDate   AS DATE      NO-UNDO. /*��� ���भ�*/
   DEFINE INPUT  PARAMETER iNoDay  AS LOGICAL   NO-UNDO. /*�஢����� ����稥 ���भ�*/
   DEFINE INPUT  PARAMETER iChkCls AS LOGICAL   NO-UNDO. /*�஢����� ������ �� ����*/
   DEFINE INPUT  PARAMETER iCat    AS CHARACTER NO-UNDO. /*�� ����� ��⥣�ਨ �஢����� ���� ���भ�*/
   DEFINE OUTPUT PARAMETER oMsg    AS CHARACTER NO-UNDO. /*����饭�� �� �訡��*/

   DEF VAR vOpDateAv AS LOG NO-UNDO INIT YES. /* �ਧ���, ���� �� ⠪�� �� � ��⥬�. */

   IF iDate EQ ? THEN
      RETURN.
                        /* ��墠� � �஢�ઠ ��. */
   UNDONOOPDATE:
   DO ON ERROR UNDO UNDONOOPDATE, LEAVE UNDONOOPDATE:
      {daylock.i
         &in-op-date = iDate
         &lock-type  = SHARE
         &cats       = iCat
         &return-mes = oMsg
         &undo-act-l = "RETURN."
         &undo-act-a = "IF iNoDay
                        THEN ASSIGN
                           oMsg        = ''
                           vOpDateAv   = NO
                        .
                        UNDO UNDONOOPDATE, LEAVE UNDONOOPDATE."
      }
   END.
                        /* ������� �����஢�� �᫨ ������� ��. */
   IF vOpDateAv
   THEN DO:
      {rel-date.i &in-op-date = iDate &cats = iCat}
   END.
   ELSE DO:
                        /* �᫨ �� �� ������ � �ॡ���� ⠪�� �஢�ઠ,
                        ** � �ନ�㥬 ᮮ�饭�� �� �訡��. */
      IF NOT iNoDay
      THEN DO:
         oMsg = "����.���� " + STRING(iDate, "99/99/9999") + " �� ������".
         RETURN.
      END.
                        /* �᫨ �� �� ������ � �஢�ન �� ������⢨� ��
                        ** �� �ॡ����, � �஢��塞 �������� �� ������ ��� � 
                        ** ���ࢠ� �������� ��. �᫨ �� � �ନ�㥬 ᮮ�饭��
                        ** �� �訡��. */
      ELSE IF iDate LE FGetLastClsDate(?, "*")
      THEN DO:
         oMsg =   "��� " + STRING(iDate, "99/99/9999") +
                  " ����� � ������ �������� ����樮���� ����.".
         RETURN.
      END.
   END.
                        /* �஢�ઠ �� ������� ���, �᫨ �� �ॡ����
                        ** � ������� ��. */
   IF       iChkCls 
      AND   vOpDateAv
   THEN DO:
      IF GetCode("acct-cat",iCat) EQ ? THEN DO: /* �������⭠� ��⥣��� */
         IF Chk_Date_AllCat (iDate) THEN DO:
            oMsg = "��� ���p�樮��� ���� 㦥 ���p�� �� �ᥬ ��⥣��� - ����� ������ ��p�������".
            RETURN.
         END.
      END.
      ELSE DO:
         IF Chk_Date_Cat (iDate,iCat) THEN DO:
            oMsg = "���� " + STRING(iDate,"99/99/9999") + ' 㦥 ������ �� ��⥣�ਨ "' + iCat + '" - ' + Cat_Name(iCat) + " - ����� ������ ��p�������".
            RETURN.
         END.
      END.
   END.

   IF work-module NE "nalog" THEN DO: /* �⪫�砥� �� �஢�ન, �᫨ �������� ��� */

      {chkdmnmx.i
          &in-op-date = iDate
          &action     = "oMsg = ""�� �� ����� �ࠢ� ࠡ���� � �⮬ ����樮���� ���!"".~
                         RETURN."
      }

      {chkblock.i
        &surr   = STRING(iDate)
        &action = "oMsg = ""�� �� ����� �ࠢ� ࠡ���� � �������஢����� ����樮���� ���!""."
      }
   END.
END PROCEDURE.

/* �஢�ઠ �⭮襭�� ���㬥�� � �����⮩/�뢥७��� ᬥ�� ���, �᫨ ᬥ�� �� ��室���� � 
����� '�������' �㤥� �㣠����. */
PROCEDURE CheckSessions:
   DEFINE INPUT   PARAMETER iOpRec  AS RECID                   NO-UNDO. /* ����� ����� ���㬥��*/
   DEFINE OUTPUT  PARAMETER oMsg    AS CHARACTER   INITIAL ""  NO-UNDO. /*����饭�� �� �訡��*/

   DEFINE VARIABLE vLockStr      AS CHARACTER   NO-UNDO.
   DEFINE VARIABLE vIntDprId     AS INT64     NO-UNDO.
   DEFINE VARIABLE vLogCloseSes  AS LOGICAL     NO-UNDO.

   DEFINE BUFFER op        FOR op.
   DEFINE BUFFER sessions  FOR sessions.

   FIND FIRST op WHERE
        RECID(op) EQ iOpRec SHARE-LOCK NO-WAIT NO-ERROR.
   IF NOT AVAILABLE op THEN DO:
      IF    LOCKED(op) THEN DO:
         IF WhoLocks2(INPUT        iOpRec, 
                       "op",
                     INPUT-OUTPUT vLockStr) 
         THEN oMsg = vLockStr.
         ELSE oMsg = "���㬥�� ।�������� ��㣨� ���짮��⥫��.".
      END.
      ELSE
         oMsg = "���㬥��  㤠��� ��㣨� ���짮��⥫��.".
      RETURN.
   END.
   FIND CURRENT op NO-LOCK.

   vIntDprId = INT64(GetXAttrValueEx("op",STRING(op.op),"Dpr-Id","_ERROR_")) NO-ERROR.
   IF NOT ERROR-STATUS:ERROR THEN
   DO:
      FIND FIRST sessions WHERE
         sessions.dpr-id EQ vIntDprId
         NO-LOCK NO-ERROR.
      vLogCloseSes = AVAILABLE sessions AND sessions.dpr-status NE "�������".
   END.
   IF vLogCloseSes AND getThisUserXattrValue("�������") NE "�����" THEN
   DO:
      oMsg = "�� ᬥ�� 㦥 ���p�� - ����� ������ ��p�������.".
      RETURN.
   END.
END PROCEDURE.

/* ������� ���祭�� ���������������� ���४����� �� ������������ ����
** � ��⮬ ���祭�� �� 㬮�砭�� */
FUNCTION GetTempXAttrValueEx RETURN CHAR (
   INPUT in-FileName AS CHAR,
   INPUT in-Surr     AS CHAR,
   INPUT in-Code     AS CHAR,
   INPUT in-Date     AS DATE,
   INPUT in-nofound  AS CHAR
):
   DEF VAR vValue    AS CHAR   NO-UNDO.
   DEF VAR vResult   AS CHAR   NO-UNDO. /* ���祭�� ��. */

   /* ���� ���ண�� "commission,acct,currency,kau,min-value,period,since" ���塞 �� ���� "comm-rate-id" */
   DEF BUFFER comm-rate FOR comm-rate.
   IF in-FileName EQ "comm-rate" AND NUM-ENTRIES(in-surr) > 3 THEN
   DO:
      IF ENTRY(4,in-surr) <> "" THEN
         FIND FIRST comm-rate WHERE
                    comm-rate.commission = ENTRY(1,in-surr) AND
                    comm-rate.acct = ENTRY(2,in-surr) AND
                    comm-rate.currency = ENTRY(3,in-surr) AND
                    comm-rate.kau = ENTRY(4,in-surr) AND
                    comm-rate.min-value = DEC(ENTRY(5,in-surr)) AND
                    comm-rate.period = INT64(ENTRY(6,in-surr)) AND
                    comm-rate.since = DATE(ENTRY(7,in-surr)) 
         NO-LOCK NO-ERROR.
      ELSE
         FIND FIRST comm-rate WHERE
                    comm-rate.filial-id = shfilial AND
                    comm-rate.branch-id = "" AND
                    comm-rate.commission = ENTRY(1,in-surr) AND
                    comm-rate.acct = ENTRY(2,in-surr) AND
                    comm-rate.currency = ENTRY(3,in-surr) AND
                    comm-rate.kau = ENTRY(4,in-surr) AND
                    comm-rate.min-value = DEC(ENTRY(5,in-surr)) AND
                    comm-rate.period = INT64(ENTRY(6,in-surr)) AND
                    comm-rate.since = DATE(ENTRY(7,in-surr)) 
            NO-LOCK NO-ERROR.
         IF AVAIL comm-rate THEN
            in-surr = STRING(comm-rate.comm-rate-id).
   END.
                        /* �஢�ઠ, ���� �� ४����� ⥬��ࠫ��. */
   FIND FIRST ttXattrTemp WHERE ttXattrTemp.fTable   EQ in-FileName
                            AND ttXattrTemp.fXattr   EQ in-Code
   NO-ERROR.
   IF AVAIL ttXattrTemp
   THEN DO:
      FIND LAST tmpsigns WHERE tmpsigns.file-name  EQ in-FileName
                           AND tmpsigns.code       EQ in-Code
                           AND tmpsigns.surrogate  EQ in-Surr
                           AND tmpsigns.since      LE in-Date
      NO-LOCK NO-ERROR.
      IF AVAIL tmpsigns THEN vValue = IF tmpsigns.code-value NE "" THEN tmpsigns.code-value ELSE tmpsigns.xattr-value.
      vResult  =  IF     AVAIL tmpsigns
                     AND {assigned vValue}
                     THEN vValue
                     ELSE in-nofound.
   END.
   ELSE vResult = in-nofound.
   RETURN vResult.
END.


/* ������� ���祭�� ���������������� ���४����� �� ���������� ����.
** �᫨ �� ������, � �����頥� ���⮥ ���祭�� */
FUNCTION GetTempXAttrValue RETURN CHAR (
   INPUT in-FileName AS CHAR,
   INPUT in-Surr     AS CHAR,
   INPUT in-Code     AS CHAR
):
   RETURN GetTempXAttrValueEx (in-FileName,in-Surr,in-Code,gend-date,"").
END.


/* ������� ���祭�� ���४����� � ��⮬ ���祭�� �� 㬮�砭�� */
FUNCTION GetXAttrValueEx RETURN CHAR (
   INPUT in-FileName AS CHAR,
   INPUT in-Surr     AS CHAR,
   INPUT in-Code     AS CHAR,
   INPUT in-nofound  AS CHAR
):
   {getxattrval.i}
END.

FUNCTION GetXAttrValue RETURN CHAR (
   INPUT in-FileName AS CHAR,
   INPUT in-Surr     AS CHAR,
   INPUT in-Code     AS CHAR
):
   DEF VAR in-nofound AS CHAR   NO-UNDO.  /* ���祭�� ��-㬮�砭�� = ���⮥ ���祭�� */

   {getxattrval.i}
END.

/* �����頥� ᯨ᮪ ��ண�⮢ �� ���祭�� */
FUNCTION GetXAttrSurr RETURNS CHARACTER 
         (INPUT in-FileName AS CHARACTER,
          INPUT in-Code     AS CHARACTER,
          INPUT in-Value    AS CHARACTER):

   DEFINE VARIABLE mRet AS CHARACTER INITIAL "" NO-UNDO.
   
   IF NOT IsXAttrIndexed(in-FileName, in-Code) THEN
      FOR EACH signs WHERE signs.file-name   EQ in-FileName
                       AND signs.code        EQ in-Code
                       AND signs.xattr-value EQ in-Value
         NO-LOCK:
         {additem.i mRet signs.surrogate}
      END.
   ELSE
      FOR EACH signs WHERE signs.file-name  EQ in-FileName
                       AND signs.code       EQ in-Code
                       AND signs.code-value EQ in-Value
         NO-LOCK:
         {additem.i mRet signs.surrogate}
      END.
   RETURN mRet.
END.


/* �஢�ઠ ���� KNF ��� ������樨 93-� */
{knf.pro}

/* ���� ���� ���ࠧ������� �� ���짮��⥫� */
function GetUserBranchId returns char (input in-user as char):

   def var out-branch as char no-undo.

   out-branch = GetXAttrValue("_user", in-user, "�⤥�����").
   IF out-branch = "" then
      out-branch = substr(in-user,2,4).
   if not can-find(first branch where branch.branch-id eq out-branch) then
      out-branch = dept.branch.
   return out-branch.
End.
                        /* ����室��� ��� ��楤��� SetValue,
                        ** �.�. �� �������᪮� ᮧ����� TT �
                        ** ������������� �訡��, ����砥� 49 �訡�� �� ࠡ��
                        ** � ����᪨�� ���७�묨 ⠡��栬�. */
DEF TEMP-TABLE ttSetValue NO-UNDO
   FIELD fInteger    AS INT64
   FIELD fDecimal    AS DEC
   FIELD fCharacter  AS CHAR
   FIELD fLogical    AS LOG
   FIELD fDate       AS DATE
   FIELD fDateTime   AS DATETIME
.
                        /* ������� ����� ��� ����᪮� ttSetValue. */
CREATE ttSetValue.
/*------------------------------------------------------------------------------
  Purpose:     �ਢ���� ���祭�� � ᮮ⢥��⢨� � �ଠ⮬ � ⨯�� 
  Parameters:  pValue   - ���祭��
               iType    - ⨯ ���祭��
               iFormat  - �ଠ�
               pMsg     - ᮮ�饭��
               oErr     - 䫠� �訡��
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE SetValue:
   DEFINE INPUT-OUTPUT PARAMETER pValue   AS CHARACTER            NO-UNDO.
   DEFINE INPUT  PARAMETER       iType    AS CHARACTER            NO-UNDO.
   DEFINE INPUT  PARAMETER       iFormat  AS CHARACTER            NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pMsg     AS CHARACTER            NO-UNDO.
   DEFINE OUTPUT PARAMETER       oErr     AS LOGICAL    INIT YES  NO-UNDO.

   DEFINE VARIABLE vHTable    AS HANDLE     NO-UNDO.
   DEFINE VARIABLE vHBuffer   AS HANDLE     NO-UNDO.

   /* Commented by KSV: �஢�ઠ �� �����⢫���� ��� ⨯� class � ���祭��
   ** "?" */
   IF iType = "class" OR pValue = "?" THEN 
   DO:
      oErr = NO.
      RETURN.
   END.

   /* �ਢ���� ���祭�� �����᪮�� ��ࠦ���� � ᮮ⢥��⢨�
   ** � �ଠ⮬, � �ਭ樯� �����४⭮� ����⢨�, �᪫��⥫쭮 ࠤ� 
   ** ᮢ���⨬��� � ���� �����.
   ** �஢��� �ଠ� �����⢫塞 ��� ��� ������⥫쭮�� ���祭��,
   ** ⠪ � ��� ����⥫쭮��. */
   IF iType EQ "LOGICAL"
      THEN pValue =  IF ENTRY (1, iFormat, "~/") EQ pValue
                        THEN  "YES"
                        ELSE  IF ENTRY (2, iFormat, "~/") EQ pValue
                                 THEN "NO"
                                 ELSE pValue.
   
   /* Commented by KSV: ��� ���⮣� ���祭�� � ��஢��� ⨯� ��ࠡ��뢠��
   ** ���祭��, �᪫��⥫쭮 ࠤ� ᮢ���⨬��� � ���� ����� */
   IF CAN-DO("integer,decimal",iType) AND pValue = "" THEN pValue = "0".
                        /* ���� �஢�ન ���祭�� ᮣ��᭮ ���ᠭ��. */
   CHK:
   DO:
                        /* ����祭�� 㪠��⥫� �� �����. */
      vHBuffer = BUFFER ttSetValue:HANDLE.
                        /* ��⠭������� ����室���� ���祭��. */
      vHBuffer:BUFFER-FIELD ("f" + iType):FORMAT = iFormat NO-ERROR.
      IF ERROR-STATUS:ERROR
         THEN LEAVE CHK.
                        /* ���࠭���� ���祭��. */
      vHBuffer:BUFFER-FIELD ("f" + iType):BUFFER-VALUE = pValue NO-ERROR.
      IF ERROR-STATUS:ERROR
         THEN LEAVE CHK.
                        /* �஢�ઠ ���祭�� �� ᮮ⢥��⢨� ⨯� ������.  */
      IF vHBuffer:BUFFER-FIELD ("f" + iType):BUFFER-VALUE EQ ?
      THEN DO:
         pValue = ?.
         LEAVE CHK.
      END.
                        /* �஢�ઠ ���祭�� �� ᮮ⢥��⢨� �ଠ� ������. */
      pValue = STRING(vHBuffer:BUFFER-FIELD ("f" + iType):BUFFER-VALUE,iFormat) NO-ERROR.
      IF ERROR-STATUS:ERROR
         OR ERROR-STATUS:NUM-MESSAGES GT 0
         THEN LEAVE CHK.
                        /* ��⠭������� ���祭��. */
      ASSIGN
         oErr     = NO
      .
   END.
   IF oErr = YES OR pValue = ? THEN 
   DO:
       pMsg = "���祭�� " + pMsg + " �� ᮮ⢥����� ⨯� ~"" +
              (IF iType = ? THEN "?" ELSE iType)   + "~"" +
              " ��� �ଠ�� ~"" +
              (IF iFormat = ? THEN "?" else iFormat) + "~" !".

      IF pValue = ? then pValue = "".
      oErr = YES.
  END.

  pValue = RIGHT-TRIM (pValue).
  
  RETURN.

END PROCEDURE.

/******************************************************************************/
/* ����஫� �������� ��� �� ��⣮�� ���
   �����頥� yes (������), �᫨ ��।��� ������ ��� �� �� ����� ��⥣�ਨ
   �� ��।������ ᯨ᪠ */
FUNCTION FChkClsDateByFil RETURNS LOGICAL
   (INPUT iDate AS DATE,
    INPUT iCats AS CHARACTER,
    INPUT iFil  AS CHARACTER
   ):
   
   DEFINE VARIABLE vI AS INT64    NO-UNDO.
   DEFINE BUFFER acct-pos FOR acct-pos.

   IF iCats = "*" THEN
   DO:
      FIND LAST acct-pos WHERE acct-pos.filial-id =  iFil
                           AND acct-pos.since     >= iDate
         NO-LOCK NO-ERROR.
      RETURN AVAILABLE acct-pos.
   END.
   ELSE
   DO vI = 1 TO NUM-ENTRIES(iCats):
      IF Chk_Date_CatByFil(iDate,ENTRY(vI,iCats),iFil) THEN
         RETURN YES.
   END.
   RETURN NO.

END.

/******************************************************************************/
/* ����஫� �������� ��� �� ��⣮�� ���
   �����頥� yes (������), �᫨ ��।��� ������ ��� �� �� ����� ��⥣�ਨ
   �� ��।������ ᯨ᪠ */
FUNCTION FChkClsDate RETURNS LOGICAL
   (INPUT iDate AS DATE,
    INPUT iCats AS CHARACTER):
   
   RETURN FChkClsDateByFil(iDate,iCats,shFilial).

END.

/******************************************************************************/
/* �����頥� ���� ��᫥����� �����⮣� ���, �� ��।����� ���� 
   �� ��⥣��� ��� � 䨫����*/
FUNCTION FGetLastClsDateByFil RETURNS DATE (
   INPUT iDate AS DATE,
   INPUT iCats AS CHARACTER,
   INPUT iFil  AS CHARACTER
):
   DEFINE VARIABLE vI         AS INT64  NO-UNDO.
   DEFINE VARIABLE vSinceDate AS DATE     NO-UNDO.
   DEFINE VARIABLE vDateTmp   AS DATE     NO-UNDO.
   DEFINE BUFFER acct-pos FOR acct-pos.
   
   IF iCats = "*" THEN
   DO:
      IF iDate = ? THEN
         FIND LAST acct-pos WHERE acct-pos.filial-id = iFil
            USE-INDEX apos-date NO-LOCK NO-ERROR.
      ELSE 
         FIND LAST acct-pos WHERE acct-pos.filial-id = iFil
                              AND acct-pos.since <= iDate 
            USE-INDEX apos-date NO-LOCK NO-ERROR.
      IF AVAILABLE acct-pos THEN
         vSinceDate = acct-pos.since.
   END.
   ELSE
   DO vI = 1 TO NUM-ENTRIES(iCats):   
      vDateTmp = Get_Date_Cat(ENTRY(vI,iCats),iDate).
      IF vDateTmp <> ? THEN
         vSinceDate =   IF vSinceDate EQ ?
                           THEN vDateTmp
                           ELSE MIN (vSinceDate, vDateTmp).
   END.
   IF       iDate       NE ?
      AND   vSinceDate  EQ ?
   THEN DO:
      RUN Fill-SysMes IN h_tmess (
         "", "core49", "",
         "%s=" + STRING (iDate,"99/99/9999")
      ).
      FIND FIRST acct-pos WHERE
               acct-pos.filial-id EQ iFil
         AND   CAN-DO (iCats,acct-pos.acct-cat)
      USE-INDEX apos-date NO-LOCK NO-ERROR.
      IF AVAILABLE acct-pos
         THEN vSinceDate = acct-pos.since.
      RUN Fill-SysMes IN h_tmess (
         "", "core50", "",
         "%s=" + (IF vSinceDate EQ ?
            THEN "�� �������"
            ELSE STRING (vSinceDate,"99/99/9999"))
      ).
   END.
   RETURN vSinceDate.

END.

/******************************************************************************/
/* �����頥� ���� ��᫥����� �����⮣� ���, �� ��।����� ���� 
   �� ��⥣��� ��� */
FUNCTION FGetLastClsDate RETURNS DATE 
   (INPUT iDate AS DATE,
    INPUT iCats AS CHARACTER):

   RETURN FGetLastClsDateByFil(iDate,iCats,shFilial).

END.




/******************************************************************************/
FUNCTION FGetCats RETURN CHARACTER 
   (INPUT iCatSourse AS CHARACTER,
    INPUT iRecid     AS RECID):

DEFINE VARIABLE vCats      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE vOpClasses AS CHARACTER  NO-UNDO.

   IF iCatSourse = "op-kind" THEN
   DO:
      FIND FIRST op-kind WHERE RECID(op-kind) = iRecid
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE op-kind THEN
         RETURN ?.

      vOpClasses = Ls-Class("op").
      FIND FIRST op-templ OF op-kind 
         NO-LOCK NO-ERROR.
      IF AVAILABLE op-templ THEN
         /* ���� �࠭���樨... */
         FOR EACH op-templ OF op-kind WHERE
                  (IF op-templ.cr-class-code EQ "" 
                      THEN TRUE
                      ELSE CAN-DO (vOpClasses, op-templ.cr-class-code))
            NO-LOCK:
            vCats = JoinStrings(vCats,op-templ.acct-cat).
         END.
      ELSE
         /* ���� �࠭���樨... */
         FOR EACH op-kind-tmpl OF op-kind WHERE
                  CAN-DO(vOpClasses,op-kind-tmpl.work-class-code)
            NO-LOCK:
            vCats = JoinStrings(vCats,GetXattrInit(op-kind-tmpl.work-class-code,
                                                   "acct-cat")).
         END.
   END.
   ELSE IF iCatSourse = "op" THEN
   DO:
      FIND FIRST op WHERE RECID(op) = iRecid
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE op THEN
         RETURN ?.
      FOR EACH op-entry OF op 
         NO-LOCK:
         IF LOOKUP(op-entry.acct-cat,vCats) = 0 THEN
            {additem.i vCats op-entry.acct-cat}
      END.
   END.
   RETURN vCats.
END.

/*------------------------------------------------------------------------------
  Purpose:     ��।���� �� 㤥ন���� ������ �� �� rec-id
  Parameters:  iRecId   - RECID �����
               pString  - ᮮ�饭��, � ���஥ ���� �������� ���ଠ�� �
                          ���짮��⥫�, 㤥ন���饬 ������
  Notes:       
------------------------------------------------------------------------------*/
FUNCTION WhoLocks RETURN LOGICAL (INPUT         iRecId      AS RECID ,
                                  INPUT-OUTPUT  pString     AS CHARACTER).

   RETURN WhoLocks2( iRecId,"", pString).
END FUNCTION.


FUNCTION WhoLocks2 RETURN LOGICAL (INPUT         iRecId      AS RECID ,
                                    INPUT         iTableName  AS CHARACTER ,
                                    INPUT-OUTPUT  pString     AS CHARACTER).

   DEFINE BUFFER xconnect FOR bisquit._connect.
   DEFINE BUFFER xuser    FOR bisquit._user.
   DEFINE BUFFER xlock    FOR bisquit._lock.

   DEFINE VARIABLE vUsers     AS CHARACTER INIT "" NO-UNDO.
   DEFINE VARIABLE vNumUsers  AS INTEGER INIT 0 NO-UNDO.
   DEFINE VARIABLE vNumTable  AS INTEGER NO-UNDO.

   /* Commented by Mike: �� ��直� ��砩 㤠�塞 RELEASE bisquit._connect. */
   
   IF pString EQ "" THEN
     pString = '������ ������� ��㣮� ���짮��⥫�,~n���஡�� �����!'.
   
   /* Commented by KSV: �᫨ ���ଠ�� � ��ᨨ ����稢襩 ������, �� ��
   ** �� �������, � �饬 �� �⠭����� ��ࠧ��, �१ ⠡���� _lock.  */
   &IF DEFINED(ORACLE) &THEN
       /* �� ����砥� recid �ਪ������ ⠡����, � ��������� ᯥ� ⠡��� mutex
          ���४��㥬..   */
       FIND FIRST mutex WHERE 
          mutex.filename EQ iTableName AND  
          mutex.rec-id   EQ iRecId NO-LOCK NO-ERROR.
       IF AVAILABLE mutex THEN
          ASSIGN
             iRecId = RECID(mutex) 
             iTableName = "mutex"
          .
   &ENDIF
   
      IF NOT AVAILABLE xconnect THEN 
      DO:
        /* ������ _LOCK �� ����� �����ᮢ � ����� �⥪���� ��������, ���⮬� 
        ** ��᫥����⥫쭮 ��ॡ�ࠥ� �� ����� ���� �� ����⨬ �㦭��, ���� �� 
        ** ��ࢮ� ���⮩  */
        DEFINE VARIABLE vStart AS INTEGER     NO-UNDO.
        vStart = TIME.

        find first _file where _file._File-Name eq iTableName no-lock.
        vNumTable = _file._File-Number.
        
        FOR EACH xlock WHILE xLock._Lock-Table <> ?: 
           IF xlock._Lock-Table EQ vNumTable AND
              xlock._lock-recid EQ INT64(iRecId) 
           THEN 
              LEAVE.     
           /* �᫨ ��� ���᪠ ����஢�� �ॡ���� ����� 15 ᥪ㭤, �४�頥�
           ** �� ��ᯥ�ᯥ�⨢��� ����⨥ */
           IF TIME - vStart > 15 THEN LEAVE. 
        END. /* FOR EACH: */
        IF AVAILABLE xlock AND xlock._lock-recid = INT64(iRecId) THEN 
        DO:
           FIND FIRST xconnect WHERE 
              xconnect._connect-usr = xlock._lock-usr NO-LOCK NO-ERROR.
           IF AVAIL xconnect THEN 
              FIND FIRST xuser WHERE 
                 xuser._userid = CODEPAGE-CONVERT(xconnect._connect-name, DBCODEPAGE("bisquit"), SESSION:CPTERM) NO-LOCK NO-ERROR.
        END.
      END.

   
   /* � ��砥� �ࠪ�� �� �ᥣ�� ����� ���� ������஢��襣� �१ _lock */
   &IF DEFINED(ORACLE) &THEN
   DEFINE VARIABLE vConnectID AS INT64    NO-UNDO.
   IF NOT AVAILABLE xconnect THEN 
   DO:
      DEFINE VAR handle1 AS INTEGER.
      DEFINE VAR i AS INTEGER.
      DEFINE VARIABLE vLockingData AS CHARACTER   NO-UNDO.
      DEFINE VARIABLE vErrMsg AS CHARACTER   NO-UNDO.
      DEFINE VARIABLE vTableName AS CHARACTER.
      vTableName = CAPS(iTableName).
      vTableName = REPLACE(vTableName,"-","_").
      
      DEFINE VARIABLE vSqlCmd AS CHARACTER   NO-UNDO.
      vSqlCmd = 
        " select lo.process "+
        " from   v$locked_object lo, dba_objects o "+
        " where  o.object_id = lo.object_id                        "+
        "        and lo.xidusn != 0                                "+
        "        and o.owner = user                                "+
        "        and o.object_name = '" + (vTableName) + "'".
      
      RUN STORED-PROC send-sql-statement handle1 = PROC-HANDLE (vSqlCmd).
   
      FOR EACH proc-text-buffer WHERE PROC-HANDLE = handle1 :
      
           FIND FIRST xconnect WHERE xconnect._connect-Pid = int64(proc-text) NO-LOCK NO-ERROR.
           IF AVAIL xconnect THEN 
           DO:
              vNumUsers = vNumUsers + 1. 
              FIND FIRST xuser WHERE 
                 xuser._userid = CODEPAGE-CONVERT(xconnect._connect-name, DBCODEPAGE("bisquit"), SESSION:CPTERM) 
              NO-LOCK NO-ERROR.
              vUsers = vUsers +
                       " ���짮��⥫�: "   + STRING(xuser._User-name, "x(35)") +
                       " ���: " + STRING(xuser._userid, "x(15)") + "~n" +
                       "   ���ன�⢮: " + STRING(xconnect._connect-device,"x(35)") +
                       " PID: " + STRING(STRING(xconnect._connect-Pid),"x(15)") + "~n" +
                       "      ����䮭: " + STRING(getUserXattrValue(xuser._userid, "����䮭"),"x(25)") + "~n ".
                
           END.   
      END.   
      CLOSE STORED-PROC send-sql-statement WHERE PROC-HANDLE = handle1.
   END.
   &ENDIF
   
   /* Commented by KSV: ���ଠ�� � ��ᨨ � ���짮��⥫� �������, ������塞
   ** �� � ��ப� ᮮ�饭�� */
   IF AVAILABLE xconnect AND 
      AVAILABLE xuser AND   
      vNumUsers < 2
      THEN
   DO:                                           

      vUsers =    "     ���짮��⥫�: "   + STRING(xuser._User-name, "x(35)") +
               "~n              ���: " + STRING(xuser._userid, "x(35)") +
               "~n       ���ன�⢮: " + STRING(xconnect._connect-device,"x(35)") +
               "~n              PID: " + STRING(STRING(xconnect._connect-Pid),"x(35)") +
               "~n          ����䮭: " + STRING(getUserXattrValue(xuser._userid, "����䮭"),"x(35)").
          
   END.
      
   pString = pString + "~n~n" + vUsers.

   RETURN YES.
END FUNCTION.

/*��ଠ�஢���� ����� ���㬥�� �� �㦭��� ���-�� ᨬ����� */
FUNCTION FormatDocNum RETURN CHARACTER (INPUT iDocNum AS CHARACTER,
                                        INPUT iLength AS INT64):
   RETURN
   STRING(INT64(
      SUBSTRING(
                STRING(iDocNum),
                (IF (LENGTH(STRING(iDocNum)) - iLength) LE 0 
                   THEN 1 
                   ELSE LENGTH(STRING(iDocNum)) - (iLength - 1) 
                ),
                iLength
               )
   )).
END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     �����뢠�� ���祭�� ��ਡ�� RETURN-VALUE � ������ ��ப�
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE ResetReturnValue:
   RETURN .
END PROCEDURE.

/* �⮡ࠦ��� �������� �த�� � �ࠢ�� ���孥� 㣫� �࠭�. */
PROCEDURE RemHeaderMark:
   IF NOT AVAILABLE dept THEN 
      FIND FIRST dept WHERE NO-ERROR.
   PUT SCREEN COLOR BLACK/GRAY COL 77 ROW 2 dept.logo [2].
END.

/*�������� ��� 䨫���� �� ����७��� ����� ���*/
FUNCTION AddFilToAcct RETURNS CHARACTER (iAcct      AS CHARACTER,
                                         iFilial-Id AS CHARACTER):
   IF NOT GetDBMode()      OR
      INDEX(iAcct,"@") > 0 OR
      NOT {assigned iAcct} THEN RETURN iAcct.
   ASSIGN
      SUBSTRING(iAcct,26,1) = "@"
      ENTRY(2,iAcct,"@")    = iFilial-Id
   .  
   RETURN iAcct.
END FUNCTION.

/*���ࠥ� ��� 䨫���� �� ����७���� ����� ���*/
FUNCTION DelFilFromAcct RETURNS CHARACTER (iAcct AS CHARACTER):
   RETURN TRIM (ENTRY (1, iAcct, "@")).
END FUNCTION.

/* �࠭��ନ��� ����, �������� �㤠 ���䨪� 䨫����
** ��� ����� acct.acct, loan.cont-code
** �ᯮ������ ��� 䨫��஢ � ������� �㭪権. */
FUNCTION FmtMskAddSuffix RETURNS CHARACTER (
   iMask       AS CHARACTER,
   iAttrCode   AS CHARACTER
):
   DEF VAR vValSrc      AS CHAR   NO-UNDO. /* ��室��� ���祭�� ����. */
   DEF VAR vVarI        AS CHAR   NO-UNDO. /* I-� ����� ���祭��. */
   DEF VAR vValRes      AS CHAR   NO-UNDO. /* ����४�஢����� ���祭��. */
   DEF VAR vCnt         AS INT64    NO-UNDO. /* ���稪. */
   DEF VAR vFormat      AS INT64    NO-UNDO. /* ��ਭ� ����. */
   DEF VAR vDelta       AS INT64    NO-UNDO. /* ���-�� �஡���� �� ࠧ����⥫�. */
   DEF VAR vLen         AS INT64    NO-UNDO. /*����� ��ப�*/
   DEF VAR vAddEndStar  AS LOG    NO-UNDO. /*vAddEndStar - 㪠�뢠�� �� ����室������ ���������� "*"
                                           ** � ����� ��᪨ ��� ���ਡ�� cont-code. */
   IF NOT shMode
      THEN RETURN iMask.
   vValSrc = iMask.
   
   CASE iAttrCode:
   WHEN  "cont-code" THEN
   DO:
      /*mitr: ��� ����� ������� �।�⮢ �⤥��� �ࠢ���.
      �᫨ ��᫥���� ᨬ��� � ��᪥ ���� ������窠 "*", � ������塞 � ����� 
      ��������.
      
      ������� cont-code ᫥����� :
      1) ����� �墠�뢠�饣� �������
      2) @
      3) ����� 䨫����
      
         �������⥫쭮 ��� �࠭襩 ������塞 
      4) �஡��
      5) ����� �祭��
      
      �ਬ��: �᫨ �� ���砥� ��ப� ⨯� 222333222*, � 
      ��� ����室��� ������ ⠪�� ���� 222333222*@002*
      
      */
      vValRes = "".
      
      IF vValSrc EQ "*" THEN
         /*�᫨ ����� ������� �� 㪠���, � �� ���� ��������� ��� 䨫����.*/                  
         vValRes = vValSrc.
      ELSE
      DO vCnt = 1 TO NUM-ENTRIES (vValSrc):
         vVarI    =  ENTRY (vCnt, vValSrc).
      
         vLen = LENGTH(vVarI).
         IF vLen > 0 THEN
            vAddEndStar = (SUBSTR(vVarI, vLen, 1) EQ "*").
   
         /*�᫨ ��᫥��� ᨬ��� � ��᪥ = "*", � ��᫥ ����� 䨫���� ⠪��
         ������塞 "*"*/
         IF INDEX(vVarI,"@") EQ 0  
         THEN
            vVarI = addFilToLoan(vVarI, shFilial) + IF vAddEndStar THEN "*" ELSE "".
         {additem.i vValRes vVarI}
      END.
   END.
   OTHERWISE
   DO vCnt = 1 TO NUM-ENTRIES (vValSrc):
      ASSIGN
         vVarI    =  ENTRY (vCnt, vValSrc)
         vFormat  =  25 + IF INDEX (vVarI, "!") EQ 0 THEN 0 ELSE 1
         vDelta   =  5
      .
      IF       INDEX (vVarI, "@")   EQ 0
         AND   vVarI                NE "*"
      THEN DO:
         vVarI =  IF INDEX (vVarI, "*")   EQ 0
                     THEN  (vVarI + FILL (" ", vFormat - LENGTH (vVarI)) + "@" + shFilial)
                     ELSE  IF SUBSTR (vVarI, LENGTH (vVarI)) EQ "*"
                        THEN  (vVarI /* +                                  "@" + shFilial*/)
                        ELSE  (vVarI + FILL (" ", vDelta) +                "@" + shFilial).
      END.
      {additem.i vValRes vVarI}
   END.
   END CASE.

   IF vValRes NE ""
      THEN RETURN vValRes.
      ELSE RETURN "".
END FUNCTION.

/*----------------------------------------------------------------------------*/
FUNCTION GetBankINN RETURN CHAR (INPUT iBankCodeType  AS CHAR,
                                 INPUT iBankCode      AS CHAR):

   DEF BUFFER banks        FOR banks.      
   DEF BUFFER banks-code   FOR banks-code. 

   DEFINE VARIABLE vBank-id AS INT64     NO-UNDO.
   DEFINE VARIABLE vBegDate AS DATE        NO-UNDO.
   DEFINE VARIABLE vEnDate  AS DATE        NO-UNDO.
   DEFINE VARIABLE vInn     AS CHARACTER   NO-UNDO.

   IF iBankCodeType EQ "bank-id" THEN   
      vBank-id = INT64 (iBankCode).
   ELSE
   DO:
      RUN GetBank IN h_base (BUFFER banks,
                             BUFFER banks-code,
                             INPUT  iBankCode,
                             INPUT  iBankCodeType,
                             INPUT  NO).
      IF AVAIL banks THEN
         vBank-id = banks.bank-id.
   END.

   ASSIGN 
      vBegDate = ?
      vEnDate  = ?
   .
   
   {getcustident.i
      &BegDate  = vBegDate
      &EndDate  = vEnDate
      &CustCat  = '�'  
      &CustId   = vBank-id
      &CustType = '���'
      &RetValue = vInn
   }

   RETURN vInn.

END FUNCTION.

/* ����砥� ���祭� ⥬�ࠫ��� ��. */
PROCEDURE SetXattrTmp.
   DEF INPUT PARAM TABLE FOR ttXattrTemp.
   RETURN.
END PROCEDURE.

PROCEDURE DestroyInterface.
   {intrface.del}          /* ���㧪� �����㬥����. */ 
   RETURN.
END PROCEDURE.

FUNCTION GetFmtQty RETURNS CHARACTER (INPUT iObject      AS CHARACTER,
                                      INPUT iAcctCat     AS CHARACTER,
                                      INPUT iNumChar     AS INT64,
                                      INPUT iDefAccuracy AS INT64):

   DEFINE VARIABLE mSett   AS CHARACTER   NO-UNDO. /* ���祭�� ����஥筮�� ��ࠬ��� �����_�����/�����_��� */
   DEFINE VARIABLE mLngBs  AS INT64     NO-UNDO. /* ����� �᭮����� */
   DEFINE VARIABLE mLngFr  AS INT64     NO-UNDO. /* ����� �஡��� ��� */
   DEFINE VARIABLE mResult AS CHARACTER   NO-UNDO.

   IF iAcctCat EQ "bal-acct" THEN
      mSett = FGetSetting("�����_�����", "", "").
   ELSE IF iAcctCat EQ "acct" THEN
      mSett = FGetSetting("�����_���", "", "").

   mLngFr = IF {assigned mSett} THEN INT64(mSett)
                                ELSE iDefAccuracy.
   mLngBs = iNumChar - mLngFr - 3.

   mResult = "-" + FILL(">", mLngBs) + "9." + FILL("9", mLngFr).

   RETURN mResult.

END FUNCTION.

/* �������� ᥬ���, �����뢠�騩 ������ �� ᫥���騩 ��㧥� ����뢠���� 
** �� GO, �� 㬮�砭�� NO */
DEFINE VARIABLE mCloseOnGo AS LOGICAL NO-UNDO.
/* ��� ��楤���, ��ࢮ� ������襩 mCloseOnGo � ���祭�� YES */
DEFINE VARIABLE mCogProcHandle AS HANDLE NO-UNDO.
/* �����䨪��� ��楤���, ��ࢮ� ������襩 mCloseOnGo � ���祭�� YES */
DEFINE VARIABLE mCogProcID     AS INT64 NO-UNDO.

/*------------------------------------------------------------------------------
  Purpose:     �஢���� ���� �� ��� ������� � ���.����஫�� �� ���祭��
               UNIQUE-ID.
  Parameters:  iObjectHandle - ���
               iObjectID     - ���祭�� UNIQUE-ID, �᫨ �� ������, � ࠡ�⠥�
                               ��� ����� VALID-HANDLE
  Notes:       ���祭�� ����� ��२ᯮ������� 横���᪨, ���⮬� 
               VALID-HANDLE ����� ������ TRUE, ��� ��ꥪ�, �� ����� �� 
               ��뫠��� ����砫쭮, 㦥 �� �������, � ���祭�� ��� 
               ���� �뫮 ��᢮��� ������ ��ꥪ��
------------------------------------------------------------------------------*/
FUNCTION ValidObjectHandle RETURNS LOGICAL ( iObjectHandle AS HANDLE,
                                             iObjectID     AS INT64 ):
   IF VALID-HANDLE( iObjectHandle ) <> YES THEN RETURN NO.
   /* �᫨ iObjectID �� �����, � ��������� ���� �㤥� �����筮 */
   IF iObjectID = ? THEN RETURN YES.
   
   /* �᫨ iObjectID 㪠��� � ᮢ������, � ��� ������� */
   IF CAN-QUERY( iObjectHandle, "UNIQUE-ID" ) AND 
      iObjectHandle:UNIQUE-ID = iObjectID THEN RETURN YES.
   
   /* �� ��� ��⠫��� �����, �� �� ������� */   
   RETURN NO.                                                 
END FUNCTION.

/*------------------------------------------------------------------------------
  Purpose:     �����頥� ���祭�� ᥬ��� CloseOnGo
  Parameters:  oCloseOnGo - ���祭�� ᥬ���
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE GetCloseOnGoSemaphore:
   DEFINE OUTPUT PARAMETER oCloseOnGo     AS LOGICAL NO-UNDO.
   
   /* �᫨ ��楤��, ��� ����砫쭮 ���������, 㦥 ���㦥��, ���祭��
   ** ���뢠���� � NO */
   IF NOT ValidObjectHandle( mCogProcHandle, mCogProcID ) THEN 
      mCloseOnGo = NO.
   
   oCloseOnGo = mCloseOnGo.   
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose:     ��⠭�������� ���祭�� ᥬ��� CloseOnGo
  Parameters:  iCallerHandle - ��� ��楤���, �믮����騩 ���������
               iCloseOnGo    - ����� ���祭�� ᥬ���
  Notes:       
------------------------------------------------------------------------------*/
PROCEDURE SetCloseOnGoSemaphore:
   DEFINE INPUT  PARAMETER iCallerHandle AS HANDLE NO-UNDO.
   DEFINE INPUT  PARAMETER iCloseOnGo    AS LOGICAL NO-UNDO.
   
   /* ���������� ��� ��楤���, �믮����襩 ��������� ᥬ��� � ���祭�� ��
   ** 㬮�砭��  */
   IF iCloseOnGo AND NOT mCloseOnGo AND 
      NOT ValidObjectHandle( mCogProcHandle, mCogProcID ) THEN
   DO:
      ASSIGN 
         mCogProcHandle = iCallerHandle
         mCogProcID     = iCallerHandle:UNIQUE-ID.            
   END.   
   
   mCloseOnGo = iCloseOnGo.
END PROCEDURE.

/*----------------------------------------------------------------------------*/
/* ��।������ ���祭�� ४����� ��ꥪ� �� ������� ������ �६��� ��       */
/* ��ୠ�� ���������.                                                         */
/* ��ࠬ����:                                                                 */
/*   iHandle   - 㪠��⥫� �� ���� ��ꥪ�                                   */
/*   iAttrName - ������������ �᭮����� ��� ���७���� ४����� ��ꥪ�,   */
/*               ���祭�� ���ண� �ॡ���� ��।�����.                      */
/*   iDate     - ���, �� ������ �ॡ���� ��।����� ���祭�� ४�����.    */
/*   iTime     - �६� ��� ���� iDate, �� ���஥ �ॡ���� ��।�����        */
/*               ���祭�� ४�����. ����뢠���� � ᥪ㭤��, ��襤�� �      */
/*               ��砫� ��⮪, ᮮ⢥������� ��� iDate. ����।��񭭮�     */
/*               ���祭�� ���ਭ������� ��� 0.                               */
/*   oResult   - �����頥�� १����, �८�ࠧ������ � ��ப����� ⨯�.   */
/* ��⠭�������� ERROR-STATUS:ERROR = YES � ᫥����� �����:                */
/*   - � iHandle ��।�� ���⮩ 㪠��⥫�;                                    */
/*   - 㪠����� ������ �६��� ��� �� ����㯨�;                              */
/*   - ��ꥪ� �� ����⢮��� � 㪠����� ������ �६���.                      */
/*----------------------------------------------------------------------------*/
PROCEDURE GetAttrValueOnDate.
    DEFINE INPUT  PARAMETER iObject   AS HANDLE    NO-UNDO.
    DEFINE INPUT  PARAMETER iAttrName AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER iDate     AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER iTime     AS INT64     NO-UNDO.
    DEFINE OUTPUT PARAMETER oResult   AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(iObject) THEN DO:
        RUN GetAttrValueOnDateEx(iObject:TABLE,
                                 Surrogate(iObject),
                                 iAttrName,
                                 iDate,
                                 iTime,
                                 OUTPUT oResult)
        NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
            RETURN.
    END.
    RETURN ERROR.
END PROCEDURE.

/*----------------------------------------------------------------------------*/
/* ����ୠ⨢�� ��ਠ�� �맮�� GetAttrValueOnDate. ��ꥪ� ��।����� ��     */
/* � ���� 㪠��⥫� �� ����, � � ���� ���� �� ����� ⠡���� � ���ண��      */
/*----------------------------------------------------------------------------*/
PROCEDURE GetAttrValueOnDateEx.
    DEFINE INPUT  PARAMETER iTable     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER iSurrogate AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER iAttrName  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER iDate      AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER iTime      AS INT64     NO-UNDO.
    DEFINE OUTPUT PARAMETER oResult    AS CHARACTER NO-UNDO.

    DEFINE BUFFER history FOR history.

    DEFINE VARIABLE vModStr LIKE history.field-value            NO-UNDO.
    DEFINE VARIABLE vI      AS   INT64                          NO-UNDO.
    DEFINE VARIABLE vS      AS   CHARACTER                      NO-UNDO.
    DEFINE VARIABLE vFound  AS   LOGICAL             INITIAL NO NO-UNDO.

    IF iTime = ? THEN
        iTime = 0.
    IF iDate > TODAY OR (iDate = TODAY AND iTime > TIME) THEN
        RETURN ERROR.
    FOR EACH history WHERE
        history.file-name = iTable     AND
        history.field-ref = iSurrogate AND
        (history.modif-date < iDate OR
         history.modif-date = iDate AND
         history.modif-time < iTime)
    NO-LOCK
    BY history.history-id DESCENDING:
        LEAVE.
    END.
    IF AVAILABLE history AND history.modify = {&HIST_DELETE} THEN
        RETURN ERROR.
    FOR EACH history WHERE
        history.file-name   = iTable     AND
        history.field-ref   = iSurrogate AND
        history.field-name  =  ""        AND
        &IF DEFINED(ORACLE) = 0 &THEN
        history.field-value <> ""        AND
        &ENDIF
        (history.modif-date > iDate OR
         history.modif-date = iDate AND
         history.modif-time > iTime)
    NO-LOCK
    BY history.history-id:
        vModStr = history.field-value.
        DO vI = 1 TO NUM-ENTRIES(vModStr) BY 2:
            vS = ENTRY(vI, vModStr).
            IF vS = "" THEN
                LEAVE.
            IF vS = iAttrName OR vS = "*" + iAttrName THEN
                ASSIGN
                    oResult = ENTRY(vI + 1, vModStr)
                    vFound  = YES
                .
        END.
        IF vFound THEN DO:
            IF oResult = "{&UNKVAL}" THEN
                oResult = ?.
            RETURN.
        END.
    END.
    oResult = DYNAMIC-FUNCTION(IF IsValidField(iTable, iAttrName) THEN
                                   "GetValueAttr"
                               ELSE
                                   "GetXAttrValue",
                               iTable,
                               iSurrogate,
                               iAttrName).
END PROCEDURE.

/*------------------------------------------------------------------------------
  Purpose:     �����頥� ᯨ᮪ ���稭����� ���짮��⥫�, �� ��ꥪ�� ������
               ���짮��⥫� ����� �ࠢ� ����㯠 �� �⥭��.
  Parameters:  iUserId - ��� ���짮��⥫�, ᯨ᮪ ���稭����� ���ண� ����室��
  Notes:
------------------------------------------------------------------------------*/
FUNCTION getUserSlaves RETURNS CHAR
          (INPUT iUserId AS CHAR): /* ��� ���짮��⥫� */

  RETURN GetSlavesListMethod (iUserId, "r").
END FUNCTION. /* getUserSlaves */

/*------------------------------------------------------------------------------
  Purpose:     �����頥� ᯨ᮪ ���稭����� ⥪�饣� ���짮��⥫�, �� ��ꥪ��
               ������ ���짮��⥫� ����� �ࠢ� ����㯠 �� �⥭��.
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
FUNCTION getSlaves RETURNS CHAR:
  RETURN getUserSlaves (USERID("bisquit")).
END FUNCTION. /* getSlaves */

