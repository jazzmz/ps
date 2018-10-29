/*
               ������᪠� ��⥣�஢����� ��⥬� �������
    Copyright: (C) 1992-2006 ��� "������᪨� ���ଠ樮��� ��⥬�"
     Filename: pctra-brw.p
      Comment: �㬬� �࠭���権
   Parameters:
         Uses:
      Used by:
      Created: 06.10.2006 18:49 MIOA     (0068298)
     Modified: 18.11.2006 18:43 OZMI     (0068806)
     Modified: 10.09.2007 18:43 JADV     (0080885)
     Modified by PIR: 11.05.2010 17:16 Buryagin
                      �������� ����� &delete � ��।������ �����.
*/

{globals.i}
{flt-file.i}
{intrface.get rights}

&GLOBAL-DEFINE BIS-TTY-EF YES

/* ��६���� �� */
DEFINE VAR vContTime AS CHAR NO-UNDO.
DEFINE VAR vFIO      AS CHAR NO-UNDO.
DEFINE VAR vFirm     AS CHAR NO-UNDO.
DEFINE VAR vCardLoan AS CHAR NO-UNDO.
DEFINE VAR vEqLoan   AS CHAR NO-UNDO.
DEFINE VAR vClName   AS CHAR NO-UNDO EXTENT 3.
DEFINE VAR mBTESurr  AS CHAR NO-UNDO.
DEFINE VAR mParamLst AS CHAR NO-UNDO.
DEFINE VAR mHField   AS HANDLE NO-UNDO.
/* ��� nav-䠩�� */
DEFINE VAR vSurr     AS CHAR NO-UNDO.
DEFINE VAR vCh       AS CHAR NO-UNDO.

/* ��ଠ 1 */
FORM
   pc-trans-amt.amt-code  FORMAT "x(12)"               COLUMN-LABEL "����"        HELP "���� �㬬� � �࠭���樨"
   pc-trans-amt.currency  FORMAT "x(3)"                COLUMN-LABEL "���"         HELP "����� �࠭���樨"
   pc-trans-amt.amt-cur   FORMAT "->>>,>>>,>>>,>>9.99" COLUMN-LABEL "�����"       HELP "�㬬�"
   pc-trans-amt.cont-date FORMAT "99/99/9999"          COLUMN-LABEL "�������"     HELP "��� �믮������ �࠭���樨"
   pc-trans-amt.proc-date FORMAT "99/99/9999"          COLUMN-LABEL "����������"  HELP "��� ��ࠡ�⪨ �࠭���樨"
   WITH FRAME browse1 TITLE COLOR bright-white "[ ����� ���������� ]". 

mParamLst = GetFltVal("pctr-id").

{qrdef.i
  &buff-list        = "pc-trans-amt"
  &need-buff-list   = "pc-trans-amt" 
  &Join-list        = "EACH"
  &SortBy           = "'BY pc-trans-amt.amt-code '"
}
    
{navigate.cqr
  &file             = "pc-trans-amt"
  &avfile           = "pc-trans-amt" 
  &files            = "pc-trans-amt" 
  
  &filt             = "YES"
  &tmprecid         = "YES"
  
  &maxfrm           = 1
  &bf1              = "pc-trans-amt.amt-code pc-trans-amt.currency pc-trans-amt.amt-cur pc-trans-amt.cont-date pc-trans-amt.proc-date"  
  
  &oh2              = "�F2 ����樨"
  &oth2             = "pctra.mnu "

  &oh6              = "�F6 䨫���"
  &oth6             = "flt-file.f6 "

  &altlook          = "pctra-brw.nav "
  &look             = "bis-tty.nav "
  &edit             = "bis-tty.ef "
  &delete           = "pir-pctra-brw.del "
}    

{intrface.del}
