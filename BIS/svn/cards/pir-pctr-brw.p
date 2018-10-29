/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2006 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: PCTR-BRW.P
      Comment: �࠭���樨 �� ���⠬
   Parameters:
         Uses:
      Used by:
      Created: ???
     Modified: 02.04.2007 laav 0072016 �뭥ᥭ� � ������� ��।������ ����� � ����ᮢ,
                               ������ ��ࠡ�⠭� ��� ࠡ��� � ���묨 ���������� 䨫���: 
                               ����饭��, ������, ��뫪�      
     Modified: 17.01.2008 jadv 80844                               
     Modified: 11.05.2010 Buryagin Pir   ������� ���祭�� ����� &delete.
*/

{globals.i}
{flt-file.i}
{intrface.get rights}
{card_mfr.i}

{navigate.def}          /* ��६���� ��� navigate.cqr. */

DEFINE VAR vClassAvailChar AS CHAR NO-UNDO. /* ���᮪ ����㯭�� ����ᮢ ��� �⥭�� */

/* ��६���� �� */
DEFINE VAR vPctrCode AS CHAR    NO-UNDO.
DEFINE VAR vContTime AS CHAR    NO-UNDO.
DEFINE VAR vSumm     AS DECIMAL NO-UNDO.
DEFINE VAR vCurr     AS CHAR    NO-UNDO.
DEFINE VAR vFIO      AS CHAR    NO-UNDO.
DEFINE VAR vFirm     AS CHAR    NO-UNDO.
DEFINE VAR vCardLoan AS CHAR    NO-UNDO.
DEFINE VAR vEqLoan   AS CHAR    NO-UNDO.
DEFINE VAR vClName   AS CHAR    NO-UNDO EXTENT 3.
/* ��� nav-䠩�� */
DEFINE VAR vSurr     AS CHAR    NO-UNDO.
DEFINE VAR vCh       AS CHAR    NO-UNDO.
DEFINE VAR mFlag     AS LOG     NO-UNDO.
DEFINE VAR mAlert    AS LOG     NO-UNDO.
DEFINE VAR mComment  AS CHAR    NO-UNDO.
DEFINE VAR mResp     AS CHAR    NO-UNDO.
DEFINE VAR vMFRType  AS CHAR    NO-UNDO.

DEF VAR mCardNumber      AS CHARACTER NO-UNDO.
DEF VAR mCardNumberMask  AS CHARACTER NO-UNDO.
DEF VAR mi               AS INTEGER   NO-UNDO.

DEF VAR shModeMultyWas LIKE shModeMulty NO-UNDO.

DEFINE BUFFER loan-card FOR loan. /* ���� ��� ������� ������஢ */
DEFINE BUFFER loan-acq  FOR loan. /* ���� ��� ������஢ ���ਭ�� */
DEFINE BUFFER bop       FOR op.
DEFINE BUFFER bsigns    FOR signs.
DEFINE BUFFER signs1    FOR signs.
DEFINE BUFFER signs2    FOR signs.
DEFINE BUFFER signs3    FOR signs.
DEFINE BUFFER signs4    FOR signs.
DEFINE BUFFER bop-int   FOR op-int.

FIND FIRST _user WHERE _user._userid = USERID("bisquit") NO-ERROR.
mCardNumberMask = GetXattrValue("_user",_user._Userid,"��᪠���⍮�").
IF work-module = "card" THEN mCardNumberMask = "*".

ASSIGN
   /* ����祭�� ᯨ᪠ ����㯭�� ����ᮢ */
   vClassAvailChar   = GetRightClasses ("pc-trans", "R")
.
{pctr-brw.frm}
{pctr-brw.qry}
ASSIGN
   shModeMultyWas = shModeMulty
.
MAIN:
DO ON ERROR  UNDO, LEAVE
   ON ENDKEY UNDO, LEAVE:

   ASSIGN
      shModeMulty = TRUE
   .
{navigate.cqr
  &file             = "pc-trans"
  &avfile           = "pc-trans" 
  &files            = "pc-trans" 
  
  &filt             = "YES"
  &tmprecid         = "YES"
  &need-tmprecid    = "YES"
  &local-rest       = "YES"
  &local-keep       = "YES"
  
  &oh3              = "�F3 �ଠ "
  &oth3             = "frames.cqr "
  &maxfrm           = 3
  &bf1              = "str-recid pc-trans.pctr-status pc-trans.cont-date vContTime vPctrCode mCardNumber pc-trans.num-equip pc-trans.inpc-result vCurr vSumm"
  &bf2              = "str-recid pc-trans.inpc-stan vCardLoan vFIO vEqLoan vFirm"
  &bf3              = "str-recid pc-trans.processing pc-trans.inpc-rrn pc-trans.eq-location pc-trans.card-country pc-trans.eq-country"
  &postfind         = "pctr-brw.fnd "

  &edit             = "bis-tty.ef "
  &look             = "bis-tty.nav "
  &altlook          = "pctr-brw.nav "
  &class_avail      = "vClassAvailChar"
  &class_upper      = "'pc-trans'"

   &CalcFld          = "vMFRType"
   &CalcVar          = "pctr-brw.cv "

  &oh6              = "�F6 䨫���"
  &oth6             = "flt-file.f6 "
  
  &print            = "pctr-brw.prt "
  &return           = "return.cqr "
    &rfld           = "pctr-id"
  &delete           = "pir-pctr-brw.del "
}    
END.
ASSIGN
   shModeMulty = shModeMultyWas
.

/*PROCEDURE PostOpenQuery:*/
/*   DEFINE INPUT PARAMETER iHdl AS HANDLE NO-UNDO.*/
/*   ASSIGN*/
/*      shModeMulty = shModeMultyWas*/
/*   .*/
/*END PROCEDURE.*/

/*PROCEDURE PostSelectQuery:*/
/*   ASSIGN*/
/*      shModeMulty = TRUE*/
/*   .*/
/*END PROCEDURE.*/

{intrface.del}
